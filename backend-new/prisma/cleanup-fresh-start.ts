/**
 * Complete Database Cleanup Script for Fresh Start
 *
 * Wipes ALL user data while preserving system/platform configuration tables.
 * Keeps two specified users: business_lead@ksrce.in, it_admin@ksrce.in
 * Designed for dev/test environment reset before multi-node testing.
 *
 * Run: npx ts-node prisma/cleanup-fresh-start.ts --force
 */

import { PrismaClient } from '@prisma/client';
import * as readline from 'readline';

const prisma = new PrismaClient();

// Users to KEEP (will NOT be deleted)
const KEEP_EMAILS = [
  'business_lead@ksrce.in',
  'it_admin@ksrce.in',
];

// Tables that should be emptied (reporting only — actual deletion is via TRUNCATE CASCADE)
const USER_DATA_TABLES = [
  'users',
  'otp_verifications',
  'user_policy_consents',
  'refresh_tokens',
  'login_history',
  'user_org_roles',
  'user_profiles',
  'user_departments',
  'user_group_members',
  'user_storage_volumes',
  'storage_extensions',
  'os_switch_history',
  'user_files',
  'bookings',
  'sessions',
  'session_events',
  'node_resource_reservations',
  'wallets',
  'wallet_holds',
  'wallet_transactions',
  'subscriptions',
  'payment_transactions',
  'billing_charges',
  'invoices',
  'invoice_line_items',
  'courses',
  'course_enrollments',
  'labs',
  'lab_group_assignments',
  'lab_assignments',
  'lab_submissions',
  'lab_grades',
  'coursework_content',
  'mentor_profiles',
  'mentor_availability_slots',
  'mentor_bookings',
  'mentor_reviews',
  'discussions',
  'discussion_replies',
  'project_showcases',
  'user_achievements',
  'notifications',
  'audit_log',
  'user_deletion_requests',
  'support_tickets',
  'ticket_messages',
  'user_feedback',
  'referrals',
  'referral_conversions',
  'referral_events',
  'recommendation_sessions',
  'waitlist_entries',
];

// Tables that must be preserved
const PRESERVED_TABLES = [
  'nodes',
  'compute_configs',
  'organizations',
  'universities',
  'departments',
  'roles',
  'permissions',
  'role_permissions',
  'credit_packages',
  'subscription_plans',
  'system_settings',
  'feature_flags',
  'base_images',
  'node_base_images',
  'notification_templates',
  'achievements',
  'user_groups',
  'compute_config_access',
  'org_contracts',
  'org_resource_quotas',
  'university_idp_configs',
  'announcements',
];

async function getTableCounts(tables: string[]): Promise<Record<string, number>> {
  const counts: Record<string, number> = {};
  for (const table of tables) {
    try {
      const result = await prisma.$queryRawUnsafe<{ count: string }[]>(
        `SELECT COUNT(*)::text as count FROM "${table}"`,
      );
      counts[table] = parseInt(result[0].count, 10);
    } catch {
      counts[table] = -1;
    }
  }
  return counts;
}

async function askConfirmation(): Promise<boolean> {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  return new Promise((resolve) => {
    rl.question('Type "yes" to permanently delete all user data: ', (answer) => {
      rl.close();
      resolve(answer.trim().toLowerCase() === 'yes');
    });
  });
}

async function tableExists(tableName: string): Promise<boolean> {
  const result = await prisma.$queryRawUnsafe<{ exists: boolean }[]>(
    `SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = '${tableName}') as exists`,
  );
  return result[0].exists;
}

