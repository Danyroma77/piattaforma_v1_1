BEGIN;

CREATE TABLE showcase (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id UUID NOT NULL UNIQUE REFERENCES business(id) ON DELETE RESTRICT,
    public_enabled BOOLEAN NOT NULL DEFAULT true,
    private_enabled BOOLEAN NOT NULL DEFAULT false,
    slug VARCHAR(180) UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE showcase_content (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    showcase_id UUID NOT NULL REFERENCES showcase(id) ON DELETE CASCADE,
    visibility VARCHAR(20) NOT NULL DEFAULT 'public'
        CHECK (visibility IN ('public','registered')),
    content_type VARCHAR(40) NOT NULL DEFAULT 'text',
    title VARCHAR(200),
    body TEXT,
    media_url TEXT,
    sort_order INTEGER NOT NULL DEFAULT 0,
    published_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX ix_showcase_content_visibility_order ON showcase_content(showcase_id, visibility, sort_order);

CREATE TABLE offer (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id UUID NOT NULL REFERENCES business(id) ON DELETE RESTRICT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    offer_type VARCHAR(40) NOT NULL DEFAULT 'discount',
    status VARCHAR(20) NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft','published','paused','expired','archived')),
    starts_at TIMESTAMPTZ,
    ends_at TIMESTAMPTZ,
    terms TEXT,
    created_by UUID REFERENCES app_user(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (ends_at IS NULL OR starts_at IS NULL OR ends_at > starts_at)
);
CREATE INDEX ix_offer_business_status_dates ON offer(business_id, status, starts_at, ends_at);

CREATE TABLE offer_assignment (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    offer_id UUID NOT NULL REFERENCES offer(id) ON DELETE RESTRICT,
    user_id UUID NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
    assigned_by UUID REFERENCES app_user(id) ON DELETE SET NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'assigned'
        CHECK (status IN ('assigned','viewed','redeemed','expired','revoked')),
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    expires_at TIMESTAMPTZ,
    UNIQUE (offer_id, user_id)
);
CREATE INDEX ix_offer_assignment_user_status ON offer_assignment(user_id, status);

CREATE TABLE offer_redemption (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    offer_id UUID NOT NULL REFERENCES offer(id) ON DELETE RESTRICT,
    assignment_id UUID REFERENCES offer_assignment(id) ON DELETE RESTRICT,
    user_id UUID NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
    business_id UUID NOT NULL REFERENCES business(id) ON DELETE RESTRICT,
    location_id UUID REFERENCES business_location(id) ON DELETE RESTRICT,
    redeemed_by UUID REFERENCES app_user(id) ON DELETE SET NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'accepted'
        CHECK (status IN ('accepted','rejected','cancelled')),
    idempotency_key VARCHAR(160) NOT NULL UNIQUE,
    redeemed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX ix_offer_redemption_business_date ON offer_redemption(business_id, redeemed_at);

CREATE TABLE campaign (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id UUID NOT NULL REFERENCES business(id) ON DELETE RESTRICT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    campaign_type VARCHAR(40) NOT NULL DEFAULT 'promotion',
    status VARCHAR(20) NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft','scheduled','active','paused','completed','cancelled')),
    starts_at TIMESTAMPTZ,
    ends_at TIMESTAMPTZ,
    created_by UUID REFERENCES app_user(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (ends_at IS NULL OR starts_at IS NULL OR ends_at > starts_at)
);
CREATE INDEX ix_campaign_business_status_dates ON campaign(business_id, status, starts_at, ends_at);

CREATE TABLE campaign_location (
    campaign_id UUID NOT NULL REFERENCES campaign(id) ON DELETE CASCADE,
    location_id UUID NOT NULL REFERENCES business_location(id) ON DELETE RESTRICT,
    PRIMARY KEY (campaign_id, location_id)
);

CREATE TABLE campaign_target (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID NOT NULL REFERENCES campaign(id) ON DELETE CASCADE,
    target_type VARCHAR(30) NOT NULL CHECK (target_type IN ('all_registered','user','segment')),
    target_user_id UUID REFERENCES app_user(id) ON DELETE RESTRICT,
    segment_key VARCHAR(120),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (
      (target_type = 'user' AND target_user_id IS NOT NULL AND segment_key IS NULL)
      OR (target_type = 'segment' AND segment_key IS NOT NULL AND target_user_id IS NULL)
      OR (target_type = 'all_registered' AND target_user_id IS NULL AND segment_key IS NULL)
    )
);
CREATE INDEX ix_campaign_target_campaign ON campaign_target(campaign_id);

INSERT INTO schema_migrations(migration_id) VALUES ('002_showcase_offers_campaigns')
ON CONFLICT (migration_id) DO NOTHING;

COMMIT;
