import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

export interface RevenueChartResponse {
  series: Array<{ time: number; value: number }>;
  ohlc: { open: number; high: number; low: number; close: number; previousHigh?: number };
  currentRate: number;
  rateChange: number;
  rateChangePct: number;
}

export interface AnalyticsKpiResponse {
  revenue: {
    total: number;
    dailyAvg: number;
    changePct: number;
    subtitleContext: string;
  };
  activeUsers: {
    count: number;
    changePct: number;
    liveSessions: number;
    newUsers: number;
    newUsersChangePct: number;
    subtitleContext: string;
  };
  gpuHours: {
    totalHours: number;
    avgSessionHours: number;
    sessionCount: number;
    changePct: number;
    subtitleContext: string;
  };
  fleetHealth: {
    trustScore: number;
    uptimePct: number;
    totalNodes: number;
    healthyNodes: number;
    alertNodes: string[];
    lastHeartbeatAt: Date | null;
  };
}

export interface ComputeActivityResponse {
  dailyBreakdown: Array<{
    date: string;
    dayName: string;
    hours: number;
  }>;
  totalHours: number;
  priorTotalHours: number;
  comparisonText: string;
  periodLabel: string;
}

export interface ActiveSessionTier {
  tierName: string;
  count: number;
  percentage: number;
  color: string;
}

export interface ActiveSessionsResponse {
  totalCount: number;
  byTier: ActiveSessionTier[];
}

export interface RecentTransaction {
  time: string;
  userName: string;
  userEmail: string;
  amount: number;
  type: 'compute' | 'storage';
  status: 'completed' | 'active';
}

export interface NrrPeriod {
  label: string;
  nrrPct: number | null;      // null for first period
  expandedUsers: number;       // users who spent more in next period
  contractedUsers: number;     // users who spent less in next period
  cohortSize: number;          // users active in this period
  cohortRevenueCents: number;  // total revenue from cohort in this period
}

export interface NrrResponse {
  periods: NrrPeriod[];
  currentNrrPct: number | null;  // latest non-null NRR
  avgNrrPct: number;             // average of all non-null NRR values
}

export interface RetentionPeriod {
  label: string;
  activeUsers: number;
  retainedUsers: number;
  retentionPct: number | null;
  newUsers: number;
  churnedUsers: number;
}

export interface RetentionResponse {
  periods: RetentionPeriod[];
  currentRetentionPct: number | null;
  avgRetentionPct: number;
}

export interface AttentionRequiredResponse {
  lowBalanceUsers: {
    count: number;
    threshold: number; // in rupees
    subtitle: string;
  };
  supportBacklog: {
    count: number;
    thresholdHours: number;
    avgResolutionTime: number; // in hours
    subtitle: string;
  };
  sessionFailures: {
    failureRate: number; // percentage
    priorWeekRate: number; // percentage from last week
    subtitle: string;
  };
}

@Injectable()
export class AnalyticsAdminService {
  constructor(private prisma: PrismaService) {}

  // IST offset in milliseconds (5.5 hours)
  private readonly IST_OFFSET_MS = 5.5 * 60 * 60 * 1000;

  /**
   * Get start of current day in IST (00:00 IST)
   */
  private getISTDayStart(date: Date): Date {
    // Convert to IST
    const istTime = new Date(date.getTime() + this.IST_OFFSET_MS);
    // Set to midnight IST
    istTime.setUTCHours(0, 0, 0, 0);
    // Convert back to UTC
    return new Date(istTime.getTime() - this.IST_OFFSET_MS);
  }

  /**
   * Split a duration across IST day boundaries proportionally.
   * Returns a Map of IST date string -> hours for that day.
   */
  private splitDurationAcrossISTDays(
    effectiveStartMs: number,
    effectiveEndMs: number,
    durationSeconds: number,
  ): Map<string, number> {
    const split = new Map<string, number>();
    const spanMs = effectiveEndMs - effectiveStartMs;
    if (spanMs <= 0 || durationSeconds <= 0) return split;

    let cursorMs = effectiveStartMs;
    while (cursorMs < effectiveEndMs) {
      const istCursor = new Date(cursorMs + this.IST_OFFSET_MS);
      const dayStr = istCursor.toISOString().split('T')[0];

      // Next IST midnight boundary (in UTC ms)
      const nextIstMidnight = new Date(istCursor);
      nextIstMidnight.setUTCHours(24, 0, 0, 0);
      const nextBoundaryMs = nextIstMidnight.getTime() - this.IST_OFFSET_MS;

      const segmentEndMs = Math.min(nextBoundaryMs, effectiveEndMs);
      const fraction = (segmentEndMs - cursorMs) / spanMs;
      const segmentHours = (durationSeconds * fraction) / 3600;

      split.set(dayStr, (split.get(dayStr) || 0) + segmentHours);
      cursorMs = segmentEndMs;
    }
    return split;
  }

  // Regular user roles that should be counted in active users
  private REGULAR_USER_ROLES = ['public_user', 'student', 'external_student'];
  // Admin role names that should be excluded from active users count
  private ADMIN_ROLES = ['business_lead', 'it_admin', 'super_admin', 'org_admin'];

  private async getRegularUserIds(): Promise<string[]> {
    // Get all role IDs for regular user roles
    const regularRoles = await this.prisma.role.findMany({
      where: { name: { in: this.REGULAR_USER_ROLES } },
      select: { id: true },
    });

    if (regularRoles.length === 0) return [];
    const regularRoleIds = regularRoles.map(r => r.id);

    // Get all admin role IDs to exclude
    const adminRoles = await this.prisma.role.findMany({
      where: { name: { in: this.ADMIN_ROLES } },
      select: { id: true },
    });
    const adminRoleIds = adminRoles.map(r => r.id);

    // Get all user IDs with regular user roles
    const regularUserOrgRoles = await this.prisma.userOrgRole.findMany({
      where: {
        roleId: { in: regularRoleIds },
      },
      select: { userId: true },
    });

    // Get all user IDs with admin roles
    const adminUserOrgRoles = await this.prisma.userOrgRole.findMany({
      where: {
        roleId: { in: adminRoleIds },
      },
      select: { userId: true },
    });

    const regularUserIds = new Set(regularUserOrgRoles.map(u => u.userId));
    const adminUserIds = new Set(adminUserOrgRoles.map(u => u.userId));

    // Filter out admin users from regular users
    const filteredIds: string[] = [];
    for (const id of regularUserIds) {
      if (!adminUserIds.has(id)) {
        filteredIds.push(id);
      }
    }

    return filteredIds;
  }

