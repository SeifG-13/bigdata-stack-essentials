# 🚀 Premier Pipeline Big Data - Guide Complet

> **Objectif** : Apprendre à créer, configurer et déployer ton premier pipeline Big Data avec Docker

---

## Table des matières

1. [C'est quoi un Pipeline Big Data ?](#1--cest-quoi-un-pipeline-big-data)
2. [Architecture d'un Pipeline](#2-️-architecture-dun-pipeline)
3. [Prérequis et Installation](#3--prérequis-et-installation)
4. [Docker pour le Big Data](#4--docker-pour-le-big-data)
5. [Créer ton Premier Pipeline](#5--créer-ton-premier-pipeline)
6. [Configuration de chaque Composant](#6-️-configuration-de-chaque-composant)
7. [Docker Compose - Le Chef d'Orchestre](#7--docker-compose---le-chef-dorchestre)
8. [Démarrer et Tester](#8--démarrer-et-tester)
9. [Debugging et Troubleshooting](#9--debugging-et-troubleshooting)
10. [Bonnes Pratiques](#10--bonnes-pratiques)
11. [Checklist de Démarrage](#11--checklist-de-démarrage)

---

## 1. 📊 C'est quoi un Pipeline Big Data ?

### Définition Simple

Un **pipeline Big Data** c'est comme une **chaîne de production** pour les données :

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      PIPELINE = CHAÎNE DE DONNÉES                        │
│                                                                          │
│   SOURCE        INGESTION       TRAITEMENT       STOCKAGE       OUTPUT  │
│  ┌──────┐       ┌──────┐        ┌──────┐        ┌──────┐       ┌──────┐│
│  │ API  │  ──►  │Kafka │  ──►   │Spark │  ──►   │  DB  │  ──►  │Grafana││
│  │ File │       │      │        │      │        │      │       │       ││
│  │ DB   │       │      │        │      │        │      │       │       ││
│  └──────┘       └──────┘        └──────┘        └──────┘       └──────┘│
│                                                                          │
│  Données       Messages        Calculs         Sauvegarde    Visualiser │
│  brutes        en temps        distribués      structurée    et alerter │
│                réel                                                      │
└─────────────────────────────────────────────────────────────────────────┘
```

### Les 5 Étapes d'un Pipeline

| Étape | Rôle | Outils courants |
|-------|------|-----------------|
| **1. Source** | D'où viennent les données | APIs, fichiers, bases de données, IoT |
| **2. Ingestion** | Collecter et transporter | Kafka, RabbitMQ, Kinesis |
| **3. Traitement** | Transformer et calculer | Spark, Flink, Storm |
| **4. Stockage** | Sauvegarder les résultats | PostgreSQL, Cassandra, HDFS, S3 |
| **5. Consommation** | Utiliser les données | Grafana, Tableau, APIs |

### Batch vs Streaming

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│  BATCH (par lots)                    STREAMING (temps réel)              │
│  ─────────────────                   ──────────────────────              │
│                                                                          │
│  ┌───────────────────┐              ┌───────────────────┐               │
│  │ Données du jour   │              │ Données continues │               │
│  │ accumulées        │              │ flux constant     │               │
│  └─────────┬─────────┘              └─────────┬─────────┘               │
│            │                                  │                          │
│            ▼ (1 fois/jour)                    ▼ (continu)               │
│  ┌───────────────────┐              ┌───────────────────┐               │
│  │   Traitement      │              │   Traitement      │               │
│  │   (ex: 2h)        │              │   (ex: < 1s)      │               │
│  └───────────────────┘              └───────────────────┘               │
│                                                                          │
│  Exemples:                          Exemples:                           │
│  - Rapports quotidiens              - Alertes en temps réel             │
│  - Analyses historiques             - Dashboards live                   │
│  - ML training                      - Détection de fraude               │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 2. 🏗️ Architecture d'un Pipeline

### Architecture Typique

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    ARCHITECTURE PIPELINE BIG DATA                        │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                    COUCHE ORCHESTRATION                          │    │
│  │                        (Airflow)                                 │    │
│  │         Planifie, déclenche et monitore les jobs                │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                               │                                          │
│                               ▼                                          │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                    COUCHE INGESTION                              │    │
│  │                        (Kafka)                                   │    │
│  │              Buffer et transport des messages                   │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                               │                                          │
│                               ▼                                          │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                    COUCHE TRAITEMENT                             │    │
│  │                        (Spark)                                   │    │
│  │              Transformation et calculs distribués               │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                               │                                          │
│                               ▼                                          │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                    COUCHE STOCKAGE                               │    │
│  │              PostgreSQL (SQL) / Cassandra (NoSQL)               │    │
│  │                   Persistance des données                        │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                               │                                          │
│                               ▼                                          │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                    COUCHE VISUALISATION                          │    │
│  │                        (Grafana)                                 │    │
│  │                   Dashboards et alertes                         │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Stack Technique Recommandée pour Débutants

| Composant | Technologie | Pourquoi ? |
|-----------|-------------|------------|
| **Orchestration** | Apache Airflow | Interface web, facile à apprendre |
| **Message Queue** | Apache Kafka | Standard industrie, très documenté |
| **Processing** | Apache Spark | Puissant, supporte batch + streaming |
| **SQL Database** | PostgreSQL | Robuste, ACID, gratuit |
| **NoSQL Database** | Cassandra | Scalable, rapide en écriture |
| **Monitoring** | Grafana + Prometheus | Dashboards, métriques, alertes |
| **Container** | Docker + Compose | Déploiement simple et reproductible |

---

## 3. 📦 Prérequis et Installation

### Matériel Minimum

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    CONFIGURATION MINIMALE                                │
│                                                                          │
│  RAM:        8 GB minimum (16 GB recommandé)                            │
│  CPU:        4 cores minimum                                            │
│  Disque:     20 GB d'espace libre                                       │
│  OS:         Windows 10/11, macOS 10.15+, Linux Ubuntu 20.04+          │
│                                                                          │
│  ⚠️  Si RAM < 8GB: Réduire le nombre de services                       │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Installation Docker

#### Windows
```bash
# 1. Télécharger Docker Desktop
# https://www.docker.com/products/docker-desktop/

# 2. Installer et redémarrer

# 3. Vérifier l'installation
docker --version
docker-compose --version
```

#### macOS
```bash
# Option 1: Télécharger Docker Desktop
# https://www.docker.com/products/docker-desktop/

# Option 2: Homebrew
brew install --cask docker

# Vérifier
docker --version
docker-compose --version
```

#### Linux (Ubuntu/Debian)
```bash
# Mettre à jour
sudo apt update

# Installer les dépendances
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Ajouter la clé GPG Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Ajouter le repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installer Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Ajouter ton user au groupe docker
sudo usermod -aG docker $USER

# Déconnecter/reconnecter puis vérifier
docker --version
docker compose version
```

### Vérification de l'Installation

```bash
# Test Docker
docker run hello-world

# Test Docker Compose
docker compose version

# Vérifier les ressources
docker system info | grep -E "Memory|CPUs"
```

---

## 4. 🐳 Docker pour le Big Data

### Pourquoi Docker ?

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    AVANTAGES DE DOCKER                                   │
│                                                                          │
│  SANS DOCKER:                          AVEC DOCKER:                     │
│  ─────────────                         ────────────                      │
│                                                                          │
│  "Ça marche sur ma machine"            "Ça marche PARTOUT"              │
│                                                                          │
│  - Installer Java 8, 11, 17...         - 1 commande: docker-compose up  │
│  - Configurer variables env            - Tout préconfiguré              │
│  - Résoudre conflits de versions       - Environnement isolé            │
│  - Docs différentes par OS             - Même comportement partout      │
│  - 2h d'installation                   - 5 minutes                      │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Concepts Docker Essentiels

| Concept | Définition | Analogie |
|---------|------------|----------|
| **Image** | Template en lecture seule | Recette de cuisine |
| **Container** | Instance d'une image en cours d'exécution | Plat préparé |
| **Volume** | Stockage persistant | Frigo (données gardées) |
| **Network** | Réseau virtuel entre containers | Câbles réseau |
| **Docker Compose** | Définit plusieurs services | Menu complet |

### Structure d'un Projet Docker

```
mon-pipeline/
├── docker-compose.yml          # ← Définit TOUS les services
├── .env                        # ← Variables d'environnement
├── config/
│   ├── airflow/               # Config Airflow
│   ├── kafka/                 # Config Kafka
│   ├── spark/                 # Config Spark
│   ├── prometheus.yml         # Config monitoring
│   └── grafana/               # Dashboards Grafana
├── dags/                      # ← DAGs Airflow (jobs)
├── spark/                     # ← Scripts Spark
├── scripts/                   # ← Scripts utilitaires
├── data/                      # ← Données (si besoin)
└── README.md                  # ← Documentation
```

### Commandes Docker Essentielles

```bash
# ═══════════════════════════════════════════════════════════════════════
#                    GESTION DES CONTAINERS
# ═══════════════════════════════════════════════════════════════════════

# Démarrer tous les services
docker-compose up -d

# Voir les services en cours
docker-compose ps

# Voir les logs (tous les services)
docker-compose logs -f

# Voir les logs d'un service
docker-compose logs -f kafka

# Arrêter tous les services
docker-compose down

# Arrêter et supprimer les volumes (RESET COMPLET)
docker-compose down -v


# ═══════════════════════════════════════════════════════════════════════
#                    INTERACTION AVEC CONTAINERS
# ═══════════════════════════════════════════════════════════════════════

# Entrer dans un container
docker exec -it kafka bash
docker exec -it spark-master bash
docker exec -it postgres psql -U airflow -d mydb

# Exécuter une commande
docker exec kafka kafka-topics.sh --list --bootstrap-server localhost:9092

# Copier un fichier vers un container
docker cp local_file.txt container_name:/path/in/container/

# Copier un fichier depuis un container
docker cp container_name:/path/in/container/file.txt ./local/


# ═══════════════════════════════════════════════════════════════════════
#                    MONITORING ET DEBUG
# ═══════════════════════════════════════════════════════════════════════

# Voir l'utilisation des ressources
docker stats

# Inspecter un container
docker inspect container_name

# Voir les réseaux
docker network ls

# Voir les volumes
docker volume ls

# Nettoyer les ressources inutilisées
docker system prune -a
```

---

## 5. 🔧 Créer ton Premier Pipeline

### Objectif du Pipeline

On va créer un pipeline simple qui :
1. **Collecte** des données depuis une API (ou génère des données)
2. **Ingère** dans Kafka
3. **Traite** avec Spark
4. **Stocke** dans PostgreSQL
5. **Visualise** avec Grafana

### Structure du Projet

```bash
# Créer la structure
mkdir -p mon-premier-pipeline/{config,dags,spark,scripts,data}
cd mon-premier-pipeline

# Créer les fichiers
touch docker-compose.yml
touch .env
touch config/prometheus.yml
touch dags/mon_premier_dag.py
touch spark/mon_premier_job.py
touch scripts/test_connexion.py
```

### Fichier .env (Variables d'Environnement)

```bash
# .env

# ═══════════════════════════════════════════════════════════════════════
#                    VERSIONS DES IMAGES
# ═══════════════════════════════════════════════════════════════════════
AIRFLOW_VERSION=2.7.0
KAFKA_VERSION=7.4.0
SPARK_VERSION=3.5.3
POSTGRES_VERSION=15
CASSANDRA_VERSION=4.1
GRAFANA_VERSION=10.1.0
PROMETHEUS_VERSION=2.47.0

# ═══════════════════════════════════════════════════════════════════════
#                    CREDENTIALS (à changer en production!)
# ═══════════════════════════════════════════════════════════════════════
POSTGRES_USER=airflow
POSTGRES_PASSWORD=airflow
POSTGRES_DB=pipeline_db

AIRFLOW_ADMIN_USER=admin
AIRFLOW_ADMIN_PASSWORD=admin

GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=admin

# ═══════════════════════════════════════════════════════════════════════
#                    CONFIGURATION KAFKA
# ═══════════════════════════════════════════════════════════════════════
KAFKA_TOPIC=my-data-topic
KAFKA_PARTITIONS=3
KAFKA_REPLICATION_FACTOR=1
```

---

## 6. ⚙️ Configuration de chaque Composant

### PostgreSQL - Base de Données SQL

```sql
-- config/init-db.sql
-- Ce script s'exécute automatiquement au premier démarrage

-- Créer la base de données
CREATE DATABASE pipeline_db;

-- Se connecter à la base
\c pipeline_db;

-- Créer une table exemple
CREATE TABLE IF NOT EXISTS events (
    id SERIAL PRIMARY KEY,
    event_type VARCHAR(50) NOT NULL,
    event_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Créer des index pour la performance
CREATE INDEX idx_events_type ON events(event_type);
CREATE INDEX idx_events_created ON events(created_at);

-- Donner les permissions
GRANT ALL PRIVILEGES ON DATABASE pipeline_db TO airflow;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO airflow;
```

### Kafka - Configuration

```yaml
# Pas de fichier de config externe nécessaire pour démarrer
# Tout est dans docker-compose.yml via les variables d'environnement

# Mais voici les paramètres importants à connaître:

# KAFKA_BROKER_ID: Identifiant unique du broker (1, 2, 3...)
# KAFKA_ZOOKEEPER_CONNECT: Adresse de ZooKeeper
# KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: Protocoles de sécurité
# KAFKA_ADVERTISED_LISTENERS: Comment Kafka s'annonce
# KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: Réplication (1 pour dev)
# KAFKA_AUTO_CREATE_TOPICS_ENABLE: Créer les topics automatiquement
```

### Prometheus - Monitoring

```yaml
# config/prometheus.yml

global:
  scrape_interval: 15s      # Collecter les métriques toutes les 15s
  evaluation_interval: 15s  # Évaluer les règles toutes les 15s

scrape_configs:
  # Prometheus lui-même
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Kafka Exporter (métriques Kafka)
  - job_name: 'kafka'
    static_configs:
      - targets: ['kafka-exporter:9308']
    
  # Node Exporter (métriques système) - optionnel
  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']
```

### Grafana - Datasources

```yaml
# config/grafana/provisioning/datasources/datasources.yml

apiVersion: 1

datasources:
  # Prometheus pour les métriques
  - name: Prometheus
    type: prometheus
    uid: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: false

  # PostgreSQL pour les données
  - name: PostgreSQL
    type: postgres
    uid: postgres
    url: postgres:5432
    database: pipeline_db
    user: airflow
    secureJsonData:
      password: airflow
    jsonData:
      sslmode: disable
    editable: true
```

---

## 7. 📝 Docker Compose - Le Chef d'Orchestre

### docker-compose.yml Complet

```yaml
# docker-compose.yml

# ═══════════════════════════════════════════════════════════════════════
#                    TEMPLATE AIRFLOW (réutilisable)
# ═══════════════════════════════════════════════════════════════════════
x-airflow-common: &airflow-common
  image: apache/airflow:${AIRFLOW_VERSION:-2.7.0}-python3.10
  environment: &airflow-common-env
    AIRFLOW__CORE__EXECUTOR: LocalExecutor
    AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@postgres/airflow
    AIRFLOW__CORE__FERNET_KEY: ''
    AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION: 'true'
    AIRFLOW__CORE__LOAD_EXAMPLES: 'false'
    AIRFLOW__API__AUTH_BACKENDS: 'airflow.api.auth.backend.basic_auth'
    _PIP_ADDITIONAL_REQUIREMENTS: 'requests psycopg2-binary confluent-kafka'
  volumes:
    - ./dags:/opt/airflow/dags
    - ./scripts:/opt/airflow/scripts
    - airflow-logs:/opt/airflow/logs
  depends_on:
    postgres:
      condition: service_healthy
  networks:
    - pipeline-network


services:
  # ═══════════════════════════════════════════════════════════════════════
  #                    POSTGRESQL - Base de données
  # ═══════════════════════════════════════════════════════════════════════
  postgres:
    image: postgres:${POSTGRES_VERSION:-15}
    container_name: postgres
    environment:
      POSTGRES_USER: airflow
      POSTGRES_PASSWORD: airflow
      POSTGRES_DB: airflow
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./config/init-db.sql:/docker-entrypoint-initdb.d/init-db.sql
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "airflow"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - pipeline-network


  # ═══════════════════════════════════════════════════════════════════════
  #                    AIRFLOW - Orchestration
  # ═══════════════════════════════════════════════════════════════════════
  airflow-init:
    <<: *airflow-common
    container_name: airflow-init
    entrypoint: /bin/bash
    command:
      - -c
      - |
        airflow db init
        airflow users create \
          --username admin \
          --password admin \
          --firstname Admin \
          --lastname User \
          --role Admin \
          --email admin@example.com
    restart: "no"

  airflow-webserver:
    <<: *airflow-common
    container_name: airflow-webserver
    command: webserver
    ports:
      - "8080:8080"
    healthcheck:
      test: ["CMD", "curl", "--fail", "http://localhost:8080/health"]
      interval: 30s
      timeout: 10s
      retries: 5
    restart: always
    depends_on:
      airflow-init:
        condition: service_completed_successfully

  airflow-scheduler:
    <<: *airflow-common
    container_name: airflow-scheduler
    command: scheduler
    healthcheck:
      test: ["CMD-SHELL", "airflow jobs check --job-type SchedulerJob --hostname $(hostname)"]
      interval: 30s
      timeout: 10s
      retries: 5
    restart: always
    depends_on:
      airflow-init:
        condition: service_completed_successfully


  # ═══════════════════════════════════════════════════════════════════════
  #                    ZOOKEEPER - Coordination Kafka
  # ═══════════════════════════════════════════════════════════════════════
  zookeeper:
    image: confluentinc/cp-zookeeper:${KAFKA_VERSION:-7.4.0}
    container_name: zookeeper
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000
    ports:
      - "2181:2181"
    healthcheck:
      test: ['CMD', 'bash', '-c', "echo 'ruok' | nc localhost 2181"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - pipeline-network


  # ═══════════════════════════════════════════════════════════════════════
  #                    KAFKA - Message Broker
  # ═══════════════════════════════════════════════════════════════════════
  kafka:
    image: confluentinc/cp-kafka:${KAFKA_VERSION:-7.4.0}
    container_name: kafka
    depends_on:
      zookeeper:
        condition: service_healthy
    ports:
      - "9092:9092"
      - "29092:29092"
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:29092,PLAINTEXT_HOST://localhost:9092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
      KAFKA_AUTO_CREATE_TOPICS_ENABLE: 'true'
    healthcheck:
      test: ["CMD", "bash", "-c", "nc -z localhost 9092"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - pipeline-network


  # ═══════════════════════════════════════════════════════════════════════
  #                    SPARK - Traitement Distribué
  # ═══════════════════════════════════════════════════════════════════════
  spark-master:
    image: apache/spark:${SPARK_VERSION:-3.5.3}
    container_name: spark-master
    user: root
    command: /opt/spark/bin/spark-class org.apache.spark.deploy.master.Master
    ports:
      - "9090:8080"   # Spark UI
      - "7077:7077"   # Spark Master
    environment:
      - SPARK_MASTER_HOST=spark-master
      - SPARK_MASTER_PORT=7077
      - SPARK_MASTER_WEBUI_PORT=8080
      - SPARK_NO_DAEMONIZE=true
    volumes:
      - ./spark:/opt/spark-apps
    networks:
      - pipeline-network

  spark-worker:
    image: apache/spark:${SPARK_VERSION:-3.5.3}
    container_name: spark-worker
    user: root
    command: /opt/spark/bin/spark-class org.apache.spark.deploy.worker.Worker spark://spark-master:7077
    depends_on:
      - spark-master
    ports:
      - "8082:8081"
    environment:
      - SPARK_WORKER_CORES=2
      - SPARK_WORKER_MEMORY=2g
      - SPARK_MASTER=spark://spark-master:7077
      - SPARK_NO_DAEMONIZE=true
    volumes:
      - ./spark:/opt/spark-apps
    networks:
      - pipeline-network


  # ═══════════════════════════════════════════════════════════════════════
  #                    MONITORING - Kafka UI
  # ═══════════════════════════════════════════════════════════════════════
  kafka-ui:
    image: provectuslabs/kafka-ui:latest
    container_name: kafka-ui
    depends_on:
      kafka:
        condition: service_healthy
    ports:
      - "8081:8080"
    environment:
      KAFKA_CLUSTERS_0_NAME: local
      KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS: kafka:29092
      KAFKA_CLUSTERS_0_ZOOKEEPER: zookeeper:2181
    networks:
      - pipeline-network


  # ═══════════════════════════════════════════════════════════════════════
  #                    MONITORING - Prometheus
  # ═══════════════════════════════════════════════════════════════════════
  prometheus:
    image: prom/prometheus:v${PROMETHEUS_VERSION:-2.47.0}
    container_name: prometheus
    ports:
      - "9091:9090"
    volumes:
      - ./config/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.enable-lifecycle'
    networks:
      - pipeline-network


  # ═══════════════════════════════════════════════════════════════════════
  #                    MONITORING - Grafana
  # ═══════════════════════════════════════════════════════════════════════
  grafana:
    image: grafana/grafana:${GRAFANA_VERSION:-10.1.0}
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin
      - GF_USERS_ALLOW_SIGN_UP=false
    volumes:
      - grafana-data:/var/lib/grafana
      - ./config/grafana/provisioning:/etc/grafana/provisioning
    depends_on:
      - prometheus
    networks:
      - pipeline-network


  # ═══════════════════════════════════════════════════════════════════════
  #                    KAFKA EXPORTER (Métriques)
  # ═══════════════════════════════════════════════════════════════════════
  kafka-exporter:
    image: danielqsj/kafka-exporter:latest
    container_name: kafka-exporter
    ports:
      - "9308:9308"
    command:
      - '--kafka.server=kafka:29092'
    depends_on:
      kafka:
        condition: service_healthy
    networks:
      - pipeline-network


# ═══════════════════════════════════════════════════════════════════════
#                    VOLUMES PERSISTANTS
# ═══════════════════════════════════════════════════════════════════════
volumes:
  postgres-data:       # Données PostgreSQL
  airflow-logs:        # Logs Airflow
  prometheus-data:     # Métriques Prometheus
  grafana-data:        # Dashboards Grafana


# ═══════════════════════════════════════════════════════════════════════
#                    RÉSEAU
# ═══════════════════════════════════════════════════════════════════════
networks:
  pipeline-network:
    driver: bridge
```

### Tableau des Ports

| Service | Port Local | Port Container | URL |
|---------|------------|----------------|-----|
| **Airflow** | 8080 | 8080 | http://localhost:8080 |
| **Kafka UI** | 8081 | 8080 | http://localhost:8081 |
| **Spark Master** | 9090 | 8080 | http://localhost:9090 |
| **Spark Worker** | 8082 | 8081 | http://localhost:8082 |
| **Prometheus** | 9091 | 9090 | http://localhost:9091 |
| **Grafana** | 3000 | 3000 | http://localhost:3000 |
| **PostgreSQL** | 5432 | 5432 | localhost:5432 |
| **Kafka** | 9092 | 9092 | localhost:9092 |
| **ZooKeeper** | 2181 | 2181 | localhost:2181 |

---

## 8. ▶️ Démarrer et Tester

### Étape 1 : Démarrer le Pipeline

```bash
# Aller dans le dossier du projet
cd mon-premier-pipeline

# Démarrer tous les services en arrière-plan
docker-compose up -d

# Suivre les logs (optionnel)
docker-compose logs -f
```

### Étape 2 : Vérifier que tout fonctionne

```bash
# Vérifier le statut de tous les services
docker-compose ps

# Résultat attendu: tous les services "running" ou "healthy"
```

### Étape 3 : Vérifier chaque Service

```bash
# ═══════════════════════════════════════════════════════════════════════
#                    TEST POSTGRESQL
# ═══════════════════════════════════════════════════════════════════════
docker exec -it postgres psql -U airflow -d pipeline_db -c "SELECT 1;"
# Résultat attendu: 1

# ═══════════════════════════════════════════════════════════════════════
#                    TEST KAFKA
# ═══════════════════════════════════════════════════════════════════════
# Lister les topics
docker exec -it kafka kafka-topics.sh --list --bootstrap-server localhost:9092

# Créer un topic de test
docker exec -it kafka kafka-topics.sh --create \
  --topic test-topic \
  --partitions 3 \
  --replication-factor 1 \
  --bootstrap-server localhost:9092

# Envoyer un message
docker exec -it kafka bash -c "echo 'Hello World' | kafka-console-producer.sh --broker-list localhost:9092 --topic test-topic"

# Lire les messages
docker exec -it kafka kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 \
  --topic test-topic \
  --from-beginning \
  --max-messages 1

# ═══════════════════════════════════════════════════════════════════════
#                    TEST SPARK
# ═══════════════════════════════════════════════════════════════════════
# Vérifier que le worker est connecté
curl http://localhost:9090/json/ | jq '.workers'

# ═══════════════════════════════════════════════════════════════════════
#                    TEST AIRFLOW
# ═══════════════════════════════════════════════════════════════════════
# Ouvrir http://localhost:8080
# Login: admin / admin

# ═══════════════════════════════════════════════════════════════════════
#                    TEST GRAFANA
# ═══════════════════════════════════════════════════════════════════════
# Ouvrir http://localhost:3000
# Login: admin / admin
```

### Script de Test Automatique

```python
# scripts/test_pipeline.py
"""
Script pour tester que tous les composants du pipeline fonctionnent
"""

import subprocess
import sys
import time
import requests

def test_service(name, test_func):
    """Teste un service et affiche le résultat"""
    try:
        result = test_func()
        print(f"✅ {name}: OK")
        return True
    except Exception as e:
        print(f"❌ {name}: FAILED - {e}")
        return False

def test_postgres():
    """Test PostgreSQL"""
    result = subprocess.run([
        "docker", "exec", "postgres", 
        "psql", "-U", "airflow", "-d", "pipeline_db", "-c", "SELECT 1;"
    ], capture_output=True, text=True)
    if result.returncode != 0:
        raise Exception(result.stderr)
    return True

def test_kafka():
    """Test Kafka"""
    result = subprocess.run([
        "docker", "exec", "kafka", 
        "kafka-topics.sh", "--list", "--bootstrap-server", "localhost:9092"
    ], capture_output=True, text=True)
    if result.returncode != 0:
        raise Exception(result.stderr)
    return True

def test_airflow():
    """Test Airflow"""
    response = requests.get("http://localhost:8080/health", timeout=10)
    if response.status_code != 200:
        raise Exception(f"Status code: {response.status_code}")
    return True

def test_spark():
    """Test Spark"""
    response = requests.get("http://localhost:9090/json/", timeout=10)
    if response.status_code != 200:
        raise Exception(f"Status code: {response.status_code}")
    return True

def test_grafana():
    """Test Grafana"""
    response = requests.get("http://localhost:3000/api/health", timeout=10)
    if response.status_code != 200:
        raise Exception(f"Status code: {response.status_code}")
    return True

def main():
    print("=" * 60)
    print("🧪 TEST DU PIPELINE BIG DATA")
    print("=" * 60)
    print()
    
    tests = [
        ("PostgreSQL", test_postgres),
        ("Kafka", test_kafka),
        ("Airflow", test_airflow),
        ("Spark Master", test_spark),
        ("Grafana", test_grafana),
    ]
    
    results = []
    for name, test_func in tests:
        results.append(test_service(name, test_func))
        time.sleep(1)
    
    print()
    print("=" * 60)
    passed = sum(results)
    total = len(results)
    
    if passed == total:
        print(f"✅ TOUS LES TESTS PASSÉS ({passed}/{total})")
    else:
        print(f"⚠️  {total - passed} TEST(S) ÉCHOUÉ(S) ({passed}/{total})")
        sys.exit(1)

if __name__ == "__main__":
    main()
```

---

## 9. 🔧 Debugging et Troubleshooting

### Problèmes Courants et Solutions

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    PROBLÈMES COURANTS                                    │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  PROBLÈME: Container ne démarre pas                                     │
│  ─────────────────────────────────                                       │
│  1. Vérifier les logs: docker-compose logs nom-service                  │
│  2. Vérifier les ports: netstat -tulpn | grep PORT                     │
│  3. Redémarrer: docker-compose restart nom-service                     │
│                                                                          │
│  PROBLÈME: "Port already in use"                                        │
│  ─────────────────────────────────                                       │
│  1. Trouver le processus: lsof -i :8080                                │
│  2. Tuer le processus: kill -9 PID                                     │
│  3. Ou changer le port dans docker-compose.yml                         │
│                                                                          │
│  PROBLÈME: Kafka ne démarre pas                                         │
│  ─────────────────────────────────                                       │
│  1. ZooKeeper doit être "healthy" d'abord                              │
│  2. docker-compose restart zookeeper kafka                             │
│                                                                          │
│  PROBLÈME: Spark worker non connecté                                    │
│  ─────────────────────────────────                                       │
│  1. Vérifier que spark-master est UP                                   │
│  2. docker-compose restart spark-worker                                │
│                                                                          │
│  PROBLÈME: "Out of memory"                                              │
│  ─────────────────────────────────                                       │
│  1. Augmenter la RAM dans Docker Desktop                               │
│  2. Réduire les services (commenter ceux non utilisés)                 │
│  3. docker system prune -a (nettoyer)                                  │
│                                                                          │
│  PROBLÈME: Airflow DAG non visible                                      │
│  ─────────────────────────────────                                       │
│  1. Vérifier la syntaxe: python dags/mon_dag.py                        │
│  2. Vérifier les logs: docker-compose logs airflow-scheduler           │
│  3. Attendre ~30 secondes (refresh)                                     │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Commandes de Diagnostic

```bash
# ═══════════════════════════════════════════════════════════════════════
#                    DIAGNOSTIC GÉNÉRAL
# ═══════════════════════════════════════════════════════════════════════

# Voir tous les containers (même arrêtés)
docker ps -a

# Voir l'utilisation des ressources
docker stats --no-stream

# Voir les logs des 100 dernières lignes
docker-compose logs --tail=100 nom-service

# Voir les logs en temps réel
docker-compose logs -f nom-service

# Inspecter un container
docker inspect nom-container

# Voir les événements Docker
docker events --since 10m


# ═══════════════════════════════════════════════════════════════════════
#                    NETTOYAGE
# ═══════════════════════════════════════════════════════════════════════

# Arrêter tous les containers
docker-compose down

# Arrêter et supprimer les volumes (RESET COMPLET)
docker-compose down -v

# Supprimer les containers orphelins
docker container prune

# Supprimer les images non utilisées
docker image prune -a

# Supprimer les volumes non utilisés
docker volume prune

# NETTOYAGE COMPLET (attention!)
docker system prune -a --volumes
```

### Ordre de Démarrage

Si les services ne démarrent pas correctement, respecter cet ordre:

```bash
# 1. Infrastructure de base
docker-compose up -d postgres zookeeper

# Attendre 30 secondes
sleep 30

# 2. Kafka (dépend de ZooKeeper)
docker-compose up -d kafka

# Attendre 30 secondes
sleep 30

# 3. Airflow (dépend de PostgreSQL)
docker-compose up -d airflow-init
docker-compose up -d airflow-webserver airflow-scheduler

# 4. Spark
docker-compose up -d spark-master spark-worker

# 5. Monitoring
docker-compose up -d kafka-ui kafka-exporter prometheus grafana
```

---

## 10. ✅ Bonnes Pratiques

### Organisation du Code

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    BONNES PRATIQUES                                      │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  STRUCTURE:                                                             │
│  □ Un fichier docker-compose.yml par environnement (dev, prod)          │
│  □ Variables dans .env (jamais de secrets en dur!)                     │
│  □ Un README.md avec instructions claires                              │
│  □ Fichiers de config dans dossiers dédiés                             │
│                                                                          │
│  DOCKER:                                                                │
│  □ Utiliser des versions spécifiques (pas :latest en prod)             │
│  □ Ajouter des healthchecks à tous les services                        │
│  □ Définir les dépendances (depends_on + condition)                    │
│  □ Limiter les ressources (mem_limit, cpus)                            │
│  □ Utiliser des volumes nommés (pas des bind mounts en prod)          │
│                                                                          │
│  KAFKA:                                                                 │
│  □ Partitions = 3 minimum pour la production                           │
│  □ Replication factor = 3 en production                                │
│  □ Monitorer le consumer lag                                           │
│                                                                          │
│  SPARK:                                                                 │
│  □ Configurer executor.memory selon les données                        │
│  □ Monitorer via Spark UI                                              │
│  □ Utiliser Parquet pour le stockage                                   │
│                                                                          │
│  AIRFLOW:                                                               │
│  □ Un DAG par pipeline logique                                         │
│  □ Utiliser des connections (pas de credentials en dur)                │
│  □ Tester les DAGs localement avant déploiement                        │
│  □ catchup=False pour éviter les exécutions massives                   │
│                                                                          │
│  MONITORING:                                                            │
│  □ Configurer des alertes sur les métriques critiques                  │
│  □ Dashboard Grafana pour chaque composant                             │
│  □ Centraliser les logs                                                │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Checklist Sécurité

```
□ Changer les mots de passe par défaut
□ Ne JAMAIS commiter le fichier .env avec des secrets
□ Utiliser un gestionnaire de secrets (Vault, AWS Secrets Manager)
□ Limiter l'accès réseau (firewall, VPN)
□ Activer SSL/TLS pour les connexions
□ Mettre à jour régulièrement les images Docker
```

---

## 11. 📋 Checklist de Démarrage

### Pour chaque nouveau projet

```
┌─────────────────────────────────────────────────────────────────────────┐
│              CHECKLIST - NOUVEAU PIPELINE BIG DATA                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  PRÉPARATION:                                                           │
│  □ Docker installé et fonctionnel                                       │
│  □ Au moins 8GB RAM disponible                                          │
│  □ Ports requis libres (8080, 9092, etc.)                              │
│                                                                          │
│  CRÉATION DU PROJET:                                                    │
│  □ Créer la structure de dossiers                                       │
│  □ Créer docker-compose.yml                                             │
│  □ Créer .env avec les variables                                        │
│  □ Créer les fichiers de configuration                                  │
│                                                                          │
│  DÉMARRAGE:                                                             │
│  □ docker-compose up -d                                                 │
│  □ Vérifier: docker-compose ps                                          │
│  □ Tester chaque service individuellement                               │
│                                                                          │
│  CONFIGURATION AIRFLOW:                                                 │
│  □ Accéder à http://localhost:8080                                      │
│  □ Créer les Connections nécessaires                                    │
│  □ Activer les DAGs                                                     │
│                                                                          │
│  CONFIGURATION GRAFANA:                                                 │
│  □ Accéder à http://localhost:3000                                      │
│  □ Vérifier les datasources                                             │
│  □ Importer/créer les dashboards                                        │
│                                                                          │
│  TESTS:                                                                 │
│  □ Tester l'envoi de messages Kafka                                     │
│  □ Tester une requête PostgreSQL                                        │
│  □ Lancer un job Spark de test                                          │
│  □ Vérifier les métriques dans Grafana                                  │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 🎯 Résumé

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                    PREMIER PIPELINE - EN BREF                              ║
╠═══════════════════════════════════════════════════════════════════════════╣
║                                                                            ║
║  ARCHITECTURE:  Source → Kafka → Spark → Database → Grafana               ║
║                                                                            ║
║  DOCKER:        docker-compose up -d    (démarrer)                        ║
║                 docker-compose down     (arrêter)                         ║
║                 docker-compose logs -f  (voir les logs)                   ║
║                                                                            ║
║  PORTS:         8080 = Airflow                                            ║
║                 8081 = Kafka UI                                           ║
║                 9090 = Spark                                              ║
║                 3000 = Grafana                                            ║
║                 9092 = Kafka                                              ║
║                 5432 = PostgreSQL                                         ║
║                                                                            ║
║  FICHIERS:      docker-compose.yml = tous les services                   ║
║                 .env = variables d'environnement                          ║
║                 config/ = configurations                                  ║
║                 dags/ = jobs Airflow                                      ║
║                 spark/ = scripts Spark                                    ║
║                                                                            ║
║  DEBUG:         docker-compose ps (statut)                                ║
║                 docker-compose logs nom-service (logs)                    ║
║                 docker exec -it nom-container bash (entrer)               ║
║                                                                            ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

---

> **Prochaine étape** : Créer ton premier DAG Airflow qui envoie des données vers Kafka ! 🚀