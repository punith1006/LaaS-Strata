"use client";

import { useEffect, useState, useRef, useMemo, useCallback } from "react";
import { useSearchParams, useRouter } from "next/navigation";
import {
  type RequestEntry,
  type UpcomingEntry,
  type LiveSessionEntry,
  type PastEntry as PastEntryApi,
  type StudentProfileDetail,
  getMentorRequests,
  getMentorUpcoming,
  getMentorLive,
  getMentorPast,
  approveMentorSession,
  rejectMentorSession,
  cancelMentorSession,
  getWithdrawableBalance,
  getStudentProfile,
  getSessionJitsiLink,
  type JitsiLinkResult,
  type SessionOverlapResult,
  checkMentorSessionOverlap,
} from "@/lib/api";
import { SupportModal } from "@/components/support/support-modal";

type SessionsSubTab = "requests" | "upcoming" | "past";

const subTabs: { id: SessionsSubTab; label: string }[] = [
  { id: "requests", label: "Requests" },
  { id: "upcoming", label: "Upcoming" },
  { id: "past", label: "Past" },
];

// --- Sub-tab component ---
function SessionsSubTabs({
  activeSubTab,
  onSubTabChange,
}: {
  activeSubTab: SessionsSubTab;
  onSubTabChange: (sub: SessionsSubTab) => void;
}) {
  return (
    <div
      style={{
        position: "relative",
        display: "flex",
        alignItems: "center",
        height: "40px",
        borderBottom: "1px solid var(--borderColor-default)",
        marginTop: "16px",
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
        {subTabs.map((tab) => {
          const isActive = activeSubTab === tab.id;
          return (
            <button
              key={tab.id}
              onClick={() => onSubTabChange(tab.id)}
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
                  color: isActive
                    ? "var(--fgColor-default)"
                    : "var(--fgColor-muted)",
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
  );
}

// --- Duration formatting ---
function formatDuration(minutes: number): string {
  if (minutes < 60) return `${minutes} min`;
  const hrs = minutes / 60;
  return hrs % 1 === 0 ? `${hrs} hr` : `${hrs.toFixed(1)} hrs`;
}

// --- Earnings formatting ---
function formatEarnings(cents: number): string {
  return `\u20B9${(cents / 100).toFixed(2)}`;
}

/** A single label-value row matching the profile page InfoRow style */
function InfoRow({ label, value, valueColor, isLast = false }: { label: string; value: string | React.ReactNode; valueColor?: string; isLast?: boolean }) {
  return (
    <div
      style={{
        display: "flex",
        alignItems: "center",
        gap: "16px",
        minHeight: "48px",
        padding: "0 20px",
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
          fontFamily: "var(--font-sans)",
        }}
      >
        {label}
      </span>
      <span
        style={{
          flex: 1,
          fontSize: "0.875rem",
          fontWeight: 400,
          color: valueColor ?? "var(--fgColor-default)",
          fontFamily: "var(--font-sans)",
        }}
      >
        {value}
      </span>
    </div>
  );
}

/** A small pill tag matching the profile page PillTag style */
function Pill({ label }: { label: string }) {
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
        fontFamily: "var(--font-sans)",
      }}
    >
      {label}
    </span>
  );
}

/** Format a relative time string like analytics dashboard */
function formatRelativeTime(isoString: string | null | undefined): string {
  if (!isoString) return "";
  const d = new Date(isoString);
  if (Number.isNaN(d.getTime())) return "";
  const now = Date.now();
  const diffMs = now - d.getTime();
  const diffMin = Math.floor(diffMs / 60000);
  if (diffMin < 1) return "just now";
  if (diffMin < 60) return `${diffMin}m ago`;
  const diffHr = Math.floor(diffMin / 60);
  if (diffHr < 24) return `${diffHr}h ago`;
  const diffDays = Math.floor(diffHr / 24);
  if (diffDays < 7) return `${diffDays}d ago`;
  return d.toLocaleDateString("en-IN", {
    timeZone: "Asia/Kolkata",
    day: "2-digit",
    month: "short",
  });
}

/** Return background/text colors for expertise level badge */
function getExpertiseColor(level: string): { bg: string; text: string } {
  switch (level.toLowerCase()) {
    case "beginner":
      return { bg: "#D97706", text: "#fff" };
    case "intermediate":
      return { bg: "#0891B2", text: "#fff" };
    case "advanced":
      return { bg: "#7C3AED", text: "#fff" };
    case "expert":
      return { bg: "#B45309", text: "#fff" };
    default:
      return { bg: "var(--bgColor-muted)", text: "var(--fgColor-muted)" };
  }
}

// --- Countdown hook (15-min TTL) ---
const EXPIRY_TTL_MS = 15 * 60 * 1000;

function useCountdown(createdAt: string) {
  const calcRemaining = () => {
    const elapsed = Date.now() - new Date(createdAt).getTime();
    return Math.max(0, EXPIRY_TTL_MS - elapsed);
  };

  const [remaining, setRemaining] = useState(calcRemaining);

  useEffect(() => {
    const timer = setInterval(() => setRemaining(calcRemaining()), 1000);
    return () => clearInterval(timer);
  }, [createdAt]);

  const totalSeconds = Math.floor(remaining / 1000);
  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;
  const isExpired = remaining <= 0;
  const isUrgent = !isExpired && remaining < 60 * 1000;

  return { display: `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`, isExpired, isUrgent };
}

// --- Action Dropdown (same pattern as payment-history-tab) ---
function RequestActionDropdown({
  onApprove,
  onReject,
}: {
  onApprove: () => void;
  onReject: () => void;
}) {
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  return (
    <div ref={dropdownRef} style={{ position: "relative" }}>
      <button
        onClick={(e) => {
                  e.stopPropagation();
                  setIsOpen(!isOpen);
                }}
        style={{
          width: "32px",
          height: "32px",
          borderRadius: "4px",
          backgroundColor: isOpen ? "var(--bgColor-muted)" : "transparent",
          border: "none",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          cursor: "pointer",
          color: "var(--fgColor-muted)",
          transition: "background-color 0.15s ease",
        }}
        onMouseOver={(e) => {
          if (!isOpen) e.currentTarget.style.backgroundColor = "var(--bgColor-muted)";
        }}
        onMouseOut={(e) => {
          if (!isOpen) e.currentTarget.style.backgroundColor = "transparent";
        }}
      >
        <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
          <circle cx="12" cy="5" r="2" />
          <circle cx="12" cy="12" r="2" />
          <circle cx="12" cy="19" r="2" />
        </svg>
      </button>

      {isOpen && (
        <div
          style={{
            position: "absolute",
            top: "100%",
            right: 0,
            marginTop: "4px",
            backgroundColor: "var(--bgColor-elevated, var(--bgColor-default))",
            border: "1px solid var(--borderColor-default)",
            borderRadius: "4px",
            boxShadow: "0 4px 16px rgba(0, 0, 0, 0.15)",
            zIndex: 100,
            minWidth: "160px",
            overflow: "hidden",
          }}
        >
          <button
            onClick={(e) => {
              e.stopPropagation();
              setIsOpen(false);
              onApprove();
            }}
            style={{
              width: "100%",
              display: "flex",
              alignItems: "center",
              gap: "8px",
              padding: "10px 12px",
              backgroundColor: "transparent",
              border: "none",
              cursor: "pointer",
              fontFamily: "var(--font-sans)",
              fontSize: "0.8125rem",
              color: "var(--fgColor-default)",
              textAlign: "left",
              transition: "background-color 0.15s ease",
            }}
            onMouseOver={(e) => {
              e.currentTarget.style.backgroundColor = "var(--bgColor-muted)";
            }}
            onMouseOut={(e) => {
              e.currentTarget.style.backgroundColor = "transparent";
            }}
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <polyline points="20 6 9 17 4 12" />
            </svg>
            Approve
          </button>
          <button
            onClick={(e) => {
              e.stopPropagation();
              setIsOpen(false);
              onReject();
            }}
            style={{
              width: "100%",
              display: "flex",
              alignItems: "center",
              gap: "8px",
              padding: "10px 12px",
              backgroundColor: "transparent",
              border: "none",
              cursor: "pointer",
              fontFamily: "var(--font-sans)",
              fontSize: "0.8125rem",
              color: "var(--fgColor-default)",
              textAlign: "left",
              transition: "background-color 0.15s ease",
            }}
            onMouseOver={(e) => {
              e.currentTarget.style.backgroundColor = "var(--bgColor-muted)";
            }}
            onMouseOut={(e) => {
              e.currentTarget.style.backgroundColor = "transparent";
            }}
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <line x1="18" y1="6" x2="6" y2="18" />
              <line x1="6" y1="6" x2="18" y2="18" />
            </svg>
            Reject
          </button>
        </div>
      )}
    </div>
  );
}

// --- Request Row (separate component so useCountdown runs at top level) ---
function RequestRow({
  req,
  isFirstRow,
  isLastRow,
  firstRowRef,
  isExpanded,
  isCollapsing,
  onApprove,
  onReject,
  onRowClick,
}: {
  req: RequestEntry;
  isFirstRow: boolean;
  isLastRow: boolean;
  firstRowRef: React.RefObject<HTMLDivElement | null>;
  isExpanded: boolean;
  isCollapsing: boolean;
  onApprove: () => void;
  onReject: () => void;
  onRowClick: () => void;
}) {
  const { display, isExpired, isUrgent } = useCountdown(req.createdAt);
  const isActive = isExpanded || isCollapsing;

  return (
    <div
      ref={isFirstRow ? firstRowRef : undefined}
      style={{
        display: "grid",
        gridTemplateColumns: "140px 1fr 120px 90px 100px 90px 90px 50px",
        gap: "12px",
        padding: "12px 20px",
        borderBottom: isActive ? "none" : isLastRow ? "none" : "1px solid var(--borderColor-default)",
        alignItems: "center",
        transition: "background-color 0.1s ease",
        cursor: "pointer",
        backgroundColor: "transparent",
      }}
      onClick={onRowClick}
      onMouseEnter={(e) => {
        e.currentTarget.style.backgroundColor = "var(--bgColor-default)";
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.backgroundColor = "transparent";
      }}
    >
      <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{req.userName}</span>
      <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{req.domain}</span>
      <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{req.serviceType}</span>
      <span style={{ fontFamily: "var(--font-mono, monospace)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{formatDuration(req.durationMinutes)}</span>
      <span style={{ fontFamily: "var(--font-mono, monospace)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{formatEarnings(req.earningsCents)}</span>
      <span style={{ fontFamily: "var(--font-mono, monospace)", fontSize: "0.8125rem", color: isExpired ? "var(--fgColor-muted)" : isUrgent ? "#E70000" : "#FDA422", fontWeight: isUrgent ? 600 : 400 }}>{isExpired ? "Expired" : display}</span>
      <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
        <span style={{ width: "8px", height: "8px", borderRadius: "50%", backgroundColor: isExpired ? "#818178" : "#FDA422" }} />
        <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{isExpired ? "Expired" : "Pending"}</span>
      </div>
      <RequestActionDropdown onApprove={onApprove} onReject={onReject} />
    </div>
  );
}

// --- Requests Table ---
function RequestsTable({
  requests,
  onApprove,
  onReject,
  onRequestExpire,
}: {
  requests: RequestEntry[];
  onApprove: (id: string) => void;
  onReject: (id: string) => void;
  onRequestExpire: (id: string) => void;
}) {
  const expiredRef = useRef<Set<string>>(new Set());

  useEffect(() => {
    const interval = setInterval(() => {
      const now = Date.now();
      requests.forEach((req) => {
        if (!expiredRef.current.has(req.id) && now - new Date(req.createdAt).getTime() >= EXPIRY_TTL_MS) {
          expiredRef.current.add(req.id);
          onRequestExpire(req.id);
        }
      });
    }, 1000);
    return () => clearInterval(interval);
  }, [requests, onRequestExpire]);

  const activeRequests = useMemo(
    () => requests.filter((r) => !expiredRef.current.has(r.id)),
    [requests],
  );

  const ROW_HEIGHT = 48;
  const PAGINATION_ROW_HEIGHT = 52;
  const TABLE_HEADER_HEIGHT = 48;
  const LAYOUT_BUFFER = 12;

  const [page, setPage] = useState(1);
  const [dynamicPageSize, setDynamicPageSize] = useState(10);
  const tableContainerRef = useRef<HTMLDivElement>(null);
  const firstRowRef = useRef<HTMLDivElement>(null);
  const paginationRowRef = useRef<HTMLDivElement>(null);
  const calcLayoutRef = useRef<() => void>(null);

  // Accordion state
  const [expandedRequestId, setExpandedRequestId] = useState<string | null>(null);
  const [collapsingRequestId, setCollapsingRequestId] = useState<string | null>(null);
  const [panelMaxHeight, setPanelMaxHeight] = useState(400);
  const panelRef = useRef<HTMLDivElement>(null);
  const [studentProfile, setStudentProfile] = useState<StudentProfileDetail | null>(null);

  const total = activeRequests.length;
  const totalPages = Math.ceil(total / dynamicPageSize);
  const rangeStart = total === 0 ? 0 : (page - 1) * dynamicPageSize + 1;
  const rangeEnd = Math.min(page * dynamicPageSize, total);
  const pageData = activeRequests.slice((page - 1) * dynamicPageSize, page * dynamicPageSize);

  // Reorder requests when one is expanded
  const orderedRequests = useMemo(() => {
    const activeId = expandedRequestId ?? collapsingRequestId;
    if (!activeId) return pageData;
    const idx = pageData.findIndex((r) => r.id === activeId);
    if (idx === -1) return pageData;
    const expanded = pageData[idx];
    const rest = [...pageData.slice(0, idx), ...pageData.slice(idx + 1)];
    return [expanded, ...rest];
  }, [pageData, expandedRequestId, collapsingRequestId]);

  // Click handler for row expand/collapse
  const handleRowClick = (requestId: string) => {
    if (expandedRequestId === requestId) {
      setCollapsingRequestId(requestId);
      setExpandedRequestId(null);
    } else {
      setCollapsingRequestId(null);
      setExpandedRequestId(requestId);
    }
  };

  useEffect(() => {
    const calcLayout = () => {
      if (!tableContainerRef.current) return;
      const containerTop = tableContainerRef.current.getBoundingClientRect().top;
      const actualRowHeight = firstRowRef.current
        ? firstRowRef.current.getBoundingClientRect().height
        : ROW_HEIGHT;
      const actualPaginationHeight = paginationRowRef.current
        ? paginationRowRef.current.getBoundingClientRect().height
        : PAGINATION_ROW_HEIGHT;
      const headerEl = tableContainerRef.current.firstElementChild as HTMLElement | null;
      const actualHeaderHeight = headerEl
        ? headerEl.getBoundingClientRect().height
        : TABLE_HEADER_HEIGHT;

      const availableForRows =
        window.innerHeight - containerTop - 2 - actualHeaderHeight - actualPaginationHeight - LAYOUT_BUFFER;
      const rows = Math.max(1, Math.floor(availableForRows / actualRowHeight));
      setDynamicPageSize(rows);

      // Panel height: space from expanded row bottom to pagination row top
      const panelH =
        window.innerHeight -
        containerTop -
        2 -
        actualHeaderHeight -
        actualRowHeight -
        actualPaginationHeight -
        8;
      setPanelMaxHeight(Math.max(200, Math.floor(panelH)));
    };
    calcLayout();
    calcLayoutRef.current = calcLayout;
    window.addEventListener("resize", calcLayout);
    return () => window.removeEventListener("resize", calcLayout);
  }, []);

  useEffect(() => { setPage(1); }, [activeRequests.length, dynamicPageSize]);

  useEffect(() => {
    requestAnimationFrame(() => calcLayoutRef.current && calcLayoutRef.current());
  }, [activeRequests.length]);

  // Animate panel open
  useEffect(() => {
    if (expandedRequestId && panelRef.current) {
      const el = panelRef.current;
      el.style.maxHeight = "0px";
      const raf = requestAnimationFrame(() => {
        el.style.maxHeight = `${panelMaxHeight}px`;
      });
      return () => cancelAnimationFrame(raf);
    }
  }, [expandedRequestId, panelMaxHeight]);

  // Collapse animation
  useEffect(() => {
    if (collapsingRequestId && panelRef.current) {
      const el = panelRef.current;
      el.style.maxHeight = "0px";
      const timeout = setTimeout(() => {
        setCollapsingRequestId(null);
      }, 400);
      return () => clearTimeout(timeout);
    }
  }, [collapsingRequestId]);

  // Fetch student profile when accordion expands
  useEffect(() => {
    if (!expandedRequestId) {
      setStudentProfile(null);
      return;
    }
    const req = requests.find(r => r.id === expandedRequestId);
    if (!req?.studentUserId) return;
    let cancelled = false;
    getStudentProfile(req.studentUserId).then(data => {
      if (!cancelled) setStudentProfile(data);
    });
    return () => { cancelled = true; };
  }, [expandedRequestId]);

  return (
    <div>
      <h2
        style={{
          fontFamily: "var(--font-sans)",
          fontSize: "1.25rem",
          fontWeight: 600,
          color: "var(--fgColor-default)",
          margin: "24px 0 16px 0",
        }}
      >
        Session Requests
      </h2>

      <div
        ref={tableContainerRef}
        style={{
          backgroundColor: "var(--bgColor-mild)",
          border: "1px solid var(--borderColor-default)",
          borderRadius: "4px",
          overflow: "visible",
        }}
      >
        {/* Table header */}
        <div
          style={{
            display: "grid",
            gridTemplateColumns: "140px 1fr 120px 90px 100px 90px 90px 50px",
            gap: "12px",
            padding: "12px 20px",
            borderBottom: "1px solid var(--borderColor-default)",
            backgroundColor: "var(--bgColor-muted)",
          }}
        >
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>User</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Domain</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Service</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Duration</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Earnings</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Expires In</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Status</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Actions</span>
        </div>

        {(activeRequests.length === 0) ? (
          /* Empty row */
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "1fr",
              padding: "48px 24px",
              textAlign: "center",
              justifyItems: "center",
            }}
          >
            <div>
              <svg
                width="48"
                height="48"
                viewBox="0 0 24 24"
                fill="none"
                stroke="var(--fgColor-muted)"
                strokeWidth="1.5"
                strokeLinecap="round"
                strokeLinejoin="round"
                style={{ margin: "0 auto 16px", display: "block" }}
              >
                <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
                <line x1="16" y1="2" x2="16" y2="6" />
                <line x1="8" y1="2" x2="8" y2="6" />
                <line x1="3" y1="10" x2="21" y2="10" />
              </svg>
              <h3
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "1rem",
                  fontWeight: 600,
                  color: "var(--fgColor-default)",
                  margin: "0 0 8px 0",
                }}
              >
                No pending requests
              </h3>
              <p
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "0.875rem",
                  color: "var(--fgColor-muted)",
                  margin: 0,
                }}
              >
                You don&apos;t have any pending session requests right now.
              </p>
            </div>
          </div>
        ) : (
          /* Table rows */
          orderedRequests.map((s, idx) => {
            const isExpanded = expandedRequestId === s.id;
            const isCollapsing = collapsingRequestId === s.id;
            return (
              <div key={s.id}>
                <RequestRow
                  req={s}
                  isFirstRow={idx === 0}
                  isLastRow={idx === orderedRequests.length - 1}
                  firstRowRef={firstRowRef}
                  isExpanded={isExpanded}
                  isCollapsing={isCollapsing}
                  onApprove={() => onApprove(s.id)}
                  onReject={() => onReject(s.id)}
                  onRowClick={() => handleRowClick(s.id)}
                />
                {/* Expanded Panel */}
                {(isExpanded || isCollapsing) && (
                  <div
                    ref={panelRef}
                    style={{
                      maxHeight: "0px",
                      overflowY: "auto",
                      transition: "max-height 0.35s cubic-bezier(0.4, 0, 0.2, 1)",
                      backgroundColor: "var(--bgColor-default)",
                      borderBottom: "1px solid var(--borderColor-default)",
                    }}
                  >
                    <div style={{ padding: "24px" }}>
                      {/* Identity Bar — matching analytics dashboard exactly, email+verified replaces name+sso */}
                      <div
                        style={{
                          display: "grid",
                          gridTemplateColumns: "1fr auto",
                          gap: "24px",
                          padding: "16px",
                          background: "var(--bgColor-mild)",
                          borderRadius: "6px",
                          border: "1px solid var(--borderColor-default)",
                        }}
                      >
                        {/* Left Column: Avatar + Email + Status */}
                        <div style={{ display: "flex", alignItems: "center", gap: "16px", overflow: "hidden" }}>
                          <div
                            style={{
                              width: "48px",
                              height: "48px",
                              borderRadius: "50%",
                              background: "var(--bgColor-muted)",
                              display: "flex",
                              alignItems: "center",
                              justifyContent: "center",
                              flexShrink: 0,
                            }}
                          >
                            <span
                              style={{
                                fontFamily: "var(--font-sans)",
                                fontSize: "1.125rem",
                                fontWeight: 600,
                                color: "var(--fgColor-default)",
                              }}
                            >
                              {studentProfile?.email?.charAt(0)?.toUpperCase() || "?"}
                            </span>
                          </div>
                          <div>
                            <div style={{ display: "flex", alignItems: "center", gap: "8px", flexWrap: "wrap" }}>
                              <span
                                style={{
                                  fontFamily: "var(--font-sans)",
                                  fontSize: "1rem",
                                  fontWeight: 600,
                                  color: "var(--fgColor-default)",
                                }}
                              >
                                {studentProfile?.email || "Loading..."}
                              </span>
                              {studentProfile?.emailVerified && (
                                <span
                                  style={{
                                    display: "inline-flex",
                                    padding: "2px 8px",
                                    borderRadius: "9999px",
                                    fontSize: "0.6875rem",
                                    fontWeight: 500,
                                    fontFamily: "var(--font-sans)",
                                    background: "#059669",
                                    color: "#fff",
                                  }}
                                >
                                  Verified
                                </span>
                              )}
                            </div>
                            <div style={{ display: "flex", alignItems: "center", gap: "6px", marginTop: "6px", flexWrap: "wrap" }}>
                              <span
                                style={{
                                  width: 8,
                                  height: 8,
                                  borderRadius: "50%",
                                  backgroundColor: "#818178",
                                  flexShrink: 0,
                                }}
                              />
                              <span
                                style={{
                                  fontFamily: "var(--font-sans)",
                                  fontSize: "0.8125rem",
                                  color: "var(--fgColor-muted)",
                                }}
                              >
                                Offline
                              </span>
                              <span style={{ color: "var(--fgColor-muted)", fontSize: "0.8125rem" }}>·</span>
                              <span
                                style={{
                                  fontFamily: "var(--font-sans)",
                                  fontSize: "0.8125rem",
                                  color: "var(--fgColor-muted)",
                                }}
                              >
                                {studentProfile?.lastLoginAt
                                  ? `Last login ${formatRelativeTime(studentProfile.lastLoginAt)}`
                                  : "Never logged in"}
                              </span>
                            </div>
                          </div>
                        </div>

                        {/* Right Column: Academic details */}
                        {(studentProfile?.collegeName || studentProfile?.courseName) && (
                          <div style={{ display: "flex", alignItems: "flex-start", gap: "32px", minWidth: 0 }}>
                            {/* Institution + Department stacked */}
                            <div style={{ flex: 1, minWidth: 0 }}>
                              {studentProfile.collegeName && (
                                <div style={{ fontFamily: "var(--font-sans)", fontSize: "0.9375rem", fontWeight: 500, color: "var(--fgColor-default)", lineHeight: 1.4, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                                  {studentProfile.collegeName}
                                </div>
                              )}
                              {studentProfile.departmentName && (
                                <div style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)", lineHeight: 1.4, marginTop: "2px", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                                  {studentProfile.departmentName}
                                </div>
                              )}
                            </div>
                            {/* Course + Expertise tag */}
                            <div style={{ textAlign: "right", flexShrink: 0 }}>
                              {studentProfile.courseName && (
                                <div style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)", lineHeight: 1.4 }}>
                                  {studentProfile.courseName}{studentProfile.academicYear ? ` \u00B7 Year ${studentProfile.academicYear}` : ""}
                                </div>
                              )}
                              {studentProfile.expertiseLevel && (
                                <span style={{ display: "inline-block", fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, padding: "3px 12px", borderRadius: "4px", marginTop: "6px", background: getExpertiseColor(studentProfile.expertiseLevel).bg, color: getExpertiseColor(studentProfile.expertiseLevel).text }}>
                                  {studentProfile.expertiseLevel}
                                </span>
                              )}
                            </div>
                          </div>
                        )}
                      </div>

                      {/* 2-Column Grid: Account | Socials */}
                      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "16px", marginTop: "20px" }}>
                        {/* Account Section */}
                        <div style={{ border: "1px solid var(--borderColor-default)", borderRadius: "4px", overflow: "hidden", background: "var(--bgColor-mild)" }}>
                          <div
                            style={{
                              background: "var(--bgColor-muted)",
                              padding: "0 20px",
                              height: "40px",
                              display: "flex",
                              alignItems: "center",
                              borderBottom: "1px solid var(--borderColor-default)",
                            }}
                          >
                            <span
                              style={{
                                fontSize: "0.75rem",
                                fontWeight: 500,
                                textTransform: "uppercase",
                                letterSpacing: "0.06em",
                                color: "var(--fgColor-default)",
                                fontFamily: "var(--font-sans)",
                              }}
                            >
                              Account
                            </span>
                          </div>
                          <div style={{ padding: "0", background: "var(--bgColor-mild)" }}>
                            <InfoRow label="Phone" value={studentProfile?.phone || "Not set"} isLast={false} />
                            <InfoRow label="Profession" value={studentProfile?.profession || "Not set"} isLast={!studentProfile?.skills?.length} />
                            {studentProfile?.skills && studentProfile.skills.length > 0 && (
                              <div style={{ borderTop: "1px solid var(--borderColor-default)", padding: "12px 20px" }}>
                                <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", color: "var(--fgColor-muted)", fontWeight: 400, display: "block", marginBottom: "8px" }}>
                                  Skills
                                </span>
                                <div style={{ display: "flex", flexWrap: "wrap", gap: "4px" }}>
                                  {studentProfile.skills.map((skill: string) => (
                                    <Pill key={skill} label={skill} />
                                  ))}
                                </div>
                              </div>
                            )}
                          </div>
                        </div>

                        {/* Socials Section */}
                        <div style={{ border: "1px solid var(--borderColor-default)", borderRadius: "4px", overflow: "hidden", background: "var(--bgColor-mild)" }}>
                          <div
                            style={{
                              background: "var(--bgColor-muted)",
                              padding: "0 20px",
                              height: "40px",
                              display: "flex",
                              alignItems: "center",
                              borderBottom: "1px solid var(--borderColor-default)",
                            }}
                          >
                            <span
                              style={{
                                fontSize: "0.75rem",
                                fontWeight: 500,
                                textTransform: "uppercase",
                                letterSpacing: "0.06em",
                                color: "var(--fgColor-default)",
                                fontFamily: "var(--font-sans)",
                              }}
                            >
                              Socials
                            </span>
                          </div>
                          <div style={{ padding: "0", background: "var(--bgColor-mild)" }}>
                            <InfoRow label="GitHub" value={studentProfile?.githubUrl || "Not set"} isLast={false} />
                            <InfoRow label="LinkedIn" value={studentProfile?.linkedinUrl || "Not set"} isLast={false} />
                            <InfoRow label="Website" value={studentProfile?.websiteUrl || "Not set"} isLast={true} />
                          </div>
                        </div>
                      </div>

                      {/* Session Info Section */}
                      {(s.subject || s.studentNotes || s.attachmentFileName) && (
                        <div style={{ marginTop: "20px", border: "1px solid var(--borderColor-default)", borderRadius: "4px", overflow: "hidden", background: "var(--bgColor-mild)" }}>
                          <div style={{ background: "var(--bgColor-muted)", padding: "0 20px", height: "40px", display: "flex", alignItems: "center", borderBottom: "1px solid var(--borderColor-default)" }}>
                            <span style={{ fontSize: "0.75rem", fontWeight: 500, textTransform: "uppercase", letterSpacing: "0.06em", color: "var(--fgColor-default)", fontFamily: "var(--font-sans)" }}>
                              Session Info
                            </span>
                          </div>
                          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "16px" }}>
                            {/* Left column: Subject + Description */}
                            <div style={{ padding: "16px 20px", display: "flex", flexDirection: "column", gap: "12px" }}>
                              {s.subject && (
                                <div>
                                  <span style={{ fontSize: "0.75rem", color: "var(--fgColor-muted)", fontWeight: 400, display: "block", marginBottom: "4px", fontFamily: "var(--font-sans)" }}>Subject</span>
                                  <span style={{ fontSize: "0.875rem", color: "var(--fgColor-default)", fontFamily: "var(--font-sans)" }}>{s.subject}</span>
                                </div>
                              )}
                              {s.studentNotes && (
                                <div>
                                  <span style={{ fontSize: "0.75rem", color: "var(--fgColor-muted)", fontWeight: 400, display: "block", marginBottom: "4px", fontFamily: "var(--font-sans)" }}>Description</span>
                                  <span style={{ fontSize: "0.875rem", color: "var(--fgColor-default)", fontFamily: "var(--font-sans)", lineHeight: 1.5 }}>{s.studentNotes}</span>
                                </div>
                              )}
                            </div>
                            {/* Right column: Attachments */}
                            <div style={{ padding: "16px 20px" }}>
                              <span style={{ fontSize: "0.75rem", color: "var(--fgColor-muted)", fontWeight: 400, display: "block", marginBottom: "4px", fontFamily: "var(--font-sans)" }}>Attachments</span>
                              {s.attachmentFileName ? (
                                <a href={`/api/mentor-sessions/attachment/${s.id}`} download style={{ display: "inline-flex", alignItems: "center", gap: "8px", textDecoration: "none", color: "var(--fgColor-default)", fontSize: "0.8125rem", fontFamily: "var(--font-sans)", cursor: "pointer" }}>
                                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                                    <polyline points="7 10 12 15 17 10" />
                                    <line x1="12" y1="15" x2="12" y2="3" />
                                  </svg>
                                  {s.attachmentFileName}
                                </a>
                              ) : (
                                <span style={{ fontSize: "0.8125rem", color: "var(--fgColor-muted)", fontStyle: "italic", fontFamily: "var(--font-sans)" }}>No attachments</span>
                              )}
                            </div>
                          </div>
                        </div>
                      )}
                    </div>
                  </div>
                )}
              </div>
            );
          })
        )}
      </div>

      {total > 0 && (
        <div
          ref={paginationRowRef}
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            marginTop: "16px",
            padding: "0 4px",
          }}
        >
          <span
            style={{
              fontFamily: "var(--font-sans)",
              fontSize: "0.875rem",
              color: "var(--fgColor-muted)",
            }}
          >
            Showing {rangeStart}-{rangeEnd} of{" "}
            {total.toLocaleString("en-IN")}
          </span>

          <div style={{ display: "flex", gap: "8px" }}>
            <button
              type="button"
              onClick={() => setPage((p) => Math.max(1, p - 1))}
              disabled={page <= 1}
              style={{
                padding: "6px 12px",
                backgroundColor: "var(--bgColor-muted)",
                border: "1px solid var(--borderColor-default)",
                borderRadius: "4px",
                fontFamily: "var(--font-sans)",
                fontSize: "0.8125rem",
                color:
                  page <= 1
                    ? "var(--fgColor-muted)"
                    : "var(--fgColor-default)",
                cursor:
                  page <= 1 ? "not-allowed" : "pointer",
                opacity: page <= 1 ? 0.5 : 1,
                transition: "background-color 0.15s ease",
              }}
              onMouseOver={(e) => {
                if (page > 1)
                  e.currentTarget.style.backgroundColor =
                    "var(--bgColor-mild)";
              }}
              onMouseOut={(e) => {
                e.currentTarget.style.backgroundColor =
                  "var(--bgColor-muted)";
              }}
            >
              Previous
            </button>
            <button
              type="button"
              onClick={() =>
                setPage((p) => Math.min(totalPages || 1, p + 1))
              }
              disabled={page >= totalPages || totalPages === 0}
              style={{
                padding: "6px 12px",
                backgroundColor: "var(--bgColor-muted)",
                border: "1px solid var(--borderColor-default)",
                borderRadius: "4px",
                fontFamily: "var(--font-sans)",
                fontSize: "0.8125rem",
                color:
                  page >= totalPages || totalPages === 0
                    ? "var(--fgColor-muted)"
                    : "var(--fgColor-default)",
                cursor:
                  page >= totalPages || totalPages === 0
                    ? "not-allowed"
                    : "pointer",
                opacity:
                  page >= totalPages || totalPages === 0 ? 0.5 : 1,
                transition: "background-color 0.15s ease",
              }}
              onMouseOver={(e) => {
                if (page < totalPages && totalPages > 0)
                  e.currentTarget.style.backgroundColor =
                    "var(--bgColor-mild)";
              }}
              onMouseOut={(e) => {
                e.currentTarget.style.backgroundColor =
                  "var(--bgColor-muted)";
              }}
            >
              Next
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

