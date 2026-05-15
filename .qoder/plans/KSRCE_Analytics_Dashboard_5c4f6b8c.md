# KSRCE Analytics Dashboard — Full Implementation Plan

## Architecture Overview

Two-role analytics portal with shared layout, role-gated views, and dedicated backend analytics API module.

```
/analytics              → Sign-in (already built)
/analytics/dashboard    → Role-router (redirect to role-specific view)
/analytics/overview     → Business Lead: Revenue, Growth, Platform KPIs
/analytics/sessions     → Both: Session metrics (business sees cost, IT sees infra)
/analytics/nodes        → IT Admin: Node health, resource allocation
/analytics/users        → Business Lead: User growth, onboarding, retention
/analytics/billing      → Business Lead: Revenue breakdown, invoices, trends
/analytics/support      → Both: Ticket volume, resolution, satisfaction
```

---

## Task 1: Backend — Analytics Module (New NestJS Module)

**Create:** `backend-new/src/analytics/`
- `analytics.module.ts` — Module registration
- `analytics.service.ts` — Core query logic
- `analytics.controller.ts` — REST endpoints with role guard

**Endpoints:**

| Endpoint | Method | Roles | Returns |
|----------|--------|-------|---------|
| `/api/analytics/overview` | GET | business_lead, it_admin | KPI summary (users, sessions, revenue, nodes) |
| `/api/analytics/sessions` | GET | both | Session stats (count, avg duration, active, by config, termination reasons) |
| `/api/analytics/sessions/trend` | GET | both | Daily/weekly session count + cost over time (query param: `range=7d|30d|90d`) |
| `/api/analytics/revenue` | GET | business_lead | Revenue totals, daily trend, charge type split, top configs by revenue |
| `/api/analytics/users` | GET | business_lead | Total users, new this period, onboarding rate, auth type distribution |
| `/api/analytics/nodes` | GET | it_admin | Per-node status, resource utilization %, session counts, last heartbeat |
| `/api/analytics/storage` | GET | both | Total allocated vs used, per-user top consumers, growth trend |
| `/api/analytics/support` | GET | both | Open tickets, avg resolution time, category breakdown, satisfaction score |

**Role Guard:** Create `AnalyticsRoleGuard` that checks the requesting user has `business_lead`, `it_admin`, `super_admin`, or `org_admin` role via `authService.getUserRoles()`. Individual endpoints can further restrict (e.g., `/revenue` only for business_lead).

**Service Query Patterns:**
```typescript
// Example: overview KPIs
async getOverview(orgId: string, range: string) {
  const [totalUsers, activeSessions, totalRevenue, nodeHealth] = await Promise.all([
    this.prisma.user.count({ where: { isActive: true, deletedAt: null } }),
    this.prisma.session.count({ where: { status: 'running' } }),
    this.prisma.billingCharge.aggregate({ _sum: { amountCents: true }, where: { createdAt: { gte: rangeStart } } }),
    this.prisma.node.findMany({ select: { hostname: true, status: true, allocatedVcpu: true, totalVcpu: true } }),
  ]);
}
```

**Key Schema Tables Used:**
- `Session` — count, duration, status, cumulativeCostCents, computeConfigId, terminationReason
- `BillingCharge` — amountCents, chargeType, rateCentsPerHour, durationSeconds, createdAt
- `Node` — status, totalVcpu/Memory/Gpu, allocated*, lastHeartbeatAt, currentSessionCount
- `User` — createdAt, lastLoginAt, isActive, authType
- `UserStorageVolume` — quotaBytes, usedBytes, status
- `SupportTicket` — status, priority, category, createdAt, resolvedAt
- `WalletTransaction` — amountCents, txnType, createdAt

---

## Task 2: Backend — Register Analytics Module

**File:** `backend-new/src/app.module.ts`
- Import and add `AnalyticsModule` to the `imports` array

---

## Task 3: Frontend — Analytics Layout with Sidebar Navigation

**File:** `frontend-new/src/app/(analytics-console)/layout.tsx`

Replace the current bare layout with a proper analytics shell:
- Left sidebar with nav links (icon + label), role-gated visibility
- Top bar with "KSRCE Analytics" branding + user avatar/sign-out
- Main content area with padding
- Mobile-responsive (collapsible sidebar)

**Navigation items (role-gated):**
| Nav Item | Icon | Visible To |
|----------|------|-----------|
| Overview | LayoutDashboard | both |
| Sessions | Monitor | both |
| Revenue | IndianRupee | business_lead |
| Users | Users | business_lead |
| Nodes | Server | it_admin |
| Storage | HardDrive | both |
| Support | LifeBuoy | both |

**Component:** `frontend-new/src/components/analytics/analytics-sidebar.tsx`

---

## Task 4: Frontend — Overview Dashboard Page (Landing)

**File:** `frontend-new/src/app/(analytics-console)/analytics/dashboard/page.tsx` (replace current placeholder)

