BEGIN;

CREATE TABLE purchase_method (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(60) NOT NULL UNIQUE,
    name VARCHAR(160) NOT NULL,
    description TEXT,
    enabled BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE loyalty_program (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_type VARCHAR(20) NOT NULL CHECK (owner_type IN ('platform','business')),
    business_id UUID REFERENCES business(id) ON DELETE RESTRICT,
    name VARCHAR(160) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active','paused','closed')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK ((owner_type = 'platform' AND business_id IS NULL) OR
           (owner_type = 'business' AND business_id IS NOT NULL))
);
CREATE UNIQUE INDEX uq_loyalty_program_platform ON loyalty_program(owner_type) WHERE owner_type = 'platform';
CREATE UNIQUE INDEX uq_loyalty_program_business ON loyalty_program(business_id) WHERE owner_type = 'business';

CREATE TABLE loyalty_rule_version (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    program_id UUID NOT NULL REFERENCES loyalty_program(id) ON DELETE RESTRICT,
    version_number INTEGER NOT NULL CHECK (version_number > 0),
    local_points_per_whole_eur NUMERIC(8,3) NOT NULL DEFAULT 1 CHECK (local_points_per_whole_eur >= 0),
    local_rounding_mode VARCHAR(30) NOT NULL DEFAULT 'nearest_euro_half_up'
        CHECK (local_rounding_mode IN ('nearest_euro_half_up')),
    global_percentage NUMERIC(5,2) NOT NULL DEFAULT 10 CHECK (global_percentage >= 0 AND global_percentage <= 100),
    global_fraction_mode VARCHAR(20) NOT NULL DEFAULT 'floor'
        CHECK (global_fraction_mode IN ('floor')),
    valid_from TIMESTAMPTZ NOT NULL DEFAULT now(),
    valid_until TIMESTAMPTZ,
    created_by UUID REFERENCES app_user(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (program_id, version_number),
    CHECK (valid_until IS NULL OR valid_until > valid_from)
);
CREATE INDEX ix_loyalty_rule_version_active ON loyalty_rule_version(program_id, valid_from, valid_until);

CREATE TABLE purchase_claim (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
    business_id UUID NOT NULL REFERENCES business(id) ON DELETE RESTRICT,
    location_id UUID REFERENCES business_location(id) ON DELETE RESTRICT,
    purchase_method_id UUID REFERENCES purchase_method(id) ON DELETE RESTRICT,
    external_reference VARCHAR(180),
    idempotency_key VARCHAR(180) NOT NULL UNIQUE,
    currency CHAR(3) NOT NULL DEFAULT 'EUR',
    actual_amount NUMERIC(12,2) NOT NULL CHECK (actual_amount >= 0),
    valid_amount NUMERIC(12,2) NOT NULL CHECK (valid_amount >= 0 AND valid_amount <= actual_amount),
    status VARCHAR(24) NOT NULL DEFAULT 'submitted'
        CHECK (status IN ('submitted','under_review','verified','rejected','partially_reversed','reversed')),
    purchased_at TIMESTAMPTZ NOT NULL,
    certified_at TIMESTAMPTZ,
    certified_by UUID REFERENCES app_user(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX ix_purchase_claim_user_date ON purchase_claim(user_id, purchased_at DESC);
CREATE INDEX ix_purchase_claim_business_status_date ON purchase_claim(business_id, status, purchased_at DESC);
CREATE UNIQUE INDEX uq_purchase_external_reference
    ON purchase_claim(business_id, external_reference)
    WHERE external_reference IS NOT NULL;

CREATE TABLE purchase_evidence (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    purchase_claim_id UUID NOT NULL REFERENCES purchase_claim(id) ON DELETE RESTRICT,
    evidence_type VARCHAR(30) NOT NULL CHECK (evidence_type IN ('receipt_image','receipt_code','qr','merchant_record','integration_payload','other')),
    storage_key TEXT,
    content_hash VARCHAR(128),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    uploaded_by UUID REFERENCES app_user(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX ix_purchase_evidence_claim ON purchase_evidence(purchase_claim_id);

CREATE TABLE purchase_verification (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    purchase_claim_id UUID NOT NULL REFERENCES purchase_claim(id) ON DELETE RESTRICT,
    method_id UUID REFERENCES purchase_method(id) ON DELETE RESTRICT,
    outcome VARCHAR(20) NOT NULL CHECK (outcome IN ('approved','rejected','needs_review')),
    notes TEXT,
    verified_by UUID REFERENCES app_user(id) ON DELETE SET NULL,
    verified_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX ix_purchase_verification_claim_date ON purchase_verification(purchase_claim_id, verified_at DESC);

CREATE TABLE loyalty_account (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    program_id UUID NOT NULL REFERENCES loyalty_program(id) ON DELETE RESTRICT,
    user_id UUID NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
    balance_points BIGINT NOT NULL DEFAULT 0 CHECK (balance_points >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (program_id, user_id)
);
CREATE INDEX ix_loyalty_account_user ON loyalty_account(user_id);

CREATE TABLE loyalty_transaction (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    account_id UUID NOT NULL REFERENCES loyalty_account(id) ON DELETE RESTRICT,
    program_id UUID NOT NULL REFERENCES loyalty_program(id) ON DELETE RESTRICT,
    purchase_claim_id UUID REFERENCES purchase_claim(id) ON DELETE RESTRICT,
    rule_version_id UUID REFERENCES loyalty_rule_version(id) ON DELETE RESTRICT,
    location_id UUID REFERENCES business_location(id) ON DELETE RESTRICT,
    transaction_type VARCHAR(30) NOT NULL
        CHECK (transaction_type IN ('purchase_credit','global_bonus','manual_adjustment','reversal','partial_reversal','expiration','redemption')),
    points_delta BIGINT NOT NULL CHECK (points_delta <> 0),
    idempotency_key VARCHAR(180) NOT NULL UNIQUE,
    reverses_transaction_id UUID REFERENCES loyalty_transaction(id) ON DELETE RESTRICT,
    reason TEXT,
    created_by UUID REFERENCES app_user(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX ix_loyalty_transaction_account_date ON loyalty_transaction(account_id, created_at DESC);
CREATE INDEX ix_loyalty_transaction_purchase ON loyalty_transaction(purchase_claim_id);
CREATE INDEX ix_loyalty_transaction_program_date ON loyalty_transaction(program_id, created_at DESC);
CREATE UNIQUE INDEX uq_loyalty_purchase_credit_per_purchase_account_type
    ON loyalty_transaction(account_id, purchase_claim_id, transaction_type)
    WHERE purchase_claim_id IS NOT NULL
      AND transaction_type IN ('purchase_credit','global_bonus');

INSERT INTO purchase_method(code, name, description) VALUES
 ('merchant_entry','Registrazione negoziante','Inserimento dell’acquisto da parte del referente autorizzato'),
 ('receipt_upload','Scontrino acquisito','Caricamento della prova di acquisto per verifica'),
 ('receipt_qr','Codice o QR scontrino','Verifica tramite codice o QR presente sullo scontrino')
ON CONFLICT (code) DO NOTHING;

INSERT INTO schema_migrations(migration_id) VALUES ('003_purchase_loyalty_ledger')
ON CONFLICT (migration_id) DO NOTHING;

COMMIT;
