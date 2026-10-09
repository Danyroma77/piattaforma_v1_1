BEGIN;

CREATE TABLE qr_code (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id UUID REFERENCES business(id) ON DELETE RESTRICT,
    location_id UUID REFERENCES business_location(id) ON DELETE RESTRICT,
    offer_id UUID REFERENCES offer(id) ON DELETE RESTRICT,
    campaign_id UUID REFERENCES campaign(id) ON DELETE RESTRICT,
    purpose VARCHAR(30) NOT NULL CHECK (purpose IN ('showcase','location','offer','campaign','loyalty_operation')),
    token_hash VARCHAR(128) NOT NULL UNIQUE,
    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active','revoked','expired')),
    valid_from TIMESTAMPTZ,
    valid_until TIMESTAMPTZ,
    created_by UUID REFERENCES app_user(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (valid_until IS NULL OR valid_from IS NULL OR valid_until > valid_from),
    CHECK (business_id IS NOT NULL OR location_id IS NOT NULL OR offer_id IS NOT NULL OR campaign_id IS NOT NULL)
);
CREATE INDEX ix_qr_code_business_status ON qr_code(business_id, status);

CREATE TABLE qr_scan_event (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    qr_code_id UUID REFERENCES qr_code(id) ON DELETE SET NULL,
    user_id UUID REFERENCES app_user(id) ON DELETE SET NULL,
    scan_context VARCHAR(30) NOT NULL,
    outcome VARCHAR(20) NOT NULL CHECK (outcome IN ('accepted','rejected','expired','replayed','invalid')),
    idempotency_key VARCHAR(180) NOT NULL UNIQUE,
    scanned_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX ix_qr_scan_code_date ON qr_scan_event(qr_code_id, scanned_at DESC);

CREATE TABLE notification (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id UUID REFERENCES business(id) ON DELETE RESTRICT,
    campaign_id UUID REFERENCES campaign(id) ON DELETE RESTRICT,
    title VARCHAR(200) NOT NULL,
    body TEXT NOT NULL,
    channel VARCHAR(20) NOT NULL CHECK (channel IN ('email','push','in_app')),
    status VARCHAR(20) NOT NULL DEFAULT 'queued' CHECK (status IN ('draft','queued','sending','sent','failed','cancelled')),
    scheduled_at TIMESTAMPTZ,
    created_by UUID REFERENCES app_user(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE notification_delivery (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_id UUID NOT NULL REFERENCES notification(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
    status VARCHAR(20) NOT NULL DEFAULT 'queued' CHECK (status IN ('queued','sent','delivered','failed','skipped')),
    provider_reference VARCHAR(240),
    attempt_count INTEGER NOT NULL DEFAULT 0 CHECK (attempt_count >= 0),
    last_error TEXT,
    sent_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (notification_id, user_id)
);
CREATE INDEX ix_notification_delivery_status ON notification_delivery(status, created_at);

CREATE TABLE push_subscription (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
    endpoint TEXT NOT NULL UNIQUE,
    p256dh_key TEXT NOT NULL,
    auth_key TEXT NOT NULL,
    user_agent TEXT,
    enabled BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX ix_push_subscription_user_enabled ON push_subscription(user_id, enabled);

CREATE TABLE plan (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(60) NOT NULL UNIQUE,
    name VARCHAR(120) NOT NULL,
    description TEXT,
    active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE plan_feature (
    plan_id UUID NOT NULL REFERENCES plan(id) ON DELETE CASCADE,
    feature_code VARCHAR(80) NOT NULL,
    enabled BOOLEAN NOT NULL DEFAULT true,
    limits JSONB NOT NULL DEFAULT '{}'::jsonb,
    PRIMARY KEY (plan_id, feature_code)
);

CREATE TABLE subscription (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id UUID NOT NULL REFERENCES business(id) ON DELETE RESTRICT,
    plan_id UUID NOT NULL REFERENCES plan(id) ON DELETE RESTRICT,
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending','active','past_due','cancelled','expired')),
    billing_period VARCHAR(20) NOT NULL DEFAULT 'monthly'
        CHECK (billing_period IN ('monthly','multi_month','annual')),
    period_months INTEGER NOT NULL DEFAULT 1 CHECK (period_months > 0),
    starts_at TIMESTAMPTZ,
    ends_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (ends_at IS NULL OR starts_at IS NULL OR ends_at > starts_at)
);
CREATE INDEX ix_subscription_business_status ON subscription(business_id, status);

CREATE TABLE payment (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subscription_id UUID NOT NULL REFERENCES subscription(id) ON DELETE RESTRICT,
    provider VARCHAR(60) NOT NULL,
    provider_payment_id VARCHAR(200),
    amount NUMERIC(12,2) NOT NULL CHECK (amount >= 0),
    currency CHAR(3) NOT NULL DEFAULT 'EUR',
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending','authorized','paid','failed','refunded','partially_refunded')),
    idempotency_key VARCHAR(180) NOT NULL UNIQUE,
    paid_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (provider, provider_payment_id)
);

INSERT INTO schema_migrations(migration_id) VALUES ('004_qr_notifications_subscriptions')
ON CONFLICT (migration_id) DO NOTHING;

COMMIT;
