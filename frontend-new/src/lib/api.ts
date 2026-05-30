import type { AuthTokens, User, ProfileData, EditableProfileData, EditableMentorProfileData } from "@/types/auth";
import { saveTokens, getAccessToken, getRefreshToken, clearTokens, isTokenExpired, saveAnalyticsTokens, getAnalyticsAccessToken, clearAnalyticsTokens } from "@/lib/token";

const API_BASE = process.env.NEXT_PUBLIC_API_URL || "";

// Mutex to prevent multiple simultaneous refresh calls
let refreshPromise: Promise<AuthTokens> | null = null;

/**
 * Perform token refresh with deduplication
 * If a refresh is already in progress, wait for it instead of starting a new one
 */
async function doRefresh(): Promise<boolean> {
  // Deduplicate: if a refresh is already in progress, wait for it
  if (refreshPromise) {
    try {
      await refreshPromise;
      return true;
    } catch {
      return false;
    }
  }

  const refreshToken = getRefreshToken();
  if (!refreshToken) return false;

  refreshPromise = refreshTokens(); // existing function
  try {
    await refreshPromise;
    return true;
  } catch {
    return false;
  } finally {
    refreshPromise = null;
  }
}

/**
 * Centralized fetch wrapper with automatic token refresh on 401
 * - Proactively refreshes expired tokens before making requests
 * - Handles 401 responses by refreshing and retrying once
 * - Deduplicates concurrent refresh requests
 */
export async function apiFetch(url: string, options: RequestInit = {}): Promise<Response> {
  let token = getAccessToken();

  // Proactive check: if token is expired, refresh BEFORE making the request
  if (isTokenExpired() && getRefreshToken()) {
    await doRefresh();
    token = getAccessToken();
  }

  // Make the request
  let res = await fetch(url, {
    ...options,
    headers: {
      ...options.headers,
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
  });

  // If 401, try refresh once and retry
  if (res.status === 401) {
    const refreshed = await doRefresh();
    if (refreshed) {
      token = getAccessToken();
      res = await fetch(url, {
        ...options,
        headers: {
          ...options.headers,
          Authorization: `Bearer ${token}`,
        },
      });
    } else {
      // Refresh failed — session is dead
      clearTokens();
      if (typeof window !== "undefined") {
        window.location.href = "/signin";
      }
    }
  }

  return res;
}

async function delay(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export async function signIn(
  email: string,
  password: string,
): Promise<AuthTokens> {
  if (API_BASE) {
    const res = await fetch(`${API_BASE}/api/auth/login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password }),
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      const msg = Array.isArray(data.message) ? data.message[0] : data.message;
      throw new Error(msg || "Sign in failed");
    }
    const tokens: AuthTokens = await res.json();
    saveTokens(tokens);
    return tokens;
  }
  await delay(1200);
  const mock: AuthTokens = {
    accessToken: "mock-access-token",
    refreshToken: "mock-refresh-token",
    expiresIn: 900,
  };
  saveTokens(mock);
  return mock;
}

export async function analyticsSignIn(
  email: string,
  password: string,
): Promise<AuthTokens> {
  if (API_BASE) {
    const res = await fetch(`${API_BASE}/api/auth/login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password }),
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      const msg = Array.isArray(data.message) ? data.message[0] : data.message;
      throw new Error(msg || "Sign in failed");
    }
    const tokens: AuthTokens = await res.json();
    saveAnalyticsTokens(tokens);
    return tokens;
  }
  await delay(1200);
  const mock: AuthTokens = {
    accessToken: "mock-access-token",
    refreshToken: "mock-refresh-token",
    expiresIn: 900,
  };
  saveAnalyticsTokens(mock);
  return mock;
}

export interface CheckEmailResponse {
  available: boolean;
  institution?: {
    name: string;
    shortName: string | null;
    slug: string;
  };
}

export async function getUniversityDepartments(slug: string): Promise<{ id: string; name: string; code: string }[]> {
  if (API_BASE) {
    const res = await fetch(`${API_BASE}/api/auth/universities/${encodeURIComponent(slug)}/departments`);
    if (!res.ok) {
      return [];
    }
    return res.json();
  }
  return [];
}

export async function checkEmail(email: string): Promise<CheckEmailResponse> {
  if (API_BASE) {
    const res = await fetch(`${API_BASE}/api/auth/check-email`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email }),
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      const msg = Array.isArray(data.message) ? data.message[0] : data.message;
      throw new Error(msg || "Email validation failed");
    }
    return res.json();
  }
  await delay(400);
  return { available: true };
}

export async function sendOtp(email: string): Promise<void> {
  if (API_BASE) {
    const res = await fetch(`${API_BASE}/api/auth/send-otp`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email }),
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      const msg = Array.isArray(data.message) ? data.message[0] : data.message;
      throw new Error(msg || "Failed to send code");
    }
    return;
  }
  await delay(600);
}

export async function resendOtp(email: string): Promise<void> {
  if (API_BASE) {
    const res = await fetch(`${API_BASE}/api/auth/resend-otp`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email }),
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      const msg = Array.isArray(data.message) ? data.message[0] : data.message;
      throw new Error(msg || "Resend failed");
    }
    return;
  }
  await delay(600);
}

export async function verifyOtp(
  email: string,
  code: string,
  payload?: {
    password: string;
    firstName: string;
    lastName: string;
    agreedPolicies: string[];
    referralCode?: string;
  },
): Promise<AuthTokens> {
  if (API_BASE && payload) {
    const res = await fetch(`${API_BASE}/api/auth/verify-otp`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        email,
        code,
        password: payload.password,
        firstName: payload.firstName,
        lastName: payload.lastName,
        agreedPolicies: payload.agreedPolicies,
        referralCode: payload.referralCode,
      }),
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      const msg = Array.isArray(data.message) ? data.message[0] : data.message;
      throw new Error(msg || "Verification failed");
    }
    const tokens: AuthTokens = await res.json();
    saveTokens(tokens);
    return tokens;
  }
  await delay(1500);
  const mock: AuthTokens = {
    accessToken: "mock-access-token",
    refreshToken: "mock-refresh-token",
    expiresIn: 900,
  };
  saveTokens(mock);
  return mock;
}

export async function refreshTokens(): Promise<AuthTokens> {
  const token = getRefreshToken();
  if (!token) throw new Error("No refresh token");

  if (API_BASE) {
    const res = await fetch(`${API_BASE}/api/auth/refresh`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ refreshToken: token }),
    });
    if (!res.ok) {
      clearTokens();
      throw new Error("Session expired");
    }
    const tokens: AuthTokens = await res.json();
    saveTokens(tokens);
    return tokens;
  }
  throw new Error("No API configured");
}

export async function getMe(): Promise<User | null> {
  const token = getAccessToken();
  if (!token) return null;

  if (API_BASE) {
    // Add cache-busting timestamp to prevent stale user data
    const res = await apiFetch(`${API_BASE}/api/auth/me?t=${Date.now()}`, {
      headers: { 
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Pragma': 'no-cache',
      },
    });
    if (!res.ok) return null;
    return res.json();
  }
  return null;
}

export async function getAnalyticsMe(): Promise<User | null> {
  const token = getAnalyticsAccessToken();
  if (!token) return null;

  if (API_BASE) {
    const res = await fetch(`${API_BASE}/api/auth/me?t=${Date.now()}`, {
      headers: {
        Authorization: `Bearer ${token}`,
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Pragma': 'no-cache',
      },
    });
    if (!res.ok) {
      if (res.status === 401) {
        clearAnalyticsTokens();
      }
      return null;
    }
    return res.json();
  }
  return null;
}

export async function forgotPassword(email: string): Promise<{ message: string }> {
  if (API_BASE) {
    const res = await fetch(`${API_BASE}/api/auth/forgot-password`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email }),
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data.message || "Failed to send reset code");
    }
    return res.json();
  }
  // Mock for development
  await delay(600);
  return { message: "Reset code sent" };
}

