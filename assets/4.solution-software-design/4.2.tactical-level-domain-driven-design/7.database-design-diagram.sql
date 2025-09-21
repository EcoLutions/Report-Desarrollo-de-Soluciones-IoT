-- ========================================
-- Profile BC Database Schema
-- PostgreSQL Database Script
-- ========================================

-- Create schema for Profile BC
CREATE SCHEMA IF NOT EXISTS profile;

-- ========================================
-- MAIN TABLES
-- ========================================

-- User Profiles table (Aggregate Root)
CREATE TABLE profile.user_profiles (
    id BIGSERIAL PRIMARY KEY,
    profile_id VARCHAR(50) UNIQUE NOT NULL,
    user_id VARCHAR(50) UNIQUE NOT NULL,
    user_type VARCHAR(30) NOT NULL,

    -- Personal Information
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    document_type VARCHAR(20) NOT NULL,
    document_number VARCHAR(20) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(10),

    -- Contact Information
    primary_email VARCHAR(200) NOT NULL,
    secondary_email VARCHAR(200),
    primary_phone VARCHAR(20),
    secondary_phone VARCHAR(20),
    emergency_contact_name VARCHAR(200),
    emergency_contact_phone VARCHAR(20),

    -- Address Information
    street VARCHAR(200),
    street_number VARCHAR(20),
    district VARCHAR(100),
    city VARCHAR(100) NOT NULL DEFAULT 'Lima',
    region VARCHAR(100) NOT NULL DEFAULT 'Lima',
    postal_code VARCHAR(10),
    address_reference VARCHAR(500),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),

    -- Service Area and Eligibility
    service_area_id VARCHAR(50),
    municipality_id VARCHAR(50),
    is_service_area_eligible BOOLEAN DEFAULT FALSE,
    eligibility_verified_date TIMESTAMP WITH TIME ZONE,

    -- Profile Status and Metadata
    profile_status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    profile_completeness_percentage DECIMAL(5, 2) DEFAULT 0.00,
    missing_required_fields JSONB DEFAULT '[]',
    account_settings JSONB,
    privacy_settings JSONB,

    -- Activity Tracking
    last_login_date TIMESTAMP WITH TIME ZONE,
    last_profile_update TIMESTAMP WITH TIME ZONE,
    login_count INTEGER DEFAULT 0,

    -- Audit Fields
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version BIGINT DEFAULT 0,

    -- Constraints
    CONSTRAINT chk_user_type CHECK (user_type IN (
        'CITIZEN', 'MUNICIPAL_ADMINISTRATOR', 'DRIVER', 'COMMUNITY_LEADER', 'SYSTEM_ADMIN'
    )),
    CONSTRAINT chk_document_type CHECK (document_type IN (
        'DNI', 'PASSPORT', 'CARNET_EXTRANJERIA', 'RUC'
    )),
    CONSTRAINT chk_gender CHECK (gender IN ('M', 'F', 'OTHER', 'PREFER_NOT_TO_SAY')),
    CONSTRAINT chk_profile_status CHECK (profile_status IN (
        'ACTIVE', 'INACTIVE', 'SUSPENDED', 'PENDING_VERIFICATION', 'DEACTIVATED'
    )),
    CONSTRAINT chk_completeness_percentage CHECK (
        profile_completeness_percentage >= 0 AND profile_completeness_percentage <= 100
    ),
    CONSTRAINT chk_coordinates CHECK (
        (latitude IS NULL AND longitude IS NULL) OR
        (latitude IS NOT NULL AND longitude IS NOT NULL AND
         latitude BETWEEN -90 AND 90 AND longitude BETWEEN -180 AND 180)
    ),
    CONSTRAINT chk_email_format CHECK (
        primary_email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    ),
    CONSTRAINT uk_user_profiles_document UNIQUE (document_type, document_number),
    CONSTRAINT uk_user_profiles_email UNIQUE (primary_email)
);

