-- ========================================
-- Community Relations BC Database Schema
-- PostgreSQL Database Script
-- ========================================

-- Create schema for Community Relations BC
CREATE SCHEMA IF NOT EXISTS community_relations;

-- ========================================
-- MAIN TABLES
-- ========================================

-- Citizens table (Aggregate Root)
CREATE TABLE community_relations.citizens (
    id BIGSERIAL PRIMARY KEY,
    citizen_id VARCHAR(50) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    document_type VARCHAR(20) NOT NULL,
    document_number VARCHAR(20) NOT NULL,
    birth_date DATE,
    email VARCHAR(200) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    alternative_phone VARCHAR(20),
    street_address VARCHAR(300),
    address_number VARCHAR(20),
    district VARCHAR(100),
    city VARCHAR(100) DEFAULT 'Lima',
    postal_code VARCHAR(10),
    registration_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    membership_level VARCHAR(30) NOT NULL DEFAULT 'BASIC',
    membership_join_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    engagement_level VARCHAR(30) NOT NULL DEFAULT 'NEW',
    engagement_score DECIMAL(5, 2) DEFAULT 0.0,
    engagement_last_calculation TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    total_reward_points INTEGER DEFAULT 0,
    language_preference VARCHAR(10) DEFAULT 'es',
    notification_email BOOLEAN DEFAULT TRUE,
    notification_sms BOOLEAN DEFAULT TRUE,
    notification_push BOOLEAN DEFAULT TRUE,
    privacy_level VARCHAR(20) DEFAULT 'STANDARD',
    is_active BOOLEAN DEFAULT TRUE,
    last_activity TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version BIGINT DEFAULT 0,

    -- Constraints
    CONSTRAINT chk_document_type CHECK (document_type IN ('DNI', 'PASSPORT', 'CE')),
    CONSTRAINT chk_membership_level CHECK (membership_level IN (
        'BASIC', 'BRONZE', 'SILVER', 'GOLD', 'PLATINUM', 'DIAMOND'
    )),
    CONSTRAINT chk_engagement_level CHECK (engagement_level IN (
        'NEW', 'LOW', 'MEDIUM', 'HIGH', 'VERY_HIGH', 'CHAMPION'
    )),
    CONSTRAINT chk_privacy_level CHECK (privacy_level IN ('MINIMAL', 'STANDARD', 'STRICT')),
    CONSTRAINT chk_engagement_score CHECK (engagement_score >= 0 AND engagement_score <= 100),
    CONSTRAINT chk_reward_points CHECK (total_reward_points >= 0),
    CONSTRAINT uk_citizens_document UNIQUE (document_type, document_number)
);

