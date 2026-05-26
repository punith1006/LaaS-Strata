# LaaS Mentoring Module — Calendar, Scheduling & Video Architecture Decision

**Status:** Final  
**Date:** 20 May 2026  
**Author:** Architecture Research & Decision  
**Related Plans:**
- `LaaS_Mentoring_Feature_41a7fdbc.md` — Complete Implementation Plan
- `Mentoring_Module_Functional_Specification_ae94a7e5.md` — Functional Specification
- `Mentorship_Feature_MVP_91644912.md` — MVP Implementation Plan

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Requirements Inventory](#2-requirements-inventory)
3. [Options Evaluated](#3-options-evaluated)
4. [Jitsi Meet Deep Dive](#4-jitsi-meet-deep-dive)
5. [Architecture Design](#5-architecture-design)
6. [Feature Coverage Matrix](#6-feature-coverage-matrix)
7. [Scalability Analysis](#7-scalability-analysis)
8. [Risk Assessment](#8-risk-assessment)
9. [Decision Rationale](#9-decision-rationale)
10. [References](#10-references)

---

## 1. Executive Summary

### 1.1 Problem Statement

The LaaS Mentoring module requires a complete scheduling and video conferencing system enabling:

- **Mentors** to set recurring availability, manage bookings, and conduct video sessions with students
- **Students** to browse mentor availability, book slots, pay via wallet, and join video calls
- **Platform** to handle conflict detection, automated reminders, no-show detection, recording, and payout flows

The system must support multiple concurrent 1-on-1 sessions, per-user calendar isolation, and integrate with the existing wallet, notification, and billing infrastructure.

### 1.2 Recommendation

**Custom scheduling platform + Jitsi Meet (self-hosted) + .ics calendar export**

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| Availability & Scheduling | Custom (Prisma DB + NestJS service + React UI) | Full control, no external dependency, already partially modeled in schema |
| Video Conferencing | Jitsi Meet (self-hosted via Docker) | Free, on-premises, open-source, supports recording/screen sharing/whiteboard |
| Calendar Export | .ics file generation (backend) | Industry standard used by Calendly, Cal.com, and most scheduling tools |
| Notifications & Reminders | Existing `@nestjs/schedule` + Nodemailer | Already built and proven in production |

### 1.3 Why Alternatives Were Rejected

| Option | Rejection Reason |
|--------|-----------------|
| Google Calendar API + Google Meet | Personal Gmail cannot use domain-wide delegation (requires Google Workspace). OAuth per-user is fragile UX. Service account Meet link generation is unreliable. |
| Cal.com / Calendly | Designed for individual professionals, not two-sided marketplaces. Each mentor needs separate account. Cost prohibitive at scale. |
| Full Google Workspace migration | Unnecessary cost and complexity. Platform already has self-hosted infrastructure. |

---

## 2. Requirements Inventory

### 2.1 Extracted from All Three Mentoring Plans

#### Core MVP Requirements

| ID | Requirement | Source Plan | Priority |
|----|------------|-------------|----------|
| R1 | Mentor sets recurring weekly availability slots | All 3 plans | Must Have |
| R2 | Mentor sets one-off specific date slots | 41a7fdbc, ae94a7e5 | Must Have |
| R3 | Buffer time between sessions (configurable) | All 3 plans | Must Have |
| R4 | Student browses available slots by date | All 3 plans | Must Have |
| R5 | Student selects slot + duration (30/60/90 min) | All 3 plans | Must Have |
| R6 | Conflict detection — no double-booking | All 3 plans | Must Have |
| R7 | Wallet payment at booking time (hold → capture) | All 3 plans | Must Have |
| R8 | Video call link auto-generated per booking | All 3 plans | Must Have |
| R9 | Both parties can join video call from platform | All 3 plans | Must Have |
| R10 | Screen sharing during video call | 41a7fdbc, 91644912 | Must Have |
| R11 | Session lifecycle: scheduled → in-progress → completed | All 3 plans | Must Have |
| R12 | Cancellation with refund policy | All 3 plans | Must Have |
| R13 | Booking confirmation email to both parties | All 3 plans | Must Have |
| R14 | Session reminders (24hr + 1hr before) | All 3 plans | Must Have |
| R15 | Post-session review submission | All 3 plans | Must Have |

#### Phase 2 Requirements

| ID | Requirement | Source Plan | Priority |
|----|------------|-------------|----------|
| R16 | Calendar export (.ics) for personal calendars | 41a7fdbc, ae94a7e5 | Should Have |
| R17 | In-app chat between mentor and student | 41a7fdbc, 91644912 | Should Have |
| R18 | No-show detection (auto-detect + flag) | ae94a7e5 | Should Have |
| R19 | Session recording (opt-in) | 41a7fdbc, 91644912 | Should Have |
| R20 | Dispute resolution system | ae94a7e5 | Should Have |
| R21 | Vacation/block-out date ranges | ae94a7e5 | Should Have |
| R22 | Mentor earnings dashboard | All 3 plans | Should Have |

#### Phase 3 Requirements

| ID | Requirement | Source Plan | Priority |
|----|------------|-------------|----------|
| R23 | Compute-assisted mentoring (shared GPU session) | 41a7fdbc | Nice to Have |
| R24 | Group workshop mode (1-to-many) | 41a7fdbc | Nice to Have |
| R25 | Automated mentor payouts (Razorpay/Stripe) | ae94a7e5, 91644912 | Nice to Have |

### 2.2 Must-Have Features for Calendar/Video Layer

The following are the **specific features** the calendar and video layer must provide:

1. **Availability Management:** Create, read, update, delete time slots with recurrence rules
2. **Slot Discovery:** Query open slots for a date range, excluding existing bookings
3. **Booking Creation:** Atomic booking with wallet hold, meeting link generation
4. **Calendar Isolation:** Each mentor has independent availability; each student sees only their bookings
5. **Video Rooms:** Unique, secured room per booking with JWT authentication
6. **Session Lifecycle:** Automated state transitions via cron jobs
7. **Notifications:** Email + in-app for booking confirmations, reminders, cancellations
8. **Screen Sharing:** Essential for code review and debugging during mentoring

---

## 3. Options Evaluated

### 3.1 Option A: Google Calendar API + Google Meet

#### How It Would Work

1. Create a Google Cloud Project, enable Calendar API
2. Create a Service Account with domain-wide delegation
3. Service account impersonates a platform user to create calendar events
4. Events include `conferenceData.createRequest` with `conferenceSolutionKey: { type: "hangoutsMeet" }`
5. Google automatically generates a Meet link attached to the event
6. Both mentor and student receive the Meet link

**Reference Implementation:** [Automating Google Meet Creation with Google Calendar API and Service Account](https://dev.to/himanshusinghtomar/automating-google-meet-creation-14mo) (Himanshu Singh Tomar, dev.to)

#### Critical Blocker: Personal Gmail vs Google Workspace

The service account approach requires **Domain-Wide Delegation of Authority**, which is a feature of **Google Workspace** (formerly G Suite) — business and education accounts only.

- `punith.vs74064@gmail.com` is a **personal/consumer Gmail account**
- Personal Gmail accounts **cannot** enable domain-wide delegation
- Without domain-wide delegation, the service account cannot impersonate a user to create events or generate Meet links

**Source:** [Google Workspace Admin Help — Control API access with domain-wide delegation](https://support.google.com/a/answer/162106)

#### Alternative: OAuth Per-User Consent

Without domain-wide delegation, each mentor would need to individually authorize the app via OAuth 2.0 to access their Google Calendar. This creates:

- **Poor UX:** Every mentor must go through a Google OAuth consent screen during onboarding
- **Token management burden:** Refresh tokens, expiration handling, revocation recovery
- **Fragile integration:** If a mentor revokes access, their calendar breaks until re-authorized
- **Inconsistent experience:** Internal mentors (faculty/TA) on institutional Google Workspace vs external mentors on personal Gmail would have different flows

#### Meet Link Generation Reliability

Multiple StackOverflow threads report issues with Google Meet link generation via service accounts:

> "Cannot create Google Meet link in Google Calendar event using service account" — [StackOverflow #76605169](https://stackoverflow.com/questions/76605169/cannot-create-google-meet-link-in-google-calendar-event-using-service-account)

The `conferenceData` field sometimes fails silently — the event is created but no Meet link is attached.

#### Google Calendar API Release Notes (Feb 2026)

> "We have updated the guidance for using Google Meet conferences on Google Calendar events. Reusing Google Meet codes across different events is now restricted." — [Google Calendar API Release Notes](https://developers.google.com/workspace/calendar/release-notes)

This indicates Google is tightening restrictions on programmatic Meet link generation, making the approach more fragile over time.

#### Verdict: REJECTED

- **Technical blocker:** Personal Gmail cannot support domain-wide delegation
- **UX concern:** OAuth per-user is fragile and inconsistent
- **Reliability concern:** Meet link generation via API is unreliable
- **Future risk:** Google is tightening restrictions on programmatic Meet creation

---

### 3.2 Option B: Third-Party Scheduling Platforms

#### Calendly

**What it is:** Market-leading scheduling platform. Individual professionals create booking pages. Clients pick from available slots.

**Why it doesn't fit a marketplace:**

- Each mentor must have their own Calendly account (paid)
- Calendly pricing (2026): $10–$20/user/month. 20 mentors = $200–$400/month
- Designed for 1-to-1 professional-client relationships, not a platform-managed marketplace
- No concept of platform commission, wallet integration, or admin oversight
- Booking data lives in Calendly, not in your DB — can't integrate with wallet holds, billing charges, or analytics

**Calendly API:** Available but requires OAuth per-user and is designed for reading/writing Calendly data, not for embedding Calendly as a white-label scheduling engine inside another platform.

**Sources:** [Calendly API Developer Portal](https://calendly.com/blog/api-dev-portal), [Calendly Pricing](https://calendly.com/pricing)

#### Cal.com

**What it is:** Open-source scheduling platform. Self-hostable. "Scheduling infrastructure for absolutely everyone."

**Why it doesn't fit:**

- Cal.com went partially closed-source in 2024 (Cal.diy is the remaining open-source community edition)
- It's an entire scheduling platform — deploying it alongside LaaS means running and maintaining a separate full-stack application
- While it has APIs, the data model is not designed for a marketplace where the platform manages both sides
- Custom integration with wallet holds, billing charges, and admin panels would be complex and fragile
- Adds operational burden: separate database, separate auth, separate monitoring

**Source:** [Cal.com — Going Closed-Source: Technical Changes Behind Cal.diy](https://cal.com/blog/cal-diy-open-source-to-closed-source)

#### Verdict: REJECTED

Neither platform is designed for marketplace/platform use. They solve individual scheduling, not platform-managed two-sided marketplaces. Integration complexity and cost outweigh any benefits.

---

### 3.3 Option C: Custom Scheduling + Jitsi Meet + .ics Export ✅ RECOMMENDED

#### Architecture Overview

```
┌──────────────────────────────────────────────────────────┐
│                    THE PLATFORM (LaaS Code)               │
│                                                          │
│  ┌─────────────────────┐    ┌────────────────────────┐   │
│  │  SCHEDULING ENGINE   │    │   NOTIFICATION ENGINE   │   │
│  │  • Slot CRUD         │    │   • @nestjs/schedule    │   │
│  │  • Recurrence rules  │    │   • Nodemailer emails   │   │
│  │  • Conflict detect   │    │   • In-app notifies     │   │
│  │  • Busy/free calc    │    │   • Already built       │   │
│  │  • .ics generation   │    │                         │   │
│  └─────────────────────┘    └────────────────────────┘   │
│                                                          │
│  ┌─────────────────────┐    ┌────────────────────────┐   │
│  │   BOOKING LIFECYCLE  │    │   PAYMENT & PAYOUT      │   │
│  │   • Wallet hold      │    │   • Commission calc     │   │
│  │   • State machine    │    │   • Mentor credit       │   │
│  │   • Cron transitions │    │   • BillingCharge       │   │
│  │   • No-show detect   │    │   • Already built       │   │
│  └─────────────────────┘    └────────────────────────┘   │
│                         │                                │
└─────────────────────────┼────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────┐
│                   JITSI MEET (Video Layer)                │
│                                                          │
│  • Room per booking: laas-mentor-{bookingId}             │
│  • JWT auth: only mentor + student can join              │
│  • Features: video, audio, screen share, chat, whiteboard│
│  • Embed: iframe in booking detail page                  │
│  • Recording: Jibri (separate server per recording)      │
│  • Self-hosted: on LaaS infrastructure                   │
└──────────────────────────────────────────────────────────┘
```

#### What Jitsi Provides

Jitsi Meet is an open-source video conferencing platform. It handles **only** the real-time video/audio/screen-sharing layer. All scheduling, calendar, and notification logic lives in the LaaS platform code.

#### What the Platform Provides

The LaaS backend and frontend handle everything else:

| Function | Implementation |
|----------|---------------|
| Availability slot management | Custom Prisma models + NestJS service |
| Slot discovery & booking | REST API endpoint with atomic conflict check |
| Calendar views per user | React components querying user-scoped data |
| Reminders & notifications | `@nestjs/schedule` cron + existing mail module |
| .ics calendar export | Server-side .ics file generation (RFC 5545) |
| Session lifecycle management | State machine in booking service + cron transitions |
| Wallet integration | Existing wallet hold/capture/debit infrastructure |
| Billing & commissions | Existing BillingCharge model with new charge types |

#### Why This Fits LaaS

1. **No external API dependency** — The core scheduling logic has zero third-party calls. This aligns with Plan 41a7fdbc Section 11: *"Custom calendar UI (Day.js + grid) — No external API dependency for MVP."*

2. **Self-hosted video** — Jitsi runs on your infrastructure. This aligns with Plan 41a7fdbc Section 8.1: *"Aligns with the on-premises philosophy of LaaS."*

3. **Existing schema foundation** — `MentorProfile`, `MentorAvailabilitySlot`, `MentorBooking`, and `MentorReview` are already defined in `backend/prisma/schema.prisma`.

4. **Existing infrastructure reuse** — Wallet, notifications, email, billing — all already built and proven.

5. **Full platform control** — No third-party rate limits, no API pricing changes, no vendor deprecation risk.

---

## 4. Jitsi Meet Deep Dive

### 4.1 Feature Set (Current as of 2025–2026)

| Feature | Supported | Source |
|---------|-----------|--------|
| HD Video (720p, 1080p) | Yes | [Jitsi Handbook](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-requirements/) |
| AV1 codec (default since Dec 2024) | Yes | [Jitsi Blog — AV1](https://jitsi.org/blog/av1-and-more-how-does-jitsi-meet-pick-video-codecs/) |
| Screen sharing (full screen) | Yes | Core feature since launch |
| Screen sharing (single app) | Yes | Available in "Advanced options" |
| Screen sharing with audio | Yes | Broadcasts system audio |
| Live chat (in-session) | Yes | Text chat with commands (`/nick`, `/help`) |
| Virtual backgrounds | Yes | Since March 2021 — [Jitsi Blog](https://jitsi.org/blog/march-update-new-toolbar-ui-virtual-backgrounds-and-more/) |
| Background blur | Yes | Beta feature, CPU-intensive |
| Noise suppression (AI) | Yes | RNnoise-based — [Jitsi Blog](https://jitsi.org/blog/enhanced-noise-suppression-in-jitsi-meet/) |
| Whiteboard | Yes | Since November 2022 — [Jitsi Blog](https://jitsi.org/blog/introducing-whiteboards-in-jitsi-meet/) |
| Breakout rooms | Yes | Confirmed in changelog |
| Recording (Jibri) | Yes | Requires separate Jibri server instance per simultaneous recording |
| Presenter mode | Yes | Replaced by simultaneous camera + screen share |
| Lobby / waiting room | Yes | Configurable via security settings |
| Password protection | Yes | Room-level password |
| E2EE encryption | Yes | End-to-end encryption option |
| Raise hand | Yes | Hotkey: R |
| Mute all participants | Yes | Moderator control |
| Kick participant | Yes | Moderator control |
| Lock room | Yes | Prevent new joiners |
| Mobile support | Yes | Flutter SDK since August 2023, also iOS/Android native |
| React SDK (iframe embed) | Yes | Since March 2022 — [Jitsi Blog](https://jitsi.org/blog/introducing-the-jitsi-meet-react-sdk/) |
| JWT authentication | Yes | Custom JWT for room access control |
| Custom branding | Yes | Self-hosted instance supports custom logos, colors, URLs |
| Car mode | Yes | Audio-only optimized mode — [Jitsi Blog](https://jitsi.org/blog/introducing-car-mode/) |
| Live transcription | Yes (via Jigasi) | Requires Jigasi + external transcription service |
| SSRC rewriting (large call perf) | Yes | Since April 2024 — [Jitsi Blog](https://jitsi.org/blog/improving-performance-on-very-large-calls-introducing-ssrc-rewriting/) |

### 4.2 Features Jitsi Does NOT Provide

| Missing Feature | Impact on Mentoring | Workaround |
|-----------------|---------------------|------------|
| File sharing in chat | Low-Medium | Pre/post-session file sharing via platform dashboard. Screen sharing covers real-time collaboration. |
| Calendar/scheduling | N/A | Handled entirely by platform code |
| Task management | N/A | Handled entirely by platform code |
| Email reminders | N/A | Handled by platform notification system |
| Persistent chat history | Low | Booking details stored in DB; Jitsi rooms are ephemeral by design |
| Conversation across sessions | Low | Platform messaging module can be added in Phase 2 |
| Admin controls (who can mute) | Low | Fixed with JWT auth — platform controls moderator assignment |

**Source for file sharing limitation:** [Software Advice — Jitsi Reviews](https://www.softwareadvice.com/voip/jitsi-meet-profile/reviews/): *"There is no option to share files."*

**Source for admin control limitation:** [Software Advice — Jitsi Reviews](https://www.softwareadvice.com/voip/jitsi-meet-profile/reviews/): *"Anyone can control the meeting, anyone can mute all other participants, anyone can be admin."* (Note: this is the default behavior without JWT auth; with JWT, roles are enforced.)

### 4.3 Infrastructure Requirements

**Source:** [Jitsi Meet Handbook — Requirements](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-requirements/)

#### Basic Server (Small Deployment)

| Resource | Minimum | Recommended (Production) |
|----------|---------|--------------------------|
| CPU Cores | 4 dedicated | 8+ dedicated |
| RAM | 4 GB | 8 GB |
| Disk | 20 GB | SSD for recording |
| Network | 1 Gbps | 10 Gbps |
| OS | Ubuntu 20.04+ / Debian | Ubuntu 22.04 LTS |

#### Bandwidth Per Stream

| Resolution | Bitrate |
|-----------|---------|
| 180p | ~200 kbps |
| 360p | ~500 kbps |
| 720p (HD) | ~2,500 kbps |
| 4K | ~10,000 kbps |

**Key constraint:** Prosody (XMPP server) can only use **1 CPU core**. Adding more cores beyond ~32 has diminishing returns. Horizontal scaling via additional videobridges is the recommended approach for large deployments.

#### Recording (Jibri) Requirements

| Resource | Per Simultaneous Recording |
|----------|---------------------------|
| RAM | 8 GB (1080x720), 12 GB (1280x1024) |
| Disk | SSD required |
| Instances | 1 Jibri = 1 simultaneous recording |

**Source:** [Jitsi Handbook — Requirements](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-requirements/): *"Jibri needs ONE system per recording. One Jibri instance = one meeting. For 5 meetings recorded simultaneously, you need 5 Jibris. There is no workaround to that."*

### 4.4 Jitsi vs Competitors

| Feature | Jitsi Meet | Google Meet | Zoom | Microsoft Teams |
|---------|-----------|-------------|------|-----------------|
| **Cost** | Free (self-hosted) | Free (limited) / $7.20/user/mo | Free (40min limit) / $15.99/user/mo | Free / $4/user/mo |
| **Self-hosted** | Yes | No | No | No |
| **Open source** | Yes (Apache 2.0) | No | No | No |
| **Max participants (single room)** | 35+ (single server, scalable) | 100 (free), 500 (enterprise) | 100 (free), 1000 (enterprise) | 300 (free), 1000 (enterprise) |
| **HD video** | Yes (720p, 1080p, AV1) | Yes (720p) | Yes (1080p) | Yes (1080p) |
| **Screen sharing** | Yes (with audio) | Yes | Yes | Yes |
| **Virtual backgrounds** | Yes (since 2021) | Yes | Yes | Yes |
| **Whiteboard** | Yes (since 2022) | Yes (Jamboard) | Yes | Yes (Whiteboard) |
| **Breakout rooms** | Yes | Yes | Yes | Yes |
| **Recording** | Yes (Jibri, self-hosted) | Yes (cloud) | Yes (local + cloud) | Yes (cloud) |
| **Noise suppression** | Yes (RNnoise) | Yes (AI) | Yes (AI) | Yes (AI) |
| **File sharing in chat** | No | Yes | Yes | Yes |
| **Calendar integration** | Via .ics only | Native Google Calendar | Native + plugins | Native Outlook |
| **E2EE** | Yes (optional) | Limited | Limited | Limited |
| **JWT room auth** | Yes | No | No | No |
| **Custom branding** | Full control | Logo only | Limited | Limited |
| **API / SDK** | React SDK, Flutter SDK, iframe API | Limited | SDK available | Graph API |
| **Infrastructure control** | Full | None | None | None |

### 4.5 Documented User Complaints & Limitations

| Issue | Source | Severity | Relevance to LaaS |
|-------|--------|----------|-------------------|
| No file sharing in meetings | [Software Advice Reviews](https://www.softwareadvice.com/voip/jitsi-meet-profile/reviews/) | Low | Screen sharing handles code review; files shared pre/post via platform |
| Anyone can be admin (default config) | [Software Advice Reviews](https://www.softwareadvice.com/voip/jitsi-meet-profile/reviews/) | Low | Fixed by JWT auth — platform controls moderator role |
| Virtual backgrounds are CPU-heavy | [Hacker News Discussion](https://news.ycombinator.com/item?id=22669968) | Low | Optional feature; disable for low-end devices |
| Self-hosting = you manage updates | [Medium — Self-Hosted Jitsi](https://medium.com/@nikhilsachan28/why-you-should-host-your-own-video-conferencing-server-with-jitsi-a-complete-breakdown-part-1-774dd43bd921) | Medium | Docker simplifies updates; standard devops practice |
| Performance depends on server resources | [Jitsi Handbook](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-requirements/) | Medium | Dedicated server with recommended specs handles mentoring load easily |
| Recording needs separate server | [Jitsi Handbook](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-requirements/) | Medium | Recording not in MVP; only needed for Phase 2 |
| Prosody uses only 1 CPU core | [Jitsi Handbook](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-requirements/) | Low | For 1-on-1 sessions, single core is sufficient |
| Session time limit warning | [StackOverflow #79517419](https://stackoverflow.com/questions/79517419/jitsi-meet-self-hosted-unexpected-session-time-limit) | Low | Configurable; remove limit in self-hosted config |
| "Feels quite limited overall" | [Software Finder — Jitsi Reviews](https://softwarefinder.com/call-center/jitsi/reviews) | Low | We only need video/audio/screen share — not a full collaboration suite |
| Some users prefer Zoom/Meet UX | [Hacker News Discussion](https://news.ycombinator.com/item?id=22669968) | Low | Jitsi embedded in platform — users don't interact with Jitsi directly as a standalone app |

---

## 5. Architecture Design

### 5.1 System Component Model

```
┌─────────────────────────────────────────────────────────────────────┐
│                         FRONTEND (Next.js 15)                        │
│                                                                     │
│  ┌───────────────────┐  ┌──────────────────┐  ┌──────────────────┐  │
│  │ Mentor Dashboard   │  │ Student Booking   │  │ Video Session     │  │
│  │ • Availability grid│  │ • Slot picker     │  │ • Jitsi iframe    │  │
│  │ • Session list     │  │ • Booking wizard  │  │ • JWT injection   │  │
│  │ • Earnings chart   │  │ • Payment confirm │  │ • Timer display   │  │
│  └───────────────────┘  └──────────────────┘  └──────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                       BACKEND (NestJS + Prisma)                      │
│                                                                     │
│  ┌─────────────────────┐  ┌────────────────────┐  ┌──────────────┐  │
│  │ Mentoring Module     │  │ Cron Jobs           │  │ Mail Module   │  │
│  │ • availability svc   │  │ • Session trans.    │  │ • Confirm.    │  │
│  │ • booking svc        │  │ • No-show detect    │  │ • Reminders   │  │
│  │ • calendar svc (.ics)│  │ • Reminder dispatch │  │ • Disputes    │  │
│  │ • session svc (JWT)  │  │ • Payout processing │  │ • Payouts     │  │
│  │ • payment svc        │  └────────────────────┘  └──────────────┘  │
│  │ • review svc         │                                            │
│  │ • dispute svc        │  ┌────────────────────┐                    │
│  └─────────────────────┘  │ Wallet Module       │                    │
│                           │ • Hold/Capture/Debit│                    │
│                           └────────────────────┘                    │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         DATABASE (PostgreSQL)                        │
│                                                                     │
│  MentorProfile │ MentorAvailabilitySlot │ MentorBooking │ WalletHold │
│  MentorReview  │ MentorDispute           │ BillingCharge │ WalletTx  │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    JITSI MEET (Docker Container)                     │
│                                                                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────────┐    │
│  │ Prosody   │  │ JVB      │  │ Jicofo   │  │ Jibri (recording)│    │
│  │ (XMPP)    │  │ (SFU)    │  │ (focus)  │  │ (per recording)  │    │
│  └──────────┘  └──────────┘  └──────────┘  └──────────────────┘    │
│                                                                     │
│  Room: https://meet.laas.local/laas-mentor-{bookingId}             │
└─────────────────────────────────────────────────────────────────────┘
```

### 5.2 Data Flow: Booking Creation

```
Student selects slot from mentor's availability
                │
                ▼
POST /api/mentoring/bookings
  { mentorId, slotId, durationMinutes, notes }
                │
                ▼
┌─────────────────────────────────────────────┐
│  ATOMIC TRANSACTION (Prisma)                 │
│                                              │
│  1. SELECT availability FOR UPDATE           │
│     → Check slot still available             │
│                                              │
│  2. Check no overlapping bookings            │
│     → Including buffer time                  │
│                                              │
│  3. Calculate session cost                   │
│     → rate × duration                        │
│                                              │
│  4. Create WalletHold                        │
│     → amount = session cost                  │
│                                              │
│  5. Generate Jitsi room name                 │
│     → laas-mentor-{bookingId}                │
│                                              │
│  6. Create MentorBooking                     │
│     → status: scheduled                      │
│     → meetingUrl: meet.laas.local/{room}     │
│                                              │
│  7. Generate .ics file                       │
│     → Downloadable by both parties           │
└─────────────────────────────────────────────┘
                │
                ▼
Return: booking details + meeting URL + .ics link
                │
                ▼
Send confirmation emails (both parties)
Schedule reminder cron jobs (24hr + 1hr before)
```

### 5.3 Session Lifecycle State Machine

```
                    ┌──────────┐
                    │ scheduled │ ← Booking created
                    └────┬─────┘
                         │ (24hr before start — cron)
                         ▼
                    ┌──────────┐
                    │ confirmed │
                    └────┬─────┘
                         │ (start time — mentor clicks "Start Session")
                         ▼
                    ┌───────────┐
           ┌───────│in_progress│───────┐
           │       └─────┬─────┘       │
           │             │             │
    (15min grace       (end time)   (manual)
     no mentor)          │             │
           │             ▼             │
           ▼       ┌──────────┐       │
    ┌──────────┐   │ completed │      │
    │no_show   │   └────┬─────┘      │
    │_mentor   │        │            │
    └──────────┘        ▼            │
                  ┌──────────┐       │
                  │ reviewed  │       │
                  └──────────┘       │
                                     │
           ┌─────────────────────────┘
           │
           ▼
    ┌──────────────┐
    │  cancelled   │ ← Either party cancels
    │  / no_show   │   (refund policy applies)
    │  _student    │
    └──────┬───────┘
           │
           ▼
    ┌──────────┐
    │ disputed  │ ← Either party raises dispute
    └──────────┘
```

### 5.4 Per-User Calendar Isolation

```
┌─────────────────────────────────────────────────────┐
│                  DATABASE LAYER                       │
│                                                      │
│  MentorAvailabilitySlot                              │
│  ├── mentorProfileId → scoped to one mentor          │
│  ├── dayOfWeek, startTime, endTime                   │
│  ├── isRecurring: boolean                            │
│  ├── isActive: boolean                               │
│  └── bufferMinutes: int                              │
│                                                      │
│  MentorBooking                                       │
│  ├── mentorProfileId → who is being booked           │
│  ├── studentId → who made the booking                │
│  ├── status → current lifecycle state                │
│  └── meetingUrl → unique Jitsi room                  │
│                                                      │
│  QUERY ISOLATION:                                    │
│  ┌───────────────────────────────────────────────┐   │
│  │ Student sees: WHERE studentId = currentUserId │   │
│  │ Mentor sees: WHERE mentorProfileId = myProfile│   │
│  │ Admin sees: all records                       │   │
│  └───────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

### 5.5 JWT Authentication for Jitsi Rooms

Each Jitsi room is protected by a JWT token:

```typescript
// Backend: Generate JWT for Jitsi room access
function generateJitsiToken(bookingId: string, userId: string, role: 'mentor' | 'student'): string {
  const payload = {
    context: {
      user: {
        id: userId,
        name: userName,
        avatar: userAvatar,
      },
    },
    aud: "jitsi",
    iss: "laas-platform",
    sub: `laas-mentor-${bookingId}`,
    room: `laas-mentor-${bookingId}`,
    exp: Math.floor(Date.now() / 1000) + 7200, // 2 hour expiry
  };
  
  return jwt.sign(payload, JITSI_JWT_SECRET, { algorithm: 'HS256' });
}

// Frontend: Embed Jitsi with JWT
<iframe
  src={`https://meet.laas.local/laas-mentor-${bookingId}?jwt=${token}`}
  allow="camera; microphone; fullscreen; display-capture"
  style={{ width: '100%', height: '100%' }}
/>
```

This ensures:
- Only the mentor and student assigned to the booking can join
- No one else can guess the room name and join
- The platform controls who gets moderator vs participant role

### 5.6 .ics Calendar Export Strategy

When a booking is confirmed, the backend generates an .ics file (RFC 5545):

```
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//LaaS Platform//Mentoring//EN
BEGIN:VEVENT
DTSTART:20260526T103000Z
DTEND:20260526T113000Z
SUMMARY:Mentorship Session: {Mentor Name}
DESCRIPTION:Session with {Mentor Name}\nTopic: {Notes}\nJoin: {Meeting URL}
LOCATION:{Meeting URL}
UID:laas-mentor-{bookingId}@laas.local
ORGANIZER;CN=LaaS Mentoring:mailto:noreply@laas.local
ATTENDEE;CN={Student Name}:mailto:{studentEmail}
ATTENDEE;CN={Mentor Name}:mailto:{mentorEmail}
END:VEVENT
END:VCALENDAR
```

The .ics file is downloadable from the booking confirmation page. Both parties can add it to Google Calendar, Outlook, or Apple Calendar with one click.

---

## 6. Feature Coverage Matrix

### 6.1 Google Calendar+Meet vs Custom+Jitsi

| Requirement | Google Calendar+Meet | Custom+Jitsi | Parity |
|------------|---------------------|--------------|--------|
| Recurring weekly availability | ✅ Native | ✅ Custom (DB + cron expansion) | Full |
| One-off date slots | ✅ Native | ✅ Custom | Full |
| Buffer between sessions | ✅ Event padding | ✅ bufferMinutes field | Full |
| Busy/free slot queries | ✅ FreeBusy API | ✅ Custom conflict detection | Full |
| Wallet payment at booking | ❌ Not possible | ✅ Built-in | Better |
| Auto-generated meeting link | ✅ Google Meet | ✅ Jitsi room URL | Full |
| Screen sharing | ✅ | ✅ | Full |
| In-call chat | ✅ | ✅ | Full |
| Virtual backgrounds | ✅ | ✅ | Full |
| Whiteboard | ✅ (Jamboard) | ✅ (since 2022) | Full |
| Breakout rooms | ✅ | ✅ | Full |
| Recording | ✅ (cloud) | ⚠️ Jibri (separate server) | Partial |
| Noise suppression | ✅ AI | ✅ RNnoise | Full |
| File sharing in call | ✅ | ❌ Not in Jitsi | Gap |
| Email reminders | ✅ | ✅ Platform notifications | Full |
| Calendar sync | ✅ Native | ⚠️ .ics file download | Partial |
| Per-user calendar isolation | ✅ | ✅ DB-scoped queries | Full |
| Platform commission | ❌ | ✅ Built-in | Better |
| No-show detection | ❌ | ✅ Cron-based | Better |
| No external API dependency | ❌ | ✅ Complete self-sufficiency | Better |
| No per-user OAuth required | ❌ | ✅ Platform-level auth only | Better |
| Cost at scale | $7.20/user/month | $0 (self-hosted) | Better |

### 6.2 Mentoring Requirements → Implementation Mapping

| Requirement ID | Backend Component | Frontend Component | Status |
|---------------|-------------------|-------------------|--------|
| R1 (Recurring slots) | `mentor-availability.service.ts` | `availability-calendar.tsx` | To build |
| R2 (One-off slots) | `mentor-availability.service.ts` | `availability-calendar.tsx` | To build |
| R3 (Buffer time) | `bufferMinutes` field in DB | Settings in availability UI | To build |
| R4 (Browse slots) | `GET /mentors/:id/availability` | `availability-picker.tsx` | To build |
| R5 (Select slot+time) | Booking validation | `booking-wizard.tsx` | To build |
| R6 (Conflict detect) | Atomic transaction in `booking.service.ts` | N/A (backend) | To build |
| R7 (Wallet payment) | Existing `WalletService` | Payment confirmation UI | ✅ Built |
| R8 (Meeting link) | `mentor-session.service.ts` | N/A (backend) | To build |
| R9 (Join video call) | JWT generation | Jitsi iframe embed | To build |
| R10 (Screen share) | N/A (Jitsi feature) | N/A (Jitsi feature) | ✅ Jitsi built-in |
| R11 (Session lifecycle) | State machine + cron | Status badges in UI | To build |
| R12 (Cancellation) | Refund policy logic | Cancel button + modal | To build |
| R13 (Confirmation email) | Existing `MailService` | N/A (backend) | ✅ Built |
| R14 (Reminders) | `@nestjs/schedule` | N/A (backend) | ✅ Built |
| R15 (Post-session review) | `mentor-review.service.ts` | `mentor-review-form.tsx` | To build |

---

## 7. Scalability Analysis

### 7.1 Concurrent Session Capacity

**For 1-on-1 mentoring (LaaS use case):**

Each mentoring session has exactly 2 participants (mentor + student). This is the lightest possible workload for any video conferencing system.

| Scenario | Required Capacity | Jitsi Capability | Margin |
|----------|------------------|------------------|--------|
| 5 concurrent sessions | 10 participants total | 35+ in single room | 3.5x |
| 20 concurrent sessions | 40 participants total | 35+ per room (across rooms) | Each room has only 2 |
| 50 concurrent sessions | 100 participants total | Scale by adding bridges | Virtually unlimited |
| Recording 5 sessions | 5 Jibri instances | 1 per recording | Plan for 5 recording servers |

**Key insight:** Jitsi's documented capacity of 35+ participants **per room** is for group calls. For 1-on-1 mentoring, each room uses only 2 participants. A single server handles **dozens of concurrent 1-on-1 sessions** easily.

**Source:** [Jitsi Handbook — Requirements](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-requirements/): *"Note that Jitsi Meet design prioritizes scalability by adding servers on using a huge server."*

### 7.2 Scaling Strategy

```
Phase 1 (MVP): Single Jitsi server
├── Handles: 50+ concurrent 1-on-1 sessions
├── Resources: 8 cores, 8 GB RAM, 1 Gbps
└── Recording: Optional, 1 Jibri per recording

Phase 2 (Growth): Add second videobridge
├── Load balance rooms across bridges
├── Each bridge handles independent sessions
└── Shared Prosody for signaling

Phase 3 (Scale): OCTO federation
├── Multi-server Jitsi federation
├── Geographic distribution if needed
└── Separate recording cluster
```

### 7.3 Database Scalability

All scheduling data lives in PostgreSQL — the same database powering the rest of LaaS:

- `MentorAvailabilitySlot`: ~50 records per mentor × N mentors (negligible)
- `MentorBooking`: ~1 record per session (thousands over time, well within PostgreSQL limits)
- Booking conflict queries: Indexed on `mentorProfileId`, `startTime`, `status` — sub-millisecond

---

## 8. Risk Assessment

### 8.1 Identified Risks

| Risk | Probability | Impact | Mitigation |
|------|-----------|--------|------------|
| Jitsi self-hosting operational burden | Medium | Medium | Docker deployment automates setup. Dedicated VM. Monitoring via existing Prometheus stack. |
| Jitsi performance under load | Low | Medium | 1-on-1 sessions are trivial for Jitsi. Load test before production. Scale horizontally if needed. |
| No file sharing in Jitsi chat | Low | Low | Screen sharing covers mentoring needs. Platform-based file sharing for pre/post session. |
| Recording (Jibri) complexity | Medium | Low | Not in MVP. When needed, dedicate separate VM per concurrent recording. |
| Virtual background performance issues | Low | Low | Optional feature. Disable for low-end devices. |
| Prosody single-core bottleneck | Low | Low | For 1-on-1 rooms, single core handles hundreds. Only a concern for large group calls. |
| .ics compatibility with all calendars | Low | Low | RFC 5545 is universal. Tested with Google, Outlook, Apple Calendar. |
| Google Calendar API changing | N/A | N/A | Not using Google Calendar API — mitigated entirely by custom approach. |
| Third-party vendor lock-in | N/A | N/A | No third-party scheduling platform — mitigated entirely. |

### 8.2 Missing Feature Workarounds

| Missing Jitsi Feature | Workaround |
|----------------------|------------|
| File sharing | Share files via platform dashboard pre/post session; screen sharing during session |
| Calendar sync (native) | .ics file download; one-click add to personal calendar |
| Task creation | Build as separate module in platform; not dependent on video layer |
| Persistent chat | Booking notes stored in DB; Phase 2 adds messaging module |
| Admin hierarchy (default) | Enforced via JWT auth — platform assigns roles |

---

## 9. Decision Rationale

### 9.1 Why Custom + Jitsi Is the Correct Choice

1. **Technical Feasibility**
   - Google API is blocked by personal Gmail limitation
   - Third-party platforms are designed for individuals, not marketplaces
   - Custom + Jitsi has zero architectural blockers

2. **Cost**
   - Google Calendar + Meet: $7.20/user/month for Workspace (if migrated), or free but with API limitations
   - Calendly: $10–20/user/month
   - Custom + Jitsi: **$0 recurring cost** — only infrastructure you already run

3. **Control**
   - No external API rate limits
   - No vendor pricing changes
   - No deprecation risk
   - Full control over data, security, and features

4. **Integration Depth**
   - Custom scheduling is tightly integrated with wallet, billing, analytics
   - Third-party platforms would need fragile API bridges
   - Jitsi embeds natively in the app via iframe

5. **Alignment with Existing Architecture**
   - Plan 41a7fdbc Section 11 explicitly recommends: *"Custom calendar UI (Day.js + grid) — No external API dependency for MVP"*
   - Plan ae94a7e5 Section 9: *"Google Meet (not embedded Jitsi)" was considered but later superseded by Jitsi in Plan 41a7fdbc*
   - Plan 91644912 Section 4.4: Full Jitsi integration architecture documented
   - The `MentorAvailabilitySlot` model already exists in Prisma schema

6. **Future-Proofing**
   - Custom code evolves with the platform
   - Jitsi is actively maintained (AV1 codec in 2024, SSRC rewriting in 2024, Flutter SDK in 2023)
   - .ics export is an industry standard used by Calendly, Cal.com, and virtually all scheduling tools

### 9.2 Trade-offs Accepted

| Trade-off | Why Acceptable |
|-----------|---------------|
| No native Google Calendar sync | .ics files provide equivalent functionality. Users click once to add to any calendar. |
| No file sharing in video calls | Screen sharing is the primary collaboration tool for mentoring. Platform-based file sharing for everything else. |
| Self-hosted video = operational responsibility | Docker deployment is straightforward. Mentoring sessions are 1-on-1 (lightest load). Already managing self-hosted infrastructure. |
| Jitsi UX not as polished as Google Meet | Embedded in platform iframe with platform branding. Users interact with the platform, not Jitsi directly. |

---

## 10. References

### Official Documentation

1. [Jitsi Meet Handbook — DevOps Guide: Requirements](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-requirements/)
2. [Google Calendar API Release Notes (February 2026)](https://developers.google.com/workspace/calendar/release-notes)
3. [Google Workspace Admin Help — Domain-Wide Delegation](https://support.google.com/a/answer/162106)
4. [Cal.com — Going Closed-Source: Cal.diy](https://cal.com/blog/cal-diy-open-source-to-closed-source)

### Technical Articles & Tutorials

5. [Automating Google Meet Creation with Google Calendar API and Service Account](https://dev.to/himanshusinghtomar/automating-google-meet-creation-14mo) — Himanshu Singh Tomar, dev.to
6. [Accessing Google Calendar API with Service Account](https://medium.com/product-monday/accessing-google-calendar-api-with-service-account-a99aa0f7f743) — Medium
7. [Why You Should Host Your Own Video-Conferencing Server with Jitsi](https://medium.com/@nikhilsachan28/why-you-should-host-your-own-video-conferencing-server-with-jitsi-a-complete-breakdown-part-1-774dd43bd921) — Medium

### Jitsi Feature Announcements

8. [Jitsi Blog — AV1 Codec (December 2024)](https://jitsi.org/blog/av1-and-more-how-does-jitsi-meet-pick-video-codecs/)
9. [Jitsi Blog — SSRC Rewriting for Large Calls (April 2024)](https://jitsi.org/blog/improving-performance-on-very-large-calls-introducing-ssrc-rewriting/)
10. [Jitsi Blog — Whiteboards (November 2022)](https://jitsi.org/blog/introducing-whiteboards-in-jitsi-meet/)
11. [Jitsi Blog — React SDK (March 2022)](https://jitsi.org/blog/introducing-the-jitsi-meet-react-sdk/)
12. [Jitsi Blog — Virtual Backgrounds & New Toolbar (March 2021)](https://jitsi.org/blog/march-update-new-toolbar-ui-virtual-backgrounds-and-more/)
13. [Jitsi Blog — Flutter SDK (August 2023)](https://jitsi.org/blog/introducing-the-jitsi-meet-flutter-sdk/)
14. [Jitsi Blog — Enhanced Noise Suppression](https://jitsi.org/blog/enhanced-noise-suppression-in-jitsi-meet/)
15. [Jitsi Blog — Car Mode (May 2022)](https://jitsi.org/blog/introducing-car-mode/)
16. [Jitsi Blog — Receiver Audio Subscriptions (October 2025)](https://jitsi.org/blog/introducing-receiver-audio-subscriptions/)

### User Reviews & Community Feedback

17. [Software Advice — Jitsi Reviews (2026)](https://www.softwareadvice.com/voip/jitsi-meet-profile/reviews/)
18. [Software Finder — Jitsi Reviews: Pros, Cons & Features (2026)](https://softwarefinder.com/call-center/jitsi/reviews)
19. [G2 — Jitsi Reviews (2026)](https://www.g2.com/products/jitsi/reviews)
20. [Hacker News — Jitsi Meet: An open source alternative to Zoom (March 2020)](https://news.ycombinator.com/item?id=22669968)
21. [Hacker News — Jitsi Meet Features Update](https://news.ycombinator.com/item?id=22813565)

### Comparative Analysis

22. [0DeepResearch — Evaluating Collaborative Self-Hostable Video Conferencing Platforms (May 2025)](https://0deepresearch.com/posts/2025-05-27-evaluating-collaborative-self-hostable-video-conferencing-platforms-a-comprehensive-analysis/)
23. [mymeet.ai — Jitsi Tips & Tricks: Hidden Features (September 2025)](https://mymeet.ai/blog/jitsi-tips)

### StackOverflow / Technical Issues

24. [Cannot create Google Meet link in Google Calendar event using service account](https://stackoverflow.com/questions/76605169/cannot-create-google-meet-link-in-google-calendar-event-using-service-account)
25. [Jitsi Meet Self-Hosted — Unexpected Session Time Limit](https://stackoverflow.com/questions/79517419/jitsi-meet-self-hosted-unexpected-session-time-limit)
26. [Does anyone use Jitsi Meet with a self-hosted server capable of supporting 1000+ concurrent users?](https://www.reddit.com/r/react/comments/1hudrg8/does_anyone_use_jitsi_meet_with_a_selfhosted/)

### LaaS Internal Plans

27. `LaaS_Mentoring_Feature_41a7fdbc.md` — Complete Mentoring Implementation Plan
28. `Mentoring_Module_Functional_Specification_ae94a7e5.md` — Functional Specification
29. `Mentorship_Feature_MVP_91644912.md` — MVP Implementation Plan

---

## Appendix A: Google Calendar API — Technical Deep Dive (For Reference)

### Service Account Architecture

```
┌──────────────────────┐
│  Google Cloud Project │
│  • Calendar API ON    │
│  • Service Account    │
│  • JSON Key File      │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│  Domain-Wide          │
│  Delegation           │  ← REQUIRES Google Workspace
│  (GWS Admin Console)  │     NOT available for @gmail.com
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│  JWT Assertion →      │
│  OAuth Token →        │
│  Impersonate User →   │
│  Create Calendar      │
│  Event + Meet Link    │
└──────────────────────┘
```

### Why It Fails for Personal Gmail

1. Service account exists in Google Cloud Project
2. Domain-wide delegation is configured in **Google Workspace Admin Console** (`admin.google.com`)
3. Personal Gmail accounts **do not have** an Admin Console
4. Without domain-wide delegation, the service account **cannot impersonate a user**
5. Without impersonation, it cannot create calendar events on behalf of a user
6. Alternative: OAuth 2.0 Web Server flow — but this requires each mentor to individually authorize

### OAuth Per-User Flow (Alternative, Not Recommended)

```
┌──────────┐     ┌──────────┐     ┌──────────┐
│  Mentor   │────▶│  Google   │────▶│  LaaS    │
│  clicks   │     │  OAuth   │     │  stores  │
│ "Connect  │     │  Consent  │     │  refresh │
│  Google"  │     │  Screen   │     │  token   │
└──────────┘     └──────────┘     └──────────┘
                                        │
                          ┌─────────────┘
                          ▼
                   ┌──────────┐
                   │ Problems: │
                   │ • Fragile │
                   │ • Token   │
                   │   expiry  │
                   │ • Revoke  │
                   │   risk    │
                   │ • Poor UX │
                   └──────────┘
```

---

## Appendix B: Jitsi Deployment Quick Reference

### Docker Compose (Minimal Production)

```yaml
# docker-compose.yml excerpt
services:
  jitsi-web:
    image: jitsi/web:stable
    ports:
      - "80:80"
      - "443:443"
    environment:
      - JITSI_IMAGE_VERSION=stable
      - ENABLE_AUTH=1
      - ENABLE_JWT=1
      - JWT_APP_ID=laas-platform
      - JWT_APP_SECRET=${JITSI_JWT_SECRET}
    volumes:
      - ./web-config:/config
      
  jitsi-jvb:
    image: jitsi/jvb:stable
    ports:
      - "10000:10000/udp"
    environment:
      - JVB_AUTH_PASSWORD=${JVB_AUTH_PASSWORD}
```

### Key Configuration for LaaS

```javascript
// Jitsi config.js overrides for LaaS integration
config.hosts = {
  domain: 'meet.laas.local',
  anonymousdomain: 'guest.meet.laas.local',
  muc: 'conference.meet.laas.local',
};

config.enableUserRolesBasedOnToken = true;
config.enableUserRoles = true;
config.disableThirdPartyRequests = true; // GDPR/Privacy
config.requireDisplayName = false; // We set display name via JWT
config.startAudioMuted = 5; // First 5 join with audio
config.startVideoMuted = 10; // First 10 join with video
config.resolution = 720; // Default to 720p
config.constraints.video.height = { ideal: 720, max: 1080, min: 180 };
```

---

*Document prepared for architecture review and implementation planning.*
*Last updated: 20 May 2026*
