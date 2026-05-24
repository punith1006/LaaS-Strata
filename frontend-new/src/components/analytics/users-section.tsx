"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import { Search } from "lucide-react";
import { getAnalyticsAccessToken } from "@/lib/token";

const API_BASE = process.env.NEXT_PUBLIC_API_URL || "";

// Row height constants for dynamic viewport-fit page sizing
const ROW_HEIGHT = 48;
const PAGINATION_ROW_HEIGHT = 52;
const TABLE_HEADER_HEIGHT = 48;

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

  const [clients, setClients] = useState<ClientOption[]>([]);
  const [departments, setDepartments] = useState<DeptOption[]>([]);

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

      // --- Page size: how many data rows fit with pagination row at the bottom ---
      const availableForRows =
        window.innerHeight -
        containerTop -
        2 - // table border-top + border-bottom
        TABLE_HEADER_HEIGHT -
        PAGINATION_ROW_HEIGHT;
      const rows = Math.max(1, Math.floor(availableForRows / ROW_HEIGHT));
      setDynamicPageSize(rows);

      // --- Panel height: space from expanded row bottom to pagination row top ---
      const panelH =
        window.innerHeight -
        containerTop -
        2 - // border top/bottom
        TABLE_HEADER_HEIGHT -
        ROW_HEIGHT - // expanded row
        PAGINATION_ROW_HEIGHT -
        8; // small buffer
      setPanelMaxHeight(Math.max(200, Math.floor(panelH)));
    };

    calcLayout();
    window.addEventListener("resize", calcLayout);
    return () => window.removeEventListener("resize", calcLayout);
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
    <div style={{ padding: "15px", fontFamily: "var(--font-sans)", overflow: "hidden", height: "100%" }}>
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
            orderedUsers.map((u) => {
              const fullName =
                `${u.firstName ?? ""} ${u.lastName ?? ""}`.trim() || "—";
              const isExpanded = expandedUserId === u.id;
              const isCollapsing = collapsingUserId === u.id;
              const isActive = isExpanded || isCollapsing;
              return (
                <div key={u.id}>
                  {/* Row */}
                  <div
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
                        overflow: "hidden",
                        transition: "max-height 0.35s cubic-bezier(0.4, 0, 0.2, 1)",
                        backgroundColor: "var(--bgColor-default)",
                        borderBottom: "1px solid var(--borderColor-default)",
                      }}
                    >
                      <div
                        style={{
                          height: panelMaxHeight,
                          padding: "24px",
                          display: "flex",
                          alignItems: "center",
                          justifyContent: "center",
                        }}
                      >
                        <span
                          style={{
                            fontFamily: "var(--font-sans)",
                            fontSize: "0.875rem",
                            color: "var(--fgColor-muted)",
                          }}
                        >
                          Details coming soon
                        </span>
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
