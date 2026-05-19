import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function diagnoseGpuHours() {
  const now = new Date();
  const IST_OFFSET_MS = 5.5 * 60 * 60 * 1000;

  // IST day start (00:00 IST today)
  const istTime = new Date(now.getTime() + IST_OFFSET_MS);
  istTime.setUTCHours(0, 0, 0, 0);
  const istDayStart = new Date(istTime.getTime() - IST_OFFSET_MS);

  // 24H: periodStart = 00:00 IST today
  const period24h = istDayStart;
  
  // 7D: periodStart = 00:00 IST 6 days ago
  const period7d = new Date(istDayStart.getTime() - 6 * 24 * 60 * 60 * 1000);

  console.log('=== Time Reference ===');
  console.log('Now:', now.toISOString(), `(${new Date(now.getTime() + IST_OFFSET_MS).toISOString().split('T')[1].split('.')[0]} IST)`);
  console.log('IST day start (00:00 IST):', istDayStart.toISOString());
  console.log('24H periodStart:', period24h.toISOString());
  console.log('7D periodStart:', period7d.toISOString());
  console.log('');

  // === 24H GPU Hours ===
  console.log('=== 24H GPU Hours ===');

  // Running sessions (shared between old and new)
  const runningSessions = await prisma.session.findMany({
    where: {
      status: 'running',
      startedAt: { not: null },
    },
    select: { id: true, startedAt: true, status: true },
  });

  const runningElapsedSeconds = runningSessions.reduce((sum, s) => {
    if (!s.startedAt) return sum;
    const countFrom = Math.max(period24h.getTime(), s.startedAt.getTime());
    return sum + Math.max(0, Math.floor((now.getTime() - countFrom) / 1000));
  }, 0);
  const runningHours24h = runningElapsedSeconds / 3600;

  // OLD approach: full durationSeconds (no prorating)
  const gpuData24hOld = await prisma.session.aggregate({
    _sum: { durationSeconds: true },
    _count: true,
    where: {
      status: { in: ['ended', 'terminated_idle', 'terminated_overuse'] },
      endedAt: { gte: period24h },
    },
  });
  const endedGpuHours24hOld = Number(gpuData24hOld._sum.durationSeconds ?? 0) / 3600;
  const totalGpuHours24hOld = endedGpuHours24hOld + runningHours24h;
  console.log(`OLD (full dur): ended=${endedGpuHours24hOld.toFixed(2)} + running=${runningHours24h.toFixed(2)} = ${totalGpuHours24hOld.toFixed(2)} hrs`);

  // NEW approach: prorated durations
  const period24hTs = period24h.toISOString().replace('Z', '');
  const gpuData24hNew = await prisma.$queryRaw<
    Array<{ total_seconds: bigint; session_count: bigint }>
  >`
    SELECT
      CAST(COALESCE(SUM(
        CASE
          WHEN s."started_at" IS NULL OR s."started_at" >= ${period24hTs}::timestamp
          THEN s."duration_seconds"
          ELSE EXTRACT(EPOCH FROM s."ended_at" - ${period24hTs}::timestamp)
        END
      ), 0) AS BIGINT) as total_seconds,
      CAST(COUNT(*) AS BIGINT) as session_count
    FROM "sessions" s
    WHERE s.status IN ('ended', 'terminated_idle', 'terminated_overuse')
      AND s."ended_at" >= ${period24hTs}::timestamp
  `;
  const endedGpuHours24hNew = Number(gpuData24hNew[0]?.total_seconds ?? 0) / 3600;
  const endedSessionCount24h = Number(gpuData24hNew[0]?.session_count ?? 0);
  const totalGpuHours24hNew = endedGpuHours24hNew + runningHours24h;
  console.log(`NEW (prorated): ended=${endedGpuHours24hNew.toFixed(2)} + running=${runningHours24h.toFixed(2)} = ${totalGpuHours24hNew.toFixed(2)} hrs`);
  console.log('');

  // Show ended sessions in detail with prorated calculation
  const endedSessions24h = await prisma.session.findMany({
    where: {
      status: { in: ['ended', 'terminated_idle', 'terminated_overuse'] },
      endedAt: { gte: period24h },
    },
    select: {
      id: true,
      status: true,
      startedAt: true,
      endedAt: true,
      durationSeconds: true,
    },
    orderBy: { endedAt: 'asc' },
  });

  console.log('Ended sessions (24H period) - with prorated duration:');
  let fullSum = 0;
  let proratedSum = 0;
  endedSessions24h.forEach((s, i) => {
    const fullHours = Number(s.durationSeconds) / 3600;
    fullSum += fullHours;
    let proratedSecs: number = Number(s.durationSeconds);
    if (s.startedAt && s.startedAt < period24h && s.endedAt) {
      proratedSecs = Math.floor((s.endedAt.getTime() - period24h.getTime()) / 1000);
    }
    const proratedHours = proratedSecs / 3600;
    proratedSum += proratedHours;
    const istEnded = s.endedAt ? new Date(s.endedAt.getTime() + IST_OFFSET_MS) : null;
    const istStarted = s.startedAt ? new Date(s.startedAt.getTime() + IST_OFFSET_MS) : null;
    const proratedNote = proratedHours !== fullHours ? ` (prorated: ${proratedHours.toFixed(2)} hrs)` : '';
    console.log(`  ${i + 1}. Full: ${fullHours.toFixed(2)} hrs${proratedNote} | ${s.status} | Started: ${istStarted?.toISOString() ?? 'N/A'} IST | Ended: ${istEnded?.toISOString() ?? 'N/A'} IST`);
  });
  console.log(`  Sum (full dur): ${fullSum.toFixed(2)} hrs | Sum (prorated): ${proratedSum.toFixed(2)} hrs | NEW query says: ${endedGpuHours24hNew.toFixed(2)} hrs`);
  console.log('');

  console.log('Running sessions:');
  runningSessions.forEach((s, i) => {
    if (!s.startedAt) return;
    const istStarted = new Date(s.startedAt.getTime() + IST_OFFSET_MS);
    const elapsed = Math.max(0, Math.floor((now.getTime() - s.startedAt.getTime()) / 1000)) / 3600;
    const sincePeriod = Math.max(0, Math.floor((now.getTime() - Math.max(period24h.getTime(), s.startedAt.getTime())) / 1000)) / 3600;
    console.log(`  ${i + 1}. ${s.status} | Started: ${istStarted.toISOString()} IST | Total elapsed: ${elapsed.toFixed(2)} hrs | Since periodStart: ${sincePeriod.toFixed(2)} hrs`);
  });
  console.log('');

  // === Prior Period (Yesterday) GPU Hours - CDC ===
  console.log('=== Prior Period (Yesterday) GPU Hours ===');
  
  const priorStart = new Date(period24h.getTime() - 24 * 60 * 60 * 1000);
  const priorEnd = period24h;
  const priorStartTs = priorStart.toISOString().replace('Z', '');
  const priorEndTs = priorEnd.toISOString().replace('Z', '');

  // OLD approach: full durationSeconds + Date params
  const priorDataOld = await prisma.session.aggregate({
    _sum: { durationSeconds: true },
    where: {
      status: { in: ['ended', 'terminated_idle', 'terminated_overuse'] },
      endedAt: { gte: priorStart, lt: priorEnd },
    },
  });
  const priorOldHours = Number(priorDataOld._sum.durationSeconds ?? 0) / 3600;

  // NEW approach: prorated at both boundaries, includes spanning sessions
  const priorDataNew = await prisma.$queryRaw<
    Array<{ total_seconds: bigint }>
  >`
    SELECT
      CAST(COALESCE(SUM(
        CASE
          WHEN s."started_at" IS NULL OR s."started_at" >= ${priorStartTs}::timestamp
          THEN
            CASE
              WHEN s."ended_at" <= ${priorEndTs}::timestamp
              THEN s."duration_seconds"
              ELSE EXTRACT(EPOCH FROM ${priorEndTs}::timestamp - s."started_at")
            END
          ELSE
            CASE
              WHEN s."ended_at" <= ${priorEndTs}::timestamp
              THEN EXTRACT(EPOCH FROM s."ended_at" - ${priorStartTs}::timestamp)
              ELSE EXTRACT(EPOCH FROM ${priorEndTs}::timestamp - ${priorStartTs}::timestamp)
            END
        END
      ), 0) AS BIGINT) as total_seconds
    FROM "sessions" s
    WHERE s.status IN ('ended', 'terminated_idle', 'terminated_overuse')
      AND s."ended_at" >= ${priorStartTs}::timestamp
      AND s."started_at" < ${priorEndTs}::timestamp
  `;
  const priorNewHours = Number(priorDataNew[0]?.total_seconds ?? 0) / 3600;

  console.log(`OLD (full dur, endedAt filter): ${priorOldHours.toFixed(2)} hrs`);
  console.log(`NEW (prorated, spanning included): ${priorNewHours.toFixed(2)} hrs`);

  const currentTotalHours = totalGpuHours24hNew;
  const cdcOld = priorOldHours > 0 ? ((currentTotalHours - priorOldHours) / priorOldHours) * 100 : 0;
  const cdcNew = priorNewHours > 0 ? ((currentTotalHours - priorNewHours) / priorNewHours) * 100 : 0;
  console.log(`Current (24H): ${currentTotalHours.toFixed(2)} hrs`);
  console.log(`CDC OLD: ${cdcOld.toFixed(1)}%  (based on prior OLD=${priorOldHours.toFixed(2)} hrs)`);
  console.log(`CDC NEW: ${cdcNew.toFixed(1)}%  (based on prior NEW=${priorNewHours.toFixed(2)} hrs)`);
  console.log('');

  // === 7D GPU Hours ===
  console.log('=== 7D GPU Hours ===');

  // OLD approach
  const gpuData7dOld = await prisma.session.aggregate({
    _sum: { durationSeconds: true },
    _count: true,
    where: {
      status: { in: ['ended', 'terminated_idle', 'terminated_overuse'] },
      endedAt: { gte: period7d },
    },
  });

  const runningElapsedSeconds7d = runningSessions.reduce((sum, s) => {
    if (!s.startedAt) return sum;
    const countFrom = Math.max(period7d.getTime(), s.startedAt.getTime());
    return sum + Math.max(0, Math.floor((now.getTime() - countFrom) / 1000));
  }, 0);
  const runningHours7d = runningElapsedSeconds7d / 3600;

  const endedGpuHours7dOld = Number(gpuData7dOld._sum.durationSeconds ?? 0) / 3600;
  console.log(`OLD (full dur): ended=${endedGpuHours7dOld.toFixed(2)} + running=${runningHours7d.toFixed(2)} = ${(endedGpuHours7dOld + runningHours7d).toFixed(2)} hrs`);

  // NEW approach
  const period7dTs = period7d.toISOString().replace('Z', '');
  const gpuData7dNew = await prisma.$queryRaw<
    Array<{ total_seconds: bigint; session_count: bigint }>
  >`
    SELECT
      CAST(COALESCE(SUM(
        CASE
          WHEN s."started_at" IS NULL OR s."started_at" >= ${period7dTs}::timestamp
          THEN s."duration_seconds"
          ELSE EXTRACT(EPOCH FROM s."ended_at" - ${period7dTs}::timestamp)
        END
      ), 0) AS BIGINT) as total_seconds,
      CAST(COUNT(*) AS BIGINT) as session_count
    FROM "sessions" s
    WHERE s.status IN ('ended', 'terminated_idle', 'terminated_overuse')
      AND s."ended_at" >= ${period7dTs}::timestamp
  `;
  const endedGpuHours7dNew = Number(gpuData7dNew[0]?.total_seconds ?? 0) / 3600;
  const endedSessionCount7d = Number(gpuData7dNew[0]?.session_count ?? 0);
  console.log(`NEW (prorated): ended=${endedGpuHours7dNew.toFixed(2)} + running=${runningHours7d.toFixed(2)} = ${(endedGpuHours7dNew + runningHours7d).toFixed(2)} hrs`);
  console.log('');

  // Show daily breakdown for 7D
  const dailyBreakdown = await prisma.$queryRaw<
    Array<{ day: Date; hours: number; count: bigint }>
  >`
    SELECT
      DATE_TRUNC('day', "ended_at" AT TIME ZONE 'UTC')::date as day,
      SUM("duration_seconds") / 3600.0 as hours,
      COUNT(*)::bigint as count
    FROM "sessions"
    WHERE status IN ('ended', 'terminated_idle', 'terminated_overuse')
      AND "ended_at" >= ${period7d}
    GROUP BY 1
    ORDER BY 1
  `;

  console.log('Daily breakdown (ended sessions only, full dur):');
  dailyBreakdown.forEach((d) => {
    const istDay = new Date(d.day.getTime() + IST_OFFSET_MS);
    console.log(`  ${istDay.toISOString().split('T')[0]} IST: ${Number(d.hours).toFixed(2)} hrs (${Number(d.count)} sessions)`);
  });

  console.log();
  console.log('Running sessions by start day (total elapsed so far):');
  runningSessions.forEach((s) => {
    if (!s.startedAt) return;
    const istStarted = new Date(s.startedAt.getTime() + IST_OFFSET_MS);
    const startDay = istStarted.toISOString().split('T')[0];
    const totalElapsed = Math.max(0, Math.floor((now.getTime() - s.startedAt.getTime()) / 1000)) / 3600;
    console.log(`  Started: ${startDay} | ${totalElapsed.toFixed(2)} hrs total elapsed`);
  });

  await prisma.$disconnect();
}

diagnoseGpuHours().catch(console.error);
