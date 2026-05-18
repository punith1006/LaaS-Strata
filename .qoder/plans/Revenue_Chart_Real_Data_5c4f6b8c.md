# Revenue Chart — Real Database Integration

## Current State

- **Revenue chart is 100% mock data** — `generateRawHourlyData()` in `revenue-chart.tsx` creates 2160 synthetic hourly data points (90 days). No API call.
- **OHLC values are hardcoded** in `analytics-dashboard.tsx` (lines 117-122).
- **Volume bars** use mock data with green/red based on hour-over-hour comparison.
- **BillingCharge table** has precise `createdAt` timestamps and `amountCents` (BigInt, in paise) — perfect for time-series aggregation.
- **Charges are created hourly** for running sessions (prepaid model: first hour on launch, then every hour via cron).

## Data Source

**Table**: `BillingCharge`
- `amountCents` (BigInt): Total charge in paise (divide by 100 for INR)
- `createdAt` (DateTime): Charge creation timestamp — PRIMARY key for time-series
- `chargeType`: 'compute' or 'storage'
- `rateCentsPerHour` (Int): Hourly rate at time of charge
- Index: `@@index([userId, createdAt])` — optimized for range queries

---

## Task 1: Backend — Revenue Time-Series Endpoint

**File**: `backend-new/src/dashboard/analytics-admin.service.ts`

Add new method `getRevenueChartData(timeRange)`:

```typescript
async getRevenueChartData(timeRange: '24H' | '7D' | '30D' | 'All'): Promise<{
  series: Array<{ time: number; value: number }>;
  ohlc: { open: number; high: number; low: number; close: number };
  currentRate: number;
  rateChange: number;
  rateChangePct: number;
}>
```

**Query pattern** (raw SQL via `prisma.$queryRaw`):
```sql
SELECT
  EXTRACT(EPOCH FROM DATE_TRUNC('hour', created_at))::int as time,
  SUM(amount_cents)::bigint as total_cents
FROM billing_charges
WHERE created_at >= {periodStart}
GROUP BY DATE_TRUNC('hour', created_at)
ORDER BY time ASC
```

**Aggregation strategy** (matches current chart buckets):
- 24H: raw hourly data (no aggregation needed — already hourly from SQL)
- 7D: average every 4 consecutive hours into one point
- 30D: average every 12 consecutive hours into one point
- All (90D): average every 24 hours (daily)

**OHLC calculation** (from the aggregated data points):
- Open (O): First data point's value in the period
- High (H): Maximum value among all data points
- Low (L): Minimum value among all data points
- Close (C): Last data point's value

**currentRate**: The most recent hour's revenue (last data point)
**rateChange**: Close - Open (absolute change in rupees)
**rateChangePct**: ((Close - Open) / Open) * 100

**File**: `backend-new/src/dashboard/dashboard.controller.ts`

Add endpoint:
```typescript
@UseGuards(JwtAuthGuard)
@Get('analytics/revenue-chart')
async getRevenueChart(@Query('timeRange') timeRange: string) {
  return this.analyticsAdminService.getRevenueChartData(
    (timeRange as '24H' | '7D' | '30D' | 'All') || '7D',
  );
}
```

---

## Task 2: Frontend — Replace Mock Data with API Fetch

**File**: `frontend-new/src/components/analytics/revenue-chart.tsx`

1. **Remove** the `generateRawHourlyData()` function (lines 16-51) and all synthetic data generation.
2. **Remove** internal aggregation logic (`aggregateFullPool()`) — backend will handle bucketing.
3. **Add** `useEffect` to fetch from `GET /api/dashboard/analytics/revenue-chart?timeRange={timeRange}`.
4. **Auth**: Use `getAnalyticsAccessToken()` with Bearer header (same pattern as KPI fetch).
5. **Data mapping**: Convert API response `series[]` directly to chart data:
   - AreaSeries: `{ time: point.time as UTCTimestamp, value: point.value }`
   - HistogramSeries: Same values, with color logic (green if `value >= prevValue`, red otherwise)
6. **Loading state**: Show skeleton/spinner while fetching.
7. **Error handling**: Show "No revenue data" if API returns empty array or errors.

**File**: `frontend-new/src/components/analytics/analytics-dashboard.tsx`

1. **Remove** hardcoded OHLC mock objects (lines 117-122).
2. **Update** OHLC display section to use data from the revenue-chart API response (pass OHLC as props or fetch in parent).
3. **Update** revenue rate display (currently hardcoded "₹5,700.00/hr") to use `currentRate` from API.
4. **Update** change values ("+₹820.00", "+16.8%") from `rateChange` and `rateChangePct`.

---

## Task 3: Handle Edge Cases

- **Empty data**: If no BillingCharge records exist in period, return empty series and zero OHLC.
- **BigInt conversion**: All `amountCents` values are BigInt in Prisma — use `Number()` conversion in raw query result mapping.
- **Single data point**: If only 1 charge exists, OHLC = all same value, no volume bars.
- **Gaps in data**: Hours with no charges should appear as 0-value points (fill gaps with zeros so chart line drops to 0 during idle periods).
- **Timezone**: All timestamps stored as UTC. Frontend displays in local timezone via lightweight-charts.
- **Lazy loading**: Remove lazy-loading logic (unnecessary — max ~90 aggregated data points load in one fetch).

---

## Files Modified

| File | Change |
|------|--------|
| `backend-new/src/dashboard/analytics-admin.service.ts` | Add `getRevenueChartData()` method |
| `backend-new/src/dashboard/dashboard.controller.ts` | Add `GET analytics/revenue-chart` endpoint |
| `frontend-new/src/components/analytics/revenue-chart.tsx` | Remove mock, fetch real data, simplify |
| `frontend-new/src/components/analytics/analytics-dashboard.tsx` | Remove hardcoded OHLC, wire to API response |

---

## Verification

- Backend endpoint returns correct hourly sums matching raw `SELECT SUM(amount_cents) FROM billing_charges GROUP BY hour`
- Chart renders real revenue with correct INR values
- OHLC header updates dynamically per timeline
- Volume bars color correctly (green = up, red = down vs previous bucket)
- Switching timelines (24H/7D/30D/All) re-fetches and re-renders correctly
- Empty state handled gracefully (no errors when no billing data exists)
