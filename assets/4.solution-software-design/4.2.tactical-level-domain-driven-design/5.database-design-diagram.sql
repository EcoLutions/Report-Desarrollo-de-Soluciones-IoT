-- ========================================
-- Payment & Subscriptions BC Database Schema
-- PostgreSQL Database Script
-- ========================================

-- Create schema for Payment & Subscriptions BC
CREATE SCHEMA IF NOT EXISTS payment_subscriptions;

-- ========================================
-- MAIN TABLES
-- ========================================

-- Subscriptions table (Aggregate Root)
CREATE TABLE payment_subscriptions.subscriptions (
    id BIGSERIAL PRIMARY KEY,
    subscription_id VARCHAR(50) UNIQUE NOT NULL,
    municipality_id VARCHAR(50) NOT NULL,
    plan_id VARCHAR(50) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'TRIAL',
    start_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    end_date TIMESTAMP WITH TIME ZONE,
    trial_start_date TIMESTAMP WITH TIME ZONE,
    trial_end_date TIMESTAMP WITH TIME ZONE,
    next_billing_date TIMESTAMP WITH TIME ZONE,
    billing_cycle VARCHAR(20) NOT NULL DEFAULT 'MONTHLY',
    billing_cycle_interval INTEGER NOT NULL DEFAULT 1,
    auto_renewal BOOLEAN DEFAULT TRUE,
    grace_period_end_date TIMESTAMP WITH TIME ZONE,
    cancellation_date TIMESTAMP WITH TIME ZONE,
    cancellation_reason VARCHAR(500),
    suspension_date TIMESTAMP WITH TIME ZONE,
    suspension_reason VARCHAR(500),
    plan_price DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(3) NOT NULL DEFAULT 'PEN',
    tax_rate DECIMAL(5, 4) DEFAULT 0.18,
    discount_percentage DECIMAL(5, 2) DEFAULT 0.00,
    payment_method_id BIGINT,
    billing_address JSONB,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version BIGINT DEFAULT 0,

    -- Constraints
    CONSTRAINT chk_subscription_status CHECK (status IN (
        'TRIAL', 'ACTIVE', 'SUSPENDED', 'CANCELLED', 'EXPIRED', 'PAST_DUE'
    )),
    CONSTRAINT chk_billing_cycle CHECK (billing_cycle IN ('MONTHLY', 'QUARTERLY', 'ANNUALLY')),
    CONSTRAINT chk_billing_interval CHECK (billing_cycle_interval > 0 AND billing_cycle_interval <= 12),
    CONSTRAINT chk_plan_price CHECK (plan_price >= 0),
    CONSTRAINT chk_tax_rate CHECK (tax_rate >= 0 AND tax_rate <= 1),
    CONSTRAINT chk_discount CHECK (discount_percentage >= 0 AND discount_percentage <= 100),
    CONSTRAINT chk_currency CHECK (currency IN ('PEN', 'USD')),
    CONSTRAINT chk_trial_dates CHECK (
        (trial_start_date IS NULL AND trial_end_date IS NULL) OR
        (trial_start_date IS NOT NULL AND trial_end_date IS NOT NULL AND trial_end_date > trial_start_date)
    ),
    CONSTRAINT chk_subscription_dates CHECK (
        end_date IS NULL OR end_date > start_date
    )
);

