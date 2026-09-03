import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const user = await prisma.user.findUnique({
    where: { email: 'mentor@laas.io' },
    select: {
      id: true,
      email: true,
      isActive: true,
      authType: true,
      passwordHash: true,
      defaultOrgId: true,
      onboardingCompletedAt: true,
      userOrgRoles: {
        select: { role: { select: { name: true } } },
      },
      profile: {
        select: { isOnboardingComplete: true },
      },
    },
  });

  if (!user) {
    console.log('User not found!');
    await prisma.$disconnect();
    return;
  }

  console.log('User found:');
  console.log(`  id: ${user.id}`);
  console.log(`  email: ${user.email}`);
  console.log(`  isActive: ${user.isActive}`);
  console.log(`  authType: ${user.authType}`);
  console.log(`  hasPasswordHash: ${!!user.passwordHash}`);
  console.log(`  passwordHash length: ${user.passwordHash?.length}`);
  console.log(`  defaultOrgId: ${user.defaultOrgId}`);
  console.log(`  onboardingCompletedAt: ${user.onboardingCompletedAt}`);
  console.log(`  roles: ${user.userOrgRoles.map(r => r.role.name).join(', ')}`);
  console.log(`  onboardingComplete: ${user.profile?.isOnboardingComplete}`);

  // Also check if there's a UserProfile
  const profile = await prisma.userProfile.findUnique({
    where: { userId: user.id },
    select: { isOnboardingComplete: true, profession: true },
  });
  console.log(`  UserProfile exists: ${!!profile}`);
  console.log(`  UserProfile.isOnboardingComplete: ${profile?.isOnboardingComplete}`);
  console.log(`  UserProfile.profession: ${profile?.profession}`);

  await prisma.$disconnect();
}

main().catch(console.error);
