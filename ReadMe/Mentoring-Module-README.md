# LaaS Mentoring Module — Living Design Document

> **Status:** Draft — Active Discussion  
> **Last Updated:** 26 May 2026  
> **Purpose:** Cohesive README + evolving spec that will ultimately derive the PRD and implementation documentation  
> **Author:** Architecture & Product Design

---

## Table of Contents

1. [Module Overview & Strategic Context](#1-module-overview--strategic-context)
2. [Core Objectives](#2-core-objectives)
3. [User Personas & Permission Matrix](#3-user-personas--permission-matrix)
4. [High-Level Architecture](#4-high-level-architecture)
5. [Data Model Overview](#5-data-model-overview)
6. [User Flows](#6-user-flows)
7. [Feature Inventory](#7-feature-inventory)
8. [Booking Lifecycle & State Machine](#8-booking-lifecycle--state-machine)
9. [Payment & Wallet Integration](#9-payment--wallet-integration)
10. [Video Conferencing (Jitsi Meet)](#10-video-conferencing-jitsi-meet)
11. [Calendar & Scheduling Engine](#11-calendar--scheduling-engine)
12. [Notifications & Reminders](#12-notifications--reminders)
13. [Reviews & Reputation System](#13-reviews--reputation-system)
14. [Admin & Dispute Resolution](#14-admin--dispute-resolution)
15. [Integration Points with Existing Modules](#15-integration-points-with-existing-modules)
16. [Technology Decisions & Rationale](#16-technology-decisions--rationale)
17. [Phased Delivery Plan](#17-phased-delivery-plan)
18. [Open Questions & Decisions Needed](#18-open-questions--decisions-needed)
19. [References & Source Files](#19-references--source-files)
20. [Mentor Home Page Design](#20-mentor-home-page-design)

---

## 1. Module Overview & Strategic Context

### What Is the Mentoring Module?

The Mentoring module transforms LaaS from a pure compute platform into a **full-stack AI learning ecosystem**. Students who use GPU instances for projects can book 1:1 sessions with expert mentors for guidance, code review, career advice, and project troubleshooting — all within the same platform.

### Why Build It?

- **Monetize expertise** — Platform earns commission on every mentor session
- **Increase retention** — Students who get mentoring stay longer and consume more GPU
- **Differentiate from competitors** — No major GPU cloud (Lambda, RunPod, Paperspace, Vast.ai) offers integrated mentorship
- **Leverage existing infrastructure** — Wallet system, billing charges, notifications, and user roles are already built
- **Compute-assisted mentoring (future)** — A mentor can eventually observe/join a student's live lab session (GPU environment, Jupyter notebook, desktop) for real-time debugging. No competitor offers this.

### Strategic Positioning

Unlike Codementor, Topmate, or MentorCruise, LaaS mentoring is **compute-assisted** — the unique value proposition is integrated GPU cloud + expert guidance in a single platform.

**Source:** `LaaS_Mentoring_Feature_41a7fdbc.md` — Section 1

---

## 2. Core Objectives

### Success Metrics

| Metric | Target | Timeline |
|--------|--------|----------|
| Mentor adoption | 20+ active mentors | First quarter |
| Booking rate | 2+ sessions/month per active student | Ongoing |
| No-show rate | Below 5% | Ongoing |
| Average mentor rating | Above 4.0/5.0 | Ongoing |
| Platform commission revenue | Sustainable new revenue stream | Ongoing |

### What Must Be True at Launch

- [ ] Mentors can set recurring availability and manage bookings
- [ ] Students can browse, book, and pay for sessions via wallet
- [ ] Video calls happen entirely within the platform (Jitsi Meet)
- [ ] Session lifecycle is automated (scheduled → completed → reviewed)
- [ ] Platform retains commission on every paid session
- [ ] Admin can approve/suspend mentors and resolve disputes
- [ ] Both parties get email + in-app notifications for all lifecycle events
- [ ] .ics export for external calendar sync (Google/Outlook/Apple)

---

## 3. User Personas & Permission Matrix

### Roles

| Role | Can Be Mentor? | Can Book Mentor? | Payment Model |
|------|---------------|-----------------|---------------|
| **Faculty** | Yes (auto-approved) | No | Free (institutional) |
| **Lab Instructor / TA** | Yes (auto-approved) | No | Free (institutional) |
| **Student** | Yes (peer mentor, needs approval) | Yes | Wallet-based |
| **External Student** | No (MVP) | Yes | Wallet-based |
| **Public User** | No (MVP) | Yes (paid only) | Wallet-based |
| **External Expert** | Yes (admin-approved) | No | Paid, receives payout |

### Mentor Types

| Type | Description | Commission |
|------|-------------|-----------|
| **Internal (Free)** | Faculty, TAs, peer mentors | 0% — institutional offering |
| **External (Paid)** | Industry experts, freelance mentors | Configurable (default 20%) |

### Permission Matrix

| Action | Student | Mentor | Admin |
|--------|---------|--------|-------|
| Browse mentors | ✅ | ✅ | ✅ |
| Book session | ✅ | ❌ | ❌ |
| Set availability | ❌ | ✅ | ❌ |
| Cancel own booking | ✅ | ✅ | ✅ |
| Confirm/reject booking | ❌ | ✅ | ❌ |
| Leave review | ✅ | ❌ | ❌ |
| Raise dispute | ✅ | ✅ | ❌ |
| Resolve dispute | ❌ | ❌ | ✅ |
| Force cancel booking | ❌ | ❌ | ✅ |
| View earnings | ❌ | ✅ | ✅ |
| View platform analytics | ❌ | ❌ | ✅ |

**Source:** `LaaS_Mentoring_Feature_41a7fdbc.md` — Section 2, `Mentoring_Module_Functional_Specification_ae94a7e5.md` — Section 2

---

## 4. High-Level Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                    FRONTEND (Next.js 15)                          │
│  Mentor Dashboard │ Browse Mentors │ Booking UI │ Video Session   │
└──────────────────────────┬───────────────────────────────────────┘
                           │ REST API
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│                  BACKEND (NestJS + Prisma)                        │
│  Mentoring Module │ Cron Jobs │ Mail Module │ Wallet Module      │
│  • availability   │ • session transitions                         │
│  • booking        │ • no-show detection                          │
│  • calendar (.ics)│ • reminder dispatch                          │
│  • session (JWT)  │ • payout processing                          │
│  • payment        │                                              │
│  • review         │                                              │
│  • waitlist       │                                              │
│  • dispute        │                                              │
└──────────────────────────┬───────────────────────────────────────┘
                           │ Prisma ORM
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│                  DATABASE (PostgreSQL)                            │
│  MentorProfile │ MentorAvailabilitySlot │ MentorBooking           │
│  MentorBookingAudit │ MentorReview │ MentorWaitlistEntry          │
│  MentorTask │ WalletHold │ BillingCharge │ WalletTransaction      │
└──────────────────────────┬───────────────────────────────────────┘
                           │ Docker API
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│              JITSI MEET (Self-Hosted on aiserver1)               │
│  Prosody (XMPP) │ JVB (SFU) │ Jicofo (Focus) │ coturn (TURN)   │
│  Room: laas-mentor-{bookingId}                                   │
│  Access: JWT-authenticated (only mentor + student)                │
└──────────────────────────────────────────────────────────────────┘
```

**Source:** `Mentoring_Calendar_Video_Architecture_Decision_ae94a7e5.md` — Section 5

---

## 5. Data Model Overview

### Core Models

| Model | Purpose | Key Relationships |
|-------|---------|-------------------|
| `MentorProfile` | Mentor bio, expertise, rate, settings | 1:1 with `User`, 1:N `MentorAvailabilitySlot`, `MentorBooking`, `MentorReview` |
| `MentorAvailabilitySlot` | Recurring/date-specific time windows | N:1 `MentorProfile` |
| `MentorBooking` | Session booking with lifecycle | N:1 `MentorProfile` + `User` (student), 1:1 `MentorReview` |
| `MentorBookingAudit` | Immutable log of status changes | N:1 `MentorBooking` |
| `MentorReview` | Post-session rating + text | 1:1 `MentorBooking`, N:1 `MentorProfile` |
| `MentorWaitlistEntry` | Student waiting for mentor slot | N:1 `MentorProfile` + `User` |
| `MentorTask` | Pre/post session to-dos | N:1 `MentorProfile`, optional link to `MentorBooking` |

### Enums

```
BookingStatus: PENDING | CONFIRMED | RESCHEDULED | COMPLETED |
               CANCELLED_BY_STUDENT | CANCELLED_BY_MENTOR | CANCELLED_BY_ADMIN |
               NO_SHOW_STUDENT | NO_SHOW_MENTOR

MentorTaskPriority: LOW | MEDIUM | HIGH
```

### Design Decisions

| Decision | Rationale |
|----------|-----------|
| Availability = slots (not blocks with slots within) | Simpler for 1:1 mentoring. A slot IS the available window. |
| BookingStatus as enum | Clear state machine. Each transition audited. |
| No cascading deletes on bookings | `Restrict` prevents accidental history loss |
| Separate audit table | Immutable trail for disputes, payouts |
| MentorProfile as separate model | Not all users are mentors. Keeps `User` clean. |

**Source:** `Mentoring_Calendar_Module_Design_ae94a7e5.md` — Section 1

---

## 6. User Flows

### 6.1 Student Booking a Mentor (Happy Path)

```
1. Student navigates to /mentoring/browse
2. Filters by expertise, price, rating, availability
3. Views mentor profile: bio, expertise, rate, reviews, availability calendar
4. Clicks "Book Session" → sees available slots
5. Selects date/time + duration (30/60/90 min)
6. Adds session notes ("Need help debugging PyTorch model")
7. System shows price breakdown:
   - Session cost: rate × duration
   - Platform fee: included
   - Wallet balance: current
8. Confirms → wallet hold created (amount reserved)
9. Receives confirmation notification (email + in-app)
10. 24hr before: reminder email
11. 1hr before: reminder email with meeting link
12. At session time: joins video call via meeting URL
13. Session happens (video + screen share + chat)
14. Session ends → wallet hold captured → mentor credited
15. Prompted to leave review (1-5 stars + text)
```

### 6.2 Mentor Setting Up and Managing

```
1. User with Mentor role navigates to /mentoring/dashboard
2. Creates/edits mentor profile:
   - Headline, bio, expertise areas (tags)
   - Experience years
   - Hourly rate (INR)
   - Default session duration (30/60/90 min)
   - Approval mode: Auto-confirm or Manual review
3. Sets availability:
   - Recurring weekly slots (Mon/Wed/Fri 6-8pm)
   - One-off specific date slots
   - Buffer time between sessions (default 15min)
4. Receives booking notification when student books
5. Views upcoming sessions on dashboard
6. At session time: clicks meeting link to join video call
7. After session: booking auto-completes, payment released
8. Views earnings summary and payout history
9. Sees reviews left by students
```

### 6.3 Cancellation & Rescheduling

```
Cancellation Policy:
- 24+ hours before: Full refund (wallet hold released)
- 12-24 hours before: 75% refund (25% fee)
- < 12 hours or no-show: No refund (mentor compensated fully)

Rescheduling:
- Either party can request reschedule
- If 24+ hours before: free reschedule to any available slot
- If < 24 hours: treated as cancellation + new booking

Mentor Cancellation:
- Mentor cancels: always full refund to student
- Repeat mentor cancellations: flagged for admin review
```

**Source:** `LaaS_Mentoring_Feature_41a7fdbc.md` — Section 3

---

## 7. Feature Inventory

### 7.1 Mentor Features

| Feature | Phase | Description |
|---------|-------|-------------|
| Set weekly recurring availability | 1 | Pick days + time ranges |
| Set date-specific slots | 1 | Override recurring for a particular date |
| Block time off | 2 | Vacation, holidays, personal blocks |
| Set session duration | 1 | Per-profile default (30/60/90 min) |
| Buffer time | 2 | Gap between sessions for prep |
| Max sessions per day | 2 | Limit to prevent burnout |
| Approval mode | 1 | Auto-confirm or manual review |
| Session notes | 2 | Private notes per booking |
| Pre/post session tasks | 2 | To-dos linked to bookings |
| Calendar view | 1 | Upcoming, past, cancelled sessions |
| Earnings dashboard | 2 | Total earned, pending payouts |
| Booking dashboard | 1 | Confirm, cancel, reschedule, mark no-show |
| Availability template | 3 | Save common schedules for re-use |

### 7.2 Student Features

| Feature | Phase | Description |
|---------|-------|-------------|
| Browse mentors | 1 | List/search/filter by expertise, rating, rate |
| View mentor profile | 1 | Headline, bio, reviews, availability |
| View mentor schedule | 1 | Calendar view of available slots |
| Book immediately | 1 | Pick a slot — auto-confirm |
| Request booking | 2 | Send request if mentor requires approval |
| Book recurring | 3 | Same slot every week for N weeks |
| Reschedule | 2 | Change time before cutoff |
| Cancel | 1 | With fee schedule per policy |
| Session goals | 2 | Notes/goals before session |
| Join video | 1 | One-click from booking page |
| Leave review | 1 | After session completed |
| Upcoming/done | 1 | Dashboard with all bookings |
| Waitlist | 3 | Join waitlist → notified when slot opens |

### 7.3 Platform / Cross-Cutting

| Feature | Phase | Description |
|---------|-------|-------------|
| Conflict detection | 1 | Atomic Prisma transaction prevents double-booking |
| .ics export | 2 | Download/send for import into external calendars |
| Reminders | 1 | Email + in-app: 24h, 1h before session |
| Status change alerts | 1 | Confirmed, rescheduled, cancelled, completed |
| Audit trail | 2 | Every status change logged |
| Wallet integration | 1 | Payment at booking → held → released |
| Admin dashboard | 2 | Platform-wide mentoring activity |
| Dispute management | 3 | Escalate, force resolution, manage refunds |

**Source:** `Mentoring_Calendar_Module_Design_ae94a7e5.md` — Section 2

---

## 8. Booking Lifecycle & State Machine

```
                    ┌──────────┐
                    │ PENDING   │ ← Booking created (if approval mode)
                    └────┬─────┘
                         │ mentor approves
                         ▼
                    ┌──────────┐
                    │ CONFIRMED │ ← Booking confirmed
                    └────┬─────┘
                         │
              ┌──────────┼──────────────┐
              ▼          ▼              ▼
        ┌──────────┐  ┌──────────┐  ┌──────────┐
        │ COMPLETED │  │RESCHEDULED│  │ CANCELLED│
        └────┬─────┘  └──────────┘  └──────────┘
             │
             ▼
        ┌──────────┐
        │ REVIEWED  │ ← Student leaves review
        └──────────┘
```

### Status Transition Rules

| Transition | Who Can | Conditions | Wallet Action |
|------------|---------|------------|---------------|
| PENDING → CONFIRMED | Mentor | Within booking window | Hold amount |
| CONFIRMED → COMPLETED | System | Auto (end time + grace) | Release to mentor |
| CONFIRMED → CANCELLED_BY_STUDENT | Student | Before deadline | Refund per policy |
| CONFIRMED → CANCELLED_BY_MENTOR | Mentor | Any time | Full refund + penalty |
| CONFIRMED → NO_SHOW_STUDENT | System | No join 20min past | Forfeit (mentor paid) |
| CONFIRMED → NO_SHOW_MENTOR | System | Mentor absent 10min | Full refund + penalty |

**Source:** `Mentoring_Calendar_Module_Design_ae94a7e5.md` — Section 3

---

## 9. Payment & Wallet Integration

### Commission Model

| Setting | Default | Notes |
|---------|---------|-------|
| Platform commission | 20% | Configurable per mentor override |
| Internal mentors | 0% | Faculty/TA — institutional offering |
| External mentors | 20% | Industry experts |
| Min hourly rate | ₹200 | System setting |
| Max hourly rate | ₹5,000 | System setting |
| Payout threshold | ₹1,000 | Minimum before payout |

### Payment Flow

```
Student books session
        ↓
System checks wallet balance ≥ session cost
        ↓
WalletHold created (amount reserved)
        ↓
MentorBooking created (status: scheduled/confirmed)
        ↓
    [Session happens]
        ↓
Session completed → WalletHold captured → WalletTransaction (debit)
        ↓
Commission deducted → Mentor wallet credited with (amount - commission)
        ↓
BillingCharge created (chargeType: mentor_session)
```

### Refund Logic

| Scenario | Student Wallet | Mentor Wallet | Platform |
|----------|---------------|---------------|----------|
| Cancel >24h before | ✅ Full refund | ⚠️ Nothing | — |
| Cancel <24h before | ⚠️ 75% refund | ✅ 50% of fee | ✅ 50% of fee |
| Student no-show | ❌ Full charge | ✅ Full payout | — |
| Mentor cancel | ✅ Full refund | ❌ Penalty | — |
| Mentor no-show | ✅ Full refund | ❌ Penalty | — |
| Session completed | ❌ Charged | ✅ Paid | ✅ Commission |

**Source:** `LaaS_Mentoring_Feature_41a7fdbc.md` — Section 4, `Mentoring_Calendar_Module_Design_ae94a7e5.md` — Section 10

---

## 10. Video Conferencing (Jitsi Meet)

### Deployment Status

| Item | Detail |
|------|--------|
| Server | `aiserver1` (Ubuntu 22.04, 60GB RAM) |
| Public IP | `103.115.236.34` |
| Access URL | `https://103.115.236.34` (via nginx proxy on port 443) |
| JVB Media Port | UDP `50000` (within allowed 49152-65535 range) |
| TURN Relay | coturn on `3478` (user: `selkies`) |
| Auth (current) | `ENABLE_AUTH=0` (testing) |
| Auth (production) | `ENABLE_AUTH=1`, `ENABLE_GUESTS=0`, JWT-based |

### Room Creation Per Booking

When a booking is confirmed:
1. Generate unique room name: `laas-mentor-{bookingId}`
2. Generate JWT token signed with `JWT_APP_SECRET`
3. Store `jitsiRoomName` and `jitsiRoomUrl` on `MentorBooking`
4. Both parties see "Join Video" button on booking detail page
5. Frontend embeds Jitsi via iframe with JWT query param

### What Jitsi Provides

| Feature | Status |
|---------|--------|
| HD Video (720p/1080p) | ✅ |
| Screen sharing (full screen + app) | ✅ |
| Live chat (in-session) | ✅ |
| Virtual backgrounds | ✅ |
| Whiteboard | ✅ |
| Noise suppression | ✅ |
| Recording (Jibri) | ⚠️ Requires separate server (Phase 2+) |
| File sharing in chat | ❌ Use platform file sharing |

**Source:** `jitsi-production-deploy-ksrceailab_ae94a7e5.md`, `Mentoring_Calendar_Video_Architecture_Decision_ae94a7e5.md` — Section 4

---

## 11. Calendar & Scheduling Engine

### How It Works

The scheduling engine is **custom-built** (not Google Calendar, not Calendly). It provides:

- **Availability management** — CRUD on time slots with recurrence rules
- **Slot discovery** — Query open slots excluding existing bookings
- **Booking creation** — Atomic transaction with wallet hold + meeting link
- **Calendar isolation** — Each mentor has independent availability
- **.ics export** — RFC 5545 standard for external calendar sync

### Why Not Google Calendar?

| Reason | Detail |
|--------|--------|
| Personal Gmail limitation | Domain-wide delegation requires Google Workspace |
| No marketplace primitives | Google Calendar doesn't understand two-sided bookings |
| No wallet integration | Can't tie payments to calendar events |
| API rate limits | 1M queries/day but complex to manage per-user |
| Vendor lock-in | Google changes = your feature breaks |

### Why Not Cal.com / Calendly?

| Reason | Detail |
|--------|--------|
| Designed for individuals | Not two-sided marketplaces |
| Per-seat pricing | $10-20/user/month — unsustainable at scale |
| Data lives externally | Can't integrate with wallet, billing, analytics |
| Limited API | Can't embed as white-label scheduling engine |

### What We Build Instead

A purpose-built **mentoring marketplace scheduling engine**:
- Prisma models store all availability + booking data
- NestJS services handle CRUD, conflict detection, lifecycle
- React frontend provides calendar views + slot picker
- .ics export for users who want external calendar sync

**Source:** `Mentoring_Calendar_Video_Architecture_Decision_ae94a7e5.md` — Section 3, `Mentoring_Calendar_Module_Design_ae94a7e5.md` — Section 8

---

## 12. Notifications & Reminders

### Notification Events

| Event | Channel | Recipient | Priority |
|-------|---------|-----------|----------|
| Booking confirmed | Email + in-app | Both | High |
| Booking PENDING (request mode) | Email | Mentor | High |
| 24h before session | Email | Both | Medium |
| 1h before session | Email + in-app | Both | High |
| 15min before session | In-app | Both | High |
| Session ready to join | Email + in-app | Both | High |
| Session ended | Email | Both | Low |
| Review prompt (1h after) | Email + in-app | Student | Low |
| Slot becomes available (waitlist) | Email | Waitlisted students | High |
| Booking rescheduled | Email + in-app | Both | High |
| Booking cancelled | Email + in-app | Both | High |
| No-show penalty | Email | Offender | High |
| Weekly digest | Email | Both | Low |

### Implementation

Uses existing infrastructure:
- **Email**: Nodemailer + Handlebars templates in `backend/templates/`
- **In-app**: Existing `Notification` + `NotificationTemplate` models
- **Scheduling**: `@nestjs/schedule` cron jobs (every 30 min checks upcoming bookings)

**Source:** `Mentoring_Calendar_Module_Design_ae94a7e5.md` — Section 7, `LaaS_Mentoring_Feature_41a7fdbc.md` — Section 9

---

## 13. Reviews & Reputation System

### Review Submission

| Rule | Detail |
|------|--------|
| Trigger | Session status = `COMPLETED` |
| Window | 7 days after session end |
| Rating | 1-5 star scale |
| Text | Optional, min 10 chars, max 1000 chars |
| One per booking | Enforced at DB level (unique constraint) |
| Criteria | Optional breakdown: communication, expertise, preparation |

### Display

- On mentor profile: Average rating + total reviews + distribution bar chart
- Latest reviews first, paginated (10 per page)
- Mentor can respond to reviews (1:1 private)

### Rating Calculation

- Weighted average (Bayesian) to avoid skew from few reviews
- Updated after each review submission

**Source:** `Mentoring_Module_Functional_Specification_ae94a7e5.md` — Section 3.4, `Mentoring_Calendar_Module_Design_ae94a7e5.md` — Section 1 (MentorReview model)

---

## 14. Admin & Dispute Resolution

### Admin Dashboard

- **Overview cards**: Active mentors, bookings this month, revenue, disputes
- **Bookings table**: Filterable by status, date, mentor, student. Force cancel, refund.
- **Dispute list**: Flagged bookings with full audit trail
- **Payout management**: Pending payouts, manually trigger payouts

### Dispute Flow

```
Student/Mentor flags booking → status: DISPUTED
        ↓
Admin reviews audit trail
        ↓
Admin resolves:
  - "Refund student" → full/partial refund
  - "Pay mentor" → release funds
  - "Split" → partial refund to both
        ↓
Admin resolution logged in audit
```

### Dispute Rules

| Rule | Detail |
|------|--------|
| Time limit | Within 48 hours of session end |
| Form | Reason (dropdown) + detailed description (min 20 chars) |
| Mentor review | Mentor notified, can respond |
| Admin escalation | If unresolved after mentor review |
| Resolution | Refund / partial / none / dismissed |

**Source:** `Mentoring_Module_Functional_Specification_ae94a7e5.md` — Section 3.7, `Mentoring_Calendar_Module_Design_ae94a7e5.md` — Section 11

---

## 15. Integration Points with Existing Modules

| Existing Module | Integration |
|----------------|-------------|
| **Wallet** | Wallet hold at booking, capture at completion, refund at cancellation |
| **BillingCharge** | New charge types: `mentor_session`, `mentor_commission`, `mentor_earning` |
| **PaymentTransaction** | Linked to MentorBooking via transaction ID |
| **Notification** | New templates for all mentor events |
| **MailService** | Reuse for email notifications |
| **AuditLog** | Log all mentor actions |
| **User** | Existing profile data (avatar, name). MentorProfile is 1:1 |
| **SubscriptionPlan** | `mentorSessionsIncluded` for subscription-based credits |
| **Analytics** | Admin analytics can add mentor tabs |

**Source:** `Mentoring_Module_Functional_Specification_ae94a7e5.md` — Section 7

---

## 16. Technology Decisions & Rationale

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Video conferencing | Jitsi Meet (self-hosted) | Free, on-prem, JWT auth, no vendor lock-in |
| Scheduling engine | Custom (Prisma + NestJS) | Full control, wallet integration, marketplace primitives |
| Calendar export | .ics (RFC 5545) | Universal standard — works with Google/Outlook/Apple |
| Calendar UI | react-big-calendar + custom slot picker | Mature library, fits our use case exactly |
| Date/time handling | Day.js (already in stack) | Lightweight, timezone-aware |
| Notifications | @nestjs/schedule + Nodemailer | Already built and proven |
| Payments | Existing Razorpay wallet | Already integrated, just add charge types |
| Conflict detection | Prisma $transaction (serializable) | Database-level atomicity, no race conditions |
| Recording | Jibri (Phase 2+) | Requires separate server per recording |
| Commission | Per-mentor configurable, default 20% | Flexibility for internal vs external |

### Why Alternatives Were Rejected

| Option | Rejection Reason |
|--------|-----------------|
| Google Calendar API + Google Meet | Personal Gmail cannot use domain-wide delegation. Meet link generation unreliable. |
| Cal.com / Calendly | Designed for individuals, not two-sided marketplaces. Per-seat pricing unsustainable. |
| Zoom API | $0.008/min/participant. No JWT room auth. Anyone with link can join. |
| Full Google Workspace migration | Unnecessary cost. Platform already has self-hosted infrastructure. |

**Source:** `Mentoring_Calendar_Video_Architecture_Decision_ae94a7e5.md` — Sections 3 & 9

---

## 17. Phased Delivery Plan

### Phase 1: Core Booking (MVP) — ~1-2 weeks

| Deliverable | What's Included |
|-------------|-----------------|
| Prisma schema | MentorProfile, MentorAvailabilitySlot, MentorBooking (CONFIRMED/COMPLETED/CANCELLED) |
| Mentor profile API | CRUD, public listing, search |
| Availability API | CRUD slots (recurring + date-specific) |
| Booking API | Create (auto-confirm), cancel, list, get |
| Wallet integration | Hold on create, refund on cancel, release on complete |
| Jitsi room generation | Room name + JWT on booking create |
| Basic UI | Mentor dashboard, student browse, slot picker, booking list |
| Notifications | Email on confirm, cancel, 1h reminder |

### Phase 2: Advanced Booking — ~1 week

| Deliverable | What's Included |
|-------------|-----------------|
| Request-based booking | PENDING status, mentor approves/rejects |
| Reschedule | Full flow with time picker |
| Session notes | Pre-session goals, private notes |
| .ics export | Generate on confirm, email attachment |
| Tasks | Mentor task CRUD, link to bookings |
| Buffer time | Per-slot configurable |
| Audit trail | Track all status changes |

### Phase 3: Trust & Safety — ~1 week

| Deliverable | What's Included |
|-------------|-----------------|
| Reviews | Rating (1-5), text, criteria breakdown |
| No-show detection | Cron-based auto-detect |
| Cancellation policy | Configurable tiers, fee calculation |
| Waitlist | Join/leave/notify/claim flow |
| Dispute system | Flag, admin review, audit, forced resolution |
| Admin dashboard | Metrics, bookings table, dispute panel |

### Phase 4: Polish & Scale — ~1 week

| Deliverable | What's Included |
|-------------|-----------------|
| Calendar templates | Save/load recurring schedules |
| Bulk availability import | Set weeks at once |
| Monthly/weekly digest | Email summaries |
| Mentor earnings dashboard | Charts, breakdown, payouts |
| Recurring series booking | Same slot weekly x N weeks |
| Performance optimization | Indexes, N+1 fixes, caching |

**Source:** `Mentoring_Calendar_Module_Design_ae94a7e5.md` — Section 12

---

## 18. Open Questions & Decisions Needed

| # | Question | Options | Status |
|---|----------|---------|--------|
| 1 | Should internal mentors (faculty/TA) have wallet payouts or just credits? | Wallet credit vs. Institutional billing | Open |
| 2 | What's the exact commission rate for external mentors? | Fixed 20% vs. configurable per mentor | Open |
| 3 | Should session recording be available in Phase 1? | Yes (Jibri needed) vs. No (Phase 2+) | Open |
| 4 | How to handle timezone for international students? | Store IST always vs. store mentor's timezone | Open |
| 5 | Should waitlist have a "priority" for students who book more often? | FIFO vs. frequency-weighted | Open |
| 6 | What happens to a mentor's availability slots when they're suspended? | Auto-deactivate vs. keep as-is | Open |
| 7 | Should the mentor application form require admin approval before going live? | Self-serve (immediate) vs. Admin gate | Open |
| 8 | Should Jitsi JWT auth be enabled in Phase 1 or kept open for testing? | JWT on vs. JWT off | Open |
| 9 | How to handle the case where both mentor and student no-show? | Split refund vs. platform retains | Open |
| 10 | Should the .ics export be a download button or auto-emailed on confirm? | Both vs. email-only | Open |

---

## 19. References & Source Files

### Internal Plans (`.qoder/plans/`)

| File | Description | Lines |
|------|-------------|-------|
| `Mentoring_Calendar_Module_Design_ae94a7e5.md` | Full calendar/scheduling design with data models, APIs, UI | 910 |
| `jitsi-production-deploy-ksrceailab_ae94a7e5.md` | Jitsi deployment guide for aiserver1 | 324 |
| `LaaS_Mentoring_Feature_41a7fdbc.md` | Complete implementation plan with user journeys | 584 |
| `Mentoring_Calendar_Video_Architecture_Decision_ae94a7e5.md` | Architecture decision document (29 cited references) | 992 |
| `Mentoring_Module_Functional_Specification_ae94a7e5.md` | Functional specification with all features | 586 |
| `Mentorship_Feature_MVP_91644912.md` | MVP implementation plan | 362 |

### External References

| Source | Link |
|--------|------|
| MentorCruise × Cal.com case study | cal.com/blog/navigating-success-how-mentorcruise-and-cal-com-charted-a-new-course-in-scheduling |
| Cal.com — Open Source rationale | cal.com/blog/open-source |
| Cal.com — Marketplace scheduling | cal.com/blog/powering-a-scheduling-marketplace |
| Jitsi Meet Handbook | jitsi.github.io/handbook/docs/devops-guide/ |
| Google Calendar API — Domain-Wide Delegation | support.google.com/a/answer/162106 |
| Jitsi AV1 Codec (2024) | jitsi.org/blog/av1-and-more |
| Jitsi SSRC Rewriting (2024) | jitsi.org/blog/improving-performance-on-very-large-calls |

---

> **Note:** This document will be incrementally updated as we discuss and refine each section. Each update should reference the source file or discussion that informed the change.

---

## 20. Mentor Home Page Design

> **Scope:** This section documents the Mentor-specific Home page layout, role-based navigation, and Sessions tab design.  
> **Implementation status:** Not yet implemented — design specification only.  
> **Reference files reviewed:** `home/page.tsx`, `home-tab-content.tsx`, `billing/page.tsx`, `payment-history-tab.tsx`, `sidebar-nav.tsx`, `types/auth.ts`, Prisma schema (Role, UserOrgRole, MentorProfile, MentorBooking).

### 20.1 Role-Based Navigation

The sidebar navigation (`components/sidebar-nav.tsx`) currently renders the same `navSections` array for all users. For Mentor users, the navigation must change based on the logged-in user's role.

#### Navigation Comparison

| Regular User Nav | Mentor Nav |
|-----------------|------------|
| HOME | HOME |
| THE HUB (Templates) | SESSIONS |
| MANAGE (Instances, Storage) | CHAT (available soon) |
| ACCOUNT (Profile, SSH Keys, Billing, Refer & Earn) | ACCOUNT (Profile, Billing) |

#### Implementation Notes

- `sidebar-nav.tsx` must read the user's role (via `user.roles` array from `getMe()` API) and conditionally select which `navSections` to render.
- For Mentor role: the HUB and MANAGE sections are replaced with SESSIONS and CHAT.
- The ACCOUNT section for mentors only shows Profile and Billing (no SSH Keys, no Refer & Earn — these are platform-user features).
- The HOME route path (`/home`) stays the same, but the page content rendered at that route changes based on role (see Section 20.11).
- New `NavIcon` cases needed: `sessions` (calendar-with-clock icon) and `chat` (message-bubble icon).
- Route matching in `getActiveItem()` must add `/sessions` and `/chat` paths.

**Source:** `sidebar-nav.tsx` (lines 40–67, 114–264)

---

### 20.2 Mentor Home Page Structure

The Mentor Home page reuses the same route (`/home`) and page component (`home/page.tsx`) but renders different tabs and content based on role.

```
Mentor Home Page
├── Greeting Header (same: "Good morning/afternoon/evening, {displayName}!")
├── Pending Requests Banner (NEW — replaces zero-credits banner for mentors)
│   "You have {N} pending session request(s) expiring soon"
├── Tab Navigation
│   ├── "Home" tab (default)
│   └── "Sessions" tab
└── Tab Content
    ├── Home → MentorHomeTabContent
    └── Sessions → MentorSessionsTabContent
```

#### Key Differences from Regular User Home Page

| Aspect | Regular User | Mentor |
|--------|-------------|--------|
| Tabs | Home, Billing | Home, Sessions |
| Home tab component | `HomeTabContent` | `MentorHomeTabContent` |
| Second tab component | `BillingTabContent` | `MentorSessionsTabContent` |
| Warning banner | Zero credits warning | Pending requests banner |
| Data fetch | `getMe()`, `getBillingData()` | `getMe()`, `getMentorDashboardData()` (future API) |

#### Tab URL Pattern

- Home tab: `/home` (no query param, default)
- Sessions tab: `/home?tab=sessions`
- Sessions sub-tabs: `/home?tab=sessions&sub=requests|upcoming|complete`

**Source:** `home/page.tsx` (lines 19–265)

---

### 20.3 Home Tab — Welcome Dialogue Box

The regular user's Home tab shows a blue info banner: *"Welcome to LaaS — Your AI Lab-as-a-Service platform is ready..."*. For mentors, this is replaced with a contextually personalized banner.

```
┌─────────────────────────────────────────────────────────────┐
│ ℹ  Welcome back, {firstName}!                              │
│    You have {N} pending request(s) and {M} upcoming        │
│    session(s) today. Set your availability to let students  │
│    book time with you.                                      │
│                                        [Set Availability →] │
└─────────────────────────────────────────────────────────────┘
```

| Element | Detail |
|---------|--------|
| Style | Same info-banner component (`bgColor-info`, `borderColor-info`) as regular user |
| Title | "Welcome back, {firstName}!" |
| Body | Dynamic counts from `getMentorDashboardData()` API |
| CTA Button | "Set Availability" → links to `/mentoring/availability` (future route) |
| Zero state | If no pending requests and no upcoming sessions, body reads: "No pending requests or sessions today. Set your availability to start receiving bookings." |

**Source:** `home-tab-content.tsx` (lines 378–435, welcome banner pattern)

---

### 20.4 Home Tab — Overview Section

The regular user's Overview shows three `QuickStatCard` components: **Storage** (used/quota GB + status badge), **Compute Sessions** (active count), **Resources** (datasets + notebooks). For mentors, these are replaced with contextually relevant mentoring metrics.

#### Mentor Overview Cards

| Card | Value | Subtitle | Status Badge | Icon |
|------|-------|----------|-------------|------|
| **Pending Requests** | Count of `PENDING` bookings | "Awaiting your response" | Pulsing amber dot (`#FDA422`) if count > 0, hidden if 0 | Clock icon |
| **Upcoming Sessions** | Count of `CONFIRMED` future bookings | "Next: {date} at {time}" or "No upcoming sessions" | Green dot (`#05C004`) if any session is today | Calendar icon |
| **Total Earnings** | Sum of `COMPLETED` booking `amountCents` minus platform commission (current month) | "This month" | No status badge | Wallet icon |
| **Avg. Rating** | `MentorProfile.avgRating` out of 5.0 | "{totalReviews} review(s)" or "No reviews yet" | Gold star icon (`#C8AA6E`) | Star icon |

#### Rationale

| Regular User Metric | Mentor Equivalent | Why It Matters |
|--------------------|--------------------|---------------|
| Storage (capacity used) | Pending Requests (demand waiting) | Mentor needs to act on incoming demand — just as user monitors capacity |
| Compute Sessions (active work) | Upcoming Sessions (commitments ahead) | Mentor needs to prepare — just as user monitors running workloads |
| Resources (assets owned) | Total Earnings (revenue generated) | Mentor's financial outcome — just as user tracks resource consumption |
| _(none)_ | Avg. Rating (reputation) | Unique to marketplace roles — mentors must maintain quality |

#### Data Source

All four cards will be served by a new `getMentorDashboardData()` API (future) that returns:

```
{
  pendingRequestCount: number,
  upcomingSessionCount: number,
  nextSession: { menteeName: string, scheduledAt: string } | null,
  totalEarningsCents: number,
  avgRating: number | null,
  totalReviews: number
}
```

**Source:** `home-tab-content.tsx` (lines 482–508, `QuickStatCard` + `SectionHeader` components)

---

### 20.5 Home Tab — Quick Actions

The regular user's Quick Actions show: **Launch Compute**, **Manage Storage**, **API Keys** — using the `QuickActionButton` component (outlined button, hover effect, links to route). For mentors, the actions are contextually different.

#### Mentor Quick Actions

| Action | Link | Rationale |
|--------|------|----------|
| **Set Availability** | `/mentoring/availability` | Core mentor workflow — define open time slots for students to book |
| **View Requests** | `/home?tab=sessions&sub=requests` | Jump directly to pending session requests that need action |
| **Earnings Report** | `/billing` | View earnings, payouts, and financial summary |

#### Implementation Notes

- Reuse the same `QuickActionButton` component (lines 728–759 of `home-tab-content.tsx`)
- Buttons render in a `flex` row with `gap: 12px` and `flexWrap: wrap`
- Same hover effect: `backgroundColor: rgba(11, 11, 11, 0.05)` on mouse enter
- In Phase 1, "Set Availability" may link to a placeholder or the Sessions tab itself until the dedicated availability UI is built

**Source:** `home-tab-content.tsx` (lines 510–522, Quick Actions section)

---

### 20.6 Home Tab — Recent Activity

The Recent Activity section behavior is **identical** for mentors and regular users — same accordion-style date-grouped layout, same `getRecentActivity()` API, same `ActivityLogEntry` interface. The only change is the addition of new mentor-specific activity event types.

#### New Mentor Activity Events

| Action Code | Display Text | Category | Details Fields |
|-------------|-------------|----------|---------------|
| `mentor.booking_received` | "New booking request from {studentName}" | mentoring | `studentName`, `durationMinutes`, `scheduledAt` |
| `mentor.booking_confirmed` | "Session confirmed with {studentName}" | mentoring | `studentName`, `scheduledAt` |
| `mentor.booking_rejected` | "Booking request rejected: {studentName}" | mentoring | `studentName`, `reason` |
| `mentor.booking_cancelled` | "Session cancelled: {studentName}" | mentoring | `studentName`, `cancelledBy` |
| `mentor.session_completed` | "Session completed with {studentName} — ₹{amount}" | mentoring | `studentName`, `amountCents`, `durationMinutes` |
| `mentor.review_received` | "New review from {studentName}: {rating} stars" | mentoring | `studentName`, `rating`, `reviewText` |
| `mentor.earning_credited` | "₹{amount} credited to your wallet" | mentoring | `amountCents`, `bookingId` |
| `mentor.no_show_student` | "No-show: {studentName} did not join" | mentoring | `studentName`, `scheduledAt` |
| `mentor.availability_updated` | "Availability updated" | mentoring | `slotsAdded`, `slotsRemoved` |

#### Category Color

The `mentoring` category uses the platform gold/accent color: **`#C8AA6E`** — consistent with the golden accent used for tab underlines, add-credits button, and other premium actions.

```
case 'mentoring':
  return '#C8AA6E'; // gold
```

#### Backend Integration

These events are written to the existing `ActivityLog` table by the mentoring module's service layer whenever a booking lifecycle event occurs. The `getRecentActivity()` API already supports filtering by category, so mentor users will see a mix of `auth`, `billing`, and `mentoring` events in their feed.

**Source:** `home-tab-content.tsx` (lines 222–346, activity grouping + description formatting)

---

### 20.7 Sessions Tab — Sub-Tab Structure

The Sessions tab provides a table-based view of all mentoring session records, organized by lifecycle stage. It uses its own sub-tab navigation, similar to how the Billing page (`/billing`) has "Usage Overview" and "Invoice & Payment History" sub-tabs.

#### Sub-Tab Layout

```
Sessions Tab
├── Sub-Tab Bar (below the main Home/Sessions tabs)
│   ├── "Requests"   — PENDING bookings needing mentor action
│   ├── "Upcoming"   — CONFIRMED future sessions
│   └── "Complete"   — COMPLETED / CANCELLED / NO_SHOW sessions
└── Table Content (varies by active sub-tab)
```

#### URL Parameters

| Sub-Tab | URL | Query Param |
|---------|-----|------------|
| Requests (default) | `/home?tab=sessions` or `/home?tab=sessions&sub=requests` | `sub=requests` |
| Upcoming | `/home?tab=sessions&sub=upcoming` | `sub=upcoming` |
| Complete | `/home?tab=sessions&sub=complete` | `sub=complete` |

#### Sub-Tab Styling

- Reuse the same tab styling pattern from the Billing page (`billing/page.tsx`, lines 12–145)
- Sub-tab bar sits below the main tab bar with `marginTop: 16px`
- Active sub-tab: `fontWeight: 600`, underline `2px solid var(--fgColor-default)`
- Inactive sub-tab: `fontWeight: 400`, `color: var(--fgColor-muted)`

#### Data Source

Each sub-tab queries `MentorBooking` records filtered by status:
- **Requests:** `WHERE status = 'PENDING' AND mentorProfileId = {mentor.id}`
- **Upcoming:** `WHERE status = 'CONFIRMED' AND scheduledAt > NOW() AND mentorProfileId = {mentor.id}`
- **Complete:** `WHERE status IN ('COMPLETED', 'CANCELLED_BY_STUDENT', 'CANCELLED_BY_MENTOR', 'CANCELLED_BY_ADMIN', 'NO_SHOW_STUDENT', 'NO_SHOW_MENTOR') AND mentorProfileId = {mentor.id}`

**Source:** `billing/page.tsx` (lines 9–145, BillingTabs component pattern)

---

### 20.8 Sessions Tab — Table Specifications

#### Sub-tab: Requests

Shows all PENDING booking requests that need the mentor to accept or reject.

| Column | Data Source | Format | Notes |
|--------|-----------|--------|-------|
| **Mentee** | `MentorBooking.student` → `User.firstName + lastName` | "John Doe" with avatar circle | Fetch student name via Prisma relation |
| **Service Type** | Derived from `MentorProfile.expertiseAreas` or booking context | "Mentoring" (Phase 1 default) | Phase 2+: "Code Review", "Project Help", etc. |
| **Objective** | `MentorBooking.notes` | Truncated to 60 chars with tooltip on hover | "Need help debugging PyTorch model..." |
| **Status** | `MentorBooking.status` | Amber dot (`#FDA422`) + "Pending" | Always PENDING in this tab |
| **Duration** | `MentorBooking.durationMinutes` | "60 min" | |
| **Earnings** | `MentorBooking.amountCents` minus platform commission | "₹800.00" | Net after commission. Show commission % in tooltip |
| **Expires In** | Calculated: `createdAt + 5min - now()` | "3:42" countdown (`mm:ss`) | See Section 20.10 for full spec |
| **Actions** | `ActionDropdown` component | Three-dot button → dropdown | See Section 20.9 |

#### Sub-tab: Upcoming

Shows all CONFIRMED sessions scheduled in the future.

| Column | Data Source | Format | Notes |
|--------|-----------|--------|-------|
| **Mentee** | Same as Requests | Same | |
| **Service Type** | Same as Requests | Same | |
| **Objective** | Same as Requests | Same | |
| **Status** | `MentorBooking.status` | Green dot (`#05C004`) + "Confirmed" | |
| **Date & Time** | `MentorBooking.scheduledAt` | "May 22, 6:00 PM" | Formatted with `toLocaleDateString` + `toLocaleTimeString` |
| **Duration** | Same as Requests | Same | |
| **Earnings** | Same as Requests | Same | |
| **Actions** | `ActionDropdown` | Three-dot button → dropdown | Options: "Join Video" (enabled if within 15 min of start), "Cancel", "Reschedule" (Phase 2) |

#### Sub-tab: Complete

Shows all terminal-state sessions (completed, cancelled, no-show).

| Column | Data Source | Format | Notes |
|--------|-----------|--------|-------|
| **Mentee** | Same as Requests | Same | |
| **Service Type** | Same as Requests | Same | |
| **Objective** | Same as Requests | Same | |
| **Status** | `MentorBooking.status` | Color-coded: Green (`#05C004`) = Completed, Gray (`#818178`) = Cancelled, Red (`#E70000`) = No-Show | Label mapped from status enum |
| **Date & Time** | Same as Upcoming | Same | |
| **Duration** | Actual or scheduled | "55 min" or "60 min (scheduled)" | |
| **Earnings** | `amountCents` minus commission | "₹800.00" or "₹0.00" | Zero for cancelled/no-show sessions |
| **Rating** | `MentorReview.rating` | ★★★★★ display (1-5 filled stars) or "—" | "—" if student hasn't reviewed |
| **Actions** | `ActionDropdown` | Three-dot button → dropdown | Options: "View Details" |

#### Table Layout Pattern

- Reuse the CSS grid table pattern from `payment-history-tab.tsx` (lines 386–575)
- Container: `bgColor-mild`, `border: 1px solid borderColor-default`, `borderRadius: 4px`
- Header row: `bgColor-muted`, uppercase labels, `fontSize: 0.75rem`, `letterSpacing: 0.05em`
- Data rows: `fontSize: 0.8125rem`, hover effect `rgba(255,255,255,0.02)`
- Pagination: Previous/Next buttons with "Showing X-Y of Z" (same as billing page, lines 578–649)

**Source:** `payment-history-tab.tsx` (lines 386–653, table + pagination pattern)

---

### 20.9 Sessions Tab — Action Dropdown Pattern

The Action Dropdown reuses the exact same component pattern as `ActionDropdown` in `payment-history-tab.tsx` (lines 55–198).

#### Component Behavior

- **Trigger:** Three-dot vertical SVG icon button (`width: 32px, height: 32px`)
- **Dropdown:** Absolutely positioned below-right of trigger, `minWidth: 160px`, elevated background, border, box-shadow
- **Close:** `useEffect` with `mousedown` event listener on `document` — closes when clicking outside
- **Hover:** Each menu item highlights on hover (`bgColor-muted`)
- **Icons:** Each menu item has a leading SVG icon + label text

#### Menu Items by Sub-Tab

| Sub-Tab | Menu Item | Action | Phase |
|---------|-----------|--------|-------|
| **Requests** | Accept | `PATCH /mentoring/bookings/{id}/confirm` — status: PENDING → CONFIRMED | 1 |
| **Requests** | Reject | `PATCH /mentoring/bookings/{id}/reject` — status: PENDING → CANCELLED_BY_MENTOR. Opens modal for optional reason | 1 |
| **Upcoming** | Join Video | Opens Jitsi Meet room URL in new tab. Enabled only if current time is within 15 min of `scheduledAt` | 1 |
| **Upcoming** | Cancel | `PATCH /mentoring/bookings/{id}/cancel` — status: CONFIRMED → CANCELLED_BY_MENTOR | 1 |
| **Upcoming** | Reschedule | Opens reschedule modal with slot picker | 2 |
| **Complete** | View Details | Navigates to booking detail page | 1 |

#### Styling Reference

```
Dropdown container: backgroundColor: var(--bgColor-elevated), border: 1px solid var(--borderColor-default),
                     borderRadius: 4px, boxShadow: 0 4px 16px rgba(0,0,0,0.15), zIndex: 100
Menu item:          padding: 10px 12px, fontSize: 0.8125rem, gap: 8px between icon and text
Hover:              backgroundColor: var(--bgColor-muted)
```

**Source:** `payment-history-tab.tsx` (lines 55–198, ActionDropdown component)

---

### 20.10 Sessions Tab — Request Expiry Countdown

The **Expires In** column is unique to the Requests sub-tab and provides a real-time countdown for each pending booking request.

#### Specification

| Property | Detail |
|----------|--------|
| **TTL** | 5 minutes from `MentorBooking.createdAt` |
| **Display format** | `mm:ss` (e.g., "3:42", "0:15") |
| **Normal color** | Amber (`#FDA422`) — matches PENDING status color |
| **Urgent color** | Red (`#E70000`) — when remaining time < 1 minute |
| **Expired state** | Show "Expired" badge (gray, `#818178`). Disable Accept/Reject actions in dropdown |
| **Refresh interval** | `setInterval` at 1000ms (1-second tick) to update all visible countdowns |
| **Calculation** | `remaining = Math.max(0, (createdAt + 5min) - Date.now())` |

#### Implementation Approach

```
// Pseudocode for countdown hook
function useRequestCountdown(createdAt: string) {
  const [remaining, setRemaining] = useState(calcRemaining(createdAt));

  useEffect(() => {
    const timer = setInterval(() => {
      setRemaining(calcRemaining(createdAt));
    }, 1000);
    return () => clearInterval(timer);
  }, [createdAt]);

  return { minutes, seconds, isExpired, isUrgent };
}
```

#### Backend Auto-Expire

A backend cron job (using `@nestjs/schedule`) runs every 30 seconds to auto-expire PENDING bookings older than 5 minutes:

```
@Cron('*/30 * * * * *')
async function expirePendingBookings() {
  await prisma.mentorBooking.updateMany({
    where: {
      status: 'PENDING',
      createdAt: { lt: new Date(Date.now() - 5 * 60 * 1000) }
    },
    data: { status: 'EXPIRED' }
  });
}
```

This ensures that even if the frontend countdown lapses, the backend enforces the 5-minute TTL authoritatively.

---

### 20.11 Role-Based View Switching Logic

The home page must conditionally render different tabs and components based on the logged-in user's role.

#### In `home/page.tsx`

```typescript
const isMentor = user?.roles?.includes("mentor");

// Tab definitions change based on role
const tabs = isMentor
  ? [{ id: "home", label: "Home" }, { id: "sessions", label: "Sessions" }]
  : [{ id: "home", label: "Home" }, { id: "billing", label: "Billing" }];

// Active tab parsing (add "sessions" as valid tab)
const currentTab = isMentor
  ? (searchParams.get("tab") === "sessions" ? "sessions" : "home")
  : (searchParams.get("tab") === "billing" ? "billing" : "home");

// Tab content rendering
{currentTab === "home" ? (
  isMentor
    ? <MentorHomeTabContent user={user} />
    : <HomeTabContent user={user} />
) : isMentor ? (
  <MentorSessionsTabContent />
) : (
  <BillingTabContent user={user} />
)}
```

#### In `sidebar-nav.tsx`

```typescript
// Define two nav section arrays
const regularNavSections: NavSection[] = [ /* existing nav */ ];
const mentorNavSections: NavSection[] = [
  { id: "home", label: "HOME", href: "/home" },
  { id: "sessions", label: "SESSIONS", href: "/sessions" },
  { id: "chat", label: "CHAT", items: [
    { id: "chat-placeholder", label: "Chat (available soon)" }
  ]},
  { id: "account", label: "ACCOUNT", items: [
    { id: "profile", label: "Profile", href: "/profile" },
    { id: "billing", label: "Billing", href: "/billing" },
  ]},
];

// In NavContent component
const isMentor = user?.roles?.includes("mentor");
const sections = isMentor ? mentorNavSections : regularNavSections;
```

#### Data Flow

```
getMe() → User { roles: ["mentor"] }
    ↓
home/page.tsx reads user.roles
    ↓
├── isMentor = true → render MentorHomeTabContent + MentorSessionsTabContent
└── isMentor = false → render HomeTabContent + BillingTabContent (existing behavior)
```

#### Important Notes

- The `User` interface (`types/auth.ts`, line 91) already has `roles?: string[]`
- The `Role` model is seeded with `mentor` (`prisma/seed.ts`, line 11)
- The `getMe()` API must return the user's roles array (may need backend verification)
- A user can be both a regular platform user AND a mentor — in that case, the mentor view takes precedence when they access `/home`
- The zero-credits warning banner should be hidden for mentor users on the mentor home page (they see the pending-requests banner instead)

**Source:** `home/page.tsx` (lines 27, 219–261), `sidebar-nav.tsx` (lines 40–67), `types/auth.ts` (line 91)