-- Payment Methods table (Entity)
CREATE TABLE payment_subscriptions.payment_methods (
    id BIGSERIAL PRIMARY KEY,
    payment_method_id VARCHAR(50) UNIQUE NOT NULL,
    municipality_id VARCHAR(50) NOT NULL,
    type VARCHAR(30) NOT NULL,
    provider VARCHAR(50) NOT NULL DEFAULT 'CULQI',
    card_last_four VARCHAR(4),
    card_brand VARCHAR(20),
    card_expiry_month INTEGER,
    card_expiry_year INTEGER,
    bank_name VARCHAR(100),
    account_number_last_four VARCHAR(4),
    account_type VARCHAR(20),
    digital_wallet_provider VARCHAR(50),
    digital_wallet_email VARCHAR(200),
    cardholder_name VARCHAR(200),
    billing_address JSONB,
    is_default BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    verification_status VARCHAR(20) DEFAULT 'PENDING',
    verification_date TIMESTAMP WITH TIME ZONE,
    last_used_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT chk_payment_method_type CHECK (type IN (
        'CREDIT_CARD', 'DEBIT_CARD', 'BANK_TRANSFER', 'DIGITAL_WALLET'
    )),
    CONSTRAINT chk_verification_status CHECK (verification_status IN (
        'PENDING', 'VERIFIED', 'FAILED', 'EXPIRED'
    )),
    CONSTRAINT chk_card_expiry CHECK (
        (type NOT IN ('CREDIT_CARD', 'DEBIT_CARD')) OR
        (card_expiry_month BETWEEN 1 AND 12 AND card_expiry_year >= EXTRACT(YEAR FROM CURRENT_DATE))
    ),
    CONSTRAINT chk_card_fields CHECK (
        (type NOT IN ('CREDIT_CARD', 'DEBIT_CARD')) OR
        (card_last_four IS NOT NULL AND card_brand IS NOT NULL)
    ),
    CONSTRAINT chk_bank_fields CHECK (
        (type != 'BANK_TRANSFER') OR
        (bank_name IS NOT NULL AND account_number_last_four IS NOT NULL)
    )
);

-- Payments table (Aggregate Root)
CREATE TABLE payment_subscriptions.payments (
    id BIGSERIAL PRIMARY KEY,
    payment_id VARCHAR(50) UNIQUE NOT NULL,
    subscription_id BIGINT NOT NULL,
    invoice_id BIGINT,
    amount DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(3) NOT NULL DEFAULT 'PEN',
    payment_method_id BIGINT NOT NULL,
    payment_type VARCHAR(30) NOT NULL DEFAULT 'SUBSCRIPTION',
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    gateway_transaction_id VARCHAR(100),
    gateway_reference VARCHAR(100),
    gateway_response JSONB,
    attempt_number INTEGER DEFAULT 1,
    max_attempts INTEGER DEFAULT 3,
    scheduled_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    processed_date TIMESTAMP WITH TIME ZONE,
    confirmed_date TIMESTAMP WITH TIME ZONE,
    failure_reason VARCHAR(500),
    failure_code VARCHAR(50),
    retry_date TIMESTAMP WITH TIME ZONE,
    refund_amount DECIMAL(12, 2) DEFAULT 0.00,
    refund_date TIMESTAMP WITH TIME ZONE,
    refund_reason VARCHAR(500),
    processing_fee DECIMAL(8, 2) DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version BIGINT DEFAULT 0,

    -- Foreign Keys
    CONSTRAINT fk_payments_subscription FOREIGN KEY (subscription_id)
        REFERENCES payment_subscriptions.subscriptions(id) ON DELETE CASCADE,
    CONSTRAINT fk_payments_method FOREIGN KEY (payment_method_id)
        REFERENCES payment_subscriptions.payment_methods(id) ON DELETE RESTRICT,

    -- Constraints
    CONSTRAINT chk_payment_status CHECK (status IN (
        'PENDING', 'PROCESSING', 'SUCCESSFUL', 'FAILED', 'CANCELLED', 'REFUNDED', 'PARTIALLY_REFUNDED'
    )),
    CONSTRAINT chk_payment_type CHECK (payment_type IN (
        'SUBSCRIPTION', 'SETUP_FEE', 'UPGRADE', 'DOWNGRADE', 'PENALTY', 'REFUND'
    )),
    CONSTRAINT chk_amount_positive CHECK (amount > 0),
    CONSTRAINT chk_refund_amount CHECK (refund_amount >= 0 AND refund_amount <= amount),
    CONSTRAINT chk_attempt_number CHECK (attempt_number > 0 AND attempt_number <= max_attempts),
    CONSTRAINT chk_processing_fee CHECK (processing_fee >= 0),
    CONSTRAINT chk_payment_dates CHECK (
        (processed_date IS NULL) OR
        (processed_date >= scheduled_date)
    )
);

