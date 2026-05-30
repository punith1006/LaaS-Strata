"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import { useRouter } from "next/navigation";
import dayjs from "dayjs";
import type { MentorProfileDetail } from "@/lib/api";
import {
  getAvailableSlots,
  getAvailableDates,
  uploadMentorAttachment,
  bookMentorSession,
} from "@/lib/api";
import type { TimeSlot } from "@/lib/api";

/* ── Constants ─────────────────────────────────────────── */

const SESSION_TYPES = [
  {
    id: "consultation",
    label: "Consultation",
    description:
      "Career advice, professional guidance, and industry insights from an experienced mentor.",
  },
  {
    id: "guidance",
    label: "Guidance",
    description:
      "Project guidance, technical mentorship, and hands-on skill development.",
  },
  {
    id: "doubt_clarification",
    label: "Doubt Clarification",
    description:
      "Clear specific doubts, concepts, and problem-solving with expert help.",
  },
  {
    id: "hands_on",
    label: "Hands-On",
    description: "Coming Soon",
    disabled: true,
  },
];

const DAYS = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];

/* ── Helpers ───────────────────────────────────────────── */

function getWordCount(text: string): number {
  return text
    .trim()
    .split(/\s+/)
    .filter(Boolean).length;
}

function formatTime12(time: string): string {
  const [h, m] = time.split(":").map(Number);
  const period = h >= 12 ? "PM" : "AM";
  const hour = h % 12 || 12;
  return `${hour}:${String(m).padStart(2, "0")} ${period}`;
}

/* ── Component ─────────────────────────────────────────── */

