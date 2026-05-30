import { Injectable } from '@nestjs/common';
import { MailerService } from '@nestjs-modules/mailer';
import { readFileSync } from 'fs';
import { join } from 'path';

@Injectable()
export class MailService {
  constructor(private mailer: MailerService) {}

  // Helper to load logo images for email templates (CID embedding)
  private getLogoAttachments() {
    return [
      {
        filename: 'ksrce-logo.png',
        content: readFileSync(join(process.cwd(), 'templates', 'images', 'ksrce-logo.png')),
        cid: 'ksrce-logo@laas.ai',
        encoding: 'base64',
      },
      {
        filename: 'global-knowledge-logo.png',
        content: readFileSync(join(process.cwd(), 'templates', 'images', 'global-knowledge-logo.png')),
        cid: 'global-knowledge-logo@laas.ai',
        encoding: 'base64',
      },
    ];
  }

  async sendOtpEmail(to: string, code: string): Promise<void> {
    await this.mailer.sendMail({
      to,
      subject: 'Your LaaS verification code',
      template: 'otp',
      context: { code },
      attachments: this.getLogoAttachments(),
    });
  }
  
  async sendPasswordResetOtpEmail(to: string, code: string): Promise<void> {
    await this.mailer.sendMail({
      to,
      subject: 'LaaS - Password Reset Code',
      template: 'password-reset',
      context: { code },
      attachments: this.getLogoAttachments(),
    });
  }

  async sendWelcomeEmail(to: string, firstName: string): Promise<void> {
    await this.mailer.sendMail({
      to,
      subject: 'Welcome to LaaS',
      template: 'welcome',
      context: { firstName },
      attachments: this.getLogoAttachments(),
    });
  }

  async sendSpendLimitWarningEmail(
    to: string,
    context: {
      firstName: string;
      currentSpendRupees: string;
      limitRupees: string;
      percentUsed: number;
      period: string;
      remainingRupees: string;
    },
  ): Promise<void> {
    await this.mailer.sendMail({
      to,
      subject: 'LaaS: Your spend is approaching your limit',
      template: 'spend-limit-warning',
      context,
    });
  }

  async sendSpendLimitEnforcedEmail(
    to: string,
    context: {
      firstName: string;
      limitRupees: string;
      totalSpentRupees: string;
      period: string;
      terminatedCount: number;
      terminatedSessions: Array<{
        name: string;
        config: string;
        uptime: string;
      }>;
    },
  ): Promise<void> {
    await this.mailer.sendMail({
      to,
      subject: 'LaaS: Spend limit reached — compute instances terminated',
      template: 'spend-limit-enforced',
      context,
    });
  }

  async sendRunwayWarningEmail(
    to: string,
    context: {
      firstName: string;
      runwayHours: string;
      burnRate: string;
      creditBalance: string;
    },
  ): Promise<void> {
    await this.mailer.sendMail({
      to,
      subject: 'LaaS: Low runway — instances will auto-terminate soon',
      template: 'runway-warning',
      context,
    });
  }

  async sendRunwayTerminationEmail(
    to: string,
    context: {
      firstName: string;
      terminatedCount: number;
      terminatedSessions: Array<{ name: string; config: string; uptime: string }>;
    },
  ): Promise<void> {
    await this.mailer.sendMail({
      to,
      subject: 'LaaS: Runway exhausted — compute instances terminated',
      template: 'runway-termination',
      context,
    });
  }

  // Support Ticket Email Methods
  async sendSupportTicketAdminNotification(
    context: {
      ticketId: string;
      userName: string;
      userEmail: string;
      category: string;
      priority: string;
      subject: string;
      description: string;
      adminPortalUrl: string;
    },
  ): Promise<void> {
    const adminEmail = process.env.SUPPORT_ADMIN_EMAIL || 'punith.vs74064@gmail.com';
    await this.mailer.sendMail({
      to: adminEmail,
      subject: `[LaaS] New Support Ticket - ${context.subject}`,
      template: 'support-ticket-admin',
      context,
    });
  }

  async sendSupportTicketConfirmation(
    to: string,
    context: {
      ticketId: string;
      userName: string;
      category: string;
      subject: string;
      description: string;
      submittedAt: string;
      docsUrl: string;
    },
  ): Promise<void> {
    await this.mailer.sendMail({
      to,
      subject: `LaaS: We received your support ticket - ${context.subject}`,
      template: 'support-ticket-confirmation',
      context,
    });
  }

