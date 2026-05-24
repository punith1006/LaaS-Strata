# LaaS Mentoring Module — Functional Specification

## 1. Module Purpose & Strategic Context

The Mentoring module transforms LaaS from a pure compute platform into a **full-stack AI learning ecosystem**. Students who use GPU instances for projects can book 1:1 sessions with expert mentors for guidance, code review, career advice, and project troubleshooting — all within the same platform. This creates stickiness, increases wallet usage, and opens a new commission revenue stream.

### Key Strategic Objectives
1. **Monetize expertise**: Platform earns commission on every mentor session
2. **Increase retention**: Students who get mentoring stay longer and consume more GPU
3. **Differentiate from competitors**: No major GPU cloud (Lambda, RunPod, Paperspace) offers integrated mentorship
4. **Leverage existing infrastructure**: Wallet system, billing charges, notifications, and user roles are already built

---

## 2. User Personas & Permission Matrix

| Persona | Description | Key Actions |
|---------|-------------|-------------|
| **Student (Mentee)** | Any platform user seeking mentorship | Browse mentors, book sessions, pay via wallet, review sessions, raise disputes |
| **Mentor** | Expert who offers paid 1:1 sessions | Create/edit profile, manage availability slots, manage calendar, view earnings, respond to disputes |
| **Admin / Business Lead** | Platform operator | Approve/reject mentor profiles (override), view all transactions, resolve disputes, set commission rate, view analytics |
| **Support Staff** | Handles disputes and issues | View dispute tickets, mediate between mentor and mentee, process refunds |

---

## 3. Feature Catalog — Complete Breakdown

### 3.1 Mentor Marketplace & Discovery

#### 3.1.1 Mentor Directory Page
- **Route**: `/mentors`
- **Layout**: Grid/list of mentor cards with:
  - Profile photo (avatar), name, headline, expertise tags
  - Star rating (avg) + review count
  - Hourly rate (₹/hr)
  - "Available now" / "Available this week" badge
  - Quick "Book Session" CTA button
- **Search & Filters**:
  - Full-text search by name, expertise, bio
  - Filter by expertise area (AI/ML, Computer Vision, NLP, Data Science, Web Dev, etc.)
  - Filter by price range (slider: ₹0 — ₹5000/hr)
  - Filter by rating (4+ stars, 4.5+ stars)
  - Filter by availability ("Available this week", "Available today")
  - Sort by: Rating (default), Price (low/high), Most sessions completed, Newest
- **State**: Empty state when no mentors match, loading skeleton cards, error state

#### 3.1.2 Mentor Profile Detail Page
- **Route**: `/mentors/[id]`
- **Sections**:
  - **Header**: Avatar, name, headline, rating stars, review count, total sessions, location
  - **About**: Full bio text, experience years, current affiliation
  - **Expertise**: Tag chips for each expertise area (clickable to filter marketplace)
  - **Stats Bar**: Total sessions completed, response rate, avg session rating
  - **Availability Calendar**: Month-view calendar showing available slots as green dots, booked slots as grey. Click a day to see available time slots.
  - **Reviews Section**: Paginated list of reviews with rating, text, date, mentee name
  - **Book Session CTA**: Sticky sidebar/bottom bar showing hourly rate, session duration selector (30min / 60min / 90min), date picker, time slot picker, "Book & Pay" button
- **State**: Not-found (invalid ID), deactivated mentor profile

#### 3.1.3 Mentor Application (Self-Serve Onboarding)
- **Route**: `/mentors/apply` (or accessible from profile/settings)
- **Multi-step Form**:
  1. **Basic Info**: Headline, bio (rich text), years of experience, current role/organization
  2. **Expertise Selection**: Multi-select from predefined categories + custom tags. Minimum 1, maximum 8.
  3. **Pricing**: Set hourly rate (₹). Show platform commission notice: "Platform retains X% commission. You receive ₹Y/hr after commission."
  4. **Availability Setup**: Initial weekly recurring slots (can add more later). Day picker + time range picker per day.
  5. **Verification**: Upload ID proof / credentials (optional for self-serve model, but stored for quality).
  6. **Terms Acceptance**: Agree to mentor terms, commission structure, cancellation policy.
