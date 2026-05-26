"use client";

export default function CalendarPage() {
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
