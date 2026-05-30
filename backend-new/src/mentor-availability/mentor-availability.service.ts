import { Injectable, NotFoundException, ConflictException, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AuditService } from '../audit/audit.service';

export interface CreateSlotDto {
  dayOfWeek?: number;
  specificDate?: string;
  startTime: string;
  endTime: string;
  isRecurring: boolean;
}

export interface AvailabilitySlotResponse {
  id: string;
  dayOfWeek: number | null;
  specificDate: string | null;
  startTime: string;
  endTime: string;
  isRecurring: boolean;
}

export interface BlockedDateResponse {
  id: string;
  blockedDate: string;
  reason: string | null;
}

export interface BlockDateDto {
  date: string;
  reason?: string;
}

@Injectable()
export class MentorAvailabilityService {
  private readonly logger = new Logger(MentorAvailabilityService.name);

  constructor(
    private prisma: PrismaService,
    private auditService: AuditService,
  ) {}

  private async findMentorProfile(userId: string) {
    const profile = await this.prisma.mentorProfile.findUnique({
      where: { userId },
    });
    if (!profile) {
      throw new NotFoundException('Mentor profile not found');
    }
    return profile;
  }

  /** Return today's date as YYYY-MM-DD in IST timezone */
  private getTodayISTString(): string {
    const formatter = new Intl.DateTimeFormat('en-CA', {
      timeZone: 'Asia/Kolkata',
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    });
    return formatter.format(new Date());
  }

  /** Get all availability slots for the logged-in mentor */
  async getSlots(userId: string): Promise<AvailabilitySlotResponse[]> {
    const profile = await this.findMentorProfile(userId);

    const slots = await this.prisma.mentorAvailabilitySlot.findMany({
      where: { mentorProfileId: profile.id },
      orderBy: [
        { dayOfWeek: 'asc' },
        { specificDate: 'asc' },
        { startTime: 'asc' },
      ],
    });

    const todayIST = this.getTodayISTString();

    return slots
      .filter((s) => {
        // Always include recurring slots, filter past date-specific slots
        if (s.isRecurring) return true;
        if (s.specificDate) {
          const dateStr = s.specificDate.toISOString().split('T')[0];
          return dateStr >= todayIST;
        }
        return true;
      })
      .map((s) => ({
        id: s.id,
        dayOfWeek: s.dayOfWeek,
        specificDate: s.specificDate ? s.specificDate.toISOString() : null,
        startTime: s.startTime,
        endTime: s.endTime,
        isRecurring: s.isRecurring,
      }));
  }

  /** Create a new availability slot */
  async createSlot(userId: string, dto: CreateSlotDto): Promise<AvailabilitySlotResponse> {
    const profile = await this.findMentorProfile(userId);

    // Validate time order
    if (dto.startTime >= dto.endTime) {
      throw new ConflictException('End time must be after start time');
    }

    // Validate: must have either dayOfWeek or specificDate
    if (dto.isRecurring && dto.dayOfWeek === undefined) {
      throw new ConflictException('Recurring slots must specify a day of week');
    }
    if (!dto.isRecurring && !dto.specificDate) {
      throw new ConflictException('Non-recurring slots must specify a specific date');
    }

    // Overlap check within same category only (recurring vs recurring, date-specific vs date-specific).
    // Date-specific slots are allowed to overlap recurring because they take precedence (override semantics).
    const existingSlots = await this.prisma.mentorAvailabilitySlot.findMany({
      where: {
        mentorProfileId: profile.id,
        ...(dto.isRecurring
          ? { dayOfWeek: dto.dayOfWeek, isRecurring: true }
          : { specificDate: new Date(dto.specificDate!), isRecurring: false }),
      },
    });

    const hasOverlap = existingSlots.some(
      (s) => dto.startTime < s.endTime && dto.endTime > s.startTime,
    );

    if (hasOverlap) {
      throw new ConflictException('This time slot overlaps with an existing slot on the same day');
    }

    const slot = await this.prisma.mentorAvailabilitySlot.create({
      data: {
        mentorProfileId: profile.id,
        dayOfWeek: dto.isRecurring ? dto.dayOfWeek ?? null : null,
        specificDate: dto.isRecurring ? null : new Date(dto.specificDate!),
        startTime: dto.startTime,
        endTime: dto.endTime,
        isRecurring: dto.isRecurring,
        createdBy: userId,
        updatedBy: userId,
      },
    });

    this.logger.log(`Slot created: ${slot.id} by user ${userId}`);

    // Audit logging
    this.auditService.log({
      userId,
      action: 'mentoring.slot_created',
      category: 'mentoring',
      status: 'success',
      details: {
        dayOfWeek: dto.dayOfWeek ?? null,
        specificDate: dto.specificDate ?? null,
        startTime: dto.startTime,
        endTime: dto.endTime,
        isRecurring: dto.isRecurring,
      },
    });

    return {
      id: slot.id,
      dayOfWeek: slot.dayOfWeek,
      specificDate: slot.specificDate ? slot.specificDate.toISOString() : null,
      startTime: slot.startTime,
      endTime: slot.endTime,
      isRecurring: slot.isRecurring,
    };
  }

