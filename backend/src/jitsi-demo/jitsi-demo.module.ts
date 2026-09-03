import { Module } from '@nestjs/common';
import { JitsiDemoService } from './jitsi-demo.service';
import { JitsiDemoController } from './jitsi-demo.controller';

@Module({
  controllers: [JitsiDemoController],
  providers: [JitsiDemoService],
})
export class JitsiDemoModule {}
