# LaaS Session Module — Comprehensive Specification

> **Status:** Active Design — Implementation Reference  
> **Last Updated:** 20 May 2026  
> **Purpose:** Authoritative spec for the Session booking lifecycle, state machine, payment flows, cancellation rules, and audit trail requirements  
> **Author:** Architecture & Product Design

---

## Table of Contents

1. [Overview](#1-overview)
2. [Session Types](#2-session-types)
3. [Session State Machine — MEET_NOW](#3-session-state-machine--meet_now)
4. [Session State Machine — SLOT_BOOKING](#4-session-state-machine--slot_booking)
5. [Status Definitions](#5-status-definitions)
6. [Payment Flow and Escrow Model](#6-payment-flow-and-escrow-model)
7. [Cancellation and Refund Rules](#7-cancellation-and-refund-rules)
8. [Verification Steps Before Join Now](#8-verification-steps-before-join-now)
9. [JWT-Based Session Termination](#9-jwt-based-session-termination)
10. [Database Schema and Audit Trail](#10-database-schema-and-audit-trail)
11. [UI Tab Visibility Rules](#11-ui-tab-visibility-rules)
12. [Constraints and Business Rules](#12-constraints-and-business-rules)
13. [Integration Points](#13-integration-points)
14. [Future Considerations](#14-future-considerations)

---

## 1. Overview

The Session Module manages the end-to-end lifecycle of mentoring video sessions on the LaaS platform. It covers two distinct booking flows — **Meet Now** (ad-hoc, mentor-approved) and **Slot Booking** (pre-scheduled, auto-confirmed) — each with its own state machine, payment rules, and termination logic.

All session data, status transitions, payment events, and participant actions are recorded in the database for full audit compliance. The calendar visualization layer derives entirely from these session objects.

### Core Principles

- **No external API dependency**: Jitsi Meet (self-hosted) for video; custom scheduling; `.ics` export for calendar sync
- **Platform escrow**: Advance payments held in transient platform wallet, released to mentor only on session completion
- **Audit-first**: Every state change logged with timestamp, actor, and reason
- **Single live session constraint**: A mentor can have at most one `LIVE` session at any given time

---

## 2. Session Types

| Attribute | MEET_NOW | SLOT_BOOKING |
|-----------|----------|--------------|
| **Trigger** | Student clicks "Meet Now" on mentor profile | Student selects date + time slot from mentor's availability |
| **Approval** | Required (mentor approves/rejects within 15 min) | Not required (auto-confirmed on booking) |
| **Duration** | Set by mentor in profile (30/60/90 min) | Set by mentor in profile (30/60/90 min) |
| **Timing** | Same day only (ad-hoc) | Any future date within mentor's availability window |
| **Payment trigger** | After mentor approval | At booking time (advance only) |
| **TTL** | 15-minute countdown on `PENDING` state | No TTL (stays `SCHEDULED` until session time) |
| **JWT grace** | Duration + 10 min from session start | `scheduled_end` + 10 min |

---

## 3. Session State Machine — MEET_NOW

```
                         ┌───────────┐
                    ┌────│  PENDING   │────┐
                    │    └─────┬─────┘    │
                    │          │          │
         mentor     │   mentor │   15-min │ TTL
         rejects    │ approves │  expires │
                    │          │          │
                    ▼          ▼          ▼
              ┌──────────┐ ┌──────────┐ ┌─────────────────┐
              │ REJECTED │ │SCHEDULED │ │ REQUEST_EXPIRED │
              └──────────┘ └────┬─────┘ └─────────────────┘
                                │
                     ┌──────────┼────────────┐
                     │          │            │
              student│   both   │   neither  │
              cancels│   join   │   joins    │
                     │          │   (grace)  │
                     ▼          ▼            ▼
              ┌──────────┐ ┌──────────┐ ┌──────────┐
              │CANCELLED │ │   LIVE   │ │  MISSED  │
              └──────────┘ └────┬─────┘ └──────────┘
                                │
                         session│ ends
                                │
                                ▼
                          ┌───────────┐
                          │ COMPLETED │
                          └───────────┘
```

### Transition Table — MEET_NOW

| From | To | Trigger | Actor |
|------|----|---------|-------|
| `PENDING` | `SCHEDULED` | Mentor approves | Mentor |
| `PENDING` | `REJECTED` | Mentor rejects | Mentor |
| `PENDING` | `REQUEST_EXPIRED` | 15-min TTL expires with no action | System |
| `SCHEDULED` | `LIVE` | Both participants join Jitsi room | System (JWT verification) |
| `SCHEDULED` | `CANCELLED` | Student or mentor cancels | Student / Mentor |
| `SCHEDULED` | `MISSED` | Grace period expires without both joining | System |
| `LIVE` | `COMPLETED` | All participants leave OR JWT expires | System |

### Key Notes — MEET_NOW

1. **"Join Now" button** appears for BOTH mentor and student only after:
   - Mentor has approved
   - Student has completed payment (advance or full)
2. **Payment gating**: Until the student pays, the session stays `SCHEDULED` but "Join Now" is locked with a "Pay to Join" prompt
3. **One live session per mentor**: If the mentor already has a `LIVE` session, new `PENDING` requests queue normally but "Join Now" for approved sessions is deferred until the current session ends
4. **Duration**: Always the mentor's profile-configured default (e.g., 60 min). The user cannot change this for Meet Now.

---

## 4. Session State Machine — SLOT_BOOKING

```
                         ┌───────────┐
                         │ SCHEDULED │
                         └─────┬─────┘
                               │
              ┌────────────────┼──────────────────┐
              │                │                  │
       mentor │         both   │          time    │
   reschedules│         join   │         passes   │
              │         during │         no-show  │
              │         window │                  │
              ▼                ▼                  ▼
        ┌───────────┐   ┌──────────┐      ┌──────────┐
        │RESCHEDULED│   │   LIVE   │      │  MISSED  │
        └───────────┘   └────┬─────┘      └──────────┘
                              │
                       session│ ends
                              │
                              ▼
                        ┌───────────┐
                        │ COMPLETED │
                        └───────────┘

        Also from SCHEDULED:
        ┌──────────┐
        │CANCELLED │ ← Either party cancels
        └──────────┘
```

### Transition Table — SLOT_BOOKING

| From | To | Trigger | Actor |
|------|----|---------|-------|
| `SCHEDULED` | `LIVE` | Both participants join during time window | System |
| `SCHEDULED` | `CANCELLED` | Student or mentor cancels | Student / Mentor |
| `SCHEDULED` | `RESCHEDULED` | Mentor reschedules (old session cancelled, new created) | Mentor |
| `SCHEDULED` | `MISSED` | Scheduled time passes without both participants joining | System |
| `LIVE` | `COMPLETED` | All participants leave OR JWT expires | System |

### Key Notes — SLOT_BOOKING

1. **Time window enforcement**: Session can only start between `scheduled_from` and `scheduled_end`. "Join Now" is disabled outside this window.
2. **Payment pending label**: If the student has paid the advance but not the balance, the Upcoming tab shows a "Payment Pending" badge next to the status. "Join Now" is locked until balance is paid.
3. **Reschedule**: Currently a dummy button. Future implementation will cancel the current session (status `RESCHEDULED`) and create a new session object with updated date/time.
4. **No approval needed**: Slot bookings go directly to `SCHEDULED` — the mentor is implicitly available because the slot came from their availability calendar.

---

## 5. Status Definitions

| Status | Description | Flow | UI Tab |
|--------|-------------|------|--------|
| `PENDING` | Meet Now request awaiting mentor decision (15-min countdown active) | MEET_NOW | Requests |
| `SCHEDULED` | Session confirmed and awaiting start time | Both | Upcoming |
| `LIVE` | Session in progress — participants in Jitsi room | Both | Live Sessions |
| `COMPLETED` | Session ended normally (participants left or JWT expired) | Both | Past |
| `CANCELLED` | Session cancelled by either party before going live | Both | Past |
| `REJECTED` | Mentor declined the Meet Now request | MEET_NOW | Past |
| `REQUEST_EXPIRED` | Meet Now request expired (15-min TTL, no mentor action) | MEET_NOW | Past |
| `RESCHEDULED` | Mentor rescheduled the slot booking (new session created) | SLOT_BOOKING | Past |
| `MISSED` | Session time passed without both participants joining | Both | Past |
| `DISPUTED` | Refund dispute raised (mentor wallet insufficient balance) | Both | Past (admin flag) |

### Status Dot Colors (UI Convention)

| Status | Color | Hex |
|--------|-------|-----|
| `PENDING` | Orange | `#FDA422` |
| `SCHEDULED` | Green | `#05C004` |
| `LIVE` | Green (blinking) | `#05C004` |
| `COMPLETED` | Green | `#05C004` |
| `CANCELLED` | Red | `#E70000` |
| `REJECTED` | Red | `#E70000` |
| `REQUEST_EXPIRED` | Grey | `#818178` |
| `RESCHEDULED` | Grey | `#818178` |
| `MISSED` | Grey | `#818178` |
| `DISPUTED` | Red | `#E70000` |

---

## 6. Payment Flow and Escrow Model

### 6.1 Meet Now Payment

```
Student clicks "Meet Now"
        │
        ▼
   [PENDING] ──mentor approves──→ [SCHEDULED]
                                       │
                                  student pays
                                  session amount
                                       │
                                       ▼
                               "Join Now" unlocked
                               for both parties
                                       │
                                  both join
                                       │
                                       ▼
                                    [LIVE]
                                       │
                                  session ends
                                       │
                                       ▼
                                 [COMPLETED]
                                       │
                              advance released from
                              platform escrow to
                              mentor wallet
```

**Payment timing:**
- Student pays **after** mentor approves (not before)
- Payment can be advance (partial) or full session amount
- "Join Now" button is locked until payment is complete

**Escrow semantics:**
- Advance payments held in **platform escrow wallet** (transient state)
- Funds released to mentor wallet **only** when session reaches `COMPLETED`
- If session is `CANCELLED` or `REQUEST_EXPIRED`, funds follow refund rules (Section 7)

### 6.2 Slot Booking Payment

```
Student books a slot
        │
        ▼
   pays advance amount
        │
        ▼
   [SCHEDULED]
   "Payment Pending" badge in UI
        │
   time approaches, student pays balance
        │
        ▼
   "Join Now" unlocked for both parties
        │
   both join during time window
        │
        ▼
      [LIVE]
        │
   session ends
        │
        ▼
   [COMPLETED]
        │
   all held funds released to mentor wallet
```

**Payment timing:**
- **Advance** paid at booking time (confirms the slot)
- **Balance** due before session start (before "Join Now" unlocks)
- "Payment Pending" label shown in Upcoming tab until balance is paid

**Escrow semantics:**
- Same as Meet Now: all funds held in platform wallet until `COMPLETED`

### 6.3 Payment Status Field

Each session has a `payment_status` field (orthogonal to session status):

| payment_status | Description |
|----------------|-------------|
| `unpaid` | No payment made yet (Meet Now before student pays) |
| `advance_paid` | Advance received, balance outstanding (Slot Booking) |
| `fully_paid` | Full session amount received |

---

## 7. Cancellation and Refund Rules

### 7.1 Student Cancels

| Scenario | Refund |
|----------|--------|
| Student cancels after paying advance | **Advance is non-refundable** (per Terms & Conditions) |
| Student cancels before paying anything (Meet Now) | No financial impact |

### 7.2 Mentor Cancels

| Scenario | Refund |
|----------|--------|
| Mentor cancels, student paid advance | **Full refund** from mentor's wallet to student |
| Mentor cancels, student paid FULL amount | **Amount is non-refundable** to student (per SLA) — mentor keeps it |
| Mentor wallet has insufficient balance for refund | System raises `DISPUTED` status, notifies platform admins |

### 7.3 System-Triggered End States

| Scenario | Financial Impact |
|----------|-----------------|
| `REQUEST_EXPIRED` (15-min TTL) | No payment occurred; no refund needed |
| `MISSED` (no-show) | Follows student-cancel rules (advance non-refundable) |
| `COMPLETED` | All held funds released from escrow to mentor wallet |

### 7.4 Dispute Flow

When the system detects insufficient mentor wallet balance for a required refund:
1. Session status set to `DISPUTED`
2. Admin notification sent
3. Admin reviews and manually resolves (force refund from platform reserve, mediate, etc.)

---

## 8. Verification Steps Before "Join Now"

The "Join Now" button is enabled only when ALL of the following conditions are met:

| # | Check | Applies To |
|---|-------|-----------|
| 1 | **Payment complete**: `payment_status` = `fully_paid` | Both |
| 2 | **Time window valid**: Current time is between `scheduled_from` and `scheduled_end` (slot bookings) or within duration window (Meet Now) | Both |
| 3 | **Mentor not in live session**: Mentor does not currently have a `LIVE` session | Both |
| 4 | **Camera/mic permissions**: Browser grants media access (client-side check) | Both |
| 5 | **Session is active**: Status is `SCHEDULED` (not `CANCELLED`, `MISSED`, etc.) | Both |

If any check fails, "Join Now" is replaced with an appropriate message:
- Payment not complete → "Pay to Join" button
- Outside time window → "Session starts at {time}" (disabled)
- Mentor in live session → "Mentor is in another session" (disabled)
- Media denied → "Enable camera/mic to join" (retry button)

---

## 9. JWT-Based Session Termination

### 9.1 JWT Token Structure

Each session generates a unique JWT for Jitsi authentication:

```json
{
  "context": {
    "user": { "name": "{participant_name}", "id": "{user_id}" }
  },
  "aud": "laas-platform",
  "iss": "laas-platform",
  "sub": "meet.ksrceailab.com",
  "room": "session-{sessionId}",
  "exp": {calculated_expiry}
}
```

### 9.2 Expiry Calculation

| Session Type | JWT `exp` |
|-------------|-----------|
| MEET_NOW | `session_start_time` + `duration_minutes` + 10 min grace |
| SLOT_BOOKING | `scheduled_end` + 10 min grace |

**Grace period**: 10 minutes (platform-wide constant, not per-mentor configurable)

### 9.3 Termination Behavior

1. When JWT expires, Jitsi's Prosody XMPP server disconnects all participants
2. The Jitsi room becomes empty → room terminates
3. The LaaS backend detects session end (via webhook or polling) and transitions status to `COMPLETED`
4. `ended_at` timestamp is recorded
5. Escrowed funds are released to mentor wallet

### 9.4 Room Naming

Each session gets a unique, isolated Jitsi room:
```
session-{sessionId}
```
- Participants in one room cannot see or interact with any other room
- JWT `room` claim restricts access to authorized participants only
- When JWT auth is enabled, even guessing the room name won't grant access

---

## 10. Database Schema and Audit Trail

### 10.1 Session Table

```prisma
model Session {
  id               String    @id @default(uuid())
  type             SessionType       // MEET_NOW | SLOT_BOOKING
  status           SessionStatus     // PENDING, SCHEDULED, LIVE, etc.
  paymentStatus    PaymentStatus     // unpaid, advance_paid, fully_paid

  mentorId         String
  mentor           User     @relation("MentorSessions", fields: [mentorId], references: [id])
  userId           String
  user             User     @relation("UserSessions", fields: [userId], references: [id])

  // Timing
  requestedAt      DateTime @default(now())
  approvedAt       DateTime?         // Set when mentor approves (MEET_NOW)
  scheduledFrom    DateTime?         // Slot booking start time
  scheduledTo      DateTime?         // Slot booking end time
  startedAt        DateTime?         // When session actually went LIVE
  endedAt          DateTime?         // When session ended

  // Session config
  durationMinutes  Int                // Mentor profile default or configured
  domain           String             // e.g., "Machine Learning"
  serviceType      String             // e.g., "1-on-1 Tutoring"

  // Jitsi
  jitsiRoomName    String   @unique   // e.g., "session-{id}"
  jwtToken         String?            // Generated JWT for session access

  // Financials
  earningsCents    Int                // Amount to be credited to mentor (on COMPLETED)
  advanceCents     Int?               // Advance amount paid by student
  balanceCents     Int?               // Remaining balance (slot bookings)

  // Relations
  statusHistory    SessionStatusHistory[]
  payments         SessionPayment[]

  createdAt        DateTime @default(now())
  updatedAt        DateTime @updatedAt
}
```

### 10.2 Enums

```prisma
enum SessionType {
  MEET_NOW
  SLOT_BOOKING
}

enum SessionStatus {
  PENDING
  SCHEDULED
  LIVE
  COMPLETED
  CANCELLED
  REJECTED
  REQUEST_EXPIRED
  RESCHEDULED
  MISSED
  DISPUTED
}

enum PaymentStatus {
  UNPAID
  ADVANCE_PAID
  FULLY_PAID
}
```

### 10.3 Session Status History (Audit Trail)

```prisma
model SessionStatusHistory {
  id          String   @id @default(uuid())
  sessionId   String
  session     Session  @relation(fields: [sessionId], references: [id])

  fromStatus  SessionStatus
  toStatus    SessionStatus
  changedBy   String           // "user" | "mentor" | "system"
  reason      String?          // e.g., "Mentor approved", "15-min TTL expired", "JWT expired"

  timestamp   DateTime @default(now())
}
```

**Every state transition must create a `SessionStatusHistory` record.** This includes system-triggered transitions (TTL expiry, JWT expiry, missed detection).

### 10.4 Session Payment Records

```prisma
model SessionPayment {
  id          String   @id @default(uuid())
  sessionId   String
  session     Session  @relation(fields: [sessionId], references: [id])

  amountCents Int
  paymentType PaymentType    // ADVANCE | BALANCE | FULL
  payerId     String         // student user ID
  payeeId     String         // mentor user ID

  status      PaymentRecordStatus  // HELD | RELEASED | REFUNDED
  timestamp   DateTime @default(now())

  // Link to wallet transaction
  walletTransactionId String?
}

enum PaymentType {
  ADVANCE
  BALANCE
  FULL
}

enum PaymentRecordStatus {
  HELD       // In platform escrow
  RELEASED   // Credited to mentor on COMPLETED
  REFUNDED   // Returned to student per refund rules
}
```

### 10.5 Audit Trail Requirements

| Event | Logged In | Fields Captured |
|-------|-----------|-----------------|
| Session created | `Session` + `SessionStatusHistory` | type, mentor, user, timestamp |
| Mentor approves/rejects | `SessionStatusHistory` | from PENDING, changedBy=mentor |
| 15-min TTL expires | `SessionStatusHistory` | from PENDING, changedBy=system, reason="TTL expired" |
| Student payment | `SessionPayment` + `SessionStatusHistory` | amount, type, payment_status update |
| Both join (goes LIVE) | `SessionStatusHistory` | from SCHEDULED, changedBy=system, startedAt |
| Session ends | `SessionStatusHistory` | from LIVE, changedBy=system, endedAt |
| Cancellation | `SessionStatusHistory` | who cancelled, reason |
| Refund processed | `SessionPayment` status update | REFUNDED, amount |
| Escrow release | `SessionPayment` status update | RELEASED, amount |
| Dispute raised | `SessionStatusHistory` | to DISPUTED, changedBy=system |

---

## 11. UI Tab Visibility Rules

### Mentor Dashboard — Sessions Tabs

| Tab | Visible Statuses | Notes |
|-----|-----------------|-------|
| **Requests** | `PENDING` | Only for MEET_NOW; 15-min countdown shown |
| **Upcoming** | `SCHEDULED` | Both MEET_NOW and SLOT_BOOKING; shows "Join Now" when conditions met, "Payment Pending" badge if advance-only |
| **Live Sessions** | `LIVE` | Appears as a section above the Upcoming table; only one at a time per mentor |
| **Past** | `COMPLETED`, `CANCELLED`, `REJECTED`, `REQUEST_EXPIRED`, `RESCHEDULED`, `MISSED` | Earnings shown only for `COMPLETED`; all others show `--` |

### Student Dashboard — Sessions View

| Tab | Visible Statuses | Notes |
|-----|-----------------|-------|
| **Upcoming** | `SCHEDULED` | Shows "Join Now" or "Pay to Join" depending on payment status |
| **Live** | `LIVE` | Active session with elapsed time |
| **Past** | Same as mentor Past tab | Includes their own booking history |

### Earnings Display Rule

- **Past tab**: Earnings column shows the formatted amount ONLY for `COMPLETED` status
- **All other statuses**: Earnings column shows `--`
- This applies to both mentor and student views

---

## 12. Constraints and Business Rules

### 12.1 Single Live Session Per Mentor

- A mentor can have at most **one** session in `LIVE` status at any time
- If a mentor already has a `LIVE` session:
  - New `PENDING` Meet Now requests are accepted normally (queue)
  - `SCHEDULED` sessions' "Join Now" is deferred until the current `LIVE` session ends
- Backend enforces this with a pre-join check: `SELECT COUNT(*) FROM sessions WHERE mentor_id = ? AND status = 'LIVE'`

### 12.2 Meet Now TTL

- **15 minutes** from request creation (configurable platform-wide via env var)
- When TTL expires, system transitions `PENDING` → `REQUEST_EXPIRED`
- Both parties notified (in-app + email)

### 12.3 JWT Grace Period

- **10 minutes** past session end time (platform-wide constant)
- Not configurable per-mentor
- Applies to both MEET_NOW and SLOT_BOOKING

### 12.4 Meet Now Duration

- Set by mentor in their profile settings
- Options: 30 min, 60 min, 90 min (or custom)
- Same duration applies to all Meet Now requests for that mentor
- Slot bookings can override per-slot if needed

### 12.5 Slot Booking Time Window

- "Join Now" is only enabled between `scheduled_from` and `scheduled_end`
- Session cannot start before `scheduled_from` (prevents early access)
- JWT expires at `scheduled_end` + 10 min grace

### 12.6 Reschedule Policy

- Currently: dummy button (no-op)
- Future: Cancels current session (status `RESCHEDULED`), creates new session with updated date/time
- Reschedule by mentor = full refund option for student if new time doesn't work

### 12.7 Calendar Derivation

- Calendar events are derived entirely from `Session` objects
- `SCHEDULED` sessions with `scheduled_from`/`scheduled_to` appear as calendar blocks
- MEET_NOW sessions (ad-hoc) appear on the calendar for the day they occur
- `COMPLETED`/`CANCELLED`/`MISSED` sessions appear in past calendar view

---

## 13. Integration Points

### 13.1 Wallet System

| Integration | Direction | Purpose |
|-------------|-----------|---------|
| `billing_charges` | Platform → Wallet | Charge student on payment |
| Platform escrow wallet | Internal | Hold advance payments |
| Mentor wallet credit | Platform → Wallet | Release on `COMPLETED` |
| Refund to student | Platform → Wallet | Process per cancellation rules |

### 13.2 Notifications

| Event | Recipients | Channel |
|-------|-----------|---------|
| Meet Now request created | Mentor | Email + In-app |
| Mentor approved | Student | Email + In-app |
| Mentor rejected | Student | Email + In-app |
| Request expired (TTL) | Both | Email + In-app |
| Session going LIVE | Both | In-app |
| Session completed | Both | Email |
| Cancellation | Both | Email + In-app |
| Payment received | Mentor | In-app |
| Dispute raised | Admins | Email + Admin dashboard |

### 13.3 Jitsi Meet

- Room URL: `https://meet.ksrceailab.com/session-{sessionId}`
- JWT passed as query parameter: `?jwt={token}`
- JWT auth must be enabled (`ENABLE_AUTH=1`) in production
- JVB port: 50000 (within allowed 49152-65535 range)

### 13.4 Mentor Availability (Calendar)

- Slot bookings validate against `MentorAvailabilitySlot` Prisma model
- Conflict detection prevents double-booking
- Buffer time between sessions (configurable, default 15 min)

---

## 14. Future Considerations

1. **Recurring sessions**: Same slot every week for N weeks
2. **Waitlist**: Students join waitlist, notified when a slot opens
3. **Session recordings**: Option to record and share via platform
4. **Compute-assisted mentoring**: Mentor joins student's live GPU lab session for real-time debugging
5. **Dispute resolution UI**: Admin dashboard for managing `DISPUTED` sessions
6. **Dynamic pricing**: Mentor sets different rates for different time slots
7. **Session notes/tasks**: Pre and post session to-dos linked to bookings
8. **Multi-language support**: Session notes and UI in regional languages

---

## Appendix A: Quick Reference — Status by Tab

```
Requests:  [PENDING]
Upcoming:  [SCHEDULED]
Live:      [LIVE]
Past:      [COMPLETED] [CANCELLED] [REJECTED] [REQUEST_EXPIRED] [RESCHEDULED] [MISSED]
```

## Appendix B: Quick Reference — Payment Status by Session Status

```
PENDING:           unpaid
SCHEDULED:         unpaid | advance_paid | fully_paid
LIVE:              fully_paid (always)
COMPLETED:         fully_paid (always)
CANCELLED:         varies (refund processed)
REJECTED:          unpaid (no payment occurred)
REQUEST_EXPIRED:   unpaid (no payment occurred)
RESCHEDULED:       advance_paid (transferred to new session)
MISSED:            advance_paid (non-refundable)
DISPUTED:          varies (admin resolution)
```
