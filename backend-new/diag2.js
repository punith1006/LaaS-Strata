const { PrismaClient } = require('@prisma/client');
require('dotenv').config();

(async () => {
  const prisma = new PrismaClient();
  try {
    const now = new Date();
    console.log('NOW:', now.toISOString());
    
    const chargeCount = await prisma.billingCharge.count();
    console.log('Total charges:', chargeCount);
    
    const charges = await prisma.billingCharge.findMany({
      orderBy: { createdAt: 'asc' },
      select: { id: true, chargeType: true, amountCents: true, createdAt: true }
    });
    console.log('Charges:');
    for (const c of charges) {
      console.log(`  ${c.createdAt.toISOString()} | ${c.chargeType} | ${c.amountCents}`);
    }
    
    const sessionCount = await prisma.session.count();
    console.log('\nTotal sessions:', sessionCount);
    
    const sessions = await prisma.session.findMany({
      select: { id: true, status: true, startedAt: true, endedAt: true, durationSeconds: true }
    });
    console.log('Sessions:');
    for (const s of sessions) {
      console.log(`  ${s.id.substring(0,8)} | ${s.status} | started=${s.startedAt ? s.startedAt.toISOString() : 'null'} | ended=${s.endedAt ? s.endedAt.toISOString() : 'null'} | dur=${s.durationSeconds}`);
    }
    
  } catch (e) {
    console.error('Error:', e.message);
  } finally {
    await prisma.$disconnect();
  }
})();
