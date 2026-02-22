# 🔄 Iteration 4: The "Hybrid" Stack (SQL + Graph)

## 🏗️ Proposed Stack
*   **Storage:** Postgres (for Text Content & Users).
*   **Graph:** Apache AGE (Graph extension for Postgres) or Dgraph.
*   **Backend:** Rust (Actix) for maximum throughput.

## 🧪 Evaluation
*   **Pros:** Best of both worlds?
*   **Cons:** Complexity. Maintaining two synchronous states is a bug factory. Apache AGE is still maturing. Dgraph is great but adds operational overhead (managing another cluster).

## 🚨 Verdict: REJECTED
Too complex for an MVP. We need a simpler architecture that scales.
