-- ========================================
-- Container Monitoring BC Database Schema
-- PostgreSQL Database Script
-- ========================================

-- Create schema for Container Monitoring BC
CREATE SCHEMA IF NOT EXISTS container_monitoring;

-- ========================================
-- MAIN TABLES
-- ========================================

-- Containers table (Aggregate Root)
CREATE TABLE container_monitoring.containers (
    id BIGSERIAL PRIMARY KEY,
    container_id VARCHAR(50) UNIQUE NOT NULL,
    location_latitude DECIMAL(10, 8) NOT NULL,
    location_longitude DECIMAL(11, 8) NOT NULL,
    location_address VARCHAR(500) NOT NULL,
    location_district VARCHAR(100) NOT NULL,
    capacity_volume_liters DECIMAL(10, 2) NOT NULL,
    capacity_max_weight DECIMAL(10, 2) NOT NULL,
    current_fill_percentage DECIMAL(5, 2) DEFAULT 0.0,
    fill_level_last_updated TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE',
    status_last_change TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    container_type VARCHAR(50) NOT NULL,
    municipality_id BIGINT NOT NULL,
    last_collection_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version BIGINT DEFAULT 0,

    -- Constraints
    CONSTRAINT chk_fill_percentage CHECK (current_fill_percentage >= 0 AND current_fill_percentage <= 100),
    CONSTRAINT chk_capacity_positive CHECK (capacity_volume_liters > 0 AND capacity_max_weight > 0),
    CONSTRAINT chk_coordinates CHECK (
        location_latitude BETWEEN -90 AND 90 AND
        location_longitude BETWEEN -180 AND 180
    ),
    CONSTRAINT chk_status CHECK (status IN ('ACTIVE', 'MAINTENANCE', 'OUT_OF_SERVICE', 'DAMAGED')),
    CONSTRAINT chk_container_type CHECK (container_type IN ('ORGANIC', 'RECYCLABLE', 'GENERAL_WASTE', 'HAZARDOUS'))
);