**Component:** `frontend-new/src/components/analytics/overview-dashboard.tsx`

**Displays (both roles):**
- KPI cards row: Total Users | Active Sessions | Revenue (period) | Node Health
- Session activity chart (line chart, last 7/30 days)
- Quick stats: Avg session duration, most popular config, storage utilization %
- Recent alerts/events feed (last 5 critical items)

**Role-specific additions:**
- business_lead sees: Revenue trend mini-chart, top 5 users by spend
- it_admin sees: Node status cards (green/yellow/red), resource utilization bars

---

## Task 5: Frontend — Sessions Analytics Page

**File:** `frontend-new/src/app/(analytics-console)/analytics/sessions/page.tsx`
**Component:** `frontend-new/src/components/analytics/sessions-analytics.tsx`

- Session count over time (bar chart)
- Active vs completed vs failed breakdown (donut)
- Average duration by compute config (horizontal bar)
- Termination reason distribution (pie chart)
- Table: Recent sessions with user, config, duration, cost, status

---

## Task 6: Frontend — Revenue Page (business_lead only)

**File:** `frontend-new/src/app/(analytics-console)/analytics/revenue/page.tsx`
**Component:** `frontend-new/src/components/analytics/revenue-analytics.tsx`

- Total revenue (period selector: 7d/30d/90d)
- Revenue trend line chart
- Compute vs Storage split (donut)
- Revenue by compute config tier (bar)
- Top users by spend (table)
- Daily revenue heatmap or bar

---

## Task 7: Frontend — Users Page (business_lead only)

**File:** `frontend-new/src/app/(analytics-console)/analytics/users/page.tsx`
**Component:** `frontend-new/src/components/analytics/users-analytics.tsx`

- Total users, new this period
- User growth trend (line chart)
- Auth type distribution (SSO vs local vs OAuth)
- Onboarding completion funnel
- User expertise/profession breakdown
- Top active users (by session count)

---

## Task 8: Frontend — Nodes Page (it_admin only)

**File:** `frontend-new/src/app/(analytics-console)/analytics/nodes/page.tsx`
**Component:** `frontend-new/src/components/analytics/nodes-analytics.tsx`

- Node cards: hostname, status indicator, last heartbeat
- Per-node resource utilization bars (CPU, Memory, GPU VRAM)
- Per-node active session count
- Node allocation efficiency (allocated/total as %)
- Alert: nodes with heartbeat > 60s old

---

## Task 9: Frontend — API Client Functions

**File:** `frontend-new/src/lib/api.ts` (add new functions)

```typescript
export async function getAnalyticsOverview(range?: string) { ... }
export async function getAnalyticsSessions(range?: string) { ... }
export async function getAnalyticsSessionsTrend(range?: string) { ... }
export async function getAnalyticsRevenue(range?: string) { ... }
export async function getAnalyticsUsers(range?: string) { ... }
export async function getAnalyticsNodes() { ... }
export async function getAnalyticsStorage() { ... }
export async function getAnalyticsSupport(range?: string) { ... }
```

Follow existing `apiFetch` pattern with token management.

---

## Task 10: Frontend — Charting Library

**Install:** `recharts` (lightweight, React-native, already commonly used with Next.js + Tailwind)

Charts needed: Line, Bar, Donut/Pie, Area. All with dark/light theme support matching Lambda design system.

---

## Dependencies & Execution Order

```
Task 1 (Backend Analytics Module)
  → Task 2 (Register Module)
    → Task 9 (Frontend API functions) [can start after backend contract is defined]
      → Task 3 (Layout + Sidebar)
        → Task 4 (Overview) — parallel with 5, 6, 7, 8
        → Task 5 (Sessions)
        → Task 6 (Revenue)
        → Task 7 (Users)
        → Task 8 (Nodes)

Task 10 (Install recharts) — independent, do first
```

---

## Design Principles

- Follow existing Lambda CSS / Tailwind design system (dark theme support, consistent spacing)
- Cards use `bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl`
- KPI cards: large number, subtle label, optional trend indicator (up/down arrow + %)
- Charts: zinc-based palette, accent colors for series
- Tables: compact, sortable columns, status badges
- Period selector: pill buttons (7d / 30d / 90d) top-right of each section
- Loading states: skeleton placeholders matching card dimensions
- Error states: inline retry buttons

---

## Risk & Considerations

1. **Performance** — Aggregate queries on large session/billing tables may be slow. Add DB indexes on `createdAt` + `status` if not present. Consider caching hot metrics (5-min TTL).
2. **KSRCE org scoping** — All queries MUST filter by organizationId to ensure multi-tenancy. The analytics portal is KSRCE-only for now.
3. **No pre-aggregation** — All metrics computed on-the-fly from transactional tables. Acceptable for current scale (hundreds of users, thousands of sessions). If scale grows, add materialized views later.
4. **Real-time node data** — Node status comes from DB (lastHeartbeatAt). For true real-time, would need WebSocket/polling. Start with page-refresh for MVP.
