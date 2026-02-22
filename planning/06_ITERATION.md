# 🔄 Iteration 6: The "Separation of Concerns" (Scylla + S3/CDN)

## 🏗️ Proposed Stack
*   **Structure/Votes:** ScyllaDB (Adjacency List sorted by Votes).
*   **Content (Text/Images):** Amazon S3 + CloudFront (Immutable JSON blobs).
*   **Backend:** Go.

## 🧪 Evaluation
*   **Flow:**
    1.  User posts node.
    2.  Server saves text to S3 -> `s3://nodes/node_123.json`.
    3.  Server writes relationship to Scylla: `INSERT INTO edges (parent, votes, child) VALUES (...)`.
*   **Pros:** Infinite storage scale. Scylla handles the "Canon" logic (getting top Voted children) in O(1).
*   **Cons:** S3 latency (50-100ms) might be too slow for fetching *individual* text lines while scrolling.

## 🚨 Verdict: ALMOST THERE
S3 is too slow for small text chunks. We need a faster content store.