-- User Preferences table (Aggregate Root)
CREATE TABLE profile.user_preferences (
    id BIGSERIAL PRIMARY KEY,
    preferences_id VARCHAR(50) UNIQUE NOT NULL,
    profile_id BIGINT NOT NULL,

    -- Notification Settings
    email_notifications_enabled BOOLEAN DEFAULT TRUE,
    sms_notifications_enabled BOOLEAN DEFAULT TRUE,
    push_notifications_enabled BOOLEAN DEFAULT TRUE,
    in_app_notifications_enabled BOOLEAN DEFAULT TRUE,

    -- Communication Preferences
    preferred_communication_channels JSONB DEFAULT '["EMAIL", "PUSH"]',
    notification_frequency VARCHAR(20) DEFAULT 'NORMAL',
    quiet_hours_start TIME,
    quiet_hours_end TIME,
    quiet_hours_timezone VARCHAR(50) DEFAULT 'America/Lima',

    -- Language and Localization
    language_preference VARCHAR(10) DEFAULT 'es',
    timezone_preference VARCHAR(50) DEFAULT 'America/Lima',
    date_format VARCHAR(20) DEFAULT 'DD/MM/YYYY',
    number_format VARCHAR(20) DEFAULT 'LATIN',

    -- Privacy and Data Settings
    profile_visibility VARCHAR(20) DEFAULT 'PRIVATE',
    data_sharing_level VARCHAR(20) DEFAULT 'MINIMAL',
    analytics_tracking_enabled BOOLEAN DEFAULT TRUE,
    marketing_communications_enabled BOOLEAN DEFAULT FALSE,
    third_party_sharing_enabled BOOLEAN DEFAULT FALSE,

    -- Accessibility Settings
    accessibility_features JSONB DEFAULT '{}',
    font_size VARCHAR(10) DEFAULT 'MEDIUM',
    high_contrast_mode BOOLEAN DEFAULT FALSE,
    screen_reader_support BOOLEAN DEFAULT FALSE,

    -- Data Retention
    data_retention_period_months INTEGER DEFAULT 24,
    auto_delete_enabled BOOLEAN DEFAULT FALSE,

    -- Marketing Consent
    marketing_consent_granted BOOLEAN DEFAULT FALSE,
    marketing_consent_date TIMESTAMP WITH TIME ZONE,
    marketing_consent_source VARCHAR(100),

    -- Audit Fields
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version BIGINT DEFAULT 0,

    -- Foreign Keys
    CONSTRAINT fk_preferences_profile FOREIGN KEY (profile_id)
        REFERENCES profile.user_profiles(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_notification_frequency CHECK (notification_frequency IN (
        'IMMEDIATE', 'NORMAL', 'DIGEST_DAILY', 'DIGEST_WEEKLY', 'MINIMAL'
    )),
    CONSTRAINT chk_language_preference CHECK (language_preference IN ('es', 'en', 'qu')),
    CONSTRAINT chk_profile_visibility CHECK (profile_visibility IN (
        'PUBLIC', 'PRIVATE', 'FRIENDS_ONLY', 'MUNICIPALITY_ONLY'
    )),
    CONSTRAINT chk_data_sharing_level CHECK (data_sharing_level IN (
        'MINIMAL', 'STANDARD', 'ENHANCED', 'FULL'
    )),
    CONSTRAINT chk_font_size CHECK (font_size IN ('SMALL', 'MEDIUM', 'LARGE', 'EXTRA_LARGE')),
    CONSTRAINT chk_data_retention CHECK (
        data_retention_period_months >= 12 AND data_retention_period_months <= 120
    ),
    CONSTRAINT chk_quiet_hours CHECK (
        (quiet_hours_start IS NULL AND quiet_hours_end IS NULL) OR
        (quiet_hours_start IS NOT NULL AND quiet_hours_end IS NOT NULL)
    )
);

-- Personalization Settings table (Aggregate Root)
CREATE TABLE profile.personalization_settings (
    id BIGSERIAL PRIMARY KEY,
    settings_id VARCHAR(50) UNIQUE NOT NULL,
    profile_id BIGINT NOT NULL,

    -- Dashboard Layout
    dashboard_layout VARCHAR(20) DEFAULT 'GRID',
    sidebar_collapsed BOOLEAN DEFAULT FALSE,
    theme_preference VARCHAR(20) DEFAULT 'LIGHT',
    color_scheme VARCHAR(30) DEFAULT 'DEFAULT',

    -- Widget Configurations
    enabled_widgets JSONB DEFAULT '[]',
    widget_positions JSONB DEFAULT '{}',
    widget_sizes JSONB DEFAULT '{}',
    widget_refresh_intervals JSONB DEFAULT '{}',

    -- Shortcuts and Quick Actions
    dashboard_shortcuts JSONB DEFAULT '[]',
    quick_actions JSONB DEFAULT '[]',
    bookmarked_pages JSONB DEFAULT '[]',

    -- View Preferences
    default_view VARCHAR(30) DEFAULT 'DASHBOARD',
    table_page_size INTEGER DEFAULT 20,
    show_tooltips BOOLEAN DEFAULT TRUE,
    show_animations BOOLEAN DEFAULT TRUE,
    compact_view BOOLEAN DEFAULT FALSE,

    -- Reporting Preferences
    default_report_format VARCHAR(20) DEFAULT 'PDF',
    include_charts_in_reports BOOLEAN DEFAULT TRUE,
    report_date_range VARCHAR(20) DEFAULT 'LAST_30_DAYS',

    -- Custom Fields and Labels
    custom_field_configurations JSONB DEFAULT '{}',
    custom_labels JSONB DEFAULT '{}',

    -- Mobile-specific Settings
    mobile_layout_preference VARCHAR(20) DEFAULT 'STANDARD',
    mobile_gestures_enabled BOOLEAN DEFAULT TRUE,
    mobile_push_badge_count BOOLEAN DEFAULT TRUE,

    -- Audit Fields
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version BIGINT DEFAULT 0,

    -- Foreign Keys
    CONSTRAINT fk_personalization_profile FOREIGN KEY (profile_id)
        REFERENCES profile.user_profiles(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_dashboard_layout CHECK (dashboard_layout IN (
        'GRID', 'LIST', 'CARDS', 'COMPACT', 'CUSTOM'
    )),
    CONSTRAINT chk_theme_preference CHECK (theme_preference IN (
        'LIGHT', 'DARK', 'AUTO', 'HIGH_CONTRAST'
    )),
    CONSTRAINT chk_default_view CHECK (default_view IN (
        'DASHBOARD', 'MAP', 'REPORTS', 'NOTIFICATIONS', 'PROFILE'
    )),
    CONSTRAINT chk_table_page_size CHECK (
        table_page_size BETWEEN 10 AND 100
    ),
    CONSTRAINT chk_report_format CHECK (default_report_format IN (
        'PDF', 'EXCEL', 'CSV', 'JSON'
    )),
    CONSTRAINT chk_mobile_layout CHECK (mobile_layout_preference IN (
        'STANDARD', 'COMPACT', 'TABLET'
    ))
);

-- Contact Methods table (Entity)
CREATE TABLE profile.contact_methods (
    id BIGSERIAL PRIMARY KEY,
    method_id VARCHAR(50) UNIQUE NOT NULL,
    profile_id BIGINT NOT NULL,
    contact_type VARCHAR(20) NOT NULL,
    contact_value VARCHAR(200) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    is_verified BOOLEAN DEFAULT FALSE,
    verification_code VARCHAR(10),
    verification_attempts INTEGER DEFAULT 0,
    verification_date TIMESTAMP WITH TIME ZONE,
    last_used_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_contact_methods_profile FOREIGN KEY (profile_id)
        REFERENCES profile.user_profiles(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_contact_type CHECK (contact_type IN (
        'EMAIL', 'PHONE', 'MOBILE', 'WHATSAPP', 'TELEGRAM'
    )),
    CONSTRAINT chk_verification_attempts CHECK (verification_attempts >= 0),
    CONSTRAINT uk_contact_methods_primary UNIQUE (profile_id, contact_type, is_primary)
        DEFERRABLE INITIALLY DEFERRED
);

-- Address History table (Entity)
CREATE TABLE profile.address_history (
    id BIGSERIAL PRIMARY KEY,
    history_id VARCHAR(50) UNIQUE NOT NULL,
    profile_id BIGINT NOT NULL,

    -- Address Information
    street VARCHAR(200),
    street_number VARCHAR(20),
    district VARCHAR(100),
    city VARCHAR(100),
    region VARCHAR(100),
    postal_code VARCHAR(10),
    address_reference VARCHAR(500),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),

    -- Validity Period
    valid_from TIMESTAMP WITH TIME ZONE NOT NULL,
    valid_to TIMESTAMP WITH TIME ZONE,
    is_current BOOLEAN DEFAULT FALSE,

    -- Change Information
    change_reason VARCHAR(100),
    change_requested_by VARCHAR(100),
    verification_status VARCHAR(20) DEFAULT 'PENDING',

    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_address_history_profile FOREIGN KEY (profile_id)
        REFERENCES profile.user_profiles(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_address_validity CHECK (
        valid_to IS NULL OR valid_to > valid_from
    ),
    CONSTRAINT chk_verification_status CHECK (verification_status IN (
        'PENDING', 'VERIFIED', 'REJECTED', 'EXPIRED'
    )),
    CONSTRAINT uk_address_history_current UNIQUE (profile_id, is_current)
        WHERE is_current = TRUE
);

-- ========================================
-- AUDIT AND EVENTS TABLES
-- ========================================

-- Profile Events table (Domain Events)
CREATE TABLE profile.profile_events (
    id BIGSERIAL PRIMARY KEY,
    event_type VARCHAR(100) NOT NULL,
    profile_id BIGINT,
    user_id VARCHAR(50),
    event_data JSONB NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    processed BOOLEAN DEFAULT FALSE,
    processing_attempts INTEGER DEFAULT 0,

    -- Foreign Keys
    CONSTRAINT fk_events_profile FOREIGN KEY (profile_id)
        REFERENCES profile.user_profiles(id) ON DELETE SET NULL,

    -- Constraints
    CONSTRAINT chk_event_type_profile CHECK (event_type IN (
        'PROFILE_CREATED',
        'PROFILE_UPDATED',
        'PREFERENCES_CHANGED',
        'SERVICE_AREA_ELIGIBILITY_CHANGED',
        'PROFILE_DEACTIVATED',
        'LOGIN_RECORDED',
        'ADDRESS_CHANGED',
        'PRIVACY_SETTINGS_UPDATED'
    ))
);

-- Profile Activity Log table
CREATE TABLE profile.profile_activity_log (
    id BIGSERIAL PRIMARY KEY,
    profile_id BIGINT NOT NULL,
    activity_type VARCHAR(50) NOT NULL,
    activity_description VARCHAR(500),
    ip_address INET,
    user_agent VARCHAR(500),
    session_id VARCHAR(100),
    metadata JSONB,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_activity_log_profile FOREIGN KEY (profile_id)
        REFERENCES profile.user_profiles(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_activity_type CHECK (activity_type IN (
        'LOGIN', 'LOGOUT', 'PROFILE_UPDATE', 'PREFERENCES_UPDATE',
        'ADDRESS_CHANGE', 'CONTACT_UPDATE', 'PRIVACY_CHANGE',
        'PASSWORD_CHANGE', 'ACCOUNT_DEACTIVATION'
    ))
);

-- ========================================
-- INDEXES FOR PERFORMANCE
-- ========================================

-- User profiles indexes
CREATE INDEX idx_user_profiles_user_id ON profile.user_profiles (user_id);
CREATE INDEX idx_user_profiles_user_type ON profile.user_profiles (user_type);
CREATE INDEX idx_user_profiles_status ON profile.user_profiles (profile_status);
CREATE INDEX idx_user_profiles_service_area ON profile.user_profiles (service_area_id);
CREATE INDEX idx_user_profiles_municipality ON profile.user_profiles (municipality_id);
CREATE INDEX idx_user_profiles_district ON profile.user_profiles (district);
CREATE INDEX idx_user_profiles_eligibility ON profile.user_profiles (is_service_area_eligible);
CREATE INDEX idx_user_profiles_document ON profile.user_profiles (document_type, document_number);
CREATE INDEX idx_user_profiles_email ON profile.user_profiles (primary_email);
CREATE INDEX idx_user_profiles_location ON profile.user_profiles USING GIST (
    ll_to_earth(latitude, longitude)
) WHERE latitude IS NOT NULL AND longitude IS NOT NULL;
CREATE INDEX idx_user_profiles_created ON profile.user_profiles (created_at DESC);
CREATE INDEX idx_user_profiles_last_login ON profile.user_profiles (last_login_date DESC)
    WHERE last_login_date IS NOT NULL;

-- User preferences indexes
CREATE INDEX idx_user_preferences_profile ON profile.user_preferences (profile_id);
CREATE INDEX idx_user_preferences_language ON profile.user_preferences (language_preference);
CREATE INDEX idx_user_preferences_notifications ON profile.user_preferences (
    email_notifications_enabled, sms_notifications_enabled, push_notifications_enabled
);
CREATE INDEX idx_user_preferences_marketing ON profile.user_preferences (marketing_communications_enabled);

-- Personalization settings indexes
CREATE INDEX idx_personalization_profile ON profile.personalization_settings (profile_id);
CREATE INDEX idx_personalization_theme ON profile.personalization_settings (theme_preference);

-- Contact methods indexes
CREATE INDEX idx_contact_methods_profile ON profile.contact_methods (profile_id);
CREATE INDEX idx_contact_methods_type ON profile.contact_methods (contact_type);
CREATE INDEX idx_contact_methods_primary ON profile.contact_methods (profile_id, is_primary)
    WHERE is_primary = TRUE;
CREATE INDEX idx_contact_methods_verified ON profile.contact_methods (is_verified);

-- Address history indexes
CREATE INDEX idx_address_history_profile ON profile.address_history (profile_id);
CREATE INDEX idx_address_history_current ON profile.address_history (profile_id, is_current)
    WHERE is_current = TRUE;
CREATE INDEX idx_address_history_validity ON profile.address_history (valid_from, valid_to);

-- Profile events indexes
CREATE INDEX idx_profile_events_type ON profile.profile_events (event_type);
CREATE INDEX idx_profile_events_timestamp ON profile.profile_events (timestamp DESC);
CREATE INDEX idx_profile_events_processed ON profile.profile_events (processed);

-- Activity log indexes
CREATE INDEX idx_activity_log_profile ON profile.profile_activity_log (profile_id);
CREATE INDEX idx_activity_log_type ON profile.profile_activity_log (activity_type);
CREATE INDEX idx_activity_log_timestamp ON profile.profile_activity_log (timestamp DESC);

-- ========================================
-- TRIGGERS AND FUNCTIONS
-- ========================================

-- Function to update timestamps
CREATE OR REPLACE FUNCTION profile.update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to increment version for optimistic locking
CREATE OR REPLACE FUNCTION profile.increment_version()
RETURNS TRIGGER AS $$
BEGIN
    NEW.version = OLD.version + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate profile completeness
CREATE OR REPLACE FUNCTION profile.calculate_profile_completeness()
RETURNS TRIGGER AS $$
DECLARE
    total_fields INTEGER := 0;
    completed_fields INTEGER := 0;
    missing_fields TEXT[] := ARRAY[]::TEXT[];
    completeness_percentage DECIMAL(5,2);
BEGIN
    -- Count total required fields based on user type
    total_fields := CASE
        WHEN NEW.user_type = 'CITIZEN' THEN 12
        WHEN NEW.user_type = 'MUNICIPAL_ADMINISTRATOR' THEN 14
        WHEN NEW.user_type = 'DRIVER' THEN 15
        ELSE 10
    END;

    -- Count completed fields
    IF NEW.first_name IS NOT NULL AND LENGTH(TRIM(NEW.first_name)) > 0 THEN
        completed_fields := completed_fields + 1;
    ELSE
        missing_fields := array_append(missing_fields, 'first_name');
    END IF;

    IF NEW.last_name IS NOT NULL AND LENGTH(TRIM(NEW.last_name)) > 0 THEN
        completed_fields := completed_fields + 1;
    ELSE
        missing_fields := array_append(missing_fields, 'last_name');
    END IF;

    IF NEW.document_number IS NOT NULL AND LENGTH(TRIM(NEW.document_number)) > 0 THEN
        completed_fields := completed_fields + 1;
    ELSE
        missing_fields := array_append(missing_fields, 'document_number');
    END IF;

    IF NEW.primary_email IS NOT NULL AND LENGTH(TRIM(NEW.primary_email)) > 0 THEN
        completed_fields := completed_fields + 1;
    ELSE
        missing_fields := array_append(missing_fields, 'primary_email');
    END IF;

    IF NEW.primary_phone IS NOT NULL AND LENGTH(TRIM(NEW.primary_phone)) > 0 THEN
        completed_fields := completed_fields + 1;
    ELSE
        missing_fields := array_append(missing_fields, 'primary_phone');
    END IF;

    IF NEW.street IS NOT NULL AND LENGTH(TRIM(NEW.street)) > 0 THEN
        completed_fields := completed_fields + 1;
    ELSE
        missing_fields := array_append(missing_fields, 'street');
    END IF;

    IF NEW.district IS NOT NULL AND LENGTH(TRIM(NEW.district)) > 0 THEN
        completed_fields := completed_fields + 1;
    ELSE
        missing_fields := array_append(missing_fields, 'district');
    END IF;

    -- Additional fields for specific user types
    IF NEW.user_type IN ('MUNICIPAL_ADMINISTRATOR', 'DRIVER') THEN
        IF NEW.municipality_id IS NOT NULL THEN
            completed_fields := completed_fields + 1;
        ELSE
            missing_fields := array_append(missing_fields, 'municipality_id');
        END IF;
    END IF;

    -- Calculate percentage
    completeness_percentage := (completed_fields::DECIMAL / total_fields::DECIMAL) * 100;

    -- Update fields
    NEW.profile_completeness_percentage := completeness_percentage;
    NEW.missing_required_fields := to_jsonb(missing_fields);
    NEW.last_profile_update := CURRENT_TIMESTAMP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to update service area eligibility
CREATE OR REPLACE FUNCTION profile.update_service_area_eligibility()
RETURNS TRIGGER AS $$
BEGIN
    -- Simple eligibility check based on district
    -- In production, this would integrate with a more sophisticated service area service
    IF NEW.district IS NOT NULL AND NEW.city = 'Lima' THEN
        NEW.is_service_area_eligible := TRUE;
        NEW.eligibility_verified_date := CURRENT_TIMESTAMP;
    ELSE
        NEW.is_service_area_eligible := FALSE;
        NEW.eligibility_verified_date := NULL;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to log profile activity
CREATE OR REPLACE FUNCTION profile.log_profile_activity()
RETURNS TRIGGER AS $$
DECLARE
    activity_desc TEXT;
    changed_fields TEXT[] := ARRAY[]::TEXT[];
BEGIN
    -- Determine activity type and description
    IF TG_OP = 'INSERT' THEN
        activity_desc := 'Profile created';
        INSERT INTO profile.profile_activity_log (profile_id, activity_type, activity_description)
        VALUES (NEW.id, 'PROFILE_CREATE', activity_desc);
    ELSIF TG_OP = 'UPDATE' THEN
        -- Track changed fields
        IF OLD.first_name IS DISTINCT FROM NEW.first_name THEN
            changed_fields := array_append(changed_fields, 'first_name');
        END IF;
        IF OLD.last_name IS DISTINCT FROM NEW.last_name THEN
            changed_fields := array_append(changed_fields, 'last_name');
        END IF;
        IF OLD.primary_email IS DISTINCT FROM NEW.primary_email THEN
            changed_fields := array_append(changed_fields, 'primary_email');
        END IF;

        IF array_length(changed_fields, 1) > 0 THEN
            activity_desc := 'Profile updated: ' || array_to_string(changed_fields, ', ');
            INSERT INTO profile.profile_activity_log (
                profile_id, activity_type, activity_description, metadata
            )
            VALUES (
                NEW.id, 'PROFILE_UPDATE', activity_desc,
                jsonb_build_object('changed_fields', changed_fields)
            );
        END IF;
    END IF;

    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Apply triggers
CREATE TRIGGER trg_user_profiles_update_timestamp
    BEFORE UPDATE ON profile.user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION profile.update_timestamp();

CREATE TRIGGER trg_user_profiles_increment_version
    BEFORE UPDATE ON profile.user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION profile.increment_version();

CREATE TRIGGER trg_user_profiles_completeness
    BEFORE INSERT OR UPDATE ON profile.user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION profile.calculate_profile_completeness();

CREATE TRIGGER trg_user_profiles_eligibility
    BEFORE INSERT OR UPDATE ON profile.user_profiles
    FOR EACH ROW
    WHEN (NEW.street IS DISTINCT FROM OLD.street OR NEW.district IS DISTINCT FROM OLD.district OR OLD IS NULL)
    EXECUTE FUNCTION profile.update_service_area_eligibility();

CREATE TRIGGER trg_user_profiles_activity_log
    AFTER INSERT OR UPDATE ON profile.user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION profile.log_profile_activity();

CREATE TRIGGER trg_user_preferences_update_timestamp
    BEFORE UPDATE ON profile.user_preferences
    FOR EACH ROW
    EXECUTE FUNCTION profile.update_timestamp();

CREATE TRIGGER trg_user_preferences_increment_version
    BEFORE UPDATE ON profile.user_preferences
    FOR EACH ROW
    EXECUTE FUNCTION profile.increment_version();

CREATE TRIGGER trg_personalization_settings_update_timestamp
    BEFORE UPDATE ON profile.personalization_settings
    FOR EACH ROW
    EXECUTE FUNCTION profile.update_timestamp();

-- Function to anonymize sensitive data (GDPR compliance)
CREATE OR REPLACE FUNCTION profile.anonymize_profile_data(p_profile_id BIGINT)
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE profile.user_profiles
    SET
        first_name = 'ANONYMIZED',
        last_name = 'USER',
        document_number = 'ANONYMIZED',
        primary_email = 'anonymized_' || p_profile_id || '@example.com',
        secondary_email = NULL,
        primary_phone = NULL,
        secondary_phone = NULL,
        emergency_contact_name = NULL,
        emergency_contact_phone = NULL,
        street = NULL,
        street_number = NULL,
        address_reference = NULL,
        latitude = NULL,
        longitude = NULL,
        profile_status = 'DEACTIVATED',
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_profile_id;

    -- Also anonymize activity logs
    UPDATE profile.profile_activity_log
    SET
        ip_address = NULL,
        user_agent = NULL,
        session_id = NULL
    WHERE profile_id = p_profile_id;

    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- Function to clean expired data
CREATE OR REPLACE FUNCTION profile.clean_expired_data()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER := 0;
BEGIN
    -- Clean old activity logs (keep last 2 years)
    DELETE FROM profile.profile_activity_log
    WHERE timestamp < CURRENT_TIMESTAMP - INTERVAL '2 years';

    GET DIAGNOSTICS deleted_count = ROW_COUNT;

    -- Clean expired verification codes
    UPDATE profile.contact_methods
    SET verification_code = NULL
    WHERE verification_code IS NOT NULL
    AND created_at < CURRENT_TIMESTAMP - INTERVAL '24 hours';

    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- VIEWS FOR COMMON QUERIES
-- ========================================

-- View for profile overview
CREATE VIEW profile.vw_profile_overview AS
SELECT
    up.id,
    up.profile_id,
    up.user_id,
    up.user_type,
    up.first_name || ' ' || up.last_name as full_name,
    up.primary_email,
    up.primary_phone,
    up.district,
    up.city,
    up.profile_status,
    up.profile_completeness_percentage,
    up.is_service_area_eligible,
    up.last_login_date,
    up.created_at,
    upr.language_preference,
    upr.timezone_preference,
    upr.email_notifications_enabled,
    ps.theme_preference,
    ps.dashboard_layout
FROM profile.user_profiles up
LEFT JOIN profile.user_preferences upr ON up.id = upr.profile_id
LEFT JOIN profile.personalization_settings ps ON up.id = ps.profile_id;

-- View for active users by area
CREATE VIEW profile.vw_users_by_service_area AS
SELECT
    service_area_id,
    district,
    user_type,
    COUNT(*) as user_count,
    COUNT(CASE WHEN profile_status = 'ACTIVE' THEN 1 END) as active_users,
    COUNT(CASE WHEN is_service_area_eligible = TRUE THEN 1 END) as eligible_users,
    AVG(profile_completeness_percentage) as avg_completeness
FROM profile.user_profiles
WHERE profile_status != 'DEACTIVATED'
GROUP BY service_area_id, district, user_type
ORDER BY user_count DESC;

-- Comments for documentation
COMMENT ON SCHEMA profile IS 'Profile Bounded Context - User profile management, preferences, and personalization';
COMMENT ON TABLE profile.user_profiles IS 'Main aggregate root for user profiles with completeness tracking';
COMMENT ON TABLE profile.user_preferences IS 'User preferences aggregate root for notifications and privacy';
COMMENT ON TABLE profile.personalization_settings IS 'UI personalization aggregate root with dashboard configuration';
COMMENT ON TABLE profile.contact_methods IS 'Contact method entity with verification tracking';

-- Grant permissions (adjust as needed for your environment)
-- GRANT USAGE ON SCHEMA profile TO wastetrack_app;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA profile TO wastetrack_app;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA profile TO wastetrack_app;