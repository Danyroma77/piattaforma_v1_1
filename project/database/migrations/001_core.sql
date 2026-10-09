CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE IF NOT EXISTS schema_migrations (
  migration_id VARCHAR(120) PRIMARY KEY,
  applied_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS app_user (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(320) NOT NULL,
  password_hash TEXT,
  display_name VARCHAR(160) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','active','suspended','deleted')),
  email_verified_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS uq_app_user_email_lower ON app_user(lower(email));
CREATE TABLE IF NOT EXISTS business (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  legal_name VARCHAR(200) NOT NULL,
  public_name VARCHAR(200) NOT NULL,
  description TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','active','suspended','closed')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS business_membership (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id UUID NOT NULL REFERENCES business(id) ON DELETE RESTRICT,
  user_id UUID NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
  membership_role VARCHAR(40) NOT NULL DEFAULT 'representative',
  status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('invited','active','suspended','revoked')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (business_id, user_id)
);
CREATE TABLE IF NOT EXISTS business_location (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id UUID NOT NULL REFERENCES business(id) ON DELETE RESTRICT,
  name VARCHAR(160) NOT NULL,
  address_line VARCHAR(240),
  postal_code VARCHAR(20),
  city VARCHAR(120),
  province VARCHAR(120),
  country_code CHAR(2) NOT NULL DEFAULT 'IT',
  latitude NUMERIC(9,6),
  longitude NUMERIC(9,6),
  status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active','inactive','closed')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (latitude IS NULL OR latitude BETWEEN -90 AND 90),
  CHECK (longitude IS NULL OR longitude BETWEEN -180 AND 180)
);
CREATE TABLE IF NOT EXISTS blog_post (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug VARCHAR(180) NOT NULL UNIQUE,
  title VARCHAR(200) NOT NULL,
  excerpt TEXT,
  body TEXT NOT NULL DEFAULT '',
  status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','published','archived')),
  author_user_id UUID REFERENCES app_user(id) ON DELETE SET NULL,
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS business_public_profile (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id UUID NOT NULL UNIQUE REFERENCES business(id) ON DELETE RESTRICT,
  public_name VARCHAR(200) NOT NULL,
  category VARCHAR(100),
  city VARCHAR(120),
  description TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','published','hidden')),
  featured BOOLEAN NOT NULL DEFAULT FALSE,
  featured_order INTEGER NOT NULL DEFAULT 100,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS contact_message (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(160) NOT NULL,
  email VARCHAR(320) NOT NULL,
  profile VARCHAR(20) NOT NULL CHECK (profile IN ('utente','negoziante','altro')),
  message TEXT NOT NULL CHECK (char_length(message) BETWEEN 10 AND 4000),
  privacy_consent BOOLEAN NOT NULL CHECK (privacy_consent = TRUE),
  status VARCHAR(20) NOT NULL DEFAULT 'new' CHECK (status IN ('new','in_progress','closed','spam')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
INSERT INTO blog_post(slug,title,excerpt,body,status,published_at) VALUES
 ('una-vetrina-digitale','Una vetrina digitale per farsi conoscere','Raccontare la propria attività, condividere novità e creare relazioni con le persone del territorio.','Contenuto dimostrativo da sostituire con un articolo redazionale approvato.','published',now()),
 ('scoprire-nuove-attivita','Scoprire nuove attività vicino a te','Esplora vetrine e iniziative e resta aggiornato sui negozi che partecipano alla community.','Contenuto dimostrativo da sostituire con un articolo redazionale approvato.','published',now()-interval '1 day'),
 ('piccole-iniziative','Piccole iniziative, grandi relazioni','Le attività locali crescono anche attraverso le storie e le esperienze condivise con il territorio.','Contenuto dimostrativo da sostituire con un articolo redazionale approvato.','published',now()-interval '2 days')
ON CONFLICT(slug) DO NOTHING;
INSERT INTO business(legal_name,public_name,description,status) VALUES
 ('Attività demo 01','La Bottega del Quartiere','Prodotti scelti e attenzione alle persone.','active'),
 ('Attività demo 02','Studio Benessere','Un punto di riferimento per il benessere quotidiano.','active'),
 ('Attività demo 03','Atelier Creativo','Idee, cura e creatività in ogni dettaglio.','active')
ON CONFLICT DO NOTHING;
INSERT INTO business_public_profile(business_id,public_name,category,city,description,status,featured,featured_order)
SELECT b.id,b.public_name,
 CASE b.public_name WHEN 'La Bottega del Quartiere' THEN 'Alimentari' WHEN 'Studio Benessere' THEN 'Benessere' ELSE 'Artigianato' END,
 'Demo',b.description,'published',TRUE,
 CASE b.public_name WHEN 'La Bottega del Quartiere' THEN 1 WHEN 'Studio Benessere' THEN 2 ELSE 3 END
FROM business b
WHERE b.public_name IN ('La Bottega del Quartiere','Studio Benessere','Atelier Creativo')
ON CONFLICT(business_id) DO NOTHING;
INSERT INTO schema_migrations(migration_id) VALUES ('001_core') ON CONFLICT(migration_id) DO NOTHING;
