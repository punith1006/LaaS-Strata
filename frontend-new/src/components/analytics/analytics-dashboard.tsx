"use client";

import { useState, useEffect, useRef, useMemo } from "react";
import dynamic from 'next/dynamic';
import { RotateCcw, X, MoreVertical, Eye, XCircle, ChevronDown, Check } from "lucide-react";
import { FleetHealthGauge, formatLastHeartbeat } from "./fleet-health-gauge";
import type { User } from "@/types/auth";
import { getAnalyticsAccessToken } from "@/lib/token";
import {
  getUnresolvedTickets,
  getTicketDetail,
  resolveTicket,
  getTicketAttachmentUrl,
  getRevenueGrowthData,
  getRetentionData,
  type UnresolvedTicket,
  type TicketDetail,
  type NrrResponse,
  type RetentionData,
} from "@/lib/api";
import { AllTransactionsModal } from "./all-transactions-modal";
import {
  BarChart,
  Bar,
  PieChart,
  Pie,
  Cell,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  CartesianGrid,
  AreaChart,
  Area,
  ReferenceLine,
} from "recharts";

const RevenueChart = dynamic(
  () => import('./revenue-chart').then(mod => ({ default: mod.RevenueChart })),
  { 
    ssr: false,
    loading: () => <div className="w-full h-[240px] bg-[#141414] rounded animate-pulse" />
  }
);

interface AnalyticsDashboardProps {
  user: User;
}

interface AnalyticsKpiResponse {
  revenue: { total: number; dailyAvg: number; changePct: number; subtitleContext: string };
  activeUsers: { count: number; changePct: number; liveSessions: number; newUsers: number; newUsersChangePct: number; subtitleContext: string };
  gpuHours: { totalHours: number; avgSessionHours: number; sessionCount: number; changePct: number; subtitleContext: string };
  fleetHealth: { trustScore: number; uptimePct: number; totalNodes: number; healthyNodes: number; alertNodes: string[]; lastHeartbeatAt: string | null };
}

interface ComputeActivityData {
  dailyBreakdown: Array<{ date: string; dayName: string; hours: number }>;
  totalHours: number;
  priorTotalHours: number;
  comparisonText: string;
  periodLabel: string;
}

interface ActiveSessionTier {
  tierName: string;
  count: number;
  percentage: number;
  color: string;
}

interface ActiveSessionsData {
  totalCount: number;
  byTier: ActiveSessionTier[];
}

interface RecentTransaction {
  time: string;
  userName: string;
  userEmail: string;
  amount: number;
  type: 'compute' | 'storage';
  status: string;
}

interface AttentionRequiredData {
  lowBalanceUsers: {
    count: number;
    threshold: number;
    subtitle: string;
  };
  supportBacklog: {
    count: number;
    thresholdHours: number;
    avgResolutionTime: number;
    subtitle: string;
  };
  sessionFailures: {
    failureRate: number;
    priorWeekRate: number;
    subtitle: string;
  };
}

// --- HELPERS ---

function getGreeting(): string {
  const hour = new Date().getHours();
  if (hour < 12) return "Good morning";
  if (hour < 17) return "Good afternoon";
  return "Good evening";
}

// Format ticket createdAt as "May 19, 11:30 PM" in IST timezone
function formatTicketTime(iso: string): string {
  try {
    const d = new Date(iso);
    return d.toLocaleString('en-US', {
      timeZone: 'Asia/Kolkata',
      month: 'short',
      day: 'numeric',
      hour: 'numeric',
      minute: '2-digit',
      hour12: true,
    });
  } catch {
    return iso;
  }
}

// Format ticket createdAt as "May 20, 2026 at 12:26 AM" in IST timezone
function formatTicketRaisedAt(iso: string): string {
  try {
    const d = new Date(iso);
    const datePart = d.toLocaleDateString('en-US', {
      timeZone: 'Asia/Kolkata',
      month: 'long',
      day: 'numeric',
      year: 'numeric',
    });
    const timePart = d.toLocaleTimeString('en-US', {
      timeZone: 'Asia/Kolkata',
      hour: 'numeric',
      minute: '2-digit',
      hour12: true,
    });
    return `${datePart} at ${timePart}`;
  } catch {
    return iso;
  }
}

// Format elapsed time since iso as "2h 15m" or "3d 4h"
function formatElapsed(iso: string): string {
  const start = new Date(iso).getTime();
  const now = Date.now();
  const diffMs = Math.max(0, now - start);
  const minutes = Math.floor(diffMs / 60000);
  const hours = Math.floor(minutes / 60);
  const days = Math.floor(hours / 24);
  if (days > 0) {
    const remH = hours - days * 24;
    return `${days}d ${remH}h`;
  }
  if (hours > 0) {
    const remM = minutes - hours * 60;
    return `${hours}h ${remM}m`;
  }
  return `${minutes}m`;
}

// Format category enum like "POD_ISSUE" -> "Pod Issue"
function formatTicketCategory(cat: string): string {
  if (!cat) return '';
  return cat
    .split(/[_\s-]+/)
    .filter(Boolean)
    .map(w => w.charAt(0).toUpperCase() + w.slice(1).toLowerCase())
    .join(' ');
}

// --- COMPONENT ---

const API_BASE = process.env.NEXT_PUBLIC_API_URL || "";

