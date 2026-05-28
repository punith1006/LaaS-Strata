"use client";

import { useState, useEffect } from "react";
import { useSearchParams, useRouter } from "next/navigation";
import { BillingTabContent } from "@/components/home/billing-tab-content";
import { PaymentHistoryTab } from "@/components/billing/payment-history-tab";
import { AddCreditsModal } from "@/components/billing/add-credits-modal";
import MentorBillingOverview from "@/components/mentor/mentor-billing-overview";
import { getMe } from "@/lib/api";
import type { User } from "@/types/auth";

// Tab type definitions
type BillingTab = "usage" | "history";
type MentorBillingTab = "overview" | "history";
type CombinedTab = BillingTab | MentorBillingTab;

// Lambda.ai style tabs component - matching Home page pattern
function BillingTabs({
  activeTab,
  onTabChange,
  onAddCreditsClick,
}: {
  activeTab: BillingTab;
  onTabChange: (tab: BillingTab) => void;
  onAddCreditsClick: () => void;
}) {
  const tabs: { id: BillingTab; label: string }[] = [
    { id: "usage", label: "Usage Overview" },
    { id: "history", label: "Invoice & Payment History" },
  ];

  return (
    <div
      style={{
        position: "relative",
        display: "flex",
        alignItems: "center",
        justifyContent: "space-between",
        height: "40px",
        borderBottom: "1px solid var(--borderColor-default)",
        marginTop: "24px",
      }}
    >
      {/* Tabs */}
      <div
        style={{
          display: "flex",
          alignItems: "center",
          height: "40px",
          gap: "24px",
        }}
      >
        {tabs.map((tab) => {
          const isActive = activeTab === tab.id;
          return (
            <button
              key={tab.id}
              onClick={() => onTabChange(tab.id)}
              style={{
                position: "relative",
                cursor: "pointer",
                flexShrink: 0,
                whiteSpace: "nowrap",
                height: "40px",
                background: "transparent",
                border: "none",
                padding: "0 0 12px 0",
                marginBottom: "-1px",
              }}
            >
              <span
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "1rem",
                  fontWeight: isActive ? 600 : 400,
                  lineHeight: "1.5rem",
                  display: "block",
                  color: isActive
                    ? "var(--fgColor-default)"
                    : "var(--fgColor-muted)",
                  transition: "color 0.15s ease",
                }}
              >
                {tab.label}
              </span>
              {/* Active tab underline */}
              {isActive && (
                <span
                  style={{
                    position: "absolute",
                    zIndex: 1,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: "2px",
                    backgroundColor: "var(--fgColor-default)",
                    transition: "all 0.2s ease",
                  }}
                />
              )}
            </button>
          );
        })}
      </div>

      {/* Add Credits Button - Golden/Accent style */}
      <button
        onClick={onAddCreditsClick}
        style={{
          display: "flex",
          alignItems: "center",
          gap: "6px",
          backgroundColor: "#C8AA6E",
          color: "#0B0B0B",
          border: "none",
          borderRadius: "4px",
          padding: "0 16px",
          height: "36px",
          fontFamily: "var(--font-sans)",
          fontSize: "0.875rem",
          fontWeight: 500,
          cursor: "pointer",
          transition: "background-color 0.15s ease",
          marginBottom: "8px",
        }}
        onMouseOver={(e) => {
          e.currentTarget.style.backgroundColor = "#B89A5E";
        }}
        onMouseOut={(e) => {
          e.currentTarget.style.backgroundColor = "#C8AA6E";
        }}
      >
        {/* Plus Icon */}
        <svg
          width="16"
          height="16"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
        >
          <line x1="12" y1="5" x2="12" y2="19" />
          <line x1="5" y1="12" x2="19" y2="12" />
        </svg>
        Add Credits
      </button>
    </div>
  );
}

