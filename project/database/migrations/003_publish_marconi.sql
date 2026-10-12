-- 003_publish_marconi.sql — SOLO ESERCIZIO: rende visibili le 27 attivita seed.
-- Idempotente e reversibile (vedi blocco ROLLBACK commentato in fondo).

-- Elenco esplicito dei 27 nomi.

CREATE TEMP TABLE IF NOT EXISTS marconi_seed_names(public_name TEXT PRIMARY KEY);
INSERT INTO marconi_seed_names(public_name) VALUES
 ('Pitti Shoes'),('Max Empory'),('Exo Outlet'),('Skyline Store'),
 ('Castroni'),('I Siciliani'),
 ('Casa Chic'),('Black Cherry Gioielli'),('Ceramiche di Sicilia'),('Einstein41'),
 ('Sforno Pizza e Pane'),('Stazione 38'),('Pizzeria Blaserna'),
 ('La Taverna del Vicolo'),('Il Tortellino dal 1963'),
 ('TIM Marconi'),('Centro Carta Pizzino'),('Quaggia e Quintieri'),
 ('Centro Copie Marconi'),('La Posta Nazionale Roma2'),('Delizie Marconi'),
 ('Nautica Tattoo'),('Extension Brasil'),('Di Micco Parrucchieri'),
 ('Ottica Sciunnach'),('Fairy Tale'),('Speedy Nails Art')
ON CONFLICT DO NOTHING;

UPDATE business b
SET status = 'active', updated_at = now()
FROM marconi_seed_names s
WHERE b.public_name = s.public_name AND b.status = 'pending';

UPDATE business_public_profile p
SET status = 'published',
    featured = TRUE,
    featured_order = sub.rn,
    updated_at = now()
FROM (
  SELECT p2.business_id, ROW_NUMBER() OVER (ORDER BY p2.public_name) AS rn
  FROM business_public_profile p2
  JOIN marconi_seed_names s ON s.public_name = p2.public_name
) AS sub
WHERE p.business_id = sub.business_id
  AND p.status = 'draft';

DROP TABLE IF EXISTS marconi_seed_names;

INSERT INTO schema_migrations(migration_id) VALUES ('003_publish_marconi') ON CONFLICT(migration_id) DO NOTHING;

-- ROLLBACK esercizio (se vuoi rimettere tutto in draft): stessi 27 nomi sopra.
-- DELETE FROM schema_migrations WHERE migration_id='003_publish_marconi';
