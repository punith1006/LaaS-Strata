"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import * as DialogPrimitive from "@radix-ui/react-dialog";
import { BarChart3 } from "lucide-react";
import { clearAnalyticsTokens } from "@/lib/token";
import { SupportModal } from "@/components/support/support-modal";

/**
 * Analytics console shell — mirrors the main AppShell layout structure.
 * Simplified for admin portal:
 * - No credits/status/mode in header (admin-specific)
 * - No user nav items in sidebar (just SUPPORT + COMPANY at bottom)
 * - Sign-out clears analytics tokens and redirects to /analytics
 */
export function AnalyticsShell({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const [isSignOutModalOpen, setIsSignOutModalOpen] = useState(false);
  const [isSupportModalOpen, setIsSupportModalOpen] = useState(false);

  const handleSignOutClick = () => {
    setIsSignOutModalOpen(true);
  };

  const performSignOut = () => {
    // Store dark mode preference before clearing
    const darkMode = localStorage.getItem("darkMode");

    // Clear analytics tokens
    clearAnalyticsTokens();

    // Restore dark mode preference
    if (darkMode) {
      localStorage.setItem("darkMode", darkMode);
    }

    setIsSignOutModalOpen(false);
    router.push("/analytics");
  };

  return (
    <div
      className="min-h-screen w-full"
      style={{
        backgroundColor: "var(--bgColor-default)",
        fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
      }}
    >
      {/* Top row: Logo box + Header */}
      <div className="flex" style={{ height: "var(--shell-header-height)" }}>
        {/* Logo box — Lambda style: fills header height with padding */}
        <div
          className="flex items-center shrink-0"
          style={{
            height: "var(--shell-header-height)",
            padding: "0 32px",
            borderRight: "1px solid var(--borderColor-default)",
            borderBottom: "1px solid var(--borderColor-default)",
            backgroundColor: "var(--bgColor-mild)",
          }}
        >
          <span
            className="select-none"
            style={{
              fontFamily: "var(--font-sans)",
              fontSize: "var(--text-lg)",
              fontWeight: 700,
              letterSpacing: "var(--tracking-label)",
              textTransform: "uppercase",
              color: "var(--fgColor-default)",
            }}
          >
            LaaS
          </span>
        </div>

        {/* Header right section */}
        <header
          className="flex-1 flex items-center justify-end"
          style={{
            height: "var(--shell-header-height)",
            borderBottom: "1px solid var(--borderColor-default)",
            backgroundColor: "var(--bgColor-mild)",
            gap: "16px",
            paddingRight: "24px",
          }}
          aria-label="Header"
        >
          {/* Sign out */}
          <button
            onClick={handleSignOutClick}
            className="flex items-center cursor-pointer"
            style={{
              fontFamily: "ui-monospace, monospace",
              fontSize: "1rem",
              fontWeight: 500,
              lineHeight: "1.375rem",
              textTransform: "uppercase",
              color: "var(--fgColor-default)",
              background: "transparent",
              border: "none",
              padding: "8px",
              gap: "8px",
            }}
          >
            Sign out
            {/* Log-out icon - Lucide style */}
            <svg
              width="22"
              height="22"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="1.5"
              strokeLinecap="round"
              strokeLinejoin="round"
            >
              <path d="m16 17 5-5-5-5" />
              <path d="M21 12H9" />
              <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
            </svg>
          </button>
        </header>
      </div>

      {/* Bottom row: Sidebar + Main content */}
      <div className="flex" style={{ height: "calc(100vh - var(--shell-header-height))" }}>
        {/* Sidebar */}
        <aside
          className="flex flex-col shrink-0"
          style={{
            width: "var(--shell-sidebar-width)",
            borderRight: "1px solid var(--borderColor-default)",
            backgroundColor: "var(--bgColor-mild)",
            fontSize: "14px",
          }}
          aria-label="Navigation"
        >
          {/* Navigation area */}
          <div className="flex-1 min-h-0 overflow-y-auto" style={{ paddingTop: "8px", paddingBottom: "8px" }}>
            {/* OVERVIEW nav item — active state */}
            <button
              className="w-full flex items-center gap-3 relative"
              style={{
                height: "48px",
                padding: "0 16px",
                color: "var(--fgColor-default)",
                backgroundColor: "var(--bgColor-default)",
                fontWeight: 400,
                border: "none",
                cursor: "pointer",
              }}
            >
              {/* Active indicator - 2px left border */}
              <span
                style={{
                  position: "absolute",
                  left: 0,
                  top: "50%",
                  transform: "translateY(-50%)",
                  width: "2px",
                  height: "28px",
                  backgroundColor: "var(--fgColor-default)",
                  borderRadius: "1px",
                }}
              />
              <span className="shrink-0">
                <BarChart3 size={22} />
              </span>
              <span
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "var(--text-base)",
                  fontWeight: 400,
                  textTransform: "uppercase",
                  letterSpacing: "var(--tracking-label)",
                }}
              >
                OVERVIEW
              </span>
            </button>
          </div>

          {/* Sidebar footer — Support, Company + copyright */}
          <div
            className="shrink-0"
            style={{
              borderTop: "1px solid var(--borderColor-default)",
              backgroundColor: "var(--bgColor-mild)",
              paddingTop: "8px",
              paddingBottom: "12px",
            }}
          >
            {[
              {
                label: "SUPPORT",
                icon: (
                  <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
                    <circle cx="12" cy="12" r="10" />
                    <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3" />
                    <line x1="12" y1="17" x2="12.01" y2="17" />
                  </svg>
                ),
                onClick: () => setIsSupportModalOpen(true),
                disabled: false,
              },
              {
                label: "COMPANY",
                icon: (
                  <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                    <circle cx="9" cy="7" r="4" />
                    <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                    <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                  </svg>
                ),
                disabled: true,
              },
            ].map(({ label, icon, onClick, disabled }) => (
              <button
                key={label}
                onClick={onClick}
                disabled={disabled}
                style={{
                  width: "100%",
                  display: "flex",
                  alignItems: "center",
                  gap: "12px",
                  height: "48px",
                  padding: "0 16px",
                  background: "transparent",
                  border: "none",
                  cursor: disabled ? "default" : "pointer",
                  fontFamily: "var(--font-sans)",
                  fontSize: "var(--text-base)",
                  fontWeight: 400,
                  textTransform: "uppercase",
                  letterSpacing: "var(--tracking-label)",
                  color: "var(--fgColor-default)",
                  textAlign: "left",
                  opacity: disabled ? 0.5 : 1,
                }}
              >
                <span style={{ flexShrink: 0 }}>{icon}</span>
                {label}
              </button>
            ))}

            {/* Copyright */}
            <div
              style={{
                padding: "8px 16px 0",
                fontFamily: "var(--font-sans)",
                fontSize: "0.6875rem",
                color: "var(--fgColor-muted)",
                lineHeight: 1.4,
              }}
            >
              © Copyright LaaS 2026
            </div>
          </div>
        </aside>

        {/* Main content area */}
        <main
          className="flex-1 min-h-0 min-w-0 overflow-auto"
          style={{
            backgroundColor: "var(--bgColor-default)",
          }}
        >
          {children}
        </main>
      </div>

      {/* Sign-out confirmation modal */}
      <DialogPrimitive.Root open={isSignOutModalOpen} onOpenChange={(open) => !open && setIsSignOutModalOpen(false)}>
        <DialogPrimitive.Portal>
          <DialogPrimitive.Overlay
            className="fixed inset-0 z-50"
            style={{
              backgroundColor: "rgba(11, 11, 11, 0.15)",
            }}
          />
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
                Sign Out
              </DialogPrimitive.Title>
            </div>

            {/* Modal content */}
            <div
              style={{
                overflowY: "auto",
                overflowX: "hidden",
                padding: "24px",
              }}
            >
              <p
                style={{
                  color: "var(--fgColor-mild)",
                  fontSize: "0.875rem",
                  lineHeight: "1.375rem",
                  fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                  margin: 0,
                  marginBottom: "24px",
                }}
              >
                Are you sure you want to sign out of the Analytics Portal? You will need to sign in again to access the admin dashboard.
              </p>

              {/* Button row */}
              <div
                style={{
                  display: "flex",
                  justifyContent: "flex-end",
                  gap: "12px",
                }}
              >
                {/* Cancel button */}
                <button
                  onClick={() => setIsSignOutModalOpen(false)}
                  style={{
                    color: "var(--fgColor-mild)",
                    backgroundColor: "transparent",
                    border: "1px solid var(--borderColor-default)",
                    borderRadius: "4px",
                    padding: "0 24px",
                    height: "40px",
                    fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                    fontSize: "0.875rem",
                    fontWeight: 500,
                    cursor: "pointer",
                    transition: "background-color 0.15s ease",
                  }}
                  onMouseEnter={(e) => {
                    e.currentTarget.style.backgroundColor = "rgba(11, 11, 11, 0.05)";
                  }}
                  onMouseLeave={(e) => {
                    e.currentTarget.style.backgroundColor = "transparent";
                  }}
                >
                  Cancel
                </button>

                {/* Confirm button */}
                <button
                  onClick={performSignOut}
                  style={{
                    color: "#E7E6D9",
                    backgroundColor: "#2E2E2E",
                    border: "1px solid transparent",
                    borderRadius: "4px",
                    padding: "0 24px",
                    height: "40px",
                    fontFamily: "var(--font-sans), ui-sans-serif, system-ui, sans-serif",
                    fontSize: "0.875rem",
                    fontWeight: 500,
                    cursor: "pointer",
                    transition: "background-color 0.15s ease",
                  }}
                  onMouseEnter={(e) => {
                    e.currentTarget.style.backgroundColor = "#0B0B0B";
                  }}
                  onMouseLeave={(e) => {
                    e.currentTarget.style.backgroundColor = "#2E2E2E";
                  }}
                >
                  Sign Out
                </button>
              </div>
            </div>
          </DialogPrimitive.Content>
        </DialogPrimitive.Portal>
      </DialogPrimitive.Root>

      {/* Support modal */}
      <SupportModal
        isOpen={isSupportModalOpen}
        onClose={() => setIsSupportModalOpen(false)}
      />
    </div>
  );
}
