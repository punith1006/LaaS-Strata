"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { getAnalyticsMe } from "@/lib/api";
import type { User } from "@/types/auth";
import { AnalyticsDashboard } from "@/components/analytics/analytics-dashboard";

export default function AnalyticsDashboardPage() {
  const router = useRouter();
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchUser = async () => {
      try {
        const userData = await getAnalyticsMe();
        if (!userData) {
          router.replace("/analytics");
          return;
        }
        // Ensure user has an admin role
        const adminRoles = ["business_lead", "it_admin", "super_admin", "org_admin"];
        const hasAdminRole = userData.roles?.some((role) =>
          adminRoles.includes(role)
        );
        if (!hasAdminRole) {
          router.replace("/analytics");
          return;
        }
        setUser(userData);
      } catch {
        router.replace("/analytics");
      } finally {
        setIsLoading(false);
      }
    };

    fetchUser();
  }, [router]);

  if (isLoading) {
    return (
      <div className="flex min-h-[60vh] items-center justify-center">
        <p className="text-neutral-500">Loading…</p>
      </div>
    );
  }

  if (!user) {
    return null;
  }

  return <AnalyticsDashboard user={user} />;
}
