<h1 align="center">flask-app-example-build</h1>

## Descrizione

L'obiettivo dell'esercizio è realizzare una pipeline dichiarativa Jenkins in grado di automatizzare il processo di build e pubblicazione di un'immagine Docker contenente una semplice applicazione Flask. </br> 
La pipeline costruisce automaticamente l'immagine Docker, la pubblica sul proprio repository Docker Hub e assegna il tag dell'immagine in base al contesto Git da cui viene eseguita la build (tag Git, branch `main` o branch `develop`). </br>

Troviamo due file principali:
- `Dockerfile`, che definisce l'immagine Docker contenente l'applicazione Flask, presente nella root del repository
- `Jenkinsfile`, che contiene la pipeline dichiarativa Jenkins, presente nella directory Step2

In Jenkins il job è configurato utilizzando come `Script Path`: `Step2/Jenkinsfile`. 

## Jenkinsfile

Il flusso di esecuzione è suddiviso in due fasi principali. Nella prima viene determinato il tag da assegnare all'immagine Docker in base al contesto Git che ha avviato la build (tag Git, branch `main`, branch `develop` o altri branch). Nella seconda fase viene costruita l'immagine Docker, effettuata l'autenticazione su Docker Hub e pubblicata l'immagine con il tag precedentemente calcolato. </br>

La funzione iniziale, `buildAndPushTag()`, permette di costruire e pubblicare l'immagine Docker. In particolare, imposta alcuni parametri di default, effettua l'autenticazione al registry Docker tramite le credenziali configurate in Jenkins, esegue la build dell'immagine, ne effettua il push su Docker Hub e rimuove infine le immagini locali per liberare spazio sul nodo Jenkins. </br>

Successivamente viene definita la pipeline dichiarativa, composta da due `stage`: 
- `Set Docker Tag`: determina automaticamente il tag da assegnare all'immagine Docker in base al contesto Git della build. La logica implementata distingue le build eseguite da tag Git, dal branch `main`, dal branch `develop` e da eventuali altri branch, assegnando un tag appropriato in ciascun caso
- `Build and Push`: richiama la funzione `buildAndPushTag()`, passando il nome dell'immagine, il tag calcolato nello stage precedente e l'indicazione di pubblicare anche il tag `latest` quando la build viene eseguita dal branch `main`

#### Gestione automatica dei tag

Il tag dell'immagine Docker viene determinato in base al branch Git da cui viene avviata la build.

| Origine della build | Tag assegnato              |
| ------------------- | -------------------------- |
| Tag Git             | <tag_git>                  |
| Branch main         | latest                     |
| Branch develop      | develop-<SHA_commit>       |
| Altri branch        | <nome_branch>-<SHA_commit> |

Per le build eseguite dal branch `develop` e dagli altri branch, la pipeline utilizza lo SHA abbreviato del commit Git più recente, ottenuto tramite il comando `git rev-parse --short HEAD`. In questo modo ogni immagine è associata univocamente al commit che l'ha generata.  