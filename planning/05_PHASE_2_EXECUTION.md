# TaleSpin: Phase 2 Execution Plan & Tracker (The Cult)

This document tracks the granular development status of TaleSpin Phase 2. The primary goal of this phase is to move from Anonymous "Guest Mode" into a retained, interactive User community by introducing robust Authentication, personalized Feeds, and the foundation for "The Lorebook" character tracking.

---

## 🟢 1. Backend API (Golang)

**Status:** In Progress
**Location:** `/backend`

| Feature / Component | Status | Details |
| :--- | :--- | :--- |
| **Auth JWT Service** | ✅ Done | Implement JWT generation, signing, and validation middleware. |
| **API: Register User** | ✅ Done | `POST /api/auth/register` (Stores cryptographically hashed passwords). |
| **API: Login User** | ✅ Done | `POST /api/auth/login` (Returns JWT token). |
| **API: Get Profile** | ✅ Done | `GET /api/me` (Protected route yielding user details). |
| **Schema: Updated Vote** | ❌ Pending | Change voting to lock 1-vote-per-user per node (migrate from anonymous Redis counting to tracking Voter IDs). |
| **API: Auth Wall** | ✅ Done | Secure `POST /api/nodes/:id/branch` and `POST /api/stories` to require valid JWTs. |
| **Lorebook Models** | ❌ Pending | Schema for `@Characters` tracking their existence across timelines. |

---

## 🔵 2. Frontend UI/UX (Flutter)

**Status:** Planning
**Location:** `/frontend`

| Feature / Component | Status | Details |
| :--- | :--- | :--- |
| **Auth State Management** | ❌ Pending | Secure local storage for JWTs and global State/Provider to track logged-in status. |
| **Screen: Onboarding** | ❌ Pending | A beautiful Splash Screen introducing the Multiverse mechanic before asking to login/browse as guest. |
| **Screen: Login / Register** | ❌ Pending | Frictionless, neon-themed forms for joining the Cult. |
| **Component: Auth Gate** | ❌ Pending | When a "Guest" tries to Branch or Vote, slide up a sleek "Join the Multiverse to alter reality" modal. |
| **Screen: User Profile** | ❌ Pending | Showing the user's Avatar, "Timelines Forged", and "Total Upvotes Received". |
| **Lorebook UI V1** | ❌ Pending | Basic parsing: typing `@` in the composer highlights text and tags a character. |

---

### Phase 2 Architecture & Security Notes

*   **Authentication Flow:**
    *   We will use JWT (JSON Web Tokens) handled by Go Fiber's middleware.
    *   Passwords will be hashed using `bcrypt` in PostgreSQL.
    *   Flutter will store the JWT securely using `flutter_secure_storage`.
*   **The "Frictionless" Requirement:**
    *   Users MUST still be able to read stories without logging in. The App should boot directly to the Home Screen feed of trending stories.
    *   Authentication is strictly an "Action Wall" not a "Content Wall". If you try to vote or write, you are prompted to login.
*   **Transitioning from Dummy Data:**
    *   We will rip out the `dummyUser` fallback currently hardcoded in Phase 1's `db.go` and `BranchNode`/`CreateStory` handlers.

---

*Last Updated: Phase 2 Initialization*