export default function BookSessionModal({
  mentor,
  onClose,
}: {
  mentor: MentorProfileDetail;
  onClose: () => void;
}) {
  const [step, setStep] = useState<1 | 2 | 3>(1);

  // Step 1 state
  const [selectedCategory, setSelectedCategory] = useState("");
  const [selectedDate, setSelectedDate] = useState<string | null>(null);
  const [viewMonth, setViewMonth] = useState(dayjs().add(1, "day").startOf("month"));
  const [availableDates, setAvailableDates] = useState<string[] | null>(null);
  const [datesLoading, setDatesLoading] = useState(false);

  // Step 2 state
  const [slots, setSlots] = useState<TimeSlot[]>([]);
  const [selectedSlot, setSelectedSlot] = useState<TimeSlot | null>(null);
  const [slotsLoading, setSlotsLoading] = useState(false);

  // Step 3 state
  const [subject, setSubject] = useState("");
  const [description, setDescription] = useState("");
  const [file, setFile] = useState<File | null>(null);
  const [uploading, setUploading] = useState(false);
  const [booking, setBooking] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState(false);
  const [showConfirmation, setShowConfirmation] = useState(false);
  const [fading, setFading] = useState(false);

  const fileInputRef = useRef<HTMLInputElement>(null);
  const router = useRouter();

  const priceValue = (mentor.pricePerHourCents / 100).toLocaleString("en-IN");
  const currencySymbol = mentor.currency === "INR" ? "\u20B9" : "$";
  const advanceCents = Math.round(mentor.pricePerHourCents * 0.1);
  const advanceValue = (advanceCents / 100).toLocaleString("en-IN");
  const balanceCents = mentor.pricePerHourCents - advanceCents;
  const balanceValue = (balanceCents / 100).toLocaleString("en-IN");

  const today = dayjs().startOf("day");

  // Fetch slots when date changes
  useEffect(() => {
    if (!selectedDate) return;
    setSlotsLoading(true);
    setSelectedSlot(null);
    getAvailableSlots(mentor.id, selectedDate)
      .then((data) => setSlots(data.slots))
      .catch(() => setSlots([]))
      .finally(() => setSlotsLoading(false));
  }, [selectedDate, mentor.id]);

  // Close on Escape
  useEffect(() => {
    const handler = (e: KeyboardEvent) => {
      if (e.key === "Escape") onClose();
    };
    window.addEventListener("keydown", handler);
    return () => window.removeEventListener("keydown", handler);
  }, [onClose]);

  // Fade-out effect before modal closes on success
  useEffect(() => {
    if (success) {
      const t = setTimeout(() => setFading(true), 1700);
      return () => clearTimeout(t);
    } else {
      setFading(false);
    }
  }, [success]);

  // Fetch available dates when month changes
  useEffect(() => {
    setDatesLoading(true);
    setAvailableDates(null);
    const month = viewMonth.format("YYYY-MM");
    getAvailableDates(mentor.id, month)
      .then((data) => setAvailableDates(data.dates))
      .catch(() => setAvailableDates([]))
      .finally(() => setDatesLoading(false));
  }, [viewMonth, mentor.id]);

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const f = e.target.files?.[0];
    if (!f) return;
    const allowed = [
      "application/pdf",
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      "text/plain",
      "image/png",
      "image/jpeg",
      "image/gif",
      "image/webp",
    ];
    if (!allowed.includes(f.type)) {
      setError("Unsupported file type. Allowed: PDF, DOCX, TXT, PNG, JPG, GIF, WEBP");
      return;
    }
    if (f.size > 2 * 1024 * 1024) {
      setError("File must be under 2MB");
      return;
    }
    setError("");
    setFile(f);
  };

  const handleConfirm = () => {
    if (!selectedDate || !selectedSlot || !selectedCategory) return;
    setShowConfirmation(true);
  };

  const handleFinalConfirm = async () => {
    if (!selectedDate || !selectedSlot || !selectedCategory) return;

    setBooking(true);
    setError("");

    try {
      let attachmentInfo: {
        attachmentFileName?: string;
        attachmentFilePath?: string;
        attachmentMimeType?: string;
        attachmentSizeBytes?: number;
      } = {};

      if (file) {
        setUploading(true);
        const uploaded = await uploadMentorAttachment(file);
        attachmentInfo = {
          attachmentFileName: uploaded.fileName,
          attachmentFilePath: uploaded.filePath,
          attachmentMimeType: uploaded.mimeType,
          attachmentSizeBytes: uploaded.sizeBytes,
        };
        setUploading(false);
      }

      await bookMentorSession({
        mentorProfileId: mentor.id,
        category: selectedCategory,
        scheduledDate: selectedDate,
        startTime: selectedSlot.startTime,
        durationMinutes: 60,
        subject,
        description,
        ...attachmentInfo,
      });

      setSuccess(true);
      setTimeout(() => {
        onClose();
        setTimeout(() => {
          router.push("/mentor?tab=upcoming");
        }, 150);
      }, 2000);
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : "Booking failed. Please try again.";
      setError(message);
    } finally {
      setBooking(false);
      setUploading(false);
    }
  };

  // ── Calendar helpers ──

  const calendarStart = viewMonth.startOf("week");
  const calendarEnd = viewMonth.endOf("month").endOf("week");
  const calendarDays: dayjs.Dayjs[] = [];
  let d = calendarStart;
  while (d.isBefore(calendarEnd) || d.isSame(calendarEnd, "day")) {
    calendarDays.push(d);
    d = d.add(1, "day");
  }

  const isDateDisabled = (date: dayjs.Dayjs): boolean => {
    // Always disable past dates
    if (date.isBefore(today, "day")) return true;
    // If availability data is still loading, don't disable
    if (availableDates === null) return false;
    // Disable dates not in the available set
    const dateStr = date.format("YYYY-MM-DD");
    return !availableDates.includes(dateStr);
  };

  // ── Render ──

  return (
    <div
      style={{
        position: "fixed",
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        zIndex: 1000,
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        backgroundColor: "rgba(0, 0, 0, 0.5)",
        backdropFilter: "blur(8px)",
      }}
      onClick={(e) => {
        if (e.target === e.currentTarget) onClose();
      }}
    >
      <div
        style={{
          backgroundColor: "var(--bgColor-default)",
          border: "1px solid var(--borderColor-default)",
          borderRadius: "8px",
          width: "90vw",
          maxWidth: "820px",
          maxHeight: "85vh",
          overflow: "auto",
          display: "flex",
          flexDirection: "column",
        }}
      >
        {/* Header */}
        <div
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            padding: "16px 20px",
            borderBottom: "1px solid var(--borderColor-default)",
          }}
        >
          <div>
            <div
              style={{
                fontFamily: "var(--font-sans)",
                fontSize: "0.75rem",
                color: "var(--fgColor-muted)",
                textTransform: "uppercase",
                letterSpacing: "0.05em",
                marginBottom: "2px",
              }}
            >
              Step {step} of 3
            </div>
            <div
              style={{
                fontFamily: "var(--font-sans)",
                fontSize: "1.125rem",
                fontWeight: 600,
                color: "var(--fgColor-default)",
              }}
            >
              {step === 1 && "Schedule a Session"}
              {step === 2 && "Select a Time Slot"}
              {step === 3 && "Confirm Your Session"}
            </div>
          </div>
          <button
            onClick={onClose}
            style={{
              background: "none",
              border: "none",
              cursor: "pointer",
              color: "var(--fgColor-muted)",
              padding: "4px",
            }}
          >
            <svg
              width="20"
              height="20"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
            >
              <line x1="18" y1="6" x2="6" y2="18" />
              <line x1="6" y1="6" x2="18" y2="18" />
            </svg>
          </button>
        </div>

        {/* Body */}
        <div style={{ display: "flex", flex: 1, overflow: "hidden" }}>
          {/* Left Panel */}
          <div
            style={{
              width: "280px",
              flexShrink: 0,
              borderRight: "1px solid var(--borderColor-default)",
              padding: "20px",
              backgroundColor: "var(--bgColor-mild)",
            }}
          >
            {/* Mentor info */}
            <div
              style={{
                fontFamily: "var(--font-sans)",
                fontSize: "0.875rem",
                fontWeight: 600,
                color: "var(--fgColor-default)",
                marginBottom: "2px",
              }}
            >
              {mentor.name}
            </div>
            {mentor.professionalRole && (
              <div
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "0.8125rem",
                  color: "var(--fgColor-muted)",
                  marginBottom: "12px",
                }}
              >
                {mentor.professionalRole}
                {mentor.company && (
                  <span style={{ color: "#C8AA6E" }}> at {mentor.company}</span>
                )}
              </div>
            )}

            <div
              style={{
                borderTop: "1px solid var(--borderColor-default)",
                paddingTop: "12px",
                marginBottom: "12px",
              }}
            >
              <div
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "0.6875rem",
                  color: "var(--fgColor-muted)",
                  textTransform: "uppercase",
                  letterSpacing: "0.05em",
                  marginBottom: "4px",
                }}
              >
                Price per hour
              </div>
              <div
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "1.25rem",
                  fontWeight: 700,
                  color: "var(--fgColor-default)",
                }}
              >
                {currencySymbol}
                {priceValue}
              </div>
            </div>

            {/* Selected info */}
            {selectedCategory && (
              <div style={{ marginBottom: "8px" }}>
                <div
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.6875rem",
                    color: "var(--fgColor-muted)",
                    textTransform: "uppercase",
                    letterSpacing: "0.05em",
                    marginBottom: "4px",
                  }}
                >
                  Session Type
                </div>
                <div
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.8125rem",
                    color: "var(--fgColor-default)",
                    fontWeight: 500,
                  }}
                >
                  {SESSION_TYPES.find((t) => t.id === selectedCategory)?.label}
                </div>
              </div>
            )}

            {selectedDate && (
              <div style={{ marginBottom: "8px" }}>
                <div
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.6875rem",
                    color: "var(--fgColor-muted)",
                    textTransform: "uppercase",
                    letterSpacing: "0.05em",
                    marginBottom: "4px",
                  }}
                >
                  Date
                </div>
                <div
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.8125rem",
                    color: "var(--fgColor-default)",
                    fontWeight: 500,
                  }}
                >
                  {dayjs(selectedDate).format("ddd, DD MMM YYYY")}
                </div>
              </div>
            )}

            {selectedSlot && (
              <div style={{ marginBottom: "8px" }}>
                <div
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.6875rem",
                    color: "var(--fgColor-muted)",
                    textTransform: "uppercase",
                    letterSpacing: "0.05em",
                    marginBottom: "4px",
                  }}
                >
                  Time
                </div>
                <div
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.8125rem",
                    color: "var(--fgColor-default)",
                    fontWeight: 500,
                  }}
                >
                  {formatTime12(selectedSlot.startTime)} –{" "}
                  {formatTime12(selectedSlot.endTime)}
                </div>
              </div>
            )}

            {step === 3 && (
              <div
                style={{
                  borderTop: "1px solid var(--borderColor-default)",
                  paddingTop: "12px",
                  marginTop: "4px",
                }}
              >
                <div
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.6875rem",
                    color: "var(--fgColor-muted)",
                    textTransform: "uppercase",
                    letterSpacing: "0.05em",
                    marginBottom: "4px",
                  }}
                >
                  Advance (10%)
                </div>
                <div
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.9375rem",
                    fontWeight: 600,
                    color: "#C8AA6E",
                  }}
                >
                  {currencySymbol}
                  {advanceValue}
                </div>
                <div
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.75rem",
                    color: "var(--fgColor-muted)",
                    marginTop: "2px",
                  }}
                >
                  Deducted from your wallet to confirm the slot
                </div>
              </div>
            )}
          </div>

          {/* Right Panel */}
          <div style={{ flex: 1, padding: "20px", overflow: "auto" }}>
            {/* ── Step 1: Session Type + Date ── */}
            {step === 1 && (
              <div>
                <div
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.875rem",
                    fontWeight: 600,
                    color: "var(--fgColor-default)",
                    marginBottom: "12px",
                  }}
                >
                  Select session type
                </div>
                <div
                  style={{
                    display: "flex",
                    flexDirection: "column",
                    gap: "8px",
                    marginBottom: "20px",
                  }}
                >
                  {SESSION_TYPES.map((type) => {
                    const isSelected = selectedCategory === type.id;
                    const isDisabled = type.disabled;
                    return (
                      <button
                        key={type.id}
                        disabled={isDisabled}
                        onClick={() => !isDisabled && setSelectedCategory(type.id)}
                        style={{
                          display: "flex",
                          alignItems: "flex-start",
                          gap: "10px",
                          padding: "12px",
                          backgroundColor: isSelected
                            ? "rgba(200, 170, 110, 0.08)"
                            : "var(--bgColor-mild)",
                          border: `1px solid ${
                            isSelected
                              ? "#C8AA6E"
                              : "var(--borderColor-default)"
                          }`,
                          borderRadius: "6px",
                          cursor: isDisabled ? "not-allowed" : "pointer",
                          opacity: isDisabled ? 0.5 : 1,
                          textAlign: "left",
                          transition: "all 0.15s ease",
                          fontFamily: "var(--font-sans)",
                        }}
                      >
                        <div
                          style={{
                            width: "18px",
                            height: "18px",
                            borderRadius: "50%",
                            border: `2px solid ${
                              isSelected ? "#C8AA6E" : "var(--borderColor-default)"
                            }`,
                            backgroundColor: isSelected ? "#C8AA6E" : "transparent",
                            display: "flex",
                            alignItems: "center",
                            justifyContent: "center",
                            flexShrink: 0,
                            marginTop: "1px",
                          }}
                        >
                          {isSelected && (
                            <div
                              style={{
                                width: "6px",
                                height: "6px",
                                borderRadius: "50%",
                                backgroundColor: "#0B0B0B",
                              }}
                            />
                          )}
                        </div>
                        <div>
                          <div
                            style={{
                              fontSize: "0.875rem",
                              fontWeight: 500,
                              color: "var(--fgColor-default)",
                            }}
                          >
                            {type.label}
                          </div>
                          <div
                            style={{
                              fontSize: "0.8125rem",
                              color: "var(--fgColor-muted)",
                              marginTop: "2px",
                            }}
                          >
                            {type.description}
                          </div>
                        </div>
                      </button>
                    );
                  })}
                </div>

                {/* Calendar */}
                <div
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.875rem",
                    fontWeight: 600,
                    color: "var(--fgColor-default)",
                    marginBottom: "12px",
                  }}
                >
                  Select date
                </div>

                <div
                  style={{
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "center",
                    marginBottom: "8px",
                  }}
                >
                  <button
                    onClick={() =>
                      setViewMonth((m) => m.subtract(1, "month"))
                    }
                    style={{
                      background: "none",
                      border: "none",
                      cursor: "pointer",
                      color: "var(--fgColor-muted)",
                      padding: "4px",
                    }}
                  >
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 18 9 12 15 6" /></svg>
                  </button>
                  <div
                    style={{
                      fontFamily: "var(--font-sans)",
                      fontSize: "0.875rem",
                      fontWeight: 500,
                      color: "var(--fgColor-default)",
                    }}
                  >
                    {viewMonth.format("MMMM YYYY")}
                  </div>
                  <button
                    onClick={() => setViewMonth((m) => m.add(1, "month"))}
                    style={{
                      background: "none",
                      border: "none",
                      cursor: "pointer",
                      color: "var(--fgColor-muted)",
                      padding: "4px",
                    }}
                  >
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polyline points="9 18 15 12 9 6" /></svg>
                  </button>
                </div>

                <div
                  style={{
                    display: "grid",
                    gridTemplateColumns: "repeat(7, 1fr)",
                    gap: "2px",
                  }}
                >
                  {DAYS.map((day) => (
                    <div
                      key={day}
                      style={{
                        textAlign: "center",
                        fontFamily: "var(--font-sans)",
                        fontSize: "0.6875rem",
                        color: "var(--fgColor-muted)",
                        padding: "4px 0",
                        fontWeight: 500,
                      }}
                    >
                      {day}
                    </div>
                  ))}
                  {calendarDays.map((date, i) => {
                    const isCurrentMonth = date.month() === viewMonth.month();
                    const disabled = isDateDisabled(date);
                    const isSelected =
                      selectedDate === date.format("YYYY-MM-DD");
                    return (
                      <button
                        key={i}
                        disabled={disabled || !isCurrentMonth}
                        onClick={() =>
                          setSelectedDate(date.format("YYYY-MM-DD"))
                        }
                        style={{
                          width: "100%",
                          aspectRatio: "1",
                          display: "flex",
                          alignItems: "center",
                          justifyContent: "center",
                          fontFamily: "var(--font-sans)",
                          fontSize: "0.8125rem",
                          border: "none",
                          borderRadius: "4px",
                          cursor:
                            disabled || !isCurrentMonth
                              ? "default"
                              : "pointer",
                          backgroundColor: isSelected
                            ? "#C8AA6E"
                            : "transparent",
                          color: isSelected
                            ? "#0B0B0B"
                            : disabled || !isCurrentMonth
                            ? "var(--fgColor-muted)"
                            : "var(--fgColor-default)",
                          opacity: disabled || !isCurrentMonth ? 0.3 : 1,
                          fontWeight: isSelected ? 600 : 400,
                          transition: "all 0.1s ease",
                        }}
                      >
                        {date.date()}
                      </button>
                    );
                  })}
                </div>
              </div>
            )}

            {/* ── Step 2: Time Slots ── */}
            {step === 2 && (
              <div>
                <div
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.875rem",
                    fontWeight: 600,
                    color: "var(--fgColor-default)",
                    marginBottom: "4px",
                  }}
                >
                  Available slots for{" "}
                  {selectedDate && dayjs(selectedDate).format("ddd, DD MMM")}
                </div>
                <div
                  style={{
                    fontFamily: "var(--font-sans)",
                    fontSize: "0.8125rem",
                    color: "var(--fgColor-muted)",
                    marginBottom: "16px",
                  }}
                >
                  Timezone: Asia/Kolkata (IST)
                </div>

                {slotsLoading ? (
                  <div
                    style={{
                      padding: "32px",
                      textAlign: "center",
                      fontFamily: "var(--font-sans)",
                      fontSize: "0.875rem",
                      color: "var(--fgColor-muted)",
                    }}
                  >
                    Loading available slots...
                  </div>
                ) : slots.length === 0 ? (
                  <div
                    style={{
                      padding: "32px",
                      textAlign: "center",
                    }}
                  >
                    <div
                      style={{
                        fontFamily: "var(--font-sans)",
                        fontSize: "0.875rem",
                        color: "var(--fgColor-muted)",
                        marginBottom: "4px",
                      }}
                    >
                      No available slots for this date
                    </div>
                    <div
                      style={{
                        fontFamily: "var(--font-sans)",
                        fontSize: "0.8125rem",
                        color: "var(--fgColor-muted)",
                      }}
                    >
                      Please select a different date
                    </div>
                  </div>
                ) : (
                  <div
                    style={{
                      display: "grid",
                      gridTemplateColumns: "repeat(auto-fill, minmax(160px, 1fr))",
                      gap: "8px",
                    }}
                  >
                    {slots.map((slot) => {
                      const isSelected =
                        selectedSlot?.startTime === slot.startTime;
                      return (
                        <button
                          key={`${slot.startTime}-${slot.endTime}`}
                          onClick={() => setSelectedSlot(slot)}
                          style={{
                            padding: "12px",
                            backgroundColor: isSelected
                              ? "rgba(200, 170, 110, 0.1)"
                              : "var(--bgColor-mild)",
                            border: `1px solid ${
                              isSelected
                                ? "#C8AA6E"
                                : "var(--borderColor-default)"
                            }`,
                            borderRadius: "6px",
                            cursor: "pointer",
                            fontFamily: "var(--font-sans)",
                            fontSize: "0.875rem",
                            fontWeight: isSelected ? 600 : 400,
                            color: isSelected
                              ? "#C8AA6E"
                              : "var(--fgColor-default)",
                            transition: "all 0.15s ease",
                          }}
                        >
                          {formatTime12(slot.startTime)} –{" "}
                          {formatTime12(slot.endTime)}
                        </button>
                      );
                    })}
                  </div>
                )}
              </div>
            )}

            {/* ── Step 3: Details + Confirm ── */}
            {step === 3 && (
              <div>
                {success ? (
                  <div
                    style={{
                      padding: "48px 24px",
                      textAlign: "center",
                      opacity: fading ? 0 : 1,
                      transition: "opacity 0.3s ease",
                    }}
                  >
                    <div
                      style={{
                        width: "48px",
                        height: "48px",
                        borderRadius: "50%",
                        backgroundColor: "rgba(63, 185, 80, 0.1)",
                        display: "flex",
                        alignItems: "center",
                        justifyContent: "center",
                        margin: "0 auto 16px",
                      }}
                    >
                      <svg
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#3fb950"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <polyline points="20 6 9 17 4 12" />
                      </svg>
                    </div>
                    <div
                      style={{
                        fontFamily: "var(--font-sans)",
                        fontSize: "1.125rem",
                        fontWeight: 600,
                        color: "var(--fgColor-default)",
                        marginBottom: "8px",
                      }}
                    >
                      Session Booked!
                    </div>
                    <div
                      style={{
                        fontFamily: "var(--font-sans)",
                        fontSize: "0.875rem",
                        color: "var(--fgColor-muted)",
                      }}
                    >
                      Your session with {mentor.name} is confirmed.
                    </div>
                  </div>
                ) : showConfirmation ? (
                  <div>
                    <div
                      style={{
                        fontFamily: "var(--font-sans)",
                        fontSize: "0.875rem",
                        fontWeight: 600,
                        color: "var(--fgColor-default)",
                        marginBottom: "16px",
                      }}
                    >
                      Review Your Booking
                    </div>

                    {/* Session Summary */}
                    <div style={{ marginBottom: "16px" }}>
                      <div
                        style={{
                          fontFamily: "var(--font-sans)",
                          fontSize: "0.6875rem",
                          color: "var(--fgColor-muted)",
                          textTransform: "uppercase",
                          letterSpacing: "0.05em",
                          marginBottom: "8px",
                        }}
                      >
                        Session Summary
                      </div>
                      <div
                        style={{
                          backgroundColor: "var(--bgColor-mild)",
                          borderRadius: "6px",
                          padding: "12px 16px",
                        }}
                      >
                        <div
                          style={{
                            display: "flex",
                            gap: "8px",
                            marginBottom: "6px",
                          }}
                        >
                          <span
                            style={{
                              fontSize: "0.8125rem",
                              color: "var(--fgColor-muted)",
                              flexShrink: 0,
                              minWidth: "80px",
                            }}
                          >
                            Subject
                          </span>
                          <span
                            style={{
                              fontSize: "0.8125rem",
                              color: "var(--fgColor-default)",
                              fontWeight: 500,
                              wordBreak: "break-word",
                            }}
                          >
                            {subject}
                          </span>
                        </div>
                        <div
                          style={{
                            display: "flex",
                            gap: "8px",
                          }}
                        >
                          <span
                            style={{
                              fontSize: "0.8125rem",
                              color: "var(--fgColor-muted)",
                              flexShrink: 0,
                              minWidth: "80px",
                            }}
                          >
                            Description
                          </span>
                          <span
                            style={{
                              fontSize: "0.8125rem",
                              color: "var(--fgColor-default)",
                              fontWeight: 500,
                              wordBreak: "break-word",
                            }}
                          >
                            {description.length > 80
                              ? description.slice(0, 80) + "..."
                              : description}
                          </span>
                        </div>
                      </div>
                    </div>

                    {/* Payment Breakdown */}
                    <div style={{ marginBottom: "16px" }}>
                      <div
                        style={{
                          fontFamily: "var(--font-sans)",
                          fontSize: "0.6875rem",
                          color: "var(--fgColor-muted)",
                          textTransform: "uppercase",
                          letterSpacing: "0.05em",
                          marginBottom: "8px",
                        }}
                      >
                        Payment Breakdown
                      </div>
                      <div
                        style={{
                          backgroundColor: "var(--bgColor-mild)",
                          borderRadius: "6px",
                          padding: "12px 16px",
                        }}
                      >
                        <div
                          style={{
                            display: "flex",
                            justifyContent: "space-between",
                            marginBottom: "6px",
                          }}
                        >
                          <span
                            style={{
                              fontSize: "0.8125rem",
                              color: "var(--fgColor-muted)",
                            }}
                          >
                            Session Fee
                          </span>
                          <span
                            style={{
                              fontSize: "0.8125rem",
                              color: "var(--fgColor-default)",
                              fontWeight: 500,
                            }}
                          >
                            {currencySymbol}{priceValue}
                          </span>
                        </div>
                        <div
                          style={{
                            display: "flex",
                            justifyContent: "space-between",
                            marginBottom: "6px",
                          }}
                        >
                          <span
                            style={{
                              fontSize: "0.8125rem",
                              color: "var(--fgColor-muted)",
                            }}
                          >
                            Advance (10%) &mdash; deducted now
                          </span>
                          <span
                            style={{
                              fontSize: "0.8125rem",
                              color: "#C8AA6E",
                              fontWeight: 600,
                            }}
                          >
                            &minus;{currencySymbol}{advanceValue}
                          </span>
                        </div>
                        <div
                          style={{
                            borderTop: "1px solid var(--borderColor-default)",
                            paddingTop: "8px",
                            display: "flex",
                            justifyContent: "space-between",
                          }}
                        >
                          <span
                            style={{
                              fontSize: "0.875rem",
                              color: "var(--fgColor-default)",
                              fontWeight: 600,
                            }}
                          >
                            Balance Due
                          </span>
                          <span
                            style={{
                              fontSize: "0.875rem",
                              color: "var(--fgColor-default)",
                              fontWeight: 600,
                            }}
                          >
                            {currencySymbol}{balanceValue}
                          </span>
                        </div>
                      </div>
                    </div>

                    {/* How it works — styled like home page dialogue box */}
                    <div
                      style={{
                        backgroundColor: "var(--bgColor-info, #cedeff)",
                        border: "1px solid var(--borderColor-info, #3a73ff)",
                        borderRadius: "4px",
                        padding: "16px",
                        marginBottom: "16px",
                        display: "flex",
                        alignItems: "flex-start",
                        gap: "12px",
                      }}
                    >
                      <div style={{ flexShrink: 0, marginTop: "2px" }}>
                        <svg
                          width="20"
                          height="20"
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="currentColor"
                          strokeWidth="2"
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          style={{ color: "var(--fgColor-info, #3a73ff)" }}
                        >
                          <circle cx="12" cy="12" r="10" />
                          <line x1="12" y1="16" x2="12" y2="12" />
                          <line x1="12" y1="8" x2="12.01" y2="8" />
                        </svg>
                      </div>
                      <div>
                        <div
                          style={{
                            fontFamily: "var(--font-sans)",
                            fontSize: "var(--text-sm)",
                            fontWeight: 600,
                            color: "var(--fgColor-default)",
                            margin: 0,
                            marginBottom: "4px",
                          }}
                        >
                          How the advance works
                        </div>
                        <div
                          style={{
                            fontFamily: "var(--font-sans)",
                            fontSize: "var(--text-sm)",
                            lineHeight: "1.35rem",
                            color: "var(--fgColor-muted)",
                            margin: 0,
                          }}
                        >
                          The <strong style={{color: "var(--fgColor-default)"}}>10% advance</strong> secures your slot
                          and confirms the mentor&apos;s time. This amount is{" "}
                          <strong style={{color: "var(--fgColor-default)"}}>redeemable towards the final payment</strong>.
                          The remaining balance will be{" "}
                          <strong style={{color: "var(--fgColor-default)"}}>due before the session begins</strong>.
                        </div>
                      </div>
                    </div>

                    {/* Cancellation Policy */}
                    <div
                      style={{
                        padding: "14px 16px",
                        backgroundColor: "rgba(248, 81, 73, 0.08)",
                        borderRadius: "8px",
                        border: "1px solid rgba(248, 81, 73, 0.35)",
                      }}
                    >
                      <div
                        style={{
                          display: "flex",
                          alignItems: "center",
                          gap: "8px",
                          marginBottom: "10px",
                        }}
                      >
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#f85149" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                          <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
                          <line x1="12" y1="9" x2="12" y2="13" />
                          <line x1="12" y1="17" x2="12.01" y2="17" />
                        </svg>
                        <span
                          style={{
                            fontFamily: "var(--font-sans)",
                            fontSize: "0.8125rem",
                            fontWeight: 700,
                            color: "#f85149",
                          }}
                        >
                          Cancellation Policy
                        </span>
                      </div>
                      <div
                        style={{
                          fontFamily: "var(--font-sans)",
                          fontSize: "0.8125rem",
                          color: "var(--fgColor-default)",
                          lineHeight: 1.7,
                        }}
                      >
                        If <strong style={{color: "#f85149"}}>you</strong> cancel: The
                        advance payment is <strong>non-refundable</strong>.
                        <br />
                        If <strong style={{color: "#f85149"}}>the mentor</strong> cancels:
                        You&apos;ll receive a <strong>full refund</strong>.
                      </div>
                    </div>
                  </div>
                ) : (
                  <div>
                    {/* Subject */}
                    <div style={{ marginBottom: "16px" }}>
                      <div
                        style={{
                          display: "flex",
                          justifyContent: "space-between",
                          marginBottom: "6px",
                        }}
                      >
                        <label
                          style={{
                            fontFamily: "var(--font-sans)",
                            fontSize: "0.8125rem",
                            fontWeight: 500,
                            color: "var(--fgColor-default)",
                          }}
                        >
                          Subject
                        </label>
                        <span
                          style={{
                            fontFamily: "var(--font-sans)",
                            fontSize: "0.75rem",
                            color:
                              getWordCount(subject) > 10
                                ? "#f85149"
                                : "var(--fgColor-muted)",
                          }}
                        >
                          {getWordCount(subject)}/10 words
                        </span>
                      </div>
                      <input
                        type="text"
                        value={subject}
                        onChange={(e) => setSubject(e.target.value)}
                        placeholder="e.g., ML model deployment guidance"
                        style={{
                          width: "100%",
                          backgroundColor: "var(--bgColor-mild)",
                          border: "1px solid var(--borderColor-default)",
                          borderRadius: "4px",
                          height: "36px",
                          padding: "0 12px",
                          fontFamily: "var(--font-sans)",
                          fontSize: "0.8125rem",
                          color: "var(--fgColor-default)",
                          outline: "none",
                          boxSizing: "border-box",
                        }}
                      />
                    </div>

                    {/* Description */}
                    <div style={{ marginBottom: "16px" }}>
                      <div
                        style={{
                          display: "flex",
                          justifyContent: "space-between",
                          marginBottom: "6px",
                        }}
                      >
                        <label
                          style={{
                            fontFamily: "var(--font-sans)",
                            fontSize: "0.8125rem",
                            fontWeight: 500,
                            color: "var(--fgColor-default)",
                          }}
                        >
                          Description
                        </label>
                        <span
                          style={{
                            fontFamily: "var(--font-sans)",
                            fontSize: "0.75rem",
                            color:
                              getWordCount(description) > 0 &&
                              getWordCount(description) < 10
                                ? "#f85149"
                                : "var(--fgColor-muted)",
                          }}
                        >
                          {getWordCount(description)} words (min 10)
                        </span>
                      </div>
                      <textarea
                        value={description}
                        onChange={(e) => setDescription(e.target.value)}
                        placeholder="Describe what you'd like help with, your current level, and what you hope to achieve..."
                        rows={4}
                        style={{
                          width: "100%",
                          backgroundColor: "var(--bgColor-mild)",
                          border: "1px solid var(--borderColor-default)",
                          borderRadius: "4px",
                          padding: "10px 12px",
                          fontFamily: "var(--font-sans)",
                          fontSize: "0.8125rem",
                          color: "var(--fgColor-default)",
                          outline: "none",
                          resize: "vertical",
                          boxSizing: "border-box",
                        }}
                      />
                    </div>

                    {/* File Upload */}
                    <div style={{ marginBottom: "20px" }}>
                      <label
                        style={{
                          fontFamily: "var(--font-sans)",
                          fontSize: "0.8125rem",
                          fontWeight: 500,
                          color: "var(--fgColor-default)",
                          display: "block",
                          marginBottom: "6px",
                        }}
                      >
                        Attachment{" "}
                        <span style={{ fontWeight: 400, color: "var(--fgColor-muted)" }}>
                          (optional, max 2MB)
                        </span>
                      </label>
                      <div
                        onClick={() => fileInputRef.current?.click()}
                        style={{
                          border: "1px dashed var(--borderColor-default)",
                          borderRadius: "4px",
                          padding: "16px",
                          textAlign: "center",
                          cursor: "pointer",
                          backgroundColor: "var(--bgColor-mild)",
                          transition: "border-color 0.15s ease",
                        }}
                        onMouseOver={(e) => {
                          e.currentTarget.style.borderColor = "var(--fgColor-muted)";
                        }}
                        onMouseOut={(e) => {
                          e.currentTarget.style.borderColor = "var(--borderColor-default)";
                        }}
                      >
                        {file ? (
                          <div>
                            <div
                              style={{
                                fontFamily: "var(--font-sans)",
                                fontSize: "0.8125rem",
                                color: "var(--fgColor-default)",
                                fontWeight: 500,
                              }}
                            >
                              {file.name}
                            </div>
                            <div
                              style={{
                                fontFamily: "var(--font-sans)",
                                fontSize: "0.75rem",
                                color: "var(--fgColor-muted)",
                                marginTop: "2px",
                              }}
                            >
                              {(file.size / 1024).toFixed(1)} KB
                            </div>
                          </div>
                        ) : (
                          <div>
                            <svg
                              width="24"
                              height="24"
                              viewBox="0 0 24 24"
                              fill="none"
                              stroke="var(--fgColor-muted)"
                              strokeWidth="1.5"
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              style={{ margin: "0 auto 8px", display: "block" }}
                            >
                              <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                              <polyline points="17 8 12 3 7 8" />
                              <line x1="12" y1="3" x2="12" y2="15" />
                            </svg>
                            <div
                              style={{
                                fontFamily: "var(--font-sans)",
                                fontSize: "0.8125rem",
                                color: "var(--fgColor-muted)",
                              }}
                            >
                              Click to upload PDF, DOCX, TXT, PNG, JPG, GIF, WEBP
                            </div>
                          </div>
                        )}
                      </div>
                      <input
                        ref={fileInputRef}
                        type="file"
                        accept=".pdf,.docx,.txt,.png,.jpg,.jpeg,.gif,.webp"
                        onChange={handleFileChange}
                        style={{ display: "none" }}
                      />
                    </div>

                    {/* Error */}
                    {error && (
                      <div
                        style={{
                          fontFamily: "var(--font-sans)",
                          fontSize: "0.8125rem",
                          color: "#f85149",
                          marginBottom: "12px",
                          padding: "8px 12px",
                          backgroundColor: "rgba(248, 81, 73, 0.1)",
                          borderRadius: "4px",
                          border: "1px solid rgba(248, 81, 73, 0.2)",
                        }}
                      >
                        {error}
                      </div>
                    )}
                  </div>
                )}
              </div>
            )}
          </div>
        </div>

        {/* Footer */}
        <div
          style={{
            borderTop: "1px solid var(--borderColor-default)",
            padding: "12px 20px",
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
          }}
        >
          <button
            onClick={() => {
              if (step === 1) onClose();
              else if (showConfirmation) setShowConfirmation(false);
              else setStep(((step - 1) as 1 | 2 | 3));
            }}
            style={{
              padding: "8px 16px",
              backgroundColor: "transparent",
              border: "1px solid var(--borderColor-default)",
              borderRadius: "4px",
              fontFamily: "var(--font-sans)",
              fontSize: "0.8125rem",
              color: "var(--fgColor-muted)",
              cursor: "pointer",
            }}
          >
            {step === 1 ? "Cancel" : showConfirmation ? "Back to Form" : "Back"}
          </button>

          {step < 3 ? (
            <button
              disabled={
                step === 1
                  ? !selectedCategory || !selectedDate
                  : !selectedSlot
              }
              onClick={() => setStep(((step + 1) as 1 | 2 | 3))}
              style={{
                padding: "8px 24px",
                backgroundColor:
                  (step === 1 && (!selectedCategory || !selectedDate)) ||
                  (step === 2 && !selectedSlot)
                    ? "var(--bgColor-muted)"
                    : "#C8AA6E",
                border: "none",
                borderRadius: "4px",
                fontFamily: "var(--font-sans)",
                fontSize: "0.875rem",
                fontWeight: 600,
                color:
                  (step === 1 && (!selectedCategory || !selectedDate)) ||
                  (step === 2 && !selectedSlot)
                    ? "var(--fgColor-muted)"
                    : "#0B0B0B",
                cursor:
                  (step === 1 && (!selectedCategory || !selectedDate)) ||
                  (step === 2 && !selectedSlot)
                    ? "not-allowed"
                    : "pointer",
                opacity:
                  (step === 1 && (!selectedCategory || !selectedDate)) ||
                  (step === 2 && !selectedSlot)
                    ? 0.5
                    : 1,
                transition: "all 0.15s ease",
              }}
            >
              Continue
            </button>
          ) : !success ? (
            showConfirmation ? (
              <button
                disabled={booking || uploading}
                onClick={handleFinalConfirm}
                style={{
                  padding: "8px 24px",
                  backgroundColor:
                    booking || uploading
                      ? "var(--bgColor-muted)"
                      : "#C8AA6E",
                  border: "none",
                  borderRadius: "4px",
                  fontFamily: "var(--font-sans)",
                  fontSize: "0.875rem",
                  fontWeight: 600,
                  color:
                    booking || uploading
                      ? "var(--fgColor-muted)"
                      : "#0B0B0B",
                  cursor:
                    booking || uploading
                      ? "not-allowed"
                      : "pointer",
                  opacity:
                    booking || uploading
                      ? 0.5
                      : 1,
                  transition: "all 0.15s ease",
                }}
              >
                {booking
                  ? "Booking..."
                  : uploading
                  ? "Uploading..."
                  : "Confirm & Pay Advance"}
              </button>
            ) : (
              <button
                disabled={
                  !subject.trim() ||
                  getWordCount(subject) > 10 ||
                  getWordCount(description) < 10
                }
                onClick={handleConfirm}
                style={{
                  padding: "8px 24px",
                  backgroundColor:
                    !subject.trim() ||
                    getWordCount(subject) > 10 ||
                    getWordCount(description) < 10
                      ? "var(--bgColor-muted)"
                      : "#C8AA6E",
                  border: "none",
                  borderRadius: "4px",
                  fontFamily: "var(--font-sans)",
                  fontSize: "0.875rem",
                  fontWeight: 600,
                  color:
                    !subject.trim() ||
                    getWordCount(subject) > 10 ||
                    getWordCount(description) < 10
                      ? "var(--fgColor-muted)"
                      : "#0B0B0B",
                  cursor:
                    !subject.trim() ||
                    getWordCount(subject) > 10 ||
                    getWordCount(description) < 10
                      ? "not-allowed"
                      : "pointer",
                  opacity:
                    !subject.trim() ||
                    getWordCount(subject) > 10 ||
                    getWordCount(description) < 10
                      ? 0.5
                      : 1,
                  transition: "all 0.15s ease",
                }}
              >
                Confirm Booking
              </button>
            )
          ) : null}
        </div>
      </div>
    </div>
  );
}
