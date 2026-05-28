import { Injectable, Logger } from '@nestjs/common';
import * as jwt from 'jsonwebtoken';
import * as crypto from 'crypto';

export interface JitsiLinkResult {
  roomName: string;
  jwt: string;
  jitsiDirectUrl: string;
  meetingUrl: string;
  expiresAt: string;
  debug: {
    issuedAt: number;
    expiresAt: number;
    ttlSeconds: number;
    issuedAtISO: string;
  };
}

@Injectable()
export class JitsiDemoService {
  private readonly logger = new Logger(JitsiDemoService.name);

  private get baseUrl(): string {
    return process.env.JITSI_BASE_URL || '';
  }

  private get appId(): string {
    return process.env.JITSI_APP_ID || 'laas-platform';
  }

  private get appSecret(): string {
    const secret = process.env.JITSI_APP_SECRET;
    if (!secret) {
      throw new Error('JITSI_APP_SECRET is not set in environment');
    }
    return secret;
  }

  /**
   * Generate a time-limited Jitsi meeting link.
   *
   * The JWT is signed with the shared JITSI_APP_SECRET and verified
   * by the Prosody token_verification plugin on the Jitsi server.
   *
   * @param displayName - Optional display name shown to other participants
   * @param ttlSeconds  - Token lifetime in seconds (default: 300 = 5 minutes)
   */
  generateMeetingLink(
    displayName?: string,
    ttlSeconds = 300,
  ): JitsiLinkResult {
    const roomName = `demo-${crypto.randomUUID().slice(0, 8)}`;
    const now = Math.floor(Date.now() / 1000);
    const exp = now + ttlSeconds;

    const payload: jwt.JwtPayload = {
      aud: 'jitsi',
      iss: this.appId,
      sub: 'meet.jitsi',
      room: roomName,
      exp,
      context: {
        user: {
          name: displayName || 'Guest',
          email: '',
          id: crypto.randomUUID(),
        },
      },
    };

    const token = jwt.sign(payload, this.appSecret, {
      algorithm: 'HS256',
    });

    const jitsiDirectUrl = `${this.baseUrl}/${roomName}?jwt=${token}`;
    const frontendUrl = process.env.FRONTEND_URL || 'http://localhost:3000';
    const meetingUrl = `${frontendUrl}/meeting?room=${roomName}&jwt=${token}&baseUrl=${encodeURIComponent(this.baseUrl)}`;
    const expiresAt = new Date(exp * 1000).toISOString();

    this.logger.log(
      `Generated Jitsi link for room "${roomName}" — expires at ${expiresAt}`,
    );

    return {
      roomName,
      jwt: token,
      jitsiDirectUrl,
      meetingUrl,
      expiresAt,
      debug: {
        issuedAt: now,
        expiresAt: exp,
        ttlSeconds,
        issuedAtISO: new Date(now * 1000).toISOString(),
      },
    };
  }
}
