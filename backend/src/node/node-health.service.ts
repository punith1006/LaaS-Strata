import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { PrismaService } from '../prisma/prisma.service';
import { NodeStatus } from '@prisma/client';

@Injectable()
export class NodeHealthService {
  private readonly logger = new Logger(NodeHealthService.name);

  constructor(private readonly prisma: PrismaService) {}

  @Cron(CronExpression.EVERY_MINUTE)
  async checkNodeHealth(): Promise<void> {
    const nodes = await this.prisma.node.findMany();

    for (const node of nodes) {
      // Skip nodes in maintenance, draining, or inactive — don't override those statuses
      if (
        node.status === NodeStatus.maintenance ||
        node.status === NodeStatus.draining ||
        node.status === NodeStatus.inactive
      ) {
        continue;
      }

      let sessionOrchOk = false;
      let storageOk = false;

      const ip = node.ipManagement || node.ipCompute;

      try {
        const orchUrl = `http://${ip}:${node.sessionOrchestrationPort}/health`;
        const orchRes = await fetch(orchUrl, {
          signal: AbortSignal.timeout(5000),
        });
        sessionOrchOk = orchRes.ok;
      } catch (err) {
        const msg = err instanceof Error ? err.message : String(err);
        this.logger.warn(
          `Session orchestration unreachable on ${node.hostname}: ${msg}`,
        );
      }

      try {
        const storageUrl = `http://${ip}:${node.storageProvisionPort}/health`;
        const storageRes = await fetch(storageUrl, {
          signal: AbortSignal.timeout(5000),
        });
        storageOk = storageRes.ok;
      } catch (err) {
        const msg = err instanceof Error ? err.message : String(err);
        this.logger.warn(
          `Storage provision unreachable on ${node.hostname}: ${msg}`,
        );
      }

      // Determine new status
      let newStatus: NodeStatus;
      if (sessionOrchOk && storageOk) {
        newStatus = NodeStatus.healthy;
      } else if (sessionOrchOk || storageOk) {
        newStatus = NodeStatus.degraded;
      } else {
        newStatus = NodeStatus.offline;
      }

      // Update node in DB
      await this.prisma.node.update({
        where: { id: node.id },
        data: {
          status: newStatus,
          lastHeartbeatAt: new Date(),
        },
      });

      if (newStatus !== NodeStatus.healthy) {
        this.logger.warn(
          `Node ${node.hostname} status: ${newStatus} (orchestration: ${sessionOrchOk}, storage: ${storageOk})`,
        );
      }
    }
  }
}
