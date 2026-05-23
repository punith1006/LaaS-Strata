ALTER TABLE recommendation_sessions ADD COLUMN IF NOT EXISTS consumed_at TIMESTAMPTZ;

-- Create index on consumed_at for faster lookups
CREATE INDEX IF NOT EXISTS recommendation_sessions_consumed_at_idx ON recommendation_sessions (consumed_at);
