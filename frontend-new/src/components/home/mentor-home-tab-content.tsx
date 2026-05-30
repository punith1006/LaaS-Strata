"use client";

import { useEffect, useState } from "react";
import type { User } from "@/types/auth";
import type { ActivityLogEntry } from "@/lib/api";
import { getRecentActivity, getMentorRequests, getMentorUpcoming, getMentorPast } from "@/lib/api";

interface MentorHomeTabContentProps {
  user: User | null;
}

// Card component for quick stats (reused from home-tab-content.tsx)
function QuickStatCard({
  title,
  value,
  subtitle,
  status,
  statusColor,
}: {
  title: string;
  value: string;
  subtitle?: string;
  status?: string;
  statusColor?: string;
}) {
  return (
    <div
      style={{
        backgroundColor: "var(--bgColor-mild)",
        border: "1px solid var(--borderColor-default)",
        borderRadius: "4px",
        padding: "16px",
        display: "flex",
        flexDirection: "column",
        gap: "8px",
      }}
    >
      <div
        style={{
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
          gap: "8px",
        }}
      >
        <div
          style={{
            fontFamily: "var(--font-sans)",
            fontSize: "var(--text-xs)",
            fontWeight: 500,
            textTransform: "uppercase",
            letterSpacing: "0.06em",
            color: "var(--fgColor-muted)",
          }}
        >
          {title}
        </div>
        {status && (
          <div
            style={{
              fontFamily: "var(--font-sans)",
              fontSize: "var(--text-xs)",
              fontWeight: 600,
              color: "var(--bgColor-default)",
              padding: "4px 12px",
              borderRadius: "4px",
              backgroundColor: "var(--fgColor-default)",
              display: "flex",
              alignItems: "center",
              gap: "6px",
              textTransform: "uppercase",
              letterSpacing: "0.1em",
            }}
          >
            <span
              style={{
                width: "8px",
                height: "8px",
                borderRadius: "50%",
                backgroundColor: statusColor ?? "#3fb950",
                flexShrink: 0,
              }}
            />
            {status}
          </div>
        )}
      </div>
      <div
        style={{
          fontFamily: "var(--font-sans)",
          fontSize: "var(--text-lg)",
          fontWeight: 600,
          color: "var(--fgColor-default)",
        }}
      >
        {value}
      </div>
      {subtitle && (
        <div
          style={{
            fontFamily: "var(--font-sans)",
            fontSize: "var(--text-xs)",
            color: "var(--fgColor-muted)",
          }}
        >
          {subtitle}
        </div>
      )}
    </div>
  );
}

// Section header component (reused from home-tab-content.tsx)
function SectionHeader({ title }: { title: string }) {
  return (
    <h2
      style={{
        fontFamily: "var(--font-sans)",
        fontSize: "var(--text-base)",
        fontWeight: 600,
        color: "var(--fgColor-default)",
        marginBottom: "12px",
        marginTop: "24px",
      }}
    >
      {title}
    </h2>
  );
}

// Quick action button component (reused from home-tab-content.tsx)
function QuickActionButton({ label, href }: { label: string; href: string }) {
  return (
    <a
      href={href}
      style={{
        display: "inline-flex",
        alignItems: "center",
        justifyContent: "center",
        height: "40px",
        padding: "0 24px",
        backgroundColor: "transparent",
        border: "1px solid var(--borderColor-default)",
        borderRadius: "4px",
        fontFamily: "var(--font-sans)",
        fontSize: "var(--text-sm)",
        fontWeight: 500,
        color: "var(--fgColor-default)",
        textDecoration: "none",
        cursor: "pointer",
        transition: "background-color 0.15s ease, border-color 0.15s ease",
      }}
      onMouseEnter={(e) => {
        e.currentTarget.style.backgroundColor = "rgba(11, 11, 11, 0.05)";
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.backgroundColor = "transparent";
      }}
    >
      {label}
    </a>
  );
}

