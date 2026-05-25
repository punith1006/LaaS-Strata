# User Accordion Profile Section

## Research Summary

### Data already visible in the row (do NOT repeat)
NAME, EMAIL, CLIENT, PROFESSION, TIMEZONE, JOIN DATE, STATUS (Active/Inactive dot)

### Data available but NOT in the row — good candidates for the profile panel
| Field | Source | Importance |
|-------|--------|------------|
| Auth Type (SSO/email) | User.authType | Identity trust |
| Email Verified | User.emailVerifiedAt | Trust signal |
| Phone | User.phone | Contact method |
| Display Name | User.displayName | If different from row name |
| Roles | UserOrgRole[] | What user can do |
| College | UserProfile.collegeName | For students |
| Department | UserProfile.department | For students |
| Course + Year | UserProfile.courseName, academicYear | For students |
| GitHub/LinkedIn/Website | UserProfile.*Url | Links |
| Skills | UserProfile.skills[] | Skills tags |
| Domains/Use Cases | UserProfile.operationalDomains, useCasePurposes | Onboarding data |
| Expertise Level | UserProfile.expertiseLevel | Proficiency |
| Storage quota/status | User.storageProvisioningStatus, storageQuotaGb | Resource allocation |
| Session active? | RefreshToken (non-expired, non-revoked) | Live indicator |
| Last Login | User.lastLoginAt | Engagement |
| Running compute sessions | Session.status='running' | Activity |

### Live indicator precedent
From `analytics-dashboard.tsx` Fleet Health card:
```tsx
<span className={`w-2 h-2 rounded-full flex-shrink-0 ${
  fleetHealthStatus === 'live'
    ? 'bg-emerald-400 animate-pulse'
    : 'bg-zinc-500'
}`} />
```
Pattern: `bg-emerald-400 animate-pulse` for live, `bg-zinc-500` for stale.

---

## Task 1: Backend — New user detail endpoint

### File: `backend-new/src/dashboard/analytics-admin.service.ts`

**Add new interface** (after `AnalyticsUserRow`, ~line 138):

```typescript
export interface UserDetailResponse {
  // Identity
  displayName: string | null;
  phone: string | null;
  authType: string;
  emailVerified: boolean;
  roles: string[];

  // Academic (only populated for students)
  collegeName: string | null;
  departmentName: string | null;
  courseName: string | null;
  academicYear: number | null;
  operationalDomains: string[];
  useCasePurposes: string[];
  expertiseLevel: string | null;

  // Links & Skills
  githubUrl: string | null;
  linkedinUrl: string | null;
  websiteUrl: string | null;
  skills: string[];

  // Session / Activity
  hasActiveSession: boolean;
  lastLoginAt: string | null;
  runningComputeSessions: number;

  // Storage
  storageProvisioningStatus: string | null;
}
```

**Add new method** `getUserDetail(userId: string)`:

```typescript
async getUserDetail(userId: string): Promise<UserDetailResponse> {
  // 1. Fetch user + profile + roles + running sessions
  const user = await this.prisma.user.findUnique({
    where: { id: userId },
    include: {
      profile: true,
      userOrgRoles: { include: { role: { select: { name: true } } } },
      sessions: { where: { status: 'running' }, select: { id: true } },
    },
  });

  // 2. Check valid refresh token (active logged-in session)
  const validToken = await this.prisma.refreshToken.findFirst({
    where: {
      userId,
      revokedAt: null,
      expiresAt: { gt: new Date() },
    },
    select: { id: true },
  });

  // 3. Get department name from UserDepartment relation
  const userDept = await this.prisma.userDepartment.findFirst({
    where: { userId },
    include: { department: { select: { name: true } } },
  });

  return {
    displayName: user?.displayName ?? null,
    phone: user?.phone ?? null,
    authType: user?.authType ?? 'email',
    emailVerified: !!user?.emailVerifiedAt,
    roles: user?.userOrgRoles?.map(r => r.role.name) ?? [],
    collegeName: user?.profile?.collegeName ?? null,
    departmentName: userDept?.department?.name ?? null,
    courseName: user?.profile?.courseName ?? null,
    academicYear: user?.profile?.academicYear ?? null,
    operationalDomains: user?.profile?.operationalDomains ?? [],
    useCasePurposes: user?.profile?.useCasePurposes ?? [],
    expertiseLevel: user?.profile?.expertiseLevel ?? null,
    githubUrl: user?.profile?.githubUrl ?? null,
    linkedinUrl: user?.profile?.linkedinUrl ?? null,
    websiteUrl: user?.profile?.websiteUrl ?? null,
    skills: user?.profile?.skills ?? [],
    hasActiveSession: !!validToken,
    lastLoginAt: user?.lastLoginAt?.toISOString() ?? null,
    runningComputeSessions: user?.sessions?.length ?? 0,
    storageProvisioningStatus: user?.storageProvisioningStatus ?? null,
  };
}
```

