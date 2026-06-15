import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  // Upsert ai4 (aiserver4)
  const node = await prisma.node.upsert({
    where: { hostname: 'aiserver4' },
    update: {
      status: 'healthy',
      ipManagement: '103.115.236.37',
      ipCompute: '20.1.1.136',
      ipStorage: '10.10.100.136',
    },
    create: {
      hostname: 'aiserver4',
      displayName: 'AI Server 4 — Prod (RTX 4090)',
      ipManagement: '103.115.236.37',
      ipCompute: '20.1.1.136',
      ipStorage: '10.10.100.136',
      cpuModel: 'AMD Ryzen 9 7950X3D',
      totalVcpu: 16,
      totalMemoryMb: 65536,          // 64 GB
      totalGpuVramMb: 24576,         // 24 GB for RTX 4090
      gpuModel: 'RTX 4090',
      nvmeTotalGb: 2000,
      status: 'healthy',
      maxConcurrentSessions: 8,     
      sessionOrchestrationPort: 9998,
      storageProvisionPort: 9999,
      nvmeOfPort: 4420,
      storageHeadroomGb: 15,
      metadata: {
        smTotal: 128,                
        cudaArch: 'sm_89',          
        reservedVcpu: 2,
        driverVersion: '565.x',      
        allocatableVcpu: 14,
        reservedMemoryMb: 10240,
        reservedGpuVramMb: 1024,
        allocatableMemoryMb: 55296,
        allocatableGpuVramMb: 23552, 
      },
    },
  });

  console.log('Successfully registered ai4 production node:');
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
    console.log('Linked selkies-egl-desktop:ubuntu2204-poc to ai4 node.');
  }
}

main()
  .then(() => prisma.$disconnect())
  .catch((e) => {
    console.error(e);
    prisma.$disconnect();
    process.exit(1);
  });
