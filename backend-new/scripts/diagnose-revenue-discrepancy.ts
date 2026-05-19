import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function diagnoseRevenueDiscrepancy() {
  const now = new Date();
  
  // IST offset
  const IST_OFFSET_MS = 5.5 * 60 * 60 * 1000;
  const istTime = new Date(now.getTime() + IST_OFFSET_MS);
  istTime.setUTCHours(0, 0, 0, 0);
  const istDayStart = new Date(istTime.getTime() - IST_OFFSET_MS);
  
  console.log('\n=== Time Reference ===');
  console.log('Current time:', now.toISOString(), '=', new Date(now.getTime() + IST_OFFSET_MS).toISOString().split('T')[1].split('.')[0], 'IST');
  console.log('IST day start (00:00 IST):', istDayStart.toISOString());
  console.log('');
  
  // Query 1: All charges since 00:00 IST today (KPI logic)
  const kpiCharges = await prisma.billingCharge.findMany({
    where: {
      createdAt: { gte: istDayStart },
    },
    orderBy: { createdAt: 'asc' },
  });
  
  console.log('=== KPI Logic: All charges since 00:00 IST today ===');
  console.log('Total charges found:', kpiCharges.length);
  const kpiTotal = kpiCharges.reduce((sum, c) => sum + Number(c.amountCents), 0);
  console.log('Total amount (cents):', kpiTotal);
  console.log('Total amount ():', (kpiTotal / 100).toFixed(2));
  console.log('');
  
  // Show individual charges
  console.log('Individual charges:');
  kpiCharges.forEach((c, i) => {
    const istCreatedAt = new Date(c.createdAt.getTime() + IST_OFFSET_MS);
    console.log(`  ${i + 1}. ₹${(Number(c.amountCents) / 100).toFixed(2)} | Created: ${c.createdAt.toISOString()} (${istCreatedAt.toISOString().split('T')[1].split('.')[0]} IST) | Type: ${c.chargeType}`);
  });
  console.log('');
  
  // Query 2: Hourly aggregation (Chart logic)
  const hourlyData = await prisma.$queryRaw<
    Array<{ time: number; total_cents: bigint; count: bigint }>
  >`
    SELECT
      EXTRACT(EPOCH FROM DATE_TRUNC('hour', "created_at"))::int as time,
      SUM("amount_cents")::bigint as total_cents,
      COUNT(*)::bigint as count
    FROM "billing_charges"
    WHERE "created_at" >= ${istDayStart}
    GROUP BY DATE_TRUNC('hour', "created_at")
    ORDER BY 1 ASC
  `;
  
  console.log('=== Chart Logic: Hourly buckets since 00:00 IST today ===');
  console.log('Total hourly buckets:', hourlyData.length);
  let chartTotal = 0;
  hourlyData.forEach((row, i) => {
    const utcTime = new Date(Number(row.time) * 1000);
    const istTime = new Date(utcTime.getTime() + IST_OFFSET_MS);
    const amount = Number(row.total_cents) / 100;
    chartTotal += amount;
    console.log(`  ${i + 1}. ${utcTime.toISOString()} (${istTime.toISOString().split('T')[1].split('.')[0]} IST) | ₹${amount.toFixed(2)} | Count: ${Number(row.count)}`);
  });
  console.log('Total from hourly buckets (₹):', chartTotal.toFixed(2));
  console.log('');
  
  // Compare
  console.log('=== Comparison ===');
  console.log('KPI total: ₹', (kpiTotal / 100).toFixed(2));
  console.log('Chart total: ₹', chartTotal.toFixed(2));
  console.log('Difference: ₹', ((kpiTotal / 100) - chartTotal).toFixed(2));
  console.log('');
  
  // Check for charges that might be in weird time zones
  const allCharges = await prisma.billingCharge.findMany({
    where: {
      createdAt: {
        gte: new Date(istDayStart.getTime() - 24 * 60 * 60 * 1000),
        lt: new Date(istDayStart.getTime() + 24 * 60 * 60 * 1000),
      },
    },
    orderBy: { createdAt: 'asc' },
  });
  
  console.log('=== All charges in 48-hour window around today ===');
  allCharges.forEach((c, i) => {
    const istCreatedAt = new Date(c.createdAt.getTime() + IST_OFFSET_MS);
    const isToday = c.createdAt >= istDayStart;
    console.log(`  ${i + 1}. ${isToday ? '✅ TODAY' : '❌ YESTERDAY'} | ₹${(Number(c.amountCents) / 100).toFixed(2)} | ${c.createdAt.toISOString()} (${istCreatedAt.toISOString().split('T')[1].split('.')[0]} IST)`);
  });
  
  await prisma.$disconnect();
}

diagnoseRevenueDiscrepancy().catch(console.error);