export async function verifyResetOtp(email: string, otp: string): Promise<{ verified: boolean }> {
  if (API_BASE) {
    const res = await fetch(`${API_BASE}/api/auth/verify-reset-otp`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, otp }),
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data.message || "Invalid OTP");
    }
    return res.json();
  }
  // Mock for development
  await delay(600);
  return { verified: true };
}

export async function resetPassword(email: string, otp: string, newPassword: string): Promise<{ message: string }> {
  if (API_BASE) {
    const res = await fetch(`${API_BASE}/api/auth/reset-password`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, otp, newPassword }),
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data.message || "Failed to reset password");
    }
    return res.json();
  }
  // Mock for development
  await delay(600);
  return { message: "Password reset successfully" };
}

export function logout(): void {
  clearTokens();
}

export async function retryStorageProvisioning(): Promise<{
  status: string;
  error?: string;
}> {
  if (!getAccessToken()) throw new Error("Not authenticated");
  const res = await apiFetch(`${API_BASE}/api/auth/storage-retry`, {
    method: "POST",
  });
  if (!res.ok) {
    const data = await res.json().catch(() => ({}));
    const msg = Array.isArray(data.message) ? data.message[0] : data.message;
    throw new Error(msg || "Storage retry failed");
  }
  return res.json();
}

// Dashboard API Types
export interface HomeDashboardData {
  user: {
    id: string;
    email: string;
    firstName: string;
    lastName: string;
    authType: string;
    storageUid: string | null;
    storageQuotaGb: number;
    storageProvisioningStatus: string | null;
    storageProvisioningError: string | null;
  };
  storage: {
    quotaGb: number;
    usedGb: number;
    status: string;
    healthStatus?: string | null; // 'live' | 'unreachable' | null
  };
  quickStats: {
    totalSessions: number;
    activeSessions: number;
    totalDatasets: number;
    totalNotebooks: number;
  };
  recentActivity: ActivityItem[];
}

export interface ActivityItem {
  id: string;
  type: 'session' | 'dataset' | 'notebook' | 'storage';
  action: string;
  description: string;
  timestamp: string;
}

export interface BillingData {
  plan: {
    type: string;
    name: string;
    description: string;
  };
  usage: {
    storageQuotaGb: number;
    storageUsedGb: number;
    storageAllocatedGb: number;
    computeHoursUsed: number;
    billingCycle: string;
  };
  paymentMethod: {
    type: string;
    description: string;
  } | null;
  billingHistory: BillingHistoryItem[];
  // Lambda.ai style billing fields
  creditBalance: number;
  spendRate: number;
  spendLimit: number;
  spendLimitEnabled: boolean;
  dailySpend: number;
  currentSpendRate: number;
  runway: number | null; // Hours of runway remaining
  gpus: number;
  gpuVramMb: number;
  vcpus: number;
  memoryMb: number;
  endpoints: number;
  storageAllocatedGb: number;
  storageUsedGb: number;
  storageUsagePercent: number;
  hourlyData: HourlySpendData[];
  // Storage billing fields (from backend Task 13)
  storageBurnRateCentsPerHour?: number;
  storageMonthlyEstimateCents?: number;
  // Student exemption flag (Task 18 - bypass compute/storage credit blocks)
  isComputeStorageExempt: boolean;
}

export interface HourlySpendData {
  hour: string;
  cumulativeSpend: number;
  hourlyRate: number;
}

export interface BillingHistoryItem {
  id: string;
  date: string;
  description: string;
  amount: number;
  status: string;
}

// Dashboard API Functions
export async function getHomeDashboardData(): Promise<HomeDashboardData | null> {
  if (!getAccessToken()) return null;

  if (API_BASE) {
    const res = await apiFetch(`${API_BASE}/api/dashboard/home`);
    if (!res.ok) return null;
    return res.json();
  }
  return null;
}

export async function getBillingData(): Promise<BillingData | null> {
  if (!getAccessToken()) return null;

  if (API_BASE) {
    const res = await apiFetch(`${API_BASE}/api/dashboard/billing`);
    if (!res.ok) return null;
    return res.json();
  }
  return null;
}

// Platform Health API Types
export interface PlatformHealth {
  overall: 'operational' | 'degraded' | 'outage';
  services: {
    name: string;
    status: 'healthy' | 'unhealthy';
    message: string;
  }[];
}

export async function getPlatformHealth(): Promise<PlatformHealth | null> {
  if (!getAccessToken()) return null;

  try {
    const res = await apiFetch(`${API_BASE}/api/dashboard/health`);
    if (!res.ok) return null;
    return res.json();
  } catch {
    return null;
  }
}

// Storage API Types
export interface StorageVolume {
  id: string;
  name: string;
  storageUid: string;
  quotaGb: number;
  usedGb: number;
  status: string;
  allocationType: string;
  provisionedAt: string | null;
  createdAt: string;
  nodeId: string | null;
  node: { id: string; hostname: string } | null;
  storageBackend: string | null;
}

export interface NameCheckResult {
  available: boolean;
  error?: string;
}

