"use client";

import { useState, useEffect } from "react";
import { getWithdrawableBalance, requestWithdrawal } from "@/lib/api";

interface WithdrawModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: () => void;
}

const PRESET_AMOUNTS = [500, 1000, 2500, 5000];
const MIN_AMOUNT = 10; // Rs 10 minimum
const PLATFORM_FEE_RATE = 0.20;

type ModalStep = "amount" | "bank" | "processing" | "success" | "failed";

export function WithdrawModal({ isOpen, onClose, onSuccess }: WithdrawModalProps) {
  const [step, setStep] = useState<ModalStep>("amount");
  const [availableBalance, setAvailableBalance] = useState<number>(0);
  const [balanceLoading, setBalanceLoading] = useState(true);
  const [selectedPreset, setSelectedPreset] = useState<number | null>(null);
  const [customAmount, setCustomAmount] = useState<string>("");
  const [error, setError] = useState<string | null>(null);

  // Bank details
  const [accountHolderName, setAccountHolderName] = useState("");
  const [accountNumber, setAccountNumber] = useState("");
  const [confirmAccountNumber, setConfirmAccountNumber] = useState("");
  const [ifscCode, setIfscCode] = useState("");

  // Fetch balance on open
  useEffect(() => {
    if (isOpen) {
      setStep("amount");
      setSelectedPreset(null);
      setCustomAmount("");
      setError(null);
      setAccountHolderName("");
      setAccountNumber("");
      setConfirmAccountNumber("");
      setIfscCode("");
      setBalanceLoading(true);
      getWithdrawableBalance()
        .then((data) => setAvailableBalance(data?.balanceCents ?? 0))
        .finally(() => setBalanceLoading(false));
    }
  }, [isOpen]);

  // Current amount in Rs
  const currentAmountRs = selectedPreset ?? (customAmount ? parseInt(customAmount, 10) : 0);
  const currentAmountCents = currentAmountRs * 100;
  const platformFeeCents = Math.round(currentAmountCents * PLATFORM_FEE_RATE);
  const netPayoutCents = currentAmountCents - platformFeeCents;

  // Validation
  const isValidAmount = currentAmountRs >= MIN_AMOUNT && currentAmountCents <= availableBalance;
  const showMinError = customAmount !== "" && currentAmountRs < MIN_AMOUNT && currentAmountRs > 0;
  const showMaxError = currentAmountCents > availableBalance && availableBalance > 0;

  // Bank validation
  const ifscValid = /^[A-Z]{4}0[A-Z0-9]{6}$/.test(ifscCode);
  const accountMatch = accountNumber.length >= 9 && accountNumber === confirmAccountNumber;
  const bankValid = accountHolderName.length >= 3 && accountMatch && ifscValid;

  const handlePresetClick = (amount: number) => {
    setSelectedPreset(amount);
    setCustomAmount(amount.toString());
    setError(null);
  };

  const handleCustomAmountChange = (value: string) => {
    const numericValue = value.replace(/[^0-9]/g, "");
    setCustomAmount(numericValue);
    setSelectedPreset(null);
    setError(null);
  };

  const handleContinue = () => {
    if (isValidAmount) setStep("bank");
  };

  const handleConfirmWithdrawal = async () => {
    if (!bankValid || !isValidAmount) return;
    setStep("processing");
    setError(null);

    try {
      const result = await requestWithdrawal(currentAmountCents, accountNumber, ifscCode, accountHolderName);
      if (result.success) {
        setStep("success");
        onSuccess();
      } else {
        setError(result.error || "Withdrawal failed");
        setStep("failed");
      }
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Withdrawal request failed");
      setStep("failed");
    }
  };

  const handleBackdropClick = (e: React.MouseEvent) => {
    if (e.target === e.currentTarget && step !== "processing") onClose();
  };

  if (!isOpen) return null;

  const formatRs = (cents: number) => `₹${(cents / 100).toLocaleString("en-IN", { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;

  // Shared input style
  const inputStyle = {
    width: "100%",
    padding: "0 12px",
    height: "40px",
    border: "1px solid var(--borderColor-default)",
    borderRadius: "4px",
    backgroundColor: "var(--bgColor-muted)",
    fontFamily: "var(--font-sans)",
    fontSize: "0.875rem",
    color: "var(--fgColor-default)",
    outline: "none",
    boxSizing: "border-box" as const,
  };

  const labelStyle = {
    display: "block",
    fontFamily: "var(--font-sans)",
    fontSize: "0.75rem",
    fontWeight: 500,
    color: "var(--fgColor-default)",
    marginBottom: "6px",
  };

  return (
    <div
      onClick={handleBackdropClick}
      style={{
        position: "fixed",
        top: 0, left: 0, right: 0, bottom: 0,
        backgroundColor: "rgba(11, 11, 11, 0.7)",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        zIndex: 1000,
      }}
    >
      <div
        style={{
          backgroundColor: "var(--bgColor-mild)",
          border: "1px solid var(--borderColor-default)",
          borderRadius: "4px",
          width: "100%",
          maxWidth: "420px",
          margin: "16px",
          overflow: "hidden",
        }}
      >
        {/* Header */}
        <div style={{ padding: "24px 24px 0 24px" }}>
          <h2 style={{ fontFamily: "var(--font-sans)", fontSize: "1.25rem", fontWeight: 600, color: "var(--fgColor-default)", margin: 0, marginBottom: "8px" }}>
            Withdraw Funds
          </h2>
          <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.875rem", color: "var(--fgColor-muted)", margin: 0, lineHeight: 1.5 }}>
            Transfer earnings to your bank account.
          </p>
        </div>

        <div style={{ height: "1px", backgroundColor: "var(--borderColor-default)", margin: "20px 0" }} />

        {/* Step 1: Amount */}
        {step === "amount" && (
          <div style={{ padding: "0 24px" }}>
            {/* Available Balance */}
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "16px" }}>
              <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", fontWeight: 500, color: "var(--fgColor-muted)", textTransform: "uppercase", letterSpacing: "0.05em" }}>
                Available Balance
              </span>
              <span style={{ fontFamily: "var(--font-sans)", fontSize: "1rem", fontWeight: 600, color: "var(--fgColor-default)" }}>
                {balanceLoading ? "..." : formatRs(availableBalance)}
              </span>
            </div>

            {/* Preset Amounts */}
            <div style={{ display: "flex", gap: "8px", marginBottom: "16px", flexWrap: "wrap" }}>
              {PRESET_AMOUNTS.map((amount) => {
                const isSelected = selectedPreset === amount;
                const isDisabled = amount * 100 > availableBalance;
                return (
                  <button
                    key={amount}
                    onClick={() => !isDisabled && handlePresetClick(amount)}
                    disabled={isDisabled}
                    style={{
                      padding: "8px 16px",
                      borderRadius: "4px",
                      border: isSelected ? "1px solid #C8AA6E" : "1px solid var(--borderColor-default)",
                      backgroundColor: isSelected ? "rgba(200, 170, 110, 0.15)" : "transparent",
                      color: isSelected ? "#C8AA6E" : isDisabled ? "var(--fgColor-muted)" : "var(--fgColor-default)",
                      fontFamily: "var(--font-sans)",
                      fontSize: "0.875rem",
                      fontWeight: 500,
                      cursor: isDisabled ? "not-allowed" : "pointer",
                      opacity: isDisabled ? 0.5 : 1,
                    }}
                  >
                    ₹{amount}
                  </button>
                );
              })}
            </div>

            {/* Custom Amount */}
            <label style={labelStyle}>Custom Amount</label>
            <div style={{ display: "flex", alignItems: "center", backgroundColor: "var(--bgColor-muted)", border: `1px solid ${showMinError || showMaxError ? "#FF6742" : "var(--borderColor-default)"}`, borderRadius: "4px", overflow: "hidden", marginBottom: "12px" }}>
              <span style={{ padding: "0 12px", fontSize: "0.875rem", color: "var(--fgColor-muted)", borderRight: "1px solid var(--borderColor-default)", height: "40px", display: "flex", alignItems: "center" }}>₹</span>
              <input
                type="text"
                inputMode="numeric"
                value={customAmount}
                onChange={(e) => handleCustomAmountChange(e.target.value)}
                placeholder="100"
                style={{ flex: 1, padding: "0 12px", height: "40px", border: "none", outline: "none", backgroundColor: "transparent", fontFamily: "var(--font-sans)", fontSize: "0.875rem", color: "var(--fgColor-default)" }}
              />
            </div>

            {/* Validation */}
            {showMinError && <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", color: "#FF6742", margin: "0 0 8px" }}>Minimum withdrawal is ₹{MIN_AMOUNT}</p>}
            {showMaxError && <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", color: "#FF6742", margin: "0 0 8px" }}>Insufficient balance</p>}

            {/* Fee Breakdown */}
            {currentAmountRs >= MIN_AMOUNT && (
              <div style={{ backgroundColor: "var(--bgColor-muted)", border: "1px solid var(--borderColor-default)", borderRadius: "4px", padding: "12px", marginBottom: "12px" }}>
                <div style={{ display: "flex", justifyContent: "space-between", marginBottom: "6px" }}>
                  <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)" }}>Withdrawal amount</span>
                  <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-default)" }}>{formatRs(currentAmountCents)}</span>
                </div>
                <div style={{ display: "flex", justifyContent: "space-between", marginBottom: "8px" }}>
                  <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)" }}>Platform fee (20%)</span>
                  <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "#FF6742" }}>- {formatRs(platformFeeCents)}</span>
                </div>
                <div style={{ height: "1px", backgroundColor: "var(--borderColor-default)", marginBottom: "8px" }} />
                <div style={{ display: "flex", justifyContent: "space-between" }}>
                  <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.875rem", fontWeight: 600, color: "var(--fgColor-default)" }}>You receive</span>
                  <span style={{ fontFamily: "var(--font-sans)", fontSize: "0.875rem", fontWeight: 600, color: "#4ade80" }}>{formatRs(netPayoutCents)}</span>
                </div>
              </div>
            )}

            {error && <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", color: "#FF6742", margin: "0 0 12px", padding: "8px 12px", backgroundColor: "rgba(255, 103, 66, 0.1)", borderRadius: "4px" }}>{error}</p>}
          </div>
        )}

        {/* Step 2: Bank Details */}
        {step === "bank" && (
          <div style={{ padding: "0 24px" }}>
            <h3 style={{ fontFamily: "var(--font-sans)", fontSize: "0.875rem", fontWeight: 600, color: "var(--fgColor-default)", margin: "0 0 16px" }}>Bank Account Details</h3>

            <div style={{ display: "flex", flexDirection: "column", gap: "12px" }}>
              <div>
                <label style={labelStyle}>Account Holder Name</label>
                <input type="text" value={accountHolderName} onChange={(e) => setAccountHolderName(e.target.value)} placeholder="As per bank records" style={inputStyle} />
              </div>
              <div>
                <label style={labelStyle}>Account Number</label>
                <input type="text" inputMode="numeric" value={accountNumber} onChange={(e) => setAccountNumber(e.target.value.replace(/[^0-9]/g, ""))} placeholder="Bank account number" style={inputStyle} />
              </div>
              <div>
                <label style={labelStyle}>Confirm Account Number</label>
                <input
                  type="text"
                  inputMode="numeric"
                  value={confirmAccountNumber}
                  onChange={(e) => setConfirmAccountNumber(e.target.value.replace(/[^0-9]/g, ""))}
                  placeholder="Re-enter account number"
                  style={{ ...inputStyle, borderColor: confirmAccountNumber && accountNumber !== confirmAccountNumber ? "#FF6742" : "var(--borderColor-default)" }}
                />
                {confirmAccountNumber && accountNumber !== confirmAccountNumber && (
                  <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.7rem", color: "#FF6742", margin: "4px 0 0" }}>Account numbers do not match</p>
                )}
              </div>
              <div>
                <label style={labelStyle}>IFSC Code</label>
                <input
                  type="text"
                  value={ifscCode.toUpperCase()}
                  onChange={(e) => setIfscCode(e.target.value.toUpperCase())}
                  placeholder="e.g. SBIN0001234"
                  style={{ ...inputStyle, borderColor: ifscCode && !ifscValid ? "#FF6742" : "var(--borderColor-default)" }}
                />
                {ifscCode && !ifscValid && (
                  <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.7rem", color: "#FF6742", margin: "4px 0 0" }}>Invalid IFSC format (e.g. SBIN0001234)</p>
                )}
              </div>
            </div>

            {error && <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.75rem", color: "#FF6742", margin: "12px 0 0", padding: "8px 12px", backgroundColor: "rgba(255, 103, 66, 0.1)", borderRadius: "4px" }}>{error}</p>}
          </div>
        )}

        {/* Processing State */}
        {step === "processing" && (
          <div style={{ padding: "0 24px", textAlign: "center" }}>
            <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.875rem", color: "var(--fgColor-muted)" }}>Processing withdrawal...</p>
          </div>
        )}

        {/* Success State */}
        {step === "success" && (
          <div style={{ padding: "0 24px", textAlign: "center" }}>
            <div style={{ width: "48px", height: "48px", borderRadius: "50%", backgroundColor: "rgba(74, 222, 128, 0.15)", display: "flex", alignItems: "center", justifyContent: "center", margin: "0 auto 12px" }}>
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#4ade80" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12" /></svg>
            </div>
            <p style={{ fontFamily: "var(--font-sans)", fontSize: "1rem", fontWeight: 600, color: "var(--fgColor-default)", margin: "0 0 8px" }}>Withdrawal Initiated</p>
            <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "var(--fgColor-muted)", margin: 0 }}>
              {formatRs(netPayoutCents)} will be transferred to your bank account within 1-2 business days.
            </p>
          </div>
        )}

        {/* Failed State */}
        {step === "failed" && (
          <div style={{ padding: "0 24px", textAlign: "center" }}>
            <div style={{ width: "48px", height: "48px", borderRadius: "50%", backgroundColor: "rgba(255, 103, 66, 0.15)", display: "flex", alignItems: "center", justifyContent: "center", margin: "0 auto 12px" }}>
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#FF6742" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" /></svg>
            </div>
            <p style={{ fontFamily: "var(--font-sans)", fontSize: "1rem", fontWeight: 600, color: "var(--fgColor-default)", margin: "0 0 8px" }}>Withdrawal Failed</p>
            <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.8125rem", color: "#FF6742", margin: 0 }}>{error}</p>
          </div>
        )}

        {/* Footer */}
        <div style={{ padding: "24px" }}>
          {/* Action Button */}
          {step === "amount" && (
            <button
              onClick={handleContinue}
              disabled={!isValidAmount || balanceLoading}
              style={{
                width: "100%", height: "44px",
                backgroundColor: isValidAmount && !balanceLoading ? "#F0EFE2" : "var(--bgColor-muted)",
                color: isValidAmount && !balanceLoading ? "#0B0B0B" : "var(--fgColor-muted)",
                border: "none", borderRadius: "4px",
                fontFamily: "var(--font-sans)", fontSize: "0.875rem", fontWeight: 600,
                cursor: isValidAmount && !balanceLoading ? "pointer" : "not-allowed",
              }}
            >
              Continue{currentAmountRs > 0 ? ` — ${formatRs(currentAmountCents)}` : ""}
            </button>
          )}

          {step === "bank" && (
            <div style={{ display: "flex", gap: "8px" }}>
              <button
                onClick={() => { setStep("amount"); setError(null); }}
                style={{
                  flex: "0 0 auto", width: "80px", height: "44px",
                  backgroundColor: "transparent", color: "var(--fgColor-default)",
                  border: "1px solid var(--borderColor-default)", borderRadius: "4px",
                  fontFamily: "var(--font-sans)", fontSize: "0.875rem", fontWeight: 500, cursor: "pointer",
                }}
              >
                Back
              </button>
              <button
                onClick={handleConfirmWithdrawal}
                disabled={!bankValid}
                style={{
                  flex: 1, height: "44px",
                  backgroundColor: bankValid ? "#C8AA6E" : "var(--bgColor-muted)",
                  color: bankValid ? "#0B0B0B" : "var(--fgColor-muted)",
                  border: "none", borderRadius: "4px",
                  fontFamily: "var(--font-sans)", fontSize: "0.875rem", fontWeight: 600,
                  cursor: bankValid ? "pointer" : "not-allowed",
                }}
              >
                Confirm Withdrawal — {formatRs(netPayoutCents)}
              </button>
            </div>
          )}

          {(step === "processing") && (
            <button disabled style={{ width: "100%", height: "44px", backgroundColor: "var(--bgColor-muted)", color: "var(--fgColor-muted)", border: "none", borderRadius: "4px", fontFamily: "var(--font-sans)", fontSize: "0.875rem", fontWeight: 600, cursor: "not-allowed" }}>
              Processing...
            </button>
          )}

          {(step === "success" || step === "failed") && (
            <button
              onClick={onClose}
              style={{
                width: "100%", height: "44px",
                backgroundColor: "#F0EFE2", color: "#0B0B0B",
                border: "none", borderRadius: "4px",
                fontFamily: "var(--font-sans)", fontSize: "0.875rem", fontWeight: 600, cursor: "pointer",
              }}
            >
              Close
            </button>
          )}

          {/* Footer Text */}
          <p style={{ fontFamily: "var(--font-sans)", fontSize: "0.6875rem", color: "var(--fgColor-muted)", textAlign: "center", margin: "12px 0 0 0" }}>
            Withdrawals are processed within 1-2 business days. Platform fee is non-refundable.
          </p>
        </div>

        {/* Close button */}
        <button
          onClick={onClose}
          disabled={step === "processing"}
          style={{
            position: "absolute", top: "16px", right: "16px",
            width: "32px", height: "32px",
            display: "flex", alignItems: "center", justifyContent: "center",
            backgroundColor: "transparent", border: "none", borderRadius: "4px",
            cursor: step === "processing" ? "not-allowed" : "pointer",
            color: "var(--fgColor-muted)", opacity: step === "processing" ? 0.5 : 1,
          }}
          aria-label="Close"
        >
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <line x1="18" y1="6" x2="6" y2="18" />
            <line x1="6" y1="6" x2="18" y2="18" />
          </svg>
        </button>
      </div>
    </div>
  );
}
