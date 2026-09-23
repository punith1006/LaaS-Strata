<div align="center">

# LaaS Cloud Console & Workstation Portal
### Enterprise Sovereign GPU Cloud Interface • Next.js 15.1 App Router • React 19 • Tailwind CSS v4 • Zustand 5 • WebRTC

[![Next.js](https://img.shields.io/badge/Framework-Next.js%2015.1-000000?logo=next.js&logoColor=white&style=for-the-badge)](https://nextjs.org)
[![React](https://img.shields.io/badge/UI%20Library-React%2019-61DAFB?logo=react&logoColor=black&style=for-the-badge)](https://react.dev)
[![TypeScript](https://img.shields.io/badge/Language-TypeScript%205.7-3178C6?logo=typescript&logoColor=white&style=for-the-badge)](https://www.typescriptlang.org/)
[![Tailwind CSS](https://img.shields.io/badge/Styling-Tailwind%20CSS%20v4-38B2AC?logo=tailwind-css&logoColor=white&style=for-the-badge)](https://tailwindcss.com)
[![Zustand](https://img.shields.io/badge/State-Zustand%205.0-443E3B?style=for-the-badge)](https://github.com/pmndrs/zustand)
[![Framer Motion](https://img.shields.io/badge/Animation-Framer%20Motion%2012-FF0055?logo=framer&logoColor=white&style=for-the-badge)](https://www.framer.com/motion/)
[![Radix UI](https://img.shields.io/badge/Primitives-Radix%20UI-161618?logo=radix-ui&logoColor=white&style=for-the-badge)](https://www.radix-ui.com)

<p align="center">
  <b>The modern, ultra-responsive cloud console for the LaaS (Lab-as-a-Service) GPU cloud platform.</b><br/>
  Empowers researchers, students, and engineers to launch fractional GPU instances, access low-latency WebRTC desktop streams, manage persistent ZFS cloud storage, monitor hourly compute spend, and book 1-on-1 AI consultations.
</p>

---

</div>

## Table of Contents
1. [Executive Overview & Design Philosophy](#-executive-overview--design-philosophy)
2. [Key Architectural Highlights & Innovations](#-key-architectural-highlights--innovations)
3. [Project Directory Structure](#-project-directory-structure)
4. [Route Groups & Page Walkthrough](#-route-groups--page-walkthrough)
   - [Authentication & Identity (`(auth)`)](#1-authentication--identity-auth)
   - [Cloud Console Core (`(console)`)](#2-cloud-console-core-console)
   - [Meeting & Video Rooms (`meeting`)](#3-meeting--video-rooms-meeting)
   - [Analytics & Executive Telemetry (`(analytics-console)`)](#4-analytics--executive-telemetry-analytics-console)
   - [Growth & Marketing (`waitlist` & `ref`)](#5-growth--marketing-waitlist--ref)
5. [Component System & UI Architecture](#-component-system--ui-architecture)
   - [App Shell & Navigation (`AppShell`, `SidebarNav`)](#1-app-shell--navigation)
   - [Compute Management Components](#2-compute-management-components)
   - [Cloud Storage & File Explorer Components](#3-cloud-storage--file-explorer-components)
   - [Billing & Razorpay Wallet Modals](#4-billing--razorpay-wallet-modals)
6. [State Management & Client API Layer](#-state-management--client-api-layer)
   - [Bulletproof Mutex Token Refresh (`apiFetch`)](#1-bulletproof-mutex-token-refresh-apifetch)
   - [Complete API Client Breakdown (`src/lib/api.ts`)](#2-complete-api-client-breakdown-srclibapits)
   - [AI Workload Recommender Engine (`recommendation-engine.ts`)](#3-ai-workload-recommender-engine)
   - [Zustand Stores (`signup-store.ts`)](#4-zustand-stores)
7. [Environment Variables & Configuration](#-environment-variables--configuration)
8. [Local Development & Production Build Runbook](#-local-development--production-build-runbook)

---

## Executive Overview & Design Philosophy

**`frontend-new`** is the primary user-facing interface for the LaaS sovereign GPU cloud. Crafted with **Next.js 15.1 (App Router)** and **React 19**, it combines the aesthetic polish and responsiveness of modern developer platforms (Lambda Labs, RunPod, Vercel) with the strict enterprise isolation and auditing required by academic and sovereign institutions.

### Design Principles:
* **Sub-100ms Perceived Latency**: Instant optimistic UI updates, background polling with exponential backoff, and proactive token refreshes.
* **Dense Information Architecture**: Information-rich dashboards displaying real-time VRAM allocation, SM compute percentage, live session duration counters, and running compute costs in INR.
* **Zero-Confusion Workstation Streaming**: In-browser WebRTC connection modals displaying auto-generated connection URLs, decrypted desktop credentials with one-click copy, and live container terminal log streaming.
* **Integrated Sovereign Cloud Drive**: A full-fledged cloud file explorer enabling folder creation, multi-file drag-and-drop uploads (up to 500MB), file downloads, and dynamic ZFS quota expansion without leaving the console.

---

## Key Architectural Highlights & Innovations

1. **Next.js 15 App Router & Route Group Isolation**:
   - Organizes distinct layouts and security contexts into route groups: `(auth)` for unauthenticated login/registration flows, `(console)` for the authenticated student/developer app shell, and `(analytics-console)` for administrative metric telemetry.
2. **Mutex-Deduplicated Automatic Token Refresh (`apiFetch`)**:
   - `src/lib/api.ts` implements a proactive and reactive token refresh mechanism using a Promise-based mutex.
   - Detects expired JWT access tokens *before* dispatching HTTP calls. If an access token expires while multiple requests fire simultaneously, only a single refresh call executes; all pending requests await that single Promise before proceeding.
   - Handles unexpected 401s gracefully, refreshing and re-trying the failed request seamlessly.
3. **AI Workload Recommender Engine**:
   - In-console natural language workload analyzer (`src/lib/recommendation-engine.ts`).
   - Parses student model requirements, training batch sizes, and dataset parameters, recommending the optimal fractional tier (`Spark 4G`, `Blaze 8G`, `Inferno 16G`, `Supernova 32G`) to prevent overspending and out-of-memory errors.
4. **Interactive ZFS Cloud Drive File Browser**:
   - Built directly into `/storage`, providing a seamless tree and table view of the user's remote ZFS dataset (`datapool/users/<uid>`).
   - Supports 500MB chunked drag-and-drop file uploads, directory downloads, instant folder creation, and active storage health status probing.
5. **Real-Time Financial Dashboard & Razorpay Integration**:
   - Displays live compute costs accumulating second-by-second while instances run.
   - Modal-based Razorpay payment gateway checkout supporting UPI, credit cards, and netbanking, with immediate wallet balance updates and downloadable PDF invoices.

---

## 📂 Project Directory Structure

```bash
frontend-new/
├── .env.example                     # Environment template (API base URL, Razorpay key)
├── .env.local                       # Local environment overrides
├── package.json                     # Next.js 15, React 19, Tailwind v4, Zustand dependencies
├── tsconfig.json                    # Strict TypeScript configuration
├── postcss.config.mjs               # PostCSS configuration with Tailwind v4 plugin
├── tailwind.config.ts               # Extended theme palette, fonts, and container rules
├── components.json                  # Shadcn / Radix component configuration
│
├── public/                          # Static assets, SVG icons, and brand graphics
│   ├── favicon.ico
│   ├── logo.svg
│   └── avatars/
│
└── src/
    ├── app/                         # Next.js 15 App Router Directory
    │   ├── globals.css              # Tailwind v4 theme variables, CSS reset, custom scrollbars
    │   ├── layout.tsx               # Root HTML layout with Sonner toast provider and font definitions
    │   ├── page.tsx                 # Root redirection controller
    │   │
    │   ├── (auth)/                  # Authentication & Onboarding Route Group
    │   │   ├── layout.tsx           # Clean split-screen authentication layout
    │   │   ├── signin/page.tsx      # Email/password login & Keycloak campus SSO trigger
    │   │   ├── signup/page.tsx      # Multi-step student registration wizard with OTP verification
    │   │   ├── institution/page.tsx # Campus institution selector & OIDC redirector
    │   │   ├── callback/page.tsx    # Keycloak SSO OAuth callback & JWT exchange handler
    │   │   ├── forgot-password/     # Password reset initiation & OTP confirmation
    │   │   └── logout/page.tsx      # Centralized session tear-down and cookie clearing
    │   │
    │   ├── (console)/               # Core Authenticated Application Shell
    │   │   ├── layout.tsx           # AppShell wrapper: topbar, sidebar, user drawer
    │   │   ├── home/page.tsx        # Console dashboard: active compute overview & quick actions
    │   │   ├── instances/page.tsx   # Workstation manager: launch modal, live cards, logs, connect
    │   │   ├── storage/page.tsx     # Cloud drive: ZFS file browser, 500MB upload, quota resize
    │   │   ├── billing/page.tsx     # Financial hub: wallet top-up, usage breakdown, invoices
    │   │   ├── mentor/page.tsx      # 1-on-1 AI expert booking, category filters, slot selector
    │   │   ├── calendar/page.tsx    # Expert scheduling calendar & availability slot manager
    │   │   ├── profile/page.tsx     # User profile, university affiliation, credentials
    │   │   ├── account/page.tsx     # Security settings, active sessions, password change
    │   │   └── referral/page.tsx    # Viral referral portal: custom link, earnings, reward history
    │   │
    │   ├── (analytics)/             # Standalone Analytics Views
    │   ├── (analytics-console)/     # Administrative Fleet Analytics
    │   │   └── page.tsx             # GPU utilization heatmaps, NRR, MRR, retention cohorts
    │   │
    │   ├── meeting/[id]/page.tsx    # Embedded Jitsi WebRTC video conference room
    │   ├── waitlist/page.tsx        # Public beta waitlist registration with priority queue
    │   └── ref/[code]/page.tsx      # Dynamic referral link capturer & cookie storer
    │
    ├── components/                  # Reusable Modular UI Components
    │   ├── app-shell.tsx            # Universal console wrapper (sidebar, breadcrumbs, drawer)
    │   ├── sidebar-nav.tsx          # Dynamic role-based navigation (Student vs. Mentor modes)
    │   ├── sign-out-modal.tsx       # Confirmation dialog for session termination
    │   │
    │   ├── compute/                 # Workstation & Instance Components
    │   │   ├── instance-card.tsx    # Active instance card with live uptime & cost counter
    │   │   ├── launch-modal.tsx     # Tier selection modal with AI workload sizing
    │   │   ├── connection-modal.tsx # WebRTC stream link & AES-256 decrypted password copy
    │   │   └── log-viewer-modal.tsx # Container stdout/stderr real-time log viewer
    │   │
    │   ├── storage/                 # Storage & Cloud Drive Components
    │   │   ├── file-explorer.tsx    # Directory table, search bar, and filter tabs
    │   │   ├── upload-dropzone.tsx  # Drag-and-drop file uploader with chunking progress
    │   │   ├── create-folder-modal.tsx # New directory modal with name validation
    │   │   └── upgrade-quota-modal.tsx # Dynamic quota slider (5GB to 32GB) with price estimator
    │   │
    │   ├── billing/                 # Billing & Payment Components
    │   │   ├── wallet-card.tsx      # Available balance in INR, active hold badges
    │   │   ├── add-credits-modal.tsx# Razorpay checkout trigger with preset amounts
    │   │   ├── payment-history-tab.tsx # Past invoices with status & PDF download
    │   │   └── withdraw-modal.tsx   # Mentor payout request modal (UPI / Bank transfer)
    │   │
    │   ├── mentor/                  # Marketplace & Consultation Components
    │   │   ├── mentor-card.tsx      # Mentor bio, hourly rate, rating, book button
    │   │   └── slot-booking-modal.tsx # Date/time slot selector with calendar sync
    │   │
    │   ├── analytics/               # Recharts & Telemetry Widgets
    │   │   ├── gpu-usage-chart.tsx  # Multi-node GPU VRAM and SM utilization graphs
    │   │   └── revenue-card.tsx     # Financial KPI cards (MRR, NRR, Avg GPU-hour)
    │   │
    │   └── ui/                      # Base Radix / Shadcn Primitives
    │       ├── button.tsx, dialog.tsx, select.tsx, checkbox.tsx,
    │       ├── popover.tsx, separator.tsx, tabs.tsx, tooltip.tsx
    │
    ├── stores/                      # Zustand Global Stores
    │   └── signup-store.ts          # Multi-step registration wizard state & form caching
    │
    ├── lib/                         # Client Utilities, API Client & Security
    │   ├── api.ts                   # 76KB typed API client: compute, storage, billing, auth
    │   ├── token.ts                 # JWT extraction, expiration detection, cookie sync
    │   ├── cookies.ts               # Client-side cookie getter/setter with domain scoping
    │   ├── recommendation-engine.ts # AI workload rules engine for compute sizing
    │   ├── validations.ts           # Zod schema definitions for form validation
    │   └── utils.ts                 # `cn()` className merger (`clsx` + `tailwind-merge`)
    │
    ├── types/                       # Shared TypeScript Interfaces & Contracts
    │   ├── auth.ts                  # User, Token, Role, Profile interfaces
    │   ├── compute.ts               # ComputeConfig, Session, SessionEvent contracts
    │   ├── storage.ts               # StorageVolume, FileItem, Quota interfaces
    │   └── billing.ts               # Wallet, Invoice, Transaction, Charge models
    │
    └── config/                      # Static Application Configuration
        └── tiers.ts                 # Default compute tier metadata and specs
```

---

## Route Groups & Page Walkthrough

### 1. Authentication & Identity (`(auth)`)
* **`signin` (`/signin`)**:
  - Clean split-screen login.
  - Supports standard email/password authentication and a prominent **"Sign in with Campus SSO"** button triggering Keycloak OIDC.
* **`signup` (`/signup`)**:
  - Multi-step registration wizard powered by `signup-store.ts`.
  - Step 1: Institutional email input $\rightarrow$ triggers 6-digit OTP delivery.
  - Step 2: OTP verification with countdown timer and rate-limited resend.
  - Step 3: Password creation and mandatory institutional policy consent checkboxes.
* **`institution` (`/institution`)**:
  - Institutional tenant selector. Allows students and faculty to select their university/partner college, redirecting directly to their campus Keycloak realm.
* **`callback` (`/callback`)**:
  - Handles the OAuth redirect code from Keycloak, exchanges it for session JWTs via `backend-new`, and redirects the user into `/home`.

---

### 2. Cloud Console Core (`(console)`)
* **`home` (`/home`)**:
  - High-level overview of the user's sovereign cloud resources.
  - Displays currently running instances, available wallet balance, active ZFS storage usage, and quick-launch buttons.
* **`instances` (`/instances`)**:
  - Complete compute orchestration portal.
  - **Launch Modal**: Interactive tier picker (`Spark 4G`, `Blaze 8G`, `Inferno 16G`) displaying VRAM, vCPU, RAM, and hourly pricing. Includes an **AI Workload Assistant** that analyzes project requirements and highlights the best tier.
  - **Active Session Cards**: Shows instance status (`starting`, `running`, `stopping`), host node name (`ai1`), live elapsed uptime timer, and second-by-second accrued cost counter in INR.
  - **Connection Panel**: Displays the secure WebRTC streaming URL with decrypted desktop passwords and one-click copy buttons.
  - **Live Log Viewer**: Real-time modal polling container stdout/stderr.
  - **Lifecycle Actions**: Restart instance, terminate instance with wallet hold release summary.
* **`storage` (`/storage`)**:
  - Full-featured web-based cloud drive directly backed by ZFS.
  - **File Explorer**: Browse directories with breadcrumb navigation, search, and category filter tabs (`All`, `Images`, `Videos`, `Files`).
  - **Upload Engine**: Multi-file drag-and-drop uploader supporting files up to 500MB with real-time chunking progress.
  - **Quota Expansion**: Dynamic modal slider allowing users to upgrade their storage allocation (5GB to 32GB) with instant monthly cost recalculation.
  - **Dataset Reachability Monitor**: Live indicator verifying that the ZFS dataset is actively mounted and accessible.
* **`billing` (`/billing`)**:
  - Two-tab financial management interface.
  - **Usage Overview Tab**: Current wallet balance, active pre-auth holds, and hourly compute/storage consumption charts.
  - **Invoice & Payment History Tab**: Historical transaction ledger, Razorpay payment statuses, and one-click PDF tax invoice downloads.
  - **Add Credits Modal**: Preset top-up packages (Rs. 100, Rs. 500, Rs. 2,000) or custom amounts, integrating directly with Razorpay checkout.
* **`mentor` (`/mentor`)**:
  - Peer-to-peer AI consultation marketplace.
  - Browse verified mentors with domain tags (Deep Learning, CUDA Optimization, Computer Vision), view ratings and hourly rates, and schedule consultation sessions.
* **`calendar` (`/calendar`)**:
  - Interactive calendar for mentors to set recurring availability windows and manage booked sessions.
* **`profile` & `account` (`/profile`, `/account`)**:
  - Manage user profile details, university roll numbers, SSH public keys, and password changes.
* **`referral` (`/referral`)**:
  - Referral dashboard with unique sharable referral URLs, conversion funnels (Signups $\rightarrow$ Active Computes $\rightarrow$ Rewards), and wallet credit ledgers.

---

### 3. Meeting & Video Rooms (`meeting`)
* **`/meeting/[id]`**:
  - Embedded **Jitsi WebRTC** video conference room for 1-on-1 student-mentor sessions.
  - Automatically loads secure JWT room tokens generated by `backend-new` ensuring only authorized participants can enter.

---

### 4. Analytics & Executive Telemetry (`(analytics-console)`)
* **`/analytics-console`**:
  - Executive-level dashboard for lab directors and administrators.
  - Real-time physical GPU utilization heatmaps across all nodes (`ai1`, `ai4`, `ai5`).
  - Financial analytics: Monthly Recurring Revenue (MRR), Net Revenue Retention (NRR), and revenue per GPU-hour.
  - Student cohort retention tables and weekly compute volume breakdowns.

---

### 5. Growth & Marketing (`waitlist` & `ref`)
* **`/waitlist`**: Public registration page for prospective students and external researchers to join the sovereign GPU beta queue.
* **`/ref/[code]`**: Dynamic route that captures incoming referral codes, persists them into secure cookies, and redirects visitors to registration.

---

## Component System & UI Architecture

### 1. App Shell & Navigation
* **`AppShell` (`src/components/app-shell.tsx`)**:
  - Provides the universal layout frame for all `/console` routes.
  - Manages the top app bar with breadcrumbs, system status indicator, wallet credit chip, and user profile drawer.
  - Handles responsive sidebar collapse on tablet and mobile viewports.
* **`SidebarNav` (`src/components/sidebar-nav.tsx`)**:
  - Role-aware navigation sidebar. Automatically shifts navigation items between **Student/Researcher Mode** (Home, Instances, Storage, Billing, Mentor) and **Mentor Mode** (Home, Calendar, Chats, Billing, Payouts).

### 2. Compute Management Components
* **`InstanceCard`**: Renders a rich card for each workstation instance, featuring status badges, live uptime counters, hardware tier specifications, and direct action triggers (Connect, Restart, Stop).
* **`LaunchModal`**: Multi-step dialog featuring interactive tier selection cards, OS distribution pickers, and storage mount selectors.
* **`ConnectionModal`**: Displays the desktop stream URL (`https://<node-ip>:<port>`), container username, and decrypted desktop password with one-click copy buttons.
* **`LogViewerModal`**: Terminal-styled modal displaying container execution logs with autoscroll and pause toggles.

### 3. Cloud Storage & File Explorer Components
* **`FileExplorer`**: Displays files and folders in customizable grid or table views with sorting by name, size, and last modified date.
* **`UploadDropzone`**: Drag-and-drop upload surface with visual drag-over indicators and multi-file progress meters.
* **`UpgradeQuotaModal`**: Visual slider interface allowing users to adjust quota ceilings (up to 32GB) with instant rate recalculation.

### 4. Billing & Razorpay Wallet Modals
* **`WalletCard`**: Visual wallet card displaying available balance, pending holds, and quick top-up buttons.
* **`AddCreditsModal`**: Modal embedding the official Razorpay checkout script, pre-filling user contact info and handling success webhooks.
* **`WithdrawModal`**: Payout interface for mentors to withdraw earned credits to their bank account or UPI ID.

---

## State Management & Client API Layer

### 1. Bulletproof Mutex Token Refresh (`apiFetch`)
Implemented in `src/lib/api.ts`:
```typescript
// Mutex to prevent multiple simultaneous refresh calls
let refreshPromise: Promise<AuthTokens> | null = null;

export async function apiFetch(url: string, options: RequestInit = {}): Promise<Response> {
  let token = getAccessToken();

  // Proactive check: if token is expired, refresh BEFORE making the request
  if (isTokenExpired() && getRefreshToken()) {
    await doRefresh();
    token = getAccessToken();
  }

  // Make the request with Bearer authorization
  let res = await fetch(url, {
    ...options,
    headers: {
      ...options.headers,
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
  });

  // Reactive fallback: if 401, refresh once and retry
  if (res.status === 401) {
    const refreshed = await doRefresh();
    if (refreshed) {
      token = getAccessToken();
      res = await fetch(url, {
        ...options,
        headers: {
          ...options.headers,
          Authorization: `Bearer ${token}`,
        },
      });
    } else {
      clearTokens();
      if (typeof window !== "undefined") window.location.href = "/signin";
    }
  }

  return res;
}
```

### 2. Complete API Client Breakdown (`src/lib/api.ts`)
The 76KB typed API client provides over 50 dedicated methods:
* **Authentication**: `signIn()`, `signUp()`, `sendOtp()`, `verifyOtp()`, `refreshToken()`, `signOut()`, `getMe()`.
* **Compute Sessions**: `getComputeConfigs()`, `getResourceUsage()`, `launchSession()`, `getUserSessions()`, `getSessionDetail()`, `terminateSession()`, `restartSession()`, `getSessionLogs()`, `getSessionConnection()`, `getSessionEvents()`.
* **Storage Operations**: `getStorageVolumes()`, `createStorageVolume()`, `upgradeStorageVolume()`, `getStorageFiles()`, `createStorageFolder()`, `uploadStorageFiles()`, `downloadStorageFile()`, `deleteStorageFile()`, `getStorageStatus()`.
* **Billing & Payments**: `getBillingData()`, `getPaymentHistory()`, `createRazorpayOrder()`, `verifyRazorpayPayment()`, `downloadInvoicePdf()`, `requestWithdrawal()`.
* **Mentor Marketplace**: `getMentors()`, `getMentorDetail()`, `bookMentorSlot()`, `getMentorSessions()`, `getMentorAvailability()`, `saveMentorAvailability()`.
* **Support & Helpdesk**: `getTickets()`, `getTicketDetail()`, `createTicket()`, `addTicketMessage()`.
* **AI Workload Analysis**: `extractDocumentText()`, `analyzeWorkload()`, `generateRecommendationExplanation()`.

### 3. AI Workload Recommender Engine
`src/lib/recommendation-engine.ts` analyzes user workloads client-side and server-side:
* Matches common deep learning frameworks (`PyTorch`, `TensorFlow`, `JAX`, `vLLM`, `HuggingFace`).
* Recommends tiers based on model parameters:
  - $< 3\text{B}$ parameters $\rightarrow$ `Spark (4GB VRAM, 25% SM)`
  - $3\text{B} - 8\text{B}$ parameters $\rightarrow$ `Blaze (8GB VRAM, 35% SM)`
  - $8\text{B} - 14\text{B}$ parameters $\rightarrow$ `Inferno (16GB VRAM, 50% SM)`
  - $> 14\text{B}$ or distributed fine-tuning $\rightarrow$ `Supernova (32GB Dedicated)`

### 4. Zustand Stores
* **`signup-store.ts`**: Persistent client store preserving form inputs across multi-step registration (email, OTP, names, policy agreements) preventing data loss on accidental page refreshes.

---

## Environment Variables & Configuration

Create a `.env.local` file in the root of `frontend-new`:
```ini
# Backend Control Plane Base URL
NEXT_PUBLIC_API_URL="http://localhost:3001"

# Razorpay Client Key (for in-browser payment checkout)
NEXT_PUBLIC_RAZORPAY_KEY_ID="rzp_test_your_key_id"

# Keycloak Realm Discovery (for institutional SSO redirects)
NEXT_PUBLIC_KEYCLOAK_URL="https://auth.ksrceailab.com"
NEXT_PUBLIC_KEYCLOAK_REALM="ksrce"
NEXT_PUBLIC_KEYCLOAK_CLIENT_ID="laas-console"

# Optional Jitsi Meet Domain for video rooms
NEXT_PUBLIC_JITSI_DOMAIN="meet.jit.si"
```

---

## Local Development & Production Build Runbook

### Prerequisites
* **Node.js**: `v20.x` or `v22.x` (LTS recommended)
* **Package Manager**: `npm` v10+
* **Backend**: An active instance of `backend-new` running on `http://localhost:3001`

### 1. Install Dependencies
```bash
cd frontend-new
npm install
```

### 2. Run the Development Server
```bash
npm run dev
```
Open [http://localhost:3000](http://localhost:3000) in your browser. The console will connect to the backend configured in `NEXT_PUBLIC_API_URL`.

### 3. Run Static Code Linting
```bash
npm run lint
```

### 4. Production Build & Execution
```bash
# Compile and optimize production bundle
npm run build

# Start production server
npm run start
```

The Next.js production server will serve the optimized bundle on port `3000` with automated Route Prefetching, Incremental Static Regeneration, and minified client assets.

---

<div align="center">
  <sub>Engineered with precision for sovereign academic and research GPU cloud infrastructure.</sub><br/>
  <sub>Maintained by the <b>LaaS Engineering Team</b> • For queries contact <a href="mailto:punith.vs74064@gmail.com">punith.vs74064@gmail.com</a></sub>
</div>
