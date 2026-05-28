import {
  Controller,
  Get,
  Post,
  Param,
  Body,
  Req,
  UseGuards,
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
}