  async getKpiData(
    timeRange: '24H' | '7D' | '30D' | 'All',
  ): Promise<AnalyticsKpiResponse> {
    const now = new Date();
    const { periodStart, priorStart, priorEnd, daysInPeriod, subtitleContext } =
      this.getPeriodBounds(timeRange, now);

    // --- Revenue ---
    const currentRevenue = await this.prisma.billingCharge.aggregate({
      _sum: { amountCents: true },
      where: { createdAt: { gte: periodStart } },
    });
    const currentTotal = Number(currentRevenue._sum.amountCents ?? 0);

    let priorTotal = 0;
    if (priorStart && priorEnd) {
      const priorRevenue = await this.prisma.billingCharge.aggregate({
        _sum: { amountCents: true },
        where: { createdAt: { gte: priorStart, lt: priorEnd } },
      });
      priorTotal = Number(priorRevenue._sum.amountCents ?? 0);
    }

    const revenueChangePct =
      priorTotal > 0 ? ((currentTotal - priorTotal) / priorTotal) * 100 : 0;
    const revenueDailyAvg = daysInPeriod > 0 ? currentTotal / daysInPeriod : 0;

    // --- Active Users: Regular users only (excludes admin roles like business_lead, it_admin) ---
    const regularUserIds = await this.getRegularUserIds();
    const activeUsers = regularUserIds.length;

    // CDC: compare active user count now vs users who existed before the period
    // i.e., how many new users joined during this period
    const usersBeforePeriod = await this.prisma.user.count({
      where: {
        isActive: true,
        createdAt: { lt: periodStart },
        id: { in: regularUserIds },
      },
    });
    const activeUsersChangePct =
      usersBeforePeriod > 0
        ? ((activeUsers - usersBeforePeriod) / usersBeforePeriod) * 100
        : 0;

    const liveSessions = await this.prisma.session.count({
      where: { status: 'running' },
    });

    const newUsers = await this.prisma.user.count({
      where: {
        createdAt: { gte: periodStart },
        id: { in: regularUserIds },
      },
    });

    let priorNewUsers = 0;
    if (priorStart && priorEnd) {
      priorNewUsers = await this.prisma.user.count({
        where: {
          createdAt: { gte: priorStart, lt: priorEnd },
          id: { in: regularUserIds },
        },
      });
    }

    const newUsersChangePct =
      priorNewUsers > 0
        ? ((newUsers - priorNewUsers) / priorNewUsers) * 100
        : 0;

    // --- GPU Hours ---
    // Ended sessions in current period — prorate sessions that span across the period boundary
    // If a session started before periodStart, only count the portion within the period
    // NOTE: format dates as plain UTC strings (no Z suffix) to prevent PostgreSQL from
    // treating them as timestamptz and converting through the session timezone (IST)
    const periodStartTs = periodStart.toISOString().replace('Z', '');
    const gpuData = await this.prisma.$queryRaw<
      Array<{ total_seconds: bigint; session_count: bigint }>
    >`
      SELECT
        CAST(COALESCE(SUM(
          CASE
            WHEN s."started_at" IS NULL OR s."started_at" >= ${periodStartTs}::timestamp
            THEN s."duration_seconds"
            ELSE EXTRACT(EPOCH FROM s."ended_at" - ${periodStartTs}::timestamp)
          END
        ), 0) AS BIGINT) as total_seconds,
        CAST(COUNT(*) AS BIGINT) as session_count
      FROM "sessions" s
      WHERE s.status IN ('ended', 'terminated_idle', 'terminated_overuse')
        AND s."ended_at" >= ${periodStartTs}::timestamp
    `;

    // Also include running sessions' elapsed time — only the portion within the selected period
    const runningSessions = await this.prisma.session.findMany({
      where: {
        status: 'running',
        startedAt: { not: null },
      },
      select: { startedAt: true },
    });
    const runningElapsedSeconds = runningSessions.reduce((sum, s) => {
      if (!s.startedAt) return sum;
      // Only count time from the later of (periodStart, startedAt) to now
      const countFrom = Math.max(periodStart.getTime(), s.startedAt.getTime());
      return sum + Math.max(0, Math.floor((now.getTime() - countFrom) / 1000));
    }, 0);

    let priorGpuTotalSeconds = 0;
    if (priorStart && priorEnd) {
      const priorStartTs = priorStart.toISOString().replace('Z', '');
      const priorEndTs = priorEnd.toISOString().replace('Z', '');
      const priorGpuData = await this.prisma.$queryRaw<
        Array<{ total_seconds: bigint }>
      >`
        SELECT
          CAST(COALESCE(SUM(
            CASE
              WHEN s."started_at" IS NULL OR s."started_at" >= ${priorStartTs}::timestamp
              THEN
                CASE
                  WHEN s."ended_at" <= ${priorEndTs}::timestamp
                  THEN s."duration_seconds"
                  ELSE EXTRACT(EPOCH FROM ${priorEndTs}::timestamp - s."started_at")
                END
              ELSE
                CASE
                  WHEN s."ended_at" <= ${priorEndTs}::timestamp
                  THEN EXTRACT(EPOCH FROM s."ended_at" - ${priorStartTs}::timestamp)
                  ELSE EXTRACT(EPOCH FROM ${priorEndTs}::timestamp - ${priorStartTs}::timestamp)
                END
            END
          ), 0) AS BIGINT) as total_seconds
        FROM "sessions" s
        WHERE s.status IN ('ended', 'terminated_idle', 'terminated_overuse')
          AND s."ended_at" >= ${priorStartTs}::timestamp
          AND s."started_at" < ${priorEndTs}::timestamp
      `;
      priorGpuTotalSeconds = Number(priorGpuData[0]?.total_seconds ?? 0);
    }

    const endedGpuSeconds = Number(gpuData[0]?.total_seconds ?? 0);
    const endedSessionCount = Number(gpuData[0]?.session_count ?? 0);
    const gpuTotalSeconds = endedGpuSeconds + runningElapsedSeconds;
    const totalSessionCount = endedSessionCount + runningSessions.length;
    const gpuTotalHours = gpuTotalSeconds / 3600;
    const gpuAvgSessionHours = totalSessionCount > 0 ? gpuTotalHours / totalSessionCount : 0;

    const gpuChangePct =
      priorGpuTotalSeconds > 0
        ? ((gpuTotalSeconds - priorGpuTotalSeconds) / priorGpuTotalSeconds) *
          100
        : 0;

    // --- Fleet Health ---
    const nodes = await this.prisma.node.findMany({
      select: { id: true, hostname: true, status: true, lastHeartbeatAt: true },
    });

    const totalNodes = nodes.length;
    const healthyNodes = nodes.filter((n) => n.status === 'healthy').length;

    let trustScore = 850;
    if (totalNodes > 0) {
      const nodeMaxContribution = 850 / totalNodes;
      const multipliers: Record<string, number> = {
        healthy: 1.0,
        maintenance: 0.8,
        degraded: 0.7,
        draining: 0.6,
        offline: 0.0,
      };

      const rawScore = nodes.reduce((sum, node) => {
        const mult = multipliers[node.status] ?? 0;
        return sum + nodeMaxContribution * mult;
      }, 0);

      trustScore = Math.max(300, Math.min(850, Math.round(rawScore)));
    }

    const alertNodes = nodes
      .filter((n) => n.status !== 'healthy')
      .map((n) => n.hostname);

    const uptimePct = totalNodes > 0 ? (healthyNodes / totalNodes) * 100 : 0;

    const lastHeartbeatAt = nodes.length > 0
      ? new Date(Math.max(...nodes.map((n) => n.lastHeartbeatAt?.getTime() ?? 0)))
      : null;

    return {
      revenue: {
        total: currentTotal,
        dailyAvg: Math.round(revenueDailyAvg),
        changePct: Math.round(revenueChangePct * 100) / 100,
        subtitleContext,
      },
      activeUsers: {
        count: activeUsers,
        changePct: Math.round(activeUsersChangePct * 100) / 100,
        liveSessions,
        newUsers,
        newUsersChangePct: Math.round(newUsersChangePct * 100) / 100,
        subtitleContext,
      },
      gpuHours: {
        totalHours: Math.round(gpuTotalHours * 100) / 100,
        avgSessionHours: Math.round(gpuAvgSessionHours * 100) / 100,
        sessionCount: totalSessionCount,
        changePct: Math.round(gpuChangePct * 100) / 100,
        subtitleContext,
      },
      fleetHealth: {
        trustScore,
        uptimePct: Math.round(uptimePct * 100) / 100,
        totalNodes,
        healthyNodes,
        alertNodes,
        lastHeartbeatAt,
      },
    };
  }

