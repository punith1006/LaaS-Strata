"use client";

import { useEffect, useState, useRef, useMemo } from "react";
import {
  type StudentRequestEntry,
  type StudentUpcomingSession,
  type StudentPastEntry,
  getStudentSessionRequests,
  getStudentUpcomingSessions,
  getStudentSessionPast,
  studentCancelMentorSession,
} from "@/lib/api";

// --- Duration formatting ---
function formatDuration(minutes: number): string {
  if (minutes < 60) return `${minutes} min`;
  const hrs = minutes / 60;
  return hrs % 1 === 0 ? `${hrs} hr` : `${hrs.toFixed(1)} hrs`;
}

// --- Cost formatting ---
function formatCost(cents: number): string {
  return `\u20B9${(cents / 100).toFixed(2)}`;
}

// --- Action Dropdown for student sessions ---
function StudentActionDropdown({ onCancel }: { onCancel: () => void }) {
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
          width: "32px", height: "32px", borderRadius: "4px",
          backgroundColor: isOpen ? "var(--bgColor-muted)" : "transparent",
          border: "none", display: "flex", alignItems: "center", justifyContent: "center",
          cursor: "pointer", color: "var(--fgColor-muted)",
          transition: "background-color 0.15s ease",
        }}
        onMouseOver={(e) => { if (!isOpen) e.currentTarget.style.backgroundColor = "var(--bgColor-muted)"; }}
        onMouseOut={(e) => { if (!isOpen) e.currentTarget.style.backgroundColor = "transparent"; }}
      >
        <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
          <circle cx="12" cy="5" r="2" /><circle cx="12" cy="12" r="2" /><circle cx="12" cy="19" r="2" />
        </svg>
      </button>
      {isOpen && (
        <div style={{
          position: "absolute", top: "100%", right: 0, marginTop: "4px",
          backgroundColor: "var(--bgColor-elevated, var(--bgColor-default))",
          border: "1px solid var(--borderColor-default)", borderRadius: "4px",
          boxShadow: "0 4px 16px rgba(0,0,0,0.15)", zIndex: 100, minWidth: "140px", overflow: "hidden",
        }}>
          <button
            onClick={() => { setIsOpen(false); onCancel(); }}
            style={{
              width: "100%", display: "flex", alignItems: "center", gap: "8px",
              padding: "10px 12px", backgroundColor: "transparent", border: "none",
              cursor: "pointer", fontFamily: "var(--font-sans)", fontSize: "0.8125rem",
              color: "var(--fgColor-default)", textAlign: "left",
              transition: "background-color 0.15s ease",
            }}
            onMouseOver={(e) => { e.currentTarget.style.backgroundColor = "var(--bgColor-muted)"; }}
            onMouseOut={(e) => { e.currentTarget.style.backgroundColor = "transparent"; }}
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" />
            </svg>
            Cancel
          </button>
        </div>
      )}
    </div>
  );
}

// --- Pagination hook ---
function useDynamicPagination(total: number) {
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

  const totalPages = Math.ceil(total / dynamicPageSize);
  const rangeStart = total === 0 ? 0 : (page - 1) * dynamicPageSize + 1;
  const rangeEnd = Math.min(page * dynamicPageSize, total);

  useEffect(() => {
    const calcLayout = () => {
      if (!tableContainerRef.current) return;
      const containerTop = tableContainerRef.current.getBoundingClientRect().top;
      const actualRowHeight = firstRowRef.current
        ? firstRowRef.current.getBoundingClientRect().height : ROW_HEIGHT;
      const actualPaginationHeight = paginationRowRef.current
        ? paginationRowRef.current.getBoundingClientRect().height : PAGINATION_ROW_HEIGHT;
      const headerEl = tableContainerRef.current.firstElementChild as HTMLElement | null;
      const actualHeaderHeight = headerEl
        ? headerEl.getBoundingClientRect().height : TABLE_HEADER_HEIGHT;
      const availableForRows = window.innerHeight - containerTop - 2 - actualHeaderHeight - actualPaginationHeight - LAYOUT_BUFFER;
      const rows = Math.max(1, Math.floor(availableForRows / actualRowHeight));
      setDynamicPageSize(rows);
    };
    calcLayout();
    calcLayoutRef.current = calcLayout;
    window.addEventListener("resize", calcLayout);
    return () => window.removeEventListener("resize", calcLayout);
  }, []);

  useEffect(() => { setPage(1); }, [total, dynamicPageSize]);
  useEffect(() => { requestAnimationFrame(() => calcLayoutRef.current && calcLayoutRef.current()); }, [total]);

  return { page, setPage, totalPages, rangeStart, rangeEnd, dynamicPageSize, tableContainerRef, firstRowRef, paginationRowRef };
}

