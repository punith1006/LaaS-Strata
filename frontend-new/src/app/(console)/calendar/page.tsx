"use client";

import "react-big-calendar/lib/css/react-big-calendar.css";

import { useState, useEffect, useCallback, useMemo } from "react";
import { Calendar, dayjsLocalizer, type EventProps } from "react-big-calendar";
import dayjs from "dayjs";
import { getMe, getMentorCalendar } from "@/lib/api";
import type { CalendarEvent as ApiCalendarEvent } from "@/lib/api";

// ─── Calendar event type with Date objects for react-big-calendar ───
interface DisplayEvent extends Omit<ApiCalendarEvent, "start" | "end"> {
  start: Date;
  end: Date;
}

// ─── Status color map ───
const STATUS_COLORS: Record<string, { bg: string; text: string; label: string }> = {
  scheduled:   { bg: "#4F7FC8", text: "#fff", label: "Scheduled" },
  live:        { bg: "#3BA37A", text: "#fff", label: "Live" },
  completed:   { bg: "#5C5F66", text: "#fff", label: "Completed" },
  cancelled:   { bg: "#C2544C", text: "#fff", label: "Cancelled" },
  rejected:    { bg: "#C2544C", text: "#fff", label: "Rejected" },
  missed:      { bg: "#C88A3D", text: "#fff", label: "Missed" },
  rescheduled: { bg: "#7E6CC4", text: "#fff", label: "Rescheduled" },
  pending:     { bg: "#C2A44A", text: "#1a1a1a", label: "Pending" },
};

// ─── Helpers ───
function formatCurrency(cents: number): string {
  return new Intl.NumberFormat("en-IN", {
    style: "currency",
    currency: "INR",
  }).format(cents / 100);
}

const localizer = dayjsLocalizer(dayjs);

// ─── Custom Event Component ───
function CalendarEventComponent({ event }: EventProps<DisplayEvent>) {
  const colors = STATUS_COLORS[event.status] || STATUS_COLORS.scheduled;
  const isCancelled = event.status === "cancelled" || event.status === "rejected";

  return (
    <div
      style={{
        backgroundColor: colors.bg,
        color: colors.text,
        borderRadius: "3px",
        padding: "1px 6px",
        fontSize: "0.75rem",
        fontFamily: "var(--font-outfit), sans-serif",
        lineHeight: "1.4",
        overflow: "hidden",
        textOverflow: "ellipsis",
        whiteSpace: "nowrap",
        textDecoration: isCancelled ? "line-through" : "none",
        opacity: event.status === "completed" ? 0.7 : 1,
      }}
      title={`${event.title} (${STATUS_COLORS[event.status]?.label || event.status})`}
    >
      {event.title}
    </div>
  );
}

// ─── Formatting ───
const calendarFormats = {
  timeGutterFormat: "HH:mm",
  eventTimeRangeFormat: ({ start, end }: { start: Date; end: Date }) =>
    `${dayjs(start).format("HH:mm")} - ${dayjs(end).format("HH:mm")}`,
  agendaTimeRangeFormat: ({ start, end }: { start: Date; end: Date }) =>
    `${dayjs(start).format("HH:mm")} - ${dayjs(end).format("HH:mm")}`,
  dayFormat: "ddd DD",
  dayHeaderFormat: "dddd, MMMM D",
  monthHeaderFormat: "MMMM YYYY",
  dayRangeHeaderFormat: ({ start, end }: { start: Date; end: Date }) =>
    `${dayjs(start).format("MMM D")} - ${dayjs(end).format("MMM D, YYYY")}`,
};

