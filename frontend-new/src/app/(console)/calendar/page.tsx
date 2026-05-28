"use client";

import { useState, useEffect } from "react";
import { getMe } from "@/lib/api";

export default function CalendarPage() {
  const [isMentor, setIsMentor] = useState<boolean | null>(null);

  useEffect(() => {
    getMe().then((me) => {
      setIsMentor(!!me?.roles?.includes("mentor"));
    });
  }, []);

  // Mentor role — show blank calendar for now
  if (isMentor) {
    return (
      <div style={{ padding: "24px" }}>
        <div style={{ maxWidth: "50%" }}>
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
              fontFamily: "var(--font-sans), sans-serif",
              fontSize: "0.875rem",
              color: "var(--fgColor-muted)",
              margin: 0,
            }}
          >
            Mentor calendar view will appear here.
          </p>
        </div>
      </div>
    );
  }

  // Non-mentor (regular user) — Google Calendar embed
  if (isMentor === false) {
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

  // Loading state
  return null;
}
