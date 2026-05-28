# Mentor Home Page Design — Documentation Plan

## Context

After thorough review of the existing codebase, here is what we understand:

**Current Home Page** (`frontend-new/src/app/(console)/home/page.tsx`, 265 lines):
- Greeting header with time-based greeting + user display name
- Two tabs: "Home" and "Billing", driven by `?tab=billing` URL search param
- Renders `HomeTabContent` or `BillingTabContent` based on active tab
- Zero credits warning banner for low-balance users

**HomeTabContent** (`frontend-new/src/components/home/home-tab-content.tsx`, 760 lines):
- Welcome info banner ("Welcome to LaaS")
- Low Runway warning (for compute users)
- **Overview** section: 3 `QuickStatCard` components — Storage (used/quota GB + status), Compute Sessions (active count), Resources (datasets + notebooks count)
- **Quick Actions**: "Launch Compute", "Manage Storage", "API Keys" buttons
- **Recent Activity**: Accordion-style date-grouped activity log, fetched from `getRecentActivity()`. Events include `auth.login`, `session.created`, `file.upload`, `billing.charge`, etc. Each entry shows category dot (color-coded), timestamp, description, and status badge.

**Billing Page** (`frontend-new/src/app/(console)/billing/page.tsx`, 220 lines):
- Sub-tabs: "Usage Overview" and "Invoice & Payment History"
- "Add Credits" gold button with modal

**PaymentHistoryTab** (`frontend-new/src/components/billing/payment-history-tab.tsx`, 653 lines):
- Table with grid layout: Date, Amount, Status (color dot), Description, Type, Actions
- **ActionDropdown** component: three-dot vertical button, opens dropdown with "View Details" and "Download Invoice" options
- Pagination (Previous/Next) with "Showing X-Y of Z"
- Empty state with icon + message

**Sidebar Nav** (`frontend-new/src/components/sidebar-nav.tsx`, 264 lines):
- Static `navSections` array: HOME, THE HUB, MANAGE (Instances, Storage), ACCOUNT (Profile, SSH Keys, Billing, Refer & Earn)
- No role-based filtering currently — same nav for all users

**Database / Roles**:
- `Role` model with `name` field (seeded values: `admin`, `billing_admin`, `faculty`, `lab_instructor`, `mentor`, `student`, `external_student`, `public_user`)
- `UserOrgRole` links User to Role within an Organization
- Frontend `User` interface has `roles?: string[]`
- `MentorProfile` model: 1:1 with User, has `headline`, `bio`, `expertiseAreas`, `pricePerHourCents`, `avgRating`, `totalSessions`, `isAvailable`
- `MentorBooking` model: `mentorProfileId`, `studentUserId`, `scheduledAt`, `durationMinutes`, `status` (varchar), `amountCents`, `meetingUrl`, `notes`

---

## Task 1: Add New Section to README — "Mentor Home Page Design"

Add a new section (Section 20) to `ReadMe/Mentoring-Module-README.md` after the existing 19 sections. This section will document the complete Mentor Home Page design.

### Sub-sections to add:

#### 20.1 Role-Based Navigation

Document how the sidebar nav changes for a Mentor user:

| Regular User Nav | Mentor Nav |
|---|---|
| HOME | HOME |
| THE HUB (Templates) | SESSIONS (new top-level nav item) |
| MANAGE (Instances, Storage) | CHAT (coming soon) |
| ACCOUNT (Profile, SSH Keys, Billing, Refer & Earn) | PROFILE, BILLING |

Key implementation notes to document:
- `sidebar-nav.tsx` must read `user.roles` and conditionally render `navSections`
- For Mentor role: replace the MANAGE and HUB sections with mentor-specific nav
- The HOME route stays the same (`/home`) but the page content changes based on role
- New nav icon needed for "SESSIONS" and "CHAT"

#### 20.2 Mentor Home Page Structure

Document the page layout (mirrors regular user but with different tabs):

```
Mentor Home Page
├── Greeting Header (same: "Good morning/afternoon/evening, {displayName}!")
├── Pending Requests Banner (NEW: replaces zero-credits banner for mentors)
│   "You have {N} pending session request(s) expiring soon"
├── Tab Navigation
│   ├── "Home" tab (default)
│   └── "Sessions" tab
└── Tab Content
    ├── Home → MentorHomeTabContent
    └── Sessions → MentorSessionsTabContent
```

