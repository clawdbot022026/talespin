# 🔄 Iteration 7: The "Redis as Primary" (For Hot Content)

## 🏗️ Proposed Stack
*   **Hot Layer:** Redis (Cluster). Stores the Tree Structure + Content of active stories.
*   **Cold Layer:** Postgres/S3. Archives old stories.

## 🧪 Evaluation
*   **Pros:** Sub-millisecond reads. Instant scrolling.
*   **Cons:** RAM is expensive. If we have 1 Billion nodes, Redis cluster costs will bankrupt us.
*   **Complexity:** Managing the "Hot vs Cold" tiering logic is a nightmare.

## 🚨 Verdict: REJECTED
Too expensive for a text-heavy app.
