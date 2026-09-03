require('dotenv').config();
const { PrismaClient } = require('@prisma/client');

async function runDiagnostics() {
  const prisma = new PrismaClient();
  try {
    console.log('Starting diagnostics...');
    const now = new Date();
    console.log('Current time:', now.toISOString());
    
    // Test connection
    const charges = await prisma.billingCharge.findMany();
    console.log('BillingCharge count:', charges.length);
    console.log('First charge:', JSON.stringify(charges[0], null, 2));
  } catch (err) {
    console.error('Error:', err.message);
    console.error(err.stack);
  } finally {
    await prisma.\\();
  }
}

runDiagnostics();
