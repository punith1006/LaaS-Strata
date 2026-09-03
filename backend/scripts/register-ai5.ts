import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  // Upsert ai5 (aiserver5)
  const node = await prisma.node.upsert({
    where: { hostname: 'aiserver5' },
    update: {
      status: 'healthy',
      ipManagement: '20.1.1.138',   // Swapped: Management (20.1.1.x)
      ipCompute: '103.115.236.38',   // Swapped: Compute/Public (103.115.236.x)
      ipStorage: '10.10.100.138',
    },
    create: {
      hostname: 'aiserver5',
      displayName: 'AI Server 5 — Prod (RTX 4090)',
      ipManagement: '20.1.1.138',
      ipCompute: '103.115.236.38',
      ipStorage: '10.10.100.138',
      cpuModel: 'AMD Ryzen 9 7950X3D',
      totalVcpu: 32,                 // 16 cores / 32 threads
      totalMemoryMb: 65536,          // 64 GB
      totalGpuVramMb: 24576,         // 24 GB for RTX 4090
      gpuModel: 'RTX 4090',
      nvmeTotalGb: 2000,             // 2 TB NVMe
      status: 'healthy',
      maxConcurrentSessions: 12,     // Max concurrent sessions
      sessionOrchestrationPort: 9998,
      storageProvisionPort: 9999,
      nvmeOfPort: 4420,
      storageHeadroomGb: 15,
      metadata: {
        smTotal: 128,                // 128 SMs for RTX 4090
        cudaArch: 'sm_89',           // Ada Lovelace
        reservedVcpu: 2,
        driverVersion: '570.x',      
        allocatableVcpu: 30,
        reservedMemoryMb: 10240,
        reservedGpuVramMb: 1024,
        allocatableMemoryMb: 55296,
        allocatableGpuVramMb: 23552, 
      },
    },
  });

  console.log('Successfully registered ai5 production node:');
  console.log(JSON.stringify(node, null, 2));

  // Find all active base images and link them to the ai5 node
  const baseImages = await prisma.baseImage.findMany();

  for (const img of baseImages) {
    await prisma.nodeBaseImage.upsert({
      where: { nodeId_baseImageId: { nodeId: node.id, baseImageId: img.id } },
      create: {
        nodeId: node.id,
        baseImageId: img.id,
        status: 'pulled',
      },
      update: { status: 'pulled' }
    });
    console.log(`Linked base image "${img.tag}" to ai5 node.`);
  }
}

main()
  .then(() => prisma.$disconnect())
  .catch((e) => {
    console.error(e);
    prisma.$disconnect();
    process.exit(1);
  });
