"use client";

import { useEffect, useRef, useState, useCallback, Suspense } from "react";
import { useSearchParams, useRouter } from "next/navigation";
import Script from "next/script";

// Decode JWT payload (client-side, no verification — just reads claims)
function decodeJwtPayload(token: string): Record<string, unknown> | null {
  try {
    const parts = token.split(".");
    if (parts.length !== 3) return null;
    const payload = JSON.parse(atob(parts[1].replace(/-/g, "+").replace(/_/g, "/")));
    return payload;
  } catch {
    return null;
  }
}

function formatCountdown(secondsLeft: number): string {
  if (secondsLeft <= 0) return "00:00";
  const m = Math.floor(secondsLeft / 60);
  const s = secondsLeft % 60;
  return `${String(m).padStart(2, "0")}:${String(s).padStart(2, "0")}`;
}

// Jitsi IFrame API type (minimal)
interface JitsiMeetExternalAPI {
  executeCommand(command: string): void;
  addListener(event: string, handler: () => void): void;
  dispose(): void;
}

declare global {
  interface Window {
    JitsiMeetExternalAPI?: new (
      domain: string,
      options: Record<string, unknown>
    ) => JitsiMeetExternalAPI;
  }
}

function MeetingPageContent() {
  const searchParams = useSearchParams();
  const router = useRouter();
  const containerRef = useRef<HTMLDivElement>(null);
  const apiRef = useRef<JitsiMeetExternalAPI | null>(null);

  const room = searchParams.get("room") || "";
  const jwt = searchParams.get("jwt") || "";
  const baseUrl = searchParams.get("baseUrl") || "https://103.115.236.34";

  const [apiReady, setApiReady] = useState(false);
  const [countdown, setCountdown] = useState("--:--");
  const [expired, setExpired] = useState(false);
  const [secondsLeft, setSecondsLeft] = useState(0);
  const [error, setError] = useState<string | null>(null);

  // Parse expiry from JWT
  const expTimestamp = useRef<number>(0);
  useEffect(() => {
    if (!jwt) {
      setError("Missing JWT parameter. Use the backend API to generate a meeting link.");
      return;
    }
    if (!room) {
      setError("Missing room parameter.");
      return;
    }
    const payload = decodeJwtPayload(jwt);
    if (!payload || typeof payload.exp !== "number") {
      setError("Invalid JWT — cannot read expiry.");
      return;
    }
    expTimestamp.current = payload.exp;
    const remaining = payload.exp - Math.floor(Date.now() / 1000);
    setSecondsLeft(Math.max(0, remaining));
  }, [jwt, room]);

  // Countdown timer
  useEffect(() => {
    if (expTimestamp.current === 0) return;

    const tick = () => {
      const remaining = expTimestamp.current - Math.floor(Date.now() / 1000);
      setSecondsLeft(remaining);
      setCountdown(formatCountdown(remaining));

      if (remaining <= 0) {
        setExpired(true);
        // Force hangup
        if (apiRef.current) {
          try {
            apiRef.current.executeCommand("hangup");
          } catch {
            // already disconnected
          }
          setTimeout(() => {
            apiRef.current?.dispose();
          }, 1000);
        }
      }
    };

    tick();
    const interval = setInterval(tick, 1000);
    return () => clearInterval(interval);
  }, [apiReady]);

  // Initialize Jitsi IFrame API
  const initJitsi = useCallback(() => {
    if (!window.JitsiMeetExternalAPI || !containerRef.current || !room || !jwt) return;

    // Extract domain from baseUrl (strip protocol)
    const domain = baseUrl.replace(/^https?:\/\//, "");

    const api = new window.JitsiMeetExternalAPI(domain, {
      roomName: room,
      jwt: jwt,
      width: "100%",
      height: "100%",
      parentNode: containerRef.current,
      configOverwrite: {
        startWithAudioMuted: false,
        startWithVideoMuted: false,
        disableDeepLinking: true,
        prejoinPageEnabled: false,
      },
      interfaceConfigOverwrite: {
        SHOW_JITSI_WATERMARK: false,
        SHOW_WATERMARK_FOR_GUESTS: false,
        DEFAULT_BACKGROUND: "#0a0a0a",
      },
    });

    apiRef.current = api;
    setApiReady(true);

    api.addListener("readyToClose", () => {
      setExpired(true);
    });
  }, [room, jwt, baseUrl]);

  // Load Jitsi external_api.js then init
  useEffect(() => {
    if (error || expired) return;
    // Script onLoad triggers initJitsi
  }, [error, expired, initJitsi]);

  if (error) {
    return (
      <div style={{ display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", height: "100vh", background: "#0a0a0a", color: "#e4e4e7", fontFamily: "var(--font-outfit, sans-serif)", padding: "2rem" }}>
        <h1 style={{ fontSize: "1.5rem", fontWeight: 600, marginBottom: "1rem" }}>Meeting Error</h1>
        <p style={{ color: "#a1a1aa", maxWidth: 480, textAlign: "center", lineHeight: 1.6 }}>{error}</p>
      </div>
    );
  }

  if (expired) {
    return (
      <div style={{ display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", height: "100vh", background: "#0a0a0a", color: "#e4e4e7", fontFamily: "var(--font-outfit, sans-serif)", gap: "1.5rem" }}>
        <div style={{ width: 64, height: 64, borderRadius: "50%", background: "rgba(239,68,68,0.15)", display: "flex", alignItems: "center", justifyContent: "center" }}>
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#ef4444" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
        </div>
        <h1 style={{ fontSize: "1.5rem", fontWeight: 600 }}>Session Ended</h1>
        <p style={{ color: "#a1a1aa", fontSize: "0.95rem" }}>Your meeting session has ended.</p>
        <button
          onClick={() => router.push("/home")}
          style={{ marginTop: "0.5rem", padding: "10px 24px", borderRadius: "8px", border: "1px solid #333", background: "#18181b", color: "#e4e4e7", fontSize: "0.9rem", cursor: "pointer", fontWeight: 500 }}
        >
          Go Home
        </button>
      </div>
    );
  }

  return (
    <div style={{ position: "relative", width: "100vw", height: "100vh", background: "#0a0a0a", overflow: "hidden" }}>
      {/* Jitsi IFrame API script */}
      <Script
        src={`${baseUrl}/external_api.js`}
        strategy="lazyOnload"
        onLoad={initJitsi}
      />

      {/* Countdown overlay */}
      <div style={{
        position: "absolute",
        top: 16,
        right: 16,
        zIndex: 1000,
        display: "flex",
        alignItems: "center",
        gap: "8px",
        padding: "8px 14px",
        borderRadius: "8px",
        background: secondsLeft <= 30 && secondsLeft > 0 ? "rgba(239,68,68,0.9)" : "rgba(0,0,0,0.75)",
        backdropFilter: "blur(8px)",
        border: "1px solid rgba(255,255,255,0.1)",
        fontFamily: "var(--font-mono, monospace)",
        fontSize: "0.85rem",
        color: "#fff",
        transition: "background 0.3s",
      }}>
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
        {countdown}
      </div>

      {/* Jitsi container */}
      <div ref={containerRef} style={{ width: "100%", height: "100%" }} />
    </div>
  );
}

export default function MeetingPage() {
  return (
    <Suspense>
      <MeetingPageContent />
    </Suspense>
  );
}
