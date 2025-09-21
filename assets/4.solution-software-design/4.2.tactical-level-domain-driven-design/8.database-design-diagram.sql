-- ========================================
-- IAM BC Database Schema
-- PostgreSQL Database Script
-- ========================================

-- Create schema for IAM BC
CREATE SCHEMA IF NOT EXISTS iam;

-- ========================================
-- MAIN TABLES
-- ========================================

-- Users table (Aggregate Root)
CREATE TABLE iam.users (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING_VERIFICATION',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP WITH TIME ZONE,
    failed_login_attempts INTEGER DEFAULT 0,
    locked_until TIMESTAMP WITH TIME ZONE,
    version BIGINT DEFAULT 0,

    -- Constraints
    CONSTRAINT chk_user_status CHECK (status IN (
        'PENDING_VERIFICATION', 'ACTIVE', 'SUSPENDED', 'DEACTIVATED'
    )),
    CONSTRAINT chk_email_format CHECK (
        email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    )
);

-- Roles table (Aggregate Root)
CREATE TABLE iam.roles (
    id BIGSERIAL PRIMARY KEY,
    role_id UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version BIGINT DEFAULT 0
);

-- Permissions table (Entity)
CREATE TABLE iam.permissions (
    id BIGSERIAL PRIMARY KEY,
    permission_id UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

-- ========================================
-- JOIN TABLES (Many-to-Many)
-- ========================================

-- User Roles join table
CREATE TABLE iam.user_roles (
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id)
        REFERENCES iam.users(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id)
        REFERENCES iam.roles(id) ON DELETE CASCADE,

    -- Constraints
    PRIMARY KEY (user_id, role_id)
);

-- Role Permissions join table
CREATE TABLE iam.role_permissions (
    role_id BIGINT NOT NULL,
    permission_id BIGINT NOT NULL,

    -- Foreign Keys
    CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id)
        REFERENCES iam.roles(id) ON DELETE CASCADE,
    CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id)
        REFERENCES iam.permissions(id) ON DELETE CASCADE,

    -- Constraints
    PRIMARY KEY (role_id, permission_id)
);

-- ========================================
-- AUXILIARY TABLES
-- ========================================

