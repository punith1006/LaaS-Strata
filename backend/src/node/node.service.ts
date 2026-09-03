import {
  Injectable,
  Logger,
  ServiceUnavailableException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Node } from '@prisma/client';

// Statuses that consume resources (session is considered "active" for resource purposes)
const RESOURCE_CONSUMING_STATUSES = [
  'pending',
  'starting',
  'running',
  'reconnecting',
];

/** Per-node allocatable resources (total minus OS/system overhead). */
interface Allocatable {
  vramMb: number;
  vcpu: number;
  ramMb: number;
}

/** Result of fleet-wide config availability check. */
export interface FleetConfigAvailability {
  configId: string;
  available: boolean;
  maxLaunchable: number;
}

@Injectable()
export class NodeService {
  private readonly logger = new Logger(NodeService.name);

  constructor(private readonly prisma: PrismaService) {}

  // ============================================================================
  // HELPER: Derive allocatable resources from a Node row
  // ============================================================================

  private getAllocatableForNode(node: Node): Allocatable {
    const metadata = node.metadata as Record<string, unknown> | null;
    return {
      vramMb:
        (metadata?.allocatableGpuVramMb as number) ??
        node.totalGpuVramMb - 1024,
      vcpu: (metadata?.allocatableVcpu as number) ?? node.totalVcpu - 2,
      ramMb:
        (metadata?.allocatableMemoryMb as number) ??
        node.totalMemoryMb - 10240,
    };
  }

  // ============================================================================
  // HELPER: Get used resources per node from active sessions
  // ============================================================================

  private async getUsedResourcesByNode(): Promise<
    Map<string, { vramMb: number; vcpu: number; ramMb: number }>
  > {
    const activeSessions = await this.prisma.session.findMany({
      where: { status: { in: RESOURCE_CONSUMING_STATUSES as any[] } },
      include: { computeConfig: true },
    });

    const usedMap = new Map<
      string,
      { vramMb: number; vcpu: number; ramMb: number }
    >();

    for (const s of activeSessions) {
      const nodeId = s.nodeId;
      if (!nodeId) continue;

      const current = usedMap.get(nodeId) || { vramMb: 0, vcpu: 0, ramMb: 0 };
      current.vramMb += s.allocatedGpuVramMb ?? s.computeConfig.gpuVramMb;
      current.vcpu += s.allocatedVcpu ?? s.computeConfig.vcpu;
      current.ramMb += s.allocatedMemoryMb ?? s.computeConfig.memoryMb;
      usedMap.set(nodeId, current);
    }

    return usedMap;
  }

  // ============================================================================
  // 2a. Fleet-wide compute config availability (for UI)
  // ============================================================================

  /**
   * For each active compute config, checks whether ANY healthy node in the
   * fleet can serve it. Returns a map of configId -> availability info.
   */
  async getFleetConfigAvailability(): Promise<FleetConfigAvailability[]> {
    // 1. Get all healthy nodes
    const healthyNodes = await this.prisma.node.findMany({
      where: { status: 'healthy' },
    });

    if (healthyNodes.length === 0) {
      // No healthy nodes — all configs unavailable
      const configs = await this.prisma.computeConfig.findMany({
        where: { isActive: true },
      });
      return configs.map((c) => ({
        configId: c.id,
        available: false,
        maxLaunchable: 0,
      }));
    }

    // 2. Get resource usage per node
    const usedMap = await this.getUsedResourcesByNode();

    // 3. Compute free resources per node
    const nodesFree = healthyNodes.map((node) => {
      const alloc = this.getAllocatableForNode(node);
      const used = usedMap.get(node.id) || { vramMb: 0, vcpu: 0, ramMb: 0 };
      return {
        nodeId: node.id,
        freeVramMb: alloc.vramMb - used.vramMb,
        freeVcpu: alloc.vcpu - used.vcpu,
        freeRamMb: alloc.ramMb - used.ramMb,
      };
    });

    // 4. For each config, check if any node can fit it
    const configs = await this.prisma.computeConfig.findMany({
      where: { isActive: true },
      orderBy: { sortOrder: 'asc' },
    });

    return configs.map((config) => {
      let totalMaxLaunchable = 0;

      for (const nf of nodesFree) {
        const fitsVram =
          config.gpuVramMb <= nf.freeVramMb;
        const fitsCpu = config.vcpu <= nf.freeVcpu;
        const fitsRam = config.memoryMb <= nf.freeRamMb;

        if (fitsVram && fitsCpu && fitsRam) {
          const byVram =
            config.gpuVramMb > 0
              ? Math.floor(nf.freeVramMb / config.gpuVramMb)
              : Infinity;
          const byCpu =
            config.vcpu > 0
              ? Math.floor(nf.freeVcpu / config.vcpu)
              : Infinity;
          const byRam =
            config.memoryMb > 0
              ? Math.floor(nf.freeRamMb / config.memoryMb)
              : Infinity;
          let nodeLaunchable = Math.min(byVram, byCpu, byRam);
          if (!isFinite(nodeLaunchable)) nodeLaunchable = 0;
          totalMaxLaunchable += nodeLaunchable;
        }
      }

      return {
        configId: config.id,
        available: totalMaxLaunchable > 0,
        maxLaunchable: totalMaxLaunchable,
      };
    });
  }

