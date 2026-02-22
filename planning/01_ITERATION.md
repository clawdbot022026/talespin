# 🔄 Iteration 1: The "Obvious" Stack (Graph DB)

## 🏗️ Proposed Stack
*   **Database:** Neo4j (Native Graph DB).
*   **Backend:** Node.js (Express).
*   **Frontend:** Flutter.
*   **Cache:** Redis.

## 🧪 Evaluation
*   **Pros:** Neo4j is built for this. `MATCH (p:Node)-[:NEXT*]->(c:Node)` queries are easy to write. Visualizing the tree is intuitive.
*   **Cons:**
    *   **Cost:** Neo4j Enterprise is extremely expensive at scale.
    *   **Write Speed:** Graph DBs can struggle with massive concurrent writes (e.g., 100k people voting/branching at once).
    *   **Overkill:** We don't need complex relations (Friend of a Friend). We only need *Tree* traversal (Parent-Child).

## 🚨 Verdict: REJECTED
Too expensive and hard to scale writes horizontally. We need something more optimized for hierarchical data, not general graphs.
