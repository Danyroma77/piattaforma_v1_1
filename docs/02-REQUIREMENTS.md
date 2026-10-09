# REQUIREMENTS — Requisiti funzionali e non funzionali

**Versione:** 1.5  
**Stato:** Baseline progettuale da validare

## 1. Requisiti funzionali

| ID | Requisito | Priorità |
|---|---|---|
| RF-001 | Registrazione, autenticazione, recupero credenziali e profilo | P0 |
| RF-002 | Un'identità può essere cliente e avere relazioni con più attività | P0 |
| RF-003 | Autorizzazioni verificate lato server | P0 |
| RF-004 | Gestione attività commerciale | P0 |
| RF-005 | Più sedi per attività | P0 |
| RF-006 | Vetrina pubblica senza login | P0 |
| RF-007 | Offerte pubbliche e riservate | P0 |
| RF-008 | Ricerca e mappa geolocalizzata | P0 |
| RF-009 | Offerte personali assegnate a utenti/segmenti | P0 |
| RF-010 | Presentazione e validazione di offerte personali | P0 |
| RF-011 | Fidelity locale condivisa tra tutte le sedi della stessa attività | P0 |
| RF-012 | Fidelity globale con percentuale configurabile dagli ADMIN | P0 |
| RF-013 | Valore iniziale fidelity globale: 10% dei punti locali maturati per acquisto valido | P0 |
| RF-014 | Ledger punti: accrediti, riscatti, rettifiche, storni e scadenze se previste | P0 |
| RF-033 | Calcolare i punti locali come 1 punto per euro, arrotondando il totale valido all'euro più vicino (50 centesimi inclusi per eccesso) | P0 |
| RF-034 | Calcolare i punti globali con la percentuale configurata e scartare le frazioni di punto | P0 |
| RF-035 | Gestire resi e annullamenti con movimenti compensativi collegati all'acquisto originale, senza duplicazioni | P0 |
| RF-015 | Più metodi di certificazione acquisto | P0 |
| RF-016 | Generazione, lettura e validazione QR | P0 |
| RF-017 | Campagne con target, sedi, offerte, QR, periodo e canali | P0 |
| RF-018 | Referente autorizzato può gestire offerte/campagne per tutte le sedi delle attività associate | P0 |
| RF-019 | Possibilità di limitare permessi a specifiche attività o sedi | P0 |
| RF-020 | Pre-saldi informativi/promozionali senza prenotazione quantità | P0 |
| RF-021 | PWA installabile e mobile-first fin dall'MVP | P0 |
| RF-022 | Notifiche push | P0 |
| RF-023 | Notifiche email | P0 |
| RF-024 | Piani e funzionalità configurabili | P0 |
| RF-025 | Abbonamenti mensili e pacchetti multi-mese | P0 |
| RF-026 | Pagamenti dell'attività verso la piattaforma | P0 |
| RF-027 | Nessun pagamento B2B utente-negoziante nell'MVP | P0 |
| RF-028 | Area admin: utenti, attività, piani, pagamenti, fidelity globale, log | P0 |
| RF-029 | Dashboard attività limitata ai dati autorizzati | P0 |
| RF-030 | Dashboard utente: offerte, punti e storico | P0 |
| RF-031 | Audit log per operazioni sensibili | P0 |
| RF-032 | Statistiche di vetrine, offerte, campagne e fidelity | P1 |

## 2. Regole fidelity

### 2.1 Punti locali
Regola iniziale: 1 punto per ogni euro conteggiato. Il calcolo si esegue sul totale valido dell'acquisto, dopo sconti ed eventuali esclusioni, non sulle singole righe. Si arrotonda il totale all'euro più vicino: da 0 a 49 centesimi si arrotonda per difetto; da 50 a 99 centesimi inclusi si arrotonda per eccesso. Esempi: € 12,49 → 12 punti; € 12,50 → 13 punti; € 99,60 → 100 punti. L'importo monetario registrato resta quello realmente pagato.

Formula per importi non negativi: `punti_locali = floor(importo_valido + 0.50)`.

### 2.2 Punti globali
Il valore iniziale è **10% dei punti locali maturati**. La quota globale è aggiuntiva e non viene sottratta dai punti locali. Le frazioni di punto globale vengono scartate: `punti_globali = floor(punti_locali * percentuale_globale / 100)`. Esempio: 100 punti locali al 10% generano altri 10 punti globali. La percentuale è una regola sui punti, non sul valore monetario o su uno sconto.

Le regole devono essere versionate e applicate una sola volta per acquisto valido. Gli acquisti senza punti locali non generano punti globali.

### 2.3 Resi, annullamenti e storni
Un annullamento integrale compensa tutti i punti locali e globali attribuiti dall'acquisto. Per un reso parziale, il sistema ricalcola i punti spettanti sul totale residuo valido e registra la differenza come movimento compensativo. Gli storni devono essere collegati all'acquisto e ai movimenti originari, tracciabili e idempotenti.

## 3. Referente multi-attività
Il referente non è un quarto macro-profilo. È una persona collegata a una o più attività. Può gestire offerte/campagne per tutte le sedi delle attività associate; l'accesso cross-business deriva da associazioni esplicite. La stessa persona può usare l'account anche come cliente. Le azioni devono essere auditabili.

## 4. Metodi di certificazione acquisto
- Inserimento da parte del negoziante.
- Acquisizione di scontrino con verifica.
- Codice/QR sullo scontrino.
- Integrazioni POS/gestionali future.

Ogni metodo definisce prova richiesta, controlli duplicati, resi/storni, revisione manuale e idempotenza. Il caricamento di una foto non implica automaticamente autenticità.

## 5. Requisiti non funzionali
Sicurezza; isolamento tra attività non associate; ledger verificabile; privacy by design; prestazioni adeguate; modularità e testabilità; accessibilità mobile; backup/ripristino; configurabilità senza hard-code.


## Requisiti tecnici dati (V1.5)
- Il database relazionale della piattaforma è PostgreSQL.
- Le migrazioni sono script SQL numerati, incrementali e indipendenti dal framework; ogni migrazione applicata viene registrata in `schema_migrations`.
- Importi monetari devono essere memorizzati come `NUMERIC`, non come floating point.
- Gli accrediti di fidelity devono essere idempotenti e collegati all'acquisto certificato; accrediti locale e globale devono essere atomici.
- I movimenti fidelity contabilizzati non possono essere cancellati o modificati: resi e storni generano movimenti compensativi.
- I vincoli e gli indici univoci devono prevenire duplicazioni note; il backend deve gestire i conflitti in modo sicuro.
- Le migrazioni devono essere verificate su PostgreSQL di test prima del rilascio.