  // ============================================================================
  // 2b. Balanced compute node selection
  // ============================================================================

  /**
   * Selects the least-congested healthy node that can fit the requested
   * resources. GPU VRAM is weighted heaviest (0.5) as the scarcest resource.
   */
  async selectComputeNode(
    requiredVcpu: number,
    requiredRamMb: number,
    requiredVramMb: number,
    requiredStorageGb: number = 0,
  ): Promise<Node> {
    const healthyNodes = await this.prisma.node.findMany({
      where: { status: 'healthy' },
    });

    if (healthyNodes.length === 0) {
      throw new ServiceUnavailableException(
        'No healthy compute nodes available',
      );
    }

    const usedMap = await this.getUsedResourcesByNode();

    type ScoredNode = { node: Node; score: number };
    const candidates: ScoredNode[] = [];

    for (const node of healthyNodes) {
      const alloc = this.getAllocatableForNode(node);
      const used = usedMap.get(node.id) || { vramMb: 0, vcpu: 0, ramMb: 0 };
      const free = {
        vramMb: alloc.vramMb - used.vramMb,
        vcpu: alloc.vcpu - used.vcpu,
        ramMb: alloc.ramMb - used.ramMb,
      };

      // 1. Skip nodes that can't fit the requested compute config
      if (
        free.vcpu < requiredVcpu ||
        free.ramMb < requiredRamMb ||
        free.vramMb < requiredVramMb
      ) {
        continue;
      }

      candidates.push({ node, score: 0 });
    }

    if (candidates.length === 0) {
      throw new ServiceUnavailableException(
        `No node has enough free compute resources (need vcpu=${requiredVcpu}, ram=${requiredRamMb}MB, vram=${requiredVramMb}MB)`,
      );
    }

    // 2. If storage is also required (e.g. ephemeral sessions), filter by storage availability
    let finalCandidates = candidates;
    if (requiredStorageGb > 0) {
      this.logger.log(
        `Filtering ${candidates.length} nodes for ${requiredStorageGb}GB ephemeral storage availability...`,
      );
      const storageResults = await Promise.all(
        candidates.map(async (c) => {
          const hasSpace = await this.checkNodeStorageAvailability(
            c.node,
            requiredStorageGb,
          );
          return { ...c, hasSpace };
        }),
      );
      finalCandidates = storageResults.filter((r) => r.hasSpace);

      this.logger.log(
        `Storage filtering complete: ${finalCandidates.length}/${candidates.length} nodes have sufficient space.`,
      );
    }

    if (finalCandidates.length === 0) {
      throw new ServiceUnavailableException(
        `No node has enough free resources AND storage space (need vcpu=${requiredVcpu}, vram=${requiredVramMb}MB, storage=${requiredStorageGb}GB)`,
      );
    }

    // 3. Score the remaining candidates
    for (const c of finalCandidates) {
      const alloc = this.getAllocatableForNode(c.node);
      const used = usedMap.get(c.node.id) || { vramMb: 0, vcpu: 0, ramMb: 0 };
      const free = {
        vramMb: alloc.vramMb - used.vramMb,
        vcpu: alloc.vcpu - used.vcpu,
        ramMb: alloc.ramMb - used.ramMb,
      };

      // Score: higher = more headroom = preferred
      // VRAM weighted 0.5, RAM 0.3, CPU 0.2
      c.score =
        (alloc.vcpu > 0 ? (free.vcpu / alloc.vcpu) * 0.2 : 0) +
        (alloc.ramMb > 0 ? (free.ramMb / alloc.ramMb) * 0.3 : 0) +
        (alloc.vramMb > 0 ? (free.vramMb / alloc.vramMb) * 0.5 : 0);
    }

    // Pick the node with the highest score (most headroom)
    finalCandidates.sort((a, b) => b.score - a.score);
    const selected = finalCandidates[0];

    this.logger.log(
      `Selected compute node ${selected.node.hostname} (score=${selected.score.toFixed(3)}) for vcpu=${requiredVcpu} ram=${requiredRamMb}MB vram=${requiredVramMb}MB`,
    );

    return selected.node;
  }

