"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import type { ReactNode } from "react";
import { Search } from "lucide-react";
import { getAnalyticsAccessToken } from "@/lib/token";
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Cell, ResponsiveContainer,
} from "recharts";

const API_BASE = process.env.NEXT_PUBLIC_API_URL || "";

// Row height constants for dynamic viewport-fit page sizing
const ROW_HEIGHT = 48;
const PAGINATION_ROW_HEIGHT = 52;
const TABLE_HEADER_HEIGHT = 48;
const LAYOUT_BUFFER = 12; // px of extra safety to prevent bottom clipping

type UsersTab = "users" | "dept";

interface UserRow {
  id: string;
  firstName: string;
  lastName: string;
  email: string;
  clientName: string | null;
  profession: string | null;
  timezone: string;
  joinDate: string;
  isActive: boolean;
  lastLoginAt: string | null;
}

interface ActiveSession {
  id: string;
  instanceName?: string;
  containerName?: string;
  status: string;
  startedAt: string | null;
  cumulativeCostCents: number;
  computeConfig?: { name: string; basePricePerHourCents: number };
  allocatedGpuVramMb?: number;
}

interface ClientOption {
  id: string;
  name: string;
}

interface DeptOption {
  id: string;
  name: string;
}

interface UsersResponse {
  users: UserRow[];
  total: number;
  totalPages: number;
  page: number;
  limit: number;
}

interface ClientsResponse {
  clients: ClientOption[];
}

interface DepartmentsResponse {
  departments: DeptOption[];
}

interface UserDetail {
  id: string;
  displayName: string | null;
  phone: string | null;
  authType: string;
  oauthProvider: string | null;
  emailVerified: boolean;
  roles: string[];
  collegeName: string | null;
  departmentName: string | null;
  courseName: string | null;
  academicYear: number | null;
  operationalDomains: string[];
  useCasePurposes: string[];
  expertiseLevel: string | null;
  githubUrl: string | null;
  linkedinUrl: string | null;
  websiteUrl: string | null;
  skills: string[];
  hasActiveSession: boolean;
  lastLoginAt: string | null;
  runningComputeSessions: number;
  storageProvisioningStatus: string | null;
  // Wallet / Billing
  balanceCents: number | null;
  currency: string | null;
  lifetimeSpentCents: number | null;
  spendLimitCents: number | null;
  spendLimitEnabled: boolean;

  // Computed billing fields (rupee values)
  burnRateRupees: number;      // Total burn rate in rupees/hour
  dailySpendRupees: number;    // Recent 12h spend in rupees
  runwayHours: number | null;  // Hours of runway remaining
}

interface ComputeActivityData {
  dailyBreakdown: Array<{ date: string; dayName: string; hours: number }>;
  totalHours: number;
  priorTotalHours: number;
  comparisonText: string;
  periodLabel: string;
}

function formatISTDate(isoString: string | null | undefined): string {
  if (!isoString) return "—";
  const d = new Date(isoString);
  if (Number.isNaN(d.getTime())) return "—";
  return d.toLocaleDateString("en-IN", {
    timeZone: "Asia/Kolkata",
    day: "2-digit",
    month: "short",
    year: "numeric",
  });
}

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

