"use client";

import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
import { Search } from "lucide-react";
import { exploreMentors } from "@/lib/api";
import type { MentorCard } from "@/lib/api";

const SERVICE_DOMAINS = [
  "Computer Science",
  "AI",
  "Digital Marketing",
  "Sales",
  "Graphics Design",
];

const EXPERTISE_LEVELS = ["Entry Level", "Intermediate", "Senior"];

// Multi-select dropdown component
function MultiSelectFilter({
  label,
  options,
  selected,
  onChange,
}: {
  label: string;
  options: string[];
  selected: string[];
  onChange: (selected: string[]) => void;
}) {
  const [isOpen, setIsOpen] = useState(false);

  const toggle = (option: string) => {
    if (selected.includes(option)) {
      onChange(selected.filter((s) => s !== option));
    } else {
      onChange([...selected, option]);
    }
  };

  const displayText = selected.length === 0 ? label : selected.length === 1 ? selected[0] : `${selected.length} selected`;

  return (
    <div style={{ position: "relative" }}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        style={{
          display: "flex",
          alignItems: "center",
          gap: "6px",
          padding: "0 12px",
          height: "36px",
          backgroundColor: selected.length > 0 ? "rgba(200, 170, 110, 0.1)" : "var(--bgColor-muted)",
          border: `1px solid ${selected.length > 0 ? "#C8AA6E" : "var(--borderColor-default)"}`,
          borderRadius: "4px",
          fontFamily: "var(--font-sans)",
          fontSize: "0.8125rem",
          color: selected.length > 0 ? "#C8AA6E" : "var(--fgColor-default)",
          cursor: "pointer",
          whiteSpace: "nowrap",
          transition: "all 0.15s ease",
        }}
      >
        {displayText}
        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <polyline points="6 9 12 15 18 9" />
        </svg>
      </button>

      {isOpen && (
        <>
          {/* Backdrop */}
          <div style={{ position: "fixed", top: 0, left: 0, right: 0, bottom: 0, zIndex: 50 }} onClick={() => setIsOpen(false)} />
          <div
            style={{
              position: "absolute",
              top: "100%",
              right: 0,
              marginTop: "4px",
              backgroundColor: "var(--bgColor-elevated, var(--bgColor-default))",
              border: "1px solid var(--borderColor-default)",
              borderRadius: "4px",
              boxShadow: "0 4px 16px rgba(0, 0, 0, 0.2)",
              zIndex: 51,
              minWidth: "180px",
              maxHeight: "240px",
              overflowY: "auto",
            }}
          >
            {options.map((option) => {
              const isSelected = selected.includes(option);
              return (
                <button
                  key={option}
                  onClick={() => toggle(option)}
                  style={{
                    width: "100%",
                    display: "flex",
                    alignItems: "center",
                    gap: "8px",
                    padding: "8px 12px",
                    backgroundColor: "transparent",
                    border: "none",
                    cursor: "pointer",
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.8125rem",
                    color: "var(--fgColor-default)",
                    textAlign: "left",
                    transition: "background-color 0.1s ease",
                  }}
                  onMouseOver={(e) => { e.currentTarget.style.backgroundColor = "var(--bgColor-muted)"; }}
                  onMouseOut={(e) => { e.currentTarget.style.backgroundColor = "transparent"; }}
                >
                  <div
                    style={{
                      width: "16px",
                      height: "16px",
                      borderRadius: "3px",
                      border: `1.5px solid ${isSelected ? "#C8AA6E" : "var(--borderColor-default)"}`,
                      backgroundColor: isSelected ? "#C8AA6E" : "transparent",
                      display: "flex",
                      alignItems: "center",
                      justifyContent: "center",
                      flexShrink: 0,
                    }}
                  >
                    {isSelected && (
                      <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#0B0B0B" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
                        <polyline points="20 6 9 17 4 12" />
                      </svg>
                    )}
                  </div>
                  {option}
                </button>
              );
            })}
            {selected.length > 0 && (
              <div style={{ borderTop: "1px solid var(--borderColor-default)", padding: "6px 12px" }}>
                <button
                  onClick={() => { onChange([]); setIsOpen(false); }}
                  style={{
                    background: "none",
                    border: "none",
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.75rem",
                    color: "var(--fgColor-muted)",
                    cursor: "pointer",
                    padding: 0,
                  }}
                >
                  Clear all
                </button>
              </div>
            )}
          </div>
        </>
      )}
    </div>
  );
}

