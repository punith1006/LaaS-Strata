import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

const ADMIN_PASSWORD = 'Admin@123';

const ADMINS = [
  {
    email: 'business_lead@ksrce.in',
    firstName: 'Business',
    lastName: 'Lead',
    roleName: 'business_lead',
  },
  {
    email: 'it_admin@ksrce.in',
    firstName: 'IT',
    lastName: 'Administrator',
    roleName: 'it_admin',
  },
];

async function main() {
  // Find KSRCE organization
  const ksrceOrg = await prisma.organization.findUnique({
    where: { slug: 'ksrce' },
  });

  if (!ksrceOrg) {
    console.error('KSRCE organization not found. Please run prisma db seed first.');
    process.exit(1);
  }

  const passwordHash = await bcrypt.hash(ADMIN_PASSWORD, 10);

  for (const admin of ADMINS) {
    // Find the role
    const role = await prisma.role.findUnique({
      where: { name: admin.roleName },
    });

    if (!role) {
      console.error(`Role "${admin.roleName}" not found. Please run prisma db seed first.`);
      continue;
    }

    // Upsert user
    const user = await prisma.user.upsert({
      where: { email: admin.email },
      update: {
        firstName: admin.firstName,
        lastName: admin.lastName,
        isActive: true,
        authType: 'public_local',
      },
      create: {
        email: admin.email,
        firstName: admin.firstName,
        lastName: admin.lastName,
        passwordHash,
        authType: 'public_local',
        isActive: true,
        defaultOrgId: ksrceOrg.id,
      },
    });

    // Assign role to user in KSRCE organization
    await prisma.userOrgRole.upsert({
      where: {
        userId_organizationId_roleId: {
          userId: user.id,
          organizationId: ksrceOrg.id,
          roleId: role.id,
        },
      },
      update: {},
      create: {
        userId: user.id,
        organizationId: ksrceOrg.id,
        roleId: role.id,
      },
    });

    console.log(`Seeded admin user: ${admin.email} (${admin.roleName})`);
  }

  console.log('\nKSRCE admin users seeded successfully!');
  console.log('Login credentials:');
  for (const admin of ADMINS) {
    console.log(`  ${admin.email} / ${ADMIN_PASSWORD}`);
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
