ALTER TABLE mentor_sessions ADD COLUMN IF NOT EXISTS category "MentorSessionCategory" NOT NULL DEFAULT 'consultation';
ALTER TABLE mentor_sessions ADD COLUMN IF NOT EXISTS jitsi_room_name VARCHAR(255) NULL;
ALTER TABLE mentor_sessions ADD COLUMN IF NOT EXISTS jwt_token TEXT NULL;
ALTER TABLE mentor_sessions ADD COLUMN IF NOT EXISTS jwt_expires_at TIMESTAMPTZ NULL;