- **Post-submit**: Profile immediately active (self-serve model). Admin can later suspend if needed.
- **Edit Profile**: Mentors can edit all fields anytime from `/mentors/dashboard`

### 3.2 Booking & Scheduling System

#### 3.2.1 Mentor Availability Management
- **Route**: `/mentors/dashboard/availability`
- **Calendar View**: Monthly calendar with visual indicators
- **Two Slot Types**:
  - **Recurring Weekly Slots**: "Every Monday 10:00–12:00, 14:00–16:00". These auto-generate availability indefinitely.
  - **Specific Date Slots**: "May 25, 2026 — 09:00–11:00". Overrides or supplements recurring.
- **Slot Management**:
  - Add time block (select day + start/end time)
  - Delete time block
  - Set buffer time between sessions (0, 15, 30 min)
  - Set max sessions per day
  - Block out vacation days / date ranges
- **Timezone**: All slots stored in IST (server timezone). Display converted to viewer's timezone.

#### 3.2.2 Booking Flow (Student Side)
1. Student selects date from mentor's calendar
2. System shows available time slots for that date (30/60/90 min increments based on mentor availability)
3. Student selects slot + duration
4. Student optionally adds notes: "Need help with PyTorch model debugging"
5. **Wallet Check**: System verifies sufficient balance. If insufficient, prompts wallet top-up.
6. **Confirmation Modal**: Shows mentor name, date, time, duration, total cost, wallet balance after deduction
7. On confirm: Wallet debited, Google Meet link generated, booking created (status: `scheduled`)
8. **Success Page**: Booking details, Google Meet link, "Add to Calendar" button (.ics download), session reminder info

#### 3.2.3 Session Lifecycle & State Machine
```
scheduled → confirmed → in_progress → completed
                ↓            ↓
           cancelled    no_show (mentor or mentee)
                         ↓
                      disputed
```

**Status Definitions**:
- `scheduled`: Booked but >24h before start time
- `confirmed`: Within 24h window of start
- `in_progress`: Session has started (mentor marks start)
- `completed`: Session ended normally, review pending
- `cancelled`: Cancelled before start (refund rules apply)
- `no_show_mentor`: Mentor didn't show — automatic full refund
- `no_show_mentee`: Mentee didn't show — no refund (mentor still paid)
- `disputed`: Either party raised a dispute

**Automated Transitions**:
- 24h before start: `scheduled` → `confirmed` (cron job)
- Scheduled start time + 15min grace: If mentor hasn't joined, auto-mark `no_show_mentor`
- Scheduled end time: `in_progress` → `completed` (can also be manually marked)

