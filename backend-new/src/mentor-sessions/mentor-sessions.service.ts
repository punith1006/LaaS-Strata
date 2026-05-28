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
}