// Storage API Functions
async function storageFetch(endpoint: string, options: RequestInit = {}) {
  if (!getAccessToken()) {
    throw new Error('Not authenticated');
  }

  const res = await apiFetch(`${API_BASE}${endpoint}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...options.headers,
    },
  });

  if (!res.ok) {
    const data = await res.json().catch(() => ({}));
    const msg = Array.isArray(data.message) ? data.message[0] : data.message;
    throw new Error(msg || `Request failed: ${res.status}`);
  }

  return res.json();
}

export async function getStorageVolumes(): Promise<StorageVolume[]> {
  if (API_BASE) {
    return storageFetch('/api/storage/volumes');
  }
  // Mock data for development
  return [];
}

export async function checkStorageName(name: string): Promise<NameCheckResult> {
  if (API_BASE) {
    const res = await apiFetch(
      `${API_BASE}/api/storage/volumes/check-name/${encodeURIComponent(name)}`,
      {
        method: 'GET',
      },
    );
    if (!res.ok) {
      return { available: false, error: 'Failed to check name availability' };
    }
    return res.json();
  }
  // Mock for development - always available
  return { available: true };
}

export async function createStorageVolume(
  name: string,
  quotaGb: number,
): Promise<StorageVolume> {
  if (API_BASE) {
    return storageFetch('/api/storage/volumes', {
      method: 'POST',
      body: JSON.stringify({ name, quotaGb }),
    });
  }
  // Mock for development
  return {
    id: `mock-${Date.now()}`,
    name,
    storageUid: `u_${Date.now().toString(16)}`,
    quotaGb,
    usedGb: 0,
    status: 'active',
    allocationType: 'user_created',
    provisionedAt: new Date().toISOString(),
    createdAt: new Date().toISOString(),
    nodeId: null,
    node: null,
    storageBackend: 'zfs_zvol',
  };
}

export async function deleteStorageVolume(id: string): Promise<void> {
  if (API_BASE) {
    await storageFetch(`/api/storage/volumes/${id}`, {
      method: 'DELETE',
      body: JSON.stringify({}),
    });
  }
  // Mock for development
}

// Delete user's file store (no ID needed - backend determines from auth)
export async function deleteUserFileStore(): Promise<{ ok: boolean; message?: string }> {
  if (API_BASE) {
    return storageFetch('/api/storage/volumes', { method: 'DELETE', body: JSON.stringify({}) });
  }
  // Mock for development
  return { ok: true, message: 'Mock delete successful' };
}

// Active session check types
export interface ActiveSession {
  id: string;
  instanceName: string;
  status: string;
}

export interface ActiveSessionsCheck {
  hasActiveSessions: boolean;
  sessionCount: number;
  sessions: ActiveSession[];
}

// Check if user has active sessions (blocks storage operations)
export async function checkActiveSessions(): Promise<ActiveSessionsCheck> {
  if (API_BASE) {
    return storageFetch('/api/storage/volumes/active-sessions-check');
  }
  // Mock for development
  return { hasActiveSessions: false, sessionCount: 0, sessions: [] };
}

// Check host available storage space
export async function checkHostSpace(): Promise<{ availableGb: number; totalGb: number; availableBytes: number }> {
  if (API_BASE) {
    return storageFetch('/api/storage/volumes/host-space-check');
  }
  // Mock for development
  return { availableGb: 45.2, totalGb: 100, availableBytes: 48534556672 };
}

// Storage upgrade response type
export interface StorageVolumeUpgrade {
  id: string;
  name: string;
  storageUid: string;
  quotaGb: number;
  usedGb: number;
  status: string;
  allocationType: string;
  previousQuotaGb: number;
  monthlyEstimate: number;
  hourlyRate: number;
}

// Upgrade storage volume
export async function upgradeStorageVolume(
  volumeId: string,
  newQuotaGb: number,
): Promise<StorageVolumeUpgrade> {
  if (API_BASE) {
    return storageFetch(`/api/storage/volumes/${volumeId}`, {
      method: 'PATCH',
      body: JSON.stringify({ newQuotaGb }),
    });
  }
  // Mock for development
  return {
    id: `mock-${Date.now()}`,
    name: 'fs1',
    storageUid: `u_${Date.now().toString(16)}`,
    quotaGb: newQuotaGb,
    usedGb: 2.5,
    status: 'active',
    allocationType: 'user_created',
    previousQuotaGb: 5,
    monthlyEstimate: newQuotaGb * 7.0,
    hourlyRate: (newQuotaGb * 700) / 730 / 100,
  };
}

// Storage status types
export interface StorageStatus {
  hasStorage: boolean;
  reachable: boolean;
  serviceHealthy: boolean;
  datasetExists?: boolean;
  volumeName?: string;
  quotaGb?: number;
}

export async function getStorageStatus(): Promise<StorageStatus> {
  if (API_BASE) {
    return storageFetch('/api/storage/status');
  }
  // Mock for development
  return { hasStorage: false, reachable: false, serviceHealthy: false };
}

// File listing types
export interface FileItem {
  name: string;
  type: 'file' | 'folder';
  size: number | null;
  updatedAt: string;
}

export async function getStorageFiles(path?: string): Promise<FileItem[]> {
  if (!getAccessToken()) {
    throw new Error('Not authenticated');
  }

  if (API_BASE) {
    const queryParam = path && path !== '/' ? `?path=${encodeURIComponent(path)}` : '';
    const res = await apiFetch(`${API_BASE}/api/storage/files${queryParam}`);

    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      const msg = Array.isArray(data.message) ? data.message[0] : data.message;
      throw new Error(msg || 'Failed to fetch files');
    }

    return res.json();
  }

  // Mock for development - return empty array
  return [];
}

// Create folder in storage
export async function createStorageFolder(
  path: string,
  folderName: string,
): Promise<{ success: boolean }> {
  if (!getAccessToken()) throw new Error('Not authenticated');

  if (API_BASE) {
    const res = await apiFetch(`${API_BASE}/api/storage/files/mkdir`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ path, folderName }),
    });

    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      const msg = Array.isArray(data.message) ? data.message[0] : data.message;
      throw new Error(msg || 'Failed to create folder');
    }

    return res.json();
  }

  return { success: true };
}

// Upload files to storage
// NOTE: Do NOT set Content-Type header - browser auto-sets multipart boundary
export async function uploadStorageFiles(
  path: string,
  files: File[],
): Promise<{ success: boolean; uploaded: string[] }> {
  if (!getAccessToken()) throw new Error('Not authenticated');

  if (API_BASE) {
    const formData = new FormData();
    formData.append('path', path);
    files.forEach((file) => formData.append('files', file));

    const res = await apiFetch(`${API_BASE}/api/storage/files/upload`, {
      method: 'POST',
      // Note: Do NOT set Content-Type - browser auto-sets with boundary for multipart
      body: formData,
    });

    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      const msg = Array.isArray(data.message) ? data.message[0] : data.message;
      throw new Error(msg || 'Upload failed');
    }

    return res.json();
  }

  return { success: true, uploaded: files.map((f) => f.name) };
}

// Download file from storage - triggers browser download
export async function downloadStorageFile(filePath: string): Promise<void> {
  if (!getAccessToken()) throw new Error('Not authenticated');

  if (API_BASE) {
    const res = await apiFetch(
      `${API_BASE}/api/storage/files/download?file=${encodeURIComponent(filePath)}`,
    );

    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      const msg = Array.isArray(data.message) ? data.message[0] : data.message;
      throw new Error(msg || 'Download failed');
    }

    // Create download link from blob
    const blob = await res.blob();
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filePath.split('/').pop() || 'download';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  }
}

// Delete file or folder from storage
export async function deleteStorageFile(
  filePath: string,
): Promise<{ success: boolean }> {
  if (!getAccessToken()) throw new Error('Not authenticated');

  if (API_BASE) {
    const res = await apiFetch(
      `${API_BASE}/api/storage/files?file=${encodeURIComponent(filePath)}`,
      {
        method: 'DELETE',
      },
    );

    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      const msg = Array.isArray(data.message) ? data.message[0] : data.message;
      throw new Error(msg || 'Delete failed');
    }

    return res.json();
  }

  return { success: true };
}

// Activity Log API Types
export interface ActivityLogEntry {
  id: string;
  action: string;
  category: string;
  status: string;
  details: Record<string, unknown> | null;
  ipAddress: string | null;
  createdAt: string;
}

export async function getRecentActivity(days: number = 30): Promise<ActivityLogEntry[]> {
  if (!getAccessToken()) return [];

  if (API_BASE) {
    try {
      const res = await apiFetch(`${API_BASE}/api/dashboard/activity?days=${days}`);
      if (!res.ok) return [];
      return res.json();
    } catch {
      return [];
    }
  }
  return [];
}

// Compute API Types
export interface ComputeConfigResponse {
  id: string;
  slug: string;
  name: string;
  description: string | null;
  tier: string | null;
  sessionType: string;
  vcpu: number;
  memoryMb: number;
  gpuVramMb: number;
  gpuModel: string | null;
  hamiSmPercent: number | null;
  basePricePerHourCents: number;
  currency: string;
  bestFor: string | null;
  sortOrder: number;
  available: boolean;
  maxLaunchable: number;
}

export interface ResourceValues {
  vramMb: number;
  vcpu: number;
  ramMb: number;
}

export interface ResourceSummary {
  total: ResourceValues;
  used: ResourceValues;
  available: ResourceValues;
}

export interface ComputeConfigsResponse {
  configs: ComputeConfigResponse[];
  resources: ResourceSummary;
  runningInstances: number;
}

export interface LaunchSessionRequest {
  computeConfigId: string;
  instanceName: string;
  interfaceMode: 'gui' | 'cli';
  storageType: 'stateful' | 'ephemeral';
}

export interface LaunchSessionResponse {
  sessionId: string;
  containerName: string | null;
  status: string;
  instanceName: string | null;
}

// Compute API Functions
export async function getComputeConfigs(): Promise<ComputeConfigsResponse | null> {
  if (!getAccessToken()) return null;

  if (API_BASE) {
    try {
      const res = await apiFetch(`${API_BASE}/api/compute/configs`);
      if (!res.ok) return null;
      return res.json();
    } catch {
      return null;
    }
  }
  return null;
}

export async function launchComputeSession(
  data: LaunchSessionRequest
): Promise<LaunchSessionResponse> {
  if (!getAccessToken()) throw new Error('Not authenticated');

  const res = await apiFetch(`${API_BASE}/api/compute/sessions`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(data),
  });

  if (!res.ok) {
    const errData = await res.json().catch(() => ({}));
    const msg = Array.isArray(errData.message) ? errData.message[0] : errData.message;
    throw new Error(msg || 'Failed to launch instance');
  }

  return res.json();
}

// Payment API Types
export interface CreateOrderResponse {
  orderId: string;
  amount: number;       // in paise
  currency: string;
  keyId: string;
  transactionId: string;
}

export interface VerifyPaymentRequest {
  razorpay_order_id: string;
  razorpay_payment_id: string;
  razorpay_signature: string;
}

export interface VerifyPaymentResponse {
  success: boolean;
  newBalance: number;
}

export interface PaymentTransactionItem {
  id: string;
  gateway: string;
  gatewayTxnId: string | null;
  gatewayOrderId: string | null;
  amountCents: number;
  currency: string;
  status: string;
  createdAt: string;
  updatedAt: string;
  description?: string | null;
  invoice?: {
    id: string;
    invoiceNumber: string;
    totalCents: number;
    status: string;
    paidAt: string | null;
    description?: string | null;
  } | null;
}

// Alias for backward compatibility
export type PaymentTransaction = PaymentTransactionItem;

export interface PaginatedTransactions {
  data: PaymentTransactionItem[];
  transactions: PaymentTransactionItem[];  // Alias for backward compat
  meta: {
    total: number;
    page: number;
    limit: number;
    totalPages: number;
  };
  // Direct access for convenience
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

export interface TransactionDetail extends PaymentTransactionItem {
  gatewayResponse: Record<string, unknown> | null;
  completedAt?: string | null;
  invoice: {
    id: string;
    invoiceNumber: string;
    periodStart: string;
    periodEnd: string;
    subtotalCents: number;
    taxCents: number;
    totalCents: number;
    currency: string;
    status: string;
    issuedAt: string | null;
    paidAt: string | null;
    description?: string | null;
    invoiceLineItems: {
      id: string;
      description: string;
      quantity: number;
      unitPriceCents: number;
      totalCents: number;
    }[];
  } | null;
}

// Payment API Functions
export async function createPaymentOrder(amountInRupees: number): Promise<CreateOrderResponse> {
  if (!getAccessToken()) throw new Error('Not authenticated');

  const res = await apiFetch(`${API_BASE}/api/payment/create-order`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ amountInRupees }),
  });

  if (!res.ok) {
    const data = await res.json().catch(() => ({}));
    const msg = Array.isArray(data.message) ? data.message[0] : data.message;
    throw new Error(msg || 'Failed to create payment order');
  }

  return res.json();
}

export async function verifyPayment(data: VerifyPaymentRequest): Promise<VerifyPaymentResponse> {
  if (!getAccessToken()) throw new Error('Not authenticated');

  const res = await apiFetch(`${API_BASE}/api/payment/verify`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(data),
  });

  if (!res.ok) {
    const data = await res.json().catch(() => ({}));
    const msg = Array.isArray(data.message) ? data.message[0] : data.message;
    throw new Error(msg || 'Payment verification failed');
  }

  return res.json();
}

export async function getPaymentTransactions(page = 1, limit = 10): Promise<PaginatedTransactions> {
  if (!getAccessToken()) throw new Error('Not authenticated');

  if (API_BASE) {
    const res = await apiFetch(`${API_BASE}/api/payment/transactions?page=${page}&limit=${limit}`);

    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      const msg = Array.isArray(data.message) ? data.message[0] : data.message;
      throw new Error(msg || 'Failed to fetch transactions');
    }

    return res.json();
  }

  // Mock data for development
  return {
    data: [],
    transactions: [],
    meta: { total: 0, page: 1, limit: 10, totalPages: 0 },
    total: 0,
    page: 1,
    limit: 10,
    totalPages: 0,
  };
}

export async function getTransactionDetail(id: string): Promise<TransactionDetail> {
  if (!getAccessToken()) throw new Error('Not authenticated');

  if (API_BASE) {
    const res = await apiFetch(`${API_BASE}/api/payment/transactions/${id}`);

    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      const msg = Array.isArray(data.message) ? data.message[0] : data.message;
      throw new Error(msg || 'Failed to fetch transaction details');
    }

    return res.json();
  }

  throw new Error('No API configured');
}

export async function downloadInvoice(transactionId: string): Promise<Blob> {
  if (!getAccessToken()) throw new Error('Not authenticated');

  if (API_BASE) {
    const res = await apiFetch(`${API_BASE}/api/payment/invoice/${transactionId}/download`);

    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      const msg = Array.isArray(data.message) ? data.message[0] : data.message;
      throw new Error(msg || 'Failed to download invoice');
    }

    return res.blob();
  }

  throw new Error('No API configured');
}

// Onboarding API Types
export interface OnboardingProfileData {
  profession?: string;
  expertiseLevel?: string;
  yearsOfExperience?: number;
  operationalDomains?: string[];
  useCasePurposes?: string[];
  useCaseOther?: string;
  country?: string;
  // Academic fields for students
  departmentId?: string;
  courseName?: string;
  academicYear?: number;
  graduationYear?: number;
}

export interface SaveOnboardingResponse {
  success: boolean;
  profileId: string;
  onboardingComplete: boolean;
}

export interface OnboardingStatusResponse {
  isOnboardingComplete: boolean;
  hasProfession: boolean;
  hasExpertiseLevel: boolean;
  hasYearsOfExperience: boolean;
  hasOperationalDomains: boolean;
  hasUseCasePurposes: boolean;
  hasCountry: boolean;
}

// Onboarding API Functions
export async function saveOnboardingProfile(
  data: OnboardingProfileData
): Promise<SaveOnboardingResponse> {
  if (!getAccessToken()) throw new Error("Not authenticated");

  if (API_BASE) {
    const res = await apiFetch(`${API_BASE}/api/user/onboarding`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(data),
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      const msg = Array.isArray(data.message) ? data.message[0] : data.message;
      throw new Error(msg || "Failed to save onboarding profile");
    }
    return res.json();
  }
  // Mock for development
  await delay(800);
  return {
    success: true,
    profileId: `profile-${Date.now()}`,
    onboardingComplete: true,
  };
}

export async function getOnboardingStatus(): Promise<OnboardingStatusResponse | null> {
  if (!getAccessToken()) return null;

  if (API_BASE) {
    const res = await apiFetch(`${API_BASE}/api/user/onboarding-status`);
    if (!res.ok) return null;
    return res.json();
  }
  // Mock for development
  return {
    isOnboardingComplete: false,
    hasProfession: false,
    hasExpertiseLevel: false,
    hasYearsOfExperience: false,
    hasOperationalDomains: false,
    hasUseCasePurposes: false,
    hasCountry: false,
  };
}

// Spend Limit API Types
export interface SpendLimitSettings {
  enabled: boolean;
  limitAmountRupees: number | null;
  period: string | null;
  startDate: string | null;
  endDate: string | null;
  consentedAt: string | null;
  currentPeriodSpendRupees: number;
}

// Spend Limit API Functions
export async function getSpendLimitSettings(): Promise<SpendLimitSettings | null> {
  if (!getAccessToken() || !API_BASE) return null;
  const res = await apiFetch(`${API_BASE}/api/billing/spend-limit`);
  if (!res.ok) return null;
  return res.json();
}

// Support Ticket API Types
export interface SupportTicketRequest {
  category: string;
  subject: string;
  description: string;
}

export interface SupportTicketResponse {
  ticketId: string;
  status: string;
  createdAt: string;
}

export interface SupportTicketListItem {
  id: string;
  subject: string;
  category: string;
  priority: string;
  status: string;
  createdAt: string;
  updatedAt: string;
  resolvedAt: string | null;
}

// Support Ticket API Functions
// NOTE: When attachments are provided, we send multipart/form-data and intentionally
// omit the Content-Type header so the browser sets the boundary automatically.
// apiFetch only spreads provided headers, so this is safe.
export async function submitSupportTicket(
  data: SupportTicketRequest,
  attachments?: File[]
): Promise<SupportTicketResponse> {
  if (!getAccessToken()) throw new Error('Not authenticated');

  const hasAttachments = Array.isArray(attachments) && attachments.length > 0;

  let res: Response;
  if (hasAttachments) {
    const formData = new FormData();
    formData.append('category', data.category);
    formData.append('subject', data.subject);
    formData.append('description', data.description);
    attachments!.forEach((file) => formData.append('attachments', file));

    res = await apiFetch(`${API_BASE}/api/support/tickets`, {
      method: 'POST',
      // Do NOT set Content-Type — browser sets multipart boundary automatically.
      body: formData,
    });
  } else {
    res = await apiFetch(`${API_BASE}/api/support/tickets`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(data),
    });
  }

  if (!res.ok) {
    const errData = await res.json().catch(() => ({}));
    const msg = Array.isArray(errData.message) ? errData.message[0] : errData.message;
    throw new Error(msg || 'Failed to submit support ticket');
  }

  return res.json();
}

export async function getSupportTickets(): Promise<SupportTicketListItem[]> {
  if (!getAccessToken()) return [];

  if (API_BASE) {
    const res = await apiFetch(`${API_BASE}/api/support/tickets/list`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
    });

    if (!res.ok) return [];
    return res.json();
  }
  return [];
}

// ── Admin Support Ticket APIs (Analytics Console) ─────────
// These endpoints are accessed from the analytics dashboard and use
// the analytics access token (separate from the regular user token).
// The analytics dashboard uses raw fetch with Bearer auth — same pattern here.
export interface UnresolvedTicket {
  id: string;
  subject: string;
  category: string;
  status: string;
  priority: string;
  createdAt: string;
  user: { email: string; firstName: string; lastName: string };
}

export interface TicketDetail extends UnresolvedTicket {
  description: string;
  attachments: { id: string; fileName: string; mimeType: string; size: number }[];
}

// Fetch all unresolved tickets (admin)
export async function getUnresolvedTickets(): Promise<UnresolvedTicket[]> {
  const token = getAnalyticsAccessToken();
  if (!token || !API_BASE) return [];

  try {
    const res = await fetch(`${API_BASE}/api/support/admin/tickets/unresolved`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (!res.ok) return [];
    const body = await res.json();
    return Array.isArray(body?.data) ? body.data : [];
  } catch {
    return [];
  }
}

// Get full ticket detail (admin)
export async function getTicketDetail(ticketId: string): Promise<TicketDetail> {
  const token = getAnalyticsAccessToken();
  if (!token) throw new Error('Not authenticated');
  if (!API_BASE) throw new Error('No API configured');

  const res = await fetch(`${API_BASE}/api/support/admin/tickets/${ticketId}`, {
    headers: { Authorization: `Bearer ${token}` },
  });

  if (!res.ok) {
    const errData = await res.json().catch(() => ({}));
    const msg = Array.isArray(errData.message) ? errData.message[0] : errData.message;
    throw new Error(msg || 'Failed to fetch ticket detail');
  }

  const body = await res.json();
  return body?.data ?? body;
}

// Resolve/close a ticket (admin)
export async function resolveTicket(
  ticketId: string,
  resolutionNotes?: string,
): Promise<{ ticketId: string; status: string }> {
  const token = getAnalyticsAccessToken();
  if (!token) throw new Error('Not authenticated');
  if (!API_BASE) throw new Error('No API configured');

  const payload: { resolutionNotes?: string } = {};
  if (resolutionNotes !== undefined && resolutionNotes !== null) {
    payload.resolutionNotes = resolutionNotes;
  }

  const res = await fetch(`${API_BASE}/api/support/admin/tickets/${ticketId}/resolve`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(payload),
  });

  if (!res.ok) {
    const errData = await res.json().catch(() => ({}));
    const msg = Array.isArray(errData.message) ? errData.message[0] : errData.message;
    throw new Error(msg || 'Failed to resolve ticket');
  }

  const body = await res.json();
  return body?.data ?? body;
}

// Get attachment URL for admin viewing.
// Returns just the URL — callers must fetch with the analytics Bearer token
// (e.g. via getAnalyticsAccessToken()) and convert the response to a blob URL
// for use in <img src=...> tags.
export function getTicketAttachmentUrl(ticketId: string, attachmentId: string): string {
  return `${API_BASE}/api/support/admin/tickets/${ticketId}/attachments/${attachmentId}`;
}

// ── Analytics Dashboard: NRR & Retention ─────────
export interface NrrPeriod {
  label: string;
  nrrPct: number | null;
  expandedUsers: number;
  contractedUsers: number;
  cohortSize: number;
  cohortRevenueCents: number;
}

export interface NrrResponse {
  periods: NrrPeriod[];
  currentNrrPct: number | null;
  avgNrrPct: number;
}

export interface RetentionPeriod {
  label: string;
  activeUsers: number;
  retainedUsers: number;
  retentionPct: number | null;
  newUsers: number;
  churnedUsers: number;
}

export interface RetentionData {
  periods: RetentionPeriod[];
  currentRetentionPct: number | null;
  avgRetentionPct: number;
}

export async function getRevenueGrowthData(timeRange: string, clientId?: string): Promise<NrrResponse> {
  const token = getAnalyticsAccessToken();
  const url = `${API_BASE}/api/dashboard/analytics/revenue-growth?timeRange=${timeRange}${clientId ? `&clientId=${clientId}` : ''}`;
  const res = await fetch(url, {
    headers: { Authorization: `Bearer ${token}` },
  });
  if (!res.ok) throw new Error('Failed to fetch revenue growth data');
  return res.json();
}

export async function getRetentionData(timeRange: string, clientId?: string): Promise<RetentionData> {
  const token = getAnalyticsAccessToken();
  const url = `${API_BASE}/api/dashboard/analytics/retention?timeRange=${timeRange}${clientId ? `&clientId=${clientId}` : ''}`;
  const res = await fetch(url, {
    headers: { Authorization: `Bearer ${token}` },
  });
  if (!res.ok) throw new Error('Failed to fetch retention data');
  return res.json();
}

export async function updateSpendLimit(data: {
  enabled: boolean;
  limitAmountRupees?: number;
  period?: string;
  startDate?: string;
  endDate?: string;
  consentAcknowledged: boolean;
}): Promise<{ success: boolean; error?: string }> {
  if (!getAccessToken() || !API_BASE) return { success: false, error: 'Not authenticated' };
  const res = await apiFetch(`${API_BASE}/api/billing/spend-limit`, {
    method: 'PATCH',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(data),
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({ message: 'Failed to update spend limit' }));
    return { success: false, error: err.message };
  }
  return { success: true };
}

// Compute Recommendation APIs

export async function extractDocument(file: File): Promise<{ text: string; wordCount: number }> {
  const token = getAccessToken();
  const formData = new FormData();
  formData.append('file', file);

  const res = await fetch(`${API_BASE}/api/compute/extract-document`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${token}`,
    },
    body: formData,
  });

  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    throw new Error(error.message || 'Failed to extract document');
  }
  return res.json();
}

