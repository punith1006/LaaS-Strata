const { PrismaClient } = require('@prisma/client');
const p = new PrismaClient();

async function main() {
  try {
    // List all tables
    const tables = await p.$queryRawUnsafe(`SELECT table_name FROM information_schema.tables WHERE table_schema='public' ORDER BY table_name`);
    console.log('=== EXISTING TABLES ===');
    const tableNames = tables.map(t => t.table_name);
    console.log(tableNames.join('\n'));

    // Check which tables from the cleanup script exist
    const cleanupTables = [
      'referral_events', 'referral_conversions', 'referrals',
      'ticket_messages', 'support_tickets', 'user_feedback',
      'notifications', 'audit_log',
      'lab_grades', 'lab_submissions', 'lab_assignments', 'course_enrollments',
      'mentor_reviews', 'mentor_bookings',
      'discussion_replies', 'discussions', 'project_showcases', 'user_achievements',
      'session_events', 'node_resource_reservations', 'bookings', 'recommendation_sessions',
      'invoice_line_items', 'invoices', 'billing_charges', 'payment_transactions',
      'subscriptions', 'wallet_holds', 'wallet_transactions', 'wallets',
      'sessions',
      'storage_extensions', 'user_files', 'user_storage_volumes', 'os_switch_history',
      'user_policy_consents', 'refresh_tokens', 'login_history',
      'user_org_roles', 'user_profiles', 'user_departments', 'user_group_members',
      'otp_verifications', 'user_deletion_requests', 'waitlist_entries',
      'users',
    ];

    console.log('\n=== TABLE EXISTENCE CHECK ===');
    const missing = [];
    for (const t of cleanupTables) {
      if (!tableNames.includes(t)) {
        missing.push(t);
        console.log(`  MISSING: ${t}`);
      }
    }
    if (missing.length === 0) {
      console.log('  All tables exist!');
    }

    // Test ANY with uuid[] cast
    console.log('\n=== TEST ANY($1::uuid[]) ===');
    const testIds = ['00000000-0000-0000-0000-000000000000'];
    const result = await p.$executeRawUnsafe(
      `DELETE FROM "users" WHERE "id" = ANY($1::uuid[]) AND 1=0`,
      testIds
    );
    console.log('ANY($1::uuid[]) works! (dry-run, 0 rows affected):', result);

    // Test without cast
    console.log('\n=== TEST ANY($1) without cast ===');
    try {
      const result2 = await p.$executeRawUnsafe(
        `DELETE FROM "users" WHERE "id" = ANY($1) AND 1=0`,
        testIds
      );
      console.log('ANY($1) also works!:', result2);
    } catch (e) {
      console.log('ANY($1) FAILED:', e.message);
    }

  } catch (e) {
    console.log('Error:', e.message);
  } finally {
    await p.$disconnect();
  }
}

main();
