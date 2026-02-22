# 🔄 Iteration 10: The "Final Polish" (The Stack)

## 🏗️ The Winner Stack
*   **Core DB:** **PostgreSQL** (Content, Users, Relationships).
*   **Caching/Hot Votes:** **Redis** (Vote buffers, Hot Story caching).
*   **Backend:** **Go (Golang)** (High concurrency for API).
*   **Frontend:** **Flutter** (Rendering the Tree Canvas).
*   **Search:** **ElasticSearch** (Finding stories/tags).

## 🧪 why this is Perfect
1.  **Reads:** Users mostly read the "Canon". We store this as a JSON array in Postgres or cache in Redis. 1 Query = Full Story.
2.  **Writes:** New branches are just `INSERT INTO nodes`. Cheap.
3.  **Votes:** Handled by Redis (fast), synced to SQL (durable).
4.  **Cost:** Postgres is cheap and runs everywhere (AWS RDS, Supabase). No niche Graph DB licenses.

## 🚀 Final Architecture Diagram
[Mobile App] -> [Go API] -> [Redis (Write Buffer)]
                          -> [Postgres (Persistent Data)]
                          -> [Worker (Path Calculator)]
