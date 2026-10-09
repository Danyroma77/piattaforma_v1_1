# DATABASE ARCHITECTURE — PostgreSQL V1.5

## Scopo
Definire la baseline dello schema fisico PostgreSQL e le regole d'integrazione per i servizi applicativi.

## Confini transazionali della fidelity
Per un acquisto certificato, il servizio deve:
1. bloccare o aggiornare in modo atomico la richiesta di acquisto affinché una sola esecuzione possa completare la certificazione;
2. determinare la versione della regola attiva alla data/ora dell'acquisto secondo la policy approvata;
3. calcolare i punti locali sul totale valido, arrotondando al più vicino con soglia di 0,50 euro;
4. ottenere/creare l'account locale e registrare il movimento locale;
5. calcolare i punti globali con `floor(punti_locali * percentuale / 100)` e registrare il movimento globale aggiuntivo;
6. aggiornare entrambi i saldi e lo stato dell'acquisto nella stessa transazione;
7. utilizzare chiavi idempotenza stabili e gestire i conflitti univoci come richiesta già elaborata, non come motivo per un secondo accredito.

Il servizio deve assicurare che il programma globale esista e che la regola usata sia valida. Le migrazioni inseriscono il programma globale e la regola iniziale del 10%.

## Saldi e ledger
`loyalty_transaction.points_delta` contiene quantità con segno. Il saldo non può scendere sotto zero. Se uno storno porterebbe il saldo negativo, il servizio deve applicare la policy di debito/limitazione approvata dal prodotto; fino a tale decisione, lo storno non deve essere scartato silenziosamente e deve generare un caso di revisione.

Il saldo materializzato `loyalty_account.balance_points` viene aggiornato nella stessa transazione che inserisce il ledger. Un job periodico deve confrontare il saldo con `SUM(points_delta)` e segnalare discrepanze.

## Sicurezza
- Nessun client accede direttamente al database.
- Tutte le query operative devono includere i controlli di autorizzazione su user, business e membership.
- Le chiavi/token QR devono essere casuali; nel database viene salvato il loro hash, non il token in chiaro.
- Le prove d'acquisto vanno in storage protetto; `storage_key` non deve essere un URL pubblico permanente.
- Audit log privo di password, token, segreti o dati personali non necessari.
- Prima della produzione definire backup, restore testato, rotazione credenziali e monitoraggio.

## Validazione necessaria prima del rilascio
- Eseguire le 5 migrazioni in un database PostgreSQL pulito.
- Verificare vincoli, indici, seed e ripetibilità controllata.
- Aggiungere test automatici per doppio invio, concorrenza, reso totale/parziale e riconciliazione saldi.
- Valutare RLS PostgreSQL dopo aver stabilito il modello di connessione e il set di variabili di sessione del backend.