// --- Upcoming Action Dropdown (same billing page pattern) ---
function UpcomingActionDropdown({
  onReschedule,
  onCancel,
}: {
  onReschedule: () => void;
  onCancel: () => void;
}) {
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  return (
    <div ref={dropdownRef} style={{ position: "relative" }}>
      <button
        onClick={(e) => {
                  e.stopPropagation();
                  setIsOpen(!isOpen);
                }}
        style={{
          width: "32px",
          height: "32px",
          borderRadius: "4px",
          backgroundColor: isOpen ? "var(--bgColor-muted)" : "transparent",
          border: "none",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          cursor: "pointer",
          color: "var(--fgColor-muted)",
          transition: "background-color 0.15s ease",
        }}
        onMouseOver={(e) => {
          if (!isOpen) e.currentTarget.style.backgroundColor = "var(--bgColor-muted)";
        }}
        onMouseOut={(e) => {
          if (!isOpen) e.currentTarget.style.backgroundColor = "transparent";
        }}
      >
        <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
          <circle cx="12" cy="5" r="2" />
          <circle cx="12" cy="12" r="2" />
          <circle cx="12" cy="19" r="2" />
        </svg>
      </button>

      {isOpen && (
        <div
          style={{
            position: "absolute",
            top: "100%",
            right: 0,
            marginTop: "4px",
            backgroundColor: "var(--bgColor-elevated, var(--bgColor-default))",
            border: "1px solid var(--borderColor-default)",
            borderRadius: "4px",
            boxShadow: "0 4px 16px rgba(0, 0, 0, 0.15)",
            zIndex: 100,
            minWidth: "160px",
            overflow: "hidden",
          }}
        >
          <button
            disabled
            style={{
              width: "100%",
              display: "flex",
              alignItems: "center",
              gap: "8px",
              padding: "10px 12px",
              backgroundColor: "transparent",
              border: "none",
              cursor: "not-allowed",
              fontFamily: "var(--font-sans)",
              fontSize: "0.8125rem",
              color: "var(--fgColor-muted)",
              textAlign: "left",
              opacity: 0.5,
            }}
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
              <line x1="16" y1="2" x2="16" y2="6" />
              <line x1="8" y1="2" x2="8" y2="6" />
              <line x1="3" y1="10" x2="21" y2="10" />
              <line x1="12" y1="14" x2="12" y2="18" />
              <line x1="10" y1="16" x2="14" y2="16" />
            </svg>
            Reschedule
          </button>
          <button
            onClick={(e) => {
              e.stopPropagation();
              setIsOpen(false);
              onCancel();
            }}
            style={{
              width: "100%",
              display: "flex",
              alignItems: "center",
              gap: "8px",
              padding: "10px 12px",
              backgroundColor: "transparent",
              border: "none",
              cursor: "pointer",
              fontFamily: "var(--font-sans)",
              fontSize: "0.8125rem",
              color: "var(--fgColor-default)",
              textAlign: "left",
              transition: "background-color 0.15s ease",
            }}
            onMouseOver={(e) => {
              e.currentTarget.style.backgroundColor = "var(--bgColor-muted)";
            }}
            onMouseOut={(e) => {
              e.currentTarget.style.backgroundColor = "transparent";
            }}
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <line x1="18" y1="6" x2="6" y2="18" />
              <line x1="6" y1="6" x2="18" y2="18" />
            </svg>
            Cancel
          </button>
        </div>
      )}
    </div>
  );
}