export function MentorHomeTabContent({ user }: MentorHomeTabContentProps) {
  const [activityData, setActivityData] = useState<ActivityLogEntry[]>([]);
  const [activityLoading, setActivityLoading] = useState(true);
  const [expandedDates, setExpandedDates] = useState<Set<string>>(new Set());

  // Overview stats from mentor sessions
  const [pendingCount, setPendingCount] = useState(0);
  const [upcomingCount, setUpcomingCount] = useState(0);
  const [totalEarningsCents, setTotalEarningsCents] = useState(0);

  useEffect(() => {
    getRecentActivity(30)
      .then((data) => {
        setActivityData(data);
        setActivityLoading(false);
        const today = new Date().toISOString().split("T")[0];
        setExpandedDates(new Set([today]));
      })
      .catch(() => {
        setActivityLoading(false);
      });

    // Fetch mentor overview stats
    Promise.all([
      getMentorRequests(),
      getMentorUpcoming(),
      getMentorPast(),
    ]).then(([requests, upcoming, past]) => {
      setPendingCount(requests.length);
      setUpcomingCount(upcoming.length);
      const completedSum = past
        .filter((p) => p.status === "Completed")
        .reduce((sum, p) => sum + p.earningsCents, 0);
      setTotalEarningsCents(completedSum);
    }).catch(() => {});
  }, []);

  const firstName = user?.firstName || "there";

  // Format helpers for activity log
  const groupActivitiesByDate = (activities: ActivityLogEntry[]) => {
    const groups: Record<string, ActivityLogEntry[]> = {};
    activities.forEach((activity) => {
      const date = activity.createdAt.split("T")[0];
      if (!groups[date]) groups[date] = [];
      groups[date].push(activity);
    });
    const sortedDates = Object.keys(groups).sort((a, b) => b.localeCompare(a));
    return sortedDates.map((date) => ({
      date,
      activities: groups[date].sort(
        (a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
      ),
    }));
  };

  const formatDateHeader = (dateStr: string) => {
    const date = new Date(dateStr + "T00:00:00");
    const today = new Date();
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);

    const isToday = dateStr === today.toISOString().split("T")[0];
    const isYesterday = dateStr === yesterday.toISOString().split("T")[0];
    const monthDay = date.toLocaleDateString("en-US", { month: "long", day: "numeric" });
    const year = date.getFullYear();
    const currentYear = today.getFullYear();

    if (isToday) return `Today, ${monthDay}`;
    if (isYesterday) return `Yesterday, ${monthDay}`;
    if (year === currentYear) return monthDay;
    return `${monthDay}, ${year}`;
  };

  const formatTime = (isoString: string) => {
    return new Date(isoString).toLocaleTimeString("en-US", {
      hour: "numeric",
      minute: "2-digit",
      hour12: true,
    });
  };

  const getActionDescription = (activity: ActivityLogEntry) => {
    const { action, details } = activity;
    switch (action) {
      case "auth.login":
        return "Signed in";
      case "auth.logout":
        return "Signed out";
      case "wallet.credit": {
        const creditAmount = details?.amountCents
          ? `₹${(Number(details.amountCents) / 100).toFixed(2)}`
          : "₹0.00";
        if (details?.referenceType === "mentor_session_refund") {
          return `Refunded ${creditAmount} — cancelled session advance`;
        }
        if (details?.referenceType === "mentor_session_advance") {
          return `Received ${creditAmount} — mentoring session advance`;
        }
        return `Added ${creditAmount} to wallet`;
      }
      case "billing.charge": {
        const chargeAmount = details?.amountCents
          ? `₹${(Number(details.amountCents) / 100).toFixed(2)}`
          : "₹0.00";
        const chargeName = details?.instanceName || "Session";
        return `Billed ${chargeAmount} for ${chargeName}`;
      }
      case "mentoring.session_booked":
        return `Booked a mentoring session with ${details?.mentorName || "a mentor"}`;
      case "mentoring.session_approved":
        return `Approved session request from ${details?.studentName || "a student"}`;
      case "mentoring.session_rejected":
        return `Rejected session request from ${details?.studentName || "a student"}`;
      case "mentoring.session_cancelled":
        return `Cancelled mentoring session${details?.studentName ? ` with ${details.studentName}` : details?.mentorName ? ` with ${details.mentorName}` : ""}`;
      case "mentoring.slot_created": {
        const dayNames = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
        const dayLabel = details?.isRecurring && details?.dayOfWeek !== null
          ? dayNames[details.dayOfWeek as number]
          : details?.specificDate || "";
        return `Created availability slot — ${dayLabel} ${details?.startTime || ""}–${details?.endTime || ""}`;
      }
      case "mentoring.slot_deleted":
        return "Removed availability slot";
      case "mentoring.date_blocked":
        return `Marked ${details?.date || ""} as Day Off${details?.reason ? ` — ${details.reason}` : ""}`;
      case "mentoring.date_unblocked":
        return `Removed Day Off for ${details?.blockedDate ? details.blockedDate.split('T')[0] : ""}`;
      default:
        return action.replace(/\./g, " ").replace(/([a-z])([A-Z])/g, "$1 $2");
    }
  };

  const getCategoryColor = (category: string) => {
    switch (category) {
      case "auth":
        return "#3a73ff";
      case "storage":
        return "#05C004";
      case "billing":
        return "#f85149";
      case "mentoring":
        return "#C8AA6E";
      default:
        return "#818178";
    }
  };

  const toggleDateExpansion = (date: string) => {
    setExpandedDates((prev) => {
      const newSet = new Set(prev);
      if (newSet.has(date)) newSet.delete(date);
      else newSet.add(date);
      return newSet;
    });
  };

  const groupedActivities = groupActivitiesByDate(activityData);

  return (
    <div>
      {/* Welcome Section - Info banner style, personalized for mentor */}
      <div
        style={{
          backgroundColor: "var(--bgColor-info, #cedeff)",
          border: "1px solid var(--borderColor-info, #3a73ff)",
          borderRadius: "4px",
          padding: "16px",
          marginBottom: "24px",
          display: "flex",
          alignItems: "flex-start",
          gap: "12px",
        }}
      >
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
            Good to see you, {firstName}!
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
            Your expertise is in demand. Students are looking for guidance
            right now — set your availability, and they&apos;ll start booking you.
          </p>
        </div>
      </div>

      {/* Overview Section */}
      <SectionHeader title="Overview" />
      <div
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))",
          gap: "16px",
        }}
      >
        <QuickStatCard
          title="Pending Requests"
          value={String(pendingCount)}
          subtitle={pendingCount === 1 ? "1 request awaiting your response" : pendingCount > 1 ? `${pendingCount} requests awaiting your response` : "Awaiting your response"}
          status={pendingCount > 0 ? "Action Needed" : "Smooth Sailing"}
          statusColor={pendingCount > 0 ? "#FDA422" : "#05C004"}
        />
        <QuickStatCard
          title="Upcoming Sessions"
          value={String(upcomingCount)}
          subtitle={upcomingCount === 0 ? "No upcoming sessions" : `${upcomingCount} session${upcomingCount > 1 ? "s" : ""} scheduled`}
        />
        <QuickStatCard
          title="Total Earnings"
          value={`Rs.${(totalEarningsCents / 100).toLocaleString("en-IN", { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`}
          subtitle="Gross earnings before platform fee"
        />
        <QuickStatCard
          title="Avg. Rating"
          value="--"
          subtitle="No reviews yet"
        />
      </div>

      {/* Quick Actions Section */}
      <SectionHeader title="Quick Actions" />
      <div
        style={{
          display: "flex",
          gap: "12px",
          flexWrap: "wrap",
        }}
      >
        <QuickActionButton label="Set Availability" href="#" />
        <QuickActionButton label="Earnings Report" href="/billing" />
      </div>

      {/* Recent Activity Section */}
      <SectionHeader title="Recent Activity" />
      <div
        style={{
          backgroundColor: "var(--bgColor-mild)",
          border: "1px solid var(--borderColor-default)",
          borderRadius: "4px",
          overflow: "hidden",
        }}
      >
        {activityLoading ? (
          <div
            style={{
              fontFamily: "var(--font-sans)",
              fontSize: "var(--text-sm)",
              color: "var(--fgColor-muted)",
              textAlign: "center",
              padding: "24px",
            }}
          >
            Loading activity...
          </div>
        ) : groupedActivities.length === 0 ? (
          <div
            style={{
              fontFamily: "var(--font-sans)",
              fontSize: "var(--text-sm)",
              color: "var(--fgColor-muted)",
              textAlign: "center",
              padding: "24px",
            }}
          >
            No recent activity to display.
          </div>
        ) : (
          <div>
            {groupedActivities.map(({ date, activities }, groupIndex) => {
              const isExpanded = expandedDates.has(date);
              return (
                <div
                  key={date}
                  style={{
                    borderBottom:
                      groupIndex < groupedActivities.length - 1
                        ? "1px solid var(--borderColor-default)"
                        : "none",
                  }}
                >
                  {/* Date header - clickable accordion trigger */}
                  <button
                    onClick={() => toggleDateExpansion(date)}
                    style={{
                      width: "100%",
                      display: "flex",
                      alignItems: "center",
                      gap: "8px",
                      padding: "12px 16px",
                      backgroundColor: "transparent",
                      border: "none",
                      cursor: "pointer",
                      fontFamily: "var(--font-sans)",
                      fontSize: "var(--text-sm)",
                      fontWeight: 600,
                      color: "var(--fgColor-default)",
                      textAlign: "left",
                    }}
                  >
                    <span
                      style={{
                        display: "inline-flex",
                        alignItems: "center",
                        justifyContent: "center",
                        width: "16px",
                        fontSize: "10px",
                        color: "var(--fgColor-muted)",
                        transition: "transform 0.15s ease",
                        transform: isExpanded ? "rotate(90deg)" : "rotate(0deg)",
                      }}
                    >
                      ▶
                    </span>
                    {formatDateHeader(date)}
                    <span
                      style={{
                        fontWeight: 400,
                        color: "var(--fgColor-muted)",
                        fontSize: "var(--text-xs)",
                      }}
                    >
                      ({activities.length}{" "}
                      {activities.length === 1 ? "event" : "events"})
                    </span>
                  </button>

                  {/* Activity entries - collapsible content */}
                  {isExpanded && (
                    <div style={{ padding: "0 16px 12px 16px" }}>
                      {activities.map((activity, actIndex) => (
                        <div
                          key={activity.id}
                          style={{
                            display: "flex",
                            alignItems: "flex-start",
                            gap: "12px",
                            padding: "10px 0",
                            borderTop:
                              actIndex > 0
                                ? "1px solid var(--borderColor-muted)"
                                : "none",
                          }}
                        >
                          {/* Category dot */}
                          <div
                            style={{
                              width: "8px",
                              height: "8px",
                              borderRadius: "50%",
                              backgroundColor: getCategoryColor(activity.category),
                              marginTop: "6px",
                              flexShrink: 0,
                            }}
                          />
                          {/* Time */}
                          <div
                            style={{
                              fontFamily: "var(--font-mono)",
                              fontSize: "var(--text-xs)",
                              color: "var(--fgColor-muted)",
                              minWidth: "72px",
                              flexShrink: 0,
                            }}
                          >
                            {formatTime(activity.createdAt)}
                          </div>
                          {/* Action description */}
                          <div
                            style={{
                              flex: 1,
                              fontFamily: "var(--font-sans)",
                              fontSize: "var(--text-sm)",
                              color: "var(--fgColor-default)",
                              lineHeight: "1.4",
                            }}
                          >
                            {getActionDescription(activity)}
                          </div>
                          {/* Status badge */}
                          <div
                            style={{
                              display: "flex",
                              alignItems: "center",
                              gap: "8px",
                              flexShrink: 0,
                            }}
                          >
                            <span
                              style={{
                                fontFamily: "var(--font-sans)",
                                fontSize: "var(--text-xs)",
                                fontWeight: 500,
                                color:
                                  activity.status === "success"
                                    ? "#05C004"
                                    : activity.status === "failed"
                                      ? "#f85149"
                                      : "var(--fgColor-muted)",
                                textTransform: "capitalize",
                              }}
                            >
                              {activity.status}
                            </span>
                            {activity.ipAddress && (
                              <span
                                style={{
                                  fontFamily: "var(--font-mono)",
                                  fontSize: "var(--text-xs)",
                                  color: "var(--fgColor-muted)",
                                }}
                              >
                                {activity.ipAddress}
                              </span>
                            )}
                          </div>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