  async getFleetHealthData() {
    const nodes = await this.prisma.node.findMany({
      select: { id: true, hostname: true, status: true, lastHeartbeatAt: true },
    });

    const totalNodes = nodes.length;
    const healthyNodes = nodes.filter((n) => n.status === 'healthy').length;

    let trustScore = 850;
    if (totalNodes > 0) {
      const nodeMaxContribution = 850 / totalNodes;
      const multipliers: Record<string, number> = {
        healthy: 1.0, maintenance: 0.8, degraded: 0.7, draining: 0.6, offline: 0.0,
      };
      const rawScore = nodes.reduce((sum, node) => {
        const mult = multipliers[node.status] ?? 0;
        return sum + nodeMaxContribution * mult;
      }, 0);
      trustScore = Math.max(300, Math.min(850, Math.round(rawScore)));
    }

    const alertNodes = nodes
      .filter((n) => n.status !== 'healthy')
      .map((n) => n.hostname);

    const uptimePct = totalNodes > 0 ? (healthyNodes / totalNodes) * 100 : 0;

    const lastHeartbeatAt = nodes.length > 0
      ? new Date(Math.max(...nodes.map((n) => n.lastHeartbeatAt?.getTime() ?? 0)))
      : null;

    return {
      trustScore,
      uptimePct: Math.round(uptimePct * 100) / 100,
      totalNodes,
      healthyNodes,
      alertNodes,
      lastHeartbeatAt,
    };
  }

