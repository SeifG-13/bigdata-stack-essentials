# 🚀 Big Data Interview Preparation Guide

> **Guide complet de préparation aux entretiens d'Ingénieur Big Data Junior**

[![Made with Love](https://img.shields.io/badge/Made%20with-❤️-red.svg)](/)
[![Big Data](https://img.shields.io/badge/Big%20Data-Technologies-blue.svg)](/)
[![French](https://img.shields.io/badge/Language-French-blue.svg)](/)

---

## 📋 Table des matières

- [À propos](#-à-propos)
- [Technologies couvertes](#-technologies-couvertes)
- [Structure du projet](#-structure-du-projet)
- [Comment utiliser ce guide](#-comment-utiliser-ce-guide)
- [Contenu détaillé](#-contenu-détaillé)
- [Premier Pipeline](#-premier-pipeline)
- [Prérequis](#-prérequis)
- [Contribution](#-contribution)

---

## 📖 À propos

Ce repository contient une **documentation complète** pour préparer les entretiens techniques en **Big Data**. Chaque guide est conçu pour les **Ingénieurs Support & Intégration Junior** et couvre les concepts fondamentaux jusqu'aux bonnes pratiques en production.

### 🎯 Objectifs

- ✅ Comprendre les architectures Big Data
- ✅ Maîtriser les concepts clés de chaque technologie
- ✅ Connaître les commandes CLI essentielles
- ✅ Savoir diagnostiquer les problèmes courants
- ✅ Répondre aux questions d'entretien types

---

## 🛠 Technologies couvertes

| Technologie | Type | Fichier |
|-------------|------|---------|
| 🌬️ **Apache Airflow** | Orchestration | [`airflow/Airflow_Resume.md`](airflow/Airflow_Resume.md) |
| 🐘 **PostgreSQL** | Base SQL | [`bdd/Databases_Resume.md`](bdd/Databases_Resume.md) |
| 👁️ **Apache Cassandra** | Base NoSQL | [`bdd/Databases_Resume.md`](bdd/Databases_Resume.md) |
| 🐘 **Apache Hadoop** | Stockage distribué | [`hadoop/Hadoop_Resume.md`](hadoop/Hadoop_Resume.md) |
| 📨 **Apache Kafka** | Message Broker | [`kafka/Kafka_Resume.md`](kafka/Kafka_Resume.md) |
| ⚡ **Apache Spark** | Traitement distribué | [`spark/Spark_Resume.md`](spark/Spark_Resume.md) |
| 🐳 **Docker** | Conteneurisation | [`first_pipeline/FIRST_PIPELINE_GUIDE.md`](first_pipeline/FIRST_PIPELINE_GUIDE.md) |

---

## 📁 Structure du projet

```
big-data-interview-prep/
│
├── 📂 airflow/
│   └── Airflow_Resume.md          # Guide complet Apache Airflow
│
├── 📂 bdd/
│   └── Databases_Resume.md        # PostgreSQL + Cassandra
│
├── 📂 hadoop/
│   └── Hadoop_Resume.md           # HDFS, YARN, MapReduce, Hive, HBase
│
├── 📂 kafka/
│   └── Kafka_Resume.md            # Architecture, Producer, Consumer
│
├── 📂 spark/
│   └── Spark_Resume.md            # RDD, DataFrame, Shuffle, Optimisation
│
├── 📂 first_pipeline/
│   ├── FIRST_PIPELINE_GUIDE.md    # Guide création pipeline
│   ├── docker-compose.yml         # Stack Big Data prête à l'emploi
│   └── config/
│       └── init-db.sql            # Script initialisation PostgreSQL
│
└── README.md                      # Ce fichier
```

---

## 📚 Comment utiliser ce guide

### 1️⃣ Pour la préparation aux entretiens

Chaque guide contient une **checklist d'entretien** à la fin avec :
- Les concepts à maîtriser
- Les questions types
- Les réponses clés

### 2️⃣ Pour l'apprentissage

Les guides suivent une progression logique :
1. Vue d'ensemble et concepts
2. Architecture détaillée
3. Commandes CLI essentielles
4. Bonnes pratiques
5. Erreurs courantes et debugging

### 3️⃣ Pour la pratique

Utilisez le dossier `first_pipeline/` pour déployer un environnement Big Data complet avec Docker.

---

## 📑 Contenu détaillé

### 🌬️ Apache Airflow
- Vue d'ensemble et concepts (DAG, Task, Operator)
- Architecture (Web Server, Scheduler, Executor)
- Types d'Executors (Sequential, Local, Celery, Kubernetes)
- Écriture de DAGs
- Scheduling et expressions Cron
- XCom et communication entre tâches
- Variables et Connections
- Interface Web et CLI
- Bonnes pratiques

### 🗄️ Bases de données (PostgreSQL & Cassandra)
- SQL vs NoSQL
- Théorème CAP
- ACID vs BASE
- PostgreSQL : Architecture, SQL, Index, Administration
- Cassandra : Architecture Ring, CQL, Partitionnement, Consistency Levels
- Quand utiliser quoi ?

### 🐘 Apache Hadoop
- Architecture HDFS (NameNode, DataNode)
- Haute Disponibilité (HA)
- Data Locality et Rack Awareness
- Small Files Problem
- MapReduce et YARN
- Hive et HBase
- Commandes CLI et monitoring

### 📨 Apache Kafka
- Architecture (Broker, Topic, Partition)
- Producer et niveaux de acks
- Consumer Groups et Offsets
- Réplication et ISR
- Retention des messages
- Monitoring et métriques
- Éviter la perte de messages

### ⚡ Apache Spark
- Spark vs MapReduce
- Architecture (Driver, Executor, Worker)
- RDD, DataFrame, Dataset
- Lazy Evaluation et DAG
- Transformations vs Actions (Narrow vs Wide)
- Jobs → Stages → Tasks
- Shuffle et optimisation
- Partitions, Cache, Data Skew
- Broadcast Variables
- Spark UI et debugging

---

## 🚀 Premier Pipeline

Le dossier `first_pipeline/` contient tout le nécessaire pour démarrer un environnement Big Data local :

### Démarrage rapide

```bash
# Cloner le repository
git clone <repo-url>
cd big-data-interview-prep/first_pipeline

# Démarrer tous les services
docker-compose up -d

# Vérifier le statut
docker-compose ps
```

### Services inclus

| Service | Port | URL |
|---------|------|-----|
| Airflow | 8080 | http://localhost:8080 |
| Kafka UI | 8081 | http://localhost:8081 |
| Grafana | 3000 | http://localhost:3000 |
| PostgreSQL | 5432 | localhost:5432 |
| Kafka | 9092 | localhost:9092 |
| ZooKeeper | 2181 | localhost:2181 |

### Identifiants par défaut

| Service | Username | Password |
|---------|----------|----------|
| Airflow | admin | admin |
| Grafana | admin | admin |
| PostgreSQL | airflow | airflow |

---

## 💻 Prérequis

Pour utiliser les guides pratiques :

- **Docker** & **Docker Compose** installés
- **8 GB RAM** minimum (16 GB recommandé)
- **20 GB** d'espace disque libre
- Connaissances de base en **Python** et **SQL**

---

## 🎯 Checklist globale pour l'entretien

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    CHECKLIST ENTRETIEN BIG DATA                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  AIRFLOW:                                                               │
│  □ DAG, Task, Operator                                                  │
│  □ Scheduler, Executor, Web Server                                      │
│  □ XCom, Variables, Connections                                         │
│                                                                          │
│  KAFKA:                                                                 │
│  □ Broker, Topic, Partition                                             │
│  □ Producer (acks), Consumer (offset, lag)                              │
│  □ Réplication, ISR                                                     │
│                                                                          │
│  SPARK:                                                                 │
│  □ Driver, Executor, Worker                                             │
│  □ Lazy Evaluation, DAG                                                 │
│  □ Shuffle, Partitions, Cache                                           │
│  □ Job → Stage → Task                                                   │
│                                                                          │
│  HADOOP:                                                                │
│  □ NameNode, DataNode                                                   │
│  □ HDFS, blocs, réplication                                             │
│  □ Data Locality                                                        │
│                                                                          │
│  BASES DE DONNÉES:                                                      │
│  □ SQL vs NoSQL                                                         │
│  □ CAP, ACID, BASE                                                      │
│  □ PostgreSQL vs Cassandra                                              │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :

- 🐛 Signaler des erreurs
- 💡 Proposer des améliorations
- 📝 Ajouter du contenu

---

<div align="center">

**Bonne chance pour ton entretien ! 🚀**

Made with ❤️ for the Big Data community

</div>