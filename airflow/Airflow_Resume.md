# 📚 Résumé Complet Apache Airflow - Guide Junior

> **Objectif** : Tout ce qu'un Ingénieur Support & Intégration Junior Big Data doit savoir sur Apache Airflow

---

## Table des matières

1. [Vue d'ensemble Airflow](#1--vue-densemble-airflow)
2. [Concepts fondamentaux](#2--concepts-fondamentaux)
3. [Architecture Airflow](#3--architecture-airflow)
4. [Écrire un DAG](#4--écrire-un-dag)
5. [Scheduling (Planification)](#5--scheduling-planification)
6. [Dépendances entre tâches](#6--dépendances-entre-tâches)
7. [XCom (Communication entre tâches)](#7--xcom-communication-entre-tâches)
8. [Variables et Connections](#8--variables-et-connections)
9. [Operators principaux](#9--operators-principaux)
10. [Interface Web (UI)](#10--interface-web-ui)
11. [Commandes CLI essentielles](#11--commandes-cli-essentielles)
12. [Tests et Debugging](#12--tests-et-debugging)
13. [Bonnes pratiques](#13--bonnes-pratiques)
14. [Erreurs courantes](#14--erreurs-courantes)
15. [Checklist Entretien Junior](#15--checklist-entretien-junior)

---

## 1. 🌬 Vue d'ensemble Airflow

### C'est quoi Airflow ?

Apache Airflow est un **orchestrateur de workflows** open-source qui permet de :
- **Planifier** des tâches (jobs)
- **Orchestrer** des pipelines de données
- **Monitorer** l'exécution des workflows

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         AIRFLOW                                          │
│                                                                          │
│  PROBLÈME: Tu as plein de jobs à exécuter dans un ordre précis         │
│                                                                          │
│  Exemple pipeline ETL:                                                  │
│  1. Extraire données de MySQL                                           │
│  2. Transformer les données                                             │
│  3. Charger dans HDFS/Data Warehouse                                    │
│                                                                          │
│  SANS AIRFLOW:                     AVEC AIRFLOW:                        │
│  - Cron jobs manuels               - Interface web pour visualiser     │
│  - Pas de dépendances              - Gestion des dépendances           │
│  - Pas de retry                    - Retry automatique si échec        │
│  - Difficile à monitorer           - Alertes email/Slack               │
│                                    - Historique des exécutions          │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Cas d'utilisation

| Cas d'usage | Exemple |
|-------------|---------|
| **ETL/ELT** | Extraire de MySQL → Transformer → Charger dans Data Lake |
| **ML Pipelines** | Entraîner modèle → Évaluer → Déployer |
| **Data Warehouse** | Rafraîchir les tables Hive/BigQuery quotidiennement |
| **Reporting** | Générer rapports chaque matin |
| **Maintenance** | Nettoyer vieux fichiers, archiver logs |

### Airflow vs autres outils

| Outil | Type | Différence avec Airflow |
|-------|------|------------------------|
| **Cron** | Planificateur simple | Pas de dépendances, pas d'UI, pas de retry |
| **Luigi** | Orchestrateur | Moins de fonctionnalités, moins populaire |
| **Prefect** | Orchestrateur moderne | Plus récent, API différente |
| **Dagster** | Orchestrateur | Orienté data assets |
| **Oozie** | Orchestrateur Hadoop | XML, plus complexe, spécifique Hadoop |

---

## 2. 🧱 Concepts fondamentaux

### Les 3 concepts clés

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    CONCEPTS AIRFLOW                                      │
│                                                                          │
│  1. DAG (Directed Acyclic Graph)                                        │
│     = Le workflow complet, le "plan" de ton pipeline                    │
│                                                                          │
│  2. TASK                                                                │
│     = Une étape individuelle dans le DAG                                │
│                                                                          │
│  3. OPERATOR                                                            │
│     = Le "type" de tâche (Bash, Python, SQL, etc.)                     │
│                                                                          │
│                                                                          │
│  DAG "mon_pipeline"                                                     │
│  ┌─────────────────────────────────────────────────────────────┐       │
│  │                                                              │       │
│  │   [Task 1]  ──────►  [Task 2]  ──────►  [Task 3]            │       │
│  │   (Python)           (Bash)             (SQL)                │       │
│  │                                                              │       │
│  └─────────────────────────────────────────────────────────────┘       │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### DAG (Directed Acyclic Graph)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           DAG                                            │
│                                                                          │
│  DIRECTED = Les tâches ont une DIRECTION (A → B)                        │
│  ACYCLIC  = Pas de CYCLES (A → B → A interdit!)                        │
│  GRAPH    = Ensemble de nœuds (tâches) et arêtes (dépendances)         │
│                                                                          │
│  ✅ VALIDE:                     ❌ INVALIDE (cycle):                    │
│                                                                          │
│      A                              A                                    │
│      │                              │                                    │
│      ▼                              ▼                                    │
│      B ───► C                       B                                    │
│             │                       │                                    │
│             ▼                       ▼                                    │
│             D                       C ───► A  (cycle!)                  │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Task (Tâche)

Une **Task** est une unité de travail dans un DAG. Chaque tâche :
- A un `task_id` unique dans le DAG
- Utilise un Operator
- Peut dépendre d'autres tâches

### Operator (Opérateur)

L'**Operator** définit **ce que fait** la tâche :

| Operator | Usage |
|----------|-------|
| `BashOperator` | Commandes shell |
| `PythonOperator` | Code Python |
| `SqlOperator` | Requêtes SQL |
| `EmailOperator` | Envoyer email |
| `DummyOperator` | Ne fait rien (jonction) |
| `BranchOperator` | Logique conditionnelle |
| `SparkSubmitOperator` | Soumettre job Spark |
| `HiveOperator` | Requêtes Hive |

### Relation entre les concepts

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    RELATION DES CONCEPTS                                 │
│                                                                          │
│                        DAG                                               │
│                         │                                                │
│            ┌────────────┼────────────┐                                  │
│            │            │            │                                  │
│            ▼            ▼            ▼                                  │
│         Task 1       Task 2       Task 3                                │
│            │            │            │                                  │
│            ▼            ▼            ▼                                  │
│      BashOperator  PythonOp    SqlOperator                              │
│                                                                          │
│  1 DAG contient N Tasks                                                 │
│  1 Task utilise 1 Operator                                              │
│  1 Operator peut être utilisé par N Tasks                               │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 3. 🏗 Architecture Airflow

### Vue d'ensemble

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     ARCHITECTURE AIRFLOW                                 │
│                                                                          │
│  ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐   │
│  │   WEB SERVER    │     │   SCHEDULER     │     │    EXECUTOR     │   │
│  │                 │     │                 │     │                 │   │
│  │  - Interface UI │     │  - Parse DAGs   │     │  - Exécute les  │   │
│  │  - Monitoring   │     │  - Planifie     │     │    tâches       │   │
│  │  - Logs         │     │  - Déclenche    │     │                 │   │
│  └────────┬────────┘     └────────┬────────┘     └────────┬────────┘   │
│           │                       │                       │             │
│           └───────────────────────┼───────────────────────┘             │
│                                   │                                      │
│                                   ▼                                      │
│                    ┌─────────────────────────────┐                      │
│                    │      METADATA DATABASE      │                      │
│                    │      (PostgreSQL/MySQL)     │                      │
│                    │                             │                      │
│                    │  - État des DAGs            │                      │
│                    │  - Historique exécutions    │                      │
│                    │  - Variables, Connections   │                      │
│                    └─────────────────────────────┘                      │
│                                                                          │
│                    ┌─────────────────────────────┐                      │
│                    │       DAGS FOLDER           │                      │
│                    │    (fichiers Python .py)    │                      │
│                    └─────────────────────────────┘                      │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Composants détaillés

| Composant | Rôle | Détails |
|-----------|------|---------|
| **Web Server** | Interface utilisateur | Flask, port 8080 par défaut |
| **Scheduler** | Planificateur | Parse les DAGs, déclenche les tâches |
| **Executor** | Exécuteur | Exécute les tâches |
| **Metadata DB** | Base de données | Stocke l'état (PostgreSQL recommandé) |
| **DAGs Folder** | Dossier DAGs | Fichiers Python définissant les DAGs |

### Types d'Executors

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        TYPES D'EXECUTORS                                 │
│                                                                          │
│  1. SequentialExecutor (défaut)                                         │
│     ┌─────────────────────────────────────────────────────────────┐    │
│     │  - Exécute 1 tâche à la fois                                │    │
│     │  - Pour développement/test uniquement                       │    │
│     │  - ❌ PAS pour production                                   │    │
│     └─────────────────────────────────────────────────────────────┘    │
│                                                                          │
│  2. LocalExecutor                                                       │
│     ┌─────────────────────────────────────────────────────────────┐    │
│     │  - Exécute plusieurs tâches en parallèle                    │    │
│     │  - Sur une seule machine                                    │    │
│     │  - ✅ OK pour petites/moyennes charges                      │    │
│     └─────────────────────────────────────────────────────────────┘    │
│                                                                          │
│  3. CeleryExecutor                                                      │
│     ┌─────────────────────────────────────────────────────────────┐    │
│     │  - Distribue sur plusieurs workers                          │    │
│     │  - Nécessite Redis/RabbitMQ comme broker                   │    │
│     │  - ✅ Production, haute disponibilité                       │    │
│     └─────────────────────────────────────────────────────────────┘    │
│                                                                          │
│  4. KubernetesExecutor                                                  │
│     ┌─────────────────────────────────────────────────────────────┐    │
│     │  - Chaque tâche = 1 pod Kubernetes                          │    │
│     │  - Scaling dynamique                                        │    │
│     │  - ✅ Cloud-native, très scalable                           │    │
│     └─────────────────────────────────────────────────────────────┘    │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Tableau comparatif des Executors

| Executor | Parallélisme | Usage | Prérequis |
|----------|--------------|-------|-----------|
| **Sequential** | ❌ Non | Dev/Test | Aucun |
| **Local** | ✅ 1 machine | Petite prod | PostgreSQL/MySQL |
| **Celery** | ✅ Distribué | Production | Redis/RabbitMQ + Workers |
| **Kubernetes** | ✅ Pods | Cloud | Cluster K8s |

### Architecture avec CeleryExecutor

```
┌─────────────────────────────────────────────────────────────────────────┐
│                  ARCHITECTURE CELERY EXECUTOR                            │
│                                                                          │
│  ┌─────────────┐     ┌─────────────┐                                    │
│  │ Web Server  │     │  Scheduler  │                                    │
│  └──────┬──────┘     └──────┬──────┘                                    │
│         │                   │                                            │
│         └─────────┬─────────┘                                            │
│                   │                                                      │
│                   ▼                                                      │
│         ┌─────────────────┐                                             │
│         │  Metadata DB    │                                             │
│         │  (PostgreSQL)   │                                             │
│         └─────────────────┘                                             │
│                   │                                                      │
│                   ▼                                                      │
│         ┌─────────────────┐                                             │
│         │  Message Broker │                                             │
│         │  (Redis/RabbitMQ)│                                            │
│         └────────┬────────┘                                             │
│                  │                                                       │
│     ┌────────────┼────────────┐                                         │
│     │            │            │                                         │
│     ▼            ▼            ▼                                         │
│ ┌────────┐  ┌────────┐  ┌────────┐                                     │
│ │Worker 1│  │Worker 2│  │Worker 3│                                     │
│ └────────┘  └────────┘  └────────┘                                     │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 4. 📝 Écrire un DAG

### Structure de base

```python
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

# ═══════════════════════════════════════════════════════════════════════
# 1. ARGUMENTS PAR DÉFAUT
# ═══════════════════════════════════════════════════════════════════════
default_args = {
    'owner': 'data_team',              # Propriétaire
    'depends_on_past': False,          # Ne dépend pas du run précédent
    'start_date': datetime(2024, 1, 1),# Date de début
    'email': ['alerts@company.com'],   # Email pour alertes
    'email_on_failure': True,          # Email si échec
    'email_on_retry': False,           # Pas d'email sur retry
    'retries': 3,                      # Nombre de tentatives
    'retry_delay': timedelta(minutes=5), # Délai entre tentatives
}

# ═══════════════════════════════════════════════════════════════════════
# 2. DÉFINITION DU DAG
# ═══════════════════════════════════════════════════════════════════════
dag = DAG(
    'mon_premier_dag',                 # Nom unique du DAG
    default_args=default_args,
    description='Un exemple de DAG ETL',
    schedule_interval='0 6 * * *',     # Tous les jours à 6h
    catchup=False,                     # Ne pas exécuter les runs passés
    tags=['exemple', 'etl'],           # Tags pour organisation
)

# ═══════════════════════════════════════════════════════════════════════
# 3. DÉFINITION DES TÂCHES
# ═══════════════════════════════════════════════════════════════════════
def ma_fonction_python():
    print("Hello depuis Python!")
    return "Succès"

task_1 = BashOperator(
    task_id='afficher_date',
    bash_command='date',
    dag=dag,
)

task_2 = PythonOperator(
    task_id='executer_python',
    python_callable=ma_fonction_python,
    dag=dag,
)

task_3 = BashOperator(
    task_id='fin',
    bash_command='echo "Pipeline terminé!"',
    dag=dag,
)

# ═══════════════════════════════════════════════════════════════════════
# 4. DÉFINIR LES DÉPENDANCES
# ═══════════════════════════════════════════════════════════════════════
task_1 >> task_2 >> task_3
# Équivalent à: task_1 → task_2 → task_3
```

### Syntaxe moderne (TaskFlow API - Airflow 2.0+)

```python
from airflow.decorators import dag, task
from datetime import datetime

@dag(
    schedule_interval='@daily',
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=['moderne', 'taskflow'],
)
def mon_dag_moderne():
    
    @task()
    def extract():
        """Extraction des données"""
        return {"data": [1, 2, 3, 4, 5]}
    
    @task()
    def transform(data: dict):
        """Transformation des données"""
        return {"data": [x * 2 for x in data["data"]]}
    
    @task()
    def load(data: dict):
        """Chargement des données"""
        print(f"Chargement: {data}")
    
    # Chaînage automatique via XCom
    data = extract()
    transformed = transform(data)
    load(transformed)

# Instancier le DAG
mon_dag_moderne()
```

### Context Manager (autre syntaxe)

```python
from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

# Utilisation du context manager "with"
with DAG(
    'dag_avec_with',
    start_date=datetime(2024, 1, 1),
    schedule_interval='@daily',
    catchup=False,
) as dag:
    
    task_1 = BashOperator(
        task_id='task_1',
        bash_command='echo "Task 1"',
        # Pas besoin de dag=dag ici
    )
    
    task_2 = BashOperator(
        task_id='task_2',
        bash_command='echo "Task 2"',
    )
    
    task_1 >> task_2
```

---

## 5. ⏰ Scheduling (Planification)

### Schedule Interval

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    SCHEDULE INTERVAL                                     │
│                                                                          │
│  PRESETS (raccourcis):                                                  │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  @once      = Une seule fois                                     │   │
│  │  @hourly    = Toutes les heures      (0 * * * *)                │   │
│  │  @daily     = Tous les jours minuit  (0 0 * * *)                │   │
│  │  @weekly    = Dimanche minuit        (0 0 * * 0)                │   │
│  │  @monthly   = 1er du mois minuit     (0 0 1 * *)                │   │
│  │  @yearly    = 1er janvier minuit     (0 0 1 1 *)                │   │
│  │  None       = Déclenché manuellement uniquement                 │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Expressions Cron

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    EXPRESSIONS CRON                                      │
│                                                                          │
│  Format: "minute heure jour_mois mois jour_semaine"                     │
│                                                                          │
│           ┌───────────── minute (0 - 59)                                │
│           │ ┌───────────── heure (0 - 23)                               │
│           │ │ ┌───────────── jour du mois (1 - 31)                      │
│           │ │ │ ┌───────────── mois (1 - 12)                            │
│           │ │ │ │ ┌───────────── jour de la semaine (0 - 6)             │
│           │ │ │ │ │              (0 = dimanche)                         │
│           │ │ │ │ │                                                      │
│           * * * * *                                                      │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Exemples Cron

| Expression | Signification |
|------------|---------------|
| `0 6 * * *` | Tous les jours à 6h00 |
| `0 0 * * 0` | Tous les dimanches à minuit |
| `0 */4 * * *` | Toutes les 4 heures |
| `30 9 * * 1-5` | Lundi à vendredi à 9h30 |
| `0 0 1,15 * *` | 1er et 15 du mois à minuit |
| `0 9,18 * * *` | À 9h et 18h chaque jour |
| `*/15 * * * *` | Toutes les 15 minutes |

### Concept important : execution_date

```
┌─────────────────────────────────────────────────────────────────────────┐
│              EXECUTION_DATE - CONCEPT IMPORTANT                          │
│                                                                          │
│  DAG planifié @daily, start_date = 2024-01-01                          │
│                                                                          │
│  ┌─────────┬─────────┬─────────┬─────────┐                              │
│  │ Jan 1   │ Jan 2   │ Jan 3   │ Jan 4   │                              │
│  └────┬────┴────┬────┴────┬────┴────┬────┘                              │
│       │         │         │         │                                    │
│       ▼         ▼         ▼         ▼                                    │
│    Run pour   Run pour  Run pour  Run pour                              │
│    Jan 1      Jan 2     Jan 3     Jan 4                                 │
│    s'exécute  s'exécute s'exécute s'exécute                             │
│    le Jan 2   le Jan 3  le Jan 4  le Jan 5                              │
│                                                                          │
│  ⚠️  IMPORTANT:                                                         │
│  Le run pour une journée s'exécute à la FIN de cette journée           │
│  (au début de la journée suivante)                                      │
│                                                                          │
│  execution_date = début de l'intervalle de données                     │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Catchup

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         CATCHUP                                          │
│                                                                          │
│  catchup=True (défaut):                                                 │
│  - Exécute TOUS les runs manqués depuis start_date                     │
│  - Utile pour backfill de données historiques                          │
│                                                                          │
│  catchup=False (recommandé):                                            │
│  - N'exécute que les runs futurs                                        │
│  - Évite l'exécution de centaines de runs au démarrage                 │
│                                                                          │
│  Exemple:                                                               │
│  start_date = 2024-01-01, aujourd'hui = 2024-06-01                     │
│                                                                          │
│  catchup=True  → 150+ runs à exécuter!                                 │
│  catchup=False → Seulement les runs à partir d'aujourd'hui             │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 6. 🔗 Dépendances entre tâches

### Syntaxe des dépendances

```python
# ═══════════════════════════════════════════════════════════════════════
# MÉTHODE 1: Opérateurs >> et << (recommandé)
# ═══════════════════════════════════════════════════════════════════════

# Séquentiel
task_a >> task_b                    # A puis B
task_a >> task_b >> task_c          # A → B → C

# Parallèle (fan-out)
task_a >> [task_b, task_c]          # A → (B et C en parallèle)

# Convergent (fan-in)
[task_a, task_b] >> task_c          # (A et B) → C

# Inverse
task_b << task_a                    # A puis B

# ═══════════════════════════════════════════════════════════════════════
# MÉTHODE 2: set_upstream / set_downstream
# ═══════════════════════════════════════════════════════════════════════

task_b.set_upstream(task_a)         # A puis B
task_a.set_downstream(task_b)       # A puis B
```

### Patterns courants

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    PATTERNS DE DÉPENDANCES                               │
│                                                                          │
│  1. LINÉAIRE:                                                           │
│     A ───► B ───► C                                                     │
│                                                                          │
│     task_a >> task_b >> task_c                                          │
│                                                                          │
│  ───────────────────────────────────────────────────────────────────    │
│                                                                          │
│  2. FAN-OUT (un vers plusieurs):                                        │
│           ┌───► B                                                       │
│     A ────┼───► C                                                       │
│           └───► D                                                       │
│                                                                          │
│     task_a >> [task_b, task_c, task_d]                                 │
│                                                                          │
│  ───────────────────────────────────────────────────────────────────    │
│                                                                          │
│  3. FAN-IN (plusieurs vers un):                                         │
│     A ────┐                                                             │
│     B ────┼───► D                                                       │
│     C ────┘                                                             │
│                                                                          │
│     [task_a, task_b, task_c] >> task_d                                 │
│                                                                          │
│  ───────────────────────────────────────────────────────────────────    │
│                                                                          │
│  4. DIAMANT:                                                            │
│           ┌───► B ───┐                                                  │
│     A ────┤         ├───► D                                             │
│           └───► C ───┘                                                  │
│                                                                          │
│     task_a >> [task_b, task_c] >> task_d                               │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Trigger Rules

```python
from airflow.utils.trigger_rule import TriggerRule

task = BashOperator(
    task_id='ma_tache',
    bash_command='echo "OK"',
    trigger_rule=TriggerRule.ALL_SUCCESS,  # Par défaut
)
```

| Trigger Rule | Comportement |
|--------------|--------------|
| `ALL_SUCCESS` | Exécute si TOUS les parents ont réussi (défaut) |
| `ALL_FAILED` | Exécute si TOUS les parents ont échoué |
| `ALL_DONE` | Exécute quand TOUS les parents sont terminés |
| `ONE_SUCCESS` | Exécute si AU MOINS UN parent a réussi |
| `ONE_FAILED` | Exécute si AU MOINS UN parent a échoué |
| `NONE_FAILED` | Exécute si AUCUN parent n'a échoué |
| `NONE_SKIPPED` | Exécute si AUCUN parent n'est skipped |
| `DUMMY` | Exécute toujours (ignore les dépendances) |

### Exemple avec Trigger Rules

```python
from airflow.utils.trigger_rule import TriggerRule

# Tâche de nettoyage qui s'exécute même si d'autres ont échoué
cleanup = BashOperator(
    task_id='cleanup',
    bash_command='rm -rf /tmp/work/*',
    trigger_rule=TriggerRule.ALL_DONE,
)

# Alerte qui s'exécute seulement si échec
alert = EmailOperator(
    task_id='send_alert',
    to='admin@company.com',
    subject='Pipeline Failed',
    trigger_rule=TriggerRule.ONE_FAILED,
)
```

---

## 7. 📬 XCom (Communication entre tâches)

### C'est quoi ?

XCom (Cross-Communication) permet aux tâches de **partager des données**.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         XCOM                                             │
│                                                                          │
│  Task A                                     Task B                       │
│  ┌─────────┐                               ┌─────────┐                  │
│  │         │  ───► xcom_push ───►  [DB]    │         │                  │
│  │ return  │       (clé, valeur)           │ xcom_pull│                  │
│  │ "data"  │                        │      │         │                  │
│  │         │                        └─────►│         │                  │
│  └─────────┘                               └─────────┘                  │
│                                                                          │
│  Les XComs sont stockés dans la Metadata Database                       │
│                                                                          │
│  ⚠️  ATTENTION: XCom pour PETITES données seulement!                   │
│      - Quelques KB max                                                  │
│      - PAS pour transférer des fichiers volumineux                     │
│      - Pour gros volumes → utiliser stockage externe (S3, HDFS)        │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Méthodes d'utilisation

```python
# ═══════════════════════════════════════════════════════════════════════
# MÉTHODE 1: Return implicite (TaskFlow API) - RECOMMANDÉ
# ═══════════════════════════════════════════════════════════════════════

@task()
def extract():
    data = {"users": 100, "orders": 500}
    return data  # Automatiquement poussé en XCom

@task()
def transform(data):  # Automatiquement récupéré
    return data["users"] * 2


# ═══════════════════════════════════════════════════════════════════════
# MÉTHODE 2: xcom_push / xcom_pull explicite
# ═══════════════════════════════════════════════════════════════════════

def push_function(**context):
    # Pousser une valeur
    context['ti'].xcom_push(key='my_key', value='my_value')

def pull_function(**context):
    # Récupérer une valeur
    value = context['ti'].xcom_pull(
        key='my_key', 
        task_ids='push_task'
    )
    print(f"Valeur récupérée: {value}")


# ═══════════════════════════════════════════════════════════════════════
# MÉTHODE 3: Templates Jinja
# ═══════════════════════════════════════════════════════════════════════

task = BashOperator(
    task_id='use_xcom',
    bash_command='echo "Valeur: {{ ti.xcom_pull(task_ids="extract") }}"',
)
```

### Bonnes pratiques XCom

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    BONNES PRATIQUES XCOM                                 │
│                                                                          │
│  ✅ DO:                                                                 │
│  - Passer des IDs, chemins de fichiers, métadonnées                    │
│  - Utiliser pour coordonner les tâches                                 │
│  - Données < quelques KB                                                │
│                                                                          │
│  ❌ DON'T:                                                              │
│  - Passer des DataFrames complets                                      │
│  - Transférer des fichiers                                             │
│  - Données > quelques KB                                                │
│                                                                          │
│  ALTERNATIVE pour gros volumes:                                         │
│  - Écrire dans S3/GCS/HDFS                                             │
│  - Passer le chemin via XCom                                           │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 8. 🔧 Variables et Connections

### Variables

Les **Variables** stockent des configurations globales.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    VARIABLES AIRFLOW                                     │
│                                                                          │
│  Stockées dans: Metadata Database                                       │
│  Accès via: UI (Admin > Variables) ou CLI                              │
│                                                                          │
│  Exemples:                                                              │
│  ┌────────────────────┬──────────────────────────────────┐             │
│  │ Clé                │ Valeur                           │             │
│  ├────────────────────┼──────────────────────────────────┤             │
│  │ env                │ production                       │             │
│  │ slack_webhook      │ https://hooks.slack.com/...      │             │
│  │ data_path          │ /data/warehouse/                 │             │
│  │ config_json        │ {"retries": 3, "timeout": 300}   │             │
│  └────────────────────┴──────────────────────────────────┘             │
│                                                                          │
│  ⚠️  Ne PAS stocker de secrets ici! Utiliser Connections              │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

```python
from airflow.models import Variable

# Récupérer une variable
my_value = Variable.get("my_var")

# Avec valeur par défaut
my_value = Variable.get("my_var", default_var="default")

# Variable JSON
my_json = Variable.get("config_json", deserialize_json=True)

# Dans un template Jinja
bash_command = 'echo "Env: {{ var.value.env }}"'
```

### Connections

Les **Connections** stockent les informations de connexion sécurisées.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    CONNECTIONS AIRFLOW                                   │
│                                                                          │
│  Stockées dans: Metadata Database (chiffrées)                           │
│  Accès via: UI (Admin > Connections) ou CLI                            │
│                                                                          │
│  Exemple Connection MySQL:                                              │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  Connection Id:    mysql_prod                                    │   │
│  │  Connection Type:  MySQL                                         │   │
│  │  Host:             db.example.com                               │   │
│  │  Schema:           analytics                                     │   │
│  │  Login:            etl_user                                      │   │
│  │  Password:         ********                                      │   │
│  │  Port:             3306                                          │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

```python
from airflow.hooks.base import BaseHook

# Récupérer une connection
conn = BaseHook.get_connection('mysql_prod')
print(conn.host)      # db.example.com
print(conn.login)     # etl_user
print(conn.password)  # le mot de passe

# Utiliser dans un opérateur
from airflow.providers.mysql.operators.mysql import MySqlOperator

query_task = MySqlOperator(
    task_id='run_query',
    mysql_conn_id='mysql_prod',  # Référence à la connection
    sql='SELECT * FROM users LIMIT 10;',
)
```

### Variables vs Connections

| Aspect | Variables | Connections |
|--------|-----------|-------------|
| **Usage** | Configuration générale | Credentials, accès DB/API |
| **Sécurité** | Non chiffrées | Chiffrées |
| **Secrets** | ❌ Non recommandé | ✅ Recommandé |
| **Exemples** | Chemins, flags, configs | DB, S3, APIs, SFTP |

---

## 9. 🔌 Operators principaux

### BashOperator

```python
from airflow.operators.bash import BashOperator

task = BashOperator(
    task_id='run_script',
    bash_command='python /scripts/etl.py',
)

# Avec template
task = BashOperator(
    task_id='process_date',
    bash_command='echo "Processing {{ ds }}"',
)
```

### PythonOperator

```python
from airflow.operators.python import PythonOperator

def my_function(name, **context):
    print(f"Hello {name}!")
    print(f"Execution date: {context['ds']}")
    return "Success"

task = PythonOperator(
    task_id='python_task',
    python_callable=my_function,
    op_kwargs={'name': 'World'},
)
```

### DummyOperator / EmptyOperator

```python
from airflow.operators.empty import EmptyOperator

# Point de départ ou de convergence
start = EmptyOperator(task_id='start')
end = EmptyOperator(task_id='end')

start >> [task_a, task_b, task_c] >> end
```

### BranchPythonOperator

```python
from airflow.operators.python import BranchPythonOperator

def choose_branch(**context):
    if context['ds_nodash'] > '20240101':
        return 'new_process'
    else:
        return 'old_process'

branch = BranchPythonOperator(
    task_id='branch',
    python_callable=choose_branch,
)

branch >> [new_process, old_process]
```

### Tableau des opérateurs courants

| Operator | Package | Usage |
|----------|---------|-------|
| `BashOperator` | airflow.operators.bash | Commandes shell |
| `PythonOperator` | airflow.operators.python | Fonctions Python |
| `EmptyOperator` | airflow.operators.empty | Placeholder/jonction |
| `BranchPythonOperator` | airflow.operators.python | Branchement conditionnel |
| `EmailOperator` | airflow.operators.email | Envoyer email |
| `MySqlOperator` | airflow.providers.mysql | Requêtes MySQL |
| `PostgresOperator` | airflow.providers.postgres | Requêtes PostgreSQL |
| `S3CreateBucketOperator` | airflow.providers.amazon | Créer bucket S3 |
| `SparkSubmitOperator` | airflow.providers.apache.spark | Soumettre job Spark |
| `HiveOperator` | airflow.providers.apache.hive | Requêtes Hive |
| `HttpOperator` | airflow.providers.http | Appels API HTTP |

---

## 10. 🖥 Interface Web (UI)

### Vues principales

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    INTERFACE WEB AIRFLOW                                 │
│                                                                          │
│  URL par défaut: http://localhost:8080                                  │
│                                                                          │
│  1. DAGs View (vue principale)                                          │
│     - Liste de tous les DAGs                                            │
│     - Toggle ON/OFF                                                     │
│     - Statut des derniers runs                                          │
│                                                                          │
│  2. Grid View (Airflow 2.3+)                                           │
│     - Vue grille des runs                                               │
│     - Statut de chaque tâche par run                                    │
│                                                                          │
│  3. Graph View                                                          │
│     - Visualisation graphique du DAG                                    │
│     - Dépendances entre tâches                                          │
│     - Statut en temps réel                                              │
│                                                                          │
│  4. Calendar View                                                       │
│     - Historique des runs par jour                                      │
│     - Vert = succès, Rouge = échec                                      │
│                                                                          │
│  5. Task Instance Details                                               │
│     - Logs de la tâche                                                  │
│     - XComs                                                             │
│     - Rendered template                                                 │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### États des tâches

| État | Couleur | Signification |
|------|---------|---------------|
| `success` | 🟢 Vert | Tâche réussie |
| `running` | 🟢 Vert clair | En cours d'exécution |
| `failed` | 🔴 Rouge | Échec |
| `upstream_failed` | 🟠 Orange | Un parent a échoué |
| `skipped` | 🩷 Rose | Ignorée (condition non remplie) |
| `queued` | ⬜ Gris | En attente d'exécution |
| `no_status` | ⬜ Gris clair | Pas encore planifiée |
| `up_for_retry` | 🟡 Jaune | En attente de retry |
| `up_for_reschedule` | 🔵 Turquoise | Sensor en attente |

### Actions dans l'UI

| Action | Description |
|--------|-------------|
| **Trigger DAG** | Déclencher manuellement un run |
| **Clear** | Effacer l'état pour re-exécuter |
| **Mark Success** | Marquer comme réussi |
| **Mark Failed** | Marquer comme échoué |
| **Pause/Unpause** | Activer/désactiver le DAG |

---

## 11. 💻 Commandes CLI essentielles

### Gestion des DAGs

```bash
# ═══════════════════════════════════════════════════════════════════════
#                    GESTION DES DAGs
# ═══════════════════════════════════════════════════════════════════════

# Lister tous les DAGs
airflow dags list

# Afficher les infos d'un DAG
airflow dags show mon_dag

# Lister les tâches d'un DAG
airflow tasks list mon_dag

# Mettre en pause / activer un DAG
airflow dags pause mon_dag
airflow dags unpause mon_dag

# Déclencher un DAG manuellement
airflow dags trigger mon_dag

# Déclencher avec paramètres
airflow dags trigger mon_dag --conf '{"key": "value"}'

# Backfill (exécuter pour une période passée)
airflow dags backfill mon_dag \
    --start-date 2024-01-01 \
    --end-date 2024-01-31

# Tester le parsing d'un DAG
airflow dags test mon_dag 2024-01-01

# Voir les erreurs d'import
airflow dags list-import-errors
```

### Gestion des tâches

```bash
# ═══════════════════════════════════════════════════════════════════════
#                    GESTION DES TÂCHES
# ═══════════════════════════════════════════════════════════════════════

# Tester une tâche (sans enregistrer dans DB)
airflow tasks test mon_dag ma_tache 2024-01-01

# Exécuter une tâche (enregistre dans DB)
airflow tasks run mon_dag ma_tache 2024-01-01

# Voir l'état d'une tâche
airflow tasks state mon_dag ma_tache 2024-01-01

# Effacer l'état pour re-exécuter
airflow tasks clear mon_dag \
    -t ma_tache \
    -s 2024-01-01 \
    -e 2024-01-31

# Voir le rendu d'un template
airflow tasks render mon_dag ma_tache 2024-01-01
```

### Variables et Connections

```bash
# ═══════════════════════════════════════════════════════════════════════
#                    VARIABLES
# ═══════════════════════════════════════════════════════════════════════

airflow variables list
airflow variables get my_var
airflow variables set my_var "my_value"
airflow variables delete my_var
airflow variables import variables.json
airflow variables export variables.json

# ═══════════════════════════════════════════════════════════════════════
#                    CONNECTIONS
# ═══════════════════════════════════════════════════════════════════════

airflow connections list
airflow connections get mysql_prod

# Ajouter une connection
airflow connections add 'mysql_prod' \
    --conn-type 'mysql' \
    --conn-host 'localhost' \
    --conn-login 'user' \
    --conn-password 'pass' \
    --conn-port 3306 \
    --conn-schema 'mydb'

airflow connections delete mysql_prod
```

### Administration

```bash
# ═══════════════════════════════════════════════════════════════════════
#                    ADMINISTRATION
# ═══════════════════════════════════════════════════════════════════════

# Démarrer les services
airflow webserver -p 8080 -D    # -D pour daemon (background)
airflow scheduler -D

# Base de données
airflow db init        # Initialiser la DB
airflow db upgrade     # Mettre à jour le schéma
airflow db check       # Vérifier la connexion

# Créer un utilisateur admin
airflow users create \
    --username admin \
    --firstname Admin \
    --lastname User \
    --role Admin \
    --email admin@example.com \
    --password admin123

# Informations système
airflow info
airflow version
airflow config list

# Nettoyer les vieilles données
airflow db clean --clean-before-timestamp "2024-01-01"
```

---

## 12. 🧪 Tests et Debugging

### Tester un DAG localement

```bash
# ═══════════════════════════════════════════════════════════════════════
#                    WORKFLOW DE TEST
# ═══════════════════════════════════════════════════════════════════════

# 1. Vérifier que le DAG parse correctement
python dags/mon_dag.py

# 2. Lister les DAGs pour voir s'il apparaît
airflow dags list | grep mon_dag

# 3. Voir les erreurs d'import
airflow dags list-import-errors

# 4. Tester une tâche individuellement
airflow tasks test mon_dag extract_task 2024-01-01

# 5. Tester avec logs détaillés
airflow tasks test mon_dag extract_task 2024-01-01 --verbose
```

### Debugging courant

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    DEBUGGING AIRFLOW                                     │
│                                                                          │
│  PROBLÈME: DAG n'apparaît pas dans l'UI                                │
│  ─────────────────────────────────────────                              │
│  1. Vérifier syntaxe Python: python dags/mon_dag.py                    │
│  2. Vérifier le dossier: AIRFLOW_HOME/dags/                            │
│  3. Chercher erreurs: airflow dags list-import-errors                  │
│  4. Vérifier start_date (doit être dans le passé)                      │
│  5. Vérifier que le fichier contient "DAG" ou "@dag"                   │
│                                                                          │
│  ───────────────────────────────────────────────────────────────────    │
│                                                                          │
│  PROBLÈME: Tâche ne s'exécute pas                                      │
│  ──────────────────────────────────                                     │
│  1. DAG est-il "unpaused"? (toggle ON dans UI)                        │
│  2. Scheduler tourne? (airflow scheduler)                              │
│  3. Executor configuré correctement?                                    │
│  4. Dépendances satisfaites? (parents réussis?)                        │
│  5. start_date dans le futur?                                          │
│                                                                          │
│  ───────────────────────────────────────────────────────────────────    │
│                                                                          │
│  PROBLÈME: Tâche échoue                                                │
│  ──────────────────────                                                 │
│  1. Voir les LOGS dans l'UI (Task Instance > Logs)                     │
│  2. Tester localement: airflow tasks test dag task date                │
│  3. Vérifier les connections/variables                                  │
│  4. Vérifier les permissions fichiers                                   │
│  5. Vérifier les dépendances Python                                    │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Fichiers de logs

```bash
# Emplacement des logs (par défaut)
$AIRFLOW_HOME/logs/

# Structure
logs/
├── dag_id/
│   └── task_id/
│       └── 2024-01-01T00:00:00+00:00/
│           └── 1.log
├── scheduler/
│   └── latest -> 2024-01-01/
└── webserver/
```

---

## 13. ✅ Bonnes pratiques

### Structure de projet

```
airflow_project/
├── dags/
│   ├── __init__.py
│   ├── etl_daily.py
│   ├── ml_pipeline.py
│   └── utils/
│       ├── __init__.py
│       └── helpers.py
├── plugins/
│   └── custom_operators.py
├── tests/
│   ├── test_dags.py
│   └── test_tasks.py
├── requirements.txt
├── docker-compose.yml
└── airflow.cfg
```

### Do's and Don'ts

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    BONNES PRATIQUES                                      │
│                                                                          │
│  ✅ DO:                                                                 │
│  ─────                                                                   │
│  - Utiliser des task_id descriptifs et uniques                         │
│  - Mettre catchup=False sauf besoin spécifique                         │
│  - Définir des retries et retry_delay                                   │
│  - Utiliser des Connections pour les credentials                        │
│  - Garder les DAGs simples et modulaires                               │
│  - Utiliser des tags pour organiser les DAGs                           │
│  - Tester les DAGs avant déploiement                                    │
│  - Documenter avec description et doc_md                               │
│  - Utiliser des templates Jinja pour les dates                         │
│                                                                          │
│  ❌ DON'T:                                                              │
│  ──────                                                                  │
│  - Mettre de la logique lourde au top-level du DAG                     │
│  - Stocker des secrets dans Variables                                   │
│  - Créer des DAGs avec trop de tâches (>100)                           │
│  - Utiliser XCom pour de gros volumes de données                       │
│  - Hardcoder des dates (utiliser {{ ds }})                             │
│  - Ignorer les logs et monitoring                                       │
│  - Faire depends_on_past=True sans raison                              │
│  - Oublier de mettre start_date                                        │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Templates Jinja utiles

```python
task = BashOperator(
    task_id='templated_task',
    bash_command='''
        echo "Date: {{ ds }}"
        echo "Sans tirets: {{ ds_nodash }}"
        echo "Fichier: /data/{{ ds }}/file.csv"
    ''',
)
```

| Template | Exemple | Description |
|----------|---------|-------------|
| `{{ ds }}` | 2024-01-15 | Date (YYYY-MM-DD) |
| `{{ ds_nodash }}` | 20240115 | Date sans tirets |
| `{{ ts }}` | 2024-01-15T00:00:00 | Timestamp |
| `{{ execution_date }}` | objet datetime | Datetime complet |
| `{{ prev_ds }}` | 2024-01-14 | Date précédente |
| `{{ next_ds }}` | 2024-01-16 | Date suivante |
| `{{ dag.dag_id }}` | mon_dag | ID du DAG |
| `{{ task.task_id }}` | ma_tache | ID de la tâche |
| `{{ var.value.my_var }}` | valeur | Variable Airflow |
| `{{ conn.my_conn.host }}` | hostname | Connection |

---

## 14. ❌ Erreurs courantes

| Erreur | Cause probable | Solution |
|--------|----------------|----------|
| `DAG not found` | Erreur syntaxe ou mauvais dossier | `python dag.py`, vérifier AIRFLOW_HOME |
| `Task is not running` | Scheduler down ou DAG paused | Vérifier scheduler, unpause DAG |
| `Broken DAG` | Erreur d'import Python | `airflow dags list-import-errors` |
| `Connection not found` | Connection ID incorrect | Vérifier Admin > Connections |
| `Variable not found` | Variable inexistante | Créer via UI ou CLI |
| `Zombie task` | Task stuck, worker mort | Clear task, redémarrer worker |
| `Scheduler not picking up` | Fichier pas dans dags folder | Vérifier chemin, permissions |
| `XCom too large` | Données trop volumineuses | Utiliser S3/GCS |
| `No module named` | Dépendance manquante | `pip install ...` |
| `Slot pool full` | Trop de tâches parallèles | Augmenter pool ou réduire concurrence |

### Procédure de diagnostic

```bash
# 1. Vérifier les services
ps aux | grep airflow

# 2. Vérifier les erreurs d'import
airflow dags list-import-errors

# 3. Tester le DAG
python dags/mon_dag.py
airflow dags test mon_dag 2024-01-01

# 4. Tester une tâche
airflow tasks test mon_dag ma_tache 2024-01-01

# 5. Voir les logs
tail -f $AIRFLOW_HOME/logs/scheduler/latest/*.log
```

---

## 15. 📋 Checklist Entretien Junior

```
┌─────────────────────────────────────────────────────────────────────────┐
│              AIRFLOW - CE QUE TU DOIS SAVOIR                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│ CONCEPTS DE BASE:                                                       │
│ □ Airflow = Orchestrateur de workflows                                 │
│ □ DAG = Directed Acyclic Graph (workflow sans cycles)                  │
│ □ Task = Une étape dans le DAG                                          │
│ □ Operator = Type de tâche (Bash, Python, SQL...)                      │
│                                                                          │
│ ARCHITECTURE:                                                           │
│ □ Web Server = Interface UI (port 8080)                                 │
│ □ Scheduler = Parse et planifie les DAGs                               │
│ □ Executor = Exécute les tâches                                        │
│ □ Metadata DB = Stocke l'état (PostgreSQL recommandé)                  │
│                                                                          │
│ EXECUTORS:                                                              │
│ □ SequentialExecutor = Dev uniquement, 1 tâche à la fois              │
│ □ LocalExecutor = Prod simple, parallèle sur 1 machine                 │
│ □ CeleryExecutor = Prod distribuée, plusieurs workers                  │
│ □ KubernetesExecutor = Cloud-native, pods K8s                         │
│                                                                          │
│ SCHEDULING:                                                             │
│ □ Cron: "minute heure jour mois jour_semaine"                          │
│ □ Exemple: "0 6 * * *" = tous les jours à 6h                           │
│ □ Presets: @daily, @hourly, @weekly, @monthly                          │
│ □ execution_date = début de l'intervalle de données                    │
│ □ catchup=False recommandé                                             │
│                                                                          │
│ DÉPENDANCES:                                                            │
│ □ Syntaxe: task_a >> task_b >> task_c                                  │
│ □ Fan-out: task_a >> [task_b, task_c]                                  │
│ □ Fan-in: [task_a, task_b] >> task_c                                   │
│ □ Trigger Rules: ALL_SUCCESS, ONE_FAILED, ALL_DONE                     │
│                                                                          │
│ COMMUNICATION:                                                          │
│ □ XCom = Partage de PETITES données entre tâches                       │
│ □ Variables = Configuration globale (pas de secrets!)                  │
│ □ Connections = Credentials sécurisés (host, login, password)          │
│                                                                          │
│ COMMANDES CLI:                                                          │
│ □ airflow dags list                                                     │
│ □ airflow dags trigger mon_dag                                         │
│ □ airflow tasks test mon_dag task 2024-01-01                          │
│ □ airflow dags list-import-errors                                      │
│                                                                          │
│ BONNES PRATIQUES:                                                       │
│ □ catchup=False par défaut                                             │
│ □ Retries et retry_delay configurés                                    │
│ □ Secrets dans Connections, pas Variables                              │
│ □ XCom pour petites données seulement                                  │
│ □ Templates Jinja pour les dates {{ ds }}                              │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 16. 🎯 Questions d'entretien types

| Question | Points clés à mentionner |
|----------|-------------------------|
| C'est quoi Airflow ? | Orchestrateur de workflows, planification, monitoring, DAGs Python |
| C'est quoi un DAG ? | Directed Acyclic Graph, workflow sans cycles, définit les dépendances |
| Différence DAG/Task/Operator ? | DAG = workflow, Task = étape, Operator = type de tâche |
| Composants principaux ? | Web Server (UI), Scheduler (planifie), Executor (exécute), Metadata DB |
| Différence entre Executors ? | Sequential (dev), Local (1 machine), Celery (distribué), K8s (cloud) |
| C'est quoi XCom ? | Communication entre tâches, petites données seulement |
| Comment définir les dépendances ? | `>>` ou `<<`, ou set_upstream/downstream |
| Qu'est-ce que catchup ? | Exécuter les runs manqués depuis start_date |
| Comment débugger un DAG ? | `python dag.py`, `airflow tasks test`, `list-import-errors`, logs UI |
| Où stocker les credentials ? | Connections (pas Variables!) |
| Comment re-exécuter une tâche ? | Clear dans l'UI ou `airflow tasks clear` |
| C'est quoi les Trigger Rules ? | Conditions pour exécuter une tâche (ALL_SUCCESS, ONE_FAILED, etc.) |

---

## 17. 🎯 Résumé en une page

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                        AIRFLOW EN BREF                                     ║
╠═══════════════════════════════════════════════════════════════════════════╣
║                                                                            ║
║  DÉFINITION:   Orchestrateur de workflows (planification + monitoring)    ║
║                                                                            ║
║  CONCEPTS:     DAG (workflow) → Tasks (étapes) → Operators (types)        ║
║                                                                            ║
║  ARCHITECTURE: Web Server + Scheduler + Executor + Metadata DB            ║
║                                                                            ║
║  EXECUTORS:    Sequential (dev) | Local (petit) | Celery (prod)          ║
║                                                                            ║
║  SCHEDULING:   Cron "0 6 * * *" ou presets @daily, @hourly                ║
║                                                                            ║
║  DÉPENDANCES:  task_a >> task_b >> task_c                                 ║
║                task_a >> [task_b, task_c] (parallèle)                     ║
║                                                                            ║
║  COMMUNICATION: XCom (petites données), Variables, Connections            ║
║                                                                            ║
║  CLI:          dags list | dags trigger | tasks test | tasks clear        ║
║                                                                            ║
║  DEBUG:        python dag.py                                              ║
║                airflow tasks test dag task date                           ║
║                airflow dags list-import-errors                            ║
║                                                                            ║
║  ⚠️  XCom = petites données seulement                                     ║
║  ⚠️  Credentials dans Connections, pas Variables                          ║
║  ⚠️  catchup=False recommandé par défaut                                  ║
║                                                                            ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

---

> **Bonne chance pour ton entretien !** 🚀