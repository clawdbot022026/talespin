# 🔄 Iteration 3: The "NoSQL" Stack (MongoDB)

## 🏗️ Proposed Stack
*   **Database:** MongoDB (Document Store).
*   **Structure:** Each Story is a Document? No, hit 16MB limit. Each Node is a Document with `parentId`.

## 🧪 Evaluation
*   **Pros:** Fast writes. Easy to scale (Sharding).
*   **Cons:**
    *   **The Traversal Nightmare:** To find the next nodes, you have to query `db.nodes.find({ parentId: currentId })`. To load a full tree, you need dozens of round-trips to the DB.
    *   **Joins:** Graph lookups in Mongo (`$graphLookup`) are heavy on memory.

## 🚨 Verdict: REJECTED
Network latency from recursive lookups will kill the user experience.
