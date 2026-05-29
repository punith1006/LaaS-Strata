import { Injectable, NotFoundException, BadRequestException, ConflictException, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { MailService } from '../mail/mail.service';
import { AuditService } from '../audit/audit.service';
import * as fs from 'fs';
import * as path from 'path';
import { randomUUID } from 'crypto';

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

  constructor(
    private prisma: PrismaService,
    private mailService: MailService,
    private auditService: AuditService,
  ) {}

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

    // Audit log
    const student = await this.prisma.user.findUnique({ where: { id: session.studentUserId }, select: { firstName: true, lastName: true } });
    this.auditService.log({
      userId,
      action: 'mentoring.session_approved',
      category: 'mentoring',
      status: 'success',
      details: { sessionId, studentName: `${student?.firstName || ''} ${student?.lastName || ''}`.trim(), domain: session.domain, serviceType: session.serviceType },
    }).catch(err => this.logger.error('Audit log failed for session approve', err));

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

    // Audit log
    const student = await this.prisma.user.findUnique({ where: { id: session.studentUserId }, select: { firstName: true, lastName: true } });
    this.auditService.log({
      userId,
      action: 'mentoring.session_rejected',
      category: 'mentoring',
      status: 'success',
      details: { sessionId, studentName: `${student?.firstName || ''} ${student?.lastName || ''}`.trim(), reason: reason || 'Mentor rejected session request' },
    }).catch(err => this.logger.error('Audit log failed for session reject', err));

    return { success: true };
  }

  /** Cancel an upcoming session (mentor side) */
  async cancelSession(userId: string, sessionId: string, reason?: string) {
    const profile = await this.findMentorProfile(userId);

    const session = await this.prisma.mentorSession.findFirst({
      where: { id: sessionId, mentorProfileId: profile.id, status: 'scheduled' },
    });
    if (!session) throw new NotFoundException('Scheduled session not found');

    await this.executeCancel(session, userId, reason || 'Mentor cancelled session');

    // Audit log
    const student = await this.prisma.user.findUnique({ where: { id: session.studentUserId }, select: { firstName: true, lastName: true } });
    this.auditService.log({
      userId,
      action: 'mentoring.session_cancelled',
      category: 'mentoring',
      status: 'success',
      details: { sessionId, studentName: `${student?.firstName || ''} ${student?.lastName || ''}`.trim(), reason: reason || 'Mentor cancelled session' },
    }).catch(err => this.logger.error('Audit log failed for mentor cancel', err));

    return { success: true };
  }

  /** Cancel an upcoming session (student side) */
  async studentCancelSession(userId: string, sessionId: string, reason?: string) {
    const session = await this.prisma.mentorSession.findFirst({
      where: { id: sessionId, studentUserId: userId, status: 'scheduled' },
    });
    if (!session) throw new NotFoundException('Scheduled session not found');

    await this.executeCancel(session, userId, reason || 'Student cancelled session');

    // Audit log
    const mentorProfile = await this.prisma.mentorProfile.findUnique({
      where: { id: session.mentorProfileId },
      include: { user: { select: { firstName: true, lastName: true } } },
    });
    this.auditService.log({
      userId,
      action: 'mentoring.session_cancelled',
      category: 'mentoring',
      status: 'success',
      details: { sessionId, mentorName: `${mentorProfile?.user.firstName || ''} ${mentorProfile?.user.lastName || ''}`.trim(), reason: reason || 'Student cancelled session' },
    }).catch(err => this.logger.error('Audit log failed for student cancel', err));

    return { success: true };
  }

  /** Shared cancel logic: updates session, refunds advance if paid, records history */
  private async executeCancel(
    session: { id: string; studentUserId: string; mentorProfileId: string; advanceCents: number | null; paymentStatus: string },
    changedByUserId: string,
    reason: string,
  ) {
    await this.prisma.$transaction(async (tx) => {
      // 1. Update session status
      await tx.mentorSession.update({
        where: { id: session.id },
        data: {
          status: 'cancelled',
          paymentStatus: session.paymentStatus === 'advance_paid' ? 'unpaid' : undefined,
          cancelReason: reason,
          updatedBy: changedByUserId,
        },
      });

      // 2. Record status history
      await tx.mentorSessionStatusHistory.create({
        data: {
          mentorSessionId: session.id,
          fromStatus: 'scheduled',
          toStatus: 'cancelled',
          changedBy: changedByUserId,
          reason,
        },
      });

      // 3. Refund advance if it was paid
      if (session.paymentStatus === 'advance_paid' && session.advanceCents && session.advanceCents > 0) {
        const advanceCents = session.advanceCents;

        // Refund to student wallet
        const studentWallet = await tx.wallet.findUnique({ where: { userId: session.studentUserId } });
        if (studentWallet) {
          const newStudentBalance = studentWallet.balanceCents + BigInt(advanceCents);
          await tx.wallet.update({
            where: { userId: session.studentUserId },
            data: { balanceCents: newStudentBalance },
          });
          await tx.walletTransaction.create({
            data: {
              walletId: studentWallet.id,
              userId: session.studentUserId,
              txnType: 'credit',
              amountCents: BigInt(advanceCents),
              balanceAfterCents: newStudentBalance,
              description: `Refund: cancelled mentoring session advance`,
              referenceType: 'mentor_session_refund',
            },
          });
        }

        // Debit from mentor wallet (advance was credited during booking)
        const mentor = await tx.mentorProfile.findUnique({
          where: { id: session.mentorProfileId },
          select: { userId: true },
        });
        if (mentor) {
          const mentorWallet = await tx.wallet.findUnique({ where: { userId: mentor.userId } });
          if (mentorWallet) {
            const newMentorBalance = mentorWallet.balanceCents - BigInt(advanceCents);
            await tx.wallet.update({
              where: { userId: mentor.userId },
              data: { balanceCents: newMentorBalance },
            });
            await tx.walletTransaction.create({
              data: {
                walletId: mentorWallet.id,
                userId: mentor.userId,
                txnType: 'debit',
                amountCents: BigInt(advanceCents),
                balanceAfterCents: newMentorBalance,
                description: `Reversal: cancelled mentoring session advance`,
                referenceType: 'mentor_session_refund',
              },
            });
          }
        }
      }
    });
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

  /** Get available time slots for a mentor on a specific date */
  async getAvailableSlots(mentorProfileId: string, dateStr: string) {
    // Parse the date
    const date = new Date(dateStr);
    if (isNaN(date.getTime())) {
      throw new NotFoundException('Invalid date format');
    }

    // Check if the date is blocked
    const blocked = await this.prisma.mentorBlockedDate.findUnique({
      where: {
        mentorProfileId_blockedDate: {
          mentorProfileId,
          blockedDate: date,
        },
      },
    });

    if (blocked) {
      return { date: dateStr, slots: [] };
    }

    // Get the day of week (0 = Sunday, 1 = Monday, ..., 6 = Saturday)
    const dayOfWeek = date.getDay();

    // Fetch availability slots for this date
    const slots = await this.prisma.mentorAvailabilitySlot.findMany({
      where: {
        mentorProfileId,
        OR: [
          { isRecurring: true, dayOfWeek },
          { isRecurring: false, specificDate: date },
        ],
      },
    });

    // If no slots, return empty
    if (slots.length === 0) {
      return { date: dateStr, slots: [] };
    }

    // Fetch existing bookings for this date
    const startOfDay = new Date(date);
    startOfDay.setHours(0, 0, 0, 0);
    const endOfDay = new Date(date);
    endOfDay.setHours(23, 59, 59, 999);

    const bookings = await this.prisma.mentorSession.findMany({
      where: {
        mentorProfileId,
        status: { in: ['scheduled', 'live'] },
        scheduledFrom: {
          gte: startOfDay,
          lte: endOfDay,
        },
      },
      select: {
        scheduledFrom: true,
        scheduledTo: true,
      },
    });

    // Get current time for filtering past slots (only for today)
    const now = new Date();
    const isToday =
      date.getFullYear() === now.getFullYear() &&
      date.getMonth() === now.getMonth() &&
      date.getDate() === now.getDate();
    const minStartTime = new Date(now.getTime() + 30 * 60 * 1000); // now + 30 min

    // Generate available 1-hour slots
    const availableSlots: { startTime: string; endTime: string }[] = [];

    for (const slot of slots) {
      const [startHour, startMin] = slot.startTime.split(':').map(Number);
      const [endHour, endMin] = slot.endTime.split(':').map(Number);

      let current = new Date(date);
      current.setHours(startHour, startMin, 0, 0);

      const end = new Date(date);
      end.setHours(endHour, endMin, 0, 0);

      // Generate 1-hour chunks
      while (current.getTime() + 60 * 60 * 1000 <= end.getTime()) {
        const slotStart = new Date(current);
        const slotEnd = new Date(current.getTime() + 60 * 60 * 1000);

        // Filter out past slots (for today)
        if (isToday && slotStart < minStartTime) {
          current = new Date(current.getTime() + 60 * 60 * 1000);
          continue;
        }

        // Check for conflicts with existing bookings
        const hasConflict = bookings.some(
          (b) =>
            b.scheduledFrom &&
            b.scheduledTo &&
            slotStart < b.scheduledTo &&
            slotEnd > b.scheduledFrom,
        );

        if (!hasConflict) {
          availableSlots.push({
            startTime: `${String(slotStart.getHours()).padStart(2, '0')}:${String(slotStart.getMinutes()).padStart(2, '0')}`,
            endTime: `${String(slotEnd.getHours()).padStart(2, '0')}:${String(slotEnd.getMinutes()).padStart(2, '0')}`,
          });
        }

        current = new Date(current.getTime() + 60 * 60 * 1000);
      }
    }

    return { date: dateStr, slots: availableSlots };
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

  /** Upload a file attachment for a mentoring session */
  async uploadAttachment(req: any): Promise<{
    fileName: string;
    filePath: string;
    mimeType: string;
    sizeBytes: number;
  }> {
    const parts = req.parts();
    let fileBuffer: Buffer | null = null;
    let originalName = '';
    let mimetype = '';

    for await (const part of parts) {
      if (part.type === 'file') {
        // Validate file type
        const allowedTypes = [
          'application/pdf',
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
          'text/plain',
          'image/png',
          'image/jpeg',
          'image/gif',
          'image/webp',
        ];
        if (!allowedTypes.includes(part.mimetype)) {
          throw new BadRequestException(
            'Unsupported file type. Allowed: PDF, DOCX, TXT, PNG, JPG, GIF, WEBP',
          );
        }

        // Read file into buffer (max 2MB)
        const chunks: Buffer[] = [];
        let size = 0;
        for await (const chunk of part.file) {
          size += chunk.length;
          if (size > 2 * 1024 * 1024) {
            throw new BadRequestException('File too large. Maximum size is 2MB');
          }
          chunks.push(chunk);
        }
        fileBuffer = Buffer.concat(chunks);
        originalName = part.filename;
        mimetype = part.mimetype;
      }
    }

    if (!fileBuffer) {
      throw new BadRequestException('No file uploaded');
    }

    // Ensure upload directory exists
    const uploadDir = path.join(process.cwd(), 'uploads', 'mentor-sessions');
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }

    // Generate unique filename
    const ext = path.extname(originalName);
    const baseName = path.basename(originalName, ext).replace(/[^a-zA-Z0-9_-]/g, '_');
    const fileName = `${randomUUID()}-${baseName}${ext}`;
    const filePath = path.join(uploadDir, fileName);

    // Write file
    fs.writeFileSync(filePath, fileBuffer);

    return {
      fileName: originalName,
      filePath: `uploads/mentor-sessions/${fileName}`,
      mimeType: mimetype,
      sizeBytes: fileBuffer.length,
    };
  }

  /** Book a mentoring session (student side) */
  async bookSession(studentUserId: string, body: any) {
    const {
      mentorProfileId,
      category,
      scheduledDate,
      startTime,
      durationMinutes = 60,
      subject,
      description,
      attachmentFileName,
      attachmentFilePath,
      attachmentMimeType,
      attachmentSizeBytes,
    } = body;

    // Validate required fields
    if (!mentorProfileId || !category || !scheduledDate || !startTime || !subject || !description) {
      throw new BadRequestException('Missing required fields');
    }

    // Validate subject word count (max 10)
    const subjectWords = subject.trim().split(/\s+/).filter(Boolean);
    if (subjectWords.length > 10) {
      throw new BadRequestException('Subject must be 10 words or fewer');
    }

    // Validate description word count (min 10)
    const descWords = description.trim().split(/\s+/).filter(Boolean);
    if (descWords.length < 10) {
      throw new BadRequestException('Description must be at least 10 words');
    }

    // Validate category
    const validCategories = ['consultation', 'guidance', 'doubt_clarification', 'hands_on'];
    if (!validCategories.includes(category)) {
      throw new BadRequestException('Invalid session category');
    }

    // Compute scheduledFrom and scheduledTo
    const scheduledFrom = new Date(`${scheduledDate}T${startTime}:00`);
    const scheduledTo = new Date(scheduledFrom.getTime() + durationMinutes * 60 * 1000);

    // Validate date is in the future
    if (scheduledFrom <= new Date()) {
      throw new BadRequestException('Session must be scheduled in the future');
    }

    // Use a transaction for atomicity
    const result = await this.prisma.$transaction(async (tx) => {
      // 1. Verify mentor exists and is available
      const mentor = await tx.mentorProfile.findUnique({
        where: { id: mentorProfileId },
        include: { user: { select: { id: true, firstName: true, lastName: true, email: true } } },
      });

      if (!mentor || !mentor.isAvailable) {
        throw new NotFoundException('Mentor not found or not available');
      }

      // 2. Verify slot is still available (no conflicting bookings)
      const conflict = await tx.mentorSession.findFirst({
        where: {
          mentorProfileId,
          status: { in: ['scheduled', 'live'] },
          scheduledFrom: { lt: scheduledTo },
          scheduledTo: { gt: scheduledFrom },
        },
      });

      if (conflict) {
        throw new ConflictException('This time slot is no longer available');
      }

      // 3. Verify slot is within mentor's availability
      const dayOfWeek = scheduledFrom.getDay();
      const dateOnly = new Date(scheduledFrom);
      dateOnly.setHours(0, 0, 0, 0);

      const availability = await tx.mentorAvailabilitySlot.findFirst({
        where: {
          mentorProfileId,
          OR: [
            { isRecurring: true, dayOfWeek },
            { isRecurring: false, specificDate: dateOnly },
          ],
        },
      });

      if (!availability) {
        throw new ConflictException('Mentor is not available at this time');
      }

      // 4. Calculate costs
      const sessionCost = mentor.pricePerHourCents;
      const advanceCents = Math.round(sessionCost * 0.1); // 10% advance
      const balanceCents = sessionCost - advanceCents;

      // 5. Check student wallet balance (must be >= full session cost)
      const wallet = await tx.wallet.findUnique({
        where: { userId: studentUserId },
      });

      if (!wallet) {
        throw new BadRequestException('Wallet not found');
      }

      const balanceCentsNum = Number(wallet.balanceCents);
      if (balanceCentsNum < sessionCost) {
        throw new BadRequestException(
          `Insufficient balance. Required: ₹${(sessionCost / 100).toFixed(2)}, Available: ₹${(balanceCentsNum / 100).toFixed(2)}`,
        );
      }

      // 6. Debit advance from student wallet
      const newStudentBalance = wallet.balanceCents - BigInt(advanceCents);
      await tx.wallet.update({
        where: { userId: studentUserId },
        data: { balanceCents: newStudentBalance },
      });

      // Create wallet transaction record
      await tx.walletTransaction.create({
        data: {
          walletId: wallet.id,
          userId: studentUserId,
          txnType: 'debit',
          amountCents: BigInt(advanceCents),
          balanceAfterCents: newStudentBalance,
          description: `Mentoring session advance: ${category}`,
          referenceType: 'mentor_session_advance',
        },
      });

      // 7. Create MentorSession record
      const jitsiRoomName = `session-${randomUUID()}`;
      const session = await tx.mentorSession.create({
        data: {
          mentorProfileId,
          studentUserId,
          type: 'slot_booking',
          status: 'scheduled',
          paymentStatus: 'advance_paid',
          scheduledFrom,
          scheduledTo,
          durationMinutes,
          domain: 'Mentoring',
          serviceType: category.replace(/_/g, ' '),
          jitsiRoomName,
          earningsCents: sessionCost,
          advanceCents,
          balanceCents,
          studentNotes: description,
          attachmentFileName: attachmentFileName || null,
          attachmentFilePath: attachmentFilePath || null,
          attachmentMimeType: attachmentMimeType || null,
          attachmentSizeBytes: attachmentSizeBytes || null,
          // category field — Prisma client needs regeneration to include this
          ...(category ? { category } : {}),
        } as any,
      });

      // 8. Create status history entry
      await tx.mentorSessionStatusHistory.create({
        data: {
          mentorSessionId: session.id,
          fromStatus: 'pending',
          toStatus: 'scheduled',
          changedBy: 'system',
        },
      });

      // 9. Create payment record
      await tx.mentorSessionPayment.create({
        data: {
          mentorSessionId: session.id,
          amountCents: advanceCents,
          paymentType: 'advance',
          payerUserId: studentUserId,
          payeeUserId: mentor.user.id,
          status: 'held',
        },
      });

      // 10. Credit advance to mentor's wallet
      let mentorWallet = await tx.wallet.findUnique({
        where: { userId: mentor.user.id },
      });

      if (!mentorWallet) {
        mentorWallet = await tx.wallet.create({
          data: {
            userId: mentor.user.id,
            balanceCents: BigInt(0),
          },
        });
      }

      const newMentorBalance = mentorWallet.balanceCents + BigInt(advanceCents);
      await tx.wallet.update({
        where: { userId: mentor.user.id },
        data: { balanceCents: newMentorBalance },
      });

      await tx.walletTransaction.create({
        data: {
          walletId: mentorWallet.id,
          userId: mentor.user.id,
          txnType: 'credit',
          amountCents: BigInt(advanceCents),
          balanceAfterCents: newMentorBalance,
          description: `Mentoring session advance received: ${category}`,
          referenceType: 'mentor_session_advance',
        },
      });

      return { sessionId: session.id, mentorUserId: mentor.user.id, studentId: studentUserId, mentorName: `${mentor.user.firstName} ${mentor.user.lastName}`.trim(), sessionCost, advanceCents, balanceCents };
    });

    // Send emails after transaction (non-blocking)
    try {
      const student = await this.prisma.user.findUnique({ where: { id: result.studentId }, select: { email: true, firstName: true, lastName: true } });
      const mentor = await this.prisma.user.findUnique({ where: { id: result.mentorUserId }, select: { email: true, firstName: true, lastName: true } });

      if (student && mentor) {
        const fmtRupees = (cents: number) => `\u20B9${(cents / 100).toLocaleString('en-IN')}`;
        const dateStr = scheduledFrom.toLocaleDateString('en-IN', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' });
        const timeStr = `${String(scheduledFrom.getHours()).padStart(2, '0')}:${String(scheduledFrom.getMinutes()).padStart(2, '0')}`;
        const categoryLabel = category.replace(/_/g, ' ').replace(/\b\w/g, (c: string) => c.toUpperCase());

        // Audit log for booking
        this.auditService.log({
          userId: studentUserId,
          action: 'mentoring.session_booked',
          category: 'mentoring',
          status: 'success',
          details: { sessionId: result.sessionId, mentorName: result.mentorName, sessionCategory: categoryLabel, advanceCents: result.advanceCents },
        }).catch(err => this.logger.error('Audit log failed for session booking', err));

        // Student confirmation
        this.mailService.sendSessionBookedStudentEmail(student.email, {
          studentName: `${student.firstName} ${student.lastName}`.trim(),
          mentorName: result.mentorName,
          sessionCategory: categoryLabel,
          sessionDate: dateStr,
          sessionTime: timeStr,
          duration: durationMinutes,
          subject,
          sessionCost: fmtRupees(result.sessionCost),
          advanceAmount: fmtRupees(result.advanceCents),
          balanceAmount: fmtRupees(result.balanceCents),
        }).catch(err => this.logger.error('Failed to send student booking email', err));

        // Mentor intimation
        this.mailService.sendSessionBookedMentorEmail(mentor.email, {
          mentorName: `${mentor.firstName} ${mentor.lastName}`.trim(),
          studentName: `${student.firstName} ${student.lastName}`.trim(),
          sessionCategory: categoryLabel,
          sessionDate: dateStr,
          sessionTime: timeStr,
          duration: durationMinutes,
          subject,
          description,
          sessionCost: fmtRupees(result.sessionCost),
          hasAttachment: !!attachmentFileName,
          attachmentName: attachmentFileName || undefined,
        }).catch(err => this.logger.error('Failed to send mentor booking email', err));
      }
    } catch (err) {
      this.logger.error('Failed to send booking notification emails', err);
    }

    return { sessionId: result.sessionId };
  }

  /** Get student's upcoming scheduled sessions */
  async getStudentUpcoming(studentUserId: string) {
    const sessions = await this.prisma.mentorSession.findMany({
      where: {
        studentUserId,
        status: 'scheduled',
        scheduledFrom: { gte: new Date() },
      },
      include: {
        mentorProfile: {
          include: {
            user: {
              select: {
                firstName: true,
                lastName: true,
              },
            },
          },
        },
      },
      orderBy: { scheduledFrom: 'asc' },
    });

    return sessions.map((s) => ({
      id: s.id,
      mentorName: `${s.mentorProfile.user.firstName} ${s.mentorProfile.user.lastName}`.trim(),
      mentorHeadline: s.mentorProfile.headline,
      mentorCompany: s.mentorProfile.company,
      scheduledFrom: s.scheduledFrom,
      scheduledTo: s.scheduledTo,
      durationMinutes: s.durationMinutes,
      domain: s.domain,
      serviceType: s.serviceType,
      paymentStatus: s.paymentStatus,
      earningsCents: s.earningsCents,
    }));
  }

  /** Get student's pending requests (sessions awaiting mentor approval) */
  async getStudentRequests(studentUserId: string) {
    const sessions = await this.prisma.mentorSession.findMany({
      where: {
        studentUserId,
        status: 'pending',
      },
      include: {
        mentorProfile: {
          include: {
            user: { select: { firstName: true, lastName: true } },
          },
        },
      },
      orderBy: { requestedAt: 'desc' },
    });

    return sessions.map((s) => ({
      id: s.id,
      mentorName: `${s.mentorProfile.user.firstName} ${s.mentorProfile.user.lastName}`.trim(),
      domain: s.domain,
      serviceType: s.serviceType,
      durationMinutes: s.durationMinutes,
      earningsCents: s.earningsCents,
      createdAt: s.requestedAt.toISOString(),
    }));
  }

  /** Get student's past sessions (terminal statuses) */
  async getStudentPast(studentUserId: string) {
    const terminalStatuses = ['completed', 'cancelled', 'rejected', 'request_expired', 'missed', 'disputed'] as const;

    const sessions = await (this.prisma.mentorSession.findMany as any)({
      where: {
        studentUserId,
        status: { in: terminalStatuses },
      },
      include: {
        mentorProfile: {
          include: {
            user: { select: { firstName: true, lastName: true } },
          },
        },
      },
      orderBy: { requestedAt: 'desc' },
    });

    const statusLabelMap: Record<string, string> = {
      completed: 'Completed',
      cancelled: 'Cancelled',
      rejected: 'Rejected',
      request_expired: 'Expired',
      missed: 'Missed',
      disputed: 'Disputed',
    };

    return sessions.map((s: any) => ({
      id: s.id,
      mentorName: `${s.mentorProfile.user.firstName} ${s.mentorProfile.user.lastName}`.trim(),
      domain: s.domain,
      serviceType: s.serviceType,
      durationMinutes: s.durationMinutes,
      earningsCents: s.earningsCents,
      createdAt: s.requestedAt.toISOString(),
      status: statusLabelMap[s.status] || s.status,
    }));
  }
}
