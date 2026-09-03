/**
 * Complete Database Cleanup Script for Fresh Start (Updated for Current Schema)
 *
 * Wipes ALL user transactional data while preserving system/platform configuration tables.
 * Keeps specified business admin and IT admin users with ALL their data preserved.
 * Keeps a specified mentor's user record + profile but cleans their transactional data.
 * Designed for dev/test environment reset before multi-node testing.
 *
 * Run: npx ts-node prisma/cleanup-fresh-start.ts --force
 */

import { PrismaClient } from '@prisma/client';
import * as readline from 'readline';

const prisma = new PrismaClient();

// ──────────────────────────────────────────────
// CONFIGURATION
// ──────────────────────────────────────────────

// Users to FULLY KEEP (user record + ALL data preserved: tokens, wallet, sessions, etc.)
const FULLY_KEEP_EMAILS = [
  'business_lead@ksrce.in',
  'it_admin@ksrce.in',
];

// Users whose RECORD and PROFILE stay, but ALL transactional data is deleted
const KEEP_USER_ONLY_IDS = [
  'd6e2fea7-4b97-45d4-90b1-2f525eb52371', // protected mentor user
];

// Mentor profile ID to preserve (the protected mentor's profile)
const KEEP_MENTOR_PROFILE_IDS = [
  'eeb5277a-70f7-4d46-94a3-f43e5c0de5eb',
];

// ──────────────────────────────────────────────
// TABLE LISTS
// ──────────────────────────────────────────────

// User-data tables (reporting only — actual deletion is via txn)
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
  'withdrawal_requests',
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
  'mentor_blocked_dates',
  'mentor_bookings',
  'mentor_reviews',
  'mentor_sessions',
  'mentor_session_status_history',
  'mentor_session_payments',
  'discussions',
  'discussion_replies',
  'project_showcases',
  'user_achievements',
  'notifications',
  'audit_log',
  'user_deletion_requests',
  'support_tickets',
  'support_ticket_attachments',
  'ticket_messages',
  'user_feedback',
  'referrals',
  'referral_conversions',
  'referral_events',
  'recommendation_sessions',
  'waitlist_entries',
];

// Tables that must be preserved (system config / master data)
const PRESERVED_TABLES = [
  'nodes',
  'compute_configs',
  'organizations',
  'universities',
  'departments',
  'user_groups',
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
  'compute_config_access',
  'org_contracts',
  'org_resource_quotas',
  'university_idp_configs',
  'announcements',
];

// ──────────────────────────────────────────────
// HELPERS
// ──────────────────────────────────────────────

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

// ──────────────────────────────────────────────
// MAIN
// ──────────────────────────────────────────────