Implementation approach:
- In `home/page.tsx`, check `user.roles?.includes("mentor")` to determine which tabs to show
- Regular user sees: `["home", "billing"]`
- Mentor sees: `["home", "sessions"]`
- The "Home" tab label is the same but renders `MentorHomeTabContent` instead of `HomeTabContent`

#### 20.3 Home Tab — Mentor Overview Section

Ideated metrics contextually relevant for mentors (analogous to Storage/Compute/Resources for platform users):

| Metric Card | Value | Subtitle | Status Badge |
|---|---|---|---|
| **Pending Requests** | Count of PENDING bookings | "Awaiting your response" | Pulsing amber dot if > 0 |
| **Upcoming Sessions** | Count of CONFIRMED future bookings | "Next: {date} at {time}" | Green dot if any today |
| **Total Earnings** | Sum of COMPLETED booking `amountCents` (minus commission) | "This month: ₹X" | No status badge |
| **Avg. Rating** | `MentorProfile.avgRating` / 5.0 | "{totalReviews} reviews" | Gold star icon |

Rationale: Just as a platform user cares about Storage (capacity), Compute (running work), and Resources (assets), a mentor cares about pending demand, upcoming commitments, earnings, and reputation.

#### 20.4 Home Tab — Welcome Dialogue Box

