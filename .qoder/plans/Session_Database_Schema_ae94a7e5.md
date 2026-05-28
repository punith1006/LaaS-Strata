# Session Database Schema for Prisma

## Key Design Decisions

1. **Name prefix `Mentor`**: The existing schema already has `Session` (compute/GPU sessions at line 1003), `SessionStatus` enum (line 27), and `SessionType` enum (line 39). All new mentoring session types use the `Mentor` prefix to avoid conflicts: `MentorSession`, `MentorSessionStatus`, `MentorSessionType`, etc.

2. **Mentor linked via MentorProfile**: The mentor is linked through `MentorProfile.id` (not directly to `User.id`), consistent with how `MentorBooking` and `MentorAvailabilitySlot` already work.

3. **Student linked via User.id**: The student is linked directly to `User` with relation name `"MentorSessionStudent"`, consistent with `MentorBooking`'s `"MentorBookingStudent"` pattern.

4. **Reschedule chain**: `MentorSession.rescheduledToId` is a self-referential optional FK to track reschedule chains (old session points to new session).

5. **Existing `MentorBooking` kept as-is**: Not modified or deleted. The new `MentorSession` model replaces its functionality going forward.

---

## Task 1 -- Add new enums (insert after existing enums, around line 145)

File: `backend-new/prisma/schema.prisma`

```prisma
enum MentorSessionStatus {
  pending
  scheduled
  live
  completed
  cancelled
  rejected
  request_expired
  rescheduled
  missed
  disputed
}

enum MentorSessionType {
  meet_now
  slot_booking
}

enum MentorPaymentStatus {
  unpaid
  advance_paid
  fully_paid
}

enum MentorPaymentType {
  advance
  balance
  full
}

enum MentorPaymentRecordStatus {
  held
  released
  refunded
}
```

---

## Task 2 -- Add `MentorSession` model (in Domain 10, after `MentorReview`)

File: `backend-new/prisma/schema.prisma` (insert after line ~1782)

```prisma
// AUDIT: Records must NEVER be deleted — required for mentoring session audit trail
model MentorSession {
  id               String                @id @default(uuid()) @db.Uuid
  type             MentorSessionType
  status           MentorSessionStatus
  paymentStatus    MentorPaymentStatus   @default(unpaid) @map("payment_status")

  mentorProfileId  String                @map("mentor_profile_id") @db.Uuid
  studentUserId    String                @map("student_user_id") @db.Uuid

  // Timing
  requestedAt      DateTime              @default(now()) @map("requested_at")
  approvedAt       DateTime?             @map("approved_at")
  scheduledFrom    DateTime?             @map("scheduled_from")
  scheduledTo      DateTime?             @map("scheduled_to")
  startedAt        DateTime?             @map("started_at")
  endedAt          DateTime?             @map("ended_at")
  expiresAt        DateTime?             @map("expires_at")

  // Session config
  durationMinutes  Int                   @map("duration_minutes")
  domain           String                @db.VarChar(255)
  serviceType      String                @map("service_type") @db.VarChar(255)

  // Jitsi
  jitsiRoomName    String                @unique @map("jitsi_room_name") @db.VarChar(255)
  jwtToken         String?               @map("jwt_token")
  jwtExpiresAt     DateTime?             @map("jwt_expires_at")

  // Financials
  earningsCents    Int                   @default(0) @map("earnings_cents")
  advanceCents     Int?                  @map("advance_cents")
  balanceCents     Int?                  @map("balance_cents")

  // Reschedule chain (old session -> new session)
  rescheduledToId  String?               @unique @map("rescheduled_to_id") @db.Uuid

  // Notes and reason
  studentNotes     String?               @map("student_notes")
  mentorNotes      String?               @map("mentor_notes")
  cancelReason     String?               @map("cancel_reason")

  // Audit
  createdAt        DateTime              @default(now()) @map("created_at")
  updatedAt        DateTime              @updatedAt @map("updated_at")
  createdBy        String?               @map("created_by") @db.Uuid
  updatedBy        String?               @map("updated_by") @db.Uuid

  // Relations
  mentorProfile    MentorProfile                  @relation(fields: [mentorProfileId], references: [id], onDelete: Restrict)
  student          User                           @relation("MentorSessionStudent", fields: [studentUserId], references: [id], onDelete: Restrict)
  statusHistory    MentorSessionStatusHistory[]
  payments         MentorSessionPayment[]
  rescheduledTo    MentorSession?                 @relation("MentorSessionReschedule", fields: [rescheduledToId], references: [id], onDelete: Restrict)

  @@index([mentorProfileId, status])
  @@index([studentUserId, status])
  @@index([status])
  @@index([requestedAt])
  @@index([scheduledFrom])
  @@index([expiresAt])
  @@map("mentor_sessions")
}
```