  /** Delete an availability slot */
  async deleteSlot(userId: string, slotId: string): Promise<{ success: boolean }> {
    const profile = await this.findMentorProfile(userId);

    const slot = await this.prisma.mentorAvailabilitySlot.findFirst({
      where: { id: slotId, mentorProfileId: profile.id },
    });

    if (!slot) {
      throw new NotFoundException('Availability slot not found');
    }

    await this.prisma.mentorAvailabilitySlot.delete({
      where: { id: slotId },
    });

    this.logger.log(`Slot deleted: ${slotId} by user ${userId}`);

    // Audit logging
    this.auditService.log({
      userId,
      action: 'mentoring.slot_deleted',
      category: 'mentoring',
      status: 'success',
      details: { slotId },
    });

    return { success: true };
  }

  // ── Blocked Dates (Day Off) ──

  /** Get all blocked dates for the logged-in mentor */
  async getBlockedDates(userId: string): Promise<BlockedDateResponse[]> {
    const profile = await this.findMentorProfile(userId);

    const blocked = await this.prisma.mentorBlockedDate.findMany({
      where: { mentorProfileId: profile.id },
      orderBy: { blockedDate: 'asc' },
    });

    const todayIST = this.getTodayISTString();

    return blocked
      .filter((b) => {
        const dateStr = b.blockedDate.toISOString().split('T')[0];
        return dateStr >= todayIST;
      })
      .map((b) => ({
        id: b.id,
        blockedDate: b.blockedDate.toISOString().split('T')[0],
        reason: b.reason,
      }));
  }

  /** Block a date (Day Off) */
  async blockDate(userId: string, dto: BlockDateDto): Promise<BlockedDateResponse> {
    const profile = await this.findMentorProfile(userId);

    if (!dto.date) {
      throw new ConflictException('Date is required');
    }

    const parsedDate = new Date(dto.date);
    if (isNaN(parsedDate.getTime())) {
      throw new ConflictException('Invalid date format');
    }

    // Check for duplicate
    const existing = await this.prisma.mentorBlockedDate.findUnique({
      where: {
        mentorProfileId_blockedDate: {
          mentorProfileId: profile.id,
          blockedDate: parsedDate,
        },
      },
    });

    if (existing) {
      throw new ConflictException('This date is already blocked');
    }

    const blocked = await this.prisma.mentorBlockedDate.create({
      data: {
        mentorProfileId: profile.id,
        blockedDate: parsedDate,
        reason: dto.reason || null,
        createdBy: userId,
        updatedBy: userId,
      },
    });

    this.logger.log(`Date blocked: ${blocked.blockedDate.toISOString()} by user ${userId}`);

    // Audit logging
    this.auditService.log({
      userId,
      action: 'mentoring.date_blocked',
      category: 'mentoring',
      status: 'success',
      details: { date: dto.date, reason: dto.reason ?? null },
    });

    return {
      id: blocked.id,
      blockedDate: blocked.blockedDate.toISOString().split('T')[0],
      reason: blocked.reason,
    };
  }

  /** Unblock a date */
  async unblockDate(userId: string, blockId: string): Promise<{ success: boolean }> {
    const profile = await this.findMentorProfile(userId);

    const blocked = await this.prisma.mentorBlockedDate.findFirst({
      where: { id: blockId, mentorProfileId: profile.id },
    });

    if (!blocked) {
      throw new NotFoundException('Blocked date not found');
    }

    await this.prisma.mentorBlockedDate.delete({
      where: { id: blockId },
    });

    this.logger.log(`Date unblocked: ${blockId} by user ${userId}`);

    // Audit logging
    this.auditService.log({
      userId,
      action: 'mentoring.date_unblocked',
      category: 'mentoring',
      status: 'success',
      details: { blockedDate: blocked.blockedDate.toISOString() },
    });

    return { success: true };
  }
}