function parseDateToSortKey(dateStr: string): string {
  // "22 May 2026" -> "2026-05-22" for string comparison
  const months: Record<string, string> = {
    Jan: "01", Feb: "02", Mar: "03", Apr: "04", May: "05", Jun: "06",
    Jul: "07", Aug: "08", Sep: "09", Oct: "10", Nov: "11", Dec: "12",
  };
  const parts = dateStr.split(" ");
  if (parts.length !== 3) return dateStr;
  const [day, month, year] = parts;
  return `${year}-${months[month] || "00"}-${day.padStart(2, "0")}`;
}

function formatElapsed(startedAt: string): string {
  const diff = Date.now() - new Date(startedAt).getTime();
  const totalSeconds = Math.floor(diff / 1000);
  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;
  return `${minutes}m ${String(seconds).padStart(2, "0")}s`;
}

/** Format remaining time until session end */
function formatRemaining(startedAt: string, durationMinutes: number): string {
  const endTime = new Date(startedAt).getTime() + durationMinutes * 60 * 1000;
  const diff = endTime - Date.now();
  if (diff <= 0) return "0m 00s";
  const totalSeconds = Math.floor(diff / 1000);
  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;
  return `${minutes}m ${String(seconds).padStart(2, "0")}s`;
}

// --- Live Action Dropdown (Report option) ---
function LiveActionDropdown({ onReport }: { onReport: () => void }) {
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  return (
    <div ref={dropdownRef} onClick={(e) => e.stopPropagation()} style={{ position: "relative" }}>
      <button
        onClick={(e) => {
                  e.stopPropagation();
                  setIsOpen(!isOpen);
                }}
        style={{
          width: "32px",
          height: "32px",
          borderRadius: "4px",
          backgroundColor: isOpen ? "var(--bgColor-muted)" : "transparent",
          border: "none",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          cursor: "pointer",
          color: "var(--fgColor-muted)",
          transition: "background-color 0.15s ease",
        }}
        onMouseOver={(e) => {
          if (!isOpen) e.currentTarget.style.backgroundColor = "var(--bgColor-muted)";
        }}
        onMouseOut={(e) => {
          if (!isOpen) e.currentTarget.style.backgroundColor = "transparent";
        }}
      >
        <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
          <circle cx="12" cy="5" r="2" />
          <circle cx="12" cy="12" r="2" />
          <circle cx="12" cy="19" r="2" />
        </svg>
      </button>

      {isOpen && (
        <div
          style={{
            position: "absolute",
            top: "100%",
            right: 0,
            marginTop: "4px",
            backgroundColor: "var(--bgColor-elevated, var(--bgColor-default))",
            border: "1px solid var(--borderColor-default)",
            borderRadius: "4px",
            boxShadow: "0 4px 16px rgba(0, 0, 0, 0.15)",
            zIndex: 100,
            minWidth: "160px",
            overflow: "hidden",
          }}
        >
          <button
            onClick={(e) => {
              e.stopPropagation();
              setIsOpen(false);
              onReport();
            }}
            style={{
              width: "100%",
              display: "flex",
              alignItems: "center",
              gap: "8px",
              padding: "10px 12px",
              backgroundColor: "transparent",
              border: "none",
              cursor: "pointer",
              fontFamily: "var(--font-sans)",
              fontSize: "0.8125rem",
              color: "var(--fgColor-default)",
              textAlign: "left",
              transition: "background-color 0.15s ease",
            }}
            onMouseOver={(e) => {
              e.currentTarget.style.backgroundColor = "var(--bgColor-muted)";
            }}
            onMouseOut={(e) => {
              e.currentTarget.style.backgroundColor = "transparent";
            }}
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z" />
              <line x1="4" y1="22" x2="4" y2="15" />
            </svg>
            Report
          </button>
        </div>
      )}
    </div>
  );
}

