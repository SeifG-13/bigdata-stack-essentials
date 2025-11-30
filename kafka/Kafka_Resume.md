# 📚 Résumé Complet Kafka - Guide Junior

> **Objectif** : Tout ce qu'un Ingénieur Support & Intégration Junior Big Data doit savoir sur Kafka

---

## Table des matières

1. [Architecture Kafka](#1-️-architecture-kafka)
2. [Topic & Partitions](#2--topic--partitions)
3. [Producer](#3--producer-envoi-de-messages)
4. [Consumer](#4--consumer-lecture-de-messages)
5. [Réplication & Haute Disponibilité](#5-️-réplication--haute-disponibilité)
6. [Retention](#6--retention-conservation-des-messages)
7. [Monitoring & Métriques](#7--monitoring--métriques)
8. [Commandes CLI Essentielles](#8--commandes-cli-essentielles)
9. [Erreurs courantes](#9-️-erreurs-courantes)
10. [Éviter la perte de messages](#10-️-éviter-la-perte-de-messages)
11. [Checklist Entretien Junior](#11--checklist-entretien-junior)

---

## 1. 🏗️ Architecture Kafka

### Vue d'ensemble

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           CLUSTER KAFKA                                  │
│                                                                          │
│  ┌─────────────┐     ┌─────────────┐     ┌─────────────┐                │
│  │  BROKER 0   │     │  BROKER 1   │     │  BROKER 2   │                │
│  │  (Server)   │     │  (Server)   │     │  (Server)   │                │
│  │             │     │             │     │             │                │
│  │ ┌─────────┐ │     │ ┌─────────┐ │     │ ┌─────────┐ │                │
│  │ │Topic A  │ │     │ │Topic A  │ │     │ │Topic A  │ │                │
│  │ │Part 0 L │ │     │ │Part 1 L │ │     │ │Part 2 L │ │                │
│  │ │Part 1 R │ │     │ │Part 2 R │ │     │ │Part 0 R │ │                │
│  │ └─────────┘ │     │ └─────────┘ │     │ └─────────┘ │                │
│  └─────────────┘     └─────────────┘     └─────────────┘                │
│         │                  │                   │                         │
│         └──────────────────┼───────────────────┘                         │
│                            │                                             │
│                   ┌────────────────┐                                     │
│                   │ ZooKeeper/KRaft│                                     │
│                   │ (Coordination) │                                     │
│                   └────────────────┘                                     │
└─────────────────────────────────────────────────────────────────────────┘
                    ▲                           │
                    │                           ▼
             ┌──────────┐                ┌─────────────┐
             │ PRODUCER │                │  CONSUMER   │
             │          │                │   GROUP     │
             └──────────┘                └─────────────┘
```

**L = Leader | R = Replica**

### Composants principaux

| Composant | Description | Rôle |
|-----------|-------------|------|
| **Cluster** | Ensemble de brokers | Infrastructure complète |
| **Broker** | Serveur Kafka | Stocke et sert les données |
| **Topic** | Catégorie logique | Nom/titre pour organiser les messages |
| **Partition** | Unité physique de stockage | Contient les messages ordonnés |
| **ZooKeeper/KRaft** | Service de coordination | Gère l'état du cluster, élection des leaders |

### Définitions clés

- **Kafka** : Plateforme de streaming distribuée pour stocker et transmettre des messages
- **Message** : Unité de donnée envoyée par un producer et lue par un consumer
- **Broker** : Serveur qui stocke les messages et répond aux requêtes
- **Topic** : Catégorie/nom logique pour organiser les messages (ne stocke rien lui-même)
- **Partition** : Division physique d'un topic, stockée sur un broker

---

## 2. 📦 Topic & Partitions

### Concept

```
TOPIC "commandes" (concept logique = juste un nom)
        │
        │ se divise en
        ▼
┌───────────────────────────────────────────────────────────────┐
│                                                               │
│  Partition 0          Partition 1          Partition 2        │
│  (physique)           (physique)           (physique)         │
│  ┌─────────────┐      ┌─────────────┐      ┌─────────────┐   │
│  │[0][1][2][3] │      │[0][1][2]    │      │[0][1][2][3] │   │
│  └─────────────┘      └─────────────┘      └─────────────┘   │
│   sur Broker 1         sur Broker 2         sur Broker 3      │
│                                                               │
└───────────────────────────────────────────────────────────────┘
```

### Points clés

| Point | Explication |
|-------|-------------|
| Topic | Concept **logique** (juste un nom) |
| Partition | Stockage **physique** sur un broker |
| Partition ne se divise pas | C'est l'unité finale |
| Offset | Position d'un message dans une partition (0, 1, 2...) |
| Ordre garanti | Seulement **dans une partition**, pas entre partitions |

### Structure d'une partition

```
Partition 0:
┌────────┬────────┬────────┬────────┬────────┬────────┐
│ Msg 0  │ Msg 1  │ Msg 2  │ Msg 3  │ Msg 4  │ Msg 5  │
│Offset=0│Offset=1│Offset=2│Offset=3│Offset=4│Offset=5│
└────────┴────────┴────────┴────────┴────────┴────────┘
                                              ▲
                                              │
                                    Nouveaux messages
                                    ajoutés à la fin
```

---

## 3. 📤 Producer (Envoi de messages)

### Flux d'envoi

```
┌──────────────────────────────────────────────────────────────┐
│                    PRODUCER ENVOIE MESSAGE                    │
│                             │                                 │
│                             ▼                                 │
│              ┌──────────────────────────────┐                │
│              │  Partition spécifiée ?       │                │
│              └──────────────┬───────────────┘                │
│                    │                │                         │
│                   OUI              NON                        │
│                    │                │                         │
│                    ▼                ▼                         │
│            Va dans         ┌────────────────┐                │
│            Partition X     │ Clé spécifiée? │                │
│                            └───────┬────────┘                │
│                              │           │                    │
│                             OUI         NON                   │
│                              │           │                    │
│                              ▼           ▼                    │
│                      hash(clé) %    Round-Robin               │
│                      nb_partitions  ou Sticky                 │
└──────────────────────────────────────────────────────────────┘
```

### Méthodes d'envoi

| Méthode | Code | Résultat |
|---------|------|----------|
| Partition forcée | `send(topic, partition=2, value)` | Va dans partition 2 |
| Avec clé | `send(topic, key="client_A", value)` | hash(clé) détermine partition |
| Sans rien | `send(topic, value)` | Round-robin ou sticky |

### Exemple avec clé

```python
# Même clé = toujours même partition = ordre garanti
producer.send("commandes", key="client_123", value="commande_1")
producer.send("commandes", key="client_123", value="commande_2")
producer.send("commandes", key="client_123", value="commande_3")

# Toutes ces commandes vont dans la MÊME partition
# L'ordre est garanti: commande_1 → commande_2 → commande_3
```

### Configuration acks (durabilité)

```
┌─────────────────────────────────────────────────────────────────┐
│                      NIVEAUX DE acks                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  acks=0        Producer ────► Broker                            │
│  (fire&forget)     │                                            │
│                    └─ N'attend rien (risque perte)              │
│                                                                 │
│  acks=1        Producer ────► Leader ✓                          │
│  (défaut)          │                                            │
│                    └─ Attend confirmation du leader seul        │
│                                                                 │
│  acks=all      Producer ────► Leader ────► Replicas ✓           │
│  (le plus sûr)     │                                            │
│                    └─ Attend confirmation de tous les ISR       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

| acks | Vitesse | Sécurité | Usage |
|------|---------|----------|-------|
| `0` | ⚡⚡⚡ Très rapide | ❌ Risque perte | Logs non critiques |
| `1` | ⚡⚡ Rapide | ⚠️ Moyen | Défaut |
| `all` | ⚡ Plus lent | ✅ Maximum | Données critiques |

### Configurations importantes du Producer

| Config | Description | Recommandation |
|--------|-------------|----------------|
| `acks` | Niveau de confirmation | `all` pour données critiques |
| `retries` | Nombre de tentatives | Élevé (ex: 2147483647) |
| `enable.idempotence` | Évite les doublons | `true` |
| `batch.size` | Taille du batch | 16384 (défaut) |
| `linger.ms` | Attente avant envoi | 5-100ms |

---

## 4. 📥 Consumer (Lecture de messages)

### Consumer Group

```
┌─────────────────────────────────────────────────────────────────┐
│                    TOPIC "commandes"                            │
│            (3 partitions: P0, P1, P2)                          │
│                                                                 │
│  ┌───────────┐    ┌───────────┐    ┌───────────┐               │
│  │    P0     │    │    P1     │    │    P2     │               │
│  └─────┬─────┘    └─────┬─────┘    └─────┬─────┘               │
│        │                │                │                      │
│        ▼                ▼                ▼                      │
│  ┌──────────────────────────────────────────────────────┐      │
│  │              CONSUMER GROUP A                         │      │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐      │      │
│  │  │ Consumer 1 │  │ Consumer 2 │  │ Consumer 3 │      │      │
│  │  │   ← P0     │  │   ← P1     │  │   ← P2     │      │      │
│  │  └────────────┘  └────────────┘  └────────────┘      │      │
│  └──────────────────────────────────────────────────────┘      │
│        │                │                │                      │
│        ▼                ▼                ▼                      │
│  ┌──────────────────────────────────────────────────────┐      │
│  │              CONSUMER GROUP B                         │      │
│  │         ┌────────────────────────┐                    │      │
│  │         │      Consumer 4        │                    │      │
│  │         │   ← P0, P1, P2         │                    │      │
│  │         └────────────────────────┘                    │      │
│  └──────────────────────────────────────────────────────┘      │
│                                                                 │
│  → Chaque groupe reçoit TOUS les messages                      │
│  → Dans un groupe, chaque partition = 1 seul consumer          │
└─────────────────────────────────────────────────────────────────┘
```

### Règles fondamentales

| Règle | Explication |
|-------|-------------|
| 1 partition = 1 consumer (par groupe) | Pas de partage d'une partition dans un groupe |
| 1 topic = plusieurs groupes | Chaque groupe reçoit tous les messages |
| Consumer > Partitions | Certains consumers seront inactifs |
| Partitions > Consumers | Un consumer lit plusieurs partitions |

### Cas pratiques

| Scénario | Comportement |
|----------|--------------|
| 3 partitions, 3 consumers (même groupe) | Chaque consumer lit 1 partition |
| 3 partitions, 2 consumers (même groupe) | 1 consumer lit 2 partitions, l'autre lit 1 |
| 3 partitions, 5 consumers (même groupe) | 3 consumers actifs, 2 inactifs |
| 3 partitions, 2 groupes différents | Chaque groupe reçoit TOUS les messages |

### Offset & Commit

```
Partition 0:
┌──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┐
│  0   │  1   │  2   │  3   │  4   │  5   │  6   │  7   │
└──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┘
                      ▲                           ▲
                      │                           │
               Committed                    Latest
               Offset = 3                   Offset = 7
                      │                           │
                      └───────────────────────────┘
                              LAG = 4
```

| Concept | Description |
|---------|-------------|
| **Offset** | Position du message (0, 1, 2...) |
| **Committed Offset** | Dernier offset confirmé traité |
| **Latest Offset** | Dernier message produit |
| **Lag** | Latest - Committed = retard du consumer |

### Modes de commit

| Mode | Config | Comportement | Risque |
|------|--------|--------------|--------|
| Auto | `auto.commit=true` | Commit toutes les 5s | Perte si crash après commit |
| Manuel | `auto.commit=false` | Commit après traitement | Plus sûr, plus de code |

### Exemple de code

```python
# Auto commit (défaut) - RISQUÉ
consumer = KafkaConsumer(
    'mon-topic',
    group_id='mon-groupe',
    enable_auto_commit=True,        # Commit auto
    auto_commit_interval_ms=5000    # Toutes les 5 secondes
)

# Manual commit (recommandé production) - SÛR
consumer = KafkaConsumer(
    'mon-topic',
    group_id='mon-groupe',
    enable_auto_commit=False        # Commit manuel
)

for msg in consumer:
    try:
        process(msg)                # Traitement du message
        consumer.commit()           # Commit APRÈS succès
    except Exception as e:
        handle_error(e)             # Pas de commit si erreur
```

### Configurations importantes du Consumer

| Config | Description | Recommandation |
|--------|-------------|----------------|
| `group.id` | Identifiant du groupe | Obligatoire |
| `enable.auto.commit` | Commit automatique | `false` en production |
| `auto.offset.reset` | Position si pas d'offset | `earliest` ou `latest` |
| `max.poll.records` | Messages par poll | 500 (défaut) |
| `session.timeout.ms` | Timeout heartbeat | 10000 (défaut) |

---

## 5. 🛡️ Réplication & Haute Disponibilité

### Architecture de réplication

```
┌─────────────────────────────────────────────────────────────────┐
│                 PARTITION 0 - RÉPLICATION                        │
│                                                                  │
│     BROKER 1              BROKER 2              BROKER 3         │
│  ┌───────────┐         ┌───────────┐         ┌───────────┐      │
│  │  LEADER   │ ──────► │ FOLLOWER  │         │ FOLLOWER  │      │
│  │           │         │  (ISR)    │         │  (ISR)    │      │
│  │ [0,1,2,3] │ ──────► │ [0,1,2,3] │ ──────► │ [0,1,2,3] │      │
│  └───────────┘         └───────────┘         └───────────┘      │
│       ▲                                                          │
│       │                                                          │
│   Producer                                                       │
│   Consumer                                                       │
│   (read/write)                                                   │
│                                                                  │
│  ISR = In-Sync Replicas = [Broker 1, Broker 2, Broker 3]        │
└─────────────────────────────────────────────────────────────────┘
```

### Concepts clés

| Concept | Description |
|---------|-------------|
| **Leader** | Seul à recevoir read/write |
| **Follower** | Copie les données du leader |
| **ISR** | Replicas synchronisés avec le leader |
| **Replication Factor** | Nombre total de copies (leader + followers) |

### Scénario de failover

```
AVANT:
Broker 1 [LEADER]  ──►  Broker 2 [FOLLOWER]  ──►  Broker 3 [FOLLOWER]
    │
    ▼
  CRASH!

APRÈS:
Broker 1 [DOWN]    Broker 2 [NOUVEAU LEADER]  ──►  Broker 3 [FOLLOWER]
                         │
                         ▼
                   Continue à servir
                   les requêtes
```

### Configuration sécurité

| Config | Valeur recommandée | Effet |
|--------|-------------------|-------|
| `replication.factor` | 3 | 3 copies de chaque partition |
| `min.insync.replicas` | 2 | Minimum 2 replicas doivent confirmer |
| `unclean.leader.election.enable` | false | Empêche un replica non-sync de devenir leader |

### Combinaison acks + min.insync.replicas

```
Exemple: replication.factor=3, min.insync.replicas=2, acks=all

Producer envoie message
        │
        ▼
    Leader (Broker 1) reçoit
        │
        ├──► Replica (Broker 2) reçoit ✓
        │
        └──► Replica (Broker 3) reçoit ✓
        
→ 2 replicas confirmés (>= min.insync.replicas)
→ Producer reçoit ACK
→ Message garanti durable
```

---

## 6. ⏰ Retention (Conservation des messages)

### Comportement unique de Kafka

```
┌─────────────────────────────────────────────────────────────────┐
│                    KAFKA vs AUTRES QUEUES                        │
│                                                                  │
│  RabbitMQ:     [msg] ──► Consumer ──► Message SUPPRIMÉ          │
│                                                                  │
│  Kafka:        [msg] ──► Consumer ──► Message GARDÉ 7 jours     │
│                              │                                   │
│                              └──► Autre Consumer peut relire     │
└─────────────────────────────────────────────────────────────────┘
```

### Avantages de la retention

- **Replay** : Relire les messages depuis un offset passé
- **Nouveaux consumers** : Peuvent lire l'historique
- **Debug** : Analyser les messages passés
- **Retraitement** : Corriger des erreurs de traitement

### Configuration retention

| Config | Défaut | Description |
|--------|--------|-------------|
| `retention.ms` | 604800000 (7 jours) | Durée de conservation |
| `retention.bytes` | -1 (illimité) | Taille max par partition |
| `cleanup.policy` | delete | `delete` ou `compact` |
| `segment.ms` | 604800000 (7 jours) | Durée d'un segment |

### Cleanup policies

| Policy | Comportement |
|--------|--------------|
| `delete` | Supprime les messages après retention.ms |
| `compact` | Garde seulement le dernier message par clé |
| `delete,compact` | Combine les deux |

---

## 7. 📊 Monitoring & Métriques

### Métriques essentielles

| Métrique | Signification | Seuil d'alerte |
|----------|---------------|----------------|
| **Consumer Lag** | Retard de consommation | > 1000 messages |
| **UnderReplicatedPartitions** | Partitions mal répliquées | > 0 |
| **OfflinePartitionsCount** | Partitions sans leader | > 0 |
| **ISR Shrink/Expand** | Changements ISR fréquents | Trop fréquent = problème |
| **Request Latency** | Temps de réponse | > 100ms |
| **Bytes In/Out** | Débit réseau | Selon capacité |
| **Active Controller Count** | Nombre de controllers | Doit être 1 |

### Consumer Lag (métrique #1)

```
┌─────────────────────────────────────────────────────────────────┐
│                    CONSUMER LAG                                  │
│                                                                  │
│  Lag faible (OK):                                               │
│  Producer: ████████████████████░░░░░                            │
│  Consumer: ██████████████████░░░░░░░   Lag = 2 ✅               │
│                                                                  │
│  Lag élevé (PROBLÈME):                                          │
│  Producer: ████████████████████████████                         │
│  Consumer: ████████░░░░░░░░░░░░░░░░░░   Lag = 500 ❌            │
│                                                                  │
│  Causes possibles:                                               │
│  - Consumer trop lent                                            │
│  - Pas assez de consumers                                        │
│  - Traitement bloqué                                             │
│  - Problème réseau                                               │
│  - GC pauses                                                     │
└─────────────────────────────────────────────────────────────────┘
```

### Comment surveiller le lag

```bash
# Commande pour voir le lag
kafka-consumer-groups.sh --describe --group mon-groupe \
    --bootstrap-server localhost:9092

# Output:
# GROUP      TOPIC       PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG
# mon-groupe mon-topic   0          1000            1050            50
# mon-groupe mon-topic   1          2000            2000            0
# mon-groupe mon-topic   2          1500            1600            100
```

---

## 8. 🔧 Commandes CLI Essentielles

### Topics

```bash
# Lister tous les topics
kafka-topics.sh --list --bootstrap-server localhost:9092

# Créer un topic
kafka-topics.sh --create --topic mon-topic \
    --partitions 3 \
    --replication-factor 2 \
    --bootstrap-server localhost:9092

# Décrire un topic (partitions, replicas, ISR)
kafka-topics.sh --describe --topic mon-topic \
    --bootstrap-server localhost:9092

# Modifier le nombre de partitions (augmenter seulement)
kafka-topics.sh --alter --topic mon-topic \
    --partitions 6 \
    --bootstrap-server localhost:9092

# Supprimer un topic
kafka-topics.sh --delete --topic mon-topic \
    --bootstrap-server localhost:9092
```

### Consumer Groups

```bash
# Lister les consumer groups
kafka-consumer-groups.sh --list --bootstrap-server localhost:9092

# Voir détails + LAG d'un groupe
kafka-consumer-groups.sh --describe --group mon-groupe \
    --bootstrap-server localhost:9092

# Reset offset au début
kafka-consumer-groups.sh --group mon-groupe \
    --topic mon-topic \
    --reset-offsets --to-earliest --execute \
    --bootstrap-server localhost:9092

# Reset offset à une date
kafka-consumer-groups.sh --group mon-groupe \
    --topic mon-topic \
    --reset-offsets --to-datetime 2024-01-01T00:00:00.000 --execute \
    --bootstrap-server localhost:9092

# Reset offset à un offset spécifique
kafka-consumer-groups.sh --group mon-groupe \
    --topic mon-topic \
    --reset-offsets --to-offset 1000 --execute \
    --bootstrap-server localhost:9092
```

### Debug / Test

```bash
# Produire des messages (test)
kafka-console-producer.sh --topic mon-topic \
    --bootstrap-server localhost:9092

# Produire avec clé
kafka-console-producer.sh --topic mon-topic \
    --property "key.separator=:" \
    --property "parse.key=true" \
    --bootstrap-server localhost:9092
# Puis taper: clé:valeur

# Consommer depuis le début
kafka-console-consumer.sh --topic mon-topic \
    --from-beginning \
    --bootstrap-server localhost:9092

# Consommer avec un groupe
kafka-console-consumer.sh --topic mon-topic \
    --group test-group \
    --bootstrap-server localhost:9092

# Consommer et afficher clé + valeur
kafka-console-consumer.sh --topic mon-topic \
    --property print.key=true \
    --property key.separator=" : " \
    --from-beginning \
    --bootstrap-server localhost:9092
```

### Cluster / Brokers

```bash
# État du cluster
kafka-broker-api-versions.sh --bootstrap-server localhost:9092

# Vérifier la config d'un broker
kafka-configs.sh --describe --broker 0 \
    --bootstrap-server localhost:9092

# Vérifier les logs d'une partition
kafka-dump-log.sh --files /var/kafka-logs/mon-topic-0/00000000000000000000.log \
    --print-data-log
```

### Tableau récapitulatif des commandes

| Besoin | Commande |
|--------|----------|
| Lister topics | `kafka-topics.sh --list` |
| Créer topic | `kafka-topics.sh --create --topic X --partitions N` |
| Décrire topic | `kafka-topics.sh --describe --topic X` |
| Voir lag | `kafka-consumer-groups.sh --describe --group X` |
| Reset offset | `kafka-consumer-groups.sh --reset-offsets` |
| Produire (test) | `kafka-console-producer.sh --topic X` |
| Consommer (test) | `kafka-console-consumer.sh --topic X` |

---

## 9. ⚠️ Erreurs courantes

| Erreur | Cause | Solution |
|--------|-------|----------|
| `LEADER_NOT_AVAILABLE` | Broker leader down | Vérifier état des brokers |
| `NOT_ENOUGH_REPLICAS` | ISR < min.insync.replicas | Attendre sync ou réduire min.insync |
| `OFFSET_OUT_OF_RANGE` | Offset demandé n'existe plus (retention) | Reset offset |
| `REBALANCE_IN_PROGRESS` | Groupe en réorganisation | Attendre stabilisation |
| `UNKNOWN_TOPIC` | Topic n'existe pas | Créer le topic |
| `RECORD_TOO_LARGE` | Message > max.message.bytes | Augmenter limite ou réduire message |
| `REQUEST_TIMED_OUT` | Broker ne répond pas | Vérifier réseau/broker |
| `GROUP_COORDINATOR_NOT_AVAILABLE` | Coordinator down | Vérifier brokers |

### Diagnostic rapide

```bash
# Étape 1: Vérifier les brokers
kafka-broker-api-versions.sh --bootstrap-server localhost:9092

# Étape 2: Vérifier le topic
kafka-topics.sh --describe --topic mon-topic --bootstrap-server localhost:9092

# Étape 3: Vérifier le consumer group
kafka-consumer-groups.sh --describe --group mon-groupe --bootstrap-server localhost:9092

# Étape 4: Vérifier les logs
tail -f /var/log/kafka/server.log
```

---

## 10. 🛡️ Éviter la perte de messages

### Checklist complète

```
┌─────────────────────────────────────────────────────────────────┐
│              GARANTIR ZÉRO PERTE DE MESSAGES                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  PRODUCER:                                                      │
│  ✅ acks=all                                                    │
│  ✅ retries=MAX_INT (ou très élevé)                            │
│  ✅ enable.idempotence=true                                     │
│  ✅ max.in.flight.requests.per.connection=5                     │
│                                                                 │
│  BROKER:                                                        │
│  ✅ replication.factor=3                                        │
│  ✅ min.insync.replicas=2                                       │
│  ✅ unclean.leader.election.enable=false                        │
│                                                                 │
│  CONSUMER:                                                      │
│  ✅ enable.auto.commit=false                                    │
│  ✅ Commit APRÈS traitement réussi                              │
│  ✅ Gérer les erreurs avant commit                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Exemple de configuration Producer (Java)

```java
Properties props = new Properties();
props.put("bootstrap.servers", "localhost:9092");
props.put("acks", "all");
props.put("retries", Integer.MAX_VALUE);
props.put("enable.idempotence", true);
props.put("max.in.flight.requests.per.connection", 5);
```

### Exemple de configuration Consumer (Python)

```python
consumer = KafkaConsumer(
    'mon-topic',
    bootstrap_servers=['localhost:9092'],
    group_id='mon-groupe',
    enable_auto_commit=False,
    auto_offset_reset='earliest'
)

for message in consumer:
    try:
        # Traitement
        process(message)
        # Commit seulement si succès
        consumer.commit()
    except Exception as e:
        # Log l'erreur, ne commit pas
        log_error(e)
```

---

## 11. 📋 Checklist Entretien Junior

### Ce que tu dois savoir expliquer

```
┌─────────────────────────────────────────────────────────────────┐
│                KAFKA - CE QUE TU DOIS SAVOIR                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ ARCHITECTURE:                                                   │
│ □ Broker = serveur Kafka                                        │
│ □ Topic = nom logique (ne stocke rien)                          │
│ □ Partition = stockage physique (unité finale)                  │
│ □ ZooKeeper/KRaft = coordination du cluster                     │
│                                                                 │
│ PRODUCER:                                                       │
│ □ 3 modes d'envoi: partition forcée, clé, round-robin           │
│ □ acks: 0 (rapide/risqué), 1 (défaut), all (sûr)               │
│ □ Même clé = même partition = ordre garanti                     │
│                                                                 │
│ CONSUMER:                                                       │
│ □ Consumer Group = partage des partitions                       │
│ □ 1 partition = 1 consumer (par groupe)                         │
│ □ 1 topic = plusieurs groupes possibles                         │
│ □ Offset = position de lecture                                  │
│ □ Commit = sauvegarder la position                              │
│ □ Lag = retard à surveiller (#1 métrique)                       │
│                                                                 │
│ RÉPLICATION:                                                    │
│ □ Leader = seul à recevoir read/write                           │
│ □ Follower = copie de backup                                    │
│ □ ISR = replicas synchronisés                                   │
│ □ Replication factor = nombre de copies                         │
│                                                                 │
│ RETENTION:                                                      │
│ □ Messages gardés même après consommation                       │
│ □ Configurable en durée ou taille                               │
│                                                                 │
│ COMMANDES CLI:                                                  │
│ □ kafka-topics.sh --describe                                    │
│ □ kafka-consumer-groups.sh --describe (voir lag)                │
│ □ kafka-console-consumer.sh (debug)                             │
│                                                                 │
│ BONNES PRATIQUES:                                               │
│ □ acks=all pour données critiques                               │
│ □ auto.commit=false en production                               │
│ □ Surveiller le consumer lag                                    │
│ □ replication.factor >= 3                                       │
│ □ min.insync.replicas >= 2                                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Questions d'entretien types

| Question | Points clés à mentionner |
|----------|-------------------------|
| Comment diagnostiquer un broker down ? | UI NameNode, `kafka-broker-api-versions`, logs, métriques JMX |
| Différence consumer group vs consumer ? | Consumer = instance unique, Group = ensemble qui partage les partitions |
| Comment éviter la perte de messages ? | acks=all, min.insync.replicas=2, auto.commit=false |
| C'est quoi le lag ? | Différence entre dernier message produit et consommé |
| Pourquoi utiliser une clé ? | Garantir l'ordre des messages liés |
| C'est quoi ISR ? | In-Sync Replicas = replicas à jour avec le leader |

---

## 12. 🎯 Résumé en une page

```
╔═══════════════════════════════════════════════════════════════════╗
║                        KAFKA EN BREF                               ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                    ║
║  ARCHITECTURE:  Cluster → Brokers → Topics → Partitions           ║
║                                                                    ║
║  FLUX:          Producer → Topic/Partition → Consumer             ║
║                                                                    ║
║  STOCKAGE:      Topic = logique | Partition = physique            ║
║                                                                    ║
║  DISTRIBUTION:  Clé → hash → Partition (même clé = même partition)║
║                                                                    ║
║  CONSOMMATION:  1 partition = 1 consumer par groupe               ║
║                 1 topic = plusieurs groupes possibles             ║
║                                                                    ║
║  DURABILITÉ:    acks=all + replication + min.insync.replicas      ║
║                                                                    ║
║  SÉCURITÉ:      auto.commit=false + commit après traitement       ║
║                                                                    ║
║  MONITORING:    Consumer Lag = métrique #1 à surveiller           ║
║                                                                    ║
║  COMMANDES:     kafka-topics.sh, kafka-consumer-groups.sh         ║
║                                                                    ║
╚═══════════════════════════════════════════════════════════════════╝
```

---

> **Bonne chance pour ton entretien !** 🚀