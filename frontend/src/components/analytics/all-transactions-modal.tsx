"use client";

import { useEffect, useMemo, useState } from "react";
import * as DialogPrimitive from "@radix-ui/react-dialog";
import { X, Download, Search } from "lucide-react";
import { getAnalyticsAccessToken } from "@/lib/token";

const API_BASE = process.env.NEXT_PUBLIC_API_URL || "";

interface AllTransactionsModalProps {
  isOpen: boolean;
  onClose: () => void;
  clientId?: string;
}

interface Transaction {
  id: string;
  status: string;
  createdAt: string;
  userEmail: string | null;
  userName: string | null;
  amountCents: number;
  walletBalanceCents: number | null;
  invoiceNumber?: string | null;
}

interface KpiSummary {
  totalTransactions: number;
  totalVolume: number;
  failedOrPending: number;
  avgTransactionSize: number;
}

interface TransactionsResponse {
  transactions: Transaction[];
  total: number;
  totalPages: number;
  page: number;
  limit: number;
  kpiSummary: KpiSummary;
}

const PAGE_SIZE = 15;

function formatISTDateTime(isoString: string): string {
  if (!isoString) return "—";
  const d = new Date(isoString);
  if (Number.isNaN(d.getTime())) return "—";
  return d.toLocaleString("en-IN", {
    timeZone: "Asia/Kolkata",
    day: "numeric",
    month: "short",
    year: "numeric",
    hour: "numeric",
    minute: "2-digit",
    hour12: true,
  });
}

function formatINR(value: number | null | undefined): string {
  if (value === null || value === undefined || Number.isNaN(value)) return "—";
  try {
    return `₹${Number(value).toLocaleString("en-IN", {
      maximumFractionDigits: 2,
      minimumFractionDigits: 0,
    })}`;
  } catch {
    return `₹${value}`;
  }
}

function getStatusVisual(status: string): { color: string; label: string } {
  const s = (status || "").toLowerCase();
  if (s === "completed" || s === "paid" || s === "success" || s === "succeeded") {
    return { color: "#22c55e", label: "Paid" };
  }
  if (s === "pending" || s === "processing" || s === "initiated") {
    return { color: "#f59e0b", label: "Pending" };
  }
  if (s === "failed" || s === "error" || s === "cancelled" || s === "canceled") {
    return { color: "#ef4444", label: "Failed" };
  }
  return { color: "#a1a1aa", label: status || "—" };
}

