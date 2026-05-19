import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { MailService } from '../mail/mail.service';
import { TicketPriority, TicketStatus } from '@prisma/client';

export interface CreateSupportTicketDto {
  category: string;
  subject: string;
  description: string;
}

export interface SupportTicketResponse {
  ticketId: string;
  status: TicketStatus;
  createdAt: Date;
}

export interface SupportTicketAttachmentInput {
  fileName: string;
  mimeType: string;
  size: number;
  buffer: Buffer;
}

@Injectable()
export class SupportService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly mailService: MailService,
  ) {}

  async createTicket(
    userId: string,
    dto: CreateSupportTicketDto,
    files?: SupportTicketAttachmentInput[],
  ): Promise<SupportTicketResponse> {
    // Determine priority based on category
    const priority = this.getPriorityFromCategory(dto.category);

    // Get user details
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        defaultOrgId: true,
      },
    });

    if (!user) {
      throw new Error('User not found');
    }

    // Create the support ticket
    const ticket = await this.prisma.supportTicket.create({
      data: {
        userId: user.id,
        organizationId: user.defaultOrgId,
        subject: dto.subject,
        description: dto.description,
        category: dto.category,
        priority: priority,
        status: 'open' as TicketStatus,
      },
    });

    // Persist any attachments uploaded with the ticket
    if (files && files.length > 0) {
      for (const file of files) {
        const ab = new ArrayBuffer(file.buffer.byteLength);
        new Uint8Array(ab).set(file.buffer);
        await this.prisma.supportTicketAttachment.create({
          data: {
            ticketId: ticket.id,
            fileName: file.fileName,
            mimeType: file.mimeType,
            size: file.size,
            data: new Uint8Array(ab),
          },
        });
      }
    }

    // Format submission time
    const submittedAt = ticket.createdAt.toLocaleString('en-US', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      timeZoneName: 'short',
    });

    // Determine base URL for links
    const baseUrl = process.env.FRONTEND_URL || 'http://localhost:3000';
    const adminPortalUrl = `${baseUrl}/admin/tickets/${ticket.id}`;
    const docsUrl = `${baseUrl}/docs`;

    // Send admin notification email
    try {
      await this.mailService.sendSupportTicketAdminNotification({
        ticketId: ticket.id,
        userName: `${user.firstName} ${user.lastName}`,
        userEmail: user.email,
        category: this.formatCategory(dto.category),
        priority: priority,
        subject: dto.subject,
        description: dto.description,
        adminPortalUrl,
      });
    } catch (error) {
      console.error('Failed to send admin notification:', error);
      // Don't fail the request if email fails
    }

    // Send user confirmation email
    try {
      await this.mailService.sendSupportTicketConfirmation(user.email, {
        ticketId: ticket.id,
        userName: user.firstName,
        category: this.formatCategory(dto.category),
        subject: dto.subject,
        description: dto.description,
        submittedAt,
        docsUrl,
      });
    } catch (error) {
      console.error('Failed to send user confirmation:', error);
      // Don't fail the request if email fails
    }

    return {
      ticketId: ticket.id,
      status: ticket.status,
      createdAt: ticket.createdAt,
    };
  }

  async getUserTickets(userId: string) {
    return this.prisma.supportTicket.findMany({
      where: {
        userId,
        deletedAt: null,
      },
      orderBy: {
        createdAt: 'desc',
      },
      select: {
        id: true,
        subject: true,
        category: true,
        priority: true,
        status: true,
        createdAt: true,
        updatedAt: true,
        resolvedAt: true,
      },
    });
  }

  async getTicketAttachments(ticketId: string, userId: string) {
    return this.prisma.supportTicketAttachment.findMany({
      where: {
        ticketId,
        ticket: { userId },
      },
      select: {
        id: true,
        fileName: true,
        mimeType: true,
        size: true,
        createdAt: true,
      },
    });
  }

  async getAttachmentFile(
    ticketId: string,
    attachmentId: string,
    userId: string,
  ) {
    const attachment = await this.prisma.supportTicketAttachment.findFirst({
      where: {
        id: attachmentId,
        ticketId: ticketId,
        ticket: { userId: userId },
      },
    });
    if (!attachment) {
      throw new NotFoundException('Attachment not found');
    }
    return attachment;
  }

  private getPriorityFromCategory(category: string): TicketPriority {
    // Map categories to priorities
    const priorityMap: Record<string, TicketPriority> = {
      'pod_issue': 'high',
      'serverless_issue': 'high',
      'template_issue': 'medium',
      'general_inquiry': 'low',
      'data_center_partner': 'medium',
    };

    return priorityMap[category] || 'medium';
  }

  private formatCategory(category: string): string {
    return category
      .split('_')
      .map(word => word.charAt(0).toUpperCase() + word.slice(1))
      .join(' ');
  }
}