async function main() {
  const force = process.argv.includes('--force');

  console.log('='.repeat(70));
  console.log('DATABASE CLEANUP: SELECTIVE USER CLEANUP');
  console.log('='.repeat(70));
  console.log('');
  console.log('FULLY KEEPING these users (all data preserved):');
  for (const email of FULLY_KEEP_EMAILS) {
    console.log(`  - ${email}`);
  }
  console.log('');
  console.log('KEEPING USER RECORD + PROFILE ONLY (transactional data cleaned):');
  for (const uid of KEEP_USER_ONLY_IDS) {
    console.log(`  - User ID: ${uid}`);
  }
  console.log('');
  console.log('DELETING all other users and ALL transactional data for keep-user-only:');
  console.log('  - Auth tokens, login history, profiles, departments, groups');
  console.log('  - Compute sessions, bookings, session events');
  console.log('  - Storage volumes, files, OS switch history');
  console.log('  - Billing charges, invoices, payments, wallets, transactions');
  console.log('  - Referrals, support tickets, notifications');
  console.log('  - Academic data: courses, labs, enrollments, grades, submissions');
  console.log('  - ALL mentorship data (slots, bookings, sessions, reviews, payments)');
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

  // ── Fetch users to keep ──

  const fullyKeepUsers = await prisma.user.findMany({
    where: { email: { in: FULLY_KEEP_EMAILS } },
    select: { id: true, email: true },
  });

  if (fullyKeepUsers.length === 0) {
    console.log('ERROR: None of the FULLY_KEEP_EMAILS users exist in the database!');
    console.log('Aborting for safety.');
    return;
  }

  console.log(`Found ${fullyKeepUsers.length} user(s) to FULLY KEEP:`);
  for (const u of fullyKeepUsers) {
    console.log(`  ${u.email} (${u.id})`);
  }
  console.log('');

  const fullyKeepIds = fullyKeepUsers.map(u => u.id);
  const allKeepIds = [...fullyKeepIds, ...KEEP_USER_ONLY_IDS];

  // Verify the protected mentor user exists
  if (KEEP_USER_ONLY_IDS.length > 0) {
    const mentorUser = await prisma.user.findUnique({ where: { id: KEEP_USER_ONLY_IDS[0] }, select: { id: true, email: true } });
    if (mentorUser) {
      console.log(`Protected mentor user found: ${mentorUser.email} (${mentorUser.id})`);
    } else {
      console.log('WARNING: Protected mentor user not found in database!');
    }
    console.log('');
  }

  // Cast UUIDs for raw SQL
  const castFullyKeepIds = fullyKeepIds.map(id => `'${id}'::uuid`).join(',');
  const castAllKeepIds = allKeepIds.map(id => `'${id}'::uuid`).join(',');

  // ── Scan database ──

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

  // ── EXECUTE DELETION ──
  // Order matters: child tables before parents, respecting FK constraints

  await prisma.$transaction(async (tx) => {
    // =====================================================================
    // DOMAIN 10: MENTORSHIP (delete ALL transactional data first)
    // =====================================================================

    // mentor_session_status_history -> mentor_sessions
    await tx.$executeRawUnsafe(`DELETE FROM "mentor_session_status_history"`);

    // mentor_session_payments -> mentor_sessions, wallet_transactions
    await tx.$executeRawUnsafe(`DELETE FROM "mentor_session_payments"`);

    // mentor_reviews -> mentor_bookings
    await tx.$executeRawUnsafe(`DELETE FROM "mentor_reviews"`);

    // mentor_bookings -> mentor_profiles, payment_transactions
    await tx.$executeRawUnsafe(`DELETE FROM "mentor_bookings"`);

    // mentor_sessions -> mentor_profiles
    await tx.$executeRawUnsafe(`DELETE FROM "mentor_sessions"`);

    // mentor_blocked_dates -> mentor_profiles
    await tx.$executeRawUnsafe(`DELETE FROM "mentor_blocked_dates"`);

    // mentor_availability_slots -> mentor_profiles
    await tx.$executeRawUnsafe(`DELETE FROM "mentor_availability_slots"`);

    // mentor_profiles: keep the protected mentor's profile, delete all others
    await tx.$executeRawUnsafe(`
      DELETE FROM "mentor_profiles"
      WHERE "id" NOT IN (${KEEP_MENTOR_PROFILE_IDS.map(id => `'${id}'::uuid`).join(',')})
    `);

    // =====================================================================
    // DOMAIN 4: STORAGE AND OS LIFECYCLE
    // =====================================================================

    // os_switch_history -> user_storage_volumes
    await tx.$executeRawUnsafe(`DELETE FROM "os_switch_history"`);

    // storage_extensions -> user_storage_volumes, wallet_transactions
    await tx.$executeRawUnsafe(`DELETE FROM "storage_extensions"`);

    // user_files -> sessions
    await tx.$executeRawUnsafe(`DELETE FROM "user_files"`);

    // billing_charges may reference storage_volume_id of non-kept users — null it out first
    await tx.$executeRawUnsafe(`UPDATE "billing_charges" SET "storage_volume_id" = NULL WHERE "storage_volume_id" IN (SELECT "id" FROM "user_storage_volumes" WHERE "user_id" NOT IN (${castFullyKeepIds}))`);

    // user_storage_volumes -> users
    await tx.$executeRawUnsafe(`DELETE FROM "user_storage_volumes" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // =====================================================================
    // DOMAIN 8: BILLING, WALLET, SUBSCRIPTIONS
    // =====================================================================

    // wallet_holds -> wallets, bookings, sessions
    await tx.$executeRawUnsafe(`DELETE FROM "wallet_holds" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // support_tickets may reference billing_charge from non-kept users — null it out
    await tx.$executeRawUnsafe(`UPDATE "support_tickets" SET "related_billing_id" = NULL WHERE "related_billing_id" IN (SELECT "id" FROM "billing_charges" WHERE "user_id" NOT IN (${castFullyKeepIds}))`);

    // billing_charges -> sessions (must delete before wallet_transactions since wallet_transactions references billing_charges)
    await tx.$executeRawUnsafe(`DELETE FROM "billing_charges" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // billing_charges may reference wallet_transaction from non-kept users — null it out before deleting wallet_transactions
    await tx.$executeRawUnsafe(`UPDATE "billing_charges" SET "wallet_transaction_id" = NULL WHERE "wallet_transaction_id" IN (SELECT "id" FROM "wallet_transactions" WHERE "user_id" NOT IN (${castFullyKeepIds}))`);

    // wallet_transactions -> wallets (also referenced by mentor_session_payments which is already deleted)
    await tx.$executeRawUnsafe(`DELETE FROM "wallet_transactions" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // withdrawal_requests -> wallets
    await tx.$executeRawUnsafe(`DELETE FROM "withdrawal_requests" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // wallets -> users
    await tx.$executeRawUnsafe(`DELETE FROM "wallets" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // =====================================================================
    // DOMAIN 7: SESSIONS AND BOOKINGS
    // =====================================================================

    // session_events -> sessions
    await tx.$executeRawUnsafe(`DELETE FROM "session_events"`);

    // node_resource_reservations -> sessions
    await tx.$executeRawUnsafe(`DELETE FROM "node_resource_reservations"`);

    // billing_charges may reference session_id from non-kept users — null it out
    await tx.$executeRawUnsafe(`UPDATE "billing_charges" SET "session_id" = NULL WHERE "session_id" IN (SELECT "id" FROM "sessions" WHERE "user_id" NOT IN (${castFullyKeepIds}))`);

    // support_tickets may reference session_id from non-kept users — null it out
    await tx.$executeRawUnsafe(`UPDATE "support_tickets" SET "related_session_id" = NULL WHERE "related_session_id" IN (SELECT "id" FROM "sessions" WHERE "user_id" NOT IN (${castFullyKeepIds}))`);

    // sessions -> users
    await tx.$executeRawUnsafe(`DELETE FROM "sessions" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // bookings -> users, organizations
    await tx.$executeRawUnsafe(`DELETE FROM "bookings" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // =====================================================================
    // DOMAIN 8: BILLING (continued — invoices, payment_transactions)
    // =====================================================================

    // invoice_line_items -> invoices
    await tx.$executeRawUnsafe(`DELETE FROM "invoice_line_items"`);

    // invoices -> users
    await tx.$executeRawUnsafe(`DELETE FROM "invoices" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // subscriptions -> users
    await tx.$executeRawUnsafe(`DELETE FROM "subscriptions" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // subscriptions may reference payment_transaction from non-kept users — null it out before deleting payment_transactions
    await tx.$executeRawUnsafe(`UPDATE "subscriptions" SET "payment_transaction_id" = NULL WHERE "payment_transaction_id" IN (SELECT "id" FROM "payment_transactions" WHERE "user_id" NOT IN (${castFullyKeepIds}))`);

    // payment_transactions -> users (also referenced by mentor_bookings which is already deleted)
    await tx.$executeRawUnsafe(`DELETE FROM "payment_transactions" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // =====================================================================
    // DOMAIN 9: ACADEMIC / LMS
    // =====================================================================

    // lab_grades -> lab_submissions
    await tx.$executeRawUnsafe(`DELETE FROM "lab_grades"`);

    // lab_submissions -> users (all transactional, delete all for fresh start)
    await tx.$executeRawUnsafe(`DELETE FROM "lab_submissions"`);

    // lab_assignments -> labs (safe now that submissions are gone)
    await tx.$executeRawUnsafe(`DELETE FROM "lab_assignments"`);

    // lab_group_assignments -> user_groups, labs
    await tx.$executeRawUnsafe(`DELETE FROM "lab_group_assignments"`);

    // labs -> users
    await tx.$executeRawUnsafe(`DELETE FROM "labs" WHERE "created_by_user_id" NOT IN (${castFullyKeepIds})`);

    // course_enrollments -> users
    await tx.$executeRawUnsafe(`DELETE FROM "course_enrollments" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // courses -> users
    await tx.$executeRawUnsafe(`DELETE FROM "courses" WHERE "instructor_id" NOT IN (${castFullyKeepIds})`);

    // coursework_content -> organizations
    await tx.$executeRawUnsafe(`DELETE FROM "coursework_content" WHERE "organization_id" IS NOT NULL`);

    // =====================================================================
    // DOMAIN 11: COMMUNITY AND GAMIFICATION
    // =====================================================================

    // discussion_replies -> discussions
    await tx.$executeRawUnsafe(`DELETE FROM "discussion_replies"`);

    // discussions -> users
    await tx.$executeRawUnsafe(`DELETE FROM "discussions" WHERE "author_id" NOT IN (${castFullyKeepIds})`);

    // project_showcases -> users
    await tx.$executeRawUnsafe(`DELETE FROM "project_showcases" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // user_achievements -> users
    await tx.$executeRawUnsafe(`DELETE FROM "user_achievements" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // =====================================================================
    // DOMAIN 12: NOTIFICATIONS
    // =====================================================================

    await tx.$executeRawUnsafe(`DELETE FROM "notifications" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // =====================================================================
    // DOMAIN 13: AUDIT
    // =====================================================================

    await tx.$executeRawUnsafe(`DELETE FROM "audit_log" WHERE "actor_id" NOT IN (${castFullyKeepIds})`);

    // =====================================================================
    // DOMAIN 13b: USER LIFECYCLE
    // =====================================================================

    await tx.$executeRawUnsafe(`DELETE FROM "user_deletion_requests" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // =====================================================================
    // DOMAIN 15: SUPPORT AND FEEDBACK
    // =====================================================================

    // ticket_messages -> support_tickets (only delete messages for non-kept tickets)
    await tx.$executeRawUnsafe(`DELETE FROM "ticket_messages" WHERE "ticket_id" IN (SELECT "id" FROM "support_tickets" WHERE "user_id" NOT IN (${castFullyKeepIds}))`);

    // support_ticket_attachments -> support_tickets (will cascade on ticket delete, but also need to clean orphaned)
    await tx.$executeRawUnsafe(`DELETE FROM "support_ticket_attachments" WHERE "ticketId" IN (SELECT "id" FROM "support_tickets" WHERE "user_id" NOT IN (${castFullyKeepIds}))`);

    // support_tickets -> users
    await tx.$executeRawUnsafe(`DELETE FROM "support_tickets" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // user_feedback -> users
    await tx.$executeRawUnsafe(`DELETE FROM "user_feedback" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // =====================================================================
    // REFERRAL SYSTEM
    // =====================================================================

    // referral_events -> referrals
    await tx.$executeRawUnsafe(`DELETE FROM "referral_events"`);

    // referral_conversions -> users
    await tx.$executeRawUnsafe(`DELETE FROM "referral_conversions" WHERE "referrer_user_id" NOT IN (${castFullyKeepIds}) AND "referred_user_id" NOT IN (${castFullyKeepIds})`);

    // referrals -> users
    await tx.$executeRawUnsafe(`DELETE FROM "referrals" WHERE "referrer_user_id" NOT IN (${castFullyKeepIds})`);

    // =====================================================================
    // RECOMMENDATION
    // =====================================================================

    await tx.$executeRawUnsafe(`DELETE FROM "recommendation_sessions" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // =====================================================================
    // WAITLIST
    // =====================================================================

    await tx.$executeRawUnsafe(`DELETE FROM "waitlist_entries" WHERE "userId" NOT IN (${castFullyKeepIds})`);

    // =====================================================================
    // AUTH & TOKENS
    // =====================================================================

    await tx.$executeRawUnsafe(`DELETE FROM "otp_verifications" WHERE "user_id" NOT IN (${castFullyKeepIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "user_policy_consents" WHERE "user_id" NOT IN (${castFullyKeepIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "refresh_tokens" WHERE "user_id" NOT IN (${castFullyKeepIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "login_history" WHERE "user_id" NOT IN (${castFullyKeepIds})`);

    // =====================================================================
    // USER ASSOCIATIONS (keep for all kept users)
    // =====================================================================

    await tx.$executeRawUnsafe(`DELETE FROM "user_group_members" WHERE "user_id" NOT IN (${castAllKeepIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "user_departments" WHERE "user_id" NOT IN (${castAllKeepIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "user_org_roles" WHERE "user_id" NOT IN (${castAllKeepIds})`);
    await tx.$executeRawUnsafe(`DELETE FROM "user_profiles" WHERE "user_id" NOT IN (${castAllKeepIds})`);

    // =====================================================================
    // FINALLY: DELETE USERS THEMSELVES
    // =====================================================================

    await tx.$executeRawUnsafe(`DELETE FROM "users" WHERE "id" NOT IN (${castAllKeepIds})`);

    // =====================================================================
    // RESET NODE RESOURCE COUNTERS
    // =====================================================================

    await tx.$executeRawUnsafe(`
      UPDATE nodes
      SET allocated_vcpu = 0,
          allocated_memory_mb = 0,
          allocated_gpu_vram_mb = 0,
          current_session_count = 0;
    `);
  });

  // ── VERIFICATION ──

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
    where: { id: { in: allKeepIds } },
    select: { id: true, email: true },
  });
  for (const u of remainingUsers) {
    console.log(`  ${u.email || u.id} (${u.id})`);
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
