# 📚 Résumé Complet Bases de Données Big Data - Guide Junior

> **Objectif** : Tout ce qu'un Ingénieur Support & Intégration Junior Big Data doit savoir sur PostgreSQL (SQL) et Cassandra (NoSQL)

---

## Table des matières

### Partie 1 : Fondamentaux
1. [SQL vs NoSQL - Vue d'ensemble](#1--sql-vs-nosql---vue-densemble)
2. [Théorème CAP](#2--théorème-cap)
3. [ACID vs BASE](#3--acid-vs-base)

### Partie 2 : PostgreSQL (SQL)
4. [PostgreSQL - Vue d'ensemble](#4--postgresql---vue-densemble)
5. [PostgreSQL - Architecture](#5--postgresql---architecture)
6. [PostgreSQL - Types de données](#6--postgresql---types-de-données)
7. [PostgreSQL - Commandes SQL essentielles](#7--postgresql---commandes-sql-essentielles)
8. [PostgreSQL - Index et Performance](#8--postgresql---index-et-performance)
9. [PostgreSQL - Administration](#9--postgresql---administration)

### Partie 3 : Cassandra (NoSQL)
10. [Cassandra - Vue d'ensemble](#10--cassandra---vue-densemble)
11. [Cassandra - Architecture](#11--cassandra---architecture)
12. [Cassandra - Modèle de données](#12--cassandra---modèle-de-données)
13. [Cassandra - CQL (Cassandra Query Language)](#13--cassandra---cql)
14. [Cassandra - Partitionnement et Réplication](#14--cassandra---partitionnement-et-réplication)
15. [Cassandra - Consistency Levels](#15--cassandra---consistency-levels)
16. [Cassandra - Administration](#16--cassandra---administration)

### Partie 4 : Comparaisons et Synthèse
17. [PostgreSQL vs Cassandra](#17--postgresql-vs-cassandra)
18. [Quand utiliser quoi ?](#18--quand-utiliser-quoi)
19. [Autres bases Big Data](#19--autres-bases-big-data)
20. [Checklist Entretien Junior](#20--checklist-entretien-junior)

---

# PARTIE 1 : FONDAMENTAUX

---

## 1. 🔄 SQL vs NoSQL - Vue d'ensemble

### Différences fondamentales

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      SQL vs NoSQL                                        │
│                                                                          │
│  SQL (Relationnel)                 NoSQL (Non-Relationnel)              │
│  ─────────────────                 ────────────────────────              │
│                                                                          │
│  ┌─────────────────┐               ┌─────────────────────┐              │
│  │     Tables      │               │  Documents / Clés   │              │
│  │  ┌───┬───┬───┐  │               │  ┌─────────────────┐│              │
│  │  │id │nom│age│  │               │  │ { "id": 1,      ││              │
│  │  ├───┼───┼───┤  │               │  │   "nom": "Ali", ││              │
│  │  │ 1 │Ali│25 │  │               │  │   "age": 25 }   ││              │
│  │  │ 2 │Sara│30│  │               │  └─────────────────┘│              │
│  │  └───┴───┴───┘  │               │                     │              │
│  └─────────────────┘               └─────────────────────┘              │
│                                                                          │
│  - Schéma FIXE                     - Schéma FLEXIBLE                    │
│  - Relations (JOIN)                - Pas de JOIN (dénormalisé)          │
│  - ACID                            - BASE (eventual consistency)         │
│  - Scaling VERTICAL                - Scaling HORIZONTAL                  │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Tableau comparatif

| Critère | SQL | NoSQL |
|---------|-----|-------|
| **Structure** | Tables avec lignes et colonnes | Documents, clé-valeur, colonnes, graphes |
| **Schéma** | Fixe, défini à l'avance | Flexible, dynamique |
| **Relations** | JOINs entre tables | Données dénormalisées |
| **Transactions** | ACID (fort) | BASE (eventual consistency) |
| **Scaling** | Vertical (plus de RAM/CPU) | Horizontal (plus de serveurs) |
| **Requêtes** | SQL standardisé | Langage spécifique (CQL, API) |
| **Exemples** | PostgreSQL, MySQL, Oracle | Cassandra, MongoDB, Redis |

### Types de bases NoSQL

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    TYPES DE BASES NoSQL                                  │
│                                                                          │
│  1. DOCUMENT (MongoDB, CouchDB)                                         │
│     ┌─────────────────────────────────────────┐                         │
│     │  { "id": 1, "nom": "Ali", "age": 25,   │                         │
│     │    "adresse": { "ville": "Tunis" } }   │                         │
│     └─────────────────────────────────────────┘                         │
│     → Documents JSON flexibles                                          │
│                                                                          │
│  2. CLÉ-VALEUR (Redis, DynamoDB)                                       │
│     ┌──────────────┬──────────────────────────┐                         │
│     │ user:1       │ {"nom": "Ali", "age": 25}│                         │
│     │ session:abc  │ {"token": "xyz123"}      │                         │
│     └──────────────┴──────────────────────────┘                         │
│     → Accès ultra-rapide par clé                                        │
│                                                                          │
│  3. COLONNE (Cassandra, HBase)                                          │
│     ┌──────────────────────────────────────────┐                        │
│     │ Row Key │ name:Ali │ age:25 │ city:Tunis │                        │
│     └──────────────────────────────────────────┘                        │
│     → Optimisé pour écriture massive                                    │
│                                                                          │
│  4. GRAPHE (Neo4j, Amazon Neptune)                                      │
│     (Ali)──[KNOWS]──>(Sara)──[WORKS_AT]──>(Company)                    │
│     → Relations complexes entre entités                                 │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 2. 📐 Théorème CAP

### Concept

```
┌─────────────────────────────────────────────────────────────────────────┐
│                       THÉORÈME CAP                                       │
│                                                                          │
│  Dans un système distribué, tu peux avoir seulement 2 sur 3:           │
│                                                                          │
│                         C                                                │
│                    (Consistency)                                         │
│                        /\                                                │
│                       /  \                                               │
│                      /    \                                              │
│                     /      \                                             │
│                    /   CA   \                                            │
│                   /          \                                           │
│                  /            \                                          │
│                 /______________\                                         │
│                A                P                                        │
│         (Availability)    (Partition                                     │
│                            Tolerance)                                    │
│                                                                          │
│  C = Consistency    : Tous les nœuds voient les mêmes données          │
│  A = Availability   : Le système répond toujours                        │
│  P = Partition Tol. : Fonctionne malgré panne réseau                   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Choix des bases de données

| Type | Privilégie | Sacrifie | Exemples |
|------|------------|----------|----------|
| **CP** | Consistency + Partition | Availability | MongoDB, HBase, Redis |
| **AP** | Availability + Partition | Consistency | Cassandra, CouchDB, DynamoDB |
| **CA** | Consistency + Availability | Partition | PostgreSQL, MySQL (single node) |

### Cassandra = AP

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    CASSANDRA = AP                                        │
│                                                                          │
│  Cassandra privilégie:                                                  │
│  ✅ Availability (toujours disponible)                                  │
│  ✅ Partition Tolerance (tolère les pannes réseau)                     │
│  ⚠️  Consistency (eventual consistency - configurable)                  │
│                                                                          │
│  → Les données peuvent être temporairement incohérentes                │
│  → Mais le système reste TOUJOURS disponible                           │
│  → Consistency Level configurable par requête                          │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 3. 🔒 ACID vs BASE

### ACID (SQL - PostgreSQL)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         ACID                                             │
│                                                                          │
│  A = Atomicity (Atomicité)                                              │
│      → Transaction complète ou pas du tout                              │
│      → Pas d'état intermédiaire                                         │
│                                                                          │
│  C = Consistency (Cohérence)                                            │
│      → La DB passe d'un état valide à un autre état valide             │
│      → Contraintes respectées                                           │
│                                                                          │
│  I = Isolation                                                          │
│      → Transactions concurrentes isolées les unes des autres           │
│      → Comme si elles s'exécutaient séquentiellement                   │
│                                                                          │
│  D = Durability (Durabilité)                                           │
│      → Une fois commitée, la transaction est permanente                │
│      → Même en cas de crash                                             │
│                                                                          │
│  EXEMPLE:                                                               │
│  Transfert bancaire: débiter compte A ET créditer compte B             │
│  → Les deux ou aucun (Atomicity)                                       │
│  → Solde total inchangé (Consistency)                                  │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### BASE (NoSQL - Cassandra)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         BASE                                             │
│                                                                          │
│  BA = Basically Available                                               │
│       → Le système est toujours disponible                              │
│       → Peut retourner des données "stale" (pas à jour)                │
│                                                                          │
│  S = Soft state                                                         │
│      → L'état peut changer avec le temps                               │
│      → Même sans nouvelles entrées (propagation)                       │
│                                                                          │
│  E = Eventual consistency                                               │
│      → Les données seront cohérentes... éventuellement                 │
│      → Pas immédiatement, mais après propagation                       │
│                                                                          │
│  EXEMPLE:                                                               │
│  Like sur Facebook:                                                     │
│  → Tu vois 100 likes, ton ami voit 99 pendant quelques secondes       │
│  → Pas grave, ça se synchronise                                        │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Comparaison ACID vs BASE

| Aspect | ACID | BASE |
|--------|------|------|
| **Priorité** | Cohérence des données | Disponibilité |
| **Transactions** | Fortes garanties | Garanties faibles |
| **Performance** | Plus lent (locks) | Plus rapide |
| **Scaling** | Difficile | Facile |
| **Cas d'usage** | Banque, finance | Social media, IoT |

---

# PARTIE 2 : POSTGRESQL (SQL)

---

## 4. 🐘 PostgreSQL - Vue d'ensemble

### C'est quoi ?

PostgreSQL est une base de données **relationnelle** open-source, connue pour sa robustesse, sa conformité SQL et ses fonctionnalités avancées.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                       POSTGRESQL                                         │
│                                                                          │
│  - Base de données relationnelle (SQL)                                  │
│  - Open-source, gratuit                                                 │
│  - ACID compliant                                                       │
│  - Très riche en fonctionnalités                                        │
│  - Extensible (types custom, fonctions, extensions)                    │
│  - Support JSON (NoSQL-like features)                                   │
│                                                                          │
│  UTILISÉ PAR: Apple, Instagram, Spotify, Reddit, NASA                  │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Caractéristiques principales

| Caractéristique | Description |
|-----------------|-------------|
| **ACID** | Transactions fiables |
| **MVCC** | Multi-Version Concurrency Control |
| **JSON/JSONB** | Support données semi-structurées |
| **Full-text search** | Recherche texte intégrée |
| **Extensions** | PostGIS, TimescaleDB, etc. |
| **Réplication** | Streaming, logical |
| **Partitioning** | Tables partitionnées |

### PostgreSQL dans le Big Data

```
┌─────────────────────────────────────────────────────────────────────────┐
│              POSTGRESQL DANS L'ÉCOSYSTÈME BIG DATA                       │
│                                                                          │
│  PostgreSQL peut servir de:                                             │
│                                                                          │
│  1. SOURCE DE DONNÉES                                                   │
│     PostgreSQL ──► Kafka ──► Spark ──► Data Lake                       │
│                                                                          │
│  2. DATA WAREHOUSE (petite/moyenne échelle)                            │
│     ETL ──► PostgreSQL (avec partitioning)                             │
│                                                                          │
│  3. METASTORE                                                           │
│     Airflow Metadata DB                                                 │
│     Hive Metastore                                                      │
│                                                                          │
│  4. SERVING LAYER                                                       │
│     Data Lake ──► PostgreSQL ──► Application                           │
│                                                                          │
│  LIMITATIONS:                                                           │
│  - Scaling horizontal difficile                                         │
│  - Pas conçu pour pétabytes                                            │
│  - Pour très gros volumes → Cassandra, BigQuery, Redshift              │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 5. 🏗 PostgreSQL - Architecture

### Composants principaux

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   ARCHITECTURE POSTGRESQL                                │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                        CLIENT                                    │   │
│  │                   (psql, application)                            │   │
│  └────────────────────────────┬────────────────────────────────────┘   │
│                               │                                         │
│                               ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                     POSTMASTER                                   │   │
│  │              (Processus principal)                               │   │
│  │         Gère les connexions, fork les backends                  │   │
│  └────────────────────────────┬────────────────────────────────────┘   │
│                               │                                         │
│         ┌─────────────────────┼─────────────────────┐                  │
│         │                     │                     │                  │
│         ▼                     ▼                     ▼                  │
│  ┌─────────────┐       ┌─────────────┐       ┌─────────────┐          │
│  │  Backend 1  │       │  Backend 2  │       │  Backend N  │          │
│  │ (1 par conn)│       │ (1 par conn)│       │ (1 par conn)│          │
│  └─────────────┘       └─────────────┘       └─────────────┘          │
│         │                     │                     │                  │
│         └─────────────────────┼─────────────────────┘                  │
│                               │                                         │
│                               ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    SHARED MEMORY                                 │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │   │
│  │  │Shared Buffers│  │   WAL Buffer │  │  Lock Tables │          │   │
│  │  │   (cache)    │  │              │  │              │          │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘          │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                               │                                         │
│                               ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                       STOCKAGE                                   │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │   │
│  │  │  Data Files  │  │   WAL Files  │  │  Log Files   │          │   │
│  │  │  (tables)    │  │ (journaling) │  │              │          │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘          │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Composants clés

| Composant | Rôle |
|-----------|------|
| **Postmaster** | Processus principal, gère les connexions |
| **Backend** | Un processus par connexion client |
| **Shared Buffers** | Cache des données en mémoire |
| **WAL (Write-Ahead Log)** | Journal pour durabilité et réplication |
| **Background Writer** | Écrit les pages modifiées sur disque |
| **Checkpointer** | Crée des points de récupération |
| **Autovacuum** | Nettoie les tuples morts (MVCC) |

### Structure des données

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   STRUCTURE DES DONNÉES                                  │
│                                                                          │
│  Cluster PostgreSQL                                                     │
│  └── Database (analytics)                                               │
│      ├── Schema (public)                                                │
│      │   ├── Table (users)                                              │
│      │   │   ├── Colonnes (id, name, email)                            │
│      │   │   ├── Index                                                  │
│      │   │   └── Contraintes                                            │
│      │   ├── Table (orders)                                             │
│      │   └── View (user_summary)                                        │
│      └── Schema (staging)                                               │
│          └── Table (raw_data)                                           │
│                                                                          │
│  1 Cluster = N Databases                                                │
│  1 Database = N Schemas                                                 │
│  1 Schema = N Tables, Views, Functions                                  │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 6. 📊 PostgreSQL - Types de données

### Types principaux

| Catégorie | Types | Exemples |
|-----------|-------|----------|
| **Numérique** | INTEGER, BIGINT, DECIMAL, FLOAT | `age INTEGER`, `price DECIMAL(10,2)` |
| **Texte** | VARCHAR, TEXT, CHAR | `name VARCHAR(100)`, `bio TEXT` |
| **Date/Heure** | DATE, TIME, TIMESTAMP, INTERVAL | `created_at TIMESTAMP` |
| **Booléen** | BOOLEAN | `is_active BOOLEAN` |
| **JSON** | JSON, JSONB | `metadata JSONB` |
| **Array** | INTEGER[], TEXT[] | `tags TEXT[]` |
| **UUID** | UUID | `id UUID DEFAULT gen_random_uuid()` |
| **Géo** | POINT, LINE, POLYGON (PostGIS) | `location POINT` |

### JSON vs JSONB

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      JSON vs JSONB                                       │
│                                                                          │
│  JSON:                                                                  │
│  - Stocké comme texte                                                   │
│  - Préserve l'ordre et les espaces                                     │
│  - Parsing à chaque lecture                                             │
│  - Plus lent pour les requêtes                                          │
│                                                                          │
│  JSONB (recommandé):                                                    │
│  - Stocké en format binaire                                             │
│  - Pas d'ordre préservé                                                 │
│  - Parsing une seule fois à l'écriture                                 │
│  - Plus rapide pour les requêtes                                        │
│  - Supporte les INDEX                                                   │
│                                                                          │
│  → Utilise JSONB sauf besoin spécifique de préserver le format         │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 7. 💻 PostgreSQL - Commandes SQL essentielles

### Connexion

```bash
# Se connecter à PostgreSQL
psql -h localhost -U postgres -d mydb

# Ou avec URL
psql postgresql://user:password@localhost:5432/mydb
```

### Commandes psql

```sql
-- Commandes méta (dans psql)
\l              -- Lister les bases de données
\c mydb         -- Se connecter à une base
\dt             -- Lister les tables
\d users        -- Décrire une table
\di             -- Lister les index
\df             -- Lister les fonctions
\du             -- Lister les utilisateurs
\q              -- Quitter
\?              -- Aide
```

### DDL (Data Definition Language)

```sql
-- ═══════════════════════════════════════════════════════════════════════
--                    CRÉATION DE BASE ET TABLES
-- ═══════════════════════════════════════════════════════════════════════

-- Créer une base de données
CREATE DATABASE analytics;

-- Créer un schéma
CREATE SCHEMA IF NOT EXISTS staging;

-- Créer une table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    age INTEGER CHECK (age >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metadata JSONB
);

-- Créer une table avec clé étrangère
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Modifier une table
ALTER TABLE users ADD COLUMN phone VARCHAR(20);
ALTER TABLE users DROP COLUMN phone;
ALTER TABLE users ALTER COLUMN name TYPE VARCHAR(200);

-- Supprimer
DROP TABLE IF EXISTS orders;
DROP DATABASE analytics;
```

### DML (Data Manipulation Language)

```sql
-- ═══════════════════════════════════════════════════════════════════════
--                    INSERT
-- ═══════════════════════════════════════════════════════════════════════

-- Insérer une ligne
INSERT INTO users (name, email, age) 
VALUES ('Ali', 'ali@example.com', 25);

-- Insérer plusieurs lignes
INSERT INTO users (name, email, age) VALUES
    ('Sara', 'sara@example.com', 30),
    ('Omar', 'omar@example.com', 28);

-- Insert avec retour
INSERT INTO users (name, email, age) 
VALUES ('Fatima', 'fatima@example.com', 22)
RETURNING id, name;

-- Insert ou update (UPSERT)
INSERT INTO users (id, name, email, age)
VALUES (1, 'Ali Updated', 'ali@example.com', 26)
ON CONFLICT (id) 
DO UPDATE SET name = EXCLUDED.name, age = EXCLUDED.age;


-- ═══════════════════════════════════════════════════════════════════════
--                    SELECT
-- ═══════════════════════════════════════════════════════════════════════

-- Sélection simple
SELECT * FROM users;
SELECT name, email FROM users WHERE age > 25;

-- Avec alias
SELECT name AS nom, age AS age_utilisateur FROM users;

-- Filtres
SELECT * FROM users 
WHERE age BETWEEN 20 AND 30 
  AND email LIKE '%@example.com';

-- Tri et limite
SELECT * FROM users ORDER BY created_at DESC LIMIT 10;

-- Agrégations
SELECT 
    COUNT(*) as total,
    AVG(age) as age_moyen,
    MIN(age) as age_min,
    MAX(age) as age_max
FROM users;

-- Group By
SELECT 
    status, 
    COUNT(*) as count,
    SUM(amount) as total
FROM orders 
GROUP BY status
HAVING COUNT(*) > 5;


-- ═══════════════════════════════════════════════════════════════════════
--                    JOINS
-- ═══════════════════════════════════════════════════════════════════════

-- INNER JOIN (intersection)
SELECT u.name, o.amount, o.status
FROM users u
INNER JOIN orders o ON u.id = o.user_id;

-- LEFT JOIN (tous les users, même sans orders)
SELECT u.name, o.amount
FROM users u
LEFT JOIN orders o ON u.id = o.user_id;

-- RIGHT JOIN (tous les orders, même sans users)
SELECT u.name, o.amount
FROM users u
RIGHT JOIN orders o ON u.id = o.user_id;

-- FULL OUTER JOIN (tous les deux)
SELECT u.name, o.amount
FROM users u
FULL OUTER JOIN orders o ON u.id = o.user_id;


-- ═══════════════════════════════════════════════════════════════════════
--                    UPDATE ET DELETE
-- ═══════════════════════════════════════════════════════════════════════

-- Update
UPDATE users SET age = 26 WHERE name = 'Ali';
UPDATE orders SET status = 'completed' WHERE created_at < '2024-01-01';

-- Delete
DELETE FROM orders WHERE status = 'cancelled';

-- Truncate (vider la table)
TRUNCATE TABLE orders;
```

### Requêtes avancées

```sql
-- ═══════════════════════════════════════════════════════════════════════
--                    SUBQUERIES
-- ═══════════════════════════════════════════════════════════════════════

-- Subquery dans WHERE
SELECT * FROM users 
WHERE id IN (SELECT user_id FROM orders WHERE amount > 100);

-- Subquery dans FROM
SELECT avg_orders.user_id, avg_orders.avg_amount
FROM (
    SELECT user_id, AVG(amount) as avg_amount
    FROM orders
    GROUP BY user_id
) as avg_orders
WHERE avg_orders.avg_amount > 50;


-- ═══════════════════════════════════════════════════════════════════════
--                    CTE (Common Table Expressions)
-- ═══════════════════════════════════════════════════════════════════════

WITH high_spenders AS (
    SELECT user_id, SUM(amount) as total_spent
    FROM orders
    GROUP BY user_id
    HAVING SUM(amount) > 1000
)
SELECT u.name, hs.total_spent
FROM users u
JOIN high_spenders hs ON u.id = hs.user_id;


-- ═══════════════════════════════════════════════════════════════════════
--                    WINDOW FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════

-- Rang par montant
SELECT 
    user_id,
    amount,
    ROW_NUMBER() OVER (ORDER BY amount DESC) as rang,
    RANK() OVER (ORDER BY amount DESC) as rank,
    SUM(amount) OVER (PARTITION BY user_id) as total_user
FROM orders;


-- ═══════════════════════════════════════════════════════════════════════
--                    JSONB
-- ═══════════════════════════════════════════════════════════════════════

-- Accéder aux champs JSON
SELECT metadata->>'city' as city FROM users;
SELECT metadata->'address'->>'street' as street FROM users;

-- Filtrer sur JSON
SELECT * FROM users WHERE metadata->>'country' = 'Tunisia';

-- Contient
SELECT * FROM users WHERE metadata @> '{"premium": true}';
```

### Transactions

```sql
-- ═══════════════════════════════════════════════════════════════════════
--                    TRANSACTIONS
-- ═══════════════════════════════════════════════════════════════════════

BEGIN;  -- ou START TRANSACTION

UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

-- Si tout va bien
COMMIT;

-- Si erreur
ROLLBACK;


-- Savepoints
BEGIN;
UPDATE users SET age = 30 WHERE id = 1;
SAVEPOINT my_savepoint;
UPDATE users SET age = 35 WHERE id = 2;
ROLLBACK TO my_savepoint;  -- Annule seulement le 2e UPDATE
COMMIT;
```

---

## 8. 📈 PostgreSQL - Index et Performance

### Types d'index

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      TYPES D'INDEX                                       │
│                                                                          │
│  1. B-TREE (défaut)                                                     │
│     - Le plus commun                                                    │
│     - Pour: =, <, >, <=, >=, BETWEEN, IN, LIKE 'abc%'                 │
│                                                                          │
│  2. HASH                                                                │
│     - Seulement pour égalité (=)                                       │
│     - Plus rapide que B-tree pour égalité pure                         │
│                                                                          │
│  3. GIN (Generalized Inverted Index)                                   │
│     - Pour: Arrays, JSONB, Full-text search                            │
│     - Contient multiple valeurs par ligne                              │
│                                                                          │
│  4. GiST (Generalized Search Tree)                                     │
│     - Pour: Données géométriques, ranges                               │
│     - PostGIS                                                           │
│                                                                          │
│  5. BRIN (Block Range Index)                                           │
│     - Pour: Grosses tables ordonnées                                   │
│     - Très compact (données naturellement triées)                      │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Créer des index

```sql
-- Index simple
CREATE INDEX idx_users_email ON users(email);

-- Index unique
CREATE UNIQUE INDEX idx_users_email_unique ON users(email);

-- Index composé
CREATE INDEX idx_orders_user_status ON orders(user_id, status);

-- Index partiel
CREATE INDEX idx_orders_pending ON orders(created_at) 
WHERE status = 'pending';

-- Index sur expression
CREATE INDEX idx_users_lower_email ON users(LOWER(email));

-- Index GIN pour JSONB
CREATE INDEX idx_users_metadata ON users USING GIN(metadata);

-- Index GIN pour full-text search
CREATE INDEX idx_articles_search ON articles 
USING GIN(to_tsvector('english', title || ' ' || content));

-- Voir les index
\di
SELECT * FROM pg_indexes WHERE tablename = 'users';
```

### EXPLAIN - Analyser les requêtes

```sql
-- Voir le plan d'exécution
EXPLAIN SELECT * FROM users WHERE email = 'ali@example.com';

-- Avec exécution réelle et timing
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'ali@example.com';

-- Sortie détaillée
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT) 
SELECT * FROM users WHERE email = 'ali@example.com';
```

### Lecture d'un plan EXPLAIN

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    LECTURE EXPLAIN                                       │
│                                                                          │
│  Seq Scan       = Lecture séquentielle (parcourt TOUT) - à éviter     │
│  Index Scan     = Utilise un index - BIEN                              │
│  Index Only Scan = Tout depuis l'index - TRÈS BIEN                     │
│  Bitmap Scan    = Combine index et table                               │
│  Nested Loop    = JOIN par boucle imbriquée                           │
│  Hash Join      = JOIN avec table de hachage                          │
│  Merge Join     = JOIN sur données triées                             │
│                                                                          │
│  COÛT:                                                                  │
│  cost=0.00..10.25  → coût estimé (startup..total)                     │
│  rows=100          → nombre de lignes estimé                          │
│  width=50          → taille moyenne d'une ligne en bytes              │
│                                                                          │
│  ACTUAL (avec ANALYZE):                                                │
│  actual time=0.015..0.020 ms                                           │
│  rows=1            → lignes réellement retournées                     │
│  loops=1           → nombre d'exécutions                              │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 9. 🔧 PostgreSQL - Administration

### Gestion des utilisateurs

```sql
-- Créer un utilisateur
CREATE USER analyst WITH PASSWORD 'secret123';

-- Créer un rôle
CREATE ROLE readonly;

-- Donner des permissions
GRANT CONNECT ON DATABASE analytics TO analyst;
GRANT USAGE ON SCHEMA public TO analyst;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst;

-- Permissions futures
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT SELECT ON TABLES TO readonly;

-- Révoquer
REVOKE ALL ON DATABASE analytics FROM analyst;

-- Supprimer
DROP USER analyst;
```

### Maintenance

```sql
-- VACUUM - Récupère l'espace des tuples morts
VACUUM;                    -- Toutes les tables
VACUUM users;              -- Une table
VACUUM FULL users;         -- Récupère l'espace disque (lock exclusif!)

-- ANALYZE - Met à jour les statistiques
ANALYZE;
ANALYZE users;

-- Les deux ensemble
VACUUM ANALYZE users;

-- Reindex
REINDEX TABLE users;
REINDEX DATABASE analytics;
```

### Backup et Restore

```bash
# ═══════════════════════════════════════════════════════════════════════
#                    BACKUP
# ═══════════════════════════════════════════════════════════════════════

# Dump SQL (texte)
pg_dump -U postgres -d analytics > backup.sql

# Dump compressé
pg_dump -U postgres -d analytics -Fc > backup.dump

# Dump d'une table
pg_dump -U postgres -d analytics -t users > users.sql

# Dump de tout le cluster
pg_dumpall -U postgres > all_databases.sql


# ═══════════════════════════════════════════════════════════════════════
#                    RESTORE
# ═══════════════════════════════════════════════════════════════════════

# Restore SQL
psql -U postgres -d analytics < backup.sql

# Restore dump compressé
pg_restore -U postgres -d analytics backup.dump

# Restore avec création de la base
createdb -U postgres analytics_new
pg_restore -U postgres -d analytics_new backup.dump
```

### Configuration importante

```
┌─────────────────────────────────────────────────────────────────────────┐
│              PARAMÈTRES POSTGRESQL IMPORTANTS                            │
│                                                                          │
│  Fichier: postgresql.conf                                               │
│                                                                          │
│  MÉMOIRE:                                                               │
│  shared_buffers = 256MB          # Cache (25% de la RAM)               │
│  work_mem = 64MB                 # Mémoire par opération               │
│  maintenance_work_mem = 512MB    # Pour VACUUM, CREATE INDEX           │
│                                                                          │
│  CONNEXIONS:                                                            │
│  max_connections = 100           # Connexions simultanées max          │
│                                                                          │
│  WAL:                                                                   │
│  wal_level = replica             # Pour réplication                    │
│  max_wal_senders = 3             # Slots de réplication                │
│                                                                          │
│  LOGGING:                                                               │
│  log_statement = 'all'           # Log toutes les requêtes            │
│  log_duration = on               # Log la durée                        │
│                                                                          │
│  Fichier: pg_hba.conf (authentification)                               │
│  host  all  all  0.0.0.0/0  md5                                        │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Commandes système

```bash
# Statut du service
sudo systemctl status postgresql
sudo systemctl start postgresql
sudo systemctl stop postgresql
sudo systemctl restart postgresql

# Recharger la configuration
sudo systemctl reload postgresql
# Ou dans psql:
SELECT pg_reload_conf();

# Voir les connexions actives
SELECT * FROM pg_stat_activity;

# Tuer une connexion
SELECT pg_terminate_backend(pid);

# Taille des bases
SELECT pg_database.datname, 
       pg_size_pretty(pg_database_size(pg_database.datname)) as size
FROM pg_database;

# Taille des tables
SELECT tablename, 
       pg_size_pretty(pg_total_relation_size(tablename::text)) as size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(tablename::text) DESC;
```

---

# PARTIE 3 : CASSANDRA (NoSQL)

---

## 10. 👁 Cassandra - Vue d'ensemble

### C'est quoi ?

Apache Cassandra est une base de données **NoSQL distribuée** conçue pour gérer de très grands volumes de données avec haute disponibilité.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                       CASSANDRA                                          │
│                                                                          │
│  - Base de données NoSQL orientée colonnes                              │
│  - Distribuée (pas de single point of failure)                          │
│  - Hautement disponible (AP dans CAP)                                   │
│  - Scalable linéairement (ajouter des nœuds = plus de capacité)        │
│  - Optimisée pour l'ÉCRITURE                                           │
│  - Inspirée de Google BigTable + Amazon Dynamo                          │
│                                                                          │
│  UTILISÉ PAR: Netflix, Apple, Instagram, Spotify, Uber                 │
│               Discord (trillions de messages)                           │
│                                                                          │
│  CAS D'USAGE:                                                           │
│  - Time series data (IoT, métriques)                                   │
│  - Messaging (chat, notifications)                                     │
│  - Tracking (événements utilisateurs)                                  │
│  - Tout ce qui nécessite haute disponibilité et volume                 │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Caractéristiques principales

| Caractéristique | Description |
|-----------------|-------------|
| **Décentralisé** | Pas de master, tous les nœuds égaux (peer-to-peer) |
| **Scalable** | Scaling horizontal linéaire |
| **Haute dispo** | Réplication automatique, tolérant aux pannes |
| **Performance** | Optimisé écriture, millions d'ops/seconde |
| **Flexible** | Schema-free (colonnes dynamiques) |
| **CQL** | Query language similaire à SQL |
| **Tunable** | Consistency level configurable |

### Quand utiliser Cassandra ?

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    QUAND UTILISER CASSANDRA                              │
│                                                                          │
│  ✅ UTILISER SI:                                                        │
│  - Très gros volumes de données (TB, PB)                               │
│  - Beaucoup d'écritures                                                 │
│  - Haute disponibilité critique                                         │
│  - Scaling horizontal nécessaire                                        │
│  - Données time-series ou event-driven                                 │
│  - Géo-distribution (multi-datacenter)                                 │
│                                                                          │
│  ❌ NE PAS UTILISER SI:                                                 │
│  - Besoin de transactions ACID                                          │
│  - Beaucoup de JOINs complexes                                          │
│  - Requêtes ad-hoc imprévisibles                                       │
│  - Petits volumes de données                                            │
│  - Besoin de strong consistency absolue                                 │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 11. 🏗 Cassandra - Architecture

### Architecture distribuée (Ring)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   ARCHITECTURE RING                                      │
│                                                                          │
│                         Node 1                                           │
│                        (0-25%)                                           │
│                           ●                                              │
│                        ╱     ╲                                           │
│                      ╱         ╲                                         │
│           Node 6   ●             ●   Node 2                             │
│          (75-100%)  ╲           ╱   (25-50%)                            │
│                      ╲         ╱                                         │
│                       ╲       ╱                                          │
│            Node 5  ●───────────●  Node 3                                │
│           (62-75%)       │       (50-62%)                               │
│                          │                                               │
│                          ●                                               │
│                       Node 4                                             │
│                      (50-62%)                                            │
│                                                                          │
│  - Chaque nœud est responsable d'une plage de tokens                   │
│  - Pas de master/slave, tous les nœuds sont égaux                      │
│  - N'importe quel nœud peut recevoir une requête                       │
│  - Les données sont répliquées sur plusieurs nœuds                     │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Composants d'un nœud

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   COMPOSANTS D'UN NŒUD CASSANDRA                         │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                        CLIENT REQUEST                            │   │
│  └────────────────────────────────┬────────────────────────────────┘   │
│                                   │                                     │
│                                   ▼                                     │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                         MEMTABLE                                 │   │
│  │              (Cache en mémoire, écritures)                       │   │
│  └────────────────────────────────┬────────────────────────────────┘   │
│                                   │                                     │
│                        Flush (quand plein)                             │
│                                   │                                     │
│                                   ▼                                     │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                         SSTABLE                                  │   │
│  │           (Sorted String Table - sur disque)                    │   │
│  │                      Immutable!                                  │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                       COMMIT LOG                                 │   │
│  │         (WAL - durabilité des écritures)                        │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Flux d'écriture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    FLUX D'ÉCRITURE CASSANDRA                             │
│                                                                          │
│  1. Client envoie une requête d'écriture                               │
│                                                                          │
│  2. Écriture dans le COMMIT LOG (durabilité)                           │
│     → Écriture séquentielle, très rapide                               │
│                                                                          │
│  3. Écriture dans la MEMTABLE (mémoire)                                │
│     → Structure en mémoire, triée                                       │
│                                                                          │
│  4. ACK envoyé au client                                                │
│     → L'écriture est considérée comme terminée                         │
│                                                                          │
│  5. Quand Memtable est pleine → FLUSH vers SSTable                     │
│     → SSTable = fichier immutable sur disque                           │
│                                                                          │
│  6. COMPACTION périodique                                               │
│     → Fusionne les SSTables, supprime les données obsolètes            │
│                                                                          │
│  C'est pourquoi Cassandra est si RAPIDE en écriture!                   │
│  → Pas de lecture avant écriture                                        │
│  → Écriture séquentielle (append-only)                                 │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Flux de lecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    FLUX DE LECTURE CASSANDRA                             │
│                                                                          │
│  1. Client envoie une requête de lecture                               │
│                                                                          │
│  2. Vérifier le ROW CACHE (si activé)                                  │
│     → Cache des lignes complètes                                        │
│                                                                          │
│  3. Vérifier la MEMTABLE                                               │
│     → Données récentes en mémoire                                       │
│                                                                          │
│  4. Vérifier le BLOOM FILTER                                           │
│     → "Cette SSTable contient-elle peut-être cette clé?"               │
│     → Évite de lire des SSTables inutilement                           │
│                                                                          │
│  5. Vérifier le KEY CACHE                                              │
│     → Position de la clé dans la SSTable                               │
│                                                                          │
│  6. Lire la SSTABLE sur disque                                         │
│                                                                          │
│  7. Fusionner les résultats de toutes les sources                      │
│     → Prend la valeur avec le timestamp le plus récent                 │
│                                                                          │
│  8. Retourner au client                                                 │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Tableau des composants

| Composant | Emplacement | Rôle |
|-----------|-------------|------|
| **Commit Log** | Disque | Durabilité (WAL) |
| **Memtable** | Mémoire | Buffer d'écriture |
| **SSTable** | Disque | Stockage permanent, immutable |
| **Bloom Filter** | Mémoire | Filtre probabiliste pour lectures |
| **Key Cache** | Mémoire | Cache des positions de clés |
| **Row Cache** | Mémoire | Cache des lignes complètes |

---

## 12. 📊 Cassandra - Modèle de données

### Concepts clés

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   MODÈLE DE DONNÉES CASSANDRA                            │
│                                                                          │
│  KEYSPACE                                                               │
│  └── TABLE (Column Family)                                              │
│      └── ROW                                                            │
│          └── COLUMNS                                                    │
│                                                                          │
│  KEYSPACE = équivalent de DATABASE en SQL                              │
│  TABLE    = équivalent de TABLE en SQL                                 │
│  ROW      = identifiée par PRIMARY KEY                                 │
│  COLUMN   = nom + valeur + timestamp                                   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Primary Key - TRÈS IMPORTANT

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   PRIMARY KEY EN CASSANDRA                               │
│                                                                          │
│  PRIMARY KEY = (PARTITION KEY, CLUSTERING COLUMNS)                     │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                                                                  │   │
│  │  PRIMARY KEY (user_id, timestamp)                               │   │
│  │               ───────   ─────────                                │   │
│  │               Partition  Clustering                              │   │
│  │               Key        Column                                  │   │
│  │                                                                  │   │
│  │  PRIMARY KEY ((country, city), timestamp, user_id)              │   │
│  │               ───────────────  ─────────────────                │   │
│  │               Partition Key    Clustering Columns               │   │
│  │               (composite)                                        │   │
│  │                                                                  │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                          │
│  PARTITION KEY:                                                        │
│  - Détermine sur QUEL NŒUD les données sont stockées                  │
│  - Hash de la partition key → position dans le ring                   │
│  - Toutes les données avec même partition key = même nœud            │
│                                                                          │
│  CLUSTERING COLUMNS:                                                   │
│  - Détermine l'ORDRE des données DANS la partition                    │
│  - Permet les range queries                                            │
│  - Tri physique sur disque                                             │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Exemple visuel

```
┌─────────────────────────────────────────────────────────────────────────┐
│  TABLE messages (                                                       │
│      user_id UUID,                                                      │
│      timestamp TIMESTAMP,                                               │
│      message TEXT,                                                      │
│      PRIMARY KEY (user_id, timestamp)                                  │
│  ) WITH CLUSTERING ORDER BY (timestamp DESC);                          │
│                                                                          │
│                                                                          │
│  Stockage physique:                                                     │
│                                                                          │
│  PARTITION (user_id = A):                                              │
│  ┌────────────────────────────────────────────────────────┐            │
│  │ timestamp   │ message                                   │            │
│  │─────────────┼──────────────────────────────────────────│            │
│  │ 2024-01-15  │ "Hello"                                  │            │
│  │ 2024-01-14  │ "Hi there"                               │            │
│  │ 2024-01-10  │ "First message"                          │            │
│  └────────────────────────────────────────────────────────┘            │
│                                                                          │
│  PARTITION (user_id = B):                                              │
│  ┌────────────────────────────────────────────────────────┐            │
│  │ timestamp   │ message                                   │            │
│  │─────────────┼──────────────────────────────────────────│            │
│  │ 2024-01-15  │ "Bonjour"                                │            │
│  │ 2024-01-12  │ "Salut"                                  │            │
│  └────────────────────────────────────────────────────────┘            │
│                                                                          │
│  Les partitions peuvent être sur des nœuds DIFFÉRENTS                  │
│  Les données DANS une partition sont triées par clustering column      │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Règles de modélisation

```
┌─────────────────────────────────────────────────────────────────────────┐
│              RÈGLES DE MODÉLISATION CASSANDRA                            │
│                                                                          │
│  1. PENSER AUX REQUÊTES D'ABORD                                        │
│     → Modéliser en fonction des queries, pas des entités               │
│     → 1 table par type de requête                                      │
│                                                                          │
│  2. DÉNORMALISER                                                        │
│     → Pas de JOINs, donc dupliquer les données                         │
│     → C'est NORMAL et ATTENDU                                          │
│                                                                          │
│  3. ÉVITER LES GROSSES PARTITIONS                                      │
│     → Max recommandé: 100MB par partition                              │
│     → Max: 100,000 lignes par partition                                │
│                                                                          │
│  4. PARTITION KEY = CE QUE TU CHERCHES                                 │
│     → La requête DOIT fournir la partition key                         │
│                                                                          │
│  5. CLUSTERING = COMMENT TU TRIES                                       │
│     → Ordre des résultats                                               │
│     → Range queries possibles                                           │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 13. 💻 Cassandra - CQL

### Connexion

```bash
# Se connecter à Cassandra
cqlsh localhost

# Avec authentification
cqlsh localhost -u cassandra -p cassandra
```

### Commandes de base

```sql
-- ═══════════════════════════════════════════════════════════════════════
--                    KEYSPACE
-- ═══════════════════════════════════════════════════════════════════════

-- Créer un keyspace
CREATE KEYSPACE analytics
WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 3
};

-- Ou avec NetworkTopologyStrategy (production)
CREATE KEYSPACE analytics
WITH replication = {
    'class': 'NetworkTopologyStrategy',
    'dc1': 3,
    'dc2': 2
};

-- Utiliser un keyspace
USE analytics;

-- Lister les keyspaces
DESCRIBE KEYSPACES;

-- Supprimer
DROP KEYSPACE analytics;


-- ═══════════════════════════════════════════════════════════════════════
--                    TABLE
-- ═══════════════════════════════════════════════════════════════════════

-- Créer une table
CREATE TABLE users (
    user_id UUID PRIMARY KEY,
    name TEXT,
    email TEXT,
    age INT,
    created_at TIMESTAMP
);

-- Table avec clustering column
CREATE TABLE messages (
    user_id UUID,
    timestamp TIMESTAMP,
    message TEXT,
    PRIMARY KEY (user_id, timestamp)
) WITH CLUSTERING ORDER BY (timestamp DESC);

-- Table avec partition key composite
CREATE TABLE events (
    country TEXT,
    date DATE,
    event_id UUID,
    event_type TEXT,
    data TEXT,
    PRIMARY KEY ((country, date), event_id)
);

-- Lister les tables
DESCRIBE TABLES;

-- Décrire une table
DESCRIBE TABLE users;

-- Supprimer
DROP TABLE users;
```

### Types de données Cassandra

| Type | Description | Exemple |
|------|-------------|---------|
| `TEXT` | Chaîne UTF-8 | `'Hello'` |
| `INT` | Entier 32-bit | `42` |
| `BIGINT` | Entier 64-bit | `9223372036854775807` |
| `FLOAT` | Flottant 32-bit | `3.14` |
| `DOUBLE` | Flottant 64-bit | `3.14159265359` |
| `BOOLEAN` | Booléen | `true`, `false` |
| `UUID` | UUID | `uuid()` |
| `TIMEUUID` | UUID avec timestamp | `now()` |
| `TIMESTAMP` | Date/heure | `'2024-01-15 10:30:00'` |
| `DATE` | Date | `'2024-01-15'` |
| `LIST<T>` | Liste ordonnée | `['a', 'b', 'c']` |
| `SET<T>` | Ensemble unique | `{'a', 'b', 'c'}` |
| `MAP<K,V>` | Dictionnaire | `{'key': 'value'}` |
| `FROZEN<T>` | Type imbriqué | `FROZEN<MAP<TEXT, TEXT>>` |

### CRUD Operations

```sql
-- ═══════════════════════════════════════════════════════════════════════
--                    INSERT
-- ═══════════════════════════════════════════════════════════════════════

-- Insert simple
INSERT INTO users (user_id, name, email, age, created_at)
VALUES (uuid(), 'Ali', 'ali@example.com', 25, toTimestamp(now()));

-- Insert avec TTL (Time To Live)
INSERT INTO users (user_id, name, email, age)
VALUES (uuid(), 'Sara', 'sara@example.com', 30)
USING TTL 86400;  -- Expire après 24h

-- Insert IF NOT EXISTS
INSERT INTO users (user_id, name, email, age)
VALUES (uuid(), 'Omar', 'omar@example.com', 28)
IF NOT EXISTS;


-- ═══════════════════════════════════════════════════════════════════════
--                    SELECT
-- ═══════════════════════════════════════════════════════════════════════

-- Select all
SELECT * FROM users;

-- Select avec WHERE (partition key OBLIGATOIRE)
SELECT * FROM users WHERE user_id = 123e4567-e89b-12d3-a456-426614174000;

-- Select avec clustering column
SELECT * FROM messages 
WHERE user_id = 123e4567-e89b-12d3-a456-426614174000
  AND timestamp > '2024-01-01';

-- Select avec LIMIT
SELECT * FROM messages 
WHERE user_id = 123e4567-e89b-12d3-a456-426614174000
LIMIT 10;

-- Select colonnes spécifiques
SELECT name, email FROM users WHERE user_id = ...;

-- ALLOW FILTERING (à éviter en prod!)
SELECT * FROM users WHERE age = 25 ALLOW FILTERING;


-- ═══════════════════════════════════════════════════════════════════════
--                    UPDATE
-- ═══════════════════════════════════════════════════════════════════════

-- Update simple
UPDATE users SET age = 26 
WHERE user_id = 123e4567-e89b-12d3-a456-426614174000;

-- Update avec TTL
UPDATE users USING TTL 3600 
SET email = 'new@example.com'
WHERE user_id = 123e4567-e89b-12d3-a456-426614174000;

-- Update conditionnel
UPDATE users SET age = 27
WHERE user_id = 123e4567-e89b-12d3-a456-426614174000
IF age = 26;


-- ═══════════════════════════════════════════════════════════════════════
--                    DELETE
-- ═══════════════════════════════════════════════════════════════════════

-- Delete une ligne
DELETE FROM users 
WHERE user_id = 123e4567-e89b-12d3-a456-426614174000;

-- Delete une colonne
DELETE email FROM users 
WHERE user_id = 123e4567-e89b-12d3-a456-426614174000;

-- Delete avec condition
DELETE FROM users 
WHERE user_id = 123e4567-e89b-12d3-a456-426614174000
IF EXISTS;
```

### Collections

```sql
-- ═══════════════════════════════════════════════════════════════════════
--                    COLLECTIONS
-- ═══════════════════════════════════════════════════════════════════════

-- Table avec collections
CREATE TABLE user_profiles (
    user_id UUID PRIMARY KEY,
    name TEXT,
    emails SET<TEXT>,
    phones LIST<TEXT>,
    properties MAP<TEXT, TEXT>
);

-- Insert avec collections
INSERT INTO user_profiles (user_id, name, emails, phones, properties)
VALUES (
    uuid(),
    'Ali',
    {'ali@work.com', 'ali@home.com'},
    ['+216 12345678', '+216 87654321'],
    {'city': 'Tunis', 'country': 'Tunisia'}
);

-- Modifier un SET
UPDATE user_profiles 
SET emails = emails + {'ali@new.com'}
WHERE user_id = ...;

-- Modifier une LIST
UPDATE user_profiles 
SET phones = phones + ['+216 99999999']
WHERE user_id = ...;

-- Modifier un MAP
UPDATE user_profiles 
SET properties['city'] = 'Sousse'
WHERE user_id = ...;
```

### Index secondaires

```sql
-- Créer un index secondaire
CREATE INDEX ON users (email);

-- Maintenant cette requête fonctionne
SELECT * FROM users WHERE email = 'ali@example.com';

-- Index sur collection
CREATE INDEX ON user_profiles (emails);

-- ⚠️ ATTENTION: Les index secondaires ont des limitations!
-- - Moins performants que les requêtes par partition key
-- - À éviter sur les colonnes à haute cardinalité
-- - À éviter sur les colonnes fréquemment mises à jour
```

---

## 14. 🔀 Cassandra - Partitionnement et Réplication

### Partitionnement

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   PARTITIONNEMENT                                        │
│                                                                          │
│  Partition Key: "user_123"                                              │
│         │                                                                │
│         ▼                                                                │
│  ┌─────────────┐                                                        │
│  │   HASH      │  → Murmur3 hash → Token: 4567890123                   │
│  │  FUNCTION   │                                                        │
│  └─────────────┘                                                        │
│         │                                                                │
│         ▼                                                                │
│  Token appartient à la plage du Node 3                                  │
│  → Données stockées sur Node 3 (et répliquées)                         │
│                                                                          │
│                                                                          │
│  Ring avec tokens:                                                      │
│                                                                          │
│  Node 1: 0 ────────────────── 3000000000                               │
│  Node 2: 3000000000 ─────────── 6000000000                             │
│  Node 3: 6000000000 ─────────── 9000000000  ← Notre token est ici     │
│  Node 4: 9000000000 ─────────── 0                                      │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Réplication

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   RÉPLICATION                                            │
│                                                                          │
│  Replication Factor (RF) = 3                                            │
│                                                                          │
│  Token 4567890123 → Node 3 (primary)                                   │
│                   → Node 4 (replica 1)                                  │
│                   → Node 5 (replica 2)                                  │
│                                                                          │
│                                                                          │
│         Node 1              Node 2              Node 3 (Primary)        │
│            ●                   ●                   ●                    │
│                                                   /│\                   │
│                                                  / │ \                  │
│         Node 6              Node 5              Node 4                  │
│            ●                   ●                   ●                    │
│                             (Replica 2)         (Replica 1)            │
│                                                                          │
│                                                                          │
│  STRATÉGIES DE RÉPLICATION:                                            │
│                                                                          │
│  1. SimpleStrategy                                                      │
│     → Pour un seul datacenter                                          │
│     → Réplique sur les N nœuds suivants dans le ring                  │
│                                                                          │
│  2. NetworkTopologyStrategy                                             │
│     → Pour multi-datacenter                                            │
│     → Spécifie RF par datacenter                                       │
│     → Réplique sur différents racks                                    │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 15. 📊 Cassandra - Consistency Levels

### Concept

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   CONSISTENCY LEVELS                                     │
│                                                                          │
│  Tu peux configurer le niveau de cohérence PAR REQUÊTE                 │
│                                                                          │
│  Plus le niveau est élevé:                                              │
│  → Plus de cohérence (données à jour)                                  │
│  → Moins de disponibilité (plus de nœuds doivent répondre)            │
│  → Plus de latence                                                      │
│                                                                          │
│  C'est un TRADE-OFF !                                                   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Niveaux disponibles

| Level | Description | Nœuds requis (RF=3) |
|-------|-------------|---------------------|
| `ONE` | 1 nœud répond | 1 |
| `TWO` | 2 nœuds répondent | 2 |
| `THREE` | 3 nœuds répondent | 3 |
| `QUORUM` | Majorité (RF/2 + 1) | 2 |
| `ALL` | Tous les replicas | 3 |
| `LOCAL_QUORUM` | Quorum dans le DC local | 2 (local DC) |
| `EACH_QUORUM` | Quorum dans chaque DC | 2 par DC |
| `LOCAL_ONE` | 1 nœud dans le DC local | 1 (local DC) |
| `ANY` | N'importe quel nœud (écriture only) | 1 |

### Formule de cohérence

```
┌─────────────────────────────────────────────────────────────────────────┐
│              FORMULE DE COHÉRENCE FORTE                                  │
│                                                                          │
│  Pour garantir une cohérence forte:                                     │
│                                                                          │
│  W + R > RF                                                             │
│                                                                          │
│  W = Consistency Level en écriture                                      │
│  R = Consistency Level en lecture                                       │
│  RF = Replication Factor                                                │
│                                                                          │
│  EXEMPLE avec RF = 3:                                                   │
│                                                                          │
│  ✅ QUORUM write + QUORUM read = 2 + 2 = 4 > 3                         │
│  ✅ ALL write + ONE read = 3 + 1 = 4 > 3                               │
│  ✅ ONE write + ALL read = 1 + 3 = 4 > 3                               │
│  ❌ ONE write + ONE read = 1 + 1 = 2 < 3 (pas de garantie)             │
│                                                                          │
│  RECOMMANDATION PRODUCTION:                                             │
│  → Write: QUORUM, Read: QUORUM                                         │
│  → Bon équilibre cohérence/disponibilité                               │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Utilisation en CQL

```sql
-- Définir le consistency level
CONSISTENCY QUORUM;

-- Exécuter une requête
SELECT * FROM users WHERE user_id = ...;

-- Voir le consistency level actuel
CONSISTENCY;

-- Différents niveaux
CONSISTENCY ONE;
CONSISTENCY LOCAL_QUORUM;
CONSISTENCY ALL;
```

---

## 16. 🔧 Cassandra - Administration

### nodetool - Outil principal

```bash
# ═══════════════════════════════════════════════════════════════════════
#                    STATUS DU CLUSTER
# ═══════════════════════════════════════════════════════════════════════

# État du cluster
nodetool status

# Sortie exemple:
# Datacenter: dc1
# ===============
# Status=Up/Down   State=Normal/Leaving/Joining/Moving
# --  Address       Load       Tokens  Owns    Host ID                               Rack
# UN  192.168.1.1   256.5 GB   256     33.3%   aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee  rack1
# UN  192.168.1.2   248.2 GB   256     33.3%   ffffffff-gggg-hhhh-iiii-jjjjjjjjjjjj  rack1
# UN  192.168.1.3   261.8 GB   256     33.3%   kkkkkkkk-llll-mmmm-nnnn-oooooooooooo  rack2

# Info détaillée d'un nœud
nodetool info

# Statistiques des tables
nodetool tablestats analytics.users


# ═══════════════════════════════════════════════════════════════════════
#                    MAINTENANCE
# ═══════════════════════════════════════════════════════════════════════

# Compaction manuelle
nodetool compact analytics users

# Flush memtables vers SSTables
nodetool flush analytics users

# Repair (synchronisation des données)
nodetool repair analytics users

# Cleanup (après changement de topology)
nodetool cleanup


# ═══════════════════════════════════════════════════════════════════════
#                    GESTION DES NŒUDS
# ═══════════════════════════════════════════════════════════════════════

# Décommissionner un nœud proprement
nodetool decommission

# Retirer un nœud mort
nodetool removenode <host-id>

# Drain avant arrêt
nodetool drain

# Rejoindre le cluster
nodetool join
```

### Monitoring

```bash
# Threads pools
nodetool tpstats

# Connexions clients
nodetool clientstats

# Latences
nodetool proxyhistograms

# Compaction en cours
nodetool compactionstats

# Garbage collection
nodetool gcstats
```

### Configuration importante

```yaml
# cassandra.yaml - Paramètres clés

# Cluster
cluster_name: 'MyCluster'
num_tokens: 256

# Réseau
listen_address: 192.168.1.1
rpc_address: 0.0.0.0

# Seeds (nœuds de bootstrap)
seed_provider:
  - class_name: org.apache.cassandra.locator.SimpleSeedProvider
    parameters:
      - seeds: "192.168.1.1,192.168.1.2"

# Répertoires
data_file_directories:
  - /var/lib/cassandra/data
commitlog_directory: /var/lib/cassandra/commitlog

# Mémoire
memtable_heap_space_in_mb: 2048
memtable_offheap_space_in_mb: 2048

# Compaction
compaction_throughput_mb_per_sec: 64

# Timeouts
read_request_timeout_in_ms: 5000
write_request_timeout_in_ms: 2000
```

### Backup et Restore

```bash
# ═══════════════════════════════════════════════════════════════════════
#                    BACKUP
# ═══════════════════════════════════════════════════════════════════════

# Snapshot (backup instantané)
nodetool snapshot -t my_snapshot analytics

# Les fichiers sont dans:
# /var/lib/cassandra/data/<keyspace>/<table>/snapshots/my_snapshot/

# Copier les fichiers de snapshot
cp -r /var/lib/cassandra/data/analytics/users*/snapshots/my_snapshot/* /backup/


# ═══════════════════════════════════════════════════════════════════════
#                    RESTORE
# ═══════════════════════════════════════════════════════════════════════

# Copier les SSTables
cp /backup/* /var/lib/cassandra/data/analytics/users-<uuid>/

# Rafraîchir la table
nodetool refresh analytics users

# Ou utiliser sstableloader pour charger sur un autre cluster
sstableloader -d 192.168.1.1 /backup/analytics/users/
```

---

# PARTIE 4 : COMPARAISONS ET SYNTHÈSE

---

## 17. ⚖ PostgreSQL vs Cassandra

### Tableau comparatif complet

| Critère | PostgreSQL | Cassandra |
|---------|------------|-----------|
| **Type** | SQL Relationnel | NoSQL Colonnes |
| **Schéma** | Fixe, strict | Flexible |
| **ACID** | ✅ Complet | ❌ Limité (per-partition) |
| **JOINs** | ✅ Complets | ❌ Non supporté |
| **Scaling** | Vertical | Horizontal |
| **Architecture** | Master-Slave | Peer-to-peer (ring) |
| **SPOF** | Oui (sans HA) | Non |
| **Écriture** | Modérée | Très rapide |
| **Lecture** | Très flexible | Par partition key |
| **Transactions** | Multi-tables | Single partition |
| **Cohérence** | Strong | Tunable (eventual) |
| **Requêtes ad-hoc** | ✅ Excellentes | ❌ Limitées |
| **Agrégations** | ✅ Puissantes | ❌ Limitées |
| **Use case** | OLTP, Data Warehouse | Big Data, Time series |

### Visualisation

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   POSTGRESQL vs CASSANDRA                                │
│                                                                          │
│                    POSTGRESQL                CASSANDRA                  │
│                                                                          │
│  Structure:        Tables & Relations       Keyspaces & Tables          │
│                    ┌─────┐ ┌─────┐          ┌────────────────┐          │
│                    │User │─│Order│          │ Partition Key  │          │
│                    └─────┘ └─────┘          │  └─ Rows       │          │
│                         JOIN                └────────────────┘          │
│                                                                          │
│  Scaling:          🔼 Vertical              ➡️ Horizontal               │
│                    (bigger server)          (more servers)              │
│                    ┌────┐                   ┌──┐ ┌──┐ ┌──┐             │
│                    │████│                   │  │ │  │ │  │             │
│                    │████│                   └──┘ └──┘ └──┘             │
│                    └────┘                                               │
│                                                                          │
│  Write:            Modéré                   Ultra-rapide                │
│                    █████░░░░░               █████████░                  │
│                                                                          │
│  Query             Très flexible            Partition key requise       │
│  Flexibility:      █████████░               ████░░░░░░                  │
│                                                                          │
│  Consistency:      Strong                   Tunable                     │
│                    ████████████             ████░░░░░░ (ONE)            │
│                                             ████████░░ (QUORUM)        │
│                                             ████████████ (ALL)          │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 18. 🎯 Quand utiliser quoi ?

### Arbre de décision

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   ARBRE DE DÉCISION                                      │
│                                                                          │
│  Besoin de transactions ACID multi-tables ?                            │
│  ├─ OUI → PostgreSQL                                                   │
│  └─ NON ↓                                                               │
│                                                                          │
│  Besoin de JOINs complexes ?                                           │
│  ├─ OUI → PostgreSQL                                                   │
│  └─ NON ↓                                                               │
│                                                                          │
│  Volume de données > 1 TB ?                                            │
│  ├─ NON → PostgreSQL (probablement suffisant)                         │
│  └─ OUI ↓                                                               │
│                                                                          │
│  Taux d'écriture très élevé (>100k/s) ?                               │
│  ├─ OUI → Cassandra                                                    │
│  └─ NON ↓                                                               │
│                                                                          │
│  Haute disponibilité critique (99.99%+) ?                              │
│  ├─ OUI → Cassandra                                                    │
│  └─ NON ↓                                                               │
│                                                                          │
│  Requêtes ad-hoc imprévisibles ?                                       │
│  ├─ OUI → PostgreSQL                                                   │
│  └─ NON → Cassandra (si patterns connus)                              │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Cas d'usage typiques

| Cas d'usage | Choix recommandé | Raison |
|-------------|------------------|--------|
| Application web classique | PostgreSQL | ACID, relations, requêtes flexibles |
| E-commerce | PostgreSQL | Transactions (paiement, stock) |
| Analytics/BI | PostgreSQL | JOINs, agrégations |
| Time series (IoT, métriques) | Cassandra | Volume, écriture rapide |
| Logs/Events | Cassandra | Append-only, volume massif |
| Chat/Messaging | Cassandra | Haute dispo, scaling |
| Profils utilisateurs | Soit | Dépend du volume |
| Session storage | Cassandra/Redis | Accès par clé, TTL |
| Données géographiques | PostgreSQL + PostGIS | Extensions spatiales |

### Architecture hybride

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   ARCHITECTURE HYBRIDE                                   │
│                                                                          │
│  Beaucoup de systèmes utilisent LES DEUX !                             │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                        APPLICATION                               │   │
│  └────────────────────────────┬────────────────────────────────────┘   │
│                               │                                         │
│          ┌────────────────────┼────────────────────┐                   │
│          │                    │                    │                   │
│          ▼                    ▼                    ▼                   │
│  ┌───────────────┐   ┌───────────────┐   ┌───────────────┐            │
│  │  PostgreSQL   │   │   Cassandra   │   │    Redis      │            │
│  │               │   │               │   │               │            │
│  │ - Users       │   │ - Events      │   │ - Sessions    │            │
│  │ - Orders      │   │ - Logs        │   │ - Cache       │            │
│  │ - Products    │   │ - Time series │   │ - Queues      │            │
│  │ - Transactions│   │ - Messages    │   │               │            │
│  └───────────────┘   └───────────────┘   └───────────────┘            │
│                                                                          │
│  Chaque base pour ce qu'elle fait de mieux !                           │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 19. 📚 Autres bases Big Data

### Vue d'ensemble

| Base | Type | Usage principal |
|------|------|-----------------|
| **MongoDB** | Document (NoSQL) | Documents JSON, flexibilité |
| **Redis** | Clé-Valeur | Cache, sessions, temps réel |
| **Elasticsearch** | Search Engine | Recherche full-text, logs |
| **HBase** | Colonnes (Hadoop) | Big Data sur HDFS |
| **InfluxDB** | Time Series | Métriques, monitoring |
| **Neo4j** | Graphe | Relations complexes |
| **ClickHouse** | Colonnes (analytique) | OLAP, analytics temps réel |
| **Amazon DynamoDB** | Clé-Valeur (managed) | Serverless, scaling auto |
| **Google BigQuery** | Data Warehouse | Analytics massive, SQL |
| **Snowflake** | Data Warehouse | Cloud data warehouse |

### Quand utiliser quoi ?

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│  Documents flexibles        → MongoDB                                   │
│  Cache ultra-rapide         → Redis                                     │
│  Recherche texte            → Elasticsearch                             │
│  Big Data sur Hadoop        → HBase                                     │
│  Métriques/Monitoring       → InfluxDB, TimescaleDB                    │
│  Graphes/Relations          → Neo4j                                     │
│  Analytics colonnes         → ClickHouse                                │
│  Serverless NoSQL           → DynamoDB                                  │
│  Data Warehouse cloud       → BigQuery, Snowflake, Redshift            │
│  SQL classique              → PostgreSQL, MySQL                         │
│  NoSQL distribué            → Cassandra, ScyllaDB                      │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 20. 📋 Checklist Entretien Junior

```
┌─────────────────────────────────────────────────────────────────────────┐
│          BASES DE DONNÉES BIG DATA - CE QUE TU DOIS SAVOIR             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│ FONDAMENTAUX:                                                           │
│ □ SQL = relationnel, schéma fixe, ACID, JOINs                          │
│ □ NoSQL = flexible, scalable, BASE, pas de JOINs                       │
│ □ CAP Theorem: Consistency, Availability, Partition Tolerance          │
│ □ ACID: Atomicity, Consistency, Isolation, Durability                  │
│ □ BASE: Basically Available, Soft state, Eventual consistency          │
│                                                                          │
│ POSTGRESQL:                                                             │
│ □ Base relationnelle, ACID complet                                     │
│ □ Scaling vertical, master-slave                                       │
│ □ JOINs, transactions multi-tables                                     │
│ □ Support JSON/JSONB                                                   │
│ □ Index: B-tree, GIN, GiST                                            │
│ □ Commandes: psql, \dt, \d, EXPLAIN                                   │
│ □ Backup: pg_dump, pg_restore                                         │
│                                                                          │
│ CASSANDRA:                                                              │
│ □ NoSQL colonnes, AP dans CAP                                         │
│ □ Scaling horizontal, peer-to-peer (ring)                              │
│ □ Pas de SPOF, haute disponibilité                                     │
│ □ Optimisé écriture (append-only)                                      │
│ □ PRIMARY KEY = (Partition Key, Clustering Columns)                    │
│ □ Partition Key = sur quel nœud                                       │
│ □ Clustering Columns = ordre dans la partition                        │
│ □ Consistency Levels: ONE, QUORUM, ALL                                 │
│ □ Commandes: cqlsh, nodetool status                                   │
│                                                                          │
│ MODÉLISATION CASSANDRA:                                                │
│ □ Penser aux requêtes d'abord                                          │
│ □ Dénormaliser les données                                             │
│ □ Éviter les grosses partitions                                        │
│ □ Partition key obligatoire dans WHERE                                 │
│                                                                          │
│ QUAND UTILISER QUOI:                                                   │
│ □ PostgreSQL: ACID, JOINs, requêtes flexibles                         │
│ □ Cassandra: Gros volumes, haute dispo, écriture intensive            │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 21. 🎯 Questions d'entretien types

| Question | Points clés |
|----------|-------------|
| Différence SQL vs NoSQL ? | Schéma fixe/flexible, ACID/BASE, JOINs, scaling |
| C'est quoi le théorème CAP ? | Consistency, Availability, Partition Tolerance - max 2/3 |
| Différence ACID vs BASE ? | ACID = cohérence forte, BASE = disponibilité + eventual consistency |
| Quand choisir PostgreSQL ? | Transactions, JOINs, requêtes complexes, volume modéré |
| Quand choisir Cassandra ? | Gros volumes, haute dispo, écriture intensive |
| C'est quoi une partition key ? | Détermine sur quel nœud les données sont stockées |
| C'est quoi un clustering column ? | Détermine l'ordre des données dans une partition |
| Consistency Level QUORUM ? | Majorité des replicas (RF/2 + 1) |
| Comment optimiser PostgreSQL ? | Index, EXPLAIN, VACUUM, partitioning |
| Pourquoi Cassandra est rapide en écriture ? | Append-only, pas de lecture avant écriture |

---

## 22. 🎯 Résumé en une page

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                 BASES DE DONNÉES BIG DATA - EN BREF                        ║
╠═══════════════════════════════════════════════════════════════════════════╣
║                                                                            ║
║  SQL (PostgreSQL)                    NoSQL (Cassandra)                    ║
║  ─────────────────                   ──────────────────                   ║
║  • Schéma fixe                       • Schéma flexible                    ║
║  • ACID complet                      • BASE (eventual)                    ║
║  • JOINs puissants                   • Pas de JOINs                       ║
║  • Scaling vertical                  • Scaling horizontal                 ║
║  • Requêtes flexibles                • Par partition key                  ║
║                                                                            ║
║  CAP THEOREM: C + A + P → maximum 2 sur 3                                 ║
║  PostgreSQL = CA, Cassandra = AP                                          ║
║                                                                            ║
║  CASSANDRA PRIMARY KEY:                                                   ║
║  PRIMARY KEY ((partition_key), clustering_col1, clustering_col2)         ║
║  • Partition Key → sur quel nœud                                         ║
║  • Clustering → ordre dans la partition                                  ║
║                                                                            ║
║  CONSISTENCY LEVELS (Cassandra):                                          ║
║  ONE < QUORUM < ALL                                                       ║
║  W + R > RF = Strong Consistency                                          ║
║                                                                            ║
║  QUAND UTILISER:                                                          ║
║  • PostgreSQL: Transactions, JOINs, analytics, OLTP                       ║
║  • Cassandra: Gros volumes, time series, haute dispo, IoT                ║
║                                                                            ║
║  COMMANDES ESSENTIELLES:                                                  ║
║  PostgreSQL: psql, \dt, EXPLAIN, pg_dump                                  ║
║  Cassandra: cqlsh, nodetool status/repair, DESCRIBE                       ║
║                                                                            ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

---

> **Bonne chance pour ton entretien !** 🚀