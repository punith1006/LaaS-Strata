# Mentor-Specific Support Categories

## Changes in support-modal.tsx

**File**: `frontend-new/src/components/support/support-modal.tsx`

### 1a. Add `roles` to `UserData` interface (line 9-14)
Add `roles?: string[]` to the `UserData` interface so role detection is possible.

### 1b. Add `MENTOR_ISSUE_CATEGORIES` array
After the existing `ISSUE_CATEGORIES` array (line 21-27), add:
```typescript
const MENTOR_ISSUE_CATEGORIES = [
  { value: "session_not_starting", label: "Session not starting or technical issue" },
  { value: "student_not_responding", label: "Student not responding or no-show" },
  { value: "revenue_not_reflected", label: "Revenue not reflected in wallet" },
  { value: "withdrawal_issue", label: "Withdrawal or payout issue" },
  { value: "availability_slot_issue", label: "Availability slot or scheduling issue" },
  { value: "platform_fee_query", label: "Platform fee or billing query" },
  { value: "profile_account_issue", label: "Profile or account issue" },
  { value: "general_inquiry", label: "General inquiry" },
];
```

### 1c. Add `useMemo` to compute categories based on role
Add after the `user` state declaration and fetch effect:
```typescript
const categories = useMemo(() => {
  if (user?.roles?.includes("mentor")) return MENTOR_ISSUE_CATEGORIES;
  return ISSUE_CATEGORIES;
}, [user]);
```

### 1d. Swap the Dropdown options
Change line 277 from `options={ISSUE_CATEGORIES}` to `options={categories}`.

## Verification
- `npx tsc --noEmit` in frontend-new/ (only pre-existing errors expected)