  async getRevenueChartData(
    timeRange: '24H' | '7D' | '30D' | 'All',
  ): Promise<RevenueChartResponse> {
    const now = new Date();
    const emptyResponse: RevenueChartResponse = {
      series: [],
      ohlc: { open: 0, high: 0, low: 0, close: 0 },
      currentRate: 0,
      rateChange: 0,
      rateChangePct: 0,
    };

    // Step 1: Determine period bounds
    // For 'All' use 90 days to avoid generating hourly slots from epoch
    let periodStart: Date;
    if (timeRange === 'All') {
      periodStart = new Date(now.getTime() - 90 * 24 * 60 * 60 * 1000);
    } else {
      const bounds = this.getPeriodBounds(timeRange, now);
      // Extend periodStart back to capture the full UTC hour where periodStart falls
      // This ensures charges at 18:30 UTC are grouped into the 18:00 UTC bucket
      const periodStartMs = bounds.periodStart.getTime();
      const hourMs = 60 * 60 * 1000;
      periodStart = new Date(periodStartMs - (periodStartMs % hourMs));
    }

    // Step 2: Query hourly aggregates in UTC
    // Group by UTC hour boundaries (simple truncation)
    const rows = await this.prisma.$queryRaw<
      Array<{ time: number; total_cents: bigint }>
    >`
      SELECT
        EXTRACT(EPOCH FROM DATE_TRUNC('hour', "created_at") AT TIME ZONE 'UTC')::int as time,
        SUM("amount_cents")::bigint as total_cents
      FROM "billing_charges"
      WHERE "created_at" >= ${periodStart}
      GROUP BY 1
      ORDER BY 1 ASC
    `;

    // Build a map of UTC epoch -> value in rupees
    // The query returns UTC epoch seconds
    const dataMap = new Map<number, number>();
    for (const row of rows) {
      dataMap.set(Number(row.time), Number(row.total_cents) / 100);
    }

    console.log('[RevenueChart] Raw hourly data from database:', {
      totalHours: rows.length,
      sampleData: rows.slice(-5).map(r => ({
        time: new Date(Number(r.time) * 1000).toISOString(),
        value: Number(r.total_cents) / 100
      }))
    });

    // Step 3: Fill gaps with zeros — generate complete hourly series
    // The timestamps from the query are UTC epoch seconds
    const startEpoch = Math.floor(periodStart.getTime() / 1000);
    const endEpoch = Math.floor(now.getTime() / 1000);
    const hourSeconds = 3600;

    // Align start to the previous UTC hour (round down)
    // This captures charges at 18:30 UTC which get grouped into 18:00 UTC bucket
    const alignedStart = startEpoch - (startEpoch % hourSeconds);

    const hourlySeries: Array<{ time: number; value: number }> = [];
    for (let t = alignedStart; t <= endEpoch; t += hourSeconds) {
      hourlySeries.push({ time: t, value: dataMap.get(t) ?? 0 });
    }

    if (hourlySeries.length === 0) {
      return emptyResponse;
    }

    // Step 4: Bucket aggregation
    let bucketSize: number;
    switch (timeRange) {
      case '24H':
        bucketSize = 1;
        break;
      case '7D':
        bucketSize = 4;
        break;
      case '30D':
        bucketSize = 12;
        break;
      case 'All':
      default:
        bucketSize = 24;
        break;
    }

    const aggregatedSeries: Array<{ time: number; value: number }> = [];
    for (let i = 0; i < hourlySeries.length; i += bucketSize) {
      const bucket = hourlySeries.slice(i, i + bucketSize);
      const sum = bucket.reduce((acc, p) => acc + p.value, 0);
      aggregatedSeries.push({ time: bucket[0].time, value: Math.round(sum * 100) / 100 });
    }

    // Debug logging for bucket aggregation
    console.log('[RevenueChart] Bucket aggregation:', {
      timeRange,
      bucketSize,
      hourlySeriesLength: hourlySeries.length,
      aggregatedSeriesLength: aggregatedSeries.length,
      firstFewBuckets: aggregatedSeries.slice(0, 3).map(b => ({ time: new Date(b.time * 1000).toISOString(), value: b.value })),
      lastFewBuckets: aggregatedSeries.slice(-3).map(b => ({ time: new Date(b.time * 1000).toISOString(), value: b.value })),
    });

    if (aggregatedSeries.length === 0) {
      return emptyResponse;
    }

    // Remove ONLY the very last bucket if it's zero AND we're at the current hour (incomplete bucket)
    // Do NOT remove buckets that have non-zero values, even if followed by zeros
    if (
      aggregatedSeries.length > 1 &&
      aggregatedSeries[aggregatedSeries.length - 1].value === 0
    ) {
      // Check if the second-to-last bucket has data (keep it if it does)
      const secondLast = aggregatedSeries[aggregatedSeries.length - 2];
      if (secondLast && secondLast.value > 0) {
        // Only remove if we're in the current (incomplete) hour
        aggregatedSeries.pop();
      }
    }

    // Step 5: Calculate OHLC from the final aggregated series
    const open = aggregatedSeries[0].value;
    const close = aggregatedSeries[aggregatedSeries.length - 1].value;
    const high = Math.max(...aggregatedSeries.map((p) => p.value));
    const nonZeroValues = aggregatedSeries
      .map((p) => p.value)
      .filter((v) => v > 0);
    const low = nonZeroValues.length > 0 ? Math.min(...nonZeroValues) : 0;

    // Step 6: Calculate rate metrics
    // currentRate should always reflect the most recent HOUR's revenue (independent of timeframe/bucket size)
    // Get from raw hourly data, not from aggregated buckets
    const hourlyValues = Array.from(dataMap.values());
    const lastHourRevenue = hourlyValues.length > 0 ? hourlyValues[hourlyValues.length - 1] : 0;
    const previousHourRevenue = hourlyValues.length > 1 ? hourlyValues[hourlyValues.length - 2] : 0;
    
    const currentRate = lastHourRevenue;
    const rateChange = Math.round((lastHourRevenue - previousHourRevenue) * 100) / 100;
    const rateChangePct =
      previousHourRevenue > 0
        ? Math.round(((lastHourRevenue - previousHourRevenue) / previousHourRevenue) * 100 * 100) / 100
        : 0;

    // Calculate previous period high (for 24H, 7D, 30D only)
    let previousHigh = 0;
    if (timeRange !== 'All') {
      // Calculate the previous period bounds
      const periodDuration = now.getTime() - periodStart.getTime();
      const previousPeriodStart = new Date(periodStart.getTime() - periodDuration);
      const previousPeriodEnd = new Date(periodStart.getTime());

      // Query for the maximum hourly bucket in the previous period
      const previousPeriodRows = await this.prisma.$queryRaw<
        Array<{ time: number; total_cents: bigint }>
      >`
        SELECT
          EXTRACT(EPOCH FROM DATE_TRUNC('hour', "created_at"))::int as time,
          SUM("amount_cents")::bigint as total_cents
        FROM "billing_charges"
        WHERE "created_at" >= ${previousPeriodStart} AND "created_at" < ${previousPeriodEnd}
        GROUP BY DATE_TRUNC('hour', "created_at")
      `;

      // Find the maximum value from previous period
      if (previousPeriodRows.length > 0) {
        previousHigh = Math.max(
          ...previousPeriodRows.map(row => Number(row.total_cents) / 100)
        );
      }
    }

    return {
      series: aggregatedSeries,
      ohlc: { open, high, low, close, previousHigh },
      currentRate,
      rateChange,
      rateChangePct,
    };
  }

  private getPeriodBounds(
    timeRange: '24H' | '7D' | '30D' | 'All',
    now: Date,
  ): {
    periodStart: Date;
    priorStart: Date | null;
    priorEnd: Date | null;
    daysInPeriod: number;
    subtitleContext: string;
  } {
    // Get today's IST day start (00:00 IST)
    const istDayStart = this.getISTDayStart(now);
    
    switch (timeRange) {
      case '24H': {
        // Today IST: 00:00 IST today to 23:59 IST today
        const periodStart = istDayStart;
        // Yesterday IST: 00:00 IST yesterday
        const priorStart = new Date(istDayStart.getTime() - 24 * 60 * 60 * 1000);
        return {
          periodStart,
          priorStart,
          priorEnd: periodStart,
          daysInPeriod: 1,
          subtitleContext: 'vs yesterday',
        };
      }
      case '7D': {
        // Last 7 complete IST days (from 00:00 IST 7 days ago)
        const periodStart = new Date(istDayStart.getTime() - 6 * 24 * 60 * 60 * 1000);
        // Prior period: 7 days before periodStart
        const priorStart = new Date(periodStart.getTime() - 7 * 24 * 60 * 60 * 1000);
        return {
          periodStart,
          priorStart,
          priorEnd: periodStart,
          daysInPeriod: 7,
          subtitleContext: 'vs prior week',
        };
      }
      case '30D': {
        // Last 30 complete IST days (from 00:00 IST 30 days ago)
        const periodStart = new Date(istDayStart.getTime() - 29 * 24 * 60 * 60 * 1000);
        // Prior period: 30 days before periodStart
        const priorStart = new Date(periodStart.getTime() - 30 * 24 * 60 * 60 * 1000);
        return {
          periodStart,
          priorStart,
          priorEnd: periodStart,
          daysInPeriod: 30,
          subtitleContext: 'vs prior 30 days',
        };
      }
      case 'All':
      default: {
        // All time: complete aggregation from epoch
        const periodStart = new Date(0);
        return {
          periodStart,
          priorStart: null,
          priorEnd: null,
          daysInPeriod: Math.ceil(
            (now.getTime() - periodStart.getTime()) / (24 * 60 * 60 * 1000),
          ),
          subtitleContext: '',
        };
      }
    }
  }