-- Reports table (Aggregate Root)
CREATE TABLE community_relations.reports (
    id BIGSERIAL PRIMARY KEY,
    report_id VARCHAR(50) UNIQUE NOT NULL,
    citizen_id BIGINT NOT NULL,
    report_type VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    location_latitude DECIMAL(10, 8) NOT NULL,
    location_longitude DECIMAL(11, 8) NOT NULL,
    location_address VARCHAR(500),
    priority_level INTEGER NOT NULL DEFAULT 2,
    priority_description VARCHAR(100),
    status VARCHAR(30) NOT NULL DEFAULT 'SUBMITTED',
    status_last_change TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    assigned_container_id BIGINT,
    submission_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    acknowledgment_date TIMESTAMP WITH TIME ZONE,
    resolution_date TIMESTAMP WITH TIME ZONE,
    estimated_resolution_date TIMESTAMP WITH TIME ZONE,
    resolution_description TEXT,
    administrator_notes TEXT,
    citizen_feedback_rating INTEGER,
    citizen_feedback_comments TEXT,
    citizen_feedback_date TIMESTAMP WITH TIME ZONE,
    resolution_time_hours INTEGER,
    is_anonymous BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version BIGINT DEFAULT 0,

    -- Foreign Keys
    CONSTRAINT fk_reports_citizen FOREIGN KEY (citizen_id)
        REFERENCES community_relations.citizens(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_report_type CHECK (report_type IN (
        'CONTAINER_OVERFLOW', 'CONTAINER_DAMAGE', 'MISSED_COLLECTION',
        'ILLEGAL_DUMPING', 'STREET_CLEANING', 'HAZARDOUS_WASTE',
        'RECYCLING_ISSUE', 'GENERAL_COMPLAINT', 'SUGGESTION'
    )),
    CONSTRAINT chk_report_status CHECK (status IN (
        'SUBMITTED', 'ACKNOWLEDGED', 'IN_PROGRESS', 'UNDER_REVIEW',
        'RESOLVED', 'CLOSED', 'REJECTED', 'DUPLICATE'
    )),
    CONSTRAINT chk_priority_level CHECK (priority_level BETWEEN 1 AND 5),
    CONSTRAINT chk_coordinates CHECK (
        location_latitude BETWEEN -90 AND 90 AND
        location_longitude BETWEEN -180 AND 180
    ),
    CONSTRAINT chk_feedback_rating CHECK (
        citizen_feedback_rating IS NULL OR
        (citizen_feedback_rating >= 1 AND citizen_feedback_rating <= 5)
    ),
    CONSTRAINT chk_resolution_dates CHECK (
        (resolution_date IS NULL) OR
        (acknowledgment_date IS NULL OR resolution_date >= acknowledgment_date)
    )
);

-- Report Images table (Entity)
CREATE TABLE community_relations.report_images (
    id BIGSERIAL PRIMARY KEY,
    image_id VARCHAR(50) UNIQUE NOT NULL,
    report_id BIGINT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size BIGINT NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    description VARCHAR(300),
    upload_order INTEGER DEFAULT 1,
    uploaded_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_images_report FOREIGN KEY (report_id)
        REFERENCES community_relations.reports(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_file_size CHECK (file_size > 0 AND file_size <= 52428800), -- 50MB max
    CONSTRAINT chk_mime_type CHECK (mime_type IN (
        'image/jpeg', 'image/png', 'image/gif', 'image/webp'
    )),
    CONSTRAINT chk_upload_order CHECK (upload_order > 0)
);

-- Notifications table (Entity)
CREATE TABLE community_relations.notifications (
    id BIGSERIAL PRIMARY KEY,
    notification_id VARCHAR(50) UNIQUE NOT NULL,
    citizen_id BIGINT NOT NULL,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    priority VARCHAR(20) NOT NULL DEFAULT 'MEDIUM',
    channel VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    scheduled_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    sent_date TIMESTAMP WITH TIME ZONE,
    read_date TIMESTAMP WITH TIME ZONE,
    expiry_date TIMESTAMP WITH TIME ZONE,
    related_entity_type VARCHAR(50),
    related_entity_id BIGINT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_notifications_citizen FOREIGN KEY (citizen_id)
        REFERENCES community_relations.citizens(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_notification_type CHECK (type IN (
        'WELCOME', 'REPORT_ACKNOWLEDGMENT', 'REPORT_UPDATE', 'REPORT_RESOLVED',
        'REWARDS_EARNED', 'REWARDS_REDEEMED', 'LEVEL_UP', 'SYSTEM_ANNOUNCEMENT',
        'REMINDER', 'SURVEY_REQUEST'
    )),
    CONSTRAINT chk_notification_priority CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    CONSTRAINT chk_notification_channel CHECK (channel IN ('EMAIL', 'SMS', 'PUSH', 'IN_APP')),
    CONSTRAINT chk_notification_status CHECK (status IN ('PENDING', 'SENT', 'DELIVERED', 'READ', 'FAILED', 'EXPIRED')),
    CONSTRAINT chk_related_entity CHECK (
        (related_entity_type IS NULL AND related_entity_id IS NULL) OR
        (related_entity_type IS NOT NULL AND related_entity_id IS NOT NULL)
    )
);

-- Rewards Programs table (Aggregate Root)
CREATE TABLE community_relations.rewards_programs (
    id BIGSERIAL PRIMARY KEY,
    program_id VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE,
    rules JSONB NOT NULL,
    redemption_options JSONB,
    total_participants INTEGER DEFAULT 0,
    total_points_awarded BIGINT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version BIGINT DEFAULT 0,

    -- Constraints
    CONSTRAINT chk_program_dates CHECK (
        end_date IS NULL OR end_date > start_date
    ),
    CONSTRAINT chk_participants CHECK (total_participants >= 0),
    CONSTRAINT chk_points_awarded CHECK (total_points_awarded >= 0)
);

-- Citizen Rewards History table
CREATE TABLE community_relations.citizen_rewards_history (
    id BIGSERIAL PRIMARY KEY,
    citizen_id BIGINT NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    points INTEGER NOT NULL,
    reason VARCHAR(500) NOT NULL,
    related_entity_type VARCHAR(50),
    related_entity_id BIGINT,
    earned_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    expiry_date TIMESTAMP WITH TIME ZONE,
    redemption_date TIMESTAMP WITH TIME ZONE,
    redemption_description VARCHAR(300),
    program_id BIGINT,

    -- Foreign Keys
    CONSTRAINT fk_rewards_citizen FOREIGN KEY (citizen_id)
        REFERENCES community_relations.citizens(id) ON DELETE CASCADE,
    CONSTRAINT fk_rewards_program FOREIGN KEY (program_id)
        REFERENCES community_relations.rewards_programs(id) ON DELETE SET NULL,

    -- Constraints
    CONSTRAINT chk_transaction_type CHECK (transaction_type IN ('EARNED', 'REDEEMED', 'EXPIRED', 'ADJUSTED')),
    CONSTRAINT chk_points_value CHECK (
        (transaction_type = 'EARNED' AND points > 0) OR
        (transaction_type IN ('REDEEMED', 'EXPIRED') AND points < 0) OR
        (transaction_type = 'ADJUSTED')
    ),
    CONSTRAINT chk_redemption_logic CHECK (
        (transaction_type != 'REDEEMED') OR
        (redemption_date IS NOT NULL AND redemption_description IS NOT NULL)
    )
);

-- Citizen Topic Interests table (for preferences)
CREATE TABLE community_relations.citizen_topic_interests (
    id BIGSERIAL PRIMARY KEY,
    citizen_id BIGINT NOT NULL,
    topic VARCHAR(100) NOT NULL,
    interest_level VARCHAR(20) NOT NULL DEFAULT 'MEDIUM',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_interests_citizen FOREIGN KEY (citizen_id)
        REFERENCES community_relations.citizens(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_topic_interest CHECK (topic IN (
        'RECYCLING', 'COMPOSTING', 'WASTE_REDUCTION', 'ENVIRONMENTAL_EDUCATION',
        'COMMUNITY_EVENTS', 'NEIGHBORHOOD_CLEANUP', 'SUSTAINABILITY', 'HAZARDOUS_WASTE'
    )),
    CONSTRAINT chk_interest_level CHECK (interest_level IN ('LOW', 'MEDIUM', 'HIGH')),
    CONSTRAINT uk_citizen_topic UNIQUE (citizen_id, topic)
);

-- ========================================
-- AUDIT AND EVENTS TABLES
-- ========================================

-- Community Events table (Domain Events)
CREATE TABLE community_relations.community_events (
    id BIGSERIAL PRIMARY KEY,
    event_type VARCHAR(100) NOT NULL,
    citizen_id BIGINT,
    report_id BIGINT,
    program_id BIGINT,
    event_data JSONB NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    processed BOOLEAN DEFAULT FALSE,
    processing_attempts INTEGER DEFAULT 0,

    -- Foreign Keys
    CONSTRAINT fk_events_citizen FOREIGN KEY (citizen_id)
        REFERENCES community_relations.citizens(id) ON DELETE SET NULL,
    CONSTRAINT fk_events_report FOREIGN KEY (report_id)
        REFERENCES community_relations.reports(id) ON DELETE SET NULL,
    CONSTRAINT fk_events_program FOREIGN KEY (program_id)
        REFERENCES community_relations.rewards_programs(id) ON DELETE SET NULL,

    -- Constraints
    CONSTRAINT chk_event_type_community CHECK (event_type IN (
        'CITIZEN_REGISTERED',
        'REPORT_SUBMITTED',
        'REPORT_RESOLVED',
        'REWARDS_EARNED',
        'REWARDS_REDEEMED',
        'ENGAGEMENT_LEVEL_CHANGED',
        'MEMBERSHIP_UPGRADED',
        'FEEDBACK_SUBMITTED'
    ))
);

-- Engagement Metrics History table
CREATE TABLE community_relations.engagement_metrics_history (
    id BIGSERIAL PRIMARY KEY,
    citizen_id BIGINT NOT NULL,
    measurement_date DATE NOT NULL,
    engagement_score DECIMAL(5, 2) NOT NULL,
    engagement_level VARCHAR(30) NOT NULL,
    reports_submitted INTEGER DEFAULT 0,
    reports_resolved INTEGER DEFAULT 0,
    rewards_earned INTEGER DEFAULT 0,
    notifications_read INTEGER DEFAULT 0,
    activities_participated INTEGER DEFAULT 0,
    feedback_provided INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_engagement_citizen FOREIGN KEY (citizen_id)
        REFERENCES community_relations.citizens(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_engagement_score_history CHECK (engagement_score >= 0 AND engagement_score <= 100),
    CONSTRAINT chk_metrics_positive CHECK (
        reports_submitted >= 0 AND reports_resolved >= 0 AND
        rewards_earned >= 0 AND notifications_read >= 0 AND
        activities_participated >= 0 AND feedback_provided >= 0
    ),
    CONSTRAINT uk_engagement_history UNIQUE (citizen_id, measurement_date)
);

-- ========================================
-- INDEXES FOR PERFORMANCE
-- ========================================

-- Citizens indexes
CREATE INDEX idx_citizens_email ON community_relations.citizens (email);
CREATE INDEX idx_citizens_district ON community_relations.citizens (district);
CREATE INDEX idx_citizens_membership ON community_relations.citizens (membership_level);
CREATE INDEX idx_citizens_engagement ON community_relations.citizens (engagement_level, engagement_score);
CREATE INDEX idx_citizens_active ON community_relations.citizens (is_active, last_activity);
CREATE INDEX idx_citizens_document ON community_relations.citizens (document_type, document_number);

-- Reports indexes
CREATE INDEX idx_reports_citizen ON community_relations.reports (citizen_id);
CREATE INDEX idx_reports_type ON community_relations.reports (report_type);
CREATE INDEX idx_reports_status ON community_relations.reports (status);
CREATE INDEX idx_reports_priority ON community_relations.reports (priority_level DESC);
CREATE INDEX idx_reports_submission_date ON community_relations.reports (submission_date DESC);
CREATE INDEX idx_reports_location ON community_relations.reports USING GIST (
    ll_to_earth(location_latitude, location_longitude)
);
CREATE INDEX idx_reports_container ON community_relations.reports (assigned_container_id);
CREATE INDEX idx_reports_resolution_time ON community_relations.reports (resolution_time_hours);

-- Report images indexes
CREATE INDEX idx_images_report ON community_relations.report_images (report_id);
CREATE INDEX idx_images_upload_date ON community_relations.report_images (uploaded_date DESC);

-- Notifications indexes
CREATE INDEX idx_notifications_citizen ON community_relations.notifications (citizen_id);
CREATE INDEX idx_notifications_type ON community_relations.notifications (type);
CREATE INDEX idx_notifications_status ON community_relations.notifications (status);
CREATE INDEX idx_notifications_channel ON community_relations.notifications (channel);
CREATE INDEX idx_notifications_scheduled ON community_relations.notifications (scheduled_date);
CREATE INDEX idx_notifications_unread ON community_relations.notifications (citizen_id, status)
    WHERE status IN ('PENDING', 'SENT', 'DELIVERED');

-- Rewards history indexes
CREATE INDEX idx_rewards_citizen ON community_relations.citizen_rewards_history (citizen_id);
CREATE INDEX idx_rewards_type ON community_relations.citizen_rewards_history (transaction_type);
CREATE INDEX idx_rewards_earned_date ON community_relations.citizen_rewards_history (earned_date DESC);
CREATE INDEX idx_rewards_expiry ON community_relations.citizen_rewards_history (expiry_date)
    WHERE expiry_date IS NOT NULL;

-- Community events indexes
CREATE INDEX idx_events_community_type ON community_relations.community_events (event_type);
CREATE INDEX idx_events_community_timestamp ON community_relations.community_events (timestamp DESC);
CREATE INDEX idx_events_community_processed ON community_relations.community_events (processed);

-- Engagement metrics indexes
CREATE INDEX idx_engagement_citizen ON community_relations.engagement_metrics_history (citizen_id);
CREATE INDEX idx_engagement_date ON community_relations.engagement_metrics_history (measurement_date DESC);
CREATE INDEX idx_engagement_score_trend ON community_relations.engagement_metrics_history (citizen_id, measurement_date);

-- ========================================
-- TRIGGERS AND FUNCTIONS
-- ========================================

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION community_relations.update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to increment version for optimistic locking
CREATE OR REPLACE FUNCTION community_relations.increment_version()
RETURNS TRIGGER AS $$
BEGIN
    NEW.version = OLD.version + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to update citizen engagement when reports are submitted/resolved
CREATE OR REPLACE FUNCTION community_relations.update_citizen_engagement()
RETURNS TRIGGER AS $$
DECLARE
    citizen_reports_count INTEGER;
    citizen_resolved_count INTEGER;
    new_engagement_score DECIMAL(5,2);
    new_engagement_level VARCHAR(30);
BEGIN
    -- Count citizen's reports
    SELECT COUNT(*), COUNT(CASE WHEN status = 'RESOLVED' THEN 1 END)
    INTO citizen_reports_count, citizen_resolved_count
    FROM community_relations.reports
    WHERE citizen_id = COALESCE(NEW.citizen_id, OLD.citizen_id);

    -- Calculate engagement score (simplified algorithm)
    new_engagement_score := LEAST(100,
        (citizen_reports_count * 10) +
        (citizen_resolved_count * 5) +
        (CASE WHEN NEW.citizen_feedback_rating IS NOT NULL THEN 5 ELSE 0 END)
    );

    -- Determine engagement level
    new_engagement_level := CASE
        WHEN new_engagement_score >= 80 THEN 'CHAMPION'
        WHEN new_engagement_score >= 60 THEN 'VERY_HIGH'
        WHEN new_engagement_score >= 40 THEN 'HIGH'
        WHEN new_engagement_score >= 20 THEN 'MEDIUM'
        WHEN new_engagement_score >= 5 THEN 'LOW'
        ELSE 'NEW'
    END;

    -- Update citizen engagement
    UPDATE community_relations.citizens
    SET engagement_score = new_engagement_score,
        engagement_level = new_engagement_level,
        engagement_last_calculation = CURRENT_TIMESTAMP,
        last_activity = CURRENT_TIMESTAMP
    WHERE id = COALESCE(NEW.citizen_id, OLD.citizen_id);

    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Function to calculate resolution time when report is resolved
CREATE OR REPLACE FUNCTION community_relations.calculate_resolution_time()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'RESOLVED' AND OLD.status != 'RESOLVED' AND NEW.resolution_date IS NOT NULL THEN
        NEW.resolution_time_hours := EXTRACT(EPOCH FROM (NEW.resolution_date - NEW.submission_date)) / 3600;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for main tables
CREATE TRIGGER trg_citizens_update_timestamp
    BEFORE UPDATE ON community_relations.citizens
    FOR EACH ROW
    EXECUTE FUNCTION community_relations.update_timestamp();

CREATE TRIGGER trg_citizens_increment_version
    BEFORE UPDATE ON community_relations.citizens
    FOR EACH ROW
    EXECUTE FUNCTION community_relations.increment_version();

CREATE TRIGGER trg_reports_update_timestamp
    BEFORE UPDATE ON community_relations.reports
    FOR EACH ROW
    EXECUTE FUNCTION community_relations.update_timestamp();

CREATE TRIGGER trg_reports_increment_version
    BEFORE UPDATE ON community_relations.reports
    FOR EACH ROW
    EXECUTE FUNCTION community_relations.increment_version();

CREATE TRIGGER trg_reports_engagement_update
    AFTER INSERT OR UPDATE OR DELETE ON community_relations.reports
    FOR EACH ROW
    EXECUTE FUNCTION community_relations.update_citizen_engagement();

CREATE TRIGGER trg_reports_resolution_time
    BEFORE UPDATE ON community_relations.reports
    FOR EACH ROW
    EXECUTE FUNCTION community_relations.calculate_resolution_time();

-- Function to clean expired notifications
CREATE OR REPLACE FUNCTION community_relations.clean_expired_notifications()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM community_relations.notifications
    WHERE expiry_date IS NOT NULL
    AND expiry_date < CURRENT_TIMESTAMP
    AND status IN ('PENDING', 'FAILED');

    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate citizen engagement statistics
CREATE OR REPLACE FUNCTION community_relations.calculate_citizen_stats(p_citizen_id BIGINT)
RETURNS TABLE(
    total_reports INTEGER,
    resolved_reports INTEGER,
    avg_resolution_time_hours DECIMAL(10,2),
    total_reward_points INTEGER,
    engagement_trend VARCHAR(20)
) AS $$
DECLARE
    current_score DECIMAL(5,2);
    previous_score DECIMAL(5,2);
BEGIN
    -- Get current engagement score
    SELECT engagement_score INTO current_score
    FROM community_relations.citizens
    WHERE id = p_citizen_id;

    -- Get previous month's score
    SELECT engagement_score INTO previous_score
    FROM community_relations.engagement_metrics_history
    WHERE citizen_id = p_citizen_id
    AND measurement_date = (CURRENT_DATE - INTERVAL '1 month')::DATE;

    RETURN QUERY
    SELECT
        COUNT(r.id)::INTEGER as total_reports,
        COUNT(CASE WHEN r.status = 'RESOLVED' THEN 1 END)::INTEGER as resolved_reports,
        AVG(r.resolution_time_hours) as avg_resolution_time_hours,
        c.total_reward_points,
        CASE
            WHEN previous_score IS NULL THEN 'NEW'
            WHEN current_score > previous_score THEN 'IMPROVING'
            WHEN current_score < previous_score THEN 'DECLINING'
            ELSE 'STABLE'
        END as engagement_trend
    FROM community_relations.citizens c
    LEFT JOIN community_relations.reports r ON c.id = r.citizen_id
    WHERE c.id = p_citizen_id
    GROUP BY c.total_reward_points;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- INITIAL DATA AND CONSTRAINTS
-- ========================================

-- Add sample rewards program
INSERT INTO community_relations.rewards_programs (
    program_id, name, description, rules, redemption_options
) VALUES (
    'PROG-001',
    'Lima Green Citizens Program',
    'Programa de recompensas para ciudadanos comprometidos con el medio ambiente',
    '{"report_submission": 10, "report_resolution": 5, "feedback_provided": 3, "monthly_bonus": 50}',
    '[{"name": "Descuento en servicios municipales", "points": 100}, {"name": "Kit de reciclaje", "points": 200}]'
) ON CONFLICT (program_id) DO NOTHING;

-- Add comments for documentation
COMMENT ON SCHEMA community_relations IS 'Community Relations Bounded Context - Citizen engagement, reports, and rewards management';
COMMENT ON TABLE community_relations.citizens IS 'Main aggregate root for citizen management with engagement and rewards tracking';
COMMENT ON TABLE community_relations.reports IS 'Citizen problem reports aggregate root with location and resolution tracking';
COMMENT ON TABLE community_relations.rewards_programs IS 'Rewards programs configuration with rules and redemption options';
COMMENT ON TABLE community_relations.citizen_rewards_history IS 'Complete history of citizen reward transactions';

-- ========================================
-- VIEWS FOR COMMON QUERIES
-- ========================================

-- View for citizen engagement overview
CREATE VIEW community_relations.vw_citizen_engagement_overview AS
SELECT
    c.id,
    c.citizen_id,
    c.first_name,
    c.last_name,
    c.email,
    c.district,
    c.membership_level,
    c.engagement_level,
    c.engagement_score,
    c.total_reward_points,
    COUNT(r.id) as total_reports,
    COUNT(CASE WHEN r.status = 'RESOLVED' THEN 1 END) as resolved_reports,
    AVG(r.citizen_feedback_rating) as avg_feedback_rating,
    MAX(r.submission_date) as last_report_date,
    COUNT(CASE WHEN n.status = 'READ' THEN 1 END) as notifications_read,
    c.last_activity
FROM community_relations.citizens c
LEFT JOIN community_relations.reports r ON c.id = r.citizen_id
LEFT JOIN community_relations.notifications n ON c.id = n.citizen_id
WHERE c.is_active = true
GROUP BY c.id, c.citizen_id, c.first_name, c.last_name, c.email, c.district,
         c.membership_level, c.engagement_level, c.engagement_score,
         c.total_reward_points, c.last_activity;

-- View for active reports with citizen info
CREATE VIEW community_relations.vw_active_reports AS
SELECT
    r.id,
    r.report_id,
    r.report_type,
    r.title,
    r.priority_level,
    r.status,
    r.submission_date,
    r.estimated_resolution_date,
    r.location_address,
    r.location_latitude,
    r.location_longitude,
    c.first_name || ' ' || c.last_name as citizen_name,
    c.email as citizen_email,
    c.phone_number as citizen_phone,
    EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - r.submission_date))/3600 as hours_since_submission,
    COUNT(ri.id) as total_images
FROM community_relations.reports r
JOIN community_relations.citizens c ON r.citizen_id = c.id
LEFT JOIN community_relations.report_images ri ON r.id = ri.report_id
WHERE r.status NOT IN ('RESOLVED', 'CLOSED', 'REJECTED')
GROUP BY r.id, r.report_id, r.report_type, r.title, r.priority_level, r.status,
         r.submission_date, r.estimated_resolution_date, r.location_address,
         r.location_latitude, r.location_longitude, c.first_name, c.last_name,
         c.email, c.phone_number
ORDER BY r.priority_level DESC, r.submission_date ASC;

-- Grant permissions (adjust as needed for your environment)
-- GRANT USAGE ON SCHEMA community_relations TO wastetrack_app;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA community_relations TO wastetrack_app;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA community_relations TO wastetrack_app;