export function AnalyticsDashboard({ user }: AnalyticsDashboardProps) {
  const [timeRange, setTimeRange] = useState<"24H" | "7D" | "30D" | "All">("7D");
  const [clientFilter, setClientFilter] = useState<string>("Overall");
  const [isClientDropdownOpen, setIsClientDropdownOpen] = useState(false);
  const clientDropdownRef = useRef<HTMLDivElement>(null);
  const [clients, setClients] = useState<Array<{ id: string; name: string }>>([]);
  const clientFilterOptions = ["Overall", ...clients.filter(c => c.name !== "Public").map((c) => c.name), "Public"];
  const activeClientId = useMemo(() => {
    if (clientFilter === "Overall") return undefined;
    if (clientFilter === "Public") return "__public__";
    const found = clients.find(c => c.name === clientFilter);
    return found?.id;
  }, [clientFilter, clients]);
  const isKsrceSelected = clientFilter.toLowerCase().includes('ksrce');

  // Close client filter dropdown when clicking outside
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (
        clientDropdownRef.current &&
        !clientDropdownRef.current.contains(event.target as Node)
      ) {
        setIsClientDropdownOpen(false);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  // Fetch clients for the client filter dropdown
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
        const data = await res.json();
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

  const [chartKey, setChartKey] = useState(0);
  const [kpiData, setKpiData] = useState<AnalyticsKpiResponse | null>(null);
  const [revenueChartData, setRevenueChartData] = useState<{
    ohlc: { open: number; high: number; low: number; close: number; previousHigh?: number };
    currentRate: number;
    rateChange: number;
    rateChangePct: number;
  } | null>(null);
  const [computeActivity, setComputeActivity] = useState<ComputeActivityData | null>(null);
  const [activeSessions, setActiveSessions] = useState<ActiveSessionsData | null>(null);
  const [recentTransactions, setRecentTransactions] = useState<RecentTransaction[]>([]);
  const [attentionRequired, setAttentionRequired] = useState<AttentionRequiredData | null>(null);
  const [revenueGrowthData, setRevenueGrowthData] = useState<NrrResponse | null>(null);
  const [retentionData, setRetentionData] = useState<RetentionData | null>(null);
  const [fleetHealthRefresh, setFleetHealthRefresh] = useState<string | null>(null);
  const [fleetHealthStatus, setFleetHealthStatus] = useState<'live' | 'stale'>('stale');
  const [, setKpiLoading] = useState(true);

  // Open Tickets state
  const [activeTab, setActiveTab] = useState<'attention' | 'tickets'>('attention');
  const [unresolvedTickets, setUnresolvedTickets] = useState<UnresolvedTicket[]>([]);
  const [ticketPage, setTicketPage] = useState(0);
  const TICKETS_PER_PAGE = 4;
  const [selectedTicket, setSelectedTicket] = useState<TicketDetail | null>(null);
  const [showViewModal, setShowViewModal] = useState(false);
  const [showCloseConfirm, setShowCloseConfirm] = useState(false);
  const [ticketToClose, setTicketToClose] = useState<string | null>(null);
  const [isResolvingTicket, setIsResolvingTicket] = useState(false);
  const [resolutionNotes, setResolutionNotes] = useState('');
  const [enlargedImage, setEnlargedImage] = useState<string | null>(null);
    const [showAllTransactions, setShowAllTransactions] = useState(false);
  const [attachmentBlobs, setAttachmentBlobs] = useState<Record<string, string>>({});

  // Auto-refresh fleet health every 60 seconds
  useEffect(() => {
    const token = getAnalyticsAccessToken();
    if (!token) return;

    const fetchFleetHealth = () => {
      fetch(`${API_BASE}/api/dashboard/analytics/fleet-health`, {
        headers: { Authorization: `Bearer ${token}` },
      })
        .then(res => res.ok ? res.json() : null)
        .then(data => {
          if (data && data.lastHeartbeatAt) {
            setFleetHealthRefresh(data.lastHeartbeatAt);
            setFleetHealthStatus('live');
          }
        })
        .catch(err => {
          console.error('[FleetHealth] refresh error:', err);
          setFleetHealthStatus('stale');
        });
    };

    fetchFleetHealth();
    const interval = setInterval(fetchFleetHealth, 60000);
    return () => clearInterval(interval);
  }, []);

  // Fetch KPI data and compute activity on timeRange change
  useEffect(() => {
    setKpiLoading(true);
    const token = getAnalyticsAccessToken();
    console.log('[KPI] token exists:', !!token, 'timeRange:', timeRange);
    if (!token) { setKpiLoading(false); return; }

    // Fetch KPI data
    fetch(`${API_BASE}/api/dashboard/analytics/kpi?timeRange=${timeRange}${activeClientId ? `&clientId=${activeClientId}` : ''}`, {
      headers: { Authorization: `Bearer ${token}` },
    })
      .then(res => {
        console.log('[KPI] response status:', res.status);
        return res.ok ? res.json() : res.text().then(t => { console.log('[KPI] error body:', t); return null; });
      })
      .then(data => {
        console.log('[KPI] data:', data);
        if (data) setKpiData(data);
      })
      .catch((err) => { console.error('[KPI] fetch error:', err); })
      .finally(() => setKpiLoading(false));

    // Fetch compute activity data
    fetch(`${API_BASE}/api/dashboard/analytics/compute-activity?timeRange=${timeRange}${activeClientId ? `&clientId=${activeClientId}` : ''}`, {
      headers: { Authorization: `Bearer ${token}` },
    })
      .then(res => res.ok ? res.json() : null)
      .then(data => {
        if (data) setComputeActivity(data);
      })
      .catch(err => console.error('[ComputeActivity] fetch error:', err));

    // Fetch revenue growth
    getRevenueGrowthData(timeRange, activeClientId)
      .then(data => setRevenueGrowthData(data))
      .catch(err => console.error('[RevenueGrowth] fetch error:', err));

    // Fetch user retention
    getRetentionData(timeRange, activeClientId)
      .then(data => setRetentionData(data))
      .catch(err => console.error('[Retention] fetch error:', err));
  }, [timeRange, clientFilter]);

    // Fetch active sessions, recent transactions, and attention required on mount
  useEffect(() => {
    const token = getAnalyticsAccessToken();
    if (!token) return;

    // Fetch active sessions
    fetch(`${API_BASE}/api/dashboard/analytics/active-sessions${activeClientId ? `?clientId=${activeClientId}` : ''}`, {
      headers: { Authorization: `Bearer ${token}` },
    })
      .then(res => res.ok ? res.json() : null)
      .then(data => {
        if (data) setActiveSessions(data);
      })
      .catch(err => console.error('[ActiveSessions] fetch error:', err));

    // Fetch recent transactions
    fetch(`${API_BASE}/api/dashboard/analytics/recent-transactions${activeClientId ? `?clientId=${activeClientId}` : ''}`, {
      headers: { Authorization: `Bearer ${token}` },
    })
      .then(res => res.ok ? res.json() : null)
      .then(data => {
        if (data) setRecentTransactions(data);
      })
      .catch(err => console.error('[RecentTransactions] fetch error:', err));

    // Fetch attention required
    fetch(`${API_BASE}/api/dashboard/analytics/attention-required${activeClientId ? `?clientId=${activeClientId}` : ''}`, {
      headers: { Authorization: `Bearer ${token}` },
    })
      .then(res => res.ok ? res.json() : null)
      .then(data => {
        if (data) setAttentionRequired(data);
      })
      .catch(err => console.error('[AttentionRequired] fetch error:', err));

    // Fetch unresolved support tickets
    getUnresolvedTickets().then(setUnresolvedTickets).catch(() => {});
  }, [clientFilter]);

  // Fetch attachment blobs whenever a ticket is selected for viewing
  useEffect(() => {
    if (!selectedTicket || !selectedTicket.attachments?.length) {
      return;
    }
    const token = getAnalyticsAccessToken();
    if (!token) return;

    const created: string[] = [];
    let cancelled = false;

    selectedTicket.attachments.forEach(att => {
      const url = getTicketAttachmentUrl(selectedTicket.id, att.id);
      fetch(url, { headers: { Authorization: `Bearer ${token}` } })
        .then(r => (r.ok ? r.blob() : null))
        .then(blob => {
          if (!blob || cancelled) return;
          const blobUrl = URL.createObjectURL(blob);
          created.push(blobUrl);
          setAttachmentBlobs(prev => ({ ...prev, [att.id]: blobUrl }));
        })
        .catch(() => {});
    });

    return () => {
      cancelled = true;
      created.forEach(URL.revokeObjectURL);
      setAttachmentBlobs({});
    };
  }, [selectedTicket]);

  // Ticket action handlers
  const refreshTickets = () => {
    getUnresolvedTickets().then(setUnresolvedTickets).catch(() => {});
  };

  const handleViewTicket = async (ticketId: string) => {
    try {
      const detail = await getTicketDetail(ticketId);
      setSelectedTicket(detail);
      setResolutionNotes('');
      setShowViewModal(true);
    } catch (err) {
      console.error('[Tickets] view error:', err);
    }
  };

  const handleRequestClose = (ticketId: string) => {
    setTicketToClose(ticketId);
    setShowCloseConfirm(true);
  };

  const handleConfirmCloseFromTable = async () => {
    if (!ticketToClose || isResolvingTicket) return;
    setIsResolvingTicket(true);
    try {
      await resolveTicket(ticketToClose);
      refreshTickets();
      setShowCloseConfirm(false);
      setTicketToClose(null);
    } catch (err) {
      console.error('[Tickets] close error:', err);
    } finally {
      setIsResolvingTicket(false);
    }
  };

  const handleConfirmCloseFromModal = async () => {
    if (!selectedTicket || isResolvingTicket) return;
    setIsResolvingTicket(true);
    try {
      await resolveTicket(selectedTicket.id, resolutionNotes || undefined);
      refreshTickets();
      setShowViewModal(false);
      setSelectedTicket(null);
      setResolutionNotes('');
    } catch (err) {
      console.error('[Tickets] close from modal error:', err);
    } finally {
      setIsResolvingTicket(false);
    }
  };

  const greeting = getGreeting();
  const displayName = user.firstName || "there";

  const todayIndex = new Date().getDay();
  // Map: 0=Sun,1=Mon...6=Sat to our array index (Mon=0)
  const todayBarIndex = todayIndex === 0 ? 6 : todayIndex - 1;

  // Revenue Rate — from actual chart data via onDataLoaded callback
  const currentRevenueRate = revenueChartData?.currentRate ?? 0;
  const revenueRateChange = revenueChartData?.rateChange ?? 0;
  const revenueRateChangePct = revenueChartData?.rateChangePct ?? 0;
  const revenueRateHigh = revenueChartData?.ohlc.high ?? 0;
  const revenueRateLow = revenueChartData?.ohlc.low ?? 0;
  const previousRevenueRate = revenueChartData?.ohlc.open ?? 0;
  const isRatePositive = revenueRateChange >= 0;

  return (
    <div className="min-h-full bg-[#0a0a0a] py-4 px-2">
      <div>

        {/* Row 1: Header */}
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-3">
          <div>
            <h1 className="text-2xl lg:text-3xl font-semibold text-white tracking-tight">
              {greeting}, {displayName}!
            </h1>
            <p className="text-zinc-500 text-sm mt-0.5 uppercase tracking-wider">
              KSRCE Analytics Overview
            </p>
          </div>
          <div className="flex items-center gap-3">
            {/* Client filter dropdown */}
            {isClientDropdownOpen && (
              <div
                style={{
                  position: "fixed",
                  inset: 0,
                  zIndex: 90,
                  backgroundColor: "rgba(11, 11, 11, 0.5)",
                  backdropFilter: "blur(6px)",
                  WebkitBackdropFilter: "blur(6px)",
                }}
                onClick={() => setIsClientDropdownOpen(false)}
              />
            )}
            <div ref={clientDropdownRef} style={{ position: "relative", zIndex: 100 }}>
              <button
                onClick={() => setIsClientDropdownOpen((prev) => !prev)}
                className={`flex items-center gap-1.5 px-4 py-1.5 text-sm font-medium text-zinc-400 hover:text-zinc-200 rounded-full transition-all border ${
                  isClientDropdownOpen
                    ? "border-zinc-700"
                    : "border-transparent hover:border-zinc-700"
                }`}
              >
                <span>{clientFilter}</span>
                <ChevronDown
                  className={`w-4 h-4 transition-transform ${
                    isClientDropdownOpen ? "rotate-180" : ""
                  }`}
                />
              </button>

              {isClientDropdownOpen && (
                <div
                  style={{
                    position: "absolute",
                    top: "100%",
                    left: 0,
                    marginTop: "4px",
                    backgroundColor:
                      "var(--bgColor-elevated, var(--bgColor-default))",
                    border: "1px solid var(--borderColor-default)",
                    borderRadius: "4px",
                    boxShadow: "0 4px 16px rgba(0, 0, 0, 0.15)",
                    zIndex: 100,
                    minWidth: "160px",
                    overflow: "hidden",
                  }}
                >
                  {clientFilterOptions.map((option) => {
                    const isSelected = clientFilter === option;
                    return (
                      <button
                        key={option}
                        onClick={() => {
                          setClientFilter(option);
                          setIsClientDropdownOpen(false);
                        }}
                        style={{
                          width: "100%",
                          display: "flex",
                          alignItems: "center",
                          justifyContent: "space-between",
                          gap: "8px",
                          padding: "10px 12px",
                          backgroundColor: isSelected
                            ? "var(--bgColor-muted)"
                            : "transparent",
                          border: "none",
                          cursor: "pointer",
                          fontFamily: "var(--font-sans)",
                          fontSize: "0.8125rem",
                          color: "var(--fgColor-default)",
                          textAlign: "left",
                          transition: "background-color 0.15s ease",
                        }}
                        onMouseOver={(e) => {
                          e.currentTarget.style.backgroundColor =
                            "var(--bgColor-muted)";
                        }}
                        onMouseOut={(e) => {
                          e.currentTarget.style.backgroundColor = isSelected
                            ? "var(--bgColor-muted)"
                            : "transparent";
                        }}
                      >
                        <span>{option}</span>
                        {isSelected && (
                          <Check
                            width={14}
                            height={14}
                            style={{ color: "var(--fgColor-muted)" }}
                          />
                        )}
                      </button>
                    );
                  })}
                </div>
              )}
            </div>

            {/* Timeframe selector */}
            <div className="flex items-center border border-zinc-700 rounded-full p-1">
              {(["24H", "7D", "30D", "All"] as const).map((range) => (
                <button
                  key={range}
                  onClick={() => setTimeRange(range)}
                  className={`px-4 py-1.5 text-sm font-medium rounded-full transition-colors ${
                    timeRange === range
                      ? "bg-white text-black"
                      : "text-zinc-400 hover:text-zinc-200"
                  }`}
                >
                  {range}
                </button>
              ))}
            </div>
          </div>
        </div>

        {/* Row 2: KPI Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-3 mb-3">
          {/* Revenue */}
          <KPICard
            label={isKsrceSelected ? "CAPEX" : "REVENUE"}
            value={kpiData ? `₹${(kpiData.revenue.total / 100).toLocaleString("en-IN")}` : "—"}
            change={kpiData ? `${kpiData.revenue.changePct >= 0 ? '+' : ''}${kpiData.revenue.changePct.toFixed(1)}%` : "—"}
            changePositive={kpiData ? kpiData.revenue.changePct >= 0 : true}
            subtitle={kpiData?.revenue.subtitleContext || ""}
            insight={kpiData ? (timeRange === '24H' ? '₹ — avg daily' : `₹${(kpiData.revenue.dailyAvg / 100).toLocaleString("en-IN")} avg daily`) : ""}
          />
          {/* Active Users */}
          <KPICard
            label="ACTIVE USERS"
            value={kpiData ? String(kpiData.activeUsers.count) : "—"}
            change={kpiData ? `${kpiData.activeUsers.newUsers >= 0 ? '+' : ''}${kpiData.activeUsers.newUsers} new` : "—"}
            changePositive={kpiData ? kpiData.activeUsers.newUsers >= 0 : true}
            subtitle={kpiData?.activeUsers.subtitleContext || ""}
            insight={kpiData ? `${kpiData.activeUsers.liveSessions} sessions live now` : ""}
          />
          {/* GPU Hours */}
          <KPICard
            label={isKsrceSelected ? "GPU HOURS RENTED" : "GPU HOURS SOLD"}
            value={kpiData ? `${kpiData.gpuHours.totalHours.toFixed(0)} hrs` : "—"}
            change={kpiData ? `${kpiData.gpuHours.changePct >= 0 ? '+' : ''}${kpiData.gpuHours.changePct.toFixed(1)}%` : "—"}
            changePositive={kpiData ? kpiData.gpuHours.changePct >= 0 : true}
            subtitle={kpiData?.gpuHours.subtitleContext || ""}
            insight={kpiData ? `Avg session: ${kpiData.gpuHours.avgSessionHours.toFixed(1)} hrs` : ""}
          />
          {/* Fleet Health */}
          <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4 flex flex-col">
            <div className="flex items-center justify-between">
              <span className="text-xs font-semibold text-white uppercase tracking-wider">
                FLEET HEALTH
              </span>
              <div className="flex items-center gap-2">
                {/* Status dot */}
                <span className={`w-2 h-2 rounded-full flex-shrink-0 ${
                  fleetHealthStatus === 'live'
                    ? 'bg-emerald-400 animate-pulse'
                    : 'bg-zinc-500'
                }`} />
                <span className="text-xs">
                  {(() => {
                    const rawDate = fleetHealthRefresh ?? kpiData?.fleetHealth.lastHeartbeatAt ?? null;
                    const text = rawDate ? formatLastHeartbeat(rawDate) : "";
                    const prefix = "Last updated: ";
                    if (text.startsWith(prefix)) {
                      const timePart = text.slice(prefix.length);
                      return (
                        <>
                          {fleetHealthStatus === 'live' && <span className="text-zinc-500">{prefix}</span>}
                          <span className="text-white font-medium">{timePart}</span>
                        </>
                      );
                    }
                    return <span className="text-zinc-500">{text}</span>;
                  })()}
                </span>
              </div>
            </div>
            <div className="flex-1 flex items-center justify-center mt-1">
              {kpiData ? (
                <FleetHealthGauge
                  uptimePct={kpiData.fleetHealth.uptimePct}
                  healthyNodes={kpiData.fleetHealth.healthyNodes}
                  totalNodes={kpiData.fleetHealth.totalNodes}
                  alertNodes={kpiData.fleetHealth.alertNodes}
                />
              ) : (
                <div className="text-2xl font-bold text-white">—</div>
              )}
            </div>
          </div>
        </div>

        {/* Row 3: Revenue Trend (left) + Attention Required (right) */}
        <div className="grid grid-cols-1 lg:grid-cols-[1fr_0.35fr] gap-3 mb-3 items-start">
          {/* Left: Revenue Trend Chart */}
          <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4 pb-2 flex flex-col min-w-0">
            {/* Top row: big value left, title + reset right */}
            <div className="flex items-center justify-between">
              <div className="flex items-end gap-3">
                <span className="text-2xl font-bold text-white leading-none">₹{currentRevenueRate.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</span>
                <div className="flex flex-col gap-0.5 mb-0.5">
                  <div className="flex items-center gap-1">
                    <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
                    <span className="text-[10px] font-semibold text-zinc-500 uppercase tracking-wider">LIVE</span>
                  </div>
                  <div className="flex items-baseline gap-2">
                    <span className="text-sm text-zinc-500">/hr</span>
                    <span className={`text-sm font-medium ${isRatePositive ? "text-emerald-400" : "text-red-400"}`}>
                      {isRatePositive ? "+" : ""}₹{Math.abs(revenueRateChange).toLocaleString("en-IN", { minimumFractionDigits: 2 })}
                    </span>
                    <span className={`text-sm font-medium ${isRatePositive ? "text-emerald-400" : "text-red-400"}`}>
                      {isRatePositive ? "+" : ""}{revenueRateChangePct.toFixed(1)}%
                    </span>
                  </div>
                </div>
              </div>
              <div className="flex items-center gap-2 mr-1">
                <h2 className="text-white font-semibold text-base">{isKsrceSelected ? "Capex Trend" : "Revenue Trend"}</h2>
                <span className="text-zinc-500 text-xs">
                  {timeRange === "24H" ? "Last 24 hours" : timeRange === "7D" ? "This Week" : timeRange === "All" ? "All time" : "This Month"}
                </span>
                <button
                  onClick={() => setChartKey(prev => prev + 1)}
                  className="p-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-800 transition-colors"
                  title="Reset chart view"
                >
                  <RotateCcw size={14} />
                </button>
              </div>
            </div>

            {/* OHLC row */}
            <div className="flex items-center gap-4 mt-1.5 mb-2">
              {timeRange === 'All' ? (
                <>
                  <span className="text-[11px] text-zinc-500">H <span className="text-emerald-400">₹{revenueRateHigh.toLocaleString("en-IN")}</span></span>
                  <span className="text-[11px] text-zinc-500">L <span className="text-red-400">₹{revenueRateLow.toLocaleString("en-IN")}</span></span>
                  <span className="text-[11px] text-zinc-500">C <span className="text-zinc-300">₹{currentRevenueRate.toLocaleString("en-IN")}</span></span>
                </>
              ) : (
                <>
                  <span className="text-[11px] text-zinc-500">PH <span className="text-zinc-300">₹{(revenueChartData?.ohlc.previousHigh ?? 0).toLocaleString("en-IN")}</span></span>
                  <span className="text-[11px] text-zinc-500">H <span className="text-emerald-400">₹{revenueRateHigh.toLocaleString("en-IN")}</span></span>
                  <span className="text-[11px] text-zinc-500">L <span className="text-red-400">₹{revenueRateLow.toLocaleString("en-IN")}</span></span>
                  <span className="text-[11px] text-zinc-500">C <span className="text-zinc-300">₹{currentRevenueRate.toLocaleString("en-IN")}</span></span>
                </>
              )}
            </div>

            <RevenueChart key={chartKey} height={240} timeRange={timeRange} clientId={activeClientId} onDataLoaded={setRevenueChartData} />
          </div>

          {/* Right: Attention Required / Open Tickets */}
          <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4 flex flex-col min-w-0 overflow-visible">
            {/* Tabbed header — billing-page style: thick underline + full-width separator */}
            <div className="relative flex items-center gap-5 mb-2 border-b border-[#262626]">
              <button
                onClick={() => { setActiveTab('attention'); }}
                className={`relative flex items-center gap-2 pb-2 -mb-px transition-colors ${
                  activeTab === 'attention'
                    ? 'border-b-[3px] border-white'
                    : 'border-b-[3px] border-transparent cursor-pointer'
                }`}
              >
                <span className={`w-2 h-2 rounded-full ${
                  !attentionRequired ? 'bg-zinc-500' :
                  attentionRequired.lowBalanceUsers.count > 20 ||
                  attentionRequired.supportBacklog.count > 5 ||
                  attentionRequired.sessionFailures.failureRate > 5
                    ? 'bg-red-400'
                    : attentionRequired.lowBalanceUsers.count > 10 ||
                      attentionRequired.supportBacklog.count > 2 ||
                      attentionRequired.sessionFailures.failureRate > 2
                      ? 'bg-amber-400'
                      : 'bg-emerald-400'
                }`} />
                <span className={`font-semibold text-sm ${
                  activeTab === 'attention' ? 'text-white' : 'text-[#a1a1aa]'
                }`}>Attention Required</span>
              </button>
              <button
                onClick={() => { setActiveTab('tickets'); setTicketPage(0); }}
                className={`relative pb-2 -mb-px transition-colors ${
                  activeTab === 'tickets'
                    ? 'border-b-[3px] border-white'
                    : 'border-b-[3px] border-transparent cursor-pointer'
                }`}
              >
                <span className={`font-semibold text-sm ${
                  activeTab === 'tickets' ? 'text-white' : 'text-[#a1a1aa]'
                }`}>Open Tickets ({unresolvedTickets.length})</span>
              </button>
            </div>

            {activeTab === 'attention' ? (
              <div className="flex flex-col gap-2">
                {/* Low Balance Users */}
                <AlertItem
                  title="Low Balance Users"
                  value={`${attentionRequired?.lowBalanceUsers.count ?? 0} users below ₹${attentionRequired?.lowBalanceUsers.threshold ?? 500}`}
                  context="May churn without top-up reminder"
                  severity={
                    !attentionRequired ? 'healthy' :
                    attentionRequired.lowBalanceUsers.count > 20 ? 'critical' :
                    attentionRequired.lowBalanceUsers.count > 10 ? 'warning' : 'healthy'
                  }
                />

                {/* Support Backlog */}
                <AlertItem
                  title="Support Backlog"
                  value={`${attentionRequired?.supportBacklog.count ?? 0} tickets > ${attentionRequired?.supportBacklog.thresholdHours ?? 12}h`}
                  context={attentionRequired?.supportBacklog.subtitle ?? "Avg resolution time: 0 hrs"}
                  severity={
                    !attentionRequired ? 'healthy' :
                    attentionRequired.supportBacklog.count > 5 ? 'critical' :
                    attentionRequired.supportBacklog.count > 2 ? 'warning' : 'healthy'
                  }
                />

                {/* Session Failures */}
                <AlertItem
                  title="Session Failures"
                  value={`${attentionRequired?.sessionFailures.failureRate ?? 0}% failure rate`}
                  context={attentionRequired?.sessionFailures.subtitle ?? "Down from 0% last week"}
                  severity={
                    !attentionRequired ? 'healthy' :
                    attentionRequired.sessionFailures.failureRate > 5 ? 'critical' :
                    attentionRequired.sessionFailures.failureRate > 2 ? 'warning' : 'healthy'
                  }
                />
              </div>
            ) : (
              (() => {
                const totalTicketPages = Math.max(1, Math.ceil(unresolvedTickets.length / TICKETS_PER_PAGE));
                const safePage = Math.min(ticketPage, totalTicketPages - 1);
                const pagedTickets = unresolvedTickets.slice(
                  safePage * TICKETS_PER_PAGE,
                  safePage * TICKETS_PER_PAGE + TICKETS_PER_PAGE
                );
                return (
                  <div className="flex flex-col min-h-0 flex-1">
                    {unresolvedTickets.length === 0 ? (
                      <div className="flex items-center justify-center py-10 text-zinc-500 text-xs">
                        No open tickets
                      </div>
                    ) : (
                      <>
                        <div className="flex-1 overflow-visible">
                          <table className="w-full text-left table-fixed">
                            <colgroup>
                              <col className="w-[130px]" />
                              <col />
                              <col className="w-[60px]" />
                              <col className="w-[50px]" />
                            </colgroup>
                            <thead>
                              <tr className="border-b border-zinc-800">
                                <th className="text-[10px] font-medium text-zinc-500 uppercase tracking-wider pb-2 pr-2">Time</th>
                                <th className="text-[10px] font-medium text-zinc-500 uppercase tracking-wider pb-2 pr-2">User</th>
                                <th className="text-[10px] font-medium text-zinc-500 uppercase tracking-wider pb-2 pr-2">Elapsed</th>
                                <th className="text-[10px] font-medium text-zinc-500 uppercase tracking-wider pb-2 text-right">Action</th>
                              </tr>
                            </thead>
                            <tbody>
                              {pagedTickets.map((t) => (
                                <tr key={t.id} className="border-b border-zinc-800/50 last:border-0">
                                  <td className="py-2 pr-3 text-xs text-zinc-400 font-mono whitespace-nowrap">{formatTicketTime(t.createdAt)}</td>
                                  <td className="py-2 pr-3 text-xs text-zinc-300 truncate" title={t.user?.email}>{t.user?.email}</td>
                                  <td className="py-2 pr-2 text-xs text-zinc-300 whitespace-nowrap">{formatElapsed(t.createdAt)}</td>
                                  <td className="py-2">
                                    <div className="flex justify-end">
                                      <TicketActionDropdown
                                        onViewDetails={() => handleViewTicket(t.id)}
                                        onCloseTicket={() => handleRequestClose(t.id)}
                                      />
                                    </div>
                                  </td>
                                </tr>
                              ))}
                            </tbody>
                          </table>
                        </div>
                        {/* Pagination — billing-style Previous/Next */}
                        <div className="flex items-center justify-between mt-3 pt-2 border-t border-zinc-800/60">
                          <span className="text-[11px] text-zinc-500">
                            Page {safePage + 1} of {totalTicketPages}
                          </span>
                          <div className="flex items-center gap-2">
                            <button
                              onClick={() => setTicketPage((p) => Math.max(0, p - 1))}
                              disabled={safePage === 0}
                              className={`px-2.5 py-1 text-[11px] rounded border border-zinc-800 bg-[#1a1a1a] transition-colors ${
                                safePage === 0
                                  ? 'text-zinc-600 opacity-50 cursor-not-allowed'
                                  : 'text-zinc-300 hover:bg-zinc-800 cursor-pointer'
                              }`}
                            >
                              Previous
                            </button>
                            <button
                              onClick={() => setTicketPage((p) => Math.min(totalTicketPages - 1, p + 1))}
                              disabled={safePage >= totalTicketPages - 1}
                              className={`px-2.5 py-1 text-[11px] rounded border border-zinc-800 bg-[#1a1a1a] transition-colors ${
                                safePage >= totalTicketPages - 1
                                  ? 'text-zinc-600 opacity-50 cursor-not-allowed'
                                  : 'text-zinc-300 hover:bg-zinc-800 cursor-pointer'
                              }`}
                            >
                              Next
                            </button>
                          </div>
                        </div>
                      </>
                    )}
                  </div>
                );
              })()
            )}
          </div>
        </div>

        {/* Row 4: Three-column bottom row */}
        <div className="grid grid-cols-1 lg:grid-cols-[1fr_0.75fr_0.75fr] gap-3">
          {/* Left: Compute Activity */}
          <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4 pb-2">
            <div className="flex items-center justify-between mb-2">
              <div>
                <h2 className="text-white font-semibold text-sm">Compute Activity</h2>
                <p className="text-zinc-500 text-[11px] mt-0.5">{computeActivity?.periodLabel || 'This Week'}</p>
              </div>
            </div>
            <div className="h-[200px]">
              {computeActivity && computeActivity.dailyBreakdown.length > 0 ? (
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={computeActivity.dailyBreakdown} margin={{ top: 15, right: 10, left: 0, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#222" vertical={false} />
                    <XAxis
                      dataKey="dayName"
                      stroke="#555"
                      tick={{ fill: "#71717a", fontSize: 10 }}
                      tickLine={false}
                      axisLine={false}
                    />
                    <YAxis
                      stroke="#555"
                      tick={{ fill: "#71717a", fontSize: 10 }}
                      tickLine={false}
                      axisLine={false}
                      tickFormatter={(v: number) => `${v}h`}
                    />
                    <Tooltip
                      cursor={{ fill: 'transparent' }}
                      contentStyle={{
                        backgroundColor: "var(--fgColor-default)",
                        border: "1px solid var(--borderColor-default)",
                        borderRadius: "4px",
                        fontSize: "0.875rem",
                        fontWeight: 500,
                        color: "var(--fgColor-inverse)",
                        padding: "6px 16px",
                      }}
                      labelStyle={{ color: "var(--fgColor-inverse)", fontWeight: 600, marginBottom: 2 }}
                      itemStyle={{ color: "var(--fgColor-inverse)" }}
                      formatter={(value: unknown) => [`${value} hrs`, "GPU Hours"]}
                    />
                    <Bar dataKey="hours" radius={[4, 4, 0, 0]} activeBar={{ fill: '#6366f1', fillOpacity: 0.8, stroke: '#6366f1', strokeWidth: 1 }} label={{ position: "top", fill: "#a1a1aa", fontSize: 10, formatter: (v: unknown) => `${v}h` }}>
                      {computeActivity.dailyBreakdown.map((item, index) => {
                        // Highlight today's bar with gradient
                        const today = new Date();
                        const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                        const todayDayName = dayNames[today.getDay()];
                        const isToday = item.dayName === todayDayName;
                        
                        return (
                          <Cell
                            key={`cell-${index}`}
                            fill={isToday ? "#6366f1" : "#3f3f46"}
                            style={{
                              cursor: 'pointer',
                              transition: 'fill 0.2s ease',
                            }}
                          />
                        );
                      })}
                    </Bar>
                  </BarChart>
                </ResponsiveContainer>
              ) : (
                <div className="flex items-center justify-center h-full text-zinc-500 text-sm">
                  No compute activity data
                </div>
              )}
            </div>
            <p className="text-zinc-500 text-xs mt-1">
              {computeActivity ? (
                <span dangerouslySetInnerHTML={{
                  __html: computeActivity.comparisonText.replace(
                    /(\d+\.?\d* GPU hours?)/g,
                    '<span class="text-zinc-300 font-medium">$1</span>'
                  )
                }} />
              ) : 'Loading...'}
            </p>
          </div>

          {/* Middle: Live Sessions */}
          <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4 pb-3 flex flex-col">
            <div className="flex items-center justify-between mb-1">
              <h2 className="text-white font-semibold text-sm">Active Sessions</h2>
              <div className="flex items-center gap-2">
                <span className="text-[11px] font-medium text-zinc-400 uppercase tracking-wider">Live</span>
                <span style={{ width: '10px', height: '10px', borderRadius: '50%', backgroundColor: '#22c55e' }} />
              </div>
            </div>
            <div className="flex-1 flex items-center justify-center relative">
              {activeSessions && activeSessions.byTier.length > 0 ? (
                <ResponsiveContainer width="100%" height={200}>
                  <PieChart>
                    <Pie
                      data={activeSessions.byTier.map(tier => ({
                        name: tier.tierName,
                        value: tier.count,
                        color: tier.color,
                      }))}
                      cx="50%"
                      cy="50%"
                      innerRadius={52}
                      outerRadius={75}
                      paddingAngle={2}
                      dataKey="value"
                    >
                      {activeSessions.byTier.map((entry, index) => (
                        <Cell key={`pie-${index}`} fill={entry.color} />
                      ))}
                    </Pie>
                    <Tooltip
                      contentStyle={{
                        backgroundColor: "#1a1a1a",
                        border: "1px solid #333",
                        borderRadius: "8px",
                        fontSize: "12px",
                      }}
                      formatter={(value: unknown, name: unknown) => [`${value} sessions`, String(name)]}
                    />
                  </PieChart>
                </ResponsiveContainer>
              ) : (
                <div className="flex items-center justify-center h-full text-zinc-500 text-sm">
                  No active sessions
                </div>
              )}
              {/* Center label */}
              <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
                <div className="text-center">
                  <div className="text-xl font-bold text-white">{activeSessions?.totalCount || 0}</div>
                  <div className="text-[10px] text-zinc-500 uppercase">active</div>
                </div>
              </div>
            </div>
            {/* Legend */}
            <div className="grid grid-cols-2 gap-x-3 gap-y-1">
              {activeSessions?.byTier.map((item) => (
                <div key={item.tierName} className="flex items-center gap-1.5">
                  <span
                    className="w-2 h-2 rounded-full flex-shrink-0"
                    style={{ backgroundColor: item.color }}
                  />
                  <span className="text-[11px] text-white truncate">{item.tierName}</span>
                  <span className="text-[11px] text-zinc-500 ml-auto">{item.count} ({item.percentage}%)</span>
                </div>
              ))}
            </div>
          </div>

          {/* Right: Recent Transactions */}
          <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4">
            <div className="flex items-center justify-between mb-2">
              <h2 className="text-white font-semibold text-sm">Recent Transactions</h2>
              <button
                onClick={() => setShowAllTransactions(true)}
                className="text-xs font-medium text-zinc-400 hover:text-white transition-colors cursor-pointer"
              >
                View All →
              </button>
            </div>
            <div className="overflow-x-auto">
              <table className="w-full text-left">
                <thead>
                  <tr className="border-b border-zinc-800">
                    <th className="text-[10px] font-medium text-zinc-500 uppercase tracking-wider pb-2 pr-2">Time</th>
                    <th className="text-[10px] font-medium text-zinc-500 uppercase tracking-wider pb-2 pr-2">User</th>
                    <th className="text-[10px] font-medium text-zinc-500 uppercase tracking-wider pb-2 pr-2">Amt</th>
                    <th className="text-[10px] font-medium text-zinc-500 uppercase tracking-wider pb-2">Status</th>
                  </tr>
                </thead>
                <tbody>
                  {recentTransactions.length > 0 ? recentTransactions.slice(0, 5).map((tx, i) => (
                    <tr key={i} className="border-b border-zinc-800/50 last:border-0">
                      <td className="py-2 pr-2 text-xs text-zinc-400 font-mono">{tx.time}</td>
                      <td className="py-2 pr-2 text-xs text-zinc-300 truncate max-w-[140px]">{tx.userEmail}</td>
                      <td className="py-2 pr-2 text-xs text-white font-medium">₹{tx.amount.toFixed(0)}</td>
                      <td className="py-2">
                        <div className="flex items-center gap-1.5">
                          <span
                            className={`w-2 h-2 rounded-full ${
                              tx.status === "completed" || tx.status === "paid"
                                ? "bg-emerald-500"
                                : tx.status === "failed"
                                  ? "bg-red-600"
                                  : tx.status === "pending" || tx.status === "active"
                                    ? "bg-amber-500"
                                    : "bg-zinc-500"
                            }`}
                          />
                          <span className="text-[11px] text-zinc-300">
                            {tx.status === "completed" || tx.status === "paid"
                              ? "Paid"
                              : tx.status === "failed"
                                ? "Failed"
                                : tx.status === "pending"
                                  ? "Pending"
                                  : tx.status}
                          </span>
                        </div>
                      </td>
                    </tr>
                  )) : (
                    <tr>
                      <td colSpan={4} className="py-4 text-center text-zinc-500 text-xs">
                        No recent transactions
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>
        </div>

        {/* Row 5: Business Insights — Revenue Growth & User-Session Retention */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-3 mt-3">
          <NrrCard data={revenueGrowthData} timeRange={timeRange} />
          <RetentionCard data={retentionData} timeRange={timeRange} />
        </div>

      </div>

      {/* View Ticket Modal */}
      {showViewModal && selectedTicket && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center backdrop-blur-sm"
          style={{
            backgroundColor: 'rgba(11, 11, 11, 0.5)',
            backdropFilter: 'blur(6px)',
            WebkitBackdropFilter: 'blur(6px)',
          }}
          onClick={() => {
            if (!isResolvingTicket) {
              setShowViewModal(false);
              setSelectedTicket(null);
              setResolutionNotes('');
            }
          }}
        >
          <div
            className="max-w-[480px] w-[calc(100%-32px)] flex flex-col"
            style={{
              maxHeight: '85vh',
              backgroundColor: 'var(--bgColor-default)',
              border: '1px solid var(--borderColor-default)',
            }}
            onClick={(e) => e.stopPropagation()}
          >
            {/* Header */}
            <div
              className="flex items-center justify-between px-5 py-3"
              style={{ borderBottom: '1px solid var(--borderColor-default)' }}
            >
              <h3 className="text-white text-base font-medium">Ticket Details</h3>
              <button
                onClick={() => {
                  setShowViewModal(false);
                  setSelectedTicket(null);
                  setResolutionNotes('');
                }}
                className="text-zinc-400 hover:text-white cursor-pointer"
                disabled={isResolvingTicket}
              >
                <X size={18} />
              </button>
            </div>

            {/* Content */}
            <div className="px-5 py-4 overflow-y-auto flex-1" style={{ maxHeight: '70vh' }}>
              {/* Raised by */}
              <div
                className="flex items-center justify-between text-sm text-zinc-400 pb-3 mb-3"
                style={{ borderBottom: '1px solid var(--borderColor-default)' }}
              >
                <span className="truncate pr-3">
                  {(() => {
                    const fn = selectedTicket.user?.firstName?.trim();
                    const ln = selectedTicket.user?.lastName?.trim();
                    const fullName = [fn, ln].filter(Boolean).join(' ');
                    return fullName || selectedTicket.user?.email || 'Unknown user';
                  })()}
                </span>
                <span className="whitespace-nowrap">{formatTicketRaisedAt(selectedTicket.createdAt)}</span>
              </div>

              {/* Type */}
              <div className="mb-3">
                <div className="text-[10px] uppercase tracking-wider text-zinc-500 mb-1">Type</div>
                <div className="text-sm text-zinc-300">{formatTicketCategory(selectedTicket.category)}</div>
              </div>

              {/* Subject */}
              <div className="mb-3">
                <div className="text-[10px] uppercase tracking-wider text-zinc-500 mb-1">Subject</div>
                <div className="text-sm text-white font-semibold">{selectedTicket.subject}</div>
              </div>

              {/* Attachments */}
              {selectedTicket.attachments && selectedTicket.attachments.length > 0 && (
                <div className="mb-3">
                  <div className="text-[10px] uppercase tracking-wider text-zinc-500 mb-1.5">Attachments</div>
                  <div className="flex flex-wrap gap-2">
                    {selectedTicket.attachments.map(att => {
                      const url = attachmentBlobs[att.id];
                      return (
                        <button
                          key={att.id}
                          type="button"
                          onClick={() => url && setEnlargedImage(url)}
                          className="w-16 h-16 rounded-sm overflow-hidden bg-[#0d0d0d] border border-[#262626] cursor-pointer flex items-center justify-center"
                          title={att.fileName}
                        >
                          {url ? (
                            <img
                              src={url}
                              alt={att.fileName}
                              className="w-full h-full object-cover"
                            />
                          ) : (
                            <span className="text-[9px] text-zinc-500">Loading…</span>
                          )}
                        </button>
                      );
                    })}
                  </div>
                </div>
              )}

              {/* Description */}
              <div className="mb-3">
                <div className="text-[10px] uppercase tracking-wider text-zinc-500 mb-1">Description</div>
                <div
                  className="text-sm text-white bg-[#2a2a2a] border border-[#3a3a3a] p-3"
                  style={{ whiteSpace: 'pre-wrap' }}
                >
                  {selectedTicket.description || <span className="text-zinc-400">(No description)</span>}
                </div>
              </div>

              {/* Resolution Notes */}
              <div>
                <div className="text-[10px] uppercase tracking-wider text-zinc-500 mb-1">Resolution Notes</div>
                <textarea
                  value={resolutionNotes}
                  onChange={(e) => setResolutionNotes(e.target.value)}
                  placeholder="Add resolution notes (optional)"
                  rows={3}
                  className="w-full text-sm text-zinc-300 bg-[#0d0d0d] border border-[#262626] p-3 outline-none focus:border-zinc-500 resize-y"
                />
              </div>
            </div>

            {/* Footer */}
            <div
              className="flex items-center justify-end gap-3 px-5 py-3"
              style={{ borderTop: '1px solid var(--borderColor-default)' }}
            >
              <button
                onClick={() => {
                  setShowViewModal(false);
                  setSelectedTicket(null);
                  setResolutionNotes('');
                }}
                disabled={isResolvingTicket}
                style={{
                  color: 'var(--fgColor-mild)',
                  backgroundColor: 'transparent',
                  border: '1px solid var(--borderColor-default)',
                  borderRadius: '4px',
                  padding: '0 24px',
                  height: '40px',
                  fontSize: '0.875rem',
                  fontWeight: 500,
                  cursor: isResolvingTicket ? 'not-allowed' : 'pointer',
                }}
              >
                Cancel
              </button>
              <button
                onClick={handleConfirmCloseFromModal}
                disabled={isResolvingTicket}
                className="bg-[#2E2E2E] text-[#E7E6D9] hover:bg-[#E7E6D9] hover:text-[#0B0B0B] transition-all duration-300"
                style={{
                  border: '1px solid transparent',
                  borderRadius: '4px',
                  padding: '0 24px',
                  height: '40px',
                  fontSize: '0.875rem',
                  fontWeight: 500,
                  cursor: isResolvingTicket ? 'not-allowed' : 'pointer',
                  opacity: isResolvingTicket ? 0.7 : 1,
                }}
              >
                {isResolvingTicket ? 'Closing…' : 'Close Ticket'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Close Confirmation Popup - matches SignOutModal */}
      {showCloseConfirm && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center"
          style={{ backgroundColor: 'rgba(11, 11, 11, 0.15)' }}
          onClick={() => {
            if (!isResolvingTicket) {
              setShowCloseConfirm(false);
              setTicketToClose(null);
            }
          }}
        >
          <div
            onClick={(e) => e.stopPropagation()}
            style={{
              width: 'calc(100% - 32px)',
              maxWidth: '420px',
              maxHeight: '95%',
              backgroundColor: 'var(--bgColor-default)',
              border: '1px solid var(--borderColor-default)',
              display: 'flex',
              flexDirection: 'column',
            }}
          >
            {/* Header */}
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                padding: '16px 24px',
                borderBottom: '1px solid var(--borderColor-default)',
                lineHeight: '1.375rem',
              }}
            >
              <h3
                style={{
                  flex: 1,
                  color: 'var(--fgColor-default)',
                  fontSize: '1.125rem',
                  fontFamily: 'var(--font-sans), ui-sans-serif, system-ui, sans-serif',
                  fontWeight: 400,
                  margin: 0,
                }}
              >
                Close Ticket
              </h3>
            </div>

            {/* Body */}
            <div
              style={{
                overflowY: 'auto',
                overflowX: 'hidden',
                padding: '24px',
              }}
            >
              <p
                style={{
                  color: 'var(--fgColor-mild)',
                  fontSize: '0.875rem',
                  lineHeight: '1.375rem',
                  fontFamily: 'var(--font-sans), ui-sans-serif, system-ui, sans-serif',
                  margin: 0,
                  marginBottom: '24px',
                }}
              >
                Are you sure you want to close this ticket? The user will be notified that their issue has been resolved.
              </p>

              <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '12px' }}>
                <button
                  onClick={() => {
                    setShowCloseConfirm(false);
                    setTicketToClose(null);
                  }}
                  disabled={isResolvingTicket}
                  style={{
                    color: 'var(--fgColor-mild)',
                    backgroundColor: 'transparent',
                    border: '1px solid var(--borderColor-default)',
                    borderRadius: '4px',
                    padding: '0 24px',
                    height: '40px',
                    fontFamily: 'var(--font-sans), ui-sans-serif, system-ui, sans-serif',
                    fontSize: '0.875rem',
                    fontWeight: 500,
                    cursor: isResolvingTicket ? 'not-allowed' : 'pointer',
                    transition: 'background-color 0.15s ease',
                  }}
                  onMouseEnter={(e) => {
                    e.currentTarget.style.backgroundColor = 'rgba(11, 11, 11, 0.05)';
                  }}
                  onMouseLeave={(e) => {
                    e.currentTarget.style.backgroundColor = 'transparent';
                  }}
                >
                  Cancel
                </button>
                <button
                  onClick={handleConfirmCloseFromTable}
                  disabled={isResolvingTicket}
                  style={{
                    color: '#E7E6D9',
                    backgroundColor: '#2E2E2E',
                    border: '1px solid transparent',
                    borderRadius: '4px',
                    padding: '0 24px',
                    height: '40px',
                    fontFamily: 'var(--font-sans), ui-sans-serif, system-ui, sans-serif',
                    fontSize: '0.875rem',
                    fontWeight: 500,
                    cursor: isResolvingTicket ? 'not-allowed' : 'pointer',
                    opacity: isResolvingTicket ? 0.7 : 1,
                    transition: 'background-color 0.15s ease',
                  }}
                  onMouseEnter={(e) => {
                    if (!isResolvingTicket) e.currentTarget.style.backgroundColor = '#0B0B0B';
                  }}
                  onMouseLeave={(e) => {
                    if (!isResolvingTicket) e.currentTarget.style.backgroundColor = '#2E2E2E';
                  }}
                >
                  {isResolvingTicket ? 'Closing…' : 'Close Ticket'}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Image Enlarge Overlay */}
      {enlargedImage && (
        <div
          className="fixed inset-0 z-[60] bg-black/80 flex items-center justify-center cursor-zoom-out"
          onClick={() => setEnlargedImage(null)}
        >
          <img
            src={enlargedImage}
            alt="Attachment preview"
            className="max-w-[90vw] max-h-[90vh] object-contain"
            onClick={(e) => e.stopPropagation()}
          />
        </div>
      )}

      {/* All Transactions Modal */}
      <AllTransactionsModal
        isOpen={showAllTransactions}
        onClose={() => setShowAllTransactions(false)}
        clientId={activeClientId}
      />
    </div>
  );
}

// --- SUB-COMPONENTS ---

function TicketActionDropdown({
  onViewDetails,
  onCloseTicket,
}: {
  onViewDetails: () => void;
  onCloseTicket: () => void;
}) {
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    }
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  return (
    <div ref={dropdownRef} className="relative">
      <button
        onClick={() => setIsOpen((v) => !v)}
        className={`w-7 h-7 rounded flex items-center justify-center transition-colors cursor-pointer ${
          isOpen ? 'bg-zinc-800 text-white' : 'text-zinc-400 hover:bg-zinc-800 hover:text-white'
        }`}
        aria-label="Ticket actions"
      >
        <MoreVertical size={14} />
      </button>
      {isOpen && (
        <div
          className="absolute right-0 top-full mt-1 z-[100] min-w-[170px] bg-[#0d0d0d] border border-[#333] rounded-sm shadow-lg overflow-hidden"
        >
          <button
            onClick={() => { setIsOpen(false); onViewDetails(); }}
            className="w-full flex items-center gap-2.5 px-3 py-2 text-sm font-medium text-white hover:bg-[#1a1a1a] transition-colors text-left cursor-pointer"
          >
            <Eye size={14} />
            View Details
          </button>
          <button
            onClick={() => { setIsOpen(false); onCloseTicket(); }}
            className="w-full flex items-center gap-2.5 px-3 py-2 text-sm font-medium text-white hover:bg-[#1a1a1a] transition-colors text-left cursor-pointer"
          >
            <XCircle size={14} />
            Close Ticket
          </button>
        </div>
      )}
    </div>
  );
}

function KPICard({
  label,
  value,
  change,
  changePositive,
  subtitle,
  insight,
}: {
  label: string;
  value: string;
  change: string;
  changePositive: boolean;
  subtitle: string;
  insight: string;
}) {
  return (
    <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4 flex flex-col justify-between">
      <span className="text-sm font-semibold text-white uppercase tracking-wider">
        {label}
      </span>
      {/* Value row: big number left, CDC capsule right */}
      <div className="flex items-center justify-between mt-2">
        <div className="text-2xl font-bold text-white">{value}</div>
        <div className="flex flex-col items-end mt-1">
          <span className={`inline-flex items-center gap-1 text-sm font-semibold px-3 py-1 rounded-full ${
            changePositive
              ? "bg-emerald-500/15 text-emerald-400"
              : "bg-red-500/15 text-red-400"
          }`}>
            <span>{changePositive ? "\u2197" : "\u2198"}</span>
            {change}
          </span>
          <span className="text-[11px] text-zinc-500 mt-0.5">{subtitle}</span>
        </div>
      </div>
      {/* Bottom row: insight left */}
      <div className="mt-2">
        <span className="text-sm text-zinc-400">{insight}</span>
      </div>
    </div>
  );
}

function AlertItem({
  title,
  value,
  context,
  severity,
}: {
  title: string;
  value: string;
  context: string;
  severity: 'critical' | 'warning' | 'healthy';
}) {
  const dotColor = severity === 'critical' ? 'bg-red-400' : severity === 'warning' ? 'bg-amber-400' : 'bg-emerald-400';
  const valueColor = severity === 'critical' ? 'text-red-400' : severity === 'warning' ? 'text-amber-400' : 'text-zinc-400';

  return (
    <div className="bg-[#0d0d0d] border border-zinc-800/50 rounded-lg p-3">
      {/* Row 1: Title (left) + Context (right) */}
      <div className="flex items-center justify-between mb-1.5">
        <div className="flex items-center gap-2 flex-1 min-w-0">
          <span className={`w-2 h-2 rounded-full flex-shrink-0 ${dotColor}`} />
          <span className="text-sm text-white font-semibold whitespace-nowrap">{title}</span>
        </div>
        <span 
          className={`text-right leading-snug flex-shrink-0 max-w-[55%] ${
            title === 'Low Balance Users' ? 'text-[10px] text-zinc-500 whitespace-nowrap' : 'text-sm text-zinc-400'
          }`}
          dangerouslySetInnerHTML={{ __html: context }}
        />
      </div>
      
      {/* Row 2: Value (full width) */}
      <div className={`text-base font-bold ${valueColor} pl-4`}>{value}</div>
    </div>
  );
}

// --- Row 5: NRR & Retention helpers ---

function getPeriodComparisonLabel(timeRange: "24H" | "7D" | "30D" | "All"): string {
  if (timeRange === '24H' || timeRange === '7D') return 'Day-over-Day';
  if (timeRange === '30D') return 'Period-over-Period';
  return 'Month-over-Month';
}

function NrrCard({
  data,
  timeRange,
}: {
  data: NrrResponse | null;
  timeRange: "24H" | "7D" | "30D" | "All";
}) {
  if (!data) {
    return (
      <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4 min-h-[340px] animate-pulse">
        <div className="h-3 w-32 bg-zinc-800/60 rounded" />
        <div className="mt-4 h-8 w-24 bg-zinc-800/60 rounded" />
        <div className="mt-6 h-[220px] bg-zinc-800/30 rounded" />
      </div>
    );
  }

  const periods = data.periods;
  const validPeriods = periods.filter(p => p.nrrPct !== null);
  const hasData = validPeriods.length > 0;

  const nrr = data.currentNrrPct;
  const nrrDisplay = nrr === null ? '--' : `${nrr.toFixed(0)}%`;
  const nrrColor =
    nrr === null ? 'text-white' : nrr > 100 ? 'text-emerald-400' : nrr < 100 ? 'text-red-400' : 'text-white';
  const nrrSubtitle =
    nrr === null ? 'vs prior period' : nrr > 100 ? 'existing users spending more' : 'existing users spending less';

  // Determine Y-axis domain
  const nrrValues = validPeriods.map(p => p.nrrPct as number);
  const maxNrr = nrrValues.length > 0 ? Math.max(...nrrValues) : 120;
  const minNrr = nrrValues.length > 0 ? Math.min(...nrrValues) : 80;
  const yMax = Math.min(200, Math.max(maxNrr + 20, 120));
  const yMin = Math.max(0, Math.min(minNrr - 20, 80));

  // Latest period stats
  const latestPeriod = periods[periods.length - 1];

  // Custom tooltip
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const renderTooltip = (props: Record<string, any>) => {
    if (!props.active || !props.payload || props.payload.length === 0) return null;
    const d = props.payload[0].payload as { label: string; nrrPct: number | null; cohortSize: number; expandedUsers: number; contractedUsers: number };
    return (
      <div className="bg-[#0d0d0d] border border-zinc-800 rounded px-3 py-2 text-xs">
        <div className="text-zinc-400 font-semibold mb-1">{d.label}</div>
        <div className="text-white">NRR: {d.nrrPct !== null ? `${d.nrrPct.toFixed(1)}%` : '--'}</div>
        <div className="text-zinc-400">Cohort: {d.cohortSize} users</div>
        <div className="text-emerald-400">Expanded: {d.expandedUsers}</div>
        <div className="text-red-400">Contracted: {d.contractedUsers}</div>
      </div>
    );
  };

  return (
    <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4 flex flex-col min-w-0">
      <div className="flex items-start justify-between">
        <span className="text-sm font-semibold text-white uppercase tracking-wider">
          Net Revenue Retention
        </span>
        <span className="text-[11px] text-zinc-500 uppercase tracking-wider">
          {getPeriodComparisonLabel(timeRange)}
        </span>
      </div>

      <div className="mt-3">
        <div className={`text-3xl font-semibold ${nrrColor} leading-none`}>
          {nrrDisplay}
        </div>
        <div className="text-[11px] text-zinc-500 mt-1">{nrrSubtitle}</div>
      </div>

      <div className="mt-3 h-[220px]">
        {hasData ? (
          <ResponsiveContainer width="100%" height="100%">
            <AreaChart data={periods} margin={{ top: 10, right: 12, left: 0, bottom: 0 }}>
              <defs>
                <linearGradient id="nrrGradient" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="0%" stopColor="#34d399" stopOpacity={0.3} />
                  <stop offset="100%" stopColor="#34d399" stopOpacity={0} />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="#1f1f1f" vertical={false} />
              <XAxis
                dataKey="label"
                stroke="#555"
                tick={{ fill: "#71717a", fontSize: 10 }}
                tickLine={false}
                axisLine={false}
              />
              <YAxis
                stroke="#555"
                tick={{ fill: "#71717a", fontSize: 10 }}
                tickLine={false}
                axisLine={false}
                domain={[yMin, yMax]}
                tickFormatter={(v: number) => `${v}%`}
                width={44}
              />
              <Tooltip content={renderTooltip} />
              <ReferenceLine
                y={100}
                stroke="#52525b"
                strokeDasharray="4 4"
                label={{ value: '100%', position: 'right', fill: '#71717a', fontSize: 10 }}
              />
              <Area
                type="monotone"
                dataKey="nrrPct"
                stroke="#34d399"
                strokeWidth={2}
                fill="url(#nrrGradient)"
                dot={{ r: 3, fill: '#34d399', strokeWidth: 0 }}
                activeDot={{ r: 5, fill: '#34d399', strokeWidth: 2, stroke: '#fff' }}
                connectNulls
              />
            </AreaChart>
          </ResponsiveContainer>
        ) : (
          <div className="flex items-center justify-center h-full text-zinc-500 text-sm">
            Insufficient data
          </div>
        )}
      </div>

      <div className="flex items-center justify-between mt-1.5">
        <span className="text-[13px] text-zinc-400">
          Expanded:{' '}<span className="text-white font-bold">{latestPeriod?.expandedUsers ?? 0}</span> · Contracted:{' '}<span className="text-white font-bold">{latestPeriod?.contractedUsers ?? 0}</span>
        </span>
        <span className="text-[13px] text-zinc-400">
          Avg NRR:{' '}
          <span className="text-white font-bold">{data.avgNrrPct.toFixed(1)}%</span>
        </span>
      </div>
    </div>
  );
}

function RetentionCard({
  data,
  timeRange,
}: {
  data: RetentionData | null;
  timeRange: "24H" | "7D" | "30D" | "All";
}) {
  if (!data) {
    return (
      <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4 min-h-[340px] animate-pulse">
        <div className="h-3 w-32 bg-zinc-800/60 rounded" />
        <div className="mt-4 h-8 w-24 bg-zinc-800/60 rounded" />
        <div className="mt-6 h-[220px] bg-zinc-800/30 rounded" />
      </div>
    );
  }

  const periods = data.periods;
  const hasData = periods.length > 0;
  const latest = hasData ? periods[periods.length - 1] : null;

  const retention = data.currentRetentionPct;
  const retentionDisplay = retention === null ? '--' : `${retention.toFixed(0)}%`;

  return (
    <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4 flex flex-col min-w-0">
      <div className="flex items-start justify-between">
        <span className="text-sm font-semibold text-white uppercase tracking-wider">
          User-Session Retention
        </span>
        <span className="text-[11px] text-zinc-500 uppercase tracking-wider">
          {getPeriodComparisonLabel(timeRange)}
        </span>
      </div>

      <div className="mt-3">
        <div className="text-3xl font-semibold text-white leading-none">{retentionDisplay}</div>
        <div className="text-[11px] text-zinc-500 mt-1">current retention</div>
      </div>

      <div className="mt-3 h-[220px]">
        {hasData ? (
          <ResponsiveContainer width="100%" height="100%">
            <AreaChart data={periods} margin={{ top: 14, right: 12, left: 0, bottom: 0 }}>
              <defs>
                <linearGradient id="retentionGradient" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="0%" stopColor="#34d399" stopOpacity={0.3} />
                  <stop offset="100%" stopColor="#34d399" stopOpacity={0} />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="#1f1f1f" vertical={false} />
              <XAxis
                dataKey="label"
                stroke="#555"
                tick={{ fill: "#71717a", fontSize: 10 }}
                tickLine={false}
                axisLine={false}
              />
              <YAxis
                stroke="#555"
                tick={{ fill: "#71717a", fontSize: 10 }}
                tickLine={false}
                axisLine={false}
                domain={[0, 100]}
                tickFormatter={(v: number) => `${v}%`}
                width={36}
              />
              <Tooltip
                cursor={{ stroke: '#3f3f46', strokeWidth: 1 }}
                contentStyle={{
                  backgroundColor: "#0d0d0d",
                  border: "1px solid #262626",
                  borderRadius: 4,
                  fontSize: 12,
                  padding: "8px 12px",
                }}
                labelStyle={{ color: "#a1a1aa", fontWeight: 600, marginBottom: 4 }}
                itemStyle={{ color: "#e4e4e7" }}
                formatter={(value: unknown, name: unknown, item: unknown) => {
                  const v =
                    value === null || value === undefined
                      ? '--'
                      : `${Number(value).toFixed(0)}%`;
                  const payload = (item as {
                    payload?: {
                      activeUsers: number;
                      retainedUsers: number;
                      newUsers: number;
                      churnedUsers: number;
                    };
                  } | undefined)?.payload;
                  if (payload) {
                    return [
                      `${v}  ·  Active ${payload.activeUsers} · Retained ${payload.retainedUsers} · New ${payload.newUsers} · Churned ${payload.churnedUsers}`,
                      String(name),
                    ];
                  }
                  return [v, String(name)];
                }}
              />
              <ReferenceLine
                y={data.avgRetentionPct}
                stroke="#52525b"
                strokeDasharray="4 4"
                ifOverflow="extendDomain"
              />
              <Area
                type="monotone"
                dataKey="retentionPct"
                name="Retention"
                stroke="#34d399"
                strokeWidth={2}
                fill="url(#retentionGradient)"
                dot={{ fill: '#34d399', r: 3, stroke: '#34d399' }}
                activeDot={{ r: 5, fill: '#34d399', stroke: '#0a0a0a', strokeWidth: 2 }}
                connectNulls
              />
            </AreaChart>
          </ResponsiveContainer>
        ) : (
          <div className="flex items-center justify-center h-full text-zinc-500 text-sm">
            No data available
          </div>
        )}
      </div>

      <div className="flex items-center justify-between mt-1.5">
        <span className="text-[13px] text-zinc-400">
          {latest ? (
            <>
              Active:{' '}
              <span className="text-white font-bold">{latest.activeUsers}</span> ·
              {' '}New:{' '}
              <span className="text-white font-bold">{latest.newUsers}</span> ·
              {' '}Churned:{' '}
              <span className="text-white font-bold">{latest.churnedUsers}</span>
            </>
          ) : (
            '—'
          )}
        </span>
        <span className="text-[13px] text-zinc-400">
          Avg retention:{' '}
          <span className="text-white font-bold">
            {data.avgRetentionPct.toFixed(0)}%
          </span>
        </span>
      </div>
    </div>
  );
}
