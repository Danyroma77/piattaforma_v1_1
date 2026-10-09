BEGIN;

CREATE TABLE audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_user_id UUID REFERENCES app_user(id) ON DELETE SET NULL,
    business_id UUID REFERENCES business(id) ON DELETE RESTRICT,
    action_code VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id UUID,
    outcome VARCHAR(20) NOT NULL DEFAULT 'success' CHECK (outcome IN ('success','denied','failure')),
    ip_address INET,
    user_agent TEXT,
    correlation_id VARCHAR(180),
    details JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX ix_audit_log_created_at ON audit_log(created_at DESC);
CREATE INDEX ix_audit_log_actor_created ON audit_log(actor_user_id, created_at DESC);
CREATE INDEX ix_audit_log_business_created ON audit_log(business_id, created_at DESC);
CREATE INDEX ix_audit_log_entity ON audit_log(entity_type, entity_id);

CREATE TABLE user_notification_preference (
    user_id UUID NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
    channel VARCHAR(20) NOT NULL CHECK (channel IN ('email','push','in_app')),
    enabled BOOLEAN NOT NULL DEFAULT true,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, channel)
);

-- Seed the platform-wide loyalty program and initial 10% rule.
WITH p AS (
    INSERT INTO loyalty_program(owner_type, business_id, name)
    VALUES ('platform', NULL, 'Fidelity globale piattaforma')
    ON CONFLICT DO NOTHING
    RETURNING id
), platform_program AS (
    SELECT id FROM p
    UNION ALL
    SELECT id FROM loyalty_program WHERE owner_type = 'platform'
    LIMIT 1
)
INSERT INTO loyalty_rule_version(program_id, version_number, global_percentage, valid_from)
SELECT id, 1, 10.00, now() FROM platform_program
ON CONFLICT (program_id, version_number) DO NOTHING;

INSERT INTO role(code, name, scope) VALUES
 ('ADMIN','Amministratore piattaforma','platform'),
 ('USER','Utente cliente','user'),
 ('BUSINESS_REPRESENTATIVE','Referente attività','business')
ON CONFLICT (code) DO NOTHING;

INSERT INTO schema_migrations(migration_id) VALUES ('005_audit_and_indexes')
ON CONFLICT (migration_id) DO NOTHING;

COMMIT;
