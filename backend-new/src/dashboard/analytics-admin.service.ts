import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

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

    // --- Active Users ---
    // Total active users in the system (not period-filtered)
    const activeUsers = await this.prisma.user.count({
      where: { isActive: true },
    });

    // CDC: compare active user count now vs users who existed before the period
    // i.e., how many new users joined during this period
    const usersBeforePeriod = await this.prisma.user.count({
      where: { isActive: true, createdAt: { lt: periodStart } },
    });
    const activeUsersChangePct =
      usersBeforePeriod > 0
        ? ((activeUsers - usersBeforePeriod) / usersBeforePeriod) * 100
        : 0;

    const liveSessions = await this.prisma.session.count({
      where: { status: 'running' },
    });

    const newUsers = await this.prisma.user.count({
      where: { createdAt: { gte: periodStart } },
    });

    let priorNewUsers = 0;
    if (priorStart && priorEnd) {
      priorNewUsers = await this.prisma.user.count({
        where: { createdAt: { gte: priorStart, lt: priorEnd } },
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

    // Also include running sessions' elapsed time (startedAt to now)
    const runningSessions = await this.prisma.session.findMany({
      where: {
        status: 'running',
        startedAt: { not: null },
      },
      select: { startedAt: true },
    });
    const runningElapsedSeconds = runningSessions.reduce((sum, s) => {
      if (!s.startedAt) return sum;
      return sum + Math.floor((now.getTime() - s.startedAt.getTime()) / 1000);
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
