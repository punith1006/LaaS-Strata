import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const TARGET_EMAILS = [
  'sowdhanya2007cse24_27@ksrce.ac.in',
  'harshananithishcse24_27@ksrce.ac.in',
  'gowthamgowtham24309@gmail.com',
  'shyamshyam14715it24-28@ksrce.ac.in',
  'bharaniprabakaran24it24-28@ksrce.ac.in',
  'sanjay8248116246cse24_27@ksrce.ac.in',
];

async function deleteUser(email: string) {
  console.log(`\n========================================`);
  console.log(`Targeting user: ${email}`);
  console.log(`========================================`);

  const user = await prisma.user.findUnique({
    where: { email },
    select: { id: true, email: true, firstName: true, lastName: true },
  });

  if (!user) {
    console.log(`❌ User with email "${email}" not found. Skipping.`);
    return;
  }

  const userId = user.id;
  console.log(`✅ Found User ID: ${userId} (${user.firstName} ${user.lastName})`);

  // Helper function to delete and log
  async function deleteAndLog(table: string, deleteFn: () => Promise<{ count: number }>) {
    try {
      const result = await deleteFn();
      if (result.count > 0) {
        console.log(`  ✓ Deleted ${result.count} record(s) from ${table}`);
      }
      return result.count;
    } catch (error) {
      console.log(`  ⚠ Error deleting from ${table}: ${error}`);
      return 0;
    }
  }

  // Phase 1: Deep dependencies
  const sessions = await prisma.session.findMany({ where: { userId }, select: { id: true } });
  const sessionIds = sessions.map((s) => s.id);
  if (sessionIds.length > 0) {
    await deleteAndLog('session_events', () =>
      prisma.sessionEvent.deleteMany({ where: { sessionId: { in: sessionIds } } })
    );
    await deleteAndLog('node_resource_reservations', () =>
      prisma.nodeResourceReservation.deleteMany({ where: { sessionId: { in: sessionIds } } })
    );
  }

  const supportTickets = await prisma.supportTicket.findMany({ where: { userId }, select: { id: true } });
  const ticketIds = supportTickets.map((t) => t.id);
  if (ticketIds.length > 0) {
    await deleteAndLog('ticket_messages', () =>
      prisma.ticketMessage.deleteMany({ where: { ticketId: { in: ticketIds } } })
    );
  }

  const invoices = await prisma.invoice.findMany({ where: { userId }, select: { id: true } });
  const invoiceIds = invoices.map((i) => i.id);
  if (invoiceIds.length > 0) {
    await deleteAndLog('invoice_line_items', () =>
      prisma.invoiceLineItem.deleteMany({ where: { invoiceId: { in: invoiceIds } } })
    );
  }

  const mentorProfile = await prisma.mentorProfile.findUnique({ where: { userId }, select: { id: true } });
  if (mentorProfile) {
    const mentorBookings = await prisma.mentorBooking.findMany({
      where: { mentorProfileId: mentorProfile.id },
      select: { id: true },
    });
    const mentorBookingIds = mentorBookings.map((b) => b.id);
    if (mentorBookingIds.length > 0) {
      await deleteAndLog('mentor_reviews', () =>
        prisma.mentorReview.deleteMany({ where: { mentorBookingId: { in: mentorBookingIds } } })
      );
    }
    await deleteAndLog('mentor_availability_slots', () =>
      prisma.mentorAvailabilitySlot.deleteMany({ where: { mentorProfileId: mentorProfile.id } })
    );
    await deleteAndLog('mentor_bookings (as mentor)', () =>
      prisma.mentorBooking.deleteMany({ where: { mentorProfileId: mentorProfile.id } })
    );
  }

  const referral = await prisma.referral.findUnique({ where: { referrerUserId: userId }, select: { id: true } });
  if (referral) {
    const conversions = await prisma.referralConversion.findMany({
      where: { referralId: referral.id },
      select: { id: true },
    });
    const conversionIds = conversions.map((c) => c.id);
    if (conversionIds.length > 0) {
      await deleteAndLog('referral_events (by conversion)', () =>
        prisma.referralEvent.deleteMany({ where: { referralConversionId: { in: conversionIds } } })
      );
    }
    await deleteAndLog('referral_events (by referral)', () =>
      prisma.referralEvent.deleteMany({ where: { referralId: referral.id } })
    );
    await deleteAndLog('referral_conversions', () =>
      prisma.referralConversion.deleteMany({ where: { referralId: referral.id } })
    );
  }

  // Phase 2: Direct relations
  await deleteAndLog('referral_conversions (as referred)', () =>
    prisma.referralConversion.deleteMany({ where: { referredUserId: userId } })
  );
  if (referral) {
    await deleteAndLog('referrals', () =>
      prisma.referral.delete({ where: { id: referral.id } }).then(() => ({ count: 1 }))
    );
  }
  await deleteAndLog('mentor_reviews (as reviewer)', () =>
    prisma.mentorReview.deleteMany({ where: { reviewerUserId: userId } })
  );
  await deleteAndLog('mentor_bookings (as student)', () =>
    prisma.mentorBooking.deleteMany({ where: { studentUserId: userId } })
  );
  await deleteAndLog('mentor_profiles', () =>
    prisma.mentorProfile.deleteMany({ where: { userId } })
  );
  await deleteAndLog('lab_grades (as grader)', () =>
    prisma.labGrade.deleteMany({ where: { gradedBy: userId } })
  );
  await deleteAndLog('lab_submissions', () =>
    prisma.labSubmission.deleteMany({ where: { userId } })
  );
  await deleteAndLog('course_enrollments', () =>
    prisma.courseEnrollment.deleteMany({ where: { userId } })
  );
  await deleteAndLog('discussion_replies', () =>
    prisma.discussionReply.deleteMany({ where: { authorId: userId } })
  );
  await deleteAndLog('discussions', () =>
    prisma.discussion.deleteMany({ where: { authorId: userId } })
  );
  await deleteAndLog('project_showcases', () =>
    prisma.projectShowcase.deleteMany({ where: { userId } })
  );
  await deleteAndLog('user_achievements', () =>
    prisma.userAchievement.deleteMany({ where: { userId } })
  );
  await deleteAndLog('notifications', () =>
    prisma.notification.deleteMany({ where: { userId } })
  );
  await deleteAndLog('audit_logs', () =>
    prisma.auditLog.deleteMany({ where: { actorId: userId } })
  );
  await deleteAndLog('user_feedback', () =>
    prisma.userFeedback.deleteMany({ where: { userId } })
  );
  await deleteAndLog('user_feedback (as responder)', () =>
    prisma.userFeedback.deleteMany({ where: { respondedBy: userId } })
  );
  await deleteAndLog('user_deletion_requests', () =>
    prisma.userDeletionRequest.deleteMany({ where: { userId } })
  );
  await deleteAndLog('user_deletion_requests (as requester)', () =>
    prisma.userDeletionRequest.deleteMany({ where: { requestedBy: userId } })
  );
  await deleteAndLog('support_tickets', () =>
    prisma.supportTicket.deleteMany({ where: { userId } })
  );
  await deleteAndLog('support_tickets (as assignee)', () =>
    prisma.supportTicket.deleteMany({ where: { assignedTo: userId } })
  );
  await deleteAndLog('ticket_messages (as sender)', () =>
    prisma.ticketMessage.deleteMany({ where: { senderId: userId } })
  );
  await deleteAndLog('recommendation_sessions', () =>
    prisma.recommendationSession.deleteMany({ where: { userId } })
  );

  // Phase 3: Wallets & billing
  const wallet = await prisma.wallet.findUnique({ where: { userId }, select: { id: true } });
  if (wallet) {
    const walletTxns = await prisma.walletTransaction.findMany({
      where: { walletId: wallet.id },
      select: { id: true },
    });
    const walletTxnIds = walletTxns.map((t) => t.id);
    if (walletTxnIds.length > 0) {
      await prisma.$executeRawUnsafe(`
        UPDATE billing_charges 
        SET wallet_transaction_id = NULL 
        WHERE wallet_transaction_id IN (${walletTxnIds.map((id) => `'${id}'`).join(',')})
      `);
      await prisma.$executeRawUnsafe(`
        UPDATE storage_extensions 
        SET wallet_transaction_id = NULL 
        WHERE wallet_transaction_id IN (${walletTxnIds.map((id) => `'${id}'`).join(',')})
      `);
    }
    await deleteAndLog('wallet_holds (by wallet)', () =>
      prisma.walletHold.deleteMany({ where: { walletId: wallet.id } })
    );
    await deleteAndLog('wallet_transactions', () =>
      prisma.walletTransaction.deleteMany({ where: { walletId: wallet.id } })
    );
  }
  await deleteAndLog('wallet_holds (by user)', () =>
    prisma.walletHold.deleteMany({ where: { userId } })
  );
  await deleteAndLog('wallet_transactions (by user)', () =>
    prisma.walletTransaction.deleteMany({ where: { userId } })
  );
  await deleteAndLog('billing_charges', () =>
    prisma.billingCharge.deleteMany({ where: { userId } })
  );
  await deleteAndLog('invoices', () =>
    prisma.invoice.deleteMany({ where: { userId } })
  );
  await deleteAndLog('subscriptions', () =>
    prisma.subscription.deleteMany({ where: { userId } })
  );
  await deleteAndLog('payment_transactions', () =>
    prisma.paymentTransaction.deleteMany({ where: { userId } })
  );
  if (wallet) {
    await deleteAndLog('wallets', () =>
      prisma.wallet.delete({ where: { id: wallet.id } }).then(() => ({ count: 1 }))
    );
  }

  // Phase 4: Sessions & bookings
  await deleteAndLog('sessions', () =>
    prisma.session.deleteMany({ where: { userId } })
  );
  await deleteAndLog('bookings', () =>
    prisma.booking.deleteMany({ where: { userId } })
  );

  // Phase 5: Storage
  const storageVolumes = await prisma.userStorageVolume.findMany({
    where: { userId },
    select: { id: true },
  });
  const storageVolumeIds = storageVolumes.map((v) => v.id);
  if (storageVolumeIds.length > 0) {
    await deleteAndLog('billing_charges (by storage volume)', () =>
      prisma.billingCharge.deleteMany({ where: { storageVolumeId: { in: storageVolumeIds } } })
    );
    await prisma.$executeRawUnsafe(`
      UPDATE os_switch_history 
      SET old_volume_id = NULL 
      WHERE old_volume_id IN (${storageVolumeIds.map((id) => `'${id}'`).join(',')})
    `);
    await prisma.$executeRawUnsafe(`
      UPDATE os_switch_history 
      SET new_volume_id = NULL 
      WHERE new_volume_id IN (${storageVolumeIds.map((id) => `'${id}'`).join(',')})
    `);
    await deleteAndLog('storage_extensions (by volume)', () =>
      prisma.storageExtension.deleteMany({ where: { storageVolumeId: { in: storageVolumeIds } } })
    );
  }
  await deleteAndLog('storage_extensions (by user)', () =>
    prisma.storageExtension.deleteMany({ where: { userId } })
  );
  await deleteAndLog('os_switch_history', () =>
    prisma.osSwitchHistory.deleteMany({ where: { userId } })
  );
  await deleteAndLog('user_files', () =>
    prisma.userFile.deleteMany({ where: { userId } })
  );
  await deleteAndLog('user_storage_volumes', () =>
    prisma.userStorageVolume.deleteMany({ where: { userId } })
  );

  // Phase 6: Auth & profiles
  await deleteAndLog('otp_verifications', () =>
    prisma.otpVerification.deleteMany({ where: { userId } })
  );
  await deleteAndLog('user_policy_consents', () =>
    prisma.userPolicyConsent.deleteMany({ where: { userId } })
  );
  await deleteAndLog('refresh_tokens', () =>
    prisma.refreshToken.deleteMany({ where: { userId } })
  );
  await deleteAndLog('login_history', () =>
    prisma.loginHistory.deleteMany({ where: { userId } })
  );
  await deleteAndLog('user_org_roles', () =>
    prisma.userOrgRole.deleteMany({ where: { userId } })
  );
  await deleteAndLog('user_group_members', () =>
    prisma.userGroupMember.deleteMany({ where: { userId } })
  );
  await deleteAndLog('user_group_members (as adder)', () =>
    prisma.userGroupMember.deleteMany({ where: { addedBy: userId } })
  );
  await deleteAndLog('user_departments', () =>
    prisma.userDepartment.deleteMany({ where: { userId } })
  );
  await deleteAndLog('user_profiles', () =>
    prisma.userProfile.deleteMany({ where: { userId } })
  );

  // Phase 7: Delete User record
  try {
    await prisma.user.delete({ where: { id: userId } });
    console.log(`  ✓ Successfully deleted User: ${email}`);
  } catch (error) {
    console.log(`  ❌ Error deleting User record: ${error}`);
  }
}

async function main() {
  console.log(`Starting clean deletion for ${TARGET_EMAILS.length} users...`);
  for (const email of TARGET_EMAILS) {
    await deleteUser(email);
  }
  console.log('\nAll targeted user cleanups completed!');
}

main()
  .then(() => prisma.$disconnect())
  .catch((e) => {
    console.error(e);
    prisma.$disconnect();
    process.exit(1);
  });