  /**
   * Get compute activity data - daily GPU hours distribution
   */
  async getComputeActivityData(
    timeRange: '24H' | '7D' | '30D' | 'All',
  ): Promise<ComputeActivityResponse> {
    const now = new Date();
    const { periodStart, priorStart, priorEnd } = this.getPeriodBounds(
      timeRange,
      now,
    );

    // NOTE: format dates as plain UTC strings (no Z suffix) to prevent PostgreSQL from
    // treating them as timestamptz and converting through the session timezone (IST)
    const periodStartTs = periodStart.toISOString().replace('Z', '');

    // Query ended sessions — fetch per-session data for IST day-boundary splitting
    const endedSessions = await this.prisma.$queryRaw<
      Array<{ started_at: Date | null; ended_at: Date | null; duration_seconds: bigint }>
    >`
      SELECT
        s.started_at,
        s.ended_at,
        CASE
          WHEN s.started_at IS NULL OR s.started_at >= ${periodStartTs}::timestamp
          THEN s.duration_seconds
          ELSE EXTRACT(EPOCH FROM s."ended_at" - ${periodStartTs}::timestamp)
        END as duration_seconds
      FROM "sessions" s
      WHERE s.status IN ('ended', 'terminated_idle', 'terminated_overuse')
        AND s.ended_at >= ${periodStartTs}::timestamp
    `;

    // Include running sessions
    const runningSessions = await this.prisma.session.findMany({
      where: {
        status: 'running',
        startedAt: { not: null },
      },
      select: { startedAt: true, durationSeconds: true },
    });

    // Build a map of day -> hours, splitting each session's effective duration across IST day boundaries
    const dayMap = new Map<string, number>();
    const periodStartMs = periodStart.getTime();

    // Add ended sessions — split across IST day boundaries
    for (const s of endedSessions) {
      const startedAtMs = s.started_at?.getTime() ?? periodStartMs;
      const endedAtMs = s.ended_at?.getTime() ?? periodStartMs;
      const effectiveStartMs = Math.max(startedAtMs, periodStartMs);
      const durSeconds = Number(s.duration_seconds);

      if (effectiveStartMs >= endedAtMs || durSeconds <= 0) continue;

      // Fast path: same IST date -> attribute directly
      const startIstDay = new Date(effectiveStartMs + this.IST_OFFSET_MS).toISOString().split('T')[0];
      const endIstDay = new Date(endedAtMs + this.IST_OFFSET_MS).toISOString().split('T')[0];

      if (startIstDay === endIstDay) {
        dayMap.set(startIstDay, (dayMap.get(startIstDay) || 0) + durSeconds / 3600);
      } else {
        const split = this.splitDurationAcrossISTDays(effectiveStartMs, endedAtMs, durSeconds);
        for (const [day, hours] of split) {
          dayMap.set(day, (dayMap.get(day) || 0) + hours);
        }
      }
    }

    // Add running sessions — split across IST day boundaries (same logic as ended)
    for (const session of runningSessions) {
      if (!session.startedAt) continue;
      const effectiveStartMs = Math.max(periodStartMs, session.startedAt.getTime());
      const effectiveEndMs = now.getTime();

      if (effectiveStartMs >= effectiveEndMs) continue;
      const elapsedSeconds = Math.floor((effectiveEndMs - effectiveStartMs) / 1000);
      if (elapsedSeconds <= 0) continue;

      // Fast path: same IST date
      const startIstDay = new Date(effectiveStartMs + this.IST_OFFSET_MS).toISOString().split('T')[0];
      const endIstDay = new Date(effectiveEndMs + this.IST_OFFSET_MS).toISOString().split('T')[0];

      if (startIstDay === endIstDay) {
        dayMap.set(startIstDay, (dayMap.get(startIstDay) || 0) + elapsedSeconds / 3600);
      } else {
        const split = this.splitDurationAcrossISTDays(effectiveStartMs, effectiveEndMs, elapsedSeconds);
        for (const [day, hours] of split) {
          dayMap.set(day, (dayMap.get(day) || 0) + hours);
        }
      }
    }

    // Always return exactly 7 days (Mon-Sun), aggregating by day of week
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const dayHours = new Array(7).fill(0);
    
    // Determine today's IST day-of-week index
    const nowIst = new Date(now.getTime() + this.IST_OFFSET_MS);
    const todayJsDay = nowIst.getUTCDay();
    const todayIndex = todayJsDay === 0 ? 6 : todayJsDay - 1; // 0=Mon..6=Sun
    
    // Aggregate all data by day of week (0=Mon, 6=Sun)
    for (const [dateStr, hours] of dayMap.entries()) {
      const date = new Date(dateStr);
      // JavaScript getDay(): 0=Sun, 1=Mon, ..., 6=Sat
      // We want: 0=Mon, 1=Tue, ..., 6=Sun
      const jsDay = date.getDay();
      const dayIndex = jsDay === 0 ? 6 : jsDay - 1;
      
      // For 24H, all data goes into today's bucket (other days should display as 0)
      if (timeRange === '24H') {
        dayHours[todayIndex] += hours;
      } else {
        dayHours[dayIndex] += hours;
      }
    }

    // Build the breakdown array
    const dailyBreakdown = dayNames.map((dayName, index) => ({
      date: '', // Not needed for display
      dayName,
      hours: Math.round(dayHours[index] * 10) / 10,
    }));

    // Calculate totals
    const totalHours = dailyBreakdown.reduce((sum, d) => sum + d.hours, 0);

    let priorTotalHours = 0;
    if (priorStart && priorEnd) {
      const priorStartTs = priorStart.toISOString().replace('Z', '');
      const priorEndTs = priorEnd.toISOString().replace('Z', '');
      const priorData = await this.prisma.$queryRaw<
        Array<{ total_hours: number }>
      >`
        SELECT COALESCE(SUM(
          CASE
            WHEN s."started_at" IS NULL OR s."started_at" >= ${priorStartTs}::timestamp
            THEN s."duration_seconds"
            ELSE EXTRACT(EPOCH FROM s."ended_at" - ${priorStartTs}::timestamp)
          END
        ), 0) / 3600.0 as total_hours
        FROM "sessions" s
        WHERE s.status IN ('ended', 'terminated_idle', 'terminated_overuse')
          AND s."ended_at" >= ${priorStartTs}::timestamp
          AND s."ended_at" < ${priorEndTs}::timestamp
      `;
      priorTotalHours = Number(priorData[0]?.total_hours || 0);
    }

    // Generate comparison text
    let comparisonText: string;
    const delta = Math.round((totalHours - priorTotalHours) * 10) / 10;
    const deltaText =
      priorStart && priorEnd
        ? delta >= 0
          ? `up ${delta} hrs from prior period`
          : `down ${Math.abs(delta)} hrs from prior period`
        : '';

    switch (timeRange) {
      case '24H':
        comparisonText = `You served ${totalHours.toFixed(1)} GPU hours today`;
        break;
      case '7D':
        comparisonText = `You served ${totalHours.toFixed(1)} GPU hours this week, ${deltaText.toLowerCase()}`;
        break;
      case '30D':
        comparisonText = `You served ${totalHours.toFixed(1)} GPU hours this month, ${deltaText.toLowerCase()}`;
        break;
      case 'All':
      default:
        comparisonText = `You have served ${totalHours.toFixed(1)} GPU hours in total`;
    }

    // Generate period label
    let periodLabel: string;
    switch (timeRange) {
      case '24H':
        periodLabel = 'Today';
        break;
      case '7D':
        periodLabel = 'This Week';
        break;
      case '30D':
        periodLabel = 'This Month';
        break;
      case 'All':
      default:
        periodLabel = 'All Time';
    }

    return {
      dailyBreakdown,
      totalHours: Math.round(totalHours * 10) / 10,
      priorTotalHours: Math.round(priorTotalHours * 10) / 10,
      comparisonText,
      periodLabel,
    };
  }

