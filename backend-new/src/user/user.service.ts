import { Injectable, NotFoundException, BadRequestException, InternalServerErrorException, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

interface OnboardingProfileDto {
  profession?: string;
  expertiseLevel?: string;
  yearsOfExperience?: number;
  operationalDomains?: string[];
  useCasePurposes?: string[];
  useCaseOther?: string;
  country?: string;
  departmentId?: string;
  courseName?: string;
  academicYear?: number;
  graduationYear?: number;
}

interface UpdateProfileDto {
  displayName?: string;
  phone?: string;
  timezone?: string;
  bio?: string;
  githubUrl?: string;
  linkedinUrl?: string;
  websiteUrl?: string;
  xUrl?: string;
  substackUrl?: string;
  skills?: string[];
}

interface UpdateMentorProfileDto {
  headline?: string;
  mentorBio?: string;
  languages?: string[];
  company?: string;
  professionalRole?: string;
  city?: string;
  country?: string;
  expertiseAreas?: string[];
  experienceYears?: number;
  pricePerHourCents?: number;
  isAvailable?: boolean;
}

@Injectable()
export class UserService {
  private readonly logger = new Logger(UserService.name);

  constructor(private prisma: PrismaService) {}

  async saveOnboardingProfile(userId: string, data: OnboardingProfileDto) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    // First check if profile exists
    const existingProfile = await this.prisma.userProfile.findUnique({
      where: { userId },
    });

    // Prepare the data to save
    const profileData: Record<string, unknown> = {
      isOnboardingComplete: true,
    };

    if (data.profession !== undefined) profileData.profession = data.profession;
    if (data.expertiseLevel !== undefined) profileData.expertiseLevel = data.expertiseLevel;
    if (data.yearsOfExperience !== undefined) profileData.yearsOfExperience = data.yearsOfExperience;
    if (data.operationalDomains !== undefined) profileData.operationalDomains = data.operationalDomains;
    if (data.useCasePurposes !== undefined) profileData.useCasePurposes = data.useCasePurposes;
    if (data.useCaseOther !== undefined) profileData.useCaseOther = data.useCaseOther;
    if (data.country !== undefined) profileData.country = data.country;
    if (data.departmentId !== undefined) profileData.departmentId = data.departmentId || null;
    if (data.courseName !== undefined) profileData.courseName = data.courseName || null;
    if (data.academicYear !== undefined) profileData.academicYear = data.academicYear || null;
    if (data.graduationYear !== undefined) profileData.graduationYear = data.graduationYear || null;

    // Validate department exists before creating relationship
    if (data.departmentId) {
      const department = await this.prisma.department.findUnique({
        where: { id: data.departmentId },
      });
      if (!department) {
        throw new BadRequestException('Invalid department ID');
      }
    }

    let profile;
    try {
      if (existingProfile) {
        profile = await this.prisma.userProfile.update({
          where: { userId },
          data: profileData,
        });
      } else {
        profile = await this.prisma.userProfile.create({
          data: {
            userId,
            ...profileData,
          },
        });
      }

      // If departmentId is provided, upsert UserDepartment record
      if (data.departmentId) {
        await this.prisma.userDepartment.upsert({
          where: {
            userId_departmentId: {
              userId,
              departmentId: data.departmentId,
            },
          },
          update: {
            isPrimary: true,
          },
          create: {
            userId,
            departmentId: data.departmentId,
            isPrimary: true,
          },
        });
      }
    } catch (error) {
      if (error instanceof BadRequestException) throw error;
      this.logger.error(`Failed to save onboarding profile for user ${userId}`, error);
      throw new InternalServerErrorException('Failed to save profile. Please try again.');
    }

    return {
      success: true,
      profileId: profile.id,
      onboardingComplete: true,
    };
  }

  async getOnboardingStatus(userId: string) {
    const profile = await this.prisma.userProfile.findUnique({
      where: { userId },
    });

    const p = profile as Record<string, unknown> | null;

    return {
      isOnboardingComplete: (p?.isOnboardingComplete as boolean) ?? false,
      hasProfession: !!(p?.profession as string),
      hasExpertiseLevel: !!(p?.expertiseLevel as string),
      hasYearsOfExperience: !!(p?.yearsOfExperience as number),
      hasOperationalDomains: ((p?.operationalDomains as string[])?.length ?? 0) > 0,
      hasUseCasePurposes: ((p?.useCasePurposes as string[])?.length ?? 0) > 0,
      hasCountry: !!(p?.country as string),
    };
  }

  async getFullProfile(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      include: {
        profile: {
          include: {
            department: true,
          },
        },
        wallet: true,
        organization: true,
        mentorProfile: true,
      },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    const wallet = user.wallet;
    const profile = user.profile;
    const mentorProfile = user.mentorProfile;

    return {
      // From User
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      displayName: user.displayName,
      avatarUrl: user.avatarUrl,
      phone: user.phone,
      timezone: user.timezone,
      createdAt: user.createdAt,
      lastLoginAt: user.lastLoginAt,
      authType: user.authType,
      oauthProvider: user.oauthProvider,
      twoFactorEnabled: user.twoFactorEnabled,
      // From UserProfile
      bio: profile?.bio,
      profession: profile?.profession,
      expertiseLevel: profile?.expertiseLevel,
      yearsOfExperience: profile?.yearsOfExperience,
      collegeName: profile?.collegeName,
      courseName: profile?.courseName,
      academicYear: profile?.academicYear,
      departmentName: profile?.department?.name,
      skills: profile?.skills,
      githubUrl: profile?.githubUrl,
      linkedinUrl: profile?.linkedinUrl,
      websiteUrl: profile?.websiteUrl,
      xUrl: profile?.xUrl,
      substackUrl: profile?.substackUrl,
      country: profile?.country,
      operationalDomains: profile?.operationalDomains,
      useCasePurposes: profile?.useCasePurposes,
      // From Wallet
      balanceCents: wallet ? Number(wallet.balanceCents) : null,
      currency: wallet?.currency,
      lifetimeSpentCents: wallet ? Number(wallet.lifetimeSpentCents) : null,
      // From Organization
      organizationName: user.organization?.name,
      // From MentorProfile
      headline: mentorProfile?.headline,
      mentorBio: mentorProfile?.bio,
      languages: mentorProfile?.languages ?? [],
      company: mentorProfile?.company,
      professionalRole: mentorProfile?.professionalRole,
      city: mentorProfile?.city,
      mentorCountry: mentorProfile?.country,
      expertiseAreas: mentorProfile?.expertiseAreas ?? [],
      mentorExperienceYears: mentorProfile?.experienceYears,
      pricePerHourCents: mentorProfile?.pricePerHourCents,
      mentorCurrency: mentorProfile?.currency,
      isAvailable: mentorProfile?.isAvailable,
      avgRating: mentorProfile?.avgRating ? Number(mentorProfile.avgRating) : null,
      totalReviews: mentorProfile?.totalReviews,
      totalSessions: mentorProfile?.totalSessions,
    };
  }

  async updateProfile(userId: string, data: UpdateProfileDto) {
    await this.prisma.$transaction(async (tx) => {
      // Update User fields (only if provided)
      const userUpdateData: Record<string, unknown> = {};
      if (data.displayName !== undefined) userUpdateData.displayName = data.displayName;
      if (data.phone !== undefined) userUpdateData.phone = data.phone;
      if (data.timezone !== undefined) userUpdateData.timezone = data.timezone;

      if (Object.keys(userUpdateData).length > 0) {
        await tx.user.update({
          where: { id: userId },
          data: userUpdateData,
        });
      }

      // Upsert UserProfile fields (only if provided)
      const profileUpdateData: Record<string, unknown> = {};
      if (data.bio !== undefined) profileUpdateData.bio = data.bio;
      if (data.githubUrl !== undefined) profileUpdateData.githubUrl = data.githubUrl;
      if (data.linkedinUrl !== undefined) profileUpdateData.linkedinUrl = data.linkedinUrl;
      if (data.websiteUrl !== undefined) profileUpdateData.websiteUrl = data.websiteUrl;
      if (data.xUrl !== undefined) profileUpdateData.xUrl = data.xUrl;
      if (data.substackUrl !== undefined) profileUpdateData.substackUrl = data.substackUrl;
      if (data.skills !== undefined) profileUpdateData.skills = data.skills;

      if (Object.keys(profileUpdateData).length > 0) {
        await tx.userProfile.upsert({
          where: { userId },
          update: profileUpdateData,
          create: {
            userId,
            ...profileUpdateData,
          },
        });
      }
    });

    // Return the updated full profile
    return this.getFullProfile(userId);
  }

  async updateMentorProfile(userId: string, data: UpdateMentorProfileDto) {
    const mentorData: Record<string, unknown> = {};
    if (data.headline !== undefined) mentorData.headline = data.headline;
    if (data.mentorBio !== undefined) mentorData.bio = data.mentorBio;
    if (data.languages !== undefined) mentorData.languages = data.languages;
    if (data.company !== undefined) mentorData.company = data.company;
    if (data.professionalRole !== undefined) mentorData.professionalRole = data.professionalRole;
    if (data.city !== undefined) mentorData.city = data.city;
    if (data.country !== undefined) mentorData.country = data.country;
    if (data.expertiseAreas !== undefined) mentorData.expertiseAreas = data.expertiseAreas;
    if (data.experienceYears !== undefined) mentorData.experienceYears = data.experienceYears;
    if (data.pricePerHourCents !== undefined) mentorData.pricePerHourCents = data.pricePerHourCents;
    if (data.isAvailable !== undefined) mentorData.isAvailable = data.isAvailable;

    await this.prisma.mentorProfile.upsert({
      where: { userId },
      update: mentorData,
      create: {
        userId,
        ...mentorData,
        pricePerHourCents: (mentorData.pricePerHourCents as number) ?? 0,
      },
    });

    return this.getFullProfile(userId);
  }
}