export async function analyzeWorkload(description: string, primaryGoal?: string): Promise<{
  detectedGoal: string;
  detectedFrameworks: string[];
  estimatedVramNeedGb: number;
  estimatedComputeIntensity: 'low' | 'medium' | 'high' | 'very_high';
  datasetSizeCategory: string;
  keyInsights: string[];
  confidence: number;
  inputQuality: 'sufficient' | 'insufficient';
  missingCategories: string[];
  suggestions: string;
  detectedProjectDuration?: string | null;
  estimatedTotalWeeks?: number | null;
  fieldConfidence: { goal: number; vram: number; intensity: number; projectDuration?: number };
  recommendedStorageType?: 'stateful' | 'ephemeral' | null;
}> {
  const token = getAccessToken();
  const res = await fetch(`${API_BASE}/api/compute/analyze-workload`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ description, primaryGoal }),
  });

  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    throw new Error(error.message || 'Failed to analyze workload');
  }
  return res.json();
}

export async function createRecommendationSession(data: {
  workloadDescription?: string;
  documentFileName?: string;
  documentExtractedText?: string;
  analysisResult?: Record<string, unknown>;
  analysisQuality?: string;
  analysisConfidence?: number;
  detectedGoal?: string;
  detectedVramGb?: number;
  detectedIntensity?: string;
  detectedFrameworks?: string[];
}): Promise<{ id: string }> {
  const token = getAccessToken();
  const res = await fetch(`${API_BASE}/api/compute/recommendation-session`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error('Failed to create recommendation session');
  return res.json();
}

export async function updateRecommendationSession(id: string, data: {
  selectedGoal?: string;
  selectedDatasetSize?: string;
  selectedIntensity?: number;
  selectedBudgetType?: string;
  selectedBudgetAmount?: number;
  selectedDuration?: string;
  selectedProjectDuration?: string;
  goalAutoSelected?: boolean;
  datasetAutoSelected?: boolean;
  intensityAutoSelected?: boolean;
  recommendations?: { slug: string; score: number; tag: string }[];
  selectedConfigSlug?: string;
  completedAt?: string;
  consumedAt?: string;
}): Promise<void> {
  const token = getAccessToken();
  const res = await fetch(`${API_BASE}/api/compute/recommendation-session/${id}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error('Failed to update recommendation session');
}

export async function getLatestRecommendationSession(): Promise<{
  id: string;
  selectedConfigSlug: string;
  analysisResult?: Record<string, unknown>;
  detectedGoal?: string;
  detectedVramGb?: number;
  detectedIntensity?: string;
  selectedGoal?: string;
  selectedDatasetSize?: string;
  selectedIntensity?: number;
  selectedBudgetType?: string;
  selectedBudgetAmount?: number;
  selectedDuration?: string;
  selectedProjectDuration?: string;
} | null> {
  const token = getAccessToken();
  if (!token) return null;
  try {
    const res = await fetch(
      `${API_BASE}/api/compute/recommendation-session/latest`,
      {
        headers: { Authorization: `Bearer ${token}` },
      }
    );
    if (!res.ok) return null;
    return res.json();
  } catch {
    return null;
  }
}

export async function consumeRecommendationSession(id: string): Promise<void> {
  try {
    await updateRecommendationSession(id, {
      consumedAt: new Date().toISOString(),
    });
  } catch (e) {
    console.warn('Failed to consume recommendation session:', e);
  }
}

export async function generateExplanation(
  configSlug: string,
  configSpecs: Record<string, unknown>,
  userGoal: string,
  userContext: string
): Promise<{ explanation: string; bullets?: string[] }> {
  const token = getAccessToken();
  const res = await fetch(`${API_BASE}/api/compute/generate-explanation`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ configSlug, configSpecs, userGoal, userContext }),
  });

  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    throw new Error(error.message || 'Failed to generate explanation');
  }
  return res.json();
}

export async function getUserProfile(): Promise<ProfileData | null> {
  const token = getAccessToken();
  if (!token) return null;

  if (API_BASE) {
    const res = await apiFetch(`${API_BASE}/api/user/profile`);
    if (!res.ok) return null;
    return res.json();
  }
  return null;
}

export async function updateUserProfile(data: Partial<EditableProfileData>): Promise<ProfileData | null> {
  const token = getAccessToken();
  if (!token) return null;

  if (API_BASE) {
    const res = await apiFetch(`${API_BASE}/api/user/profile`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    if (!res.ok) return null;
    return res.json();
  }
  return null;
}

// ── Mentor Profile ─────────────────────────────────────────
export async function getMentorProfile(): Promise<ProfileData | null> {
  // Reuses the same /api/user/profile endpoint which now includes mentorProfile fields
  return getUserProfile();
}

export async function updateMentorProfile(data: Partial<EditableMentorProfileData>): Promise<ProfileData | null> {
  const token = getAccessToken();
  if (!token) return null;

  if (API_BASE) {
    const res = await apiFetch(`${API_BASE}/api/user/mentor-profile`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    if (!res.ok) return null;
    return res.json();
  }
  return null;
}

// ── Waitlist ──────────────────────────────────────────────
export interface WaitlistFormData {
  // Optional manual fields for unauthenticated submissions
  firstName?: string;
  lastName?: string;
  email?: string;
  currentStatus: string;
  organizationName?: string;
  jobTitle?: string;
  computeNeeds: string;
  expectedDuration?: string;
  urgency?: string;
  expectations: string[];
  primaryWorkload: string;
  workloadDescription?: string;
  agreedToPolicy: boolean;
  agreedToComms: boolean;
}

export interface WaitlistResponse {
  id: string;
  email: string;
  status: string;
  createdAt: string;
}

export async function submitWaitlist(data: WaitlistFormData): Promise<WaitlistResponse> {
  const res = await apiFetch(`${API_BASE}/api/waitlist`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({ message: 'Submission failed' }));
    throw new Error(err.message || 'Failed to submit waitlist entry');
  }
  return res.json();
}

export async function analyzeWaitlistWorkload(description: string): Promise<{
  detectedGoal: string;
  detectedFrameworks: string[];
  estimatedVramNeedGb: number;
  estimatedComputeIntensity: 'low' | 'medium' | 'high' | 'very_high';
  datasetSizeCategory: string;
  keyInsights: string[];
  confidence: number;
  inputQuality: 'sufficient' | 'insufficient';
  missingCategories: string[];
  suggestions: string;
  fieldConfidence: { goal: number; vram: number; intensity: number };
}> {
  const res = await apiFetch(`${API_BASE}/api/waitlist/analyze-workload`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ description }),
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({ message: 'Analysis failed' }));
    throw new Error(err.message || 'Failed to analyze workload');
  }
  return res.json();
}

// Waitlist Status Types
export interface WaitlistEntry {
  id: string;
  firstName: string;
  lastName: string;
  email: string;
  currentStatus: string;
  organizationName: string | null;
  jobTitle: string | null;
  computeNeeds: string | null;
  expectedDuration: string | null;
  urgency: string | null;
  primaryWorkload: string | null;
  workloadDescription: string | null;
  status: string;
  createdAt: string;
}

export interface WaitlistStatusResponse {
  enrolled: boolean;
  entry?: WaitlistEntry;
  position?: number;
  totalCount?: number;
}

// Get public waitlist count (no auth required)
export async function getWaitlistCount(): Promise<number> {
  if (API_BASE) {
    try {
      const res = await fetch(`${API_BASE}/api/waitlist/count`);
      if (res.ok) {
        const data = await res.json();
        return data.count ?? 0;
      }
    } catch {}
  }
  return 0;
}

// Check if the current user is already enrolled in the waitlist
export async function checkWaitlistStatus(): Promise<WaitlistStatusResponse> {
  if (!getAccessToken()) return { enrolled: false };

  if (API_BASE) {
    try {
      const res = await apiFetch(`${API_BASE}/api/waitlist/status`);
      if (!res.ok) return { enrolled: false };
      return res.json();
    } catch {
      return { enrolled: false };
    }
  }
  return { enrolled: false };
}

// --- Analytics Admin: All Transactions ---

export interface AllTransactionsRow {
  id: string;
  status: string;
  createdAt: string;
  userEmail: string;
  userName: string;
  amountCents: number;
  walletBalanceCents: number;
  invoiceNumber: string | null;
}

export interface AllTransactionsKpiSummary {
  totalTransactions: number;
  totalVolume: number;
  failedOrPending: number;
  avgTransactionSize: number;
}

export interface AllTransactionsResponse {
  transactions: AllTransactionsRow[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
  kpiSummary: AllTransactionsKpiSummary;
}

export async function getAllAnalyticsTransactions(params: {
  page?: number;
  limit?: number;
  search?: string;
  status?: string;
  startDate?: string;
  endDate?: string;
}): Promise<AllTransactionsResponse | null> {
  const token = getAnalyticsAccessToken();
  if (!token || !API_BASE) return null;

  const searchParams = new URLSearchParams();
  if (params.page) searchParams.set('page', String(params.page));
  if (params.limit) searchParams.set('limit', String(params.limit));
  if (params.search) searchParams.set('search', params.search);
  if (params.status) searchParams.set('status', params.status);
  if (params.startDate) searchParams.set('startDate', params.startDate);
  if (params.endDate) searchParams.set('endDate', params.endDate);

  try {
    const res = await fetch(
      `${API_BASE}/api/dashboard/analytics/all-transactions?${searchParams.toString()}`,
      { headers: { Authorization: `Bearer ${token}` } }
    );
    if (!res.ok) return null;
    return res.json();
  } catch {
    return null;
  }
}

// ── Mentor Session API functions ──

export interface RequestEntry {
  id: string;
  userName: string;
  domain: string;
  serviceType: string;
  durationMinutes: number;
  earningsCents: number;
  studentUserId: string;
  subject: string | null;
  studentNotes: string | null;
  attachmentFileName: string | null;
  attachmentFilePath: string | null;
  createdAt: string;
}

export interface UpcomingEntry {
  id: string;
  userName: string;
  domain: string;
  serviceType: string;
  durationMinutes: number;
  fromTime: string;
  toTime: string;
  date: string;
  earningsCents: number;
  subject: string | null;
  studentNotes: string | null;
  attachmentFileName: string | null;
  attachmentFilePath: string | null;
  advanceCents: number | null;
  paymentStatus: string;
  studentUserId: string;
  scheduledFrom: string;
  scheduledTo: string;
}

export interface LiveSessionEntry {
  id: string;
  userName: string;
  domain: string;
  serviceType: string;
  startedAt: string;
  earningsCents: number;
  studentUserId: string;
  subject: string | null;
  studentNotes: string | null;
  attachmentFileName: string | null;
  attachmentFilePath: string | null;
}

export interface PastEntry {
  id: string;
  userName: string;
  domain: string;
  serviceType: string;
  durationMinutes: number;
  earningsCents: number;
  scheduledFrom: string;
  createdAt: string;
  status: 'Expired' | 'Approved' | 'Rejected' | 'Completed' | 'Cancelled' | 'Missed' | 'Disputed';
}

/** Fetch pending session requests for logged-in mentor */
export async function getMentorRequests(): Promise<RequestEntry[]> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/requests`);
  if (!res.ok) return [];
  return res.json();
}

/** Fetch upcoming sessions for logged-in mentor */
export async function getMentorUpcoming(): Promise<UpcomingEntry[]> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/upcoming`);
  if (!res.ok) return [];
  return res.json();
}

/** Fetch live sessions for logged-in mentor */
export async function getMentorLive(): Promise<LiveSessionEntry[]> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/live`);
  if (!res.ok) return [];
  return res.json();
}

