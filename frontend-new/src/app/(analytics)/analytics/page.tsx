"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { isAnalyticsAuthenticated } from "@/lib/token";
import { AnalyticsSignInForm } from "@/components/auth/analytics-sign-in-form";

export default function AnalyticsSignInPage() {
  const router = useRouter();
  const [isReady, setIsReady] = useState(false);

  useEffect(() => {
    if (isAnalyticsAuthenticated()) {
      router.replace("/analytics/dashboard");
    } else {
      setIsReady(true);
    }
  }, [router]);

  if (!isReady) return null;

  return <AnalyticsSignInForm />;
}
