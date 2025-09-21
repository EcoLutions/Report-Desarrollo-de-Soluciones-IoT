-- ========================================
-- Route Planning BC Database Schema
-- PostgreSQL Database Script
-- ========================================

-- Create schema for Route Planning BC
CREATE SCHEMA IF NOT EXISTS route_planning;

-- ========================================
-- MAIN TABLES
-- ========================================

-- Routes table (Aggregate Root)
CREATE TABLE route_planning.routes (
    id BIGSERIAL PRIMARY KEY,
    route_id VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(200) NOT NULL,
    municipality_id BIGINT NOT NULL,
    driver_id BIGINT,
    vehicle_id BIGINT,
    route_type VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'DRAFT',
    status_last_change TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    scheduled_date TIMESTAMP WITH TIME ZONE NOT NULL,
    start_time TIMESTAMP WITH TIME ZONE,
    end_time TIMESTAMP WITH TIME ZONE,
    estimated_duration_minutes INTEGER,
    actual_duration_minutes INTEGER,
    total_distance_km DECIMAL(10, 3),
    estimated_fuel_cost DECIMAL(10, 2),
    co2_emissions_kg DECIMAL(10, 3),
    optimization_score DECIMAL(5, 2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version BIGINT DEFAULT 0,

    -- Constraints
    CONSTRAINT chk_route_status CHECK (status IN (
        'DRAFT', 'OPTIMIZED', 'ASSIGNED', 'EXECUTING', 'COMPLETED', 'CANCELLED'
    )),
    CONSTRAINT chk_route_type CHECK (route_type IN (
        'REGULAR_COLLECTION', 'EMERGENCY_COLLECTION', 'SPECIAL_WASTE', 'MAINTENANCE'
    )),
    CONSTRAINT chk_optimization_score CHECK (optimization_score >= 0 AND optimization_score <= 100),
    CONSTRAINT chk_distance_positive CHECK (total_distance_km >= 0),
    CONSTRAINT chk_duration_positive CHECK (
        estimated_duration_minutes >= 0 AND
        (actual_duration_minutes IS NULL OR actual_duration_minutes >= 0)
    ),
    CONSTRAINT chk_execution_times CHECK (
        (start_time IS NULL AND end_time IS NULL) OR
        (start_time IS NOT NULL AND end_time IS NULL) OR
        (start_time IS NOT NULL AND end_time IS NOT NULL AND end_time >= start_time)
    )
);

-- Waypoints table (Entity)
CREATE TABLE route_planning.waypoints (
    id BIGSERIAL PRIMARY KEY,
    waypoint_id VARCHAR(50) UNIQUE NOT NULL,
    route_id BIGINT NOT NULL,
    container_id BIGINT NOT NULL,
    location_latitude DECIMAL(10, 8) NOT NULL,
    location_longitude DECIMAL(11, 8) NOT NULL,
    location_address VARCHAR(500),
    priority_level INTEGER NOT NULL DEFAULT 1,
    priority_description VARCHAR(200),
    estimated_arrival_time TIMESTAMP WITH TIME ZONE,
    actual_arrival_time TIMESTAMP WITH TIME ZONE,
    estimated_service_minutes INTEGER DEFAULT 5,
    actual_service_minutes INTEGER,
    sequence_order INTEGER NOT NULL,
    waypoint_status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    collection_instructions TEXT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_waypoints_route FOREIGN KEY (route_id)
        REFERENCES route_planning.routes(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_coordinates CHECK (
        location_latitude BETWEEN -90 AND 90 AND
        location_longitude BETWEEN -180 AND 180
    ),
    CONSTRAINT chk_priority_level CHECK (priority_level BETWEEN 1 AND 10),
    CONSTRAINT chk_sequence_order CHECK (sequence_order > 0),
    CONSTRAINT chk_waypoint_status CHECK (waypoint_status IN (
        'PENDING', 'IN_PROGRESS', 'COMPLETED', 'SKIPPED', 'FAILED'
    )),
    CONSTRAINT chk_service_times CHECK (
        estimated_service_minutes > 0 AND
        (actual_service_minutes IS NULL OR actual_service_minutes >= 0)
    ),
    CONSTRAINT chk_arrival_times CHECK (
        (actual_arrival_time IS NULL) OR
        (estimated_arrival_time IS NULL) OR
        (actual_arrival_time >= estimated_arrival_time - INTERVAL '2 hours')
    )
);

-- Optimization Results table (Entity)
CREATE TABLE route_planning.optimization_results (
    id BIGSERIAL PRIMARY KEY,
    result_id VARCHAR(50) UNIQUE NOT NULL,
    route_id BIGINT NOT NULL,
    algorithm_used VARCHAR(100) NOT NULL,
    execution_time_ms BIGINT NOT NULL,
    total_distance_km DECIMAL(10, 3) NOT NULL,
    estimated_fuel_consumption_liters DECIMAL(8, 2),
    co2_emissions_kg DECIMAL(10, 3),
    cost_estimate DECIMAL(10, 2),
    optimization_score DECIMAL(5, 2) NOT NULL,
    improvement_percentage DECIMAL(5, 2),
    waypoints_count INTEGER NOT NULL,
    optimization_parameters JSONB,
    performance_metrics JSONB,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_optimization_route FOREIGN KEY (route_id)
        REFERENCES route_planning.routes(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_algorithm CHECK (algorithm_used IN (
        'TRAVELING_SALESMAN', 'NEAREST_NEIGHBOR', 'GENETIC_ALGORITHM',
        'HYBRID_OPTIMIZATION', 'GREEDY_INSERTION', 'SIMULATED_ANNEALING'
    )),
    CONSTRAINT chk_execution_time CHECK (execution_time_ms >= 0),
    CONSTRAINT chk_optimization_score_range CHECK (optimization_score >= 0 AND optimization_score <= 100),
    CONSTRAINT chk_waypoints_count CHECK (waypoints_count > 0),
    CONSTRAINT chk_distance_positive_opt CHECK (total_distance_km >= 0)
);

-- Route Progress Tracking table
CREATE TABLE route_planning.route_progress (
    id BIGSERIAL PRIMARY KEY,
    route_id BIGINT NOT NULL,
    current_latitude DECIMAL(10, 8),
    current_longitude DECIMAL(11, 8),
    current_waypoint_id BIGINT,
    progress_percentage DECIMAL(5, 2) DEFAULT 0.0,
    estimated_completion_time TIMESTAMP WITH TIME ZONE,
    distance_completed_km DECIMAL(10, 3) DEFAULT 0.0,
    distance_remaining_km DECIMAL(10, 3),
    deviation_distance_km DECIMAL(8, 3) DEFAULT 0.0,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_progress_route FOREIGN KEY (route_id)
        REFERENCES route_planning.routes(id) ON DELETE CASCADE,
    CONSTRAINT fk_progress_waypoint FOREIGN KEY (current_waypoint_id)
        REFERENCES route_planning.waypoints(id) ON DELETE SET NULL,

    -- Constraints
    CONSTRAINT chk_progress_percentage CHECK (progress_percentage >= 0 AND progress_percentage <= 100),
    CONSTRAINT chk_coordinates_progress CHECK (
        (current_latitude IS NULL AND current_longitude IS NULL) OR
        (current_latitude BETWEEN -90 AND 90 AND current_longitude BETWEEN -180 AND 180)
    ),
    CONSTRAINT chk_distances_progress CHECK (
        distance_completed_km >= 0 AND
        (distance_remaining_km IS NULL OR distance_remaining_km >= 0) AND
        deviation_distance_km >= 0
    )
);

-- ========================================
-- AUDIT AND EVENTS TABLES
-- ========================================

-- Route Events table (Domain Events)
CREATE TABLE route_planning.route_events (
    id BIGSERIAL PRIMARY KEY,
    event_type VARCHAR(100) NOT NULL,
    route_id BIGINT NOT NULL,
    waypoint_id BIGINT,
    event_data JSONB NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    processed BOOLEAN DEFAULT FALSE,
    processing_attempts INTEGER DEFAULT 0,

    -- Foreign Keys
    CONSTRAINT fk_events_route FOREIGN KEY (route_id)
        REFERENCES route_planning.routes(id) ON DELETE CASCADE,
    CONSTRAINT fk_events_waypoint FOREIGN KEY (waypoint_id)
        REFERENCES route_planning.waypoints(id) ON DELETE SET NULL,

    -- Constraints
    CONSTRAINT chk_event_type_route CHECK (event_type IN (
        'ROUTE_CREATED',
        'ROUTE_OPTIMIZED',
        'ROUTE_OPTIMIZATION_COMPLETED',
        'ROUTE_EXECUTION_STARTED',
        'WAYPOINT_COMPLETED',
        'ROUTE_DEVIATION_DETECTED',
        'ROUTE_COMPLETED',
        'ROUTE_CANCELLED',
        'OPTIMIZATION_FAILED'
    ))
);

-- Algorithm Performance Cache table
CREATE TABLE route_planning.algorithm_performance_cache (
    id BIGSERIAL PRIMARY KEY,
    algorithm_name VARCHAR(100) NOT NULL,
    waypoints_count_range VARCHAR(20) NOT NULL,
    avg_execution_time_ms BIGINT NOT NULL,
    avg_optimization_score DECIMAL(5, 2) NOT NULL,
    success_rate DECIMAL(5, 2) NOT NULL,
    sample_size INTEGER NOT NULL,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Unique constraint
    CONSTRAINT uk_algorithm_performance UNIQUE (algorithm_name, waypoints_count_range),

    -- Constraints
    CONSTRAINT chk_success_rate CHECK (success_rate >= 0 AND success_rate <= 100),
    CONSTRAINT chk_sample_size CHECK (sample_size > 0)
);

-- ========================================
-- INDEXES FOR PERFORMANCE
-- ========================================

-- Routes indexes
CREATE INDEX idx_routes_municipality ON route_planning.routes (municipality_id);
CREATE INDEX idx_routes_driver ON route_planning.routes (driver_id);
CREATE INDEX idx_routes_vehicle ON route_planning.routes (vehicle_id);
CREATE INDEX idx_routes_status ON route_planning.routes (status);
CREATE INDEX idx_routes_type ON route_planning.routes (route_type);
CREATE INDEX idx_routes_scheduled_date ON route_planning.routes (scheduled_date);
CREATE INDEX idx_routes_execution_times ON route_planning.routes (start_time, end_time);

-- Waypoints indexes
CREATE INDEX idx_waypoints_route ON route_planning.waypoints (route_id);
CREATE INDEX idx_waypoints_container ON route_planning.waypoints (container_id);
CREATE INDEX idx_waypoints_sequence ON route_planning.waypoints (route_id, sequence_order);
CREATE INDEX idx_waypoints_status ON route_planning.waypoints (waypoint_status);
CREATE INDEX idx_waypoints_priority ON route_planning.waypoints (priority_level DESC);
CREATE INDEX idx_waypoints_location ON route_planning.waypoints USING GIST (
    ll_to_earth(location_latitude, location_longitude)
);

-- Optimization results indexes
CREATE INDEX idx_optimization_route ON route_planning.optimization_results (route_id);
CREATE INDEX idx_optimization_algorithm ON route_planning.optimization_results (algorithm_used);
CREATE INDEX idx_optimization_score ON route_planning.optimization_results (optimization_score DESC);
CREATE INDEX idx_optimization_timestamp ON route_planning.optimization_results (timestamp DESC);

-- Route progress indexes
CREATE INDEX idx_progress_route ON route_planning.route_progress (route_id);
CREATE INDEX idx_progress_update ON route_planning.route_progress (last_update DESC);

-- Route events indexes
CREATE INDEX idx_events_route_planning ON route_planning.route_events (route_id);
CREATE INDEX idx_events_type_planning ON route_planning.route_events (event_type);
CREATE INDEX idx_events_timestamp_planning ON route_planning.route_events (timestamp DESC);
CREATE INDEX idx_events_processed_planning ON route_planning.route_events (processed);

-- ========================================
-- TRIGGERS AND FUNCTIONS
-- ========================================

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION route_planning.update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to increment version for optimistic locking
CREATE OR REPLACE FUNCTION route_planning.increment_version()
RETURNS TRIGGER AS $$
BEGIN
    NEW.version = OLD.version + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to update route progress when waypoint is completed
CREATE OR REPLACE FUNCTION route_planning.update_route_progress()
RETURNS TRIGGER AS $$
DECLARE
    total_waypoints INTEGER;
    completed_waypoints INTEGER;
    progress_pct DECIMAL(5,2);
BEGIN
    IF NEW.waypoint_status = 'COMPLETED' AND OLD.waypoint_status != 'COMPLETED' THEN
        -- Calculate progress percentage
        SELECT COUNT(*) INTO total_waypoints
        FROM route_planning.waypoints
        WHERE route_id = NEW.route_id;

        SELECT COUNT(*) INTO completed_waypoints
        FROM route_planning.waypoints
        WHERE route_id = NEW.route_id AND waypoint_status = 'COMPLETED';

        progress_pct := (completed_waypoints::DECIMAL / total_waypoints::DECIMAL) * 100;

        -- Update route progress
        INSERT INTO route_planning.route_progress (route_id, current_waypoint_id, progress_percentage)
        VALUES (NEW.route_id, NEW.id, progress_pct)
        ON CONFLICT (route_id) DO UPDATE SET
            current_waypoint_id = NEW.id,
            progress_percentage = progress_pct,
            last_update = CURRENT_TIMESTAMP;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for routes table
CREATE TRIGGER trg_routes_update_timestamp
    BEFORE UPDATE ON route_planning.routes
    FOR EACH ROW
    EXECUTE FUNCTION route_planning.update_timestamp();

CREATE TRIGGER trg_routes_increment_version
    BEFORE UPDATE ON route_planning.routes
    FOR EACH ROW
    EXECUTE FUNCTION route_planning.increment_version();

-- Triggers for waypoints table
CREATE TRIGGER trg_waypoints_update_timestamp
    BEFORE UPDATE ON route_planning.waypoints
    FOR EACH ROW
    EXECUTE FUNCTION route_planning.update_timestamp();

CREATE TRIGGER trg_waypoints_progress_update
    AFTER UPDATE ON route_planning.waypoints
    FOR EACH ROW
    EXECUTE FUNCTION route_planning.update_route_progress();

-- Function to calculate route efficiency metrics
CREATE OR REPLACE FUNCTION route_planning.calculate_route_efficiency(p_route_id BIGINT)
RETURNS TABLE(
    total_distance_km DECIMAL(10,3),
    avg_waypoint_distance_km DECIMAL(8,3),
    optimization_score DECIMAL(5,2),
    time_efficiency_pct DECIMAL(5,2)
) AS $$
DECLARE
    waypoint_count INTEGER;
    total_dist DECIMAL(10,3);
    estimated_time INTEGER;
    actual_time INTEGER;
BEGIN
    -- Get basic route metrics
    SELECT COUNT(*), r.total_distance_km, r.estimated_duration_minutes, r.actual_duration_minutes
    INTO waypoint_count, total_dist, estimated_time, actual_time
    FROM route_planning.routes r
    JOIN route_planning.waypoints w ON r.id = w.route_id
    WHERE r.id = p_route_id
    GROUP BY r.id, r.total_distance_km, r.estimated_duration_minutes, r.actual_duration_minutes;

    RETURN QUERY
    SELECT
        total_dist as total_distance_km,
        CASE WHEN waypoint_count > 0 THEN total_dist / waypoint_count ELSE 0 END as avg_waypoint_distance_km,
        COALESCE((100 - (total_dist / waypoint_count * 10)), 0)::DECIMAL(5,2) as optimization_score,
        CASE
            WHEN actual_time IS NOT NULL AND estimated_time > 0
            THEN LEAST(100, (estimated_time::DECIMAL / actual_time::DECIMAL * 100))::DECIMAL(5,2)
            ELSE NULL
        END as time_efficiency_pct;
END;
$$ LANGUAGE plpgsql;

-- Function to clean old route events and optimization results
CREATE OR REPLACE FUNCTION route_planning.clean_old_data(retention_days INTEGER DEFAULT 180)
RETURNS INTEGER AS $$
DECLARE
    deleted_events INTEGER;
    deleted_results INTEGER;
    total_deleted INTEGER;
BEGIN
    -- Clean old route events
    DELETE FROM route_planning.route_events
    WHERE timestamp < (CURRENT_TIMESTAMP - INTERVAL '1 day' * retention_days)
    AND processed = true;

    GET DIAGNOSTICS deleted_events = ROW_COUNT;

    -- Clean old optimization results (keep best result per route)
    DELETE FROM route_planning.optimization_results
    WHERE id NOT IN (
        SELECT DISTINCT ON (route_id) id
        FROM route_planning.optimization_results
        ORDER BY route_id, optimization_score DESC, timestamp DESC
    )
    AND timestamp < (CURRENT_TIMESTAMP - INTERVAL '1 day' * retention_days);

    GET DIAGNOSTICS deleted_results = ROW_COUNT;

    total_deleted := deleted_events + deleted_results;
    RETURN total_deleted;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- INITIAL DATA AND CONSTRAINTS
-- ========================================

-- Add sample routes for testing
INSERT INTO route_planning.routes (
    route_id, name, municipality_id, route_type, scheduled_date, total_distance_km
) VALUES
    ('RT-001', 'Miraflores Morning Route', 1, 'REGULAR_COLLECTION', CURRENT_DATE + INTERVAL '1 day', 15.5),
    ('RT-002', 'San Isidro Emergency Route', 1, 'EMERGENCY_COLLECTION', CURRENT_DATE, 8.2),
    ('RT-003', 'Lima Centro Weekly Route', 1, 'REGULAR_COLLECTION', CURRENT_DATE + INTERVAL '2 days', 22.8)
ON CONFLICT (route_id) DO NOTHING;

-- Add comments for documentation
COMMENT ON SCHEMA route_planning IS 'Route Planning Bounded Context - Optimization and execution of waste collection routes';
COMMENT ON TABLE route_planning.routes IS 'Main aggregate root storing route information and execution status';
COMMENT ON TABLE route_planning.waypoints IS 'Entity representing individual stops within a route';
COMMENT ON TABLE route_planning.optimization_results IS 'Results from route optimization algorithms';
COMMENT ON TABLE route_planning.route_progress IS 'Real-time tracking of route execution progress';
COMMENT ON TABLE route_planning.route_events IS 'Domain events for route state changes and notifications';

-- ========================================
-- VIEWS FOR COMMON QUERIES
-- ========================================

-- View for active routes with progress
CREATE VIEW route_planning.vw_active_routes_progress AS
SELECT
    r.id,
    r.route_id,
    r.name,
    r.driver_id,
    r.vehicle_id,
    r.status,
    r.scheduled_date,
    r.start_time,
    r.total_distance_km,
    rp.progress_percentage,
    rp.distance_completed_km,
    rp.estimated_completion_time,
    COUNT(w.id) as total_waypoints,
    COUNT(CASE WHEN w.waypoint_status = 'COMPLETED' THEN 1 END) as completed_waypoints
FROM route_planning.routes r
LEFT JOIN route_planning.route_progress rp ON r.id = rp.route_id
LEFT JOIN route_planning.waypoints w ON r.id = w.route_id
WHERE r.status IN ('EXECUTING', 'ASSIGNED')
GROUP BY r.id, r.route_id, r.name, r.driver_id, r.vehicle_id, r.status,
         r.scheduled_date, r.start_time, r.total_distance_km,
         rp.progress_percentage, rp.distance_completed_km, rp.estimated_completion_time;

-- View for optimization performance analysis
CREATE VIEW route_planning.vw_optimization_performance AS
SELECT
    algorithm_used,
    COUNT(*) as optimization_count,
    AVG(optimization_score) as avg_score,
    AVG(execution_time_ms) as avg_execution_time,
    AVG(total_distance_km) as avg_distance,
    MIN(optimization_score) as min_score,
    MAX(optimization_score) as max_score
FROM route_planning.optimization_results
WHERE timestamp >= (CURRENT_TIMESTAMP - INTERVAL '30 days')
GROUP BY algorithm_used
ORDER BY avg_score DESC;

-- Grant permissions (adjust as needed for your environment)
-- GRANT USAGE ON SCHEMA route_planning TO wastetrack_app;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA route_planning TO wastetrack_app;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA route_planning TO wastetrack_app;