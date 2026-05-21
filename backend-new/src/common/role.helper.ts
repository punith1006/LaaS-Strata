import { PrismaClient } from '@prisma/client';

/**
 * Check if a user has the 'student' role in the system.
 * Students are institutional users (@ksrce.in) exempt from compute/storage billing.
 */
export async function isStudentRole(
  prisma: PrismaClient,
  userId: string,
): Promise<boolean> {
  const match = await prisma.userOrgRole.findFirst({
    where: { userId, role: { name: 'student' } },
  });
  return !!match;
}
