"use client";

import { useState } from "react";
import type { User } from "@/types/auth";
import {
  AreaChart,
  Area,
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
  ComposedChart,
} from "recharts";

interface AnalyticsDashboardProps {
  user: User;
}

// --- MOCK DATA ---

function generateRevenueData() {
  const data: { date: string; revenue: number; prevRevenue: number }[] = [];
  const base = new Date(2026, 4, 1); // May 1, 2026
  // Realistic 30 days: weekdays ₹7000-₹11000, weekends ₹3000-₹6000
  const dailyAmounts = [
    8200, 9100, 7800, 10200, 9400, 4800, 5200, // Week 1 (Thu-Wed, May 1-7)
    8700, 9800, 8400, 10500, 9900, 5100, 4600, // Week 2
    9200, 10100, 8900, 11000, 9600, 5400, 4900, // Week 3
    9800, 10800, 9300, 10700, 10200, 5600, 5100, // Week 4
    9500, 10430, // May 29-30
  ];
  for (let i = 0; i < 30; i++) {
    const d = new Date(base);
    d.setDate(d.getDate() + i);
    data.push({
      date: d.toLocaleDateString("en-US", { month: "short", day: "numeric" }),
      revenue: dailyAmounts[i],
      prevRevenue: i === 0 ? 7800 : dailyAmounts[i - 1],
    });
  }
  return data;
}

const revenueData = generateRevenueData();

const sparklineRevenue = [
  { v: 6200 }, { v: 7100 }, { v: 6800 }, { v: 7900 }, { v: 8200 },
  { v: 7400 }, { v: 8600 }, { v: 9100 }, { v: 8800 }, { v: 9400 },
];

const sparklineUsers = [
  { v: 120 }, { v: 128 }, { v: 131 }, { v: 138 }, { v: 142 },
  { v: 145 }, { v: 148 }, { v: 150 }, { v: 153 }, { v: 156 },
];

const sparklineGPU = [
  { v: 22 }, { v: 28 }, { v: 25 }, { v: 31 }, { v: 34 },
  { v: 29 }, { v: 36 }, { v: 32 }, { v: 38 }, { v: 35 },
];

const weeklyComputeData = [
  { day: "Mon", hours: 6.2 },
  { day: "Tue", hours: 7.8 },
  { day: "Wed", hours: 5.9 },
  { day: "Thu", hours: 8.4 },
  { day: "Fri", hours: 7.1 },
  { day: "Sat", hours: 3.8 },
  { day: "Sun", hours: 3.1 },
];

