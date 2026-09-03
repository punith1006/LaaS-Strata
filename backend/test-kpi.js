const { PrismaClient } = require('@prisma/client');
const p = new PrismaClient();

async function main() {
  try {
    const now = new Date();
    const runningSessions = await p.session.findMany({
      where: { status: 'running', startedAt: { not: null } },
      select: { startedAt: true },
    });
    console.log('Running sessions found:', runningSessions.length);
    const runningElapsedSeconds = runningSessions.reduce((sum, s) => {
      if (!s.startedAt) return sum;
      const elapsed = Math.floor((now.getTime() - s.startedAt.getTime()) / 1000);
      console.log('  Session startedAt:', s.startedAt, 'elapsed seconds:', elapsed);
      return sum + elapsed;
    }, 0);
    console.log('Total running elapsed seconds:', runningElapsedSeconds);
    console.log('Total running elapsed hours:', runningElapsedSeconds / 3600);
  } catch (e) {
    console.log('Error:', e.message);
  } finally {
    await p.$disconnect();
  }
}

main();