/** Fetch past sessions for logged-in mentor */
export async function getMentorPast(): Promise<PastEntry[]> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/past`);
  if (!res.ok) return [];
  return res.json();
}

export interface StudentProfileDetail {
  email: string;
  emailVerified: boolean;
  authType: string;
  oauthProvider: string | null;
  phone: string | null;
  profession: string | null;
  skills: string[];
  githubUrl: string | null;
  linkedinUrl: string | null;
  websiteUrl: string | null;
  collegeName: string | null;
  departmentName: string | null;
  courseName: string | null;
  academicYear: number | null;
  expertiseLevel: string | null;
  lastLoginAt: string | null;
}

export async function getStudentProfile(studentUserId: string): Promise<StudentProfileDetail | null> {
  try {
    const token = getAccessToken();
    const res = await fetch(`${API_BASE}/api/mentor-sessions/student-profile/${studentUserId}`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (!res.ok) return null;
    return res.json();
  } catch {
    return null;
  }
}

export interface MentorProfileDetail {
  email: string;
  emailVerified: boolean;
  authType: string;
  oauthProvider: string | null;
  phone: string | null;
  profession: string | null;
  skills: string[];
  githubUrl: string | null;
  linkedinUrl: string | null;
  websiteUrl: string | null;
  collegeName: string | null;
  departmentName: string | null;
  courseName: string | null;
  academicYear: number | null;
  expertiseLevel: string | null;
  lastLoginAt: string | null;
}

export async function getMentorProfileForAccordion(mentorProfileId: string): Promise<MentorProfileDetail | null> {
  try {
    const token = getAccessToken();
    const res = await fetch(`${API_BASE}/api/mentor-sessions/mentor-profile/${mentorProfileId}`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (!res.ok) return null;
    return res.json();
  } catch {
    return null;
  }
}

/** Approve a pending session request */
export async function approveMentorSession(sessionId: string): Promise<boolean> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/${sessionId}/approve`, {
    method: 'POST',
  });
  return res.ok;
}