// --- Live Session Section ---
function LiveSessionSection({ sessions, tick: _tick }: { sessions: LiveSessionEntry[]; tick: number }) {
  const [showSupportModal, setShowSupportModal] = useState(false);
  const handleReport = (id: string) => {
    setShowSupportModal(true);
  };

  const handleJoinNow = async (sessionId: string) => {
    const result = await getSessionJitsiLink(sessionId);
    if (result?.meetingUrl) window.open(result.meetingUrl, '_blank');
  };

  // Accordion state
  const [expandedSessionId, setExpandedSessionId] = useState<string | null>(null);
  const [collapsingSessionId, setCollapsingSessionId] = useState<string | null>(null);
  const [panelMaxHeight, setPanelMaxHeight] = useState(400);
  const panelRef = useRef<HTMLDivElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  const [studentProfile, setStudentProfile] = useState<StudentProfileDetail | null>(null);

  // Click handler for row expand/collapse
  const handleRowClick = (sessionId: string) => {
    if (expandedSessionId === sessionId) {
      setCollapsingSessionId(sessionId);
      setExpandedSessionId(null);
    } else {
      setCollapsingSessionId(null);
      setExpandedSessionId(sessionId);
    }
  };

  // Reorder sessions when one is expanded: expanded row moves to top
  const orderedSessions = useMemo(() => {
    const activeId = expandedSessionId ?? collapsingSessionId;
    if (!activeId) return sessions;
    const idx = sessions.findIndex((s) => s.id === activeId);
    if (idx === -1) return sessions;
    const expanded = sessions[idx];
    const rest = [...sessions.slice(0, idx), ...sessions.slice(idx + 1)];
    return [expanded, ...rest];
  }, [sessions, expandedSessionId, collapsingSessionId]);

  // Panel height based on container position
  useEffect(() => {
    if (!containerRef.current) return;
    const calcPanelHeight = () => {
      const containerTop = containerRef.current?.getBoundingClientRect().top ?? 0;
      const panelH =
        window.innerHeight - containerTop - 60;
      setPanelMaxHeight(Math.max(200, Math.floor(panelH)));
    };
    calcPanelHeight();
    window.addEventListener("resize", calcPanelHeight);
    return () => window.removeEventListener("resize", calcPanelHeight);
  }, []);

  // Animate panel open
  useEffect(() => {
    if (expandedSessionId && panelRef.current) {
      const el = panelRef.current;
      el.style.maxHeight = "0px";
      const raf = requestAnimationFrame(() => {
        el.style.maxHeight = `${panelMaxHeight}px`;
      });
      return () => cancelAnimationFrame(raf);
    }
  }, [expandedSessionId, panelMaxHeight]);

  // Collapse animation
  useEffect(() => {
    if (collapsingSessionId && panelRef.current) {
      const el = panelRef.current;
      el.style.maxHeight = "0px";
      const timeout = setTimeout(() => {
        setCollapsingSessionId(null);
      }, 400);
      return () => clearTimeout(timeout);
    }
  }, [collapsingSessionId]);

  // Fetch student profile when accordion expands
  useEffect(() => {
    if (!expandedSessionId) {
      setStudentProfile(null);
      return;
    }
    const session = sessions.find(s => s.id === expandedSessionId);
    if (!session?.studentUserId) return;
    let cancelled = false;
    getStudentProfile(session.studentUserId).then(data => {
      if (!cancelled) setStudentProfile(data);
    });
    return () => { cancelled = true; };
  }, [expandedSessionId]);

  return (
    <>
      <style>{`
        @keyframes liveBlink {
          0%, 100% { opacity: 1; }
          50% { opacity: 0.2; }
        }
      `}</style>
      <div ref={containerRef} style={{ marginBottom: "32px" }}>
      <h2
        style={{
          fontFamily: "var(--font-sans)",
          fontSize: "1.25rem",
          fontWeight: 600,
          color: "var(--fgColor-default)",
          margin: "24px 0 16px 0",
        }}
      >
        Live Session
      </h2>

      <div
        style={{
          backgroundColor: "var(--bgColor-mild)",
          border: "1px solid var(--borderColor-default)",
          borderRadius: "4px",
          overflow: "visible",
        }}
      >
        {/* Table header */}
        <div
          style={{
            display: "grid",
            gridTemplateColumns: "140px 1fr 100px 100px 80px 100px 80px 50px",
            gap: "12px",
            padding: "12px 20px",
            borderBottom: "1px solid var(--borderColor-default)",
            backgroundColor: "var(--bgColor-muted)",
          }}
        >
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>User</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Domain</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Service</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em", whiteSpace: "nowrap" }}>Time Remaining</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Duration</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Earnings</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Status</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Actions</span>
        </div>

        {/* Table rows */}
        {orderedSessions.map((s, idx) => {
          const isExpanded = expandedSessionId === s.id;
          const isCollapsing = collapsingSessionId === s.id;
          const isActive = isExpanded || isCollapsing;
          return (
            <div key={s.id}>
              {/* Row */}
              <div
                style={{
                  display: "grid",
                  gridTemplateColumns: "140px 1fr 100px 100px 80px 100px 80px 50px",
                  gap: "12px",
                  padding: "12px 20px",
                  borderBottom: isActive ? "none" : idx < orderedSessions.length - 1 ? "1px solid var(--borderColor-default)" : "none",
                  alignItems: "center",
                  transition: "background-color 0.1s ease",
                  cursor: "pointer",
                  backgroundColor: "transparent",
                }}
                onClick={() => handleRowClick(s.id)}
                onMouseEnter={(e) => {
                  e.currentTarget.style.backgroundColor = "var(--bgColor-default)";
                }}
                onMouseLeave={(e) => {
                  e.currentTarget.style.backgroundColor = "transparent";
                }}
              >
                {/* User */}
                <span
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.8125rem",
                    color: "var(--fgColor-default)",
                  }}
                >
                  {s.userName}
                </span>

                {/* Domain */}
                <span
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.8125rem",
                    color: "var(--fgColor-default)",
                    overflow: "hidden",
                    textOverflow: "ellipsis",
                    whiteSpace: "nowrap",
                  }}
                >
                  {s.domain}
                </span>

                {/* Service Type */}
                <span
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.8125rem",
                    color: "var(--fgColor-default)",
                  }}
                >
                  {s.serviceType}
                </span>

                {/* Time Remaining */}
                <span
                  style={{
                    fontFamily: "var(--font-mono, monospace)",
                    fontSize: "0.8125rem",
                    color: "var(--fgColor-default)",
                  }}
                >
                  {formatRemaining(s.startedAt, s.durationMinutes)}
                </span>

                {/* Duration */}
                <span
                  style={{
                    fontFamily: "var(--font-mono, monospace)",
                    fontSize: "0.8125rem",
                    color: "var(--fgColor-default)",
                  }}
                >
                  {s.durationMinutes} min
                </span>

                {/* Earnings */}
                <span
                  style={{
                    fontFamily: "var(--font-mono, monospace)",
                    fontSize: "0.8125rem",
                    color: "var(--fgColor-default)",
                  }}
                >
                  {`\u20B9${(s.earningsCents / 100).toFixed(2)}`}
                </span>

                {/* Status */}
                <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
                  <span
                    style={{
                      width: "8px",
                      height: "8px",
                      borderRadius: "50%",
                      backgroundColor: "#05C004",
                      animation: "liveBlink 1.5s ease-in-out infinite",
                    }}
                  />
                  <span
                    style={{
                      fontFamily: "var(--font-sans)",
                      fontSize: "0.8125rem",
                      color: "var(--fgColor-default)",
                    }}
                  >
                    Live
                  </span>
                </div>

                {/* Actions */}
                <LiveActionDropdown
                  onReport={() => handleReport(s.id)}
                />
              </div>

              {/* Expanded Panel */}
              {(isExpanded || isCollapsing) && (
                <div
                  ref={panelRef}
                  style={{
                    maxHeight: "0px",
                    overflowY: "auto",
                    transition: "max-height 0.35s cubic-bezier(0.4, 0, 0.2, 1)",
                    backgroundColor: "var(--bgColor-default)",
                    borderBottom: "1px solid var(--borderColor-default)",
                  }}
                >
                  <div style={{ padding: "24px" }}>
                                          {/* Join Now */}
                      <div style={{ display: "flex", justifyContent: "flex-end", marginBottom: "16px" }}>
                        <button
                          onClick={(e) => { e.stopPropagation(); handleJoinNow(s.id); }}
                          style={{
                            backgroundColor: "var(--fgColor-default)",
                            color: "var(--bgColor-default)",
                            border: "1px solid var(--fgColor-default)",
                            borderRadius: "4px",
                            padding: "0 20px",
                            height: "36px",
                            cursor: "pointer",
                            fontWeight: 500,
                            fontFamily: "var(--font-sans)",
                            fontSize: "0.875rem",
                            whiteSpace: "nowrap",
                            transition: "opacity 0.15s ease",
                          }}
                          onMouseEnter={(e) => { e.currentTarget.style.opacity = "0.85"; }}
                          onMouseLeave={(e) => { e.currentTarget.style.opacity = "1"; }}
                        >
                          Join Now
                        </button>
                      </div>
                    
{/* Identity Bar — matching analytics dashboard exactly, email+verified replaces name+sso */}
                    <div
                      style={{
                        display: "grid",
                        gridTemplateColumns: "1fr auto",
                        gap: "24px",
                        padding: "16px",
                        background: "var(--bgColor-mild)",
                        borderRadius: "6px",
                        border: "1px solid var(--borderColor-default)",
                      }}
                    >
                      {/* Left Column: Avatar + Email + Status */}
                      <div style={{ display: "flex", alignItems: "center", gap: "16px", overflow: "hidden" }}>
                        <div
                          style={{
                            width: "48px",
                            height: "48px",
                            borderRadius: "50%",
                            background: "var(--bgColor-muted)",
                            display: "flex",
                            alignItems: "center",
                            justifyContent: "center",
                            flexShrink: 0,
                          }}
                        >
                          <span
                            style={{
                              fontFamily: "var(--font-sans)",
                              fontSize: "1.125rem",
                              fontWeight: 600,
                              color: "var(--fgColor-default)",
                            }}
                          >
                            {studentProfile?.email?.charAt(0)?.toUpperCase() || "?"}
                          </span>
                        </div>
                        <div>
                          <div style={{ display: "flex", alignItems: "center", gap: "8px", flexWrap: "wrap" }}>
                            <span
                              style={{
                                fontFamily: "var(--font-sans)",
                                fontSize: "1rem",
                                fontWeight: 600,
                                color: "var(--fgColor-default)",
                              }}
                            >
                              {studentProfile?.email || "Loading..."}
                            </span>
                            {studentProfile?.emailVerified && (
                              <span
                                style={{
                                  display: "inline-flex",
                                  padding: "2px 8px",
                                  borderRadius: "9999px",
                                  fontSize: "0.6875rem",
                                  fontWeight: 500,
                                  fontFamily: "var(--font-sans)",
                                  background: "#059669",
                                  color: "#fff",
                                }}
                              >
                                Verified
                              </span>
                            )}
                          </div>
                          <div style={{ display: "flex", alignItems: "center", gap: "6px", marginTop: "6px", flexWrap: "wrap" }}>
                            <span
                              style={{
                                width: 8,
                                height: 8,
                                borderRadius: "50%",
                                backgroundColor: "#818178",
                                flexShrink: 0,
                              }}
                            />
                            <span
                              style={{
                                fontFamily: "var(--font-sans)",
                                fontSize: "0.8125rem",
                                color: "var(--fgColor-muted)",
                              }}
                            >
                              Offline
                            </span>
                            <span style={{ color: "var(--fgColor-muted)", fontSize: "0.8125rem" }}>·</span>
                            <span
                              style={{
                                fontFamily: "var(--font-sans)",
                                fontSize: "0.8125rem",
                                color: "var(--fgColor-muted)",
                              }}
                            >
                              {studentProfile?.lastLoginAt
                                ? `Last login ${formatRelativeTime(studentProfile.lastLoginAt)}`
                                : "Never logged in"}
                            </span>
                          </div>
                        </div>
                      </div>

                      {/* Right Column: Academic details */}
                      {(studentProfile?.collegeName || studentProfile?.courseName) && (
                        <div style={{ display: "flex", alignItems: "flex-start", gap: "32px", minWidth: 0 }}>
                          <div style={{ flex: 1, minWidth: 0 }}>
                            {studentProfile.collegeName && (
                              <div style={{ fontFamily: "var(--font-sans)", fontSize: "0.9375rem", fontWeight: 500, color: "var(--fgColor-default)", lineHeight: 1.4, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                                {studentProfile.collegeName}
                              </div>
                            )}
                            {studentProfile.departmentName && (
                              <div style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)", lineHeight: 1.4, marginTop: "2px", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                                {studentProfile.departmentName}
                              </div>
                            )}
                          </div>
                          <div style={{ textAlign: "right", flexShrink: 0 }}>
                            {studentProfile.courseName && (
                              <div style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)", lineHeight: 1.4 }}>
                                {studentProfile.courseName}{studentProfile.academicYear ? ` \u00B7 Year ${studentProfile.academicYear}` : ""}
                              </div>
                            )}
                            {studentProfile.expertiseLevel && (
                              <span style={{ display: "inline-block", fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, padding: "3px 12px", borderRadius: "4px", marginTop: "6px", background: getExpertiseColor(studentProfile.expertiseLevel).bg, color: getExpertiseColor(studentProfile.expertiseLevel).text }}>
                                {studentProfile.expertiseLevel}
                              </span>
                            )}
                          </div>
                        </div>
                      )}
                    </div>

                    {/* 2-Column Grid: Account | Socials */}
                    <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "16px", marginTop: "20px" }}>
                      {/* Account Section */}
                      <div style={{ border: "1px solid var(--borderColor-default)", borderRadius: "4px", overflow: "hidden", background: "var(--bgColor-mild)" }}>
                        <div
                          style={{
                            background: "var(--bgColor-muted)",
                            padding: "0 20px",
                            height: "40px",
                            display: "flex",
                            alignItems: "center",
                            borderBottom: "1px solid var(--borderColor-default)",
                          }}
                        >
                          <span
                            style={{
                              fontSize: "0.75rem",
                              fontWeight: 500,
                              textTransform: "uppercase",
                              letterSpacing: "0.06em",
                              color: "var(--fgColor-default)",
                              fontFamily: "var(--font-sans)",
                            }}
                          >
                            Account
                          </span>
                        </div>
                        <div style={{ padding: "0", background: "var(--bgColor-mild)" }}>
                          <InfoRow label="Phone" value={studentProfile?.phone || "Not set"} isLast={false} />
                          <InfoRow label="Profession" value={studentProfile?.profession || "Not set"} isLast={!studentProfile?.skills?.length} />
                          {studentProfile?.skills && studentProfile.skills.length > 0 && (
                            <div style={{ borderTop: "1px solid var(--borderColor-default)", padding: "12px 20px" }}>
                              <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", color: "var(--fgColor-muted)", fontWeight: 400, display: "block", marginBottom: "8px" }}>
                                Skills
                              </span>
                              <div style={{ display: "flex", flexWrap: "wrap", gap: "4px" }}>
                                {studentProfile.skills.map((skill: string) => (
                                  <Pill key={skill} label={skill} />
                                ))}
                              </div>
                            </div>
                          )}
                        </div>
                      </div>

                      {/* Socials Section */}
                      <div style={{ border: "1px solid var(--borderColor-default)", borderRadius: "4px", overflow: "hidden", background: "var(--bgColor-mild)" }}>
                        <div
                          style={{
                            background: "var(--bgColor-muted)",
                            padding: "0 20px",
                            height: "40px",
                            display: "flex",
                            alignItems: "center",
                            borderBottom: "1px solid var(--borderColor-default)",
                          }}
                        >
                          <span
                            style={{
                              fontSize: "0.75rem",
                              fontWeight: 500,
                              textTransform: "uppercase",
                              letterSpacing: "0.06em",
                              color: "var(--fgColor-default)",
                              fontFamily: "var(--font-sans)",
                            }}
                          >
                            Socials
                          </span>
                        </div>
                        <div style={{ padding: "0", background: "var(--bgColor-mild)" }}>
                          <InfoRow label="GitHub" value={studentProfile?.githubUrl || "Not set"} isLast={false} />
                          <InfoRow label="LinkedIn" value={studentProfile?.linkedinUrl || "Not set"} isLast={false} />
                          <InfoRow label="Website" value={studentProfile?.websiteUrl || "Not set"} isLast={true} />
                        </div>
                      </div>
                    </div>

                    {/* Session Info Section */}
                    {(s.subject || s.studentNotes || s.attachmentFileName) && (
                      <div style={{ marginTop: "20px", border: "1px solid var(--borderColor-default)", borderRadius: "4px", overflow: "hidden", background: "var(--bgColor-mild)" }}>
                        <div style={{ background: "var(--bgColor-muted)", padding: "0 20px", height: "40px", display: "flex", alignItems: "center", borderBottom: "1px solid var(--borderColor-default)" }}>
                          <span style={{ fontSize: "0.75rem", fontWeight: 500, textTransform: "uppercase", letterSpacing: "0.06em", color: "var(--fgColor-default)", fontFamily: "var(--font-sans)" }}>
                            Session Info
                          </span>
                        </div>
                        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "16px" }}>
                          <div style={{ padding: "16px 20px", display: "flex", flexDirection: "column", gap: "12px" }}>
                            {s.subject && (
                              <div>
                                <span style={{ fontSize: "0.75rem", color: "var(--fgColor-muted)", fontWeight: 400, display: "block", marginBottom: "4px", fontFamily: "var(--font-sans)" }}>Subject</span>
                                <span style={{ fontSize: "0.875rem", color: "var(--fgColor-default)", fontFamily: "var(--font-sans)" }}>{s.subject}</span>
                              </div>
                            )}
                            {s.studentNotes && (
                              <div>
                                <span style={{ fontSize: "0.75rem", color: "var(--fgColor-muted)", fontWeight: 400, display: "block", marginBottom: "4px", fontFamily: "var(--font-sans)" }}>Description</span>
                                <span style={{ fontSize: "0.875rem", color: "var(--fgColor-default)", fontFamily: "var(--font-sans)", lineHeight: 1.5 }}>{s.studentNotes}</span>
                              </div>
                            )}
                          </div>
                          <div style={{ padding: "16px 20px" }}>
                            <span style={{ fontSize: "0.75rem", color: "var(--fgColor-muted)", fontWeight: 400, display: "block", marginBottom: "4px", fontFamily: "var(--font-sans)" }}>Attachments</span>
                            {s.attachmentFileName ? (
                              <a href={`/api/mentor-sessions/attachment/${s.id}`} download style={{ display: "inline-flex", alignItems: "center", gap: "8px", textDecoration: "none", color: "var(--fgColor-default)", fontSize: "0.8125rem", fontFamily: "var(--font-sans)", cursor: "pointer" }}>
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                  <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                                  <polyline points="7 10 12 15 17 10" />
                                  <line x1="12" y1="15" x2="12" y2="3" />
                                </svg>
                                {s.attachmentFileName}
                              </a>
                            ) : (
                              <span style={{ fontSize: "0.8125rem", color: "var(--fgColor-muted)", fontStyle: "italic", fontFamily: "var(--font-sans)" }}>No attachments</span>
                            )}
                          </div>
                        </div>
                      </div>
                    )}
                  </div>
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
      <SupportModal isOpen={showSupportModal} onClose={() => setShowSupportModal(false)} />
    </>
  );
}

