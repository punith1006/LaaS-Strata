require('dotenv').config();
const { PrismaClient } = require('@prisma/client');
const p = new PrismaClient();
async function run() {
  // Check schema search path
  const path = await p.$queryRawUnsafe(`SELECT current_schema(), current_database()`);
  console.log('Schema/Database:', path);
  
  // List ALL columns in the table
  const cols = await p.$queryRawUnsafe(`SELECT column_name, ordinal_position FROM information_schema.COLUMNS WHERE table_schema=current_schema() AND table_name='mentor_sessions' ORDER BY ordinal_position`);
  console.log('\nCurrent columns:');
  for (const c of cols) console.log('  ' + c.column_name);
  
  // Check for Prisma schema columns that might be missing
  const prismaCols = `SELECT column_name FROM information_schema.COLUMNS WHERE table_schema=current_schema() AND table_name='mentor_sessions'`;
  const existing = new Set((await p.$queryRawUnsafe(prismaCols)).map(c => c.column_name));
  const expected = ['category','jitsi_room_name','jwt_token','jwt_expires_at'];
  console.log('\nMissing columns:');
  for (const col of expected) {
    if (!existing.has(col)) console.log('  MISSING: ' + col);
  }
  
  // Check enums
  const enums = await p.$queryRawUnsafe(`SELECT t.typname FROM pg_type t JOIN pg_enum e ON t.oid = e.enumtypid GROUP BY t.typname`);
  console.log('\nExisting enum types:', enums.map(e => e.typname));
  
  await p.$disconnect();
}
run().catch(e => { console.error(e.message); p.$disconnect(); })
