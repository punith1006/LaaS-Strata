import { Injectable, NotFoundException, ConflictException, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

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

@Injectable()
export class MentorAvailabilityService {
  private readonly logger = new Logger(MentorAvailabilityService.name);

  constructor(private prisma: PrismaService) {}

  private async findMentorProfile(userId: string) {
    const profile = await this.prisma.mentorProfile.findUnique({
      where: { userId },
    });
    if (!profile) {
      throw new NotFoundException('Mentor profile not found');
    }
    return profile;
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

    return slots.map((s) => ({
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

    return { success: true };
  }
}
