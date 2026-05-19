"use client";

import { useState, useEffect, useRef, useMemo } from "react";
import * as DialogPrimitive from "@radix-ui/react-dialog";
import { getMe } from "@/lib/api";
import { submitSupportTicket, SupportTicketResponse } from "@/lib/api";
import { Dropdown } from "./dropdown";

interface UserData {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
}

interface SupportModalProps {
  isOpen: boolean;
  onClose: () => void;
}

const ISSUE_CATEGORIES = [
  { value: "pod_issue", label: "Pod issue" },
  { value: "serverless_issue", label: "Serverless issue" },
  { value: "template_issue", label: "Template issue or inquiry" },
  { value: "general_inquiry", label: "General inquiry" },
  { value: "data_center_partner", label: "Data center partner support" },
];

export function SupportModal({ isOpen, onClose }: SupportModalProps) {
  const [user, setUser] = useState<UserData | null>(null);
  const [category, setCategory] = useState("");
  const [subject, setSubject] = useState("");
  const [description, setDescription] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState("");
  const [submitted, setSubmitted] = useState(false);
  const [ticketId, setTicketId] = useState("");
  const [attachments, setAttachments] = useState<File[]>([]);
  const [attachmentError, setAttachmentError] = useState("");
  const [isDragOver, setIsDragOver] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const ALLOWED_TYPES = [
    "image/jpeg",
    "image/png",
    "image/gif",
    "image/webp",
    "image/bmp",
  ];
  const MAX_FILES = 3;
  const MAX_SIZE = 3 * 1024 * 1024;

  // Generate (and revoke) preview URLs in lockstep with the attachments list.
  const previewUrls = useMemo(
    () => attachments.map((file) => URL.createObjectURL(file)),
    [attachments]
  );
  useEffect(() => {
    return () => {
      previewUrls.forEach((url) => URL.revokeObjectURL(url));
    };
  }, [previewUrls]);

  const processFiles = (incoming: File[]) => {
    if (incoming.length === 0) return;

    if (attachments.length + incoming.length > MAX_FILES) {
      setAttachmentError(`You can attach a maximum of ${MAX_FILES} images.`);
      return;
    }

    for (const file of incoming) {
      if (!ALLOWED_TYPES.includes(file.type)) {
        setAttachmentError(
          `"${file.name}" is not a supported image type.`
        );
        return;
      }
      if (file.size > MAX_SIZE) {
        setAttachmentError(`"${file.name}" exceeds the 3MB size limit.`);
        return;
      }
    }

    setAttachmentError("");
    setAttachments((prev) => [...prev, ...incoming]);
  };

  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files ?? []);
    processFiles(files);
    // Reset so re-selecting the same file fires onChange again.
    e.target.value = "";
  };

  const handleDragOver = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    e.stopPropagation();
    if (!isDragOver) setIsDragOver(true);
  };

  const handleDragLeave = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    e.stopPropagation();
    setIsDragOver(false);
  };

  const handleDrop = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    e.stopPropagation();
    setIsDragOver(false);
    const files = Array.from(e.dataTransfer.files ?? []);
    processFiles(files);
  };

  const handleRemoveAttachment = (index: number) => {
    setAttachments((prev) => prev.filter((_, i) => i !== index));
    setAttachmentError("");
  };

  useEffect(() => {
    if (isOpen) {
      getMe().then((userData) => {
        if (userData) {
          setUser(userData as UserData);
        }
      });
    }
  }, [isOpen]);

  useEffect(() => {
    if (!isOpen) {
      setCategory("");
      setSubject("");
      setDescription("");
      setError("");
      setSubmitted(false);
      setTicketId("");
      setIsSubmitting(false);
      setAttachments([]);
      setAttachmentError("");
      setIsDragOver(false);
    }
  }, [isOpen]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");

    if (!category || !subject.trim() || !description.trim()) {
      setError("Please fill in all required fields");
      return;
    }

    setIsSubmitting(true);

    try {
      const response: SupportTicketResponse = await submitSupportTicket(
        {
          category,
          subject: subject.trim(),
          description: description.trim(),
        },
        attachments
      );
      
      setTicketId(response.ticketId);
      setSubmitted(true);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to submit ticket. Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleReset = () => {
    setCategory("");
    setSubject("");
    setDescription("");
    setError("");
    setAttachments([]);
    setAttachmentError("");
  };

  return (
    <DialogPrimitive.Root open={isOpen} onOpenChange={(open) => !open && onClose()}>
      <DialogPrimitive.Portal>
        {/* Modal background overlay */}
        <DialogPrimitive.Overlay
          className="fixed inset-0 z-50"
          style={{
            backgroundColor: "rgba(11, 11, 11, 0.5)",
            backdropFilter: "blur(6px)",
            WebkitBackdropFilter: "blur(6px)",
          }}
        />
        
        {/* Modal content */}
        <DialogPrimitive.Content
          className="fixed left-[50%] top-[50%] z-50 translate-x-[-50%] translate-y-[-50%]"
          style={{
            width: "calc(100% - 32px)",
            maxWidth: "420px",
            maxHeight: "95%",
            backgroundColor: "var(--bgColor-default)",
            border: "1px solid var(--borderColor-default)",
            display: "flex",
            flexDirection: "column",
          }}
        >
          {/* Modal header */}
          <div
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
              padding: "16px 24px",
              borderBottom: "1px solid var(--borderColor-default)",
              lineHeight: "1.375rem",
            }}
          >
            <DialogPrimitive.Title
              style={{
                flex: 1,
                color: "var(--fgColor-default)",
                fontSize: "1.125rem",
                fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                fontWeight: 400,
                margin: 0,
              }}
            >
              {submitted ? "Ticket Submitted" : "Request support"}
            </DialogPrimitive.Title>
            
            <div style={{ display: "flex", alignItems: "center", gap: "4px" }}>
              {!submitted && (
                <button
                  type="button"
                  onClick={handleReset}
                  title="Reset form"
                  style={{
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    width: "32px",
                    height: "32px",
                    padding: 0,
                    background: "transparent",
                    border: "none",
                    borderRadius: "4px",
                    cursor: "pointer",
                    color: "var(--fgColor-muted)",
                    transition: "all 0.15s ease",
                  }}
                  onMouseEnter={(e) => {
                    e.currentTarget.style.backgroundColor = "rgba(11, 11, 11, 0.05)";
                    e.currentTarget.style.color = "var(--fgColor-default)";
                  }}
                  onMouseLeave={(e) => {
                    e.currentTarget.style.backgroundColor = "transparent";
                    e.currentTarget.style.color = "var(--fgColor-muted)";
                  }}
                >
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M21 2v6h-6" />
                    <path d="M3 12a9 9 0 0 1 15-6.7L21 8" />
                    <path d="M3 22v-6h6" />
                    <path d="M21 12a9 9 0 0 1-15 6.7L3 16" />
                  </svg>
                </button>
              )}
              
              <DialogPrimitive.Close asChild>
                <button
                  type="button"
                  title="Close"
                  style={{
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    width: "32px",
                    height: "32px",
                    padding: 0,
                    background: "transparent",
                    border: "none",
                    borderRadius: "4px",
                    cursor: "pointer",
                    color: "var(--fgColor-muted)",
                    transition: "all 0.15s ease",
                  }}
                  onMouseEnter={(e) => {
                    e.currentTarget.style.backgroundColor = "rgba(11, 11, 11, 0.05)";
                    e.currentTarget.style.color = "var(--fgColor-default)";
                  }}
                  onMouseLeave={(e) => {
                    e.currentTarget.style.backgroundColor = "transparent";
                    e.currentTarget.style.color = "var(--fgColor-muted)";
                  }}
                >
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
                    <line x1="18" y1="6" x2="6" y2="18" />
                    <line x1="6" y1="6" x2="18" y2="18" />
                  </svg>
                </button>
              </DialogPrimitive.Close>
            </div>
          </div>

          {/* Modal content */}
          <div
            style={{
              overflowY: "auto",
              overflowX: "hidden",
              padding: "24px",
            }}
          >
            {submitted ? (
              /* Success State */
              <div style={{
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                textAlign: "center",
                padding: "16px 0",
              }}>
                {/* Success Icon */}
                <div style={{
                  width: "64px",
                  height: "64px",
                  borderRadius: "50%",
                  backgroundColor: "rgba(5, 192, 4, 0.1)",
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  marginBottom: "20px",
                  color: "#05C004",
                }}>
                  <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
                    <polyline points="20 6 9 17 4 12" />
                  </svg>
                </div>

                <h3 style={{
                  fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                  fontSize: "1.25rem",
                  fontWeight: 500,
                  color: "var(--fgColor-default)",
                  margin: "0 0 12px 0",
                }}>
                  Thank you for reaching out!
                </h3>
                
                <p style={{
                  fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                  fontSize: "0.875rem",
                  fontWeight: 400,
                  color: "var(--fgColor-muted)",
                  lineHeight: 1.6,
                  margin: "0 0 24px 0",
                  maxWidth: "320px",
                }}>
                  We have received your support request. Our team will review it and get back to you within 24 hours.
                </p>

                {/* Ticket Reference */}
                <div style={{
                  display: "flex",
                  flexDirection: "column",
                  gap: "6px",
                  padding: "16px 24px",
                  backgroundColor: "var(--bgColor-muted)",
                  border: "1px solid var(--borderColor-default)",
                  borderRadius: "4px",
                  marginBottom: "16px",
                }}>
                  <span style={{
                    fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                    fontSize: "0.75rem",
                    fontWeight: 400,
                    color: "var(--fgColor-muted)",
                    textTransform: "uppercase",
                    letterSpacing: "0.05em",
                  }}>
                    Ticket Reference
                  </span>
                  <span style={{
                    fontFamily: "ui-monospace, monospace",
                    fontSize: "0.875rem",
                    fontWeight: 500,
                    color: "var(--fgColor-default)",
                    letterSpacing: "0.05em",
                  }}>
                    {ticketId ? ticketId.slice(0, 8).toUpperCase() : "PROCESSING"}
                  </span>
                </div>

                <p style={{
                  fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                  fontSize: "0.75rem",
                  fontWeight: 400,
                  color: "var(--fgColor-muted)",
                  margin: "0 0 24px 0",
                }}>
                  A confirmation email has been sent to your registered email address.
                </p>

                {/* Done Button */}
                <button
                  type="button"
                  onClick={onClose}
                  style={{
                    fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                    fontSize: "0.875rem",
                    fontWeight: 500,
                    lineHeight: 1.375,
                    borderRadius: "4px",
                    padding: "0 24px",
                    height: "40px",
                    cursor: "pointer",
                    backgroundColor: "#2E2E2E",
                    color: "#E7E6D9",
                    border: "1px solid transparent",
                    transition: "all 0.15s ease",
                  }}
                  onMouseEnter={(e) => {
                    e.currentTarget.style.backgroundColor = "#0B0B0B";
                  }}
                  onMouseLeave={(e) => {
                    e.currentTarget.style.backgroundColor = "#2E2E2E";
                  }}
                >
                  Done
                </button>
              </div>
            ) : (
              /* Form State */
              <form onSubmit={handleSubmit} style={{ display: "flex", flexDirection: "column", gap: "20px" }}>
                {/* Error Message */}
                {error && (
                  <div style={{
                    display: "flex",
                    alignItems: "flex-start",
                    gap: "10px",
                    padding: "12px 16px",
                    borderRadius: "4px",
                    backgroundColor: "rgba(255, 103, 66, 0.1)",
                    border: "1px solid rgba(255, 103, 66, 0.3)",
                    color: "#FF6742",
                    fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                    fontSize: "0.875rem",
                    lineHeight: 1.4,
                  }}>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0, marginTop: "2px" }}>
                      <circle cx="12" cy="12" r="10" />
                      <line x1="12" y1="8" x2="12" y2="12" />
                      <line x1="12" y1="16" x2="12.01" y2="16" />
                    </svg>
                    <span>{error}</span>
                  </div>
                )}

                {/* Issue Type */}
                <div style={{ display: "flex", flexDirection: "column" }}>
                  <label style={{
                    fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                    fontSize: "0.875rem",
                    fontWeight: 400,
                    color: "var(--fgColor-default)",
                    marginBottom: "4px",
                  }}>
                    What issue or inquiry do you have
                  </label>
                  <div style={{
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "center",
                    marginBottom: "8px",
                  }}>
                    <span />
                    <span style={{
                      fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                      fontSize: "0.75rem",
                      fontWeight: 400,
                      color: "var(--fgColor-critical)",
                    }}>
                      Required
                    </span>
                  </div>
                  <Dropdown
                    value={category}
                    onChange={setCategory}
                    options={ISSUE_CATEGORIES}
                    placeholder="Select type"
                  />
                </div>

                {/* Subject */}
                <div style={{ display: "flex", flexDirection: "column" }}>
                  <div style={{
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "center",
                    marginBottom: "8px",
                  }}>
                    <label style={{
                      fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                      fontSize: "0.875rem",
                      fontWeight: 500,
                      color: "var(--fgColor-default)",
                    }}>
                      Subject
                    </label>
                    <span style={{
                      fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                      fontSize: "0.75rem",
                      fontWeight: 400,
                      color: "var(--fgColor-critical)",
                    }}>
                      Required
                    </span>
                  </div>
                  <input
                    type="text"
                    value={subject}
                    onChange={(e) => setSubject(e.target.value)}
                    placeholder="Subject"
                    required
                    style={{
                      fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                      fontSize: "0.875rem",
                      fontWeight: 400,
                      lineHeight: 1.375,
                      color: "var(--fgColor-default)",
                      caretColor: "var(--fgColor-default)",
                      backgroundColor: "transparent",
                      border: "1px solid var(--borderColor-default)",
                      borderRadius: "4px",
                      outline: "none",
                      padding: "8px 12px",
                      width: "100%",
                      height: "40px",
                      transition: "border-color 0.15s ease",
                    }}
                    onFocus={(e) => {
                      e.currentTarget.style.borderColor = "var(--fgColor-default)";
                    }}
                    onBlur={(e) => {
                      e.currentTarget.style.borderColor = "var(--borderColor-default)";
                    }}
                  />
                </div>

                {/* Attach Screenshots */}
                <div style={{ display: "flex", flexDirection: "column" }}>
                  <div style={{
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "center",
                    marginBottom: "8px",
                  }}>
                    <label style={{
                      fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                      fontSize: "0.875rem",
                      fontWeight: 500,
                      color: "var(--fgColor-default)",
                    }}>
                      Attach Screenshots
                    </label>
                    <span style={{
                      fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                      fontSize: "0.75rem",
                      fontWeight: 400,
                      color: "var(--fgColor-muted)",
                    }}>
                      (Optional)
                    </span>
                  </div>

                  <div
                    role="button"
                    tabIndex={0}
                    onClick={() => fileInputRef.current?.click()}
                    onKeyDown={(e) => {
                      if (e.key === "Enter" || e.key === " ") {
                        e.preventDefault();
                        fileInputRef.current?.click();
                      }
                    }}
                    onDragOver={handleDragOver}
                    onDragLeave={handleDragLeave}
                    onDrop={handleDrop}
                    style={{
                      display: "flex",
                      flexDirection: "column",
                      alignItems: "center",
                      justifyContent: "center",
                      gap: "6px",
                      padding: "16px",
                      borderRadius: "4px",
                      border: `1px dashed ${isDragOver ? "rgba(255, 255, 255, 0.3)" : "var(--borderColor-default)"}`,
                      backgroundColor: isDragOver
                        ? "rgba(255, 255, 255, 0.02)"
                        : "transparent",
                      cursor: "pointer",
                      transition: "border-color 0.15s ease, background-color 0.15s ease",
                    }}
                  >
                    <svg
                      width="20"
                      height="20"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="1.5"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      style={{ color: "var(--fgColor-muted)" }}
                    >
                      <path d="M12 16V4" />
                      <path d="m7 9 5-5 5 5" />
                      <path d="M5 20h14" />
                    </svg>
                    <span style={{
                      fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                      fontSize: "0.8125rem",
                      fontWeight: 400,
                      color: "var(--fgColor-muted)",
                    }}>
                      Drag &amp; drop or click to upload
                    </span>
                    <span style={{
                      fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                      fontSize: "0.6875rem",
                      fontWeight: 400,
                      color: "var(--fgColor-muted)",
                      opacity: 0.7,
                    }}>
                      Max 3 images, 3MB each
                    </span>
                  </div>

                  <input
                    ref={fileInputRef}
                    type="file"
                    accept=".jpg,.jpeg,.png,.gif,.webp,.bmp"
                    multiple
                    onChange={handleFileSelect}
                    className="hidden"
                    style={{ display: "none" }}
                  />

                  {attachmentError && (
                    <span style={{
                      fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                      fontSize: "0.75rem",
                      fontWeight: 400,
                      color: "var(--fgColor-critical)",
                      marginTop: "8px",
                    }}>
                      {attachmentError}
                    </span>
                  )}

                  {attachments.length > 0 && (
                    <div style={{
                      display: "flex",
                      flexDirection: "column",
                      gap: "6px",
                      marginTop: "10px",
                    }}>
                      <div style={{
                        display: "flex",
                        flexWrap: "wrap",
                        gap: "8px",
                      }}>
                        {attachments.map((file, idx) => (
                          <div
                            key={`${file.name}-${file.size}-${idx}`}
                            style={{ position: "relative" }}
                          >
                            <img
                              src={previewUrls[idx]}
                              alt={file.name}
                              style={{
                                width: "64px",
                                height: "64px",
                                objectFit: "cover",
                                borderRadius: "6px",
                                border: "1px solid var(--borderColor-default)",
                                display: "block",
                              }}
                            />
                            <button
                              type="button"
                              onClick={(e) => {
                                e.stopPropagation();
                                handleRemoveAttachment(idx);
                              }}
                              title="Remove"
                              style={{
                                position: "absolute",
                                top: "-6px",
                                right: "-6px",
                                width: "18px",
                                height: "18px",
                                borderRadius: "50%",
                                backgroundColor: "var(--bgColor-default)",
                                border: "1px solid var(--borderColor-default)",
                                color: "var(--fgColor-default)",
                                display: "flex",
                                alignItems: "center",
                                justifyContent: "center",
                                cursor: "pointer",
                                padding: 0,
                                lineHeight: 0,
                              }}
                            >
                              <svg
                                width="10"
                                height="10"
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
                        ))}
                      </div>
                      <span style={{
                        fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                        fontSize: "0.75rem",
                        fontWeight: 400,
                        color: "var(--fgColor-muted)",
                      }}>
                        {attachments.length}/{MAX_FILES}
                      </span>
                    </div>
                  )}
                </div>

                {/* Description */}
                <div style={{ display: "flex", flexDirection: "column" }}>
                  <div style={{
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "center",
                    marginBottom: "8px",
                  }}>
                    <label style={{
                      fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                      fontSize: "0.875rem",
                      fontWeight: 500,
                      color: "var(--fgColor-default)",
                    }}>
                      Description
                    </label>
                    <span style={{
                      fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                      fontSize: "0.75rem",
                      fontWeight: 400,
                      color: "var(--fgColor-critical)",
                    }}>
                      Required
                    </span>
                  </div>
                  <textarea
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                    placeholder="Tell us more about your issue"
                    required
                    rows={5}
                    style={{
                      fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                      fontSize: "0.875rem",
                      fontWeight: 400,
                      lineHeight: 1.375,
                      color: "var(--fgColor-default)",
                      caretColor: "var(--fgColor-default)",
                      backgroundColor: "transparent",
                      border: "1px solid var(--borderColor-default)",
                      borderRadius: "4px",
                      outline: "none",
                      padding: "8px 12px",
                      width: "100%",
                      resize: "none",
                      transition: "border-color 0.15s ease",
                    }}
                    onFocus={(e) => {
                      e.currentTarget.style.borderColor = "var(--fgColor-default)";
                    }}
                    onBlur={(e) => {
                      e.currentTarget.style.borderColor = "var(--borderColor-default)";
                    }}
                  />
                </div>

                {/* User Info Display */}
                {user && (
                  <div style={{
                    display: "flex",
                    flexDirection: "column",
                    gap: "4px",
                    padding: "12px 16px",
                    backgroundColor: "var(--bgColor-muted)",
                    border: "1px solid var(--borderColor-default)",
                    borderRadius: "4px",
                  }}>
                    <span style={{
                      fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                      fontSize: "0.75rem",
                      fontWeight: 400,
                      color: "var(--fgColor-muted)",
                      textTransform: "uppercase",
                      letterSpacing: "0.05em",
                    }}>
                      Submitting as
                    </span>
                    <span style={{
                      fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                      fontSize: "0.875rem",
                      fontWeight: 400,
                      color: "var(--fgColor-default)",
                    }}>
                      {user.firstName} {user.lastName} ({user.email})
                    </span>
                  </div>
                )}

                {/* Action Buttons */}
                <div style={{
                  display: "flex",
                  justifyContent: "flex-end",
                  gap: "12px",
                  marginTop: "8px",
                }}>
                  <button
                    type="button"
                    onClick={onClose}
                    style={{
                      fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                      fontSize: "0.875rem",
                      fontWeight: 500,
                      lineHeight: 1.375,
                      borderRadius: "4px",
                      padding: "0 24px",
                      height: "40px",
                      cursor: "pointer",
                      backgroundColor: "transparent",
                      color: "var(--fgColor-mild)",
                      border: "1px solid var(--borderColor-default)",
                      transition: "all 0.15s ease",
                    }}
                    onMouseEnter={(e) => {
                      e.currentTarget.style.backgroundColor = "rgba(11, 11, 11, 0.05)";
                      e.currentTarget.style.borderColor = "var(--fgColor-muted)";
                    }}
                    onMouseLeave={(e) => {
                      e.currentTarget.style.backgroundColor = "transparent";
                      e.currentTarget.style.borderColor = "var(--borderColor-default)";
                    }}
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    disabled={isSubmitting}
                    style={{
                      fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                      fontSize: "0.875rem",
                      fontWeight: 500,
                      lineHeight: 1.375,
                      borderRadius: "4px",
                      padding: "0 24px",
                      height: "40px",
                      cursor: isSubmitting ? "not-allowed" : "pointer",
                      backgroundColor: "#7565F6",
                      color: "#E7E6D9",
                      border: "1px solid transparent",
                      transition: "all 0.15s ease",
                      opacity: isSubmitting ? 0.6 : 1,
                    }}
                    onMouseEnter={(e) => {
                      if (!isSubmitting) {
                        e.currentTarget.style.backgroundColor = "#6560D9";
                      }
                    }}
                    onMouseLeave={(e) => {
                      if (!isSubmitting) {
                        e.currentTarget.style.backgroundColor = "#7565F6";
                      }
                    }}
                  >
                    {isSubmitting ? "Submitting..." : "Submit"}
                  </button>
                </div>
              </form>
            )}
          </div>
        </DialogPrimitive.Content>
      </DialogPrimitive.Portal>
    </DialogPrimitive.Root>
  );
}
