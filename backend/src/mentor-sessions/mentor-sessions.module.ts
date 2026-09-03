import { Module } from '@nestjs/common';
import { MentorSessionsController } from './mentor-sessions.controller';
import { MentorSessionsService } from './mentor-sessions.service';
import { MailModule } from '../mail/mail.module';

@Module({
  imports: [MailModule],
  controllers: [MentorSessionsController],
  providers: [MentorSessionsService],
  exports: [MentorSessionsService],
})
export class MentorSessionsModule {}