  /**
   * Get active sessions breakdown by tier
   */
  async getActiveSessionsByTier(): Promise<ActiveSessionsResponse> {
    const activeSessions = await this.prisma.session.findMany({
      where: { status: 'running' },
      select: {
        computeConfig: {
          select: { name: true, gpuVramMb: true },
        },
      },
    });

    const totalCount = activeSessions.length;

    // Group by tier
    const byTierMap = new Map<string, number>();
    for (const session of activeSessions) {
      const tierName = `${session.computeConfig.name} (${session.computeConfig.gpuVramMb / 1024}GB)`;
      byTierMap.set(tierName, (byTierMap.get(tierName) || 0) + 1);
    }

    // Color mapping for tiers
    const colorMap: Record<string, string> = {
      Spark: '#71717a',
      Blaze: '#6366f1',
      Inferno: '#818cf8',
      Supernova: '#f59e0b',
    };

    const byTier = Array.from(byTierMap.entries()).map(([tierName, count]) => {
      const baseName = tierName.split(' ')[0];
      const color = colorMap[baseName] || '#6366f1';
      return {
        tierName,
        count,
        percentage: totalCount > 0 ? Math.round((count / totalCount) * 100) : 0,
        color,
      };
    });

    return {
      totalCount,
      byTier,
    };
  }

  /**
   * Get recent 5 wallet top-ups/credit additions
   */
  async getRecentTransactions(): Promise<RecentTransaction[]> {
    const transactions = await this.prisma.walletTransaction.findMany({
      where: {
        txnType: 'credit',
        referenceType: 'payment', // Only payment top-ups, not refunds or adjustments
      },
      take: 5,
      orderBy: { createdAt: 'desc' },
      include: {
        user: { select: { firstName: true, email: true } },
      },
    });

    return transactions.map((txn) => {
      // Format time to IST
      const istTime = new Date(txn.createdAt.getTime() + 5.5 * 60 * 60 * 1000);
      const hours = istTime.getUTCHours();
      const minutes = istTime.getUTCMinutes();
      const ampm = hours >= 12 ? 'PM' : 'AM';
      const formattedHours = hours % 12 || 12;
      const formattedMinutes = minutes.toString().padStart(2, '0');
      const time = `${formattedHours}:${formattedMinutes} ${ampm}`;

      const userName =
        txn.user.firstName || txn.user.email.split('@')[0];

      return {
        time,
        userName,
        userEmail: txn.user.email,
        amount: Number(txn.amountCents) / 100,
        type: 'compute' as const, // All are credit top-ups
        status: 'completed' as const, // Payment transactions are completed
      };
    });
  }

  /**
   * Get attention required metrics (time-independent, always current state)
   */
  async getAttentionRequiredData(): Promise<AttentionRequiredResponse> {
    const now = new Date();

    // 1. Low Balance Users: Count users with balance < ₹500 (50000 cents)
    const lowBalanceThresholdCents = 50000; // ₹500
    const lowBalanceUsers = await this.prisma.wallet.count({
      where: {
        balanceCents: { lt: BigInt(lowBalanceThresholdCents) },
      },
    });

    // 2. Support Backlog: Tickets open/in_progress > 12h
    const twelveHoursAgo = new Date(now.getTime() - 12 * 60 * 60 * 1000);
    const backlogTickets = await this.prisma.supportTicket.findMany({
      where: {
        status: { in: ['open', 'in_progress'] },
        createdAt: { lte: twelveHoursAgo },
      },
    });

    // Calculate average resolution time for all resolved tickets (all time)
    const resolvedTickets = await this.prisma.supportTicket.findMany({
      where: {
        status: { in: ['resolved', 'closed'] },
        resolvedAt: { not: null },
      },
      select: {
        createdAt: true,
        resolvedAt: true,
      },
    });

    let avgResolutionTime = 0;
    if (resolvedTickets.length > 0) {
      const totalResolutionSeconds = resolvedTickets.reduce((sum, ticket) => {
        if (ticket.resolvedAt) {
          return sum + (ticket.resolvedAt.getTime() - ticket.createdAt.getTime());
        }
        return sum;
      }, 0);
      avgResolutionTime = totalResolutionSeconds / resolvedTickets.length / (1000 * 60 * 60); // Convert to hours
    }

    // 3. Session Failures: Calculate failure rate for current week vs prior week
    const currentWeekStart = new Date(now);
    currentWeekStart.setHours(0, 0, 0, 0);
    currentWeekStart.setDate(currentWeekStart.getDate() - currentWeekStart.getDay()); // Start of this week (Sunday)

    const priorWeekStart = new Date(currentWeekStart);
    priorWeekStart.setDate(priorWeekStart.getDate() - 7);

    // Current week sessions
    const currentWeekSessions = await this.prisma.session.findMany({
      where: {
        startedAt: { gte: currentWeekStart },
      },
      select: {
        status: true,
      },
    });

    const currentWeekTotal = currentWeekSessions.length;
    const currentWeekFailed = currentWeekSessions.filter(
      (s) => s.status === 'failed' || s.status === 'terminated_overuse'
    ).length;
    const currentFailureRate = currentWeekTotal > 0 ? (currentWeekFailed / currentWeekTotal) * 100 : 0;

    // Prior week sessions
    const priorWeekSessions = await this.prisma.session.findMany({
      where: {
        startedAt: {
          gte: priorWeekStart,
          lt: currentWeekStart,
        },
      },
      select: {
        status: true,
      },
    });

    const priorWeekTotal = priorWeekSessions.length;
    const priorWeekFailed = priorWeekSessions.filter(
      (s) => s.status === 'failed' || s.status === 'terminated_overuse'
    ).length;
    const priorFailureRate = priorWeekTotal > 0 ? (priorWeekFailed / priorWeekTotal) * 100 : 0;

    return {
      lowBalanceUsers: {
        count: lowBalanceUsers,
        threshold: lowBalanceThresholdCents / 100, // Convert to rupees
        subtitle: 'May churn without top-up reminder',
      },
      supportBacklog: {
        count: backlogTickets.length,
        thresholdHours: 12,
        avgResolutionTime: Math.round(avgResolutionTime * 10) / 10, // Round to 1 decimal
        subtitle: `Avg resolution time: <span style="color: white; font-weight: 600;">${Math.round(avgResolutionTime * 10) / 10} hrs</span>`,
      },
      sessionFailures: {
        failureRate: Math.round(currentFailureRate * 10) / 10,
        priorWeekRate: Math.round(priorFailureRate * 10) / 10,
        subtitle: `Down from <span style="color: white; font-weight: 600;">${Math.round(priorFailureRate * 10) / 10}%</span> last week`,
      },
    };
  }

