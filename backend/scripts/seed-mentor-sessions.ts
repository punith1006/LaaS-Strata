import { PrismaClient, MentorSessionStatus, MentorSessionType } from '@prisma/client';

const prisma = new PrismaClient();

const SAMPLE_STUDENTS = [
  { email: 'priya.k@example.com', firstName: 'Priya', lastName: 'K.' },
  { email: 'rahul.s@example.com', firstName: 'Rahul', lastName: 'S.' },
  { email: 'vikram.r@example.com', firstName: 'Vikram', lastName: 'R.' },
  { email: 'ananya.r@example.com', firstName: 'Ananya', lastName: 'R.' },
];

async function main() {
  // 1. Find mentor profile
  const mentorProfile = await prisma.mentorProfile.findFirst({
    include: { user: { select: { id: true, email: true } } },
  });

  if (!mentorProfile) {
    console.error('No mentor profile found. Run seed-mentor-user.ts first.');
    process.exit(1);
  }

  console.log(`Found mentor: ${mentorProfile.user.email} (profile: ${mentorProfile.id})`);

  // 2. Find or create sample student users
  const students = await Promise.all(
    SAMPLE_STUDENTS.map(async (s) => {
      const user = await prisma.user.upsert({
        where: { email: s.email },
        update: {},
        create: {
          email: s.email,
          firstName: s.firstName,
          lastName: s.lastName,
          authType: 'public_local',
          isActive: true,
        },
      });
      return user;
    }),
  );
  console.log(`Found/created ${students.length} sample students`);

  // 3. Delete existing sessions for this mentor (idempotent)
  await prisma.mentorSessionStatusHistory.deleteMany({
    where: { mentorSession: { mentorProfileId: mentorProfile.id } },
  });
  await prisma.mentorSession.deleteMany({
    where: { mentorProfileId: mentorProfile.id },
  });
  console.log('Cleared existing sessions for this mentor');

  // 4. Define sample session data
  const now = new Date();
  const tenMinutesAgo = new Date(now.getTime() - 10 * 60 * 1000);
  const tomorrow = new Date(now);
  tomorrow.setDate(tomorrow.getDate() + 1);
  tomorrow.setHours(10, 0, 0, 0);
  const tomorrowEnd = new Date(tomorrow);
  tomorrowEnd.setHours(11, 0, 0, 0);
  const twoDaysAgo = new Date(now.getTime() - 2 * 24 * 60 * 60 * 1000);

  interface SessionSeed {
    type: MentorSessionType;
    status: MentorSessionStatus;
    studentIdx: number;
    domain: string;
    serviceType: string;
    durationMinutes: number;
    earningsCents: number;
    requestedAt: Date;
    scheduledFrom?: Date;
    scheduledTo?: Date;
    approvedAt?: Date;
    startedAt?: Date;
    endedAt?: Date;
    expiresAt?: Date;
    cancelReason?: string;
    statusHistory: { from: MentorSessionStatus; reason: string }[];
  }

  const sessions: SessionSeed[] = [
    // 1. PENDING request — just created 2 mins ago, 15-min TTL
    {
      type: 'meet_now',
      status: 'pending',
      studentIdx: 0,
      domain: 'Machine Learning',
      serviceType: '1-on-1 Tutoring',
      durationMinutes: 60,
      earningsCents: 100000,
      requestedAt: new Date(now.getTime() - 2 * 60 * 1000),
      expiresAt: new Date(now.getTime() + 13 * 60 * 1000),
      statusHistory: [],
    },
    // 2. UPCOMING — approved, scheduled for tomorrow
    {
      type: 'slot_booking',
      status: 'scheduled',
      studentIdx: 1,
      domain: 'Deep Learning',
      serviceType: 'Project Review',
      durationMinutes: 60,
      earningsCents: 100000,
      requestedAt: twoDaysAgo,
      approvedAt: new Date(twoDaysAgo.getTime() + 30 * 60 * 1000),
      scheduledFrom: tomorrow,
      scheduledTo: tomorrowEnd,
      statusHistory: [
        { from: 'pending', reason: 'Student booked a slot' },
      ],
    },
    // 3. PAST — COMPLETED
    {
      type: 'meet_now',
      status: 'completed',
      studentIdx: 3,
      domain: 'Natural Language Processing',
      serviceType: 'Paper Discussion',
      durationMinutes: 45,
      earningsCents: 100000,
      requestedAt: twoDaysAgo,
      approvedAt: new Date(twoDaysAgo.getTime() + 5 * 60 * 1000),
      scheduledFrom: new Date(twoDaysAgo.getTime() + 30 * 60 * 1000),
      scheduledTo: new Date(twoDaysAgo.getTime() + 75 * 60 * 1000),
      startedAt: new Date(twoDaysAgo.getTime() + 30 * 60 * 1000),
      endedAt: new Date(twoDaysAgo.getTime() + 75 * 60 * 1000),
      statusHistory: [
        { from: 'pending', reason: 'Mentor approved session request' },
        { from: 'live', reason: 'Session started' },
        { from: 'completed', reason: 'Session completed successfully' },
      ],
    },
    // 4. PAST — REQUEST EXPIRED
    {
      type: 'meet_now',
      status: 'request_expired',
      studentIdx: 2,
      domain: 'Computer Vision',
      serviceType: 'Code Review',
      durationMinutes: 45,
      earningsCents: 75000,
      requestedAt: new Date(now.getTime() - 25 * 60 * 1000),
      expiresAt: new Date(now.getTime() - 10 * 60 * 1000),
      statusHistory: [
        { from: 'pending', reason: '15-min TTL expired, no action taken' },
      ],
    },
    // 5. PAST — REJECTED
    {
      type: 'meet_now',
      status: 'rejected',
      studentIdx: 0,
      domain: 'Machine Learning',
      serviceType: '1-on-1 Tutoring',
      durationMinutes: 30,
      earningsCents: 50000,
      requestedAt: new Date(twoDaysAgo.getTime() + 60 * 60 * 1000),
      cancelReason: 'Schedule conflict',
      statusHistory: [
        { from: 'pending', reason: 'Mentor rejected: Schedule conflict' },
      ],
    },
    // 6. LIVE — currently in progress
    {
      type: 'meet_now',
      status: 'live',
      studentIdx: 3,
      domain: 'Natural Language Processing',
      serviceType: 'Paper Discussion',
      durationMinutes: 60,
      earningsCents: 100000,
      requestedAt: new Date(now.getTime() - 40 * 60 * 1000),
      approvedAt: new Date(now.getTime() - 38 * 60 * 1000),
      scheduledFrom: tenMinutesAgo,
      scheduledTo: new Date(now.getTime() + 50 * 60 * 1000),
      startedAt: tenMinutesAgo,
      statusHistory: [
        { from: 'pending', reason: 'Mentor approved session request' },
        { from: 'live', reason: 'Session started' },
      ],
    },
  ];

  // 5. Create sessions
  for (const s of sessions) {
    const student = students[s.studentIdx];
    const sessionId = crypto.randomUUID();

    await prisma.mentorSession.create({
      data: {
        id: sessionId,
        type: s.type,
        status: s.status,
        paymentStatus: 'unpaid',
        mentorProfileId: mentorProfile.id,
        studentUserId: student.id,
        requestedAt: s.requestedAt,
        approvedAt: s.approvedAt,
        scheduledFrom: s.scheduledFrom,
        scheduledTo: s.scheduledTo,
        startedAt: s.startedAt,
        endedAt: s.endedAt,
        expiresAt: s.expiresAt,
        durationMinutes: s.durationMinutes,
        domain: s.domain,
        serviceType: s.serviceType,
        jitsiRoomName: `mentor-session-${sessionId.slice(0, 8)}`,
        earningsCents: s.earningsCents,
        cancelReason: s.cancelReason,
      },
    });

    // Create initial status history entry
    if (s.statusHistory.length > 0) {
      await prisma.mentorSessionStatusHistory.create({
        data: {
          mentorSessionId: sessionId,
          fromStatus: s.statusHistory[0].from,
          toStatus: s.status,
          changedBy: 'seed-script',
          reason: s.statusHistory[0].reason,
          timestamp: s.requestedAt,
        },
      });
    } else {
      await prisma.mentorSessionStatusHistory.create({
        data: {
          mentorSessionId: sessionId,
          fromStatus: 'pending',
          toStatus: s.status,
          changedBy: 'seed-script',
          reason: 'Session created via seed',
          timestamp: s.requestedAt,
        },
      });
    }

    const statusLabel = s.status === 'live' ? 'LIVE' : s.status;
    console.log(`  [${statusLabel.toUpperCase().padEnd(16)}] ${s.domain} — ${student.firstName} ${student.lastName}`);
  }

  console.log('\n========================================');
  console.log('Mentor session seed data created!');
  console.log('========================================');
  console.log('  Pending:   Priya K. — Machine Learning (15-min countdown)');
  console.log('  Upcoming:  Rahul S. — Deep Learning (tomorrow 10:00)');
  console.log('  Live:      Ananya R. — NLP (started 10 min ago)');
  console.log('  Past:      3 records (Completed, Expired, Rejected)');
  console.log('========================================\n');
}

main()
  .catch((e) => {
    console.error('Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
