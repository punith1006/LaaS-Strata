import { Injectable, NotFoundException, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

export interface RequestEntry {
  id: string;
  userName: string;
  domain: string;
  serviceType: string;
  durationMinutes: number;
  earningsCents: number;
  createdAt: string;
}

export interface UpcomingEntry {
  id: string;
  userName: string;
  domain: string;
  serviceType: string;
  durationMinutes: number;
  fromTime: string;
  toTime: string;
  date: string;
  earningsCents: number;
}

export interface LiveSessionEntry {
  id: string;
  userName: string;
  domain: string;
  serviceType: string;
  startedAt: string;
  earningsCents: number;
}

export interface PastEntry {
  id: string;
  userName: string;
  domain: string;
  serviceType: string;
  durationMinutes: number;
  earningsCents: number;
  createdAt: string;
  status: 'Expired' | 'Approved' | 'Rejected' | 'Completed' | 'Cancelled' | 'Missed' | 'Rescheduled' | 'Disputed';
}

export interface CalendarEvent {
  id: string;
  title: string;
  start: string;
  end: string;
  status: string;
  domain: string;
  serviceType: string;
  durationMinutes: number;
  earningsCents: number;
  userName: string;
}

export interface MentorBillingStats {
  totalEarningsCents: number;
  sessionsCompleted: number;
  mentoringHoursTotal: number;
  avgEarningsPerSessionCents: number;
  completionRate: number;
  effectiveHourlyRateCents: number;
  dailyEarnings: { date: string; earningsCents: number }[];
  dailyHours: { dayName: string; hours: number }[];
}

@Injectable()
export class MentorSessionsService {
  private readonly logger = new Logger(MentorSessionsService.name);

  constructor(private prisma: PrismaService) {}

  private async findMentorProfile(userId: string) {
    const profile = await this.prisma.mentorProfile.findUnique({
      where: { userId },
    });
    if (!profile) {
      throw new NotFoundException('Mentor profile not found for this user');
    }
    return profile;
  }

  /** Get pending session requests (status: pending) */
  async getRequests(userId: string): Promise<RequestEntry[]> {
    const profile = await this.findMentorProfile(userId);

    const sessions = await this.prisma.mentorSession.findMany({
      where: {
        mentorProfileId: profile.id,
        status: 'pending',
      },
      include: {
        student: {
          select: { firstName: true, lastName: true },
        },
      },
      orderBy: { requestedAt: 'desc' },
    });

    return sessions.map((s) => ({
      id: s.id,
      userName: `${s.student.firstName || ''} ${s.student.lastName || ''}`.trim() || 'Unknown',
      domain: s.domain,
      serviceType: s.serviceType,
      durationMinutes: s.durationMinutes,
      earningsCents: s.earningsCents,
      createdAt: s.requestedAt.toISOString(),
    }));
  }

  /** Get upcoming sessions (status: scheduled) */
  async getUpcoming(userId: string): Promise<UpcomingEntry[]> {
    const profile = await this.findMentorProfile(userId);

    const sessions = await this.prisma.mentorSession.findMany({
      where: {
        mentorProfileId: profile.id,
        status: 'scheduled',
      },
      include: {
        student: {
          select: { firstName: true, lastName: true },
        },
      },
      orderBy: [{ scheduledFrom: 'asc' }],
    });

    return sessions.map((s) => {
      const fromDate = s.scheduledFrom ? new Date(s.scheduledFrom) : new Date();
      const toDate = s.scheduledTo ? new Date(s.scheduledTo) : new Date();
      const fromTime = `${String(fromDate.getHours()).padStart(2, '0')}:${String(fromDate.getMinutes()).padStart(2, '0')}`;
      const toTime = `${String(toDate.getHours()).padStart(2, '0')}:${String(toDate.getMinutes()).padStart(2, '0')}`;
      const dateStr = fromDate.toLocaleDateString('en-IN', {
        day: '2-digit',
        month: 'short',
        year: 'numeric',
      });

      return {
        id: s.id,
        userName: `${s.student.firstName || ''} ${s.student.lastName || ''}`.trim() || 'Unknown',
        domain: s.domain,
        serviceType: s.serviceType,
        durationMinutes: s.durationMinutes,
        fromTime,
        toTime,
        date: dateStr,
        earningsCents: s.earningsCents,
      };
    });
  }

  /** Get live sessions (status: live) */
  async getLive(userId: string): Promise<LiveSessionEntry[]> {
    const profile = await this.findMentorProfile(userId);

    const sessions = await this.prisma.mentorSession.findMany({
      where: {
        mentorProfileId: profile.id,
        status: 'live',
      },
      include: {
        student: {
          select: { firstName: true, lastName: true },
        },
      },
      orderBy: { startedAt: 'desc' },
    });

    return sessions.map((s) => ({
      id: s.id,
      userName: `${s.student.firstName || ''} ${s.student.lastName || ''}`.trim() || 'Unknown',
      domain: s.domain,
      serviceType: s.serviceType,
      startedAt: (s.startedAt || s.requestedAt).toISOString(),
      earningsCents: s.earningsCents,
    }));
  }

  /** Get past sessions (all terminal statuses) */
  async getPast(userId: string): Promise<PastEntry[]> {
    const profile = await this.findMentorProfile(userId);

    const terminalStatuses = ['completed', 'cancelled', 'rejected', 'request_expired', 'missed', 'disputed'] as const;

    const sessions = await (this.prisma.mentorSession.findMany as any)({
      where: {
        mentorProfileId: profile.id,
        status: { in: terminalStatuses },
      },
      include: {
        student: {
          select: { firstName: true, lastName: true },
        },
      },
      orderBy: { updatedAt: 'desc' },
    });

    const statusMap: Record<string, PastEntry['status']> = {
      completed: 'Completed',
      cancelled: 'Cancelled',
      rejected: 'Rejected',
      request_expired: 'Expired',
      missed: 'Missed',
      disputed: 'Disputed',
    };

    return sessions.map((s) => ({
      id: s.id,
      userName: `${s.student.firstName || ''} ${s.student.lastName || ''}`.trim() || 'Unknown',
      domain: s.domain,
      serviceType: s.serviceType,
      durationMinutes: s.durationMinutes,
      earningsCents: s.earningsCents,
      createdAt: s.createdAt.toISOString(),
      status: statusMap[s.status] || 'Completed',
    }));
  }

  /** Get all sessions for calendar view (scheduled, live, and past with start/end times) */
  async getCalendar(userId: string): Promise<CalendarEvent[]> {
    const profile = await this.findMentorProfile(userId);

    // Fetch sessions that have scheduled times (exclude pending/request_expired/rejected without times)
    const statuses = ['scheduled', 'live', 'completed', 'cancelled', 'missed', 'rescheduled'];

    const sessions = await (this.prisma.mentorSession.findMany as any)({
      where: {
        mentorProfileId: profile.id,
        status: { in: statuses },
        scheduledFrom: { not: null },
        scheduledTo: { not: null },
      },
      include: {
        student: {
          select: { firstName: true, lastName: true },
        },
      },
      orderBy: { scheduledFrom: 'asc' },
    });

    return sessions
      .filter((s: any) => s.scheduledFrom && s.scheduledTo)
      .map((s: any) => {
        const studentName = `${s.student.firstName || ''} ${s.student.lastName || ''}`.trim() || 'Unknown';
        return {
          id: s.id,
          title: `${studentName} — ${s.domain}`,
          start: new Date(s.scheduledFrom).toISOString(),
          end: new Date(s.scheduledTo).toISOString(),
        status: s.status,
        domain: s.domain,
        serviceType: s.serviceType,
        durationMinutes: s.durationMinutes,
        earningsCents: s.earningsCents,
        userName: studentName,
      };
    });
  }

  /** Approve a pending session request */
  async approveSession(userId: string, sessionId: string) {
    const profile = await this.findMentorProfile(userId);

    const session = await this.prisma.mentorSession.findFirst({
      where: { id: sessionId, mentorProfileId: profile.id, status: 'pending' },
    });
    if (!session) throw new NotFoundException('Pending session request not found');

    const now = new Date();
    const scheduledFrom = now;
    const scheduledTo = new Date(now.getTime() + session.durationMinutes * 60 * 1000);

    await this.prisma.$transaction(async (tx) => {
      await tx.mentorSession.update({
        where: { id: sessionId },
        data: {
          status: 'scheduled',
          approvedAt: now,
          scheduledFrom,
          scheduledTo,
          updatedBy: userId,
        },
      });

      await tx.mentorSessionStatusHistory.create({
        data: {
          mentorSessionId: sessionId,
          fromStatus: 'pending',
          toStatus: 'scheduled',
          changedBy: userId,
          reason: 'Mentor approved session request',
        },
      });
    });

    return { success: true };
  }

  /** Reject a pending session request */
  async rejectSession(userId: string, sessionId: string, reason?: string) {
    const profile = await this.findMentorProfile(userId);

    const session = await this.prisma.mentorSession.findFirst({
      where: { id: sessionId, mentorProfileId: profile.id, status: 'pending' },
    });
    if (!session) throw new NotFoundException('Pending session request not found');

    await this.prisma.$transaction(async (tx) => {
      await tx.mentorSession.update({
        where: { id: sessionId },
        data: {
          status: 'rejected',
          cancelReason: reason || null,
          updatedBy: userId,
        },
      });

      await tx.mentorSessionStatusHistory.create({
        data: {
          mentorSessionId: sessionId,
          fromStatus: 'pending',
          toStatus: 'rejected',
          changedBy: userId,
          reason: reason || 'Mentor rejected session request',
        },
      });
    });

    return { success: true };
  }

  /** Cancel an upcoming session */
  async cancelSession(userId: string, sessionId: string, reason?: string) {
    const profile = await this.findMentorProfile(userId);

    const session = await this.prisma.mentorSession.findFirst({
      where: { id: sessionId, mentorProfileId: profile.id, status: 'scheduled' },
    });
    if (!session) throw new NotFoundException('Scheduled session not found');

    await this.prisma.$transaction(async (tx) => {
      await tx.mentorSession.update({
        where: { id: sessionId },
        data: {
          status: 'cancelled',
          cancelReason: reason || null,
          updatedBy: userId,
        },
      });

      await tx.mentorSessionStatusHistory.create({
        data: {
          mentorSessionId: sessionId,
          fromStatus: 'scheduled',
          toStatus: 'cancelled',
          changedBy: userId,
          reason: reason || 'Mentor cancelled session',
        },
      });
    });

    return { success: true };
  }

  /** Get mentor billing stats (earnings, sessions, hours, daily breakdowns) */
  async getMentorBillingStats(userId: string): Promise<MentorBillingStats> {
    const profile = await this.findMentorProfile(userId);

    // Aggregate totals from completed sessions
    const completedAgg = await this.prisma.mentorSession.aggregate({
      where: { mentorProfileId: profile.id, status: 'completed' },
      _sum: { earningsCents: true, durationMinutes: true },
      _count: true,
    });

    const totalEarningsCents = completedAgg._sum.earningsCents ?? 0;
    const sessionsCompleted = completedAgg._count;
    const totalMinutes = completedAgg._sum.durationMinutes ?? 0;
    const mentoringHoursTotal = Math.round((totalMinutes / 60) * 100) / 100;
    const avgEarningsPerSessionCents =
      sessionsCompleted > 0 ? Math.round(totalEarningsCents / sessionsCompleted) : 0;

    // Completion rate: completed / (completed + cancelled + missed)
    const terminalStatuses = await this.prisma.mentorSession.groupBy({
      by: ['status'],
      where: {
        mentorProfileId: profile.id,
        status: { in: ['completed', 'cancelled', 'missed'] },
      },
      _count: true,
    });
    const completedCount =
      terminalStatuses.find((g) => g.status === 'completed')?._count ?? 0;
    const totalTerminal = terminalStatuses.reduce((s, g) => s + g._count, 0);
    const completionRate =
      totalTerminal > 0 ? Math.round((completedCount / totalTerminal) * 100) : 0;

    // Daily earnings — last 30 days grouped by IST date
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
    thirtyDaysAgo.setHours(0, 0, 0, 0);

    const dailyRows: { date: string; earnings_cents: number }[] =
      await this.prisma.$queryRaw`
        SELECT
          TO_CHAR(DATE(scheduled_from AT TIME ZONE 'Asia/Kolkata'), 'YYYY-MM-DD') AS date,
          COALESCE(SUM(earnings_cents), 0)::int AS earnings_cents
        FROM mentor_sessions
        WHERE mentor_profile_id = ${profile.id}::uuid
          AND status = 'completed'
          AND scheduled_from >= ${thirtyDaysAgo}
        GROUP BY DATE(scheduled_from AT TIME ZONE 'Asia/Kolkata')
        ORDER BY date ASC
      `;

    const dailyEarnings = dailyRows.map((r) => ({
      date: r.date,
      earningsCents: r.earnings_cents,
    }));

    // Daily hours — last 30 days grouped by day-of-week name
    const hourRows: { dow: number; total_minutes: number }[] =
      await this.prisma.$queryRaw`
        SELECT
          EXTRACT(ISODOW FROM scheduled_from AT TIME ZONE 'Asia/Kolkata')::int AS dow,
          COALESCE(SUM(duration_minutes), 0)::int AS total_minutes
        FROM mentor_sessions
        WHERE mentor_profile_id = ${profile.id}::uuid
          AND status = 'completed'
          AND scheduled_from >= ${thirtyDaysAgo}
        GROUP BY EXTRACT(ISODOW FROM scheduled_from AT TIME ZONE 'Asia/Kolkata')
        ORDER BY dow ASC
      `;

    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const dailyHours = dayNames.map((name, idx) => {
      const row = hourRows.find((r) => r.dow === idx + 1);
      return {
        dayName: name,
        hours: row ? Math.round((row.total_minutes / 60) * 100) / 100 : 0,
      };
    });

    return {
      totalEarningsCents,
      sessionsCompleted,
      mentoringHoursTotal,
      avgEarningsPerSessionCents,
      completionRate,
      effectiveHourlyRateCents:
        totalMinutes > 0 ? Math.round(totalEarningsCents / (totalMinutes / 60)) : 0,
      dailyEarnings,
      dailyHours,
    };
  }

  /** Explore mentors with search and filters */
  async exploreMentors(query: {
    search?: string;
    domains?: string[];
    expertise?: string[];
    page?: number;
    limit?: number;
  }) {
    const { search, domains, expertise, page = 1, limit = 10 } = query;
    const skip = (page - 1) * limit;

    const where: any = {
      isAvailable: true,
    };

    // Search by name, headline, or bio
    if (search && search.trim()) {
      const searchTerm = search.trim();
      where.OR = [
        { headline: { contains: searchTerm, mode: 'insensitive' } },
        { bio: { contains: searchTerm, mode: 'insensitive' } },
        { user: { firstName: { contains: searchTerm, mode: 'insensitive' } } },
        { user: { lastName: { contains: searchTerm, mode: 'insensitive' } } },
      ];
    }

    // Filter by service domain (expertiseAreas contains any)
    if (domains && domains.length > 0) {
      where.expertiseAreas = { hasSome: domains };
    }

    // Filter by expertise level (mapped from experienceYears)
    if (expertise && expertise.length > 0) {
      const yearFilters: any[] = [];
      for (const level of expertise) {
        switch (level.toLowerCase()) {
          case 'entry level':
            yearFilters.push({ experienceYears: { lte: 3 } });
            break;
          case 'intermediate':
            yearFilters.push({ experienceYears: { gte: 4, lte: 7 } });
            break;
          case 'senior':
            yearFilters.push({ experienceYears: { gte: 8 } });
            break;
        }
      }
      if (yearFilters.length > 0) {
        where.AND = where.AND ? [...where.AND, { OR: yearFilters }] : [{ OR: yearFilters }];
      }
    }

    const [profiles, total] = await Promise.all([
      this.prisma.mentorProfile.findMany({
        where,
        include: {
          user: {
            select: {
              id: true,
              firstName: true,
              lastName: true,
              email: true,
            },
          },
          _count: {
            select: {
              mentorSessions: {
                where: { status: 'completed' },
              },
            },
          },
        },
        orderBy: { avgRating: 'desc' },
        skip,
        take: limit,
      }),
      this.prisma.mentorProfile.count({ where }),
    ]);

    return {
      mentors: profiles.map((p) => ({
        id: p.id,
        userId: p.userId,
        name: `${p.user.firstName || ''} ${p.user.lastName || ''}`.trim() || 'Unknown',
        headline: p.headline,
        expertiseAreas: p.expertiseAreas,
        experienceYears: p.experienceYears,
        pricePerHourCents: p.pricePerHourCents,
        currency: p.currency,
        avgRating: Number(p.avgRating) || 0,
        totalReviews: p.totalReviews,
        totalSessions: p._count.mentorSessions,
        isAvailable: p.isAvailable,
        country: p.country,
        company: p.company,
        professionalRole: p.professionalRole,
      })),
      total,
      totalPages: Math.ceil(total / limit),
    };
  }

  /** Get detailed mentor profile for public view */
  async getMentorProfile(mentorProfileId: string) {
    const profile = await this.prisma.mentorProfile.findUnique({
      where: { id: mentorProfileId },
      include: {
        user: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            lastLoginAt: true,
          },
        },
      },
    });

    if (!profile) {
      throw new NotFoundException('Mentor profile not found');
    }

    const userProfile = await this.prisma.userProfile.findUnique({
      where: { userId: profile.userId },
      select: {
        skills: true,
        githubUrl: true,
        linkedinUrl: true,
        websiteUrl: true,
        xUrl: true,
        substackUrl: true,
        bio: true,
      },
    });

    const completedSessions = await this.prisma.mentorSession.findMany({
      where: {
        mentorProfileId: profile.id,
        status: 'completed',
      },
      select: {
        durationMinutes: true,
      },
    });

    const totalMentoringMinutes = completedSessions.reduce(
      (sum, s) => sum + s.durationMinutes,
      0,
    );

    const totalSessions = completedSessions.length;

    return {
      id: profile.id,
      userId: profile.userId,
      name: `${profile.user.firstName || ''} ${profile.user.lastName || ''}`.trim() || 'Unknown',
      headline: profile.headline,
      bio: profile.bio || userProfile?.bio || null,
      company: profile.company,
      professionalRole: profile.professionalRole,
      country: profile.country,
      expertiseAreas: profile.expertiseAreas,
      languages: profile.languages,
      experienceYears: profile.experienceYears,
      pricePerHourCents: profile.pricePerHourCents,
      currency: profile.currency,
      avgRating: Number(profile.avgRating) || 0,
      totalReviews: profile.totalReviews,
      totalSessions,
      totalMentoringMinutes,
      isAvailable: profile.isAvailable,
      lastLoginAt: profile.user.lastLoginAt,
      skills: userProfile?.skills || [],
      githubUrl: userProfile?.githubUrl || null,
      linkedinUrl: userProfile?.linkedinUrl || null,
      websiteUrl: userProfile?.websiteUrl || null,
      xUrl: userProfile?.xUrl || null,
      substackUrl: userProfile?.substackUrl || null,
    };
  }
}
