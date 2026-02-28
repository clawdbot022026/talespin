# TaleSpin: Phased Implementation Roadmap

Building TaleSpin requires a strategic rollout. If we build heavy AI features on day one, we waste time on infrastructure before verifying the core loop. The strategy is to build a **Minimum Viable Experience (MVE)** with a world-class UI, get users hooked on the branching mechanic, and *then* introduce advanced features as the tree grows too complex.

**Core Philosophy:** The UI/UX must feel premium, frictionless, and addictive from Phase 1. Even if the backend is simple, the frontend must feel like a finished, top-tier product.

---

## 🟢 Phase 1: "The Core Hook" (Minimum Viable Experience)

**Goal:** Establish the fundamental mechanic of reading, branching, and voting. Prove that users enjoy writing collaborative stories.

**Focus:** Frictionless onboarding, premium aesthetics, and the core graph database logic.

**Key Features:**
1.  **Guest Mode (Frictionless Onboarding):**
    *   No login wall to *read*. Guests open the app and are immediately dropped into the trending story.
    *   They can swipe through branches and read the "Canon" paths instantly.
2.  **Authentication (To Play):**
    *   Email/Password and Google/Apple SSO. Required only when a user attempts to vote, create a branch, or continue a story.
3.  **The Engine Room (Reading & Writing):**
    *   Creation of "Genesis Nodes" (starting a new story).
    *   **"Continue"** (adding to a linear path) & **"Branch Here"** (creating a divergence).
    *   Character limit enforcement (280 characters).
4.  **The Canon System (Voting V1):**
    *   Users can upvote a node.
    *   The node with the highest votes becomes the "Main" or "Canon" path on the UI.
5.  **Premium UI/UX:**
    *   Sleek dark mode, fluid swipe gestures to navigate side-branches, and satisfying haptic feedback when branching or voting.
6.  **Concurrency Safety:**
    *   Basic optimistic concurrency. If two users branch simultaneously, they simply become two separate branches.

---

## 🟡 Phase 2: "The Cult" (Identity & Lore)

**Goal:** Turn readers into an obsessed community. Introduce features that make them care about the world they are building.

**Focus:** User retention, notifications, and tracking characters.

**Key Features:**
1.  **The "Incognito Storyteller" (Anonymous Mode):**
    *   Allow users to post under mysterious aliases for darker or controversial branches without risking their main profile reputation.
2.  **The Lorebook V1 (@ Mentions):**
    *   Introduce the `@character` tagging system.
    *   Clicking a tag shows a basic page tracking which timelines the character is currently alive in. (Manual entries at this stage).
3.  **WebSockets & "Typing Hooks":**
    *   Show real-time presence: *"2 people are currently writing alternative timelines for this moment."*
    *   Provides a visual lock if someone is continuing the main path.
4.  **Notification System & The Timeline Shift:**
    *   Push notifications: *"Your timeline was just overthrown! Defend your canon!"*
    *   Notifications when someone branches from your node.
5.  **Profiles & Basic Badges:**
    *   Leaderboards for "Most Canon Nodes Written" and "Biggest Plot Twists".

---

## 🟠 Phase 3: "The Multiverse" (AI Integrations)

**Goal:** Address the friction of scale. As stories get hundreds of nodes long, new users will struggle to catch up. This is where AI becomes necessary.

**Focus:** AI-powered catch-ups, audio, and visual enhancements.

**Key Features:**
1.  **AI Recaps ("Previously on TaleSpin..."):**
    *   When a user clicks into a branch deep in the tree, an LLM summarizes the exact path taken to get there in 3 bullet points so they can start writing immediately.
2.  **AI Voice Narration:**
    *   Text-to-speech integration. Users can pick a "Voice Skin" for their story (e.g., Noir Detective, Horror Whisper).
3.  **AI Avatar Minting:**
    *   When a new character is `@minted`, allow the author to generate a quick AI avatar for their Lorebook profile.
4.  **The Visual Multiverse Map:**
    *   A massive, zoomable complex graph view of the entire story tree (like a skill tree in an RPG) showing dead ends and thriving timelines.

---

## 🔴 Phase 4: "The Platform" (Monetization & Expansion)

**Goal:** Build a sustainable business model and allow private groups.

**Focus:** Enterprise/Creator tools and private instances.

**Key Features:**
1.  **Private Circles:**
    *   Invite-only stories for friend groups to write together.
2.  **Creator Tipping:**
    *   Allow readers to tip the authors of their favorite "Canon" branches.
3.  **The "Choice" Nodes:**
    *   Interactive gamification where an author posts a poll (Red Pill vs Blue Pill), locking the story until the community votes on which direction it should go next.
4.  **Export to E-Book:**
    *   Allow a community to officially "publish" a completed Canon timeline as a readable PDF/EPUB.