/** Reject a pending session request */
export async function rejectMentorSession(sessionId: string, reason?: string): Promise<boolean> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/${sessionId}/reject`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ reason }),
  });
  return res.ok;
}

/** Cancel an upcoming session (mentor side) */
export async function cancelMentorSession(sessionId: string, reason?: string): Promise<boolean> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/${sessionId}/cancel`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ reason }),
  });
  return res.ok;
}

/** Cancel an upcoming session (student side) */
export async function studentCancelMentorSession(sessionId: string, reason?: string): Promise<boolean> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/${sessionId}/student-cancel`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ reason }),
  });
  return res.ok;
}

// ── Mentor Calendar ─────────────────────────────────────────

export interface CalendarEvent {
  id: string;
  title: string;
  start: string;
  end: string;
  status: string;
  domain: string;
  serviceType: string;
  durationMinutes: number;
  earningsCents: number;
  userName: string;
}

/** Fetch all sessions for calendar view */
export async function getMentorCalendar(): Promise<CalendarEvent[]> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/calendar`);
  if (!res.ok) return [];
  return res.json();
}

// ── Mentor Availability Slots ──────────────────────────────

export interface AvailabilitySlot {
  id: string;
  dayOfWeek: number | null;
  specificDate: string | null;
  startTime: string;
  endTime: string;
  isRecurring: boolean;
}

