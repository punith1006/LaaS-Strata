# Session Module Comprehensive Specification

## Task 1 -- Create `ReadMe/Session-Module-Specification.md`

A single comprehensive spec document covering:

### Section 1: Session Types and State Machine
- **MEET_NOW** flow: `PENDING` -> `SCHEDULED` -> `LIVE` -> `COMPLETED` (plus `REJECTED`, `REQUEST_EXPIRED`, `CANCELLED`, `MISSED`)
- **SLOT_BOOKING** flow: `SCHEDULED` -> `LIVE` -> `COMPLETED` (plus `CANCELLED`, `RESCHEDULED`, `MISSED`)
- ASCII state diagrams for both flows
- Status definitions table with: status name, description, which flow it belongs to, which UI tab it appears in

### Section 2: Payment Flow and Escrow Model
- **Meet Now payment**: After mentor approval, student pays session amount. "Join Now" unlocks only after payment complete. Advance held in platform escrow (transient wallet state). Full payment credited to mentor wallet only after session `COMPLETED`.
- **Slot Booking payment**: Student pays advance at booking time. Remaining balance due before "Join Now" unlocks (shows "Payment Pending" label until paid).
- **Escrow semantics**: Platform wallet holds advance payments. Release to mentor only on `COMPLETED`.

### Section 3: Cancellation and Refund Rules
- **Student cancels (after paying advance)**: Advance is non-refundable (T&C)
- **Mentor cancels**: Full refund from mentor's wallet to student
  - If mentor wallet insufficient: system raises `DISPUTED` status, notifies admins
- **Student pays FULL + mentor cancels**: Amount is non-refundable (per SLA)
- **Slot Booking cancel/reschedule**: Same refund logic applies

### Section 4: Verification Steps Before "Join Now"
- Payment status = fully paid (advance + balance for slot bookings)
- Session is within allowed time window (slot bookings: scheduled_from to scheduled_end + 10 min grace)
- Mentor does not already have an active `LIVE` session
- Camera/mic permissions (browser-level check)

### Section 5: JWT-Based Session Termination
- JWT `exp` claim = `scheduled_end + 10 min` (platform-wide constant grace period)
- For Meet Now: JWT `exp` = session start time + mentor-configured duration + 10 min
- When JWT expires: Prosody disconnects participants, session auto-transitions to `COMPLETED`
- Room is unique per session (e.g., `session-{sessionId}`)

### Section 6: Database Schema and Audit Trail
- `Session` table fields: id, type (MEET_NOW/SLOT_BOOKING), status, mentor_id, user_id, requested_at, approved_at, scheduled_from, scheduled_to, started_at, ended_at, duration_minutes, jitsi_room_name, jwt_token, payment_status (unpaid/advance_paid/fully_paid), earnings_cents, domain, service_type
- `SessionStatusHistory` table: id, session_id, from_status, to_status, changed_by (user/mentor/system), reason, timestamp
- `SessionPayment` table: id, session_id, amount_cents, payment_type (advance/balance/full), payer_id, payee_id, status (held/released/refunded), timestamp
- All state transitions logged with timestamp, actor, and reason for full audit compliance

### Section 7: UI Tab Visibility Rules
- Requests tab: `PENDING`
- Upcoming tab: `SCHEDULED` (with "Payment Pending" label if not fully paid, "Join Now" when ready)
- Live Sessions section: `LIVE`
- Past tab: `REJECTED`, `REQUEST_EXPIRED`, `COMPLETED`, `CANCELLED`, `RESCHEDULED`, `MISSED`
- Earnings display: only for `COMPLETED` status in Past tab; `--` for all others

### Section 8: Constraints and Business Rules
- One `LIVE` session per mentor at any given time
- Meet Now requests have 15-min TTL (configurable platform-wide)
- JWT grace period: 10 minutes past session end (platform-wide constant)
- Meet Now duration: set by mentor in profile (30/60/90 min)
- Slot Booking time window enforcement: session can only start between scheduled_from and scheduled_end

## Task 2 -- Update existing `ReadMe/Mentoring-Module-README.md` Section 8
Update the state machine diagram in the Living Design Document (line 327+) to reflect the refined two-flow state machine with payment-aware transitions.

## Task 3 -- Update memory with finalized session module spec
Store the key decisions (payment escrow model, cancellation rules, verification steps) as project introduction memories for future reference.
