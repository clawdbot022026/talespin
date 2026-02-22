# 🔄 Iteration 9: The "Vote Sharding" Architecture

## 🏗️ Proposed Stack
*   **Database:** PostgreSQL (Nodes & Content).
*   **Vote Counter:** Redis HyperLogLog (Approximate) or Counter Tables.
*   **Path Calculation:** Async Worker (Go) runs every 10 seconds.

## 🧪 Evaluation
*   **Flow:**
    1.  User votes.
    2.  Redis increments `vote:node_123`.
    3.  User sees the count go up instantly (Optimistic UI).
    4.  Every 10s, a Worker reads Redis, updates Postgres, and recalculates the "Canon" line.
*   **Pros:** Writes are instant (Redis). Reads are instant (Postgres Materialized Path).
*   **Cons:** "Canon" updates lag by 10s. (Acceptable for UX).

## 🚨 Verdict: STRONG WINNER
This balances Cost, Consistency, and Speed.
