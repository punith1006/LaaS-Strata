"use client";

import { useState } from "react";
import dynamic from 'next/dynamic';
import { RotateCcw } from "lucide-react";
import type { User } from "@/types/auth";
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

// --- MOCK DATA ---

const weeklyComputeData = [
  { day: "Mon", hours: 6.2 },
  { day: "Tue", hours: 7.8 },
  { day: "Wed", hours: 5.9 },
  { day: "Thu", hours: 8.4 },
  { day: "Fri", hours: 7.1 },
  { day: "Sat", hours: 3.8 },
  { day: "Sun", hours: 3.1 },
];

const liveSessionsData = [
  { name: "Spark (2GB)", value: 8, color: "#71717a" },
  { name: "Blaze (4GB)", value: 12, color: "#6366f1" },
  { name: "Inferno (8GB)", value: 5, color: "#818cf8" },
  { name: "Supernova (16GB)", value: 2, color: "#f59e0b" },
];

const recentTransactions = [
  { time: "2:34 PM", user: "arun.k@ksrc.in", type: "compute", amount: 42.5, status: "completed" },
  { time: "2:12 PM", user: "priya.s@ksrc.in", type: "compute", amount: 28.0, status: "completed" },
  { time: "1:58 PM", user: "deepak.r@ksrc.in", type: "storage", amount: 5.0, status: "completed" },
  { time: "1:45 PM", user: "kavitha.m@ksrc.in", type: "compute", amount: 63.75, status: "active" },
  { time: "12:30 PM", user: "suresh.p@ksrc.in", type: "compute", amount: 21.0, status: "completed" },
  { time: "11:55 AM", user: "meena.v@ksrc.in", type: "storage", amount: 5.0, status: "completed" },
  { time: "11:20 AM", user: "raj.n@ksrc.in", type: "compute", amount: 84.0, status: "completed" },
  { time: "10:48 AM", user: "anitha.g@ksrc.in", type: "compute", amount: 35.25, status: "completed" },
];

// --- HELPERS ---

function getGreeting(): string {
  const hour = new Date().getHours();
  if (hour < 12) return "Good morning";
  if (hour < 17) return "Good afternoon";
  return "Good evening";
}

// --- COMPONENT ---

