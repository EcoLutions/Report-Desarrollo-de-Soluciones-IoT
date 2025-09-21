-- ========================================
-- Communication Hub BC Database Schema
-- PostgreSQL Database Script
-- ========================================

-- Create schema for Communication Hub BC
CREATE SCHEMA IF NOT EXISTS communication_hub;

-- ========================================
-- MAIN TABLES
-- ========================================

-- Notification Requests table (Aggregate Root)
CREATE TABLE communication_hub.notification_requests (
    id BIGSERIAL PRIMARY KEY,
    request_id VARCHAR(50) UNIQUE NOT NULL,
    source_context VARCHAR(100) NOT NULL,
    source_entity_type VARCHAR(50),
    source_entity_id VARCHAR(100),
    recipient_id VARCHAR(100) NOT NULL,
    recipient_type VARCHAR(50) NOT NULL,
    message_type VARCHAR(50) NOT NULL,
    priority INTEGER NOT NULL DEFAULT 2,
    priority_description VARCHAR(100),
    template_id VARCHAR(50),
    template_data JSONB,
    preferred_channels JSONB NOT NULL DEFAULT '[]',
    scheduled_date TIMESTAMP WITH TIME ZONE,
    expiry_date TIMESTAMP WITH TIME ZONE,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    total_attempts INTEGER DEFAULT 0,
    max_attempts INTEGER DEFAULT 3,
    last_attempt_date TIMESTAMP WITH TIME ZONE,
    delivery_confirmation BOOLEAN DEFAULT FALSE,
    confirmation_date TIMESTAMP WITH TIME ZONE,
    cost_total DECIMAL(8, 4) DEFAULT 0.0000,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version BIGINT DEFAULT 0,

    -- Constraints
    CONSTRAINT chk_notification_status CHECK (status IN (
        'PENDING', 'PROCESSING', 'DELIVERED', 'PARTIALLY_DELIVERED',
        'FAILED', 'EXPIRED', 'CANCELLED'
    )),
    CONSTRAINT chk_priority_level CHECK (priority BETWEEN 1 AND 5),
    CONSTRAINT chk_recipient_type CHECK (recipient_type IN (
        'CITIZEN', 'MUNICIPAL_ADMINISTRATOR', 'DRIVER', 'COMMUNITY_LEADER', 'SYSTEM_ADMIN'
    )),
    CONSTRAINT chk_message_type CHECK (message_type IN (
        'ALERT', 'NOTIFICATION', 'REMINDER', 'CONFIRMATION', 'MARKETING',
        'SYSTEM_ANNOUNCEMENT', 'EMERGENCY', 'WELCOME', 'INVOICE', 'REWARD'
    )),
    CONSTRAINT chk_source_context CHECK (source_context IN (
        'CONTAINER_MONITORING', 'ROUTE_PLANNING', 'MUNICIPAL_OPERATIONS',
        'PAYMENT_SUBSCRIPTIONS', 'COMMUNITY_RELATIONS', 'SYSTEM'
    )),
    CONSTRAINT chk_expiry_logic CHECK (
        expiry_date IS NULL OR expiry_date > created_at
    ),
    CONSTRAINT chk_attempt_limits CHECK (
        total_attempts >= 0 AND max_attempts > 0 AND total_attempts <= max_attempts
    )
);

-- Message Templates table (Aggregate Root)
CREATE TABLE communication_hub.message_templates (
    id BIGSERIAL PRIMARY KEY,
    template_id VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(200) NOT NULL,
    category VARCHAR(50) NOT NULL,
    message_type VARCHAR(50) NOT NULL,
    channels JSONB NOT NULL DEFAULT '[]',
    subject_template VARCHAR(500),
    body_template TEXT NOT NULL,
    variables JSONB NOT NULL DEFAULT '[]',
    localization JSONB NOT NULL DEFAULT '{}',
    version_number INTEGER NOT NULL DEFAULT 1,
    is_active BOOLEAN DEFAULT TRUE,
    is_default BOOLEAN DEFAULT FALSE,
    usage_count INTEGER DEFAULT 0,
    last_used_date TIMESTAMP WITH TIME ZONE,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version BIGINT DEFAULT 0,

    -- Constraints
    CONSTRAINT chk_template_category CHECK (category IN (
        'SYSTEM', 'TRANSACTIONAL', 'MARKETING', 'EMERGENCY', 'OPERATIONAL'
    )),
    CONSTRAINT chk_template_message_type CHECK (message_type IN (
        'ALERT', 'NOTIFICATION', 'REMINDER', 'CONFIRMATION', 'MARKETING',
        'SYSTEM_ANNOUNCEMENT', 'EMERGENCY', 'WELCOME', 'INVOICE', 'REWARD'
    )),
    CONSTRAINT chk_version_number CHECK (version_number > 0),
    CONSTRAINT chk_usage_count CHECK (usage_count >= 0),
    CONSTRAINT uk_template_default UNIQUE (message_type, is_default)
        DEFERRABLE INITIALLY DEFERRED
);

