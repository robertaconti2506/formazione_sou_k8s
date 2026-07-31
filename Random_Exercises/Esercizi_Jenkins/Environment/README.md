<h1 align="center">Environment</h1>
La pipeline Jenkins accetta un parametro denominato `ENVIRONMENT` e, in base al valore scelto, viene eseguito uno dei due stage, `PRODUCTION` e `DEVELOPMENT`.
Ogni stage stampa a video il valore del parametro selezionato utilizzando il comando `echo`.

## Funzionamento 
La pipeline:
- Viene eseguita sull'agente Jenkins con label `agent1`
- Richiede la selezione del parametro `ENVIRONMENT`
- Il parametro può assumere il valore `PRODUCTION` o `DEVELOPMENT`
- Grazie alla direttiva `when`, Jenkins esegue solamente lo stage corrispondente al valore selezionato
- Lo stage eseguito stampa il valore del parametro tramite il comando `echo`
