# Add Session Overlap Warning on Approve

## Changes

### 1. Backend: New `checkSessionOverlap()` method in `mentor-sessions.service.ts`
For a given pending sessionId, compute the proposed time window (now to now+session.durationMinutes), then check if the mentor has any SCHEDULED sessions that overlap with this window. Return the overlapping session details if found.

```typescript
async checkSessionOverlap(sessionId: string): Promise<{ hasOverlap: boolean; overlappingSession?: { id: string; scheduledFrom: string; scheduledTo: string; durationMinutes: number } }>
```

### 2. Backend: New controller endpoint
Add `GET :id/check-overlap` in the controller that calls `checkSessionOverlap`.

### 3. Frontend API: Add `checkSessionOverlap()` in `api.ts`
```typescript
export async function checkMentorSessionOverlap(sessionId: string): Promise<...>
```

### 4. Frontend: Modify `handleApprove` in `mentor-sessions-tab-content.tsx`
- Before calling `approveMentorSession`, call `checkMentorSessionOverlap`
- If `hasOverlap` is true, show a confirmation modal (styled like sign-out modal) with the overlapping session info
- If Proceed, then call `approveMentorSession`
- If Back, close the modal

### 5. Frontend: Build the overlap warning modal inline
Match the sign-out modal style:
- Fixed overlay: `rgba(11, 11, 11, 0.15)`
- Container: max-width 420px, bgColor-default, border-default
- Header "Heads Up" with bottom border
- Body text with overlap info (session start time, duration)
- Two buttons: "Back" (outlined) and "Proceed" (filled dark)