  // ============================================================================
  // 2c. Sequential storage node selection
  // ============================================================================

  /**
   * Returns an ordered list of healthy nodes that have enough space for the
   * requested quota. Ordered by hostname (Sequential filling).
   */
  async selectStorageNodeCandidates(requiredQuotaGb: number): Promise<Node[]> {
    const healthyNodes = await this.prisma.node.findMany({
      where: { status: 'healthy' },
      orderBy: { hostname: 'asc' },
    });

    if (healthyNodes.length === 0) {
      throw new ServiceUnavailableException(
        'No healthy storage nodes available',
      );
    }

    const secret = process.env.USER_STORAGE_PROVISION_SECRET;
    const candidates: Node[] = [];

    for (const node of healthyNodes) {
      const ip = node.ipManagement || node.ipCompute;
      const url = `http://${ip}:${node.storageProvisionPort}/host-space`;

      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 5000);

      try {
        const headers: Record<string, string> = {};
        if (secret) headers['X-Storage-Secret'] = secret;

        const res = await fetch(url, {
          method: 'GET',
          headers,
          signal: controller.signal,
        });
        clearTimeout(timeoutId);

        if (!res.ok) {
          this.logger.warn(
            `Storage space check failed for ${node.hostname} (${url}): HTTP ${res.status}`,
          );
          continue;
        }

        const data = (await res.json()) as {
          availableGb: number;
          totalGb: number;
        };

        const remainingAfter = data.availableGb - requiredQuotaGb;
        if (remainingAfter >= node.storageHeadroomGb) {
          candidates.push(node);
        } else {
          this.logger.debug(
            `Node ${node.hostname} skipped for storage: ${data.availableGb}GB available, need ${requiredQuotaGb}GB + ${node.storageHeadroomGb}GB headroom`,
          );
        }
      } catch (err) {
        clearTimeout(timeoutId);
        const msg = err instanceof Error ? err.message : String(err);
        this.logger.warn(
          `Storage space check error for ${node.hostname} (${url}): ${msg}`,
        );
        continue;
      }
    }

    return candidates;
  }

  /**
   * Backward compatible: Selects the first available storage node.
   */
  async selectStorageNode(requiredQuotaGb: number): Promise<Node> {
    const candidates = await this.selectStorageNodeCandidates(requiredQuotaGb);
    if (candidates.length === 0) {
      throw new ServiceUnavailableException(
        `No node has enough storage space for ${requiredQuotaGb}GB (with headroom)`,
      );
    }
    return candidates[0];
  }

  /**
   * Helper: Checks if a node has enough ZFS storage space available.
   */
  async checkNodeStorageAvailability(
    node: Node,
    requiredGb: number,
  ): Promise<boolean> {
    const secret = process.env.USER_STORAGE_PROVISION_SECRET;
    const ip = node.ipManagement || node.ipCompute;
    const url = `http://${ip}:${node.storageProvisionPort}/host-space`;

    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 5000);

    try {
      const headers: Record<string, string> = {};
      if (secret) headers['X-Storage-Secret'] = secret;

      const res = await fetch(url, {
        method: 'GET',
        headers,
        signal: controller.signal,
      });
      clearTimeout(timeoutId);

      if (!res.ok) return false;

      const data = (await res.json()) as {
        availableGb: number;
        totalGb: number;
      };

      const remainingAfter = data.availableGb - requiredGb;
      return remainingAfter >= node.storageHeadroomGb;
    } catch (err) {
      clearTimeout(timeoutId);
      return false;
    }
  }

  // ============================================================================
  // 2d. Node endpoint resolvers
  // ============================================================================

  getSessionOrchestrationUrl(node: Node): string {
    const ip = node.ipManagement || node.ipCompute;
    return `http://${ip}:${node.sessionOrchestrationPort}`;
  }

  getStorageProvisionUrl(node: Node): string {
    const ip = node.ipManagement || node.ipCompute;
    return `http://${ip}:${node.storageProvisionPort}`;
  }
}