function getInitials(name: string): string {
  const parts = name.trim().split(/\s+/);
  if (parts.length >= 2) return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  return name.slice(0, 2).toUpperCase();
}

/* Deterministic hue from name so each card gets a unique avatar tint */
function avatarHue(name: string): number {
  let h = 0;
  for (let i = 0; i < name.length; i++) h = name.charCodeAt(i) + ((h << 5) - h);
  return Math.abs(h) % 360;
}

function MentorCardComponent({ mentor, onClick }: { mentor: MentorCard; onClick?: () => void }) {
  const initials = getInitials(mentor.name);
  const hue = avatarHue(mentor.name);
  const priceValue = (mentor.pricePerHourCents / 100).toLocaleString("en-IN");
  const currencySymbol = mentor.currency === "INR" ? "\u20B9" : "$";
  const countryBadge = mentor.country ? mentor.country.toUpperCase() : null;

  return (
    <div
      onClick={onClick}
      style={{
        backgroundColor: "var(--bgColor-mild)",
        border: "1px solid var(--borderColor-default)",
        borderRadius: "6px",
        display: "flex",
        flexDirection: "column",
        transition: "all 0.2s ease",
        cursor: "pointer",
        overflow: "hidden",
      }}
      onMouseOver={(e) => {
        e.currentTarget.style.borderColor = "var(--fgColor-muted)";
        e.currentTarget.style.transform = "translateY(-2px)";
        e.currentTarget.style.boxShadow = "0 6px 20px rgba(0,0,0,0.25)";
      }}
      onMouseOut={(e) => {
        e.currentTarget.style.borderColor = "var(--borderColor-default)";
        e.currentTarget.style.transform = "translateY(0)";
        e.currentTarget.style.boxShadow = "none";
      }}
    >
      {/* ---- Zone 1: Identity ---- */}
      <div style={{ padding: "20px 18px 0 18px", display: "flex", gap: "14px", alignItems: "flex-start" }}>
        {/* Circular Initials Avatar */}
        <div
          style={{
            width: "52px",
            height: "52px",
            borderRadius: "50%",
            background: `linear-gradient(135deg, hsl(${hue}, 40%, 28%), hsl(${hue}, 50%, 18%))`,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            flexShrink: 0,
            fontFamily: "var(--font-sans)",
            fontSize: "1rem",
            fontWeight: 700,
            color: `hsl(${hue}, 50%, 78%)`,
            letterSpacing: "0.04em",
            border: `2px solid hsl(${hue}, 35%, 35%)`,
          }}
        >
          {initials}
        </div>

        {/* Name + Country + Role */}
        <div style={{ flex: 1, minWidth: 0 }}>
          {/* Name row */}
          <div style={{ display: "flex", alignItems: "center", gap: "8px", flexWrap: "wrap" }}>
            <span
              style={{
                fontFamily: "var(--font-sans)",
                fontSize: "1rem",
                fontWeight: 600,
                color: "var(--fgColor-default)",
                overflow: "hidden",
                textOverflow: "ellipsis",
                whiteSpace: "nowrap",
              }}
            >
              {mentor.name}
            </span>
            {countryBadge && (
              <span
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "0.625rem",
                  fontWeight: 600,
                  color: "var(--fgColor-muted)",
                  backgroundColor: "var(--bgColor-muted)",
                  border: "1px solid var(--borderColor-default)",
                  borderRadius: "3px",
                  padding: "1px 5px",
                  letterSpacing: "0.04em",
                  lineHeight: "1.4",
                  flexShrink: 0,
                }}
              >
                {countryBadge}
              </span>
            )}
          </div>

          {/* Role at Company */}
          {(mentor.professionalRole || mentor.company) && (
            <div
              style={{
                fontFamily: "var(--font-sans)",
                fontSize: "0.8125rem",
                color: "var(--fgColor-muted)",
                marginTop: "4px",
                overflow: "hidden",
                textOverflow: "ellipsis",
                whiteSpace: "nowrap",
                lineHeight: "1.4",
              }}
            >
              {mentor.professionalRole && (
                <span>{mentor.professionalRole}</span>
              )}
              {mentor.professionalRole && mentor.company && (
                <span style={{ color: "var(--fgColor-muted)", opacity: 0.7 }}>{" "}at{" "}</span>
              )}
              {mentor.company && (
                <span style={{ color: "#C8AA6E", fontWeight: 500 }}>{mentor.company}</span>
              )}
              {!mentor.professionalRole && mentor.company && (
                <span style={{ color: "#C8AA6E", fontWeight: 500 }}>{mentor.company}</span>
              )}
            </div>
          )}
        </div>
      </div>

      {/* ---- Zone 2: Sessions + Rating ---- */}
      <div
        style={{
          padding: "14px 18px 0 18px",
          display: "flex",
          alignItems: "center",
          gap: "6px",
          flexWrap: "wrap",
        }}
      >
        {/* Calendar icon + sessions */}
        <div style={{ display: "flex", alignItems: "center", gap: "5px" }}>
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="var(--fgColor-muted)" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round">
            <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
            <line x1="16" y1="2" x2="16" y2="6" />
            <line x1="8" y1="2" x2="8" y2="6" />
            <line x1="3" y1="10" x2="21" y2="10" />
          </svg>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)" }}>
            {mentor.totalSessions} session{mentor.totalSessions !== 1 ? "s" : ""}
          </span>
        </div>

        {/* Reviews (if any) */}
        {mentor.totalReviews > 0 && (
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)" }}>
            ({mentor.totalReviews} review{mentor.totalReviews !== 1 ? "s" : ""})
          </span>
        )}

        {/* Rating badge */}
        {mentor.avgRating > 0 && (
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: "3px",
              marginLeft: "auto",
              backgroundColor: "rgba(200, 170, 110, 0.1)",
              borderRadius: "3px",
              padding: "2px 6px",
            }}
          >
            <svg width="12" height="12" viewBox="0 0 24 24" fill="#C8AA6E" stroke="#C8AA6E" strokeWidth="1">
              <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
            </svg>
            <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 600, color: "#C8AA6E" }}>
              {mentor.avgRating.toFixed(1)}
            </span>
          </div>
        )}
      </div>

      {/* ---- Expertise Tags ---- */}
      {mentor.expertiseAreas.length > 0 && (
        <div style={{ padding: "12px 18px 0 18px", display: "flex", gap: "6px", flexWrap: "wrap" }}>
          {mentor.expertiseAreas.slice(0, 3).map((area) => (
            <span
              key={area}
              style={{
                fontFamily: "var(--font-sans)",
                fontSize: "0.6875rem",
                padding: "3px 8px",
                borderRadius: "3px",
                backgroundColor: "var(--bgColor-muted)",
                color: "var(--fgColor-muted)",
                border: "1px solid var(--borderColor-default)",
              }}
            >
              {area}
            </span>
          ))}
        </div>
      )}

      {/* Spacer to push metrics strip to bottom */}
      <div style={{ flex: 1 }} />

      {/* ---- Zone 3: Metrics Strip ---- */}
      <div
        style={{
          marginTop: "16px",
          borderTop: "1px solid var(--borderColor-default)",
          backgroundColor: "var(--bgColor-muted)",
          padding: "12px 18px",
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
        }}
      >
        <div>
          <div
            style={{
              fontFamily: "var(--font-sans)",
              fontSize: "0.625rem",
              fontWeight: 500,
              color: "var(--fgColor-muted)",
              marginBottom: "3px",
              textTransform: "uppercase",
              letterSpacing: "0.06em",
            }}
          >
            Experience
          </div>
          <div style={{ fontFamily: "var(--font-sans)", fontSize: "0.875rem", fontWeight: 600, color: "var(--fgColor-default)" }}>
            {mentor.experienceYears !== null ? `${mentor.experienceYears} yrs` : "\u2014"}
          </div>
        </div>
        <div style={{ width: "1px", height: "28px", backgroundColor: "var(--borderColor-default)" }} />
        <div style={{ textAlign: "right" }}>
          <div
            style={{
              fontFamily: "var(--font-sans)",
              fontSize: "0.625rem",
              fontWeight: 500,
              color: "var(--fgColor-muted)",
              marginBottom: "3px",
              textTransform: "uppercase",
              letterSpacing: "0.06em",
            }}
          >
            Price/Session
          </div>
          <div style={{ fontFamily: "var(--font-sans)", fontSize: "0.875rem", fontWeight: 600, color: "var(--fgColor-default)" }}>
            {currencySymbol}{priceValue}/hr
          </div>
        </div>
      </div>
    </div>
  );
}