/** Fetch all availability slots for the logged-in mentor */
export async function getMentorAvailability(): Promise<AvailabilitySlot[]> {
  const res = await apiFetch(`${API_BASE}/api/mentor/availability`);
  if (!res.ok) return [];
  return res.json();
}

/** Create a new availability slot */
export async function createMentorSlot(data: {
  dayOfWeek?: number;
  specificDate?: string;
  startTime: string;
  endTime: string;
  isRecurring: boolean;
}): Promise<AvailabilitySlot | null> {
  const res = await apiFetch(`${API_BASE}/api/mentor/availability`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  });
  if (!res.ok) return null;
  return res.json();
}

/** Delete an availability slot */
export async function deleteMentorSlot(id: string): Promise<boolean> {
  const res = await apiFetch(`${API_BASE}/api/mentor/availability/${id}`, {
    method: 'DELETE',
  });
  return res.ok;
}

// ── Blocked Dates (Day Off) ──

export interface BlockedDate {
  id: string;
  blockedDate: string;
  reason: string | null;
}

/** Fetch all blocked dates for the logged-in mentor */
export async function getBlockedDates(): Promise<BlockedDate[]> {
  const res = await apiFetch(`${API_BASE}/api/mentor/availability/blocked-dates`);
  if (!res.ok) return [];
  return res.json();
}

/** Block a date (Day Off) */
export async function blockDate(date: string, reason?: string): Promise<BlockedDate | null> {
  const res = await apiFetch(`${API_BASE}/api/mentor/availability/blocked-dates`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ date, reason }),
  });
  if (!res.ok) return null;
  return res.json();
}

/** Unblock a date */
export async function unblockDate(id: string): Promise<boolean> {
  const res = await apiFetch(`${API_BASE}/api/mentor/availability/blocked-dates/${id}`, {
    method: 'DELETE',
  });
  return res.ok;
}

// ── Mentor Billing Stats ──

export interface MentorBillingStats {
  totalEarningsCents: number;
  sessionsCompleted: number;
  mentoringHoursTotal: number;
  avgEarningsPerSessionCents: number;
  completionRate: number;
  effectiveHourlyRateCents: number;
  dailyEarnings: { date: string; earningsCents: number }[];
  dailyHours: { dayName: string; hours: number }[];
}