export function AnalyticsDashboard({ user }: AnalyticsDashboardProps) {
  const [timeRange, setTimeRange] = useState<"24H" | "7D" | "30D" | "All">("7D");
  const [chartKey, setChartKey] = useState(0);
  const greeting = getGreeting();
  const displayName = user.firstName || "there";

  const todayIndex = new Date().getDay();
  // Map: 0=Sun,1=Mon...6=Sat to our array index (Mon=0)
  const todayBarIndex = todayIndex === 0 ? 6 : todayIndex - 1;

  // Revenue Rate — trading-view style mock values (varies by timeRange)
  const ohlcByRange = {
    "24H": { open: 4880, high: 6240, low: 3420, close: 5700, change: 820 },
    "7D":  { open: 4200, high: 6240, low: 2800, close: 5700, change: 1500 },
    "30D": { open: 3600, high: 6240, low: 1200, close: 5700, change: 2100 },
    "All": { open: 3600, high: 6240, low: 1200, close: 5700, change: 2100 },
  };
  const { open: previousRevenueRate, high: revenueRateHigh, low: revenueRateLow, close: currentRevenueRate, change: revenueRateChange } = ohlcByRange[timeRange];
  const revenueRateChangePct = ((revenueRateChange / previousRevenueRate) * 100);
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
            value="₹2,47,830"
            change="+18.3%"
            changePositive
            subtitle="vs prior period"
            insight="₹8,261 avg daily"
          />
          {/* Active Users */}
          <KPICard
            label="ACTIVE USERS"
            value="156"
            change="+12 new"
            changePositive
            subtitle="this week"
            insight="23 sessions live now"
          />
          {/* GPU Hours */}
          <KPICard
            label="GPU HOURS SOLD"
            value="847 hrs"
            change="+34.2%"
            changePositive
            subtitle="vs prior period"
            insight="Avg session: 2.4 hrs"
          />
          {/* Fleet Health */}
          <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4 flex flex-col justify-between">
            <span className="text-xs font-semibold text-white uppercase tracking-wider">
              FLEET HEALTH
            </span>
            <div className="mt-2">
              <span className="text-2xl font-bold text-white">4/4 nodes</span>
            </div>
            <div className="flex items-center gap-2 mt-1.5">
              <span className="w-2 h-2 rounded-full bg-emerald-400 inline-block" />
              <span className="text-xs text-zinc-400">92% uptime</span>
            </div>
          </div>
        </div>

        {/* Row 3: Revenue Trend (left) + Attention Required (right) */}
        <div className="grid grid-cols-1 lg:grid-cols-[1fr_0.35fr] gap-3 mb-3">
          {/* Left: Revenue Trend Chart */}
          <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4 pb-2 flex flex-col">
            {/* Top row: big value left, title + reset right */}
            <div className="flex items-center justify-between">
              <div className="flex items-baseline gap-3">
                <div className="flex items-baseline">
                  <span className="text-2xl font-bold text-white">₹{currentRevenueRate.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</span>
                  <span className="text-sm text-zinc-500 ml-1">/hr</span>
                </div>
                <span className={`text-sm font-medium ${isRatePositive ? "text-emerald-400" : "text-red-400"}`}>
                  {isRatePositive ? "+" : ""}₹{Math.abs(revenueRateChange).toLocaleString("en-IN", { minimumFractionDigits: 2 })}
                </span>
                <span className={`text-sm font-medium ${isRatePositive ? "text-emerald-400" : "text-red-400"}`}>
                  {isRatePositive ? "+" : ""}{revenueRateChangePct.toFixed(1)}%
                </span>
              </div>
              <div className="flex items-center gap-2 mr-1">
                <h2 className="text-white font-semibold text-base">Revenue Rate</h2>
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
              <span className="text-[11px] text-zinc-500">O <span className="text-zinc-300">₹{previousRevenueRate.toLocaleString("en-IN")}</span></span>
              <span className="text-[11px] text-zinc-500">H <span className="text-emerald-400">₹{revenueRateHigh.toLocaleString("en-IN")}</span></span>
              <span className="text-[11px] text-zinc-500">L <span className="text-red-400">₹{revenueRateLow.toLocaleString("en-IN")}</span></span>
              <span className="text-[11px] text-zinc-500">C <span className="text-zinc-300">₹{currentRevenueRate.toLocaleString("en-IN")}</span></span>
            </div>

            <RevenueChart key={chartKey} height={240} timeRange={timeRange} />
          </div>

          {/* Right: Attention Required */}
          <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4 flex flex-col">
            <div className="flex items-center gap-2 mb-3">
              <span className="w-2 h-2 rounded-full bg-amber-400" />
              <h2 className="text-white font-semibold text-sm">Attention Required</h2>
            </div>
            <div className="flex flex-col gap-2.5 flex-1">
              <AlertItem
                title="Low Balance Users"
                metric="18 users below ₹100"
                subtitle="May churn without top-up reminder"
                color="amber"
              />
              <AlertItem
                title="Support Backlog"
                metric="3 tickets > 24h"
                subtitle="Avg resolution time: 4.2 hrs"
                color="red"
              />
              <AlertItem
                title="Session Failures"
                metric="2.1% failure rate"
                subtitle="Down from 3.8% last week"
                color="green"
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
                <p className="text-zinc-500 text-[11px] mt-0.5">This Week</p>
              </div>
            </div>
            <div className="h-[200px]">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={weeklyComputeData} margin={{ top: 15, right: 10, left: 0, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#222" vertical={false} />
                  <XAxis
                    dataKey="day"
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
                  <Bar dataKey="hours" radius={[4, 4, 0, 0]} activeBar={{ fill: '#6366f1', fillOpacity: 0.6, stroke: '#6366f1', strokeWidth: 1 }} label={{ position: "top", fill: "#a1a1aa", fontSize: 10, formatter: (v: unknown) => `${v}h` }}>
                    {weeklyComputeData.map((_, index) => (
                      <Cell
                        key={`cell-${index}`}
                        fill={index === todayBarIndex ? "#6366f1" : "#3f3f46"}
                      />
                    ))}
                  </Bar>
                </BarChart>
              </ResponsiveContainer>
            </div>
            <p className="text-zinc-500 text-xs mt-1">
              You sold <span className="text-zinc-300 font-medium">42.3 GPU hours</span> this week, up 4.8 hrs from last week.
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
              <ResponsiveContainer width="100%" height={200}>
                <PieChart>
                  <Pie
                    data={liveSessionsData}
                    cx="50%"
                    cy="50%"
                    innerRadius={52}
                    outerRadius={75}
                    paddingAngle={2}
                    dataKey="value"
                  >
                    {liveSessionsData.map((entry, index) => (
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
              {/* Center label */}
              <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
                <div className="text-center">
                  <div className="text-xl font-bold text-white">27</div>
                  <div className="text-[10px] text-zinc-500 uppercase">active</div>
                </div>
              </div>
            </div>
            {/* Legend */}
            <div className="grid grid-cols-2 gap-x-3 gap-y-1">
              {liveSessionsData.map((item) => {
                const total = liveSessionsData.reduce((sum, d) => sum + d.value, 0);
                const pct = Math.round((item.value / total) * 100);
                return (
                  <div key={item.name} className="flex items-center gap-1.5">
                    <span
                      className="w-2 h-2 rounded-full flex-shrink-0"
                      style={{ backgroundColor: item.color }}
                    />
                    <span className="text-[11px] text-white truncate">{item.name}</span>
                    <span className="text-[11px] text-zinc-500 ml-auto">{item.value} ({pct}%)</span>
                  </div>
                );
              })}
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
                  {recentTransactions.slice(0, 5).map((tx, i) => (
                    <tr key={i} className="border-b border-zinc-800/50 last:border-0">
                      <td className="py-2 pr-2 text-xs text-zinc-400 font-mono">{tx.time}</td>
                      <td className="py-2 pr-2 text-xs text-zinc-300 truncate max-w-[100px]">{tx.user.split("@")[0]}</td>
                      <td className="py-2 pr-2 text-xs text-white font-medium">₹{tx.amount.toFixed(0)}</td>
                      <td className="py-2">
                        <span className={`text-[11px] font-medium ${
                          tx.status === "completed" ? "text-emerald-400" :
                          tx.status === "active" ? "text-amber-400" : "text-zinc-500"
                        }`}>
                          {tx.status === "completed" ? "✓" : tx.status === "active" ? "●" : tx.status}
                        </span>
                      </td>
                    </tr>
                  ))}
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
  metric,
  subtitle,
  color,
}: {
  title: string;
  metric: string;
  subtitle: string;
  color: "amber" | "red" | "green";
}) {
  const dotColor = color === "amber" ? "bg-amber-400" : color === "red" ? "bg-red-400" : "bg-emerald-400";
  const metricColor = color === "amber" ? "text-amber-400" : color === "red" ? "text-red-400" : "text-emerald-400";

  return (
    <div className="bg-[#0d0d0d] border border-zinc-800/50 rounded-lg p-3">
      <div className="flex items-center gap-2 mb-1">
        <span className={`w-1.5 h-1.5 rounded-full ${dotColor}`} />
        <span className="text-[11px] text-zinc-400 font-medium">{title}</span>
      </div>
      <div className={`text-xs font-semibold ${metricColor} mb-0.5`}>{metric}</div>
      <p className="text-[10px] text-zinc-500">{subtitle}</p>
    </div>
  );
}
