# Book Session Flow

## Task 1: Schema Changes

**File**: `backend-new/prisma/schema.prisma`

### 1a. Add session category to MentorSession

Add a new enum and field to `MentorSession`:

```prisma
enum MentorSessionCategory {
  consultation
  guidance
  doubt_clarification
  hands_on
}
```

Add to `MentorSession` model:
```prisma
category MentorSessionCategory @default(consultation)
```

### 1b. Add attachment fields to MentorSession

Add directly to the `MentorSession` model (one file only, simple for MVP):
```prisma
attachmentFileName     String?  @map("attachment_file_name") @db.VarChar(255)
attachmentFilePath     String?  @map("attachment_file_path") @db.VarChar(512)
attachmentMimeType     String?  @map("attachment_mime_type") @db.VarChar(100)
attachmentSizeBytes    Int?     @map("attachment_size_bytes")
```

### 1c. Run migration

```
npx prisma db push
```

---

## Task 2: Backend -- Slot Availability API

**File**: `backend-new/src/mentor-sessions/mentor-sessions.service.ts` and `.controller.ts`

### New endpoint: `GET /api/mentor-sessions/available-slots/:mentorProfileId?date=YYYY-MM-DD`

Logic:
1. Fetch the mentor's `MentorAvailabilitySlot` records for the given date:
   - Match `dayOfWeek` (if recurring) OR `specificDate` (if date-specific)
   - Date-specific slots override recurring slots for that date
