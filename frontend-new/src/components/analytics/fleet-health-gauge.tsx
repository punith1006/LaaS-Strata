"use client";

interface FleetHealthGaugeProps {
  uptimePct: number;
  healthyNodes: number;
  totalNodes: number;
  alertNodes?: string[];
  lastHeartbeatAt?: string | null;
}

export function formatLastHeartbeat(isoString: string | null | undefined): string {
  if (!isoString) return "No heartbeat yet";
  const date = new Date(isoString);
  const istMs = date.getTime() + 5.5 * 60 * 60 * 1000;
  const ist = new Date(istMs);
  const hours = ist.getUTCHours();
  const minutes = ist.getUTCMinutes().toString().padStart(2, "0");
  const ampm = hours >= 12 ? "PM" : "AM";
  const fmtHours = hours % 12 || 12;

  const today = new Date();
  const todayIstMs = today.getTime() + 5.5 * 60 * 60 * 1000;
  const todayIst = new Date(todayIstMs);
  const isToday =
    ist.getUTCDate() === todayIst.getUTCDate() &&
    ist.getUTCMonth() === todayIst.getUTCMonth() &&
    ist.getUTCFullYear() === todayIst.getUTCFullYear();

  const dayLabel = isToday ? "Today" : "Yesterday";
  return `Last updated: ${dayLabel} at ${fmtHours}:${minutes} ${ampm}`;
}

export function FleetHealthGauge({
  uptimePct,
  healthyNodes,
  totalNodes,
  alertNodes = [],
  lastHeartbeatAt,
}: FleetHealthGaugeProps) {
  const width = 220;
  const height = 120;
  const cx = width / 2;
  const cy = height - 8;
  const radius = 90;
  const strokeWidth = 10;

  const isHealthy = alertNodes.length === 0;

  // Semicircle arc from left (180deg) to right (0deg)
  const arcPath = `M ${cx - radius} ${cy} A ${radius} ${radius} 0 0 1 ${cx + radius} ${cy}`;

  const ticks = [0, 25, 50, 75, 100];

  return (
    <div className="flex flex-col items-center w-full">
      {/* Gauge SVG container with centered percentage overlay */}
      <div className="relative" style={{ width, height }}>
        <svg width={width} height={height} viewBox={`0 0 ${width} ${height}`}>
          <defs>
            <linearGradient id="gaugeGradient" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" stopColor="#ef4444" />
              <stop offset="25%" stopColor="#f97316" />
              <stop offset="50%" stopColor="#eab308" />
              <stop offset="75%" stopColor="#84cc16" />
              <stop offset="100%" stopColor="#22c55e" />
            </linearGradient>
          </defs>

          {/* Background track */}
          <path
            d={arcPath}
            fill="none"
            stroke="#27272a"
            strokeWidth={strokeWidth}
            strokeLinecap="round"
          />

          {/* Colored gradient arc */}
          <path
            d={arcPath}
            fill="none"
            stroke="url(#gaugeGradient)"
            strokeWidth={strokeWidth}
            strokeLinecap="round"
          />

          {/* Tick marks and labels */}
          {ticks.map((tick) => {
            const angle = Math.PI - (tick / 100) * Math.PI;
            const innerR = radius - 16;
            const labelR = radius + 13;
            const ix = cx + innerR * Math.cos(angle);
            const iy = cy - innerR * Math.sin(angle);
            const ox = cx + (radius + 2) * Math.cos(angle);
            const oy = cy - (radius + 2) * Math.sin(angle);
            const lx = cx + labelR * Math.cos(angle);
            const ly = cy - labelR * Math.sin(angle);

            return (
              <g key={tick}>
                <line
                  x1={ix}
                  y1={iy}
                  x2={ox}
                  y2={oy}
                  stroke="#52525b"
                  strokeWidth={1.5}
                />
                <text
                  x={lx}
                  y={ly}
                  textAnchor="middle"
                  dominantBaseline="middle"
                  fill="#a1a1aa"
                  fontSize="9"
                  fontFamily="var(--font-sans)"
                  fontWeight="500"
                >
                  {tick}
                </text>
              </g>
            );
          })}
        </svg>

        {/* Percentage centered inside the arc */}
        <div
          className="absolute left-1/2 transform -translate-x-1/2 flex flex-col items-center"
          style={{ bottom: 18 }}
        >
          <span className="text-3xl font-bold text-white leading-none">
            {uptimePct.toFixed(0)}%
          </span>
        </div>
      </div>
    </div>
  );
}