-- Delivery Records table (Aggregate Root)
CREATE TABLE communication_hub.delivery_records (
    id BIGSERIAL PRIMARY KEY,
    record_id VARCHAR(50) UNIQUE NOT NULL,
    request_id BIGINT NOT NULL,
    channel VARCHAR(20) NOT NULL,
    provider VARCHAR(50) NOT NULL,
    provider_transaction_id VARCHAR(200),
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    attempt_number INTEGER NOT NULL DEFAULT 1,
    scheduled_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    sent_date TIMESTAMP WITH TIME ZONE,
    delivered_date TIMESTAMP WITH TIME ZONE,
    confirmed_date TIMESTAMP WITH TIME ZONE,
    failed_date TIMESTAMP WITH TIME ZONE,
    failure_reason VARCHAR(500),
    failure_code VARCHAR(50),
    retry_date TIMESTAMP WITH TIME ZONE,
    cost DECIMAL(8, 4) DEFAULT 0.0000,
    delivery_time_ms INTEGER,
    provider_response JSONB,
    recipient_response JSONB,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_delivery_request FOREIGN KEY (request_id)
        REFERENCES communication_hub.notification_requests(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_delivery_channel CHECK (channel IN (
        'EMAIL', 'SMS', 'PUSH', 'IN_APP', 'WEBHOOK'
    )),
    CONSTRAINT chk_delivery_status CHECK (status IN (
        'PENDING', 'SENT', 'DELIVERED', 'FAILED', 'BOUNCED', 'REJECTED'
    )),
    CONSTRAINT chk_delivery_provider CHECK (provider IN (
        'SENDGRID', 'TWILIO', 'FIREBASE', 'WEBHOOK', 'INTERNAL'
    )),
    CONSTRAINT chk_attempt_number CHECK (attempt_number > 0),
    CONSTRAINT chk_delivery_times CHECK (
        (sent_date IS NULL) OR
        (delivered_date IS NULL OR delivered_date >= sent_date) AND
        (failed_date IS NULL OR failed_date >= sent_date)
    ),
    CONSTRAINT chk_cost_positive CHECK (cost >= 0),
    CONSTRAINT chk_delivery_time CHECK (delivery_time_ms IS NULL OR delivery_time_ms >= 0)
);

-- Recipient Preferences table (Entity)
CREATE TABLE communication_hub.recipient_preferences (
    id BIGSERIAL PRIMARY KEY,
    preference_id VARCHAR(50) UNIQUE NOT NULL,
    recipient_id VARCHAR(100) NOT NULL,
    recipient_type VARCHAR(50) NOT NULL,
    preferred_channels JSONB NOT NULL DEFAULT '[]',
    blocked_channels JSONB NOT NULL DEFAULT '[]',
    quiet_hours_start TIME,
    quiet_hours_end TIME,
    quiet_hours_timezone VARCHAR(50) DEFAULT 'America/Lima',
    language_code VARCHAR(10) DEFAULT 'es',
    frequency_limit INTEGER DEFAULT 10,
    frequency_period VARCHAR(20) DEFAULT 'DAILY',
    emergency_override BOOLEAN DEFAULT TRUE,
    marketing_consent BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT chk_pref_recipient_type CHECK (recipient_type IN (
        'CITIZEN', 'MUNICIPAL_ADMINISTRATOR', 'DRIVER', 'COMMUNITY_LEADER', 'SYSTEM_ADMIN'
    )),
    CONSTRAINT chk_language_code CHECK (language_code IN ('es', 'en', 'qu')),
    CONSTRAINT chk_frequency_limit CHECK (frequency_limit > 0),
    CONSTRAINT chk_frequency_period CHECK (frequency_period IN (
        'HOURLY', 'DAILY', 'WEEKLY', 'MONTHLY'
    )),
    CONSTRAINT chk_quiet_hours CHECK (
        (quiet_hours_start IS NULL AND quiet_hours_end IS NULL) OR
        (quiet_hours_start IS NOT NULL AND quiet_hours_end IS NOT NULL)
    ),
    CONSTRAINT uk_recipient_preferences UNIQUE (recipient_id, recipient_type)
);

-- Delivery Attempts table (Entity)
CREATE TABLE communication_hub.delivery_attempts (
    id BIGSERIAL PRIMARY KEY,
    attempt_id VARCHAR(50) UNIQUE NOT NULL,
    request_id BIGINT NOT NULL,
    record_id BIGINT,
    channel VARCHAR(20) NOT NULL,
    attempt_number INTEGER NOT NULL,
    attempt_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL,
    provider_response JSONB,
    error_code VARCHAR(50),
    error_message VARCHAR(500),
    response_time_ms INTEGER,
    retry_recommended BOOLEAN DEFAULT FALSE,
    next_retry_date TIMESTAMP WITH TIME ZONE,
    cost DECIMAL(8, 4) DEFAULT 0.0000,

    -- Foreign Keys
    CONSTRAINT fk_attempts_request FOREIGN KEY (request_id)
        REFERENCES communication_hub.notification_requests(id) ON DELETE CASCADE,
    CONSTRAINT fk_attempts_record FOREIGN KEY (record_id)
        REFERENCES communication_hub.delivery_records(id) ON DELETE SET NULL,

    -- Constraints
    CONSTRAINT chk_attempt_channel CHECK (channel IN (
        'EMAIL', 'SMS', 'PUSH', 'IN_APP', 'WEBHOOK'
    )),
    CONSTRAINT chk_attempt_status CHECK (status IN (
        'INITIATED', 'SENT', 'DELIVERED', 'FAILED', 'TIMEOUT', 'REJECTED'
    )),
    CONSTRAINT chk_attempt_number_positive CHECK (attempt_number > 0),
    CONSTRAINT chk_response_time_positive CHECK (response_time_ms IS NULL OR response_time_ms >= 0),
    CONSTRAINT chk_attempt_cost CHECK (cost >= 0),
    CONSTRAINT uk_attempt_unique UNIQUE (request_id, channel, attempt_number)
);

-- ========================================
-- AUDIT AND EVENTS TABLES
-- ========================================

-- Communication Events table (Domain Events)
CREATE TABLE communication_hub.communication_events (
    id BIGSERIAL PRIMARY KEY,
    event_type VARCHAR(100) NOT NULL,
    request_id BIGINT,
    template_id VARCHAR(50),
    recipient_id VARCHAR(100),
    event_data JSONB NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    processed BOOLEAN DEFAULT FALSE,
    processing_attempts INTEGER DEFAULT 0,

    -- Foreign Keys
    CONSTRAINT fk_events_request FOREIGN KEY (request_id)
        REFERENCES communication_hub.notification_requests(id) ON DELETE SET NULL,

    -- Constraints
    CONSTRAINT chk_event_type_communication CHECK (event_type IN (
        'NOTIFICATION_REQUEST_CREATED',
        'NOTIFICATION_DELIVERED',
        'NOTIFICATION_FAILED',
        'TEMPLATE_UPDATED',
        'DELIVERY_CONFIRMED',
        'CHANNEL_FALLBACK_TRIGGERED',
        'RECIPIENT_PREFERENCES_UPDATED'
    ))
);

-- Channel Performance table (Analytics)
CREATE TABLE communication_hub.channel_performance (
    id BIGSERIAL PRIMARY KEY,
    channel VARCHAR(20) NOT NULL,
    provider VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    total_sent INTEGER DEFAULT 0,
    total_delivered INTEGER DEFAULT 0,
    total_failed INTEGER DEFAULT 0,
    total_bounced INTEGER DEFAULT 0,
    total_cost DECIMAL(10, 4) DEFAULT 0.0000,
    avg_delivery_time_ms INTEGER,
    success_rate DECIMAL(5, 4),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT chk_perf_channel CHECK (channel IN (
        'EMAIL', 'SMS', 'PUSH', 'IN_APP', 'WEBHOOK'
    )),
    CONSTRAINT chk_perf_provider CHECK (provider IN (
        'SENDGRID', 'TWILIO', 'FIREBASE', 'WEBHOOK', 'INTERNAL'
    )),
    CONSTRAINT chk_perf_metrics CHECK (
        total_sent >= 0 AND total_delivered >= 0 AND
        total_failed >= 0 AND total_bounced >= 0 AND
        total_cost >= 0
    ),
    CONSTRAINT chk_success_rate CHECK (success_rate IS NULL OR (success_rate >= 0 AND success_rate <= 1)),
    CONSTRAINT uk_channel_performance UNIQUE (channel, provider, date)
);

-- ========================================
-- INDEXES FOR PERFORMANCE
-- ========================================

-- Notification requests indexes
CREATE INDEX idx_notification_requests_recipient ON communication_hub.notification_requests (recipient_id, recipient_type);
CREATE INDEX idx_notification_requests_status ON communication_hub.notification_requests (status);
CREATE INDEX idx_notification_requests_source ON communication_hub.notification_requests (source_context);
CREATE INDEX idx_notification_requests_type ON communication_hub.notification_requests (message_type);
CREATE INDEX idx_notification_requests_priority ON communication_hub.notification_requests (priority DESC);
CREATE INDEX idx_notification_requests_scheduled ON communication_hub.notification_requests (scheduled_date);
CREATE INDEX idx_notification_requests_expiry ON communication_hub.notification_requests (expiry_date)
    WHERE expiry_date IS NOT NULL;
CREATE INDEX idx_notification_requests_pending ON communication_hub.notification_requests (status, created_at)
    WHERE status IN ('PENDING', 'PROCESSING');

-- Message templates indexes
CREATE INDEX idx_templates_type ON communication_hub.message_templates (message_type);
CREATE INDEX idx_templates_category ON communication_hub.message_templates (category);
CREATE INDEX idx_templates_active ON communication_hub.message_templates (is_active);
CREATE INDEX idx_templates_default ON communication_hub.message_templates (message_type, is_default)
    WHERE is_default = TRUE;
CREATE INDEX idx_templates_usage ON communication_hub.message_templates (usage_count DESC);

-- Delivery records indexes
CREATE INDEX idx_delivery_records_request ON communication_hub.delivery_records (request_id);
CREATE INDEX idx_delivery_records_channel ON communication_hub.delivery_records (channel);
CREATE INDEX idx_delivery_records_status ON communication_hub.delivery_records (status);
CREATE INDEX idx_delivery_records_provider ON communication_hub.delivery_records (provider);
CREATE INDEX idx_delivery_records_sent_date ON communication_hub.delivery_records (sent_date DESC);
CREATE INDEX idx_delivery_records_retry ON communication_hub.delivery_records (retry_date)
    WHERE retry_date IS NOT NULL;

-- Recipient preferences indexes
CREATE INDEX idx_recipient_preferences_recipient ON communication_hub.recipient_preferences (recipient_id, recipient_type);
CREATE INDEX idx_recipient_preferences_active ON communication_hub.recipient_preferences (is_active);

-- Delivery attempts indexes
CREATE INDEX idx_delivery_attempts_request ON communication_hub.delivery_attempts (request_id);
CREATE INDEX idx_delivery_attempts_channel ON communication_hub.delivery_attempts (channel);
CREATE INDEX idx_delivery_attempts_status ON communication_hub.delivery_attempts (status);
CREATE INDEX idx_delivery_attempts_date ON communication_hub.delivery_attempts (attempt_date DESC);

-- Communication events indexes
CREATE INDEX idx_communication_events_type ON communication_hub.communication_events (event_type);
CREATE INDEX idx_communication_events_timestamp ON communication_hub.communication_events (timestamp DESC);
CREATE INDEX idx_communication_events_processed ON communication_hub.communication_events (processed);

-- Channel performance indexes
CREATE INDEX idx_channel_performance_date ON communication_hub.channel_performance (date DESC);
CREATE INDEX idx_channel_performance_channel ON communication_hub.channel_performance (channel);
CREATE INDEX idx_channel_performance_provider ON communication_hub.channel_performance (provider);

-- ========================================
-- TRIGGERS AND FUNCTIONS
-- ========================================

-- Function to update timestamps
CREATE OR REPLACE FUNCTION communication_hub.update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to increment version for optimistic locking
CREATE OR REPLACE FUNCTION communication_hub.increment_version()
RETURNS TRIGGER AS $$
BEGIN
    NEW.version = OLD.version + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to update template usage statistics
CREATE OR REPLACE FUNCTION communication_hub.update_template_usage()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.template_id IS NOT NULL THEN
        UPDATE communication_hub.message_templates
        SET usage_count = usage_count + 1,
            last_used_date = CURRENT_TIMESTAMP
        WHERE template_id = NEW.template_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to update notification request status based on delivery records
CREATE OR REPLACE FUNCTION communication_hub.update_notification_status()
RETURNS TRIGGER AS $$
DECLARE
    total_records INTEGER;
    delivered_records INTEGER;
    failed_records INTEGER;
    new_status VARCHAR(30);
BEGIN
    -- Count delivery records for this notification
    SELECT
        COUNT(*),
        COUNT(CASE WHEN status = 'DELIVERED' THEN 1 END),
        COUNT(CASE WHEN status = 'FAILED' THEN 1 END)
    INTO total_records, delivered_records, failed_records
    FROM communication_hub.delivery_records
    WHERE request_id = COALESCE(NEW.request_id, OLD.request_id);

    -- Determine new status
    IF delivered_records > 0 AND failed_records = 0 THEN
        new_status := 'DELIVERED';
    ELSIF delivered_records > 0 AND failed_records > 0 THEN
        new_status := 'PARTIALLY_DELIVERED';
    ELSIF failed_records = total_records AND total_records > 0 THEN
        new_status := 'FAILED';
    ELSE
        new_status := 'PROCESSING';
    END IF;

    -- Update notification request status
    UPDATE communication_hub.notification_requests
    SET status = new_status,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = COALESCE(NEW.request_id, OLD.request_id);

    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Function to calculate delivery time
CREATE OR REPLACE FUNCTION communication_hub.calculate_delivery_time()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.delivered_date IS NOT NULL AND NEW.sent_date IS NOT NULL THEN
        NEW.delivery_time_ms := EXTRACT(EPOCH FROM (NEW.delivered_date - NEW.sent_date)) * 1000;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply triggers
CREATE TRIGGER trg_notification_requests_update_timestamp
    BEFORE UPDATE ON communication_hub.notification_requests
    FOR EACH ROW
    EXECUTE FUNCTION communication_hub.update_timestamp();

CREATE TRIGGER trg_notification_requests_increment_version
    BEFORE UPDATE ON communication_hub.notification_requests
    FOR EACH ROW
    EXECUTE FUNCTION communication_hub.increment_version();

CREATE TRIGGER trg_templates_update_timestamp
    BEFORE UPDATE ON communication_hub.message_templates
    FOR EACH ROW
    EXECUTE FUNCTION communication_hub.update_timestamp();

CREATE TRIGGER trg_templates_increment_version
    BEFORE UPDATE ON communication_hub.message_templates
    FOR EACH ROW
    EXECUTE FUNCTION communication_hub.increment_version();

CREATE TRIGGER trg_preferences_update_timestamp
    BEFORE UPDATE ON communication_hub.recipient_preferences
    FOR EACH ROW
    EXECUTE FUNCTION communication_hub.update_timestamp();

CREATE TRIGGER trg_notification_template_usage
    AFTER INSERT ON communication_hub.notification_requests
    FOR EACH ROW
    EXECUTE FUNCTION communication_hub.update_template_usage();

CREATE TRIGGER trg_delivery_status_update
    AFTER INSERT OR UPDATE OR DELETE ON communication_hub.delivery_records
    FOR EACH ROW
    EXECUTE FUNCTION communication_hub.update_notification_status();

CREATE TRIGGER trg_delivery_time_calculation
    BEFORE INSERT OR UPDATE ON communication_hub.delivery_records
    FOR EACH ROW
    EXECUTE FUNCTION communication_hub.calculate_delivery_time();

-- Function to clean expired notifications
CREATE OR REPLACE FUNCTION communication_hub.clean_expired_notifications()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    UPDATE communication_hub.notification_requests
    SET status = 'EXPIRED'
    WHERE expiry_date IS NOT NULL
    AND expiry_date < CURRENT_TIMESTAMP
    AND status IN ('PENDING', 'PROCESSING');

    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Function to generate channel performance analytics
CREATE OR REPLACE FUNCTION communication_hub.generate_channel_analytics(p_date DATE)
RETURNS VOID AS $$
BEGIN
    INSERT INTO communication_hub.channel_performance (
        channel, provider, date, total_sent, total_delivered,
        total_failed, total_bounced, total_cost, avg_delivery_time_ms, success_rate
    )
    SELECT
        dr.channel,
        dr.provider,
        p_date,
        COUNT(*) as total_sent,
        COUNT(CASE WHEN dr.status = 'DELIVERED' THEN 1 END) as total_delivered,
        COUNT(CASE WHEN dr.status = 'FAILED' THEN 1 END) as total_failed,
        COUNT(CASE WHEN dr.status = 'BOUNCED' THEN 1 END) as total_bounced,
        SUM(dr.cost) as total_cost,
        AVG(dr.delivery_time_ms)::INTEGER as avg_delivery_time_ms,
        CASE
            WHEN COUNT(*) > 0 THEN
                COUNT(CASE WHEN dr.status = 'DELIVERED' THEN 1 END)::DECIMAL / COUNT(*)
            ELSE NULL
        END as success_rate
    FROM communication_hub.delivery_records dr
    WHERE DATE(dr.sent_date) = p_date
    GROUP BY dr.channel, dr.provider
    ON CONFLICT (channel, provider, date)
    DO UPDATE SET
        total_sent = EXCLUDED.total_sent,
        total_delivered = EXCLUDED.total_delivered,
        total_failed = EXCLUDED.total_failed,
        total_bounced = EXCLUDED.total_bounced,
        total_cost = EXCLUDED.total_cost,
        avg_delivery_time_ms = EXCLUDED.avg_delivery_time_ms,
        success_rate = EXCLUDED.success_rate,
        created_at = CURRENT_TIMESTAMP;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- VIEWS FOR COMMON QUERIES
-- ========================================

-- View for notification overview
CREATE VIEW communication_hub.vw_notification_overview AS
SELECT
    nr.id,
    nr.request_id,
    nr.source_context,
    nr.recipient_id,
    nr.recipient_type,
    nr.message_type,
    nr.priority,
    nr.status,
    nr.scheduled_date,
    nr.created_at,
    COUNT(dr.id) as total_delivery_attempts,
    COUNT(CASE WHEN dr.status = 'DELIVERED' THEN 1 END) as successful_deliveries,
    COUNT(CASE WHEN dr.status = 'FAILED' THEN 1 END) as failed_deliveries,
    SUM(dr.cost) as total_cost,
    MIN(dr.sent_date) as first_sent_date,
    MAX(dr.delivered_date) as last_delivered_date
FROM communication_hub.notification_requests nr
LEFT JOIN communication_hub.delivery_records dr ON nr.id = dr.request_id
GROUP BY nr.id, nr.request_id, nr.source_context, nr.recipient_id,
         nr.recipient_type, nr.message_type, nr.priority, nr.status,
         nr.scheduled_date, nr.created_at;

-- View for delivery analytics
CREATE VIEW communication_hub.vw_delivery_analytics AS
SELECT
    DATE_TRUNC('day', dr.sent_date) as delivery_date,
    dr.channel,
    dr.provider,
    COUNT(*) as total_attempts,
    COUNT(CASE WHEN dr.status = 'DELIVERED' THEN 1 END) as successful_deliveries,
    COUNT(CASE WHEN dr.status = 'FAILED' THEN 1 END) as failed_deliveries,
    ROUND(COUNT(CASE WHEN dr.status = 'DELIVERED' THEN 1 END) * 100.0 / COUNT(*), 2) as success_rate,
    SUM(dr.cost) as total_cost,
    AVG(dr.delivery_time_ms) as avg_delivery_time_ms
FROM communication_hub.delivery_records dr
WHERE dr.sent_date IS NOT NULL
GROUP BY DATE_TRUNC('day', dr.sent_date), dr.channel, dr.provider
ORDER BY delivery_date DESC;

-- Comments for documentation
COMMENT ON SCHEMA communication_hub IS 'Communication Hub Bounded Context - Multi-channel notification delivery and template management';
COMMENT ON TABLE communication_hub.notification_requests IS 'Main aggregate root for notification requests with multi-channel delivery';
COMMENT ON TABLE communication_hub.message_templates IS 'Template management aggregate root with localization and versioning';
COMMENT ON TABLE communication_hub.delivery_records IS 'Delivery tracking aggregate root with provider integration';
COMMENT ON TABLE communication_hub.recipient_preferences IS 'User preferences for notification channels and timing';

-- Grant permissions (adjust as needed for your environment)
-- GRANT USAGE ON SCHEMA communication_hub TO wastetrack_app;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA communication_hub TO wastetrack_app;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA communication_hub TO wastetrack_app;