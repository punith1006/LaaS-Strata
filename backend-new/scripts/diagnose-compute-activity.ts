import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function diagnoseComputeActivity() {
  const now = new Date();
  const IST_OFFSET_MS = 5.5 * 60 * 60 * 1000;

  // IST day start (00:00 IST today)
  const istTime = new Date(now.getTime() + IST_OFFSET_MS);
  istTime.setUTCHours(0, 0, 0, 0);
  const istDayStart = new Date(istTime.getTime() - IST_OFFSET_MS);

  // 24H periodStart = 00:00 IST today
  const period24h = istDayStart;
  // 7D periodStart = 00:00 IST 6 days ago
  const period7d = new Date(istDayStart.getTime() - 6 * 24 * 60 * 60 * 1000);

  console.log('=== Time Reference ===');
  console.log('Now (UTC):', now.toISOString());
  console.log(`Now (IST): ${new Date(now.getTime() + IST_OFFSET_MS).toISOString().split('T')[0]} ${new Date(now.getTime() + IST_OFFSET_MS).toISOString().split('T')[1].split('.')[0]}`);
  console.log('IST day start (00:00 IST today):', istDayStart.toISOString());
  console.log('');

  // === COMPUTE ACTIVITY: OLD approach (current buggy code) ===
  console.log('=== OLD APPROACH (UTC DATE_TRUNC, full dur, Date params) ===');

  const oldData24h = await prisma.$queryRaw<Array<{ day: Date; hours: number }>>`
    SELECT
      DATE_TRUNC('day', "started_at")::date as day,
      SUM("duration_seconds") / 3600.0 as hours
    FROM "sessions"
    WHERE status IN ('ended', 'terminated_idle', 'terminated_overuse')
      AND "ended_at" >= ${period24h}
    GROUP BY 1
    ORDER BY 1
  `;
  console.log('24H - Ended sessions (OLD):');
  for (const row of oldData24h) {
    const dayUtc = row.day.toISOString().split('T')[0];
    const dayIst = new Date(row.day.getTime() + IST_OFFSET_MS).toISOString().split('T')[0];
    console.log(`  UTC day: ${dayUtc} (IST: ${dayIst}) => ${Number(row.hours).toFixed(2)} hrs`);
  }

  // === COMPUTE ACTIVITY: NEW approach (IST DATE_TRUNC, prorated, ::timestamp) ===
  console.log('');
  console.log('=== NEW APPROACH (IST DATE_TRUNC, prorated, ::timestamp) ===');

  const period24hTs = period24h.toISOString().replace('Z', '');
  const newData24h = await prisma.$queryRaw<Array<{ day: Date; hours: number }>>`
    SELECT
      DATE_TRUNC('day', s."started_at" AT TIME ZONE 'Asia/Kolkata')::date as day,
      COALESCE(SUM(
        CASE
          WHEN s."started_at" IS NULL OR s."started_at" >= ${period24hTs}::timestamp
          THEN s."duration_seconds"
          ELSE EXTRACT(EPOCH FROM s."ended_at" - ${period24hTs}::timestamp)
        END
      ), 0) / 3600.0 as hours
    FROM "sessions" s
    WHERE s.status IN ('ended', 'terminated_idle', 'terminated_overuse')
      AND s."ended_at" >= ${period24hTs}::timestamp
    GROUP BY 1
    ORDER BY 1
  `;
  console.log('24H - Ended sessions (NEW):');
  for (const row of newData24h) {
    const dayStr = row.day.toISOString().split('T')[0];
    console.log(`  IST day: ${dayStr} => ${Number(row.hours).toFixed(2)} hrs`);
  }

  // === Running sessions ===
  console.log('');
  console.log('=== Running Sessions (24H period) ===');
  const runningSessions = await prisma.session.findMany({
    where: {
      status: 'running',
      startedAt: { not: null },
    },
    select: { id: true, startedAt: true, status: true },
  });

  for (const s of runningSessions) {
    if (!s.startedAt) continue;
    const istStarted = new Date(s.startedAt.getTime() + IST_OFFSET_MS);
    const istDateStr = istStarted.toISOString().split('T')[0];
    const utcDateStr = s.startedAt.toISOString().split('T')[0];
    const elapsedSincePeriod = Math.max(0, Math.floor((now.getTime() - Math.max(period24h.getTime(), s.startedAt.getTime())) / 1000)) / 3600;
    console.log(`  Started(UTC): ${utcDateStr}, Started(IST): ${istDateStr}, Elapsed since periodStart: ${elapsedSincePeriod.toFixed(2)} hrs`);
  }

  // === BUILD dayMap with IST dates (NEW approach) ===
  console.log('');
  console.log('=== Expected dayMap with IST dates (NEW) ===');
  const dayMap = new Map<string, number>();

  // Ended sessions (NEW data)
  for (const row of newData24h) {
    const dayStr = row.day.toISOString().split('T')[0];
    dayMap.set(dayStr, (dayMap.get(dayStr) || 0) + Number(row.hours));
  }

  // Running sessions - attribute to today (elapsed time is consumed NOW, not on start day)
  for (const s of runningSessions) {
    if (!s.startedAt) continue;
    const countFrom = Math.max(period24h.getTime(), s.startedAt.getTime());
    const elapsedHours = Math.max(0, Math.floor((now.getTime() - countFrom) / 1000)) / 3600;
    const nowIst = new Date(now.getTime() + IST_OFFSET_MS);
    const todayIstStr = nowIst.toISOString().split('T')[0];
    dayMap.set(todayIstStr, (dayMap.get(todayIstStr) || 0) + elapsedHours);
  }

  for (const [dateStr, hours] of dayMap.entries()) {
    console.log(`  ${dateStr}: ${hours.toFixed(2)} hrs`);
  }

  // === Day-of-week aggregation ===
  console.log('');
  console.log('=== Day-of-week bar chart output ===');
  const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const dayHours = new Array(7).fill(0);

  const nowIst = new Date(now.getTime() + IST_OFFSET_MS);
  const todayJsDay = nowIst.getUTCDay();
  const todayIndex = todayJsDay === 0 ? 6 : todayJsDay - 1;

  for (const [dateStr, hours] of dayMap.entries()) {
    const date = new Date(dateStr);
    const jsDay = date.getDay();
    const dayIndex = jsDay === 0 ? 6 : jsDay - 1;

    // For 24H, all data goes into today's bucket (other days display as 0)
    dayHours[todayIndex] += hours;
  }

  dayNames.forEach((name, i) => {
    console.log(`  ${name}: ${dayHours[i].toFixed(1)} hrs`);
  });

  // === 7D comparison ===
  console.log('');
  console.log('=== 7D period (NEW) ===');
  const period7dTs = period7d.toISOString().replace('Z', '');
  const newData7d = await prisma.$queryRaw<Array<{ day: Date; hours: number }>>`
    SELECT
      DATE_TRUNC('day', s."started_at" AT TIME ZONE 'Asia/Kolkata')::date as day,
      COALESCE(SUM(
        CASE
          WHEN s."started_at" IS NULL OR s."started_at" >= ${period7dTs}::timestamp
          THEN s."duration_seconds"
          ELSE EXTRACT(EPOCH FROM s."ended_at" - ${period7dTs}::timestamp)
        END
      ), 0) / 3600.0 as hours
    FROM "sessions" s
    WHERE s.status IN ('ended', 'terminated_idle', 'terminated_overuse')
      AND s."ended_at" >= ${period7dTs}::timestamp
    GROUP BY 1
    ORDER BY 1
  `;

  console.log('7D - Ended sessions (NEW, by IST day, prorated):');
  for (const row of newData7d) {
    const dayStr = row.day.toISOString().split('T')[0];
    console.log(`  ${dayStr}: ${Number(row.hours).toFixed(2)} hrs`);
  }

  // 7D day-of-week bar chart (simulates what the service code would produce)
  const dayMap7d = new Map<string, number>();
  for (const row of newData7d) {
    const dayStr = row.day.toISOString().split('T')[0];
    dayMap7d.set(dayStr, (dayMap7d.get(dayStr) || 0) + Number(row.hours));
  }
  // Running sessions - attributed to today's IST date (not start date)
  for (const s of runningSessions) {
    if (!s.startedAt) continue;
    const countFrom = Math.max(period7d.getTime(), s.startedAt.getTime());
    const elapsedHours = Math.max(0, Math.floor((now.getTime() - countFrom) / 1000)) / 3600;
    const nowIst = new Date(now.getTime() + IST_OFFSET_MS);
    const todayIstStr = nowIst.toISOString().split('T')[0];
    dayMap7d.set(todayIstStr, (dayMap7d.get(todayIstStr) || 0) + elapsedHours);
  }

  const dayHours7d = new Array(7).fill(0);
  for (const [dateStr, hours] of dayMap7d.entries()) {
    const date = new Date(dateStr);
    const jsDay = date.getDay();
    const dayIndex = jsDay === 0 ? 6 : jsDay - 1;
    dayHours7d[dayIndex] += hours;
  }

  console.log('7D - Day-of-week bar chart output:');
  dayNames.forEach((name, i) => {
    console.log(`  ${name}: ${dayHours7d[i].toFixed(1)} hrs`);
  });

  await prisma.$disconnect();
}

diagnoseComputeActivity().catch(console.error);