async function main() {
  const force = process.argv.includes('--force');

  console.log('='.repeat(70));
  console.log('DATABASE CLEANUP: SELECTIVE USER CLEANUP');
  console.log('='.repeat(70));
  console.log('');
  console.log('KEEPING these users:');
  for (const email of KEEP_EMAILS) {
    console.log(`  - ${email}`);
  }
  console.log('');
  console.log('DELETING all other users and their data:');
  console.log('  - Auth tokens, login history, profiles, departments, groups');
  console.log('  - Sessions, bookings, session events');
  console.log('  - Storage volumes, files, OS switch history');
  console.log('  - Billing charges, invoices, payments, wallets, transactions');
  console.log('  - Referrals, support tickets, notifications');
  console.log('  - Academic data: courses, labs, enrollments, grades, submissions');
  console.log('  - Mentorship data');
  console.log('  - Community data: discussions, showcases');
  console.log('  - All audit logs');
  console.log('  - All node resource reservations');
  console.log('');
  console.log('PRESERVED (system config):');
  console.log('  - nodes, compute_configs, organizations');
  console.log('  - universities, departments, user_groups');
  console.log('  - roles, permissions, role_permissions');
  console.log('  - credit_packages, subscription_plans');
  console.log('  - system_settings, feature_flags');
  console.log('  - base_images, node_base_images');
  console.log('  - notification_templates, achievements');
  console.log('');

  // Get users to keep
  const keepUsers = await prisma.user.findMany({
    where: { email: { in: KEEP_EMAILS } },
    select: { id: true, email: true },
  });

  if (keepUsers.length === 0) {
    console.log('ERROR: None of the KEEP_EMAILS users exist in the database!');
    console.log('Aborting for safety.');
    return;
  }

  console.log(`Found ${keepUsers.length} user(s) to KEEP:`);
  for (const u of keepUsers) {
    console.log(`  \u2713 ${u.email}`);
  }
  console.log('');

  const keepIds = keepUsers.map(u => u.id);

  // Cast UUIDs for raw SQL
  const castIds = keepIds.map(id => `'${id}'::uuid`).join(',');

  console.log('Scanning database...');
  const countsBefore = await getTableCounts(USER_DATA_TABLES);

  const tablesWithData = Object.entries(countsBefore)
    .filter(([_, count]) => count > 0)
    .sort((a, b) => b[1] - a[1]);

  const totalRecords = tablesWithData.reduce((sum, [_, count]) => sum + count, 0);

  if (totalRecords === 0) {
    console.log('No user data found. Database is already clean.');
    await prisma.$executeRawUnsafe(`
      UPDATE nodes
      SET allocated_vcpu = 0, allocated_memory_mb = 0, allocated_gpu_vram_mb = 0, current_session_count = 0;
    `);
    console.log('Node resource counters reset to 0.');
    return;
  }

  console.log(`Found ${totalRecords} total records across ${tablesWithData.length} tables.`);
  console.log('');
  console.log('Tables with data:');
  for (const [table, count] of tablesWithData) {
    console.log(`  ${table}: ${count}`);
  }
  console.log('');

  if (!force) {
    const confirmed = await askConfirmation();
    if (!confirmed) {
      console.log('Aborted. No changes were made.');
      return;
    }
    console.log('');
  }

  console.log('Executing selective cleanup in transaction...');

  await prisma.$transaction(async (tx) => {
    // Delete in dependency order: leaf tables first, then users
    // Auth & tokens
    await tx.$executeRawUnsafe(`DELETE FROM "otp_verifications" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "user_policy_consents" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "refresh_tokens" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "login_history" WHERE "user_id" NOT IN (${castIds})`);

    // User lifecycle
    await tx.$executeRawUnsafe(`DELETE FROM "user_deletion_requests" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "waitlist_entries" WHERE "userId" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "user_feedback" WHERE "user_id" NOT IN (${castIds})`);

    // Storage
    await tx.$executeRawUnsafe(`DELETE FROM "storage_extensions" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "os_switch_history" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "user_files" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "user_storage_volumes" WHERE "user_id" NOT IN (${castIds})`);

    // Sessions - delete child tables first (FK to sessions)
    await tx.$executeRawUnsafe(`DELETE FROM "wallet_holds" WHERE "session_id" IN (SELECT "id" FROM "sessions" WHERE "user_id" NOT IN (${castIds}))`);
    await tx.$executeRawUnsafe(`DELETE FROM "billing_charges" WHERE "session_id" IN (SELECT "id" FROM "sessions" WHERE "user_id" NOT IN (${castIds}))`);
    await tx.$executeRawUnsafe(`DELETE FROM "session_events" WHERE "session_id" IN (SELECT "id" FROM "sessions" WHERE "user_id" NOT IN (${castIds}))`);
    await tx.$executeRawUnsafe(`DELETE FROM "node_resource_reservations" WHERE "session_id" IN (SELECT "id" FROM "sessions" WHERE "user_id" NOT IN (${castIds}))`);
    await tx.$executeRawUnsafe(`DELETE FROM "bookings" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "sessions" WHERE "user_id" NOT IN (${castIds})`);

    // Billing
    await tx.$executeRawUnsafe(`DELETE FROM "invoice_line_items" WHERE "invoice_id" IN (SELECT "id" FROM "invoices" WHERE "user_id" NOT IN (${castIds}))`);
    await tx.$executeRawUnsafe(`DELETE FROM "invoices" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "billing_charges" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "payment_transactions" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "subscriptions" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "wallet_holds" WHERE "wallet_id" IN (SELECT "id" FROM "wallets" WHERE "user_id" NOT IN (${castIds}))`);
    await tx.$executeRawUnsafe(`DELETE FROM "wallet_transactions" WHERE "wallet_id" IN (SELECT "id" FROM "wallets" WHERE "user_id" NOT IN (${castIds}))`);
    await tx.$executeRawUnsafe(`DELETE FROM "wallets" WHERE "user_id" NOT IN (${castIds})`);

    // Academic
    await tx.$executeRawUnsafe(`DELETE FROM "lab_grades" WHERE "submission_id" IN (SELECT "id" FROM "lab_submissions" WHERE "user_id" NOT IN (${castIds}))`);
    await tx.$executeRawUnsafe(`DELETE FROM "lab_submissions" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "lab_assignments" WHERE "lab_id" IN (SELECT "id" FROM "labs" WHERE "created_by_user_id" NOT IN (${castIds}))`);
    await tx.$executeRawUnsafe(`DELETE FROM "course_enrollments" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "labs" WHERE "created_by_user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "courses" WHERE "instructor_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "coursework_content" WHERE "organization_id" IS NOT NULL`);

    // Mentorship
    await tx.$executeRawUnsafe(`DELETE FROM "mentor_reviews" WHERE "reviewer_user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "mentor_bookings" WHERE "student_user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "mentor_availability_slots" WHERE "mentor_profile_id" IN (SELECT "id" FROM "mentor_profiles" WHERE "user_id" NOT IN (${castIds}))`);
    await tx.$executeRawUnsafe(`DELETE FROM "mentor_profiles" WHERE "user_id" NOT IN (${castIds})`);

    // Community
    await tx.$executeRawUnsafe(`DELETE FROM "discussion_replies" WHERE "author_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "discussions" WHERE "author_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "project_showcases" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "user_achievements" WHERE "user_id" NOT IN (${castIds})`);

    // Notifications & audit
    await tx.$executeRawUnsafe(`DELETE FROM "notifications" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "audit_log" WHERE "actor_id" NOT IN (${castIds})`);

    // Support
    await tx.$executeRawUnsafe(`DELETE FROM "ticket_messages" WHERE "ticket_id" IN (SELECT "id" FROM "support_tickets" WHERE "user_id" NOT IN (${castIds}))`);
    await tx.$executeRawUnsafe(`DELETE FROM "support_tickets" WHERE "user_id" NOT IN (${castIds})`);

    // Referrals
    await tx.$executeRawUnsafe(`DELETE FROM "referral_events" WHERE "referral_id" IN (SELECT "id" FROM "referrals" WHERE "referrer_user_id" NOT IN (${castIds}))`);
    await tx.$executeRawUnsafe(`DELETE FROM "referral_conversions" WHERE "referrer_user_id" NOT IN (${castIds}) OR "referred_user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "referrals" WHERE "referrer_user_id" NOT IN (${castIds})`);

    // Recommendation
    await tx.$executeRawUnsafe(`DELETE FROM "recommendation_sessions" WHERE "user_id" NOT IN (${castIds})`);

    // User associations
    await tx.$executeRawUnsafe(`DELETE FROM "user_group_members" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "user_departments" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "user_org_roles" WHERE "user_id" NOT IN (${castIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "user_profiles" WHERE "user_id" NOT IN (${castIds})`);

    // Finally delete the users themselves (keep the protected ones)
    await tx.$executeRawUnsafe(`DELETE FROM "users" WHERE "id" NOT IN (${castIds})`);

    // Reset node resource counters
    await tx.$executeRawUnsafe(`
      UPDATE nodes
      SET allocated_vcpu = 0,
          allocated_memory_mb = 0,
          allocated_gpu_vram_mb = 0,
          current_session_count = 0;
    `);
  });

  console.log('');
  console.log('Cleanup executed. Verifying...');
  console.log('');

  const countsAfter = await getTableCounts(USER_DATA_TABLES);
  const preservedCounts = await getTableCounts(PRESERVED_TABLES);

  console.log('='.repeat(70));
  console.log('RESULT');
  console.log('='.repeat(70));
  console.log('');
  console.log('REMOVED USER TABLES:');
  for (const table of USER_DATA_TABLES) {
    const before = countsBefore[table] || 0;
    const after = countsAfter[table] || 0;
    if (before > 0) {
      const deleted = before - after;
      console.log(`  ${table}: ${deleted} deleted (${after} remaining)`);
    }
  }
  console.log('');

  console.log('KEPT USERS:');
  const remainingUsers = await prisma.user.findMany({
    where: { email: { in: KEEP_EMAILS } },
    select: { id: true, email: true },
  });
  for (const u of remainingUsers) {
    console.log(`  \u2713 ${u.email}`);
  }
  console.log('');

  console.log('PRESERVED SYSTEM TABLES (verification):');
  for (const [table, count] of Object.entries(preservedCounts).sort((a, b) => b[1] - a[1])) {
    if (count >= 0) {
      console.log(`  ${table}: ${count} records`);
    }
  }
  console.log('');
  console.log('Done! Selective cleanup complete.');
}

async function run() {
  try {
    await main();
  } catch (e) {
    console.error('\nFatal error during cleanup:', e);
    process.exitCode = 1;
  } finally {
    await prisma.$disconnect();
  }
}

run();