Personalized for mentor context (replaces the regular user's "Welcome to LaaS" banner):

```
Title: "Welcome back, {firstName}!"
Body: "You have {N} pending request(s) and {M} upcoming session(s) today.
       Set your availability to let students book time with you."
CTA: "Set Availability" → links to /mentoring/availability (future)
```

#### 20.5 Home Tab — Quick Actions

Mentor-specific quick actions (analogous to Launch Compute / Manage Storage / API Keys):

| Action | Link | Rationale |
|---|---|---|
| **Set Availability** | `/mentoring/availability` | Core mentor workflow — set open slots |
| **View Requests** | `/home?tab=sessions&sub=requests` | Jump to pending session requests |
| **Earnings Report** | `/billing` | View earnings and payouts |

Same `QuickActionButton` component style as regular user (outlined button, hover effect).

#### 20.6 Home Tab — Recent Activity

Same behavior and component as regular user (no change to the accordion pattern). New mentor-specific activity events to add:

| Action Code | Description | Category |
|---|---|---|
| `mentor.booking_received` | "New booking request from {studentName}" | mentoring |
| `mentor.booking_confirmed` | "Session confirmed with {studentName}" | mentoring |
| `mentor.booking_cancelled` | "Session cancelled: {studentName}" | mentoring |
| `mentor.session_completed` | "Session completed with {studentName} — ₹{amount}" | mentoring |
| `mentor.review_received` | "New review from {studentName}: {rating} stars" | mentoring |
| `mentor.earning_credited` | "₹{amount} credited to your wallet" | mentoring |
| `mentor.no_show` | "No-show: {studentName} did not join" | mentoring |

Category color for mentoring: `#C8AA6E` (the gold/accent color already used in the platform).

#### 20.7 Sessions Tab — Sub-Tab Structure

The Sessions tab has its own sub-tab navigation (like the Billing page has Usage/History):

```
Sessions Tab
├── Sub-Tab Navigation (URL param: ?sub=requests|upcoming|complete)
│   ├── "Requests"   — PENDING bookings needing mentor action
│   ├── "Upcoming"   — CONFIRMED future sessions
│   └── "Complete"   — COMPLETED / CANCELLED / NO_SHOW sessions
└── Table Content (varies by sub-tab)
```

Default sub-tab: `requests`. URL example: `/home?tab=sessions&sub=upcoming`

#### 20.8 Sessions Tab — Table Specifications

**Sub-tab: Requests**

| Column | Data Source | Format | Notes |
|---|---|---|---|
| Mentee | `MentorBooking.student` → `User.firstName + lastName` | "John Doe" with avatar | Fetch student name via relation |
| Service Type | Derived from `MentorProfile.expertiseAreas` or booking context | "Code Review", "Project Help", etc. | Phase 1: show "Mentoring" as default |
| Objective | `MentorBooking.notes` | Truncated to 60 chars + tooltip | "Need help debugging PyTorch model..." |
| Status | `MentorBooking.status` | Amber dot + "Pending" | Always PENDING in this tab |
| Duration | `MentorBooking.durationMinutes` | "60 min" | |
| Earnings | `MentorBooking.amountCents` minus commission | "₹800.00" | Show net after platform commission |
| Expires In | Calculated: `createdAt + 5min - now` | "3:42" countdown (mm:ss) | Red when < 1 min. Auto-refresh every 10s. If expired: "Expired" label |
| Actions | ActionDropdown (three-dot button) | Dropdown menu | Options: "Accept", "Reject" |

**Sub-tab: Upcoming**

| Column | Data Source | Format | Notes |
|---|---|---|---|
| Mentee | Same as above | Same | |
| Service Type | Same | Same | |
| Objective | Same | Same | |
| Status | `MentorBooking.status` | Green dot + "Confirmed" | |
| Date & Time | `MentorBooking.scheduledAt` | "May 22, 6:00 PM" | |
| Duration | Same | Same | |
| Earnings | Same | Same | |
| Actions | ActionDropdown | Dropdown | Options: "Join Video" (if within 15min), "Cancel", "Reschedule" |

**Sub-tab: Complete**

| Column | Data Source | Format | Notes |
|---|---|---|---|
| Mentee | Same | Same | |
| Service Type | Same | Same | |
| Objective | Same | Same | |
| Status | `MentorBooking.status` | Color-coded: Green=Completed, Gray=Cancelled, Red=No-Show | |
| Date & Time | Same | Same | |
| Duration | Actual or scheduled | "55 min" or "60 min (scheduled)" | |
| Earnings | `amountCents` minus commission | "₹800.00" or "₹0.00" (if cancelled/no-show) | |
| Rating | `MentorReview.rating` | 1-5 stars or "—" if not reviewed | |
| Actions | ActionDropdown | Dropdown | Options: "View Details" |

#### 20.9 Sessions Tab — Action Dropdown Pattern

Reuse the exact same `ActionDropdown` component pattern from `payment-history-tab.tsx`:
- Three-dot vertical SVG icon button
- Click opens absolutely-positioned dropdown below/right
- Close on outside click (`useEffect` with `mousedown` listener)
- Menu items vary by sub-tab and booking status
- Hover effect on menu items

For Phase 1, the Request dropdown has:
- **Accept** — Changes status PENDING → CONFIRMED
- **Reject** — Changes status PENDING → CANCELLED_BY_MENTOR (with optional reason)

#### 20.10 Sessions Tab — Request Expiry Countdown

The "Expires In" column is unique to the Requests sub-tab:
- Each PENDING booking has a 5-minute TTL from `createdAt`
- Display format: `mm:ss` countdown (e.g., "3:42")
- Color: amber normally, red when < 1 minute remaining
- When expired: show "Expired" badge, disable Accept/Reject actions
- Implementation: `useEffect` with `setInterval(1000)` to update countdown display
- Backend cron job should auto-expire PENDING bookings past 5 minutes

#### 20.11 Role-Based View Switching Logic

Document the conditional rendering approach:

```typescript
// In home/page.tsx
const isMentor = user?.roles?.includes("mentor");

// Tab labels change based on role
const tabs = isMentor
  ? [{ id: "home", label: "Home" }, { id: "sessions", label: "Sessions" }]
  : [{ id: "home", label: "Home" }, { id: "billing", label: "Billing" }];

// Tab content changes based on role + active tab
{currentTab === "home" ? (
  isMentor ? <MentorHomeTabContent user={user} /> : <HomeTabContent user={user} />
) : isMentor ? (
  <MentorSessionsTabContent />
) : (
  <BillingTabContent user={user} />
)}
```

Similarly in `sidebar-nav.tsx`:
```typescript
const isMentor = user?.roles?.includes("mentor");
const sections = isMentor ? mentorNavSections : regularNavSections;
```

---

## Task 2: Update Table of Contents

Add entry `20. Mentor Home Page Design` to the Table of Contents at the top of the README.

---

## Execution Summary

| Step | Action | File |
|---|---|---|
| 1 | Add Section 20 (sub-sections 20.1-20.11) to README | `ReadMe/Mentoring-Module-README.md` |
| 2 | Update Table of Contents with new section | `ReadMe/Mentoring-Module-README.md` |

Total estimated addition: ~300-400 lines of documentation in the README.