-- Sensor Readings table (Entity)
CREATE TABLE container_monitoring.sensor_readings (
    id BIGSERIAL PRIMARY KEY,
    reading_id VARCHAR(50) UNIQUE NOT NULL,
    container_id BIGINT NOT NULL,
    sensor_id VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    fill_percentage DECIMAL(5, 2) NOT NULL,
    fill_level_last_updated TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    temperature_celsius DECIMAL(5, 2),
    sensor_health_status VARCHAR(50) NOT NULL DEFAULT 'HEALTHY',
    sensor_battery_level DECIMAL(5, 2),
    sensor_signal_strength DECIMAL(5, 2),
    sensor_last_communication TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_validated BOOLEAN DEFAULT FALSE,
    validation_result JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_sensor_readings_container FOREIGN KEY (container_id)
        REFERENCES container_monitoring.containers(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_fill_percentage CHECK (fill_percentage >= 0 AND fill_percentage <= 100),
    CONSTRAINT chk_temperature CHECK (temperature_celsius BETWEEN -50 AND 100),
    CONSTRAINT chk_battery_level CHECK (sensor_battery_level >= 0 AND sensor_battery_level <= 100),
    CONSTRAINT chk_signal_strength CHECK (sensor_signal_strength >= 0 AND sensor_signal_strength <= 100),
    CONSTRAINT chk_sensor_health CHECK (sensor_health_status IN ('HEALTHY', 'WARNING', 'CRITICAL', 'OFFLINE'))
);

-- Maintenance Events table (Entity)
CREATE TABLE container_monitoring.maintenance_events (
    id BIGSERIAL PRIMARY KEY,
    container_id BIGINT NOT NULL,
    maintenance_type VARCHAR(100) NOT NULL,
    scheduled_date TIMESTAMP WITH TIME ZONE NOT NULL,
    completed_date TIMESTAMP WITH TIME ZONE,
    description TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'SCHEDULED',
    estimated_duration_hours INTEGER,
    technician_id BIGINT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_maintenance_container FOREIGN KEY (container_id)
        REFERENCES container_monitoring.containers(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_maintenance_status CHECK (status IN ('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
    CONSTRAINT chk_estimated_duration CHECK (estimated_duration_hours > 0)
);

-- ========================================
-- AUDIT AND EVENTS TABLES
-- ========================================

-- Container Events table (Domain Events)
CREATE TABLE container_monitoring.container_events (
    id BIGSERIAL PRIMARY KEY,
    event_type VARCHAR(100) NOT NULL,
    container_id BIGINT NOT NULL,
    event_data JSONB NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    processed BOOLEAN DEFAULT FALSE,
    processing_attempts INTEGER DEFAULT 0,

    -- Foreign Keys
    CONSTRAINT fk_events_container FOREIGN KEY (container_id)
        REFERENCES container_monitoring.containers(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_event_type CHECK (event_type IN (
        'CONTAINER_OVERFLOW',
        'SENSOR_MALFUNCTION',
        'MAINTENANCE_REQUIRED',
        'COLLECTION_COMPLETED',
        'CONTAINER_CREATED',
        'FILL_LEVEL_UPDATED'
    ))
);

-- Container Analytics Cache table (for performance)
CREATE TABLE container_monitoring.container_analytics_cache (
    id BIGSERIAL PRIMARY KEY,
    container_id BIGINT NOT NULL,
    analytics_type VARCHAR(100) NOT NULL,
    calculation_date DATE NOT NULL,
    analytics_data JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP WITH TIME ZONE,

    -- Foreign Keys
    CONSTRAINT fk_analytics_container FOREIGN KEY (container_id)
        REFERENCES container_monitoring.containers(id) ON DELETE CASCADE,

    -- Unique constraint to prevent duplicate analytics
    CONSTRAINT uk_analytics_cache UNIQUE (container_id, analytics_type, calculation_date)
);

-- ========================================
-- INDEXES FOR PERFORMANCE
-- ========================================

-- Containers indexes
CREATE INDEX idx_containers_location ON container_monitoring.containers USING GIST (
    ll_to_earth(location_latitude, location_longitude)
);
CREATE INDEX idx_containers_fill_level ON container_monitoring.containers (current_fill_percentage);
CREATE INDEX idx_containers_status ON container_monitoring.containers (status);
CREATE INDEX idx_containers_type ON container_monitoring.containers (container_type);
CREATE INDEX idx_containers_municipality ON container_monitoring.containers (municipality_id);
CREATE INDEX idx_containers_collection_date ON container_monitoring.containers (last_collection_date);

-- Sensor readings indexes
CREATE INDEX idx_sensor_readings_container ON container_monitoring.sensor_readings (container_id);
CREATE INDEX idx_sensor_readings_timestamp ON container_monitoring.sensor_readings (timestamp DESC);
CREATE INDEX idx_sensor_readings_sensor ON container_monitoring.sensor_readings (sensor_id);
CREATE INDEX idx_sensor_readings_validation ON container_monitoring.sensor_readings (is_validated);
CREATE INDEX idx_sensor_readings_container_timestamp ON container_monitoring.sensor_readings (container_id, timestamp DESC);

-- Maintenance events indexes
CREATE INDEX idx_maintenance_container ON container_monitoring.maintenance_events (container_id);
CREATE INDEX idx_maintenance_status ON container_monitoring.maintenance_events (status);
CREATE INDEX idx_maintenance_scheduled_date ON container_monitoring.maintenance_events (scheduled_date);

-- Container events indexes
CREATE INDEX idx_events_container ON container_monitoring.container_events (container_id);
CREATE INDEX idx_events_timestamp ON container_monitoring.container_events (timestamp DESC);
CREATE INDEX idx_events_type ON container_monitoring.container_events (event_type);
CREATE INDEX idx_events_processed ON container_monitoring.container_events (processed);

-- Analytics cache indexes
CREATE INDEX idx_analytics_container ON container_monitoring.container_analytics_cache (container_id);
CREATE INDEX idx_analytics_type ON container_monitoring.container_analytics_cache (analytics_type);
CREATE INDEX idx_analytics_expires ON container_monitoring.container_analytics_cache (expires_at);

-- ========================================
-- TRIGGERS AND FUNCTIONS
-- ========================================

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION container_monitoring.update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to increment version for optimistic locking
CREATE OR REPLACE FUNCTION container_monitoring.increment_version()
RETURNS TRIGGER AS $$
BEGIN
    NEW.version = OLD.version + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for containers table
CREATE TRIGGER trg_containers_update_timestamp
    BEFORE UPDATE ON container_monitoring.containers
    FOR EACH ROW
    EXECUTE FUNCTION container_monitoring.update_timestamp();

CREATE TRIGGER trg_containers_increment_version
    BEFORE UPDATE ON container_monitoring.containers
    FOR EACH ROW
    EXECUTE FUNCTION container_monitoring.increment_version();

-- Triggers for maintenance events table
CREATE TRIGGER trg_maintenance_update_timestamp
    BEFORE UPDATE ON container_monitoring.maintenance_events
    FOR EACH ROW
    EXECUTE FUNCTION container_monitoring.update_timestamp();

-- Function to clean old sensor readings (data retention)
CREATE OR REPLACE FUNCTION container_monitoring.clean_old_sensor_readings(retention_days INTEGER DEFAULT 90)
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM container_monitoring.sensor_readings
    WHERE created_at < (CURRENT_TIMESTAMP - INTERVAL '1 day' * retention_days);

    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Function to clean expired analytics cache
CREATE OR REPLACE FUNCTION container_monitoring.clean_expired_analytics()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM container_monitoring.container_analytics_cache
    WHERE expires_at IS NOT NULL AND expires_at < CURRENT_TIMESTAMP;

    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- INITIAL DATA AND CONSTRAINTS
-- ========================================

-- Add some reference/lookup data if needed
INSERT INTO container_monitoring.containers (
    container_id,
    location_latitude,
    location_longitude,
    location_address,
    location_district,
    capacity_volume_liters,
    capacity_max_weight,
    container_type,
    municipality_id
) VALUES
    ('CNT-001', -12.0464, -77.0428, 'Av. Arequipa 1234', 'Miraflores', 1000.0, 500.0, 'GENERAL_WASTE', 1),
    ('CNT-002', -12.0621, -77.0365, 'Jr. Lampa 567', 'Lima Cercado', 800.0, 400.0, 'RECYCLABLE', 1),
    ('CNT-003', -12.1192, -77.0285, 'Av. Javier Prado 890', 'San Isidro', 1200.0, 600.0, 'ORGANIC', 1)
ON CONFLICT (container_id) DO NOTHING;

-- Add comments for documentation
COMMENT ON SCHEMA container_monitoring IS 'Container Monitoring Bounded Context - IoT waste container management';
COMMENT ON TABLE container_monitoring.containers IS 'Main aggregate root storing container information and current state';
COMMENT ON TABLE container_monitoring.sensor_readings IS 'Entity storing individual sensor measurements from IoT devices';
COMMENT ON TABLE container_monitoring.maintenance_events IS 'Entity tracking container maintenance activities';
COMMENT ON TABLE container_monitoring.container_events IS 'Domain events for container state changes and notifications';
COMMENT ON TABLE container_monitoring.container_analytics_cache IS 'Cached analytics data for performance optimization';

-- ========================================
-- VIEWS FOR COMMON QUERIES
-- ========================================

-- View for containers with current status
CREATE VIEW container_monitoring.vw_container_status AS
SELECT
    c.id,
    c.container_id,
    c.location_address,
    c.location_district,
    c.current_fill_percentage,
    c.status,
    c.container_type,
    c.last_collection_date,
    CASE
        WHEN c.current_fill_percentage >= 90 THEN 'CRITICAL'
        WHEN c.current_fill_percentage >= 75 THEN 'HIGH'
        WHEN c.current_fill_percentage >= 50 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS priority_level,
    sr.timestamp AS last_reading_time,
    sr.sensor_health_status
FROM container_monitoring.containers c
LEFT JOIN LATERAL (
    SELECT timestamp, sensor_health_status
    FROM container_monitoring.sensor_readings sr2
    WHERE sr2.container_id = c.id
    ORDER BY timestamp DESC
    LIMIT 1
) sr ON true;

-- View for overflowing containers requiring immediate attention
CREATE VIEW container_monitoring.vw_critical_containers AS
SELECT
    c.container_id,
    c.location_address,
    c.location_district,
    c.current_fill_percentage,
    c.last_collection_date,
    EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - c.last_collection_date))/3600 AS hours_since_collection
FROM container_monitoring.containers c
WHERE c.current_fill_percentage >= 90
   OR c.status = 'DAMAGED'
   OR c.last_collection_date < (CURRENT_TIMESTAMP - INTERVAL '7 days');

-- Grant permissions (adjust as needed for your environment)
-- GRANT USAGE ON SCHEMA container_monitoring TO wastetrack_app;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA container_monitoring TO wastetrack_app;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA container_monitoring TO wastetrack_app;