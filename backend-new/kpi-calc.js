const { PrismaClient } = require('@prisma/client');
require('dotenv').config();

(async () => {
  const prisma = new PrismaClient();
  try {
    const now = new Date('2026-05-18T05:20:26.434Z');
    
    // Calculate period bounds
    const h24Start = new Date(now.getTime() - 24 * 60 * 60 * 1000);
    const d7Start = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
    
    console.log('CALCULATION TIME:', now.toISOString());
    console.log('24H period start:', h24Start.toISOString());
    console.log('7D period start:', d7Start.toISOString());
    console.log('\n=== REVENUE ===');
    
    // Revenue 24H
    const rev24h = await prisma.billingCharge.aggregate({
      _sum: { amountCents: true },
      where: { createdAt: { gte: h24Start } }
    });
    const rev24hTotal = Number(rev24h._sum.amountCents ?? 0);
    console.log('Revenue 24H (gte', h24Start.toISOString(), '):', rev24hTotal, 'paise =', rev24hTotal / 100, 'INR');
    
    // Revenue 7D
    const rev7d = await prisma.billingCharge.aggregate({
      _sum: { amountCents: true },
      where: { createdAt: { gte: d7Start } }
    });
    const rev7dTotal = Number(rev7d._sum.amountCents ?? 0);
    console.log('Revenue 7D (gte', d7Start.toISOString(), '):', rev7dTotal, 'paise =', rev7dTotal / 100, 'INR');
    console.log('Should differ?', rev24hTotal !== rev7dTotal);
    
    console.log('\n=== GPU HOURS (Current Logic - BUGGY) ===');
    
    // GPU hours 24H (current logic)
    const gpuData24h = await prisma.session.aggregate({
      _sum: { durationSeconds: true },
      _count: true,
      where: {
        status: { in: ['ended', 'terminated_idle', 'terminated_overuse'] },
        endedAt: { gte: h24Start }
      }
    });
    console.log('Ended sessions in 24H:', gpuData24h._count, 'sessions, duration:', gpuData24h._sum.durationSeconds ?? 0, 'seconds');
    
    // GPU hours 7D (current logic)
    const gpuData7d = await prisma.session.aggregate({
      _sum: { durationSeconds: true },
      _count: true,
      where: {
        status: { in: ['ended', 'terminated_idle', 'terminated_overuse'] },
        endedAt: { gte: d7Start }
      }
    });
    console.log('Ended sessions in 7D:', gpuData7d._count, 'sessions, duration:', gpuData7d._sum.durationSeconds ?? 0, 'seconds');
    
    // Running sessions (SAME for both - this is the bug!)
    const runningSessions = await prisma.session.findMany({
      where: { status: 'running', startedAt: { not: null } },
      select: { id: true, startedAt: true }
    });
    console.log('\nRunning sessions:', runningSessions.length);
    let runningElapsedSeconds = 0;
    for (const s of runningSessions) {
      const elapsed = Math.floor((now.getTime() - s.startedAt.getTime()) / 1000);
      console.log(`  Session ${s.id.substring(0,8)} started ${s.startedAt.toISOString()} | elapsed: ${elapsed}s (${(elapsed/3600).toFixed(1)}h)`);
      runningElapsedSeconds += elapsed;
    }
    
    const totalEndedSeconds24h = gpuData24h._sum.durationSeconds ?? 0;
    const totalEndedSeconds7d = gpuData7d._sum.durationSeconds ?? 0;
    const totalGpu24h = (totalEndedSeconds24h + runningElapsedSeconds) / 3600;
    const totalGpu7d = (totalEndedSeconds7d + runningElapsedSeconds) / 3600;
    
    console.log('\nTotal GPU hours (current logic):');
    console.log('24H: ended(' + (totalEndedSeconds24h/3600).toFixed(2) + 'h) + running(' + (runningElapsedSeconds/3600).toFixed(2) + 'h) =', totalGpu24h.toFixed(2), 'h');
    console.log('7D: ended(' + (totalEndedSeconds7d/3600).toFixed(2) + 'h) + running(' + (runningElapsedSeconds/3600).toFixed(2) + 'h) =', totalGpu7d.toFixed(2), 'h');
    console.log('SAME VALUE?', totalGpu24h === totalGpu7d, '<-- BUG!');
    
    console.log('\n=== ACTIVE USERS ===');
    const activeUsers = await prisma.user.count({ where: { isActive: true } });
    const activeBeforeH24 = await prisma.user.count({ where: { isActive: true, createdAt: { lt: h24Start } } });
    const activeBeforeD7 = await prisma.user.count({ where: { isActive: true, createdAt: { lt: d7Start } } });
    
    console.log('Total active users:', activeUsers);
    console.log('Active before 24H:', activeBeforeH24, '-> new:', activeUsers - activeBeforeH24);
    console.log('Active before 7D:', activeBeforeD7, '-> new:', activeUsers - activeBeforeD7);
    
  } catch (e) {
    console.error('Error:', e.message);
    console.error(e.stack);
  } finally {
    await prisma.$disconnect();
  }
})();
