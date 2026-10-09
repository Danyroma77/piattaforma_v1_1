# FUNCTIONAL MODULES — Moduli funzionali

**Versione:** 1.5

## 1. Moduli
1. Identity & Access
2. Users & Preferences
3. Businesses & Memberships
4. Locations / Multi-sede
5. Showcase & Content
6. Search & Geolocation
7. Offers & Redemption
8. Global Loyalty
9. Business Loyalty
10. Purchase Verification
11. QR Management
12. Campaign Management
13. Pre-Sales
14. Notifications (Push + Email)
15. Plans & Subscriptions
16. Payments
17. Business Operations
18. Analytics
19. Administration
20. Audit & Logs

## 2. Attività, sedi e referente
`BUSINESS` è l'entità commerciale; `BUSINESS_LOCATION` ogni punto vendita. Il referente è una relazione tra identità e attività (`BUSINESS_MEMBERSHIP`) con permessi. Può operare su tutte le sedi delle attività associate e, se collegato a più attività, in modalità cross-business entro tali associazioni.

## 3. Fidelity globale
A ogni acquisto valido che genera punti locali, il sistema calcola la quota globale con una percentuale configurabile dall'ADMIN, inizialmente 10%. Le frazioni di punto globale vengono scartate. Le regole sono versionate e registrate nel ledger. La quota globale è aggiuntiva e non riduce i punti locali. Gli annullamenti e i resi generano movimenti compensativi collegati ai movimenti originari e protetti da idempotenza.

## 4. Fidelity locale
Ogni attività ha un programma condiviso tra le proprie sedi. I punti locali non si trasferiscono automaticamente ad attività commerciali distinte. Regola iniziale: 1 punto per ogni euro del totale valido arrotondato all'euro più vicino; 50 centesimi inclusi comportano l'arrotondamento all'euro superiore. Il totale viene arrotondato una sola volta dopo sconti ed esclusioni, non riga per riga. L'importo reale pagato non viene modificato.

## 5. Purchase Verification
Supporta registrazione del negoziante, prova/scontrino acquisito e verificato, codice/QR su scontrino e future integrazioni POS/gestionali. Verifica e accredito sono passaggi distinti. Prevedere deduplicazione, idempotenza, resi e storni.

## 6. Offers & Campaigns
Il referente può gestire offerte/campagne su tutte le sedi delle attività associate. Una campagna può valere per tutte le sedi o solo alcune. Le offerte personali sono assegnate a utenti/segmenti e validate al riscatto.

## 7. QR e notifiche
QR per vetrine, sedi, offerte, campagne e operazioni fidelity; validazione server-side per operazioni sensibili. Notifiche push ed email con preferenze, template, pianificazione, esiti e fallimenti.

## 8. Abbonamenti, analytics e audit
Abbonamenti mensili e pacchetti multi-mese. Statistiche su vetrine, offerte, QR, campagne e fidelity. Operazioni sensibili e cross-business auditabili.
