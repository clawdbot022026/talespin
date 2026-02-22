# 🔄 Iteration 5: The "Big Table" Approach (Cassandra/ScyllaDB)

## 🏗️ Proposed Stack
*   **Database:** ScyllaDB (High throughput NoSQL).
*   **Pattern:** Adjacency List.
    *   Row: `PartitionKey: ParentID` -> `ClusteringKey: VoteCount` -> `Value: ChildID`.

## 🧪 Evaluation
*   **Pros:** Insane write speed (millions/sec). Perfect for the "Vote" blast.
*   **The Magic:** We can store children *sorted by votes* automatically on disk!
*   **Cons:**
    *   **Content:** Scylla isn't great for text blobs.
    *   **Consistency:** Eventual consistency might mean you see a branch 1 second later (Acceptable).

## 💡 Insight
This handles the "Ranked Children" problem perfectly. We just need to separate the *Structure* from the *Content*.

## 🚨 Verdict: STRONG CANDIDATE (Backend)
But what about the Content?
