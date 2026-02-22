# 🔄 Iteration 8: The "Materialized Path" (Postgres Optimized)

## 🏗️ Proposed Stack
*   **Database:** PostgreSQL.
*   **Optimization:** Store the "Canon Path" as a Materialized View.
    *   Table `nodes`: `id, content, parent_id`
    *   Table `votes`: `node_id, user_id`
    *   Table `canon_paths`: `story_id, path_array []` (Updated via Trigger).

## 🧪 Evaluation
*   **Pros:** When a user opens a story, we just fetch `SELECT path_array FROM canon_paths`. 1 Query. Instant load.
*   **Cons:** Write Amplification. Every single vote triggers a recalculation of the "Canon".
    *   If 10,000 people vote per second, the database locks up trying to update the path.

## 🚨 Verdict: PARTIAL SUCCESS
Great for Reads, Suicide for Writes. We need to decouple the "Vote" from the "Path Calculation".