/** Fetch mentor billing/earnings stats */
export async function getMentorBillingStats(): Promise<MentorBillingStats | null> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/billing-stats`);
  if (!res.ok) return null;
  return res.json();
}

// ── Withdrawal ──

export interface WithdrawalRecord {
  id: string;
  amountCents: number;
  platformFeeCents: number;
  netPayoutCents: number;
  status: string;
  utr: string | null;
  failureReason: string | null;
  createdAt: string;
}

/** Request a withdrawal to bank account */
export async function requestWithdrawal(
  amountCents: number,
  accountNumber: string,
  ifscCode: string,
  accountHolderName: string,
): Promise<{ success: boolean; withdrawal?: WithdrawalRecord; error?: string }> {
  const res = await apiFetch(`${API_BASE}/api/withdrawal/request`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ amountCents, accountNumber, ifscCode, accountHolderName }),
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({ message: 'Withdrawal request failed' }));
    return { success: false, error: err.message || 'Withdrawal request failed' };
  }
  return res.json();
}

/** Get paginated withdrawal history */
export async function getWithdrawalHistory(
  page: number = 1,
  limit: number = 10,
): Promise<{ withdrawals: WithdrawalRecord[]; total: number; totalPages: number }> {
  const res = await apiFetch(`${API_BASE}/api/withdrawal/history?page=${page}&limit=${limit}`);
  if (!res.ok) return { withdrawals: [], total: 0, totalPages: 0 };
  return res.json();
}

/** Get withdrawable balance */
export async function getWithdrawableBalance(): Promise<{ balanceCents: number } | null> {
  const res = await apiFetch(`${API_BASE}/api/withdrawal/balance`);
  if (!res.ok) return null;
  return res.json();
}

// ── Mentor Explore ──

export interface MentorCard {
  id: string;
  userId: string;
  name: string;
  headline: string | null;
  expertiseAreas: string[];
  experienceYears: number | null;
  pricePerHourCents: number;
  currency: string;
  avgRating: number;
  totalReviews: number;
  totalSessions: number;
  isAvailable: boolean;
  country: string | null;
  company: string | null;
  professionalRole: string | null;
}

export interface MentorProfileDetail {
  id: string;
  userId: string;
  name: string;
  headline: string | null;
  bio: string | null;
  company: string | null;
  professionalRole: string | null;
  country: string | null;
  expertiseAreas: string[];
  languages: string[];
  experienceYears: number | null;
  pricePerHourCents: number;
  currency: string;
  avgRating: number;
  totalReviews: number;
  totalSessions: number;
  totalMentoringMinutes: number;
  isAvailable: boolean;
  lastLoginAt: string | null;
  skills: string[];
  githubUrl: string | null;
  linkedinUrl: string | null;
  websiteUrl: string | null;
  xUrl: string | null;
  substackUrl: string | null;
}

/** Fetch a single mentor public profile detail by ID */
export async function getPublicMentorProfile(mentorProfileId: string): Promise<MentorProfileDetail> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/profile/${mentorProfileId}`);
  return res.json();
}

/** Fetch mentors with search and filters */
export async function exploreMentors(params: {
  search?: string;
  domains?: string[];
  expertise?: string[];
  page?: number;
  limit?: number;
}): Promise<{ mentors: MentorCard[]; total: number; totalPages: number }> {
  const query = new URLSearchParams();
  if (params.search) query.set('search', params.search);
  if (params.domains?.length) query.set('domains', params.domains.join(','));
  if (params.expertise?.length) query.set('expertise', params.expertise.join(','));
  if (params.page) query.set('page', String(params.page));
  if (params.limit) query.set('limit', String(params.limit));
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/explore?${query.toString()}`);
  if (!res.ok) return { mentors: [], total: 0, totalPages: 0 };
  return res.json();
}

// ── Booking API ─────────────────────────────────────────────

export interface TimeSlot {
  startTime: string;
  endTime: string;
}

export interface BookSessionRequest {
  mentorProfileId: string;
  category: string;
  scheduledDate: string;
  startTime: string;
  durationMinutes: number;
  subject: string;
  description: string;
  attachmentFileName?: string;
  attachmentFilePath?: string;
  attachmentMimeType?: string;
  attachmentSizeBytes?: number;
}

export interface BookMeetNowRequest {
  mentorProfileId: string;
  category: string;
  durationMinutes: number;
  subject: string;
  description: string;
  attachmentFileName?: string;
  attachmentFilePath?: string;
  attachmentMimeType?: string;
  attachmentSizeBytes?: number;
}

export interface MeetNowAvailability {
  available: boolean;
  reason?: string;
}

export interface StudentUpcomingSession {
  id: string;
  mentorName: string;
  mentorHeadline: string | null;
  mentorCompany: string | null;
  mentorProfileId: string;
  scheduledFrom: string;
  scheduledTo: string;
  durationMinutes: number;
  domain: string;
  serviceType: string;
  paymentStatus: string;
  earningsCents: number;
  advanceCents: number | null;
  subject: string | null;
  studentNotes: string | null;
  attachmentFileName: string | null;
  attachmentFilePath: string | null;
}

export interface StudentRequestEntry {
  id: string;
  mentorName: string;
  mentorProfileId: string;
  domain: string;
  serviceType: string;
  durationMinutes: number;
  earningsCents: number;
  subject: string | null;
  studentNotes: string | null;
  attachmentFileName: string | null;
  attachmentFilePath: string | null;
  createdAt: string;
}

export interface StudentPastEntry {
  id: string;
  mentorName: string;
  domain: string;
  serviceType: string;
  durationMinutes: number;
  earningsCents: number;
  advanceCents: number | null;
  cancelledByStudent: boolean;
  scheduledFrom: string;
  createdAt: string;
  status: 'Completed' | 'Cancelled' | 'Rejected' | 'Expired' | 'Missed' | 'Disputed';
}

/** Get available time slots for a mentor on a specific date */
export async function getAvailableSlots(
  mentorProfileId: string,
  date: string,
): Promise<{ date: string; slots: TimeSlot[] }> {
  const res = await apiFetch(
    `${API_BASE}/api/mentor-sessions/available-slots/${mentorProfileId}?date=${date}`,
  );
  if (!res.ok) return { date, slots: [] };
  return res.json();
}

/** Get dates in a month that have at least one available slot */
export async function getAvailableDates(
  mentorProfileId: string,
  month: string,
): Promise<{ dates: string[] }> {
  const res = await apiFetch(
    `${API_BASE}/api/mentor-sessions/available-slots/${mentorProfileId}/calendar?month=${month}`,
  );
  if (!res.ok) return { dates: [] };
  return res.json();
}

/** Upload a file attachment for a mentoring session */
export async function uploadMentorAttachment(file: File): Promise<{
  fileName: string;
  filePath: string;
  mimeType: string;
  sizeBytes: number;
}> {
  const formData = new FormData();
  formData.append('file', file);
  const token = getAccessToken();
  const res = await fetch(`${API_BASE}/api/mentor-sessions/upload-attachment`, {
    method: 'POST',
    headers: token ? { Authorization: `Bearer ${token}` } : {},
    body: formData,
  });
  if (!res.ok) throw new Error('Upload failed');
  return res.json();
}

/** Book a mentoring session */
export async function bookMentorSession(data: BookSessionRequest): Promise<{ sessionId: string }> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/book`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({ message: 'Booking failed' }));
    throw new Error(err.message || 'Booking failed');
  }
  return res.json();
}

/** Book a Meet Now session (full payment, no advance) */
export async function bookMeetNowSession(data: BookMeetNowRequest): Promise<{ sessionId: string }> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/book-meet-now`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({ message: 'Booking failed' }));
    throw new Error(err.message || 'Booking failed');
  }
  return res.json();
}

/** Check if mentor is available for a Meet Now session */
export async function checkMeetNowAvailability(mentorProfileId: string): Promise<MeetNowAvailability> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/check-availability/${mentorProfileId}`);
  if (!res.ok) return { available: false, reason: 'Unable to check availability' };
  return res.json();
}

/** Get student's upcoming sessions */
export async function getStudentUpcomingSessions(): Promise<StudentUpcomingSession[]> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/student-upcoming`);
  if (!res.ok) return [];
  return res.json();
}

/** Get student's pending session requests */
export async function getStudentSessionRequests(): Promise<StudentRequestEntry[]> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/student-requests`);
  if (!res.ok) return [];
  return res.json();
}

/** Get student's past sessions */
export async function getStudentSessionPast(): Promise<StudentPastEntry[]> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/student-past`);
  if (!res.ok) return [];
  return res.json();
}

/** Get student's live sessions */
export interface StudentLiveEntry {
  id: string;
  mentorName: string;
  mentorProfileId: string;
  startedAt: string;
  durationMinutes: number;
  domain: string;
  serviceType: string;
  earningsCents: number;
}

export async function getStudentLiveSessions(): Promise<StudentLiveEntry[]> {
  const res = await apiFetch(`${API_BASE}/api/mentor-sessions/student-live`);
  if (!res.ok) return [];
  return res.json();
}
