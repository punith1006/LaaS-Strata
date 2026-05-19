import {
  Controller,
  Post,
  Get,
  Body,
  Param,
  UseGuards,
  Req,
  Res,
  HttpCode,
  HttpStatus,
  BadRequestException,
} from '@nestjs/common';
import { FastifyRequest, FastifyReply } from 'fastify';
import {
  SupportService,
  CreateSupportTicketDto,
  SupportTicketAttachmentInput,
} from './support.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

const ALLOWED_MIME_TYPES = new Set([
  'image/jpeg',
  'image/png',
  'image/gif',
  'image/webp',
  'image/bmp',
]);
const MAX_FILE_SIZE_BYTES = 3 * 1024 * 1024; // 3MB
const MAX_FILE_COUNT = 3;

@Controller('api/support')
@UseGuards(JwtAuthGuard)
export class SupportController {
  constructor(private readonly supportService: SupportService) {}

  @Post('tickets')
  @HttpCode(HttpStatus.CREATED)
  async createTicket(
    @Req() req: FastifyRequest & { user: { id: string } },
    @Body() body: CreateSupportTicketDto,
  ) {
    const dto: CreateSupportTicketDto = {
      category: body?.category,
      subject: body?.subject,
      description: body?.description,
    };
    const files: SupportTicketAttachmentInput[] = [];

    // If the request is multipart/form-data, parse parts to extract fields + files.
    // Otherwise (JSON), keep using the @Body() values as-is.
    const contentType = (req.headers?.['content-type'] || '').toString();
    if (contentType.toLowerCase().includes('multipart/form-data')) {
      // Reset dto so we collect from form fields
      dto.category = '';
      dto.subject = '';
      dto.description = '';

      const parts = (req as any).parts();
      for await (const part of parts as AsyncIterable<any>) {
        if (part.type === 'field') {
          const value = typeof part.value === 'string' ? part.value : '';
          switch (part.fieldname) {
            case 'category':
              dto.category = value;
              break;
            case 'subject':
              dto.subject = value;
              break;
            case 'description':
              dto.description = value;
              break;
            default:
              break;
          }
        } else if (part.type === 'file') {
          if (part.fieldname !== 'attachments') {
            // Drain stream to avoid hanging the request
            // eslint-disable-next-line @typescript-eslint/no-unused-vars
            for await (const _chunk of part.file) {
              // discard
            }
            continue;
          }

          if (files.length >= MAX_FILE_COUNT) {
            // Drain remaining file stream and reject
            // eslint-disable-next-line @typescript-eslint/no-unused-vars
            for await (const _chunk of part.file) {
              // discard
            }
            throw new BadRequestException(
              `A maximum of ${MAX_FILE_COUNT} attachments are allowed`,
            );
          }

          const mimeType = (part.mimetype || '').toString().toLowerCase();
          if (!ALLOWED_MIME_TYPES.has(mimeType)) {
            // eslint-disable-next-line @typescript-eslint/no-unused-vars
            for await (const _chunk of part.file) {
              // discard
            }
            throw new BadRequestException(
              `Unsupported file type "${mimeType}". Allowed types: JPEG, PNG, GIF, WebP, BMP`,
            );
          }

          const chunks: Buffer[] = [];
          let total = 0;
          let exceeded = false;
          for await (const chunk of part.file) {
            const buf = chunk as Buffer;
            total += buf.length;
            if (total > MAX_FILE_SIZE_BYTES) {
              exceeded = true;
              // keep draining to release the stream
            } else {
              chunks.push(buf);
            }
          }

          if (exceeded || (part.file as any)?.truncated) {
            throw new BadRequestException(
              `File "${part.filename}" exceeds the maximum size of 3MB`,
            );
          }

          const buffer = Buffer.concat(chunks);
          files.push({
            fileName: part.filename || 'attachment',
            mimeType,
            size: buffer.length,
            buffer,
          });
        }
      }
    }

    if (!dto.category || !dto.subject || !dto.description) {
      throw new BadRequestException(
        'category, subject, and description are required',
      );
    }

    const result = await this.supportService.createTicket(
      req.user.id,
      dto,
      files,
    );
    return {
      success: true,
      data: result,
    };
  }

  @Post('tickets/list')
  @HttpCode(HttpStatus.OK)
  async getUserTickets(@Req() req: FastifyRequest & { user: { id: string } }) {
    const tickets = await this.supportService.getUserTickets(req.user.id);
    return {
      success: true,
      data: tickets,
    };
  }

  @Get('tickets/:ticketId/attachments')
  @HttpCode(HttpStatus.OK)
  async listTicketAttachments(
    @Req() req: FastifyRequest & { user: { id: string } },
    @Param('ticketId') ticketId: string,
  ) {
    const attachments = await this.supportService.getTicketAttachments(
      ticketId,
      req.user.id,
    );
    return {
      success: true,
      data: attachments,
    };
  }

  @Get('tickets/:ticketId/attachments/:attachmentId')
  async getAttachment(
    @Req() req: FastifyRequest & { user: { id: string } },
    @Param('ticketId') ticketId: string,
    @Param('attachmentId') attachmentId: string,
    @Res() res: FastifyReply,
  ) {
    const attachment = await this.supportService.getAttachmentFile(
      ticketId,
      attachmentId,
      req.user.id,
    );
    return res
      .header('Content-Type', attachment.mimeType)
      .header(
        'Content-Disposition',
        `inline; filename="${attachment.fileName}"`,
      )
      .header('Content-Length', attachment.size.toString())
      .send(attachment.data);
  }

  // ---------------- Admin Endpoints ----------------

  @Get('admin/tickets/unresolved')
  @HttpCode(HttpStatus.OK)
  async adminGetUnresolvedTickets(
    @Req() req: FastifyRequest & { user: { id: string } },
  ) {
    await this.supportService.assertAdminRole(req.user.id);
    const data = await this.supportService.getUnresolvedTicketsAdmin();
    return { success: true, data };
  }

  @Post('admin/tickets/:id/resolve')
  @HttpCode(HttpStatus.OK)
  async adminResolveTicket(
    @Req() req: FastifyRequest & { user: { id: string } },
    @Param('id') id: string,
    @Body() body: { resolutionNotes?: string },
  ) {
    await this.supportService.assertAdminRole(req.user.id);
    const data = await this.supportService.resolveTicketAdmin(
      id,
      body?.resolutionNotes,
    );
    return { success: true, data };
  }

  @Get('admin/tickets/:id')
  @HttpCode(HttpStatus.OK)
  async adminGetTicketDetail(
    @Req() req: FastifyRequest & { user: { id: string } },
    @Param('id') id: string,
  ) {
    await this.supportService.assertAdminRole(req.user.id);
    const data = await this.supportService.getTicketDetailAdmin(id);
    return { success: true, data };
  }

  @Get('admin/tickets/:id/attachments/:attachmentId')
  async adminGetAttachment(
    @Req() req: FastifyRequest & { user: { id: string } },
    @Param('id') _id: string,
    @Param('attachmentId') attachmentId: string,
    @Res() res: FastifyReply,
  ) {
    await this.supportService.assertAdminRole(req.user.id);
    const attachment =
      await this.supportService.getAttachmentFileAdmin(attachmentId);
    return res
      .header('Content-Type', attachment.mimeType)
      .header(
        'Content-Disposition',
        `inline; filename="${attachment.fileName}"`,
      )
      .header('Content-Length', attachment.size.toString())
      .send(attachment.data);
  }
}
