# 🏰 TaleSpin: The Final Architecture

After 10 iterations of rigorous analysis, we have selected the **"Hybrid SQL + Redis Buffer"** architecture. This prioritizes **Read Performance** (for the millions of readers) while handling **Write Bursts** (viral voting moments).

---

## 1. The Stack 🛠️

| Component | Technology | Reasoning |
| :--- | :--- | :--- |
| **Frontend** | **Flutter** | Best for rendering the custom "Tree Graph" UI smoothly on iOS/Android/Web. |
| **Backend API** | **Go (Golang)** | High concurrency, low latency, typesafe. Perfect for handling 100k+ WebSocket connections. |
| **Primary DB** | **PostgreSQL** | Stores Nodes (Text), Users, and Relationships. Reliable, cheap, SQL joins are fast enough for hierarchy if indexed correctly. |
| **Hot Cache** | **Redis** | Buffers incoming votes. Caches the "Canon Path" of trending stories. |
| **Search** | **MeiliSearch / Elastic** | Full-text search for finding stories. |

---

## 2. Data Model (PostgreSQL)

We use a **Materialized Path** approach for fast tree traversal.

### Table: `nodes`
| Column | Type | Index |
| :--- | :--- | :--- |
| `id` | UUID | PK |
| `story_id` | UUID | FK |
| `parent_id` | UUID | FK |
| `content` | TEXT | |
| `path` | LTREE / TEXT | Index (Fast retrieval of descendants) |
| `vote_count` | INT | Index |

### Table: `canon_paths` (The Optimization)
| Column | Type |
| :--- | :--- |
| `story_id` | UUID |
| `node_ids` | JSONB Array (Ordered list of nodes in the main path) |

---

## 3. The "Canon" Algorithm (The Secret Sauce) 🧠

**Problem:** How to determine the "Main Story" from 10,000 branches in real-time?

**Solution: The Async Vote Pump**
1.  **User Votes:** Request goes to API -> **Redis** (`INCR vote:node_123`). UI updates instantly (Optimistic).
2.  **Worker (Go):** Every 5-10 seconds, pulls vote counts from Redis and updates Postgres `nodes` table.
3.  **Recalculator:** If a node's vote count flips the leaderboard, the Worker updates the `canon_paths` table.
4.  **Reader:** When a user opens a story, API fetches `canon_paths` (1 Query). **Load time: < 50ms.**

---

## 4. Scalability Plan 📈

*   **10k Users:** Single Postgres RDS (t3.medium). Redis (t3.small).
*   **1M Users:**
    *   **Read Replicas:** 3x Postgres Readers.
    *   **CDN:** CloudFront for caching the API responses of "Finished Stories".
    *   **Sharding:** Shard `nodes` table by `story_id`.

---

*Status: Ready for Implementation*
