-- 002_marconi_seed.sql — Seed iniziale Rete Shopping Marconi (27 attivita).
-- Inserimento in pending/draft, idempotente via WHERE NOT EXISTS.
-- Da applicare dopo 001_core.sql. Parte 1/6.

-- 1. Pitti Shoes (Abbigliamento)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Pitti Shoes', 'Pitti Shoes', 'Calzature in zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Pitti Shoes'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Viale Guglielmo Marconi 150', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Pitti Shoes'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Abbigliamento', 'Roma', 'Calzature. Viale Marconi 150, Roma. Orari pubblicati: 9-13 e 16-20.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Pitti Shoes'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 2. Max Empory (Abbigliamento)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Max Empory', 'Max Empory', 'Abbigliamento in zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Max Empory'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Viale Guglielmo Marconi 70', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Max Empory'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Abbigliamento', 'Roma', 'Abbigliamento uomo/donna e bambino. Viale Marconi 70, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Max Empory'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 3. Exo Outlet (Abbigliamento)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Exo Outlet', 'Exo Outlet', 'Outlet abbigliamento zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Exo Outlet'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Viale Gregorio XIII 58/60', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Exo Outlet'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Abbigliamento', 'Roma', 'Showroom outlet uomo/donna. Viale Gregorio XIII 58/60, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Exo Outlet'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 4. Skyline Store (Abbigliamento)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Skyline Store', 'Skyline Store', 'Abbigliamento zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Skyline Store'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Piazza Enrico Fermi 60', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Skyline Store'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Abbigliamento', 'Roma', 'Abbigliamento. Piazza Enrico Fermi 60, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Skyline Store'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 5. Castroni (Bar Caffetteria)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Castroni', 'Castroni', 'Torrefazione e caffe zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Castroni'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Viale Guglielmo Marconi 102', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Castroni'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Bar Caffetteria', 'Roma', 'Torrefazione storica. Viale Marconi 102, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Castroni'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 6. I Siciliani (Bar Caffetteria)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'I Siciliani', 'I Siciliani', 'Caffetteria zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('I Siciliani'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Viale Guglielmo Marconi 210', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='I Siciliani'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Bar Caffetteria', 'Roma', 'Caffetteria di tradizione siciliana. Viale Marconi 210, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='I Siciliani'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 7. Casa Chic (Gioielli e Regali)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Casa Chic', 'Casa Chic', 'Idee regalo e arredo zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Casa Chic'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Viale Guglielmo Marconi 70', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Casa Chic'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Gioielli e Regali', 'Roma', 'Idee regalo e arredo. Viale Marconi 70, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Casa Chic'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 8. Black Cherry Gioielli (Gioielli e Regali)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Black Cherry Gioielli', 'Black Cherry Gioielli', 'Gioielleria zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Black Cherry Gioielli'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Viale Guglielmo Marconi 166A', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Black Cherry Gioielli'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Gioielli e Regali', 'Roma', 'Gioielleria e bijoux. Viale Marconi 166A, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Black Cherry Gioielli'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 9. Ceramiche di Sicilia (Gioielli e Regali)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Ceramiche di Sicilia', 'Ceramiche di Sicilia', 'Ceramiche artigianali zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Ceramiche di Sicilia'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Via Francesco Grimaldi 10', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Ceramiche di Sicilia'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Gioielli e Regali', 'Roma', 'Ceramiche di Caltagirone e artigianato. Via Grimaldi 10, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Ceramiche di Sicilia'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 10. Einstein41 (Gioielli e Regali)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Einstein41', 'Einstein41', 'Negozio zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Einstein41'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Via Albert Einstein 41', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Einstein41'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Gioielli e Regali', 'Roma', 'Negozio di prodotti e storie. Via Einstein 41, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Einstein41'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 11. Sforno Pizza e Pane (Risto Point)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Sforno Pizza e Pane', 'Sforno Pizza e Pane', 'Pizzeria zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Sforno Pizza e Pane'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Viale Guglielmo Marconi 150', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Sforno Pizza e Pane'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Risto Point', 'Roma', 'Pizza e pane. Viale Marconi 150, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Sforno Pizza e Pane'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 12. Stazione 38 (Risto Point)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Stazione 38', 'Stazione 38', 'Bar ristorante zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Stazione 38'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Piazza della Radio 38', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Stazione 38'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Risto Point', 'Roma', 'Bar ristorante cocktail bar. Piazza della Radio 38, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Stazione 38'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 13. Pizzeria Blaserna (Risto Point)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Pizzeria Blaserna', 'Pizzeria Blaserna', 'Pizzeria zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Pizzeria Blaserna'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Via Pietro Blaserna 12', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Pizzeria Blaserna'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Risto Point', 'Roma', 'Pizza al taglio e primi. Via Blaserna 12, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Pizzeria Blaserna'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 14. La Taverna del Vicolo (Risto Point; slug na-mezza-fojetta)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'La Taverna del Vicolo', 'La Taverna del Vicolo', 'Trattoria zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('La Taverna del Vicolo'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Via Pietro Mengoli 7', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='La Taverna del Vicolo'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Risto Point', 'Roma', 'Trattoria di cucina locale. Via Mengoli 7, Roma (altra sede: Via Corbino 27).', 'draft', FALSE, 100
FROM business b WHERE b.public_name='La Taverna del Vicolo'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 15. Il Tortellino dal 1963 (Risto Point)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Il Tortellino dal 1963', 'Il Tortellino dal 1963', 'Pasta fresca zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Il Tortellino dal 1963'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Via Gerolamo Cardano 50', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Il Tortellino dal 1963'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Risto Point', 'Roma', 'Pasta fresca e piatti pronti. Via Cardano 50, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Il Tortellino dal 1963'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 16. TIM / Il Telefonino Marconi (Servizi)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'TIM Marconi', 'TIM Marconi', 'Telefonia zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('TIM Marconi'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Viale Guglielmo Marconi 150', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='TIM Marconi'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Servizi', 'Roma', 'Negozio telefonia. Viale Marconi 150, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='TIM Marconi'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 17. Centro Carta Pizzino (Servizi)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Centro Carta Pizzino', 'Centro Carta Pizzino', 'Cartoleria zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Centro Carta Pizzino'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Piazza della Radio 42', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Centro Carta Pizzino'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Servizi', 'Roma', 'Articoli scuola ufficio e feste. Piazza della Radio 42, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Centro Carta Pizzino'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 18. Quaggia e Quintieri (Servizi)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Quaggia e Quintieri', 'Quaggia e Quintieri', 'Negozio storico zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Quaggia e Quintieri'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Via Francesco Grimaldi 9', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Quaggia e Quintieri'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Servizi', 'Roma', 'Negozio storico dal 1957. Via Grimaldi 9, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Quaggia e Quintieri'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 19. Centro Copie Marconi (Servizi)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Centro Copie Marconi', 'Centro Copie Marconi', 'Copisteria zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Centro Copie Marconi'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Via Albert Einstein 36', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Centro Copie Marconi'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Servizi', 'Roma', 'Copisteria e stampe. Via Einstein 36, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Centro Copie Marconi'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 20. La Posta Nazionale Roma2 (Servizi)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'La Posta Nazionale Roma2', 'La Posta Nazionale Roma2', 'Servizi postali zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('La Posta Nazionale Roma2'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Via Giuseppe Bagnera 44', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='La Posta Nazionale Roma2'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Servizi', 'Roma', 'Centro servizi postali. Via Bagnera 44, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='La Posta Nazionale Roma2'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 21. Delizie Marconi (Servizi)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Delizie Marconi', 'Delizie Marconi', 'Detersivi ecologici zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Delizie Marconi'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Via Giuseppe Veronese 4', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Delizie Marconi'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Servizi', 'Roma', 'Detersivi alla spina ecologici. Via Veronese 4, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Delizie Marconi'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 22. Nautica Tattoo (Salute e bellezza)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Nautica Tattoo', 'Nautica Tattoo', 'Tattoo studio zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Nautica Tattoo'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Viale Guglielmo Marconi 70', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Nautica Tattoo'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Salute e bellezza', 'Roma', 'Tattoo studio con sala espositiva. Viale Marconi 70 (Galleria), Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Nautica Tattoo'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 23. Extension Brasil (Salute e bellezza)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Extension Brasil', 'Extension Brasil', 'Extension e bellezza zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Extension Brasil'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Viale Guglielmo Marconi 70 Galleria Box 12', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Extension Brasil'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Salute e bellezza', 'Roma', 'Capelli ed estetica. Viale Marconi 70 Galleria Box 12, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Extension Brasil'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 24. Di Micco Parrucchieri (Salute e bellezza)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Di Micco Parrucchieri', 'Di Micco Parrucchieri', 'Parrucchiere zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Di Micco Parrucchieri'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Via Albert Einstein 27-29', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Di Micco Parrucchieri'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Salute e bellezza', 'Roma', 'Salone parrucchiere. Via Einstein 27-29, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Di Micco Parrucchieri'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 25. Ottica Sciunnach (Salute e bellezza)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Ottica Sciunnach', 'Ottica Sciunnach', 'Ottica zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Ottica Sciunnach'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Viale Guglielmo Marconi 157', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Ottica Sciunnach'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Salute e bellezza', 'Roma', 'Ottica con laboratorio in sede. Viale Marconi 157, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Ottica Sciunnach'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 26. Fairy Tale (Salute e bellezza)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Fairy Tale', 'Fairy Tale', 'Parrucchiere zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Fairy Tale'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Viale Guglielmo Marconi 70 Galleria Marconi Primo Piano', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Fairy Tale'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Salute e bellezza', 'Roma', 'Hair salon. Viale Marconi 70 Galleria Primo Piano, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Fairy Tale'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

