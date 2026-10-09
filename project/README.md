# Piattaforma — starter V2

## Obiettivo
Base applicativa per un progetto cliente, senza branding proprietario di EB Soluzioni. L'unico riferimento a EB Soluzioni è nel footer: "Powered by EB Soluzioni".

## Stack
- React + Vite
- React Router
- Bootstrap 5 + Bootstrap Icons
- FastAPI
- PostgreSQL
- Docker Compose

## Avvio locale
1. Copiare `.env.example` in `.env`.
2. Eseguire `docker compose up --build`.
3. Aprire:
   - Frontend: http://localhost:5173
   - API docs: http://localhost:8000/docs
   - Health: http://localhost:8000/health

Il database esegue `database/migrations/001_core.sql` al primo avvio del volume. Se si cambia lo script dopo la prima inizializzazione, non verrà rieseguito automaticamente. Per resettare i soli dati demo locali: `docker compose down -v` (ATTENZIONE: elimina il volume PostgreSQL).

## Pagine frontend
- `/` — Home
- `/come-funziona` — spiegazione per utenti e negozianti
- `/negozi` — directory delle attività
- `/blog` — comunicazioni e storie della community
- `/contatti` — form contatti
- `/accedi` — interfaccia di accesso
- `/registrati` — scelta profilo e interfaccia di registrazione

## Stato funzionale
La navigazione e le pagine sono implementate. Le pagine Accedi e Registrati sono per ora interfacce frontend: autenticazione, creazione account, verifica email, recupero password e autorizzazioni server-side non sono ancora implementati. Il form contatti è collegato all'API. Blog e negozi usano dati dimostrativi se l'API non restituisce dati.

Prima di una demo pubblica servono almeno: autenticazione reale, protezione anti-spam, informativa privacy effettiva, gestione dei consensi, test, HTTPS e verifica della persistenza del database nel provider scelto.
