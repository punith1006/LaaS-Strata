import { Module } from '@nestjs/common';
import { NodeService } from './node.service';
import { NodeHealthService } from './node-health.service';

@Module({
  providers: [NodeService, NodeHealthService],
  exports: [NodeService],
})
export class NodeModule {}