-- Invoices table (Aggregate Root)
CREATE TABLE payment_subscriptions.invoices (
    id BIGSERIAL PRIMARY KEY,
    invoice_id VARCHAR(50) UNIQUE NOT NULL,
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    subscription_id BIGINT NOT NULL,
    billing_period_start DATE NOT NULL,
    billing_period_end DATE NOT NULL,
    issue_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    due_date TIMESTAMP WITH TIME ZONE NOT NULL,
    paid_date TIMESTAMP WITH TIME ZONE,
    status VARCHAR(30) NOT NULL DEFAULT 'DRAFT',
    currency VARCHAR(3) NOT NULL DEFAULT 'PEN',
    subtotal DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    tax_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    amount_paid DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    amount_due DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    payment_terms VARCHAR(100) DEFAULT 'Net 30',
    notes TEXT,
    billing_address JSONB,
    tax_details JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version BIGINT DEFAULT 0,

    -- Foreign Keys
    CONSTRAINT fk_invoices_subscription FOREIGN KEY (subscription_id)
        REFERENCES payment_subscriptions.subscriptions(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_invoice_status CHECK (status IN (
        'DRAFT', 'PENDING', 'SENT', 'PAID', 'OVERDUE', 'CANCELLED', 'REFUNDED'
    )),
    CONSTRAINT chk_invoice_amounts CHECK (
        subtotal >= 0 AND tax_amount >= 0 AND discount_amount >= 0 AND
        total_amount >= 0 AND amount_paid >= 0 AND amount_due >= 0 AND
        total_amount = subtotal + tax_amount - discount_amount AND
        amount_due = total_amount - amount_paid
    ),
    CONSTRAINT chk_billing_period CHECK (billing_period_end > billing_period_start),
    CONSTRAINT chk_invoice_dates CHECK (due_date >= issue_date)
);

-- Invoice Line Items table (Entity)
CREATE TABLE payment_subscriptions.invoice_line_items (
    id BIGSERIAL PRIMARY KEY,
    line_item_id VARCHAR(50) UNIQUE NOT NULL,
    invoice_id BIGINT NOT NULL,
    description VARCHAR(500) NOT NULL,
    service_period_start DATE,
    service_period_end DATE,
    quantity INTEGER NOT NULL DEFAULT 1,
    unit_price DECIMAL(12, 2) NOT NULL,
    total_price DECIMAL(12, 2) NOT NULL,
    tax_rate DECIMAL(5, 4) NOT NULL DEFAULT 0.18,
    tax_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    discount_percentage DECIMAL(5, 2) DEFAULT 0.00,
    discount_amount DECIMAL(12, 2) DEFAULT 0.00,
    item_type VARCHAR(30) NOT NULL DEFAULT 'SUBSCRIPTION',
    metadata JSONB,

    -- Foreign Keys
    CONSTRAINT fk_line_items_invoice FOREIGN KEY (invoice_id)
        REFERENCES payment_subscriptions.invoices(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_line_item_type CHECK (item_type IN (
        'SUBSCRIPTION', 'SETUP_FEE', 'USAGE_CHARGE', 'DISCOUNT', 'TAX'
    )),
    CONSTRAINT chk_line_quantities CHECK (quantity > 0),
    CONSTRAINT chk_line_prices CHECK (unit_price >= 0 AND total_price >= 0),
    CONSTRAINT chk_line_tax CHECK (tax_rate >= 0 AND tax_rate <= 1 AND tax_amount >= 0),
    CONSTRAINT chk_line_discount CHECK (
        discount_percentage >= 0 AND discount_percentage <= 100 AND
        discount_amount >= 0
    ),
    CONSTRAINT chk_line_calculations CHECK (
        total_price = (quantity * unit_price) - discount_amount
    )
);

-- Payment Attempts table (Entity)
CREATE TABLE payment_subscriptions.payment_attempts (
    id BIGSERIAL PRIMARY KEY,
    attempt_id VARCHAR(50) UNIQUE NOT NULL,
    payment_id BIGINT NOT NULL,
    attempt_number INTEGER NOT NULL,
    attempt_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL,
    gateway_transaction_id VARCHAR(100),
    gateway_response JSONB,
    response_time_ms INTEGER,
    error_code VARCHAR(50),
    error_message VARCHAR(500),
    retry_recommended BOOLEAN DEFAULT FALSE,
    next_retry_date TIMESTAMP WITH TIME ZONE,

    -- Foreign Keys
    CONSTRAINT fk_attempts_payment FOREIGN KEY (payment_id)
        REFERENCES payment_subscriptions.payments(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_attempt_status CHECK (status IN (
        'INITIATED', 'PROCESSING', 'SUCCESSFUL', 'FAILED', 'TIMEOUT', 'CANCELLED'
    )),
    CONSTRAINT chk_attempt_number_positive CHECK (attempt_number > 0),
    CONSTRAINT chk_response_time CHECK (response_time_ms >= 0),
    CONSTRAINT uk_payment_attempt UNIQUE (payment_id, attempt_number)
);

-- ========================================
-- AUDIT AND EVENTS TABLES
-- ========================================

-- Payment Events table (Domain Events)
CREATE TABLE payment_subscriptions.payment_events (
    id BIGSERIAL PRIMARY KEY,
    event_type VARCHAR(100) NOT NULL,
    subscription_id BIGINT,
    payment_id BIGINT,
    invoice_id BIGINT,
    event_data JSONB NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    processed BOOLEAN DEFAULT FALSE,
    processing_attempts INTEGER DEFAULT 0,

    -- Foreign Keys
    CONSTRAINT fk_events_subscription FOREIGN KEY (subscription_id)
        REFERENCES payment_subscriptions.subscriptions(id) ON DELETE SET NULL,
    CONSTRAINT fk_events_payment FOREIGN KEY (payment_id)
        REFERENCES payment_subscriptions.payments(id) ON DELETE SET NULL,
    CONSTRAINT fk_events_invoice FOREIGN KEY (invoice_id)
        REFERENCES payment_subscriptions.invoices(id) ON DELETE SET NULL,

    -- Constraints
    CONSTRAINT chk_event_type_payment CHECK (event_type IN (
        'SUBSCRIPTION_CREATED',
        'SUBSCRIPTION_ACTIVATED',
        'SUBSCRIPTION_SUSPENDED',
        'SUBSCRIPTION_CANCELLED',
        'PAYMENT_PROCESSED',
        'PAYMENT_FAILED',
        'PAYMENT_REFUNDED',
        'INVOICE_GENERATED',
        'INVOICE_PAID',
        'INVOICE_OVERDUE'
    ))
);

-- Subscription Usage Tracking table
CREATE TABLE payment_subscriptions.subscription_usage (
    id BIGSERIAL PRIMARY KEY,
    subscription_id BIGINT NOT NULL,
    usage_date DATE NOT NULL,
    metric_name VARCHAR(100) NOT NULL,
    metric_value DECIMAL(15, 4) NOT NULL,
    unit VARCHAR(50) NOT NULL,
    billable_units DECIMAL(15, 4) DEFAULT 0,
    unit_price DECIMAL(12, 6) DEFAULT 0,
    total_charge DECIMAL(12, 2) DEFAULT 0,
    included_in_plan BOOLEAN DEFAULT TRUE,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_usage_subscription FOREIGN KEY (subscription_id)
        REFERENCES payment_subscriptions.subscriptions(id) ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT chk_usage_values CHECK (
        metric_value >= 0 AND billable_units >= 0 AND
        unit_price >= 0 AND total_charge >= 0
    ),
    CONSTRAINT uk_subscription_usage UNIQUE (subscription_id, usage_date, metric_name)
);

-- ========================================
-- INDEXES FOR PERFORMANCE
-- ========================================

-- Subscriptions indexes
CREATE INDEX idx_subscriptions_municipality ON payment_subscriptions.subscriptions (municipality_id);
CREATE INDEX idx_subscriptions_status ON payment_subscriptions.subscriptions (status);
CREATE INDEX idx_subscriptions_billing_date ON payment_subscriptions.subscriptions (next_billing_date);
CREATE INDEX idx_subscriptions_trial_end ON payment_subscriptions.subscriptions (trial_end_date)
    WHERE trial_end_date IS NOT NULL;
CREATE INDEX idx_subscriptions_grace_period ON payment_subscriptions.subscriptions (grace_period_end_date)
    WHERE grace_period_end_date IS NOT NULL;
CREATE INDEX idx_subscriptions_plan ON payment_subscriptions.subscriptions (plan_id);

-- Payment methods indexes
CREATE INDEX idx_payment_methods_municipality ON payment_subscriptions.payment_methods (municipality_id);
CREATE INDEX idx_payment_methods_type ON payment_subscriptions.payment_methods (type);
CREATE INDEX idx_payment_methods_default ON payment_subscriptions.payment_methods (municipality_id, is_default)
    WHERE is_default = TRUE;
CREATE INDEX idx_payment_methods_active ON payment_subscriptions.payment_methods (is_active);

-- Payments indexes
CREATE INDEX idx_payments_subscription ON payment_subscriptions.payments (subscription_id);
CREATE INDEX idx_payments_status ON payment_subscriptions.payments (status);
CREATE INDEX idx_payments_method ON payment_subscriptions.payments (payment_method_id);
CREATE INDEX idx_payments_scheduled_date ON payment_subscriptions.payments (scheduled_date);
CREATE INDEX idx_payments_gateway_transaction ON payment_subscriptions.payments (gateway_transaction_id);
CREATE INDEX idx_payments_failed_retry ON payment_subscriptions.payments (retry_date)
    WHERE status = 'FAILED' AND retry_date IS NOT NULL;

-- Invoices indexes
CREATE INDEX idx_invoices_subscription ON payment_subscriptions.invoices (subscription_id);
CREATE INDEX idx_invoices_status ON payment_subscriptions.invoices (status);
CREATE INDEX idx_invoices_due_date ON payment_subscriptions.invoices (due_date);
CREATE INDEX idx_invoices_issue_date ON payment_subscriptions.invoices (issue_date DESC);
CREATE INDEX idx_invoices_billing_period ON payment_subscriptions.invoices (billing_period_start, billing_period_end);
CREATE INDEX idx_invoices_overdue ON payment_subscriptions.invoices (due_date, status)
    WHERE status IN ('PENDING', 'SENT', 'OVERDUE');

-- Payment events indexes
CREATE INDEX idx_payment_events_type ON payment_subscriptions.payment_events (event_type);
CREATE INDEX idx_payment_events_timestamp ON payment_subscriptions.payment_events (timestamp DESC);
CREATE INDEX idx_payment_events_processed ON payment_subscriptions.payment_events (processed);

-- Usage tracking indexes
CREATE INDEX idx_usage_subscription ON payment_subscriptions.subscription_usage (subscription_id);
CREATE INDEX idx_usage_date ON payment_subscriptions.subscription_usage (usage_date DESC);
CREATE INDEX idx_usage_metric ON payment_subscriptions.subscription_usage (metric_name);

-- ========================================
-- TRIGGERS AND FUNCTIONS
-- ========================================

-- Function to update timestamps
CREATE OR REPLACE FUNCTION payment_subscriptions.update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to increment version for optimistic locking
CREATE OR REPLACE FUNCTION payment_subscriptions.increment_version()
RETURNS TRIGGER AS $$
BEGIN
    NEW.version = OLD.version + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate invoice totals
CREATE OR REPLACE FUNCTION payment_subscriptions.calculate_invoice_totals()
RETURNS TRIGGER AS $$
DECLARE
    calc_subtotal DECIMAL(12,2);
    calc_tax DECIMAL(12,2);
    calc_discount DECIMAL(12,2);
    calc_total DECIMAL(12,2);
BEGIN
    -- Calculate totals from line items
    SELECT
        COALESCE(SUM(total_price), 0),
        COALESCE(SUM(tax_amount), 0),
        COALESCE(SUM(discount_amount), 0)
    INTO calc_subtotal, calc_tax, calc_discount
    FROM payment_subscriptions.invoice_line_items
    WHERE invoice_id = COALESCE(NEW.invoice_id, OLD.invoice_id);

    calc_total := calc_subtotal + calc_tax - calc_discount;

    -- Update invoice totals
    UPDATE payment_subscriptions.invoices
    SET
        subtotal = calc_subtotal,
        tax_amount = calc_tax,
        discount_amount = calc_discount,
        total_amount = calc_total,
        amount_due = calc_total - amount_paid,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = COALESCE(NEW.invoice_id, OLD.invoice_id);

    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Function to update subscription status based on payments
CREATE OR REPLACE FUNCTION payment_subscriptions.update_subscription_status()
RETURNS TRIGGER AS $$
DECLARE
    overdue_payments INTEGER;
    subscription_status VARCHAR(30);
BEGIN
    -- Count overdue payments
    SELECT COUNT(*)
    INTO overdue_payments
    FROM payment_subscriptions.payments p
    JOIN payment_subscriptions.invoices i ON p.invoice_id = i.id
    WHERE p.subscription_id = NEW.subscription_id
    AND p.status = 'FAILED'
    AND i.due_date < CURRENT_TIMESTAMP;

    -- Determine new status
    IF NEW.status = 'SUCCESSFUL' THEN
        subscription_status := 'ACTIVE';
    ELSIF overdue_payments >= 3 THEN
        subscription_status := 'SUSPENDED';
    ELSIF overdue_payments >= 1 THEN
        subscription_status := 'PAST_DUE';
    ELSE
        subscription_status := 'ACTIVE';
    END IF;

    -- Update subscription status
    UPDATE payment_subscriptions.subscriptions
    SET
        status = subscription_status,
        grace_period_end_date = CASE
            WHEN subscription_status = 'PAST_DUE' THEN CURRENT_TIMESTAMP + INTERVAL '7 days'
            ELSE NULL
        END,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = NEW.subscription_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply triggers
CREATE TRIGGER trg_subscriptions_update_timestamp
    BEFORE UPDATE ON payment_subscriptions.subscriptions
    FOR EACH ROW
    EXECUTE FUNCTION payment_subscriptions.update_timestamp();

CREATE TRIGGER trg_subscriptions_increment_version
    BEFORE UPDATE ON payment_subscriptions.subscriptions
    FOR EACH ROW
    EXECUTE FUNCTION payment_subscriptions.increment_version();

CREATE TRIGGER trg_payments_update_timestamp
    BEFORE UPDATE ON payment_subscriptions.payments
    FOR EACH ROW
    EXECUTE FUNCTION payment_subscriptions.update_timestamp();

CREATE TRIGGER trg_payments_increment_version
    BEFORE UPDATE ON payment_subscriptions.payments
    FOR EACH ROW
    EXECUTE FUNCTION payment_subscriptions.increment_version();

CREATE TRIGGER trg_invoices_update_timestamp
    BEFORE UPDATE ON payment_subscriptions.invoices
    FOR EACH ROW
    EXECUTE FUNCTION payment_subscriptions.update_timestamp();

CREATE TRIGGER trg_line_items_calculate_totals
    AFTER INSERT OR UPDATE OR DELETE ON payment_subscriptions.invoice_line_items
    FOR EACH ROW
    EXECUTE FUNCTION payment_subscriptions.calculate_invoice_totals();

CREATE TRIGGER trg_payments_update_subscription_status
    AFTER INSERT OR UPDATE ON payment_subscriptions.payments
    FOR EACH ROW
    WHEN (NEW.status IS DISTINCT FROM OLD.status OR OLD IS NULL)
    EXECUTE FUNCTION payment_subscriptions.update_subscription_status();

-- Function to calculate subscription MRR (Monthly Recurring Revenue)
CREATE OR REPLACE FUNCTION payment_subscriptions.calculate_mrr(p_start_date DATE, p_end_date DATE)
RETURNS TABLE(
    municipality_id VARCHAR(50),
    plan_id VARCHAR(50),
    active_subscriptions INTEGER,
    monthly_revenue DECIMAL(12,2),
    annual_revenue DECIMAL(12,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        s.municipality_id,
        s.plan_id,
        COUNT(*)::INTEGER as active_subscriptions,
        SUM(CASE
            WHEN s.billing_cycle = 'MONTHLY' THEN s.plan_price
            WHEN s.billing_cycle = 'QUARTERLY' THEN s.plan_price / 3
            WHEN s.billing_cycle = 'ANNUALLY' THEN s.plan_price / 12
        END) as monthly_revenue,
        SUM(CASE
            WHEN s.billing_cycle = 'MONTHLY' THEN s.plan_price * 12
            WHEN s.billing_cycle = 'QUARTERLY' THEN s.plan_price * 4
            WHEN s.billing_cycle = 'ANNUALLY' THEN s.plan_price
        END) as annual_revenue
    FROM payment_subscriptions.subscriptions s
    WHERE s.status = 'ACTIVE'
    AND s.start_date <= p_end_date
    AND (s.end_date IS NULL OR s.end_date >= p_start_date)
    GROUP BY s.municipality_id, s.plan_id
    ORDER BY monthly_revenue DESC;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- VIEWS FOR COMMON QUERIES
-- ========================================

-- View for subscription overview
CREATE VIEW payment_subscriptions.vw_subscription_overview AS
SELECT
    s.id,
    s.subscription_id,
    s.municipality_id,
    s.plan_id,
    s.status,
    s.start_date,
    s.next_billing_date,
    s.plan_price,
    s.currency,
    s.billing_cycle,
    pm.type as payment_method_type,
    pm.card_brand,
    pm.card_last_four,
    COUNT(p.id) as total_payments,
    COUNT(CASE WHEN p.status = 'SUCCESSFUL' THEN 1 END) as successful_payments,
    COUNT(CASE WHEN p.status = 'FAILED' THEN 1 END) as failed_payments,
    COALESCE(SUM(CASE WHEN p.status = 'SUCCESSFUL' THEN p.amount END), 0) as total_paid_amount,
    MAX(p.processed_date) as last_payment_date
FROM payment_subscriptions.subscriptions s
LEFT JOIN payment_subscriptions.payment_methods pm ON s.payment_method_id = pm.id
LEFT JOIN payment_subscriptions.payments p ON s.id = p.subscription_id
GROUP BY s.id, s.subscription_id, s.municipality_id, s.plan_id, s.status,
         s.start_date, s.next_billing_date, s.plan_price, s.currency,
         s.billing_cycle, pm.type, pm.card_brand, pm.card_last_four;

-- View for payment analytics
CREATE VIEW payment_subscriptions.vw_payment_analytics AS
SELECT
    DATE_TRUNC('month', p.processed_date) as payment_month,
    p.currency,
    COUNT(*) as total_transactions,
    COUNT(CASE WHEN p.status = 'SUCCESSFUL' THEN 1 END) as successful_transactions,
    COUNT(CASE WHEN p.status = 'FAILED' THEN 1 END) as failed_transactions,
    ROUND(COUNT(CASE WHEN p.status = 'SUCCESSFUL' THEN 1 END) * 100.0 / COUNT(*), 2) as success_rate,
    SUM(p.amount) as total_amount,
    SUM(CASE WHEN p.status = 'SUCCESSFUL' THEN p.amount ELSE 0 END) as successful_amount,
    AVG(CASE WHEN p.status = 'SUCCESSFUL' THEN p.amount END) as avg_transaction_amount
FROM payment_subscriptions.payments p
WHERE p.processed_date IS NOT NULL
GROUP BY DATE_TRUNC('month', p.processed_date), p.currency
ORDER BY payment_month DESC;

-- Comments for documentation
COMMENT ON SCHEMA payment_subscriptions IS 'Payment & Subscriptions Bounded Context - Billing, payments, and subscription management';
COMMENT ON TABLE payment_subscriptions.subscriptions IS 'Main aggregate root for subscription lifecycle management';
COMMENT ON TABLE payment_subscriptions.payments IS 'Payment processing aggregate root with gateway integration';
COMMENT ON TABLE payment_subscriptions.invoices IS 'Invoice generation and billing management';
COMMENT ON TABLE payment_subscriptions.payment_methods IS 'Payment method management with Culqi integration';

-- Grant permissions (adjust as needed for your environment)
-- GRANT USAGE ON SCHEMA payment_subscriptions TO wastetrack_app;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA payment_subscriptions TO wastetrack_app;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA payment_subscriptions TO wastetrack_app;