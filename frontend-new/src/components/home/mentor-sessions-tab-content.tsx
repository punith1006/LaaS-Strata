"use client";

import { useEffect, useState, useRef, useMemo } from "react";
import { useSearchParams, useRouter } from "next/navigation";

type SessionsSubTab = "requests" | "upcoming" | "complete";

const subTabs: { id: SessionsSubTab; label: string }[] = [
  { id: "requests", label: "Requests" },
  { id: "upcoming", label: "Upcoming" },
  { id: "complete", label: "Complete" },
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

// --- Earnings formatting (80% platform cut) ---
function formatEarnings(cents: number): string {
  const net = cents * 0.8;
  return `\u20B9${(net / 100).toFixed(2)}`;
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
        onClick={() => setIsOpen(!isOpen)}
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
            onClick={() => {
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
            onClick={() => {
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

interface RequestEntry {
  id: string;
  userName: string;
  domain: string;
  serviceType: string;
  durationMinutes: number;
  earningsCents: number;
  createdAt: string;
}

// --- Requests Table ---
function RequestsTable() {
  const [requests, setRequests] = useState<RequestEntry[]>([
    {
      id: "REQ-001",
      userName: "Priya K.",
      domain: "Machine Learning",
      serviceType: "1-on-1 Tutoring",
      durationMinutes: 60,
      earningsCents: 100000,
      createdAt: new Date(Date.now() - 2 * 60 * 1000).toISOString(),
    },
  ]);

  const handleApprove = (id: string) => {
    console.log(`Approved request: ${id}`);
    // TODO: API call
  };

  const handleReject = (id: string) => {
    console.log(`Rejected request: ${id}`);
    // TODO: API call
  };

  const ROW_HEIGHT = 48;
  const PAGINATION_ROW_HEIGHT = 52;
  const TABLE_HEADER_HEIGHT = 48;
  const LAYOUT_BUFFER = 12;

  const [page, setPage] = useState(1);
  const [dynamicPageSize, setDynamicPageSize] = useState(10);
  const tableContainerRef = useRef<HTMLDivElement>(null);
  const firstRowRef = useRef<HTMLDivElement>(null);
  const paginationRowRef = useRef<HTMLDivElement>(null);

  const total = requests.length;
  const totalPages = Math.ceil(total / dynamicPageSize);
  const rangeStart = total === 0 ? 0 : (page - 1) * dynamicPageSize + 1;
  const rangeEnd = Math.min(page * dynamicPageSize, total);
  const pageData = requests.slice((page - 1) * dynamicPageSize, page * dynamicPageSize);

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
    window.addEventListener("resize", calcLayout);
    return () => window.removeEventListener("resize", calcLayout);
  }, []);

  useEffect(() => { setPage(1); }, [requests.length, dynamicPageSize]);

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

        {(requests.length === 0) ? (
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
          pageData.map((req, idx) => {
            const { display, isExpired, isUrgent } = useCountdown(req.createdAt);
            return (
              <div
                key={req.id}
                ref={pageData.length > 0 && idx === 0 ? firstRowRef : undefined}
                style={{
                  display: "grid",
                  gridTemplateColumns: "140px 1fr 120px 90px 100px 90px 90px 50px",
                  gap: "12px",
                  padding: "12px 20px",
                  borderBottom: idx < pageData.length - 1 ? "1px solid var(--borderColor-default)" : "none",
                  alignItems: "center",
                  transition: "background-color 0.1s ease",
                }}
                onMouseOver={(e) => { e.currentTarget.style.backgroundColor = "rgba(255,255,255,0.02)"; }}
                onMouseOut={(e) => { e.currentTarget.style.backgroundColor = "transparent"; }}
              >
                {/* User */}
                <span
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.8125rem",
                    color: "var(--fgColor-default)",
                  }}
                >
                  {req.userName}
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
                  {req.domain}
                </span>

                {/* Service Type */}
                <span
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.8125rem",
                    color: "var(--fgColor-default)",
                  }}
                >
                  {req.serviceType}
                </span>

                {/* Duration */}
                <span
                  style={{
                    fontFamily: "var(--font-mono, monospace)",
                    fontSize: "0.8125rem",
                    color: "var(--fgColor-default)",
                  }}
                >
                  {formatDuration(req.durationMinutes)}
                </span>

                {/* Earnings */}
                <span
                  style={{
                    fontFamily: "var(--font-mono, monospace)",
                    fontSize: "0.8125rem",
                    color: "var(--fgColor-default)",
                  }}
                >
                  {formatEarnings(req.earningsCents)}
                </span>

                {/* Expires In */}
                <span
                  style={{
                    fontFamily: "var(--font-mono, monospace)",
                    fontSize: "0.8125rem",
                    color: isExpired ? "var(--fgColor-muted)" : isUrgent ? "#E70000" : "#FDA422",
                    fontWeight: isUrgent ? 600 : 400,
                  }}
                >
                  {isExpired ? "Expired" : display}
                </span>

                {/* Status */}
                <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
                  <span
                    style={{
                      width: "8px",
                      height: "8px",
                      borderRadius: "50%",
                      backgroundColor: isExpired ? "#818178" : "#FDA422",
                    }}
                  />
                  <span
                    style={{
                      fontFamily: "var(--font-sans)",
                      fontSize: "0.8125rem",
                      color: "var(--fgColor-default)",
                    }}
                  >
                    {isExpired ? "Expired" : "Pending"}
                  </span>
                </div>

                {/* Actions */}
                <RequestActionDropdown
                  onApprove={() => handleApprove(req.id)}
                  onReject={() => handleReject(req.id)}
                />
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
        onClick={() => setIsOpen(!isOpen)}
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
            onClick={() => {
              setIsOpen(false);
              onReschedule();
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
            onClick={() => {
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

interface UpcomingEntry {
  id: string;
  userName: string;
  domain: string;
  serviceType: string;
  durationMinutes: number;
  fromTime: string; // HH:mm IST
  toTime: string;   // HH:mm IST
  date: string;     // e.g. 22 May 2026
  earningsCents: number;
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

interface LiveSessionEntry {
  id: string;
  userName: string;
  domain: string;
  serviceType: string;
  startedAt: string;
  earningsCents: number;
}

function formatElapsed(startedAt: string): string {
  const diff = Date.now() - new Date(startedAt).getTime();
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
    <div ref={dropdownRef} style={{ position: "relative" }}>
      <button
        onClick={() => setIsOpen(!isOpen)}
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
            onClick={() => {
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
  const handleReport = (id: string) => {
    console.log(`Report session: ${id}`);
    // TODO: API call
  };

  return (
    <>
      <style>{`
        @keyframes liveBlink {
          0%, 100% { opacity: 1; }
          50% { opacity: 0.2; }
        }
      `}</style>
      <div style={{ marginBottom: "32px" }}>
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
            gridTemplateColumns: "140px 1fr 100px 100px 100px 80px 50px",
            gap: "12px",
            padding: "12px 20px",
            borderBottom: "1px solid var(--borderColor-default)",
            backgroundColor: "var(--bgColor-muted)",
          }}
        >
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>User</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Domain</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Service</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Time Elapsed</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Earnings</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Status</span>
          <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>Actions</span>
        </div>

        {/* Table rows */}
        {sessions.map((s, idx) => {
          return (
            <div
              key={s.id}
              style={{
                display: "grid",
                gridTemplateColumns: "140px 1fr 100px 100px 100px 80px 50px",
                gap: "12px",
                padding: "12px 20px",
                borderBottom: idx < sessions.length - 1 ? "1px solid var(--borderColor-default)" : "none",
                alignItems: "center",
                transition: "background-color 0.1s ease",
              }}
              onMouseOver={(e) => { e.currentTarget.style.backgroundColor = "rgba(255,255,255,0.02)"; }}
              onMouseOut={(e) => { e.currentTarget.style.backgroundColor = "transparent"; }}
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

              {/* Time Elapsed */}
              <span
                style={{
                  fontFamily: "var(--font-mono, monospace)",
                  fontSize: "0.8125rem",
                  color: "var(--fgColor-default)",
                }}
              >
                {formatElapsed(s.startedAt)}
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
          );
        })}
      </div>
    </div>
    </>
  );
}

// --- Upcoming Sessions Table ---
function UpcomingTable() {
  const [sessions, setSessions] = useState<UpcomingEntry[]>([
    {
      id: "UP-001",
      userName: "Rahul S.",
      domain: "Deep Learning",
      serviceType: "Project Review",
      durationMinutes: 60,
      fromTime: "10:00",
      toTime: "11:00",
      date: "22 May 2026",
      earningsCents: 100000,
    },
  ]);

  const handleReschedule = (id: string) => {
    console.log(`Reschedule session: ${id}`);
    // TODO: API call
  };

  const handleCancel = (id: string) => {
    console.log(`Cancel session: ${id}`);
    // TODO: API call
  };

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

  const total = sessions.length;
  const totalPages = Math.ceil(total / dynamicPageSize);
  const rangeStart = total === 0 ? 0 : (page - 1) * dynamicPageSize + 1;
  const rangeEnd = Math.min(page * dynamicPageSize, total);
  const pageData = sortedSessions.slice((page - 1) * dynamicPageSize, page * dynamicPageSize);

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
    window.addEventListener("resize", calcLayout);
    return () => window.removeEventListener("resize", calcLayout);
  }, []);

  useEffect(() => { setPage(1); }, [sessions.length, dynamicPageSize]);

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
          pageData.map((s, idx) => (
            <div
              key={s.id}
              ref={pageData.length > 0 && idx === 0 ? firstRowRef : undefined}
              style={{
                display: "grid",
                gridTemplateColumns: "140px 1fr 100px 80px 80px 80px 100px 100px 80px 50px",
                gap: "12px",
                padding: "12px 20px",
                borderBottom: idx < pageData.length - 1 ? "1px solid var(--borderColor-default)" : "none",
                alignItems: "center",
                transition: "background-color 0.1s ease",
              }}
              onMouseOver={(e) => { e.currentTarget.style.backgroundColor = "rgba(255,255,255,0.02)"; }}
              onMouseOut={(e) => { e.currentTarget.style.backgroundColor = "transparent"; }}
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
          ))
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

// --- Generic empty state for Upcoming / Complete ---
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
    complete: {
      title: "No completed sessions",
      message: "Your completed session history will appear here.",
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

  const [liveSessions, setLiveSessions] = useState<LiveSessionEntry[]>([
    {
      id: "LIVE-001",
      userName: "Ananya R.",
      domain: "Natural Language Processing",
      serviceType: "Paper Discussion",
      startedAt: "2026-05-20T10:15:00.000Z",
      earningsCents: 42556,
    },
  ]);
  const [tick, setTick] = useState(0);

  useEffect(() => {
    const hasLive = liveSessions.length > 0;
    if (!hasLive) return;
    const interval = setInterval(() => setTick((t) => t + 1), 1000);
    return () => clearInterval(interval);
  }, [liveSessions]);

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
        <RequestsTable />
      ) : currentSubTab === "upcoming" ? (
        <>
          {liveSessions.length > 0 && <LiveSessionSection sessions={liveSessions} tick={tick} />}
          <UpcomingTable />
        </>
      ) : (
        <EmptySessionsState subTab={currentSubTab} />
      )}
    </div>
  );
}
