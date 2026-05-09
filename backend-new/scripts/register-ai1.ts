import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  // 1. Mark all other nodes as offline so the scheduler only uses ai1
  await prisma.node.updateMany({
    where: { hostname: { not: 'aiserver1' } },
    data: { status: 'offline' }
  });
  console.log('Marked other nodes as offline.');

  // 2. Upsert ai1
  const node = await prisma.node.upsert({
    where: { hostname: 'aiserver1' },
    update: {
      status: 'healthy',
      ipManagement: '103.115.236.34',
      ipCompute: '100.115.142.23',
      ipStorage: '10.10.100.130',
    },
    create: {
      hostname: 'aiserver1',
      displayName: 'AI Server 1 — Prod (RTX 5090)',
      ipManagement: '103.115.236.34',
      ipCompute: '100.115.142.23',
      ipStorage: '10.10.100.130',
      cpuModel: 'AMD Ryzen 9 7950X',
      totalVcpu: 16,
      totalMemoryMb: 65536,
      totalGpuVramMb: 32768,         // 32 GB for RTX 5090
      gpuModel: 'RTX 5090',
      nvmeTotalGb: 2000,
      status: 'healthy',
      maxConcurrentSessions: 12,     // Increased due to higher VRAM
      sessionOrchestrationPort: 9998,
      storageProvisionPort: 9999,
      nvmeOfPort: 4420,
      storageHeadroomGb: 15,
      metadata: {
        smTotal: 170,                // Blackwell SM count
        cudaArch: 'sm_100',          // Blackwell Architecture
        reservedVcpu: 2,
        driverVersion: '570.x',      // Assuming latest drivers for 5090
        allocatableVcpu: 14,
        reservedMemoryMb: 10240,
        reservedGpuVramMb: 1024,
        allocatableMemoryMb: 55296,
        allocatableGpuVramMb: 31744, // 31 GB allocatable
      },
    },
  });

  console.log('Successfully registered ai1 production node:');
  console.log(JSON.stringify(node, null, 2));

  // Also ensure the base image exists for this node
  const baseImage = await prisma.baseImage.findUnique({
    where: { tag: 'selkies-egl-desktop:ubuntu2204-poc' }
  });

  if (baseImage) {
    await prisma.nodeBaseImage.upsert({
      where: { nodeId_baseImageId: { nodeId: node.id, baseImageId: baseImage.id } },
      create: {
        nodeId: node.id,
        baseImageId: baseImage.id,
        status: 'pulled',
      },
      update: { status: 'pulled' }
    });
    console.log('Linked selkies-egl-desktop:ubuntu2204-poc to ai1 node.');
  }
}

main()
  .then(() => prisma.$disconnect())
  .catch((e) => {
    console.error(e);
    prisma.$disconnect();
    process.exit(1);
  });
