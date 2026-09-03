import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

function splitDurationAcrossISTDays(
  effectiveStartMs: number,
  effectiveEndMs: number,
  durationSeconds: number,
  IST_OFFSET_MS: number,
): Map<string, number> {
  const split = new Map<string, number>();
  const spanMs = effectiveEndMs - effectiveStartMs;
  if (spanMs <= 0 || durationSeconds <= 0) return split;

  let cursorMs = effectiveStartMs;
  while (cursorMs < effectiveEndMs) {
    const istCursor = new Date(cursorMs + IST_OFFSET_MS);
    const dayStr = istCursor.toISOString().split('T')[0];

    const nextIstMidnight = new Date(istCursor);
    nextIstMidnight.setUTCHours(24, 0, 0, 0);
    const nextBoundaryMs = nextIstMidnight.getTime() - IST_OFFSET_MS;

    const segmentEndMs = Math.min(nextBoundaryMs, effectiveEndMs);
    const fraction = (segmentEndMs - cursorMs) / spanMs;
    const segmentHours = (durationSeconds * fraction) / 3600;

    split.set(dayStr, (split.get(dayStr) || 0) + segmentHours);
    cursorMs = segmentEndMs;
  }
  return split;
}

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
  const nowIst = new Date(now.getTime() + IST_OFFSET_MS);
  console.log('Now (IST):', nowIst.toISOString().split('T')[0], nowIst.toISOString().split('T')[1].split('.')[0]);
  console.log('IST day start (00:00 IST today):', istDayStart.toISOString());
  console.log('');

  // === Per-session query (NEW approach) ===
  console.log('=== Per-session ended data (24H period) ===');
  const period24hTs = period24h.toISOString().replace('Z', '');
  const endedSessions24h = await prisma.$queryRaw<
    Array<{ started_at: Date | null; ended_at: Date | null; duration_seconds: bigint }>
  >`
    SELECT
      s.started_at,
      s.ended_at,
      CASE
        WHEN s.started_at IS NULL OR s.started_at >= ${period24hTs}::timestamp
        THEN s.duration_seconds
        ELSE EXTRACT(EPOCH FROM s."ended_at" - ${period24hTs}::timestamp)
      END as duration_seconds
    FROM "sessions" s
    WHERE s.status IN ('ended', 'terminated_idle', 'terminated_overuse')
      AND s.ended_at >= ${period24hTs}::timestamp
    ORDER BY s.started_at
  `;

  for (const s of endedSessions24h) {
    const startIst = s.started_at ? new Date(s.started_at.getTime() + IST_OFFSET_MS) : null;
    const endIst = s.ended_at ? new Date(s.ended_at.getTime() + IST_OFFSET_MS) : null;
    const dur = Number(s.duration_seconds) / 3600;
    console.log(`  dur=${dur.toFixed(2)}hrs | start IST: ${startIst?.toISOString().split('T')[0] ?? 'null'} ${startIst?.toISOString().split('T')[1].split('.')[0] ?? ''} | end IST: ${endIst?.toISOString().split('T')[0] ?? 'null'} ${endIst?.toISOString().split('T')[1].split('.')[0] ?? ''}`);
  }

  // === Running sessions ===
  console.log('');
  console.log('=== Running Sessions ===');
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
    console.log(`  Started IST: ${istDateStr} ${istStarted.toISOString().split('T')[1].split('.')[0]}`);
  }

  // === 24H dayMap with IST day-boundary splitting ===
  console.log('');
  console.log('=== 24H dayMap with IST day-boundary splitting ===');
  const period24hMs = period24h.getTime();
  const dayMap24h = new Map<string, number>();

  // Ended sessions 24H
  for (const s of endedSessions24h) {
    const startedAtMs = s.started_at?.getTime() ?? period24hMs;
    const endedAtMs = s.ended_at?.getTime() ?? period24hMs;
    const effectiveStartMs = Math.max(startedAtMs, period24hMs);
    const durSeconds = Number(s.duration_seconds);

    if (effectiveStartMs >= endedAtMs || durSeconds <= 0) continue;

    const startIstDay = new Date(effectiveStartMs + IST_OFFSET_MS).toISOString().split('T')[0];
    const endIstDay = new Date(endedAtMs + IST_OFFSET_MS).toISOString().split('T')[0];

    if (startIstDay === endIstDay) {
      dayMap24h.set(startIstDay, (dayMap24h.get(startIstDay) || 0) + durSeconds / 3600);
    } else {
      const split = splitDurationAcrossISTDays(effectiveStartMs, endedAtMs, durSeconds, IST_OFFSET_MS);
      for (const [day, hours] of split) {
        dayMap24h.set(day, (dayMap24h.get(day) || 0) + hours);
      }
    }
  }

  // Running sessions 24H
  for (const s of runningSessions) {
    if (!s.startedAt) continue;
    const effectiveStartMs = Math.max(period24hMs, s.startedAt.getTime());
    const effectiveEndMs = now.getTime();

    if (effectiveStartMs >= effectiveEndMs) continue;
    const elapsedSeconds = Math.floor((effectiveEndMs - effectiveStartMs) / 1000);
    if (elapsedSeconds <= 0) continue;

    const startIstDay = new Date(effectiveStartMs + IST_OFFSET_MS).toISOString().split('T')[0];
    const endIstDay = new Date(effectiveEndMs + IST_OFFSET_MS).toISOString().split('T')[0];

    if (startIstDay === endIstDay) {
      dayMap24h.set(startIstDay, (dayMap24h.get(startIstDay) || 0) + elapsedSeconds / 3600);
    } else {
      const split = splitDurationAcrossISTDays(effectiveStartMs, effectiveEndMs, elapsedSeconds, IST_OFFSET_MS);
      for (const [day, hours] of split) {
        dayMap24h.set(day, (dayMap24h.get(day) || 0) + hours);
      }
    }
  }

  for (const [dateStr, hours] of dayMap24h.entries()) {
    console.log(`  ${dateStr}: ${hours.toFixed(2)} hrs`);
  }

  // 24H day-of-week chart
  console.log('');
  console.log('=== 24H Day-of-week bar chart ===');
  const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const dayHours24h = new Array(7).fill(0);

  const nowIst2 = new Date(now.getTime() + IST_OFFSET_MS);
  const todayJsDay = nowIst2.getUTCDay();
  const todayIndex = todayJsDay === 0 ? 6 : todayJsDay - 1;

  for (const [dateStr, hours] of dayMap24h.entries()) {
    const date = new Date(dateStr);
    const jsDay = date.getDay();
    const dayIndex = jsDay === 0 ? 6 : jsDay - 1;
    // For 24H, all data goes into today's bucket
    dayHours24h[todayIndex] += hours;
  }

  dayNames.forEach((name, i) => {
    console.log(`  ${name}: ${dayHours24h[i].toFixed(1)} hrs`);
  });

  // === 7D dayMap with IST day-boundary splitting ===
  console.log('');
  console.log('=== 7D dayMap with IST day-boundary splitting ===');
  const period7dTs = period7d.toISOString().replace('Z', '');
  const endedSessions7d = await prisma.$queryRaw<
    Array<{ started_at: Date | null; ended_at: Date | null; duration_seconds: bigint }>
  >`
    SELECT
      s.started_at,
      s.ended_at,
      CASE
        WHEN s.started_at IS NULL OR s.started_at >= ${period7dTs}::timestamp
        THEN s.duration_seconds
        ELSE EXTRACT(EPOCH FROM s."ended_at" - ${period7dTs}::timestamp)
      END as duration_seconds
    FROM "sessions" s
    WHERE s.status IN ('ended', 'terminated_idle', 'terminated_overuse')
      AND s.ended_at >= ${period7dTs}::timestamp
    ORDER BY s.started_at
  `;

  const period7dMs = period7d.getTime();
  const dayMap7d = new Map<string, number>();

  // Ended sessions 7D
  for (const s of endedSessions7d) {
    const startedAtMs = s.started_at?.getTime() ?? period7dMs;
    const endedAtMs = s.ended_at?.getTime() ?? period7dMs;
    const effectiveStartMs = Math.max(startedAtMs, period7dMs);
    const durSeconds = Number(s.duration_seconds);

    if (effectiveStartMs >= endedAtMs || durSeconds <= 0) continue;

    const startIstDay = new Date(effectiveStartMs + IST_OFFSET_MS).toISOString().split('T')[0];
    const endIstDay = new Date(endedAtMs + IST_OFFSET_MS).toISOString().split('T')[0];

    if (startIstDay === endIstDay) {
      dayMap7d.set(startIstDay, (dayMap7d.get(startIstDay) || 0) + durSeconds / 3600);
    } else {
      const split = splitDurationAcrossISTDays(effectiveStartMs, endedAtMs, durSeconds, IST_OFFSET_MS);
      for (const [day, hours] of split) {
        dayMap7d.set(day, (dayMap7d.get(day) || 0) + hours);
      }
    }
  }

  // Running sessions 7D
  for (const s of runningSessions) {
    if (!s.startedAt) continue;
    const effectiveStartMs = Math.max(period7dMs, s.startedAt.getTime());
    const effectiveEndMs = now.getTime();

    if (effectiveStartMs >= effectiveEndMs) continue;
    const elapsedSeconds = Math.floor((effectiveEndMs - effectiveStartMs) / 1000);
    if (elapsedSeconds <= 0) continue;

    const startIstDay = new Date(effectiveStartMs + IST_OFFSET_MS).toISOString().split('T')[0];
    const endIstDay = new Date(effectiveEndMs + IST_OFFSET_MS).toISOString().split('T')[0];

    if (startIstDay === endIstDay) {
      dayMap7d.set(startIstDay, (dayMap7d.get(startIstDay) || 0) + elapsedSeconds / 3600);
    } else {
      const split = splitDurationAcrossISTDays(effectiveStartMs, effectiveEndMs, elapsedSeconds, IST_OFFSET_MS);
      for (const [day, hours] of split) {
        dayMap7d.set(day, (dayMap7d.get(day) || 0) + hours);
      }
    }
  }

  for (const [dateStr, hours] of dayMap7d.entries()) {
    console.log(`  ${dateStr}: ${hours.toFixed(2)} hrs`);
  }

  // 7D day-of-week chart (no force-to-today)
  console.log('');
  console.log('=== 7D Day-of-week bar chart ===');
  const dayHours7d = new Array(7).fill(0);

  for (const [dateStr, hours] of dayMap7d.entries()) {
    const date = new Date(dateStr);
    const jsDay = date.getDay();
    const dayIndex = jsDay === 0 ? 6 : jsDay - 1;
    dayHours7d[dayIndex] += hours;
  }

  dayNames.forEach((name, i) => {
    console.log(`  ${name}: ${dayHours7d[i].toFixed(1)} hrs`);
  });

  console.log('');
  console.log('=== Consistency Check ===');
  const total24h = dayHours24h.reduce((s, v) => s + v, 0);
  const total7d = dayHours7d.reduce((s, v) => s + v, 0);
  console.log(`24H total: ${total24h.toFixed(1)} hrs`);
  console.log(`7D total: ${total7d.toFixed(1)} hrs`);
  console.log(`7D Tue (should ≈ 24H Tue): ${dayHours7d[1].toFixed(1)} hrs vs 24H Tue: ${dayHours24h[1].toFixed(1)} hrs`);

  await prisma.$disconnect();
}

diagnoseComputeActivity().catch(console.error);
