"use client";

import { useSearchParams, useRouter } from "next/navigation";
import MentorExploreTab from "@/components/mentor/mentor-explore-tab";
import MentorUserSessionsTab from "@/components/mentor/mentor-user-sessions-tab";

type MentorTab = "explore" | "requests" | "upcoming" | "past";

const TABS: { id: MentorTab; label: string }[] = [
  { id: "explore", label: "Explore" },
  { id: "requests", label: "Requests" },
  { id: "upcoming", label: "Upcoming" },
  { id: "past", label: "Past" },
];

export default function MentorPage() {
  const router = useRouter();
  const searchParams = useSearchParams();

  const currentTab: MentorTab = (searchParams.get("tab") as MentorTab) || "explore";

  const handleTabChange = (tab: MentorTab) => {
    const params = new URLSearchParams(searchParams);
    params.set("tab", tab);
    router.push(`/mentor?${params.toString()}`, { scroll: false });
  };

  return (
    <div style={{ padding: "15px" }}>
      {/* Page Header */}
      <h1
        style={{
          fontFamily: "var(--font-sans)",
          fontSize: "2rem",
          fontWeight: 600,
          lineHeight: "2.5rem",
          color: "var(--fgColor-default)",
          letterSpacing: "-0.02em",
          margin: 0,
        }}
      >
        Mentor
      </h1>

      {/* Subheading */}
      <p
        style={{
          fontFamily: "var(--font-sans)",
          fontSize: "0.875rem",
          color: "var(--fgColor-muted)",
          margin: "8px 0 0 0",
          lineHeight: "1.5",
        }}
      >
        Connect with expert mentors for 1-on-1 guidance. Book sessions, track your learning, and level up your skills.
      </p>

      {/* Info Banner */}
      <div
        style={{
          backgroundColor: "var(--bgColor-info, #cedeff)",
          border: "1px solid var(--borderColor-info, #3a73ff)",
          borderRadius: "4px",
          padding: "16px",
          marginBottom: "24px",
          marginTop: "16px",
          display: "flex",
          alignItems: "flex-start",
          gap: "12px",
        }}
      >
        {/* Info icon */}
        <div style={{ flexShrink: 0, marginTop: "2px" }}>
          <svg
            width="20"
            height="20"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
            style={{ color: "var(--fgColor-info, #3a73ff)" }}
          >
            <circle cx="12" cy="12" r="10" />
            <line x1="12" y1="16" x2="12" y2="12" />
            <line x1="12" y1="8" x2="12.01" y2="8" />
          </svg>
        </div>
        <div>
          <h2
            style={{
              fontFamily: "var(--font-sans)",
              fontSize: "var(--text-base)",
              fontWeight: 600,
              color: "var(--fgColor-default)",
              margin: 0,
              marginBottom: "4px",
            }}
          >
            1-on-1 Expert Mentoring
          </h2>
          <p
            style={{
              fontFamily: "var(--font-sans)",
              fontSize: "var(--text-sm)",
              lineHeight: "1.375rem",
              color: "var(--fgColor-default)",
              margin: 0,
            }}
          >
            Find mentors in your domain, book sessions that fit your schedule, and get hands-on guidance for real-world projects. Pay only for the time you use.
          </p>
        </div>
      </div>

      {/* Tab Navigation */}
      <div
        style={{
          position: "relative",
          display: "flex",
          alignItems: "center",
          height: "40px",
          borderBottom: "1px solid var(--borderColor-default)",
          marginTop: "24px",
        }}
      >
        <div
          style={{
            display: "flex",
            alignItems: "center",
            height: "40px",
            gap: "24px",
          }}
        >
          {TABS.map((tab) => {
            const isActive = currentTab === tab.id;
            return (
              <button
                key={tab.id}
                onClick={() => handleTabChange(tab.id)}
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
                }}
              >
                <span
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "1rem",
                    fontWeight: isActive ? 600 : 400,
                    lineHeight: "1.5rem",
                    display: "block",
                    color: isActive ? "var(--fgColor-default)" : "var(--fgColor-muted)",
                    transition: "color 0.15s ease",
                  }}
                >
                  {tab.label}
                </span>
                {isActive && (
                  <span
                    style={{
                      position: "absolute",
                      zIndex: 1,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: "2px",
                      backgroundColor: "var(--fgColor-default)",
                      transition: "all 0.2s ease",
                    }}
                  />
                )}
              </button>
            );
          })}
        </div>
      </div>

      {/* Tab Content */}
      <div style={{ marginTop: "24px" }}>
        {currentTab === "explore" ? (
          <MentorExploreTab />
        ) : (
          <MentorUserSessionsTab activeTab={currentTab} />
        )}
      </div>
    </div>
  );
}
