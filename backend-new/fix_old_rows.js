require('dotenv').config();
const { PrismaClient } = require('@prisma/client');
const p = new PrismaClient();
async function run() {
  const old = await p.$queryRawUnsafe("SELECT id, type FROM mentor_sessions WHERE type NOT IN ('meet_now','slot_booking')");
  console.log('Old rows to fix:', old.length);
  for (const r of old) console.log('  ' + r.id + ' => ' + r.type);
  if (old.length > 0) {
    await p.$executeRawUnsafe("UPDATE mentor_sessions SET type = 'slot_booking' WHERE type NOT IN ('meet_now','slot_booking')");
    console.log('Updated ' + old.length + ' rows to slot_booking');
  }
  await p.$disconnect();
}
run().catch(e => { console.error(e.message); p.$disconnect(); });
