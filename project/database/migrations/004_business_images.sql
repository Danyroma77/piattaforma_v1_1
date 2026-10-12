-- 004_business_images.sql — aggiunge cover alle 27 vetrine Marconi.
-- Idempotente: ALTER ... ADD COLUMN IF NOT EXISTS + UPDATE mirati.

ALTER TABLE business_public_profile
  ADD COLUMN IF NOT EXISTS cover_image_url TEXT;
ALTER TABLE business_public_profile
  DROP COLUMN IF EXISTS image_credit;

UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/5150_114174571310_7488649_n.jpg', updated_at=now() WHERE public_name='Pitti Shoes';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/logo.jpg', updated_at=now() WHERE public_name='Max Empory';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/logo_exo.jpg', updated_at=now() WHERE public_name='Exo Outlet';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/06/logo-1.png', updated_at=now() WHERE public_name='Skyline Store';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/castronilog.jpg', updated_at=now() WHERE public_name='Castroni';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/logo_i_siciliani.png', updated_at=now() WHERE public_name='I Siciliani';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/logo-casa-chic-1.png', updated_at=now() WHERE public_name='Casa Chic';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/459053_358591737515204_2077886398_o.jpg', updated_at=now() WHERE public_name='Black Cherry Gioielli';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/ceramiche_sicilia_roma_marconi_14.jpg', updated_at=now() WHERE public_name='Ceramiche di Sicilia';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/06/logo-2.png', updated_at=now() WHERE public_name='Einstein41';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/rete_commercianti_marconi_sforno_pizza_pane_36.jpg', updated_at=now() WHERE public_name='Sforno Pizza e Pane';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/06/logo_ip.png', updated_at=now() WHERE public_name='Stazione 38';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/06/Blaserna_logo.png', updated_at=now() WHERE public_name='Pizzeria Blaserna';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/06/logo-3.png', updated_at=now() WHERE public_name='La Taverna del Vicolo';

UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/06/Il-Tortellino-Centro-Arvalia-Marconi.jpg', updated_at=now() WHERE public_name='Il Tortellino dal 1963';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/testata-blog.png', updated_at=now() WHERE public_name='TIM Marconi';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/Pizzino_logo.png', updated_at=now() WHERE public_name='Centro Carta Pizzino';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/quaggia_quinteri_ferramenta_roma_marconi_8.jpg', updated_at=now() WHERE public_name='Quaggia e Quintieri';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/logo.png', updated_at=now() WHERE public_name='Centro Copie Marconi';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/servizio_posta_nazionale_privata_marconi_-6.jpg', updated_at=now() WHERE public_name='La Posta Nazionale Roma2';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/06/logo2.png', updated_at=now() WHERE public_name='Delizie Marconi';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/natuica_tattoo_roma_marconi_16.jpg', updated_at=now() WHERE public_name='Nautica Tattoo';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/extension_brasil_parrucchiere_marconi_13.jpg', updated_at=now() WHERE public_name='Extension Brasil';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/dimicco_parrucchiere_roma_marconi_11.jpg', updated_at=now() WHERE public_name='Di Micco Parrucchieri';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/fairytale_parrucchiere_roma_marconi_1.jpg', updated_at=now() WHERE public_name='Fairy Tale';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/05/Ottica_sciunnach_viale_marconi_arvalia_6.jpg', updated_at=now() WHERE public_name='Ottica Sciunnach';
UPDATE business_public_profile SET cover_image_url='https://www.shoppingmarconi.com/wp-content/uploads/2019/06/logo.png', updated_at=now() WHERE public_name='Speedy Nails Art';

INSERT INTO schema_migrations(migration_id) VALUES ('004_business_images') ON CONFLICT(migration_id) DO NOTHING;