/** A single label-value row matching the profile page InfoRow style */
function InfoRow({ label, value, valueColor, isLast = false }: { label: string; value: string | ReactNode; valueColor?: string; isLast?: boolean }) {
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

// --- Active sessions table helpers (mirrored from instances page) ---
const ACTIVE_STATUSES = ["pending", "starting", "running", "reconnecting", "stopping"];
const ENDED_STATUSES = ["ended", "failed", "terminated_idle", "terminated_overuse"];

function formatUptime(startedAt: string | null, status: string): string {
  if (!startedAt || ENDED_STATUSES.includes(status)) return "-";
  const start = new Date(startedAt).getTime();
  const now = Date.now();
  const diff = now - start;
  const hours = Math.floor(diff / 3600000);
  const minutes = Math.floor((diff % 3600000) / 60000);
  if (hours > 0) return `${hours}h ${minutes}m`;
  return `${minutes}m`;
}

function formatCostRupees(cents: number): string {
  const rupees = cents / 100;
  const formatted = rupees.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  return `\u20B9${formatted}`;
}

function calculateLiveCost(session: ActiveSession): number {
  if (ENDED_STATUSES.includes(session.status)) return session.cumulativeCostCents;
  if (!session.startedAt || !session.computeConfig) return 0;
  if (!ACTIVE_STATUSES.includes(session.status) || session.status === 'pending') return 0;
  const elapsedMs = Date.now() - new Date(session.startedAt).getTime();
  const elapsedHours = elapsedMs / 3600000;
  return elapsedHours * session.computeConfig.basePricePerHourCents;
}

function getStatusColor(status: string): string {
  switch (status) {
    case "running": return "#009C00";
    case "pending": case "starting": case "reconnecting": return "#D4A017";
    case "stopping": return "#E76742";
    case "failed": return "var(--fgColor-critical, #E70000)";
    case "ended": case "terminated_idle": case "terminated_overuse": return "var(--fgColor-muted)";
    default: return "var(--fgColor-muted)";
  }
}

function getStatusLabel(status: string): string {
  switch (status) {
    case "running": return "Running";
    case "pending": return "Pending";
    case "starting": return "Starting";
    case "reconnecting": return "Reconnecting";
    case "stopping": return "Stopping";
    case "ended": return "Ended";
    case "failed": return "Failed";
    case "terminated_idle": return "Terminated (Idle)";
    case "terminated_overuse": return "Terminated (Overuse)";
    default: return status;
  }
}

function StatusBadge({ status }: { status: string }) {
  const isPulsing = status === "pending" || status === "starting";
  return (
    <span style={{ display: "inline-flex", alignItems: "center", gap: "6px", fontSize: "0.875rem", fontWeight: 400, color: "var(--fgColor-default)" }}>
      <span style={{ width: "6px", height: "6px", borderRadius: "50%", backgroundColor: getStatusColor(status), animation: isPulsing ? "pulse 1.5s ease-in-out infinite" : "none", flexShrink: 0 }} />
      {getStatusLabel(status)}
      <style>{`@keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.4; } }`}</style>
    </span>
  );
}

/** Color palette for expertise level tags (avoids green/red/blue/grey used elsewhere) */
function getExpertiseColor(level: string): { bg: string; text: string } {
  switch (level.toLowerCase()) {
    case "beginner":
      return { bg: "#D97706", text: "#fff" }; // solid amber
    case "intermediate":
      return { bg: "#0891B2", text: "#fff" }; // solid cyan
    case "advanced":
      return { bg: "#7C3AED", text: "#fff" }; // solid violet
    case "expert":
      return { bg: "#B45309", text: "#fff" }; // solid dark amber
    default:
      return { bg: "var(--bgColor-muted)", text: "var(--fgColor-muted)" };
  }
}

/** Auth badge color + label based on oauthProvider and authType */
function getAuthBadge(oauthProvider: string | null, authType: string): { bg: string; label: string } {
  if (oauthProvider === "google") return { bg: "#4285F4", label: "Google" };
  if (oauthProvider === "github") return { bg: "#333333", label: "GitHub" };
  if (oauthProvider === "keycloak") return { bg: "#4F46E5", label: "Keycloak" };
  if (authType === "university_sso" || authType === "institution_local") return { bg: "#6366F1", label: "SSO" };
  return { bg: "#52525B", label: "Email" };
}

/** Metric card for Balance Summary — matches billing-tab-content MetricCard */
function MetricCard({ icon, label, value, subValue, highlight }: { icon: React.ReactNode; label: string; value: string; subValue?: string; highlight?: boolean }) {
  return (
    <div
      style={{
        backgroundColor: highlight ? "var(--bgColor-info, #cedeff)" : "var(--bgColor-mild)",
        border: highlight ? "1px solid var(--borderColor-info, #3a73ff)" : "1px solid var(--borderColor-default)",
        borderRadius: "4px",
        padding: "16px",
        display: "flex",
        alignItems: "center",
        gap: "12px",
        flex: 1,
        minWidth: "140px",
      }}
    >
      <div
        style={{
          width: "40px",
          height: "40px",
          borderRadius: "4px",
          backgroundColor: highlight ? "transparent" : "var(--bgColor-muted)",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          flexShrink: 0,
        }}
      >
        {icon}
      </div>
      <div>
        <div
          style={{
            fontFamily: "var(--font-sans)",
            fontSize: "var(--text-xs)",
            color: highlight ? "var(--fgColor-info, #3a73ff)" : "var(--fgColor-muted)",
            marginBottom: "2px",
          }}
        >
          {label}
        </div>
        <div
          style={{
            fontFamily: "var(--font-sans)",
            fontSize: "var(--text-h4)",
            fontWeight: 600,
            color: "var(--fgColor-default)",
            lineHeight: 1.2,
          }}
        >
          {value}
        </div>
        {subValue && (
          <div
            style={{
              fontFamily: "var(--font-sans)",
              fontSize: "var(--text-xs)",
              color: "var(--fgColor-muted)",
              marginTop: "2px",
            }}
          >
            {subValue}
          </div>
        )}
      </div>
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

const SELECT_CHEVRON_BG =
  "url(\"data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%23848D97' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><polyline points='6 9 12 15 18 9'/></svg>\")";

// Tabs component — mirrors BillingTabs styling exactly
function UsersTabs({ activeTab }: { activeTab: UsersTab }) {
  const tabs: { id: UsersTab; label: string; disabled?: boolean }[] = [
    { id: "users", label: "Users" },
    { id: "dept", label: "Dept.", disabled: true },
  ];

  return (
    <div
      style={{
        position: "relative",
        display: "flex",
        alignItems: "center",
        justifyContent: "space-between",
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
        {tabs.map((tab) => {
          const isActive = activeTab === tab.id;
          const isDisabled = !!tab.disabled;
          return (
            <button
              key={tab.id}
              type="button"
              disabled={isDisabled}
              style={{
                position: "relative",
                cursor: isDisabled ? "not-allowed" : "pointer",
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
                  color: isDisabled
                    ? "var(--fgColor-disabled, #6E7681)"
                    : isActive
                      ? "var(--fgColor-default)"
                      : "var(--fgColor-muted)",
                  transition: "color 0.15s ease",
                  opacity: isDisabled ? 0.6 : 1,
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

// Kebab menu dropdown — matches billing ActionDropdown pattern exactly
function UserActionDropdown({
  onDisable,
  onAddTo,
}: {
  onDisable: () => void;
  onAddTo: () => void;
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
              onDisable();
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
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <circle cx="12" cy="12" r="10" />
              <line x1="4.93" y1="4.93" x2="19.07" y2="19.07" />
            </svg>
            Disable
          </button>
          <button
            onClick={(e) => {
              e.stopPropagation();
              setIsOpen(false);
              onAddTo();
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
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <line x1="12" y1="5" x2="12" y2="19" />
              <line x1="5" y1="12" x2="19" y2="12" />
            </svg>
            Add to
          </button>
        </div>
      )}
    </div>
  );
}

export function UsersSection() {
  // Filter state
  const [search, setSearch] = useState("");
  const [debouncedSearch, setDebouncedSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<"all" | "active" | "inactive">("all");
  const [clientFilter, setClientFilter] = useState<string>("");
  const [deptFilter, setDeptFilter] = useState<string>("");
  const [page, setPage] = useState(1);

  // Data state
  const [users, setUsers] = useState<UserRow[]>([]);
  const [total, setTotal] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const [isLoading, setIsLoading] = useState(false);

  // Dynamic page size — calculated from viewport so all rows + pagination fit without scrolling
  const [dynamicPageSize, setDynamicPageSize] = useState(10);

  // Accordion state
  const [expandedUserId, setExpandedUserId] = useState<string | null>(null);
  const [collapsingUserId, setCollapsingUserId] = useState<string | null>(null);
  const [panelMaxHeight, setPanelMaxHeight] = useState(400);
  const panelRef = useRef<HTMLDivElement>(null);
  const tableContainerRef = useRef<HTMLDivElement>(null);
  const filtersRowRef = useRef<HTMLDivElement>(null);
  const outerContainerRef = useRef<HTMLDivElement>(null);
  const calcLayoutRef = useRef<() => void>(() => {});
  const firstRowRef = useRef<HTMLDivElement>(null);
  const paginationRowRef = useRef<HTMLDivElement>(null);

  // User detail (fetched when accordion opens)
  const [userDetail, setUserDetail] = useState<UserDetail | null>(null);
  const [detailLoading, setDetailLoading] = useState(false);

  const [clients, setClients] = useState<ClientOption[]>([]);
  const [departments, setDepartments] = useState<DeptOption[]>([]);

  const [userComputeActivity, setUserComputeActivity] = useState<ComputeActivityData | null>(null);

  // Active sessions table state
  const [showActiveSessions, setShowActiveSessions] = useState(false);
  const [activeSessions, setActiveSessions] = useState<ActiveSession[] | null>(null);
  const [sessionsLoading, setSessionsLoading] = useState(false);

  // Debounce search
  useEffect(() => {
    const t = setTimeout(() => setDebouncedSearch(search), 300);
    return () => clearTimeout(t);
  }, [search]);

  // Reset page on filter change
  useEffect(() => {
    setPage(1);
  }, [debouncedSearch, statusFilter, clientFilter, deptFilter]);

  // Reset dept filter when client changes
  useEffect(() => {
    setDeptFilter("");
  }, [clientFilter]);

  // Fetch users
  useEffect(() => {
    const token = getAnalyticsAccessToken();
    if (!token) return;
    let cancelled = false;

    const run = async () => {
      setIsLoading(true);
      try {
        const params = new URLSearchParams();
        params.set("page", String(page));
        params.set("limit", String(dynamicPageSize));
        if (debouncedSearch) params.set("search", debouncedSearch);
        if (statusFilter && statusFilter !== "all") params.set("status", statusFilter);
        if (clientFilter) params.set("clientId", clientFilter);
        if (deptFilter) params.set("departmentId", deptFilter);

        const res = await fetch(
          `${API_BASE}/api/dashboard/analytics/users?${params.toString()}`,
          { headers: { Authorization: `Bearer ${token}` } }
        );
        if (!res.ok) {
          if (!cancelled) {
            setUsers([]);
            setTotal(0);
            setTotalPages(0);
          }
          return;
        }
        const data: UsersResponse = await res.json();
        if (cancelled) return;
        setUsers(Array.isArray(data.users) ? data.users : []);
        setTotal(data.total ?? 0);
        setTotalPages(data.totalPages ?? 0);
      } catch {
        if (!cancelled) {
          setUsers([]);
          setTotal(0);
          setTotalPages(0);
        }
      } finally {
        if (!cancelled) setIsLoading(false);
      }
    };

    run();
    return () => {
      cancelled = true;
    };
  }, [page, debouncedSearch, statusFilter, clientFilter, deptFilter, dynamicPageSize]);

  // Fetch clients on mount
  useEffect(() => {
    const token = getAnalyticsAccessToken();
    if (!token) return;
    let cancelled = false;

    const run = async () => {
      try {
        const res = await fetch(
          `${API_BASE}/api/dashboard/analytics/clients`,
          { headers: { Authorization: `Bearer ${token}` } }
        );
        if (!res.ok) return;
        const data: ClientsResponse = await res.json();
        if (cancelled) return;
        setClients(Array.isArray(data.clients) ? data.clients : []);
      } catch {
        // swallow
      }
    };

    run();
    return () => {
      cancelled = true;
    };
  }, []);

  // Fetch departments when clientFilter changes
  useEffect(() => {
    if (!clientFilter) {
      setDepartments([]);
      return;
    }
    const token = getAnalyticsAccessToken();
    if (!token) return;
    let cancelled = false;

    const run = async () => {
      try {
        const res = await fetch(
          `${API_BASE}/api/dashboard/analytics/departments?clientId=${encodeURIComponent(clientFilter)}`,
          { headers: { Authorization: `Bearer ${token}` } }
        );
        if (!res.ok) {
          if (!cancelled) setDepartments([]);
          return;
        }
        const data: DepartmentsResponse = await res.json();
        if (cancelled) return;
        setDepartments(Array.isArray(data.departments) ? data.departments : []);
      } catch {
        if (!cancelled) setDepartments([]);
      }
    };

    run();
    return () => {
      cancelled = true;
    };
  }, [clientFilter]);

  // Calculate dynamic page size (rows that fit viewport) and expanded panel height
  useEffect(() => {
    const calcLayout = () => {
      if (!tableContainerRef.current) return;

      const containerTop = tableContainerRef.current.getBoundingClientRect().top;

      // Measure actual rendered heights from DOM (fall back to constants when no data yet)
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

      // --- Page size: how many data rows fit with pagination row at the bottom ---
      const availableForRows =
        window.innerHeight -
        containerTop -
        2 - // table border-top + border-bottom
        actualHeaderHeight -
        actualPaginationHeight -
        LAYOUT_BUFFER;
      const rows = Math.max(1, Math.floor(availableForRows / actualRowHeight));
      setDynamicPageSize(rows);

      // --- Panel height: space from expanded row bottom to pagination row top ---
      const panelH =
        window.innerHeight -
        containerTop -
        2 - // border top/bottom
        actualHeaderHeight -
        actualRowHeight - // expanded row
        actualPaginationHeight -
        8; // small buffer
      setPanelMaxHeight(Math.max(200, Math.floor(panelH)));
    };

    calcLayoutRef.current = calcLayout;
    calcLayout();
    window.addEventListener("resize", calcLayout);
    return () => window.removeEventListener("resize", calcLayout);
  }, []);

  // Recalculate when data finishes loading (real rows render at 48px, not skeleton height)
  useEffect(() => {
    if (!isLoading && users.length > 0) {
      requestAnimationFrame(() => calcLayoutRef.current());
    }
  }, [isLoading, users]);

  // ResizeObserver on outer container for responsive container-level changes
  useEffect(() => {
    const el = outerContainerRef.current;
    if (!el) return;
    const ro = new ResizeObserver(() => calcLayoutRef.current());
    ro.observe(el);
    return () => ro.disconnect();
  }, []);

  // Animate panel open: after mount, set max-height to trigger CSS transition
  useEffect(() => {
    if (expandedUserId && panelRef.current) {
      const el = panelRef.current;
      el.style.maxHeight = "0px";
      const raf = requestAnimationFrame(() => {
        el.style.maxHeight = `${panelMaxHeight}px`;
      });
      return () => cancelAnimationFrame(raf);
    }
  }, [expandedUserId, panelMaxHeight]);

  // Collapse animation: set max-height to 0, wait for transition, then clear collapsingUserId
  useEffect(() => {
    if (collapsingUserId && panelRef.current) {
      const el = panelRef.current;
      el.style.maxHeight = "0px";
      const timeout = setTimeout(() => {
        setCollapsingUserId(null);
      }, 400); // slightly longer than CSS transition (350ms)
      return () => clearTimeout(timeout);
    }
  }, [collapsingUserId]);

  // Fetch user detail when accordion expands
  useEffect(() => {
    if (!expandedUserId) {
      setUserDetail(null);
      return;
    }
    const token = getAnalyticsAccessToken();
    if (!token) return;
    let cancelled = false;

    const fetchDetail = async () => {
      setDetailLoading(true);
      try {
        const res = await fetch(
          `${API_BASE}/api/dashboard/analytics/users/${expandedUserId}/detail`,
          { headers: { Authorization: `Bearer ${token}` } }
        );
        if (!res.ok) return;
        const data: UserDetail = await res.json();
        if (!cancelled) setUserDetail(data);
      } catch {
        // swallow
      } finally {
        if (!cancelled) setDetailLoading(false);
      }
    };
    fetchDetail();
    return () => {
      cancelled = true;
    };
  }, [expandedUserId]);

  // Fetch user-specific compute activity when accordion expands
  useEffect(() => {
    if (!expandedUserId) {
      setUserComputeActivity(null);
      return;
    }
    const token = getAnalyticsAccessToken();
    if (!token) return;
    fetch(
      `${API_BASE}/api/dashboard/analytics/users/compute-activity?userId=${expandedUserId}&timeRange=30D`,
      { headers: { Authorization: `Bearer ${token}` } }
    )
      .then(res => res.ok ? res.json() : null)
      .then(data => setUserComputeActivity(data))
      .catch(() => setUserComputeActivity(null));
  }, [expandedUserId]);

  // Fetch active sessions when table view is toggled
  useEffect(() => {
    if (!showActiveSessions || !expandedUserId) {
      if (!showActiveSessions) setActiveSessions(null);
      return;
    }
    const token = getAnalyticsAccessToken();
    if (!token) return;
    setSessionsLoading(true);
    fetch(
      `${API_BASE}/api/dashboard/analytics/users/${expandedUserId}/sessions`,
      { headers: { Authorization: `Bearer ${token}` } }
    )
      .then(res => res.ok ? res.json() : [])
      .then(data => { setActiveSessions(data); setSessionsLoading(false); })
      .catch(() => { setActiveSessions([]); setSessionsLoading(false); });
  }, [showActiveSessions, expandedUserId]);

  // Click handler for row expand/collapse
  const handleRowClick = (userId: string) => {
    if (expandedUserId === userId) {
      // Collapse: trigger collapse animation
      setCollapsingUserId(userId);
      setExpandedUserId(null);
    } else {
      // Expand: clear any pending collapse, set new expanded
      setCollapsingUserId(null);
      setExpandedUserId(userId);
    }
  };

  const rangeStart = useMemo(
    () => (total === 0 ? 0 : (page - 1) * dynamicPageSize + 1),
    [page, total, dynamicPageSize]
  );
  const rangeEnd = useMemo(
    () => Math.min(page * dynamicPageSize, total),
    [page, total, dynamicPageSize]
  );

  // Reorder users when one is expanded: expanded row moves to top
  const orderedUsers = useMemo(() => {
    const activeId = expandedUserId ?? collapsingUserId;
    if (!activeId) return users;
    const idx = users.findIndex((u) => u.id === activeId);
    if (idx === -1) return users;
    const expanded = users[idx];
    const rest = [...users.slice(0, idx), ...users.slice(idx + 1)];
    return [expanded, ...rest];
  }, [users, expandedUserId, collapsingUserId]);

  // Grid template — 8 columns (Name | Email | Client | Profession | Timezone | Join Date | Status | Actions)
  const GRID_TEMPLATE =
    "minmax(140px, 1.2fr) minmax(180px, 1.4fr) minmax(120px, 1fr) minmax(100px, 0.9fr) minmax(100px, 0.8fr) 110px 90px 50px";

  // Reusable header cell style — matches payment-history-tab header span
  const headerCellStyle: React.CSSProperties = {
    fontFamily: "var(--font-sans)",
    fontSize: "0.75rem",
    fontWeight: 500,
    color: "var(--fgColor-muted)",
    textTransform: "uppercase",
    letterSpacing: "0.05em",
  };

  const headers: { label: string; align?: "left" | "center" }[] = [
    { label: "Name" },
    { label: "Email" },
    { label: "Client" },
    { label: "Profession" },
    { label: "Timezone" },
    { label: "Join Date" },
    { label: "Status" },
    { label: "Actions", align: "center" },
  ];

  return (
    <div ref={outerContainerRef} style={{ padding: "15px", fontFamily: "var(--font-sans)", overflow: "hidden", height: "100%" }}>
      {/* Page Header — exact billing page styling */}
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
        Users
      </h1>

      <p
        style={{
          fontFamily: "var(--font-sans)",
          fontSize: "0.875rem",
          color: "var(--fgColor-muted)",
          margin: "8px 0 0 0",
          lineHeight: "1.5",
        }}
      >
        View and manage all platform users
      </p>

      {/* Tabs — billing-style */}
      <UsersTabs activeTab="users" />

      {/* Tab content area */}
      <div style={{ marginTop: "24px" }}>
        {/* Filters row */}
        <div
          ref={filtersRowRef}
          style={{
            display: "flex",
            alignItems: "center",
            gap: "12px",
            marginBottom: "16px",
          }}
        >
          <div style={{ position: "relative", flex: 1 }}>
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
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search by name or email..."
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

          <select
            value={statusFilter}
            onChange={(e) =>
              setStatusFilter(e.target.value as "all" | "active" | "inactive")
            }
            style={{
              backgroundColor: "var(--bgColor-muted)",
              border: "1px solid var(--borderColor-default)",
              borderRadius: "4px",
              height: "36px",
              padding: "0 28px 0 12px",
              cursor: "pointer",
              appearance: "none",
              backgroundImage: SELECT_CHEVRON_BG,
              backgroundRepeat: "no-repeat",
              backgroundPosition: "right 10px center",
              minWidth: 140,
              fontFamily: "var(--font-sans)",
              fontSize: "0.8125rem",
              color: "var(--fgColor-default)",
              outline: "none",
            }}
          >
            <option value="all">All Statuses</option>
            <option value="active">Active</option>
            <option value="inactive">Inactive</option>
          </select>

          <select
            value={clientFilter}
            onChange={(e) => setClientFilter(e.target.value)}
            style={{
              backgroundColor: "var(--bgColor-muted)",
              border: "1px solid var(--borderColor-default)",
              borderRadius: "4px",
              height: "36px",
              padding: "0 28px 0 12px",
              cursor: "pointer",
              appearance: "none",
              backgroundImage: SELECT_CHEVRON_BG,
              backgroundRepeat: "no-repeat",
              backgroundPosition: "right 10px center",
              minWidth: 160,
              fontFamily: "var(--font-sans)",
              fontSize: "0.8125rem",
              color: "var(--fgColor-default)",
              outline: "none",
            }}
          >
            <option value="">All Clients</option>
            {clients.map((c) => (
              <option key={c.id} value={c.id}>
                {c.name}
              </option>
            ))}
          </select>

          <select
            value={deptFilter}
            onChange={(e) => setDeptFilter(e.target.value)}
            disabled={!clientFilter}
            style={{
              backgroundColor: "var(--bgColor-muted)",
              border: "1px solid var(--borderColor-default)",
              borderRadius: "4px",
              height: "36px",
              padding: "0 28px 0 12px",
              cursor: clientFilter ? "pointer" : "not-allowed",
              appearance: "none",
              backgroundImage: SELECT_CHEVRON_BG,
              backgroundRepeat: "no-repeat",
              backgroundPosition: "right 10px center",
              minWidth: 180,
              fontFamily: "var(--font-sans)",
              fontSize: "0.8125rem",
              color: clientFilter
                ? "var(--fgColor-default)"
                : "var(--fgColor-muted)",
              opacity: clientFilter ? 1 : 0.7,
              outline: "none",
            }}
          >
            {!clientFilter ? (
              <option value="">Select client first</option>
            ) : (
              <>
                <option value="">All Departments</option>
                {departments.map((d) => (
                  <option key={d.id} value={d.id}>
                    {d.name}
                  </option>
                ))}
              </>
            )}
          </select>
        </div>

        {/* Table container — billing pattern */}
        <div
          ref={tableContainerRef}
          style={{
            backgroundColor: "var(--bgColor-mild)",
            border: "1px solid var(--borderColor-default)",
            borderRadius: "4px",
            overflow: "visible",
          }}
        >
          {/* Header row */}
          <div
            style={{
              display: "grid",
              gridTemplateColumns: GRID_TEMPLATE,
              gap: "12px",
              padding: "12px 20px",
              borderBottom: "1px solid var(--borderColor-default)",
              backgroundColor: "var(--bgColor-muted)",
            }}
          >
            {headers.map((h) => (
              <span
                key={h.label}
                style={{
                  ...headerCellStyle,
                  textAlign: h.align ?? "left",
                }}
              >
                {h.label}
              </span>
            ))}
          </div>

          {/* Body */}
          {isLoading ? (
            Array.from({ length: 6 }).map((_, i) => (
              <div
                key={`skeleton-${i}`}
                style={{
                  display: "grid",
                  gridTemplateColumns: GRID_TEMPLATE,
                  gap: "12px",
                  padding: "12px 20px",
                  borderBottom: "1px solid var(--borderColor-default)",
                  alignItems: "center",
                }}
              >
                {Array.from({ length: 8 }).map((__, j) => (
                  <div
                    key={`s-${i}-${j}`}
                    className="animate-pulse"
                    style={{
                      height: 12,
                      width: j === 7 ? 24 : "75%",
                      borderRadius: "2px",
                      backgroundColor: "var(--bgColor-muted)",
                      marginLeft: j === 7 ? "auto" : 0,
                      marginRight: j === 7 ? "auto" : 0,
                    }}
                  />
                ))}
              </div>
            ))
          ) : users.length === 0 ? (
            <div
              style={{
                padding: "48px 20px",
                textAlign: "center",
                fontFamily: "var(--font-sans)",
                fontSize: "0.875rem",
                color: "var(--fgColor-muted)",
              }}
            >
              No users found
            </div>
          ) : (
            orderedUsers.map((u, i) => {
              const fullName =
                `${u.firstName ?? ""} ${u.lastName ?? ""}`.trim() || "—";
              const isExpanded = expandedUserId === u.id;
              const isCollapsing = collapsingUserId === u.id;
              const isActive = isExpanded || isCollapsing;
              return (
                <div key={u.id}>
                  {/* Row */}
                  <div
                    ref={i === 0 ? firstRowRef : undefined}
                    style={{
                      display: "grid",
                      gridTemplateColumns: GRID_TEMPLATE,
                      gap: "12px",
                      padding: "12px 20px",
                      borderBottom: "1px solid var(--borderColor-default)",
                      alignItems: "center",
                      transition: "background-color 0.1s ease",
                      cursor: "pointer",
                      backgroundColor: "transparent",
                    }}
                    onClick={() => handleRowClick(u.id)}
                    onMouseEnter={(e) => {
                      e.currentTarget.style.backgroundColor =
                        "var(--bgColor-default)";
                    }}
                    onMouseLeave={(e) => {
                      e.currentTarget.style.backgroundColor = "transparent";
                    }}
                  >
                    {/* Name */}
                    <span
                      style={{
                        fontFamily: "var(--font-sans)",
                        fontSize: "0.8125rem",
                        fontWeight: 500,
                        color: "var(--fgColor-default)",
                        overflow: "hidden",
                        textOverflow: "ellipsis",
                        whiteSpace: "nowrap",
                      }}
                      title={fullName}
                    >
                      {fullName}
                    </span>

                    {/* Email */}
                    <span
                      style={{
                        fontFamily: "var(--font-sans)",
                        fontSize: "0.8125rem",
                        color: "var(--fgColor-default)",
                        overflow: "hidden",
                        textOverflow: "ellipsis",
                        whiteSpace: "nowrap",
                      }}
                      title={u.email}
                    >
                      {u.email || "—"}
                    </span>

                    {/* Client */}
                    <span
                      style={{
                        fontFamily: "var(--font-sans)",
                        fontSize: "0.8125rem",
                        color: u.clientName
                          ? "var(--fgColor-default)"
                          : "var(--fgColor-muted)",
                        fontStyle: u.clientName ? "normal" : "italic",
                        overflow: "hidden",
                        textOverflow: "ellipsis",
                        whiteSpace: "nowrap",
                      }}
                      title={u.clientName || "Public User"}
                    >
                      {u.clientName || "Public User"}
                    </span>

                    {/* Profession */}
                    <span
                      style={{
                        fontFamily: "var(--font-sans)",
                        fontSize: "0.8125rem",
                        color: "var(--fgColor-default)",
                        overflow: "hidden",
                        textOverflow: "ellipsis",
                        whiteSpace: "nowrap",
                      }}
                      title={u.profession || ""}
                    >
                      {u.profession || "—"}
                    </span>

                    {/* Timezone */}
                    <span
                      style={{
                        fontFamily: "var(--font-sans)",
                        fontSize: "0.8125rem",
                        color: "var(--fgColor-muted)",
                        overflow: "hidden",
                        textOverflow: "ellipsis",
                        whiteSpace: "nowrap",
                      }}
                      title={u.timezone || ""}
                    >
                      {u.timezone || "—"}
                    </span>

                    {/* Join Date */}
                    <span
                      style={{
                        fontFamily: "var(--font-mono, monospace)",
                        fontSize: "0.8125rem",
                        color: "var(--fgColor-default)",
                        whiteSpace: "nowrap",
                      }}
                    >
                      {formatISTDate(u.joinDate)}
                    </span>

                    {/* Status */}
                    <span
                      style={{
                        display: "flex",
                        alignItems: "center",
                        gap: "6px",
                        fontFamily: "var(--font-sans)",
                        fontSize: "0.8125rem",
                      }}
                    >
                      <span
                        style={{
                          display: "inline-block",
                          width: 8,
                          height: 8,
                          borderRadius: "9999px",
                          backgroundColor: u.isActive ? "#05C004" : "#818178",
                          flexShrink: 0,
                        }}
                      />
                      <span style={{ color: u.isActive ? "var(--fgColor-default)" : "var(--fgColor-muted)" }}>
                        {u.isActive ? "Active" : "Inactive"}
                      </span>
                    </span>

                    {/* Actions — kebab menu only */}
                    <div style={{ display: "flex", justifyContent: "center", alignItems: "center", gap: "4px" }}>
                      <UserActionDropdown
                        onDisable={() => { /* no-op */ }}
                        onAddTo={() => { /* no-op */ }}
                      />
                    </div>
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
                      <div
                        style={{
                          padding: "24px",
                        }}
                      >
                        {detailLoading ? (
                          <div
                            style={{
                              display: "flex",
                              alignItems: "center",
                              justifyContent: "center",
                              height: "100%",
                            }}
                          >
                            <span
                              style={{
                                fontFamily: "var(--font-sans)",
                                fontSize: "0.875rem",
                                color: "var(--fgColor-muted)",
                              }}
                            >
                              Loading profile...
                            </span>
                          </div>
                        ) : userDetail ? (
                          <div
                            style={{
                              display: "flex",
                              flexDirection: "column",
                              gap: "20px",
                              height: "100%",
                            }}
                          >
                            {/* Identity Bar — two columns: user info | academic details */}
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
                              {/* Left Column: Avatar + Name + Session */}
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
                                    {fullName.charAt(0)?.toUpperCase() || "?"}
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
                                      {fullName}
                                    </span>
                                    <span
                                      style={{
                                        display: "inline-flex",
                                        padding: "2px 8px",
                                        borderRadius: "9999px",
                                        fontSize: "0.6875rem",
                                        fontWeight: 500,
                                        fontFamily: "var(--font-sans)",
                                        background: getAuthBadge(userDetail.oauthProvider, userDetail.authType).bg,
                                        color: "#fff",
                                      }}
                                    >
                                      {getAuthBadge(userDetail.oauthProvider, userDetail.authType).label}
                                    </span>
                                    {userDetail.emailVerified && (
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
                                    {userDetail.hasActiveSession ? (
                                      <>
                                        <span
                                          className="w-2 h-2 rounded-full"
                                          style={{
                                            width: 8,
                                            height: 8,
                                            borderRadius: "50%",
                                            backgroundColor: "#34D399",
                                            flexShrink: 0,
                                          }}
                                        />
                                        <span
                                          style={{
                                            fontFamily: "var(--font-sans)",
                                            fontSize: "0.8125rem",
                                            color: "#34D399",
                                          }}
                                        >
                                          Active Now
                                        </span>
                                      </>
                                    ) : (
                                      <>
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
                                      </>
                                    )}
                                    <span style={{ color: "var(--fgColor-muted)", fontSize: "0.8125rem" }}>·</span>
                                    <span
                                      style={{
                                        fontFamily: "var(--font-sans)",
                                        fontSize: "0.8125rem",
                                        color: "var(--fgColor-muted)",
                                      }}
                                    >
                                      {userDetail.lastLoginAt
                                        ? `Last login ${formatRelativeTime(userDetail.lastLoginAt)}`
                                        : "Never logged in"}
                                    </span>
                                  </div>
                                </div>
                              </div>

                              {/* Right Column: Academic details — restructured as single flex row */}
                              {(userDetail.collegeName || userDetail.courseName) && (
                                <div style={{ display: "flex", alignItems: "flex-start", gap: "32px", minWidth: 0 }}>
                                  {/* Institution + Department stacked */}
                                  <div style={{ flex: 1, minWidth: 0 }}>
                                    {userDetail.collegeName && (
                                      <div style={{ fontFamily: "var(--font-sans)", fontSize: "0.9375rem", fontWeight: 500, color: "var(--fgColor-default)", lineHeight: 1.4, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                                        {userDetail.collegeName}
                                      </div>
                                    )}
                                    {userDetail.departmentName && (
                                      <div style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)", lineHeight: 1.4, marginTop: "2px", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                                        {userDetail.departmentName}
                                      </div>
                                    )}
                                  </div>
                                  {/* Course + Expertise tag */}
                                  <div style={{ textAlign: "right", flexShrink: 0 }}>
                                    {userDetail.courseName && (
                                      <div style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)", lineHeight: 1.4 }}>
                                        {userDetail.courseName}{userDetail.academicYear ? ` \u00B7 Year ${userDetail.academicYear}` : ""}
                                      </div>
                                    )}
                                    {userDetail.expertiseLevel && (
                                      <span style={{ display: "inline-block", fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, padding: "3px 12px", borderRadius: "4px", marginTop: "6px", background: getExpertiseColor(userDetail.expertiseLevel).bg, color: getExpertiseColor(userDetail.expertiseLevel).text }}>
                                        {userDetail.expertiseLevel}
                                      </span>
                                    )}
                                  </div>
                                </div>
                              )}
                            </div>

                            {/* 2-Column Info Grid */}
                            <div
                              style={{
                                display: "grid",
                                gridTemplateColumns: "1fr 1fr",
                                gap: "16px",
                                flex: 1,
                                overflow: "hidden",
                              }}
                            >
                              {/* Left Column */}
                              <div style={{ display: "flex", flexDirection: "column", gap: "16px", overflow: "auto" }}>
                                {/* Account Card — SectionCard style */}
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
                                    <InfoRow label="Account ID" value={<span style={{ display: "flex", alignItems: "center", gap: "8px" }}><code style={{ fontFamily: '"Suisse Intl Mono", ui-monospace, monospace', fontSize: "0.875rem", background: "var(--bgColor-muted)", padding: "4px 8px", borderRadius: "4px" }}>{userDetail.id}</code><button onClick={() => navigator.clipboard.writeText(userDetail.id)} style={{ background: "none", border: "none", cursor: "pointer", color: "var(--fgColor-muted)", fontSize: "0.75rem" }}>Copy</button></span>} isLast={false} />
                                    <InfoRow label="Auth Type" value={userDetail.oauthProvider === "google" ? "Google OAuth" : userDetail.oauthProvider === "github" ? "GitHub OAuth" : userDetail.authType === "university_sso" || userDetail.authType === "institution_local" ? "Institutional SSO" : "Email & Password"} isLast={false} />
                                    <InfoRow label="Phone" value={userDetail.phone || "Not set"} isLast={true} />
                                  </div>
                                </div>

                              </div>

                              {/* Right Column */}
                              <div style={{ display: "flex", flexDirection: "column", gap: "16px", overflow: "auto" }}>
                                {/* Links & Skills Card — SectionCard style */}
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
                                      Links & Skills
                                    </span>
                                  </div>
                                  <div style={{ padding: "0", background: "var(--bgColor-mild)" }}>
                                    <InfoRow label="GitHub" value={userDetail.githubUrl || "Not set"} isLast={false} />
                                    <InfoRow label="LinkedIn" value={userDetail.linkedinUrl || "Not set"} isLast={false} />
                                    <InfoRow label="Website" value={userDetail.websiteUrl || "Not set"} isLast={userDetail.skills.length === 0} />
                                    {userDetail.skills.length > 0 && (
                                      <div style={{ borderTop: "1px solid var(--borderColor-default)", padding: "12px 20px" }}>
                                        <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", color: "var(--fgColor-muted)", fontWeight: 400, display: "block", marginBottom: "8px" }}>
                                          Skills
                                        </span>
                                        <div style={{ display: "flex", flexWrap: "wrap", gap: "4px" }}>
                                          {userDetail.skills.map((s: string) => (
                                            <Pill key={s} label={s} />
                                          ))}
                                        </div>
                                      </div>
                                    )}
                                  </div>
                                </div>
                              </div>
                            </div>

                            {/* Balance Summary Section */}
                            <div
                              style={{
                                background: "var(--bgColor-mild)",
                                border: "1px solid var(--borderColor-default)",
                                borderRadius: "4px",
                                padding: "24px",
                              }}
                            >
                              <div
                                style={{
                                  display: "flex",
                                  alignItems: "baseline",
                                  gap: "12px",
                                  marginBottom: "16px",
                                }}
                              >
                                <h3
                                  style={{
                                    fontFamily: "var(--font-sans)",
                                    fontSize: "var(--text-h4)",
                                    fontWeight: 600,
                                    color: "var(--fgColor-default)",
                                    margin: 0,
                                  }}
                                >
                                  Balance Summary
                                </h3>
                                <p
                                  style={{
                                    fontFamily: "var(--font-sans)",
                                    fontSize: "var(--text-sm)",
                                    color: "var(--fgColor-muted)",
                                    margin: 0,
                                  }}
                                >
                                  Spending overview
                                </p>
                                <span
                                  style={{
                                    marginLeft: "auto",
                                    fontFamily: "var(--font-sans)",
                                    fontSize: "var(--text-h4)",
                                    fontWeight: 600,
                                    color: "var(--fgColor-default)",
                                  }}
                                >
                                  Lifetime Spent:{" "}
                                  <span
                                    style={{
                                      color: (userDetail.lifetimeSpentCents ?? 0) > 0 ? "#34D399" : "var(--fgColor-muted)",
                                    }}
                                  >
                                    ₹{((userDetail.lifetimeSpentCents ?? 0) / 100).toFixed(2)}
                                  </span>
                                </span>
                              </div>
                              <div style={{ display: "flex", gap: "16px", flexWrap: "wrap" }}>
                                <MetricCard
                                  highlight
                                  icon={
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" style={{ color: "var(--fgColor-info, #3a73ff)" }}>
                                      <rect x="2" y="6" width="20" height="12" rx="2" />
                                      <path d="M2 10h20" />
                                    </svg>
                                  }
                                  label="Credit balance"
                                  value={`₹${((userDetail.balanceCents ?? 0) / 100).toFixed(2)}`}
                                />
                                <MetricCard
                                  icon={
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" style={{ color: "var(--fgColor-muted)" }}>
                                      <circle cx="12" cy="12" r="10" />
                                      <path d="M12 6v6l4 2" />
                                    </svg>
                                  }
                                  label="Burn rate"
                                  value={`₹${userDetail.burnRateRupees.toFixed(2)}/hr`}
                                />
                                <MetricCard
                                  icon={
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" style={{ color: "var(--fgColor-muted)" }}>
                                      <circle cx="12" cy="12" r="10" />
                                      <path d="M12 6v6l4 2" />
                                    </svg>
                                  }
                                  label="Runway"
                                  value={(() => {
                                    const h = userDetail.runwayHours;
                                    const r = userDetail.burnRateRupees;
                                    if (h === null || h === undefined) return r <= 0 ? "∞" : "--";
                                    if (h <= 0) return "0 hrs";
                                    if (h > 8760) return "∞";
                                    const days = Math.floor(h / 24);
                                    const rem = Math.floor(h % 24);
                                    return days > 0 ? (rem > 0 ? `${days}d ${rem}h` : `${days}d`) : `${rem}h`;
                                  })()}
                                />
                                <MetricCard
                                  icon={
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" style={{ color: "var(--fgColor-muted)" }}>
                                      <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
                                      <line x1="12" y1="9" x2="12" y2="13" />
                                      <line x1="12" y1="17" x2="12.01" y2="17" />
                                    </svg>
                                  }
                                  label="Spend limit"
                                  value={userDetail.spendLimitEnabled ? `₹${((userDetail.spendLimitCents ?? 0) / 100).toFixed(2)}` : "Not set"}
                                />
                              </div>
                            </div>

                            {/* Two-column row: Compute Activity | Billing Summary */}
                            <div style={{ display: "flex", gap: "24px" }}>
                              {/* Left: Compute Activity */}
                              <div style={{ flex: 3, background: "var(--bgColor-mild)", border: "1px solid var(--borderColor-default)", borderRadius: "4px", padding: "20px" }}>
                                <style>{`@keyframes dotPulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.2; } }`}</style>
                                <div style={{ display: "flex", alignItems: "flex-start", justifyContent: "space-between", marginBottom: "12px" }}>
                                  <div>
                                    <div style={{ fontFamily: "var(--font-sans)", fontSize: "var(--text-h4)", fontWeight: 600, color: "var(--fgColor-default)" }}>Compute Activity</div>
                                    <div style={{ fontFamily: "var(--font-sans)", fontSize: "var(--text-sm)", color: "var(--fgColor-muted)", marginTop: "2px" }}>{userComputeActivity?.periodLabel || 'This Month'}</div>
                                  </div>
                                  <button
                                    style={{
                                      fontFamily: "var(--font-sans)",
                                      fontSize: "var(--text-sm)",
                                      color: "var(--fgColor-default)",
                                      background: "none",
                                      border: "none",
                                      cursor: "pointer",
                                      display: "inline-flex",
                                      alignItems: "center",
                                      gap: "6px",
                                      padding: 0,
                                    }}
                                    onClick={() => setShowActiveSessions(prev => !prev)}
                                  >
                                    <span
                                      style={{
                                        display: "inline-block",
                                        width: 8,
                                        height: 8,
                                        borderRadius: "50%",
                                        backgroundColor: (userDetail?.runningComputeSessions ?? 0) > 0 ? "#34D399" : "var(--fgColor-muted)",
                                        animation: (userDetail?.runningComputeSessions ?? 0) > 0 ? "dotPulse 1.5s ease-in-out infinite" : "none",
                                        flexShrink: 0,
                                      }}
                                    />
                                    Active Instances:{" "}
                                    <span
                                      style={{
                                        color: (userDetail?.runningComputeSessions ?? 0) > 0 ? "var(--fgColor-default)" : "var(--fgColor-muted)",
                                      }}
                                    >
                                      {userDetail?.runningComputeSessions ?? 0}
                                    </span>
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{ color: "var(--fgColor-default)" }}>
                                      <path d="M5 12h14" />
                                      <path d="M12 5l7 7-7 7" />
                                    </svg>
                                  </button>
                                </div>
                                {showActiveSessions ? (
                                  <div style={{ height: "200px", overflowY: "auto" }}>
                                    <div style={{ overflowX: "auto" }}>
                                    {sessionsLoading ? (
                                      <div style={{ display: "flex", justifyContent: "center", alignItems: "center", padding: "80px 24px", color: "var(--fgColor-muted)", fontSize: "0.875rem" }}>
                                        Loading sessions...
                                      </div>
                                    ) : !activeSessions || activeSessions.length === 0 ? (
                                      <div style={{ display: "flex", alignItems: "center", justifyContent: "center", height: "100%", fontFamily: "var(--font-sans)", fontSize: "0.875rem", color: "var(--fgColor-muted)" }}>
                                        No active instances
                                      </div>
                                    ) : (
                                      <table style={{ width: "100%", borderCollapse: "collapse" }}>
                                        <thead>
                                          <tr style={{ borderBottom: "1px solid var(--borderColor-default)" }}>
                                            {["Name", "Config", "GPU", "Status", "Uptime", "Cost", "Cost/hr"].map((header, idx) => (
                                              <th key={header} style={{ textAlign: idx >= 5 ? "right" : "left", padding: "12px 16px", paddingLeft: idx === 6 ? "24px" : "16px", fontSize: "0.75rem", fontWeight: 600, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em", whiteSpace: "nowrap" }}>
                                                {header}
                                              </th>
                                            ))}
                                          </tr>
                                        </thead>
                                        <tbody>
                                          {activeSessions.map((session: ActiveSession) => (
                                            <tr key={session.id} style={{ borderBottom: "1px solid var(--borderColor-default)", height: "48px" }}>
                                              <td style={{ padding: "12px 16px" }}>
                                                <span style={{ fontSize: "0.875rem", fontWeight: 500, color: "var(--fgColor-default)" }}>
                                                  {session.instanceName || (session.containerName ? <span style={{ fontFamily: "var(--font-mono)" }}>{session.containerName}</span> : "-")}
                                                </span>
                                              </td>
                                              <td style={{ padding: "12px 16px", fontSize: "0.875rem", color: "var(--fgColor-default)" }}>
                                                {session.computeConfig?.name || "-"}
                                              </td>
                                              <td style={{ padding: "12px 16px", fontSize: "0.875rem", color: "var(--fgColor-default)" }}>
                                                {session.allocatedGpuVramMb ? `${(session.allocatedGpuVramMb / 1024).toFixed(0)} GB VRAM` : "-"}
                                              </td>
                                              <td style={{ padding: "12px 16px" }}>
                                                <StatusBadge status={session.status} />
                                              </td>
                                              <td style={{ padding: "12px 16px", fontSize: "0.875rem", color: "var(--fgColor-muted)" }}>
                                                {formatUptime(session.startedAt, session.status)}
                                              </td>
                                              <td style={{ padding: "12px 16px", textAlign: "right", fontFamily: "var(--font-mono)", fontSize: "0.875rem" }}>
                                                {(() => {
                                                  const isLive = ACTIVE_STATUSES.includes(session.status) && session.status !== 'pending' && session.startedAt;
                                                  const costCents = calculateLiveCost(session);
                                                  if (session.status === 'pending' || (!session.startedAt && ACTIVE_STATUSES.includes(session.status))) {
                                                    return <span style={{ color: "var(--fgColor-muted)" }}>—</span>;
                                                  }
                                                  return (
                                                    <span style={{ display: "inline-flex", alignItems: "center", gap: "6px", color: isLive ? "var(--fgColor-default)" : "var(--fgColor-muted)" }}>
                                                      {isLive && <span style={{ width: "6px", height: "6px", borderRadius: "50%", backgroundColor: "#009C00", animation: "pulse 1.5s ease-in-out infinite" }} />}
                                                      {formatCostRupees(costCents)}
                                                    </span>
                                                  );
                                                })()}
                                              </td>
                                              <td style={{ padding: "12px 16px", paddingLeft: "24px", fontSize: "0.875rem", color: "var(--fgColor-default)", textAlign: "right", whiteSpace: "nowrap" }}>
                                                {session.computeConfig ? `₹${(session.computeConfig.basePricePerHourCents / 100).toFixed(0)}/hr` : "-"}
                                              </td>
                                            </tr>
                                          ))}
                                        </tbody>
                                      </table>
                                    )}
                                  </div>
                                  </div>
                                ) : (
                                  <div style={{ height: "200px" }}>
                                    {userComputeActivity && userComputeActivity.dailyBreakdown.length > 0 ? (
                                      <ResponsiveContainer width="100%" height="100%">
                                        <BarChart data={userComputeActivity.dailyBreakdown} margin={{ top: 15, right: 10, left: 0, bottom: 0 }}>
                                          <CartesianGrid strokeDasharray="3 3" stroke="#222" vertical={false} />
                                          <XAxis dataKey="dayName" stroke="#555" tick={{ fill: "#71717a", fontSize: 10 }} tickLine={false} axisLine={false} />
                                          <YAxis stroke="#555" tick={{ fill: "#71717a", fontSize: 10 }} tickLine={false} axisLine={false} tickFormatter={(v: number) => `${v}h`} />
                                          <Tooltip cursor={{ fill: 'transparent' }}
                                            contentStyle={{ backgroundColor: "var(--fgColor-default)", border: "1px solid var(--borderColor-default)", borderRadius: "4px", fontSize: "0.875rem", fontWeight: 500, color: "var(--fgColor-inverse)", padding: "6px 16px" }}
                                            labelStyle={{ color: "var(--fgColor-inverse)", fontWeight: 600, marginBottom: 2 }}
                                            itemStyle={{ color: "var(--fgColor-inverse)" }}
                                            formatter={(value: unknown) => [`${value} hrs`, "GPU Hours"]}
                                          />
                                          <Bar dataKey="hours" radius={[4, 4, 0, 0]} activeBar={{ fill: '#6366f1', fillOpacity: 0.8, stroke: '#6366f1', strokeWidth: 1 }} label={{ position: "top", fill: "#a1a1aa", fontSize: 10, formatter: (v: unknown) => `${v}h` }}>
                                            {userComputeActivity.dailyBreakdown.map((item, index) => {
                                              const today = new Date();
                                              const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                                              const todayDayName = dayNames[today.getDay()];
                                              const isToday = item.dayName === todayDayName;
                                              return (
                                                <Cell key={`cell-${index}`} fill={isToday ? "#6366f1" : "#3f3f46"}
                                                  style={{ cursor: 'pointer', transition: 'fill 0.2s ease' }} />
                                              );
                                            })}
                                          </Bar>
                                        </BarChart>
                                      </ResponsiveContainer>
                                    ) : (
                                      <div style={{ display: "flex", alignItems: "center", justifyContent: "center", height: "100%", fontFamily: "var(--font-sans)", fontSize: "0.875rem", color: "var(--fgColor-muted)" }}>
                                        No compute activity data
                                      </div>
                                    )}
                                  </div>
                                )}
                                <div style={{ marginTop: "8px", minHeight: "22px", fontFamily: "var(--font-sans)", fontSize: "0.75rem", color: "var(--fgColor-muted)" }}>
                                  {!showActiveSessions ? (userComputeActivity ? (
                                    <span dangerouslySetInnerHTML={{
                                      __html: userComputeActivity.comparisonText.replace(
                                        /(\d+\.?\d* GPU hours?)/g,
                                        '<span style="color:var(--fgColor-default);font-weight:500">$1</span>'
                                      )
                                    }} />
                                  ) : 'Loading...') : null}
                                </div>
                              </div>

                              {/* Right: empty placeholder to maintain layout */}
                              <div style={{ flex: 2 }} />
                            </div>
                          </div>
                        ) : null}
                      </div>
                    </div>
                  )}
                </div>
              );
            })
          )}

          {/* Pagination footer inside table */}
          {total > 0 && (
            <div
              ref={paginationRowRef}
              style={{
                display: "flex",
                justifyContent: "space-between",
                alignItems: "center",
                padding: "10px 20px",
                borderTop: "1px solid var(--borderColor-default)",
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
                    disabled={page <= 1 || isLoading}
                    style={{
                      padding: "6px 12px",
                      backgroundColor: "var(--bgColor-muted)",
                      border: "1px solid var(--borderColor-default)",
                      borderRadius: "4px",
                      fontFamily: "var(--font-sans)",
                      fontSize: "0.8125rem",
                      color:
                        page <= 1 || isLoading
                          ? "var(--fgColor-muted)"
                          : "var(--fgColor-default)",
                      cursor:
                        page <= 1 || isLoading ? "not-allowed" : "pointer",
                      opacity: page <= 1 || isLoading ? 0.5 : 1,
                      transition: "background-color 0.15s ease",
                    }}
                    onMouseOver={(e) => {
                      if (page > 1 && !isLoading)
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
                    disabled={
                      page >= totalPages || totalPages === 0 || isLoading
                    }
                    style={{
                      padding: "6px 12px",
                      backgroundColor: "var(--bgColor-muted)",
                      border: "1px solid var(--borderColor-default)",
                      borderRadius: "4px",
                      fontFamily: "var(--font-sans)",
                      fontSize: "0.8125rem",
                      color:
                        page >= totalPages || totalPages === 0 || isLoading
                          ? "var(--fgColor-muted)"
                          : "var(--fgColor-default)",
                      cursor:
                        page >= totalPages || totalPages === 0 || isLoading
                          ? "not-allowed"
                          : "pointer",
                      opacity:
                        page >= totalPages || totalPages === 0 || isLoading
                          ? 0.5
                          : 1,
                      transition: "background-color 0.15s ease",
                    }}
                    onMouseOver={(e) => {
                      if (page < totalPages && !isLoading)
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
      </div>
    </div>
  );
}