// --- Upcoming Sessions Table ---
function UpcomingTable({ liveSessionVisible }: { liveSessionVisible: boolean }) {
  const [sessions, setSessions] = useState<UpcomingEntry[]>([]);
  const [loading, setLoading] = useState(true);
  const [showCancelModal, setShowCancelModal] = useState(false);
  const [cancellingSessionId, setCancellingSessionId] = useState<
    string | null
  >(null);
  const [cancelReason, setCancelReason] = useState("");
  const [walletBalance, setWalletBalance] = useState<number | null>(null);
  const [checkingBalance, setCheckingBalance] = useState(false);
  const [cancelling, setCancelling] = useState(false);

  // Accordion state
  const [expandedSessionId, setExpandedSessionId] = useState<string | null>(null);
  const [collapsingSessionId, setCollapsingSessionId] = useState<string | null>(null);
  const [panelMaxHeight, setPanelMaxHeight] = useState(400);
  const panelRef = useRef<HTMLDivElement>(null);
  const [studentProfile, setStudentProfile] = useState<StudentProfileDetail | null>(null);

  useEffect(() => {
    setLoading(true);
    getMentorUpcoming().then((data) => {
      setSessions(data);
      setLoading(false);
    }).catch(() => setLoading(false));
  }, []);

  const handleReschedule = (id: string) => {
    console.log(`Reschedule session: ${id}`);
    // TODO: API call
  };

  const handleCancel = async (id: string) => {
    setCancellingSessionId(id);
    setShowCancelModal(true);
    setCancelReason("");
    setCheckingBalance(true);
    setWalletBalance(null);
    const result = await getWithdrawableBalance();
    if (result) {
      setWalletBalance(result.balanceCents);
    }
    setCheckingBalance(false);
  };

  const cancellingSession = useMemo(
    () => sessions.find((s) => s.id === cancellingSessionId) ?? null,
    [sessions, cancellingSessionId],
  );

  const confirmCancel = async () => {
    if (!cancellingSessionId) return;
    setCancelling(true);
    const ok = await cancelMentorSession(
      cancellingSessionId,
      cancelReason.trim() || undefined,
    );
    if (ok) {
      setSessions((prev) => prev.filter((s) => s.id !== cancellingSessionId));
    }
    setCancelling(false);
    setShowCancelModal(false);
    setCancellingSessionId(null);
    setCancelReason("");
  };

  const wordCount = cancelReason.trim()
    ? cancelReason.trim().split(/\s+/).length
    : 0;

  const isBalanceInsufficient = Boolean(
    cancellingSession?.advanceCents &&
    cancellingSession.advanceCents > 0 &&
    walletBalance !== null &&
    walletBalance < cancellingSession.advanceCents
  );

  const sortedSessions = useMemo(() => {
    return [...sessions].sort((a, b) => {
      const dateCompare = parseDateToSortKey(a.date).localeCompare(parseDateToSortKey(b.date));
      if (dateCompare !== 0) return dateCompare;
      return a.fromTime.localeCompare(b.fromTime);
    });
  }, [sessions]);

  const ROW_HEIGHT = 48;
  const PAGINATION_ROW_HEIGHT = 52;
  const TABLE_HEADER_HEIGHT = 48;
  const LAYOUT_BUFFER = 12;

  const [page, setPage] = useState(1);
  const [dynamicPageSize, setDynamicPageSize] = useState(10);
  const tableContainerRef = useRef<HTMLDivElement>(null);
  const firstRowRef = useRef<HTMLDivElement>(null);
  const paginationRowRef = useRef<HTMLDivElement>(null);
  const calcLayoutRef = useRef<() => void>(null);

  const total = sessions.length;
  const totalPages = Math.ceil(total / dynamicPageSize);
  const rangeStart = total === 0 ? 0 : (page - 1) * dynamicPageSize + 1;
  const rangeEnd = Math.min(page * dynamicPageSize, total);
  const pageData = sortedSessions.slice((page - 1) * dynamicPageSize, page * dynamicPageSize);

  // Reorder sessions when one is expanded: expanded row moves to top
  const orderedSessions = useMemo(() => {
    const activeId = expandedSessionId ?? collapsingSessionId;
    if (!activeId) return pageData;
    const idx = pageData.findIndex((s) => s.id === activeId);
    if (idx === -1) return pageData;
    const expanded = pageData[idx];
    const rest = [...pageData.slice(0, idx), ...pageData.slice(idx + 1)];
    return [expanded, ...rest];
  }, [pageData, expandedSessionId, collapsingSessionId]);

  // Click handler for row expand/collapse
  const handleRowClick = (sessionId: string) => {
    if (expandedSessionId === sessionId) {
      setCollapsingSessionId(sessionId);
      setExpandedSessionId(null);
    } else {
      setCollapsingSessionId(null);
      setExpandedSessionId(sessionId);
    }
  };

  useEffect(() => {
    const calcLayout = () => {
      if (!tableContainerRef.current) return;
      const containerTop = tableContainerRef.current.getBoundingClientRect().top;
      const actualRowHeight = firstRowRef.current
        ? firstRowRef.current.getBoundingClientRect().height
        : ROW_HEIGHT;
      const actualPaginationHeight = paginationRowRef.current
        ? paginationRowRef.current.getBoundingClientRect().height
        : PAGINATION_ROW_HEIGHT;
      const headerEl = tableContainerRef.current.firstElementChild as HTMLElement | null;
      const actualHeaderHeight = headerEl
        ? headerEl.getBoundingClientRect().height
        : TABLE_HEADER_HEIGHT;

      const availableForRows =
        window.innerHeight - containerTop - 2 - actualHeaderHeight - actualPaginationHeight - LAYOUT_BUFFER;
      const rows = Math.max(1, Math.floor(availableForRows / actualRowHeight));
      setDynamicPageSize(rows);

      // Panel height: space from expanded row bottom to pagination row top
      const panelH =
        window.innerHeight -
        containerTop -
        2 -
        actualHeaderHeight -
        actualRowHeight -
        actualPaginationHeight -
        8;
      setPanelMaxHeight(Math.max(200, Math.floor(panelH)));
    };
    calcLayout();
    calcLayoutRef.current = calcLayout;
    window.addEventListener("resize", calcLayout);
    return () => window.removeEventListener("resize", calcLayout);
  }, []);

  useEffect(() => { setPage(1); requestAnimationFrame(() => calcLayoutRef.current && calcLayoutRef.current()); }, [sessions.length, dynamicPageSize]);

  useEffect(() => {
    requestAnimationFrame(() => calcLayoutRef.current && calcLayoutRef.current());
  }, [liveSessionVisible]);

  // Animate panel open
  useEffect(() => {
    if (expandedSessionId && panelRef.current) {
      const el = panelRef.current;
      el.style.maxHeight = "0px";
      const raf = requestAnimationFrame(() => {
        el.style.maxHeight = `${panelMaxHeight}px`;
      });
      return () => cancelAnimationFrame(raf);
    }
  }, [expandedSessionId, panelMaxHeight]);

  // Collapse animation
  useEffect(() => {
    if (collapsingSessionId && panelRef.current) {
      const el = panelRef.current;
      el.style.maxHeight = "0px";
      const timeout = setTimeout(() => {
        setCollapsingSessionId(null);
      }, 400);
      return () => clearTimeout(timeout);
    }
  }, [collapsingSessionId]);

  // Fetch student profile when accordion expands
  useEffect(() => {
    if (!expandedSessionId) {
      setStudentProfile(null);
      return;
    }
    const session = sessions.find(s => s.id === expandedSessionId);
    if (!session?.studentUserId) return;
    let cancelled = false;
    getStudentProfile(session.studentUserId).then(data => {
      if (!cancelled) setStudentProfile(data);
    });
    return () => { cancelled = true; };
  }, [expandedSessionId]);

  return (
    <>
    <div>
      <h2
        style={{
          fontFamily: "var(--font-sans)",
          fontSize: "1.25rem",
          fontWeight: 600,
          color: "var(--fgColor-default)",
          margin: "24px 0 16px 0",
        }}
      >
        Upcoming Sessions
      </h2>

      <div
        ref={tableContainerRef}
        style={{
          backgroundColor: "var(--bgColor-mild)",
          border: "1px solid var(--borderColor-default)",
          borderRadius: "4px",
          overflow: "visible",
        }}
      >
        {/* Table header */}
        <div
          style={{
            display: "grid",
            gridTemplateColumns: "140px 1fr 100px 80px 80px 80px 100px 100px 80px 50px",
            gap: "12px",
            padding: "12px 20px",
            borderBottom: "1px solid var(--borderColor-default)",
            backgroundColor: "var(--bgColor-muted)",
          }}
        >
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>User</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Domain</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Service</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Duration</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>From</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>To</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Date</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Earnings</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Status</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Actions</span>
        </div>

        {sessions.length === 0 ? (
          /* Empty row */
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "1fr",
              padding: "48px 24px",
              textAlign: "center",
              justifyItems: "center",
            }}
          >
            <div>
              <svg
                width="48"
                height="48"
                viewBox="0 0 24 24"
                fill="none"
                stroke="var(--fgColor-muted)"
                strokeWidth="1.5"
                strokeLinecap="round"
                strokeLinejoin="round"
                style={{ margin: "0 auto 16px", display: "block" }}
              >
                <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
                <line x1="16" y1="2" x2="16" y2="6" />
                <line x1="8" y1="2" x2="8" y2="6" />
                <line x1="3" y1="10" x2="21" y2="10" />
              </svg>
              <h3
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "1rem",
                  fontWeight: 600,
                  color: "var(--fgColor-default)",
                  margin: "0 0 8px 0",
                }}
              >
                No upcoming sessions
              </h3>
              <p
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "0.875rem",
                  color: "var(--fgColor-muted)",
                  margin: 0,
                }}
              >
                You don&apos;t have any upcoming sessions scheduled.
              </p>
            </div>
          </div>
        ) : (
          /* Table rows */
          orderedSessions.map((s, idx) => {
            const isExpanded = expandedSessionId === s.id;
            const isCollapsing = collapsingSessionId === s.id;
            const isActive = isExpanded || isCollapsing;
            return (
              <div key={s.id}>
                {/* Row */}
                <div
                  ref={idx === 0 ? firstRowRef : undefined}
                  style={{
                    display: "grid",
                    gridTemplateColumns: "140px 1fr 100px 80px 80px 80px 100px 100px 80px 50px",
                    gap: "12px",
                    padding: "12px 20px",
                    borderBottom: isActive ? "none" : idx < orderedSessions.length - 1 ? "1px solid var(--borderColor-default)" : "none",
                    alignItems: "center",
                    transition: "background-color 0.1s ease",
                    cursor: "pointer",
                    backgroundColor: "transparent",
                  }}
                  onClick={() => handleRowClick(s.id)}
                  onMouseEnter={(e) => {
                    e.currentTarget.style.backgroundColor = "var(--bgColor-default)";
                  }}
                  onMouseLeave={(e) => {
                    e.currentTarget.style.backgroundColor = "transparent";
                  }}
                >
                  {/* User */}
                  <span
                    style={{
                      fontFamily: "var(--font-sans)",
                      fontSize: "0.8125rem",
                      color: "var(--fgColor-default)",
                    }}
                  >
                    {s.userName}
                  </span>

                  {/* Domain */}
                  <span
                    style={{
                      fontFamily: "var(--font-sans)",
                      fontSize: "0.8125rem",
                      color: "var(--fgColor-default)",
                      overflow: "hidden",
                      textOverflow: "ellipsis",
                      whiteSpace: "nowrap",
                    }}
                  >
                    {s.domain}
                  </span>

                  {/* Service Type */}
                  <span
                    style={{
                      fontFamily: "var(--font-sans)",
                      fontSize: "0.8125rem",
                      color: "var(--fgColor-default)",
                    }}
                  >
                    {s.serviceType}
                  </span>

                  {/* Duration */}
                  <span
                    style={{
                      fontFamily: "var(--font-mono, monospace)",
                      fontSize: "0.8125rem",
                      color: "var(--fgColor-default)",
                    }}
                  >
                    {formatDuration(s.durationMinutes)}
                  </span>

                  {/* From-time */}
                  <span
                    style={{
                      fontFamily: "var(--font-mono, monospace)",
                      fontSize: "0.8125rem",
                      color: "var(--fgColor-default)",
                    }}
                  >
                    {s.fromTime}
                  </span>

                  {/* To-time */}
                  <span
                    style={{
                      fontFamily: "var(--font-mono, monospace)",
                      fontSize: "0.8125rem",
                      color: "var(--fgColor-default)",
                    }}
                  >
                    {s.toTime}
                  </span>

                  {/* Date */}
                  <span
                    style={{
                      fontFamily: "var(--font-mono, monospace)",
                      fontSize: "0.8125rem",
                      color: "var(--fgColor-default)",
                    }}
                  >
                    {s.date}
                  </span>

                  {/* Earnings */}
                  <span
                    style={{
                      fontFamily: "var(--font-mono, monospace)",
                      fontSize: "0.8125rem",
                      color: "var(--fgColor-default)",
                    }}
                  >
                    {formatEarnings(s.earningsCents)}
                  </span>

                  {/* Status */}
                  <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
                    <span
                      style={{
                        width: "8px",
                        height: "8px",
                        borderRadius: "50%",
                        backgroundColor: "#05C004",
                      }}
                    />
                    <span
                      style={{
                        fontFamily: "var(--font-sans)",
                        fontSize: "0.8125rem",
                        color: "var(--fgColor-default)",
                      }}
                    >
                      Confirmed
                    </span>
                  </div>

                  {/* Actions */}
                  <UpcomingActionDropdown
                    onReschedule={() => handleReschedule(s.id)}
                    onCancel={() => handleCancel(s.id)}
                  />
                </div>

                {/* Expanded Panel */}
                {(isExpanded || isCollapsing) && (
                  <div
                    ref={panelRef}
                    style={{
                      maxHeight: "0px",
                      overflowY: "auto",
                      transition: "max-height 0.35s cubic-bezier(0.4, 0, 0.2, 1)",
                      backgroundColor: "var(--bgColor-default)",
                      borderBottom: "1px solid var(--borderColor-default)",
                    }}
                  >
                    <div style={{ padding: "24px" }}>
                      {/* Identity Bar — matching analytics dashboard exactly, email+verified replaces name+sso */}
                      <div
                        style={{
                          display: "grid",
                          gridTemplateColumns: "1fr auto",
                          gap: "24px",
                          padding: "16px",
                          background: "var(--bgColor-mild)",
                          borderRadius: "6px",
                          border: "1px solid var(--borderColor-default)",
                        }}
                      >
                        {/* Left Column: Avatar + Email + Status */}
                        <div style={{ display: "flex", alignItems: "center", gap: "16px", overflow: "hidden" }}>
                          <div
                            style={{
                              width: "48px",
                              height: "48px",
                              borderRadius: "50%",
                              background: "var(--bgColor-muted)",
                              display: "flex",
                              alignItems: "center",
                              justifyContent: "center",
                              flexShrink: 0,
                            }}
                          >
                            <span
                              style={{
                                fontFamily: "var(--font-sans)",
                                fontSize: "1.125rem",
                                fontWeight: 600,
                                color: "var(--fgColor-default)",
                              }}
                            >
                              {studentProfile?.email?.charAt(0)?.toUpperCase() || "?"}
                            </span>
                          </div>
                          <div>
                            <div style={{ display: "flex", alignItems: "center", gap: "8px", flexWrap: "wrap" }}>
                              <span
                                style={{
                                  fontFamily: "var(--font-sans)",
                                  fontSize: "1rem",
                                  fontWeight: 600,
                                  color: "var(--fgColor-default)",
                                }}
                              >
                                {studentProfile?.email || "Loading..."}
                              </span>
                              {studentProfile?.emailVerified && (
                                <span
                                  style={{
                                    display: "inline-flex",
                                    padding: "2px 8px",
                                    borderRadius: "9999px",
                                    fontSize: "0.6875rem",
                                    fontWeight: 500,
                                    fontFamily: "var(--font-sans)",
                                    background: "#059669",
                                    color: "#fff",
                                  }}
                                >
                                  Verified
                                </span>
                              )}
                            </div>
                            <div style={{ display: "flex", alignItems: "center", gap: "6px", marginTop: "6px", flexWrap: "wrap" }}>
                              <span
                                style={{
                                  width: 8,
                                  height: 8,
                                  borderRadius: "50%",
                                  backgroundColor: "#818178",
                                  flexShrink: 0,
                                }}
                              />
                              <span
                                style={{
                                  fontFamily: "var(--font-sans)",
                                  fontSize: "0.8125rem",
                                  color: "var(--fgColor-muted)",
                                }}
                              >
                                Offline
                              </span>
                              <span style={{ color: "var(--fgColor-muted)", fontSize: "0.8125rem" }}>·</span>
                              <span
                                style={{
                                  fontFamily: "var(--font-sans)",
                                  fontSize: "0.8125rem",
                                  color: "var(--fgColor-muted)",
                                }}
                              >
                                {studentProfile?.lastLoginAt
                                  ? `Last login ${formatRelativeTime(studentProfile.lastLoginAt)}`
                                  : "Never logged in"}
                              </span>
                            </div>
                          </div>
                        </div>

                        {/* Right Column: Academic details */}
                        {(studentProfile?.collegeName || studentProfile?.courseName) && (
                          <div style={{ display: "flex", alignItems: "flex-start", gap: "32px", minWidth: 0 }}>
                            {/* Institution + Department stacked */}
                            <div style={{ flex: 1, minWidth: 0 }}>
                              {studentProfile.collegeName && (
                                <div style={{ fontFamily: "var(--font-sans)", fontSize: "0.9375rem", fontWeight: 500, color: "var(--fgColor-default)", lineHeight: 1.4, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                                  {studentProfile.collegeName}
                                </div>
                              )}
                              {studentProfile.departmentName && (
                                <div style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)", lineHeight: 1.4, marginTop: "2px", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                                  {studentProfile.departmentName}
                                </div>
                              )}
                            </div>
                            {/* Course + Expertise tag */}
                            <div style={{ textAlign: "right", flexShrink: 0 }}>
                              {studentProfile.courseName && (
                                <div style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)", lineHeight: 1.4 }}>
                                  {studentProfile.courseName}{studentProfile.academicYear ? ` \u00B7 Year ${studentProfile.academicYear}` : ""}
                                </div>
                              )}
                              {studentProfile.expertiseLevel && (
                                <span style={{ display: "inline-block", fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, padding: "3px 12px", borderRadius: "4px", marginTop: "6px", background: getExpertiseColor(studentProfile.expertiseLevel).bg, color: getExpertiseColor(studentProfile.expertiseLevel).text }}>
                                  {studentProfile.expertiseLevel}
                                </span>
                              )}
                            </div>
                          </div>
                        )}
                      </div>

                      {/* 2-Column Grid: Account | Socials */}
                      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "16px", marginTop: "20px" }}>
                        {/* Account Section */}
                        <div style={{ border: "1px solid var(--borderColor-default)", borderRadius: "4px", overflow: "hidden", background: "var(--bgColor-mild)" }}>
                          <div
                            style={{
                              background: "var(--bgColor-muted)",
                              padding: "0 20px",
                              height: "40px",
                              display: "flex",
                              alignItems: "center",
                              borderBottom: "1px solid var(--borderColor-default)",
                            }}
                          >
                            <span
                              style={{
                                fontSize: "0.75rem",
                                fontWeight: 500,
                                textTransform: "uppercase",
                                letterSpacing: "0.06em",
                                color: "var(--fgColor-default)",
                                fontFamily: "var(--font-sans)",
                              }}
                            >
                              Account
                            </span>
                          </div>
                          <div style={{ padding: "0", background: "var(--bgColor-mild)" }}>
                            <InfoRow label="Phone" value={studentProfile?.phone || "Not set"} isLast={false} />
                            <InfoRow label="Profession" value={studentProfile?.profession || "Not set"} isLast={!studentProfile?.skills?.length} />
                            {studentProfile?.skills && studentProfile.skills.length > 0 && (
                              <div style={{ borderTop: "1px solid var(--borderColor-default)", padding: "12px 20px" }}>
                                <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", color: "var(--fgColor-muted)", fontWeight: 400, display: "block", marginBottom: "8px" }}>
                                  Skills
                                </span>
                                <div style={{ display: "flex", flexWrap: "wrap", gap: "4px" }}>
                                  {studentProfile.skills.map((skill: string) => (
                                    <Pill key={skill} label={skill} />
                                  ))}
                                </div>
                              </div>
                            )}
                          </div>
                        </div>

                        {/* Socials Section */}
                        <div style={{ border: "1px solid var(--borderColor-default)", borderRadius: "4px", overflow: "hidden", background: "var(--bgColor-mild)" }}>
                          <div
                            style={{
                              background: "var(--bgColor-muted)",
                              padding: "0 20px",
                              height: "40px",
                              display: "flex",
                              alignItems: "center",
                              borderBottom: "1px solid var(--borderColor-default)",
                            }}
                          >
                            <span
                              style={{
                                fontSize: "0.75rem",
                                fontWeight: 500,
                                textTransform: "uppercase",
                                letterSpacing: "0.06em",
                                color: "var(--fgColor-default)",
                                fontFamily: "var(--font-sans)",
                              }}
                            >
                              Socials
                            </span>
                          </div>
                          <div style={{ padding: "0", background: "var(--bgColor-mild)" }}>
                            <InfoRow label="GitHub" value={studentProfile?.githubUrl || "Not set"} isLast={false} />
                            <InfoRow label="LinkedIn" value={studentProfile?.linkedinUrl || "Not set"} isLast={false} />
                            <InfoRow label="Website" value={studentProfile?.websiteUrl || "Not set"} isLast={true} />
                          </div>
                        </div>
                      </div>

                      {/* Session Info Section */}
                      {(s.subject || s.studentNotes || s.attachmentFileName) && (
                        <div style={{ marginTop: "20px", border: "1px solid var(--borderColor-default)", borderRadius: "4px", overflow: "hidden", background: "var(--bgColor-mild)" }}>
                          <div style={{ background: "var(--bgColor-muted)", padding: "0 20px", height: "40px", display: "flex", alignItems: "center", borderBottom: "1px solid var(--borderColor-default)" }}>
                            <span style={{ fontSize: "0.75rem", fontWeight: 500, textTransform: "uppercase", letterSpacing: "0.06em", color: "var(--fgColor-default)", fontFamily: "var(--font-sans)" }}>
                              Session Info
                            </span>
                          </div>
                          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "16px" }}>
                            {/* Left column: Subject + Description */}
                            <div style={{ padding: "16px 20px", display: "flex", flexDirection: "column", gap: "12px" }}>
                              {s.subject && (
                                <div>
                                  <span style={{ fontSize: "0.75rem", color: "var(--fgColor-muted)", fontWeight: 400, display: "block", marginBottom: "4px", fontFamily: "var(--font-sans)" }}>Subject</span>
                                  <span style={{ fontSize: "0.875rem", color: "var(--fgColor-default)", fontFamily: "var(--font-sans)" }}>{s.subject}</span>
                                </div>
                              )}
                              {s.studentNotes && (
                                <div>
                                  <span style={{ fontSize: "0.75rem", color: "var(--fgColor-muted)", fontWeight: 400, display: "block", marginBottom: "4px", fontFamily: "var(--font-sans)" }}>Description</span>
                                  <span style={{ fontSize: "0.875rem", color: "var(--fgColor-default)", fontFamily: "var(--font-sans)", lineHeight: 1.5 }}>{s.studentNotes}</span>
                                </div>
                              )}
                            </div>
                            {/* Right column: Attachments */}
                            <div style={{ padding: "16px 20px" }}>
                              <span style={{ fontSize: "0.75rem", color: "var(--fgColor-muted)", fontWeight: 400, display: "block", marginBottom: "4px", fontFamily: "var(--font-sans)" }}>Attachments</span>
                              {s.attachmentFileName ? (
                                <a href={`/api/mentor-sessions/attachment/${s.id}`} download style={{ display: "inline-flex", alignItems: "center", gap: "8px", textDecoration: "none", color: "var(--fgColor-default)", fontSize: "0.8125rem", fontFamily: "var(--font-sans)", cursor: "pointer" }}>
                                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                                    <polyline points="7 10 12 15 17 10" />
                                    <line x1="12" y1="15" x2="12" y2="3" />
                                  </svg>
                                  {s.attachmentFileName}
                                </a>
                              ) : (
                                <span style={{ fontSize: "0.8125rem", color: "var(--fgColor-muted)", fontStyle: "italic", fontFamily: "var(--font-sans)" }}>No attachments</span>
                              )}
                            </div>
                          </div>
                        </div>
                      )}
                    </div>
                  </div>
                )}
              </div>
            );
          })
        )}
      </div>

      {total > 0 && (
        <div
          ref={paginationRowRef}
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            marginTop: "16px",
            padding: "0 4px",
          }}
        >
          <span
            style={{
              fontFamily: "var(--font-sans)",
              fontSize: "0.875rem",
              color: "var(--fgColor-muted)",
            }}
          >
            Showing {rangeStart}-{rangeEnd} of{" "}
            {total.toLocaleString("en-IN")}
          </span>

          <div style={{ display: "flex", gap: "8px" }}>
            <button
              type="button"
              onClick={() => setPage((p) => Math.max(1, p - 1))}
              disabled={page <= 1}
              style={{
                padding: "6px 12px",
                backgroundColor: "var(--bgColor-muted)",
                border: "1px solid var(--borderColor-default)",
                borderRadius: "4px",
                fontFamily: "var(--font-sans)",
                fontSize: "0.8125rem",
                color:
                  page <= 1
                    ? "var(--fgColor-muted)"
                    : "var(--fgColor-default)",
                cursor:
                  page <= 1 ? "not-allowed" : "pointer",
                opacity: page <= 1 ? 0.5 : 1,
                transition: "background-color 0.15s ease",
              }}
              onMouseOver={(e) => {
                if (page > 1)
                  e.currentTarget.style.backgroundColor =
                    "var(--bgColor-mild)";
              }}
              onMouseOut={(e) => {
                e.currentTarget.style.backgroundColor =
                  "var(--bgColor-muted)";
              }}
            >
              Previous
            </button>
            <button
              type="button"
              onClick={() =>
                setPage((p) => Math.min(totalPages || 1, p + 1))
              }
              disabled={page >= totalPages || totalPages === 0}
              style={{
                padding: "6px 12px",
                backgroundColor: "var(--bgColor-muted)",
                border: "1px solid var(--borderColor-default)",
                borderRadius: "4px",
                fontFamily: "var(--font-sans)",
                fontSize: "0.8125rem",
                color:
                  page >= totalPages || totalPages === 0
                    ? "var(--fgColor-muted)"
                    : "var(--fgColor-default)",
                cursor:
                  page >= totalPages || totalPages === 0
                    ? "not-allowed"
                    : "pointer",
                opacity:
                  page >= totalPages || totalPages === 0 ? 0.5 : 1,
                transition: "background-color 0.15s ease",
              }}
              onMouseOver={(e) => {
                if (page < totalPages && totalPages > 0)
                  e.currentTarget.style.backgroundColor =
                    "var(--bgColor-mild)";
              }}
              onMouseOut={(e) => {
                e.currentTarget.style.backgroundColor =
                  "var(--bgColor-muted)";
              }}
            >
              Next
            </button>
          </div>
        </div>
      )}
    </div>

      {/* ── Cancel Session Modal ── */}
      {showCancelModal && cancellingSession && (
        <>
          {/* Overlay */}
          <div
            onClick={() => {
              setShowCancelModal(false);
              setCancellingSessionId(null);
            }}
            style={{
              position: "fixed",
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              backgroundColor: "rgba(11, 11, 11, 0.60)",
              backdropFilter: "blur(4px)",
              WebkitBackdropFilter: "blur(4px)",
              zIndex: 1000,
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
            }}
          />

          {/* Modal Container */}
          <div
            style={{
              position: "fixed",
              top: "50%",
              left: "50%",
              transform: "translate(-50%, -50%)",
              width: "100%",
              maxWidth: "500px",
              backgroundColor: "var(--bgColor-default)",
              border: "1px solid var(--borderColor-default)",
              borderRadius: 0,
              zIndex: 1001,
              display: "flex",
              flexDirection: "column",
              boxShadow: "none",
            }}
          >
            {/* Modal Header */}
            <div
              style={{
                display: "flex",
                justifyContent: "space-between",
                alignItems: "center",
                padding: "24px 32px 0 32px",
              }}
            >
              <h2
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "1.25rem",
                  fontWeight: 600,
                  color: "var(--fgColor-default)",
                  margin: 0,
                }}
              >
                Cancel Session
              </h2>
              <button
                onClick={() => {
                  setShowCancelModal(false);
                  setCancellingSessionId(null);
                }}
                style={{
                  width: "24px",
                  height: "24px",
                  backgroundColor: "transparent",
                  border: "none",
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  cursor: "pointer",
                  color: "var(--fgColor-default)",
                  padding: 0,
                }}
              >
                <svg
                  width="24"
                  height="24"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="1.5"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <line x1="18" y1="6" x2="6" y2="18" />
                  <line x1="6" y1="6" x2="18" y2="18" />
                </svg>
              </button>
            </div>

            {/* Modal Content */}
            <div style={{ padding: "24px 32px" }}>
              <h3
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "1rem",
                  fontWeight: 500,
                  color: "var(--fgColor-default)",
                  margin: "0 0 16px 0",
                }}
              >
                Cancel session with {cancellingSession.userName}?
              </h3>

              {/* Session Info */}
              <div
                style={{
                  marginBottom: "16px",
                  fontFamily: "var(--font-sans)",
                  fontSize: "0.875rem",
                  color: "var(--fgColor-muted)",
                  lineHeight: "1.6",
                }}
              >
                <div>
                  {cancellingSession.domain} ·{" "}
                  {cancellingSession.serviceType} ·{" "}
                  {formatDuration(cancellingSession.durationMinutes)}
                </div>
                <div>
                  {cancellingSession.date} ·{" "}
                  {cancellingSession.fromTime} -{" "}
                  {cancellingSession.toTime}
                </div>
              </div>

              {/* Advance / Refund Info */}
              {checkingBalance ? (
                <div
                  style={{
                    backgroundColor: "#fef3c7",
                    border: "1px solid #f59e0b",
                    borderRadius: "4px",
                    padding: "12px 16px",
                    marginBottom: "16px",
                  }}
                >
                  <span
                    style={{
                      fontFamily: "var(--font-sans)",
                      fontSize: "0.8125rem",
                      color: "#92400e",
                    }}
                  >
                    Checking wallet balance...
                  </span>
                </div>
              ) : cancellingSession.advanceCents &&
                cancellingSession.advanceCents > 0 ? (
                walletBalance !== null &&
                walletBalance >= cancellingSession.advanceCents ? (
                  <p
                    style={{
                      fontFamily: "var(--font-sans)",
                      fontSize: "0.875rem",
                      color: "var(--fgColor-default)",
                      margin: "0 0 16px 0",
                    }}
                  >
                    The advance of ₹
                    {(cancellingSession.advanceCents / 100).toFixed(
                      2,
                    )}{" "}
                    will be refunded to the student from your wallet.
                  </p>
                ) : (
                  <div
                    style={{
                      backgroundColor: "#fef2f2",
                      border: "1px solid #ef4444",
                      borderRadius: "4px",
                      padding: "12px 16px",
                      marginBottom: "16px",
                      display: "flex",
                      alignItems: "flex-start",
                      gap: "10px",
                    }}
                  >
                    <svg
                      width="16"
                      height="16"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="#ef4444"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      style={{ flexShrink: 0, marginTop: "2px" }}
                    >
                      <circle cx="12" cy="12" r="10" />
                      <line x1="12" y1="8" x2="12" y2="12" />
                      <line
                        x1="12"
                        y1="16"
                        x2="12.01"
                        y2="16"
                      />
                    </svg>
                    <div>
                      <p
                        style={{
                          fontFamily: "var(--font-sans)",
                          fontSize: "0.8125rem",
                          color: "#991b1b",
                          margin: 0,
                          fontWeight: 500,
                        }}
                      >
                        Insufficient balance to process refund
                      </p>
                      <p
                        style={{
                          fontFamily: "var(--font-sans)",
                          fontSize: "0.8125rem",
                          color: "#b91c1c",
                          margin: "4px 0 0 0",
                        }}
                      >
                        Your wallet balance (₹
                        {((walletBalance ?? 0) / 100).toFixed(2)})
                        is less than the advance amount of ₹
                        {(cancellingSession.advanceCents / 100).toFixed(
                          2,
                        )}
                        . Please add funds to your wallet before
                        cancelling.
                      </p>
                    </div>
                  </div>
                )
              ) : null}

              {/* Reason Input */}
              <div style={{ marginBottom: "16px" }}>
                <div
                  style={{
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "center",
                    marginBottom: "8px",
                  }}
                >
                  <label
                    style={{
                      fontFamily: "var(--font-sans)",
                      fontSize: "0.8125rem",
                      fontWeight: 500,
                      color: "var(--fgColor-default)",
                    }}
                  >
                    Reason for cancellation
                  </label>
                  <span
                    style={{
                      fontFamily: "var(--font-mono, monospace)",
                      fontSize: "0.75rem",
                      color:
                        wordCount >= 10
                          ? "#ef4444"
                          : "var(--fgColor-muted)",
                    }}
                  >
                    {wordCount}/10
                  </span>
                </div>
                <input
                  type="text"
                  value={cancelReason}
                  onChange={(e) => {
                    const words = e.target.value.trim()
                      ? e.target.value.trim().split(/\s+/)
                      : [];
                    if (words.length <= 10)
                      setCancelReason(e.target.value);
                  }}
                  placeholder="Enter cancellation reason (optional)"
                  style={{
                    width: "100%",
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.875rem",
                    color: "var(--fgColor-default)",
                    backgroundColor: "transparent",
                    border: "1px solid #818178",
                    borderRadius: "4px",
                    padding: "8px 12px",
                    height: "40px",
                    outline: "none",
                    boxSizing: "border-box",
                  }}
                  onFocus={(e) => {
                    e.target.style.border =
                      "1px solid var(--fgColor-default)";
                  }}
                  onBlur={(e) => {
                    e.target.style.border = "1px solid #818178";
                  }}
                />
              </div>
            </div>

            {/* Modal Footer */}
            <div
              style={{
                display: "flex",
                justifyContent: "flex-end",
                gap: "12px",
                padding: "0 32px 24px 32px",
              }}
            >
              <button
                onClick={() => {
                  setShowCancelModal(false);
                  setCancellingSessionId(null);
                }}
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "0.875rem",
                  fontWeight: 500,
                  color: "var(--fgColor-default)",
                  backgroundColor: "transparent",
                  border: "1px solid #818178",
                  borderRadius: "4px",
                  padding: "0 20px",
                  height: "40px",
                  cursor: "pointer",
                  transition: "opacity 0.15s ease",
                }}
                onMouseEnter={(e) =>
                  (e.currentTarget.style.opacity = "0.85")
                }
                onMouseLeave={(e) =>
                  (e.currentTarget.style.opacity = "1")
                }
              >
                Cancel
              </button>
              <button
                onClick={confirmCancel}
                disabled={
                  cancelling || isBalanceInsufficient
                }
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "0.875rem",
                  fontWeight: 500,
                  color: "#ffffff",
                  backgroundColor: "#da3633",
                  border: "1px solid #da3633",
                  borderRadius: "4px",
                  padding: "0 20px",
                  height: "40px",
                  cursor:
                    cancelling || isBalanceInsufficient
                      ? "not-allowed"
                      : "pointer",
                  opacity:
                    cancelling || isBalanceInsufficient ? 0.5 : 1,
                  transition: "opacity 0.15s ease",
                }}
              >
                {cancelling
                  ? "Cancelling..."
                  : "Confirm Cancellation"}
              </button>
            </div>
          </div>
        </>
      )}
    </>
  );
}

