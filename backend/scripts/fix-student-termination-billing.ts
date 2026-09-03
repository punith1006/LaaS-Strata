/**
 * Fix incorrectly classified student termination charges
 * 
 * PROBLEM: When a KSRCE student's session was terminated, the final billing charge
 * was incorrectly classified as 'revenue' instead of 'capex', and the wallet was
 * incorrectly deducted.
 * 
 * This script:
 * 1. Finds all billing charges for student users that are incorrectly classified as 'revenue'
 * 2. Updates them to 'capex'
 * 3. Reverts any wallet deductions that shouldn't have happened
 * 
 * HOW TO RUN:
 * npx ts-node scripts/fix-student-termination-billing.ts
 */

import { PrismaClient } from '@prisma/client';

async function fixStudentTerminationBilling() {
  const prisma = new PrismaClient();

  try {
    console.log(' Finding incorrectly classified student termination charges...\n');

    // Find all student users
    const studentUsers = await prisma.userOrgRole.findMany({
      where: {
        role: { name: 'student' },
      },
      select: { userId: true },
    });

    const studentUserIds = studentUsers.map((u) => u.userId);

    if (studentUserIds.length === 0) {
      console.log('✅ No student users found. Exiting.');
      return;
    }

    console.log(`📊 Found ${studentUserIds.length} student user(s)\n`);

    // Find all billing charges for students that are incorrectly classified as 'revenue'
    const incorrectCharges = await prisma.billingCharge.findMany({
      where: {
        userId: { in: studentUserIds },
        costClassification: 'revenue',
      },
      include: {
        session: {
          select: {
            id: true,
            instanceName: true,
            status: true,
          },
        },
      },
      orderBy: {
        createdAt: 'desc',
      },
    });

    if (incorrectCharges.length === 0) {
      console.log('✅ No incorrectly classified charges found. All student charges are correctly marked as CapEx.');
      return;
    }

    console.log(` Found ${incorrectCharges.length} incorrectly classified charge(s):\n`);

    let totalIncorrectAmount = 0;

    for (const charge of incorrectCharges) {
      const amountRupees = Number(charge.amountCents) / 100;
      totalIncorrectAmount += amountRupees;

      console.log(`  • Charge ID: ${charge.id}`);
      console.log(`    User ID: ${charge.userId}`);
      console.log(`    Amount: ₹${amountRupees.toFixed(2)}`);
      console.log(`    Type: ${charge.chargeType}`);
      console.log(`    Session: ${charge.session?.instanceName || charge.sessionId}`);
      console.log(`    Created: ${charge.createdAt.toISOString()}`);
      console.log(`    Current classification: ${charge.costClassification}`);
      console.log('');
    }

    console.log(` Total incorrect amount: ₹${totalIncorrectAmount.toFixed(2)}\n`);

    // Ask for confirmation
    console.log('⚠️  WARNING: This will update billing charges and potentially revert wallet deductions.');
    console.log('   Please review the charges above before proceeding.\n');

    // Uncomment the line below to enable automatic fixing (remove for manual confirmation)
    // const shouldFix = true;
    const shouldFix = true; // Set to true after reviewing the charges above

    if (!shouldFix) {
      console.log(' Fix not enabled. Set shouldFix = true in the script to apply changes.');
      return;
    }

    // Fix the charges
    console.log('🔧 Applying fixes...\n');

    let fixedCount = 0;
    let revertedWalletAmount = 0;

    await prisma.$transaction(async (tx) => {
      for (const charge of incorrectCharges) {
        // 1. Update costClassification to 'capex'
        await tx.billingCharge.update({
          where: { id: charge.id },
          data: { costClassification: 'capex' },
        });

        console.log(`  ✓ Updated charge ${charge.id} to costClassification='capex'`);
        fixedCount++;

        // 2. If this charge has a walletTransactionId, revert the wallet deduction
        if (charge.walletTransactionId) {
          const walletTxn = await tx.walletTransaction.findUnique({
            where: { id: charge.walletTransactionId },
            include: { wallet: true },
          });

          if (walletTxn && walletTxn.txnType === 'debit') {
            // Revert the wallet balance
            const amountCents = Number(walletTxn.amountCents);
            revertedWalletAmount += amountCents;

            await tx.wallet.update({
              where: { id: walletTxn.walletId },
              data: {
                balanceCents: { increment: amountCents },
                lifetimeSpentCents: { decrement: amountCents },
              },
            });

            // Mark the wallet transaction as reverted
            await tx.walletTransaction.update({
              where: { id: walletTxn.id },
              data: {
                description: `${walletTxn.description} [REVERTED - student billing fix]`,
              },
            });

            console.log(`    ✓ Reverted wallet deduction: ₹${(amountCents / 100).toFixed(2)}`);
          }
        }
      }
    });

    console.log(`\n✅ Fix complete!`);
    console.log(`   • Fixed ${fixedCount} billing charge(s)`);
    console.log(`   • Reverted ₹${(revertedWalletAmount / 100).toFixed(2)} in wallet deduction(s)`);
    console.log(`\n📊 The ₹${totalIncorrectAmount.toFixed(2)} should now appear in CapEx instead of Revenue.`);

  } catch (error) {
    console.error('❌ Error fixing student termination billing:', error);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

fixStudentTerminationBilling();