#### 3.2.4 Google Meet Integration
- **Link Generation**: At booking confirmation, backend calls Google Calendar API to create an event with Google Meet conferencing. Store the `meetingUrl` on the booking record.
- **Service Account**: Use a platform-level Google service account. Events are created on a platform calendar (not user's personal calendar).
- **Meeting Details**: Title: "Mentorship: [Mentor Name] × [Mentee Name]", description with booking notes, duration matching session.
- **Join Flow**: Both mentor and mentee see the Google Meet link in:
  - Booking confirmation page
  - Dashboard upcoming sessions
  - Email notification
  - SMS reminder (optional)

### 3.3 Payments & Wallet Integration

#### 3.3.1 Commission Model
- Platform commission rate: Configurable via `SystemSetting` (default: 20%)
- Calculation: `mentorPayout = sessionAmount × (1 - commissionRate)`
- Commission is earned by platform upon session completion
- Mentor earnings tracked as `mentor_earning` in `BillingCharge` (new chargeType)

#### 3.3.2 Payment Flow
1. Student books session → wallet debited immediately for full amount
2. Funds held in platform wallet (not yet paid to mentor)
3. Session completes → commission calculated → mentor's earning recorded
4. Mentor payout: Accumulated earnings shown in dashboard. Actual payout via:
   - **MVP**: Manual payout (admin processes bank transfers monthly)
   - **Future**: Automated via Razorpay Payouts / Stripe Connect

#### 3.3.3 Refund Logic
| Scenario | Refund | Mentor Paid | Commission |
|----------|--------|-------------|------------|
| Cancellation >24h before | 100% refund to wallet | No | No |
| Cancellation <24h before | 50% refund to wallet | 50% of rate | Platform keeps commission on paid portion |
| Cancellation <1h before | No refund | Full payment | Yes |
| Mentor no-show | 100% refund | No | No |
| Mentee no-show | No refund | Full payment | Yes |
| Dispute resolved in mentee's favor | Full/partial refund | Reduced/void | Adjusted proportionally |

#### 3.3.4 Invoice Generation
- After completed session: Auto-generate invoice for mentee (downloadable PDF)
- After month-end: Auto-generate earnings statement for mentor (PDF)
- Invoice data stored in existing `Invoice` + `InvoiceLineItem` tables

### 3.4 Reviews & Reputation System

#### 3.4.1 Review Submission
- **Trigger**: Session marked as `completed`
- **Window**: 7 days after session completion to submit review
- **Rating**: 1–5 star scale
- **Review Text**: Optional, min 10 chars if provided, max 1000 chars
- **One review per booking**: Enforced at DB level (existing unique constraint on `mentor_booking_id`)

#### 3.4.2 Review Display
- On mentor profile: Avg rating, total reviews, rating distribution bar chart (5★, 4★, 3★, 2★, 1★)
- Latest reviews shown first, paginated (10 per page)
- Mentor cannot delete reviews; can report inappropriate reviews to admin

#### 3.4.3 Mentor Rating Calculation
- `avgRating`: Weighted average (Bayesian to avoid skew from few reviews)
- `totalReviews`: Count of completed reviews
- Updated via DB trigger or service call after each review submission

### 3.5 Mentor Dashboard

#### 3.5.1 Dashboard Overview
- **Route**: `/mentors/dashboard`
- **Metrics Cards**: Total earnings (lifetime), earnings this month, total sessions completed, avg rating, upcoming sessions count
- **Earnings Chart**: Bar chart showing monthly earnings (last 6 months)
- **Upcoming Sessions**: List of next 5 scheduled sessions with date, time, mentee name, topic
- **Recent Reviews**: Latest 3 reviews received

#### 3.5.2 Session Management
- **Route**: `/mentors/dashboard/sessions`
- **Filterable Table**: All sessions with status filter (Upcoming / Completed / Cancelled / Disputed)
- **Actions per session**:
  - Upcoming: View details, Cancel (with reason)
  - Completed: View details, See review
  - Disputed: View dispute details, respond

#### 3.5.3 Earnings & Payouts
- **Route**: `/mentors/dashboard/earnings`
- **Earnings Table**: Per-session breakdown (date, mentee, duration, amount, commission, net earning)
- **Payout History**: Record of previous manual payouts (date, amount, reference)
- **Export**: Download CSV of earnings for tax purposes

### 3.6 Student (Mentee) Dashboard

#### 3.6.1 My Sessions
- **Route**: `/mentors/my-sessions`
- **Filterable Table**: All booked sessions with status
- **Actions**:
  - Upcoming: View details, Join Google Meet, Cancel, Add to Calendar
  - Completed: View details, Leave Review, Raise Dispute
  - Disputed: View dispute status

#### 3.6.2 My Mentors
- Bookmarked/favorite mentors for quick access
- Session history per mentor

### 3.7 Dispute Resolution System

#### 3.7.1 Raise Dispute
- **Available When**: Session completed but mentee unsatisfied, mentor no-show, technical issues
- **Time Limit**: Within 48 hours of session end time
- **Form**: Select dispute reason (dropdown: "Mentor didn't show", "Poor quality session", "Technical issues", "Other"), provide detailed description (min 20 chars), optional screenshot upload

#### 3.7.2 Dispute Workflow
```
opened → mentor_review → admin_review → resolved
   ↓                      ↓
cancelled (by mentee)  escalated
```
1. Mentee opens dispute → status: `opened`
2. Mentor notified → can respond with explanation → status: `mentor_review`
3. If unresolved → escalated to admin → status: `admin_review`
4. Admin reviews both sides, decides outcome → status: `resolved`
   - Refund (full/partial/none) processed automatically
   - Both parties notified of resolution

#### 3.7.3 Admin Dispute Panel
- **Route**: `/admin/disputes` (analytics-console route)
- Queue of open disputes with priority indicators
- View full conversation history
- Actions: Resolve (select refund amount + reason), Escalate, Request more info

### 3.8 Notifications (Reusing Existing Notification System)

| Trigger | Channel | Recipient | Template |
|---------|---------|-----------|----------|
| Booking confirmed | Email + In-app | Mentee + Mentor | "Your session with [name] is confirmed for [datetime]" |
| Session reminder (24h) | Email + In-app | Both | "Reminder: Your mentorship session is tomorrow at [time]" |
| Session reminder (1h) | In-app + Push | Both | "Your session starts in 1 hour" |
| Session completed | In-app | Mentee | "How was your session? Leave a review!" |
| New review received | In-app | Mentor | "[Name] left you a 5-star review" |
| Dispute opened | Email + In-app | Mentor | "A dispute has been opened for session on [date]" |
| Dispute resolved | Email + In-app | Both | "Dispute #[id] has been resolved: [outcome]" |
| Earnings updated | In-app | Mentor | "Your earnings have been updated: +₹[amount]" |

### 3.9 Admin Analytics & Management

#### 3.9.1 Mentor Management
- **Route**: `/admin/mentors`
- All mentors table with status, sessions, earnings, rating
- Actions: View profile, Suspend/Activate, Edit commission override, View disputes

#### 3.9.2 Session Analytics
- Total sessions per day/week/month
- Revenue from commissions (separate from compute revenue)
- Popular expertise areas
- Top mentors by sessions/earnings/rating
- Cancellation rate, no-show rate, dispute rate

#### 3.9.3 Commission Configuration
- Global commission rate (SystemSetting)
- Per-mentor commission override capability
- Commission history and projections

---

## 4. Database Schema Changes

### 4.1 New Tables Required

```sql
-- Dispute system
CREATE TABLE mentor_disputes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  mentor_booking_id UUID NOT NULL REFERENCES mentor_bookings(id),
  opened_by UUID NOT NULL REFERENCES users(id),  -- who raised the dispute
  reason VARCHAR(64) NOT NULL,
  description TEXT,
  status VARCHAR(32) NOT NULL DEFAULT 'opened',
  resolution VARCHAR(32),         -- full_refund, partial_refund, no_refund, dismissed
  refund_amount_cents BIGINT,
  admin_notes TEXT,
  resolved_by UUID REFERENCES users(id),
  resolved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE mentor_dispute_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dispute_id UUID NOT NULL REFERENCES mentor_disputes(id),
  sender_id UUID NOT NULL REFERENCES users(id),
  body TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Mentor earnings tracking
CREATE TABLE mentor_earnings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  mentor_profile_id UUID NOT NULL REFERENCES mentor_profiles(id),
  mentor_booking_id UUID NOT NULL REFERENCES mentor_bookings(id),
  gross_amount_cents BIGINT NOT NULL,
  commission_rate_percent INT NOT NULL,
  commission_cents BIGINT NOT NULL,
  net_amount_cents BIGINT NOT NULL,   -- mentor's actual earning
  status VARCHAR(32) DEFAULT 'pending_payout',  -- pending_payout, paid_out
  payout_id UUID,                      -- reference to payout batch
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Mentor payout batches
CREATE TABLE mentor_payouts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  mentor_profile_id UUID NOT NULL REFERENCES mentor_profiles(id),
  amount_cents BIGINT NOT NULL,
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,
  status VARCHAR(32) DEFAULT 'pending',  -- pending, processed, failed
  reference VARCHAR(128),
  processed_by UUID REFERENCES users(id),
  processed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Mentor bookmarks/favorites
CREATE TABLE mentor_favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  mentor_profile_id UUID NOT NULL REFERENCES mentor_profiles(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, mentor_profile_id)
);
```

### 4.2 Modify Existing Tables

```sql
-- MentorProfile: Add new columns
ALTER TABLE mentor_profiles 
  ADD COLUMN status VARCHAR(32) DEFAULT 'active',  -- active, suspended, pending_review
  ADD COLUMN commission_override INT,              -- override global commission rate for this mentor
  ADD COLUMN max_sessions_per_day INT DEFAULT 4,
  ADD COLUMN buffer_minutes INT DEFAULT 15,        -- buffer between sessions
  ADD COLUMN verified_at TIMESTAMPTZ,
  ADD COLUMN application_data JSONB;               -- store original application form data

-- MentorBooking: Add new columns
ALTER TABLE mentor_bookings
  ADD COLUMN session_duration_minutes INT DEFAULT 60,
  ADD COLUMN join_url TEXT,                        -- Google Meet link
  ADD COLUMN calendar_event_id VARCHAR(256),       -- Google Calendar event ID
  ADD COLUMN cancelled_by UUID REFERENCES users(id),
  ADD COLUMN cancelled_at TIMESTAMPTZ,
  ADD COLUMN cancel_reason TEXT,
  ADD COLUMN refund_amount_cents BIGINT,
  ADD COLUMN no_show_by VARCHAR(16);               -- 'mentor' or 'mentee'

-- BillingCharge: Support mentor transactions
ALTER TABLE billing_charges
  ADD COLUMN mentor_booking_id UUID REFERENCES mentor_bookings(id);

-- Add new charge_type values handling
-- charge_type now supports: 'compute', 'storage', 'mentor_session', 'mentor_commission'
```

### 4.3 New System Settings
```
mentor_commission_rate: 20 (percent)
mentor_min_rate_cents: 20000 (₹200 minimum per hour)
mentor_max_rate_cents: 500000 (₹5000 maximum per hour)
mentor_payout_threshold_cents: 100000 (₹1000 minimum before payout)
mentor_cancellation_window_hours: 24
mentor_dispute_window_hours: 48
mentor_review_window_days: 7
```

---

## 5. Backend Module Architecture

### 5.1 New NestJS Module: `MentorModule`

```
backend-new/src/mentor/
├── mentor.module.ts
├── mentor.controller.ts       -- Public endpoints (browse, profile, booking)
├── mentor-admin.controller.ts -- Admin endpoints (management, disputes, payouts)
├── mentor.service.ts          -- Core business logic
├── mentor-availability.service.ts -- Slot management & calendar
├── mentor-booking.service.ts  -- Booking lifecycle & state machine
├── mentor-payment.service.ts  -- Commission, payouts, refunds
├── mentor-dispute.service.ts  -- Dispute workflow
├── mentor-review.service.ts   -- Review management
├── mentor-notification.service.ts -- Notification triggers
├── mentor-google-meet.service.ts  -- Google Meet/Calendar integration
└── mentor.dto.ts              -- All DTOs
```

### 5.2 API Endpoints — Public

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/mentors` | List mentors with search, filters, pagination |
| GET | `/api/mentors/:id` | Mentor profile detail |
| GET | `/api/mentors/:id/availability` | Get available slots for date range |
| GET | `/api/mentors/:id/reviews` | Paginated reviews |
| POST | `/api/mentors/apply` | Apply to become a mentor |
| GET | `/api/mentors/dashboard` | Mentor dashboard stats |
| PUT | `/api/mentors/profile` | Update own mentor profile |
| PUT | `/api/mentors/availability` | Update availability slots |
| GET | `/api/mentors/sessions` | List own sessions (mentor view) |
| GET | `/api/mentors/earnings` | Earnings history |
| POST | `/api/mentors/bookings` | Student books a session |
| GET | `/api/mentors/bookings/:id` | Booking detail |
| POST | `/api/mentors/bookings/:id/cancel` | Cancel booking |
| POST | `/api/mentors/bookings/:id/review` | Submit review |
| POST | `/api/mentors/bookings/:id/dispute` | Raise dispute |
| GET | `/api/mentors/my-sessions` | List own sessions (student view) |
| POST | `/api/mentors/favorites/:id` | Toggle mentor favorite |
| GET | `/api/mentors/favorites` | List favorite mentors |

### 5.3 API Endpoints — Admin

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/admin/mentors` | All mentors (with filters) |
| PUT | `/api/admin/mentors/:id` | Update mentor (suspend, override commission) |
| GET | `/api/admin/disputes` | All disputes |
| PUT | `/api/admin/disputes/:id/resolve` | Resolve dispute |
| GET | `/api/admin/mentor-analytics` | Session/revenue analytics |
| POST | `/api/admin/mentor-payouts` | Process payout batch |
| GET | `/api/admin/mentor-payouts` | Payout history |

### 5.4 Cron Jobs (Scheduled Tasks)

| Cron | Schedule | Action |
|------|----------|--------|
| Session state updater | Every 5 min | Transition `confirmed` → `in_progress`, detect no-shows |
| Session completion | Every 15 min | Mark past-end-time sessions as `completed` |
| No-show detector | Every 5 min | Check if start_time + 15min grace passed without mentor join |
| Review reminder | Daily | Email mentees 24h after completed session if no review |
| Monthly earnings statement | 1st of month | Generate and email mentor earnings statements |

---

## 6. Frontend Route Structure

```
frontend-new/src/app/(console)/
├── mentors/
│   ├── page.tsx                    -- Mentor directory (search, filter, listing)
│   ├── [id]/
│   │   └── page.tsx                -- Mentor profile detail + booking
│   ├── apply/
│   │   └── page.tsx                -- Mentor application form
│   ├── dashboard/
│   │   ├── page.tsx                -- Mentor dashboard (stats, earnings chart)
│   │   ├── availability/
│   │   │   └── page.tsx            -- Calendar / slot management
│   │   ├── sessions/
│   │   │   └── page.tsx            -- Session management table
│   │   └── earnings/
│   │       └── page.tsx            -- Earnings history & payout info
│   └── my-sessions/
│       └── page.tsx                -- Student's booked sessions

frontend-new/src/app/(analytics-console)/
├── analytics/
│   └── mentors/
│       └── page.tsx                -- Admin mentor management
│   └── disputes/
│       └── page.tsx                -- Admin dispute resolution

frontend-new/src/components/
├── mentor/
│   ├── mentor-card.tsx             -- Mentor listing card
│   ├── mentor-profile-header.tsx   -- Profile header section
│   ├── mentor-availability-calendar.tsx -- Calendar component
│   ├── mentor-booking-modal.tsx    -- Booking confirmation modal
│   ├── mentor-review-card.tsx      -- Review display card
│   ├── mentor-review-form.tsx      -- Review submission form
│   ├── mentor-session-card.tsx     -- Session item in dashboard
│   ├── mentor-dispute-form.tsx     -- Dispute submission form
│   └── mentor-earnings-chart.tsx   -- Earnings bar chart
```

### 6.1 Sidebar Navigation Update

Add new section to `sidebar-nav.tsx`:

```typescript
{
  id: "mentorship",
  label: "MENTORSHIP",
  items: [
    { id: "mentors", label: "Find Mentors", href: "/mentors" },
    { id: "my-sessions", label: "My Sessions", href: "/mentors/my-sessions" },
  ],
},
```

When user has mentor profile, additionally show:
```typescript
{ id: "mentor-dashboard", label: "Mentor Dashboard", href: "/mentors/dashboard" },
```

---

## 7. Integration Points with Existing Modules

| Existing Module | Integration |
|----------------|-------------|
| **Wallet** | Wallet debited at booking; refunds credited back. New txn_type: `mentor_session_debit`, `mentor_session_refund` |
| **BillingCharge** | New charge_type: `mentor_session` (student cost), `mentor_commission` (platform revenue), `mentor_earning` (mentor payout tracking) |
| **PaymentTransaction** | Already linked to MentorBooking via `payment_transaction_id` |
| **Notification** | New notification templates for all mentor events. Reuse existing Notification + NotificationTemplate infrastructure |
| **AuditLog** | Log all mentor actions: application, booking, cancellation, dispute, review |
| **MailService** | Reuse for email notifications (booking confirmations, reminders, disputes) |
| **User** | Use existing user profile data (avatar, name). MentorProfile is 1:1 with User |
| **SubscriptionPlan** | Already has `mentorSessionsIncluded`. Can be leveraged later for subscription-based mentor credits |
| **Dashboard / Analytics** | Existing admin analytics can add mentor tabs |

---

## 8. MVP vs Full Vision — Phased Delivery

### Phase 1: MVP (4-6 weeks)
- Mentor directory with search/filter
- Mentor profile pages with reviews
- Mentor application (self-serve)
- Availability management (recurring weekly slots only)
- Booking flow with wallet payment
- Google Meet link generation
- Basic session lifecycle (scheduled → completed → reviewed)
- Review submission and display
- Mentor dashboard (basic stats)
- Student "My Sessions" page
- Email notifications for bookings
- Admin mentor management (view, suspend)

### Phase 2: v1.1 (2-3 weeks)
- Advanced availability (specific date slots, buffer time, max sessions/day)
- Dispute resolution system
- Cancellation + refund automation
- No-show detection
- Mentor earnings dashboard + payout tracking
- Monthly earnings statements (PDF)
- In-app notifications
- Session reminders (24h + 1h)
- Rating distribution charts

### Phase 3: v1.2 (2-3 weeks)
- Mentor favorites/bookmarks
- Subscription plan integration (mentor session credits)
- Advanced analytics dashboard (admin)
- Automated payouts (Razorpay/Stripe)
- Featured mentor promotion
- Session notes/history
- Mentee progress tracking across sessions

---

## 9. Key Design Decisions & Rationale

| Decision | Rationale |
|----------|-----------|
| Google Meet (not embedded Jitsi) | Zero cost, enterprise reliability, no hosting burden, familiar UX. Google Calendar API is well-documented. |
| Platform commission (not subscription) | Lower barrier to entry for students. Revenue scales with usage. Aligns with existing pay-as-you-go wallet model. |
| Self-serve mentor onboarding | Faster marketplace growth. Quality managed organically via reviews. Admin can still suspend bad actors. |
| Wallet debit at booking (not after session) | Prevents payment disputes. Holds mentor accountable (they know payment is secured). Aligns with existing compute billing where prepaid hours are used. |
| Manual payouts (MVP) | Avoids complex payment gateway integration for payouts. Can automate later with Razorpay Payouts API. |
| IST timezone for all stored slots | Platform primarily serves Indian users. Single timezone avoids conversion bugs. Display conversion handled in frontend. |
| 15-min no-show grace period | Industry standard. Protects mentors from late students. Protects students from no-show mentors. |
| 24h cancellation window | Standard in mentorship industry (Codementor, MentorCruise). Balances flexibility with mentor protection. |