### File: `backend-new/src/dashboard/dashboard.controller.ts`

**Add new route** (after `getAnalyticsUsers`, ~line 174):

```typescript
@UseGuards(JwtAuthGuard)
@Get('analytics/users/:userId/detail')
async getUserDetail(@Param('userId') userId: string) {
  return this.analyticsAdminService.getUserDetail(userId);
}
```

---

## Task 2: Frontend — Fetch detail data on accordion expand

### File: `frontend-new/src/components/analytics/users-section.tsx`

**Add state** for user detail data (~line 320):

```typescript
const [userDetail, setUserDetail] = useState<UserDetail | null>(null);
const [detailLoading, setDetailLoading] = useState(false);
```

**Add `UserDetail` interface** (~line 30):

```typescript
interface UserDetail {
  displayName: string | null;
  phone: string | null;
  authType: string;
  emailVerified: boolean;
  roles: string[];
  collegeName: string | null;
  departmentName: string | null;
  courseName: string | null;
  academicYear: number | null;
  operationalDomains: string[];
  useCasePurposes: string[];
  expertiseLevel: string | null;
  githubUrl: string | null;
  linkedinUrl: string | null;
  websiteUrl: string | null;
  skills: string[];
  hasActiveSession: boolean;
  lastLoginAt: string | null;
  runningComputeSessions: number;
  storageProvisioningStatus: string | null;
}
```

**Fetch detail when accordion expands** — update `handleRowClick` or add a `useEffect` that fetches when `expandedUserId` changes:

```typescript
useEffect(() => {
  if (!expandedUserId) {
    setUserDetail(null);
    return;
  }
  const token = getAnalyticsAccessToken();
  if (!token) return;
  let cancelled = false;

  const fetch = async () => {
    setDetailLoading(true);
    try {
      const res = await fetch(
        `${API_BASE}/api/dashboard/analytics/users/${expandedUserId}/detail`,
        { headers: { Authorization: `Bearer ${token}` } }
      );
      if (!res.ok) return;
      const data: UserDetail = await res.json();
      if (!cancelled) setUserDetail(data);
    } catch { /* swallow */ }
    finally { if (!cancelled) setDetailLoading(false); }
  };
  fetch();
  return () => { cancelled = true; };
}, [expandedUserId]);
```

---

## Task 3: Frontend — Build profile section UI (replaces "Details coming soon")

### File: `frontend-new/src/components/analytics/users-section.tsx`

Replace the placeholder content inside the expanded panel div (~lines 1002-1020) with:

### Layout: Top identity bar + 2-column info grid

**Top bar** (full width):
```
[Avatar circle with initial]  Full Name          [SSO] badge
                              user@email.com      [Verified] badge
                              [LIVE DOT] Active Now · Last login 2 hours ago
```

**Info grid** (2 columns):

Left column:
- Card: "Account" — Auth Type, Email Verified, Phone, Roles (pills)
- Card: "Academic" — College, Department, Course, Year, Domains (pills), Use Cases (pills) *(only if student)*

Right column:
- Card: "Links & Skills" — GitHub, LinkedIn, Website, Skills (pills)
- Card: "Activity" — Live session (blinking dot), Running compute sessions count, Storage status

### Styling
- Cards with subtle border + rounded corners, matching dark theme
- Label-value pairs with consistent typography
- Pill/badge components for tags (roles, domains, skills)
- Blinking green dot: inline SVG circle + CSS `animate-pulse` class
- Section headers in uppercase muted text
- Overall padding matching the panel (`24px`)

---

## What is explicitly NOT done in this plan
- Compute resources section (future task)
- Billing info section (future task)
- Activity heatmap (future task)
- Department tab content (still disabled)
- Kebab menu actions (still no-ops)
