import {
  Controller,
  Get,
  Post,
  Delete,
  Param,
  Body,
  Req,
  UseGuards,
} from '@nestjs/common';
import { IsBoolean, IsNumber, IsOptional, IsString } from 'class-validator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { MentorAvailabilityService } from './mentor-availability.service';

class CreateSlotDto {
  @IsOptional()
  @IsNumber()
  dayOfWeek?: number;

  @IsOptional()
  @IsString()
  specificDate?: string;

  @IsString()
  startTime: string;

  @IsString()
  endTime: string;

  @IsBoolean()
  isRecurring: boolean;
}

@Controller('api/mentor/availability')
export class MentorAvailabilityController {
  constructor(private readonly service: MentorAvailabilityService) {}

  @UseGuards(JwtAuthGuard)
  @Get()
  async getSlots(@Req() req: { user: { id: string } }) {
    return this.service.getSlots(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Post()
  async createSlot(
    @Req() req: { user: { id: string } },
    @Body() dto: CreateSlotDto,
  ) {
    return this.service.createSlot(req.user.id, dto);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  async deleteSlot(
    @Param('id') id: string,
    @Req() req: { user: { id: string } },
  ) {
    return this.service.deleteSlot(req.user.id, id);
  }
}
