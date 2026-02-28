# TaleSpin: Phase 1 (The Core Hook) Execution Plan

**Goal:** Launch the MVP (Minimum Viable Product). Prove the core loop of frictionless reading, simple branching, and voting. Develop a highly polished, addictive UI from day one.

**Deadline (Suggested):** 6-8 Weeks

---

## 🏗️ 1. Technical Foundation

*   **Frontend Repository:** Flutter (Web & Mobile).
*   **Backend Repository:** Go (Golang) REST + WebSockets API.
*   **Database:** PostgreSQL (using `LTREE` extension for graph paths).
*   **Caching/Queue:** Redis (for vote buffering and session management).
*   **Auth:** Firebase Auth (Email/Google) - Simplest for Day 1.

---

## ✅ 2. Feature Breakdown & Requirements

### Feature 1: The Frictionless Reader (Guest Mode)
Users must be able to experience the app's magic within 3 seconds of opening it, without logging in.

*   **Requirements:**
    *   **The Global Feed:** A scrolling list of "Trending Genesis Nodes" (story starters) ranked by activity (velocity of new branches/votes).
    *   **The Reader View:** A clean, immersive reading experience showing the `Canon Path` of a selected story.
    *   **Branch Navigation:** At a junction point (where a node has multiple children), the user sees a UI indicator (e.g., "3 Alternative Paths"). Swiping left/right reveals these alternative timelines.
    *   **Limits:** Guests cannot vote, branch, or continue. Clicking these actions triggers a beautiful, non-intrusive "Log in to shape the multiverse" modal.

### Feature 2: Authentication System
Required strictly for participating in the ecosystem.

*   **Requirements:**
    *   **Methods:** Google Sign-In, Apple Sign-In, Email/Password.
    *   **Profile Creation:** Users pick a unique `@username` and a profile picture upon first login.
    *   **Session Management:** Secure JWT tokens stored on the client.

### Feature 3: The Engine Room (Writing & Branching)
The core mechanical loop of TaleSpin. All inputs are constrained to enforce fast-paced storytelling.

*   **Requirements:**
    *   **Start a Story (Genesis Node):** Users can create a new story from scratch. Must include a Title, Tags (e.g., #sci-fi, #horror), and the first node's text.
    *   **"Continue" Action:** Appends a new child node to the *current* node being viewed.
    *   **"Branch Here" Action:** If a node already has a child, the user creates an alternative child, splitting the timeline.
    *   **Constraints:**
        *   Min Length: 50 characters (No "lol next" spam).
        *   Max Length: 280 characters (Twitter-style punchiness).
        *   One-Step Rule: A user cannot reply to their own node immediately.

### Feature 4: The Canon System (Voting & Reality)
How the community decides the "Main Story".

*   **Requirements:**
    *   **Upvoting:** Users can upvote any node they like.
    *   **Visual Distinction:** The node with the highest cumulative votes at any junction visually becomes the "Thick Line" (Canon Path). The others become "Thin Lines" (Alternative Paths).
    *   **The Real-Time Flip:** If Branch B suddenly gets more votes than Branch A, the UI must dynamically reflect Branch B becoming the new Canon Path.
    *   **Performance Optimization:** The Go backend handles votes asynchronously. It pumps votes into Redis, and a background worker updates the Postgres database every 10 seconds to prevent DB locking.

### Feature 5: The "Mini-Map" (Tree Visualization MVP)
Users need to understand they are in a tree, not a flat feed.

*   **Requirements:**
    *   **The Locator:** A simple visual indicator at the top of the screen showing how deep they are (e.g., "Node 45/112").
    *   **The Path Breadcrumbs:** A horizontal scrolling view showing the IDs or first 3 words of the parent nodes leading up to the current moment. (We will save the complex 2D zoomable graph map for Phase 3).

---

## 🎨 3. UI/UX Aesthetic Mandates (The "Premium" Feel)
Because the backend is simple for Phase 1, the frontend *must carry the product*.

*   **Theme:** "Deep Space / Neon". Very dark backgrounds (`#0A0A0A` or true OLED black) with vibrant, glowing accent colors for interactive elements.
*   **Typography:** Modern, highly legible sans-serif (e.g., *Inter*, *SF Pro*, or *Outfit*). High contrast for reading mode.
*   **Micro-interactions:**
    *   When switching timelines (swiping left/right), the screen should do a subtle "glitch" or smooth slide transition.
    *   Voting a node should trigger a satisfying, glowing haptic pop.
    *   Publishing a node should feel instant (Optimistic UI updates).

---

## 🚀 4. Action Items to Start Code

1.  **Initialize Flutter App:** Set up routing, state management (Riverpod/Bloc), and the base theme.
2.  **Initialize Go API:** Set up Gin/Fiber framework, Postgres connection pool, and Redis client.
3.  **Database Migration 001:** Create the `users`, `stories`, and complex `nodes` (with LTREE) tables.
4.  **API Endpoints:**
    *   `POST /api/auth/register`
    *   `GET /api/stories/trending`
    *   `GET /api/stories/{id}/canon` (Fetches the main path fast)
    *   `POST /api/nodes/{id}/branch`
    *   `POST /api/nodes/{id}/vote` (Hits Redis)

Let the multiverse begin.
