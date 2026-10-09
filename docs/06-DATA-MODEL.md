# DATA MODEL — Modello dati e schema fisico PostgreSQL

**Versione:** 1.5  
**Stato:** schema fisico iniziale proposto; da validare eseguendo le migrazioni su PostgreSQL.

## 1. Principi
- Database: PostgreSQL.
- Migrazioni SQL numerate, indipendenti dal framework.
- UUID per le chiavi primarie; `TIMESTAMPTZ` per i timestamp; `NUMERIC(12,2)` per gli importi.
- Eliminazione logica per entità di business quando serve conservarne lo storico; niente cancellazione fisica di movimenti fidelity.
- Indici su chiavi esterne e colonne usate nei filtri; vincoli univoci per evitare duplicati.
- Gli stati applicativi sono stringhe controllate da `CHECK` quando il vocabolario è stabile, altrimenti tabelle di riferimento o validazione applicativa.

## 2. Aree e tabelle principali

### Identità e autorizzazioni
- `app_user`: account e credenziali/identità esterna; non confonde l'identità con il ruolo.
- `role`, `permission`, `role_permission`, `user_role`: RBAC di piattaforma.
- `business`, `business_membership`, `business_location`: attività, membership esplicite e sedi.
- Le richieste applicative verificano sia il ruolo sia la membership sull'attività richiesta. Il referente può operare su più attività solo se associato esplicitamente.

### Vetrine, offerte e campagne
- `showcase`: vetrina dell'attività; `showcase_content`: contenuti.
- `offer`, `offer_assignment`, `offer_redemption`: offerte, assegnazioni personali e riscatti.
- `campaign`, `campaign_location`, `campaign_target`: campagne e sedi/target associati.

### Acquisti e fidelity
- `purchase_claim`: acquisto dichiarato, importo reale, importo valido per punti, sede, stato, certificazione e idempotency key.
- `purchase_evidence`, `purchase_verification`: prove e verifiche dell'acquisto.
- `loyalty_program`: programma locale (owner business) o globale (owner platform).
- `loyalty_rule_version`: regole versionate e data di validità.
- `loyalty_account`: account punti per utente e programma.
- `loyalty_transaction`: ledger append-only con quantità con segno, chiave idempotenza, acquisto e movimento compensato.
- `purchase_claim` è la fonte del fatto commerciale; i movimenti di fidelity sono registrazioni separate e correlabili.

### QR, notifiche, abbonamenti e audit
- `qr_code`, `qr_scan_event`: token QR non contenenti dati personali in chiaro, scansioni ed esito validato server-side.
- `notification`, `notification_delivery`, `push_subscription`: notifiche e consegne.
- `plan`, `plan_feature`, `subscription`, `payment`: piani, funzionalità, abbonamenti e pagamenti della piattaforma.
- `audit_log`: tracciamento delle operazioni amministrative e sensibili.

## 3. Regole fidelity e formule

### Punti locali
Per importi non negativi in euro:
`local_points = floor(valid_amount + 0.50)`

Il calcolo si esegue una sola volta sul totale valido dell'acquisto dopo sconti ed esclusioni, mai sulle singole righe. Esempi:
- € 12,49 → 12 punti
- € 12,50 → 13 punti
- € 99,60 → 100 punti

L'importo reale non viene modificato. Il database memorizza l'importo reale e quello valido; la logica di calcolo è applicativa e coperta da test. Per evitare errori di floating point, usare aritmetica decimale.

### Punti globali
`global_points = floor(local_points * global_percentage / 100)`

La percentuale iniziale è 10, configurabile e versionata. I punti globali sono aggiuntivi e non vengono sottratti dai punti locali. La versione di regola applicata è memorizzata nella transazione.

### Idempotenza e storni
- `purchase_claim.idempotency_key` univoca nel contesto previsto.
- `loyalty_transaction.idempotency_key` univoca.
- Indice univoco parziale per impedire più accrediti originari dello stesso tipo per acquisto/account.
- Ogni storno indica il movimento o l'acquisto compensato.
- Movimenti già contabilizzati non vengono aggiornati o eliminati: si aggiungono movimenti compensativi.
- Le scritture dei movimenti locale/globale e l'aggiornamento dei saldi devono avvenire nella stessa transazione database; usare lock o aggiornamenti atomici per evitare race condition.

## 4. Schema fisico
Lo schema SQL è definito negli script `migrations/001_core_identity_business.sql` fino a `migrations/005_audit_and_indexes.sql`. Applicare gli script in ordine, usando `migrations/README.md`.

## 5. Vincoli di dominio e punti da validare
- Il saldo in `loyalty_account.balance_points` è una proiezione operativa; il ledger è la fonte di audit. Un controllo periodico deve riconciliare saldo e somma movimenti.
- La certificazione dell'acquisto precede l'accredito; la scansione QR da sola non attribuisce punti.
- Il database non sostituisce i controlli autorizzativi dell'applicazione.
- La strategia di reso parziale e la gestione delle prove variano per metodo di certificazione e vanno definite nel servizio applicativo.
- La baseline non include ancora policy PostgreSQL RLS; l'isolamento multi-tenant deve essere garantito dal backend e verificato con test. RLS può essere aggiunta dopo aver definito il modello di connessione e sessione.
