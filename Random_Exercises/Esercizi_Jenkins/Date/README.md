# <h1 align="center">Date</h1>
La pipeline Jenkins esegue una build esclusivamente dal lunedì al venerdì.
Se la pipeline viene avviata il sabato o la domenica, la build non viene eseguita e viene mostrato un messaggio di warning.

## Funzionamento 
La pipeline:
- Viene eseguita sull'agente Jenkins `agent1`
- Crea un oggetto `Date` di Groovy
- Ottiene il giorno della settimana tramite il metodo `getDay()`
- Verifica il valore del giorno:
    - 1-5 → esegue la build Docker
    - 0 oppure 6 → stampa un messaggio di warning e non esegue la build
    - Qualsiasi altro valore → genera un errore

Nei giorni lavorativi viene eseguito il comando:
```bash
docker build -t flask-app-example .
```
che crea l'immagine Docker denominata `flask-app-example`.