-- 27. Speedy Nails Art (Salute e bellezza)
INSERT INTO business(legal_name, public_name, description, status)
SELECT 'Speedy Nails Art', 'Speedy Nails Art', 'Nails e bellezza zona Marconi.', 'pending'
WHERE NOT EXISTS (SELECT 1 FROM business WHERE lower(public_name)=lower('Speedy Nails Art'));
INSERT INTO business_location(business_id, name, address_line, city, province, country_code, status)
SELECT b.id, 'Sede principale', 'Via Albert Einstein 15/17', 'Roma', 'RM', 'IT', 'active'
FROM business b WHERE b.public_name='Speedy Nails Art'
AND NOT EXISTS (SELECT 1 FROM business_location l WHERE l.business_id=b.id);
INSERT INTO business_public_profile(business_id, public_name, category, city, description, status, featured, featured_order)
SELECT b.id, b.public_name, 'Salute e bellezza', 'Roma', 'Nail art e bellezza mani piedi viso. Via Einstein 15/17, Roma.', 'draft', FALSE, 100
FROM business b WHERE b.public_name='Speedy Nails Art'
AND NOT EXISTS (SELECT 1 FROM business_public_profile p WHERE p.business_id=b.id);

INSERT INTO schema_migrations(migration_id) VALUES ('002_marconi_seed') ON CONFLICT(migration_id) DO NOTHING;






