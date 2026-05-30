import {
  Controller,
  Get,
  Post,
  Param,
  Body,
  Query,
  Req,
  UseGuards,
  BadRequestException,
} from '@nestjs/common';
import { IsOptional, IsString } from 'class-validator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { MentorSessionsService } from './mentor-sessions.service';

class RejectSessionDto {
  @IsOptional()
  @IsString()
  reason?: string;
}

class CancelSessionDto {
  @IsOptional()
  @IsString()
  reason?: string;
}

@Controller('api/mentor-sessions')
export class MentorSessionsController {
  constructor(private readonly service: MentorSessionsService) {}

  @UseGuards(JwtAuthGuard)
  @Get('calendar')
  async getCalendar(@Req() req: { user: { id: string } }) {
    return this.service.getCalendar(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Get('requests')
  async getRequests(@Req() req: { user: { id: string } }) {
    return this.service.getRequests(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Get('upcoming')
  async getUpcoming(@Req() req: { user: { id: string } }) {
    return this.service.getUpcoming(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Get('live')
  async getLive(@Req() req: { user: { id: string } }) {
    return this.service.getLive(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Get('past')
  async getPast(@Req() req: { user: { id: string } }) {
    return this.service.getPast(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Get('billing-stats')
  async getBillingStats(@Req() req: { user: { id: string } }) {
    return this.service.getMentorBillingStats(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Post(':id/approve')
  async approve(
    @Param('id') id: string,
    @Req() req: { user: { id: string } },
  ) {
    return this.service.approveSession(req.user.id, id);
  }

  @UseGuards(JwtAuthGuard)
  @Post(':id/reject')
  async reject(
    @Param('id') id: string,
    @Req() req: { user: { id: string } },
    @Body() dto: RejectSessionDto,
  ) {
    return this.service.rejectSession(req.user.id, id, dto.reason);
  }

  @UseGuards(JwtAuthGuard)
  @Post(':id/cancel')
  async cancel(
    @Param('id') id: string,
    @Req() req: { user: { id: string } },
    @Body() dto: CancelSessionDto,
  ) {
    return this.service.cancelSession(req.user.id, id, dto.reason);
  }

  @UseGuards(JwtAuthGuard)
  @Post(':id/student-cancel')
  async studentCancel(
    @Param('id') id: string,
    @Req() req: { user: { id: string } },
    @Body() dto: CancelSessionDto,
  ) {
    return this.service.studentCancelSession(req.user.id, id, dto.reason);
  }

  @UseGuards(JwtAuthGuard)
  @Get('available-slots/:mentorProfileId')
  async getAvailableSlots(
    @Param('mentorProfileId') mentorProfileId: string,
    @Query('date') date: string,
  ) {
    return this.service.getAvailableSlots(mentorProfileId, date);
  }

  @UseGuards(JwtAuthGuard)
  @Get('available-slots/:mentorProfileId/calendar')
  async getAvailableDates(
    @Param('mentorProfileId') mentorProfileId: string,
    @Query('month') month: string,
  ) {
    return this.service.getAvailableDatesForMonth(mentorProfileId, month);
  }

  @UseGuards(JwtAuthGuard)
  @Get('profile/:mentorProfileId')
  async getMentorProfile(
    @Param('mentorProfileId') mentorProfileId: string,
  ) {
    return this.service.getMentorProfile(mentorProfileId);
  }

  @UseGuards(JwtAuthGuard)
  @Get('explore')
  async exploreMentors(
    @Query('search') search?: string,
    @Query('domains') domains?: string,
    @Query('expertise') expertise?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.service.exploreMentors({
      search,
      domains: domains ? domains.split(',').map((d) => d.trim()).filter(Boolean) : undefined,
      expertise: expertise ? expertise.split(',').map((e) => e.trim()).filter(Boolean) : undefined,
      page: page ? parseInt(page, 10) : 1,
      limit: limit ? parseInt(limit, 10) : 12,
    });
  }

  @UseGuards(JwtAuthGuard)
  @Post('upload-attachment')
  async uploadAttachment(@Req() req: any): Promise<{
    fileName: string;
    filePath: string;
    mimeType: string;
    sizeBytes: number;
  }> {
    return this.service.uploadAttachment(req);
  }

  @UseGuards(JwtAuthGuard)
  @Post('book')
  async bookSession(
    @Req() req: { user: { id: string } },
    @Body() body: any,
  ) {
    return this.service.bookSession(req.user.id, body);
  }

  @UseGuards(JwtAuthGuard)
  @Get('student-upcoming')
  async getStudentUpcoming(@Req() req: { user: { id: string } }) {
    return this.service.getStudentUpcoming(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Get('student-requests')
  async getStudentRequests(@Req() req: { user: { id: string } }) {
    return this.service.getStudentRequests(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Get('student-past')
  async getStudentPast(@Req() req: { user: { id: string } }) {
    return this.service.getStudentPast(req.user.id);
  }
}