export default function CalendarPage() {
  const [isMentor, setIsMentor] = useState<boolean | null>(null);
  const [events, setEvents] = useState<ApiCalendarEvent[]>([]);
  const [loading, setLoading] = useState(false);
  const [selectedEvent, setSelectedEvent] = useState<DisplayEvent | null>(null);
  const [currentDate, setCurrentDate] = useState(new Date());
  const [currentView, setCurrentView] = useState<string>("month");

  useEffect(() => {
    getMe().then((me) => {
      setIsMentor(!!me?.roles?.includes("mentor"));
    });
  }, []);

  useEffect(() => {
    if (!isMentor) return;
    setLoading(true);
    getMentorCalendar()
      .then((data) => {
        setEvents(data);
      })
      .catch(() => setEvents([]))
      .finally(() => setLoading(false));
  }, [isMentor]);

  const handleSelectEvent = useCallback((event: DisplayEvent) => {
    setSelectedEvent(event);
  }, []);

  const handleNavigate = useCallback((date: Date) => {
    setCurrentDate(date);
  }, []);

  const handleView = useCallback((view: string) => {
    setCurrentView(view);
  }, []);

  // Map API events to react-big-calendar format (convert strings to Dates)
  const calendarEvents: DisplayEvent[] = useMemo(
    () =>
      events.map((e) => ({
        ...e,
        start: new Date(e.start),
        end: new Date(e.end),
      })),
    [events]
  );

  const eventStyleGetter = useCallback(
    (event: DisplayEvent) => {
      const colors = STATUS_COLORS[event.status] || STATUS_COLORS.scheduled;
      return {
        style: {
          backgroundColor: colors.bg,
          color: colors.text,
          borderRadius: "3px",
          border: "none",
        },
      };
    },
    []
  );

  // Loading state
  if (isMentor === null) return null;

  // Non-mentor (regular user) — Google Calendar embed
  if (!isMentor) {
    const calendarSrc =
      "https://calendar.google.com/calendar/embed?src=punith.vs74064%40gmail.com" +
      "&ctz=Asia%2FKolkata" +
      "&mode=WEEK" +
      "&showCalendars=1" +
      "&showTitle=1" +
      "&showNav=1" +
      "&showPrint=0" +
      "&showTabs=1";

    return (
      <div style={{ width: "100%", height: "100%", padding: "24px" }}>
        <iframe
          src={calendarSrc}
          style={{
            width: "100%",
            height: "100%",
            border: "1px solid var(--borderColor-default)",
            borderRadius: "4px",
          }}
          frameBorder="0"
          scrolling="no"
          title="Google Calendar"
        />
      </div>
    );
  }

  // Mentor — full react-big-calendar view
  return (
    <div style={{ padding: "24px", height: "calc(100vh - 64px)", display: "flex", flexDirection: "column" }}>
      {/* Page Header */}
      <div style={{ maxWidth: "50%", marginBottom: "24px", flexShrink: 0 }}>
        <h1
          style={{
            fontFamily: "var(--font-outfit), sans-serif",
            fontSize: "2rem",
            fontWeight: 400,
            lineHeight: "2.5rem",
            color: "var(--fgColor-default)",
            letterSpacing: "-0.04em",
            margin: 0,
            marginBottom: "8px",
          }}
        >
          Calendar
        </h1>
        <p
          style={{
            fontFamily: "var(--font-outfit), sans-serif",
            fontSize: "0.875rem",
            color: "var(--fgColor-muted)",
            margin: 0,
          }}
        >
          View and manage your mentoring sessions
        </p>
      </div>

      {/* Calendar Container */}
      <div
        style={{
          flex: 1,
          minHeight: 0,
          background: "var(--bgColor-mild)",
          border: "1px solid var(--borderColor-default)",
          borderRadius: "4px",
          overflow: "hidden",
        }}
      >
        {loading ? (
          <div style={{ display: "flex", alignItems: "center", justifyContent: "center", height: "100%" }}>
            <p style={{ color: "var(--fgColor-muted)", fontSize: "0.875rem" }}>Loading calendar...</p>
          </div>
        ) : (
          <Calendar
            localizer={localizer}
            events={calendarEvents}
            startAccessor="start"
            endAccessor="end"
            defaultView="month"
            view={currentView as "month" | "week" | "day"}
            views={["month", "week", "day"]}
            step={60}
            timeslots={1}
            date={currentDate}
            onNavigate={handleNavigate}
            onView={handleView}
            onSelectEvent={handleSelectEvent}
            eventPropGetter={eventStyleGetter}
            components={{
              event: CalendarEventComponent,
            }}
            formats={calendarFormats}
            style={{
              height: "100%",
              fontFamily: "var(--font-outfit), sans-serif",
            }}
            popup
          />
        )}
      </div>

      {/* Event Detail Modal */}
      {selectedEvent && (
        <div
          style={{
            position: "fixed",
            inset: 0,
            background: "rgba(0,0,0,0.6)",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            zIndex: 1000,
          }}
          onClick={() => setSelectedEvent(null)}
        >
          <div
            style={{
              background: "var(--bgColor-default, #0d1117)",
              border: "1px solid var(--borderColor-default)",
              borderRadius: "8px",
              padding: "24px",
              maxWidth: "480px",
              width: "100%",
              boxShadow: "0 8px 32px rgba(0,0,0,0.4)",
            }}
            onClick={(e) => e.stopPropagation()}
          >
            {/* Status badge */}
            <div style={{ marginBottom: "16px" }}>
              {(() => {
                const colors = STATUS_COLORS[selectedEvent.status] || STATUS_COLORS.scheduled;
                return (
                  <span
                    style={{
                      display: "inline-flex",
                      alignItems: "center",
                      padding: "2px 10px",
                      borderRadius: "4px",
                      backgroundColor: colors.bg,
                      color: colors.text,
                      fontSize: "0.75rem",
                      fontWeight: 500,
                      fontFamily: "var(--font-outfit), sans-serif",
                    }}
                  >
                    {selectedEvent.status === "live" && (
                      <span
                        style={{
                          width: 6,
                          height: 6,
                          borderRadius: "50%",
                          backgroundColor: colors.text,
                          marginRight: 6,
                          animation: "rbc-pulse 1.5s infinite",
                        }}
                      />
                    )}
                    {colors.label}
                  </span>
                );
              })()}
            </div>

            {/* Student name */}
            <h3
              style={{
                fontFamily: "var(--font-outfit), sans-serif",
                fontSize: "1.125rem",
                fontWeight: 500,
                color: "var(--fgColor-default)",
                margin: "0 0 4px 0",
              }}
            >
              {selectedEvent.userName}
            </h3>

            {/* Domain & service */}
            <p
              style={{
                fontFamily: "var(--font-outfit), sans-serif",
                fontSize: "0.875rem",
                color: "var(--fgColor-muted)",
                margin: "0 0 16px 0",
              }}
            >
              {selectedEvent.domain} — {selectedEvent.serviceType}
            </p>

            {/* Divider */}
            <div style={{ height: 1, background: "var(--borderColor-default)", margin: "0 0 16px 0" }} />

            {/* Detail rows */}
            <div style={{ display: "flex", flexDirection: "column", gap: "10px" }}>
              <div style={{ display: "flex", justifyContent: "space-between" }}>
                <span style={{ fontSize: "0.8125rem", color: "var(--fgColor-muted)", fontFamily: "var(--font-outfit), sans-serif" }}>
                  Date
                </span>
                <span style={{ fontSize: "0.8125rem", color: "var(--fgColor-default)", fontFamily: "var(--font-outfit), sans-serif" }}>
                  {dayjs(selectedEvent.start).format("dddd, MMMM D, YYYY")}
                </span>
              </div>
              <div style={{ display: "flex", justifyContent: "space-between" }}>
                <span style={{ fontSize: "0.8125rem", color: "var(--fgColor-muted)", fontFamily: "var(--font-outfit), sans-serif" }}>
                  Time
                </span>
                <span style={{ fontSize: "0.8125rem", color: "var(--fgColor-default)", fontFamily: "var(--font-outfit), sans-serif" }}>
                  {dayjs(selectedEvent.start).format("HH:mm")} - {dayjs(selectedEvent.end).format("HH:mm")}
                </span>
              </div>
              <div style={{ display: "flex", justifyContent: "space-between" }}>
                <span style={{ fontSize: "0.8125rem", color: "var(--fgColor-muted)", fontFamily: "var(--font-outfit), sans-serif" }}>
                  Duration
                </span>
                <span style={{ fontSize: "0.8125rem", color: "var(--fgColor-default)", fontFamily: "var(--font-outfit), sans-serif" }}>
                  {selectedEvent.durationMinutes} min
                </span>
              </div>
              {selectedEvent.status === "completed" && selectedEvent.earningsCents > 0 && (
                <div style={{ display: "flex", justifyContent: "space-between" }}>
                  <span style={{ fontSize: "0.8125rem", color: "var(--fgColor-muted)", fontFamily: "var(--font-outfit), sans-serif" }}>
                    Earnings
                  </span>
                  <span style={{ fontSize: "0.8125rem", color: "#28A745", fontFamily: "var(--font-outfit), sans-serif", fontWeight: 500 }}>
                    {formatCurrency(selectedEvent.earningsCents)}
                  </span>
                </div>
              )}
            </div>

            {/* Close button */}
            <div style={{ marginTop: "20px", textAlign: "right" }}>
              <button
                onClick={() => setSelectedEvent(null)}
                style={{
                  background: "var(--bgColor-muted)",
                  border: "1px solid var(--borderColor-default)",
                  borderRadius: "4px",
                  padding: "6px 16px",
                  color: "var(--fgColor-default)",
                  cursor: "pointer",
                  fontSize: "0.8125rem",
                  fontFamily: "var(--font-outfit), sans-serif",
                }}
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
