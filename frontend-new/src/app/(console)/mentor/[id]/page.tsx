"use client";

import { useState, useEffect } from "react";
import { useParams, useRouter } from "next/navigation";
import { getPublicMentorProfile } from "@/lib/api";
import type { MentorProfileDetail } from "@/lib/api";
import BookSessionModal from "@/components/mentor/book-session-modal";

/* ── Helpers ─────────────────────────────────────────────── */

function getInitials(name: string): string {
  const parts = name.trim().split(/\s+/);
  if (parts.length >= 2) return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  return name.slice(0, 2).toUpperCase();
}

function avatarHue(name: string): number {
  let h = 0;
  for (let i = 0; i < name.length; i++) h = name.charCodeAt(i) + ((h << 5) - h);
  return Math.abs(h) % 360;
}

function formatRelativeTime(iso: string | null): string {
  if (!iso) return "Never";
  const then = new Date(iso).getTime();
  const now = Date.now();
  const diffMs = now - then;
  const diffMins = Math.floor(diffMs / 60000);
  if (diffMins < 15) return "Online";
  if (diffMins < 60) return `Last seen ${diffMins}m ago`;
  const diffHours = Math.floor(diffMins / 60);
  if (diffHours < 24) return `Last seen ${diffHours}h ago`;
  const diffDays = Math.floor(diffHours / 24);
  if (diffDays < 30) return `Last seen ${diffDays}d ago`;
  return "Last seen long ago";
}

function formatMinutes(min: number): string {
  if (min < 60) return `${min} min`;
  const h = Math.floor(min / 60);
  const m = min % 60;
  if (m === 0) return `${h} hr`;
  return `${h}h ${m}m`;
}

/* ── Social Link Button ──────────────────────────────────── */

function SocialLink({
  href,
  src,
  alt,
}: {
  href: string;
  src: string;
  alt: string;
}) {
  return (
    <a
      href={href}
      target="_blank"
      rel="noopener noreferrer"
      style={{
        width: "36px",
        height: "36px",
        borderRadius: "4px",
        border: "1px solid var(--borderColor-default)",
        backgroundColor: "var(--bgColor-muted)",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        transition: "border-color 0.15s ease",
        cursor: "pointer",
        flexShrink: 0,
      }}
      onMouseOver={(e) => {
        e.currentTarget.style.borderColor = "var(--fgColor-muted)";
      }}
      onMouseOut={(e) => {
        e.currentTarget.style.borderColor = "var(--borderColor-default)";
      }}
    >
      <img
        src={src}
        alt={alt}
        style={{ width: "18px", height: "18px", objectFit: "contain" }}
      />
    </a>
  );
}

/* ── Pill Tag ────────────────────────────────────────────── */

function PillTag({ text }: { text: string }) {
  return (
    <span
      style={{
        fontFamily: "var(--font-sans)",
        fontSize: "0.6875rem",
        padding: "3px 10px",
        borderRadius: "3px",
        backgroundColor: "var(--bgColor-muted)",
        color: "var(--fgColor-default)",
        border: "1px solid var(--borderColor-default)",
        fontWeight: 500,
        whiteSpace: "nowrap",
      }}
    >
      {text}
    </span>
  );
}

/* ── Section Heading ─────────────────────────────────────── */

function SectionHeading({ children }: { children: React.ReactNode }) {
  return (
    <h2
      style={{
        fontFamily: "var(--font-sans)",
        fontSize: "1rem",
        fontWeight: 600,
        color: "var(--fgColor-default)",
        margin: "0 0 14px 0",
      }}
    >
      {children}
    </h2>
  );
}

/* ── Main Page ───────────────────────────────────────────── */