-- Authentication Tokens table (for refresh tokens, password resets, etc.)
CREATE TABLE iam.auth_tokens (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    token_hash VARCHAR(255) UNIQUE NOT NULL,
    token_type VARCHAR(30) NOT NULL,
    expiry_date TIMESTAMP WITH TIME ZONE NOT NULL,
    is_revoked BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_auth_tokens_user FOREIGN KEY (user_id)
        REFERENCES iam.users(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_token_type CHECK (token_type IN (
        'REFRESH_TOKEN', 'PASSWORD_RESET', 'EMAIL_VERIFICATION'
    ))
);

-- IAM Events table (Domain Events)
CREATE TABLE iam.iam_events (
    id BIGSERIAL PRIMARY KEY,
    event_type VARCHAR(100) NOT NULL,
    user_id BIGINT,
    event_data JSONB NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    processed BOOLEAN DEFAULT FALSE,
    processing_attempts INTEGER DEFAULT 0,

    -- Foreign Keys
    CONSTRAINT fk_events_user FOREIGN KEY (user_id)
        REFERENCES iam.users(id) ON DELETE SET NULL,

    -- Constraints
    CONSTRAINT chk_event_type_iam CHECK (event_type IN (
        'USER_REGISTERED',
        'USER_ACTIVATED',
        'USER_DEACTIVATED',
        'PASSWORD_RESET_REQUESTED',
        'PASSWORD_CHANGED',
        'ROLE_ASSIGNED'
    ))
);

-- ========================================
-- INDEXES FOR PERFORMANCE
-- ========================================

-- Users indexes
CREATE INDEX idx_users_email ON iam.users (email);
CREATE INDEX idx_users_status ON iam.users (status);
CREATE INDEX idx_users_username ON iam.users (username);

-- Roles indexes
CREATE INDEX idx_roles_name ON iam.roles (name);

-- Permissions indexes
CREATE INDEX idx_permissions_name ON iam.permissions (name);

-- Auth tokens indexes
CREATE INDEX idx_auth_tokens_user ON iam.auth_tokens (user_id);
CREATE INDEX idx_auth_tokens_expiry ON iam.auth_tokens (expiry_date);
CREATE INDEX idx_auth_tokens_type ON iam.auth_tokens (token_type);

-- IAM events indexes
CREATE INDEX idx_iam_events_type ON iam.iam_events (event_type);
CREATE INDEX idx_iam_events_timestamp ON iam.iam_events (timestamp DESC);
CREATE INDEX idx_iam_events_processed ON iam.iam_events (processed);

-- ========================================
-- TRIGGERS AND FUNCTIONS
-- ========================================

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION iam.update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to increment version for optimistic locking
CREATE OR REPLACE FUNCTION iam.increment_version()
RETURNS TRIGGER AS $$
BEGIN
    NEW.version = OLD.version + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply triggers for main tables
CREATE TRIGGER trg_users_update_timestamp
    BEFORE UPDATE ON iam.users
    FOR EACH ROW
    EXECUTE FUNCTION iam.update_timestamp();

CREATE TRIGGER trg_users_increment_version
    BEFORE UPDATE ON iam.users
    FOR EACH ROW
    EXECUTE FUNCTION iam.increment_version();

CREATE TRIGGER trg_roles_update_timestamp
    BEFORE UPDATE ON iam.roles
    FOR EACH ROW
    EXECUTE FUNCTION iam.update_timestamp();

CREATE TRIGGER trg_roles_increment_version
    BEFORE UPDATE ON iam.roles
    FOR EACH ROW
    EXECUTE FUNCTION iam.increment_version();

-- ========================================
-- INITIAL DATA (Roles and Permissions)
-- ========================================

-- Function to insert roles and permissions idempotently
CREATE OR REPLACE FUNCTION iam.seed_roles_and_permissions()
RETURNS VOID AS $$
DECLARE
    -- Role IDs
    citizen_role_id BIGINT;
    driver_role_id BIGINT;
    admin_role_id BIGINT;
    support_role_id BIGINT;

    -- Permission IDs
    view_containers_perm_id BIGINT;
    report_issues_perm_id BIGINT;
    view_routes_perm_id BIGINT;
    update_route_status_perm_id BIGINT;
    manage_districts_perm_id BIGINT;
    manage_users_perm_id BIGINT;
    view_analytics_perm_id BIGINT;
    manage_support_tickets_perm_id BIGINT;

BEGIN
    -- Insert Permissions
    INSERT INTO iam.permissions (name, description) VALUES ('VIEW_CONTAINERS', 'Allows viewing container status on map') ON CONFLICT (name) DO NOTHING;
    INSERT INTO iam.permissions (name, description) VALUES ('REPORT_ISSUES', 'Allows a citizen to report a container issue') ON CONFLICT (name) DO NOTHING;
    INSERT INTO iam.permissions (name, description) VALUES ('VIEW_ROUTES', 'Allows viewing assigned collection routes') ON CONFLICT (name) DO NOTHING;
    INSERT INTO iam.permissions (name, description) VALUES ('UPDATE_ROUTE_STATUS', 'Allows a driver to update their route progress') ON CONFLICT (name) DO NOTHING;
    INSERT INTO iam.permissions (name, description) VALUES ('MANAGE_DISTRICTS', 'Allows managing all aspects of a municipal district') ON CONFLICT (name) DO NOTHING;
    INSERT INTO iam.permissions (name, description) VALUES ('MANAGE_USERS', 'Allows creating and managing drivers and other users') ON CONFLICT (name) DO NOTHING;
    INSERT INTO iam.permissions (name, description) VALUES ('VIEW_ANALYTICS', 'Allows viewing system-wide analytics dashboards') ON CONFLICT (name) DO NOTHING;
    INSERT INTO iam.permissions (name, description) VALUES ('MANAGE_SUPPORT_TICKETS', 'Allows EcoLutions support to manage customer issues') ON CONFLICT (name) DO NOTHING;

    -- Get Permission IDs
    SELECT id INTO view_containers_perm_id FROM iam.permissions WHERE name = 'VIEW_CONTAINERS';
    SELECT id INTO report_issues_perm_id FROM iam.permissions WHERE name = 'REPORT_ISSUES';
    SELECT id INTO view_routes_perm_id FROM iam.permissions WHERE name = 'VIEW_ROUTES';
    SELECT id INTO update_route_status_perm_id FROM iam.permissions WHERE name = 'UPDATE_ROUTE_STATUS';
    SELECT id INTO manage_districts_perm_id FROM iam.permissions WHERE name = 'MANAGE_DISTRICTS';
    SELECT id INTO manage_users_perm_id FROM iam.permissions WHERE name = 'MANAGE_USERS';
    SELECT id INTO view_analytics_perm_id FROM iam.permissions WHERE name = 'VIEW_ANALYTICS';
    SELECT id INTO manage_support_tickets_perm_id FROM iam.permissions WHERE name = 'MANAGE_SUPPORT_TICKETS';

    -- Insert Roles
    INSERT INTO iam.roles (name, description, is_default) VALUES ('CITIZEN', 'Default role for all registered citizens', TRUE) ON CONFLICT (name) DO NOTHING;
    INSERT INTO iam.roles (name, description) VALUES ('DRIVER', 'Role for collection vehicle drivers') ON CONFLICT (name) DO NOTHING;
    INSERT INTO iam.roles (name, description) VALUES ('MUNICIPAL_ADMINISTRATOR', 'Role for municipal administrators managing a district') ON CONFLICT (name) DO NOTHING;
    INSERT INTO iam.roles (name, description) VALUES ('ECOLUTIONS_SUPPORT', 'Role for EcoLutions support staff') ON CONFLICT (name) DO NOTHING;

    -- Get Role IDs
    SELECT id INTO citizen_role_id FROM iam.roles WHERE name = 'CITIZEN';
    SELECT id INTO driver_role_id FROM iam.roles WHERE name = 'DRIVER';
    SELECT id INTO admin_role_id FROM iam.roles WHERE name = 'MUNICIPAL_ADMINISTRATOR';
    SELECT id INTO support_role_id FROM iam.roles WHERE name = 'ECOLUTIONS_SUPPORT';

    -- Assign Permissions to Roles
    -- Citizen Role
    INSERT INTO iam.role_permissions (role_id, permission_id) VALUES (citizen_role_id, view_containers_perm_id) ON CONFLICT DO NOTHING;
    INSERT INTO iam.role_permissions (role_id, permission_id) VALUES (citizen_role_id, report_issues_perm_id) ON CONFLICT DO NOTHING;

    -- Driver Role
    INSERT INTO iam.role_permissions (role_id, permission_id) VALUES (driver_role_id, view_routes_perm_id) ON CONFLICT DO NOTHING;
    INSERT INTO iam.role_permissions (role_id, permission_id) VALUES (driver_role_id, update_route_status_perm_id) ON CONFLICT DO NOTHING;

    -- Administrator Role
    INSERT INTO iam.role_permissions (role_id, permission_id) VALUES (admin_role_id, manage_districts_perm_id) ON CONFLICT DO NOTHING;
    INSERT INTO iam.role_permissions (role_id, permission_id) VALUES (admin_role_id, manage_users_perm_id) ON CONFLICT DO NOTHING;
    INSERT INTO iam.role_permissions (role_id, permission_id) VALUES (admin_role_id, view_analytics_perm_id) ON CONFLICT DO NOTHING;

    -- Support Role
    INSERT INTO iam.role_permissions (role_id, permission_id) VALUES (support_role_id, manage_support_tickets_perm_id) ON CONFLICT DO NOTHING;
    INSERT INTO iam.role_permissions (role_id, permission_id) VALUES (support_role_id, view_analytics_perm_id) ON CONFLICT DO NOTHING;

END;
$$ LANGUAGE plpgsql;

-- Execute the seeding function
SELECT iam.seed_roles_and_permissions();


-- ========================================
-- COMMENTS
-- ========================================
COMMENT ON SCHEMA iam IS 'IAM Bounded Context - User identity, authentication, and authorization management';
COMMENT ON TABLE iam.users IS 'Main aggregate root for user identity and credentials';
COMMENT ON TABLE iam.roles IS 'Aggregate root for managing user roles and their associated permissions';
COMMENT ON TABLE iam.auth_tokens IS 'Stores temporary tokens for processes like password reset and email verification';