---

## Task 3 -- Add `MentorSessionStatusHistory` model (after MentorSession)

```prisma
// AUDIT: Records must NEVER be deleted — required for state transition audit trail
model MentorSessionStatusHistory {
  id              String              @id @default(uuid()) @db.Uuid
  mentorSessionId String              @map("mentor_session_id") @db.Uuid
  fromStatus      MentorSessionStatus @map("from_status")
  toStatus        MentorSessionStatus @map("to_status")
  changedBy       String              @map("changed_by") @db.VarChar(32)
  reason          String?
  timestamp       DateTime            @default(now())

  // Relations
  mentorSession   MentorSession       @relation(fields: [mentorSessionId], references: [id], onDelete: Restrict)

  @@index([mentorSessionId])
  @@index([timestamp])
  @@map("mentor_session_status_history")
}
```

---

## Task 4 -- Add `MentorSessionPayment` model (after MentorSessionStatusHistory)

```prisma
// AUDIT: Records must NEVER be deleted — required for financial audit trail
model MentorSessionPayment {
  id                  String                    @id @default(uuid()) @db.Uuid
  mentorSessionId     String                    @map("mentor_session_id") @db.Uuid
  amountCents         Int                       @map("amount_cents")
  paymentType         MentorPaymentType         @map("payment_type")
  payerUserId         String                    @map("payer_user_id") @db.Uuid
  payeeUserId         String                    @map("payee_user_id") @db.Uuid
  status              MentorPaymentRecordStatus
  walletTransactionId String?                   @map("wallet_transaction_id") @db.Uuid
  releasedAt          DateTime?                 @map("released_at")
  refundedAt          DateTime?                 @map("refunded_at")
  createdAt           DateTime                  @default(now()) @map("created_at")

  // Relations
  mentorSession       MentorSession             @relation(fields: [mentorSessionId], references: [id], onDelete: Restrict)
  payer               User                      @relation("MentorSessionPaymentPayer", fields: [payerUserId], references: [id], onDelete: Restrict)
  payee               User                      @relation("MentorSessionPaymentPayee", fields: [payeeUserId], references: [id], onDelete: Restrict)
  walletTransaction   WalletTransaction?        @relation(fields: [walletTransactionId], references: [id], onDelete: Restrict)

  @@index([mentorSessionId])
  @@index([payerUserId])
  @@index([payeeUserId])
  @@index([status])
  @@map("mentor_session_payments")
}
```

---

## Task 5 -- Add back-relation arrays to existing models

### User model (line ~233, in Domain 10 relations block)
Add three new relation arrays:
```prisma
  mentorSessionsAsStudent    MentorSession[]          @relation("MentorSessionStudent")
  mentorSessionPaymentsPaid  MentorSessionPayment[]   @relation("MentorSessionPaymentPayer")
  mentorSessionPaymentsReceived MentorSessionPayment[] @relation("MentorSessionPaymentPayee")
```

### MentorProfile model (line ~1715, in relations block)
Add one new relation array:
```prisma
  mentorSessions             MentorSession[]
```

### WalletTransaction model (line ~1232, in relations block)
Add one new relation array:
```prisma
  mentorSessionPayments      MentorSessionPayment[]
```

---

## Task 6 -- Run Prisma migration

After schema changes:
```bash
npx prisma migrate dev --name add_mentor_session_tables
```