export default function MentorProfilePage() {
  const router = useRouter();
  const params = useParams();
  const mentorProfileId = params.id as string;

  const [profile, setProfile] = useState<MentorProfileDetail | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);
  const [showBooking, setShowBooking] = useState(false);

  useEffect(() => {
    if (!mentorProfileId) return;
    setLoading(true);
    getPublicMentorProfile(mentorProfileId)
      .then((data) => {
        setProfile(data);
        setError(false);
      })
      .catch(() => {
        setProfile(null);
        setError(true);
      })
      .finally(() => setLoading(false));
  }, [mentorProfileId]);

  if (loading) {
    return (
      <div style={{ padding: "48px", textAlign: "center" }}>
        <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.875rem", color: "var(--fgColor-muted)" }}>
          Loading profile...
        </p>
      </div>
    );
  }

  if (error || !profile) {
    return (
      <div style={{ padding: "48px", textAlign: "center" }}>
        <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.875rem", color: "var(--fgColor-muted)" }}>
          Failed to load mentor profile.
        </p>
        <button
          onClick={() => router.push("/mentor")}
          style={{
            marginTop: "16px",
            padding: "8px 16px",
            backgroundColor: "var(--bgColor-muted)",
            border: "1px solid var(--borderColor-default)",
            borderRadius: "4px",
            fontFamily: "var(--font-sans)",
            fontSize: "0.8125rem",
            color: "var(--fgColor-default)",
            cursor: "pointer",
          }}
        >
          Back to Explore
        </button>
      </div>
    );
  }

  const initials = getInitials(profile.name);
  const hue = avatarHue(profile.name);
  const lastSeenText = formatRelativeTime(profile.lastLoginAt);
  const isOnline = lastSeenText === "Online";
  const currencySymbol = profile.currency === "INR" ? "\u20B9" : "$";
  const priceValue = (profile.pricePerHourCents / 100).toLocaleString("en-IN");

  /* Build social links */
  const socials: { href: string; src: string; alt: string }[] = [];
  if (profile.githubUrl) socials.push({ href: profile.githubUrl, src: "/images/Github.png", alt: "GitHub" });
  if (profile.linkedinUrl) socials.push({ href: profile.linkedinUrl, src: "/images/Linkedin_dark_theme.png", alt: "LinkedIn" });
  if (profile.xUrl) socials.push({ href: profile.xUrl, src: "/images/X_logo_(dark_theme).png", alt: "X" });
  if (profile.substackUrl) socials.push({ href: profile.substackUrl, src: "/images/Substack.png", alt: "Substack" });
  if (profile.websiteUrl) socials.push({ href: profile.websiteUrl, src: "/images/Github.png", alt: "Website" }); // fallback, will override with globe

  return (
    <div style={{ padding: "15px" }}>
      {/* Back link */}
      <button
        onClick={() => router.push("/mentor")}
        style={{
          display: "flex",
          alignItems: "center",
          gap: "6px",
          background: "none",
          border: "none",
          fontFamily: "var(--font-sans)",
          fontSize: "0.8125rem",
          color: "var(--fgColor-muted)",
          cursor: "pointer",
          marginBottom: "20px",
          padding: 0,
        }}
      >
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <polyline points="15 18 9 12 15 6" />
        </svg>
        Back to Explore
      </button>

      {/* Two-column layout */}
      <div style={{ display: "flex", gap: "24px", flexWrap: "wrap", alignItems: "flex-start" }}>
        {/* ── Left Column ── */}
        <div style={{ flex: "1 1 500px", minWidth: "300px" }}>
          {/* Profile Header */}
          <div
            style={{
              backgroundColor: "var(--bgColor-mild)",
              border: "1px solid var(--borderColor-default)",
              borderRadius: "6px",
              padding: "24px",
              marginBottom: "20px",
            }}
          >
            <div style={{ display: "flex", gap: "18px", alignItems: "flex-start" }}>
              {/* Large Avatar */}
              <div
                style={{
                  width: "72px",
                  height: "72px",
                  borderRadius: "50%",
                  background: `linear-gradient(135deg, hsl(${hue}, 40%, 28%), hsl(${hue}, 50%, 18%))`,
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  flexShrink: 0,
                  fontFamily: "var(--font-sans)",
                  fontSize: "1.5rem",
                  fontWeight: 700,
                  color: `hsl(${hue}, 50%, 78%)`,
                  letterSpacing: "0.04em",
                  border: `2px solid hsl(${hue}, 35%, 35%)`,
                }}
              >
                {initials}
              </div>

              <div style={{ flex: 1, minWidth: 0 }}>
                {/* Name + Country */}
                <div style={{ display: "flex", alignItems: "center", gap: "10px", flexWrap: "wrap", marginBottom: "4px" }}>
                  <span
                    style={{
                      fontFamily: "var(--font-sans)",
                      fontSize: "1.25rem",
                      fontWeight: 600,
                      color: "var(--fgColor-default)",
                    }}
                  >
                    {profile.name}
                  </span>
                  {profile.country && (
                    <span
                      style={{
                        fontFamily: "var(--font-sans)",
                        fontSize: "0.6875rem",
                        fontWeight: 600,
                        color: "var(--fgColor-muted)",
                        backgroundColor: "var(--bgColor-muted)",
                        border: "1px solid var(--borderColor-default)",
                        borderRadius: "3px",
                        padding: "1px 6px",
                        letterSpacing: "0.04em",
                        lineHeight: "1.4",
                      }}
                    >
                      {profile.country.toUpperCase()}
                    </span>
                  )}
                </div>

                {/* Role at Company */}
                {(profile.professionalRole || profile.company) && (
                  <div
                    style={{
                      fontFamily: "var(--font-sans)",
                      fontSize: "0.875rem",
                      color: "var(--fgColor-muted)",
                      marginBottom: "8px",
                    }}
                  >
                    {profile.professionalRole && <span>{profile.professionalRole}</span>}
                    {profile.professionalRole && profile.company && (
                      <span style={{ opacity: 0.7 }}>{" "}at{" "}</span>
                    )}
                    {profile.company && <span style={{ color: "#C8AA6E", fontWeight: 500 }}>{profile.company}</span>}
                  </div>
                )}

                {/* Last Seen */}
                <div style={{ display: "flex", alignItems: "center", gap: "6px", marginBottom: "10px" }}>
                  <span
                    style={{
                      width: "8px",
                      height: "8px",
                      borderRadius: "50%",
                      backgroundColor: isOnline ? "#3fb950" : "var(--fgColor-muted)",
                      display: "inline-block",
                      flexShrink: 0,
                    }}
                  />
                  <span
                    style={{
                      fontFamily: "var(--font-sans)",
                      fontSize: "0.8125rem",
                      color: isOnline ? "#3fb950" : "var(--fgColor-muted)",
                      fontWeight: isOnline ? 500 : 400,
                    }}
                  >
                    {lastSeenText}
                  </span>
                </div>

                {/* Stats Row */}
                <div style={{ display: "flex", gap: "16px", flexWrap: "wrap" }}>
                  <div style={{ display: "flex", alignItems: "center", gap: "4px" }}>
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="var(--fgColor-muted)" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round">
                      <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
                      <line x1="16" y1="2" x2="16" y2="6" />
                      <line x1="8" y1="2" x2="8" y2="6" />
                      <line x1="3" y1="10" x2="21" y2="10" />
                    </svg>
                    <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)", fontWeight: 500 }}>
                      {profile.totalSessions}
                    </span>
                    <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)" }}>
                      session{profile.totalSessions !== 1 ? "s" : ""}
                    </span>
                  </div>

                  <div style={{ display: "flex", alignItems: "center", gap: "4px" }}>
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="var(--fgColor-muted)" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round">
                      <circle cx="12" cy="12" r="10" />
                      <polyline points="12 6 12 12 16 14" />
                    </svg>
                    <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)" }}>
                      {formatMinutes(profile.totalMentoringMinutes)} mentored
                    </span>
                  </div>

                  {profile.avgRating > 0 && (
                    <div style={{ display: "flex", alignItems: "center", gap: "4px" }}>
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="#C8AA6E" stroke="#C8AA6E" strokeWidth="1">
                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                      </svg>
                      <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)", fontWeight: 500 }}>
                        {profile.avgRating.toFixed(1)}
                      </span>
                      <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)" }}>
                        ({profile.totalReviews} reviews)
                      </span>
                    </div>
                  )}
                </div>
              </div>
            </div>
          </div>

          {/* About Me */}
          <div
            style={{
              backgroundColor: "var(--bgColor-mild)",
              border: "1px solid var(--borderColor-default)",
              borderRadius: "6px",
              padding: "20px 24px",
              marginBottom: "20px",
            }}
          >
            <SectionHeading>About</SectionHeading>
            {profile.bio ? (
              <p
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "0.875rem",
                  lineHeight: "1.6",
                  color: "var(--fgColor-default)",
                  margin: 0,
                  whiteSpace: "pre-wrap",
                }}
              >
                {profile.bio}
              </p>
            ) : (
              <p
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "0.875rem",
                  color: "var(--fgColor-muted)",
                  margin: 0,
                  fontStyle: "italic",
                }}
              >
                No bio provided yet.
              </p>
            )}
          </div>

          {/* Social Handles */}
          {socials.length > 0 && (
            <div
              style={{
                backgroundColor: "var(--bgColor-mild)",
                border: "1px solid var(--borderColor-default)",
                borderRadius: "6px",
                padding: "20px 24px",
                marginBottom: "20px",
              }}
            >
              <SectionHeading>Connect</SectionHeading>
              <div style={{ display: "flex", gap: "10px", flexWrap: "wrap" }}>
                {socials.map((s) => (
                  <SocialLink key={s.alt} href={s.href} src={s.src} alt={s.alt} />
                ))}
                {profile.websiteUrl && (
                  <a
                    href={profile.websiteUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    style={{
                      width: "36px",
                      height: "36px",
                      borderRadius: "4px",
                      border: "1px solid var(--borderColor-default)",
                      backgroundColor: "var(--bgColor-muted)",
                      display: "flex",
                      alignItems: "center",
                      justifyContent: "center",
                      transition: "border-color 0.15s ease",
                      cursor: "pointer",
                      flexShrink: 0,
                    }}
                    onMouseOver={(e) => { e.currentTarget.style.borderColor = "var(--fgColor-muted)"; }}
                    onMouseOut={(e) => { e.currentTarget.style.borderColor = "var(--borderColor-default)"; }}
                  >
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="var(--fgColor-muted)" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                      <circle cx="12" cy="12" r="10" />
                      <line x1="2" y1="12" x2="22" y2="12" />
                      <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
                    </svg>
                  </a>
                )}
              </div>
            </div>
          )}

          {/* Background / Skills */}
          <div
            style={{
              backgroundColor: "var(--bgColor-mild)",
              border: "1px solid var(--borderColor-default)",
              borderRadius: "6px",
              padding: "20px 24px",
              marginBottom: "20px",
            }}
          >
            <SectionHeading>Background</SectionHeading>

            {/* Expertise Areas */}
            {profile.expertiseAreas.length > 0 && (
              <div
                style={{
                  display: "flex",
                  justifyContent: "space-between",
                  alignItems: "center",
                  gap: "16px",
                  padding: "12px 0",
                  borderBottom: "1px solid var(--borderColor-default)",
                }}
              >
                <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)", flexShrink: 0 }}>
                  Expertise Areas
                </span>
                <div style={{ display: "flex", gap: "6px", flexWrap: "wrap", justifyContent: "flex-end" }}>
                  {profile.expertiseAreas.map((area) => (
                    <PillTag key={area} text={area} />
                  ))}
                </div>
              </div>
            )}

            {/* Skills */}
            {profile.skills.length > 0 && (
              <div
                style={{
                  display: "flex",
                  justifyContent: "space-between",
                  alignItems: "center",
                  gap: "16px",
                  padding: "12px 0",
                  borderBottom: "1px solid var(--borderColor-default)",
                }}
              >
                <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)", flexShrink: 0 }}>
                  Skills
                </span>
                <div style={{ display: "flex", gap: "6px", flexWrap: "wrap", justifyContent: "flex-end" }}>
                  {profile.skills.map((skill) => (
                    <PillTag key={skill} text={skill} />
                  ))}
                </div>
              </div>
            )}

            {/* Languages */}
            {profile.languages.length > 0 && (
              <div
                style={{
                  display: "flex",
                  justifyContent: "space-between",
                  alignItems: "center",
                  gap: "16px",
                  padding: "12px 0",
                }}
              >
                <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)", flexShrink: 0 }}>
                  Languages
                </span>
                <div style={{ display: "flex", gap: "6px", flexWrap: "wrap", justifyContent: "flex-end" }}>
                  {profile.languages.map((lang) => (
                    <PillTag key={lang} text={lang} />
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>

        {/* ── Right Column: Book Session ── */}
        <div style={{ width: "340px", flexShrink: 0, position: "sticky", top: "15px" }}>
          <div
            style={{
              backgroundColor: "var(--bgColor-mild)",
              border: "1px solid var(--borderColor-default)",
              borderRadius: "6px",
              padding: "24px",
            }}
          >
            <h3
              style={{
                fontFamily: "var(--font-sans)",
                fontSize: "1rem",
                fontWeight: 600,
                color: "var(--fgColor-default)",
                margin: "0 0 4px 0",
              }}
            >
              Book a Session
            </h3>
            <p
              style={{
                fontFamily: "var(--font-sans)",
                fontSize: "0.8125rem",
                color: "var(--fgColor-muted)",
                margin: "0 0 16px 0",
              }}
            >
              1-on-1 mentoring session
            </p>

            <div
              style={{
                borderTop: "1px solid var(--borderColor-default)",
                borderBottom: "1px solid var(--borderColor-default)",
                padding: "16px 0",
                marginBottom: "16px",
              }}
            >
              <div
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "0.6875rem",
                  fontWeight: 500,
                  color: "var(--fgColor-muted)",
                  textTransform: "uppercase",
                  letterSpacing: "0.06em",
                  marginBottom: "6px",
                }}
              >
                Price per hour
              </div>
              <div style={{ display: "flex", alignItems: "baseline", gap: "4px" }}>
                <span
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "1.75rem",
                    fontWeight: 700,
                    color: "var(--fgColor-default)",
                  }}
                >
                  {currencySymbol}{priceValue}
                </span>
                <span
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.875rem",
                    color: "var(--fgColor-muted)",
                  }}
                >
                  /hr
                </span>
              </div>
            </div>

            <button
              type="button"
              onClick={() => setShowBooking(true)}
              style={{
                width: "100%",
                padding: "12px 0",
                backgroundColor: "#C8AA6E",
                border: "none",
                borderRadius: "4px",
                fontFamily: "var(--font-sans)",
                fontSize: "0.9375rem",
                fontWeight: 600,
                color: "#0B0B0B",
                cursor: "pointer",
                transition: "filter 0.15s ease",
              }}
              onMouseOver={(e) => {
                e.currentTarget.style.filter = "brightness(1.1)";
              }}
              onMouseOut={(e) => {
                e.currentTarget.style.filter = "brightness(1)";
              }}
            >
              Schedule Session
            </button>
          </div>
        </div>
      </div>

      {/* Booking Modal */}
      {showBooking && profile && (
        <BookSessionModal
          mentor={profile}
          onClose={() => setShowBooking(false)}
        />
      )}
    </div>
  );
}
