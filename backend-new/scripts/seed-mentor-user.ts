import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

const MENTOR_PASSWORD = 'Mentor@123';

const MENTOR = {
  email: 'mentor@laas.io',
  firstName: 'Arjun',
  lastName: 'Mehta',
  headline: 'Senior AI/ML Engineer | 8+ Years Experience',
  bio: 'Experienced AI/ML engineer specializing in deep learning, computer vision, and NLP. I help students and professionals master PyTorch, TensorFlow, and production ML deployment.',
  expertiseAreas: ['Deep Learning', 'PyTorch', 'TensorFlow', 'Computer Vision', 'NLP', 'MLOps'],
  experienceYears: 8,
  pricePerHourCents: 100000, // Rs.1,000/hr
};

async function main() {
  // Find the mentor role
  const role = await prisma.role.findUnique({
    where: { name: 'mentor' },
  });

  if (!role) {
    console.error('Role "mentor" not found. Please run prisma db seed first.');
    process.exit(1);
  }

  // Find the public organization
  const publicOrg = await prisma.organization.findUnique({
    where: { slug: 'public' },
  });

  if (!publicOrg) {
    console.error('Public organization not found. Please run prisma db seed first.');
    process.exit(1);
  }

  const passwordHash = await bcrypt.hash(MENTOR_PASSWORD, 10);

  // Upsert user
  const user = await prisma.user.upsert({
    where: { email: MENTOR.email },
    update: {
      firstName: MENTOR.firstName,
      lastName: MENTOR.lastName,
      isActive: true,
      authType: 'public_local',
    },
    create: {
      email: MENTOR.email,
      firstName: MENTOR.firstName,
      lastName: MENTOR.lastName,
      passwordHash,
      authType: 'public_local',
      isActive: true,
      defaultOrgId: publicOrg.id,
      onboardingCompletedAt: new Date(),
    },
  });

  console.log(`User created/updated: ${user.email} (${user.id})`);

  // Assign mentor role to user in public organization
  await prisma.userOrgRole.upsert({
    where: {
      userId_organizationId_roleId: {
        userId: user.id,
        organizationId: publicOrg.id,
        roleId: role.id,
      },
    },
    update: {},
    create: {
      userId: user.id,
      organizationId: publicOrg.id,
      roleId: role.id,
    },
  });

  console.log(`Role assigned: ${MENTOR.email} → ${role.name}`);

  // Create UserProfile with onboarding marked complete (mentors skip onboarding)
  await prisma.userProfile.upsert({
    where: { userId: user.id },
    update: {
      isOnboardingComplete: true,
      profession: 'Mentor',
      expertiseLevel: 'expert',
      skills: MENTOR.expertiseAreas,
    },
    create: {
      userId: user.id,
      isOnboardingComplete: true,
      profession: 'Mentor',
      expertiseLevel: 'expert',
      skills: MENTOR.expertiseAreas,
    },
  });

  console.log('UserProfile created with onboarding complete');

  // Create or update MentorProfile
  const mentorProfile = await prisma.mentorProfile.upsert({
    where: { userId: user.id },
    update: {
      headline: MENTOR.headline,
      bio: MENTOR.bio,
      expertiseAreas: MENTOR.expertiseAreas,
      experienceYears: MENTOR.experienceYears,
      pricePerHourCents: MENTOR.pricePerHourCents,
      isAvailable: true,
    },
    create: {
      userId: user.id,
      headline: MENTOR.headline,
      bio: MENTOR.bio,
      expertiseAreas: MENTOR.expertiseAreas,
      experienceYears: MENTOR.experienceYears,
      pricePerHourCents: MENTOR.pricePerHourCents,
      isAvailable: true,
    },
  });

  console.log(`MentorProfile created/updated: ${mentorProfile.id}`);

  // Create wallet if not exists
  await prisma.wallet.upsert({
    where: { userId: user.id },
    update: {},
    create: {
      userId: user.id,
      balanceCents: BigInt(500000), // Rs.5,000 starting balance
      currency: 'INR',
      lifetimeCreditsCents: BigInt(500000),
      lifetimeSpentCents: BigInt(0),
      lowBalanceThresholdCents: 10000, // Rs.100
    },
  });

  console.log('Wallet created with Rs.5,000 starting balance');

  console.log('\n========================================');
  console.log('Mentor user seeded successfully!');
  console.log('========================================');
  console.log('Login credentials:');
  console.log(`  Email:    ${MENTOR.email}`);
  console.log(`  Password: ${MENTOR_PASSWORD}`);
  console.log(`  Role:     ${role.name}`);
  console.log(`  Rate:     Rs.${(MENTOR.pricePerHourCents / 100).toFixed(0)}/hr`);
  console.log('========================================\n');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
