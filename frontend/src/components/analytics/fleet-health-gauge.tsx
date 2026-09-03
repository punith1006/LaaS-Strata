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

  // Helper to get SVG arc path between two angles
  const arcPath = (startAngle: number, endAngle: number) => {
    const x1 = cx + radius * Math.cos(startAngle);
    const y1 = cy - radius * Math.sin(startAngle);
    const x2 = cx + radius * Math.cos(endAngle);
    const y2 = cy - radius * Math.sin(endAngle);
    const largeArc = Math.abs(endAngle - startAngle) > Math.PI ? 1 : 0;
    return `M ${x1} ${y1} A ${radius} ${radius} 0 ${largeArc} 1 ${x2} ${y2}`;
  };

  // Angle for each key tick
  const toAngle = (pct: number) => Math.PI - (pct / 100) * Math.PI;

  const ticks = [0, 50, 70, 85, 100];

  // Pointer position
  const clamped = Math.max(0, Math.min(100, uptimePct));
  const pointerAngle = toAngle(clamped);
  const pointerX = cx + radius * Math.cos(pointerAngle);
  const pointerY = cy - radius * Math.sin(pointerAngle);

  // Color based on value
  const getColor = (pct: number) => {
    if (pct <= 50) return '#EF4444';
    if (pct <= 70) return '#F97316';
    if (pct <= 85) return '#EAB308';
    return '#22C55E';
  };

  const arcColor = getColor(clamped);

  return (
    <div className="flex flex-col items-center w-full">
      <div className="relative" style={{ width, height }}>
        <svg width={width} height={height} viewBox={`0 0 ${width} ${height}`}>
          {/* Background track */}
          <path
            d={arcPath(Math.PI, 0)}
            fill="none"
            stroke="#27272a"
            strokeWidth={10}
            strokeLinecap="round"
          />

          {/* Colored arc segments */}
          <path d={arcPath(Math.PI, toAngle(50))} fill="none" stroke="#EF4444" strokeWidth={10} strokeLinecap="butt" />
          <path d={arcPath(toAngle(50), toAngle(70))} fill="none" stroke="#F97316" strokeWidth={10} strokeLinecap="butt" />
          <path d={arcPath(toAngle(70), toAngle(85))} fill="none" stroke="#EAB308" strokeWidth={10} strokeLinecap="butt" />
          <path d={arcPath(toAngle(85), 0)} fill="none" stroke="#22C55E" strokeWidth={10} strokeLinecap="butt" />

          {/* Tick marks */}
          {ticks.map((tick) => {
            const angle = toAngle(tick);
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
                <line x1={ix} y1={iy} x2={ox} y2={oy} stroke="#52525b" strokeWidth={1.5} />
                <text
                  x={lx} y={ly}
                  textAnchor="middle"
                  dominantBaseline="middle"
                  fill="#a1a1aa"
                  fontSize="9"
                  fontFamily="sans-serif"
                  fontWeight="500"
                >
                  {tick}
                </text>
              </g>
            );
          })}

          {/* Pointer base circle */}
          <circle cx={cx} cy={cy} r="4" fill="#27272a" stroke="#52525b" strokeWidth="1.5" />

          {/* Pointer needle */}
          <line
            x1={cx} y1={cy}
            x2={pointerX} y2={pointerY}
            stroke={arcColor}
            strokeWidth="2.5"
            strokeLinecap="round"
          />
        </svg>

        {/* Percentage centered below the arc */}
        <div
          className="absolute left-1/2 transform -translate-x-1/2 flex flex-col items-center"
          style={{ bottom: 18 }}
        >
          <span className="text-3xl font-bold" style={{ color: arcColor }}>
            {uptimePct.toFixed(0)}%
          </span>
        </div>
      </div>
    </div>
  );
}
