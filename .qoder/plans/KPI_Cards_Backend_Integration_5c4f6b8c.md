# KPI Cards Backend Integration

## Available Database Models

The following Prisma models provide the data for each card:

| Card | Primary Model(s) | Key Fields |
|------|-----------------|------------|
| Revenue | `BillingCharge` | `amountCents`, `createdAt`, `chargeType` |
| Active Users | `User` + `Session` | `User.lastLoginAt`, `Session.status='running'` |
| GPU Hours Sold | `Session` | `durationSeconds`, `startedAt`, `endedAt`, `status` |
| Fleet Health | `Node` | `status` (healthy/degraded/offline/maintenance/draining), `lastHeartbeatAt` |

---

## Task 1: Create Analytics Admin Service

**File:** `c:\Users\Punith\LaaS\backend-new\src\dashboard\analytics-admin.service.ts` (new)

A service class with a single method `getKpiData(timeRange: '24H'|'7D'|'30D'|'All', orgId?: string)` that returns:

```ts
interface AnalyticsKpiResponse {
  revenue: {
    total: number;           // accumulated revenue in cents for the period
    dailyAvg: number;        // total / days in period (always full-period avg)
    changePct: number;       // % change vs prior equivalent period
    priorTotal: number;      // revenue in the prior period (for CDC calc)
  };
  activeUsers: {
    total: number;           // distinct users with lastLoginAt in period
    liveSessions: number;    // sessions with status='running' RIGHT NOW
    changeCount: number;     // new users in this period vs prior
    changePct: number;       // % change
    subtitleContext: string; // "vs yesterday" | "vs prior week" | "vs prior month" | "vs prior 30 days"
  };
  gpuHours: {
    total: number;           // SUM(durationSeconds)/3600 for ended sessions in period
    avgSessionDuration: number; // avg session duration in hours
    changePct: number;       // % change vs prior period
  };
  fleetHealth: {
    totalNodes: number;      // COUNT(Node)
    healthyNodes: number;    // COUNT(Node where status='healthy')
    trustScore: number;      // calculated score (see below)
    alertNodes: string[];    // names of nodes NOT in 'healthy' status
    uptimePct: number;       // % of time all nodes healthy (from lastHeartbeatAt checks)
  };
}
```

**Revenue query:**
```sql
SELECT SUM(amountCents) FROM BillingCharge WHERE createdAt >= [periodStart]
-- Prior period: same duration before periodStart
```

**Active Users query:**
```sql
SELECT COUNT(DISTINCT userId) FROM User WHERE lastLoginAt >= [periodStart]
-- Live sessions: SELECT COUNT(*) FROM Session WHERE status = 'running'
-- New users: SELECT COUNT(*) FROM User WHERE createdAt >= [periodStart]
```

**GPU Hours query:**
```sql
SELECT SUM(durationSeconds) FROM Session 
WHERE status IN ('ended','terminated_idle','terminated_overuse') 
AND endedAt >= [periodStart]
```

**Fleet Health — Trust Score (FICO-inspired):**
- Base score: 850 (perfect)
- Each node contributes equally (4 nodes = 212.5 points each at max)
- Healthy node: full contribution (212.5)
- Degraded: 70% contribution (148.75) 
- Maintenance: 80% contribution (170) — planned downtime, less penalty
- Draining: 60% contribution (127.5)
- Offline: 0 contribution
- Score = SUM of node contributions, clamped to 300-850 range
- This ensures gradual degradation (1 offline node: score drops from 850 to ~637, not a cliff)

**Period calculation:**
- 24H: now - 24hrs, prior = 24-48hrs ago
- 7D: now - 7 days, prior = 7-14 days ago
- 30D: now - 30 days, prior = 30-60 days ago
- All: all time (no prior period, changePct = 0)

---

## Task 2: Create Analytics Admin Controller Endpoint

**File:** `c:\Users\Punith\LaaS\backend-new\src\dashboard\dashboard.controller.ts` (add endpoint)

```ts
@Get('analytics/kpi')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('business_lead', 'admin')
async getAnalyticsKpi(@Query('timeRange') timeRange: string) {
  return this.analyticsAdminService.getKpiData(timeRange);
}
```

Register `AnalyticsAdminService` in the Dashboard module.

---

## Task 3: Wire Frontend to Fetch Real Data

**File:** `c:\Users\Punith\LaaS\frontend-new\src\components\analytics\analytics-dashboard.tsx`

1. Add a `useEffect` that calls `GET /api/dashboard/analytics/kpi?timeRange={timeRange}` whenever `timeRange` changes.
2. Store response in state: `const [kpiData, setKpiData] = useState<AnalyticsKpiResponse | null>(null)`
3. Replace hardcoded KPICard values with data from the response:

```tsx
{/* Revenue */}
<KPICard
  label="REVENUE"
  value={`₹${(kpiData.revenue.total / 100).toLocaleString("en-IN")}`}
  change={`${kpiData.revenue.changePct >= 0 ? '+' : ''}${kpiData.revenue.changePct.toFixed(1)}%`}
  changePositive={kpiData.revenue.changePct >= 0}
  subtitle={kpiData.activeUsers.subtitleContext}
  insight={`₹${(kpiData.revenue.dailyAvg / 100).toLocaleString("en-IN")} avg daily`}
/>

{/* Active Users */}
<KPICard
  label="ACTIVE USERS"
  value={String(kpiData.activeUsers.total)}
  change={`${kpiData.activeUsers.changeCount >= 0 ? '+' : ''}${kpiData.activeUsers.changeCount} new`}
  changePositive={kpiData.activeUsers.changeCount >= 0}
  subtitle={kpiData.activeUsers.subtitleContext}
  insight={`${kpiData.activeUsers.liveSessions} sessions live now`}
/>

{/* GPU Hours */}
<KPICard
  label="GPU HOURS SOLD"
  value={`${kpiData.gpuHours.total.toFixed(0)} hrs`}
  change={`${kpiData.gpuHours.changePct >= 0 ? '+' : ''}${kpiData.gpuHours.changePct.toFixed(1)}%`}
  changePositive={kpiData.gpuHours.changePct >= 0}
  subtitle={kpiData.activeUsers.subtitleContext}
  insight={`Avg session: ${kpiData.gpuHours.avgSessionDuration.toFixed(1)} hrs`}
/>

{/* Fleet Health — custom card */}
// Shows: X/Y nodes, trust score (e.g., "Score: 780/850")
// Alert state: if any node is not healthy, show amber dot + node name
// Green dot if all healthy
```

4. Add loading skeleton state while data fetches.
5. Keep the CDC subtitle contextual: "vs yesterday" for 24H, "vs prior week" for 7D, "vs prior month" for 30D, no CDC for "All".

---

## Task 4: Fleet Health Card Upgrade

The Fleet Health card already has a custom layout (not using `KPICard`). Enhance it:
- Show `X/Y nodes` as the main value (from `healthyNodes/totalNodes`)
- Show trust score as insight: `Trust: 780/850`
- If any nodes are not healthy, change the dot to amber and show which node(s) are down/degraded
- CDC shows uptime % change vs prior period

---

## Summary of Changes

| Layer | File | Action |
|-------|------|--------|
| Backend | `analytics-admin.service.ts` | New service with `getKpiData()` |
| Backend | `dashboard.controller.ts` | Add `GET analytics/kpi` endpoint |
| Backend | `dashboard.module.ts` | Register new service |
| Frontend | `analytics-dashboard.tsx` | Fetch + display real data, loading states |