export function AllTransactionsModal({ isOpen, onClose, clientId }: AllTransactionsModalProps) {
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState("");
  const [debouncedSearch, setDebouncedSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");

  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [total, setTotal] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const [kpiSummary, setKpiSummary] = useState<KpiSummary | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [downloadingId, setDownloadingId] = useState<string | null>(null);

  // Reset state on close
  useEffect(() => {
    if (!isOpen) {
      setPage(1);
      setSearch("");
      setDebouncedSearch("");
      setStatusFilter("all");
      setStartDate("");
      setEndDate("");
      setTransactions([]);
      setTotal(0);
      setTotalPages(0);
      setKpiSummary(null);
      setIsLoading(false);
    }
  }, [isOpen]);

  // Debounce search
  useEffect(() => {
    const t = setTimeout(() => setDebouncedSearch(search), 300);
    return () => clearTimeout(t);
  }, [search]);

  // Reset page when any filter changes
  useEffect(() => {
    setPage(1);
  }, [debouncedSearch, statusFilter, startDate, endDate]);

  // Fetch when needed
  useEffect(() => {
    if (!isOpen) return;
    let cancelled = false;

    const fetchTransactions = async () => {
      const token = getAnalyticsAccessToken();
      if (!token) return;

      setIsLoading(true);
      try {
        const params = new URLSearchParams();
        params.set("page", String(page));
        params.set("limit", String(PAGE_SIZE));
        if (debouncedSearch) params.set("search", debouncedSearch);
        if (statusFilter && statusFilter !== "all") params.set("status", statusFilter);
        if (startDate) params.set("startDate", startDate);
        if (endDate) params.set("endDate", endDate);
        if (clientId) params.set("clientId", clientId);

        const res = await fetch(
          `${API_BASE}/api/dashboard/analytics/all-transactions?${params.toString()}`,
          { headers: { Authorization: `Bearer ${token}` } }
        );
        if (!res.ok) {
          if (!cancelled) {
            setTransactions([]);
            setTotal(0);
            setTotalPages(0);
            setKpiSummary(null);
          }
          return;
        }
        const data: TransactionsResponse = await res.json();
        if (cancelled) return;
        setTransactions(Array.isArray(data.transactions) ? data.transactions : []);
        setTotal(data.total ?? 0);
        setTotalPages(data.totalPages ?? 0);
        setKpiSummary(data.kpiSummary ?? null);
      } catch {
        if (!cancelled) {
          setTransactions([]);
          setTotal(0);
          setTotalPages(0);
          setKpiSummary(null);
        }
      } finally {
        if (!cancelled) setIsLoading(false);
      }
    };

    fetchTransactions();
    return () => {
      cancelled = true;
    };
  }, [isOpen, page, debouncedSearch, statusFilter, startDate, endDate, clientId]);

  const handleDownload = async (txn: Transaction) => {
    const token = getAnalyticsAccessToken();
    if (!token) return;
    setDownloadingId(txn.id);
    try {
      const res = await fetch(
        `${API_BASE}/api/dashboard/analytics/invoice/${txn.id}/download`,
        { headers: { Authorization: `Bearer ${token}` } }
      );
      if (!res.ok) return;
      const blob = await res.blob();
      const url = URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url;
      a.download = txn.invoiceNumber
        ? `${txn.invoiceNumber}.pdf`
        : `invoice-${txn.id.slice(0, 8)}.pdf`;
      document.body.appendChild(a);
      a.click();
      a.remove();
      URL.revokeObjectURL(url);
    } catch {
      // swallow
    } finally {
      setDownloadingId(null);
    }
  };

  const rangeStart = useMemo(() => (total === 0 ? 0 : (page - 1) * PAGE_SIZE + 1), [page, total]);
  const rangeEnd = useMemo(
    () => Math.min(page * PAGE_SIZE, total),
    [page, total]
  );

  const failedPendingColor = (() => {
    const v = kpiSummary?.failedOrPending ?? 0;
    if (v === 0) return "#22c55e";
    if (v <= 5) return "#f59e0b";
    return "#ef4444";
  })();

  return (
    <DialogPrimitive.Root open={isOpen} onOpenChange={(open) => !open && onClose()}>
      <DialogPrimitive.Portal>
        <DialogPrimitive.Overlay
          className="fixed inset-0 z-50"
          style={{
            backgroundColor: "rgba(11, 11, 11, 0.5)",
            backdropFilter: "blur(6px)",
            WebkitBackdropFilter: "blur(6px)",
          }}
        />

        <DialogPrimitive.Content
          className="fixed left-[50%] top-[50%] z-50 translate-x-[-50%] translate-y-[-50%]"
          style={{
            width: "calc(100% - 48px)",
            maxWidth: "1100px",
            maxHeight: "90vh",
            backgroundColor: "#0a0a0a",
            border: "1px solid #262626",
            borderRadius: "12px",
            display: "flex",
            flexDirection: "column",
            fontFamily:
              "ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, sans-serif",
            color: "#e4e4e7",
          }}
        >
          {/* Header */}
          <div
            className="flex items-center justify-between"
            style={{
              padding: "16px 20px",
              borderBottom: "1px solid #262626",
            }}
          >
            <DialogPrimitive.Title
              className="text-white font-semibold text-lg"
              style={{ margin: 0 }}
            >
              All Transactions
            </DialogPrimitive.Title>
            <DialogPrimitive.Close asChild>
              <button
                type="button"
                title="Close"
                className="flex items-center justify-center rounded-md text-zinc-400 hover:text-white"
                style={{
                  width: 32,
                  height: 32,
                  background: "transparent",
                  border: "none",
                  cursor: "pointer",
                  transition: "all 0.15s ease",
                }}
                onMouseEnter={(e) => {
                  e.currentTarget.style.backgroundColor = "#1a1a1a";
                }}
                onMouseLeave={(e) => {
                  e.currentTarget.style.backgroundColor = "transparent";
                }}
              >
                <X size={18} strokeWidth={1.75} />
              </button>
            </DialogPrimitive.Close>
          </div>

          {/* Filters Row */}
          <div
            className="flex items-center gap-3"
            style={{
              padding: "14px 20px",
              borderBottom: "1px solid #262626",
            }}
          >
            <div className="relative flex-1">
              <span
                className="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-500 pointer-events-none"
                aria-hidden
              >
                <Search size={14} strokeWidth={1.75} />
              </span>
              <input
                type="text"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                placeholder="Search by email, name, or invoice..."
                className="w-full text-sm text-white placeholder:text-zinc-500 outline-none"
                style={{
                  backgroundColor: "#141414",
                  border: "1px solid #3f3f46",
                  borderRadius: "8px",
                  height: "36px",
                  padding: "0 12px 0 32px",
                  transition: "border-color 0.15s ease",
                }}
                onFocus={(e) => {
                  e.currentTarget.style.borderColor = "#71717a";
                }}
                onBlur={(e) => {
                  e.currentTarget.style.borderColor = "#3f3f46";
                }}
              />
            </div>

            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              className="text-sm text-white outline-none"
              style={{
                backgroundColor: "#141414",
                border: "1px solid #3f3f46",
                borderRadius: "8px",
                height: "36px",
                padding: "0 28px 0 12px",
                cursor: "pointer",
                appearance: "none",
                backgroundImage:
                  "url(\"data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%2371717a' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><polyline points='6 9 12 15 18 9'/></svg>\")",
                backgroundRepeat: "no-repeat",
                backgroundPosition: "right 10px center",
              }}
            >
              <option value="all">All Statuses</option>
              <option value="paid">Paid</option>
              <option value="pending">Pending</option>
              <option value="failed">Failed</option>
            </select>

            <input
              type="date"
              value={startDate}
              onChange={(e) => setStartDate(e.target.value)}
              aria-label="From date"
              className="text-sm text-white outline-none"
              style={{
                backgroundColor: "#141414",
                border: "1px solid #3f3f46",
                borderRadius: "8px",
                height: "36px",
                padding: "0 10px",
                colorScheme: "dark",
              }}
            />
            <input
              type="date"
              value={endDate}
              onChange={(e) => setEndDate(e.target.value)}
              aria-label="To date"
              className="text-sm text-white outline-none"
              style={{
                backgroundColor: "#141414",
                border: "1px solid #3f3f46",
                borderRadius: "8px",
                height: "36px",
                padding: "0 10px",
                colorScheme: "dark",
              }}
            />
          </div>

          {/* KPI Insights */}
          <div
            className="grid grid-cols-4 gap-3"
            style={{ padding: "16px 20px 0 20px" }}
          >
            <div
              className="rounded-lg p-4"
              style={{ backgroundColor: "#141414", border: "1px solid #27272a" }}
            >
              <div className="text-[10px] uppercase tracking-wider text-zinc-500 font-medium">
                Total Transactions
              </div>
              <div className="text-xl font-bold text-white mt-1.5">
                {kpiSummary ? kpiSummary.totalTransactions.toLocaleString("en-IN") : "—"}
              </div>
            </div>
            <div
              className="rounded-lg p-4"
              style={{ backgroundColor: "#141414", border: "1px solid #27272a" }}
            >
              <div className="text-[10px] uppercase tracking-wider text-zinc-500 font-medium">
                Total Volume
              </div>
              <div
                className="text-xl font-bold text-white mt-1.5"
                style={{ fontFamily: "ui-monospace, SFMono-Regular, Menlo, monospace" }}
              >
                {kpiSummary ? formatINR(kpiSummary.totalVolume / 100) : "—"}
              </div>
            </div>
            <div
              className="rounded-lg p-4"
              style={{ backgroundColor: "#141414", border: "1px solid #27272a" }}
            >
              <div className="text-[10px] uppercase tracking-wider text-zinc-500 font-medium">
                Failed / Pending
              </div>
              <div
                className="text-xl font-bold mt-1.5"
                style={{ color: failedPendingColor }}
              >
                {kpiSummary ? kpiSummary.failedOrPending.toLocaleString("en-IN") : "—"}
              </div>
            </div>
            <div
              className="rounded-lg p-4"
              style={{ backgroundColor: "#141414", border: "1px solid #27272a" }}
            >
              <div className="text-[10px] uppercase tracking-wider text-zinc-500 font-medium">
                Avg. Size
              </div>
              <div
                className="text-xl font-bold text-white mt-1.5"
                style={{ fontFamily: "ui-monospace, SFMono-Regular, Menlo, monospace" }}
              >
                {kpiSummary ? formatINR(kpiSummary.avgTransactionSize / 100) : "—"}
              </div>
            </div>
          </div>

          {/* Table */}
          <div
            className="flex-1 overflow-auto"
            style={{ padding: "16px 20px 0 20px", minHeight: 0 }}
          >
            <div
              className="rounded-lg overflow-hidden"
              style={{ border: "1px solid #27272a", backgroundColor: "#0d0d0d" }}
            >
              <table className="w-full" style={{ borderCollapse: "collapse" }}>
                <thead>
                  <tr
                    style={{
                      position: "sticky",
                      top: 0,
                      backgroundColor: "#141414",
                      zIndex: 1,
                    }}
                  >
                    <th
                      className="text-[10px] uppercase tracking-wider text-zinc-500 font-medium text-left"
                      style={{ padding: "10px 14px", borderBottom: "1px solid #27272a" }}
                    >
                      Status
                    </th>
                    <th
                      className="text-[10px] uppercase tracking-wider text-zinc-500 font-medium text-left"
                      style={{ padding: "10px 14px", borderBottom: "1px solid #27272a" }}
                    >
                      Date &amp; Time
                    </th>
                    <th
                      className="text-[10px] uppercase tracking-wider text-zinc-500 font-medium text-left"
                      style={{ padding: "10px 14px", borderBottom: "1px solid #27272a" }}
                    >
                      User Email
                    </th>
                    <th
                      className="text-[10px] uppercase tracking-wider text-zinc-500 font-medium text-left"
                      style={{ padding: "10px 14px", borderBottom: "1px solid #27272a" }}
                    >
                      User Name
                    </th>
                    <th
                      className="text-[10px] uppercase tracking-wider text-zinc-500 font-medium text-right"
                      style={{ padding: "10px 14px", borderBottom: "1px solid #27272a" }}
                    >
                      Amount
                    </th>
                    <th
                      className="text-[10px] uppercase tracking-wider text-zinc-500 font-medium text-right"
                      style={{ padding: "10px 14px", borderBottom: "1px solid #27272a" }}
                    >
                      Wallet Bal.
                    </th>
                    <th
                      className="text-[10px] uppercase tracking-wider text-zinc-500 font-medium text-center"
                      style={{ padding: "10px 14px", borderBottom: "1px solid #27272a" }}
                    >
                      Action
                    </th>
                  </tr>
                </thead>
                <tbody>
                  {isLoading ? (
                    Array.from({ length: 6 }).map((_, i) => (
                      <tr
                        key={`skeleton-${i}`}
                        style={{ borderBottom: "1px solid rgba(39,39,42,0.5)" }}
                      >
                        {Array.from({ length: 7 }).map((__, j) => (
                          <td
                            key={`s-${i}-${j}`}
                            style={{ padding: "12px 14px" }}
                          >
                            <div
                              className="animate-pulse rounded"
                              style={{
                                height: 12,
                                width: j === 0 ? 60 : j === 6 ? 24 : "80%",
                                backgroundColor: "#1a1a1a",
                              }}
                            />
                          </td>
                        ))}
                      </tr>
                    ))
                  ) : transactions.length === 0 ? (
                    <tr>
                      <td
                        colSpan={7}
                        className="text-center text-sm text-zinc-500"
                        style={{ padding: "48px 14px" }}
                      >
                        No transactions found
                      </td>
                    </tr>
                  ) : (
                    transactions.map((txn) => {
                      const visual = getStatusVisual(txn.status);
                      const status = (txn.status || "").toLowerCase();
                      const canDownload =
                        (status === "completed" ||
                          status === "paid" ||
                          status === "success" ||
                          status === "succeeded") &&
                        Boolean(txn.invoiceNumber);
                      return (
                        <tr
                          key={txn.id}
                          style={{
                            borderBottom: "1px solid rgba(39,39,42,0.5)",
                            transition: "background-color 0.15s ease",
                          }}
                          onMouseEnter={(e) => {
                            e.currentTarget.style.backgroundColor = "#1a1a1a";
                          }}
                          onMouseLeave={(e) => {
                            e.currentTarget.style.backgroundColor = "transparent";
                          }}
                        >
                          <td style={{ padding: "12px 14px" }}>
                            <div className="flex items-center gap-2">
                              <span
                                style={{
                                  display: "inline-block",
                                  width: 6,
                                  height: 6,
                                  borderRadius: "9999px",
                                  backgroundColor: visual.color,
                                  boxShadow: `0 0 0 2px ${visual.color}22`,
                                }}
                              />
                              <span
                                className="text-xs"
                                style={{ color: visual.color, fontWeight: 500 }}
                              >
                                {visual.label}
                              </span>
                            </div>
                          </td>
                          <td
                            className="text-xs text-zinc-300 whitespace-nowrap"
                            style={{ padding: "12px 14px" }}
                          >
                            {formatISTDateTime(txn.createdAt)}
                          </td>
                          <td
                            className="text-xs text-zinc-300"
                            style={{
                              padding: "12px 14px",
                              maxWidth: 220,
                              overflow: "hidden",
                              textOverflow: "ellipsis",
                              whiteSpace: "nowrap",
                            }}
                            title={txn.userEmail || ""}
                          >
                            {txn.userEmail || "—"}
                          </td>
                          <td
                            className="text-xs text-zinc-300"
                            style={{
                              padding: "12px 14px",
                              maxWidth: 180,
                              overflow: "hidden",
                              textOverflow: "ellipsis",
                              whiteSpace: "nowrap",
                            }}
                            title={txn.userName || ""}
                          >
                            {txn.userName || "—"}
                          </td>
                          <td
                            className="text-right text-xs font-medium text-white whitespace-nowrap"
                            style={{
                              padding: "12px 14px",
                              fontFamily:
                                "ui-monospace, SFMono-Regular, Menlo, monospace",
                            }}
                          >
                            {formatINR(txn.amountCents / 100)}
                          </td>
                          <td
                            className="text-right text-xs text-zinc-400 whitespace-nowrap"
                            style={{
                              padding: "12px 14px",
                              fontFamily:
                                "ui-monospace, SFMono-Regular, Menlo, monospace",
                            }}
                          >
                            {formatINR(txn.walletBalanceCents != null ? txn.walletBalanceCents / 100 : null)}
                          </td>
                          <td
                            className="text-center"
                            style={{ padding: "8px 14px" }}
                          >
                            <button
                              type="button"
                              disabled={!canDownload || downloadingId === txn.id}
                              onClick={() => canDownload && handleDownload(txn)}
                              title={
                                canDownload
                                  ? "Download invoice"
                                  : "Invoice unavailable"
                              }
                              className="inline-flex items-center justify-center rounded-md"
                              style={{
                                width: 28,
                                height: 28,
                                backgroundColor: canDownload
                                  ? "#1a1a1a"
                                  : "transparent",
                                border: "1px solid #27272a",
                                color: canDownload ? "#e4e4e7" : "#52525b",
                                cursor: canDownload ? "pointer" : "not-allowed",
                                opacity: downloadingId === txn.id ? 0.6 : 1,
                                transition: "all 0.15s ease",
                              }}
                              onMouseEnter={(e) => {
                                if (canDownload) {
                                  e.currentTarget.style.backgroundColor =
                                    "#262626";
                                  e.currentTarget.style.color = "#ffffff";
                                }
                              }}
                              onMouseLeave={(e) => {
                                if (canDownload) {
                                  e.currentTarget.style.backgroundColor =
                                    "#1a1a1a";
                                  e.currentTarget.style.color = "#e4e4e7";
                                }
                              }}
                            >
                              <Download size={13} strokeWidth={1.75} />
                            </button>
                          </td>
                        </tr>
                      );
                    })
                  )}
                </tbody>
              </table>
            </div>
          </div>

          {/* Pagination Footer */}
          <div
            className="flex items-center justify-between"
            style={{
              padding: "14px 20px",
              borderTop: "1px solid #262626",
              marginTop: 16,
            }}
          >
            <div className="text-xs text-zinc-500">
              {total > 0
                ? `Showing ${rangeStart}–${rangeEnd} of ${total.toLocaleString("en-IN")}`
                : "Showing 0 of 0"}
            </div>
            <div className="flex items-center gap-2">
              <button
                type="button"
                disabled={page <= 1 || isLoading}
                onClick={() => setPage((p) => Math.max(1, p - 1))}
                className="rounded text-zinc-300"
                style={{
                  padding: "4px 10px",
                  fontSize: 11,
                  border: "1px solid #27272a",
                  backgroundColor: "#1a1a1a",
                  cursor: page <= 1 || isLoading ? "not-allowed" : "pointer",
                  opacity: page <= 1 || isLoading ? 0.5 : 1,
                  transition: "all 0.15s ease",
                }}
                onMouseEnter={(e) => {
                  if (page > 1 && !isLoading) {
                    e.currentTarget.style.backgroundColor = "#262626";
                  }
                }}
                onMouseLeave={(e) => {
                  e.currentTarget.style.backgroundColor = "#1a1a1a";
                }}
              >
                Previous
              </button>
              <button
                type="button"
                disabled={page >= totalPages || totalPages === 0 || isLoading}
                onClick={() => setPage((p) => Math.min(totalPages || 1, p + 1))}
                className="rounded text-zinc-300"
                style={{
                  padding: "4px 10px",
                  fontSize: 11,
                  border: "1px solid #27272a",
                  backgroundColor: "#1a1a1a",
                  cursor:
                    page >= totalPages || totalPages === 0 || isLoading
                      ? "not-allowed"
                      : "pointer",
                  opacity:
                    page >= totalPages || totalPages === 0 || isLoading ? 0.5 : 1,
                  transition: "all 0.15s ease",
                }}
                onMouseEnter={(e) => {
                  if (page < totalPages && !isLoading) {
                    e.currentTarget.style.backgroundColor = "#262626";
                  }
                }}
                onMouseLeave={(e) => {
                  e.currentTarget.style.backgroundColor = "#1a1a1a";
                }}
              >
                Next
              </button>
            </div>
          </div>
        </DialogPrimitive.Content>
      </DialogPrimitive.Portal>
    </DialogPrimitive.Root>
  );
}
