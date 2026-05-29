"use client";

import { useState, useEffect, useCallback } from "react";
import { getMentorAvailability, createMentorSlot, deleteMentorSlot, getBlockedDates, blockDate, unblockDate } from "@/lib/api";
import type { AvailabilitySlot, BlockedDate } from "@/lib/api";

const DAY_NAMES = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

// Generate time options: 00:00 to 23:00 in 1-hour increments
function generateTimeOptions(): string[] {
  const options: string[] = [];
  for (let h = 0; h < 24; h++) {
    options.push(`${String(h).padStart(2, "0")}:00`);
  }
  return options;
}

const TIME_OPTIONS = generateTimeOptions();

function formatDate(dateStr: string): string {
  const d = new Date(dateStr);
  return d.toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" });
}

function getDayOfWeek(dateStr: string): number {
  return new Date(dateStr + "T00:00:00").getDay();
}

export default function AvailabilityManager() {
  const [slots, setSlots] = useState<AvailabilitySlot[]>([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [toast, setToast] = useState<string | null>(null);

  // Add-mode state for recurring: per day { dayOfWeek: { open: bool, start: string, end: string } }
  const [addMode, setAddMode] = useState<Record<number, { start: string; end: string } | null>>({});

  // Edit-mode state for recurring: per day { slotId, start, end }
  const [editMode, setEditMode] = useState<Record<number, { slotId: string; start: string; end: string } | null>>({});

  // Delete confirmation: which slot ID is awaiting confirmation
  const [confirmDeleteId, setConfirmDeleteId] = useState<string | null>(null);

  // Add-mode state for date-specific
  const [dateForm, setDateForm] = useState({ date: "", start: "09:00", end: "10:00" });
  const [blockReason, setBlockReason] = useState("");

  // Blocked dates
  const [blockedDates, setBlockedDates] = useState<BlockedDate[]>([]);

  // Collapsible sections
  const [weeklyOpen, setWeeklyOpen] = useState(true);
  const [dateOpen, setDateOpen] = useState(true);

  const recurring = slots.filter((s) => s.dayOfWeek !== null && s.isRecurring);
  const dateSpecific = slots.filter((s) => s.specificDate !== null && !s.isRecurring);

  const fetchSlots = useCallback(async () => {
    setLoading(true);
    const data = await getMentorAvailability();
    setSlots(data);
    setLoading(false);
  }, []);

  const fetchBlockedDates = useCallback(async () => {
    const data = await getBlockedDates();
    setBlockedDates(data);
  }, []);

  useEffect(() => {
    fetchSlots();
    fetchBlockedDates();
  }, [fetchSlots, fetchBlockedDates]);

  const showToast = (msg: string) => {
    setToast(msg);
    setTimeout(() => setToast(null), 3000);
  };

  // ── Recurring slot handlers ──
  const openAddForDay = (day: number) => {
    setAddMode((prev) => ({ ...prev, [day]: { start: "09:00", end: "10:00" } }));
  };

  const cancelAddForDay = (day: number) => {
    setAddMode((prev) => {
      const next = { ...prev };
      delete next[day];
      return next;
    });
  };

  const saveRecurringSlot = async (day: number) => {
    const form = addMode[day];
    if (!form) return;
    if (form.start >= form.end) {
      showToast("End time must be after start time");
      return;
    }
    setSaving(true);
    const result = await createMentorSlot({
      dayOfWeek: day,
      startTime: form.start,
      endTime: form.end,
      isRecurring: true,
    });
    setSaving(false);
    if (result) {
      showToast(`Slot added for ${DAY_NAMES[day]}`);
      await fetchSlots();
      cancelAddForDay(day);
    } else {
      showToast("Failed to add slot — may overlap with existing");
    }
  };

  const deleteRecurringSlot = async (slotId: string) => {
    if (confirmDeleteId !== slotId) {
      setConfirmDeleteId(slotId);
      return;
    }
    setConfirmDeleteId(null);
    setSaving(true);
    const ok = await deleteMentorSlot(slotId);
    setSaving(false);
    if (ok) {
      showToast("Slot removed");
      await fetchSlots();
    } else {
      showToast("Failed to remove slot");
    }
  };

  const openEditForSlot = (day: number, slot: AvailabilitySlot) => {
    setEditMode((prev) => ({
      ...prev,
      [day]: { slotId: slot.id, start: slot.startTime, end: slot.endTime },
    }));
  };

  const cancelEditForDay = (day: number) => {
    setEditMode((prev) => {
      const next = { ...prev };
      delete next[day];
      return next;
    });
  };

  const saveEditForSlot = async (day: number) => {
    const form = editMode[day];
    if (!form) return;
    if (form.start >= form.end) {
      showToast("End time must be after start time");
      return;
    }
    setSaving(true);
    // Edit = delete old + create new (no PATCH endpoint yet)
    await deleteMentorSlot(form.slotId);
    const result = await createMentorSlot({
      dayOfWeek: day,
      startTime: form.start,
      endTime: form.end,
      isRecurring: true,
    });
    setSaving(false);
    if (result) {
      showToast(`Slot updated for ${DAY_NAMES[day]}`);
      await fetchSlots();
      cancelEditForDay(day);
    } else {
      showToast("Failed to update slot — may overlap with existing");
    }
  };

  // ── Date-specific handlers ──
  const saveDateSlot = async () => {
    if (!dateForm.date) {
      showToast("Please select a date");
      return;
    }
    if (dateForm.start >= dateForm.end) {
      showToast("End time must be after start time");
      return;
    }
    setSaving(true);
    const result = await createMentorSlot({
      specificDate: dateForm.date,
      startTime: dateForm.start,
      endTime: dateForm.end,
      isRecurring: false,
    });
    setSaving(false);
    if (result) {
      showToast("Date-specific slot added");
      await fetchSlots();
      setDateForm({ date: "", start: "09:00", end: "10:00" });
    } else {
      showToast("Failed to add slot — may overlap with existing");
    }
  };

  const deleteDateSlot = async (slotId: string) => {
    if (confirmDeleteId !== slotId) {
      setConfirmDeleteId(slotId);
      return;
    }
    setConfirmDeleteId(null);
    setSaving(true);
    const ok = await deleteMentorSlot(slotId);
    setSaving(false);
    if (ok) {
      showToast("Slot removed");
      await fetchSlots();
    } else {
      showToast("Failed to remove slot");
    }
  };

  // ── Blocked date (Day Off) handlers ──
  const saveBlockDate = async () => {
    if (!dateForm.date) {
      showToast("Please select a date");
      return;
    }
    // Warn if date already has a custom slot
    const hasCustom = dateSpecific.some((s) => s.specificDate && s.specificDate.startsWith(dateForm.date));
    if (hasCustom) {
      if (!confirm("This date already has a custom time slot. Block it anyway?")) return;
    }
    setSaving(true);
    const result = await blockDate(dateForm.date, blockReason || undefined);
    setSaving(false);
    if (result) {
      showToast("Day Off added");
      await fetchBlockedDates();
      setBlockReason("");
    } else {
      showToast("Failed to block date — may already be blocked");
    }
  };

  const deleteBlockedDate = async (blockId: string) => {
    if (confirmDeleteId !== blockId) {
      setConfirmDeleteId(blockId);
      return;
    }
    setConfirmDeleteId(null);
    setSaving(true);
    const ok = await unblockDate(blockId);
    setSaving(false);
    if (ok) {
      showToast("Day Off removed");
      await fetchBlockedDates();
    } else {
      showToast("Failed to remove Day Off");
    }
  };

  // ── Shared styles ──
  const sectionStyle: React.CSSProperties = {
    background: "var(--bgColor-mild)",
    border: "1px solid rgba(255,255,255,0.06)",
    borderRadius: "4px",
    overflow: "hidden",
  };

  const sectionHeaderStyle: React.CSSProperties = {
    display: "flex",
    alignItems: "center",
    justifyContent: "space-between",
    padding: "12px 20px",
    cursor: "pointer",
    userSelect: "none",
    borderBottom: "1px solid rgba(255,255,255,0.06)",
  };

  const slotPillStyle: React.CSSProperties = {
    display: "inline-flex",
    alignItems: "center",
    gap: "6px",
    background: "#2d333b",
    borderRadius: "4px",
    padding: "2px 8px",
    fontFamily: "var(--font-outfit), sans-serif",
    fontSize: "0.8125rem",
    color: "#d1d5db",
    marginRight: "8px",
    marginBottom: "4px",
  };

  const deleteBtnStyle: React.CSSProperties = {
    background: "none",
    border: "none",
    color: "#6b7280",
    cursor: "pointer",
    fontSize: "0.875rem",
    padding: "0 2px",
    lineHeight: 1,
  };

  if (loading) {
    return (
      <div style={{ padding: "48px", textAlign: "center" }}>
        <p style={{ color: "var(--fgColor-muted)", fontSize: "0.875rem", fontFamily: "var(--font-outfit), sans-serif", margin: 0 }}>
          Loading availability...
        </p>
      </div>
    );
  }

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: "16px" }}>
      {/* Toast */}
      {toast && (
        <div
          style={{
            position: "fixed",
            bottom: "24px",
            right: "24px",
            background: "#C8AA6E",
            color: "#1a1d24",
            padding: "10px 20px",
            borderRadius: "4px",
            fontFamily: "var(--font-outfit), sans-serif",
            fontSize: "0.8125rem",
            zIndex: 1000,
            boxShadow: "0 4px 12px rgba(0,0,0,0.4)",
          }}
        >
          {toast}
        </div>
      )}

      {/* Section 1: Weekly Recurring Schedule */}
      <div style={sectionStyle}>
        <div style={sectionHeaderStyle} onClick={() => setWeeklyOpen(!weeklyOpen)}>
          <div>
            <span
              style={{
                fontFamily: "var(--font-outfit), sans-serif",
                fontSize: "1rem",
                fontWeight: 600,
                color: "#e5e7eb",
              }}
            >
              Weekly Recurring Schedule
            </span>
            <p
              style={{
                fontFamily: "var(--font-outfit), sans-serif",
                fontSize: "0.8125rem",
                color: "#9ca3af",
                margin: "2px 0 0 0",
              }}
            >
              These slots repeat every week indefinitely. Date-specific slots on the same date will override them.
              Students can book during these times unless a date-specific slot takes precedence.
              {"\n"}Days marked as &quot;Day Off&quot; will suppress all recurring slots for that date.
            </p>
          </div>
          <span style={{ color: "#9ca3af", fontSize: "0.75rem" }}>{weeklyOpen ? "\u25B2" : "\u25BC"}</span>
        </div>

        {weeklyOpen && (
          <div style={{ padding: "16px 20px" }}>
            {recurring.length === 0 && Object.keys(addMode).length === 0 ? (
              <p style={{ color: "#6b7280", fontSize: "0.875rem", fontFamily: "var(--font-outfit), sans-serif", textAlign: "center", padding: "24px 0", margin: 0 }}>
                Set your weekly availability to let students book sessions
              </p>
            ) : null}

            {DAY_NAMES.map((name, dayIdx) => {
              const daySlots = recurring.filter((s) => s.dayOfWeek === dayIdx);
              const isAdding = addMode[dayIdx] !== undefined && addMode[dayIdx] !== null;
              const form = addMode[dayIdx];

              return (
                <div
                  key={name}
                  style={{
                    display: "flex",
                    alignItems: "flex-start",
                    padding: "10px 0",
                    borderBottom: dayIdx < 6 ? "1px solid rgba(255,255,255,0.04)" : "none",
                    minHeight: "36px",
                  }}
                >
                  {/* Day label */}
                  <div
                    style={{
                      width: "100px",
                      flexShrink: 0,
                      fontFamily: "var(--font-outfit), sans-serif",
                      fontSize: "0.875rem",
                      fontWeight: 600,
                      color: "#d1d5db",
                      paddingTop: "2px",
                    }}
                  >
                    {name}
                  </div>

                  {/* Slots / empty state / add form */}
                  <div style={{ flex: 1 }}>
                    {daySlots.length > 0 && (
                      <div style={{ marginBottom: isAdding || editMode[dayIdx] ? "8px" : 0 }}>
                        {daySlots.map((slot) => (
                          <span
                            key={slot.id}
                            style={{
                              ...slotPillStyle,
                              cursor: "pointer",
                              background: confirmDeleteId === slot.id ? "#5c2d2d" : "#2d333b",
                            }}
                            onClick={() => {
                              if (confirmDeleteId === slot.id) return;
                              openEditForSlot(dayIdx, slot);
                            }}
                            title="Click to edit"
                          >
                            {slot.startTime}{"\u2013"}{slot.endTime}
                            <button
                              style={{
                                ...deleteBtnStyle,
                                color: confirmDeleteId === slot.id ? "#f87171" : "#6b7280",
                              }}
                              onClick={(e) => {
                                e.stopPropagation();
                                deleteRecurringSlot(slot.id);
                              }}
                              disabled={saving}
                              title={confirmDeleteId === slot.id ? "Click again to confirm delete" : "Remove slot"}
                            >
                              {confirmDeleteId === slot.id ? "?" : "\u00D7"}
                            </button>
                          </span>
                        ))}
                      </div>
                    )}

                    {editMode[dayIdx] ? (
                      <div style={{ display: "flex", alignItems: "center", gap: "8px", flexWrap: "wrap" }}>
                        <select
                          value={editMode[dayIdx]!.start}
                          onChange={(e) => setEditMode((prev) => ({ ...prev, [dayIdx]: { ...prev[dayIdx]!, start: e.target.value } }))}
                          style={{
                            background: "#2d333b",
                            color: "#d1d5db",
                            border: "1px solid rgba(255,255,255,0.12)",
                            borderRadius: "4px",
                            padding: "4px 8px",
                            fontSize: "0.8125rem",
                            fontFamily: "var(--font-outfit), sans-serif",
                          }}
                        >
                          {TIME_OPTIONS.map((t) => (
                            <option key={t} value={t}>{t}</option>
                          ))}
                        </select>
                        <span style={{ color: "#9ca3af", fontSize: "0.8125rem" }}>to</span>
                        <select
                          value={editMode[dayIdx]!.end}
                          onChange={(e) => setEditMode((prev) => ({ ...prev, [dayIdx]: { ...prev[dayIdx]!, end: e.target.value } }))}
                          style={{
                            background: "#2d333b",
                            color: "#d1d5db",
                            border: "1px solid rgba(255,255,255,0.12)",
                            borderRadius: "4px",
                            padding: "4px 8px",
                            fontSize: "0.8125rem",
                            fontFamily: "var(--font-outfit), sans-serif",
                          }}
                        >
                          {TIME_OPTIONS.map((t) => (
                            <option key={t} value={t}>{t}</option>
                          ))}
                        </select>
                        <button
                          onClick={() => saveEditForSlot(dayIdx)}
                          disabled={saving}
                          style={{
                            background: "#C8AA6E",
                            color: "#1a1d24",
                            border: "none",
                            borderRadius: "4px",
                            padding: "4px 12px",
                            fontSize: "0.8125rem",
                            fontWeight: 500,
                            fontFamily: "var(--font-outfit), sans-serif",
                            cursor: "pointer",
                          }}
                        >
                          Update
                        </button>
                        <button
                          onClick={() => cancelEditForDay(dayIdx)}
                          style={{
                            background: "transparent",
                            color: "#9ca3af",
                            border: "1px solid rgba(255,255,255,0.12)",
                            borderRadius: "4px",
                            padding: "4px 12px",
                            fontSize: "0.8125rem",
                            fontFamily: "var(--font-outfit), sans-serif",
                            cursor: "pointer",
                          }}
                        >
                          Cancel
                        </button>
                      </div>
                    ) : isAdding ? (
                      <div style={{ display: "flex", alignItems: "center", gap: "8px", flexWrap: "wrap" }}>
                        <select
                          value={form!.start}
                          onChange={(e) => setAddMode((prev) => ({ ...prev, [dayIdx]: { ...prev[dayIdx]!, start: e.target.value } }))}
                          style={{
                            background: "#2d333b",
                            color: "#d1d5db",
                            border: "1px solid rgba(255,255,255,0.12)",
                            borderRadius: "4px",
                            padding: "4px 8px",
                            fontSize: "0.8125rem",
                            fontFamily: "var(--font-outfit), sans-serif",
                          }}
                        >
                          {TIME_OPTIONS.map((t) => (
                            <option key={t} value={t}>{t}</option>
                          ))}
                        </select>
                        <span style={{ color: "#9ca3af", fontSize: "0.8125rem" }}>to</span>
                        <select
                          value={form!.end}
                          onChange={(e) => setAddMode((prev) => ({ ...prev, [dayIdx]: { ...prev[dayIdx]!, end: e.target.value } }))}
                          style={{
                            background: "#2d333b",
                            color: "#d1d5db",
                            border: "1px solid rgba(255,255,255,0.12)",
                            borderRadius: "4px",
                            padding: "4px 8px",
                            fontSize: "0.8125rem",
                            fontFamily: "var(--font-outfit), sans-serif",
                          }}
                        >
                          {TIME_OPTIONS.map((t) => (
                            <option key={t} value={t}>{t}</option>
                          ))}
                        </select>
                        <button
                          onClick={() => saveRecurringSlot(dayIdx)}
                          disabled={saving}
                          style={{
                            background: "#C8AA6E",
                            color: "#1a1d24",
                            border: "none",
                            borderRadius: "4px",
                            padding: "4px 12px",
                            fontSize: "0.8125rem",
                            fontWeight: 500,
                            fontFamily: "var(--font-outfit), sans-serif",
                            cursor: "pointer",
                          }}
                        >
                          Save
                        </button>
                        <button
                          onClick={() => cancelAddForDay(dayIdx)}
                          style={{
                            background: "transparent",
                            color: "#9ca3af",
                            border: "1px solid rgba(255,255,255,0.12)",
                            borderRadius: "4px",
                            padding: "4px 12px",
                            fontSize: "0.8125rem",
                            fontFamily: "var(--font-outfit), sans-serif",
                            cursor: "pointer",
                          }}
                        >
                          Cancel
                        </button>
                      </div>
                    ) : (
                      <button
                        onClick={() => openAddForDay(dayIdx)}
                        style={{
                          background: "none",
                          border: "none",
                          color: "#C8AA6E",
                          cursor: "pointer",
                          fontSize: "0.8125rem",
                          fontFamily: "var(--font-outfit), sans-serif",
                          padding: 0,
                        }}
                      >
                        {daySlots.length === 0 ? "No slots set \u2014 " : ""}+ Add
                      </button>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* Section 2: Date-Specific Slots */}
      <div style={sectionStyle}>
        <div style={sectionHeaderStyle} onClick={() => setDateOpen(!dateOpen)}>
          <div>
            <span
              style={{
                fontFamily: "var(--font-outfit), sans-serif",
                fontSize: "1rem",
                fontWeight: 600,
                color: "#e5e7eb",
              }}
            >
              Date Exceptions
            </span>
            <p
              style={{
                fontFamily: "var(--font-outfit), sans-serif",
                fontSize: "0.8125rem",
                color: "#9ca3af",
                margin: "2px 0 0 0",
              }}
            >
              Override your weekly schedule for specific dates {"\u2014"} custom hours, extra availability, or days off.
              These take precedence over your weekly schedule for the dates listed.
            </p>
          </div>
          <span style={{ color: "#9ca3af", fontSize: "0.75rem" }}>{dateOpen ? "\u25B2" : "\u25BC"}</span>
        </div>

        {dateOpen && (
          <div style={{ padding: "16px 20px" }}>
            {/* Add form */}
            <div style={{ display: "flex", alignItems: "center", gap: "8px", flexWrap: "wrap", marginBottom: "8px" }}>
              <input
                type="date"
                value={dateForm.date}
                onChange={(e) => setDateForm((prev) => ({ ...prev, date: e.target.value }))}
                style={{
                  background: "#2d333b",
                  color: "#d1d5db",
                  border: "1px solid rgba(255,255,255,0.12)",
                  borderRadius: "4px",
                  padding: "4px 8px",
                  fontSize: "0.8125rem",
                  fontFamily: "var(--font-outfit), sans-serif",
                }}
              />
              <select
                value={dateForm.start}
                onChange={(e) => setDateForm((prev) => ({ ...prev, start: e.target.value }))}
                style={{
                  background: "#2d333b",
                  color: "#d1d5db",
                  border: "1px solid rgba(255,255,255,0.12)",
                  borderRadius: "4px",
                  padding: "4px 8px",
                  fontSize: "0.8125rem",
                  fontFamily: "var(--font-outfit), sans-serif",
                }}
              >
                {TIME_OPTIONS.map((t) => (
                  <option key={t} value={t}>{t}</option>
                ))}
              </select>
              <span style={{ color: "#9ca3af", fontSize: "0.8125rem" }}>to</span>
              <select
                value={dateForm.end}
                onChange={(e) => setDateForm((prev) => ({ ...prev, end: e.target.value }))}
                style={{
                  background: "#2d333b",
                  color: "#d1d5db",
                  border: "1px solid rgba(255,255,255,0.12)",
                  borderRadius: "4px",
                  padding: "4px 8px",
                  fontSize: "0.8125rem",
                  fontFamily: "var(--font-outfit), sans-serif",
                }}
              >
                {TIME_OPTIONS.map((t) => (
                  <option key={t} value={t}>{t}</option>
                ))}
              </select>
              <button
                onClick={saveDateSlot}
                disabled={saving}
                style={{
                  background: "#C8AA6E",
                  color: "#1a1d24",
                  border: "none",
                  borderRadius: "4px",
                  padding: "4px 14px",
                  fontSize: "0.8125rem",
                  fontWeight: 500,
                  fontFamily: "var(--font-outfit), sans-serif",
                  cursor: "pointer",
                }}
              >
                Add Custom Slot
              </button>
              <button
                onClick={saveBlockDate}
                disabled={saving}
                style={{
                  background: "rgba(194, 84, 76, 0.2)",
                  color: "#f87171",
                  border: "1px solid rgba(194, 84, 76, 0.3)",
                  borderRadius: "4px",
                  padding: "4px 14px",
                  fontSize: "0.8125rem",
                  fontWeight: 500,
                  fontFamily: "var(--font-outfit), sans-serif",
                  cursor: "pointer",
                }}
              >
                Block Day
              </button>
            </div>
            {/* Optional reason for Block Day */}
            <div style={{ marginBottom: "16px" }}>
              <input
                type="text"
                value={blockReason}
                onChange={(e) => setBlockReason(e.target.value)}
                placeholder="Reason (optional, e.g. Holiday, Travel)"
                style={{
                  background: "#2d333b",
                  color: "#d1d5db",
                  border: "1px solid rgba(255,255,255,0.12)",
                  borderRadius: "4px",
                  padding: "4px 8px",
                  fontSize: "0.8125rem",
                  fontFamily: "var(--font-outfit), sans-serif",
                  width: "300px",
                  maxWidth: "100%",
                }}
              />
            </div>

            {/* Custom Time Slots */}
            <div style={{ marginBottom: "16px" }}>
              <span style={{ color: "#9ca3af", fontSize: "0.75rem", fontFamily: "var(--font-outfit), sans-serif", fontWeight: 500, textTransform: "uppercase", letterSpacing: "0.04em" }}>
                Custom Time Slots
              </span>
              {dateSpecific.length === 0 ? (
                <p style={{ color: "#6b7280", fontSize: "0.875rem", fontFamily: "var(--font-outfit), sans-serif", textAlign: "center", padding: "16px 0", margin: 0 }}>
                  No custom time slots yet
                </p>
              ) : (
                <div style={{ display: "flex", flexDirection: "column", gap: "6px", marginTop: "8px" }}>
                  {dateSpecific.map((slot) => (
                    <div
                      key={slot.id}
                      style={{
                        display: "flex",
                        alignItems: "center",
                        justifyContent: "space-between",
                        padding: "6px 12px",
                        background: "#2d333b",
                        borderRadius: "4px",
                      }}
                    >
                      <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
                        <span
                          style={{
                            background: "#3a3d47",
                            color: "#d1d5db",
                            borderRadius: "3px",
                            padding: "2px 8px",
                            fontSize: "0.75rem",
                            fontFamily: "var(--font-outfit), sans-serif",
                            fontWeight: 500,
                          }}
                        >
                          {slot.specificDate ? formatDate(slot.specificDate) : "Unknown"}
                        </span>
                        <span style={{ color: "#d1d5db", fontSize: "0.8125rem", fontFamily: "var(--font-outfit), sans-serif" }}>
                          {slot.startTime}{"\u2013"}{slot.endTime}
                        </span>
                        {slot.specificDate && recurring.some((r) => r.dayOfWeek === getDayOfWeek(slot.specificDate!)) && (
                          <span
                            style={{
                              background: "rgba(200,170,110,0.18)",
                              color: "#C8AA6E",
                              borderRadius: "3px",
                              padding: "1px 7px",
                              fontSize: "0.6875rem",
                              fontFamily: "var(--font-outfit), sans-serif",
                              fontWeight: 500,
                            }}
                          >
                            Overrides recurring
                          </span>
                        )}
                      </div>
                      <button
                        onClick={() => deleteDateSlot(slot.id)}
                        disabled={saving}
                        title={confirmDeleteId === slot.id ? "Click again to confirm delete" : "Remove slot"}
                        style={{
                          background: "none",
                          border: "none",
                          color: confirmDeleteId === slot.id ? "#f87171" : "#6b7280",
                          cursor: "pointer",
                          fontSize: "0.875rem",
                          padding: "2px 6px",
                          lineHeight: 1,
                        }}
                      >
                        {confirmDeleteId === slot.id ? "?" : "\u00D7"}
                      </button>
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* Days Off */}
            <div>
              <span style={{ color: "#9ca3af", fontSize: "0.75rem", fontFamily: "var(--font-outfit), sans-serif", fontWeight: 500, textTransform: "uppercase", letterSpacing: "0.04em" }}>
                Days Off
              </span>
              {blockedDates.length === 0 ? (
                <p style={{ color: "#6b7280", fontSize: "0.875rem", fontFamily: "var(--font-outfit), sans-serif", textAlign: "center", padding: "16px 0", margin: 0 }}>
                  No days off set
                </p>
              ) : (
                <div style={{ display: "flex", flexDirection: "column", gap: "6px", marginTop: "8px" }}>
                  {blockedDates.map((bd) => (
                    <div
                      key={bd.id}
                      style={{
                        display: "flex",
                        alignItems: "center",
                        justifyContent: "space-between",
                        padding: "6px 12px",
                        background: "rgba(194, 84, 76, 0.12)",
                        borderRadius: "4px",
                        border: "1px solid rgba(194, 84, 76, 0.2)",
                      }}
                    >
                      <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
                        <span
                          style={{
                            background: "rgba(194, 84, 76, 0.25)",
                            color: "#f87171",
                            borderRadius: "3px",
                            padding: "2px 8px",
                            fontSize: "0.75rem",
                            fontFamily: "var(--font-outfit), sans-serif",
                            fontWeight: 500,
                          }}
                        >
                          {formatDate(bd.blockedDate + "T00:00:00")}
                        </span>
                        <span style={{ color: "#d1d5db", fontSize: "0.8125rem", fontFamily: "var(--font-outfit), sans-serif" }}>
                          {bd.reason || "Day Off"}
                        </span>
                        <span
                          style={{
                            background: "rgba(194, 84, 76, 0.18)",
                            color: "#f87171",
                            borderRadius: "3px",
                            padding: "1px 7px",
                            fontSize: "0.6875rem",
                            fontFamily: "var(--font-outfit), sans-serif",
                            fontWeight: 500,
                          }}
                        >
                          Blocked
                        </span>
                      </div>
                      <button
                        onClick={() => deleteBlockedDate(bd.id)}
                        disabled={saving}
                        title={confirmDeleteId === bd.id ? "Click again to confirm delete" : "Remove Day Off"}
                        style={{
                          background: "none",
                          border: "none",
                          color: confirmDeleteId === bd.id ? "#f87171" : "#6b7280",
                          cursor: "pointer",
                          fontSize: "0.875rem",
                          padding: "2px 6px",
                          lineHeight: 1,
                        }}
                      >
                        {confirmDeleteId === bd.id ? "?" : "\u00D7"}
                      </button>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