// Lambda.ai style tabs component - Mentor version
function MentorBillingTabs({
  activeTab,
  onTabChange,
  onAddCreditsClick,
}: {
  activeTab: MentorBillingTab;
  onTabChange: (tab: MentorBillingTab) => void;
  onAddCreditsClick: () => void;
}) {
  const tabs: { id: MentorBillingTab; label: string }[] = [
    { id: "overview", label: "Overview" },
    { id: "history", label: "Invoice and Payments" },
  ];

  return (
    <div
      style={{
        position: "relative",
        display: "flex",
        alignItems: "center",
        justifyContent: "space-between",
        height: "40px",
        borderBottom: "1px solid var(--borderColor-default)",
        marginTop: "24px",
      }}
    >
      {/* Tabs */}
      <div
        style={{
          display: "flex",
          alignItems: "center",
          height: "40px",
          gap: "24px",
        }}
      >
        {tabs.map((tab) => {
          const isActive = activeTab === tab.id;
          return (
            <button
              key={tab.id}
              onClick={() => onTabChange(tab.id)}
              style={{
                position: "relative",
                cursor: "pointer",
                flexShrink: 0,
                whiteSpace: "nowrap",
                height: "40px",
                background: "transparent",
                border: "none",
                padding: "0 0 12px 0",
                marginBottom: "-1px",
              }}
            >
              <span
                style={{
                  fontFamily: "var(--font-sans)",
                  fontSize: "1rem",
                  fontWeight: isActive ? 600 : 400,
                  lineHeight: "1.5rem",
                  display: "block",
                  color: isActive
                    ? "var(--fgColor-default)"
                    : "var(--fgColor-muted)",
                  transition: "color 0.15s ease",
                }}
              >
                {tab.label}
              </span>
              {/* Active tab underline */}
              {isActive && (
                <span
                  style={{
                    position: "absolute",
                    zIndex: 1,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: "2px",
                    backgroundColor: "var(--fgColor-default)",
                    transition: "all 0.2s ease",
                  }}
                />
              )}
            </button>
          );
        })}
      </div>

      {/* Action Buttons */}
      <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
        {/* Withdraw Button (dummy) */}
        <button
          onClick={() => console.log("Withdraw functionality coming soon")}
          style={{
            display: "flex",
            alignItems: "center",
            gap: "6px",
            backgroundColor: "transparent",
            color: "var(--fgColor-default)",
            border: "1px solid var(--borderColor-default)",
            borderRadius: "4px",
            padding: "0 16px",
            height: "36px",
            fontFamily: "var(--font-sans)",
            fontSize: "0.875rem",
            fontWeight: 500,
            cursor: "pointer",
            transition: "background-color 0.15s ease, border-color 0.15s ease",
            marginBottom: "8px",
          }}
          onMouseOver={(e) => {
            e.currentTarget.style.backgroundColor = "var(--bgColor-muted)";
            e.currentTarget.style.borderColor = "var(--fgColor-muted)";
          }}
          onMouseOut={(e) => {
            e.currentTarget.style.backgroundColor = "transparent";
            e.currentTarget.style.borderColor = "var(--borderColor-default)";
          }}
        >
          {/* Arrow Up Icon */}
          <svg
            width="16"
            height="16"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          >
            <path d="M12 19V5" />
            <path d="M5 12l7-7 7 7" />
          </svg>
          Withdraw
        </button>

        {/* Add Credits Button - Golden/Accent style */}
        <button
          onClick={onAddCreditsClick}
          style={{
            display: "flex",
            alignItems: "center",
            gap: "6px",
            backgroundColor: "#C8AA6E",
            color: "#0B0B0B",
            border: "none",
            borderRadius: "4px",
            padding: "0 16px",
            height: "36px",
            fontFamily: "var(--font-sans)",
            fontSize: "0.875rem",
            fontWeight: 500,
            cursor: "pointer",
            transition: "background-color 0.15s ease",
            marginBottom: "8px",
          }}
          onMouseOver={(e) => {
            e.currentTarget.style.backgroundColor = "#B89A5E";
          }}
          onMouseOut={(e) => {
            e.currentTarget.style.backgroundColor = "#C8AA6E";
          }}
        >
          {/* Plus Icon */}
          <svg
            width="16"
            height="16"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          >
            <line x1="12" y1="5" x2="12" y2="19" />
            <line x1="5" y1="12" x2="19" y2="12" />
          </svg>
          Add Credits
        </button>
      </div>
    </div>
  );
}

export default function BillingPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [isAddCreditsOpen, setIsAddCreditsOpen] = useState(false);
  const [refreshKey, setRefreshKey] = useState(0);
  const [user, setUser] = useState<User | null>(null);

  // Fetch user to detect mentor role
  useEffect(() => {
    getMe().then(setUser);
  }, []);

  const isMentor = user?.roles?.includes("mentor") ?? false;

  // Get tab from URL or default based on role
  const urlTab = searchParams.get("tab");
  const defaultTab: CombinedTab = isMentor ? "overview" : "usage";
  const currentTab: CombinedTab = (urlTab as CombinedTab) || defaultTab;

  const handleTabChange = (tab: CombinedTab) => {
    // Update URL with new tab parameter
    const params = new URLSearchParams(searchParams);
    params.set("tab", tab);
    router.push(`/billing?${params.toString()}`, { scroll: false });
  };

  // Handle successful payment - refresh billing data
  const handlePaymentSuccess = () => {
    setRefreshKey((prev) => prev + 1);
  };

  return (
    <div style={{ padding: "15px" }}>
      {/* Page Header - Lambda.ai style */}
      <h1
        style={{
          fontFamily: "var(--font-sans)",
          fontSize: "2rem",
          fontWeight: 600,
          lineHeight: "2.5rem",
          color: "var(--fgColor-default)",
          letterSpacing: "-0.02em",
          margin: 0,
        }}
      >
        {isMentor ? "Billing & Earnings" : "Billing & Credits"}
      </h1>

      {/* Subheading */}
      <p
        style={{
          fontFamily: "var(--font-sans)",
          fontSize: "0.875rem",
          color: "var(--fgColor-muted)",
          margin: "8px 0 0 0",
          lineHeight: "1.5",
        }}
      >
        {isMentor
          ? "Track your earnings, sessions, and payment history"
          : "Manage your credits, track usage, and view payment history"}
      </p>

      {/* Tabs - conditional based on role */}
      {isMentor ? (
        <MentorBillingTabs
          activeTab={currentTab as MentorBillingTab}
          onTabChange={(tab) => handleTabChange(tab)}
          onAddCreditsClick={() => setIsAddCreditsOpen(true)}
        />
      ) : (
        <BillingTabs
          activeTab={currentTab as BillingTab}
          onTabChange={(tab) => handleTabChange(tab)}
          onAddCreditsClick={() => setIsAddCreditsOpen(true)}
        />
      )}

      {/* Tab Content */}
      <div style={{ marginTop: "24px" }}>
        {isMentor ? (
          <>
            {currentTab === "overview" && <MentorBillingOverview key={refreshKey} />}
            {currentTab === "history" && <PaymentHistoryTab />}
          </>
        ) : (
          <>
            {currentTab === "usage" && <BillingTabContent key={refreshKey} user={null} />}
            {currentTab === "history" && <PaymentHistoryTab />}
          </>
        )}
      </div>

      {/* Add Credits Modal */}
      <AddCreditsModal
        isOpen={isAddCreditsOpen}
        onClose={() => setIsAddCreditsOpen(false)}
        onSuccess={handlePaymentSuccess}
      />
    </div>
  );
}