  // ------------------------------------------------------------------
  // Revenue Growth & Retention helpers
  // ------------------------------------------------------------------

  private static MONTH_SHORT = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /**
   * Generate the list of expected weekly buckets (IST Monday 00:00) for the
   * last `count` weeks (oldest → newest, including the current week).
   *
   * Each entry exposes:
   *  - key: "YYYY-MM-DD" matching the period_start returned by
   *    DATE_TRUNC('week', (col AT TIME ZONE 'UTC') AT TIME ZONE 'Asia/Kolkata')
   *  - label: e.g. "May 12"
   *  - queryStartUtc: the actual UTC moment of that IST Monday 00:00,
   *    suitable for a `created_at >= …` filter.
   */
  private computeExpectedWeeklyPeriods(
    now: Date,
    count: number,
  ): Array<{ key: string; label: string; queryStartUtc: Date }> {
    const nowIst = new Date(now.getTime() + this.IST_OFFSET_MS);
    const dayOfWeek = nowIst.getUTCDay(); // 0=Sun..6=Sat
    const daysFromMonday = dayOfWeek === 0 ? 6 : dayOfWeek - 1;

    const istMondayMs = Date.UTC(
      nowIst.getUTCFullYear(),
      nowIst.getUTCMonth(),
      nowIst.getUTCDate() - daysFromMonday,
      0, 0, 0, 0,
    );

    const periods: Array<{ key: string; label: string; queryStartUtc: Date }> = [];
    for (let i = count - 1; i >= 0; i--) {
      const startMs = istMondayMs - i * 7 * 24 * 60 * 60 * 1000;
      const d = new Date(startMs);
      const key = d.toISOString().slice(0, 10);
      const label = `${AnalyticsAdminService.MONTH_SHORT[d.getUTCMonth()]} ${d.getUTCDate()}`;
      periods.push({
        key,
        label,
        queryStartUtc: new Date(startMs - this.IST_OFFSET_MS),
      });
    }
    return periods;
  }

  /**
   * Generate the list of expected monthly buckets (IST 1st of month 00:00)
   * for the last `count` months (oldest → newest, including the current month).
   */
  private computeExpectedMonthlyPeriods(
    now: Date,
    count: number,
  ): Array<{ key: string; label: string; queryStartUtc: Date }> {
    const nowIst = new Date(now.getTime() + this.IST_OFFSET_MS);
    const baseYear = nowIst.getUTCFullYear();
    const baseMonth = nowIst.getUTCMonth();

    const periods: Array<{ key: string; label: string; queryStartUtc: Date }> = [];
    for (let i = count - 1; i >= 0; i--) {
      const startMs = Date.UTC(baseYear, baseMonth - i, 1, 0, 0, 0, 0);
      const d = new Date(startMs);
      const key = d.toISOString().slice(0, 10);
      const label = AnalyticsAdminService.MONTH_SHORT[d.getUTCMonth()];
      periods.push({
        key,
        label,
        queryStartUtc: new Date(startMs - this.IST_OFFSET_MS),
      });
    }
    return periods;
  }

