# Migrazioni PostgreSQL — EB Soluzioni V1.5

Questi script sono SQL PostgreSQL indipendenti dal framework backend. Sono una baseline progettuale e **non sono dichiarati testati su un server PostgreSQL in questa consegna**.

## Ordine
1. `001_core_identity_business.sql`
2. `002_showcase_offers_campaigns.sql`
3. `003_purchase_loyalty_ledger.sql`
4. `004_qr_notifications_subscriptions.sql`
5. `005_audit_and_indexes.sql`

## Prerequisiti
- PostgreSQL 14+ consigliato.
- Database vuoto dedicato all'applicazione.
- Eseguire come ruolo proprietario dello schema o ruolo con i permessi necessari.
- Backup prima di ogni migrazione in ambienti contenenti dati.

## Esecuzione
Dalla directory del progetto, eseguire gli script in ordine con `psql` e interrompere al primo errore. Esempio:

```bash
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f migrations/001_core_identity_business.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f migrations/002_showcase_offers_campaigns.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f migrations/003_purchase_loyalty_ledger.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f migrations/004_qr_notifications_subscriptions.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f migrations/005_audit_and_indexes.sql
```

Ogni file crea `schema_migrations` se non esiste e registra il proprio ID. Gli script sono pensati per una prima installazione pulita; non rieseguire uno script parzialmente fallito senza aver verificato lo stato del database. In caso di errore, ripristinare il backup oppure correggere lo stato in modo controllato prima di ripartire.

## Strategia di rollback
Non si forniscono rollback automatici distruttivi per la baseline iniziale: rimuovere tabelle in ordine inverso può distruggere dati. Per ambienti non produttivi si può ricreare il database; per ambienti condivisi si preferiscono migrazioni correttive in avanti. Prima della produzione, definire rollback specifici e testati per ogni rilascio.

## Note
- UUID generati con `gen_random_uuid()`.
- Timestamp con timezone.
- La logica dei punti, l'autorizzazione e la verifica dei metodi di acquisto restano responsabilità dei servizi applicativi.
- La tabella `loyalty_account.balance_points` è una proiezione aggiornata in transazione; prevedere job di riconciliazione con il ledger.
