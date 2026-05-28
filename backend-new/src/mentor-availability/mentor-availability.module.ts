import { Module } from '@nestjs/common';
import { MentorAvailabilityController } from './mentor-availability.controller';
import { MentorAvailabilityService } from './mentor-availability.service';

@Module({
  controllers: [MentorAvailabilityController],
  providers: [MentorAvailabilityService],
  exports: [MentorAvailabilityService],
})
export class MentorAvailabilityModule {}