export default function MentorExploreTab() {
  const router = useRouter();
  const [search, setSearch] = useState("");
  const [selectedDomains, setSelectedDomains] = useState<string[]>([]);
  const [selectedExpertise, setSelectedExpertise] = useState<string[]>([]);
  const [mentors, setMentors] = useState<MentorCard[]>([]);
  const [loading, setLoading] = useState(true);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(0);

  const fetchMentors = useCallback(async () => {
    setLoading(true);
    try {
      const result = await exploreMentors({
        search: search || undefined,
        domains: selectedDomains.length > 0 ? selectedDomains : undefined,
        expertise: selectedExpertise.length > 0 ? selectedExpertise : undefined,
        page,
        limit: 10,
      });
      setMentors(result.mentors);
      setTotal(result.total);
      setTotalPages(result.totalPages);
    } catch {
      setMentors([]);
    } finally {
      setLoading(false);
    }
  }, [search, selectedDomains, selectedExpertise, page]);

  useEffect(() => {
    fetchMentors();
  }, [fetchMentors]);

  // Reset page when filters change
  useEffect(() => {
    setPage(1);
  }, [search, selectedDomains, selectedExpertise]);

  // Debounce search
  const [searchInput, setSearchInput] = useState("");
  useEffect(() => {
    const timer = setTimeout(() => setSearch(searchInput), 300);
    return () => clearTimeout(timer);
  }, [searchInput]);

  return (
    <div>
      {/* Search + Filters Bar */}
      <div style={{ display: "flex", gap: "8px", alignItems: "center", flexWrap: "wrap", marginBottom: "20px" }}>
        {/* Search Input */}
        <div style={{ position: "relative", flex: "1 1 240px", minWidth: "200px" }}>
          <span
            style={{
              position: "absolute",
              left: "12px",
              top: "50%",
              transform: "translateY(-50%)",
              color: "var(--fgColor-muted)",
              pointerEvents: "none",
              display: "inline-flex",
            }}
            aria-hidden
          >
            <Search size={14} strokeWidth={1.75} />
          </span>
          <input
            type="text"
            value={searchInput}
            onChange={(e) => setSearchInput(e.target.value)}
            placeholder="Search mentors by name, skill, or topic..."
            style={{
              width: "100%",
              backgroundColor: "var(--bgColor-default)",
              border: "1px solid var(--borderColor-default)",
              borderRadius: "4px",
              height: "36px",
              padding: "0 12px 0 32px",
              fontFamily: "var(--font-sans)",
              fontSize: "0.8125rem",
              color: "var(--fgColor-default)",
              outline: "none",
              transition: "border-color 0.15s ease",
            }}
            onFocus={(e) => {
              e.currentTarget.style.borderColor = "var(--fgColor-muted)";
            }}
            onBlur={(e) => {
              e.currentTarget.style.borderColor = "var(--borderColor-default)";
            }}
          />
        </div>

        {/* Filters */}
        <MultiSelectFilter
          label="Service Domain"
          options={SERVICE_DOMAINS}
          selected={selectedDomains}
          onChange={setSelectedDomains}
        />
        <MultiSelectFilter
          label="Expertise"
          options={EXPERTISE_LEVELS}
          selected={selectedExpertise}
          onChange={setSelectedExpertise}
        />
      </div>

      {/* Results Grid */}
      {loading ? (
        <div style={{ padding: "48px", textAlign: "center" }}>
          <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.875rem", color: "var(--fgColor-muted)" }}>Loading mentors...</p>
        </div>
      ) : mentors.length === 0 ? (
        <div
          style={{
            backgroundColor: "var(--bgColor-mild)",
            border: "1px solid var(--borderColor-default)",
            borderRadius: "4px",
            padding: "48px 24px",
            textAlign: "center",
          }}
        >
          <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="var(--fgColor-muted)" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" style={{ margin: "0 auto 16px" }}>
            <circle cx="11" cy="11" r="8" />
            <line x1="21" y1="21" x2="16.65" y2="16.65" />
          </svg>
          <h3 style={{ fontFamily: "var(--font-sans)", fontSize: "1rem", fontWeight: 600, color: "var(--fgColor-default)", margin: "0 0 8px 0" }}>
            No mentors found
          </h3>
          <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.875rem", color: "var(--fgColor-muted)", margin: 0 }}>
            Try adjusting your search or filters to find more mentors.
          </p>
        </div>
      ) : (
        <>
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "repeat(5, 1fr)",
              gap: "16px",
            }}
          >
            {mentors.map((mentor) => (
              <MentorCardComponent key={mentor.id} mentor={mentor} onClick={() => router.push(`/mentor/${mentor.id}`)} />
            ))}
          </div>

          {/* Pagination */}
          {total > 0 && (
            <div
              style={{
                display: "flex",
                justifyContent: "space-between",
                alignItems: "center",
                padding: "10px 20px",
                borderTop: "1px solid var(--borderColor-default)",
                marginTop: "20px",
              }}
            >
              <span
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "0.875rem",
                  color: "var(--fgColor-muted)",
                }}
              >
                Showing {(page - 1) * 10 + 1}-{Math.min(page * 10, total)} of {total.toLocaleString("en-IN")}
              </span>

              <div style={{ display: "flex", gap: "8px" }}>
                <button
                  type="button"
                  onClick={() => setPage((p) => Math.max(1, p - 1))}
                  disabled={page <= 1 || loading}
                  style={{
                    padding: "6px 12px",
                    backgroundColor: "var(--bgColor-muted)",
                    border: "1px solid var(--borderColor-default)",
                    borderRadius: "4px",
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.8125rem",
                    color: page <= 1 || loading ? "var(--fgColor-muted)" : "var(--fgColor-default)",
                    cursor: page <= 1 || loading ? "not-allowed" : "pointer",
                    opacity: page <= 1 || loading ? 0.5 : 1,
                    transition: "background-color 0.15s ease",
                  }}
                  onMouseOver={(e) => {
                    if (page > 1 && !loading) e.currentTarget.style.backgroundColor = "var(--bgColor-mild)";
                  }}
                  onMouseOut={(e) => {
                    e.currentTarget.style.backgroundColor = "var(--bgColor-muted)";
                  }}
                >
                  Previous
                </button>
                <button
                  type="button"
                  onClick={() => setPage((p) => Math.min(totalPages || 1, p + 1))}
                  disabled={page >= totalPages || totalPages === 0 || loading}
                  style={{
                    padding: "6px 12px",
                    backgroundColor: "var(--bgColor-muted)",
                    border: "1px solid var(--borderColor-default)",
                    borderRadius: "4px",
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.8125rem",
                    color: page >= totalPages || totalPages === 0 || loading ? "var(--fgColor-muted)" : "var(--fgColor-default)",
                    cursor: page >= totalPages || totalPages === 0 || loading ? "not-allowed" : "pointer",
                    opacity: page >= totalPages || totalPages === 0 || loading ? 0.5 : 1,
                    transition: "background-color 0.15s ease",
                  }}
                  onMouseOver={(e) => {
                    if (page < totalPages && !loading) e.currentTarget.style.backgroundColor = "var(--bgColor-mild)";
                  }}
                  onMouseOut={(e) => {
                    e.currentTarget.style.backgroundColor = "var(--bgColor-muted)";
                  }}
                >
                  Next
                </button>
              </div>
            </div>
          )}
        </>
      )}
    </div>
  );
}
