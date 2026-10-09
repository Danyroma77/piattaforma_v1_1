# ROLES & PERMISSIONS — Ruoli, identità e autorizzazioni

**Versione:** 1.5

## 1. Principio
I tre macro-profili restano ADMIN/personale interno, UTENTE e NEGOZIO/SERVIZIO. Una persona può essere cliente e referente di attività usando lo stesso account.

## 2. Referente dell'attività
Il referente autorizzato è la figura che gestisce vetrine, offerte e campagne. Non è un quarto profilo pubblico chiamato “venditore”.

Può:
- gestire attività e sedi associate;
- creare/modificare offerte;
- gestire campagne secondo piano e permessi;
- consultare statistiche delle attività associate;
- svolgere operazioni fidelity autorizzate.

Se associato a più attività, può avere un profilo operativo trasversale su tutte le attività associate. La visibilità cross-business non è globale per impostazione predefinita: deriva da associazioni esplicite.

## 3. ADMIN/personale interno
Gestisce utenti, attività, piani, pagamenti, log e configurazioni; definisce la percentuale fidelity globale; assegna o revoca associazioni e permessi. Eventuali dipendenti commerciali della piattaforma sono personale interno e distinti dal referente del negoziante.

## 4. UTENTE
Gestisce il proprio profilo, vede vetrine e offerte pubbliche, accede alle offerte personali assegnate, presenta offerte, consulta punti e storico, usa QR e gestisce preferenze push/email.

## 5. Matrice sintetica

| Capacità | Visitatore | Utente | Referente attività | Admin |
|---|---:|---:|---:|---:|
| Consultare vetrine pubbliche | Sì | Sì | Sì | Sì |
| Vedere offerte personali | No | Se autorizzato | Se autorizzato come cliente | Per supporto autorizzato |
| Gestire profilo personale | No | Sì | Sì | Sì |
| Gestire attività/sedi | No | No | Attività associate | Sì |
| Gestire offerte/campagne | No | No | Entro piano e ambito | Sì |
| Gestire fidelity locale | No | No | Se abilitato | Supervisione |
| Configurare fidelity globale | No | No | No | Sì |
| Accedere ad attività non associate | No | No | No | Per funzione autorizzata |
| Consultare log globali | No | No | No | Sì, secondo permessi |

## 6. Sicurezza e audit
Ogni richiesta protetta verifica lato server membership e permesso. Le azioni registrano attore, attività, sede se pertinente, azione, data/ora ed esito.
