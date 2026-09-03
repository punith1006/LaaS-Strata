"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { getUserProfile, updateUserProfile, updateMentorProfile, getMe } from "@/lib/api";
import AvailabilityManager from "@/components/mentor/availability-manager";
import type { ProfileData, EditableProfileData, EditableMentorProfileData } from "@/types/auth";

// Helper to format currency
function formatCurrency(cents: number | null, currency: string | null): string {
  if (cents === null || cents === undefined) return "-";
  const code = currency || "INR";
  return new Intl.NumberFormat("en-IN", {
    style: "currency",
    currency: code,
  }).format(cents / 100);
}

// Helper to format date
function formatDate(dateStr: string | null): string {
  if (!dateStr) return "-";
  return new Date(dateStr).toLocaleDateString("en-US", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
}

// Get initials from name
function getInitials(firstName: string, lastName: string): string {
  const first = firstName?.charAt(0) || "";
  const last = lastName?.charAt(0) || "";
  return (first + last).toUpperCase() || "?";
}

// Get auth method display
function getAuthMethodDisplay(profile: ProfileData): string {
  if (profile.oauthProvider === "google") return "Google OAuth";
  if (profile.oauthProvider === "github") return "GitHub OAuth";
  if (profile.authType === "institution_local" || profile.authType === "university_sso") {
    return "Institutional SSO";
  }
  return "Email & Password";
}

// Get auth badge color
function getAuthBadgeStyle(provider: string | null, authType: string): React.CSSProperties {
  const base: React.CSSProperties = {
    display: "inline-flex",
    alignItems: "center",
    padding: "0 8px",
    borderRadius: "2px",
    fontSize: "0.75rem",
    fontWeight: 500,
    height: "22px",
  };

  if (provider === "google") {
    return { ...base, backgroundColor: "#4285F4", color: "#fff" };
  }
  if (provider === "github") {
    return { ...base, backgroundColor: "#333", color: "#fff" };
  }
  if (authType === "institution_local" || authType === "university_sso") {
    return { ...base, backgroundColor: "#7C3AED", color: "#fff" };
  }
  return { ...base, backgroundColor: "var(--bgColor-muted)", color: "var(--fgColor-default)" };
}

// Section Card Component
function SectionCard({
  title,
  children,
  action,
  accent = false,
}: {
  title: string;
  children: React.ReactNode;
  action?: React.ReactNode;
  accent?: boolean;
}) {
  return (
    <div
      style={{
        background: "var(--bgColor-mild)",
        border: "1px solid var(--borderColor-default)",
        borderRadius: "4px",
        overflow: "hidden",
      }}
    >
      {/* Header */}
      <div
        style={{
          background: accent ? "var(--bgColor-info, #cedeff)" : "var(--bgColor-muted)",
          padding: "0 20px",
          height: "40px",
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
          borderBottom: accent ? "1px solid var(--borderColor-info, #3a73ff)" : "1px solid var(--borderColor-default)",
        }}
      >
        <span
          style={{
            fontSize: "0.75rem",
            fontWeight: 500,
            textTransform: "uppercase",
            letterSpacing: "0.06em",
            color: "var(--fgColor-default)",
            fontFamily: "var(--font-outfit), sans-serif",
          }}
        >
          {title}
        </span>
        {action}
      </div>
      {/* Body */}
      <div style={{ padding: "0" }}>{children}</div>
    </div>
  );
}

// Info Row Component
function InfoRow({
  label,
  value,
  isEditing,
  editComponent,
  isLast = false,
}: {
  label: string;
  value: React.ReactNode;
  isEditing?: boolean;
  editComponent?: React.ReactNode;
  isLast?: boolean;
}) {
  return (
    <div
      style={{
        display: "flex",
        alignItems: isEditing ? "flex-start" : "center",
        gap: "16px",
        minHeight: "48px",
        padding: isEditing ? "12px 20px" : "0 20px",
        borderBottom: isLast ? "none" : "1px solid var(--borderColor-default)",
      }}
    >
      <span
        style={{
          width: "160px",
          flexShrink: 0,
          color: "var(--fgColor-muted)",
          fontSize: "0.75rem",
          fontWeight: 400,
          lineHeight: "1rem",
          fontFamily: "var(--font-outfit), sans-serif",
        }}
      >
        {label}
      </span>
      <div style={{ flex: 1, fontSize: "0.875rem", lineHeight: "1.375rem", fontWeight: 400, color: "var(--fgColor-default)", fontFamily: "var(--font-outfit), sans-serif" }}>
        {isEditing ? editComponent : value}
      </div>
    </div>
  );
}

// Input Component
function TextInput({
  value,
  onChange,
  placeholder,
  type = "text",
}: {
  value: string;
  onChange: (val: string) => void;
  placeholder?: string;
  type?: string;
}) {
  return (
    <input
      type={type}
      value={value}
      onChange={(e) => onChange(e.target.value)}
      placeholder={placeholder}
      style={{
        width: "100%",
        height: "40px",
        background: "transparent",
        border: "1px solid var(--borderColor-strong)",
        borderRadius: "4px",
        padding: "8px",
        color: "var(--fgColor-default)",
        fontSize: "0.875rem",
        fontFamily: "var(--font-outfit), sans-serif",
        outline: "none",
      }}
    />
  );
}

// Textarea Component
function TextArea({
  value,
  onChange,
  placeholder,
  rows = 3,
}: {
  value: string;
  onChange: (val: string) => void;
  placeholder?: string;
  rows?: number;
}) {
  return (
    <textarea
      value={value}
      onChange={(e) => onChange(e.target.value)}
      placeholder={placeholder}
      rows={rows}
      style={{
        width: "100%",
        background: "transparent",
        border: "1px solid var(--borderColor-strong)",
        borderRadius: "4px",
        padding: "8px",
        color: "var(--fgColor-default)",
        fontSize: "0.875rem",
        fontFamily: "var(--font-outfit), sans-serif",
        outline: "none",
        resize: "vertical",
      }}
    />
  );
}

// Pill Tag Component
function PillTag({ label }: { label: string }) {
  return (
    <span
      style={{
        display: "inline-flex",
        alignItems: "center",
        padding: "0 8px",
        borderRadius: "2px",
        background: "var(--bgColor-muted)",
        fontSize: "0.75rem",
        fontWeight: 500,
        height: "22px",
        color: "var(--fgColor-default)",
      }}
    >
      {label}
    </span>
  );
}

// Button Components
function Button({
  children,
  onClick,
  variant = "primary",
  size = "default",
  disabled = false,
}: {
  children: React.ReactNode;
  onClick?: () => void;
  variant?: "primary" | "secondary" | "ghost";
  size?: "default" | "compact";
  disabled?: boolean;
}) {
  const isCompact = size === "compact";
  const baseStyle: React.CSSProperties = {
    display: "inline-flex",
    alignItems: "center",
    justifyContent: "center",
    height: isCompact ? "32px" : "40px",
    padding: isCompact ? "0 12px" : "0 24px",
    borderRadius: "4px",
    fontSize: isCompact ? "0.75rem" : "0.875rem",
    fontWeight: 500,
    cursor: disabled ? "not-allowed" : "pointer",
    opacity: disabled ? 0.4 : 1,
    fontFamily: "var(--font-outfit), sans-serif",
    transition: "opacity 0.15s ease",
  };

  const variantStyles: Record<string, React.CSSProperties> = {
    primary: {
      background: "var(--fgColor-default)",
      color: "var(--fgColor-inverse)",
      border: "1px solid var(--fgColor-default)",
    },
    secondary: {
      background: "transparent",
      color: "var(--fgColor-default)",
      border: "1px solid var(--borderColor-default)",
    },
    ghost: {
      background: "transparent",
      color: "var(--fgColor-muted)",
      border: "1px solid transparent",
    },
  };

  return (
    <button
      onClick={onClick}
      disabled={disabled}
      style={{ ...baseStyle, ...variantStyles[variant] }}
    >
      {children}
    </button>
  );
}

// Toast Component
function Toast({ message, onClose }: { message: string; onClose: () => void }) {
  useEffect(() => {
    const timer = setTimeout(onClose, 3000);
    return () => clearTimeout(timer);
  }, [onClose]);

  return (
    <div
      style={{
        position: "fixed",
        bottom: "24px",
        right: "24px",
        background: "var(--bgColor-muted)",
        border: "1px solid var(--borderColor-default)",
        borderRadius: "8px",
        padding: "12px",
        minWidth: "320px",
        gap: "12px",
        color: "var(--fgColor-default)",
        fontSize: "0.875rem",
        zIndex: 1000,
        boxShadow: "0 4px 12px rgba(0,0,0,0.15)",
      }}
    >
      {message}
    </div>
  );
}

// Loading Skeleton
function ProfileSkeleton() {
  return (
    <div style={{ maxWidth: "100%" }}>
      <div style={{ marginBottom: "32px" }}>
        <div
          style={{
            width: "200px",
            height: "32px",
            background: "var(--bgColor-muted)",
            borderRadius: "4px",
            marginBottom: "8px",
          }}
        />
        <div
          style={{
            width: "300px",
            height: "16px",
            background: "var(--bgColor-muted)",
            borderRadius: "4px",
          }}
        />
      </div>
      {[1, 2, 3, 4].map((i) => (
        <div
          key={i}
          style={{
            background: "var(--bgColor-mild)",
            border: "1px solid var(--borderColor-default)",
            borderRadius: "4px",
            height: "200px",
            marginBottom: "24px",
          }}
        />
      ))}
    </div>
  );
}

export default function ProfilePage() {
  const router = useRouter();
  const [isMentor, setIsMentor] = useState<boolean | null>(null);
  const [profile, setProfile] = useState<ProfileData | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [toast, setToast] = useState<string | null>(null);

  // Edit states
  const [editingPersonal, setEditingPersonal] = useState(false);
  const [editingLinks, setEditingLinks] = useState(false);

  // Mentor edit states
  const [editingAbout, setEditingAbout] = useState(false);
  const [editingLanguages, setEditingLanguages] = useState(false);
  const [editingOccupation, setEditingOccupation] = useState(false);
  const [editingExpertise, setEditingExpertise] = useState(false);
  const [editingAddress, setEditingAddress] = useState(false);
  const [editingSkills, setEditingSkills] = useState(false);
  const [editingMentorLinks, setEditingMentorLinks] = useState(false);
  const [showingServices, setShowingServices] = useState(false);
  const [activeServicesTab, setActiveServicesTab] = useState<"availability" | "services">("availability");

  // Form states
  const [personalForm, setPersonalForm] = useState({
    displayName: "",
    phone: "",
    timezone: "",
  });

  const [linksForm, setLinksForm] = useState({
    githubUrl: "",
    linkedinUrl: "",
    websiteUrl: "",
    bio: "",
    skills: [] as string[],
  });

  const [newSkill, setNewSkill] = useState("");

  // Mentor form states
  const [aboutForm, setAboutForm] = useState({
    headline: "",
    mentorBio: "",
  });
  const [languagesForm, setLanguagesForm] = useState<string[]>([]);
  const [newLanguage, setNewLanguage] = useState("");
  const [occupationForm, setOccupationForm] = useState({
    company: "",
    professionalRole: "",
    experienceYears: "",
  });
  const [expertiseForm, setExpertiseForm] = useState<string[]>([]);
  const [newExpertise, setNewExpertise] = useState("");
  const [addressForm, setAddressForm] = useState({
    city: "",
    country: "",
  });
  const [skillsForm, setSkillsForm] = useState<string[]>([]);
  const [newMentorSkill, setNewMentorSkill] = useState("");
  const [mentorLinksForm, setMentorLinksForm] = useState({
    xUrl: "",
    substackUrl: "",
    githubUrl: "",
    linkedinUrl: "",
    websiteUrl: "",
  });

  // Fetch profile on mount
  useEffect(() => {
    async function loadProfile() {
      // Check if user is a mentor
      const me = await getMe();
      const mentor = me?.roles?.includes("mentor") ?? false;
      setIsMentor(mentor);

      const data = await getUserProfile();
      if (data) {
        setProfile(data);
        setPersonalForm({
          displayName: data.displayName || "",
          phone: data.phone || "",
          timezone: data.timezone || "",
        });
        setLinksForm({
          githubUrl: data.githubUrl || "",
          linkedinUrl: data.linkedinUrl || "",
          websiteUrl: data.websiteUrl || "",
          bio: data.bio || "",
          skills: data.skills || [],
        });

        // Initialize mentor forms
        if (mentor) {
          setAboutForm({
            headline: data.headline || "",
            mentorBio: data.mentorBio || "",
          });
          setLanguagesForm(data.languages || []);
          setOccupationForm({
            company: data.company || "",
            professionalRole: data.professionalRole || "",
            experienceYears: data.mentorExperienceYears?.toString() || "",
          });
          setExpertiseForm(data.expertiseAreas || []);
          setAddressForm({
            city: data.city || "",
            country: data.mentorCountry || "",
          });
          setSkillsForm(data.skills || []);
          setMentorLinksForm({
            xUrl: data.xUrl || "",
            substackUrl: data.substackUrl || "",
            githubUrl: data.githubUrl || "",
            linkedinUrl: data.linkedinUrl || "",
            websiteUrl: data.websiteUrl || "",
          });
        }
      }
      setLoading(false);
    }
    loadProfile();
  }, []);

  // Save handlers
  const handleSavePersonal = async () => {
    if (!profile) return;
    setSaving(true);
    const updates: Partial<EditableProfileData> = {};
    if (personalForm.displayName !== (profile.displayName || "")) {
      updates.displayName = personalForm.displayName || undefined;
    }
    if (personalForm.phone !== (profile.phone || "")) {
      updates.phone = personalForm.phone || undefined;
    }
    if (personalForm.timezone !== (profile.timezone || "")) {
      updates.timezone = personalForm.timezone || undefined;
    }

    const updated = await updateUserProfile(updates);
    if (updated) {
      setProfile(updated);
      setEditingPersonal(false);
      setToast("Profile updated");
    }
    setSaving(false);
  };

  const handleCancelPersonal = () => {
    if (!profile) return;
    setPersonalForm({
      displayName: profile.displayName || "",
      phone: profile.phone || "",
      timezone: profile.timezone || "",
    });
    setEditingPersonal(false);
  };

  const handleSaveLinks = async () => {
    if (!profile) return;
    setSaving(true);
    const updates: Partial<EditableProfileData> = {};
    if (linksForm.githubUrl !== (profile.githubUrl || "")) {
      updates.githubUrl = linksForm.githubUrl || undefined;
    }
    if (linksForm.linkedinUrl !== (profile.linkedinUrl || "")) {
      updates.linkedinUrl = linksForm.linkedinUrl || undefined;
    }
    if (linksForm.websiteUrl !== (profile.websiteUrl || "")) {
      updates.websiteUrl = linksForm.websiteUrl || undefined;
    }
    if (linksForm.bio !== (profile.bio || "")) {
      updates.bio = linksForm.bio || undefined;
    }
    if (JSON.stringify(linksForm.skills) !== JSON.stringify(profile.skills || [])) {
      updates.skills = linksForm.skills;
    }

    const updated = await updateUserProfile(updates);
    if (updated) {
      setProfile(updated);
      setEditingLinks(false);
      setToast("Profile updated");
    }
    setSaving(false);
  };

  const handleCancelLinks = () => {
    if (!profile) return;
    setLinksForm({
      githubUrl: profile.githubUrl || "",
      linkedinUrl: profile.linkedinUrl || "",
      websiteUrl: profile.websiteUrl || "",
      bio: profile.bio || "",
      skills: profile.skills || [],
    });
    setEditingLinks(false);
  };

  // Skills handlers
  const addSkill = () => {
    if (newSkill.trim() && !linksForm.skills.includes(newSkill.trim())) {
      setLinksForm((prev) => ({
        ...prev,
        skills: [...prev.skills, newSkill.trim()],
      }));
      setNewSkill("");
    }
  };

  const removeSkill = (skill: string) => {
    setLinksForm((prev) => ({
      ...prev,
      skills: prev.skills.filter((s) => s !== skill),
    }));
  };

  // Word count helper
  const wordCount = (text: string): number => {
    return text.trim() ? text.trim().split(/\s+/).length : 0;
  };

  // ── Mentor save handlers ──
  const handleSaveAbout = async () => {
    if (!profile) return;
    setSaving(true);
    const updates: Partial<EditableMentorProfileData> = {};
    if (aboutForm.headline !== (profile.headline || "")) {
      updates.headline = aboutForm.headline || undefined;
    }
    if (aboutForm.mentorBio !== (profile.mentorBio || "")) {
      updates.mentorBio = aboutForm.mentorBio || undefined;
    }
    const updated = await updateMentorProfile(updates);
    if (updated) {
      setProfile(updated);
      setEditingAbout(false);
      setToast("Profile updated");
    }
    setSaving(false);
  };

  const handleCancelAbout = () => {
    if (!profile) return;
    setAboutForm({
      headline: profile.headline || "",
      mentorBio: profile.mentorBio || "",
    });
    setEditingAbout(false);
  };

  const handleSaveLanguages = async () => {
    if (!profile) return;
    setSaving(true);
    const updated = await updateMentorProfile({ languages: languagesForm });
    if (updated) {
      setProfile(updated);
      setEditingLanguages(false);
      setToast("Profile updated");
    }
    setSaving(false);
  };

  const handleCancelLanguages = () => {
    if (!profile) return;
    setLanguagesForm(profile.languages || []);
    setEditingLanguages(false);
  };

  const handleSaveOccupation = async () => {
    if (!profile) return;
    setSaving(true);
    const updates: Partial<EditableMentorProfileData> = {};
    if (occupationForm.company !== (profile.company || "")) {
      updates.company = occupationForm.company || undefined;
    }
    if (occupationForm.professionalRole !== (profile.professionalRole || "")) {
      updates.professionalRole = occupationForm.professionalRole || undefined;
    }
    const expYears = occupationForm.experienceYears ? parseInt(occupationForm.experienceYears, 10) : undefined;
    if (expYears !== (profile.mentorExperienceYears ?? undefined)) {
      updates.experienceYears = expYears;
    }
    if (Object.keys(updates).length > 0) {
      const updated = await updateMentorProfile(updates);
      if (updated) {
        setProfile(updated);
        setEditingOccupation(false);
        setToast("Profile updated");
      }
    } else {
      setEditingOccupation(false);
    }
    setSaving(false);
  };

  const handleCancelOccupation = () => {
    if (!profile) return;
    setOccupationForm({
      company: profile.company || "",
      professionalRole: profile.professionalRole || "",
      experienceYears: profile.mentorExperienceYears?.toString() || "",
    });
    setEditingOccupation(false);
  };

  const handleSaveExpertise = async () => {
    if (!profile) return;
    setSaving(true);
    const updated = await updateMentorProfile({ expertiseAreas: expertiseForm });
    if (updated) {
      setProfile(updated);
      setEditingExpertise(false);
      setToast("Profile updated");
    }
    setSaving(false);
  };

  const handleCancelExpertise = () => {
    if (!profile) return;
    setExpertiseForm(profile.expertiseAreas || []);
    setEditingExpertise(false);
  };

  const handleSaveAddress = async () => {
    if (!profile) return;
    setSaving(true);
    const updates: Partial<EditableMentorProfileData> = {};
    if (addressForm.city !== (profile.city || "")) {
      updates.city = addressForm.city || undefined;
    }
    if (addressForm.country !== (profile.mentorCountry || "")) {
      updates.country = addressForm.country || undefined;
    }
    const updated = await updateMentorProfile(updates);
    if (updated) {
      setProfile(updated);
      setEditingAddress(false);
      setToast("Profile updated");
    }
    setSaving(false);
  };

  const handleCancelAddress = () => {
    if (!profile) return;
    setAddressForm({
      city: profile.city || "",
      country: profile.mentorCountry || "",
    });
    setEditingAddress(false);
  };

  const handleSaveSkills = async () => {
    if (!profile) return;
    setSaving(true);
    const updated = await updateUserProfile({ skills: skillsForm });
    if (updated) {
      setProfile(updated);
      setEditingSkills(false);
      setToast("Profile updated");
    }
    setSaving(false);
  };

  const handleCancelSkills = () => {
    if (!profile) return;
    setSkillsForm(profile.skills || []);
    setEditingSkills(false);
  };

  const handleSaveMentorLinks = async () => {
    if (!profile) return;
    setSaving(true);
    const profileUpdates: Partial<EditableProfileData> = {};
    if (mentorLinksForm.xUrl !== (profile.xUrl || "")) {
      profileUpdates.xUrl = mentorLinksForm.xUrl || undefined;
    }
    if (mentorLinksForm.substackUrl !== (profile.substackUrl || "")) {
      profileUpdates.substackUrl = mentorLinksForm.substackUrl || undefined;
    }
    if (mentorLinksForm.githubUrl !== (profile.githubUrl || "")) {
      profileUpdates.githubUrl = mentorLinksForm.githubUrl || undefined;
    }
    if (mentorLinksForm.linkedinUrl !== (profile.linkedinUrl || "")) {
      profileUpdates.linkedinUrl = mentorLinksForm.linkedinUrl || undefined;
    }
    if (mentorLinksForm.websiteUrl !== (profile.websiteUrl || "")) {
      profileUpdates.websiteUrl = mentorLinksForm.websiteUrl || undefined;
    }
    // Only call if there are actual changes
    if (Object.keys(profileUpdates).length > 0) {
      const updated = await updateUserProfile(profileUpdates);
      if (updated) {
        setProfile(updated);
        setEditingMentorLinks(false);
        setToast("Profile updated");
      }
    } else {
      setEditingMentorLinks(false);
    }
    setSaving(false);
  };

  const handleCancelMentorLinks = () => {
    if (!profile) return;
    setMentorLinksForm({
      xUrl: profile.xUrl || "",
      substackUrl: profile.substackUrl || "",
      githubUrl: profile.githubUrl || "",
      linkedinUrl: profile.linkedinUrl || "",
      websiteUrl: profile.websiteUrl || "",
    });
    setEditingMentorLinks(false);
  };

  // Copy to clipboard
  const copyToClipboard = (text: string) => {
    navigator.clipboard.writeText(text);
    setToast("Copied to clipboard");
  };

  if (loading) {
    return (
      <div style={{ padding: "16px 24px" }}>
        <ProfileSkeleton />
      </div>
    );
  }

  // Mentor role — show mentor-specific profile view
  if (isMentor) {
    if (!profile) {
      return (
        <div style={{ padding: "16px 24px" }}>
          <div style={{ maxWidth: "100%", textAlign: "center", padding: "48px" }}>
            <p style={{ color: "var(--fgColor-muted)" }}>Failed to load profile. Please try again.</p>
            <Button onClick={() => window.location.reload()}>Retry</Button>
          </div>
        </div>
      );
    }

    return (
      <div style={{ padding: "16px 24px" }}>
        <div style={{ maxWidth: "50%" }}>
          {/* Page Header */}
          <h1
            style={{
              fontFamily: "var(--font-outfit), sans-serif",
              fontSize: "2rem",
              fontWeight: 400,
              lineHeight: "2.5rem",
              color: "var(--fgColor-default)",
              letterSpacing: "-0.04em",
              margin: 0,
              marginBottom: "8px",
            }}
          >
            Profile
          </h1>
          <p
            style={{
              fontFamily: "var(--font-outfit), sans-serif",
              fontSize: "0.875rem",
              color: "var(--fgColor-muted)",
              margin: "0 0 24px 0",
              lineHeight: "1.375rem",
            }}
          >
            Manage your mentor profile and account settings
          </p>
        </div>

        {/* Profile Header - full width row with button at far right */}
        <div
          style={{
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
            gap: "16px",
            marginBottom: "24px",
          }}
        >
          <div style={{ display: "flex", alignItems: "center", gap: "16px" }}>
            <div
              style={{
                width: "56px",
                height: "56px",
                borderRadius: "50%",
                background: "var(--bgColor-muted)",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                fontSize: "1.125rem",
                fontWeight: 600,
                color: "var(--fgColor-default)",
                flexShrink: 0,
              }}
            >
              {getInitials(profile.firstName, profile.lastName)}
            </div>
            <div>
              <div style={{ display: "flex", alignItems: "center", gap: "12px", marginBottom: "4px" }}>
                <h2
                  style={{
                    fontSize: "1.125rem",
                    fontWeight: 400,
                    color: "var(--fgColor-default)",
                    fontFamily: "var(--font-outfit), sans-serif",
                    margin: 0,
                  }}
                >
                  {profile.firstName} {profile.lastName}
                </h2>
                <span style={getAuthBadgeStyle(profile.oauthProvider, profile.authType)}>
                  {profile.oauthProvider
                    ? profile.oauthProvider.charAt(0).toUpperCase() + profile.oauthProvider.slice(1)
                    : profile.authType === "institution_local" || profile.authType === "university_sso"
                    ? "SSO"
                    : "Email"}
                </span>
                <span
                  style={{
                    display: "inline-flex",
                    alignItems: "center",
                    padding: "0 8px",
                    borderRadius: "2px",
                    background: "#7C3AED",
                    color: "#fff",
                    fontSize: "0.75rem",
                    fontWeight: 500,
                    height: "22px",
                  }}
                >
                  Mentor
                </span>
              </div>
              <p style={{ margin: "0 0 2px 0", color: "var(--fgColor-muted)", fontSize: "0.875rem", lineHeight: "1.375rem", fontFamily: "var(--font-outfit), sans-serif" }}>
                {profile.email}
              </p>
              <p style={{ margin: 0, color: "var(--fgColor-muted)", fontSize: "0.75rem", fontFamily: "var(--font-outfit), sans-serif" }}>
                Member since {formatDate(profile.createdAt)}
              </p>
            </div>
          </div>
          <button
            onClick={() => setShowingServices(!showingServices)}
            style={{
              background: "none",
              border: "none",
              fontFamily: "var(--font-outfit), sans-serif",
              fontSize: "1.125rem",
              fontWeight: 400,
              color: "var(--fgColor-default)",
              cursor: "pointer",
              padding: 0,
              whiteSpace: "nowrap",
            }}
          >
            <span style={{ borderBottom: showingServices ? "2px solid #C8AA6E" : "1px solid #C8AA6E" }}>
              Manage Your Services →
            </span>
          </button>
        </div>

        {showingServices ? (
          <div style={{ marginTop: "24px" }}>
            {/* Tabs — matching billing page pattern */}
            <div
              style={{
                position: "relative",
                display: "flex",
                alignItems: "center",
                height: "40px",
                borderBottom: "1px solid var(--borderColor-default)",
              }}
            >
              {/* Availability Slots tab */}
              <button
                onClick={() => setActiveServicesTab("availability")}
                style={{
                  position: "relative",
                  cursor: "pointer",
                  flexShrink: 0,
                  whiteSpace: "nowrap",
                  height: "40px",
                  background: "transparent",
                  border: "none",
                  padding: "0 0 12px 0",
                  marginBottom: "-1px",
                  marginRight: "24px",
                }}
              >
                <span
                  style={{
                    fontFamily: "var(--font-outfit), sans-serif",
                    fontSize: "1rem",
                    fontWeight: activeServicesTab === "availability" ? 600 : 400,
                    lineHeight: "1.5rem",
                    display: "block",
                    color: activeServicesTab === "availability"
                      ? "var(--fgColor-default)"
                      : "var(--fgColor-muted)",
                    transition: "color 0.15s ease",
                  }}
                >
                  Availability Slots
                </span>
                {activeServicesTab === "availability" && (
                  <span
                    style={{
                      position: "absolute",
                      zIndex: 1,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: "2px",
                      backgroundColor: "#C8AA6E",
                      transition: "all 0.2s ease",
                    }}
                  />
                )}
              </button>

              {/* Services tab — inactive dummy */}
              <span
                style={{
                  position: "relative",
                  flexShrink: 0,
                  whiteSpace: "nowrap",
                  height: "40px",
                  background: "transparent",
                  border: "none",
                  padding: "0 0 12px 0",
                  marginBottom: "-1px",
                  cursor: "not-allowed",
                  opacity: 0.45,
                }}
              >
                <span
                  style={{
                    fontFamily: "var(--font-outfit), sans-serif",
                    fontSize: "1rem",
                    fontWeight: 400,
                    lineHeight: "1.5rem",
                    display: "block",
                    color: "var(--fgColor-muted)",
                  }}
                >
                  Services
                </span>
              </span>
            </div>

            {/* Tab content */}
            <div style={{ marginTop: "24px" }}>
              {activeServicesTab === "availability" && (
                <AvailabilityManager />
              )}
            </div>
          </div>
        ) : (
          <>
        {/* Personal Information || About (with Languages) — side by side */}
        <div style={{ display: "flex", gap: "24px", marginTop: "24px" }}>
          <div style={{ flex: 1, minWidth: 0 }}>
            <SectionCard
              title="Personal Information"
              action={
                editingPersonal ? (
                  <div style={{ display: "flex", gap: "8px" }}>
                    <Button variant="ghost" size="compact" onClick={handleCancelPersonal} disabled={saving}>
                      Cancel
                    </Button>
                    <Button size="compact" onClick={handleSavePersonal} disabled={saving}>
                      {saving ? "Saving..." : "Save"}
                    </Button>
                  </div>
                ) : (
                  <Button variant="primary" size="compact" onClick={() => setEditingPersonal(true)}>
                    Edit
                  </Button>
                )
              }
            >
              <InfoRow
                label="Name"
                value={`${profile.firstName} ${profile.lastName}`}
                isLast={false}
              />
              <InfoRow
                label="Display Name"
                value={profile.displayName || "Not set"}
                isEditing={editingPersonal}
                editComponent={
                  <TextInput
                    value={personalForm.displayName}
                    onChange={(v) => setPersonalForm((p) => ({ ...p, displayName: v }))}
                    placeholder="Enter display name"
                  />
                }
                isLast={false}
              />
              <InfoRow
                label="Email"
                value={
                  <span style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                    {profile.email}
                    <span
                      style={{
                        display: "inline-flex",
                        alignItems: "center",
                        padding: "0 8px",
                        borderRadius: "2px",
                        background: "#10B981",
                        color: "#fff",
                        fontSize: "0.75rem",
                        height: "22px",
                      }}
                    >
                      Verified
                    </span>
                  </span>
                }
                isLast={false}
              />
              <InfoRow
                label="Phone"
                value={profile.phone || "Not set"}
                isEditing={editingPersonal}
                editComponent={
                  <TextInput
                    value={personalForm.phone}
                    onChange={(v) => setPersonalForm((p) => ({ ...p, phone: v }))}
                    placeholder="Enter phone number"
                  />
                }
                isLast={false}
              />
              <InfoRow
                label="Timezone"
                value={profile.timezone || "Not set"}
                isEditing={editingPersonal}
                editComponent={
                  <TextInput
                    value={personalForm.timezone}
                    onChange={(v) => setPersonalForm((p) => ({ ...p, timezone: v }))}
                    placeholder="e.g., Asia/Kolkata"
                  />
                }
                isLast={true}
              />
            </SectionCard>
          </div>

          <div style={{ flex: 1, minWidth: 0 }}>
            <SectionCard
              title="About"
              action={
                editingAbout || editingLanguages ? (
                  <div style={{ display: "flex", gap: "8px" }}>
                    <Button variant="ghost" size="compact" onClick={() => { handleCancelAbout(); handleCancelLanguages(); }} disabled={saving}>
                      Cancel
                    </Button>
                    <Button size="compact" onClick={async () => {
                      if (editingAbout) await handleSaveAbout();
                      if (editingLanguages) await handleSaveLanguages();
                    }} disabled={saving || wordCount(aboutForm.mentorBio) > 250}>
                      {saving ? "Saving..." : "Save"}
                    </Button>
                  </div>
                ) : (
                  <div style={{ display: "flex", gap: "4px" }}>
                    <Button variant="primary" size="compact" onClick={() => { setEditingAbout(true); setEditingLanguages(true); }}>
                      Edit
                    </Button>
                  </div>
                )
              }
            >
              <InfoRow
                label="Headline"
                value={profile.headline || "Not set"}
                isEditing={editingAbout}
                editComponent={
                  <TextInput
                    value={aboutForm.headline}
                    onChange={(v) => setAboutForm((p) => ({ ...p, headline: v }))}
                    placeholder="e.g., Senior ML Engineer & Mentor"
                  />
                }
                isLast={false}
              />
              <InfoRow
                label="Bio"
                value={
                  profile.mentorBio ? (
                    <span style={{ whiteSpace: "pre-wrap" }}>{profile.mentorBio}</span>
                  ) : (
                    "Not set"
                  )
                }
                isEditing={editingAbout}
                editComponent={
                  <div>
                    <TextArea
                      value={aboutForm.mentorBio}
                      onChange={(v) => setAboutForm((p) => ({ ...p, mentorBio: v }))}
                      placeholder="Tell potential mentees about yourself, your experience, and what you can help with"
                      rows={5}
                    />
                    <div
                      style={{
                        fontSize: "0.75rem",
                        color: wordCount(aboutForm.mentorBio) > 250 ? "#EF4444" : "var(--fgColor-muted)",
                        marginTop: "4px",
                        fontFamily: "var(--font-outfit), sans-serif",
                      }}
                    >
                      {wordCount(aboutForm.mentorBio)} / 250 words
                      {wordCount(aboutForm.mentorBio) > 250 && " (max exceeded)"}
                    </div>
                  </div>
                }
                isLast={false}
              />
              <InfoRow
                label="Languages"
                value={
                  languagesForm.length > 0 ? (
                    <div style={{ display: "flex", flexWrap: "wrap", gap: "8px" }}>
                      {languagesForm.map((lang) => (
                        <PillTag key={lang} label={lang} />
                      ))}
                    </div>
                  ) : (
                    "Not set"
                  )
                }
                isEditing={editingLanguages}
                editComponent={
                  <div>
                    <div style={{ display: "flex", flexWrap: "wrap", gap: "8px", marginBottom: "12px" }}>
                      {languagesForm.map((lang) => (
                        <span
                          key={lang}
                          style={{
                            display: "inline-flex",
                            alignItems: "center",
                            gap: "6px",
                            padding: "0 8px",
                            borderRadius: "2px",
                            background: "var(--bgColor-muted)",
                            fontSize: "0.75rem",
                            fontWeight: 500,
                            height: "22px",
                          }}
                        >
                          {lang}
                          <button
                            onClick={() => setLanguagesForm((prev) => prev.filter((l) => l !== lang))}
                            style={{
                              background: "none",
                              border: "none",
                              cursor: "pointer",
                              padding: 0,
                              color: "var(--fgColor-muted)",
                              fontSize: "0.75rem",
                            }}
                          >
                            ×
                          </button>
                        </span>
                      ))}
                    </div>
                    <div style={{ display: "flex", gap: "8px" }}>
                      <TextInput
                        value={newLanguage}
                        onChange={setNewLanguage}
                        placeholder="Add a language"
                      />
                      <Button
                        onClick={() => {
                          if (newLanguage.trim() && !languagesForm.includes(newLanguage.trim())) {
                            setLanguagesForm((prev) => [...prev, newLanguage.trim()]);
                            setNewLanguage("");
                          }
                        }}
                      >
                        Add
                      </Button>
                    </div>
                  </div>
                }
                isLast={true}
              />
            </SectionCard>
          </div>
        </div>

        {/* Occupation || Expertise Domains — side by side */}
        <div style={{ display: "flex", gap: "24px", marginTop: "24px" }}>
          <div style={{ flex: 1, minWidth: 0 }}>
            <SectionCard
              title="Occupation"
              action={
                editingOccupation ? (
                  <div style={{ display: "flex", gap: "8px" }}>
                    <Button variant="ghost" size="compact" onClick={handleCancelOccupation} disabled={saving}>
                      Cancel
                    </Button>
                    <Button size="compact" onClick={handleSaveOccupation} disabled={saving}>
                      {saving ? "Saving..." : "Save"}
                    </Button>
                  </div>
                ) : (
                  <Button variant="primary" size="compact" onClick={() => setEditingOccupation(true)}>
                    Edit
                  </Button>
                )
              }
            >
              <InfoRow
                label="Company"
                value={profile.company || "Not set"}
                isEditing={editingOccupation}
                editComponent={
                  <TextInput
                    value={occupationForm.company}
                    onChange={(v) => setOccupationForm((p) => ({ ...p, company: v }))}
                    placeholder="e.g., Google"
                  />
                }
                isLast={false}
              />
              <InfoRow
                label="Role"
                value={profile.professionalRole || "Not set"}
                isEditing={editingOccupation}
                editComponent={
                  <TextInput
                    value={occupationForm.professionalRole}
                    onChange={(v) => setOccupationForm((p) => ({ ...p, professionalRole: v }))}
                    placeholder="e.g., Senior ML Engineer"
                  />
                }
                isLast={false}
              />
              <InfoRow
                label="Experience"
                value={profile.mentorExperienceYears != null ? `${profile.mentorExperienceYears} years` : "Not set"}
                isEditing={editingOccupation}
                editComponent={
                  <TextInput
                    type="number"
                    value={occupationForm.experienceYears}
                    onChange={(v) => setOccupationForm((p) => ({ ...p, experienceYears: v }))}
                    placeholder="e.g., 5"
                  />
                }
                isLast={true}
              />
            </SectionCard>
            <div style={{ marginTop: "24px" }}>
              <SectionCard
                title="Links"
                action={
                  editingMentorLinks ? (
                    <div style={{ display: "flex", gap: "8px" }}>
                      <Button variant="ghost" size="compact" onClick={handleCancelMentorLinks} disabled={saving}>
                        Cancel
                      </Button>
                      <Button size="compact" onClick={handleSaveMentorLinks} disabled={saving}>
                        {saving ? "Saving..." : "Save"}
                      </Button>
                    </div>
                  ) : (
                    <Button variant="primary" size="compact" onClick={() => setEditingMentorLinks(true)}>
                      Edit
                    </Button>
                  )
                }
              >
                <InfoRow
                  label="X (Twitter)"
                  value={
                    profile.xUrl ? (
                      <a
                        href={profile.xUrl}
                        target="_blank"
                        rel="noopener noreferrer"
                        style={{ color: "var(--fgColor-default)", textDecoration: "underline" }}
                      >
                        {profile.xUrl}
                      </a>
                    ) : (
                      "Not set"
                    )
                  }
                  isEditing={editingMentorLinks}
                  editComponent={
                    <TextInput
                      value={mentorLinksForm.xUrl}
                      onChange={(v) => setMentorLinksForm((p) => ({ ...p, xUrl: v }))}
                      placeholder="https://x.com/username"
                    />
                  }
                  isLast={false}
                />
                <InfoRow
                  label="Substack"
                  value={
                    profile.substackUrl ? (
                      <a
                        href={profile.substackUrl}
                        target="_blank"
                        rel="noopener noreferrer"
                        style={{ color: "var(--fgColor-default)", textDecoration: "underline" }}
                      >
                        {profile.substackUrl}
                      </a>
                    ) : (
                      "Not set"
                    )
                  }
                  isEditing={editingMentorLinks}
                  editComponent={
                    <TextInput
                      value={mentorLinksForm.substackUrl}
                      onChange={(v) => setMentorLinksForm((p) => ({ ...p, substackUrl: v }))}
                      placeholder="https://substack.com/@username"
                    />
                  }
                  isLast={false}
                />
                <InfoRow
                  label="GitHub"
                  value={
                    profile.githubUrl ? (
                      <a
                        href={profile.githubUrl}
                        target="_blank"
                        rel="noopener noreferrer"
                        style={{ color: "var(--fgColor-default)", textDecoration: "underline" }}
                      >
                        {profile.githubUrl}
                      </a>
                    ) : (
                      "Not set"
                    )
                  }
                  isEditing={editingMentorLinks}
                  editComponent={
                    <TextInput
                      value={mentorLinksForm.githubUrl}
                      onChange={(v) => setMentorLinksForm((p) => ({ ...p, githubUrl: v }))}
                      placeholder="https://github.com/username"
                    />
                  }
                  isLast={false}
                />
                <InfoRow
                  label="LinkedIn"
                  value={
                    profile.linkedinUrl ? (
                      <a
                        href={profile.linkedinUrl}
                        target="_blank"
                        rel="noopener noreferrer"
                        style={{ color: "var(--fgColor-default)", textDecoration: "underline" }}
                      >
                        {profile.linkedinUrl}
                      </a>
                    ) : (
                      "Not set"
                    )
                  }
                  isEditing={editingMentorLinks}
                  editComponent={
                    <TextInput
                      value={mentorLinksForm.linkedinUrl}
                      onChange={(v) => setMentorLinksForm((p) => ({ ...p, linkedinUrl: v }))}
                      placeholder="https://linkedin.com/in/username"
                    />
                  }
                  isLast={false}
                />
                <InfoRow
                  label="Website"
                  value={
                    profile.websiteUrl ? (
                      <a
                        href={profile.websiteUrl}
                        target="_blank"
                        rel="noopener noreferrer"
                        style={{ color: "var(--fgColor-default)", textDecoration: "underline" }}
                      >
                        {profile.websiteUrl}
                      </a>
                    ) : (
                      "Not set"
                    )
                  }
                  isEditing={editingMentorLinks}
                  editComponent={
                    <TextInput
                      value={mentorLinksForm.websiteUrl}
                      onChange={(v) => setMentorLinksForm((p) => ({ ...p, websiteUrl: v }))}
                      placeholder="https://yourwebsite.com"
                    />
                  }
                  isLast={true}
                />
              </SectionCard>
            </div>
          </div>

          <div style={{ flex: 1, minWidth: 0 }}>
            <SectionCard
              title="Expertise Domains"
              action={
                editingExpertise ? (
                  <div style={{ display: "flex", gap: "8px" }}>
                    <Button variant="ghost" size="compact" onClick={handleCancelExpertise} disabled={saving}>
                      Cancel
                    </Button>
                    <Button size="compact" onClick={handleSaveExpertise} disabled={saving}>
                      {saving ? "Saving..." : "Save"}
                    </Button>
                  </div>
                ) : (
                  <Button variant="primary" size="compact" onClick={() => setEditingExpertise(true)}>
                    Edit
                  </Button>
                )
              }
            >
              <InfoRow
                label="Domains"
                value={
                  expertiseForm.length > 0 ? (
                    <div style={{ display: "flex", flexWrap: "wrap", gap: "8px" }}>
                      {expertiseForm.map((domain) => (
                        <PillTag key={domain} label={domain} />
                      ))}
                    </div>
                  ) : (
                    "Not set"
                  )
                }
                isEditing={editingExpertise}
                editComponent={
                  <div>
                    <div style={{ display: "flex", flexWrap: "wrap", gap: "8px", marginBottom: "12px" }}>
                      {expertiseForm.map((domain) => (
                        <span
                          key={domain}
                          style={{
                            display: "inline-flex",
                            alignItems: "center",
                            gap: "6px",
                            padding: "0 8px",
                            borderRadius: "2px",
                            background: "var(--bgColor-muted)",
                            fontSize: "0.75rem",
                            fontWeight: 500,
                            height: "22px",
                          }}
                        >
                          {domain}
                          <button
                            onClick={() => setExpertiseForm((prev) => prev.filter((d) => d !== domain))}
                            style={{
                              background: "none",
                              border: "none",
                              cursor: "pointer",
                              padding: 0,
                              color: "var(--fgColor-muted)",
                              fontSize: "0.75rem",
                            }}
                          >
                            ×
                          </button>
                        </span>
                      ))}
                    </div>
                    <div style={{ display: "flex", gap: "8px" }}>
                      <TextInput
                        value={newExpertise}
                        onChange={setNewExpertise}
                        placeholder="Add a domain"
                      />
                      <Button
                        onClick={() => {
                          if (newExpertise.trim() && !expertiseForm.includes(newExpertise.trim())) {
                            setExpertiseForm((prev) => [...prev, newExpertise.trim()]);
                            setNewExpertise("");
                          }
                        }}
                      >
                        Add
                      </Button>
                    </div>
                  </div>
                }
                isLast={true}
              />
            </SectionCard>
            <div style={{ marginTop: "8px" }}>
              <SectionCard
                title="Skills"
                action={
                  editingSkills ? (
                    <div style={{ display: "flex", gap: "8px" }}>
                      <Button variant="ghost" size="compact" onClick={handleCancelSkills} disabled={saving}>
                        Cancel
                      </Button>
                      <Button size="compact" onClick={handleSaveSkills} disabled={saving}>
                        {saving ? "Saving..." : "Save"}
                      </Button>
                    </div>
                  ) : (
                    <Button variant="primary" size="compact" onClick={() => setEditingSkills(true)}>
                      Edit
                    </Button>
                  )
                }
              >
                <InfoRow
                  label="Skills"
                  value={
                    skillsForm.length > 0 ? (
                      <div style={{ display: "flex", flexWrap: "wrap", gap: "8px" }}>
                        {skillsForm.map((skill) => (
                          <PillTag key={skill} label={skill} />
                        ))}
                      </div>
                    ) : (
                      "Not set"
                    )
                  }
                  isEditing={editingSkills}
                  editComponent={
                    <div>
                      <div style={{ display: "flex", flexWrap: "wrap", gap: "8px", marginBottom: "12px" }}>
                        {skillsForm.map((skill) => (
                          <span
                            key={skill}
                            style={{
                              display: "inline-flex",
                              alignItems: "center",
                              gap: "6px",
                              padding: "0 8px",
                              borderRadius: "2px",
                              background: "var(--bgColor-muted)",
                              fontSize: "0.75rem",
                              fontWeight: 500,
                              height: "22px",
                            }}
                          >
                            {skill}
                            <button
                              onClick={() => setSkillsForm((prev) => prev.filter((s) => s !== skill))}
                              style={{
                                background: "none",
                                border: "none",
                                cursor: "pointer",
                                padding: 0,
                                color: "var(--fgColor-muted)",
                                fontSize: "0.75rem",
                              }}
                            >
                              ×
                            </button>
                          </span>
                        ))}
                      </div>
                      <div style={{ display: "flex", gap: "8px" }}>
                        <TextInput
                          value={newMentorSkill}
                          onChange={setNewMentorSkill}
                          placeholder="Add a skill"
                        />
                        <Button
                          onClick={() => {
                            if (newMentorSkill.trim() && !skillsForm.includes(newMentorSkill.trim())) {
                              setSkillsForm((prev) => [...prev, newMentorSkill.trim()]);
                              setNewMentorSkill("");
                            }
                          }}
                        >
                          Add
                        </Button>
                      </div>
                    </div>
                  }
                  isLast={true}
                />
              </SectionCard>
            </div>
          </div>
        </div>

        {/* Account & Security || Billing Summary — side by side */}
        <div style={{ display: "flex", gap: "24px", marginTop: "24px" }}>
          <div style={{ flex: 1, minWidth: 0 }}>
            <SectionCard title="Account & Security">
              <InfoRow
                label="Account ID"
                value={
                  <span style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                    <code
                      style={{
                        fontFamily: '"Suisse Intl Mono", ui-monospace, monospace',
                        fontSize: "0.875rem",
                        background: "var(--bgColor-muted)",
                        padding: "4px 8px",
                        borderRadius: "4px",
                      }}
                    >
                      {profile.id}
                    </code>
                    <button
                      onClick={() => copyToClipboard(profile.id)}
                      style={{
                        background: "none",
                        border: "none",
                        cursor: "pointer",
                        color: "var(--fgColor-muted)",
                        fontSize: "0.75rem",
                      }}
                    >
                      Copy
                    </button>
                  </span>
                }
                isLast={false}
              />
              <InfoRow
                label="Auth Method"
                value={getAuthMethodDisplay(profile)}
                isLast={false}
              />
              <InfoRow
                label="Two-Factor Auth"
                value={
                  profile.twoFactorEnabled ? (
                    <span style={{ color: "#10B981" }}>Enabled</span>
                  ) : (
                    <span style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                      Not enabled
                      <span style={{ color: "var(--fgColor-muted)", fontSize: "0.75rem" }}>
                        Setup MFA
                      </span>
                    </span>
                  )
                }
                isLast={false}
              />
              <InfoRow
                label="Last Login"
                value={formatDate(profile.lastLoginAt)}
                isLast={true}
              />
            </SectionCard>
          </div>

          <div style={{ flex: 1, minWidth: 0 }}>
            <SectionCard title="Billing Summary" accent>
              <InfoRow
                label="Current Balance"
                value={
                  <span style={{ fontSize: "1.125rem", fontWeight: 400 }}>
                    {formatCurrency(profile.balanceCents, profile.currency)}
                  </span>
                }
                isLast={false}
              />
              <InfoRow
                label="Lifetime Spent"
                value={formatCurrency(profile.lifetimeSpentCents, profile.currency)}
                isLast={false}
              />
              <InfoRow
                label=""
                value={
                  <button
                    onClick={() => router.push("/billing")}
                    style={{
                      background: "none",
                      border: "none",
                      color: "var(--fgColor-default)",
                      textDecoration: "underline",
                      fontSize: "0.875rem",
                      fontFamily: "var(--font-outfit), sans-serif",
                      cursor: "pointer",
                      padding: 0,
                    }}
                  >
                    View full billing →
                  </button>
                }
                isLast={true}
              />
            </SectionCard>
          </div>
        </div>
          </>
        )}

        {/* Toast */}
        {toast && <Toast message={toast} onClose={() => setToast(null)} />}
      </div>
    );
  }

  if (!profile) {
    return (
      <div style={{ padding: "16px 24px" }}>
        <div style={{ maxWidth: "100%", textAlign: "center", padding: "48px" }}>
          <p style={{ color: "var(--fgColor-muted)" }}>Failed to load profile. Please try again.</p>
          <Button onClick={() => window.location.reload()}>Retry</Button>
        </div>
      </div>
    );
  }

  const isStudent = profile.authType === "institution_local" || profile.authType === "university_sso";

  return (
    <div style={{ padding: "16px 24px" }}>
      <div style={{ maxWidth: "50%" }}>
        {/* Page Header */}
        <h1
          style={{
            fontFamily: "var(--font-outfit), sans-serif",
            fontSize: "2rem",
            fontWeight: 400,
            lineHeight: "2.5rem",
            color: "var(--fgColor-default)",
            letterSpacing: "-0.04em",
            margin: 0,
            marginBottom: "8px",
          }}
        >
          Profile
        </h1>
        <p
          style={{
            fontFamily: "var(--font-outfit), sans-serif",
            fontSize: "0.875rem",
            color: "var(--fgColor-muted)",
            margin: "0 0 24px 0",
            lineHeight: "1.375rem",
          }}
        >
          Manage your account settings and profile information
        </p>

        {/* Profile Header */}
        <div
          style={{
            display: "flex",
            alignItems: "center",
            gap: "16px",
            marginBottom: "24px",
          }}
        >
          {/* Avatar */}
          <div
            style={{
              width: "56px",
              height: "56px",
              borderRadius: "50%",
              background: "var(--bgColor-muted)",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              fontSize: "1.125rem",
              fontWeight: 600,
              color: "var(--fgColor-default)",
              flexShrink: 0,
            }}
          >
            {getInitials(profile.firstName, profile.lastName)}
          </div>

          {/* Info */}
          <div style={{ flex: 1 }}>
            <div style={{ display: "flex", alignItems: "center", gap: "12px", marginBottom: "4px" }}>
              <h2
                style={{
                  fontSize: "1.125rem",
                  fontWeight: 400,
                  color: "var(--fgColor-default)",
                  fontFamily: "var(--font-outfit), sans-serif",
                  margin: 0,
                }}
              >
                {profile.firstName} {profile.lastName}
              </h2>
              <span style={getAuthBadgeStyle(profile.oauthProvider, profile.authType)}>
                {profile.oauthProvider
                  ? profile.oauthProvider.charAt(0).toUpperCase() + profile.oauthProvider.slice(1)
                  : profile.authType === "institution_local" || profile.authType === "university_sso"
                  ? "SSO"
                  : "Email"}
              </span>
            </div>
            <p style={{ margin: "0 0 2px 0", color: "var(--fgColor-muted)", fontSize: "0.875rem", lineHeight: "1.375rem", fontFamily: "var(--font-outfit), sans-serif" }}>
              {profile.email}
            </p>
            <p style={{ margin: 0, color: "var(--fgColor-muted)", fontSize: "0.75rem", fontFamily: "var(--font-outfit), sans-serif" }}>
              Member since {formatDate(profile.createdAt)}
            </p>
          </div>
        </div>

        {/* Personal Information Section */}
        <SectionCard
          title="Personal Information"
          action={
            editingPersonal ? (
              <div style={{ display: "flex", gap: "8px" }}>
                <Button variant="ghost" size="compact" onClick={handleCancelPersonal} disabled={saving}>
                  Cancel
                </Button>
                <Button size="compact" onClick={handleSavePersonal} disabled={saving}>
                  {saving ? "Saving..." : "Save"}
                </Button>
              </div>
            ) : (
              <Button variant="primary" size="compact" onClick={() => setEditingPersonal(true)}>
                Edit
              </Button>
            )
          }
        >
          <InfoRow
            label="Name"
            value={`${profile.firstName} ${profile.lastName}`}
            isLast={false}
          />
          <InfoRow
            label="Display Name"
            value={profile.displayName || "Not set"}
            isEditing={editingPersonal}
            editComponent={
              <TextInput
                value={personalForm.displayName}
                onChange={(v) => setPersonalForm((p) => ({ ...p, displayName: v }))}
                placeholder="Enter display name"
              />
            }
            isLast={false}
          />
          <InfoRow
            label="Email"
            value={
              <span style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                {profile.email}
                <span
                  style={{
                    display: "inline-flex",
                    alignItems: "center",
                    padding: "0 8px",
                    borderRadius: "2px",
                    background: "#10B981",
                    color: "#fff",
                    fontSize: "0.75rem",
                    height: "22px",
                  }}
                >
                  Verified
                </span>
              </span>
            }
            isLast={false}
          />
          <InfoRow
            label="Phone"
            value={profile.phone || "Not set"}
            isEditing={editingPersonal}
            editComponent={
              <TextInput
                value={personalForm.phone}
                onChange={(v) => setPersonalForm((p) => ({ ...p, phone: v }))}
                placeholder="Enter phone number"
              />
            }
            isLast={false}
          />
          <InfoRow
            label="Timezone"
            value={profile.timezone || "Not set"}
            isEditing={editingPersonal}
            editComponent={
              <TextInput
                value={personalForm.timezone}
                onChange={(v) => setPersonalForm((p) => ({ ...p, timezone: v }))}
                placeholder="e.g., Asia/Kolkata"
              />
            }
            isLast={true}
          />
        </SectionCard>
      </div>

        {/* Professional/Academic Details + Links & Skills — side by side */}
        <div style={{ display: "flex", gap: "24px", marginTop: "24px" }}>
          <div style={{ flex: 1, minWidth: 0 }}>
          <SectionCard title={isStudent ? "Academic Details" : "Professional Details"}>
            {isStudent ? (
              <>
                <InfoRow
                  label="Department"
                  value={profile.departmentName || "Not set"}
                  isLast={false}
                />
                <InfoRow
                  label="Course"
                  value={profile.courseName || "Not set"}
                  isLast={false}
                />
                <InfoRow
                  label="Academic Year"
                  value={profile.academicYear?.toString() || "Not set"}
                  isLast={false}
                />
                <InfoRow
                  label="College"
                  value={profile.collegeName || "Not set"}
                  isLast={false}
                />
              </>
            ) : (
              <>
                <InfoRow
                  label="Profession"
                  value={profile.profession || "Not set"}
                  isLast={false}
                />
                <InfoRow
                  label="Expertise Level"
                  value={profile.expertiseLevel || "Not set"}
                  isLast={false}
                />
                <InfoRow
                  label="Years of Experience"
                  value={profile.yearsOfExperience?.toString() || "Not set"}
                  isLast={false}
                />
              </>
            )}
            <InfoRow
              label="Domains"
              value={
                profile.operationalDomains?.length > 0 ? (
                  <div style={{ display: "flex", flexWrap: "wrap", gap: "8px" }}>
                    {profile.operationalDomains.map((domain) => (
                      <PillTag key={domain} label={domain} />
                    ))}
                  </div>
                ) : (
                  "Not set"
                )
              }
              isLast={false}
            />
            <InfoRow
              label="Use Cases"
              value={
                profile.useCasePurposes?.length > 0 ? (
                  <div style={{ display: "flex", flexWrap: "wrap", gap: "8px" }}>
                    {profile.useCasePurposes.map((useCase) => (
                      <PillTag key={useCase} label={useCase} />
                    ))}
                  </div>
                ) : (
                  "Not set"
                )
              }
              isLast={true}
            />
          </SectionCard>
          </div>

          <div style={{ flex: 1, minWidth: 0 }}>
          <SectionCard
            title="Links & Skills"
            action={
              editingLinks ? (
                <div style={{ display: "flex", gap: "8px" }}>
                  <Button variant="ghost" size="compact" onClick={handleCancelLinks} disabled={saving}>
                    Cancel
                  </Button>
                  <Button size="compact" onClick={handleSaveLinks} disabled={saving}>
                    {saving ? "Saving..." : "Save"}
                  </Button>
                </div>
              ) : (
                <Button variant="primary" size="compact" onClick={() => setEditingLinks(true)}>
                  Edit
                </Button>
              )
            }
          >
            <InfoRow
              label="GitHub"
              value={
                profile.githubUrl ? (
                  <a
                    href={profile.githubUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    style={{ color: "var(--fgColor-default)", textDecoration: "underline" }}
                  >
                    {profile.githubUrl}
                  </a>
                ) : (
                  "Not set"
                )
              }
              isEditing={editingLinks}
              editComponent={
                <TextInput
                  value={linksForm.githubUrl}
                  onChange={(v) => setLinksForm((p) => ({ ...p, githubUrl: v }))}
                  placeholder="https://github.com/username"
                />
              }
              isLast={false}
            />
            <InfoRow
              label="LinkedIn"
              value={
                profile.linkedinUrl ? (
                  <a
                    href={profile.linkedinUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    style={{ color: "var(--fgColor-default)", textDecoration: "underline" }}
                  >
                    {profile.linkedinUrl}
                  </a>
                ) : (
                  "Not set"
                )
              }
              isEditing={editingLinks}
              editComponent={
                <TextInput
                  value={linksForm.linkedinUrl}
                  onChange={(v) => setLinksForm((p) => ({ ...p, linkedinUrl: v }))}
                  placeholder="https://linkedin.com/in/username"
                />
              }
              isLast={false}
            />
            <InfoRow
              label="Website"
              value={
                profile.websiteUrl ? (
                  <a
                    href={profile.websiteUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    style={{ color: "var(--fgColor-default)", textDecoration: "underline" }}
                  >
                    {profile.websiteUrl}
                  </a>
                ) : (
                  "Not set"
                )
              }
              isEditing={editingLinks}
              editComponent={
                <TextInput
                  value={linksForm.websiteUrl}
                  onChange={(v) => setLinksForm((p) => ({ ...p, websiteUrl: v }))}
                  placeholder="https://yourwebsite.com"
                />
              }
              isLast={false}
            />
            <InfoRow
              label="Skills"
              value={
                profile.skills?.length > 0 ? (
                  <div style={{ display: "flex", flexWrap: "wrap", gap: "8px" }}>
                    {profile.skills.map((skill) => (
                      <PillTag key={skill} label={skill} />
                    ))}
                  </div>
                ) : (
                  "Not set"
                )
              }
              isEditing={editingLinks}
              editComponent={
                <div>
                  <div style={{ display: "flex", flexWrap: "wrap", gap: "8px", marginBottom: "12px" }}>
                    {linksForm.skills.map((skill) => (
                      <span
                        key={skill}
                        style={{
                          display: "inline-flex",
                          alignItems: "center",
                          gap: "6px",
                          padding: "0 8px",
                          borderRadius: "2px",
                          background: "var(--bgColor-muted)",
                          fontSize: "0.75rem",
                          fontWeight: 500,
                          height: "22px",
                        }}
                      >
                        {skill}
                        <button
                          onClick={() => removeSkill(skill)}
                          style={{
                            background: "none",
                            border: "none",
                            cursor: "pointer",
                            padding: 0,
                            color: "var(--fgColor-muted)",
                            fontSize: "0.75rem",
                          }}
                        >
                          ×
                        </button>
                      </span>
                    ))}
                  </div>
                  <div style={{ display: "flex", gap: "8px" }}>
                    <TextInput
                      value={newSkill}
                      onChange={setNewSkill}
                      placeholder="Add a skill"
                    />
                    <Button onClick={addSkill}>Add</Button>
                  </div>
                </div>
              }
              isLast={false}
            />
            <InfoRow
              label="Bio"
              value={profile.bio || "Not set"}
              isEditing={editingLinks}
              editComponent={
                <TextArea
                  value={linksForm.bio}
                  onChange={(v) => setLinksForm((p) => ({ ...p, bio: v }))}
                  placeholder="Tell us about yourself"
                  rows={3}
                />
              }
              isLast={true}
            />
          </SectionCard>
          </div>
        </div>

        {/* Account & Security + Billing Summary — side by side */}
        <div style={{ display: "flex", gap: "24px", marginTop: "24px" }}>
          <div style={{ flex: 1, minWidth: 0 }}>
          <SectionCard title="Account & Security">
            <InfoRow
              label="Account ID"
              value={
                <span style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                  <code
                    style={{
                      fontFamily: '"Suisse Intl Mono", ui-monospace, monospace',
                      fontSize: "0.875rem",
                      background: "var(--bgColor-muted)",
                      padding: "4px 8px",
                      borderRadius: "4px",
                    }}
                  >
                    {profile.id}
                  </code>
                  <button
                    onClick={() => copyToClipboard(profile.id)}
                    style={{
                      background: "none",
                      border: "none",
                      cursor: "pointer",
                      color: "var(--fgColor-muted)",
                      fontSize: "0.75rem",
                    }}
                  >
                    Copy
                  </button>
                </span>
              }
              isLast={false}
            />
            <InfoRow
              label="Auth Method"
              value={getAuthMethodDisplay(profile)}
              isLast={false}
            />
            <InfoRow
              label="Two-Factor Auth"
              value={
                profile.twoFactorEnabled ? (
                  <span style={{ color: "#10B981" }}>Enabled</span>
                ) : (
                  <span style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                    Not enabled
                    <span style={{ color: "var(--fgColor-muted)", fontSize: "0.75rem" }}>
                      Setup MFA
                    </span>
                  </span>
                )
              }
              isLast={false}
            />
            <InfoRow
              label="Last Login"
              value={formatDate(profile.lastLoginAt)}
              isLast={true}
            />
          </SectionCard>
          </div>

          <div style={{ flex: 1, minWidth: 0 }}>
          <SectionCard title="Billing Summary" accent>
            <InfoRow
              label="Current Balance"
              value={
                <span style={{ fontSize: "1.125rem", fontWeight: 400 }}>
                  {formatCurrency(profile.balanceCents, profile.currency)}
                </span>
              }
              isLast={false}
            />
            <InfoRow
              label="Lifetime Spent"
              value={formatCurrency(profile.lifetimeSpentCents, profile.currency)}
              isLast={false}
            />
            <InfoRow
              label=""
              value={
                <button
                  onClick={() => router.push("/billing")}
                  style={{
                    background: "none",
                    border: "none",
                    color: "var(--fgColor-default)",
                    textDecoration: "underline",
                    fontSize: "0.875rem",
                    fontFamily: "var(--font-outfit), sans-serif",
                    cursor: "pointer",
                    padding: 0,
                  }}
                >
                  View full billing →
                </button>
              }
              isLast={true}
            />
          </SectionCard>
          </div>
        </div>

      {/* Toast */}
      {toast && <Toast message={toast} onClose={() => setToast(null)} />}
    </div>
  );
}
