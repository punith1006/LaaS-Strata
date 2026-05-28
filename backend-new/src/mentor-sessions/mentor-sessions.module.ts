import { Module } from '@nestjs/common';
import { MentorSessionsController } from './mentor-sessions.controller';
import { MentorSessionsService } from './mentor-sessions.service';

@Module({
  controllers: [MentorSessionsController],
  providers: [MentorSessionsService],
  exports: [MentorSessionsService],
})
export class MentorSessionsModule {}
