"use client";

import { useState, useEffect, useMemo } from "react";
import { getMentorBillingStats } from "@/lib/api";
import type { MentorBillingStats } from "@/lib/api";
import {
  BarChart,
  Bar,
  Cell,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  CartesianGrid,
  AreaChart,
  Area,
} from "recharts";

// ─── MetricCard (same pattern as billing-tab-content) ───
function MetricCard({
  icon,
  label,
  value,
  highlight,
}: {
  icon: React.ReactNode;
  label: string;
  value: string;
  highlight?: boolean;
}) {
  return (
    <div
      style={{
        backgroundColor: highlight ? "var(--bgColor-info, #cedeff)" : "var(--bgColor-mild)",
        border: highlight
          ? "1px solid var(--borderColor-info, #3a73ff)"
          : "1px solid var(--borderColor-default)",
        borderRadius: "4px",
        padding: "16px",
        display: "flex",
        alignItems: "center",
        gap: "12px",
        flex: 1,
        minWidth: "160px",
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
      </div>
    </div>
  );
}

// ─── Icons (inline SVGs, Lambda.ai line style) ───
const WalletIcon = (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" style={{ color: "var(--fgColor-info, #3a73ff)" }}>
    <rect x="2" y="6" width="20" height="12" rx="2" />
    <path d="M2 10h20" />
  </svg>
);

const CheckCircleIcon = (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" style={{ color: "var(--fgColor-muted)" }}>
    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
    <polyline points="22 4 12 14.01 9 11.01" />
  </svg>
);

const ClockIcon = (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" style={{ color: "var(--fgColor-muted)" }}>
    <circle cx="12" cy="12" r="10" />
    <path d="M12 6v6l4 2" />
  </svg>
);

const TrendingUpIcon = (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" style={{ color: "var(--fgColor-muted)" }}>
    <polyline points="23 6 13.5 15.5 8.5 10.5 1 18" />
    <polyline points="17 6 23 6 23 12" />
  </svg>
);

// ─── Helpers ───
function formatCurrency(cents: number): string {
  return `₹${(cents / 100).toLocaleString("en-IN", { minimumFractionDigits: 0, maximumFractionDigits: 0 })}`;
}

export default function MentorBillingOverview() {
  const [stats, setStats] = useState<MentorBillingStats | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getMentorBillingStats()
      .then((data) => setStats(data))
      .finally(() => setLoading(false));
  }, []);

  // Build chart data for daily earnings (cumulative + daily)
  const earningsChartData = useMemo(() => {
    if (!stats?.dailyEarnings.length) return [];
    let cumulative = 0;
    return stats.dailyEarnings.map((d) => {
      cumulative += d.earningsCents;
      const dateObj = new Date(d.date + "T00:00:00");
      return {
        date: dateObj.toLocaleDateString("en-US", { month: "short", day: "numeric" }),
        daily: d.earningsCents / 100,
        cumulative: cumulative / 100,
      };
    });
  }, [stats?.dailyEarnings]);

  // Rolling average daily earnings
  const rollingAvg = useMemo(() => {
    if (!stats?.dailyEarnings.length) return 0;
    const total = stats.dailyEarnings.reduce((s, d) => s + d.earningsCents, 0);
    return total / stats.dailyEarnings.length / 100;
  }, [stats?.dailyEarnings]);

  if (loading) {
    return (
      <div style={{ padding: "48px", textAlign: "center" }}>
        <p style={{ color: "var(--fgColor-muted)", fontSize: "0.875rem" }}>Loading billing data...</p>
      </div>
    );
  }

  return (
    <div>
      {/* ─── Section 1: Overview KPI Cards ─── */}
      <div
        style={{
          backgroundColor: "var(--bgColor-mild)",
          border: "1px solid var(--borderColor-default)",
          borderRadius: "4px",
          padding: "24px",
          marginBottom: "24px",
        }}
      >
        <h3
          style={{
            fontFamily: "var(--font-sans)",
            fontSize: "var(--text-h4)",
            fontWeight: 600,
            color: "var(--fgColor-default)",
            margin: 0,
            marginBottom: "4px",
          }}
        >
          Overview
        </h3>
        <p
          style={{
            fontFamily: "var(--font-sans)",
            fontSize: "var(--text-sm)",
            color: "var(--fgColor-muted)",
            margin: 0,
            marginBottom: "16px",
          }}
        >
          Your mentoring performance at a glance
        </p>

        <div style={{ display: "flex", gap: "16px", flexWrap: "wrap" }}>
          <MetricCard
            highlight
            icon={WalletIcon}
            label="Total Earnings"
            value={stats ? formatCurrency(stats.totalEarningsCents) : "₹0"}
          />
          <MetricCard
            icon={CheckCircleIcon}
            label="Sessions Completed"
            value={String(stats?.sessionsCompleted ?? 0)}
          />
          <MetricCard
            icon={ClockIcon}
            label="Mentoring Hours"
            value={`${(stats?.mentoringHoursTotal ?? 0).toFixed(1)} hrs`}
          />
          <MetricCard
            icon={TrendingUpIcon}
            label="Avg Earnings/Session"
            value={stats ? formatCurrency(stats.avgEarningsPerSessionCents) : "₹0"}
          />
        </div>
      </div>

      {/* ─── Section 2: Daily Earnings Chart ─── */}
      <div
        style={{
          backgroundColor: "var(--bgColor-mild)",
          border: "1px solid var(--borderColor-default)",
          borderRadius: "4px",
          padding: "24px",
          marginBottom: "24px",
          minHeight: "400px",
        }}
      >
        {/* Header */}
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: "16px" }}>
          <div>
            <h3
              style={{
                fontFamily: "var(--font-sans)",
                fontSize: "var(--text-h4)",
                fontWeight: 600,
                color: "var(--fgColor-default)",
                margin: 0,
                marginBottom: "4px",
              }}
            >
              Daily Earnings
            </h3>
            <p
              style={{
                fontFamily: "var(--font-sans)",
                fontSize: "var(--text-sm)",
                color: "var(--fgColor-muted)",
                margin: 0,
              }}
            >
              Track your daily mentoring income over the last 30 days.
            </p>
          </div>
          <span
            style={{
              fontFamily: "var(--font-sans)",
              fontSize: "var(--text-xs)",
              color: "var(--fgColor-muted)",
              backgroundColor: "var(--bgColor-muted)",
              padding: "4px 8px",
              borderRadius: "4px",
              border: "1px solid var(--borderColor-default)",
            }}
          >
            LAST 30 DAYS
          </span>
        </div>

        {/* Stats Row */}
        <div style={{ display: "flex", gap: "32px", marginBottom: "24px" }}>
          <div>
            <div
              style={{
                fontFamily: "var(--font-sans)",
                fontSize: "var(--text-xs)",
                color: "var(--fgColor-muted)",
                marginBottom: "4px",
                textTransform: "uppercase",
                letterSpacing: "0.05em",
              }}
            >
              Rolling average
            </div>
            <div
              style={{
                fontFamily: "var(--font-sans)",
                fontSize: "var(--text-h3)",
                fontWeight: 600,
                color: "var(--fgColor-default)",
              }}
            >
              ₹{rollingAvg.toFixed(2)}
              <span style={{ fontSize: "var(--text-sm)", fontWeight: 400, color: "var(--fgColor-muted)" }}>
                {" "}/ day
              </span>
            </div>
          </div>
          <div>
            <div
              style={{
                fontFamily: "var(--font-sans)",
                fontSize: "var(--text-xs)",
                color: "var(--fgColor-muted)",
                marginBottom: "4px",
                textTransform: "uppercase",
                letterSpacing: "0.05em",
              }}
            >
              Effective Hourly Rate
            </div>
            <div
              style={{
                fontFamily: "var(--font-sans)",
                fontSize: "var(--text-h3)",
                fontWeight: 600,
                color: "var(--fgColor-default)",
              }}
            >
              {stats ? formatCurrency(stats.effectiveHourlyRateCents) : "₹0"}
              <span style={{ fontSize: "var(--text-sm)", fontWeight: 400, color: "var(--fgColor-muted)" }}>
                {" "}/ hr
              </span>
            </div>
          </div>
        </div>

        {/* Chart */}
        <div style={{ height: "260px" }}>
          {earningsChartData.length > 0 ? (
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={earningsChartData} margin={{ top: 10, right: 10, left: 0, bottom: 0 }}>
                <defs>
                  <linearGradient id="earningsGradient" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#3b82f6" stopOpacity={0.3} />
                    <stop offset="95%" stopColor="#3b82f6" stopOpacity={0} />
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" stroke="var(--borderColor-default)" vertical={false} />
                <XAxis
                  dataKey="date"
                  stroke="var(--fgColor-muted)"
                  tick={{ fill: "var(--fgColor-muted)", fontSize: 11 }}
                  tickLine={false}
                  axisLine={false}
                />
                <YAxis
                  yAxisId="left"
                  stroke="var(--fgColor-muted)"
                  tick={{ fill: "var(--fgColor-muted)", fontSize: 11 }}
                  tickLine={false}
                  axisLine={false}
                  tickFormatter={(v: number) => `₹${v}`}
                />
                <YAxis
                  yAxisId="right"
                  orientation="right"
                  stroke="var(--fgColor-muted)"
                  tick={{ fill: "var(--fgColor-muted)", fontSize: 11 }}
                  tickLine={false}
                  axisLine={false}
                  tickFormatter={(v: number) => `₹${v}`}
                />
                <Tooltip
                  contentStyle={{
                    backgroundColor: "var(--bgColor-mild)",
                    border: "1px solid var(--borderColor-default)",
                    borderRadius: "4px",
                    fontSize: "0.875rem",
                    color: "var(--fgColor-default)",
                  }}
                  labelStyle={{ color: "var(--fgColor-default)", fontWeight: 600, marginBottom: 4 }}
                  formatter={(value: any, name: any) => [
                    `₹${Number(value).toFixed(2)}`,
                    name === "cumulative" ? "Cumulative earnings" : "Daily earnings",
                  ]}
                />
                <Area
                  yAxisId="left"
                  type="monotone"
                  dataKey="cumulative"
                  stroke="#3b82f6"
                  strokeWidth={2}
                  fill="url(#earningsGradient)"
                  name="cumulative"
                />
                <Area
                  yAxisId="right"
                  type="monotone"
                  dataKey="daily"
                  stroke="#f97316"
                  strokeWidth={2}
                  fill="none"
                  name="daily"
                />
              </AreaChart>
            </ResponsiveContainer>
          ) : (
            <div
              style={{
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                height: "100%",
                color: "var(--fgColor-muted)",
                fontSize: "0.875rem",
              }}
            >
              No earnings data yet — complete sessions to see your earnings here
            </div>
          )}
        </div>

        {/* Legend */}
        {earningsChartData.length > 0 && (
          <div style={{ display: "flex", gap: "24px", marginTop: "12px" }}>
            <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
              <span style={{ width: "12px", height: "3px", backgroundColor: "#3b82f6", borderRadius: "2px" }} />
              <span style={{ fontFamily: "var(--font-sans)", fontSize: "var(--text-xs)", color: "var(--fgColor-muted)" }}>
                Cumulative earnings
              </span>
            </div>
            <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
              <span style={{ width: "12px", height: "3px", backgroundColor: "#f97316", borderRadius: "2px" }} />
              <span style={{ fontFamily: "var(--font-sans)", fontSize: "var(--text-xs)", color: "var(--fgColor-muted)" }}>
                Daily earnings
              </span>
            </div>
          </div>
        )}
      </div>

      {/* ─── Section 3: Mentoring Activity Bar Chart ─── */}
      <div
        style={{
          backgroundColor: "var(--bgColor-mild)",
          border: "1px solid var(--borderColor-default)",
          borderRadius: "4px",
          padding: "24px",
        }}
      >
        <div style={{ marginBottom: "16px" }}>
          <h3
            style={{
              fontFamily: "var(--font-sans)",
              fontSize: "var(--text-h4)",
              fontWeight: 600,
              color: "var(--fgColor-default)",
              margin: 0,
              marginBottom: "4px",
            }}
          >
            Mentoring Activity
          </h3>
          <p
            style={{
              fontFamily: "var(--font-sans)",
              fontSize: "var(--text-sm)",
              color: "var(--fgColor-muted)",
              margin: 0,
            }}
          >
            Hours spent mentoring by day of week
          </p>
        </div>

        <div style={{ height: "220px" }}>
          {stats?.dailyHours && stats.dailyHours.some((d) => d.hours > 0) ? (
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={stats.dailyHours} margin={{ top: 15, right: 10, left: 0, bottom: 0 }}>
                <CartesianGrid strokeDasharray="3 3" stroke="var(--borderColor-default)" vertical={false} />
                <XAxis
                  dataKey="dayName"
                  stroke="var(--fgColor-muted)"
                  tick={{ fill: "var(--fgColor-muted)", fontSize: 11 }}
                  tickLine={false}
                  axisLine={false}
                />
                <YAxis
                  stroke="var(--fgColor-muted)"
                  tick={{ fill: "var(--fgColor-muted)", fontSize: 11 }}
                  tickLine={false}
                  axisLine={false}
                  tickFormatter={(v: number) => `${v}h`}
                />
                <Tooltip
                  cursor={{ fill: "transparent" }}
                  contentStyle={{
                    backgroundColor: "var(--bgColor-mild)",
                    border: "1px solid var(--borderColor-default)",
                    borderRadius: "4px",
                    fontSize: "0.875rem",
                    color: "var(--fgColor-default)",
                  }}
                  formatter={(value: any) => [`${value} hrs`, "Mentoring hours"]}
                />
                <Bar
                  dataKey="hours"
                  radius={[4, 4, 0, 0]}
                  label={{
                    position: "top",
                    fill: "var(--fgColor-muted)",
                    fontSize: 11,
                    formatter: (v: any) => `${v}h`,
                  }}
                >
                  {stats.dailyHours.map((item, index) => {
                    const today = new Date();
                    const dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
                    const todayName = dayNames[today.getDay()];
                    const isToday = item.dayName === todayName;
                    return (
                      <Cell
                        key={`cell-${index}`}
                        fill={isToday ? "#6366f1" : "#3f3f46"}
                        style={{ cursor: "pointer", transition: "fill 0.2s ease" }}
                      />
                    );
                  })}
                </Bar>
              </BarChart>
            </ResponsiveContainer>
          ) : (
            <div
              style={{
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                height: "100%",
                color: "var(--fgColor-muted)",
                fontSize: "0.875rem",
              }}
            >
              No mentoring activity data yet
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