  /**
   * Net Revenue Retention (NRR): Measures whether EXISTING users are spending
   * more or less over time by comparing the same cohort's spend across adjacent
   * periods. Weekly (last 6 weeks) for 24H/7D, monthly (last 6 months) for 30D/All.
   */
  async getNetRevenueRetention(timeRange: string): Promise<NrrResponse> {
    const isMonthly = timeRange === '30D' || timeRange === 'All';
    const periodCount = 6;

    const now = new Date();
    const expectedPeriods = isMonthly
      ? this.computeExpectedMonthlyPeriods(now, periodCount)
      : this.computeExpectedWeeklyPeriods(now, periodCount);

    if (expectedPeriods.length === 0) {
      return { periods: [], currentNrrPct: null, avgNrrPct: 0 };
    }

    // Use the same plain-UTC-string pattern as existing methods to avoid
    // session-timezone shifts when comparing against `timestamp` columns.
    const queryStartTs = expectedPeriods[0].queryStartUtc
      .toISOString()
      .replace('Z', '');

    const truncFn = isMonthly ? 'month' : 'week';

    type Row = {
      period_start: Date;
      user_id: string;
      user_revenue: bigint | null;
    };

    const rows: Row[] = await this.prisma.$queryRaw<Row[]>`
      SELECT
        DATE_TRUNC(${truncFn}, ("created_at" AT TIME ZONE 'UTC') AT TIME ZONE 'Asia/Kolkata') AS period_start,
        "user_id" AS user_id,
        SUM("amount_cents")::bigint AS user_revenue
      FROM "billing_charges"
      WHERE "created_at" >= ${queryStartTs}::timestamp
      GROUP BY 1, 2
      ORDER BY 1 ASC
    `;

    // Build Map<periodKey, Map<userId, revenueCents>>
    const periodUserRevenue = new Map<string, Map<string, number>>();
    for (const row of rows) {
      if (!row.period_start || !row.user_id) continue;
      const key = new Date(row.period_start).toISOString().slice(0, 10);
      let userMap = periodUserRevenue.get(key);
      if (!userMap) {
        userMap = new Map<string, number>();
        periodUserRevenue.set(key, userMap);
      }
      userMap.set(
        row.user_id,
        (userMap.get(row.user_id) || 0) + Number(row.user_revenue ?? 0),
      );
    }

    // Build NRR periods by comparing adjacent periods
    const periods: NrrPeriod[] = [];
    for (let i = 0; i < expectedPeriods.length; i++) {
      const exp = expectedPeriods[i];
      const currUserMap = periodUserRevenue.get(exp.key) || new Map<string, number>();
      const cohortSize = currUserMap.size;
      const cohortRevenueCents = Array.from(currUserMap.values()).reduce((a, b) => a + b, 0);

      if (i === 0) {
        // First period — no prior to compare
        periods.push({
          label: exp.label,
          nrrPct: null,
          expandedUsers: 0,
          contractedUsers: 0,
          cohortSize,
          cohortRevenueCents,
        });
        continue;
      }

      // Prior period's user map
      const priorExp = expectedPeriods[i - 1];
      const priorUserMap = periodUserRevenue.get(priorExp.key) || new Map<string, number>();

      // The "cohort" is users who were active in the PRIOR period
      let priorRevenueCents = 0;
      let currentRevenueCents = 0;
      let expandedUsers = 0;
      let contractedUsers = 0;

      for (const [userId, priorSpend] of priorUserMap) {
        priorRevenueCents += priorSpend;
        const currentSpend = currUserMap.get(userId) || 0;
        currentRevenueCents += currentSpend;

        if (currentSpend > priorSpend) {
          expandedUsers++;
        } else if (currentSpend < priorSpend) {
          contractedUsers++;
        }
      }

      // NRR = (same users' revenue in N+1) / (same users' revenue in N) × 100
      let nrrPct: number | null = null;
      if (priorRevenueCents > 0) {
        nrrPct = Math.round((currentRevenueCents / priorRevenueCents) * 100 * 100) / 100;
      } else {
        nrrPct = 0;
      }

      periods.push({
        label: exp.label,
        nrrPct,
        expandedUsers,
        contractedUsers,
        cohortSize,
        cohortRevenueCents,
      });
    }

    // Latest non-null NRR
    const currentNrrPct =
      periods.length > 0 ? periods[periods.length - 1].nrrPct : null;

    // Average of all non-null NRR values
    const validNrrs = periods
      .map((p) => p.nrrPct)
      .filter((n): n is number => n !== null);
    const avgNrrPct =
      validNrrs.length > 0
        ? Math.round(
            (validNrrs.reduce((a, b) => a + b, 0) / validNrrs.length) * 100,
          ) / 100
        : 0;

    return { periods, currentNrrPct, avgNrrPct };
  }

  /**
   * Retention: distinct non-admin users with at least one session per period,
   * compared across adjacent periods to derive retention/new/churn counts.
   * Weekly (last 8 weeks) for 24H/7D, monthly (last 6 months) for 30D/All.
   */
  async getRetentionData(timeRange: string): Promise<RetentionResponse> {
    const isMonthly = timeRange === '30D' || timeRange === 'All';
    const periodCount = isMonthly ? 6 : 8;

    const now = new Date();
    const expectedPeriods = isMonthly
      ? this.computeExpectedMonthlyPeriods(now, periodCount)
      : this.computeExpectedWeeklyPeriods(now, periodCount);

    if (expectedPeriods.length === 0) {
      return { periods: [], currentRetentionPct: null, avgRetentionPct: 0 };
    }

    const queryStartTs = expectedPeriods[0].queryStartUtc
      .toISOString()
      .replace('Z', '');

    type Row = { period_start: Date; user_id: string };

    const rows: Row[] = isMonthly
      ? await this.prisma.$queryRaw<Row[]>`
          SELECT DISTINCT
            DATE_TRUNC('month', (s."started_at" AT TIME ZONE 'UTC') AT TIME ZONE 'Asia/Kolkata') AS period_start,
            s."user_id" AS user_id
          FROM "sessions" s
          JOIN "user_org_roles" uor ON s."user_id" = uor."user_id"
          JOIN "roles" r ON uor."role_id" = r."id"
          WHERE s."status" IN ('ended', 'terminated_idle', 'terminated_overuse', 'running')
            AND s."started_at" >= ${queryStartTs}::timestamp
            AND r."name" NOT IN ('business_lead', 'it_admin', 'super_admin', 'org_admin')
        `
      : await this.prisma.$queryRaw<Row[]>`
          SELECT DISTINCT
            DATE_TRUNC('week', (s."started_at" AT TIME ZONE 'UTC') AT TIME ZONE 'Asia/Kolkata') AS period_start,
            s."user_id" AS user_id
          FROM "sessions" s
          JOIN "user_org_roles" uor ON s."user_id" = uor."user_id"
          JOIN "roles" r ON uor."role_id" = r."id"
          WHERE s."status" IN ('ended', 'terminated_idle', 'terminated_overuse', 'running')
            AND s."started_at" >= ${queryStartTs}::timestamp
            AND r."name" NOT IN ('business_lead', 'it_admin', 'super_admin', 'org_admin')
        `;

    // Map: periodKey -> Set<userId>
    const userSets = new Map<string, Set<string>>();
    for (const row of rows) {
      if (!row.period_start || !row.user_id) continue;
      const key = new Date(row.period_start).toISOString().slice(0, 10);
      let set = userSets.get(key);
      if (!set) {
        set = new Set<string>();
        userSets.set(key, set);
      }
      set.add(row.user_id);
    }

    const periods: RetentionPeriod[] = [];
    let prevSet: Set<string> | null = null;
    for (const exp of expectedPeriods) {
      const currSet = userSets.get(exp.key) || new Set<string>();

      let retainedUsers = 0;
      let newUsers = 0;
      let churnedUsers = 0;
      let retentionPct: number | null = null;

      if (prevSet !== null) {
        for (const u of currSet) {
          if (prevSet.has(u)) retainedUsers++;
          else newUsers++;
        }
        for (const u of prevSet) {
          if (!currSet.has(u)) churnedUsers++;
        }
        retentionPct =
          prevSet.size > 0
            ? Math.round((retainedUsers / prevSet.size) * 100 * 100) / 100
            : null;
      }

      periods.push({
        label: exp.label,
        activeUsers: currSet.size,
        retainedUsers,
        retentionPct,
        newUsers,
        churnedUsers,
      });
      prevSet = currSet;
    }

    const currentRetentionPct =
      periods.length > 0 ? periods[periods.length - 1].retentionPct : null;

    const validRetentions = periods
      .map((p) => p.retentionPct)
      .filter((r): r is number => r !== null);
    const avgRetentionPct =
      validRetentions.length > 0
        ? Math.round(
            (validRetentions.reduce((a, b) => a + b, 0) /
              validRetentions.length) *
              100,
          ) / 100
        : 0;

    return { periods, currentRetentionPct, avgRetentionPct };
  }
}
