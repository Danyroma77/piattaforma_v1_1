# VISION — Visione e obiettivi della piattaforma

**Versione:** 1.5  
**Stato:** Baseline progettuale da validare  
**Data:** 2026-10-09

## 1. Visione
La piattaforma consente a negozi, imprese, professionisti e fornitori di servizi di pubblicare una vetrina online, farsi trovare geograficamente, distribuire offerte e fidelizzare i clienti. È una PWA mobile-first fin dall'MVP.

## 2. Utenti e valore
- **Visitatori/utenti:** scoperta attività, vetrine, offerte pubbliche e personali, fidelity, QR, notifiche push ed email.
- **Negozi/servizi:** gestione vetrine, sedi, offerte, campagne, fidelity e statistiche.
- **Piattaforma:** abbonamenti e servizi commerciali aggiuntivi.

## 3. Accesso
I visitatori consultano vetrine pubbliche e mappe senza login. La registrazione abilita offerte riservate, fidelity, punti, vantaggi e preferenze di comunicazione.

## 4. Attività e sedi
Un'attività può avere più sedi con indirizzi, coordinate e orari distinti. Le sedi appartengono a una sola entità commerciale e condividono il programma fidelity locale. Il referente autorizzato può operare su tutte le sedi delle attività associate al proprio profilo; se associato a più attività, può avere visibilità cross-business entro tali associazioni.

## 5. Fidelity globale e locale
- **Fidelity globale:** a ogni acquisto valido che genera punti locali, una percentuale configurabile dagli ADMIN viene attribuita anche al programma globale. Il valore iniziale richiesto è **10% dei punti locali maturati**.
- **Fidelity locale:** ogni esercente ha un programma condiviso tra le proprie sedi.

Il 10% è un parametro iniziale, non un valore fisso nel codice. I punti locali si calcolano sul totale valido dell'acquisto: 1 punto per euro, arrotondando all'euro più vicino (da 50 centesimi inclusi si arrotonda all'euro superiore). Le frazioni dei punti globali vengono scartate. I punti globali sono aggiuntivi rispetto a quelli locali. Resi e storni generano movimenti compensativi tracciati e idempotenti.

## 6. Acquisti
Sono previsti più metodi di certificazione: registrazione da parte del negoziante, acquisizione/verifica dello scontrino, codici o QR sullo scontrino e possibili integrazioni future. La certificazione precede l'accredito secondo le regole del metodo, prevenendo duplicazioni e consentendo storni.

## 7. Offerte e campagne
Gli utenti autenticati vedono le offerte a loro riservate. Le offerte personali devono poter essere presentate e validate dal negoziante. I pre-saldi sono campagne informative/promozionali senza prenotazione di quantità.

Il referente dell'attività può creare offerte e campagne per le sedi/attività associate al proprio profilo, nel rispetto dei permessi e del piano.

## 8. PWA, QR e comunicazioni
PWA, generazione/lettura QR, notifiche push ed email sono requisiti dell'MVP. Le push dipendono dal supporto e dai permessi del browser/dispositivo; l'email è un canale complementare.

## 9. Modello commerciale
Piani iniziali BASE, EVOLUTION, PROFESSIONAL e FULL. Piani, funzionalità e limiti sono configurabili. Abbonamento standard mensile, con offerte per pacchetti anticipati di più mesi.

## 10. Principi
- Mobile-first, app-like, PWA fin dall'MVP.
- Accesso pubblico ai contenuti pubblici.
- Una sola identità può essere cliente e referente di attività.
- Accesso trasversale solo alle attività associate.
- Isolamento dati, auditabilità e autorizzazioni lato server.
- Nessun pagamento B2B tra utente e negoziante gestito dalla piattaforma nell'MVP.

## 11. Obiettivo MVP
**Scoperta → vetrina → offerta personale/QR → acquisto certificato → punti locali + quota globale → campagna → push/email → ritorno all'attività.**