// --- Pagination Controls ---
function PaginationControls({ page, totalPages, rangeStart, rangeEnd, total, setPage }: {
  page: number; totalPages: number; rangeStart: number; rangeEnd: number; total: number;
  setPage: (fn: (p: number) => number) => void;
}) {
  if (total <= 0) return null;
  return (
    <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: "16px", padding: "0 4px" }}>
      <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.875rem", color: "var(--fgColor-muted)" }}>
        Showing {rangeStart}-{rangeEnd} of {total.toLocaleString("en-IN")}
      </span>
      <div style={{ display: "flex", gap: "8px" }}>
        <button type="button" onClick={() => setPage((p) => Math.max(1, p - 1))} disabled={page <= 1}
          style={{ padding: "6px 12px", backgroundColor: "var(--bgColor-muted)", border: "1px solid var(--borderColor-default)", borderRadius: "4px", fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: page <= 1 ? "var(--fgColor-muted)" : "var(--fgColor-default)", cursor: page <= 1 ? "not-allowed" : "pointer", opacity: page <= 1 ? 0.5 : 1 }}>
          Previous
        </button>
        <button type="button" onClick={() => setPage((p) => Math.min(totalPages || 1, p + 1))} disabled={page >= totalPages || totalPages === 0}
          style={{ padding: "6px 12px", backgroundColor: "var(--bgColor-muted)", border: "1px solid var(--borderColor-default)", borderRadius: "4px", fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: page >= totalPages || totalPages === 0 ? "var(--fgColor-muted)" : "var(--fgColor-default)", cursor: page >= totalPages || totalPages === 0 ? "not-allowed" : "pointer", opacity: page >= totalPages || totalPages === 0 ? 0.5 : 1 }}>
          Next
        </button>
      </div>
    </div>
  );
}

// --- Empty State ---
function EmptyState({ title, message }: { title: string; message: string }) {
  return (
    <div style={{ display: "grid", gridTemplateColumns: "1fr", padding: "48px 24px", textAlign: "center", justifyItems: "center" }}>
      <div>
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="var(--fgColor-muted)" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" style={{ margin: "0 auto 16px", display: "block" }}>
          <rect x="3" y="4" width="18" height="18" rx="2" ry="2" /><line x1="16" y1="2" x2="16" y2="6" /><line x1="8" y1="2" x2="8" y2="6" /><line x1="3" y1="10" x2="21" y2="10" />
        </svg>
        <h3 style={{ fontFamily: "var(--font-sans)", fontSize: "1rem", fontWeight: 600, color: "var(--fgColor-default)", margin: "0 0 8px 0" }}>{title}</h3>
        <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.875rem", color: "var(--fgColor-muted)", margin: 0 }}>{message}</p>
      </div>
    </div>
  );
}