2. Fetch `MentorBlockedDate` for the given date -- if blocked, return empty
3. Fetch existing `MentorSession` records for that mentor on that date with status in (`scheduled`, `live`) to identify booked slots
4. For each availability slot range (e.g., 09:00-12:00):
   - Divide into 60-minute chunks: 09:00, 10:00, 11:00
   - Filter out any chunk whose start time overlaps with a booked session's `scheduledFrom`
   - Filter out any chunk that starts before `now + 30 minutes` (only for today's date)
5. Return `{ date, slots: [{ startTime: "09:00", endTime: "10:00" }, ...] }`

Controller: add `GET available-slots/:mentorProfileId` with `@Query('date')`.

---

## Task 3: Backend -- File Upload Endpoint

**File**: `backend-new/src/mentor-sessions/mentor-sessions.controller.ts` and `.service.ts`

### New endpoint: `POST /api/mentor-sessions/upload-attachment`

Logic:
1. Accept multipart form-data with a single file field
2. Validate file: max 2MB, allowed types: `.pdf`, `.docx`, `.txt`, `.png`, `.jpg`, `.jpeg`, `.gif`, `.webp`
3. Generate a unique filename: `{uuid}-{originalName}`
4. Save to `uploads/mentor-sessions/` directory (create if not exists)
5. Return `{ fileName, filePath, mimeType, sizeBytes }`

Use Fastify's multipart parsing (same pattern as `extract-document` in compute controller).

---

## Task 4: Backend -- Book Session Endpoint

**File**: `backend-new/src/mentor-sessions/mentor-sessions.service.ts` and `.controller.ts`

### New endpoint: `POST /api/mentor-sessions/book`

Request body:
```ts
{
  mentorProfileId: string,
  category: 'consultation' | 'guidance' | 'doubt_clarification',
  scheduledDate: string,   // YYYY-MM-DD
  startTime: string,       // "HH:MM"
  durationMinutes: number, // 60
  subject: string,         // max 10 words
  description: string,     // min 10 words
  attachmentFileName?: string,
  attachmentFilePath?: string,
  attachmentMimeType?: string,
  attachmentSizeBytes?: number,
}
```

Logic (in a Prisma `$transaction`):
1. Validate the mentor exists and `isAvailable`
2. Validate `subject` word count <= 10
3. Validate `description` word count >= 10
4. Compute `scheduledFrom` and `scheduledTo` from date + startTime + durationMinutes
5. Verify the slot is still available (re-check no conflicting `scheduled`/`live` sessions)
6. Verify the slot is within the mentor's availability (check `MentorAvailabilitySlot`)
7. Get session cost = `mentor.pricePerHourCents` (1 hour)
8. Get advance amount = 10% of session cost
9. Check student wallet balance >= session cost (full amount, not just advance)
10. Debit `advanceCents` from student wallet:
    - Create `WalletTransaction` (debit, type: "mentor_session_advance")
    - Update wallet balance
11. Create `MentorSession` record:
    - `type: slot_booking`
    - `status: scheduled`
    - `paymentStatus: advance_paid`
    - `scheduledFrom`, `scheduledTo`
    - `earningsCents: sessionCost`
    - `advanceCents`, `balanceCents: 90%`
    - `category`, `domain: "Mentoring"`, `serviceType: category label`
    - `studentNotes: description`
    - `jitsiRoomName: "session-{id}"`
    - Attachment fields if provided
12. Create `MentorSessionStatusHistory` entry: `null -> scheduled`
13. Create `MentorSessionPayment` record: `type: advance, status: held`
14. Credit `advanceCents` to mentor's wallet (minus platform fee if applicable -- for now, no platform fee on advance)
15. Return the created session ID

---

## Task 5: Backend -- Student Session Query

**File**: `backend-new/src/mentor-sessions/mentor-sessions.service.ts` and `.controller.ts`

### New endpoint: `GET /api/mentor-sessions/student-upcoming`

Returns the student's sessions with `status: scheduled`, ordered by `scheduledFrom ASC`.

Include mentor profile details (name, headline, company) in the response.

This will be used for the user-side "Upcoming" tab later.

---

## Task 6: Frontend API Functions

**File**: `frontend-new/src/lib/api.ts`

Add:
```ts
// Get available slots for a mentor on a date
export async function getAvailableSlots(mentorProfileId: string, date: string): Promise<{ date: string; slots: { startTime: string; endTime: string }[] }>

// Upload attachment file
export async function uploadMentorAttachment(file: File): Promise<{ fileName: string; filePath: string; mimeType: string; sizeBytes: number }>

// Book a session
export async function bookMentorSession(data: BookSessionRequest): Promise<{ sessionId: string }>

// Student's upcoming sessions
export async function getStudentUpcomingSessions(): Promise<StudentUpcomingSession[]>
```

---

## Task 7: Frontend -- Booking Modal Component

**File**: `frontend-new/src/components/mentor/book-session-modal.tsx`

### Structure

A modal overlay with `backdrop-filter: blur(8px)` background. Three steps:

**Step 1 -- Session Type + Date**
- Left panel: Mentor name, title, price
- Session type cards (radio selection):
  - Consultation: "Career advice, professional guidance, and industry insights"
  - Guidance: "Project guidance, technical mentorship, and skill development"
  - Doubt Clarification: "Clear specific doubts, concepts, and problem-solving"
  - Hands-On: "Coming Soon" (disabled, grayed out)
- Calendar component showing the selected month
  - Only dates with available slots are highlighted (call slot availability API for each visible date -- or better: user picks a date, then we fetch slots)
  - Today + past dates are disabled
  - Blocked dates are disabled
- Continue button (disabled until type + date selected)

**Step 2 -- Time Slot**
- Left panel: Selected date, session type, price
- Time slot grid: available 1-hour slots as clickable cards
  - Each shows: "09:00 AM - 10:00 AM"
  - Past slots (today, before now + 30min) are hidden
  - Already booked slots are hidden (handled by backend API)
- Continue button (disabled until slot selected)

**Step 3 -- Details + Confirm**
- Left panel: Summary (date, time, session type, price breakdown showing full price + advance deduction)
- Input fields:
  - Subject (text input, max 10 words with word counter)
  - Description (textarea, min 10 words with word counter)
  - File upload (drag-and-drop zone, max 2MB, supported formats listed)
- "Confirm Booking" button:
  - Check wallet balance >= full session cost
  - Show confirmation: "Advance: X (10%) will be deducted from your wallet"
  - On click: upload file (if attached), then call bookMentorSession API
  - Show loading state
  - On success: show success state, close modal after 2s
  - On failure: show error, allow retry

### Calendar Component
- Simple month-view calendar using Day.js
- Navigate months with arrow buttons
- Highlight dates that have available slots
- Disable past dates and today

### Session Type Descriptions (hardcoded)
```ts
const SESSION_TYPES = [
  { id: 'consultation', label: 'Consultation', description: 'Career advice, professional guidance, and industry insights from an experienced mentor.' },
  { id: 'guidance', label: 'Guidance', description: 'Project guidance, technical mentorship, and hands-on skill development.' },
  { id: 'doubt_clarification', label: 'Doubt Clarification', description: 'Clear specific doubts, concepts, and problem-solving with expert help.' },
  { id: 'hands_on', label: 'Hands-On', description: 'Coming Soon', disabled: true },
];
```

---

## Task 8: Frontend -- Wire Modal into Profile Page

**File**: `frontend-new/src/app/(console)/mentor/[id]/page.tsx`

- Change "Book Now" button text to "Schedule Session"
- On click: open `<BookSessionModal mentor={profile} onClose={...} />`
- Modal uses backdrop blur

---

## Task 9: Verify with tsc --noEmit

Run type check on both frontend and backend after all changes.