const configData = [
  { name: "Starter (CPU)", value: 35, color: "#71717a" },
  { name: "Standard (CPU)", value: 25, color: "#a1a1aa" },
  { name: "Pro (4GB GPU)", value: 20, color: "#6366f1" },
  { name: "Power (8GB GPU)", value: 12, color: "#818cf8" },
  { name: "Max (16GB GPU)", value: 5, color: "#a78bfa" },
  { name: "Full Machine", value: 3, color: "#f59e0b" },
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
  const [timeRange, setTimeRange] = useState<"24H" | "7D" | "30D" | "All">("30D");
  const greeting = getGreeting();
  const displayName = user.firstName || "there";

  const todayIndex = new Date().getDay();
  // Map: 0=Sun,1=Mon...6=Sat to our array index (Mon=0)
  const todayBarIndex = todayIndex === 0 ? 6 : todayIndex - 1;

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
            sparkData={sparklineRevenue}
            sparkColor="#6366f1"
          />
          {/* Active Users */}
          <KPICard
            label="ACTIVE USERS"
            value="156"
            change="+12 new"
            changePositive
            subtitle="this week"
            sparkData={sparklineUsers}
            sparkColor="#10b981"
          />
          {/* GPU Hours */}
          <KPICard
            label="GPU HOURS SOLD"
            value="847 hrs"
            change="+34.2%"
            changePositive
            subtitle="vs prior period"
            sparkData={sparklineGPU}
            sparkColor="#f59e0b"
          />
          {/* Fleet Health */}
          <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4 flex flex-col justify-between">
            <span className="text-[11px] font-medium text-zinc-500 uppercase tracking-wider">
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
            {/* Compact Header */}
            <div className="flex items-center justify-between mb-2">
              <div>
                <h2 className="text-white font-semibold text-sm">Revenue Trend</h2>
                <p className="text-zinc-500 text-[11px] mt-0.5">Last 30 days</p>
              </div>
            </div>

            {/* ComposedChart: Area (revenue) + Bar (volume, green/red) */}
            <div className="h-[240px]">
              <ResponsiveContainer width="100%" height="100%">
                <ComposedChart data={revenueData} margin={{ top: 5, right: 10, left: 0, bottom: 0 }}>
                  <defs>
                    <linearGradient id="gradRevenue" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="0%" stopColor="#6366f1" stopOpacity={0.35} />
                      <stop offset="60%" stopColor="#6366f1" stopOpacity={0.08} />
                      <stop offset="100%" stopColor="#6366f1" stopOpacity={0} />
                    </linearGradient>
                  </defs>
                  <CartesianGrid strokeDasharray="3 3" stroke="#1f1f1f" vertical={false} />
                  <XAxis
                    dataKey="date"
                    stroke="#333"
                    tick={{ fill: "#52525b", fontSize: 10 }}
                    tickLine={false}
                    axisLine={false}
                    interval={4}
                  />
                  <YAxis
                    yAxisId="revenue"
                    orientation="left"
                    stroke="#333"
                    tick={{ fill: "#52525b", fontSize: 10 }}
                    tickLine={false}
                    axisLine={false}
                    tickFormatter={(v: number) => `₹${(v / 1000).toFixed(0)}k`}
                    domain={[0, "auto"]}
                  />
                  <YAxis
                    yAxisId="volume"
                    orientation="right"
                    hide
                    domain={[0, (dataMax: number) => dataMax * 4]}
                  />
                  <Tooltip
                    contentStyle={{
                      backgroundColor: "#1a1a1a",
                      border: "1px solid #333",
                      borderRadius: "8px",
                      fontSize: "12px",
                    }}
                    labelStyle={{ color: "#aaa" }}
                    formatter={(value: unknown, name: unknown) => {
                      if (String(name) === "revenue") return [`₹${Number(value).toLocaleString("en-IN")}`, "Revenue"];
                      return [`₹${Number(value).toLocaleString("en-IN")}`, "Volume"];
                    }}
                  />
                  <Bar yAxisId="volume" dataKey="revenue" radius={[2, 2, 0, 0]} barSize={8} opacity={0.7}>
                    {revenueData.map((entry, index) => (
                      <Cell
                        key={`vol-${index}`}
                        fill={entry.revenue >= entry.prevRevenue ? "#22c55e" : "#ef4444"}
                        fillOpacity={0.6}
                      />
                    ))}
                  </Bar>
                  <Area
                    yAxisId="revenue"
                    type="monotone"
                    dataKey="revenue"
                    stroke="#6366f1"
                    strokeWidth={2}
                    fill="url(#gradRevenue)"
                    dot={false}
                    activeDot={{ r: 4, fill: "#6366f1", stroke: "#fff", strokeWidth: 1 }}
                  />
                </ComposedChart>
              </ResponsiveContainer>
            </div>
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
                    contentStyle={{
                      backgroundColor: "#1a1a1a",
                      border: "1px solid #333",
                      borderRadius: "8px",
                      fontSize: "12px",
                    }}
                    labelStyle={{ color: "#aaa" }}
                    formatter={(value: unknown) => [`${value} hrs`, "GPU Hours"]}
                  />
                  <Bar dataKey="hours" radius={[4, 4, 0, 0]} label={{ position: "top", fill: "#a1a1aa", fontSize: 10, formatter: (v: unknown) => `${v}h` }}>
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
            <p className="text-zinc-500 text-[11px] mt-1">
              You sold <span className="text-zinc-300 font-medium">42.3 GPU hours</span> this week, up 4.8 hrs from last week.
            </p>
          </div>

          {/* Middle: Config Popularity */}
          <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4 pb-2">
            <h2 className="text-white font-semibold text-sm mb-2">Config Popularity</h2>
            <div className="h-[180px] flex items-center justify-center relative">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie
                    data={configData}
                    cx="50%"
                    cy="50%"
                    innerRadius={42}
                    outerRadius={62}
                    paddingAngle={2}
                    dataKey="value"
                  >
                    {configData.map((entry, index) => (
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
                    formatter={(value: unknown, name: unknown) => [`${value}%`, String(name)]}
                  />
                </PieChart>
              </ResponsiveContainer>
              {/* Center label */}
              <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
                <div className="text-center">
                  <div className="text-lg font-bold text-white">1,247</div>
                  <div className="text-[10px] text-zinc-500 uppercase">sessions</div>
                </div>
              </div>
            </div>
            {/* Legend */}
            <div className="grid grid-cols-2 gap-x-3 gap-y-1 mt-1">
              {configData.map((item) => (
                <div key={item.name} className="flex items-center gap-1.5">
                  <span
                    className="w-2 h-2 rounded-full flex-shrink-0"
                    style={{ backgroundColor: item.color }}
                  />
                  <span className="text-[11px] text-zinc-400 truncate">{item.name}</span>
                  <span className="text-[11px] text-zinc-500 ml-auto">{item.value}%</span>
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
  sparkData,
  sparkColor,
}: {
  label: string;
  value: string;
  change: string;
  changePositive: boolean;
  subtitle: string;
  sparkData: { v: number }[];
  sparkColor: string;
}) {
  return (
    <div className="bg-[#141414] border border-zinc-800 rounded-xl p-4 flex flex-col justify-between">
      <span className="text-[11px] font-medium text-zinc-500 uppercase tracking-wider">
        {label}
      </span>
      <div className="flex items-end justify-between mt-2">
        <div>
          <div className="text-2xl font-bold text-white">{value}</div>
          <div className="flex items-center gap-2 mt-1">
            <span className={`text-xs font-medium px-2 py-0.5 rounded-full ${
              changePositive
                ? "bg-emerald-500/10 text-emerald-400"
                : "bg-red-500/10 text-red-400"
            }`}>
              {change}
            </span>
            <span className="text-[11px] text-zinc-500">{subtitle}</span>
          </div>
        </div>
        {/* Sparkline */}
        <div className="w-[80px] h-[32px]">
          <ResponsiveContainer width="100%" height="100%">
            <AreaChart data={sparkData} margin={{ top: 0, right: 0, left: 0, bottom: 0 }}>
              <defs>
                <linearGradient id={`spark-${label.replace(/\s+/g, "-")}`} x1="0" y1="0" x2="0" y2="1">
                  <stop offset="0%" stopColor={sparkColor} stopOpacity={0.3} />
                  <stop offset="100%" stopColor={sparkColor} stopOpacity={0} />
                </linearGradient>
              </defs>
              <Area
                type="monotone"
                dataKey="v"
                stroke={sparkColor}
                strokeWidth={1.5}
                fill={`url(#spark-${label.replace(/\s+/g, "-")})`}
              />
            </AreaChart>
          </ResponsiveContainer>
        </div>
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
