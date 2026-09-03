import { Controller, Post, Body } from '@nestjs/common';
import { IsOptional, IsString, IsNumber } from 'class-validator';
import { JitsiDemoService } from './jitsi-demo.service';

class CreateJitsiLinkDto {
  @IsOptional()
  @IsString()
  displayName?: string;

  @IsOptional()
  @IsNumber()
  ttlSeconds?: number;
}

class ParticipantLinkDto {
  @IsString()
  roomName: string;

  @IsOptional()
  @IsString()
  displayName?: string;

  @IsOptional()
  @IsNumber()
  ttlSeconds?: number;
}

@Controller('api/test/jitsi-link')
export class JitsiDemoController {
  constructor(private readonly jitsiService: JitsiDemoService) {}

  /**
   * POST /api/test/jitsi-link
   *
   * Generate a time-limited Jitsi meeting URL.
   * No auth guard — for demo/testing only.
   *
   * Body:
   *   displayName?: string  — name shown in the meeting (default: "Guest")
   *   ttlSeconds?:  number  — token lifetime in seconds (default: 300)
   *
   * Returns:
   *   { roomName, jwt, meetingUrl, expiresAt }
   */
  @Post()
  createLink(@Body() dto: CreateJitsiLinkDto) {
    return this.jitsiService.generateMeetingLink(
      dto.displayName,
      dto.ttlSeconds,
    );
  }

  /**
   * POST /api/test/jitsi-link/participant
   *
   * Generate a JWT token for a participant to join an existing room.
   * This prevents invitees from seeing username/password prompts.
   *
   * Body:
   *   roomName:    string  — the room to join (required)
   *   displayName?: string — name shown in the meeting
   *   ttlSeconds?:  number — token lifetime (default: 300)
   */
  @Post('participant')
  createParticipantLink(@Body() dto: ParticipantLinkDto) {
    return this.jitsiService.generateParticipantToken(
      dto.roomName,
      dto.displayName,
      dto.ttlSeconds,
    );
  }
}
