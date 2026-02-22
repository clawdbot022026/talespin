# 📋 Product Requirements Document (PRD) - TaleSpin

**Target Scale:** 1M+ Daily Active Users (DAU).
**Core Challenge:** Infinite Branching Data Structure (Trees/Graphs) at scale.

## 1. Functional Requirements
*   **The Tree:** Users can view a story as a visual tree.
*   **The Branch:** Users can attach a new node to *any* existing node.
*   **The Traverse:** Fast retrieval of the "Canon Path" (Root -> Leaf with max votes).
*   **The Feed:** Personalized feed of "Genesis Nodes" and "Trending Branches".
*   **Real-Time:** Votes and new branches should appear near-instantly.

## 2. Technical Constraints & Performance Goals
*   **Read vs. Write Ratio:** Heavily Read-Biased (100 Reads : 1 Write).
    *   *Implication:* Caching and Read Replicas are critical.
*   **Latency:**
    *   Story Traversal (Loading the path): < 100ms.
    *   Vote Count Update: Near real-time (< 500ms).
*   **Data Integrity:** A branch *must* point to a valid parent. No orphaned nodes.
*   **Cost Efficiency:** Graph DBs are expensive. We need a cost-effective way to store millions of text nodes.

## 3. The "Hard" Problems
1.  **The "Canon" Query:** "Given Node A, find the full path to the end with the highest sum of votes at every step." (This is a heavy graph algorithm).
2.  **The "Withering":** efficiently hiding/archiving millions of 0-vote branches without slowing down the active tree.
3.  **Notifications:** "Someone branched from your node 3 layers deep." (Fan-out complexity).

## 4. Platform
*   **Mobile (iOS/Android):** Flutter (High performance rendering of the Tree Canvas).
*   **Web:** Flutter Web or React (SEO might matter for public stories).

---
*Status: Locked for Architectural Analysis*
