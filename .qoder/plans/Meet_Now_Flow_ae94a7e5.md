# Meet Now Instant Session Flow

## Current State
- Mentor profile page at `/mentor/[id]` has a "Schedule Session" button that opens `BookSessionModal` (3 steps: session type + date/time → available slots → details)
- `bookSession()` creates sessions with `type: 'slot_booking'`, `status: 'scheduled'`, `paymentStatus: 'advance_paid'`
- `approveSession()` transitions `pending` → `scheduled` with `scheduledFrom = now`
- `MentorSessionType` enum already has `meet_now` and `slot_booking`
- Live sessions are detected by `status: 'live'` in `getLive()`
- The hardcoded live session has been manually deleted from the DB

## What "Meet Now" Does
- Checks mentor real-time availability (not in live session, no upcoming session within 1hr, within availability slot, today not blocked)
- Creates a session as a REQUEST (`status: 'pending'`, `type: 'meet_now'`) — appears in mentor's Requests tab
- 10% advance is deducted from student wallet
- Mentor sees it in Requests tab with Approve/Reject
- On approve, session goes directly to `live` (NOT `scheduled`) — appears in Live Session section
- On reject, advance is refunded (reuse existing cancel/refund logic)

## Task 1: Availability Check Backend Endpoint

**File:** `backend-new/src/mentor-sessions/mentor-sessions.service.ts`

Add `checkAvailabilityNow(mentorProfileId)` method:
- Check `mentorBlockedDate` for today's date → if blocked, return `{ available: false, reason: 'Mentor is not available today' }`
- Check mentor `isAvailable` flag
- Check for `live` session (status: 'live') → `{ available: false, reason: 'Mentor is in a session right now' }`
- Check for `scheduled` session starting within next 60min → `{ available: false, reason: 'Mentor has an upcoming session soon' }`
- Check if current time falls within any `mentorAvailabilitySlot` for today's dayOfWeek (recurring) or specificDate
  - If no slot covers current time → `{ available: false, reason: 'Mentor is not available at this time' }`
- Return `{ available: true, endsAt: ` next slot boundary or end of current slot `}`

**File:** `backend-new/src/mentor-sessions/mentor-sessions.controller.ts`

Add `GET :mentorProfileId/availability-now` endpoint

## Task 2: Frontend API Functions

**File:** `frontend-new/src/lib/api.ts`

Add:
- `checkMentorAvailabilityNow(mentorProfileId): Promise<{ available: boolean; reason?: string; endsAt?: string }>`
- `bookMeetNowSession(data): Promise<{ sessionId: string }>` — calls a new `POST /api/mentor-sessions/meet-now` endpoint

## Task 3: Backend "Meet Now" Booking Endpoint

**File:** `backend-new/src/mentor-sessions/mentor-sessions.service.ts`

Add `bookMeetNow(studentUserId, body)` method:
- Same validation as `bookSession()` but WITHOUT date/time fields
- Set `scheduledFrom = now()`, `scheduledTo = now() + 60min`
- Set `type: 'meet_now'`, `status: 'pending'` (goes to Requests tab, NOT directly to scheduled)
- Same wallet check (full session cost), 10% advance deduction
- Same audit log
- Send email: "Your instant session request has been sent to {mentor}. They'll respond shortly."

**File:** `backend-new/src/mentor-sessions/mentor-sessions.controller.ts`

Add `POST meet-now` endpoint

## Task 4: Modify approveSession for meet_now

**File:** `backend-new/src/mentor-sessions/mentor-sessions.service.ts`

Modify `approveSession()`:
- When `session.type === 'meet_now'`: set `status: 'live'`, `startedAt: now`, `scheduledFrom: now`, `scheduledTo: now + durationMinutes`
- When `session.type === 'slot_booking'`: keep existing behavior (`status: 'scheduled'`)
- Send email to student: "Your instant session with {mentor} is now live!" with relevant details
- Record status history: `pending → live`

## Task 5: Frontend "Meet Now" Button + Modal

**File:** `frontend-new/src/app/(console)/mentor/[id]/page.tsx`

In the right sidebar card:
- Add a "Meet Now" button above/below "Schedule Session"
- On mount, call `checkMentorAvailabilityNow()` 
- If unavailable: button is grayed out, tooltip/caption shows the reason (e.g., "Mentor is in a session right now")
- If available: active gold button, on click opens `MeetNowModal`

**New file:** `frontend-new/src/components/mentor/meet-now-modal.tsx`

Simplified 2-step modal:
- Step 1: "Select session type" (same session type cards)
- Step 2: "Tell us what you need" — Subject + Description + Attachment (same as step 3 in BookSessionModal)
- Left panel: mentor name, price, "Instant Session" label, advance amount
- On confirm: call `bookMeetNowSession()`, show success state
- Modal title: "Request Instant Session"

## Task 6: Handle Rejection (Refund)

When mentor rejects a `meet_now` request, the advance should be refunded. Modify `rejectSession()`:
- If `session.type === 'meet_now'` and `paymentStatus === 'advance_paid'`, reverse the wallet transaction (credit student, debit mentor)

## Task 7: Verify
- Run `npx tsc --noEmit` on both backend and frontend
- Verify the approve flow for meet_now changes status to 'live'
- Verify the getRequests still returns pending meet_now sessions
- Verify getLive returns approved meet_now sessions
