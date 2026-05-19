"use client";

import { useState, useEffect } from "react";
import dynamic from 'next/dynamic';
import { RotateCcw } from "lucide-react";
import { FleetHealthGauge, formatLastHeartbeat } from "./fleet-health-gauge";
import type { User } from "@/types/auth";
import { getAnalyticsAccessToken } from "@/lib/token";
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

// --- COMPONENT ---

const API_BASE = process.env.NEXT_PUBLIC_API_URL || "";

export function AnalyticsDashboard({ user }: AnalyticsDashboardProps) {
  const [timeRange, setTimeRange] = useState<"24H" | "7D" | "30D" | "All">("7D");
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
  const [fleetHealthRefresh, setFleetHealthRefresh] = useState<string | null>(null);
  const [fleetHealthStatus, setFleetHealthStatus] = useState<'live' | 'stale'>('stale');
  const [, setKpiLoading] = useState(true);

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
    fetch(`${API_BASE}/api/dashboard/analytics/kpi?timeRange=${timeRange}`, {
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
    fetch(`${API_BASE}/api/dashboard/analytics/compute-activity?timeRange=${timeRange}`, {
      headers: { Authorization: `Bearer ${token}` },
    })
      .then(res => res.ok ? res.json() : null)
      .then(data => {
        if (data) setComputeActivity(data);
      })
      .catch(err => console.error('[ComputeActivity] fetch error:', err));
  }, [timeRange]);

    // Fetch active sessions, recent transactions, and attention required on mount
  useEffect(() => {
    const token = getAnalyticsAccessToken();
    if (!token) return;

    // Fetch active sessions
    fetch(`${API_BASE}/api/dashboard/analytics/active-sessions`, {
      headers: { Authorization: `Bearer ${token}` },
    })
      .then(res => res.ok ? res.json() : null)
      .then(data => {
        if (data) setActiveSessions(data);
      })
      .catch(err => console.error('[ActiveSessions] fetch error:', err));

    // Fetch recent transactions
    fetch(`${API_BASE}/api/dashboard/analytics/recent-transactions`, {
      headers: { Authorization: `Bearer ${token}` },
    })
      .then(res => res.ok ? res.json() : null)
      .then(data => {
        if (data) setRecentTransactions(data);
      })
      .catch(err => console.error('[RecentTransactions] fetch error:', err));

    // Fetch attention required
    fetch(`${API_BASE}/api/dashboard/analytics/attention-required`, {
      headers: { Authorization: `Bearer ${token}` },
    })
      .then(res => res.ok ? res.json() : null)
      .then(data => {
        if (data) setAttentionRequired(data);
      })
      .catch(err => console.error('[AttentionRequired] fetch error:', err));
  }, []);

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

        {/* Row 2: KPI Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-3 mb-3">
          {/* Revenue */}
          <KPICard
            label="REVENUE"
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
            label="GPU HOURS SOLD"
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
                <h2 className="text-white font-semibold text-base">Revenue Trend</h2>
                <span className="text-zinc-500 text-xs">
                  {timeRange === "24H" ? "Last 24 hours" : timeRange === "7D" ? "Last 7 days" : timeRange === "All" ? "All time" : "Last 30 days"}
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

            <RevenueChart key={chartKey} height={240} timeRange={timeRange} onDataLoaded={setRevenueChartData} />
          </div>

          {/* Right: Attention Required */}
          <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4 flex flex-col min-w-0">
            <div className="flex items-center gap-2 mb-3">
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
              <h2 className="text-white font-semibold text-sm">Attention Required</h2>
            </div>
            <div className="flex flex-col gap-2.5">
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
            <h2 className="text-white font-semibold text-sm mb-2">Recent Transactions</h2>
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

      </div>
    </div>
  );
}

// --- SUB-COMPONENTS ---

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
      <span className="text-xs font-semibold text-white uppercase tracking-wider">
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
    <div className="bg-[#0d0d0d] border border-zinc-800/50 rounded-lg p-3.5">
      {/* Row 1: Title (left) + Context (right) */}
      <div className="flex items-center justify-between mb-2">
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
