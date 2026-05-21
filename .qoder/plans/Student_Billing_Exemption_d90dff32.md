# Student-Role Billing Exemption and CapEx Classification

## Context

Student-role users (signup with @ksrce.in email or institutional SSO) should use the platform for free **for compute and storage resources only**, while all costs are still tracked and classified as institutional CapEx (capital expenditure by KSRCE). The auto-provisioned 10GB storage on signup should also be removed.

**Important:** Students retain full access to the credits/wallet system. They can add credits — these will be consumed by a future **mentor booking** feature. The exemption applies ONLY to compute and storage charges.

---

## Task 1: Database Schema — Add `cost_classification` to BillingCharge

**File:** `c:\Users\Punith\LaaS\backend-new\prisma\schema.prisma` (Lines ~1394-1424)

Add a new field to the `BillingCharge` model:
```prisma
costClassification  String   @default("revenue") @map("cost_classification")
```

Values: `'revenue'` (default, paying users) or `'capex'` (student/institutional users absorbed by KSRCE).

Generate and apply Prisma migration.

**Rationale:** Denormalizing classification into the charge record ensures historical accuracy even if a user's role changes later.

---

## Task 2: Backend — Comment Out Auto-Storage Provisioning

**File:** `c:\Users\Punith\LaaS\backend-new\src\auth\auth.service.ts` (Lines 306-370)

Comment out the entire storage provisioning block that runs during institutional signup. The block currently:
- Calls `this.storage.provisionUserQuota(storageUid, user.id, 10)`
- Creates a `UserStorageVolume` record
- Updates user with `storageProvisioningStatus`

Comment it out (not delete) so students can still manually provision storage later.

---

## Task 3: Backend — Create Shared `isStudentRole()` Helper

**New file or add to existing service** (recommend adding to a shared utility, e.g. `src/common/role.helper.ts`)

```typescript
export async function isStudentRole(prisma: PrismaClient, userId: string): Promise<boolean> {
  const match = await prisma.userOrgRole.findFirst({
    where: { userId, role: { name: 'student' } },
  });
  return !!match;
}
```

This helper will be used by compute, billing, and storage services.

---

## Task 4: Backend — Bypass Credit Check for Student Compute Launch

**File:** `c:\Users\Punith\LaaS\backend-new\src\compute\compute.service.ts` (Lines 380-411)

In `launchSession()`:
1. Check if user is student role
2. If student: skip wallet balance check, skip `WalletHold` creation
3. Still proceed with container launch normally
4. When creating the prepaid `BillingCharge`, set `costClassification: 'capex'`
5. Skip wallet deduction (no `WalletTransaction` debit)

---

## Task 5: Backend — Billing Service: Track Costs Without Wallet Deduction for Students

**File:** `c:\Users\Punith\LaaS\backend-new\src\billing\billing.service.ts`

In the hourly billing cron:
1. For **compute billing**: If user is student → create `BillingCharge` with `costClassification: 'capex'`, skip wallet deduction, do NOT skip due to low balance
2. For **storage billing**: Same — create charge record with `costClassification: 'capex'`, skip wallet deduction, do NOT skip due to low balance

Key principle: Student charges are ALWAYS created (never skipped for insufficient balance) but never deducted from wallet.

---

## Task 6: Backend — Filter Student Charges from Revenue Analytics

**File:** `c:\Users\Punith\LaaS\backend-new\src\dashboard\analytics-admin.service.ts` (Lines ~314-328)

Update the Revenue KPI query to exclude CapEx charges:
```typescript
where: { 
  createdAt: { gte: periodStart },
  costClassification: 'revenue'  // Exclude student/capex charges
}
```

Apply to all revenue-related aggregations (Revenue KPI, Revenue Trend chart, NRR calculations). This ensures student usage doesn't inflate platform revenue metrics.

---

## Task 7: Frontend — Bypass Compute/Storage Credit Blocks for Student-Role Users

The frontend already has `user.roles` from the `/api/auth/me` endpoint. Add a helper:
```typescript
const isStudent = user?.roles?.includes('student');
```

**Changes across 3 files (NOT app-shell.tsx):**

| File | Change |
|------|--------|
| `app/(console)/home/page.tsx` (Line 133) | Hide "No credits remaining" banner if `isStudent` (misleading — implies they can't use platform) |
| `app/(console)/instances/launch/page.tsx` (Line 386) | Bypass `hasInsufficientBalance` for students; hide "INSUFFICIENT CREDIT BALANCE" badge |
| `app/(console)/storage/page.tsx` (Line 1911) | Bypass `hasEnoughCredits` for students; hide "Insufficient credits" warning |

**What stays the same for students:**
- "CREDITS REMAINING" header display remains visible (students can have credits for mentoring)
- "Add Credits" button on billing page remains functional
- Billing tab (balance summary, burn rate, daily spend) all remain visible
- Wallet/credits system fully intact — credits will be used for future mentor booking

Students only lose the compute/storage BLOCKING warnings.

---

## Task 8: Backend — Billing API Response for Students

**File:** `c:\Users\Punith\LaaS\backend-new\src\dashboard\` (billing endpoint)

Add an `isComputeStorageExempt: boolean` field to the billing data API response. When `true`, the frontend bypasses credit balance checks for compute and storage operations only (defense-in-depth). This does NOT exempt from future mentor booking charges.

---

## Execution Order (Dependencies)

```
Task 1 (Schema) → Task 3 (Helper) → Task 4 + 5 (Backend exemptions, parallel)
                                   → Task 6 (Analytics filter)
Task 2 (Comment out storage) — independent, can run in parallel
Task 7 + 8 (Frontend + API flag) — can start after Task 3
```

---

## What This Does NOT Change

- Wallet/credits system fully intact — students can add credits (for future mentor booking)
- "CREDITS REMAINING" header display stays visible
- "Add Credits" button stays functional
- Billing tab still visible (balance summary, burn rate, daily spend for transparency)
- Recent Activity still shows billing events with full cost detail
- All cost calculations (burn rate, daily spend) still compute normally
- billing_charges records are always created — full audit trail
- Other users (public_user, external_student) are unaffected
- Future mentor booking charges WILL deduct from student wallet (not exempt)

---

## Future Features (not in this scope)

**CapEx Dashboard:** The `cost_classification = 'capex'` field enables a future admin view that mirrors the current analytics dashboard but shows only student expenditure (institutional CapEx). The same revenue chart logic can be reused with a WHERE filter on `cost_classification`.

**Mentor Booking:** A future feature where students spend their credits to book mentoring sessions. These charges deduct from wallet normally (NOT classified as capex — they are a separate revenue stream).