// --- Requests Table ---
function RequestsTable({ requests, onCancel }: { requests: StudentRequestEntry[]; onCancel: (id: string) => void }) {
  const sorted = useMemo(() => [...requests].sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()), [requests]);
  const { page, setPage, totalPages, rangeStart, rangeEnd, dynamicPageSize, tableContainerRef, firstRowRef, paginationRowRef } = useDynamicPagination(sorted.length);
  const pageData = sorted.slice((page - 1) * dynamicPageSize, page * dynamicPageSize);

  return (
    <div>
      <h2 style={{ fontFamily: "var(--font-sans)", fontSize: "1.25rem", fontWeight: 600, color: "var(--fgColor-default)", margin: "24px 0 16px 0" }}>Session Requests</h2>
      <div ref={tableContainerRef} style={{ backgroundColor: "var(--bgColor-mild)", border: "1px solid var(--borderColor-default)", borderRadius: "4px", overflow: "visible" }}>
        {/* Header */}
        <div style={{ display: "grid", gridTemplateColumns: "160px 1fr 120px 90px 120px 100px 90px 50px", gap: "12px", padding: "12px 20px", borderBottom: "1px solid var(--borderColor-default)", backgroundColor: "var(--bgColor-muted)" }}>
          {["Mentor", "Domain", "Service", "Duration", "Date", "Cost", "Status", "Actions"].map(h => (
            <span key={h} style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>{h}</span>
          ))}
        </div>
        {sorted.length === 0 ? (
          <EmptyState title="No pending requests" message="You don't have any pending session requests right now." />
        ) : (
          pageData.map((req, idx) => {
            const dateStr = new Date(req.createdAt).toLocaleDateString("en-IN", { day: "2-digit", month: "short", year: "numeric" });
            return (
              <div key={req.id} ref={idx === 0 ? firstRowRef : undefined}
                style={{ display: "grid", gridTemplateColumns: "160px 1fr 120px 90px 120px 100px 90px 50px", gap: "12px", padding: "12px 20px", borderBottom: idx < pageData.length - 1 ? "1px solid var(--borderColor-default)" : "none", alignItems: "center", transition: "background-color 0.1s ease" }}
                onMouseOver={(e) => { e.currentTarget.style.backgroundColor = "rgba(255,255,255,0.02)"; }}
                onMouseOut={(e) => { e.currentTarget.style.backgroundColor = "transparent"; }}>
                <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{req.mentorName}</span>
                <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{req.domain}</span>
                <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{req.serviceType}</span>
                <span style={{ fontFamily: "var(--font-mono, monospace)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{formatDuration(req.durationMinutes)}</span>
                <span style={{ fontFamily: "var(--font-mono, monospace)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{dateStr}</span>
                <span style={{ fontFamily: "var(--font-mono, monospace)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{formatCost(req.earningsCents)}</span>
                <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
                  <span style={{ width: "8px", height: "8px", borderRadius: "50%", backgroundColor: "#FDA422" }} />
                  <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>Pending</span>
                </div>
                <StudentActionDropdown onCancel={() => onCancel(req.id)} />
              </div>
            );
          })
        )}
      </div>
      <PaginationControls page={page} totalPages={totalPages} rangeStart={rangeStart} rangeEnd={rangeEnd} total={sorted.length} setPage={setPage} />
    </div>
  );
}

// --- Upcoming Table ---
function UpcomingTable({ sessions, onCancel }: { sessions: StudentUpcomingSession[]; onCancel: (id: string) => void }) {
  const sorted = useMemo(() => {
    return [...sessions].sort((a, b) => {
      const dateA = new Date(a.scheduledFrom).getTime();
      const dateB = new Date(b.scheduledFrom).getTime();
      return dateA - dateB;
    });
  }, [sessions]);

  const { page, setPage, totalPages, rangeStart, rangeEnd, dynamicPageSize, tableContainerRef, firstRowRef, paginationRowRef } = useDynamicPagination(sorted.length);
  const pageData = sorted.slice((page - 1) * dynamicPageSize, page * dynamicPageSize);

  return (
    <div>
      <h2 style={{ fontFamily: "var(--font-sans)", fontSize: "1.25rem", fontWeight: 600, color: "var(--fgColor-default)", margin: "24px 0 16px 0" }}>Upcoming Sessions</h2>
      <div ref={tableContainerRef} style={{ backgroundColor: "var(--bgColor-mild)", border: "1px solid var(--borderColor-default)", borderRadius: "4px", overflow: "visible" }}>
        {/* Header */}
        <div style={{ display: "grid", gridTemplateColumns: "160px 1fr 100px 80px 80px 80px 110px 100px 90px 50px", gap: "12px", padding: "12px 20px", borderBottom: "1px solid var(--borderColor-default)", backgroundColor: "var(--bgColor-muted)" }}>
          {["Mentor", "Domain", "Service", "Duration", "From", "To", "Date", "Cost", "Status", "Actions"].map(h => (
            <span key={h} style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>{h}</span>
          ))}
        </div>
        {sorted.length === 0 ? (
          <EmptyState title="No upcoming sessions" message="You don't have any upcoming sessions scheduled." />
        ) : (
          pageData.map((s, idx) => {
            const fromDate = new Date(s.scheduledFrom);
            const toDate = new Date(s.scheduledTo);
            const fromTime = `${String(fromDate.getHours()).padStart(2, "0")}:${String(fromDate.getMinutes()).padStart(2, "0")}`;
            const toTime = `${String(toDate.getHours()).padStart(2, "0")}:${String(toDate.getMinutes()).padStart(2, "0")}`;
            const dateStr = fromDate.toLocaleDateString("en-IN", { day: "2-digit", month: "short", year: "numeric" });
            return (
              <div key={s.id} ref={idx === 0 ? firstRowRef : undefined}
                style={{ display: "grid", gridTemplateColumns: "160px 1fr 100px 80px 80px 80px 110px 100px 90px 50px", gap: "12px", padding: "12px 20px", borderBottom: idx < pageData.length - 1 ? "1px solid var(--borderColor-default)" : "none", alignItems: "center", transition: "background-color 0.1s ease" }}
                onMouseOver={(e) => { e.currentTarget.style.backgroundColor = "rgba(255,255,255,0.02)"; }}
                onMouseOut={(e) => { e.currentTarget.style.backgroundColor = "transparent"; }}>
                <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{s.mentorName}</span>
                <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{s.domain}</span>
                <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{s.serviceType}</span>
                <span style={{ fontFamily: "var(--font-mono, monospace)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{formatDuration(s.durationMinutes)}</span>
                <span style={{ fontFamily: "var(--font-mono, monospace)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{fromTime}</span>
                <span style={{ fontFamily: "var(--font-mono, monospace)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{toTime}</span>
                <span style={{ fontFamily: "var(--font-mono, monospace)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{dateStr}</span>
                <span style={{ fontFamily: "var(--font-mono, monospace)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{formatCost(s.earningsCents)}</span>
                <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
                  <span style={{ width: "8px", height: "8px", borderRadius: "50%", backgroundColor: "#05C004" }} />
                  <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>Confirmed</span>
                </div>
                <StudentActionDropdown onCancel={() => onCancel(s.id)} />
              </div>
            );
          })
        )}
      </div>
      <PaginationControls page={page} totalPages={totalPages} rangeStart={rangeStart} rangeEnd={rangeEnd} total={sorted.length} setPage={setPage} />
    </div>
  );
}

// --- Past Table ---
function PastTable({ entries }: { entries: StudentPastEntry[] }) {
  const sorted = useMemo(() => [...entries].sort((a, b) => new Date(b.scheduledFrom).getTime() - new Date(a.scheduledFrom).getTime()), [entries]);
  const { page, setPage, totalPages, rangeStart, rangeEnd, dynamicPageSize, tableContainerRef, firstRowRef, paginationRowRef } = useDynamicPagination(sorted.length);
  const pageData = sorted.slice((page - 1) * dynamicPageSize, page * dynamicPageSize);

  const statusConfig: Record<StudentPastEntry["status"], { color: string; label: string }> = {
    Completed: { color: "#05C004", label: "Completed" },
    Cancelled: { color: "#E70000", label: "Cancelled" },
    Rejected: { color: "#E70000", label: "Rejected" },
    Expired: { color: "#818178", label: "Expired" },
    Missed: { color: "#818178", label: "Missed" },
    Disputed: { color: "#FDA422", label: "Disputed" },
  };

  return (
    <div>
      <h2 style={{ fontFamily: "var(--font-sans)", fontSize: "1.25rem", fontWeight: 600, color: "var(--fgColor-default)", margin: "24px 0 16px 0" }}>Past Sessions</h2>
      <div ref={tableContainerRef} style={{ backgroundColor: "var(--bgColor-mild)", border: "1px solid var(--borderColor-default)", borderRadius: "4px", overflow: "visible" }}>
        <div style={{ display: "grid", gridTemplateColumns: "160px 1fr 120px 90px 120px 100px 120px", gap: "12px", padding: "12px 20px", borderBottom: "1px solid var(--borderColor-default)", backgroundColor: "var(--bgColor-muted)" }}>
          {["Mentor", "Domain", "Service", "Duration", "Date", "Cost", "Status"].map(h => (
            <span key={h} style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>{h}</span>
          ))}
        </div>
        {sorted.length === 0 ? (
          <EmptyState title="No past sessions" message="Your past session history will appear here." />
        ) : (
          pageData.map((entry, idx) => {
            const sc = statusConfig[entry.status] || { color: "#818178", label: entry.status };
            const dateStr = new Date(entry.scheduledFrom).toLocaleDateString("en-IN", { day: "2-digit", month: "short", year: "numeric" });
            return (
              <div key={entry.id} ref={idx === 0 ? firstRowRef : undefined}
                style={{ display: "grid", gridTemplateColumns: "160px 1fr 120px 90px 120px 100px 120px", gap: "12px", padding: "12px 20px", borderBottom: idx < pageData.length - 1 ? "1px solid var(--borderColor-default)" : "none", alignItems: "center", transition: "background-color 0.1s ease" }}
                onMouseOver={(e) => { e.currentTarget.style.backgroundColor = "rgba(255,255,255,0.02)"; }}
                onMouseOut={(e) => { e.currentTarget.style.backgroundColor = "transparent"; }}>
                <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{entry.mentorName}</span>
                <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{entry.domain}</span>
                <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{entry.serviceType}</span>
                <span style={{ fontFamily: "var(--font-mono, monospace)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{formatDuration(entry.durationMinutes)}</span>
                <span style={{ fontFamily: "var(--font-mono, monospace)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{dateStr}</span>
                <span style={{ fontFamily: "var(--font-mono, monospace)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{entry.status === "Completed" ? formatCost(entry.earningsCents) : entry.status === "Cancelled" && entry.cancelledByStudent && entry.advanceCents ? formatCost(entry.advanceCents) : "--"}</span>
                <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
                  <span style={{ width: "8px", height: "8px", borderRadius: "50%", backgroundColor: sc.color }} />
                  <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{sc.label}</span>
                </div>
              </div>
            );
          })
        )}
      </div>
      <PaginationControls page={page} totalPages={totalPages} rangeStart={rangeStart} rangeEnd={rangeEnd} total={sorted.length} setPage={setPage} />
    </div>
  );
}

// --- Main Component ---
export default function MentorUserSessionsTab({ activeTab }: { activeTab: "requests" | "upcoming" | "past" }) {
  const [requests, setRequests] = useState<StudentRequestEntry[]>([]);
  const [upcoming, setUpcoming] = useState<StudentUpcomingSession[]>([]);
  const [past, setPast] = useState<StudentPastEntry[]>([]);
  const [loading, setLoading] = useState(true);
  const [showCancelModal, setShowCancelModal] = useState(false);
  const [cancelType, setCancelType] = useState<
    'upcoming' | 'request'
  >('upcoming');
  const [cancelId, setCancelId] = useState<string | null>(null);
  const [cancelReason, setCancelReason] = useState('');
  const [cancelling, setCancelling] = useState(false);

  const fetchData = () => {
    setLoading(true);
    Promise.all([
      getStudentSessionRequests(),
      getStudentUpcomingSessions(),
      getStudentSessionPast(),
    ]).then(([reqs, up, p]) => {
      setRequests(reqs);
      setUpcoming(up);
      setPast(p);
      setLoading(false);
    }).catch(() => setLoading(false));
  };

  useEffect(() => { fetchData(); }, []);

  const handleCancelRequest = (id: string) => {
    setCancelType('request');
    setCancelId(id);
    setCancelReason('');
    setShowCancelModal(true);
  };

  const handleCancelUpcoming = (id: string) => {
    setCancelType('upcoming');
    setCancelId(id);
    setCancelReason('');
    setShowCancelModal(true);
  };

  const cancellingUpcoming = useMemo(
    () =>
      cancelType === 'upcoming'
        ? upcoming.find((s) => s.id === cancelId) ?? null
        : null,
    [cancelType, cancelId, upcoming],
  );

  const cancellingRequest = useMemo(
    () =>
      cancelType === 'request'
        ? requests.find((r) => r.id === cancelId) ?? null
        : null,
    [cancelType, cancelId, requests],
  );

  const confirmStudentCancel = async () => {
    if (!cancelId) return;
    setCancelling(true);
    const ok = await studentCancelMentorSession(
      cancelId,
      cancelReason.trim() || undefined,
    );
    if (ok) {
      if (cancelType === 'upcoming') {
        setUpcoming((prev) =>
          prev.filter((s) => s.id !== cancelId),
        );
      } else {
        setRequests((prev) =>
          prev.filter((r) => r.id !== cancelId),
        );
      }
    }
    setCancelling(false);
    setShowCancelModal(false);
    setCancelId(null);
    setCancelReason('');
  };

  const wordCount = cancelReason.trim()
    ? cancelReason.trim().split(/\s+/).length
    : 0;

  if (loading) {
    return (
      <div style={{ padding: "48px 24px", textAlign: "center" }}>
        <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.875rem", color: "var(--fgColor-muted)" }}>Loading sessions...</p>
      </div>
    );
  }

  return (
    <>
    <div>
      {activeTab === "requests" && <RequestsTable requests={requests} onCancel={handleCancelRequest} />}
      {activeTab === "upcoming" && <UpcomingTable sessions={upcoming} onCancel={handleCancelUpcoming} />}
      {activeTab === "past" && <PastTable entries={past} />}
    </div>

      {/* ── Cancel Session Modal ── */}
      {showCancelModal && (cancelType === 'upcoming' ? cancellingUpcoming : cancellingRequest) && (
        <>
          {/* Overlay */}
          <div
            onClick={() => {
              setShowCancelModal(false);
              setCancelId(null);
              setCancelReason('');
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
                {cancelType === 'request'
                  ? 'Cancel Request'
                  : 'Cancel Session'}
              </h2>
              <button
                onClick={() => {
                  setShowCancelModal(false);
                  setCancelId(null);
                  setCancelReason('');
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
                {cancelType === 'request'
                  ? 'Cancel session request with '
                  : 'Cancel session with '}
                {cancelType === 'upcoming'
                  ? cancellingUpcoming?.mentorName
                  : cancellingRequest?.mentorName}
                ?
              </h3>

              {/* Session Info */}
              <div
                style={{
                  marginBottom: '16px',
                  fontFamily: 'var(--font-sans)',
                  fontSize: '0.875rem',
                  color: 'var(--fgColor-muted)',
                  lineHeight: '1.6',
                }}
              >
                {cancelType === 'upcoming' && cancellingUpcoming ? (
                  <>
                    <div>
                      {cancellingUpcoming.domain} ·{" "}
                      {cancellingUpcoming.serviceType} ·{" "}
                      {formatDuration(
                        cancellingUpcoming.durationMinutes,
                      )}
                    </div>
                    <div>
                      {new Date(
                        cancellingUpcoming.scheduledFrom,
                      ).toLocaleDateString('en-IN', {
                        day: '2-digit',
                        month: 'short',
                        year: 'numeric',
                      })}{" "}
                      ·{' '}
                      {`${String(
                        new Date(cancellingUpcoming.scheduledFrom)
                          .getHours(),
                      ).padStart(2, '0')}:${String(
                        new Date(cancellingUpcoming.scheduledFrom)
                          .getMinutes(),
                      ).padStart(2, '0')}`}
                      {' '}-
                      {' '}
                      {`${String(
                        new Date(cancellingUpcoming.scheduledTo)
                          .getHours(),
                      ).padStart(2, '0')}:${String(
                        new Date(cancellingUpcoming.scheduledTo)
                          .getMinutes(),
                      ).padStart(2, '0')}`}
                    </div>
                  </>
                ) : cancellingRequest ? (
                  <div>
                    {cancellingRequest.domain} ·{" "}
                    {cancellingRequest.serviceType} ·{" "}
                    {formatDuration(
                      cancellingRequest.durationMinutes,
                    )}
                  </div>
                ) : null}
              </div>

              {/* Payment Warning for upcoming */}
              {cancelType === 'upcoming' && cancellingUpcoming && (
                <>
                  {cancellingUpcoming.advanceCents &&
                  cancellingUpcoming.advanceCents > 0 ? (
                    <div
                      style={{
                        backgroundColor: '#fef2f2',
                        border: '1px solid #ef4444',
                        borderRadius: '4px',
                        padding: '12px 16px',
                        marginBottom: '16px',
                      }}
                    >
                      <p
                        style={{
                          fontFamily: 'var(--font-sans)',
                          fontSize: '0.8125rem',
                          color: '#991b1b',
                          margin: 0,
                          fontWeight: 500,
                        }}
                      >
                        You have paid an advance of ₹
                        {(cancellingUpcoming.advanceCents / 100).toFixed(
                          2,
                        )}
                        {' '}which is non-refundable as per
                        T&C.
                      </p>
                    </div>
                  ) : cancellingUpcoming.paymentStatus === 'paid' ? (
                    <div
                      style={{
                        backgroundColor: '#fef2f2',
                        border: '1px solid #ef4444',
                        borderRadius: '4px',
                        padding: '12px 16px',
                        marginBottom: '16px',
                      }}
                    >
                      <p
                        style={{
                          fontFamily: 'var(--font-sans)',
                          fontSize: '0.8125rem',
                          color: '#991b1b',
                          margin: 0,
                          fontWeight: 500,
                        }}
                      >
                        The full session fee of ₹
                        {(cancellingUpcoming.earningsCents / 100).toFixed(
                          2,
                        )}
                        {' '}has been paid and is
                        non-refundable as per T&C.
                      </p>
                    </div>
                  ) : null}
                </>
              )}

              {/* Reason Input */}
              <div style={{ marginBottom: '16px' }}>
                <div
                  style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                    marginBottom: '8px',
                  }}
                >
                  <label
                    style={{
                      fontFamily: 'var(--font-sans)',
                      fontSize: '0.8125rem',
                      fontWeight: 500,
                      color: 'var(--fgColor-default)',
                    }}
                  >
                    Reason for cancellation
                  </label>
                  <span
                    style={{
                      fontFamily: 'var(--font-mono, monospace)',
                      fontSize: '0.75rem',
                      color:
                        wordCount >= 10
                          ? '#ef4444'
                          : 'var(--fgColor-muted)',
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
                    width: '100%',
                    fontFamily: 'var(--font-sans)',
                    fontSize: '0.875rem',
                    color: 'var(--fgColor-default)',
                    backgroundColor: 'transparent',
                    border: '1px solid #818178',
                    borderRadius: '4px',
                    padding: '8px 12px',
                    height: '40px',
                    outline: 'none',
                    boxSizing: 'border-box',
                  }}
                  onFocus={(e) => {
                    e.target.style.border =
                      '1px solid var(--fgColor-default)';
                  }}
                  onBlur={(e) => {
                    e.target.style.border = '1px solid #818178';
                  }}
                />
              </div>
            </div>

            {/* Modal Footer */}
            <div
              style={{
                display: 'flex',
                justifyContent: 'flex-end',
                gap: '12px',
                padding: '0 32px 24px 32px',
              }}
            >
              <button
                onClick={() => {
                  setShowCancelModal(false);
                  setCancelId(null);
                  setCancelReason('');
                }}
                style={{
                  fontFamily: 'var(--font-sans)',
                  fontSize: '0.875rem',
                  fontWeight: 500,
                  color: 'var(--fgColor-default)',
                  backgroundColor: 'transparent',
                  border: '1px solid #818178',
                  borderRadius: '4px',
                  padding: '0 20px',
                  height: '40px',
                  cursor: 'pointer',
                  transition: 'opacity 0.15s ease',
                }}
                onMouseEnter={(e) =>
                  (e.currentTarget.style.opacity = '0.85')
                }
                onMouseLeave={(e) =>
                  (e.currentTarget.style.opacity = '1')
                }
              >
                Cancel
              </button>
              <button
                onClick={confirmStudentCancel}
                disabled={cancelling}
                style={{
                  fontFamily: 'var(--font-sans)',
                  fontSize: '0.875rem',
                  fontWeight: 500,
                  color: '#ffffff',
                  backgroundColor: '#da3633',
                  border: '1px solid #da3633',
                  borderRadius: '4px',
                  padding: '0 20px',
                  height: '40px',
                  cursor: cancelling
                    ? 'not-allowed'
                    : 'pointer',
                  opacity: cancelling ? 0.5 : 1,
                  transition: 'opacity 0.15s ease',
                }}
              >
                {cancelling
                  ? 'Cancelling...'
                  : 'Confirm Cancellation'}
              </button>
            </div>
          </div>
        </>
      )}
    </>
  );
}
