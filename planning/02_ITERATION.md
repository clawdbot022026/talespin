# 🔄 Iteration 2: The "Relational" Stack (PostgreSQL)

## 🏗️ Proposed Stack
*   **Database:** PostgreSQL (using Recursive CTEs or `ltree` extension).
*   **Backend:** Go (Golang) for raw performance.
*   **Frontend:** Flutter.

## 🧪 Evaluation
*   **Pros:** Postgres is rock solid. `ltree` stores paths (`root.child.grandchild`) effectively for fast reads. ACID compliance ensures no orphaned nodes.
*   **Cons:**
    *   **The "Canon" Problem:** Calculating the "Max Voted Path" requires traversing *every* branch and summing votes. Doing this in SQL for a 100-level deep story with 10k branches is slow.
    *   **Content Bloat:** Storing millions of text blobs in Postgres can slow down the main table.

## 🚨 Verdict: PARTIAL FAIL
Good for structure, bad for the specific "Vote Summation" algorithm we need for the Canon logic.
