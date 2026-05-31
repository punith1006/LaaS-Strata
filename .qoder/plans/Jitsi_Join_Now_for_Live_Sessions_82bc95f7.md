# Jitsi "Join Now" for Live Sessions

## Task 1: Backend — Jitsi link endpoint for sessions

### 1a. Add `generateSessionJitsiLink()` to `MentorSessionsService`
**File**: `backend-new/src/mentor-sessions/mentor-sessions.service.ts`

Add a new method that generates a Jitsi meeting link for a specific session:
```typescript
async generateSessionJitsiLink(sessionId: string, displayName?: string) {
  const session = await this.prisma.mentorSession.findUnique({
    where: { id: sessionId },
  });
  if (!session) throw new NotFoundException('Session not found');
  if (session.status !== 'live') throw new BadRequestException('Session is not live');

  const roomName = session.jitsiRoomName;
  if (!roomName) throw new BadRequestException('Session has no Jitsi room configured');

  const now = Math.floor(Date.now() / 1000);
  const scheduledTo = session.scheduledTo;
  const remainingSeconds = scheduledTo ? Math.max(60, Math.floor((scheduledTo.getTime() - Date.now()) / 1000)) : 300;

  const payload: jwt.JwtPayload = {
    aud: 'jitsi',
    iss: process.env.JITSI_APP_ID || 'laas-platform',
    sub: 'meet.jitsi',
    room: roomName,
    exp: now + remainingSeconds,
    context: {
      user: { name: displayName || 'User', email: '', id: session.studentUserId },
    },
  };

  const token = jwt.sign(payload, process.env.JITSI_APP_SECRET || '', { algorithm: 'HS256' });
  const baseUrl = process.env.JITSI_BASE_URL || '';
  const frontendUrl = process.env.FRONTEND_URL || 'http://localhost:3000';
  const meetingUrl = `${frontendUrl}/meeting?room=${roomName}&jwt=${token}&baseUrl=${encodeURIComponent(baseUrl)}`;

  return { meetingUrl, roomName, jwt: token, expiresAt: new Date((now + remainingSeconds) * 1000).toISOString() };
}
```

You'll need to import `* as jwt from 'jsonwebtoken'` at the top of the service file (if not already there).

### 1b. Add controller endpoint
**File**: `backend-new/src/mentor-sessions/mentor-sessions.controller.ts`

```typescript
@UseGuards(JwtAuthGuard)
@Get(':id/jitsi-link')
async getSessionJitsiLink(@Param('id') id: string, @Req() req: { user: { id: string } }) {
  return this.service.generateSessionJitsiLink(id);
}
```

## Task 2: Frontend API — Add fetch function

**File**: `frontend-new/src/lib/api.ts`

```typescript
export interface JitsiLinkResult {
  meetingUrl: string;
  roomName: string;
  jwt: string;
  expiresAt: string;
}

export async function getSessionJitsiLink(sessionId: string): Promise<JitsiLinkResult | null> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/${sessionId}/jitsi-link`);
  if (!res.ok) return null;
  return res.json();
}
```

## Task 3: Frontend — Update meeting page text

**File**: `frontend-new/src/app/meeting/page.tsx`

- Change "Session Expired" → "Session Ended"
- Change back button: `router.push("/")` → `router.push("/home")`

## Task 4: Frontend — Add Join Now button to mentor LiveSessionSection

**File**: `frontend-new/src/components/home/mentor-sessions-tab-content.tsx`

In the LiveSessionSection's expanded panel identity bar, add a "Join Now" button styled like the Launch Instance button. Place it in the right column area (next to academic details or above the Account/Socials grid).

The button:
- `backgroundColor: "var(--fgColor-default)"`
- `color: "var(--bgColor-default)"`
- `border: "1px solid var(--fgColor-default)"`
- `borderRadius: "4px"`
- `padding: "0 20px"`
- `height: "36px"`
- `cursor: "pointer"`
- `fontWeight: 500`
- On hover: opacity 0.85

On click:
```typescript
const handleJoinNow = async (sessionId: string) => {
  const result = await getSessionJitsiLink(sessionId);
  if (result?.meetingUrl) window.open(result.meetingUrl, '_blank');
};
```

## Task 5: Frontend — Add Join Now button to student StudentLiveSection

**File**: `frontend-new/src/components/mentor/mentor-user-sessions-tab.tsx`

Same "Join Now" button as Task 4, placed in the expanded panel's identity bar for the student's live session view.

## Task 6: Verify
- `npx tsc --noEmit` in backend-new/
- `npx tsc --noEmit` in frontend-new/
