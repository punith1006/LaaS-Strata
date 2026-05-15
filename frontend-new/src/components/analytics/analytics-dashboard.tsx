"use client";

import type { User } from "@/types/auth";

interface AnalyticsDashboardProps {
  user: User;
}

export function AnalyticsDashboard({ user }: AnalyticsDashboardProps) {
  const primaryRole = user.roles?.[0] ?? "unknown";

  return (
    <div className="flex min-h-[60vh] flex-col items-center justify-center space-y-8">
      <div className="text-center">
        <h1 className="text-3xl font-bold text-neutral-900">
          Welcome, {user.firstName || "Admin"}
        </h1>
        <p className="mt-2 text-neutral-600">
          You are signed in to the KSRCE Analytics Portal.
        </p>
      </div>

      <div className="rounded-2xl border border-neutral-200 bg-white p-12 text-center shadow-sm">
        <p className="text-sm font-medium uppercase tracking-wider text-neutral-500">
          Detected Role
        </p>
        <p className="mt-4 text-5xl font-bold text-neutral-900">
          {primaryRole}
        </p>
        <p className="mt-4 text-sm text-neutral-500">
          Full analytics views for this role will be available shortly.
        </p>
      </div>

      {user.roles && user.roles.length > 1 && (
        <div className="text-center">
          <p className="text-sm text-neutral-500">
            All assigned roles: {user.roles.join(", ")}
          </p>
        </div>
      )}
    </div>
  );
}