  async sendTicketResolutionNotification(
    to: string,
    context: {
      userName: string;
      ticketId: string;
      subject: string;
      category: string;
      resolutionNotes: string;
      resolvedAt: string;
    },
  ): Promise<void> {
    await this.mailer.sendMail({
      to,
      subject: `Your Support Ticket Has Been Resolved - ${context.subject}`,
      template: 'ticket-resolution',
      context,
      attachments: this.getLogoAttachments(),
    });
  }

  async sendWaitlistConfirmationEmail(
    to: string,
    context: {
      firstName: string;
      email: string;
      currentStatus: string;
      companyOrOrg: string;
      roleOrDesignation: string;
      primaryWorkload: string;
      computeNeeds: string;
      expectedDuration?: string;
      expectations: string[];
    },
  ): Promise<void> {
    await this.mailer.sendMail({
      to,
      subject: "You're on the List — Welcome to LaaS!",
      template: 'waitlist-confirmation',
      context,
      attachments: this.getLogoAttachments(),
    });
  }

  // ── Mentoring Session Emails ──

  async sendSessionBookedStudentEmail(
    to: string,
    context: {
      studentName: string;
      mentorName: string;
      sessionCategory: string;
      sessionDate: string;
      sessionTime: string;
      duration: number;
      subject: string;
      sessionCost: string;
      advanceAmount: string;
      balanceAmount: string;
    },
  ): Promise<void> {
    await this.mailer.sendMail({
      to,
      subject: `LaaS: Session Booked with ${context.mentorName}`,
      template: 'session-booked-student',
      context,
      attachments: this.getLogoAttachments(),
    });
  }

  async sendSessionBookedMentorEmail(
    to: string,
    context: {
      mentorName: string;
      studentName: string;
      sessionCategory: string;
      sessionDate: string;
      sessionTime: string;
      duration: number;
      subject: string;
      description: string;
      sessionCost: string;
      hasAttachment: boolean;
      attachmentName?: string;
    },
  ): Promise<void> {
    await this.mailer.sendMail({
      to,
      subject: `LaaS: New Session Booking from ${context.studentName}`,
      template: 'session-booked-mentor',
      context,
      attachments: this.getLogoAttachments(),
    });
  }

  async sendSessionCancelledStudentEmail(
    to: string,
    context: {
      studentName: string;
      mentorName: string;
      sessionCategory: string;
      sessionDate: string;
      sessionTime: string;
      duration: number;
      sessionCost: string;
      advanceAmount: string;
      reason?: string;
    },
  ): Promise<void> {
    await this.mailer.sendMail({
      to,
      subject: `LaaS: Session Cancelled — ${context.mentorName}`,
      template: 'session-cancelled-student',
      context,
      attachments: this.getLogoAttachments(),
    });
  }

  async sendSessionCancelledMentorEmail(
    to: string,
    context: {
      mentorName: string;
      studentName: string;
      sessionCategory: string;
      sessionDate: string;
      sessionTime: string;
      duration: number;
      sessionCost: string;
      advanceAmount: string;
      reason?: string;
    },
  ): Promise<void> {
    await this.mailer.sendMail({
      to,
      subject: `LaaS: Session Cancelled — ${context.studentName}`,
      template: 'session-cancelled-mentor',
      context,
      attachments: this.getLogoAttachments(),
    });
  }

  // ── Meet Now Session Emails ──

  async sendMeetNowRequestMentorEmail(
    to: string,
    context: {
      mentorName: string;
      studentName: string;
      sessionCategory: string;
      duration: number;
      subject: string;
      description: string;
      sessionCost: string;
      hasAttachment: boolean;
      attachmentName?: string;
    },
  ): Promise<void> {
    await this.mailer.sendMail({
      to,
      subject: `LaaS: Meet Now Request from ${context.studentName}`,
      template: 'session-meetnow-mentor',
      context,
      attachments: this.getLogoAttachments(),
    });
  }

  async sendMeetNowRequestStudentEmail(
    to: string,
    context: {
      studentName: string;
      mentorName: string;
      sessionCategory: string;
      duration: number;
      subject: string;
      sessionCost: string;
    },
  ): Promise<void> {
    await this.mailer.sendMail({
      to,
      subject: `LaaS: Meet Now Request Sent — ${context.mentorName}`,
      template: 'session-meetnow-student',
      context,
      attachments: this.getLogoAttachments(),
    });
  }

  async sendMeetNowLiveStudentEmail(
    to: string,
    context: {
      studentName: string;
      mentorName: string;
      sessionCategory: string;
      duration: number;
      subject: string;
      sessionCost: string;
    },
  ): Promise<void> {
    await this.mailer.sendMail({
      to,
      subject: `LaaS: Session Live — ${context.mentorName}`,
      template: 'session-meetnow-live-student',
      context,
      attachments: this.getLogoAttachments(),
    });
  }
}
