import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

export interface RevenueChartResponse {
  series: Array<{ time: number; value: number }>;
  ohlc: { open: number; high: number; low: number; close: number };
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
  };
}

@Injectable()
export class AnalyticsAdminService {
  constructor(private prisma: PrismaService) {}

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
    // Ended sessions in current period
    const gpuData = await this.prisma.session.aggregate({
      _sum: { durationSeconds: true },
      _avg: { durationSeconds: true },
      _count: true,
      where: {
        status: { in: ['ended', 'terminated_idle', 'terminated_overuse'] },
        endedAt: { gte: periodStart },
      },
    });

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
      const priorGpuData = await this.prisma.session.aggregate({
        _sum: { durationSeconds: true },
        where: {
          status: { in: ['ended', 'terminated_idle', 'terminated_overuse'] },
          endedAt: { gte: priorStart, lt: priorEnd },
        },
      });
      priorGpuTotalSeconds = priorGpuData._sum.durationSeconds ?? 0;
    }

    const endedGpuSeconds = gpuData._sum.durationSeconds ?? 0;
    const gpuTotalSeconds = endedGpuSeconds + runningElapsedSeconds;
    const totalSessionCount = gpuData._count + runningSessions.length;
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
      },
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
      periodStart = bounds.periodStart;
    }

    // Step 2: Query hourly aggregates
    // Get charges grouped by UTC hour, then we'll handle IST alignment in TypeScript
    const rows = await this.prisma.$queryRaw<
      Array<{ time: number; total_cents: bigint }>
    >`
      SELECT
        EXTRACT(EPOCH FROM DATE_TRUNC('hour', "created_at"))::int as time,
        SUM("amount_cents")::bigint as total_cents
      FROM "billing_charges"
      WHERE "created_at" >= ${periodStart}
      GROUP BY DATE_TRUNC('hour', "created_at")
      ORDER BY 1 ASC
    `;

    // Build a map of UTC epoch -> value in rupees
    const dataMap = new Map<number, number>();
    for (const row of rows) {
      dataMap.set(Number(row.time), Number(row.total_cents) / 100);
    }

    // Step 3: Fill gaps with zeros — generate complete hourly series in UTC
    // Then convert to IST for display alignment
    const startEpoch = Math.floor(periodStart.getTime() / 1000);
    const endEpoch = Math.floor(now.getTime() / 1000);
    const hourSeconds = 3600;

    // Align start to the beginning of the UTC hour
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

    if (aggregatedSeries.length === 0) {
      return emptyResponse;
    }

    // Trim trailing zero buckets (current incomplete bucket has no revenue yet)
    while (
      aggregatedSeries.length > 1 &&
      aggregatedSeries[aggregatedSeries.length - 1].value === 0
    ) {
      aggregatedSeries.pop();
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
    const currentRate =
      nonZeroValues.length > 0 ? nonZeroValues[nonZeroValues.length - 1] : 0;
    const rateChange = Math.round((currentRate - open) * 100) / 100;
    const rateChangePct =
      open > 0
        ? Math.round(((currentRate - open) / open) * 100 * 100) / 100
        : 0;

    return {
      series: aggregatedSeries,
      ohlc: { open, high, low, close },
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
    switch (timeRange) {
      case '24H': {
        const periodStart = new Date(now.getTime() - 24 * 60 * 60 * 1000);
        const priorStart = new Date(now.getTime() - 48 * 60 * 60 * 1000);
        return {
          periodStart,
          priorStart,
          priorEnd: periodStart,
          daysInPeriod: 1,
          subtitleContext: 'vs yesterday',
        };
      }
      case '7D': {
        const periodStart = new Date(
          now.getTime() - 7 * 24 * 60 * 60 * 1000,
        );
        const priorStart = new Date(
          now.getTime() - 14 * 24 * 60 * 60 * 1000,
        );
        return {
          periodStart,
          priorStart,
          priorEnd: periodStart,
          daysInPeriod: 7,
          subtitleContext: 'vs prior week',
        };
      }
      case '30D': {
        const periodStart = new Date(
          now.getTime() - 30 * 24 * 60 * 60 * 1000,
        );
        const priorStart = new Date(
          now.getTime() - 60 * 24 * 60 * 60 * 1000,
        );
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
        const periodStart = new Date(0); // epoch
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
}
