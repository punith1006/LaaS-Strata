require('dotenv').config();
const{PrismaClient}=require('@prisma/client');
const p=new PrismaClient();
async function run(){
  try{
    await p.$executeRawUnsafe("ALTER TYPE \"MentorSessionType\" ADD VALUE IF NOT EXISTS 'meet_now'");
    console.log('meet_now OK');
  }catch(e){console.log(e.message)}
  try{
    await p.$executeRawUnsafe("ALTER TYPE \"MentorSessionType\" ADD VALUE IF NOT EXISTS 'slot_booking'");
    console.log('slot_booking OK');
  }catch(e){console.log(e.message)}
  await p.$disconnect();
}
run().catch(e=>{console.error(e.message);p.$disconnect()})
