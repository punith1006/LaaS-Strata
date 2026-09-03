"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { getAnalyticsAccessToken } from "@/lib/token";
import { AnalyticsShell } from "@/components/analytics/analytics-shell";

export default function AnalyticsConsoleLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const router = useRouter();
  const [isAuthenticated, setIsAuthenticated] = useState<boolean | null>(null);

  useEffect(() => {
    const checkAuth = () => {
      const token = getAnalyticsAccessToken();
      if (!token) {
        router.replace("/analytics");
        return;
      }
      setIsAuthenticated(true);
    };

    checkAuth();
  }, [router]);

  if (isAuthenticated === null) {
    return null;
  }

  return <AnalyticsShell>{children}</AnalyticsShell>;
}
