SELECT 'ALL BILLING CHARGES' as section;
SELECT id, charge_type, amount_cents, duration_seconds, rate_cents_per_hour, created_at, session_id 
FROM "BillingCharge" 
ORDER BY created_at ASC;

SELECT 'REVENUE BY PERIOD' as section;
SELECT 
  (SELECT COALESCE(SUM(amount_cents), 0) FROM "BillingCharge" WHERE created_at >= NOW() - INTERVAL '24 hours') as revenue_24h,
  (SELECT COALESCE(SUM(amount_cents), 0) FROM "BillingCharge" WHERE created_at >= NOW() - INTERVAL '7 days') as revenue_7d,
  (SELECT COALESCE(SUM(amount_cents), 0) FROM "BillingCharge" WHERE created_at >= NOW() - INTERVAL '30 days') as revenue_30d,
  (SELECT COALESCE(SUM(amount_cents), 0) FROM "BillingCharge") as revenue_all;

SELECT 'ALL SESSIONS' as section;
SELECT id, status, started_at, ended_at, duration_seconds, cumulative_cost_cents
FROM "Session"
ORDER BY created_at ASC;

SELECT 'GPU HOURS' as section;
SELECT 
  (SELECT COUNT(*) FROM "Session" WHERE status IN ('ended', 'terminated_idle', 'terminated_overuse') AND ended_at >= NOW() - INTERVAL '24 hours') as ended_24h_count,
  (SELECT COALESCE(SUM(duration_seconds), 0) / 3600.0 FROM "Session" WHERE status IN ('ended', 'terminated_idle', 'terminated_overuse') AND ended_at >= NOW() - INTERVAL '24 hours') as ended_24h_hours,
  (SELECT COUNT(*) FROM "Session" WHERE status IN ('ended', 'terminated_idle', 'terminated_overuse') AND ended_at >= NOW() - INTERVAL '7 days') as ended_7d_count,
  (SELECT COALESCE(SUM(duration_seconds), 0) / 3600.0 FROM "Session" WHERE status IN ('ended', 'terminated_idle', 'terminated_overuse') AND ended_at >= NOW() - INTERVAL '7 days') as ended_7d_hours,
  (SELECT COUNT(*) FROM "Session" WHERE status = 'running' AND started_at IS NOT NULL) as running_sessions;

SELECT 'USERS' as section;
SELECT id, email, is_active, created_at, last_login_at
FROM "User"
ORDER BY created_at ASC;
