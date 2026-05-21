const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function main() {
  console.log('\n=== ALL ROLES IN SYSTEM ===\n');
  const roles = await prisma.role.findMany({ orderBy: { name: 'asc' } });
  for (const role of roles) {
    console.log(`  ${role.name} (ID: ${role.id})`);
  }

  console.log('\n=== KSRCE USERS (@ksrce.in) ===\n');
  const ksrceUsers = await prisma.user.findMany({
    where: { email: { endsWith: '@ksrce.in' }, deletedAt: null },
    include: {
      organization: true,
      userOrgRoles: { include: { role: true } },
    },
  });

  if (ksrceUsers.length === 0) {
    console.log('  No @ksrce.in users found');
  } else {
    for (const user of ksrceUsers) {
      const r = user.userOrgRoles.map((uor) => uor.role.name).join(', ');
      console.log(`  ${user.email}`);
      console.log(`    Name: ${user.firstName} ${user.lastName}`);
      console.log(`    Organization: ${user.organization?.name || 'N/A'}`);
      console.log(`    Roles: ${r}`);
      console.log(`    Auth Type: ${user.authType}`);
      console.log();
    }
  }

  console.log('\n=== TEST USERS (gmail/other) ===\n');
  const testEmails = ['punith.vs74064@gmail.com', 'viswanaths365@gmail.com', 'ttdinesh@gmail.com', 'test-user@ksrce.in'];
  for (const email of testEmails) {
    const user = await prisma.user.findFirst({
      where: { email, deletedAt: null },
      include: {
        organization: true,
        userOrgRoles: { include: { role: true } },
      },
    });
    if (user) {
      const r = user.userOrgRoles.map((uor) => uor.role.name).join(', ');
      console.log(`  ${user.email}`);
      console.log(`    Name: ${user.firstName} ${user.lastName}`);
      console.log(`    Organization: ${user.organization?.name || 'N/A'}`);
      console.log(`    Roles: ${r}`);
      console.log(`    Auth Type: ${user.authType}`);
    } else {
      console.log(`  ${email} - NOT FOUND`);
    }
    console.log();
  }

  console.log('\n=== KSRCE ORGANIZATION & UNIVERSITY ===\n');
  const ksrceOrg = await prisma.organization.findFirst({
    where: { slug: 'ksrce' },
    include: { university: true },
  });
  if (ksrceOrg) {
    console.log(`  Organization ID: ${ksrceOrg.id}`);
    console.log(`  Organization Name: ${ksrceOrg.name}`);
    console.log(`  Organization Type: ${ksrceOrg.orgType}`);
    console.log(`  University: ${ksrceOrg.university?.name || 'N/A'}`);
    console.log(`  University Domain Suffixes: ${JSON.stringify(ksrceOrg.university?.domainSuffixes)}`);
  }
}

main()
  .catch((e) => console.error(e))
  .finally(() => prisma.$disconnect());