// --- Past Sessions Table ---
function PastTable({ entries }: { entries: PastEntryApi[] }) {
  const ROW_HEIGHT = 48;
  const PAGINATION_ROW_HEIGHT = 52;
  const TABLE_HEADER_HEIGHT = 48;
  const LAYOUT_BUFFER = 12;

  const [page, setPage] = useState(1);
  const [dynamicPageSize, setDynamicPageSize] = useState(10);
  const tableContainerRef = useRef<HTMLDivElement>(null);
  const firstRowRef = useRef<HTMLDivElement>(null);
  const paginationRowRef = useRef<HTMLDivElement>(null);
  const calcLayoutRef = useRef<() => void>(null);

  const sortedEntries = useMemo(() => {
    return [...entries].sort(
      (a, b) => new Date(b.scheduledFrom).getTime() - new Date(a.scheduledFrom).getTime(),
    );
  }, [entries]);

  const total = sortedEntries.length;
  const totalPages = Math.ceil(total / dynamicPageSize);
  const rangeStart = total === 0 ? 0 : (page - 1) * dynamicPageSize + 1;
  const rangeEnd = Math.min(page * dynamicPageSize, total);
  const pageData = sortedEntries.slice((page - 1) * dynamicPageSize, page * dynamicPageSize);

  useEffect(() => {
    const calcLayout = () => {
      if (!tableContainerRef.current) return;
      const containerTop = tableContainerRef.current.getBoundingClientRect().top;
      const actualRowHeight = firstRowRef.current
        ? firstRowRef.current.getBoundingClientRect().height
        : ROW_HEIGHT;
      const actualPaginationHeight = paginationRowRef.current
        ? paginationRowRef.current.getBoundingClientRect().height
        : PAGINATION_ROW_HEIGHT;
      const headerEl = tableContainerRef.current.firstElementChild as HTMLElement | null;
      const actualHeaderHeight = headerEl
        ? headerEl.getBoundingClientRect().height
        : TABLE_HEADER_HEIGHT;

      const availableForRows =
        window.innerHeight - containerTop - 2 - actualHeaderHeight - actualPaginationHeight - LAYOUT_BUFFER;
      const rows = Math.max(1, Math.floor(availableForRows / actualRowHeight));
      setDynamicPageSize(rows);
    };
    calcLayout();
    calcLayoutRef.current = calcLayout;
    window.addEventListener("resize", calcLayout);
    return () => window.removeEventListener("resize", calcLayout);
  }, []);

  useEffect(() => { setPage(1); }, [entries.length, dynamicPageSize]);

  useEffect(() => {
    requestAnimationFrame(() => calcLayoutRef.current && calcLayoutRef.current());
  }, [entries.length]);

  const statusConfig: Record<PastEntryApi['status'], { color: string; label: string }> = {
    Expired: { color: '#818178', label: 'Request Expired' },
    Approved: { color: '#05C004', label: 'Approved' },
    Rejected: { color: '#E70000', label: 'Rejected' },
    Completed: { color: '#05C004', label: 'Completed' },
    Cancelled: { color: '#E70000', label: 'Cancelled' },
    Missed: { color: '#818178', label: 'Missed' },
    Disputed: { color: '#FDA422', label: 'Disputed' },
  };

  if (entries.length === 0) {
    return (
      <div>
        <h2 style={{ fontFamily: "var(--font-sans)", fontSize: "1.25rem", fontWeight: 600, color: "var(--fgColor-default)", margin: "24px 0 16px 0" }}>Past Sessions</h2>
        <div style={{ backgroundColor: "var(--bgColor-mild)", border: "1px solid var(--borderColor-default)", borderRadius: "4px", padding: "48px 24px", textAlign: "center" }}>
          <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="var(--fgColor-muted)" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" style={{ margin: "0 auto 16px" }}>
            <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
            <line x1="16" y1="2" x2="16" y2="6" />
            <line x1="8" y1="2" x2="8" y2="6" />
            <line x1="3" y1="10" x2="21" y2="10" />
          </svg>
          <h3 style={{ fontFamily: "var(--font-sans)", fontSize: "1rem", fontWeight: 600, color: "var(--fgColor-default)", margin: "0 0 8px 0" }}>No past sessions</h3>
          <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.875rem", color: "var(--fgColor-muted)", margin: 0 }}>Your past session history will appear here.</p>
        </div>
      </div>
    );
  }

  return (
    <div>
      <h2 style={{ fontFamily: "var(--font-sans)", fontSize: "1.25rem", fontWeight: 600, color: "var(--fgColor-default)", margin: "24px 0 16px 0" }}>Past Sessions</h2>

      <div ref={tableContainerRef} style={{ backgroundColor: "var(--bgColor-mild)", border: "1px solid var(--borderColor-default)", borderRadius: "4px", overflow: "visible" }}>
        <div style={{ display: "grid", gridTemplateColumns: "140px 1fr 120px 90px 100px 100px 130px", gap: "12px", padding: "12px 20px", borderBottom: "1px solid var(--borderColor-default)", backgroundColor: "var(--bgColor-muted)" }}>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>User</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Domain</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Service</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Duration</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Earnings</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Date</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Status</span>
        </div>

        {pageData.map((entry, idx) => {
          const sc = statusConfig[entry.status];
          const dateStr = new Date(entry.scheduledFrom).toLocaleDateString("en-IN", { day: "2-digit", month: "short", year: "numeric" });
          return (
            <div key={entry.id} ref={pageData.length > 0 && idx === 0 ? firstRowRef : undefined} style={{ display: "grid", gridTemplateColumns: "140px 1fr 120px 90px 100px 100px 130px", gap: "12px", padding: "12px 20px", borderBottom: idx < pageData.length - 1 ? "1px solid var(--borderColor-default)" : "none", alignItems: "center", transition: "background-color 0.1s ease" }} onMouseOver={(e) => { e.currentTarget.style.backgroundColor = "rgba(255,255,255,0.02)"; }} onMouseOut={(e) => { e.currentTarget.style.backgroundColor = "transparent"; }}>
              <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{entry.userName}</span>
              <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{entry.domain}</span>
              <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{entry.serviceType}</span>
              <span style={{ fontFamily: "var(--font-mono, monospace)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{formatDuration(entry.durationMinutes)}</span>
              <span style={{ fontFamily: "var(--font-mono, monospace)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{entry.status === "Completed" ? formatEarnings(entry.earningsCents) : "--"}</span>
              <span style={{ fontFamily: "var(--font-mono, monospace)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{dateStr}</span>
              <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
                <span style={{ width: "8px", height: "8px", borderRadius: "50%", backgroundColor: sc.color }} />
                <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{sc.label}</span>
              </div>
            </div>
          );
        })}
      </div>

      {total > 0 && (
        <div ref={paginationRowRef} style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: "16px", padding: "0 4px" }}>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.875rem", color: "var(--fgColor-muted)" }}>Showing {rangeStart}-{rangeEnd} of {total.toLocaleString("en-IN")}</span>
          <div style={{ display: "flex", gap: "8px" }}>
            <button type="button" onClick={() => setPage((p) => Math.max(1, p - 1))} disabled={page <= 1} style={{ padding: "6px 12px", backgroundColor: "var(--bgColor-muted)", border: "1px solid var(--borderColor-default)", borderRadius: "4px", fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: page <= 1 ? "var(--fgColor-muted)" : "var(--fgColor-default)", cursor: page <= 1 ? "not-allowed" : "pointer", opacity: page <= 1 ? 0.5 : 1, transition: "background-color 0.15s ease" }} onMouseOver={(e) => { if (page > 1) e.currentTarget.style.backgroundColor = "var(--bgColor-mild)"; }} onMouseOut={(e) => { e.currentTarget.style.backgroundColor = "var(--bgColor-muted)"; }}>Previous</button>
            <button type="button" onClick={() => setPage((p) => Math.min(totalPages || 1, p + 1))} disabled={page >= totalPages || totalPages === 0} style={{ padding: "6px 12px", backgroundColor: "var(--bgColor-muted)", border: "1px solid var(--borderColor-default)", borderRadius: "4px", fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: page >= totalPages || totalPages === 0 ? "var(--fgColor-muted)" : "var(--fgColor-default)", cursor: page >= totalPages || totalPages === 0 ? "not-allowed" : "pointer", opacity: page >= totalPages || totalPages === 0 ? 0.5 : 1, transition: "background-color 0.15s ease" }} onMouseOver={(e) => { if (page < totalPages && totalPages > 0) e.currentTarget.style.backgroundColor = "var(--bgColor-mild)"; }} onMouseOut={(e) => { e.currentTarget.style.backgroundColor = "var(--bgColor-muted)"; }}>Next</button>
          </div>
        </div>
      )}
    </div>
  );
}

// --- Generic empty state for Upcoming / Past ---
function EmptySessionsState({ subTab }: { subTab: SessionsSubTab }) {
  const labels: Record<SessionsSubTab, { title: string; message: string }> = {
    requests: {
      title: "No pending requests",
      message: "You don't have any pending session requests right now.",
    },
    upcoming: {
      title: "No upcoming sessions",
      message: "You don't have any upcoming sessions scheduled.",
    },
    past: {
      title: "No past sessions",
      message: "Your past session history will appear here.",
    },
  };

  const info = labels[subTab];

  return (
    <div
      style={{
        backgroundColor: "var(--bgColor-mild)",
        border: "1px solid var(--borderColor-default)",
        borderRadius: "4px",
        padding: "48px 24px",
        textAlign: "center",
        marginTop: "24px",
      }}
    >
      <svg
        width="48"
        height="48"
        viewBox="0 0 24 24"
        fill="none"
        stroke="var(--fgColor-muted)"
        strokeWidth="1.5"
        strokeLinecap="round"
        strokeLinejoin="round"
        style={{ margin: "0 auto 16px" }}
      >
        <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
        <line x1="16" y1="2" x2="16" y2="6" />
        <line x1="8" y1="2" x2="8" y2="6" />
        <line x1="3" y1="10" x2="21" y2="10" />
      </svg>
      <h3
        style={{
          fontFamily: "var(--font-sans)",
          fontSize: "1rem",
          fontWeight: 600,
          color: "var(--fgColor-default)",
          margin: "0 0 8px 0",
        }}
      >
        {info.title}
      </h3>
      <p
        style={{
          fontFamily: "var(--font-sans)",
          fontSize: "0.875rem",
          color: "var(--fgColor-muted)",
          margin: 0,
        }}
      >
        {info.message}
      </p>
    </div>
  );
}

// --- Main component ---
export function MentorSessionsTabContent() {
  const router = useRouter();
  const searchParams = useSearchParams();

  const currentSubTab = (searchParams.get("sub") as SessionsSubTab) || "requests";

  // Data states
  const [liveSessions, setLiveSessions] = useState<LiveSessionEntry[]>([]);
  const [requests, setRequests] = useState<RequestEntry[]>([]);
  const [pastEntries, setPastEntries] = useState<PastEntryApi[]>([]);
  const [tick, setTick] = useState(0);
  const [overlapWarning, setOverlapWarning] = useState<SessionOverlapResult | null>(null);
  const [pendingApproveId, setPendingApproveId] = useState<string | null>(null);

  // Fetch all data from API
  const fetchData = useCallback(async () => {
    try {
      const [live, reqs, past] = await Promise.all([
        getMentorLive(),
        getMentorRequests(),
        getMentorPast(),
      ]);
      setLiveSessions(live);
      setRequests(reqs);
      setPastEntries(past);
    } catch (err) {
      console.error("Failed to fetch mentor sessions data", err);
    }
  }, []);

  // Fetch on mount and when sub-tab changes
  useEffect(() => {
    fetchData();
  }, [fetchData]);

  // Tick for live session elapsed timer
  useEffect(() => {
    if (liveSessions.length === 0) return;
    const interval = setInterval(() => setTick((t) => t + 1), 1000);
    return () => clearInterval(interval);
  }, [liveSessions]);

  const handleApprove = async (id: string) => {
    const overlap = await checkMentorSessionOverlap(id);
    if (overlap.hasOverlap) {
      setOverlapWarning(overlap);
      setPendingApproveId(id);
    } else {
      const ok = await approveMentorSession(id);
      if (ok) fetchData();
    }
  };

  const handleProceedOverlap = async () => {
    if (!pendingApproveId) return;
    const ok = await approveMentorSession(pendingApproveId);
    setOverlapWarning(null);
    setPendingApproveId(null);
    if (ok) fetchData();
  };

  const handleDismissOverlap = () => {
    setOverlapWarning(null);
    setPendingApproveId(null);
  };

  const handleReject = async (id: string) => {
    const ok = await rejectMentorSession(id);
    if (ok) fetchData();
  };

  const handleRequestExpire = (id: string) => {
    setRequests((prev) => prev.filter((r) => r.id !== id));
  };

  const handleSubTabChange = (sub: SessionsSubTab) => {
    const params = new URLSearchParams(searchParams);
    if (sub === "requests") {
      params.delete("sub");
    } else {
      params.set("sub", sub);
    }
    router.push(`/home?tab=sessions${params.toString() ? `&${params.toString()}` : ""}`, {
      scroll: false,
    });
  };

  return (
    <div>
      <SessionsSubTabs
        activeSubTab={currentSubTab}
        onSubTabChange={handleSubTabChange}
      />

      {currentSubTab === "requests" ? (
        <RequestsTable
          requests={requests}
          onApprove={handleApprove}
          onReject={handleReject}
          onRequestExpire={handleRequestExpire}
        />
      ) : currentSubTab === "upcoming" ? (
        <>
          {liveSessions.length > 0 && <LiveSessionSection sessions={liveSessions} tick={tick} />}
          <UpcomingTable liveSessionVisible={liveSessions.length > 0} />
        </>
      ) : currentSubTab === "past" ? (
        <PastTable entries={pastEntries} />
      ) : (
        <EmptySessionsState subTab={currentSubTab} />
      )}

      {/* Overlap warning modal */}
      {overlapWarning && overlapWarning.overlappingSession && (
        <div
          style={{
            position: "fixed", inset: 0, zIndex: 50, display: "flex",
            alignItems: "center", justifyContent: "center",
            backgroundColor: "rgba(11, 11, 11, 0.15)",
          }}
          onClick={handleDismissOverlap}
        >
          <div
            onClick={(e) => e.stopPropagation()}
            style={{
              width: "calc(100% - 32px)", maxWidth: "420px", maxHeight: "95%",
              backgroundColor: "var(--bgColor-default)",
              border: "1px solid var(--borderColor-default)",
              display: "flex", flexDirection: "column",
            }}
          >
            <div style={{ display: "flex", alignItems: "center", padding: "16px 24px", borderBottom: "1px solid var(--borderColor-default)", lineHeight: "1.375rem" }}>
              <h3 style={{ flex: 1, color: "var(--fgColor-default)", fontSize: "1.125rem", fontFamily: "var(--font-sans)", fontWeight: 400, margin: 0 }}>Heads Up</h3>
            </div>
            <div style={{ overflowY: "auto", overflowX: "hidden", padding: "24px" }}>
              <p style={{ color: "var(--fgColor-mild)", fontSize: "0.875rem", lineHeight: "1.375rem", fontFamily: "var(--font-sans)", margin: 0, marginBottom: "12px" }}>
                You have a session with <strong>{overlapWarning.overlappingSession.userName}</strong> scheduled at{" "}
                {new Date(overlapWarning.overlappingSession.scheduledFrom).toLocaleTimeString("en-IN", { hour: "2-digit", minute: "2-digit" })} —{" "}
                {new Date(overlapWarning.overlappingSession.scheduledTo).toLocaleTimeString("en-IN", { hour: "2-digit", minute: "2-digit" })}{" "}
                ({overlapWarning.overlappingSession.durationMinutes} min).
              </p>
              <p style={{ color: "var(--fgColor-mild)", fontSize: "0.875rem", lineHeight: "1.375rem", fontFamily: "var(--font-sans)", margin: 0, marginBottom: "24px" }}>
                Are you sure you want to continue with this session request as well? The session timings might overlap.
                If not sure, we recommend you check the upcoming session for details and manage your timings accordingly.
              </p>
              <div style={{ display: "flex", justifyContent: "flex-end", gap: "12px" }}>
                <button
                  onClick={handleDismissOverlap}
                  style={{
                    color: "var(--fgColor-mild)", backgroundColor: "transparent",
                    border: "1px solid var(--borderColor-default)", borderRadius: "4px",
                    padding: "0 24px", height: "40px",
                    fontFamily: "var(--font-sans)", fontSize: "0.875rem", fontWeight: 500,
                    cursor: "pointer", transition: "background-color 0.15s ease",
                  }}
                  onMouseEnter={(e) => { e.currentTarget.style.backgroundColor = "rgba(11, 11, 11, 0.05)"; }}
                  onMouseLeave={(e) => { e.currentTarget.style.backgroundColor = "transparent"; }}
                >
                  Back
                </button>
                <button
                  onClick={handleProceedOverlap}
                  style={{
                    color: "#ffffff", backgroundColor: "#2E2E2E",
                    border: "none", borderRadius: "4px",
                    padding: "0 24px", height: "40px",
                    fontFamily: "var(--font-sans)", fontSize: "0.875rem", fontWeight: 500,
                    cursor: "pointer", transition: "background-color 0.15s ease",
                  }}
                  onMouseEnter={(e) => { e.currentTarget.style.backgroundColor = "#0B0B0B"; }}
                  onMouseLeave={(e) => { e.currentTarget.style.backgroundColor = "#2E2E2E"; }}
                >
                  Proceed
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
