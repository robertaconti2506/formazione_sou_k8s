# Workstation Mac
L'obiettivo di questo esercizio è quello di realizzare una workstation Mac.
Dal pc host ho configurato una VM Rocky tramite Vagrantfile e Ansible. 
Tramite Ansible ho installato Docker sulla VM e configurato Docker Network, installato Jenkins Master e Jenkins Agent.

## Progettazione 
Sistema operativo della VM: Rocky Linux 9 
Indirizzo IP della VM: `192.168.56.45`

Per automatizzare la configurazione dell'ambiente ho realizzato quattro Ansible rolese:
```bash
ansible-galaxy init roles/docker 
```
per l'installazione di docker 
```bash
ansible-galaxy init roles/docker_network  
```
per la configurazione della Docker Network 
```bash
ansible-galaxy init roles/jenkins  
```
per installare Jenkins Master 
```bash
ansible-galaxy init roles/jenkins_agent 
```
per installare Jenkins Agent. 

---
Il role `docker` ha lo scopo di installare e configurare Docker sulla macchina virtuale Rocky Linux 9 
- aggiorna la cache dei pacchetti DNF (`ansible.builtin.dnf`)
- installa i pacchetti necessari per la gestione dei repository (`ansible.builtin.dnf`)
- aggiunge il repository Docker ufficiale (`ansible.builtin.command`, con cmd: `dnf config-manager`)
- installa Docker Engine e i relativi componenti: `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin` e `docker-compose-plugin` (`ansible.builtin.dnf`)
- avvia e abilita Docker service all'avvio del sistema (`ansible.builtin.service`)
- aggiunge l'utente `vagrant` al gruppo `docker` (`ansible.builtin.user`)
- mostra lo stato di docker con un messaggio (se attivo `ansible.builtin.debug` o meno `ansible.builtin.fail`)

--- 
Il role `docker_network` si occupa solo della creazione della rete Docker, viene creata prima dell'avvio del container in modo da consentire la comunicazione tra i due container (Jenkins Controller e Jenkins Agent). Il modulo utilizzato è `community.docker.docker_network`. 

--------
il role `jenkins` si occupa della configurazione del container Jenkins Controller, in particolare: 
- crea il volume Jenkins (`community.docker.docker_volume`)
- crea il container Jenkins (`community.docker.docker_container`, `image: jenkins/jenkins:lts`), definendo il nome, immagine, rete, porte (8080 per consentire l'accesso all'interfaccia web di Jenkins e 50000 per stabilire la connessione con il Jenkins Agent)

---
il role `jenkins_agent` si occupa della configurazione del container Jenkins Agent, comprende un file `defaults/main.yml`, che contiene le variabili utilizzate per la connessione al Jenkins Controller, e il file `tasks/main.yml`, che gestisce la creazione e la configurazione del Jenkins Agent.
Inizialmente verifica che il controller sia effettivamente raggiungibile (`ansible.builtin.uri`) e poi crea il container Jenkins Agent (`community.docker.docker_container`,`image: jenkins/inbound-agent:latest`). La configurazione viene effettuata tramite le variabili d'ambiente (definite in `defaults/main.yml`).

---
Per quanto riguarda i dati sensibili (`jenkins_agent_secret`e `jenkins_agent_admin_token`) ho realizzato un Vault Ansible (`ansible-vault create group_vars/rocky/vault.yml`), quindi per eseguire il playbook è necessario aggiungere `--ask-vault-pass`.