-- 005_remove_demo_content.sql — rimuove i contenuti dimostrativi iniziali (001_core).
-- Idempotente: DELETE mirati + registrazione in schema_migrations.
-- NON tocca i seed reali Marconi (002/003/004).

-- Rimuove i 3 articoli dimostrativi di 001_core (se mai pubblicati).
DELETE FROM blog_post
WHERE slug IN ('una-vetrina-digitale', 'scoprire-nuove-attivita', 'piccole-iniziative');

-- Rimuove i profili pubblici demo collegati alle 3 attività demo.
DELETE FROM business_public_profile
WHERE public_name IN ('La Bottega del Quartiere', 'Studio Benessere', 'Atelier Creativo');

-- Rimuove le sedi demo (se presenti) e poi le 3 attività demo.
DELETE FROM business_location
WHERE business_id IN (SELECT id FROM business WHERE public_name IN ('La Bottega del Quartiere', 'Studio Benessere', 'Atelier Creativo'));

DELETE FROM business
WHERE public_name IN ('La Bottega del Quartiere', 'Studio Benessere', 'Atelier Creativo');

INSERT INTO schema_migrations(migration_id) VALUES ('005_remove_demo_content') ON CONFLICT(migration_id) DO NOTHING;
