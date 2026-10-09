# DECISIONS — Registro decisioni di progetto

**Versione:** 1.5  
**Data:** 2026-10-09

| ID | Decisione | Stato |
|---|---|---|
| DEC-001 | La piattaforma è una PWA fin dall'MVP | Confermata |
| DEC-002 | Push ed email sono canali richiesti nell'MVP | Confermata |
| DEC-003 | La piattaforma supporta generazione, lettura e validazione QR | Confermata |
| DEC-004 | Un'attività può avere più sedi | Confermata |
| DEC-005 | La fidelity locale è condivisa tra tutte le sedi della stessa attività | Confermata |
| DEC-006 | Un'identità può essere cliente e referente di una o più attività | Confermata |
| DEC-007 | Il referente autorizzato può operare su tutte le sedi delle attività associate al proprio profilo | Confermata |
| DEC-008 | La fidelity globale accredita punti aggiuntivi, non sottratti dal saldo locale | Confermata |
| DEC-009 | La percentuale globale è configurabile dagli ADMIN; valore iniziale 10% dei punti locali maturati | Confermata |
| DEC-010 | I metodi di certificazione acquisto devono essere multipli ed estendibili | Confermata |
| DEC-011 | Le offerte personali devono essere mostrate e validate come offerte dell'utente | Confermata |
| DEC-012 | I pre-saldi non prevedono prenotazione di quantità | Confermata |
| DEC-013 | Gli abbonamenti sono mensili, con possibili pacchetti multi-mese | Confermata |
| DEC-014 | I punti locali si calcolano arrotondando il totale valido all'euro più vicino: da 50 centesimi inclusi si arrotonda all'euro superiore | Confermata |
| DEC-015 | I punti globali sono il 10% configurato dei punti locali maturati; le frazioni di punto globale vengono scartate | Confermata |
| DEC-016 | Il database applicativo è PostgreSQL | Confermata |
| DEC-017 | Le migrazioni sono script SQL numerati e indipendenti dal framework backend | Confermata |
| DEC-018 | Le migrazioni devono essere incrementali, registrate e applicate in ordine; l'esecuzione in produzione richiede backup e verifica preventiva | Confermata |

## Regole fidelity approvate

### Fidelity locale
- Regola iniziale: 1 punto per ogni euro conteggiato.
- Il calcolo si applica al totale valido dell'acquisto, dopo sconti ed eventuali esclusioni, e non alle singole righe.
- Arrotondamento commerciale: da 0 a 49 centesimi si arrotonda all'euro inferiore; da 50 a 99 centesimi inclusi si arrotonda all'euro superiore.
- Esempi: € 12,49 → 12 punti; € 12,50 → 13 punti; € 99,60 → 100 punti.
- L'importo reale dell'acquisto non viene modificato; l'arrotondamento vale solo per i punti.

Formula per importi non negativi in euro: `punti_locali = floor(importo_valido + 0.50)`. Nell'implementazione usare `NUMERIC`, mai `FLOAT`, per importi monetari.

### Fidelity globale
La percentuale iniziale è 10% dei punti locali maturati. La parte frazionaria del risultato globale viene scartata: `punti_globali = floor(punti_locali * percentuale_globale / 100)`.

Esempio: 100 punti locali al 10% producono +10 punti globali aggiuntivi. I due accrediti sono movimenti distinti, correlati allo stesso acquisto e protetti da idempotenza. La quota globale non riduce il saldo locale.

### Resi e storni
Gli annullamenti integrali devono compensare tutti i punti attribuiti dall'acquisto originario. Nei resi parziali si ricalcolano i punti spettanti sul totale residuo valido e si registra la differenza come movimento compensativo, collegato all'acquisto originario. Tutti gli storni sono tracciabili e idempotenti. Il ledger è append-only a livello applicativo: non si cancellano o modificano movimenti già contabilizzati; si aggiungono movimenti compensativi.

## Decisioni tecniche database
- PostgreSQL come database relazionale.
- Chiavi primarie UUID generate dall'applicazione o con `gen_random_uuid()` dove disponibile.
- Timestamp salvati in `TIMESTAMPTZ` in UTC.
- Importi monetari `NUMERIC(12,2)`; percentuali `NUMERIC(5,2)`.
- Le tabelle operative includono `created_at`; per le entità modificabili anche `updated_at`.
- Le autorizzazioni cross-business derivano da membership esplicite e vengono sempre verificate lato server.
- Gli script SQL numerati non dipendono da ORM o framework. La tabella tecnica `schema_migrations` registra le migrazioni applicate.
- Le migrazioni incluse sono una baseline progettuale: devono essere eseguite e verificate su una istanza PostgreSQL di test prima di un ambiente condiviso o di produzione.
