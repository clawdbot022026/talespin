# TaleSpin: Phase 1 Action & Status Tracker

This document tracks the granular development status of TaleSpin Phase 1 (The Core Hook).

---

## 🟢 1. Backend API (Golang)

**Status:** In Progress (Foundation Built)
**Location:** `/backend`

| Feature / Component | Status | Details |
| :--- | :--- | :--- |
| **Go Module Init** | ✅ Done | Initialized Fiber, GORM, Postgres driver, Redis v9. |
| **Database Connection** | ✅ Done | Postgres connection pooling and `LTREE` extension creation. |
| **Redis Connection** | ✅ Done | Redis v9 client configured for vote buffering. |
| **Schema: `User` Model** | ✅ Done | UUID, Username, Email, Avatar URL. |
| **Schema: `Story` Model** | ✅ Done | UUID, Title, Tags, Author FK (Genesis Node pointer). |
| **Schema: `Node` Model** | ✅ Done | UUID, Story FK, Parent FK, Content (280 char max), VoteCount, Path (LTREE). |
| **API: Health Check** | ✅ Done | `GET /api/health` |
| **API: Get Trending** | ✅ Done | `GET /api/stories/trending` (Live feed wired to DB). |
| **API: Create Genesis** | ✅ Done | `POST /api/stories` (Handles cross-table atomic Node creation). |
| **API: Branch/Continue** | ✅ Done | `POST /api/nodes/:id/branch` (Using PostgreSQL LTREE replacement for 0(1) graph insertions). |
| **API: Get Story Graph** | ✅ Done | `GET /api/stories/:id/nodes` (Fetches entire graph in Pre-Order using LTREE). |
| **API: Vote Node** | ❌ Pending | `POST /api/nodes/:id/vote` (Requires Redis buffering logic). |

---

## 🔵 2. Frontend UI/UX (Flutter)

**Status:** Awaiting Initialization
**Location:** `/frontend`

### The "Deep Space / Neon" Aesthetic Mandate
TaleSpin must feel like a premium, frictionless, collaborative artifact.

*   **Color Palette:**
    *   Background: True Black `#000000` (OLED friendly) or Deep Violet-Black `#0A0910`.
    *   Surfaces/Cards: Slightly lifted `#15141A` with subtle white borders (`opacity: 0.1`).
    *   Neon Accents (Glowing): Cyan `#00E5FF` (For Canon Path) and Magenta `#FF007F` (For Alternative Paths).
*   **Typography:** Google Font `Outfit` (Modern, geometric, clean).

### Screen-by-Screen Layout Specifications

#### 1. The Global Feed (Home Screen)
**Mobile Layout:**
*   **Top Bar:** "TaleSpin" neon logo (Left). Search Icon & Profile Avatar (Right).
*   **Content:** A vertical list of large Story Cards.
*   **Story Card Design:** Uses 90% of screen width. Contains: Title, Genesis Author Avatar, 3 Tags (e.g. `sci-fi`), Total Nodes/Length, and a "Trending" sparkline graph visualizing recent vote activity.
*   **Action:** Tapping anywhere heavily presses the card inwards (haptic feedback) and opens the Reader.

**Tablet/Desktop Layout:**
*   **Left Sidebar:** Navigation (Home, My Library, Notifications) fixed.
*   **Content Area:** Masonry grid layout (2 or 3 columns) of Story Cards to utilize wide screens.

#### 2. The Engine Room (Reader / Branching view)
**Mobile Layout:**
*   **The Breadcrumb Header (Top 10%):** A horizontally scrolling list of tiny dots or the first word of previous nodes. Shows context.
*   **The Main Node (Center 50%):** The current text block (up to 280 chars) styled beautifully. Large text, highly readable.
*   **The Multiverse Indicator:** If this node has 3 children (branches), show a glowing "1 of 3 Timelines" indicator below the text.
    *   *Interaction:* Swipe Left/Right anywhere on the screen gently transitions to timeline 2 or 3.
*   **The Action Bar (Bottom 20%):**
    *   Floating Action Button (Large, Primary Color): **"Continue Story"**
    *   Secondary Button (Outline): **"Branch Here"**
    *   Upvote Button: Sparkles/glows when pressed.

**Tablet/Desktop Layout:**
*   **Left Panel (30% width):** Shows a massive vertically scrolling thread of the entire prior history leading up to the current node.
*   **Right Panel (70% width):** The active reading/writing zone. The "Multiverse Indicator" doesn't require swiping—instead, alternative branches are shown side-by-side as distinct columns a user can click into.

#### 3. The Composer (Writing Modal)
*   Must slide up seamlessly.
*   Full-screen immersive text input.
*   Character counter at the bottom tracking up to 280 characters.
*   "Publish to Multiverse" final button.

---

*Last Updated: Phase 1 Setup*
