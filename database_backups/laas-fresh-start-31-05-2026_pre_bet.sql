--
-- PostgreSQL database dump
--

\restrict lo0SsjafQpT6RxGbtz0V9Pm2xQc6gw72pu7231HBDfbE7iiZ8y9aTrIftZIbyDo

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-05-31 17:12:04

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 6175 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- TOC entry 932 (class 1247 OID 151083)
-- Name: AuthType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."AuthType" AS ENUM (
    'university_sso',
    'public_local',
    'public_oauth'
);


ALTER TYPE public."AuthType" OWNER TO postgres;

--
-- TOC entry 935 (class 1247 OID 151090)
-- Name: BookingStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."BookingStatus" AS ENUM (
    'scheduled',
    'launched',
    'completed',
    'cancelled',
    'no_show',
    'expired'
);


ALTER TYPE public."BookingStatus" OWNER TO postgres;

--
-- TOC entry 1217 (class 1247 OID 187106)
-- Name: MentorPaymentRecordStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."MentorPaymentRecordStatus" AS ENUM (
    'held',
    'released',
    'refunded'
);


ALTER TYPE public."MentorPaymentRecordStatus" OWNER TO postgres;

--
-- TOC entry 1211 (class 1247 OID 187090)
-- Name: MentorPaymentStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."MentorPaymentStatus" AS ENUM (
    'unpaid',
    'advance_paid',
    'fully_paid'
);


ALTER TYPE public."MentorPaymentStatus" OWNER TO postgres;

--
-- TOC entry 1214 (class 1247 OID 187098)
-- Name: MentorPaymentType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."MentorPaymentType" AS ENUM (
    'advance',
    'balance',
    'full'
);


ALTER TYPE public."MentorPaymentType" OWNER TO postgres;

--
-- TOC entry 1238 (class 1247 OID 196972)
-- Name: MentorSessionCategory; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."MentorSessionCategory" AS ENUM (
    'consultation',
    'project_review',
    'concept_exploration',
    'hands_on'
);


ALTER TYPE public."MentorSessionCategory" OWNER TO postgres;

--
-- TOC entry 1241 (class 1247 OID 196982)
-- Name: MentorSessionStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."MentorSessionStatus" AS ENUM (
    'pending',
    'scheduled',
    'live',
    'completed',
    'cancelled',
    'rejected',
    'request_expired',
    'rescheduled',
    'missed',
    'disputed'
);


ALTER TYPE public."MentorSessionStatus" OWNER TO postgres;

--
-- TOC entry 1235 (class 1247 OID 196942)
-- Name: MentorSessionType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."MentorSessionType" AS ENUM (
    'mentorship',
    'mock_interview',
    'career_guidance',
    'doubt_clearing',
    'meet_now',
    'slot_booking'
);


ALTER TYPE public."MentorSessionType" OWNER TO postgres;

--
-- TOC entry 938 (class 1247 OID 151104)
-- Name: NodeStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."NodeStatus" AS ENUM (
    'healthy',
    'degraded',
    'offline',
    'maintenance',
    'draining',
    '
inactive
',
    'inactive'
);


ALTER TYPE public."NodeStatus" OWNER TO postgres;

--
-- TOC entry 941 (class 1247 OID 151116)
-- Name: OrgType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."OrgType" AS ENUM (
    'university',
    'partner_college',
    'enterprise',
    'public_'
);


ALTER TYPE public."OrgType" OWNER TO postgres;

--
-- TOC entry 944 (class 1247 OID 151126)
-- Name: ReferralConversionStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ReferralConversionStatus" AS ENUM (
    'SIGNUP_COMPLETED',
    'PAYMENT_PENDING',
    'QUALIFIED',
    'REWARD_CREDITED',
    'REWARD_VOIDED',
    'EXPIRED'
);


ALTER TYPE public."ReferralConversionStatus" OWNER TO postgres;

--
-- TOC entry 947 (class 1247 OID 151140)
-- Name: ReferralRewardStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ReferralRewardStatus" AS ENUM (
    'PENDING',
    'CREDITED',
    'VOIDED'
);


ALTER TYPE public."ReferralRewardStatus" OWNER TO postgres;

--
-- TOC entry 950 (class 1247 OID 151148)
-- Name: SessionStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."SessionStatus" AS ENUM (
    'pending',
    'starting',
    'running',
    'reconnecting',
    'stopping',
    'ended',
    'failed',
    'terminated_idle',
    'terminated_overuse'
);


ALTER TYPE public."SessionStatus" OWNER TO postgres;

--
-- TOC entry 953 (class 1247 OID 151168)
-- Name: SessionTerminationReason; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."SessionTerminationReason" AS ENUM (
    'user_requested',
    'idle_timeout',
    'resource_exhaustion',
    'spend_limit_exceeded',
    'node_failure',
    'node_maintenance',
    'admin_terminated',
    'session_expired',
    'booking_expired',
    'error_unrecoverable',
    'network_disconnect',
    'quota_exceeded',
    'credit_exhausted'
);


ALTER TYPE public."SessionTerminationReason" OWNER TO postgres;

--
-- TOC entry 956 (class 1247 OID 151196)
-- Name: SessionType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."SessionType" AS ENUM (
    'stateful_desktop',
    'ephemeral_jupyter',
    'ephemeral_codeserver',
    'ephemeral_cli'
);


ALTER TYPE public."SessionType" OWNER TO postgres;

--
-- TOC entry 959 (class 1247 OID 151206)
-- Name: StorageBackend; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."StorageBackend" AS ENUM (
    'zfs_dataset',
    'zfs_zvol'
);


ALTER TYPE public."StorageBackend" OWNER TO postgres;

--
-- TOC entry 962 (class 1247 OID 151212)
-- Name: StorageMode; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."StorageMode" AS ENUM (
    'stateful',
    'ephemeral'
);


ALTER TYPE public."StorageMode" OWNER TO postgres;

--
-- TOC entry 965 (class 1247 OID 151218)
-- Name: StorageTransport; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."StorageTransport" AS ENUM (
    'local_zfs',
    'nvmeof_tcp'
);


ALTER TYPE public."StorageTransport" OWNER TO postgres;

--
-- TOC entry 968 (class 1247 OID 151224)
-- Name: StorageVolumeStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."StorageVolumeStatus" AS ENUM (
    'provisioning',
    'active',
    'wiping',
    'wiped',
    'error',
    'migrating'
);


ALTER TYPE public."StorageVolumeStatus" OWNER TO postgres;

--
-- TOC entry 971 (class 1247 OID 151238)
-- Name: SubscriptionStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."SubscriptionStatus" AS ENUM (
    'active',
    'past_due',
    'cancelled',
    'expired'
);


ALTER TYPE public."SubscriptionStatus" OWNER TO postgres;

--
-- TOC entry 974 (class 1247 OID 151248)
-- Name: TicketPriority; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."TicketPriority" AS ENUM (
    'low',
    'medium',
    'high',
    'critical'
);


ALTER TYPE public."TicketPriority" OWNER TO postgres;

--
-- TOC entry 977 (class 1247 OID 151258)
-- Name: TicketStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."TicketStatus" AS ENUM (
    'open',
    'in_progress',
    'waiting_on_user',
    'resolved',
    'closed'
);


ALTER TYPE public."TicketStatus" OWNER TO postgres;

--
-- TOC entry 980 (class 1247 OID 151270)
-- Name: WalletHoldStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."WalletHoldStatus" AS ENUM (
    'active',
    'captured',
    'released',
    'expired'
);


ALTER TYPE public."WalletHoldStatus" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 151279)
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 151291)
-- Name: achievements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.achievements (
    id uuid NOT NULL,
    slug character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    description text,
    icon_url character varying(512),
    category character varying(64),
    criteria jsonb,
    points integer DEFAULT 0 NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.achievements OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 151304)
-- Name: announcements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.announcements (
    id uuid NOT NULL,
    organization_id uuid,
    title character varying(255) NOT NULL,
    body text,
    severity character varying(32) NOT NULL,
    published_at timestamp(3) without time zone,
    expires_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    deleted_at timestamp(3) without time zone,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.announcements OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 151315)
-- Name: audit_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_log (
    id uuid NOT NULL,
    actor_id uuid,
    actor_role character varying(64),
    org_id uuid,
    action character varying(64) NOT NULL,
    resource_type character varying(64) NOT NULL,
    resource_id uuid,
    old_data jsonb,
    new_data jsonb,
    client_ip text,
    user_agent text,
    action_reason text,
    request_id character varying(64),
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.audit_log OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 151325)
-- Name: base_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.base_images (
    id uuid NOT NULL,
    tag text NOT NULL,
    os_name text,
    description text,
    size_bytes bigint,
    software_manifest jsonb,
    is_default boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.base_images OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 151337)
-- Name: billing_charges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.billing_charges (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    session_id uuid,
    compute_config_id uuid,
    duration_seconds integer NOT NULL,
    rate_cents_per_hour integer NOT NULL,
    amount_cents bigint NOT NULL,
    currency text DEFAULT 'INR'::text NOT NULL,
    wallet_transaction_id uuid,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid,
    charge_type text DEFAULT 'compute'::text NOT NULL,
    quota_gb integer,
    storage_volume_id uuid,
    cost_classification text DEFAULT 'revenue'::text NOT NULL
);


ALTER TABLE public.billing_charges OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 151353)
-- Name: bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookings (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    organization_id uuid,
    compute_config_id uuid NOT NULL,
    node_id uuid,
    required_vcpu integer,
    required_memory_mb integer,
    required_gpu_vram_mb integer,
    scheduled_start_at timestamp(3) without time zone NOT NULL,
    scheduled_end_at timestamp(3) without time zone NOT NULL,
    status public."BookingStatus" NOT NULL,
    cancellation_reason text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.bookings OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 151367)
-- Name: compute_config_access; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compute_config_access (
    id uuid NOT NULL,
    compute_config_id uuid NOT NULL,
    organization_id uuid,
    role_id uuid,
    is_allowed boolean DEFAULT true NOT NULL,
    price_override_cents integer,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.compute_config_access OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 151377)
-- Name: compute_configs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compute_configs (
    id uuid NOT NULL,
    slug text NOT NULL,
    name text NOT NULL,
    description text,
    session_type public."SessionType" NOT NULL,
    tier text,
    vcpu integer NOT NULL,
    memory_mb integer NOT NULL,
    gpu_vram_mb integer DEFAULT 0 NOT NULL,
    gpu_exclusive boolean DEFAULT false NOT NULL,
    hami_sm_percent integer,
    base_price_per_hour_cents integer NOT NULL,
    currency text DEFAULT 'INR'::text NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid,
    best_for text,
    gpu_model text,
    max_concurrent_per_node integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.compute_configs OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 151404)
-- Name: course_enrollments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_enrollments (
    id uuid NOT NULL,
    course_id uuid NOT NULL,
    user_id uuid NOT NULL,
    status character varying(32) DEFAULT 'enrolled'::character varying NOT NULL,
    enrolled_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.course_enrollments OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 151415)
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    id uuid NOT NULL,
    organization_id uuid NOT NULL,
    department_id uuid,
    instructor_id uuid NOT NULL,
    title character varying(255) NOT NULL,
    code character varying(32),
    description text,
    semester character varying(32),
    academic_year character varying(16),
    status character varying(32) DEFAULT 'draft'::character varying NOT NULL,
    default_compute_config_id uuid,
    max_students integer,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    deleted_at timestamp(3) without time zone,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 151429)
-- Name: coursework_content; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coursework_content (
    id uuid NOT NULL,
    organization_id uuid,
    category character varying(64) NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    content_url character varying(512),
    thumbnail_url character varying(512),
    difficulty_level character varying(32),
    tags text[],
    is_featured boolean DEFAULT false NOT NULL,
    view_count integer DEFAULT 0 NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    deleted_at timestamp(3) without time zone,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.coursework_content OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 151444)
-- Name: credit_packages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.credit_packages (
    id uuid NOT NULL,
    name text NOT NULL,
    amount_cents integer NOT NULL,
    credit_cents integer NOT NULL,
    bonus_cents integer DEFAULT 0 NOT NULL,
    validity_days integer,
    is_active boolean DEFAULT true NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.credit_packages OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 151462)
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    id uuid NOT NULL,
    university_id uuid NOT NULL,
    parent_id uuid,
    name text NOT NULL,
    code text,
    slug text NOT NULL,
    head_user_id uuid,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    deleted_at timestamp(3) without time zone,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 151476)
-- Name: discussion_replies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discussion_replies (
    id uuid NOT NULL,
    discussion_id uuid NOT NULL,
    parent_reply_id uuid,
    author_id uuid NOT NULL,
    body text NOT NULL,
    is_accepted_answer boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    deleted_at timestamp(3) without time zone,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.discussion_replies OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 151490)
-- Name: discussions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discussions (
    id uuid NOT NULL,
    organization_id uuid,
    course_id uuid,
    lab_id uuid,
    author_id uuid NOT NULL,
    title character varying(255) NOT NULL,
    body text NOT NULL,
    is_pinned boolean DEFAULT false NOT NULL,
    is_locked boolean DEFAULT false NOT NULL,
    reply_count integer DEFAULT 0 NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    deleted_at timestamp(3) without time zone,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.discussions OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 151508)
-- Name: feature_flags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feature_flags (
    id uuid NOT NULL,
    key character varying(128) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    rollout_percent integer DEFAULT 100 NOT NULL,
    allowed_org_ids text[],
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.feature_flags OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 151522)
-- Name: invoice_line_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice_line_items (
    id uuid NOT NULL,
    invoice_id uuid NOT NULL,
    description text NOT NULL,
    quantity integer NOT NULL,
    unit_price_cents integer NOT NULL,
    total_cents bigint NOT NULL,
    reference_type text,
    reference_id uuid,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.invoice_line_items OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 151535)
-- Name: invoices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoices (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    organization_id uuid,
    invoice_number text NOT NULL,
    period_start timestamp(3) without time zone NOT NULL,
    period_end timestamp(3) without time zone NOT NULL,
    subtotal_cents bigint NOT NULL,
    tax_cents bigint DEFAULT 0 NOT NULL,
    total_cents bigint NOT NULL,
    currency text DEFAULT 'INR'::text NOT NULL,
    status text NOT NULL,
    issued_at timestamp(3) without time zone,
    paid_at timestamp(3) without time zone,
    pdf_url text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.invoices OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 151555)
-- Name: lab_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lab_assignments (
    id uuid NOT NULL,
    lab_id uuid NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    instructions text,
    due_at timestamp(3) without time zone,
    max_score numeric(6,2) DEFAULT 100,
    allow_late_submission boolean DEFAULT false NOT NULL,
    late_penalty_percent integer DEFAULT 0 NOT NULL,
    max_attempts integer DEFAULT 1 NOT NULL,
    rubric jsonb,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    deleted_at timestamp(3) without time zone,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.lab_assignments OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 151575)
-- Name: lab_grades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lab_grades (
    id uuid NOT NULL,
    submission_id uuid NOT NULL,
    graded_by uuid NOT NULL,
    score numeric(6,2),
    max_score numeric(6,2),
    feedback text,
    rubric_scores jsonb,
    graded_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.lab_grades OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 151586)
-- Name: lab_group_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lab_group_assignments (
    id uuid NOT NULL,
    lab_id uuid NOT NULL,
    user_group_id uuid NOT NULL,
    assigned_by uuid NOT NULL,
    available_from timestamp(3) without time zone,
    available_until timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.lab_group_assignments OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 151596)
-- Name: lab_submissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lab_submissions (
    id uuid NOT NULL,
    lab_assignment_id uuid NOT NULL,
    user_id uuid NOT NULL,
    session_id uuid,
    attempt_number integer DEFAULT 1 NOT NULL,
    status character varying(32) NOT NULL,
    submitted_at timestamp(3) without time zone,
    file_ids text[],
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.lab_submissions OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 151610)
-- Name: labs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.labs (
    id uuid NOT NULL,
    course_id uuid,
    organization_id uuid NOT NULL,
    created_by_user_id uuid NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    instructions text,
    compute_config_id uuid,
    base_image_id uuid,
    preloaded_notebook_url character varying(512),
    preloaded_dataset_urls text[],
    max_duration_minutes integer,
    status character varying(32) DEFAULT 'draft'::character varying NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    deleted_at timestamp(3) without time zone,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.labs OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 151624)
-- Name: login_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login_history (
    login_method text,
    ip_address text,
    user_agent text,
    "geoLocation" jsonb,
    success boolean NOT NULL,
    failure_reason text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid,
    id uuid NOT NULL,
    user_id uuid NOT NULL
);


ALTER TABLE public.login_history OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 151634)
-- Name: mentor_availability_slots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mentor_availability_slots (
    id uuid NOT NULL,
    mentor_profile_id uuid NOT NULL,
    day_of_week integer,
    specific_date date,
    start_time text NOT NULL,
    end_time text NOT NULL,
    is_recurring boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.mentor_availability_slots OWNER TO postgres;

--
-- TOC entry 298 (class 1259 OID 196790)
-- Name: mentor_blocked_dates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mentor_blocked_dates (
    id uuid NOT NULL,
    mentor_profile_id uuid NOT NULL,
    blocked_date date NOT NULL,
    reason character varying(255),
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.mentor_blocked_dates OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 151648)
-- Name: mentor_bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mentor_bookings (
    id uuid NOT NULL,
    mentor_profile_id uuid NOT NULL,
    student_user_id uuid NOT NULL,
    scheduled_at timestamp(3) without time zone NOT NULL,
    duration_minutes integer DEFAULT 60 NOT NULL,
    status character varying(32) NOT NULL,
    meeting_url character varying(512),
    payment_transaction_id uuid,
    amount_cents integer,
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.mentor_bookings OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 151663)
-- Name: mentor_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mentor_profiles (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    headline character varying(255),
    bio text,
    expertise_areas text[],
    experience_years integer,
    price_per_hour_cents integer NOT NULL,
    currency character varying(3) DEFAULT 'INR'::character varying NOT NULL,
    is_available boolean DEFAULT true NOT NULL,
    avg_rating numeric(3,2) DEFAULT 0,
    total_reviews integer DEFAULT 0 NOT NULL,
    total_sessions integer DEFAULT 0 NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid,
    city character varying(150),
    company character varying(255),
    country character varying(100),
    languages text[],
    professional_role character varying(255)
);


ALTER TABLE public.mentor_profiles OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 151683)
-- Name: mentor_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mentor_reviews (
    id uuid NOT NULL,
    mentor_booking_id uuid NOT NULL,
    reviewer_user_id uuid NOT NULL,
    rating integer NOT NULL,
    review_text text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.mentor_reviews OWNER TO postgres;

--
-- TOC entry 297 (class 1259 OID 187152)
-- Name: mentor_session_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mentor_session_payments (
    id uuid NOT NULL,
    mentor_session_id uuid NOT NULL,
    amount_cents integer NOT NULL,
    payment_type public."MentorPaymentType" NOT NULL,
    payer_user_id uuid NOT NULL,
    payee_user_id uuid NOT NULL,
    status public."MentorPaymentRecordStatus" NOT NULL,
    wallet_transaction_id uuid,
    released_at timestamp(3) without time zone,
    refunded_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.mentor_session_payments OWNER TO postgres;

--
-- TOC entry 296 (class 1259 OID 187138)
-- Name: mentor_session_status_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mentor_session_status_history (
    id uuid NOT NULL,
    mentor_session_id uuid NOT NULL,
    from_status public."MentorSessionStatus" NOT NULL,
    to_status public."MentorSessionStatus" NOT NULL,
    changed_by character varying(36) NOT NULL,
    reason text,
    "timestamp" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.mentor_session_status_history OWNER TO postgres;

--
-- TOC entry 295 (class 1259 OID 187113)
-- Name: mentor_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mentor_sessions (
    id uuid NOT NULL,
    type public."MentorSessionType" NOT NULL,
    status public."MentorSessionStatus" NOT NULL,
    payment_status public."MentorPaymentStatus" DEFAULT 'unpaid'::public."MentorPaymentStatus" NOT NULL,
    mentor_profile_id uuid NOT NULL,
    student_user_id uuid NOT NULL,
    requested_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    approved_at timestamp(3) without time zone,
    scheduled_from timestamp(3) without time zone,
    scheduled_to timestamp(3) without time zone,
    started_at timestamp(3) without time zone,
    ended_at timestamp(3) without time zone,
    duration_minutes integer NOT NULL,
    domain character varying(255) NOT NULL,
    service_type character varying(255) NOT NULL,
    earnings_cents integer DEFAULT 0 NOT NULL,
    advance_cents integer,
    balance_cents integer,
    rescheduled_to_id uuid,
    student_notes text,
    mentor_notes text,
    cancel_reason text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid,
    attachment_file_name character varying(255),
    attachment_file_path character varying(512),
    attachment_mime_type character varying(100),
    attachment_size_bytes integer,
    cancelled_by uuid,
    last_reminder_at timestamp(3) without time zone,
    mentor_fee_cents integer DEFAULT 0 NOT NULL,
    platform_fee_cents integer DEFAULT 0 NOT NULL,
    expires_at timestamp with time zone,
    category public."MentorSessionCategory" DEFAULT 'consultation'::public."MentorSessionCategory" NOT NULL,
    jitsi_room_name character varying(255),
    jwt_token text,
    jwt_expires_at timestamp with time zone,
    subject character varying(255)
);


ALTER TABLE public.mentor_sessions OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 151695)
-- Name: node_base_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.node_base_images (
    node_id uuid NOT NULL,
    base_image_id uuid NOT NULL,
    status text NOT NULL,
    pulled_at timestamp(3) without time zone,
    error_message text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.node_base_images OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 151706)
-- Name: node_resource_reservations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.node_resource_reservations (
    id uuid NOT NULL,
    node_id uuid NOT NULL,
    session_id uuid NOT NULL,
    reserved_vcpu integer NOT NULL,
    reserved_memory_mb integer NOT NULL,
    reserved_gpu_vram_mb integer NOT NULL,
    reserved_hami_sm_percent integer,
    reserved_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    released_at timestamp(3) without time zone,
    status text DEFAULT 'reserved'::text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.node_resource_reservations OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 151724)
-- Name: nodes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nodes (
    id uuid NOT NULL,
    hostname text NOT NULL,
    display_name text,
    ip_management text,
    ip_compute text,
    ip_storage text,
    cpu_model text,
    total_vcpu integer NOT NULL,
    total_memory_mb integer NOT NULL,
    total_gpu_vram_mb integer NOT NULL,
    gpu_model text,
    nvme_total_gb integer,
    allocated_vcpu integer DEFAULT 0 NOT NULL,
    allocated_memory_mb integer DEFAULT 0 NOT NULL,
    allocated_gpu_vram_mb integer DEFAULT 0 NOT NULL,
    max_concurrent_sessions integer,
    status public."NodeStatus" NOT NULL,
    last_heartbeat_at timestamp(3) without time zone,
    metadata jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid,
    current_session_count integer DEFAULT 0 NOT NULL,
    last_resource_sync_at timestamp(3) without time zone,
    session_orchestration_port integer DEFAULT 9998 NOT NULL,
    storage_provision_port integer DEFAULT 9999 NOT NULL,
    nvme_of_port integer DEFAULT 4420 NOT NULL,
    storage_headroom_gb integer DEFAULT 15 NOT NULL
);


ALTER TABLE public.nodes OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 151754)
-- Name: notification_templates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_templates (
    id uuid NOT NULL,
    slug character varying(128) NOT NULL,
    channel character varying(32) NOT NULL,
    subject_template character varying(512),
    body_template text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.notification_templates OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 151766)
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    template_id uuid,
    channel character varying(32) NOT NULL,
    title character varying(255),
    body text,
    data jsonb,
    status character varying(32) NOT NULL,
    sent_at timestamp(3) without time zone,
    read_at timestamp(3) without time zone,
    delivery_attempts integer DEFAULT 0 NOT NULL,
    last_delivery_error character varying(512),
    delivery_confirmed_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 151779)
-- Name: org_contracts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.org_contracts (
    id uuid NOT NULL,
    organization_id uuid NOT NULL,
    contract_name text,
    starts_at timestamp(3) without time zone NOT NULL,
    ends_at timestamp(3) without time zone,
    max_seats integer,
    billing_model text,
    total_credits_cents bigint,
    used_credits_cents bigint DEFAULT 0 NOT NULL,
    status text NOT NULL,
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.org_contracts OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 151793)
-- Name: org_resource_quotas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.org_resource_quotas (
    id uuid NOT NULL,
    organization_id uuid NOT NULL,
    max_concurrent_sessions_per_org integer,
    max_concurrent_stateful_per_user integer DEFAULT 1 NOT NULL,
    max_concurrent_ephemeral_per_user integer DEFAULT 3 NOT NULL,
    max_registered_users integer,
    max_storage_per_user_mb integer DEFAULT 15360 NOT NULL,
    allowed_session_types text[],
    max_booking_hours_per_day integer,
    max_gpu_vram_mb_total integer,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.org_resource_quotas OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 151809)
-- Name: organizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organizations (
    name text NOT NULL,
    slug text NOT NULL,
    logo_url text,
    billing_email text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    deleted_at timestamp(3) without time zone,
    created_by uuid,
    updated_by uuid,
    id uuid NOT NULL,
    org_type public."OrgType" NOT NULL,
    university_id uuid
);


ALTER TABLE public.organizations OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 151823)
-- Name: os_switch_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.os_switch_history (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    old_os text,
    new_os text NOT NULL,
    old_volume_id uuid,
    new_volume_id uuid,
    confirmation_text text,
    ip_address text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid
);


ALTER TABLE public.os_switch_history OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 151833)
-- Name: otp_verifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otp_verifications (
    email text NOT NULL,
    code_hash text NOT NULL,
    purpose text NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    expires_at timestamp(3) without time zone NOT NULL,
    used_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    id uuid NOT NULL,
    user_id uuid
);


ALTER TABLE public.otp_verifications OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 151847)
-- Name: payment_transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_transactions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    gateway text NOT NULL,
    gateway_txn_id text,
    gateway_order_id text,
    amount_cents integer NOT NULL,
    currency text DEFAULT 'INR'::text NOT NULL,
    status text NOT NULL,
    gateway_response jsonb,
    refund_amount_cents integer,
    refunded_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.payment_transactions OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 151862)
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    code text NOT NULL,
    description text,
    module text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid,
    id uuid NOT NULL
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 151872)
-- Name: project_showcases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_showcases (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    organization_id uuid,
    title character varying(255) NOT NULL,
    description text,
    project_url character varying(512),
    thumbnail_url character varying(512),
    tags text[],
    is_featured boolean DEFAULT false NOT NULL,
    view_count integer DEFAULT 0 NOT NULL,
    like_count integer DEFAULT 0 NOT NULL,
    status character varying(32) DEFAULT 'draft'::character varying NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    deleted_at timestamp(3) without time zone,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.project_showcases OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 151891)
-- Name: recommendation_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recommendation_sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    workload_description text,
    document_file_name text,
    document_extracted_text text,
    analysis_result jsonb,
    analysis_quality text,
    analysis_confidence double precision,
    detected_goal text,
    detected_vram_gb double precision,
    detected_intensity text,
    detected_frameworks text[] DEFAULT ARRAY[]::text[],
    selected_goal text,
    selected_dataset_size text,
    selected_intensity integer,
    selected_budget_type text,
    selected_budget_amount integer,
    selected_duration text,
    goal_auto_selected boolean DEFAULT false NOT NULL,
    dataset_auto_selected boolean DEFAULT false NOT NULL,
    intensity_auto_selected boolean DEFAULT false NOT NULL,
    recommendations jsonb,
    selected_config_slug text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    completed_at timestamp(3) without time zone,
    consumed_at timestamp(3) without time zone,
    selected_project_duration text
);


ALTER TABLE public.recommendation_sessions OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 151908)
-- Name: referral_conversions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.referral_conversions (
    id uuid NOT NULL,
    referral_id uuid NOT NULL,
    referrer_user_id uuid NOT NULL,
    referred_user_id uuid NOT NULL,
    status public."ReferralConversionStatus" DEFAULT 'SIGNUP_COMPLETED'::public."ReferralConversionStatus" NOT NULL,
    signup_method character varying(50) NOT NULL,
    signup_completed_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    first_payment_at timestamp(3) without time zone,
    first_payment_amount_cents bigint,
    first_payment_txn_id uuid,
    reward_amount_cents integer DEFAULT 5000 NOT NULL,
    reward_status public."ReferralRewardStatus" DEFAULT 'PENDING'::public."ReferralRewardStatus" NOT NULL,
    reward_credited_at timestamp(3) without time zone,
    reward_wallet_txn_id uuid,
    metadata jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.referral_conversions OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 151929)
-- Name: referral_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.referral_events (
    id uuid NOT NULL,
    referral_id uuid NOT NULL,
    referral_conversion_id uuid,
    event_type character varying(50) NOT NULL,
    previous_status character varying(50),
    new_status character varying(50),
    metadata jsonb,
    actor_type character varying(20) NOT NULL,
    actor_id uuid,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.referral_events OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 151940)
-- Name: referrals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.referrals (
    id uuid NOT NULL,
    referrer_user_id uuid NOT NULL,
    referral_code character varying(20) NOT NULL,
    referral_url character varying(500) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    total_clicks integer DEFAULT 0 NOT NULL,
    total_signups integer DEFAULT 0 NOT NULL,
    total_rewards_cents bigint DEFAULT 0 NOT NULL,
    expires_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.referrals OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 151960)
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refresh_tokens (
    token_hash text NOT NULL,
    "deviceInfo" jsonb,
    ip_address text,
    expires_at timestamp(3) without time zone NOT NULL,
    revoked_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    token_version integer DEFAULT 0 NOT NULL,
    id uuid NOT NULL,
    user_id uuid NOT NULL
);


ALTER TABLE public.refresh_tokens OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 151973)
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 151978)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    name text NOT NULL,
    display_name text,
    description text,
    is_system boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid,
    id uuid NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 151990)
-- Name: session_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session_events (
    id uuid NOT NULL,
    session_id uuid NOT NULL,
    event_type text NOT NULL,
    payload jsonb,
    client_ip text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.session_events OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 152000)
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    organization_id uuid,
    compute_config_id uuid NOT NULL,
    booking_id uuid,
    node_id uuid,
    session_type public."SessionType" NOT NULL,
    container_id text,
    container_name text,
    nginx_port integer,
    selkies_port integer,
    display_number integer,
    session_token_hash text,
    session_url text,
    status public."SessionStatus" NOT NULL,
    started_at timestamp(3) without time zone,
    ended_at timestamp(3) without time zone,
    scheduled_end_at timestamp(3) without time zone,
    last_activity_at timestamp(3) without time zone,
    nfs_mount_path text,
    base_image_id uuid,
    actual_gpu_vram_mb integer,
    actual_hami_sm_percent integer,
    reconnect_count integer DEFAULT 0 NOT NULL,
    last_reconnect_at timestamp(3) without time zone,
    auto_preserve_files boolean DEFAULT false NOT NULL,
    avg_rtt_ms integer,
    avg_packet_loss_ratio numeric(65,30),
    resource_snapshot jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid,
    allocated_gpu_vram_mb integer,
    allocated_hami_sm_percent integer,
    allocated_memory_mb integer,
    allocated_vcpu integer,
    allocation_snapshot_at timestamp(3) without time zone,
    cost_last_updated_at timestamp(3) without time zone,
    cumulative_cost_cents bigint DEFAULT 0 NOT NULL,
    duration_seconds integer,
    instance_name character varying(256),
    storage_mode public."StorageMode" DEFAULT 'ephemeral'::public."StorageMode" NOT NULL,
    terminated_at timestamp(3) without time zone,
    terminated_by uuid,
    termination_details jsonb,
    termination_reason public."SessionTerminationReason",
    storage_node_id uuid,
    storage_transport public."StorageTransport",
    ephemeral_storage_path character varying(512),
    ephemeral_storage_size_mb integer
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 152021)
-- Name: storage_extensions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.storage_extensions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    storage_volume_id uuid NOT NULL,
    extension_type text NOT NULL,
    previous_quota_bytes bigint NOT NULL,
    new_quota_bytes bigint NOT NULL,
    extension_bytes bigint NOT NULL,
    amount_cents integer DEFAULT 0 NOT NULL,
    currency text DEFAULT 'INR'::text NOT NULL,
    payment_transaction_id uuid,
    wallet_transaction_id uuid,
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid
);


ALTER TABLE public.storage_extensions OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 152039)
-- Name: subscription_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscription_plans (
    id uuid NOT NULL,
    slug text NOT NULL,
    name text NOT NULL,
    description text,
    price_cents integer NOT NULL,
    currency text DEFAULT 'INR'::text NOT NULL,
    billing_period text,
    gpu_hours_included integer,
    mentor_sessions_included integer DEFAULT 0 NOT NULL,
    features jsonb,
    is_active boolean DEFAULT true NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.subscription_plans OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 152059)
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscriptions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    plan_id uuid NOT NULL,
    organization_id uuid,
    status public."SubscriptionStatus" NOT NULL,
    starts_at timestamp(3) without time zone NOT NULL,
    ends_at timestamp(3) without time zone,
    gpu_hours_remaining numeric(65,30),
    mentor_sessions_remaining integer,
    auto_renew boolean DEFAULT true NOT NULL,
    cancellation_requested_at timestamp(3) without time zone,
    cancel_at_period_end boolean DEFAULT false NOT NULL,
    grace_period_until timestamp(3) without time zone,
    payment_transaction_id uuid,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.subscriptions OWNER TO postgres;

--
-- TOC entry 294 (class 1259 OID 163196)
-- Name: support_ticket_attachments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.support_ticket_attachments (
    id uuid NOT NULL,
    "ticketId" uuid NOT NULL,
    "fileName" character varying(255) NOT NULL,
    "mimeType" character varying(64) NOT NULL,
    size integer NOT NULL,
    data bytea NOT NULL,
    "createdAt" timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.support_ticket_attachments OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 152074)
-- Name: support_tickets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.support_tickets (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    organization_id uuid,
    subject character varying(255) NOT NULL,
    description text NOT NULL,
    category character varying(64) NOT NULL,
    priority public."TicketPriority" DEFAULT 'medium'::public."TicketPriority" NOT NULL,
    status public."TicketStatus" NOT NULL,
    assigned_to uuid,
    related_session_id uuid,
    related_billing_id uuid,
    resolved_at timestamp(3) without time zone,
    resolution_notes text,
    satisfaction_rating integer,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    deleted_at timestamp(3) without time zone,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.support_tickets OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 152090)
-- Name: system_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_settings (
    id uuid NOT NULL,
    key character varying(128) NOT NULL,
    value text NOT NULL,
    value_type character varying(32),
    description text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.system_settings OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 152101)
-- Name: ticket_messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ticket_messages (
    id uuid NOT NULL,
    ticket_id uuid NOT NULL,
    sender_id uuid NOT NULL,
    body text NOT NULL,
    is_internal boolean DEFAULT false NOT NULL,
    attachments jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.ticket_messages OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 152114)
-- Name: universities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.universities (
    id uuid NOT NULL,
    name text NOT NULL,
    short_name text,
    slug text NOT NULL,
    domain_suffixes text[],
    logo_url text,
    website_url text,
    contact_email text,
    contact_phone text,
    city text,
    state text,
    country text DEFAULT 'IN'::text,
    timezone text DEFAULT 'Asia/Kolkata'::text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    deleted_at timestamp(3) without time zone,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.universities OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 152129)
-- Name: university_idp_configs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.university_idp_configs (
    id uuid NOT NULL,
    university_id uuid NOT NULL,
    idp_type text NOT NULL,
    idp_entity_id text,
    idp_metadata_url text,
    idp_config jsonb,
    keycloak_idp_alias text,
    display_name text,
    is_primary boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.university_idp_configs OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 152144)
-- Name: user_achievements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_achievements (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    achievement_id uuid NOT NULL,
    earned_at timestamp(3) without time zone NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.user_achievements OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 152154)
-- Name: user_deletion_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_deletion_requests (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    requested_at timestamp(3) without time zone NOT NULL,
    requested_by uuid,
    reason text,
    grace_period_days integer DEFAULT 30 NOT NULL,
    scheduled_deletion_at timestamp(3) without time zone NOT NULL,
    status character varying(32) NOT NULL,
    cancelled_at timestamp(3) without time zone,
    completed_at timestamp(3) without time zone,
    completion_details jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.user_deletion_requests OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 152169)
-- Name: user_departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_departments (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    department_id uuid NOT NULL,
    is_primary boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.user_departments OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 152180)
-- Name: user_feedback; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_feedback (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    session_id uuid,
    feedback_type character varying(64) NOT NULL,
    rating integer,
    subject character varying(255),
    body text,
    status character varying(32) DEFAULT 'submitted'::character varying NOT NULL,
    admin_response text,
    responded_by uuid,
    responded_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.user_feedback OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 152193)
-- Name: user_files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_files (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    file_name text NOT NULL,
    file_path text NOT NULL,
    file_size_bytes bigint,
    mime_type text,
    file_type text,
    session_id uuid,
    is_pinned boolean DEFAULT false NOT NULL,
    storage_backend text,
    retention_days integer,
    scheduled_deletion_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    deleted_at timestamp(3) without time zone,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.user_files OWNER TO postgres;

--
-- TOC entry 283 (class 1259 OID 152207)
-- Name: user_group_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_group_members (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    user_group_id uuid NOT NULL,
    added_by uuid,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.user_group_members OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 152216)
-- Name: user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_groups (
    id uuid NOT NULL,
    organization_id uuid,
    department_id uuid,
    parent_id uuid,
    group_type text NOT NULL,
    name text NOT NULL,
    slug text,
    description text,
    keycloak_group_id text,
    max_members integer,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    deleted_at timestamp(3) without time zone,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.user_groups OWNER TO postgres;

--
-- TOC entry 285 (class 1259 OID 152229)
-- Name: user_org_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_org_roles (
    expires_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid,
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    role_id uuid NOT NULL,
    granted_by uuid
);


ALTER TABLE public.user_org_roles OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 152239)
-- Name: user_policy_consents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_policy_consents (
    policy_slug text NOT NULL,
    policy_version text,
    agreed_at timestamp(3) without time zone NOT NULL,
    ip_address text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid,
    id uuid NOT NULL,
    user_id uuid NOT NULL
);


ALTER TABLE public.user_policy_consents OWNER TO postgres;

--
-- TOC entry 287 (class 1259 OID 152250)
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_profiles (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    bio text,
    enrollment_number text,
    id_proof_url text,
    id_proof_verified_at timestamp(3) without time zone,
    id_proof_verified_by uuid,
    college_name text,
    graduation_year integer,
    github_url text,
    linkedin_url text,
    website_url text,
    skills text[],
    theme_preference text DEFAULT 'dark'::text NOT NULL,
    notification_preferences jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid,
    country text,
    expertise_level text,
    onboarding_complete boolean DEFAULT false NOT NULL,
    operational_domains text[],
    profession text,
    use_case_other text,
    use_case_purposes text[],
    years_of_experience integer,
    academic_year integer,
    course_name text,
    department_id uuid,
    substack_url text,
    x_url text
);


ALTER TABLE public.user_profiles OWNER TO postgres;

--
-- TOC entry 288 (class 1259 OID 152266)
-- Name: user_storage_volumes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_storage_volumes (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    storage_uid character varying(64) NOT NULL,
    zfs_dataset_path text,
    nfs_export_path text,
    container_mount_path text,
    os_choice character varying(32) NOT NULL,
    quota_bytes bigint NOT NULL,
    used_bytes bigint DEFAULT 0 NOT NULL,
    used_bytes_updated_at timestamp(3) without time zone,
    status public."StorageVolumeStatus" NOT NULL,
    provisioned_at timestamp(3) without time zone,
    wiped_at timestamp(3) without time zone,
    wipe_reason text,
    quota_warning_sent_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid,
    allocation_type text NOT NULL,
    name character varying(128) NOT NULL,
    price_per_gb_cents_month integer DEFAULT 700 NOT NULL,
    node_id uuid,
    storage_backend public."StorageBackend" DEFAULT 'zfs_dataset'::public."StorageBackend" NOT NULL
);


ALTER TABLE public.user_storage_volumes OWNER TO postgres;

--
-- TOC entry 289 (class 1259 OID 152288)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    email text NOT NULL,
    email_verified_at timestamp(3) without time zone,
    password_hash text,
    first_name text NOT NULL,
    last_name text NOT NULL,
    display_name text,
    avatar_url text,
    phone text,
    timezone text DEFAULT 'Asia/Kolkata'::text,
    keycloak_sub text,
    auth_type text NOT NULL,
    oauth_provider text,
    storage_uid text,
    token_version integer DEFAULT 0 NOT NULL,
    two_factor_enabled boolean DEFAULT false NOT NULL,
    last_login_at timestamp(3) without time zone,
    last_login_ip text,
    onboarding_completed_at timestamp(3) without time zone,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    deleted_at timestamp(3) without time zone,
    storage_provisioned_at timestamp(3) without time zone,
    storage_provisioning_error text,
    storage_provisioning_status text,
    created_by uuid,
    keycloak_last_sync_at timestamp(3) without time zone,
    lock_expires_at timestamp(3) without time zone,
    lock_reason text,
    locked_at timestamp(3) without time zone,
    os_choice text,
    pending_email text,
    updated_by uuid,
    id uuid NOT NULL,
    default_org_id uuid,
    referred_by_code character varying(20)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 152308)
-- Name: waitlist_entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.waitlist_entries (
    id uuid NOT NULL,
    "userId" uuid,
    email text NOT NULL,
    "firstName" text,
    "lastName" text,
    "currentStatus" text,
    "organizationName" text,
    "jobTitle" text,
    "computeNeeds" text,
    "expectedDuration" text,
    urgency text,
    expectations text[],
    "primaryWorkload" text,
    "workloadDescription" text,
    "agreedToPolicy" boolean DEFAULT false NOT NULL,
    "policyAgreedAt" timestamp(3) without time zone,
    "agreedToComms" boolean DEFAULT false NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.waitlist_entries OWNER TO postgres;

--
-- TOC entry 291 (class 1259 OID 152324)
-- Name: wallet_holds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wallet_holds (
    id uuid NOT NULL,
    wallet_id uuid NOT NULL,
    user_id uuid NOT NULL,
    amount_cents bigint NOT NULL,
    hold_reason text,
    booking_id uuid,
    session_id uuid,
    status public."WalletHoldStatus" NOT NULL,
    expires_at timestamp(3) without time zone,
    released_at timestamp(3) without time zone,
    release_reason text,
    captured_amount bigint,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.wallet_holds OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 152336)
-- Name: wallet_transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wallet_transactions (
    id uuid NOT NULL,
    wallet_id uuid NOT NULL,
    user_id uuid NOT NULL,
    txn_type text NOT NULL,
    amount_cents bigint NOT NULL,
    balance_after_cents bigint NOT NULL,
    reference_type text,
    reference_id uuid,
    description text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid
);


ALTER TABLE public.wallet_transactions OWNER TO postgres;

--
-- TOC entry 293 (class 1259 OID 152349)
-- Name: wallets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wallets (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    balance_cents bigint DEFAULT 0 NOT NULL,
    currency text DEFAULT 'INR'::text NOT NULL,
    lifetime_credits_cents bigint DEFAULT 0 NOT NULL,
    lifetime_spent_cents bigint DEFAULT 0 NOT NULL,
    low_balance_threshold_cents integer DEFAULT 10000 NOT NULL,
    is_frozen boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    created_by uuid,
    updated_by uuid,
    spend_limit_cents integer,
    spend_limit_enabled boolean DEFAULT false NOT NULL,
    spend_limit_period text,
    spend_limit_consented_at timestamp(3) without time zone,
    spend_limit_end_date timestamp(3) without time zone,
    spend_limit_start_date timestamp(3) without time zone,
    spend_limit_warning_85_sent boolean DEFAULT false NOT NULL,
    runway_warning_1hour_sent boolean DEFAULT false NOT NULL
);


ALTER TABLE public.wallets OWNER TO postgres;

--
-- TOC entry 299 (class 1259 OID 196807)
-- Name: withdrawal_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.withdrawal_requests (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    wallet_id uuid NOT NULL,
    amount_cents integer NOT NULL,
    platform_fee_cents integer NOT NULL,
    net_payout_cents integer NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    razorpay_payout_id character varying(64),
    razorpay_contact_id character varying(64),
    utr character varying(64),
    failure_reason text,
    idempotency_key character varying(64) NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.withdrawal_requests OWNER TO postgres;

--
-- TOC entry 6089 (class 0 OID 151279)
-- Dependencies: 219
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
43ab8b8f-5a00-4e68-9723-a8b407d0609f	f06a850ab2b4518fe5576c8daaea695a89f63021b086dfac513ba953b60c836c	2026-04-08 07:21:48.080551+05:30	20260316082629_init_auth_tables	\N	\N	2026-04-08 07:21:47.926859+05:30	1
20c3c9d1-1666-49ad-9eba-7c1ee662838b	d5bfdc1c1dafd47ef9685207c3f75a3c9ebe9c872f2d30b044466dc2220a0362	2026-04-08 07:21:48.090273+05:30	20260316184502_add_storage_provisioning_status	\N	\N	2026-04-08 07:21:48.083086+05:30	1
010b2722-1018-459d-9b40-63366f68dcb6	afbc1564c0e054c0091d387e63393e9408f4632bd675a74806dd176e9af8c866	2026-04-08 14:51:17.1213+05:30	20260408092116_add_student_academic_fields	\N	\N	2026-04-08 14:51:17.086803+05:30	1
0babe03a-3834-453f-8d6f-51cd739602f0	d31f04d058bcd80d585153a0774ed4f70e49567f3708a23c480ce9b509a65a56	2026-04-08 07:21:49.458962+05:30	20260319081325_full_enterprise_schema	\N	\N	2026-04-08 07:21:48.094113+05:30	1
e00c49c5-f00b-4042-8633-d55fa9800765	be1792b6204ecb99b7362135d4ecfedd6094fe4019cd7b724fb5cf530cb2e41b	2026-04-08 07:21:49.507099+05:30	20260319155518_add_storage_extensions	\N	\N	2026-04-08 07:21:49.46062+05:30	1
dbd33e5a-9347-4512-b2d9-ee7ecc019b3f	5d8d484c038d2bd29227fb057738c47004b332e275f80d506773b6cdaefeb6e6	2026-04-08 07:21:49.518134+05:30	20260319182951_add_billing_fields	\N	\N	2026-04-08 07:21:49.508916+05:30	1
e0f850a6-ac51-4362-ad27-b59e3f231bf9	1df438dac2a5fff9679ac77b87932e4f8ac1d9674480c666f6edf281fd81fed3	2026-04-26 12:13:39.703288+05:30	20260422000000_multi_node_support	\N	\N	2026-04-26 12:13:39.631664+05:30	1
b410a63a-34d0-44e4-bedc-e4fc5196731d	b1ac6a784a71996508124de03c1e46fad6f5644b37585f40907326177e4e45d7	2026-04-08 07:21:49.5281+05:30	20260319184508_add_wallet_spend_limit	\N	\N	2026-04-08 07:21:49.519994+05:30	1
a60e1766-e22a-47cd-8085-21e7bdcf768d	e6025c027621a247f732c9da16080467b9e0b0bd793f143a98b11612ea538433	2026-04-26 18:06:23.736829+05:30	20260426000000_add_migrating_status		\N	2026-04-26 18:06:23.736829+05:30	0
ea180aa2-33e4-4a4a-9261-fdf3afd97835	a91f16a99a8e8c08adb6eac868c767aa0b25cde3bab392e8d7498c58000ceba1	2026-04-08 07:21:49.539767+05:30	20260320065444_add_name_to_storage_volume	\N	\N	2026-04-08 07:21:49.529398+05:30	1
224f7ce4-0bc3-4a3d-8e7d-459d77799f71	e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855	2026-04-26 21:37:28.092707+05:30	20260426100000_add_ephemeral_storage_fields		\N	2026-04-26 21:37:28.092707+05:30	0
e8e1ad47-c4a0-4a03-825f-527d71c0a2d7	1eab734f4dde2d7855bb00d5600928f75b13093bdbff56e06325b1044ccef655	2026-04-08 07:21:49.546677+05:30	20260320065614_file_system_update	\N	\N	2026-04-08 07:21:49.541215+05:30	1
d951ffb8-3cb3-4f93-ad78-da932da655f9	c42d41c38b1f4acebd4e725c962871f3b7fb3d827d90f2b31cca4199f9c52e53	2026-04-08 07:21:49.562304+05:30	20260322155218_add_storage_billing	\N	\N	2026-04-08 07:21:49.548156+05:30	1
9c657222-2b72-41e0-a024-4c77b2c47285	ec80fec54d49bbaec96a10050863b8cb60a4635cef15fe27df65d6e9ceb9c1fe	2026-04-08 07:21:49.572304+05:30	20260323053019_add_compute_config_fields	\N	\N	2026-04-08 07:21:49.564233+05:30	1
55537eaa-e1f6-46da-aaa9-147a343f8659	61db71d79d6debf195081ad538153979314a2fca64b7c8e241d6efe2d6e7fff9	2026-04-08 07:21:49.627632+05:30	20260323064506_add_compute_resource_tracking	\N	\N	2026-04-08 07:21:49.57395+05:30	1
a3ed7d32-c16b-4c35-b23e-c76e69b156d6	6bc0af65e162d6a104f2cc19b37f42159e123fa2c33ac0f22aaf0cfd18aa18ac	2026-04-08 07:21:49.636141+05:30	20260324083822_add_spend_limit_date_range	\N	\N	2026-04-08 07:21:49.629053+05:30	1
2c04a88e-9ed7-4693-b27a-de98f8332994	b228a0265feb2a3d7a355ebd300513a4744fdc4e36f7a5219f8f981fcda891a5	2026-04-08 07:22:39.383691+05:30	20260408015239_add_recommendation_session	\N	\N	2026-04-08 07:22:39.253981+05:30	1
68ceb3cf-0622-4af2-881e-f094805800f5	62580273e31cbc2a587ff064456c837cf149464d66eae56ad30f89eca1e10012	2026-05-19 23:03:48.093589+05:30	20260519170000_add_support_ticket_attachments		\N	2026-05-19 23:03:48.093589+05:30	0
10978bd7-2679-46a9-a382-0963392758c8	cfbc977b3dad6efbe89c77cf766320b8840ad8b82fb199d9d1632efa827861dd	2026-05-23 22:31:51.756422+05:30	20260520000000_add_recommendation_consumed_at		\N	2026-05-23 22:31:51.756422+05:30	0
028d2c90-499a-43f2-8eb6-9a03d044a7aa	efa9ed800445a0eec23dd9c034b50a26462f57495b4bdc1b3e89ac846ad7e9aa	2026-05-29 22:27:22.719008+05:30	20260529000000_add_inactive_node_status		\N	2026-05-29 22:27:22.719008+05:30	0
\.


--
-- TOC entry 6090 (class 0 OID 151291)
-- Dependencies: 220
-- Data for Name: achievements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.achievements (id, slug, name, description, icon_url, category, criteria, points, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6091 (class 0 OID 151304)
-- Dependencies: 221
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.announcements (id, organization_id, title, body, severity, published_at, expires_at, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6092 (class 0 OID 151315)
-- Dependencies: 222
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_log (id, actor_id, actor_role, org_id, action, resource_type, resource_id, old_data, new_data, client_ip, user_agent, action_reason, request_id, created_at) FROM stdin;
50794120-61d9-4c20-80b5-9c23fec4a222	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-31 10:24:16.456
cd49679d-aa08-4924-9cce-55a5ff0b0576	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-15 07:58:10.787
71f6c814-f802-4c15-ba38-bfeda87bef4a	bd8f8f80-a9ab-43e9-999f-b653f359e4c9	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-15 07:58:44.503
88137993-9e8c-4b11-b37e-60c735541ac8	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-15 10:00:34.38
03c595a9-a07a-4e43-9d0d-ce9bbafb0b2b	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-15 10:15:56.044
b6f8ff64-fa27-4f3d-a469-306481194a69	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-15 11:23:16.355
0bf9babc-1ca4-4759-9637-3c9c87a4fbb4	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-15 11:53:44.837
7676420d-31f1-40ef-ab09-27aecc379e6c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-15 13:33:59.538
01b82527-698d-46ab-9a1c-1554d88b10d2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-16 06:22:31.656
970d8e65-7479-4acd-bec9-19fd64f43aae	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-16 07:18:37.422
1054ef0c-c5a2-4e97-a0d8-ef3a27634c97	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-16 07:37:52.931
afc9976e-3e28-43ec-a291-4e84d9600149	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-17 08:58:39.638
206f5943-ecd2-443e-b0c8-4e0b005a483f	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-17 09:15:10.466
ca58ffbf-e246-403e-ba0a-b162ed6a017c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-17 09:20:18.435
33b6239c-0408-43ab-9a5b-ae571e402d43	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-17 10:09:30.249
acf5875d-3ccc-4aba-a0a9-8f5eb4d640b6	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-17 10:27:45.828
24d2d6cb-55c7-42b0-b368-11a919262241	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-17 11:57:24.734
297d214c-0618-4c66-845a-c82d0cbc4a4f	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-17 12:28:09.489
f1a2636d-35c8-4686-baa0-94a84a0ee79b	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-17 14:28:37.679
88143b72-2740-4974-a226-cf20360a8118	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-17 14:53:16.48
f9ddc649-32e3-49ac-a767-ed8fd3160065	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-17 17:39:38.829
9d1e8c59-33a8-495b-9792-ff175579ac5f	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-17 18:12:51.1
a82bbf1c-580d-4ba3-976d-aeb06260de3a	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-17 18:17:18.239
44811dda-e009-45f8-94bb-319670b174e2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-17 18:27:53.988
1b491af1-e619-45d2-bf77-c7711906c0fe	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-17 18:34:59.231
908b423a-5599-44e3-92f3-0acbf93f765e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-17 18:48:59.37
5d98c556-ae3c-46e0-82d1-9b169fba50da	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-17 19:00:12.043
de670b89-e547-44a9-a5fb-df0b89db8ea8	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 04:54:56.009
aaddc786-cfaf-4816-912f-3a88adbd7262	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 04:58:51.035
a3627776-bae2-4a70-ae56-00784b12e4e2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 05:05:37.167
842a7a38-9d89-40fd-a9be-7027ee35c723	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 05:08:13.804
7d77eac2-5d9d-457f-91e9-5984fd0bcbd2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 05:13:51.957
fe2f899d-6f56-4543-b0f4-859e113259d8	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 05:21:39.337
7236fca8-00d9-46ed-8535-d74f76636370	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 06:24:22.24
0d4425e4-39d9-4383-ba00-2451af63b41c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 06:24:55.145
48c71092-9774-4a7b-ba3d-b4ffcd706b0f	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 06:26:45.112
105d9f74-6c88-48cd-9f8b-343640b99c51	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 06:46:23.954
cb458a10-ee63-46b1-b887-422ea5a524da	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 07:03:13.5
c262fabc-0d47-449f-b8a6-eefe5229f26c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 07:29:34.45
1e12c8d9-4e46-47ca-8e82-3a014a4aa2e0	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 08:22:39.848
115dd67a-d882-4719-89a1-ba3bc7aa2d02	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 08:40:31.287
b64fe274-6652-4d1e-b728-0524dd9ef501	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 08:57:46.767
6a7df6c8-ff12-41c1-a014-62687f801e4e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 09:13:56.957
d7f6775c-898e-4e4b-b636-732f221ebe1c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 09:31:11.269
7d2b5c3b-528f-4e56-b845-6eccff91c54b	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 09:31:37.299
e1f055b2-836e-4dab-a8d9-7e30b078cdbc	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 09:57:26.374
5697e721-f3c5-4900-8b70-6b4c540ca162	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 10:01:28.038
0161e2e0-50fb-4f2b-b27b-8a6e73286152	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 10:06:47.59
be2037a3-e89f-48a7-a5c1-f5ea3e02349f	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 10:22:26.45
dc5d9e7f-2030-4760-83a6-19d03f45c6a7	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 10:39:24.228
a2780c21-4730-4e04-ac0a-dfb89eb79a1c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 10:49:20.283
9aaf377a-d9d8-4920-bd86-d852a56c50d2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 11:05:22.382
d8a5a15e-be4f-494c-86c5-8b6f0135fa19	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 11:22:07.091
7de94b06-dbb3-4b94-a8b5-09e05fb93f00	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 11:43:00.527
89b82550-ef87-4c65-93a6-11bd8935d6df	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 11:58:40.932
43aef783-a6cc-4036-aeb6-fdae700489ff	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 12:21:16.657
00cc7eda-1066-4bfa-b4b5-773239d55116	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 12:37:32.934
ddadce15-d557-4975-96c4-ef4ea0bc75af	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 12:57:53.765
ec40b544-376d-41bd-aff9-b199bbdb7c63	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 16:49:01.269
06dc7e0c-5010-463b-9d50-946f157d4d78	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 17:06:50.991
0e3c325b-d128-46ef-b4c7-d987e11db147	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 17:23:58.183
60741f93-34ea-41e7-a9db-fab2d11a2256	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 17:41:39.971
e5f88291-f2f5-48dc-b42e-f07543e90ef3	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 17:59:10.458
499ff1da-69f2-4a00-9366-d96b6cb3b39b	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 18:20:56.195
dc67b382-cdbd-421b-9c69-a14588f69140	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 18:36:48.837
31a35273-c37b-43bf-a774-272d57a7ccde	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 18:58:44.704
bd5b9b42-a0f8-4520-9d9d-e6b9d7353a97	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 19:01:54.571
a97c0a86-5538-4e45-ac3e-78d4e822dc77	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 19:21:45.776
16725b79-9e66-43ad-9789-82b45f4ce3eb	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 19:22:53.065
763d9dd1-27a1-4d99-9593-e6796db904e0	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 19:25:12.742
6a964966-84ea-431b-a407-3d207d95fb27	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 00:11:15.104
0daf471c-f270-4473-a2ec-21b63828857b	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 00:26:51.721
32fcd006-1386-46a0-a357-5fb9fa2f339a	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 00:44:15.654
8122b092-4282-4174-953c-8c2c2ed0719c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 01:00:18.159
0314e1b0-f664-40b9-8dea-13bdd7fb6cfd	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 01:19:18.315
a63bbc3b-0bf6-40bd-b42e-652f2f2dda97	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 01:36:56.778
200ed5ef-79be-4474-8559-0076c2a860f0	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 02:40:40.555
4a87d45c-c247-420e-8f4c-05740e56c920	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 02:42:38.357
dc61a4b3-798d-4b18-9aa1-3850a9060fc0	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 02:47:01.02
9a843290-fe27-479f-84d4-e25bed2933b7	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 03:14:41.834
7c8d2b97-04a4-4c1f-8e47-c40844512e81	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 03:31:31.552
d2b559b0-f8fc-4132-893a-d6e71d828d4a	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 04:25:50.505
1b00a0d3-3fbc-4434-9ad9-05c2c602ed0e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 04:50:01.331
ba8b8c5b-01d8-4673-8fa9-cef11391bfa2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 04:58:39.995
81b4f636-4154-4007-9f65-188a35763031	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 05:17:22.46
62497f61-1776-486a-a395-9c7430cccd30	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 05:33:14.181
cfae6756-bf07-4a49-b096-b0463276e0a1	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 05:40:16.164
fc73f910-1df9-4de3-b766-bcadcf81a7d5	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 06:01:20.282
78124d7a-5828-4069-9330-4c64a5e86604	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 06:28:50.151
9533c979-2a37-4adf-a398-a10e0e937efc	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 06:48:22.811
9f93351d-7a5b-4240-83c5-68234ce4fc72	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 07:03:48.927
b9f64af7-7c86-44d3-8d73-1334b8574c43	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 07:42:31.232
bfe24c43-9956-40b1-b287-4bea89bf2283	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 08:03:49.719
58d796be-4ae4-492c-acb0-ab206a6e9185	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 08:20:51.171
e1d9ea4e-6f28-44f9-9b49-9ce8cea3abb7	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 08:30:08.839
f34bfc5b-ca7b-46a5-a744-94885ca0452d	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 08:51:03.189
d8f33900-03d7-4ced-92b8-b06d97973bbf	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 09:16:49.449
1be1c504-f9f7-43a8-831d-53b8fb6fa69e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 09:40:10.722
1fc5cf86-f8c6-46a9-8d80-371a4c53711b	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 09:59:36.379
8a6f50b0-d62f-439d-a93a-872dc4bb68d5	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 10:18:37.89
dca5e847-0635-40d9-91d3-0b039ebba9a7	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 10:33:28.667
d99ca951-6d8f-49df-b449-14425f116f2c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 10:51:21.274
585433bd-8039-439b-a3fd-6d52b90657ff	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 11:08:21.002
3f31037e-a53b-46d5-bc6c-462608318ca4	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 11:26:47.259
98b4aa6d-73e6-4414-b157-1f0cf2bfd20c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 11:42:36.033
ebd3e54d-10f6-4c8a-8de9-01981bd70889	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 12:03:00.131
3304fabe-8024-4d34-8ea7-4f144641268a	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 12:36:15.953
9e87b69e-3962-4514-a593-9b97f8ae2d37	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 16:31:38.562
414d204c-40c6-4353-8a6e-d53fdcccb9ea	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-31 11:09:05.327
e7cdd168-54e4-4fa9-a5f7-86ca7e92bbaf	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 17:45:23.153
f999ed7d-0404-425e-983c-010959e5224e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 18:16:14.963
5b133bd3-b4ca-48fc-9b59-1d557cde0b7a	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 18:32:03.949
7a72439f-4947-47a3-983e-5cbf63940787	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 18:36:43.769
2ab1e086-f30d-4458-84dc-975ba659d9b3	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 18:53:15.809
d41e4bbd-6325-4f7c-9b8d-b817b421f4e5	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 19:09:27.866
186236fe-eaeb-46c0-babb-67f36d237eac	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 19:20:12.365
997ee3dc-3eba-4fc6-8fa1-9592b196860d	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 19:35:22.788
bc257238-1f36-4093-a168-ffe4f4c8951d	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 00:25:52.88
e8b159b7-cac9-4e1c-91fb-251b801ac73e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 00:45:10.942
1a7a3140-221d-48ac-8d13-542c34445adc	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 01:20:45.017
e4244a50-db0f-444e-962f-8da18c3b3b43	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 01:31:18.826
33eb2ad2-3d7c-42d7-ac14-486db283f319	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 01:50:22.421
1ac3a1c1-0fc4-4aae-a1c4-ad623f9148a9	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 02:11:10.124
40d4dc6d-c1de-453b-b1f0-722a34cf83bb	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 02:32:06.414
ef898488-2147-4df0-bb72-a998721c8b02	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 02:52:08.366
db449f7a-229a-4755-817c-3c1beafbc8e3	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 03:28:38.655
c89fb713-d18e-4546-a03d-9c47ac7a8cc4	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 03:41:40.022
85a276f9-2fd2-4d13-b27f-a65ef9abc18f	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 04:35:49.431
3e5e3331-16c5-4a34-a619-08663b981a08	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 04:54:23.863
04011477-06fe-4adb-af8e-6843c4113942	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 05:13:53.223
9b30627e-bf6b-4dfc-a824-6b0734bffd98	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 05:31:23.898
f8da447b-7572-4329-a9f3-6066a739c324	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 06:04:21.722
b7862765-74b5-456b-a6b4-40e0a3853e60	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 06:19:50.887
ddcb080e-01f3-4e29-85db-c8e6dc052ba8	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-31 11:10:54.187
59ebe277-9426-4d4b-892a-7bcdb3157309	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 06:36:40.867
0e3391b7-36be-4845-8b9e-77a962fbf750	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 07:20:44.16
fd0c05b9-727c-4fa6-8c33-cef987a35a4e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 08:38:26.587
4175301d-c13d-4e42-a84a-d4defa85dbe6	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 09:42:44.91
cc5131f3-7195-496d-a395-6dfe21856464	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 11:32:06.886
ff564128-6c61-43d7-8040-3a2c61dfb1df	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 12:41:19.16
8a74cb13-2156-40e7-a807-2625b5e875b8	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 16:00:39.271
6df54ac9-0e7b-4420-a1ef-6fc8d816c4ba	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 16:16:37.354
f69e10ea-bb0b-408a-bde8-eccabc93b4c5	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 05:04:17.884
38fc7592-d489-4f45-8f12-da6f3819dda9	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 05:32:12.062
a8ada6d9-d3b0-4c37-bde4-25f62c490998	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 05:53:03.312
25cc5764-6406-4245-be22-bee852266adf	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 06:24:38.854
0fafbf58-6841-4fb0-a658-9cff57cb19e5	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 06:38:26.853
9b433d47-cfc8-4bb8-b39e-28ee54a933bd	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 10:35:57.405
57369962-f80e-49cb-9302-a3cc9f43c642	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 10:46:05.02
2295eea4-3192-4462-bfde-86ec4c27561e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 11:07:03.667
46ccba4c-362f-48ba-b354-8ca47a2ea321	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 11:17:33.117
14123c81-fca6-46ca-ba2e-311704b5ebb5	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 11:37:26.533
3530a522-df95-4d5b-ad14-1f72351f71c2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 12:02:28.535
280ac81f-ca5c-4bb9-94ef-9a8bc80b2f0f	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 12:20:26.353
9bfd2586-ece7-4bf0-bbde-a5dd2f5c5250	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 13:53:20.193
06d9417f-c135-4365-bfff-7cff5f0816d2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 15:17:10.041
7d91e286-d4b0-45dd-a4b6-1c3f8df791e2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 15:18:41.87
4aeae348-6e5e-4141-9d7c-20d68b7b5c49	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 15:34:34.772
2d1b1665-cf48-44c4-8c20-796c520d0719	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 16:18:04.757
bad4260c-19a0-4060-a077-829a6e856ec7	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 16:33:35.031
27f53c14-a1ed-43c1-98a2-727b85d23e3f	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 16:44:07.065
70c5960d-83f2-4783-974a-081ef46dc975	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 17:12:26.236
74e23922-6bdd-47f7-bd36-9f1f81b6f875	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 17:18:08.66
b571558d-beaf-4dfe-b2fd-ac83a1b39f75	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-22 05:04:06.363
c061cfdb-3cd7-45a0-99cc-2b7f619ee7a5	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-22 05:37:43.071
96f98783-b875-4fdb-902b-e08f6f61592e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-22 05:53:32.576
ff4275d3-18ec-4b4f-b6a0-7293e47e98e1	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-22 06:00:40.714
233c7f08-62bb-42bf-9fbc-0bb6bacdb355	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-22 06:27:15.485
c329ac10-fc45-4e9d-824f-114cfd8a5204	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-22 07:05:11.18
fe66ef7b-d5f8-4e5d-80e4-030966cb227e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-22 07:21:57.772
b73bda6c-20e8-408d-be19-e16946bd7696	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-22 07:53:22.096
bb2656c0-283e-4307-99a8-14b96496d01e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-22 10:36:46.083
a355fe5a-00a2-4058-bf6f-0e73f6e64ebe	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-22 11:22:53.916
16f1894e-6284-455e-99c0-29d7eef14017	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-23 13:20:21.97
c0fec4ea-ea63-4826-88ac-2f532ae57dd6	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-23 13:36:00.893
1905c6ac-dad6-498c-bd1b-53f8ad927d15	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-24 07:20:37.329
b45f47e3-eec7-4ee1-9352-b410f7a4bbb5	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-24 07:44:40.876
4256e8d1-e98a-4a7d-9690-7c37f8a3b442	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-24 08:01:54.922
d8fd6e8a-6a73-4b31-b5d7-5d7fbfafdff9	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-24 12:18:03.995
8d529e1d-bbc2-409a-a100-8924518de4c2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-24 12:36:11.865
7cf05ee7-bb35-47d9-ab8b-e4cc2ebb6dce	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-24 16:51:02.911
2278873a-e707-40ca-b93a-fcb46884dcfe	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-24 17:06:20.376
9a58753b-e521-4825-9798-84e3fdaf25ca	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 05:12:02.443
7cb33ea1-25c9-4c22-958e-a3d207a73066	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 05:27:38.248
67958e2c-be87-43ba-8bdb-8b3a9359caca	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 05:43:31.294
c58fdac1-44a1-4bc5-b8c9-9a788c05b21b	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 06:12:42.959
298469cf-078f-4537-af89-5a6adc354db0	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 06:20:22.121
962c8788-36f1-4579-80c5-a177c28039b2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 06:30:11.591
87b1b440-ef36-4299-8b85-f8b776b55402	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 06:48:55.818
7f2fd61c-e3a8-4fea-8fe8-ef836a9d7d9b	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 06:59:38.002
44587c24-5186-442b-9a9b-705b5349ecc1	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 07:17:02.303
461bb35c-ab37-429d-937b-8b9c1b8ed2ac	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 08:09:50.775
b7485000-f78a-4fe1-8a89-0ee32554ba71	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 08:25:56.129
fd062732-c685-4867-9294-5d663fa0b21c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 08:38:45.122
f9865660-4a1c-4f47-b5f5-ffb9279f8859	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 08:58:33.215
25ca52fe-8039-4861-998f-2e4dc2b1d22f	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 09:23:55.197
c2c74b7d-2b46-4d33-bf20-f393be704b05	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 09:31:35.196
be41f1ca-498e-4c43-a0dd-0f77a8cc473a	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 10:01:41.746
1b01020f-9952-4c9c-8c31-e2cb823139d3	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 10:14:27.097
02bf8d2c-06ae-41d2-9578-b8e7521f0efa	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 10:33:28.278
ce1e5eba-82f0-4811-9c8e-693fc7fac098	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 11:11:28.972
80fd8519-7998-4b5c-b45e-2763692da3b0	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 11:32:38.275
bd2df706-bd01-4b2e-a9b8-c8fa47755cc3	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 11:35:14.822
cd21c083-6f44-4781-8920-cddbaf2dc740	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 12:04:40.988
52f95239-c65a-47f4-a1c3-efdb22f2bfaa	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 12:06:27.137
87d93d9a-6e2c-4c95-8b43-e08b147f2a11	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 12:25:00.68
3ae395a0-fbf4-4861-b87e-1cab76aaa1ff	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-25 12:41:49.697
b4aa56a2-aa9b-4e8e-8126-b462ce565ec1	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 00:10:29.03
8b8f54e4-38f7-4d7d-b6ff-63aaf016f6ea	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 00:17:11.145
a6bb7ca1-d88c-42a5-b884-d426ec53efb7	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 00:36:38.672
f2ad04dd-9897-475c-b1ec-ba40ac590e58	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 00:51:55.351
2add3847-fe75-4600-9b2c-3f7293241936	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 01:14:53.998
7ff8a23b-6122-4569-955f-aab436013d07	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 01:30:15.216
f2c691b0-a52b-47d5-9032-e660bdacfe0e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 04:41:45.177
a08cd488-8280-4c61-a8d7-d7394a700387	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 05:21:22.737
370692bf-0524-4144-a413-74d536fc9974	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 05:36:59.025
be393f0a-df7e-4555-84d6-28d11da7cb2c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 05:49:38.688
217e218f-5539-455b-81a4-e2981add5bc9	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 05:51:12.49
aa27cf62-d7d2-4190-8663-0fd8e4f0d588	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 05:55:57.563
e7adbc7b-be58-4426-ba27-d7574b8e9f87	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 05:56:10.233
1ec6411b-4bd2-4da6-9670-4835cafb856c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 06:11:30.432
a6725e61-b3e6-40cf-8cac-8c4d59474f0e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 06:27:15.276
1741ab3e-d6a4-4c8d-95db-e37b4ba1c2bb	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 06:49:27.679
5933d70a-0fdd-4418-ba32-6e400c69d171	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 07:04:50.135
680bcfc6-4389-466e-91b6-ab3d9664674d	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 07:34:33.64
21c092d9-98a9-4aaf-b432-6a1d867157fe	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 07:37:15.389
19d4f5ab-23db-449e-aa05-c25e64f1ba8b	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-26 07:57:03.058
bf4273a8-a71f-4e22-88f1-a7a5bc8556bf	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-27 07:19:41.227
791238e9-9119-4d89-80ed-6c955081fb78	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-27 11:23:15.293
24d106d5-80ac-48c3-80ad-93d3b6775bb8	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-28 00:40:04.02
8558614e-999e-4e19-8d81-b89131bdfff4	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-28 01:50:20.463
4a70af22-52d4-4f9e-a710-1bc2852072a2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-28 02:38:23.343
fb8d81ea-fa5c-46d9-8c38-37750e4f62fb	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-28 16:08:29.565
d820e78b-f486-4344-ba59-f828a6295813	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-28 23:12:54.627
2e4c2e90-11b5-42e7-b684-6e1b7d734f39	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-28 23:40:27.952
f623f3e2-9da2-4b7d-beb5-40fca6019720	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-29 00:23:36.217
5acba96c-ef8e-4db5-86e3-5017b469ba09	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-29 04:35:40.153
aba691d5-8170-4baa-b3b1-a2404622b5ef	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-29 04:50:15.122
cbb51ed2-a23f-47c7-929a-1dd4e164a2a9	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-29 06:09:56.999
91ef98c8-a449-4873-8036-86c10e97e22d	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-29 06:55:33.704
6643cd8b-d159-49cf-ae1c-cdc6191cdf71	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-29 07:29:11.311
d6e4a714-a686-4159-ac1b-c9f44f1106e3	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-29 08:24:25.531
d2a69b45-41bb-44a3-9721-07feb83e85e0	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-29 09:17:45.912
72d23bf3-f23c-4451-bd0a-f61edc625d91	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-29 12:03:20.235
c81bc22a-7eae-4810-b765-c23af1265055	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-29 16:22:31.073
3fbd859f-497d-4c5e-adb6-7b5c2b26ac57	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-29 16:40:39.672
7faa6846-e1ae-481e-945d-cc539bf5c3cf	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-29 16:53:34.483
0bcc3ae5-45b5-4189-9ff4-e8a3ec46a41e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-29 17:13:11.236
58e2e58e-a420-441b-8958-46a96c12304d	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-29 17:28:50
9d02e4e7-d03f-4272-af91-6649fec505d5	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-29 17:36:03.84
8c6c0e30-961d-42f3-9320-b82f9fa65b0b	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-30 04:38:35.874
91b14320-ab2b-4118-9dbc-bef2e20af2bd	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-30 05:01:41.136
5341c26b-58b6-4e76-846d-ded3b70997e9	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-30 05:38:01.869
cc10bec1-0886-485f-b9e1-ddbe029c4db5	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-30 09:04:35.152
d614a075-9b5f-4b2f-8907-51880b169dff	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-30 11:39:11.846
f4a84ff4-d699-4f30-82e1-9faaa80dcfad	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-30 13:47:18.92
86050a0d-a3c4-4e98-bb12-acad15200ba1	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-31 01:40:32.218
f5e3cd1d-01e7-408e-a084-e2ff7ce69aaf	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-31 02:56:54.359
\.


--
-- TOC entry 6093 (class 0 OID 151325)
-- Dependencies: 223
-- Data for Name: base_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.base_images (id, tag, os_name, description, size_bytes, software_manifest, is_default, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6094 (class 0 OID 151337)
-- Dependencies: 224
-- Data for Name: billing_charges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.billing_charges (id, user_id, session_id, compute_config_id, duration_seconds, rate_cents_per_hour, amount_cents, currency, wallet_transaction_id, created_at, created_by, charge_type, quota_gb, storage_volume_id, cost_classification) FROM stdin;
\.


--
-- TOC entry 6095 (class 0 OID 151353)
-- Dependencies: 225
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (id, user_id, organization_id, compute_config_id, node_id, required_vcpu, required_memory_mb, required_gpu_vram_mb, scheduled_start_at, scheduled_end_at, status, cancellation_reason, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6096 (class 0 OID 151367)
-- Dependencies: 226
-- Data for Name: compute_config_access; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compute_config_access (id, compute_config_id, organization_id, role_id, is_allowed, price_override_cents, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6097 (class 0 OID 151377)
-- Dependencies: 227
-- Data for Name: compute_configs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compute_configs (id, slug, name, description, session_type, tier, vcpu, memory_mb, gpu_vram_mb, gpu_exclusive, hami_sm_percent, base_price_per_hour_cents, currency, sort_order, is_active, created_at, updated_at, created_by, updated_by, best_for, gpu_model, max_concurrent_per_node) FROM stdin;
46756643-41f5-4eb1-a161-d5b595b4e0c8	blaze	Blaze	Standard GPU compute for development, moderate ML training, and data science.	stateful_desktop	gpu	4	8192	4096	f	17	21000	INR	2	t	2026-04-08 01:52:11.994	2026-05-15 07:32:20.596	\N	\N	Model fine-tuning, GPU-accelerated rendering, professional development	RTX 5090	6
73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	inferno	Inferno	Advanced GPU compute for heavy ML training, 3D rendering, and simulations.	stateful_desktop	gpu	8	16384	8192	f	33	30000	INR	3	t	2026-04-08 01:52:11.998	2026-05-15 07:32:20.604	\N	\N	Large model training, complex 3D rendering, GPU-intensive simulations	RTX 5090	3
d2fb06af-8256-4105-812b-05a10cbe99a1	spark	Spark	Entry-level GPU compute for learning, light inference, and small experiments.	stateful_desktop	gpu	2	4096	2048	f	8	12000	INR	1	t	2026-04-08 01:52:11.975	2026-05-15 07:32:20.584	\N	\N	Small PyTorch inference, Jupyter notebooks with CUDA, educational projects	RTX 5090	13
28a49cc2-a6c4-4387-a93f-9d48c153bb6e	supernova	Supernova	Premium GPU compute with near-exclusive access for research and large-scale workloads.	stateful_desktop	gpu-exclusive	12	32768	16384	f	67	36000	INR	4	t	2026-04-08 01:52:12.005	2026-05-15 07:32:20.61	\N	\N	Large-scale deep learning, exclusive research sessions, production inference	RTX 5090	1
\.


--
-- TOC entry 6098 (class 0 OID 151404)
-- Dependencies: 228
-- Data for Name: course_enrollments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_enrollments (id, course_id, user_id, status, enrolled_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6099 (class 0 OID 151415)
-- Dependencies: 229
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (id, organization_id, department_id, instructor_id, title, code, description, semester, academic_year, status, default_compute_config_id, max_students, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6100 (class 0 OID 151429)
-- Dependencies: 230
-- Data for Name: coursework_content; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coursework_content (id, organization_id, category, title, description, content_url, thumbnail_url, difficulty_level, tags, is_featured, view_count, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6101 (class 0 OID 151444)
-- Dependencies: 231
-- Data for Name: credit_packages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.credit_packages (id, name, amount_cents, credit_cents, bonus_cents, validity_days, is_active, sort_order, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6102 (class 0 OID 151462)
-- Dependencies: 232
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (id, university_id, parent_id, name, code, slug, head_user_id, is_active, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
6d421cde-607e-43cb-9c5a-4638876462da	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Computer Science and Engineering	CSE	cse	\N	t	2026-05-14 15:10:45.732	2026-05-14 15:10:45.732	\N	\N	\N
600da3eb-43d0-4ae5-973f-dde8251be2b1	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Information Technology	IT	it	\N	t	2026-05-14 15:10:45.773	2026-05-14 15:10:45.773	\N	\N	\N
84a31ffc-c5be-441d-aed2-54ff65f92d30	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Electronics and Communication Engineering	ECE	ece	\N	t	2026-05-14 15:10:45.779	2026-05-14 15:10:45.779	\N	\N	\N
47d864a1-f50a-438a-b364-67b4a6659de6	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Electrical and Electronics Engineering	EEE	eee	\N	t	2026-05-14 15:10:45.784	2026-05-14 15:10:45.784	\N	\N	\N
28cb5786-b12d-43f0-a228-93a79f201990	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Mechanical Engineering	MECH	mech	\N	t	2026-05-14 15:10:45.789	2026-05-14 15:10:45.789	\N	\N	\N
2a03fb69-08bb-43c9-982b-d3c3620bde0a	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Civil Engineering	CIVIL	civil	\N	t	2026-05-14 15:10:45.794	2026-05-14 15:10:45.794	\N	\N	\N
47563591-17ba-4e02-9d7e-fd1c98f950a3	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Biomedical Engineering	BME	bme	\N	t	2026-05-14 15:10:45.816	2026-05-14 15:10:45.816	\N	\N	\N
a0582e92-14f8-4ca0-8d76-148e223dc596	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Master of Business Administration	MBA	mba	\N	t	2026-05-14 15:10:45.821	2026-05-14 15:10:45.821	\N	\N	\N
679de575-40a2-447d-a2fe-0cc200a52836	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Master of Computer Applications	MCA	mca	\N	t	2026-05-14 15:10:45.826	2026-05-14 15:10:45.826	\N	\N	\N
67ef63ef-2331-41a3-9abf-c01d56a75d3d	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Artificial Intelligence and Data Science	AIDS	aids	\N	f	2026-05-14 15:10:45.8	2026-05-14 15:10:45.8	2026-05-29 22:53:57.183	\N	\N
66f940dc-4ee5-4d3b-948e-940e1493028e	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Artificial Intelligence and Machine Learning	AIML	aiml	\N	f	2026-05-14 15:10:45.806	2026-05-14 15:10:45.806	2026-05-29 22:53:57.183	\N	\N
893440ea-4b47-45c1-b302-da656e930b0c	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Cyber Security	CS	cyber-security	\N	f	2026-05-14 15:10:45.811	2026-05-14 15:10:45.811	2026-05-29 22:53:57.183	\N	\N
ae36e92a-7f21-433e-bb5b-4b633511ade5	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Automobile Engineering	AUTO	automobile	\N	t	2026-05-29 22:54:51.344	2026-05-29 22:54:51.344	\N	\N	\N
ba82f0e6-58a0-4e4c-a27b-1877fb033f27	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Computer System and Design	CSD	computer-system-design	\N	t	2026-05-29 22:54:51.344	2026-05-29 22:54:51.344	\N	\N	\N
7ed8d05d-d783-4a96-bb7b-58718c2df57b	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Computer Science and Engineering (IOT)	CSE-IOT	cse-iot	\N	t	2026-05-29 22:54:51.344	2026-05-29 22:54:51.344	\N	\N	\N
0af24dcf-29c3-4f9d-a8c2-f4c3cc845673	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Computer Science and Engineering (Cyber Security)	CSE-CS	cse-cyber-security	\N	t	2026-05-29 22:54:51.344	2026-05-29 22:54:51.344	\N	\N	\N
ab1a30d4-3543-4144-b9a9-0713a6b7920a	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Safety and Fire Engineering	SAFE	safety-fire	\N	t	2026-05-29 22:54:51.344	2026-05-29 22:54:51.344	\N	\N	\N
\.


--
-- TOC entry 6103 (class 0 OID 151476)
-- Dependencies: 233
-- Data for Name: discussion_replies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discussion_replies (id, discussion_id, parent_reply_id, author_id, body, is_accepted_answer, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6104 (class 0 OID 151490)
-- Dependencies: 234
-- Data for Name: discussions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discussions (id, organization_id, course_id, lab_id, author_id, title, body, is_pinned, is_locked, reply_count, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6105 (class 0 OID 151508)
-- Dependencies: 235
-- Data for Name: feature_flags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feature_flags (id, key, enabled, rollout_percent, allowed_org_ids, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6106 (class 0 OID 151522)
-- Dependencies: 236
-- Data for Name: invoice_line_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice_line_items (id, invoice_id, description, quantity, unit_price_cents, total_cents, reference_type, reference_id, created_at) FROM stdin;
\.


--
-- TOC entry 6107 (class 0 OID 151535)
-- Dependencies: 237
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoices (id, user_id, organization_id, invoice_number, period_start, period_end, subtotal_cents, tax_cents, total_cents, currency, status, issued_at, paid_at, pdf_url, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6108 (class 0 OID 151555)
-- Dependencies: 238
-- Data for Name: lab_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_assignments (id, lab_id, title, description, instructions, due_at, max_score, allow_late_submission, late_penalty_percent, max_attempts, rubric, sort_order, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6109 (class 0 OID 151575)
-- Dependencies: 239
-- Data for Name: lab_grades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_grades (id, submission_id, graded_by, score, max_score, feedback, rubric_scores, graded_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6110 (class 0 OID 151586)
-- Dependencies: 240
-- Data for Name: lab_group_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_group_assignments (id, lab_id, user_group_id, assigned_by, available_from, available_until, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6111 (class 0 OID 151596)
-- Dependencies: 241
-- Data for Name: lab_submissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_submissions (id, lab_assignment_id, user_id, session_id, attempt_number, status, submitted_at, file_ids, notes, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6112 (class 0 OID 151610)
-- Dependencies: 242
-- Data for Name: labs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.labs (id, course_id, organization_id, created_by_user_id, title, description, instructions, compute_config_id, base_image_id, preloaded_notebook_url, preloaded_dataset_urls, max_duration_minutes, status, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6113 (class 0 OID 151624)
-- Dependencies: 243
-- Data for Name: login_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login_history (login_method, ip_address, user_agent, "geoLocation", success, failure_reason, created_at, created_by, id, user_id) FROM stdin;
password	127.0.0.1	\N	\N	t	\N	2026-05-31 10:24:16.446	\N	aceee7c0-bb14-4924-98ca-c3976411ef01	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-15 07:58:10.753	\N	817c6594-e1a5-4f43-93e7-955591afc64f	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	f	invalid_password	2026-05-15 07:58:38.753	\N	a342fabd-f507-49b0-bc1b-950a722593a5	bd8f8f80-a9ab-43e9-999f-b653f359e4c9
password	127.0.0.1	\N	\N	t	\N	2026-05-15 07:58:44.498	\N	cf3a37f1-1774-48c3-9962-20d087b79e7d	bd8f8f80-a9ab-43e9-999f-b653f359e4c9
password	127.0.0.1	\N	\N	f	invalid_password	2026-05-15 10:00:27.846	\N	6b490931-322f-4948-8d7a-1b2447840cf1	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-15 10:00:34.353	\N	a9edc755-d5a1-4da4-83ee-bc17aab087f8	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-15 10:15:56.035	\N	b8a71284-f1ca-4465-9aad-88cb7a9171fa	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-15 11:23:16.325	\N	6d63f368-9494-441b-b33a-42f8a1034c0a	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-15 11:53:44.816	\N	ef5455cd-62f5-4d0f-a50e-33d568d31e13	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-15 13:33:59.216	\N	399227c0-7799-45fd-9b2c-434bf3252096	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-16 06:22:31.642	\N	9b1a212c-5361-48da-98d6-8cc48f1859a5	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-16 07:18:37.4	\N	4bd891c9-f2d5-48b0-90b9-761fd1924379	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-16 07:37:52.896	\N	563c71ec-ac69-4928-9c7b-9d206231b2cb	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-17 08:58:39.62	\N	1af0838e-720b-408c-a95d-b433c607624e	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	f	invalid_password	2026-05-17 09:15:05.988	\N	16cd5e02-c17d-4081-83d5-a9a193d76496	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-17 09:15:10.46	\N	fcc5a69b-e996-4549-9821-ca88bbf5d870	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-17 09:20:18.429	\N	dbceb560-a7b1-4f68-8b7a-86083e907873	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-17 10:09:30.239	\N	7c327a80-9774-4f0d-9fcc-01775a964b10	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	f	invalid_password	2026-05-17 10:27:41.979	\N	6b111e48-d918-412d-81fa-8f8a1534b7d0	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-17 10:27:45.822	\N	2cc3b87d-fe06-48e1-b87c-bf61d97616c4	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-17 11:57:24.713	\N	0ce69188-8254-4d8a-ae1a-b05b02fcda87	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-17 12:28:09.481	\N	8dba3797-6d70-4f03-8708-6ca4a88175d2	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-17 14:28:37.664	\N	4c2d6b75-36fc-460c-b8fd-28983505e0d8	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-17 14:53:16.463	\N	b046a4eb-bae2-4320-8889-ca10ce9461aa	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-17 17:39:38.822	\N	d1204461-803a-4a30-a227-eabd8c318cc2	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-17 18:12:51.089	\N	42b2a141-ca3a-4787-80a8-dd88505cbd91	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-17 18:17:18.232	\N	d9aacff0-7b98-4c37-a70a-077131d387c1	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-17 18:27:53.983	\N	7187dc8e-b258-4d7e-b4eb-82e16212dce5	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-17 18:34:59.22	\N	3b7f7cbf-988b-4d9d-b39c-e9c0eb4798bb	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-17 18:48:59.362	\N	6ee93e2f-3682-4131-8b91-49520fb56d9a	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-17 19:00:12.037	\N	72a166c2-344b-444e-9a97-5b2dcf6c8256	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 04:54:55.996	\N	eb731960-45ca-4f52-a84c-63960a465ea4	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 04:58:51.03	\N	43223635-f56f-4a62-9f54-ba15a7abe149	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 05:05:37.138	\N	5d8f724b-7aed-4f47-978c-b8a188941c29	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 05:08:13.796	\N	9240e490-d126-4d0f-9435-fed6aead72d8	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 05:13:51.949	\N	d5a8d87f-619c-4688-bf2b-c4ebacfbb575	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 05:21:39.328	\N	88e2b5f2-000a-487b-a34f-b5369e0f01b7	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 06:24:22.23	\N	e3ec1489-e19f-4e84-a9e0-f76663323d33	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 06:24:55.137	\N	6729c661-2690-489b-97b5-b09b162cc125	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 06:26:45.103	\N	22e3d49d-8b57-4ae0-81d1-a6930cfd2a95	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 06:46:23.948	\N	963d8527-f380-4a92-87c4-ff5046b8db17	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 07:03:13.492	\N	9d93bf6f-f40b-4ac8-bb50-0f784127e3a3	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 07:29:34.435	\N	edf88320-0fb3-42ec-bd58-99fc6cc2513f	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 08:22:39.84	\N	1f497d3c-81f9-40ff-af95-b75b15d6ed02	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 08:40:31.279	\N	9670e62f-52da-4017-a911-34c08b8866eb	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 08:57:46.755	\N	051a18ce-b072-4bff-973d-b35f1e3240cf	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 09:13:56.945	\N	66ef29a5-c7de-4369-b33c-8db695f5fc69	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 09:31:11.262	\N	2dcd3b7b-b28b-40f5-b905-6ce2f6e0a875	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 09:31:37.295	\N	1e11c3de-0007-4e81-9723-d1a49b446e32	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 09:57:26.364	\N	c923da54-e2a7-494e-974e-a5e294dfb626	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 10:01:28.029	\N	d30cf5f9-7dca-4262-a233-e5dd7a4da1f1	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 10:06:47.582	\N	0c53b062-17ca-4b72-8d22-55c4fe0d948b	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 10:22:26.445	\N	29c762b7-0ede-47e7-8ca7-a25d2ba1d717	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 10:39:24.223	\N	6862bf8b-8d30-4f62-bdf2-9f9ec9eec48c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 10:49:20.277	\N	4715ab3c-e21a-4a64-84d5-2862d1b21be7	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 11:05:22.377	\N	a4929a1f-77f8-47cd-86a7-4a1e8ed5eb9a	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 11:22:07.084	\N	9cdc0fa9-be66-4598-b13d-d77edf1d41fd	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 11:43:00.516	\N	5374a7bb-98b3-4113-be49-c8f898a33f50	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 11:58:40.923	\N	dddee939-a418-4450-bd6e-4b705d32911c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 12:21:16.65	\N	cff3ab5b-f24e-4444-af9a-338b02207380	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 12:37:32.928	\N	ff9c89fb-8f5d-448e-8043-9f8fa9391c99	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 12:57:53.759	\N	d412b8f3-12a1-44cf-ab81-c05343c86f5c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 16:49:01.256	\N	48ed247a-c578-4cf5-93f0-ccb1faf1d53a	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 17:06:50.983	\N	9c6e9cee-0977-48c7-b900-0a538a152850	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 17:23:58.175	\N	b491d186-d702-49c6-962f-4d3a169a18d0	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 17:41:39.967	\N	672ebffe-2860-4566-9c8e-df30fadeba77	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 17:59:10.449	\N	4991f1af-a536-491c-9d42-c69e0774c7e7	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 18:20:56.191	\N	ab5a837a-6341-4bde-aab6-e0bda9923e3d	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 18:36:48.832	\N	a90773f0-c0b7-4f41-85a2-9efac18a245a	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 18:58:44.697	\N	51e47fa8-7df5-45f9-aa36-e563a31c8ca9	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 19:01:54.565	\N	21026265-1ef4-41b1-b99c-3ee3074fe6dd	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 19:21:45.759	\N	953910b3-7bbc-47e4-8116-45c4a11e2c22	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 19:22:53.06	\N	a8bebf30-04c5-4d29-867f-bca28259e7d0	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 19:25:12.734	\N	fd974b97-62d0-4cbe-b001-caebd2eed08d	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 00:11:15.087	\N	9298dc3a-1443-4bc4-b86f-894a75b4fb04	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 00:26:51.716	\N	bc926405-f47a-4b32-81dd-9d8a1fba14b1	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 00:44:15.645	\N	525c7a22-5262-4876-a3dc-2db1a371e812	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 01:00:18.151	\N	28ba4b2b-0fe4-4d46-bdb0-5d232b0c71dc	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 01:19:18.307	\N	96807194-40ee-4c7d-bab1-d61b0928e786	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 01:36:56.774	\N	d4554e2a-fefe-4dbb-a101-8d21635c1960	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 02:40:40.534	\N	35fd0add-9e77-486c-b01b-cf1030dd347a	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 02:42:38.348	\N	3037c1bb-97a5-4b13-a1c6-5a885e385929	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 02:47:01.002	\N	cc999f45-9ab8-434b-9759-40efafc572d6	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 03:14:41.826	\N	9f2a1416-56e5-45ab-ae6e-f8e3bcacaf53	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 03:31:31.544	\N	e050663e-9e56-4465-aabe-b67d61233fee	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 04:25:50.471	\N	aaaa12df-da3a-4caa-b8f7-7da3dc227558	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 04:50:01.307	\N	6bc011df-7c21-495a-b657-b0914d08c2b7	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 04:58:39.987	\N	59b52735-5029-4a4c-8e3f-0ab7e304d73c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 05:17:22.439	\N	07cd0869-ed58-4a21-8615-45876d877bb1	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 05:33:14.178	\N	d76cd9b7-80e9-4549-8053-3d960311e17c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 05:40:16.159	\N	3e7b2be7-207c-473b-add4-d3e000f30094	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 06:01:20.274	\N	835c81e3-c5f0-44e0-8aaa-5b471d2c76fe	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 06:28:50.142	\N	171f6b44-4ce0-42b4-a422-e4c3c9d7167b	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 06:48:22.794	\N	eb143f78-8c95-4aa2-b966-ba4315ad9399	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 07:03:48.908	\N	1464027b-9d32-40aa-80b8-dd49df3d65e8	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 07:42:31.209	\N	aaa6987f-fb0d-43c6-aea2-2614b8a00db9	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 08:03:49.696	\N	ca710e96-e856-4b00-bb7d-93cec4c01f57	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 08:20:51.164	\N	7df58edc-3df9-4559-b056-e127a5d0b1ac	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 08:30:08.787	\N	42bd74b2-1cd9-4cc5-911f-0062faddd2bb	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 08:51:03.14	\N	22a8a8de-1301-46f8-b27e-36e8da8593a2	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 09:16:49.442	\N	014b0b88-6ea3-424a-87c0-6432c5946cbd	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 09:40:10.71	\N	fe2e9db8-70e0-4087-bf8f-093faa6e70d1	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 09:59:36.366	\N	6b15bc27-c25b-4375-8c1d-f98bfc1dd6a2	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 10:18:37.884	\N	147abe33-f411-422b-b193-f5b0e42fe9f7	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 10:33:28.658	\N	675537d2-3b68-4abf-b23a-6cb095049e76	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 10:51:21.264	\N	c6eb8039-ac1d-432a-b7e4-d25aa45d1a4f	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 11:08:20.985	\N	2f20d6b0-1246-4193-b3db-2970094322b0	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 11:26:47.25	\N	57493fc9-8790-40ed-8f7d-15459b073a38	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 11:42:36.02	\N	3fde2347-1404-4fdf-8bf4-b397839ab8df	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 12:03:00.124	\N	71d7d0db-d5d0-47fc-bc4a-647e0164e2ec	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 12:36:15.948	\N	e9a75091-97e0-484f-9650-cdfb0c584e5e	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 16:31:38.551	\N	120c23d5-8bdb-46ea-a493-ae0cf8266961	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 17:45:23.147	\N	5a709657-3255-47bd-a607-36c8329d6737	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 18:16:14.951	\N	cdda1269-574d-400d-9806-f69034ba8a79	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 18:32:03.94	\N	27dd2ff2-c998-4137-81de-4a87f3d5a6a2	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 18:36:43.758	\N	284bba70-f914-45fa-a9bd-d24fbae0c6c8	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 18:53:15.803	\N	021d9376-8eeb-4465-8c74-6b3ea09e69b7	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 19:09:27.861	\N	7ded94de-6faf-4416-a700-ae8f057c6451	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 19:20:12.296	\N	cc7496bb-6c91-4af7-adcc-3bfd7cc4de81	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 19:35:22.784	\N	598c92e3-b38e-4f36-993f-cd7fbd1aed2e	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 00:25:52.861	\N	e0bfb639-d8f8-46eb-b33d-55ad1330b7b2	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 00:45:10.937	\N	148926d2-9350-4cb7-b321-e42e2bc4c288	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 01:20:45.007	\N	26c0387c-4b0d-4d97-b185-0d29fb64b251	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 01:31:18.794	\N	85428e32-fb19-49af-86f3-7b9bd746e816	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 01:50:22.409	\N	f5d56944-970f-444a-9fc8-a2caf56a72db	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 02:11:10.114	\N	f0f8e3f5-fed0-47a3-907c-3a55db059239	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 02:32:06.402	\N	5942e40b-303c-4460-8794-0c16de9c27e6	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 02:52:08.359	\N	a3c32ea1-b87f-4de0-8a2c-858af0da9b87	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 03:28:38.649	\N	d8d27cd3-5b7f-4eed-9723-35f79a826bcf	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 03:41:40.012	\N	c2553e0e-b03c-4745-a735-5f9cd7efce3a	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 04:35:49.402	\N	301b9c6a-55d8-4c7b-83e9-92c18a9ef44d	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 04:54:23.846	\N	d2863d74-b3e6-44bf-ba5f-dea785f3c53c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 05:13:53.214	\N	22b154e9-3f72-4db1-8120-de72fdc649ef	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 05:31:23.893	\N	b4f6190a-e478-488a-9054-5e4a154c1356	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 06:04:21.713	\N	3ac1f9fd-7d1b-4994-8fcd-ce6f0f9fd41c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 06:19:50.876	\N	732b19e8-3e84-4dd9-8bc2-c973b2edf897	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 06:36:40.863	\N	9257934b-8151-4bf3-a7a9-d7643eb3bfa1	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 07:20:44.154	\N	8bf51cde-0dcc-46eb-846a-8ee0ed2a5f9b	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 08:38:26.578	\N	491ccb90-9939-4741-ae45-7c3ee7d42fcd	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 09:42:44.903	\N	7132fa39-bd8a-44fa-9d87-925ce7ecf3d8	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 11:32:06.882	\N	7cadc724-64db-4513-b229-fc62c56b2997	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 12:41:19.145	\N	c2c9ef40-dbee-4aa5-a52c-5b2edaa6e2a6	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 16:00:39.238	\N	7f45bce5-bbe1-411d-a56e-7ee7aeb9ff61	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 16:16:37.349	\N	c8c0916c-79c5-4217-8ebf-014fec5256f2	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 05:04:17.87	\N	f0e4a856-1327-41f0-923a-7ac45deb7a9d	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 05:32:12.052	\N	7db9eef0-e6b0-4ef1-b8cc-d3f6850cb3ca	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 05:53:03.302	\N	bc038965-63e9-456c-96f9-8d02c7c4c99c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 06:24:38.849	\N	7424ab88-1d39-402a-9c54-8ef736fb0147	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 06:38:26.847	\N	46e1973a-9922-4860-93e4-d1ca52572d47	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 10:35:57.395	\N	5113a617-0c55-40dc-86b5-96895cc6db6f	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 10:46:05.014	\N	1a348f4b-6d44-4056-8c76-f043e0488e23	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 11:07:03.656	\N	c129f2ed-5e2b-4e18-baf9-11805613302b	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 11:17:33.111	\N	49aec67d-6ae3-4bb4-85ed-6e898a4faae4	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 11:37:26.527	\N	651cb82a-1b9d-42f4-aa0f-5e9c3107284c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 12:02:28.529	\N	d6f1ddf5-5672-4492-bf79-bd29194ef716	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 12:20:26.325	\N	867d2508-9198-4356-9c7e-8b2ed6423942	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 13:53:20.165	\N	f20774db-5166-45ad-8945-54de92dbae96	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 15:17:10.019	\N	86ffcf67-7e93-4222-b4ff-e193bc0b1e50	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 15:18:41.857	\N	15b0a918-3183-4b6c-8594-c64872267756	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 15:34:34.767	\N	4765cc61-c9a8-4c53-a869-a089caf6af8a	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 16:18:04.741	\N	cae952c7-a852-4b54-9756-19c6ce0bac73	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 16:33:35.018	\N	f34dba24-d886-42b4-a950-5153dd7fe231	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 16:44:07.043	\N	99b5a0bc-9bb1-4f52-ba94-1273f6ac3c41	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 17:12:26.222	\N	21a55553-6eb9-4994-b070-4df5a12dbe75	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 17:18:08.646	\N	78e24897-f312-43b8-b2a0-f75fd04b20ab	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-22 05:04:06.345	\N	458b9bb2-ef19-4cc2-b23f-06898a86d4a7	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-22 05:37:43.053	\N	30a68d78-d722-41ce-b9f0-469622b64972	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-22 05:53:32.564	\N	a9479b57-053e-4062-952e-1855f5c3bd61	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-22 06:00:40.699	\N	755e5b71-8241-4ce3-9b3d-6115486ec721	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-22 06:27:15.469	\N	8b01416d-cf19-439c-a57d-28a541a5d599	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-22 07:05:11.169	\N	1e0895d4-b51e-456b-92de-7be2eac134ab	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-22 07:21:57.766	\N	d8001c11-ab31-4125-97be-49dc0f80879e	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-22 07:53:22.089	\N	7fa43fe5-abe2-4745-9816-68e35fd1987d	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-22 10:36:46.077	\N	66f7fa93-cc7d-4e82-a32a-cdbedf6e5bc0	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-22 11:22:53.909	\N	a9688dcf-4bd5-43ee-9a55-519e42e964a8	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-23 13:20:21.953	\N	de0d3998-82a1-4ef9-b113-3991b6bd522f	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-23 13:36:00.888	\N	80a3e991-17d5-4b0b-9f50-ebd04ee585c8	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-24 07:20:37.155	\N	e20bf1ed-f940-463d-86c2-1ef4a0a1b3f7	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-24 07:44:40.865	\N	184401b0-6a70-48b6-ac5e-df39737006c3	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-24 08:01:54.913	\N	a1c6da63-a94c-4508-8350-c1d9b45d9a16	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-24 12:18:03.987	\N	b639fdda-9fd2-4d7a-aa38-6086790ff13b	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-24 12:36:11.855	\N	3de20eda-78a3-41a8-a8ca-d23e9fea7e60	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-24 16:51:02.891	\N	9bee6b4a-904b-4b92-9e4d-401a2ce412f1	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-24 17:06:20.37	\N	d234d133-b407-4bbd-976a-43a7f98e6b13	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 05:12:02.423	\N	768926c7-ac08-4cf8-a361-aba490f08c9c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 05:27:38.242	\N	2742a3fa-b431-4c66-a4f6-4f29451a74e1	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 05:43:31.284	\N	790406bf-6ed8-463b-b6cb-932e9950127f	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 06:12:42.944	\N	f32d9914-f12e-4992-8ddf-b874b182b871	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 06:20:22.112	\N	8bc7f93d-0e08-4367-87bd-fe97f15fa30f	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 06:30:11.577	\N	05081dc8-592f-4201-a800-34bf94bee76a	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 06:48:55.812	\N	2a0bad70-dbc8-45d7-abd7-5db1fd01de86	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 06:59:37.995	\N	8bcbb373-3246-4422-a73a-10f64aa0f914	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 07:17:02.297	\N	4df01358-b8d7-4e64-9ec9-f4dcc5ea5bcb	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 08:09:50.745	\N	f5e03240-38ed-4776-a689-2808b58a26d2	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 08:25:56.125	\N	3134790c-c1c9-4f16-913f-b56a7f32eb11	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 08:38:45.117	\N	d59fd8df-3b56-45d5-a24b-cee0f1b5ec81	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 08:58:33.209	\N	35c257b5-8484-4c7d-99b5-e03f6f858b12	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 09:23:55.191	\N	03443b4a-07a0-4009-87e7-ee5242a4018e	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 09:31:35.189	\N	ddd4e5e3-958b-4303-bb6e-2ced0b631a3b	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 10:01:41.741	\N	1773d185-3590-438c-98c6-943283320bdf	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 10:14:27.079	\N	0e017ddd-8567-4bd6-801e-043aa06bbae5	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 10:33:28.262	\N	13281060-76ba-4fd7-9901-dcd2a3f1254e	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 11:11:28.964	\N	9445534b-dd4e-4995-a093-d7f1cf10ba4c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 11:32:38.259	\N	39986ab5-4a4c-4be4-863b-a8b36aca3ccb	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 11:35:14.815	\N	f71e3279-7e42-48f6-837a-bd8b8267b88e	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 12:04:40.962	\N	6a4782d1-da4d-474a-ae80-85a56f82b7d2	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 12:06:27.122	\N	fac6c618-9f95-4daf-a6ee-e1082a8e1bc4	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 12:25:00.667	\N	649d413f-d37f-435c-87c6-9e9900e0e97f	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-25 12:41:49.684	\N	327cdd49-2a77-4adb-9b22-b3204a9e717a	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 00:10:29.014	\N	b5889f78-e186-489c-9589-0fe42b8c3b60	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 00:17:11.138	\N	43815038-0340-4e5d-b5ad-ce70747dcf17	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 00:36:38.664	\N	e22a915a-86e0-40a1-9c95-b9728df27064	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 00:51:55.333	\N	457e1fd1-1fcd-421c-b1ff-61f8811ba00a	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 01:14:53.985	\N	dbe126db-bf2f-4c69-8ad3-a9e0c149f79f	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 01:30:15.21	\N	a10ffb53-0893-4864-b062-9ab2bd00ff09	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 04:41:45.164	\N	67b7f370-8f89-422a-88a6-e2e1ee42909a	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 05:21:22.729	\N	f971686f-1d1e-4430-af29-96adb790f943	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 05:36:59.012	\N	e1bf9c8f-1868-4415-9765-f079ff9a6e27	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 05:49:38.628	\N	e007b6ec-877d-4a12-b79c-cad78e1e5e92	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 05:51:12.479	\N	35b3ccec-8a9d-44de-937e-655b318716b1	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 05:55:57.554	\N	fcb699bd-2e48-41da-a9cf-7527b4ffe848	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 05:56:10.219	\N	d50f5104-b642-4f40-a24d-929a4726d3e8	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 06:11:30.422	\N	7e8af571-8a49-4fe6-9da4-6bbf2651d349	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 06:27:15.269	\N	7559e288-5d63-43d0-9420-f668ce27aa47	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 06:49:27.668	\N	a78b9487-a9ad-4e0a-850d-093eb207bb21	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 07:04:50.127	\N	8f87240e-aceb-4f2a-a694-b794c8f418bd	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 07:34:33.626	\N	511cb6be-8eeb-469f-999f-7f092a2fe35e	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 07:37:15.376	\N	cf164bc8-5ce1-48d3-a07d-32734d7ac8ca	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-26 07:57:03.045	\N	4771f8cd-6ca6-41a2-a576-9f25bd10b234	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-31 11:09:05.322	\N	c7e3834d-fc2b-42ef-a88f-fdad5c77058a	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-27 07:19:41.216	\N	d73c83cc-5fc8-4866-8f12-96ab4cded52a	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-27 11:23:15.282	\N	09b3373b-dc8c-4111-a332-9793cc7a87fd	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-28 00:40:04.012	\N	60af3fdf-2161-4d2e-a905-97a8d03bfecd	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-28 01:50:20.458	\N	338584d2-285c-46cc-b9e7-a501d6d689ef	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-28 02:38:23.336	\N	c1a70ad6-09c3-46b6-986a-e5cc75664308	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-28 16:08:29.552	\N	c35b337b-07fa-4f3c-8618-68bbd6c9301b	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	f	invalid_password	2026-05-28 23:12:45.869	\N	cfb33549-9019-4fc9-8ae5-1295f2a23ea4	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-28 23:12:54.609	\N	f37edb69-a57d-4e32-bae7-20c4090efbbb	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-28 23:40:27.943	\N	cc944fb7-631a-4b96-b43d-0416ec8870e7	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-29 00:23:36.196	\N	5458c267-e39f-4a95-8adb-8259ecace35e	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-29 04:35:40.139	\N	a73c93b8-fa62-4b76-990d-0655a2f1f04f	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-29 04:50:15.089	\N	a21652f4-e98f-493d-8822-ac3dc0cc25a8	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-29 06:09:56.988	\N	2b8f2efd-ffc8-4dd1-8995-b40745c39aae	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-29 06:55:33.699	\N	ad48a40d-8a30-4fec-878e-d75147f5143c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-29 07:29:11.287	\N	4316f274-1ac6-4aaf-a8a2-8b66faf8a480	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-29 08:24:25.52	\N	b7d1cbda-8fa2-4676-a5c8-e32f2c2d3bfb	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-29 09:17:45.882	\N	ddb31205-7ea3-4446-85b2-15191d1722e3	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-29 12:03:20.226	\N	69d3c576-0cec-42c1-8ff1-9f73a5c6f0b6	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-29 16:22:31.057	\N	0ffde933-4acb-4db4-99a4-dec2a4a5c4b0	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-29 16:40:39.666	\N	e9b88f81-54c5-400c-8356-fa9757a9b01a	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-29 16:53:34.472	\N	af969f1e-d101-414d-a9bc-3947e34e7dbc	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-31 11:10:54.183	\N	f68bd16d-30a6-4fd7-a9b4-057329c13348	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-29 17:13:11.225	\N	849f1b02-ce78-4f68-b5d1-cd957446043e	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-29 17:28:49.986	\N	74be0b48-c163-4774-a189-17a0e0985066	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-29 17:36:03.832	\N	0c228dfc-4ea9-435c-8d89-fba9e1c74809	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-30 04:38:35.868	\N	fda3208d-0f4e-4852-bcfe-b8dbb42a07eb	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-30 05:01:41.101	\N	23be01b4-8375-462d-837c-f3ccc2091dcb	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-30 05:38:01.861	\N	6b683be6-c699-4c56-b05a-2b8793159d95	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-30 09:04:35.143	\N	2306f291-e16d-4d3c-aebe-9c2b467756f6	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-30 11:39:11.835	\N	d63b65da-ce99-4647-9737-a5b8db8bb19c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-30 13:47:18.909	\N	2162a0bd-4a59-43c4-9d94-8812727b5efe	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-31 01:40:32.209	\N	468f7c40-2a16-48bf-a057-4b881f2a6125	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-31 02:56:54.334	\N	704739ee-9cd4-4590-b60e-f48564fc7af5	9f08f905-999a-4c6f-87bc-66e29dc6301e
\.


--
-- TOC entry 6114 (class 0 OID 151634)
-- Dependencies: 244
-- Data for Name: mentor_availability_slots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_availability_slots (id, mentor_profile_id, day_of_week, specific_date, start_time, end_time, is_recurring, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6168 (class 0 OID 196790)
-- Dependencies: 298
-- Data for Name: mentor_blocked_dates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_blocked_dates (id, mentor_profile_id, blocked_date, reason, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6115 (class 0 OID 151648)
-- Dependencies: 245
-- Data for Name: mentor_bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_bookings (id, mentor_profile_id, student_user_id, scheduled_at, duration_minutes, status, meeting_url, payment_transaction_id, amount_cents, notes, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6116 (class 0 OID 151663)
-- Dependencies: 246
-- Data for Name: mentor_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_profiles (id, user_id, headline, bio, expertise_areas, experience_years, price_per_hour_cents, currency, is_available, avg_rating, total_reviews, total_sessions, created_at, updated_at, created_by, updated_by, city, company, country, languages, professional_role) FROM stdin;
eeb5277a-70f7-4d46-94a3-f43e5c0de5eb	d6e2fea7-4b97-45d4-90b1-2f525eb52371	Senior AI/ML Engineer | 8+ Years Experience	Experienced AI/ML engineer specializing in deep learning, computer vision, and NLP. I help students and professionals master PyTorch, TensorFlow, and production ML deployment.	{"Computer Science","Artifical Intelligence"}	8	100000	INR	t	0.00	0	0	2026-05-27 10:52:39.5	2026-05-28 16:07:31.942	\N	\N	\N	Amex	\N	{English,Hindi}	Senior Solutions Architect
\.


--
-- TOC entry 6117 (class 0 OID 151683)
-- Dependencies: 247
-- Data for Name: mentor_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_reviews (id, mentor_booking_id, reviewer_user_id, rating, review_text, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6167 (class 0 OID 187152)
-- Dependencies: 297
-- Data for Name: mentor_session_payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_session_payments (id, mentor_session_id, amount_cents, payment_type, payer_user_id, payee_user_id, status, wallet_transaction_id, released_at, refunded_at, created_at) FROM stdin;
\.


--
-- TOC entry 6166 (class 0 OID 187138)
-- Dependencies: 296
-- Data for Name: mentor_session_status_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_session_status_history (id, mentor_session_id, from_status, to_status, changed_by, reason, "timestamp") FROM stdin;
\.


--
-- TOC entry 6165 (class 0 OID 187113)
-- Dependencies: 295
-- Data for Name: mentor_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_sessions (id, type, status, payment_status, mentor_profile_id, student_user_id, requested_at, approved_at, scheduled_from, scheduled_to, started_at, ended_at, duration_minutes, domain, service_type, earnings_cents, advance_cents, balance_cents, rescheduled_to_id, student_notes, mentor_notes, cancel_reason, created_at, updated_at, created_by, updated_by, attachment_file_name, attachment_file_path, attachment_mime_type, attachment_size_bytes, cancelled_by, last_reminder_at, mentor_fee_cents, platform_fee_cents, expires_at, category, jitsi_room_name, jwt_token, jwt_expires_at, subject) FROM stdin;
\.


--
-- TOC entry 6118 (class 0 OID 151695)
-- Dependencies: 248
-- Data for Name: node_base_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.node_base_images (node_id, base_image_id, status, pulled_at, error_message, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6119 (class 0 OID 151706)
-- Dependencies: 249
-- Data for Name: node_resource_reservations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.node_resource_reservations (id, node_id, session_id, reserved_vcpu, reserved_memory_mb, reserved_gpu_vram_mb, reserved_hami_sm_percent, reserved_at, released_at, status, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 6120 (class 0 OID 151724)
-- Dependencies: 250
-- Data for Name: nodes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nodes (id, hostname, display_name, ip_management, ip_compute, ip_storage, cpu_model, total_vcpu, total_memory_mb, total_gpu_vram_mb, gpu_model, nvme_total_gb, allocated_vcpu, allocated_memory_mb, allocated_gpu_vram_mb, max_concurrent_sessions, status, last_heartbeat_at, metadata, created_at, updated_at, created_by, updated_by, current_session_count, last_resource_sync_at, session_orchestration_port, storage_provision_port, nvme_of_port, storage_headroom_gb) FROM stdin;
16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	laas-node-02	LaaS Node 02 — RTX 4090	100.94.157.114	100.94.157.114	10.10.100.88	AMD Ryzen 9 7950X3D	16	65536	24576	RTX 4090	2000	0	0	0	8	inactive	2026-05-31 11:30:00.226	{"smTotal": 128, "cudaArch": "sm_89", "reservedVcpu": 2, "driverVersion": "565.x", "allocatableVcpu": 14, "reservedMemoryMb": 10240, "reservedGpuVramMb": 1024, "allocatableMemoryMb": 55296, "allocatableGpuVramMb": 23552}	2026-04-26 12:53:44.426	2026-05-31 11:30:07.155	\N	\N	0	\N	9998	9999	4420	15
7a75efa5-959c-45d9-a55c-e6d4adff2a23	aiserver2	AI Server 2 — Prod (RTX 5090)	103.115.236.35	103.115.236.35	10.10.100.132	AMD Ryzen 9 7950X	16	65536	32768	RTX 5090	2000	0	0	0	12	healthy	2026-05-31 11:13:20.06	{"smTotal": 170, "cudaArch": "sm_100", "reservedVcpu": 2, "driverVersion": "570.x", "allocatableVcpu": 32, "reservedMemoryMb": 10240, "reservedGpuVramMb": 1024, "allocatableMemoryMb": 55296, "allocatableGpuVramMb": 31744}	2026-05-06 13:30:26.021	2026-05-31 11:13:20.062	\N	\N	0	\N	9998	9999	4420	15
7a75efa5-959c-45d9-a55c-e6d4adff2a33	aiserver1	AI Server 1 — Prod (RTX 5090)	103.115.236.34	103.115.236.34	10.10.100.130	AMD Ryzen 9 7950X	16	65536	32768	RTX 5090	2000	0	0	0	12	healthy	2026-05-31 11:13:10.039	{"smTotal": 170, "cudaArch": "sm_100", "reservedVcpu": 2, "driverVersion": "570.x", "allocatableVcpu": 32, "reservedMemoryMb": 10240, "reservedGpuVramMb": 1024, "allocatableMemoryMb": 55296, "allocatableGpuVramMb": 31744}	2026-05-06 13:30:26.021	2026-05-31 11:13:10.04	\N	\N	0	\N	9998	9999	4420	15
c9868115-ff99-403c-8e87-06124ba7df66	laas-node-01	LaaS Node 01 — RTX 4090	100.88.57.107	100.88.57.107	10.10.100.99	AMD Ryzen 9 7950X3D	16	65536	24576	RTX 4090	2000	0	0	0	8	inactive	2026-05-31 11:30:00.364	{"smTotal": 128, "cudaArch": "sm_89", "reservedVcpu": 2, "driverVersion": "565.x", "allocatableVcpu": 14, "reservedMemoryMb": 10240, "reservedGpuVramMb": 1024, "allocatableMemoryMb": 55296, "allocatableGpuVramMb": 23552}	2026-04-08 01:52:12.012	2026-05-31 11:30:00.365	\N	\N	0	\N	9998	9999	4420	15
\.


--
-- TOC entry 6121 (class 0 OID 151754)
-- Dependencies: 251
-- Data for Name: notification_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_templates (id, slug, channel, subject_template, body_template, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6122 (class 0 OID 151766)
-- Dependencies: 252
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, user_id, template_id, channel, title, body, data, status, sent_at, read_at, delivery_attempts, last_delivery_error, delivery_confirmed_at, created_at) FROM stdin;
\.


--
-- TOC entry 6123 (class 0 OID 151779)
-- Dependencies: 253
-- Data for Name: org_contracts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org_contracts (id, organization_id, contract_name, starts_at, ends_at, max_seats, billing_model, total_credits_cents, used_credits_cents, status, notes, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6124 (class 0 OID 151793)
-- Dependencies: 254
-- Data for Name: org_resource_quotas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org_resource_quotas (id, organization_id, max_concurrent_sessions_per_org, max_concurrent_stateful_per_user, max_concurrent_ephemeral_per_user, max_registered_users, max_storage_per_user_mb, allowed_session_types, max_booking_hours_per_day, max_gpu_vram_mb_total, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6125 (class 0 OID 151809)
-- Dependencies: 255
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (name, slug, logo_url, billing_email, is_active, created_at, updated_at, deleted_at, created_by, updated_by, id, org_type, university_id) FROM stdin;
Public	public	\N	\N	t	2026-04-08 01:52:11.915	2026-04-08 01:52:11.915	\N	\N	\N	07b07401-b326-4045-af3a-44a7c45e56d8	public_	\N
LaaS Academy	laas-academy	\N	\N	t	2026-04-08 01:52:11.93	2026-04-08 01:52:11.93	\N	\N	\N	0cdb29b2-5017-450d-97e4-71b80be8b535	university	\N
KSRCE	ksrce	\N	\N	t	2026-04-08 01:52:11.957	2026-04-08 01:52:11.957	\N	\N	\N	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	university	f213bc95-2fe5-4401-94c1-39efeaa39a5a
\.


--
-- TOC entry 6126 (class 0 OID 151823)
-- Dependencies: 256
-- Data for Name: os_switch_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.os_switch_history (id, user_id, old_os, new_os, old_volume_id, new_volume_id, confirmation_text, ip_address, created_at, created_by) FROM stdin;
\.


--
-- TOC entry 6127 (class 0 OID 151833)
-- Dependencies: 257
-- Data for Name: otp_verifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.otp_verifications (email, code_hash, purpose, attempts, expires_at, used_at, created_at, id, user_id) FROM stdin;
test@ksrce.in	$2b$10$ZpScYJWdj7TUsFxwM3l5QeZ5e.BEExU0IcD9N7uS7rapjxXYOg4lm	email_verification	0	2026-05-14 16:09:17.038	2026-05-14 15:59:38.553	2026-05-14 15:59:17.04	800f7b02-6b91-435c-b903-4571804be8db	\N
testuser1023@gmail.com	$2b$10$RWiTsVdB/YEojwOaFQTuPOrk8kzUMEyLlqCRJpjQK5bZEe7KkeGhG	email_verification	0	2026-05-18 05:11:24.744	2026-05-18 05:02:52.906	2026-05-18 05:01:24.745	468c9e8c-29cb-475b-aef7-d06ffe3be681	\N
test-user@ksrce.in	$2b$10$3L/2ZXglwi5wdjk5iHcApuTKNp37QIkOIN/3U.NvcVDoqGiaPRsui	email_verification	0	2026-05-20 06:44:11.95	2026-05-20 06:34:57.943	2026-05-20 06:34:11.952	f6b5ac46-58b0-4b18-ba3c-8af8b949cd03	\N
ttdinesh@gmail.com	$2b$10$sDbSKR4lbwFnfP90NX/YIu9qRyCbHpAMW4KD0Wn8I2d7HRcOJfYEO	email_verification	0	2026-05-20 07:47:36.345	2026-05-20 07:38:01.449	2026-05-20 07:37:36.346	862e3780-2492-46db-9385-9f1a416d1c8d	\N
test-user123@ksrce.in	$2b$10$Jle5zMsklJI0pMHpY9XMIeHkJmZ5GaArN6xN8hIVKVtBrTqHRhMCK	email_verification	0	2026-05-20 08:37:47.853	2026-05-20 08:28:09.035	2026-05-20 08:27:47.855	9dc160ad-a7c1-4ff7-8c74-c4b5203ce056	\N
test-user10@ksrce.in	$2b$10$p4loGVXpYJrO2zPi8a/mu.ZQqKS4EL6GgF6rzDSMFtBoLenfHXhrS	email_verification	0	2026-05-21 07:16:15.784	2026-05-21 07:07:36.728	2026-05-21 07:06:15.787	8b5756e1-baf7-4fd8-90b8-c64967a84cd7	\N
test-user11@ksrce.in	$2b$10$X0SkWSr7lWF8ZCm2Jyul5.BLFa7eJa872JrU2E8LCRabue/HLi82W	email_verification	0	2026-05-22 07:34:05.406	2026-05-22 07:25:16.145	2026-05-22 07:24:05.408	9794926c-32bf-4b9b-a41d-f15a03331823	\N
testuser321@ksrce.in	$2b$10$phKHpLOSDe003Qkzm3kQE.U7nyFj1aKgD4tXoIPImRI7WrBPQNL9a	email_verification	0	2026-05-25 10:37:00.519	\N	2026-05-25 10:27:00.521	de956216-8203-49ca-a51a-ed5ff7f21f3a	\N
test-user321@gmail.com	$2b$10$B0QrSfqrZNigake5VTa7o.SjpU9Su.p.mS5prF4T8I.IrHDQ1ILP6	email_verification	0	2026-05-25 10:41:01.145	2026-05-25 10:32:59.981	2026-05-25 10:31:01.147	de9006bf-6136-476b-9cfc-a7ada5bd67e9	\N
test-user321@ksrce.in	$2b$10$808fQwvNTzRUZXzttByXy.viuOKChzQdZdP/CvLXD9e0q503i6NtK	email_verification	0	2026-05-25 10:46:22.093	2026-05-25 10:38:02.923	2026-05-25 10:36:22.094	a3b089fd-ab63-4032-8a2a-c4b345fc92a8	\N
test-user333@gmail.com	$2b$10$FRY40cnE0KsdzFL3iHPDzO.r0VsBychzPACrD87pTxH/sVD84iqia	email_verification	0	2026-05-25 12:31:39.367	2026-05-25 12:22:15.575	2026-05-25 12:21:39.369	5b031418-ce54-4bc9-a3ce-f7818fd3feff	\N
test-user1234@gmail.com	$2b$10$uvI5jvYIkN6LcsTE9jDvJ.R2gpzN9MbjflaAcqaSjFz2Nk5ocDgYW	email_verification	0	2026-05-29 05:42:43.962	2026-05-29 05:35:57.879	2026-05-29 05:32:43.978	f48c63ef-2c37-41e6-9b7f-6c06c6746879	\N
test-user12345@gmail.com	$2b$10$r3ApDHDHzVHUUOSHOit2qugenSvLmYbmfPVCy2wlphIcWHvh1RVCO	email_verification	0	2026-05-29 09:12:08.634	2026-05-29 09:03:27.502	2026-05-29 09:02:08.637	7033eebd-bb71-45e3-ae36-154a3f8df4ec	\N
test-user110@ksrce.ac.in	$2b$10$z0nibN/E0g0X0r4HCu6/yeMSoagNUZ4Bd4elOeEKons4eUmpbYYEe	email_verification	0	2026-05-29 10:35:51.186	2026-05-29 10:26:20.301	2026-05-29 10:25:51.188	303037f9-14e8-445e-8eb7-7a5e2367039d	\N
test-user246@ksrce.ac.in	$2b$10$LyUHMO6zrBHdTQCbzPEcW.mMt.zgOZdozyqwJihLni8h6oH3FfD82	email_verification	0	2026-05-29 17:25:32.304	2026-05-29 17:16:32.305	2026-05-29 17:15:32.306	a38bad63-d19f-424c-b320-46c86fe124bb	\N
test-user@ksrce.ac.in	$2b$10$msHxCOJL9FZsThbF4cPAguQVUkUA1orwdHdh2/R5qvchhtcT4IiEO	email_verification	0	2026-05-30 10:30:30.417	2026-05-30 10:21:16.344	2026-05-30 10:20:30.419	4c52b9b1-33f3-4b69-ba90-195cc0f2f96f	\N
test-user@ksrce.ac.in	$2b$10$DoD6EqEgXTY0u2g5y3VTjeGv40qK5.xuTCcV/O50IJ/5e33Wvk6ka	email_verification	0	2026-05-31 11:37:24.976	2026-05-31 11:27:42.31	2026-05-31 11:27:24.978	99f7a546-87f9-4442-990e-76d3c47b0a86	\N
\.


--
-- TOC entry 6128 (class 0 OID 151847)
-- Dependencies: 258
-- Data for Name: payment_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_transactions (id, user_id, gateway, gateway_txn_id, gateway_order_id, amount_cents, currency, status, gateway_response, refund_amount_cents, refunded_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6129 (class 0 OID 151862)
-- Dependencies: 259
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (code, description, module, created_at, updated_at, created_by, updated_by, id) FROM stdin;
\.


--
-- TOC entry 6130 (class 0 OID 151872)
-- Dependencies: 260
-- Data for Name: project_showcases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_showcases (id, user_id, organization_id, title, description, project_url, thumbnail_url, tags, is_featured, view_count, like_count, status, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6131 (class 0 OID 151891)
-- Dependencies: 261
-- Data for Name: recommendation_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recommendation_sessions (id, user_id, workload_description, document_file_name, document_extracted_text, analysis_result, analysis_quality, analysis_confidence, detected_goal, detected_vram_gb, detected_intensity, detected_frameworks, selected_goal, selected_dataset_size, selected_intensity, selected_budget_type, selected_budget_amount, selected_duration, goal_auto_selected, dataset_auto_selected, intensity_auto_selected, recommendations, selected_config_slug, created_at, updated_at, completed_at, consumed_at, selected_project_duration) FROM stdin;
\.


--
-- TOC entry 6132 (class 0 OID 151908)
-- Dependencies: 262
-- Data for Name: referral_conversions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.referral_conversions (id, referral_id, referrer_user_id, referred_user_id, status, signup_method, signup_completed_at, first_payment_at, first_payment_amount_cents, first_payment_txn_id, reward_amount_cents, reward_status, reward_credited_at, reward_wallet_txn_id, metadata, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 6133 (class 0 OID 151929)
-- Dependencies: 263
-- Data for Name: referral_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.referral_events (id, referral_id, referral_conversion_id, event_type, previous_status, new_status, metadata, actor_type, actor_id, created_at) FROM stdin;
\.


--
-- TOC entry 6134 (class 0 OID 151940)
-- Dependencies: 264
-- Data for Name: referrals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.referrals (id, referrer_user_id, referral_code, referral_url, is_active, total_clicks, total_signups, total_rewards_cents, expires_at, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 6135 (class 0 OID 151960)
-- Dependencies: 265
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refresh_tokens (token_hash, "deviceInfo", ip_address, expires_at, revoked_at, created_at, token_version, id, user_id) FROM stdin;
$2b$10$iKWTf31eYpOO8POjJAVZ4uKE282Pl/.5KEmZafGw2E7C3m6i1AJBy	\N	\N	2026-05-25 06:24:22.415	\N	2026-05-18 06:24:22.416	0	193bb615-7fbf-4367-9835-3728ac7f2ece	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$yns/Px3R4LL4UFLRyqlSBuvQUWpPrclXp35VQuRaL2Pt23hUiAnpm	\N	\N	2026-05-25 06:26:45.324	\N	2026-05-18 06:26:45.327	0	6121e510-fdcd-4d4f-a248-555916fc2b6b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$nJLWp/KidqM4Tdw0F5SYl.wHNk5bxIW7llDvcdHkZhqKvBb.aiPoG	\N	\N	2026-05-25 06:46:24.1	\N	2026-05-18 06:46:24.102	0	41c05e24-cc44-457c-b65e-c8425adb24e4	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$yu3yMnwC8wN8BfNliD0s1eeaeeTe/kTpkVD.q6qOfeouFaj0Wr6Qe	\N	\N	2026-05-25 07:03:13.675	\N	2026-05-18 07:03:13.676	0	0347c4db-0864-4adb-8905-ab53ace67e9e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Bz6jvaVq.PXLaWY6XozcOO4zkLgQfi3zfiHa2SOB25mPvUj7obAuy	\N	\N	2026-05-25 07:29:34.675	\N	2026-05-18 07:29:34.677	0	ca44d574-264f-43fa-aa7e-1584038c94f6	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$VISlx5NIAwDMdmvPQrmUKuzUPGOAQyaknqfpmNhMPWX44omXRwIly	\N	\N	2026-06-07 10:24:16.579	\N	2026-05-31 10:24:16.58	0	53b33402-93bd-46cd-87dc-9302cb02a9ff	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$qCRItZ9U1pQr5tjtCmjwOOHrVBk4JVTyXx6./c/H/hfevTe1ZXgZu	\N	\N	2026-05-25 08:22:40.067	\N	2026-05-18 08:22:40.069	0	a89f31aa-b1e8-4c94-98a2-692ae433c0f3	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$S/m4sHEor1UZf3bo37lsEO/6T7jD991sUheo8fyMoMkt2/qva9QJC	\N	\N	2026-05-25 08:40:31.504	\N	2026-05-18 08:40:31.506	0	b31a7887-1b8e-4005-b018-db49c360bd90	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$f1D30/PpFl7/iN.vTqedY.QKBaXAaizCQb02T7/h.jc5tpwu12pLi	\N	\N	2026-05-25 08:57:46.998	\N	2026-05-18 08:57:47	0	299b6208-cca3-4c48-aa00-10fa194f6316	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$XMJlqqfV8pozDJNdfXm2j.AGDjTLjsM4wekHU0UJUY1yA97nCOHpK	\N	\N	2026-05-25 09:13:57.215	\N	2026-05-18 09:13:57.216	0	2c5f0ef4-ad0f-4fb2-9210-60177905e81f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$pckbocwt8RNFanbyrfqMDecxdrWLSVDHGxckdSwSxVl9jPDitDYH6	\N	\N	2026-05-22 07:58:11.016	\N	2026-05-15 07:58:11.018	0	a4cc127e-4bb6-46ce-9f7b-4995a0228523	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$I0AXh.n1/6J7fTviqrpHd.BAqlLZg8DPBj4CK8AVd/DRdE.BQl0.2	\N	\N	2026-05-22 07:58:44.638	2026-05-15 09:36:04.234	2026-05-15 07:58:44.64	0	bbe29db1-2236-4ee1-bbde-8d9253981a33	bd8f8f80-a9ab-43e9-999f-b653f359e4c9
$2b$10$MhVlU4I5v5uzSy6bOuhuy.cTUkdUyGeE53t.Virl2B9Le/9htcmdy	\N	\N	2026-05-22 09:36:04.906	2026-05-15 09:51:25.155	2026-05-15 09:36:04.908	0	36df00d9-aeca-4a2d-8a25-bc849eeb7b1c	bd8f8f80-a9ab-43e9-999f-b653f359e4c9
$2b$10$CPk2lAkSYGsQBl0DbbHr1.j.E4.7bdglL74zY4AkXZGBD1jQ/55Na	\N	\N	2026-05-22 09:51:25.443	\N	2026-05-15 09:51:25.446	0	392fa428-b474-40fe-bf0c-5e34c3124f1c	bd8f8f80-a9ab-43e9-999f-b653f359e4c9
$2b$10$ECHoZvD5U0IFR/RSVJ6GBuXTOLMlTRmwAuHVZdsbPns7yAWmR2gJ.	\N	\N	2026-05-25 09:57:26.518	\N	2026-05-18 09:57:26.52	0	06fb9553-e07c-4383-9a03-25d18599f7c0	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$lNCj27iKUs5MyA/fK.bmtunKECagi9WtfXCaWhr8hutgxJz6k67zq	\N	\N	2026-05-22 10:00:34.652	\N	2026-05-15 10:00:34.654	0	353f5cf6-9f80-4116-8f0b-fae96a3916a4	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$chYIhwG3niYKkDbYn4CyAewgaTxOjwQVSiOMOyufsfG0vAGTo4kmK	\N	\N	2026-05-25 10:06:47.743	\N	2026-05-18 10:06:47.745	0	c91123cd-aa2f-48ac-89c2-1491a4f1b676	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$HVzTcs51lFuHgiS4UUd1z.Ffw/WSxy9O2L8FcEPP/jRSh4VjhjJrW	\N	\N	2026-05-22 10:15:56.232	\N	2026-05-15 10:15:56.233	0	d38ac0e4-3d62-4572-94f1-bd94d770abd9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$PIn3Va6apBnMctprmxy85eyHcfxhI5IPwX/sYwY8lKZ/OCpGmCmfi	\N	\N	2026-05-22 11:23:16.622	\N	2026-05-15 11:23:16.624	0	229ee5cc-6e32-42be-9e75-2dc120875065	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$2R6DffBz3umiiFf9hnJSLOycydoOTwlkHW73rczNqc/eFKPz2h51O	\N	\N	2026-05-22 11:53:45.035	\N	2026-05-15 11:53:45.037	0	667551c1-8fe9-4570-96d6-e01213a4f0fd	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$3N8ZzZWmN0x8rgjEWRSSmuuj39GHOEZY/CGBZuxQN8i3awEnuyaLK	\N	\N	2026-05-22 13:34:01.219	\N	2026-05-15 13:34:01.22	0	7275d5c9-ab2e-4eea-8098-d55fffe935b9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$GcOK97uAz7oqh.bynmVu3.Tv1yjeE0lHywPlce0Tjp5odXXD7MLZC	\N	\N	2026-05-23 06:22:31.815	\N	2026-05-16 06:22:31.816	0	7cfe1415-8d4c-48c7-af67-870261b56a8f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$evYDeAmcw2C51vE7EuUGl.mbvyk.qlM5kMe.XKkwxKsyKoNw33gzu	\N	\N	2026-05-23 07:18:37.636	\N	2026-05-16 07:18:37.638	0	681d4f64-603d-4b27-8383-01fcc1280932	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Mwme/E.VkHWqg9/9Qlw5yemJJcA2mBaJYsfsgnBL.9QOMZ0bEeu1.	\N	\N	2026-05-23 07:37:53.37	\N	2026-05-16 07:37:53.373	0	cb0e8413-9755-4dbd-8314-fd459e844ef9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Y5myUJBzWRfSwIoEJzQUv.broRu67wB8HDctr6qghdEPuXocIoyx.	\N	\N	2026-05-24 08:58:39.838	\N	2026-05-17 08:58:39.84	0	eac30210-c8d9-4d9b-aaef-c675ac7f8b7a	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$tkqCf4KCKx94vK0pkP6ib.J/m5ju/4D4iODLCih6ot.uJPUslXVw6	\N	\N	2026-05-24 09:15:10.648	\N	2026-05-17 09:15:10.651	0	dd24b467-d74c-4cc1-bf48-c0062c0049b9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Q7Wx1WwEvsn9ruuR.zdP3ud1MR.HIHY087Pq98A6NJd.kGLgDju9W	\N	\N	2026-05-24 09:20:18.589	\N	2026-05-17 09:20:18.591	0	e9fee3d8-1518-43f0-bfd8-cc64537653b2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$znBRrfrVgR4RJ7sqgKyQvuT1VesczuXpEQ7PVAxrljiYcf1U0yNpq	\N	\N	2026-05-25 11:05:22.509	\N	2026-05-18 11:05:22.511	0	84bc600d-0e57-4dc0-8bad-503e5004e15b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Fo.YV14ygIixhwckPPTmU.HtHvpXGr8VWkz25pFHIA8TDrgL3vF7e	\N	\N	2026-05-24 10:09:30.424	\N	2026-05-17 10:09:30.426	0	c7b1ac2e-4b48-428c-bd38-8679f8b574f4	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$1AKKc8mlvdqsdZrpw7VK8uS95B6u4s1tmsNB62updFmR4cB078EsK	\N	\N	2026-05-25 11:22:07.285	\N	2026-05-18 11:22:07.286	0	37ec3edd-127a-482d-9761-adeecf6d0c38	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$jYQKjD01uY6a1eCArWl1FOvxh8AkJv3BZpMNj7nooeIJyWaE/1/Jm	\N	\N	2026-05-25 11:43:00.788	\N	2026-05-18 11:43:00.791	0	0180dd50-c4fc-4ee7-864d-c9e4fdec2375	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$RFtHkJVPzjxmcKwN7wQgk./QipElwAVesSNoG0Vh3bV0fTenJKrPC	\N	\N	2026-05-24 10:27:46.041	\N	2026-05-17 10:27:46.042	0	1c416735-1400-4d80-a920-cfe8c5fc3bd9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$bKFCQErd/QZf7YJzcN0hae7NLqLJINK/pzZK0lmyRh2v389xRQJ8C	\N	\N	2026-05-25 11:58:41.109	\N	2026-05-18 11:58:41.11	0	e522abbb-48e7-4bb5-aab5-a566ebda425a	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$liD295j2LwoUAZW9iHxz..K0PC/hF5FdpFlB3cqxA7Qbva9JHq06u	\N	\N	2026-05-25 12:37:33.065	\N	2026-05-18 12:37:33.067	0	eca32cf5-b663-487a-9289-55990d7ec7ae	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$XTMndgZnKKED7Xa4omqF6.8QLQAi.v767coGPdCrJ/7YXwyqIzgdW	\N	\N	2026-05-25 17:06:51.126	\N	2026-05-18 17:06:51.128	0	72bda6ef-f491-42f8-9243-28b04db780ae	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$3tfYI3h9l3jZO8w2KqRyF.V2g7.kyuLNn0Quzu/OI39XfGRua/GGW	\N	\N	2026-05-25 16:49:01.482	\N	2026-05-18 16:49:01.484	0	0b602ab0-40c8-47ac-8020-e7ba96718410	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$bXaQPYm.Ku31lhZdSf5.JejtO9otTrobny/.YK/1IqURj/ieIdNUq	\N	\N	2026-05-24 11:57:24.95	\N	2026-05-17 11:57:24.952	0	6b3b4272-30b6-4ebe-b976-36d2aef0f102	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$kRift7kT5kh48Fib1axMxuA7xqZeucxe9BTpw5j4Ht/a4Zcm2uEte	\N	\N	2026-05-25 17:23:58.34	\N	2026-05-18 17:23:58.341	0	5d00aa29-ddfb-47d4-ac20-229550dbeab2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$rtalU/nJmi89r2fIE8Nju.OwnxndI3vnS0K2s2kJ.lQcp59MoEoQW	\N	\N	2026-05-25 17:41:40.091	\N	2026-05-18 17:41:40.092	0	c9619da2-96c2-441c-9fec-2981504cfcd1	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$9WD71w./M/wgT4kQN1HAUeejeIyXDjV.LQoZB6RtrxuVTsPgIpl.m	\N	\N	2026-05-24 12:28:09.651	\N	2026-05-17 12:28:09.653	0	52f4b781-2cf8-42ef-a0e6-cd4b4c67b4bb	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$CqN9F0lZQ3Cirjg8O9r34OchA..ZWPuay0peofQwEBfPlYHx0hqa.	\N	\N	2026-05-25 06:24:55.378	\N	2026-05-18 06:24:55.38	0	a417cc9d-18b4-46e4-a565-cee81045e37e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$KJ/d6Fy4KGPto3dZfntFX.jNIR2E8.1sIxBRI7WeA4dqA7e47duPq	\N	\N	2026-05-24 14:28:37.945	\N	2026-05-17 14:28:37.946	0	25476c0b-05cc-445d-bffd-0606bd9496d8	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$6rDr4XDpj3PIRr6kf1K5yeAYY83IP0XyKVc7Hse3JUUfsh2fQuzq6	\N	\N	2026-05-24 14:53:16.658	\N	2026-05-17 14:53:16.659	0	502bfcd8-010c-4ebc-b330-3f4ee9945c64	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$RbuNSfgDky3xABFdCwmQzOkb1WfBc2HdSSyEhRMAmLITn2eZorzG6	\N	\N	2026-05-25 09:31:11.44	\N	2026-05-18 09:31:11.441	0	c8a1f4bd-3736-4802-9562-947e6c3a9046	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$OgRRKcAt2u/Gfxfoifrz/.IooGF.8DmLsoAMrp0DCSyn3cqWuX3EW	\N	\N	2026-05-25 09:31:37.422	\N	2026-05-18 09:31:37.423	0	f592ab2c-0d0f-48c7-a49f-4f3961d13a1d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$kw5CpagbLsVKKx9J5OEoiOLlfHzaO9/FfAB8krGzEMrdUITJvb09a	\N	\N	2026-05-25 10:01:28.18	\N	2026-05-18 10:01:28.182	0	1c35d673-ab34-41cb-b09a-e099b02dbf95	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$J6tbhUfE0dyQFEnQlHfxDuOVAsjdzVBe9/tAfKwNQmrai.BPWXPe.	\N	\N	2026-05-25 10:22:26.63	\N	2026-05-18 10:22:26.631	0	a9a3169b-2bfa-4038-91d9-56a03184e07a	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$xq58DPDzWcqv49CxhRnfxeQxau82Zt57GqLISpQPsbl5PLIRCzV4e	\N	\N	2026-05-25 10:39:24.364	\N	2026-05-18 10:39:24.367	0	5201135c-adc5-4252-bb9e-13073bd808f2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$I.9qL.MzcvsNd3nheiHfPecf5uZ8y02X2hpo6h.n20CO5A9732sjK	\N	\N	2026-05-25 10:49:20.431	\N	2026-05-18 10:49:20.433	0	aa914a0b-1a09-4d3b-b180-ee9029210c15	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$N/1OpDApiYlk/hD6snTaruMADte8FW7ZlB6zTWMzjMFPia3dxTEwO	\N	\N	2026-05-25 12:21:16.795	\N	2026-05-18 12:21:16.798	0	3fdb5fd9-d47c-47d6-b9b4-4ba5dd4a5baf	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$npnUIrSITib3k22D4DoMLeum0fcJ3mXiOyYgaRhCl8AnoO.iMzuUS	\N	\N	2026-05-25 12:57:53.895	\N	2026-05-18 12:57:53.896	0	a5ee123f-1fae-4da0-8fef-670d9cf59fa2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$zjWu3QKUUHgibenuOVbgceWfWBh868foUIdNM7HHhEZn.dS0m7PVi	\N	\N	2026-05-24 17:39:38.965	\N	2026-05-17 17:39:38.967	0	ca99e6c5-7385-44ee-ab83-6e26270b789d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$cm5YSMP5N3ubfTZnIpWK0O9PNbwKTRa6hbVksvXN0WNyDfVNbbUvO	\N	\N	2026-05-24 18:12:51.28	\N	2026-05-17 18:12:51.282	0	db376c80-a448-4528-9281-024c41cc910b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Z/O1xne6VwvOInxM4r/4D.qRs.fKQz3jVxN.Uu8i7L.DZSWIHjjpm	\N	\N	2026-05-24 18:17:18.358	\N	2026-05-17 18:17:18.36	0	ad9875a5-c285-4da0-9933-1b4f23a25805	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$gIDcud.Y0if573CUDmUE2er5vmbkfKbA5/3XZQqkqpyLmKZ7DjKFW	\N	\N	2026-05-24 18:27:54.14	\N	2026-05-17 18:27:54.141	0	9da95577-2136-455d-ba22-934fba268946	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$CxbwsUGJTM.Rmv6X7wmJBeet1kXJGxtbXcMJv6nqQK3Qe8nL70aXG	\N	\N	2026-05-24 18:34:59.482	\N	2026-05-17 18:34:59.483	0	b270a39f-8470-4672-882e-3071271418da	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$n7DwrFs4NQcPanoO668R9.cBJjryiCMjcpmfOXdsD3mYDFgIS3bmK	\N	\N	2026-05-24 18:48:59.489	\N	2026-05-17 18:48:59.49	0	3a999925-4ce2-4315-bb9d-c1b73117bed5	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$WqfRrI4W4UNloL7/eoqy6ufReHBmAAFvJpbq0nFn03vb0hmOc29se	\N	\N	2026-05-24 19:00:12.164	\N	2026-05-17 19:00:12.165	0	acd26203-ea67-4203-a6b0-4ec75b4acf95	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$I1UNnZJrBixUQpzpBoL00.i0ta3hagvYV0yfM7pwnPpGPBXkG.aR2	\N	\N	2026-05-25 04:54:56.176	\N	2026-05-18 04:54:56.177	0	b09f3200-7c10-402a-9caa-5a01570882b9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$JoAXTm5X7uICboWOJQxGzu0Mhuv9s0yifyjDPmjbkPEBUTUcLelIK	\N	\N	2026-05-25 17:59:10.603	\N	2026-05-18 17:59:10.604	0	486e8555-aee7-4868-946a-8ed3a2e18d0f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$KP4NJzboafbyhHPPYGLRxOcq5yw4vTnXsD083S8EJMqFkOyRPmnGe	\N	\N	2026-05-25 04:58:51.224	\N	2026-05-18 04:58:51.225	0	0e0f2bf0-a8d6-45f7-95d3-ed55e620b51b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$q0IbNhFF1uVWKFPzQTP2a.k4GQObN001B9pOMPTpWSahOfykpmGCy	\N	\N	2026-05-25 05:05:37.58	\N	2026-05-18 05:05:37.591	0	828a52de-0353-4cd7-b6f0-6d6aaef1931e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Q26KfaSXIifnxjFHnrHyXeiFefRivMIIax733Fz0Mi0wH48oHGRPS	\N	\N	2026-05-25 05:08:14.007	\N	2026-05-18 05:08:14.01	0	5441cbf4-96f7-46e4-96f5-62aab4108dcb	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$sqcVJWc16yIPtQtK1XpC3.ZNJtuRPTd9YtumUPstYqsHoqyPhb3fq	\N	\N	2026-05-25 05:13:52.156	\N	2026-05-18 05:13:52.158	0	8b373861-989b-46d9-b1ef-dc907307dc77	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$hvkxKOHAFTQiWzALwpj4oeVBGwgBN8dtDuft6/RIrIC0wNbXyySoe	\N	\N	2026-05-25 05:21:39.565	\N	2026-05-18 05:21:39.568	0	4c22e200-f931-43af-a3fc-40a2ca674ca7	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$1OzIadbRCLd1Y12cO8OEI.B72xmF7w63.2XuI35AGL3T3s3NKeN4.	\N	\N	2026-05-25 18:20:56.31	\N	2026-05-18 18:20:56.311	0	309234cf-3712-43e0-b1ac-fa61547a7d70	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Qx/3Zs3psU9XDl9hVOWPheNke1tfp/OBAmouXnZdo2ijg8ctjQray	\N	\N	2026-05-25 18:36:48.956	\N	2026-05-18 18:36:48.957	0	10622fdd-ccb1-4162-baee-e7e30f8a883f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$pzC5zT5LrCc5olh/nz0DC.mP.jhNQjaukGNFsfF0ADZ34Y8z4G3FC	\N	\N	2026-05-25 18:58:44.815	\N	2026-05-18 18:58:44.817	0	69e2571a-21d3-4499-8b20-f4118acb0d69	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$OEQ4OsYdH1e1JKUk8WPXcOqXLjxrq.VjysXOkZxJ.ev4gm6cD1so6	\N	\N	2026-05-25 19:01:54.68	\N	2026-05-18 19:01:54.682	0	96e2835e-8917-4f61-b84d-029a67fb7aba	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$jCZlG/XGYudBjcxEHYVQv.PZ0oS6lput/T2qca9lLN/Oi7WKxU1ui	\N	\N	2026-05-25 19:21:45.946	\N	2026-05-18 19:21:45.948	0	ff37fb89-36d2-48f6-a570-2a2999503146	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$5QyIAZc5wU3mXjZSFRzrLOB5Dw6UdHY62ceM46xAyFOcUFOnxnt4i	\N	\N	2026-05-25 19:22:53.206	\N	2026-05-18 19:22:53.208	0	167e8d9b-b33f-486b-8ef1-6f890ae87500	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$4EgYPW3dJ7FS1kw4jvQIb.hSLSOgRLRW2IkOTxqqQfwfC6ZaSoAJ.	\N	\N	2026-05-25 19:25:12.862	2026-05-18 23:43:40.794	2026-05-18 19:25:12.863	0	739da809-bac5-4247-a0f1-f489efbef8bf	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$9svmg3XuAtygtV87lXeaRuoBJLDNdHY4/7O2VtfnbAVaqz0XAc13u	\N	\N	2026-05-25 23:43:40.92	\N	2026-05-18 23:43:40.922	0	deb16196-d736-446b-af8e-54e517a5ae00	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$eX7S9O2ktaN6im7D5jKz/.1LJ2DJ/j6rbh34YFNxpzs5bvMSmNlva	\N	\N	2026-05-25 23:43:40.921	2026-05-19 00:08:25.536	2026-05-18 23:43:40.923	0	36ea6489-4e04-4a02-87a7-27b627a35d26	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$FoGraa1WgsxzMu.ZOlgb9ewVPgf4Ltz34C9U6nGeTqdBhY.oimbWu	\N	\N	2026-05-26 00:08:25.643	\N	2026-05-19 00:08:25.645	0	3c165834-c0db-4b43-a8ef-38dd8f79cb16	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$.vS7U3YXCe2rAF6EyqwFour1.37FiETBBI38qUgSRxLIz99CBXhNW	\N	\N	2026-05-26 00:08:25.659	\N	2026-05-19 00:08:25.661	0	761ab16a-0768-4183-9b1c-dafaed25c69c	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$2ZACu6ND9YYg1zgjgwdwx.3aPQRjXArUn2F5VBkJmL3aa2W4QJ8ae	\N	\N	2026-05-26 00:11:15.399	\N	2026-05-19 00:11:15.402	0	400be7ec-c772-4143-8e73-16229445a99f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$zkwDvQ5tRq8u2hMfqzxaFuMOvXUny0UqRSeKKKO9CNX7ePQQkOtjC	\N	\N	2026-05-26 00:26:51.84	\N	2026-05-19 00:26:51.842	0	32d7b426-5922-47cd-a7e4-3df2d8cc963a	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$CUvsmv9v3TAJIwfzniR/xeQyypBTBfrF4VeM8GzN8fXvvd.GjnDCS	\N	\N	2026-05-26 00:44:15.808	\N	2026-05-19 00:44:15.81	0	b8973ee0-e1e0-40de-9b26-679f5f4ced39	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$YJY.3PgDUQenxAccfDY0Qe9tnYD3kjUf5gzAffmwJoihrGU..9MxO	\N	\N	2026-05-26 01:00:18.339	\N	2026-05-19 01:00:18.341	0	72c54aa8-783b-4d3b-af13-2dde6ef58ff2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Bc8fLhfYpld0yRovLEgsk.JAEfG8YEqY2Dtcifcw1/Ip4WLyrG41i	\N	\N	2026-05-26 01:19:18.438	\N	2026-05-19 01:19:18.439	0	9d9b6d72-c5e9-42be-8bb3-05f67b3f1a8d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$uCNkcPQvo/aZR1eaLqZgvOKB4ZGA.RcqwE1TyEQBgO7RjOUC2lma6	\N	\N	2026-05-26 01:36:56.896	\N	2026-05-19 01:36:56.898	0	9ea59f25-9fad-4e08-ae47-adf5d9043de9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$2qeHNGoEbsqhTbXVnD1D5eO3TCbL6Zj5c.bMEj3kRCliIONob0JKO	\N	\N	2026-05-26 02:40:40.855	\N	2026-05-19 02:40:40.858	0	5340fc19-946b-4aa6-a959-dd93157020ee	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$LTQBdywB4lHbojr/L25MkOzM1xCh8r3nd7exUsZqUioKZwx3g.gNu	\N	\N	2026-05-26 02:42:38.514	\N	2026-05-19 02:42:38.516	0	182e2d73-1379-42e9-8c3b-349cd0384565	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$p7S63UsuLzqJk8yDT4k4EeOzOeRiJ9wAI6wI9PJa1/fdsIfyUSVbK	\N	\N	2026-05-26 02:47:01.191	\N	2026-05-19 02:47:01.192	0	d4beab66-6b0c-41e2-8b5d-e37b4427ef3f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$wxQu17HgVzKKHIP/mgIM4eIJnjOdDULprMyvUhpmjKyiH0zleyXJG	\N	\N	2026-05-26 03:14:42.007	\N	2026-05-19 03:14:42.01	0	c2a6c8fb-6fc8-46e6-afd9-1dadfb87c627	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$pFxgKzObfvHOaj7PRVaTUe2JfJjqhdHQAhnY5jNxtUHQD/C6FsjK6	\N	\N	2026-05-26 03:31:31.737	\N	2026-05-19 03:31:31.739	0	09f34eaf-7857-4775-b986-549626a5fd27	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$.BMT/3jnhqc7oCnfIxlgrOpdEQHHA4pwjRc3cNX556aNHomcct7JW	\N	\N	2026-05-26 04:25:50.86	\N	2026-05-19 04:25:50.862	0	9a02a94e-9942-48ae-8792-ad027efaa99f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$KEFWQK5.BS4.kYTpuN.gTOA7NAt3L6CIMO.t7NUYVVJlScmrHp.Y6	\N	\N	2026-05-26 04:50:01.759	\N	2026-05-19 04:50:01.763	0	59530980-9444-47fa-aca1-0f287bfb63f2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$uUUjPLOO4Uis/.Dbhl5cv.D5MsUBFVTTa9yXaTLUazYpEb/9oaMqm	\N	\N	2026-05-26 04:58:40.174	\N	2026-05-19 04:58:40.175	0	f06268ac-082d-4a28-a6cd-b2c5e5eff6d9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$9LqKe2wQXRjrLaMuNLTQH.lRnq7q3rubi7X.U28Dstxuk7.ZmruMW	\N	\N	2026-05-26 05:17:22.695	\N	2026-05-19 05:17:22.697	0	bfa08ad9-4831-45f0-aa2f-82b2db202464	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$.cDhwJERGK0txSFBykzk..wcA7r12ORl4G.yZq2Rr9I0zmL.e/57q	\N	\N	2026-05-26 05:33:14.305	\N	2026-05-19 05:33:14.306	0	03ad6928-dc43-47f5-9c2c-bd6f385be00c	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$9WO8mWEJBUb.79gPZtuAHeKx6ZPSWJ.sZxPpaRB7WekmGXNPZdmxa	\N	\N	2026-05-26 05:40:16.289	\N	2026-05-19 05:40:16.29	0	93ce9ae6-bd47-4175-b54f-83466fb5410e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$n5FWTLxZm5TcR22YBTfst./y2hLSy1ZVGdiqMbhKRH4pwlpX2ljIW	\N	\N	2026-05-26 06:01:20.461	\N	2026-05-19 06:01:20.463	0	bbd65915-62b8-4f22-bbb0-ec652e89a34a	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$KPfC5SY0fC.3v0P/QHlpjOXQL3BL04W6trErOPwX0otioJBq4pLUO	\N	\N	2026-05-26 06:28:50.348	\N	2026-05-19 06:28:50.35	0	a5e2b271-26ef-42f6-8bdc-262037b33c21	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$/fjxG4YGPqRTd/pQsZIIMe0hJNfbSfozPFpQFxY6aCwwdoJhFa/um	\N	\N	2026-05-26 06:48:22.938	\N	2026-05-19 06:48:22.939	0	5d09c8eb-1c4b-4221-9f6a-af4e2a74f81b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$IfMtN52sl7f8eLpo6kTEzOmanlq5/z/j.D5HHnAMjuhDQIBvLpqe6	\N	\N	2026-05-26 07:03:49.162	\N	2026-05-19 07:03:49.164	0	2a9c9bda-e593-468e-a868-7045c5c09744	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$DZf5DCOjy960FOmiiX2jR.Pq2ssPJ0uwzjow7OnsHZkXUyIy9pmzS	\N	\N	2026-05-26 07:42:31.531	\N	2026-05-19 07:42:31.534	0	6c4a4641-ca98-450d-8774-7f047e7132fb	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$85EC2JfpHZ8/WWEVmCjcJ.L5I0ybujtsnJejZMbCB1qXbFsCI2bqC	\N	\N	2026-05-26 08:03:49.957	\N	2026-05-19 08:03:49.959	0	7a0a1309-fea4-434d-be8d-9bb775321668	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$ITjwyldzh/BSSb9e2KVdgOJRpoF1bTcDGZptaWjveuLmqo8PoiCUK	\N	\N	2026-05-26 08:20:51.297	\N	2026-05-19 08:20:51.298	0	2ef0795e-cf07-4ab5-9a5f-01c930de033d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$mSlsTWMQsA1kp31.Uz8e4uQN8oOkop0cMB0maLsh8yimunHJMqQLO	\N	\N	2026-05-26 08:30:09.228	\N	2026-05-19 08:30:09.23	0	b5de1e76-1131-40e0-836f-c7648cceb838	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$9ds3.3GR0ilW502gNSzHq.sIFJcvidTyZvgSmVLbEBg.e/WsRXplS	\N	\N	2026-05-26 08:51:03.507	\N	2026-05-19 08:51:03.509	0	281c8212-1021-44b1-9ee9-f788502862aa	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$hHgHoN/B0QDCp12LFUGwu.H.akCJkYZgTZ9h8nz4Ed7VHgL9DvlpO	\N	\N	2026-05-26 09:16:49.553	\N	2026-05-19 09:16:49.555	0	52090d65-fb64-47e0-a38c-79a02d9a5fd4	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$ZT7FdEUJ.uA.46snRNwPQOTVh66nzh5hl2FGulB17BFxMSzbiC4Qi	\N	\N	2026-05-26 09:40:10.945	\N	2026-05-19 09:40:10.947	0	8ae6d34c-5de7-465b-a9cf-7ce6e70ef8a7	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$lX66exiNQIuCi6nfeE/IluAx9.XTctjyjltnov9hSU2BxHcqicoYq	\N	\N	2026-05-26 09:59:36.621	\N	2026-05-19 09:59:36.623	0	4f7309dc-5084-4156-8ed0-4120fb8f0e12	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$spR/EIM9yl.XiVdwLyd4WOZNBTh3KUGdLZ/ABVca/l2QZFCLJz19W	\N	\N	2026-05-26 10:18:38.06	\N	2026-05-19 10:18:38.061	0	44f143e8-d85d-49db-859a-f64bf3f8167e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$dh6FsqMUHrp5a4N6GYCmRuAwnydnvvFC9T9ywrva8fkK.NpJquAKO	\N	\N	2026-05-26 10:33:28.829	\N	2026-05-19 10:33:28.83	0	099678a3-3b3f-44db-9d16-59e23bf96486	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$ioFyF8MZvOK9v0ryUDgyIOyazbYGrun4QiYjcjCwMR/OmvU8dpiEG	\N	\N	2026-05-26 10:51:21.474	\N	2026-05-19 10:51:21.475	0	05e06cbc-c7fe-43bd-9207-334ede22e8c8	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$oMrwcHMtNdIprQ4s8ayvkeDWr2/wCs1UZ.frH9SnHxayoeOcfwNb.	\N	\N	2026-05-26 11:08:21.144	\N	2026-05-19 11:08:21.145	0	27ed68ec-e014-4689-ae13-a8099eb36bb3	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$ZCdvtIs1WvAODNqulmUbQeQpuCk6Ryc0eHIezsX3yW/3W4YIYmT6C	\N	\N	2026-05-26 11:26:47.431	\N	2026-05-19 11:26:47.433	0	e7d0036e-d169-4eb5-bf86-d1751dba21f7	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$4lgMmfamR/kMMMRqgWeIpeInzldpo4RHz9zky.AThmp02bt5Rsafa	\N	\N	2026-05-26 11:42:36.436	\N	2026-05-19 11:42:36.438	0	b3310b40-2304-461d-9075-a5a75b8bf438	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$LrwrcFSb/lVLNCJ2BD2nVe85Q7xa0prEhPR3vHl8y.Ui2QQDubZq6	\N	\N	2026-05-26 12:03:00.271	\N	2026-05-19 12:03:00.272	0	4b2969d5-174f-4cc1-b49c-30ca22501769	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$gUXYVc4MQl5DTD2oVizkU..OdRKD.dKj3uVEIW3V9EnGM5zXLIBbu	\N	\N	2026-05-26 12:36:16.07	\N	2026-05-19 12:36:16.071	0	efc0bdf5-7cb1-438f-bde4-eed9b4a2acf7	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$p3rAWGU56exk1bR1.KTOK.dZt1VG9g.ljn.4./pvKMidVK.95XTvm	\N	\N	2026-05-26 16:31:38.693	\N	2026-05-19 16:31:38.695	0	3970ce09-1027-4ad7-81c1-2842f8f5fdaa	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$ob3m1zJIo8WG7vaTwn952eq7hG5G3b2ZDaDaMV7QS4O8t9WTfA.Ry	\N	\N	2026-05-26 17:45:23.31	\N	2026-05-19 17:45:23.311	0	2ce55283-c96f-4d14-949c-f99e5915dc2f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$f9lTCvrkSlQQ8ed6c0YLfulyGx0.Bp5o/zd/l7lLHWHIqzGAyjrhW	\N	\N	2026-05-26 18:16:15.192	\N	2026-05-19 18:16:15.193	0	ecf2baf0-a11b-43e9-aae1-877418965951	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$4SVugEmhnwPiK3BKOOxf5uiCPw6EQPpyFekE84PClMrPX9m2J4eny	\N	\N	2026-05-26 18:32:04.219	\N	2026-05-19 18:32:04.221	0	30b24f38-3238-410b-ab31-9fe2c663fc85	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Gcdx2lipUhsapWHC3WeOZ.CRBXdn5Ru6tdX0vmTQtuqMdIoWlAgnu	\N	\N	2026-05-26 18:36:43.982	\N	2026-05-19 18:36:43.984	0	2528ba28-bd3a-4a31-9489-dd6e393c16cf	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Zw9tx/xA8Nj.EYVyqqjKOO1pud5ny8iZ/w0wpl49jzmWcOxKg6wM2	\N	\N	2026-05-26 18:53:15.93	\N	2026-05-19 18:53:15.931	0	e7988a7a-e71c-4372-82b3-398b503eee01	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$cYrNc0P6Z/5lF2OZ1scXKu1FYdWiI1Am4Z44ih8zEBkD6MoHBr1eG	\N	\N	2026-05-26 19:09:27.99	\N	2026-05-19 19:09:27.991	0	84ef0a98-e873-422b-b407-a0d6eb306f8c	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$xZfpzUj38K8oZXolod6.YuVnq2sBN3XPI1HissR1SkF.bkOI6m7tW	\N	\N	2026-05-26 19:20:14.593	\N	2026-05-19 19:20:14.595	0	04f24224-ff37-4630-97bc-0cff5739e0af	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Yn43z1Anyc2KOX1USGluZ.TzAiVHCxn2CrYUOb6FB229EsGqbobmm	\N	\N	2026-05-26 19:35:22.906	\N	2026-05-19 19:35:22.907	0	a5846176-372f-4ee2-bea8-d4f5101015d2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$rofRb04.tmYS/SZWLpK2iOZXval4P8arnNMe3Os9q49oWxu4Okhku	\N	\N	2026-05-27 00:25:53.071	\N	2026-05-20 00:25:53.072	0	59bc0dc6-0f28-4c2c-aa6a-f57657236bba	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$HmnG3/Ya0saeKW.aLwq11.RHzxx12Ev6yY2j8GZTiTkSvvdxBJ5FK	\N	\N	2026-05-27 00:45:11.064	\N	2026-05-20 00:45:11.066	0	93ffb3b2-2323-47df-9a3f-9c7414b20f26	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$WC3WUvncH6LsR25Z3mvKfuktK.3MQg4Xs6S6PylK3dkjTPUv3s1f2	\N	\N	2026-05-27 01:20:45.166	\N	2026-05-20 01:20:45.167	0	2a5e0e5d-5b7b-4ba3-b018-2328e7c7a893	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$2ow3Ow28pfZ07j1HBtEsh.C/1LblWme1B1EpjmCmKr4rECuWY/KMy	\N	\N	2026-06-07 11:09:05.463	\N	2026-05-31 11:09:05.465	0	21f909a1-957f-49dc-9f0a-0a975b67d59a	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$zz16SuacYMqBPfujk/hMoOgI560vD3cHEKjI5ElV2uGNLzodqtfpS	\N	\N	2026-05-27 01:31:19.437	\N	2026-05-20 01:31:19.439	0	178ac323-1861-475b-888b-e89759900aee	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$hj78m0GuOIAgYOJ2uRV2ue7FyOCC.O/dBhQYFz8gOI6TK9qxb6lCG	\N	\N	2026-05-27 01:50:22.725	\N	2026-05-20 01:50:22.727	0	37dc5b99-cf0e-4f63-8fed-0ecb82334ffe	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$VQjUClIt/J/G62i7tS4L6uAiwqRWLD9bEsd9AdRP9fYoUAH0XlBxu	\N	\N	2026-05-27 02:11:10.424	\N	2026-05-20 02:11:10.426	0	aa3c4899-c36a-4073-893a-8b35093b0f1d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$2YDBx993o8Y4jpbDfGfUAOVTZUqtpjaGMgcMH3HcufkcKtA1d9/wS	\N	\N	2026-05-27 02:32:06.836	\N	2026-05-20 02:32:06.838	0	ca7f0bb6-3616-4d4a-b4af-5062ab013923	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$zJHZ2oWb5nP/xm4ySeBaAuvwMSFqCYBMmfgFaz7xPs6DXo5LBMy9.	\N	\N	2026-05-27 02:52:08.532	\N	2026-05-20 02:52:08.534	0	21cf0def-83d0-4004-909e-feb16c298a03	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$wvdZXOYLmO7BWT4Mlo4rlOSTM3loA05z8zJtz.xS8JhldEsu.HxmW	\N	\N	2026-05-27 03:28:38.842	\N	2026-05-20 03:28:38.843	0	b6296c73-2950-497c-86d5-1da784aa98dc	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$fLe5kOpYexXA28PqZzZdzeL2rkSLaizq6BNzwDjsiMo0Njecd69u6	\N	\N	2026-05-27 03:41:40.205	\N	2026-05-20 03:41:40.206	0	be96e465-cdbe-4d83-99b0-3bfca7370c5d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$CGw8ScMVWW/PVBXr4HBUNuQI3wiZAQGzI8ubL0oqHKayCDHt.pNKW	\N	\N	2026-05-27 04:35:49.745	\N	2026-05-20 04:35:49.748	0	39926b7b-ac22-4dd4-85b9-a0d6e0bc373b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$WD641NIiubE9rarObPUQlenkG1qdB98/R6wJhIMmbI4K2vXetA7RC	\N	\N	2026-05-27 04:54:24.162	\N	2026-05-20 04:54:24.166	0	571b3a4b-3917-4c60-a7d7-93648d763cd8	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$eaACi80jmSnbNo7ocgtaKe3r2/wffh7RwsdkMVwdk7uVa48GC51oS	\N	\N	2026-05-27 05:13:53.395	\N	2026-05-20 05:13:53.396	0	13c07f90-aad4-4ab0-8234-829bcc00d3de	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$YqVi/b/vRDtR8rsIj1vEUuzQAfD6ghnS5N0o7UEqk/l2NUTJzf1JG	\N	\N	2026-05-27 05:31:24.013	\N	2026-05-20 05:31:24.015	0	4e2cb140-1b37-4031-92c9-b4e5618a9593	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Vdx6Wja0YuAoofRaAwHa9OykbFFZlqdWnufcO/6zVbBsvZZTzLPqS	\N	\N	2026-05-27 06:04:21.852	\N	2026-05-20 06:04:21.854	0	149f036a-b4ac-4267-aee9-e733d479ecd7	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$RuFI.3GnESbsP0Sh4Y45Me//8t7lKq0fCtmaGOCNyNNcmrIpPHiO.	\N	\N	2026-05-27 06:19:51.117	\N	2026-05-20 06:19:51.121	0	e7cac128-e5b8-4cb4-8c27-70ca01ebbeb6	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$4hcg3yp6KIroP6KhTFM60.pFQBspT8goj.dYLh2N716eOeTD2f1Xm	\N	\N	2026-05-27 06:36:40.983	\N	2026-05-20 06:36:40.984	0	513dd382-4dc6-441c-80ac-464b71ea8add	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$4WryPcf58vCgitNZ5BWIN.oGogzK5lfI64DhD3/z0q4f.xi6lPewS	\N	\N	2026-05-27 07:20:44.329	\N	2026-05-20 07:20:44.331	0	28b97298-8ce2-4193-a873-a269fd0c19b9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$v16J3/hTc0PgROK6548.3O6x8NePi1CunS4pFL6GXNOzszQzeO3OO	\N	\N	2026-05-27 08:38:26.775	\N	2026-05-20 08:38:26.776	0	7d8fa1a2-14f4-4f38-8762-cd62c3f6629c	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$cx4SIUMiAkoQ1T0xgS9u4.2x/ScXVguN4u4rrc81kzAIuCCY.tJza	\N	\N	2026-06-07 11:10:54.296	\N	2026-05-31 11:10:54.298	0	9b197d56-3db8-4442-8367-d6fff19bb60d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Avvg..yjYBpZ2Poq4pnvG.OHk1DjJnJ3vMDtXKDD1GJpAvY9g0Sj2	\N	\N	2026-05-27 09:42:45.036	\N	2026-05-20 09:42:45.037	0	74d80e58-8ec9-471b-a579-7b7844e568b8	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$kCFYJ11ot87LYXDkLaziROvUXQDUVtm0zawhCfVjIv1HqIcW.O9ke	\N	\N	2026-05-27 11:32:07.012	\N	2026-05-20 11:32:07.013	0	7b078c92-7cf6-46e4-987f-3140b10290c5	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Gvc6EuK6FqkYSa3YfPyV5uMzjwIX2AL6TogldeiYleQawwiFOzbby	\N	\N	2026-05-27 12:41:19.423	\N	2026-05-20 12:41:19.425	0	0543d0da-dda5-40d9-94c6-667066229bad	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$ORSEfVWHXqaIYJcxKzefHu15BHgVnv/FhXCOM7RpNZ1nxhmRKBQc2	\N	\N	2026-05-27 16:00:40.139	\N	2026-05-20 16:00:40.141	0	e2e6547c-833e-47bf-8457-dc9d1667aa32	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$4bVxEZgZDC4NvccgXFmPvOu4UHRrRbujz3Np279lorqnaLL9MIiJW	\N	\N	2026-05-27 16:16:37.482	\N	2026-05-20 16:16:37.483	0	ceb64b16-1712-4ed9-b41c-e53c5e83d86b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$A8jh88QggRSu56rGKjaup.KFQAbNN7XmnJcEeD2jL81qB8F0VRbMK	\N	\N	2026-05-28 05:04:18.055	\N	2026-05-21 05:04:18.056	0	53f4af5c-1e1c-4a33-8830-e5506bb66e46	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$VdZNoOHXuI6oaMpvIEPF5ONBe.1X.2uBlWhp2Pn9TIyG1wjot6omS	\N	\N	2026-05-28 05:32:12.319	\N	2026-05-21 05:32:12.323	0	0f05483a-4333-496c-8f58-a56d1977a94b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$mSn840BFOxTBZtIjJUJaQ.oeFA909Ac9boBvlZf1.hjkayXudSfVO	\N	\N	2026-05-28 05:53:03.499	\N	2026-05-21 05:53:03.501	0	b15d3d08-26bd-42e3-9478-fa8eaeba520a	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$T0YyjUKHpJt1oMA/rXaXs.yNmVoAggMH5CRKZ0rXtI5MBrPrEa9N6	\N	\N	2026-05-28 06:24:38.978	\N	2026-05-21 06:24:38.979	0	cf9ee9fb-855f-4d13-92b3-c87e395535f6	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Amumzb2vc0xffF5WUP0sq.BudUffw2EfiWAkKwmkFOWUWgCd7Uvmq	\N	\N	2026-05-28 06:38:26.991	\N	2026-05-21 06:38:26.992	0	2bc73730-c6a3-47a1-810e-82a54842441e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$uWJao0LcEOaUvrevsXU0EOgxwdM3B4wui8fsGt1qbD5m9i80GSBia	\N	\N	2026-05-28 10:35:57.562	\N	2026-05-21 10:35:57.563	0	8251bb3a-ef90-4ddb-91b5-01435a544617	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$hLQrAtPOKaIadUk2pDCQ7ORQxmPV7kxDmfgtZzIpqc2ZT1AG5jHXK	\N	\N	2026-05-28 10:46:05.19	\N	2026-05-21 10:46:05.191	0	3d72682b-b488-43f7-8ec8-ec1c892e2eb8	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$UTSgLC0r8e9OPL19Yo34f.lT9iEDwDIUV7v7oNHFq1qx3qw4p46La	\N	\N	2026-05-28 11:07:03.886	\N	2026-05-21 11:07:03.887	0	1a81cf48-f1f6-4f2b-8cb3-8d75bda3a5c6	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$zO/.x9vPUCkGWqrMqV4i8.d1z7MnXN3uuuPz.KI9iqYpwacWRcqca	\N	\N	2026-05-28 11:17:33.287	\N	2026-05-21 11:17:33.288	0	74123cdc-57b3-40a1-b5dc-bfe0492d38ac	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$8I8MAIR8eapy9JOf/KfHvOoqbq0DzHzQkokfd1JEL/59SiAJgJP2m	\N	\N	2026-05-28 11:37:26.696	\N	2026-05-21 11:37:26.698	0	06f78e02-7031-4128-bbae-99b210325d06	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$dCPq4KaaGoPDvrzojnQCB.djEa5MzGY2NKbf1UGGu25eC2KOwzakO	\N	\N	2026-05-28 12:02:28.691	\N	2026-05-21 12:02:28.692	0	288d92fb-1453-4a6c-98cc-2e56986a5d9d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$MEi22An/jWhm.52N3a3jB.NM2Wy.AzaIlK72fo9yJAojGkSgRNjHu	\N	\N	2026-05-28 12:20:27.452	\N	2026-05-21 12:20:27.453	0	c0678755-0908-44c3-bc16-6976d44d5d34	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Wx7Ap6kcq0MnQI064lbEMeseEQsylDoQR1RCuSJM8U/EuxVmugaU.	\N	\N	2026-05-28 13:53:20.463	\N	2026-05-21 13:53:20.466	0	9c69b201-1c62-49c3-b96b-4bb6471aa2e0	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$t45nKmMSQMW8jrGtca10/OZ2DWhkgzWAYOewPD3kaKuIfKZbxnPB6	\N	\N	2026-05-28 15:17:10.213	\N	2026-05-21 15:17:10.214	0	b3fed9d7-3639-44dc-bd40-cc5bbc2d98fa	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$RxNKSSmgJcteji7ucCpukuy8idLZKVaJZwwQ2jDsJec1tdDqMJx4.	\N	\N	2026-05-28 15:18:42.198	\N	2026-05-21 15:18:42.201	0	adf0abb3-2035-4907-8c3d-4724abac2f3e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$6gy.t7SN5Z.G/uFsvXq7hOA7RbqbYb0r7l/NDrFDQY6uaLe1Kjix6	\N	\N	2026-05-28 15:34:34.905	\N	2026-05-21 15:34:34.906	0	fda3e2a0-4b0a-437b-916f-d7c83179627d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$rtvPeTYz34Kl5/eufVKViexTtnAfHAw9pybPVUnQlGemz28hmPEdi	\N	\N	2026-05-28 16:18:05.284	\N	2026-05-21 16:18:05.286	0	f0493785-6423-40ba-8feb-a7927f3a20c6	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$diBaqEcnXNxlfCVGYTYOF.LPBiflxMefZvO5dCfZ32Z5kB9uoaGfC	\N	\N	2026-05-28 16:33:35.317	\N	2026-05-21 16:33:35.319	0	4e81ac97-1d8b-470f-b9ca-ecc70959ae6a	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$zhyx2h0wJ23eGhpBo4dsCurxcgd07OBCnpIr48EPDZx6UAYpZQgoe	\N	\N	2026-05-28 16:44:07.315	\N	2026-05-21 16:44:07.316	0	4e28071f-99bf-4781-acca-90fe4ed6620f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$qqEtvGNKiknbw5.rHQrzq.zLQqdHI5PKXYP8eIAsEP43fTU9xuKu6	\N	\N	2026-05-28 17:12:26.449	\N	2026-05-21 17:12:26.45	0	2636bae2-2f4d-4e3d-b1d5-84e79e1d6291	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$.MwMJKr1Ch8T6t5opiwvX.OV2WtAPLCdz7Qn4yOx0eWykuUU0PJJS	\N	\N	2026-05-28 17:18:08.945	\N	2026-05-21 17:18:08.946	0	19a4b94b-bd13-4ab1-94a5-98bc7bf84fab	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$/rn0gv5hX2wa6oaTFpKqCu5Y32taEaNIKzqwEsbSiFEs3uQ9Ri1Cu	\N	\N	2026-05-29 05:04:06.608	\N	2026-05-22 05:04:06.611	0	74fa8489-de54-4dde-b30f-7233c93e9435	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$.4kJC/8nlQy86ooxhfjQgueyT19LmAFVdzP.2pxE5uYco82piqU3i	\N	\N	2026-05-29 05:37:43.235	\N	2026-05-22 05:37:43.236	0	5ab4eeb3-efcd-4764-a278-3dfb5904e030	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$qgLFWXI3Gca9hjL0Uw8d4uNRTQSr6mrwEi004/i8A.qqBe6Lyb5G.	\N	\N	2026-05-29 05:53:32.835	\N	2026-05-22 05:53:32.837	0	59d42761-3d51-45dc-844a-5560def60de9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$JDcnwcdtA4PWgaOWeB8fqewujHXsGJAsDxEFp4LPjaWmV6Bnguh/m	\N	\N	2026-05-29 06:00:41.005	\N	2026-05-22 06:00:41.007	0	1aaf5080-587f-42de-83b4-9c1c3d7edefd	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$5mfmyzws/g0CTjtGgKaL5u83WQSfMWdC3gTXanuyyG19QgRXAeu.C	\N	\N	2026-05-29 06:27:15.728	\N	2026-05-22 06:27:15.73	0	4c1b53fa-b4e8-4c4b-a102-ff9b332b97e1	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$/E6BZKIXXjs/GhBn4HNmweMsz0L5Cz.QAK6AWLxhA48QwIDumVbDK	\N	\N	2026-05-29 07:05:11.487	\N	2026-05-22 07:05:11.488	0	51ae5e41-1168-4cd2-aa7e-9949b73b163e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$pnzwqC7fjLaTf83iHmZX9..gmUoN.XnLCoCYzUu.vNNb9GytLTmPO	\N	\N	2026-05-29 07:21:57.934	\N	2026-05-22 07:21:57.936	0	1406fb0e-96d8-4fe7-bf31-48d129a25a3d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$kZdQuq22MOuef1i8zLx9MOJeVeeaAtzIsSzIIUc2QX6g3Dd45PLc2	\N	\N	2026-05-29 07:53:22.236	\N	2026-05-22 07:53:22.237	0	09acc1f2-55f4-49b2-af2a-1a4418bc7b6e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$WGQSiNNA/i7LwTo7Scs/sOLx8jmu6oOYbRZQU5C3HZ3e19lLHVdiG	\N	\N	2026-05-29 10:36:46.209	\N	2026-05-22 10:36:46.21	0	3fbcf674-cfd8-4474-a9b1-01fe46b93929	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Z0F0rr783E77j6vTjTDO9eYloXdfjGn6.HsJED1ykRWuJjBS6kUiK	\N	\N	2026-05-29 11:22:54.091	\N	2026-05-22 11:22:54.093	0	9c114698-b113-4a2b-8eb2-995196cf6982	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Ifk8COCFzJybNh.Z6uAeYOv90jrPUwi12jgZmK7zhZ3oU7Sb.0xia	\N	\N	2026-05-30 13:20:22.097	\N	2026-05-23 13:20:22.098	0	917d0c00-6481-4b75-8de2-da3de0a93737	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$aaSl.8agbNV9PxrNtJ2Saes5KGId8HjqnQrW7fYBWimVJY8m8v4TK	\N	\N	2026-05-30 13:36:00.997	\N	2026-05-23 13:36:00.999	0	a984c329-5b1d-456d-804e-4677f5bda836	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$VC35zpCeGy8Wq9bPHXWuaOAPfs0vBW8QnP6vaACd7PWGVY4c5Gjmu	\N	\N	2026-05-31 07:20:38.281	\N	2026-05-24 07:20:38.283	0	af5a4262-5951-48ee-aad8-4fae546c418e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$DSxQsQ0ucgCa.QhYnNbPRuH7WK/Cqx/ca.Pr3KD6e1nskxYqf.1ZC	\N	\N	2026-05-31 07:44:41.038	\N	2026-05-24 07:44:41.039	0	311e40db-c503-45dd-a565-7be9ed46fa89	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$uoopsncaDcQOqS7kWwwspuepIhdrPEjKHkZTvKfoaglafY...yyLW	\N	\N	2026-05-31 08:01:55.145	\N	2026-05-24 08:01:55.148	0	0dd8b0af-500e-4602-a3cf-f0c8cafa4f32	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$G1ecLChqLORMZ72C8uwD..9W9vmvYYEJt6A8LYMEiYRiiD1yZg1Vy	\N	\N	2026-05-31 12:18:04.163	\N	2026-05-24 12:18:04.165	0	ecbeb40c-d988-42fa-8fce-c47c5c8cee10	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$3iK/qlutwOoQn9YKJPx.xegxfOlxAcv6mnVDGXH2UCrnwT1XivEEa	\N	\N	2026-05-31 12:36:12.127	\N	2026-05-24 12:36:12.13	0	df8fae4c-b7bc-4121-8b56-f0734238f33b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$YQJZGpbH0Yy9s0QHrv9EveOjnX3znjnMYxlBwEZVyEYuOPrzl/rfG	\N	\N	2026-05-31 16:51:03.193	\N	2026-05-24 16:51:03.196	0	98174fbe-576a-46ed-a119-ce105dbd0b09	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$o0QS4XSLEWxHSJfieBgbtOrBqNXhnmIGi2OQ7PUdtRUnhHncRhpO2	\N	\N	2026-05-31 17:06:20.566	\N	2026-05-24 17:06:20.568	0	826c84bd-4fea-4900-9c71-07d28a24a498	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$AI7TjuJnA8A7P817JwmHzOfM0BBZAsNIc2D17lUczBhGJ3ZL.MPVa	\N	\N	2026-06-01 05:12:02.589	\N	2026-05-25 05:12:02.59	0	c9f98a67-d596-4abe-b6c2-6330c493f367	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$QAcy8XNaH/x7pdfrqDlude2dzS1kaPUWQn9FP2P9KotImxFbI9K5a	\N	\N	2026-06-01 05:27:38.377	\N	2026-05-25 05:27:38.379	0	74dfd120-b75d-4a0f-bc1f-4dbd5491b231	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$1KYIM3r6k/ZBIn2QRQx26OQeajU5CNk/tFV4cCLuOisU8u71WjZ4S	\N	\N	2026-06-01 05:43:31.509	\N	2026-05-25 05:43:31.51	0	16d919b3-5a03-4bb7-a68f-8081a15a00a0	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$bO2t2CIZz1aAE6eTDm0gGeWAoGoiZlbH9QDcE0f.hOOjCmzo6xGQy	\N	\N	2026-06-01 06:12:43.115	\N	2026-05-25 06:12:43.117	0	eceb060b-406a-4647-942c-cca461e0aa39	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$WBlCwLLCzrGvjQFVSuOIIuYyT6ABsg9PR74kpvgF4V.Y9YGRVgE.e	\N	\N	2026-06-01 06:20:22.305	\N	2026-05-25 06:20:22.307	0	d437a449-d842-4ad3-8708-a67fa2b67317	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$weoJne6a6BrRWBr6Y42nO.Xa7jkOU.zkRIbxKjIP.UJRWn0RTJKpy	\N	\N	2026-06-01 06:30:11.874	\N	2026-05-25 06:30:11.877	0	13f36ce8-87d7-4f04-924e-14fdfc96db9f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$mfFCqHFzqqhsQd88MtuJmuRQS1TYb5wQG.o/UAhm4mDDLGeBKI54C	\N	\N	2026-06-01 06:48:55.964	\N	2026-05-25 06:48:55.966	0	467d2636-7e92-425c-8a57-52a0b21aed5d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$HJcdCcN8P6qU2Hdw6ry1yupavnR9RoV77xyB8RCdF1aVn6mY2oE6i	\N	\N	2026-06-01 06:59:38.17	\N	2026-05-25 06:59:38.171	0	1cadeefc-2dce-455c-9b03-a082cb8d49e1	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$xz3V/Tx0ZsOk2yHmfwZ/J.ncoh3DteQc/dkaMXq2Vat1k5dg45kK2	\N	\N	2026-06-01 07:17:02.432	\N	2026-05-25 07:17:02.433	0	45fbcb44-3194-4875-8f1a-e6e927b7fd31	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$VrYWigOegFH04Cen4FzN6.Yrcm3l7WO/1WEwD9Mci/nmUtuK2OhzW	\N	\N	2026-06-01 08:09:51.096	\N	2026-05-25 08:09:51.1	0	a9e37faf-e918-4134-b279-0bff093f1bd9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$ZYMS.Q0ayzSNynemlc2T.O7NMUFVneEiqq4Hor9jle.Zf5G38cbAS	\N	\N	2026-06-01 08:25:56.263	\N	2026-05-25 08:25:56.263	0	cb057609-5e02-4675-83ce-eeb08ecd4f30	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$55t7wPDUEEjuZ/sB8QIIver9UnLFWnX1olVO16cly7jMowVXDEYN6	\N	\N	2026-06-01 08:38:45.233	\N	2026-05-25 08:38:45.235	0	53846148-8fd6-4c0f-b25c-e720120d14dc	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$swt7wFITUrXNBAcrhfduaemt86doE/NjrZtgSa7Ru3.L1cjDjzovu	\N	\N	2026-06-01 08:58:33.337	\N	2026-05-25 08:58:33.339	0	43d5f13f-af7f-48cc-a885-806da53322e2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$4fY8QiJeRuxOB4N3N8A56.4lYE3NUm1fMYTIke.RVnAOS1B9E/icu	\N	\N	2026-06-01 09:23:55.314	\N	2026-05-25 09:23:55.316	0	923fe4f7-790f-4bc7-948a-5d2c9f7c2194	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$2mxFkighxiWyw5SkCktM6.lqaDyc/e/EUHWleVLI2rFqTyNpo/fQu	\N	\N	2026-06-01 09:31:35.389	\N	2026-05-25 09:31:35.391	0	f3cbde78-9e46-4ce8-a6a5-294134ff31e1	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$gYi.N5P.QxJ84hJFwleOlOiTRBr1sPGBYE01FHvFdzbocEnZHIfxy	\N	\N	2026-06-01 10:01:41.867	\N	2026-05-25 10:01:41.869	0	f09366a5-76fb-4ea6-ad01-820382bcee6c	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$hQ9Rpe6ifI4O4t5q6WwSKeUQf9pTTRsMbYopNr8qYg/xfb9Ev9VH.	\N	\N	2026-06-01 10:14:27.36	\N	2026-05-25 10:14:27.363	0	d401b366-791a-4713-a831-30c5836a6772	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$AuQnSkHKiX3zWDol.iW4ne2lUhZWewHRlIQxsYCKw8lehKbK6vdjG	\N	\N	2026-06-01 10:33:28.548	\N	2026-05-25 10:33:28.552	0	a7dcb1de-a1f8-41fb-86bd-ccfebc526ead	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$a88RiCcUxTpbymCwKdgtkem6.JowLg6nEX8osYTWj0tdMgTzH1NBS	\N	\N	2026-06-01 11:11:29.112	\N	2026-05-25 11:11:29.113	0	57ea0c6d-7a8a-495a-9380-0b443e7cfe00	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$4AIWT7g7L0udJSX0a/acYultyXT3/zSqZH.L63iMQn/.6ctWMQEvy	\N	\N	2026-06-01 11:32:38.686	\N	2026-05-25 11:32:38.689	0	96a7fa48-4dc6-4774-9b9e-1c15e3fea02f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Z3fDIxUkgAvwtJxH3pa7Q.JpswK9tBG4bj8mzcAmGffkVLKHqi3F.	\N	\N	2026-06-01 11:35:15.01	\N	2026-05-25 11:35:15.011	0	88d611c1-d1fb-48f4-94f7-ab4cd1f79c91	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$wThDchp0wTHqbSiasIBsN.bbh6dUtOmRDodSriSvxvEZp7ZQurKkO	\N	\N	2026-06-01 12:04:41.805	\N	2026-05-25 12:04:41.807	0	a570a1a7-f374-4f97-ad0d-be26b167984e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$ZtQcKAnyuTQRjO8F0MSMb..iaR0msFLkhWSzggJOYG1TD5fvLZ9LS	\N	\N	2026-06-01 12:06:27.392	\N	2026-05-25 12:06:27.394	0	d145050e-73ca-4c7f-a0db-fce43231d40e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$UqgNr/vuhYT6DWdMgiss/.e1p9wRKQNRZg9sQ.mDENuJjnRaCHhzG	\N	\N	2026-06-01 12:25:00.953	\N	2026-05-25 12:25:00.955	0	ca91e300-ab11-45f8-9e13-047167c85c4b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$DWTl3mgibn84r0TEL5YREeFf5PEJtPuMylLntmZbNaAGu/KlWBXqW	\N	\N	2026-06-01 12:41:49.898	\N	2026-05-25 12:41:49.9	0	62d06785-f71e-4744-b309-c696c02c0707	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$0Ps060QaOo47f2Sac.lmLOSCRAU.FnG.cyitNU5jTbajAKM57UrSO	\N	\N	2026-06-02 00:10:29.246	\N	2026-05-26 00:10:29.247	0	cf05d9a0-a5a5-4db4-8e9e-0d5e28a70afe	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$4ob9wdOe9bspb2fKtQY.hu6G/g2az2b0qsl50grleB30SaQDqxrHm	\N	\N	2026-06-02 00:17:11.313	\N	2026-05-26 00:17:11.315	0	05cada9b-14d2-4548-8894-4f480a1266a4	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$XBG2k6vEPSji7qh8SrdLf.y/GvoqGjIhYdUbLBulbqfk1mf9sswN2	\N	\N	2026-06-02 00:36:38.854	\N	2026-05-26 00:36:38.855	0	c04294b8-c9cd-485a-8c42-0f6a10e884bd	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$5a.06PVh5P3epe4pWyLGdOS.QUx8LrPKlC2mIgWBrzI0FfwMuWIK6	\N	\N	2026-06-02 00:51:55.54	\N	2026-05-26 00:51:55.542	0	f56d2099-92fa-4999-88ff-266b32607163	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$D9yRSsvGt9IvJ5j82TB1te5IfVKjbqGm93Q5k6AgrW9bzVfddZbj6	\N	\N	2026-06-02 01:14:54.277	\N	2026-05-26 01:14:54.279	0	6072dca8-6cff-485c-bdac-4c2e29280662	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$8eiCzxitz.SUqw00g72iOOlSFDouV8tlskZ16QlDU3JWMMsYRJL6.	\N	\N	2026-06-02 01:30:15.395	\N	2026-05-26 01:30:15.396	0	872ea7eb-f113-4de0-a25f-1dfac8c602b5	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$tTmdBSAAZn4/9C6a93lS5udrCkLelU6V2k/WgH9M/025CzhnCoJFm	\N	\N	2026-06-02 04:41:45.42	\N	2026-05-26 04:41:45.422	0	90d11fdf-a5ac-42e4-9bf8-d39fc29cb98d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$smZBSYIr0CvhbxAMPbh87evjlloTpsMGwf7uzng22p03qnO756ZfK	\N	\N	2026-06-02 05:21:22.907	\N	2026-05-26 05:21:22.908	0	a143de22-e8c1-4122-b2a1-5065bcda6e4c	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$jrzJfpOsI3.lG7Jxu3WHc.s/FJHkM5XmUPTKESJt.Q49NunYSWu8W	\N	\N	2026-06-02 05:36:59.251	\N	2026-05-26 05:36:59.252	0	fdc569f4-e3c7-46a1-aaa0-284955079ffb	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$1pfW/Jaa4H3CLnNGkrM6wu40WgzZ0s9zpzMJJxjTg7gnMAnueiG0C	\N	\N	2026-06-02 05:49:39.022	\N	2026-05-26 05:49:39.024	0	1bece3f6-5c73-48bd-a5dd-1be93a65a03a	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$d/h23mj9G5mPIISCT.0HWeIW3suWodQwr0WKAhlzkj0VMAZoqhBsu	\N	\N	2026-06-02 05:51:12.745	\N	2026-05-26 05:51:12.746	0	92964406-4bb4-446d-897c-4b4c11c76003	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$l/3W0zERew1dldeRu4DKYOOYElC7Xg3wLQxt7ja9Do6Mj7wchU8eq	\N	\N	2026-06-02 05:55:57.752	\N	2026-05-26 05:55:57.753	0	946cd55a-542a-4755-b694-d68f9c4a6de6	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$rsorAY9xJlWTqV8jJ8xwveu9bu.aK/9bEvJ32Pwh41eyk6aNlnPJy	\N	\N	2026-06-02 05:56:10.497	\N	2026-05-26 05:56:10.498	0	169bf4d6-a58a-4ed2-bdb5-c6df35b8128d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$ba7ZRgG2lt0vttuZw/u/KuDMRcWOj.Epbpfzf4kZI1xKcmIYAgtJe	\N	\N	2026-06-02 06:11:30.669	\N	2026-05-26 06:11:30.672	0	438dbb4d-748c-47ab-9da5-9ce32a8c9dee	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$63K2bbmP9VZV/8.bXOxK5OueSVSH3fdWTXfTINB1GNeGTUFaExhiy	\N	\N	2026-06-02 06:27:15.454	\N	2026-05-26 06:27:15.455	0	0c21ca92-99f4-4fe0-b653-bc3dafd5fd71	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Bof1V6rIsC5JABx70fnADOHejHAQPK8B4BocX8Gg4ZkygwT9qlr/e	\N	\N	2026-06-02 06:49:27.87	\N	2026-05-26 06:49:27.872	0	10bb816d-2d19-48db-9df1-c970eed1db3b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$UJnz8v7wYRJE3iv7J8wN9OVtrVHy7m2ekp6QVk.lb1VO.Q03jWb3S	\N	\N	2026-06-02 07:04:50.308	\N	2026-05-26 07:04:50.31	0	aa3f39f9-e54d-4e85-a7d6-423a30131175	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$L.4taGspxrtSTW1s0ZCWdOoQ8U5pLFePXdbd8E9yEULtkf3sI2HTa	\N	\N	2026-06-02 07:34:33.949	\N	2026-05-26 07:34:33.951	0	b2eecb5d-9ea4-4a31-bd6f-c2e0e215dd07	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$qoNL.ymcBwsmB1dL8WaMCebYxnZL7ZvM6GACuRWhlAtY94MsZLIu2	\N	\N	2026-06-02 07:37:15.642	\N	2026-05-26 07:37:15.643	0	50544169-7d9c-4462-a82c-14071386a235	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$VGfC/xyEqoFD2fZ3sUGz/eQlyvJaGKohEexA/lGBV.vM4N0th8Gfm	\N	\N	2026-06-02 07:57:03.469	\N	2026-05-26 07:57:03.471	0	b95b19b9-54c9-4cdc-af87-85ef529c8b5c	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$xFCus25ucKH6fOP8q3Bft.QAf.0FTs3s3MGbJ3fzjFrNzi9pQ6aVC	\N	\N	2026-06-03 07:19:41.375	\N	2026-05-27 07:19:41.376	0	8da284e0-487a-4163-923c-d1c94a72b145	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$3WzoVkN1edH.nbHr0c38LuzmdwF7YRtnuXUbhWZimBKkHMeuzvzZe	\N	\N	2026-06-03 11:23:15.506	\N	2026-05-27 11:23:15.508	0	bed35818-114a-4ba8-a7b1-f9924cf695e3	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$2GRu/ZRdZS7RpJP57F04aOFnv2VNdczzl5LQ0Epg5.lGQYVs38KfK	\N	\N	2026-06-04 00:40:04.154	\N	2026-05-28 00:40:04.156	0	248fd8cb-e237-4232-b9cc-56e9e73e43c4	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$w0Qyx/..ia9YAsRYMHB0rO7U6qwlQc0CqwH5hsPtsG4ar864jPk5G	\N	\N	2026-06-04 01:50:20.57	\N	2026-05-28 01:50:20.572	0	093b253a-1742-4e15-bd73-7cdb3b5121e5	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$ConBABGQH126KlO.MeiBYumE2Ut7nFCmWMTk.jAx0ASOOzkhay/be	\N	\N	2026-06-04 02:38:23.547	\N	2026-05-28 02:38:23.549	0	95154d3e-229e-4c21-9337-7085bc75c5c7	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$C6oWjrVbrvWTBWY8AVKw/.zyXdhLwIDQx9P2mfqQ7ZH6SZGjdfVzu	\N	\N	2026-06-04 16:08:29.753	\N	2026-05-28 16:08:29.755	0	06cf6c69-99c5-46eb-b16f-4beb6235b280	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$9KnOrhYfFVUxAKv1WJbOqeuiY4tiA3alQYZxWTlvpNpXaCZy0nxGO	\N	\N	2026-06-04 23:12:54.989	\N	2026-05-28 23:12:54.992	0	65205e7e-78e1-42af-a8e1-8b6ffc7fcee6	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$TxVV1KDSLGTIi.QngLC9.uSi1RreMzhYYo73hz6ds2rZdbWWrBDOu	\N	\N	2026-06-04 23:40:28.091	\N	2026-05-28 23:40:28.092	0	0b33cf9c-2e49-4987-bac7-c3fb4aa67d65	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$JWzdkllPHtLHG6d7pDCthu8ZUOvzqkFWtISX2ZtND4SUJ8/GIOC5m	\N	\N	2026-06-05 00:23:36.502	\N	2026-05-29 00:23:36.504	0	20a2d81e-da59-46e9-9e74-7e5201be3b42	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$3GyzYpUjJcjUE0rGQ/hBT.f2AYC/sXppE3k2Ae2DvZ3q8LGbkQevC	\N	\N	2026-06-05 04:35:40.453	\N	2026-05-29 04:35:40.454	0	7bb61330-88ff-4982-96f4-1be304d180ac	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$JN3Ctzc3gphimBA6BWWCW.36sF0dmvL9oqyNCtmujkZbUnYiLZr.S	\N	\N	2026-06-05 04:50:16.142	\N	2026-05-29 04:50:16.144	0	d49e20ed-e973-4704-9ffd-282abff249ed	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$QRHgqO7PMknybNjJAvngi.YL22Ahp.hxCZ9QJG.vq7uH6DJTvfd/a	\N	\N	2026-06-05 06:09:57.232	\N	2026-05-29 06:09:57.233	0	a9e2cf9f-e259-423f-a9e3-3b091f346264	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$axBQymW95wyhp3HDJdeZyeQIuNFq7UR2OovdxYJ4n/9dFsDZ6bliG	\N	\N	2026-06-05 06:55:33.9	\N	2026-05-29 06:55:33.901	0	40d29d93-ab2c-4813-a264-6f9cedf4767b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$VCX2bHNeokJiZD9ZA6Z0HuG2x1lTqEQ3Zz5zeGWpvmL7ci1AJp6.K	\N	\N	2026-06-05 07:29:11.542	\N	2026-05-29 07:29:11.544	0	d4b55bb4-1c32-4704-a0a4-a72f09535ca1	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$7zent7y4gaVDAmUorD283.f71qD9MdsQA19yB0r4BepJp/6IS5o6q	\N	\N	2026-06-05 08:24:25.76	\N	2026-05-29 08:24:25.761	0	8182c06b-7b3a-4f3b-90c1-931996b11308	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$mnk9i0jxxE0xGIHYXN/P2.nj/OYlCUzsX90UgKhCh7FzvZkqQNdVi	\N	\N	2026-06-05 09:17:46.219	\N	2026-05-29 09:17:46.221	0	a3f6d15f-5a8d-4d14-887e-4114d0b20b87	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$PKkcSeNEfhI2m5C/qGEyxunbMi7v/uKjyM4FETfr7Do3LzFAaoIXi	\N	\N	2026-06-05 12:03:20.452	\N	2026-05-29 12:03:20.453	0	8adacf38-f900-4ff8-b3cc-cf206b33f0a2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$uPTFIiD4Ah7lhnJ./bFgGOMGW2GHvMNyT/bqoScbDvmuEUvXdU6sm	\N	\N	2026-06-05 16:22:31.384	\N	2026-05-29 16:22:31.386	0	efee587a-a2d4-4393-a784-6c75aefc54d4	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$qudz/54kM1JfDPSE1.e6iulZLa18nE0WrePOQFsCcOZEc64M4aquC	\N	\N	2026-06-05 16:40:39.882	\N	2026-05-29 16:40:39.884	0	c453db87-6187-4e8f-a74d-eb2ca5d73de2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$.D2rP8usMnEGtWxwlzQia.bYoZh3A1cIPCc5t0dWf1c71kmtKuT4S	\N	\N	2026-06-05 16:53:34.683	\N	2026-05-29 16:53:34.685	0	56d9dfa3-01cd-4419-b054-ce8c56270ad7	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$2PyhmXsBaUxIMClfQIanUunq8Xjq3fB.PhOblzg9HPKFvNRyBQ7sC	\N	\N	2026-06-05 17:13:11.442	\N	2026-05-29 17:13:11.443	0	923c210a-b802-45a6-a5bb-c8af02a95ac9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Xs8fe6FXReK89GsLEVinzutpHkiqvKFN8ukp0xzQmfsXbByUPZjrC	\N	\N	2026-06-05 17:28:50.214	\N	2026-05-29 17:28:50.217	0	68663aa4-8caf-45a9-bb46-a9f9800160cf	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$RaKzzFJbRqXPuM5Ed149D.hiO1X8vwN2g4lyA7bOj51DupdTrryva	\N	\N	2026-06-05 17:36:04.049	\N	2026-05-29 17:36:04.051	0	ac00d9c3-1c74-47c4-a49b-d0d24daf64fe	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$q3fsyRGl8LPmbOy3pKo5xuRjwLPTf2eJTRvE3OsDbiZzoKPrgnNse	\N	\N	2026-06-06 04:38:36.023	\N	2026-05-30 04:38:36.025	0	cd6c478e-7969-402b-bbdd-de3eca73e505	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$HelzKrGQb5D/Thx2ig0D3OegDZrKCSnrkl9lKNiyfwLwfiSKXHTHS	\N	\N	2026-06-06 05:01:41.399	\N	2026-05-30 05:01:41.401	0	467dd86b-9a9a-436d-8c2e-d3b503088ca7	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$duDUyaQEJMSox2BPUWt7HOFtVXEdu2YIaWPBINNcjdy53MSwMoIha	\N	\N	2026-06-06 05:38:02.081	\N	2026-05-30 05:38:02.082	0	71ba31af-e848-4f04-ad6c-d7d1b660b29c	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$C6m.vNOCdeG9mZVNC.hNv.YYgGelXsKv.O3TZP8gv0Z7lB.rs1dqa	\N	\N	2026-06-06 09:04:35.363	\N	2026-05-30 09:04:35.364	0	f818bcab-fdfc-40f6-9b93-5c44ff2e67c7	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$r45DNanDFJEtj4sHzchGRengjvaFz0zPgawvCAAcO8JvgNZMo6JTq	\N	\N	2026-06-06 11:39:12.037	\N	2026-05-30 11:39:12.039	0	092b58db-401d-4416-805c-4670fd82a8ab	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$lNREzHC3F2pc1dUPaHP70OjZimhJU0T5rZD3RnN97T23TjtJ0aVJO	\N	\N	2026-06-06 13:47:19.091	\N	2026-05-30 13:47:19.093	0	2f0c1017-8361-4fd4-aa9c-869c234806c5	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$zBPfDuouSgfJhCfOfDPoxuS8P.QPaN1C4lq5/DZC46CMhq1RavmBO	\N	\N	2026-06-07 01:40:32.448	\N	2026-05-31 01:40:32.449	0	2c6d48ce-83e9-4cdc-ab25-92a8a15a1e8f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$YSirK1Kqz2msnUD4wENAwOm9aFWy1AX/lDkjiY5y9YXeyjwasba0a	\N	\N	2026-06-07 02:56:54.708	\N	2026-05-31 02:56:54.71	0	08b5d541-c441-401e-aea4-3c8f0db08a29	9f08f905-999a-4c6f-87bc-66e29dc6301e
\.


--
-- TOC entry 6136 (class 0 OID 151973)
-- Dependencies: 266
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (role_id, permission_id) FROM stdin;
\.


--
-- TOC entry 6137 (class 0 OID 151978)
-- Dependencies: 267
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (name, display_name, description, is_system, created_at, updated_at, created_by, updated_by, id) FROM stdin;
super_admin	super admin	\N	t	2026-04-08 01:52:11.823	2026-04-08 01:52:11.823	\N	\N	2bc0c1c5-fd1d-4b5d-aa30-b648a6604642
org_admin	org admin	\N	t	2026-04-08 01:52:11.848	2026-04-08 01:52:11.848	\N	\N	e9d7875e-a245-4d46-aa3d-a366bfdc75cf
billing_admin	billing admin	\N	t	2026-04-08 01:52:11.856	2026-04-08 01:52:11.856	\N	\N	6d11d58b-6d2b-4462-9ec0-550609b92586
faculty	faculty	\N	t	2026-04-08 01:52:11.863	2026-04-08 01:52:11.863	\N	\N	2775c6de-8e14-40a9-904f-6622d3950a08
lab_instructor	lab instructor	\N	t	2026-04-08 01:52:11.872	2026-04-08 01:52:11.872	\N	\N	460a57ea-17fc-4fdd-926b-b17348700f9f
mentor	mentor	\N	t	2026-04-08 01:52:11.88	2026-04-08 01:52:11.88	\N	\N	5704746a-6623-4b8b-a9fb-9fcef85fd237
student	student	\N	t	2026-04-08 01:52:11.888	2026-04-08 01:52:11.888	\N	\N	f231dfb8-cb4c-4942-bb56-852cf0884569
external_student	external student	\N	t	2026-04-08 01:52:11.896	2026-04-08 01:52:11.896	\N	\N	f870be4a-548d-4014-ab9b-19c286971ee4
public_user	public user	\N	t	2026-04-08 01:52:11.905	2026-04-08 01:52:11.905	\N	\N	42abadfe-edfa-4b0e-985d-adaa65091959
business_lead	business lead	\N	t	2026-05-15 07:32:20.34	2026-05-15 07:32:20.34	\N	\N	c99954e1-3820-442c-a1cb-33f9cde68672
it_admin	it admin	\N	t	2026-05-15 07:32:20.36	2026-05-15 07:32:20.36	\N	\N	ee7518c5-3ed0-4025-8aa5-d5c0eca54787
\.


--
-- TOC entry 6138 (class 0 OID 151990)
-- Dependencies: 268
-- Data for Name: session_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.session_events (id, session_id, event_type, payload, client_ip, created_at) FROM stdin;
\.


--
-- TOC entry 6139 (class 0 OID 152000)
-- Dependencies: 269
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, user_id, organization_id, compute_config_id, booking_id, node_id, session_type, container_id, container_name, nginx_port, selkies_port, display_number, session_token_hash, session_url, status, started_at, ended_at, scheduled_end_at, last_activity_at, nfs_mount_path, base_image_id, actual_gpu_vram_mb, actual_hami_sm_percent, reconnect_count, last_reconnect_at, auto_preserve_files, avg_rtt_ms, avg_packet_loss_ratio, resource_snapshot, created_at, updated_at, created_by, updated_by, allocated_gpu_vram_mb, allocated_hami_sm_percent, allocated_memory_mb, allocated_vcpu, allocation_snapshot_at, cost_last_updated_at, cumulative_cost_cents, duration_seconds, instance_name, storage_mode, terminated_at, terminated_by, termination_details, termination_reason, storage_node_id, storage_transport, ephemeral_storage_path, ephemeral_storage_size_mb) FROM stdin;
\.


--
-- TOC entry 6140 (class 0 OID 152021)
-- Dependencies: 270
-- Data for Name: storage_extensions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.storage_extensions (id, user_id, storage_volume_id, extension_type, previous_quota_bytes, new_quota_bytes, extension_bytes, amount_cents, currency, payment_transaction_id, wallet_transaction_id, notes, created_at, created_by) FROM stdin;
\.


--
-- TOC entry 6141 (class 0 OID 152039)
-- Dependencies: 271
-- Data for Name: subscription_plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscription_plans (id, slug, name, description, price_cents, currency, billing_period, gpu_hours_included, mentor_sessions_included, features, is_active, sort_order, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6142 (class 0 OID 152059)
-- Dependencies: 272
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscriptions (id, user_id, plan_id, organization_id, status, starts_at, ends_at, gpu_hours_remaining, mentor_sessions_remaining, auto_renew, cancellation_requested_at, cancel_at_period_end, grace_period_until, payment_transaction_id, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6164 (class 0 OID 163196)
-- Dependencies: 294
-- Data for Name: support_ticket_attachments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.support_ticket_attachments (id, "ticketId", "fileName", "mimeType", size, data, "createdAt") FROM stdin;
\.


--
-- TOC entry 6143 (class 0 OID 152074)
-- Dependencies: 273
-- Data for Name: support_tickets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.support_tickets (id, user_id, organization_id, subject, description, category, priority, status, assigned_to, related_session_id, related_billing_id, resolved_at, resolution_notes, satisfaction_rating, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6144 (class 0 OID 152090)
-- Dependencies: 274
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_settings (id, key, value, value_type, description, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6145 (class 0 OID 152101)
-- Dependencies: 275
-- Data for Name: ticket_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ticket_messages (id, ticket_id, sender_id, body, is_internal, attachments, created_at) FROM stdin;
\.


--
-- TOC entry 6146 (class 0 OID 152114)
-- Dependencies: 276
-- Data for Name: universities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.universities (id, name, short_name, slug, domain_suffixes, logo_url, website_url, contact_email, contact_phone, city, state, country, timezone, is_active, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
f213bc95-2fe5-4401-94c1-39efeaa39a5a	K.S. Rangasamy College of Engineering	KSRCE	ksrce	{@ksrce.ac.in}	\N	\N	\N	\N	\N	\N	IN	Asia/Kolkata	t	2026-04-08 01:52:11.94	2026-05-15 07:32:20.399	\N	\N	\N
\.


--
-- TOC entry 6147 (class 0 OID 152129)
-- Dependencies: 277
-- Data for Name: university_idp_configs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.university_idp_configs (id, university_id, idp_type, idp_entity_id, idp_metadata_url, idp_config, keycloak_idp_alias, display_name, is_primary, is_active, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6148 (class 0 OID 152144)
-- Dependencies: 278
-- Data for Name: user_achievements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_achievements (id, user_id, achievement_id, earned_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6149 (class 0 OID 152154)
-- Dependencies: 279
-- Data for Name: user_deletion_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_deletion_requests (id, user_id, requested_at, requested_by, reason, grace_period_days, scheduled_deletion_at, status, cancelled_at, completed_at, completion_details, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6150 (class 0 OID 152169)
-- Dependencies: 280
-- Data for Name: user_departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_departments (id, user_id, department_id, is_primary, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6151 (class 0 OID 152180)
-- Dependencies: 281
-- Data for Name: user_feedback; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_feedback (id, user_id, session_id, feedback_type, rating, subject, body, status, admin_response, responded_by, responded_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6152 (class 0 OID 152193)
-- Dependencies: 282
-- Data for Name: user_files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_files (id, user_id, file_name, file_path, file_size_bytes, mime_type, file_type, session_id, is_pinned, storage_backend, retention_days, scheduled_deletion_at, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6153 (class 0 OID 152207)
-- Dependencies: 283
-- Data for Name: user_group_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_group_members (id, user_id, user_group_id, added_by, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6154 (class 0 OID 152216)
-- Dependencies: 284
-- Data for Name: user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_groups (id, organization_id, department_id, parent_id, group_type, name, slug, description, keycloak_group_id, max_members, is_active, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6155 (class 0 OID 152229)
-- Dependencies: 285
-- Data for Name: user_org_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_org_roles (expires_at, created_at, updated_at, created_by, updated_by, id, user_id, organization_id, role_id, granted_by) FROM stdin;
\N	2026-05-15 07:33:03.993	2026-05-15 07:33:03.993	\N	\N	61ff92ba-a2c2-49ec-8aed-009e74d51569	9f08f905-999a-4c6f-87bc-66e29dc6301e	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	c99954e1-3820-442c-a1cb-33f9cde68672	\N
\N	2026-05-15 07:33:04.025	2026-05-15 07:33:04.025	\N	\N	a8b4dec5-8557-420f-ba33-3363c93a0993	bd8f8f80-a9ab-43e9-999f-b653f359e4c9	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	ee7518c5-3ed0-4025-8aa5-d5c0eca54787	\N
\N	2026-05-27 10:52:39.487	2026-05-27 10:52:39.487	\N	\N	14d2e664-6b2c-49e4-b68e-8f12b8660049	d6e2fea7-4b97-45d4-90b1-2f525eb52371	07b07401-b326-4045-af3a-44a7c45e56d8	5704746a-6623-4b8b-a9fb-9fcef85fd237	\N
\.


--
-- TOC entry 6156 (class 0 OID 152239)
-- Dependencies: 286
-- Data for Name: user_policy_consents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_policy_consents (policy_slug, policy_version, agreed_at, ip_address, created_at, created_by, id, user_id) FROM stdin;
\.


--
-- TOC entry 6157 (class 0 OID 152250)
-- Dependencies: 287
-- Data for Name: user_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profiles (id, user_id, bio, enrollment_number, id_proof_url, id_proof_verified_at, id_proof_verified_by, college_name, graduation_year, github_url, linkedin_url, website_url, skills, theme_preference, notification_preferences, created_at, updated_at, created_by, updated_by, country, expertise_level, onboarding_complete, operational_domains, profession, use_case_other, use_case_purposes, years_of_experience, academic_year, course_name, department_id, substack_url, x_url) FROM stdin;
378c196c-efcd-4ada-bb85-7f55829aafce	d6e2fea7-4b97-45d4-90b1-2f525eb52371	\N	\N	\N	\N	\N	\N	\N	https://github.com/punith1006/	\N	https://ksrceailab.com	{"Deep Learning",PyTorch,TensorFlow,"Computer Vision",NLP,MLOps}	dark	{}	2026-05-27 11:35:20.289	2026-05-30 03:51:02.129	\N	\N	\N	expert	t	\N	Mentor	\N	\N	\N	\N	\N	\N	https://substack.com/@punithvs	https://x.com/vs_punith/
96edc69d-088e-484e-a30c-2e8c19c43068	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	dark	{}	2026-05-18 06:24:46.859	2026-05-18 06:24:46.859	\N	\N	IN	beginner	t	{video_editing}	researcher	\N	{ai_ml_training,FFmpeg}	1	\N	\N	\N	\N	\N
\.


--
-- TOC entry 6158 (class 0 OID 152266)
-- Dependencies: 288
-- Data for Name: user_storage_volumes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_storage_volumes (id, user_id, storage_uid, zfs_dataset_path, nfs_export_path, container_mount_path, os_choice, quota_bytes, used_bytes, used_bytes_updated_at, status, provisioned_at, wiped_at, wipe_reason, quota_warning_sent_at, created_at, updated_at, created_by, updated_by, allocation_type, name, price_per_gb_cents_month, node_id, storage_backend) FROM stdin;
\.


--
-- TOC entry 6159 (class 0 OID 152288)
-- Dependencies: 289
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (email, email_verified_at, password_hash, first_name, last_name, display_name, avatar_url, phone, timezone, keycloak_sub, auth_type, oauth_provider, storage_uid, token_version, two_factor_enabled, last_login_at, last_login_ip, onboarding_completed_at, is_active, created_at, updated_at, deleted_at, storage_provisioned_at, storage_provisioning_error, storage_provisioning_status, created_by, keycloak_last_sync_at, lock_expires_at, lock_reason, locked_at, os_choice, pending_email, updated_by, id, default_org_id, referred_by_code) FROM stdin;
it_admin@ksrce.in	\N	$2b$10$JTOY2w1Bt8D2YbJYeRBaPueFREpcgRtBDgb3WRvTP0mLd.FcPMlh2	IT	Administrator	\N	\N	\N	Asia/Kolkata	\N	public_local	\N	\N	0	f	2026-05-15 07:58:44.492	127.0.0.1	\N	t	2026-05-15 07:33:04.015	2026-05-15 07:58:44.494	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	bd8f8f80-a9ab-43e9-999f-b653f359e4c9	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	\N
mentor@laas.io	\N	$2b$10$SuKcaxKL0b2knof93DimtOCPDYmQYVAce82No29ExV.RdfZ58bh4u	Arjun	Mehta	Zenith	\N	7406455036	Asia/Kolkata	\N	public_local	\N	\N	0	f	2026-05-31 11:22:36.739	127.0.0.1	\N	t	2026-05-27 10:52:39.467	2026-05-31 11:22:36.74	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	d6e2fea7-4b97-45d4-90b1-2f525eb52371	07b07401-b326-4045-af3a-44a7c45e56d8	\N
business_lead@ksrce.in	\N	$2b$10$JTOY2w1Bt8D2YbJYeRBaPueFREpcgRtBDgb3WRvTP0mLd.FcPMlh2	Business-Lead	Lead	\N	\N	\N	Asia/Kolkata	\N	public_local	\N	\N	0	f	2026-05-31 11:10:54.176	127.0.0.1	\N	t	2026-05-15 07:33:03.975	2026-05-31 11:10:54.178	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	9f08f905-999a-4c6f-87bc-66e29dc6301e	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	\N
\.


--
-- TOC entry 6160 (class 0 OID 152308)
-- Dependencies: 290
-- Data for Name: waitlist_entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.waitlist_entries (id, "userId", email, "firstName", "lastName", "currentStatus", "organizationName", "jobTitle", "computeNeeds", "expectedDuration", urgency, expectations, "primaryWorkload", "workloadDescription", "agreedToPolicy", "policyAgreedAt", "agreedToComms", status, "createdAt", "updatedAt") FROM stdin;
\.


--
-- TOC entry 6161 (class 0 OID 152324)
-- Dependencies: 291
-- Data for Name: wallet_holds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wallet_holds (id, wallet_id, user_id, amount_cents, hold_reason, booking_id, session_id, status, expires_at, released_at, release_reason, captured_amount, created_at) FROM stdin;
\.


--
-- TOC entry 6162 (class 0 OID 152336)
-- Dependencies: 292
-- Data for Name: wallet_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wallet_transactions (id, wallet_id, user_id, txn_type, amount_cents, balance_after_cents, reference_type, reference_id, description, created_at, created_by) FROM stdin;
\.


--
-- TOC entry 6163 (class 0 OID 152349)
-- Dependencies: 293
-- Data for Name: wallets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wallets (id, user_id, balance_cents, currency, lifetime_credits_cents, lifetime_spent_cents, low_balance_threshold_cents, is_frozen, created_at, updated_at, created_by, updated_by, spend_limit_cents, spend_limit_enabled, spend_limit_period, spend_limit_consented_at, spend_limit_end_date, spend_limit_start_date, spend_limit_warning_85_sent, runway_warning_1hour_sent) FROM stdin;
\.


--
-- TOC entry 6169 (class 0 OID 196807)
-- Dependencies: 299
-- Data for Name: withdrawal_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.withdrawal_requests (id, user_id, wallet_id, amount_cents, platform_fee_cents, net_payout_cents, status, razorpay_payout_id, razorpay_contact_id, utr, failure_reason, idempotency_key, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5457 (class 2606 OID 152378)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 5459 (class 2606 OID 152380)
-- Name: achievements achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- TOC entry 5463 (class 2606 OID 152382)
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- TOC entry 5470 (class 2606 OID 152384)
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- TOC entry 5474 (class 2606 OID 152386)
-- Name: base_images base_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_images
    ADD CONSTRAINT base_images_pkey PRIMARY KEY (id);


--
-- TOC entry 5477 (class 2606 OID 152388)
-- Name: billing_charges billing_charges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_pkey PRIMARY KEY (id);


--
-- TOC entry 5483 (class 2606 OID 152390)
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- TOC entry 5488 (class 2606 OID 152392)
-- Name: compute_config_access compute_config_access_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_config_access
    ADD CONSTRAINT compute_config_access_pkey PRIMARY KEY (id);


--
-- TOC entry 5492 (class 2606 OID 152394)
-- Name: compute_configs compute_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_configs
    ADD CONSTRAINT compute_configs_pkey PRIMARY KEY (id);


--
-- TOC entry 5499 (class 2606 OID 152396)
-- Name: course_enrollments course_enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_pkey PRIMARY KEY (id);


--
-- TOC entry 5504 (class 2606 OID 152398)
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- TOC entry 5509 (class 2606 OID 152400)
-- Name: coursework_content coursework_content_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coursework_content
    ADD CONSTRAINT coursework_content_pkey PRIMARY KEY (id);


--
-- TOC entry 5512 (class 2606 OID 152402)
-- Name: credit_packages credit_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_packages
    ADD CONSTRAINT credit_packages_pkey PRIMARY KEY (id);


--
-- TOC entry 5516 (class 2606 OID 152404)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- TOC entry 5522 (class 2606 OID 152406)
-- Name: discussion_replies discussion_replies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_pkey PRIMARY KEY (id);


--
-- TOC entry 5527 (class 2606 OID 152408)
-- Name: discussions discussions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_pkey PRIMARY KEY (id);


--
-- TOC entry 5530 (class 2606 OID 152410)
-- Name: feature_flags feature_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_flags
    ADD CONSTRAINT feature_flags_pkey PRIMARY KEY (id);


--
-- TOC entry 5532 (class 2606 OID 152412)
-- Name: invoice_line_items invoice_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_line_items
    ADD CONSTRAINT invoice_line_items_pkey PRIMARY KEY (id);


--
-- TOC entry 5535 (class 2606 OID 152414)
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- TOC entry 5540 (class 2606 OID 152416)
-- Name: lab_assignments lab_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_assignments
    ADD CONSTRAINT lab_assignments_pkey PRIMARY KEY (id);


--
-- TOC entry 5542 (class 2606 OID 152418)
-- Name: lab_grades lab_grades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_grades
    ADD CONSTRAINT lab_grades_pkey PRIMARY KEY (id);


--
-- TOC entry 5546 (class 2606 OID 152420)
-- Name: lab_group_assignments lab_group_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_group_assignments
    ADD CONSTRAINT lab_group_assignments_pkey PRIMARY KEY (id);


--
-- TOC entry 5549 (class 2606 OID 152422)
-- Name: lab_submissions lab_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_submissions
    ADD CONSTRAINT lab_submissions_pkey PRIMARY KEY (id);


--
-- TOC entry 5555 (class 2606 OID 152424)
-- Name: labs labs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_pkey PRIMARY KEY (id);


--
-- TOC entry 5557 (class 2606 OID 152426)
-- Name: login_history login_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_pkey PRIMARY KEY (id);


--
-- TOC entry 5559 (class 2606 OID 152428)
-- Name: mentor_availability_slots mentor_availability_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_availability_slots
    ADD CONSTRAINT mentor_availability_slots_pkey PRIMARY KEY (id);


--
-- TOC entry 5782 (class 2606 OID 196800)
-- Name: mentor_blocked_dates mentor_blocked_dates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_blocked_dates
    ADD CONSTRAINT mentor_blocked_dates_pkey PRIMARY KEY (id);


--
-- TOC entry 5562 (class 2606 OID 152430)
-- Name: mentor_bookings mentor_bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_bookings
    ADD CONSTRAINT mentor_bookings_pkey PRIMARY KEY (id);


--
-- TOC entry 5565 (class 2606 OID 152432)
-- Name: mentor_profiles mentor_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_profiles
    ADD CONSTRAINT mentor_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 5569 (class 2606 OID 152434)
-- Name: mentor_reviews mentor_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_reviews
    ADD CONSTRAINT mentor_reviews_pkey PRIMARY KEY (id);


--
-- TOC entry 5778 (class 2606 OID 187165)
-- Name: mentor_session_payments mentor_session_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_session_payments
    ADD CONSTRAINT mentor_session_payments_pkey PRIMARY KEY (id);


--
-- TOC entry 5772 (class 2606 OID 187151)
-- Name: mentor_session_status_history mentor_session_status_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_session_status_history
    ADD CONSTRAINT mentor_session_status_history_pkey PRIMARY KEY (id);


--
-- TOC entry 5763 (class 2606 OID 187137)
-- Name: mentor_sessions mentor_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_sessions
    ADD CONSTRAINT mentor_sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 5571 (class 2606 OID 152436)
-- Name: node_base_images node_base_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_base_images
    ADD CONSTRAINT node_base_images_pkey PRIMARY KEY (node_id, base_image_id);


--
-- TOC entry 5576 (class 2606 OID 152438)
-- Name: node_resource_reservations node_resource_reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_resource_reservations
    ADD CONSTRAINT node_resource_reservations_pkey PRIMARY KEY (id);


--
-- TOC entry 5584 (class 2606 OID 152440)
-- Name: nodes nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nodes
    ADD CONSTRAINT nodes_pkey PRIMARY KEY (id);


--
-- TOC entry 5587 (class 2606 OID 152442)
-- Name: notification_templates notification_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_templates
    ADD CONSTRAINT notification_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 5590 (class 2606 OID 152444)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 5594 (class 2606 OID 152446)
-- Name: org_contracts org_contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_contracts
    ADD CONSTRAINT org_contracts_pkey PRIMARY KEY (id);


--
-- TOC entry 5598 (class 2606 OID 152448)
-- Name: org_resource_quotas org_resource_quotas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_resource_quotas
    ADD CONSTRAINT org_resource_quotas_pkey PRIMARY KEY (id);


--
-- TOC entry 5600 (class 2606 OID 152450)
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- TOC entry 5604 (class 2606 OID 152452)
-- Name: os_switch_history os_switch_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_switch_history
    ADD CONSTRAINT os_switch_history_pkey PRIMARY KEY (id);


--
-- TOC entry 5607 (class 2606 OID 152454)
-- Name: otp_verifications otp_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_verifications
    ADD CONSTRAINT otp_verifications_pkey PRIMARY KEY (id);


--
-- TOC entry 5610 (class 2606 OID 152456)
-- Name: payment_transactions payment_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 5615 (class 2606 OID 152458)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 5618 (class 2606 OID 152460)
-- Name: project_showcases project_showcases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_showcases
    ADD CONSTRAINT project_showcases_pkey PRIMARY KEY (id);


--
-- TOC entry 5622 (class 2606 OID 152462)
-- Name: recommendation_sessions recommendation_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recommendation_sessions
    ADD CONSTRAINT recommendation_sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 5625 (class 2606 OID 152464)
-- Name: referral_conversions referral_conversions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_conversions
    ADD CONSTRAINT referral_conversions_pkey PRIMARY KEY (id);


--
-- TOC entry 5632 (class 2606 OID 152466)
-- Name: referral_events referral_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_events
    ADD CONSTRAINT referral_events_pkey PRIMARY KEY (id);


--
-- TOC entry 5635 (class 2606 OID 152468)
-- Name: referrals referrals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_pkey PRIMARY KEY (id);


--
-- TOC entry 5641 (class 2606 OID 152470)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 5643 (class 2606 OID 152472)
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- TOC entry 5646 (class 2606 OID 152474)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 5649 (class 2606 OID 152476)
-- Name: session_events session_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_events
    ADD CONSTRAINT session_events_pkey PRIMARY KEY (id);


--
-- TOC entry 5656 (class 2606 OID 152478)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 5663 (class 2606 OID 152480)
-- Name: storage_extensions storage_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_pkey PRIMARY KEY (id);


--
-- TOC entry 5667 (class 2606 OID 152482)
-- Name: subscription_plans subscription_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_plans
    ADD CONSTRAINT subscription_plans_pkey PRIMARY KEY (id);


--
-- TOC entry 5672 (class 2606 OID 152484)
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- TOC entry 5759 (class 2606 OID 163211)
-- Name: support_ticket_attachments support_ticket_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_ticket_attachments
    ADD CONSTRAINT support_ticket_attachments_pkey PRIMARY KEY (id);


--
-- TOC entry 5677 (class 2606 OID 152486)
-- Name: support_tickets support_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_pkey PRIMARY KEY (id);


--
-- TOC entry 5681 (class 2606 OID 152488)
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 5683 (class 2606 OID 152490)
-- Name: ticket_messages ticket_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_messages
    ADD CONSTRAINT ticket_messages_pkey PRIMARY KEY (id);


--
-- TOC entry 5686 (class 2606 OID 152492)
-- Name: universities universities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.universities
    ADD CONSTRAINT universities_pkey PRIMARY KEY (id);


--
-- TOC entry 5689 (class 2606 OID 152494)
-- Name: university_idp_configs university_idp_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.university_idp_configs
    ADD CONSTRAINT university_idp_configs_pkey PRIMARY KEY (id);


--
-- TOC entry 5692 (class 2606 OID 152496)
-- Name: user_achievements user_achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_pkey PRIMARY KEY (id);


--
-- TOC entry 5695 (class 2606 OID 152498)
-- Name: user_deletion_requests user_deletion_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_deletion_requests
    ADD CONSTRAINT user_deletion_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 5701 (class 2606 OID 152500)
-- Name: user_departments user_departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_departments
    ADD CONSTRAINT user_departments_pkey PRIMARY KEY (id);


--
-- TOC entry 5705 (class 2606 OID 152502)
-- Name: user_feedback user_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_pkey PRIMARY KEY (id);


--
-- TOC entry 5709 (class 2606 OID 152504)
-- Name: user_files user_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_files
    ADD CONSTRAINT user_files_pkey PRIMARY KEY (id);


--
-- TOC entry 5713 (class 2606 OID 152506)
-- Name: user_group_members user_group_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_members
    ADD CONSTRAINT user_group_members_pkey PRIMARY KEY (id);


--
-- TOC entry 5721 (class 2606 OID 152508)
-- Name: user_groups user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 5723 (class 2606 OID 152510)
-- Name: user_org_roles user_org_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_org_roles
    ADD CONSTRAINT user_org_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 5726 (class 2606 OID 152512)
-- Name: user_policy_consents user_policy_consents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_policy_consents
    ADD CONSTRAINT user_policy_consents_pkey PRIMARY KEY (id);


--
-- TOC entry 5728 (class 2606 OID 152514)
-- Name: user_profiles user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 5733 (class 2606 OID 152516)
-- Name: user_storage_volumes user_storage_volumes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_storage_volumes
    ADD CONSTRAINT user_storage_volumes_pkey PRIMARY KEY (id);


--
-- TOC entry 5739 (class 2606 OID 152518)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 5744 (class 2606 OID 152520)
-- Name: waitlist_entries waitlist_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waitlist_entries
    ADD CONSTRAINT waitlist_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 5748 (class 2606 OID 152522)
-- Name: wallet_holds wallet_holds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_pkey PRIMARY KEY (id);


--
-- TOC entry 5751 (class 2606 OID 152524)
-- Name: wallet_transactions wallet_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_transactions
    ADD CONSTRAINT wallet_transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 5756 (class 2606 OID 152526)
-- Name: wallets wallets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT wallets_pkey PRIMARY KEY (id);


--
-- TOC entry 5785 (class 2606 OID 196825)
-- Name: withdrawal_requests withdrawal_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.withdrawal_requests
    ADD CONSTRAINT withdrawal_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 5460 (class 1259 OID 152527)
-- Name: achievements_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX achievements_slug_key ON public.achievements USING btree (slug);


--
-- TOC entry 5461 (class 1259 OID 152528)
-- Name: announcements_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX announcements_organization_id_idx ON public.announcements USING btree (organization_id);


--
-- TOC entry 5464 (class 1259 OID 152529)
-- Name: announcements_published_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX announcements_published_at_idx ON public.announcements USING btree (published_at);


--
-- TOC entry 5465 (class 1259 OID 152530)
-- Name: audit_log_action_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_action_idx ON public.audit_log USING btree (action);


--
-- TOC entry 5466 (class 1259 OID 152531)
-- Name: audit_log_actor_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_actor_id_idx ON public.audit_log USING btree (actor_id);


--
-- TOC entry 5467 (class 1259 OID 152532)
-- Name: audit_log_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_created_at_idx ON public.audit_log USING btree (created_at);


--
-- TOC entry 5468 (class 1259 OID 152533)
-- Name: audit_log_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_org_id_idx ON public.audit_log USING btree (org_id);


--
-- TOC entry 5471 (class 1259 OID 152534)
-- Name: audit_log_resource_type_resource_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_resource_type_resource_id_idx ON public.audit_log USING btree (resource_type, resource_id);


--
-- TOC entry 5472 (class 1259 OID 152535)
-- Name: base_images_is_default_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX base_images_is_default_idx ON public.base_images USING btree (is_default);


--
-- TOC entry 5475 (class 1259 OID 152536)
-- Name: base_images_tag_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX base_images_tag_key ON public.base_images USING btree (tag);


--
-- TOC entry 5478 (class 1259 OID 152537)
-- Name: billing_charges_session_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX billing_charges_session_id_idx ON public.billing_charges USING btree (session_id);


--
-- TOC entry 5479 (class 1259 OID 152538)
-- Name: billing_charges_storage_volume_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX billing_charges_storage_volume_id_idx ON public.billing_charges USING btree (storage_volume_id);


--
-- TOC entry 5480 (class 1259 OID 152539)
-- Name: billing_charges_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX billing_charges_user_id_created_at_idx ON public.billing_charges USING btree (user_id, created_at);


--
-- TOC entry 5481 (class 1259 OID 152540)
-- Name: bookings_node_id_scheduled_start_at_scheduled_end_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bookings_node_id_scheduled_start_at_scheduled_end_at_idx ON public.bookings USING btree (node_id, scheduled_start_at, scheduled_end_at);


--
-- TOC entry 5484 (class 1259 OID 152541)
-- Name: bookings_user_id_status_scheduled_start_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bookings_user_id_status_scheduled_start_at_idx ON public.bookings USING btree (user_id, status, scheduled_start_at);


--
-- TOC entry 5485 (class 1259 OID 152542)
-- Name: compute_config_access_compute_config_id_organization_id_rol_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX compute_config_access_compute_config_id_organization_id_rol_key ON public.compute_config_access USING btree (compute_config_id, organization_id, role_id);


--
-- TOC entry 5486 (class 1259 OID 152543)
-- Name: compute_config_access_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_config_access_organization_id_idx ON public.compute_config_access USING btree (organization_id);


--
-- TOC entry 5489 (class 1259 OID 152544)
-- Name: compute_config_access_role_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_config_access_role_id_idx ON public.compute_config_access USING btree (role_id);


--
-- TOC entry 5490 (class 1259 OID 152545)
-- Name: compute_configs_is_active_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_configs_is_active_idx ON public.compute_configs USING btree (is_active);


--
-- TOC entry 5493 (class 1259 OID 152546)
-- Name: compute_configs_session_type_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_configs_session_type_idx ON public.compute_configs USING btree (session_type);


--
-- TOC entry 5494 (class 1259 OID 152547)
-- Name: compute_configs_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX compute_configs_slug_key ON public.compute_configs USING btree (slug);


--
-- TOC entry 5495 (class 1259 OID 152548)
-- Name: compute_configs_sort_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_configs_sort_order_idx ON public.compute_configs USING btree (sort_order);


--
-- TOC entry 5496 (class 1259 OID 152549)
-- Name: course_enrollments_course_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX course_enrollments_course_id_idx ON public.course_enrollments USING btree (course_id);


--
-- TOC entry 5497 (class 1259 OID 152550)
-- Name: course_enrollments_course_id_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX course_enrollments_course_id_user_id_key ON public.course_enrollments USING btree (course_id, user_id);


--
-- TOC entry 5500 (class 1259 OID 152551)
-- Name: course_enrollments_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX course_enrollments_user_id_idx ON public.course_enrollments USING btree (user_id);


--
-- TOC entry 5501 (class 1259 OID 152552)
-- Name: courses_instructor_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX courses_instructor_id_idx ON public.courses USING btree (instructor_id);


--
-- TOC entry 5502 (class 1259 OID 152553)
-- Name: courses_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX courses_organization_id_idx ON public.courses USING btree (organization_id);


--
-- TOC entry 5505 (class 1259 OID 152554)
-- Name: courses_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX courses_status_idx ON public.courses USING btree (status);


--
-- TOC entry 5506 (class 1259 OID 152555)
-- Name: coursework_content_category_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX coursework_content_category_idx ON public.coursework_content USING btree (category);


--
-- TOC entry 5507 (class 1259 OID 152556)
-- Name: coursework_content_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX coursework_content_organization_id_idx ON public.coursework_content USING btree (organization_id);


--
-- TOC entry 5510 (class 1259 OID 152557)
-- Name: credit_packages_is_active_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX credit_packages_is_active_idx ON public.credit_packages USING btree (is_active);


--
-- TOC entry 5513 (class 1259 OID 152558)
-- Name: credit_packages_sort_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX credit_packages_sort_order_idx ON public.credit_packages USING btree (sort_order);


--
-- TOC entry 5514 (class 1259 OID 152559)
-- Name: departments_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX departments_parent_id_idx ON public.departments USING btree (parent_id);


--
-- TOC entry 5517 (class 1259 OID 152560)
-- Name: departments_university_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX departments_university_id_idx ON public.departments USING btree (university_id);


--
-- TOC entry 5518 (class 1259 OID 152561)
-- Name: departments_university_id_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX departments_university_id_slug_key ON public.departments USING btree (university_id, slug);


--
-- TOC entry 5519 (class 1259 OID 152562)
-- Name: discussion_replies_author_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussion_replies_author_id_idx ON public.discussion_replies USING btree (author_id);


--
-- TOC entry 5520 (class 1259 OID 152563)
-- Name: discussion_replies_discussion_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussion_replies_discussion_id_idx ON public.discussion_replies USING btree (discussion_id);


--
-- TOC entry 5523 (class 1259 OID 152564)
-- Name: discussions_author_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussions_author_id_idx ON public.discussions USING btree (author_id);


--
-- TOC entry 5524 (class 1259 OID 152565)
-- Name: discussions_course_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussions_course_id_idx ON public.discussions USING btree (course_id);


--
-- TOC entry 5525 (class 1259 OID 152566)
-- Name: discussions_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussions_organization_id_idx ON public.discussions USING btree (organization_id);


--
-- TOC entry 5528 (class 1259 OID 152567)
-- Name: feature_flags_key_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX feature_flags_key_key ON public.feature_flags USING btree (key);


--
-- TOC entry 5533 (class 1259 OID 152568)
-- Name: invoices_invoice_number_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX invoices_invoice_number_key ON public.invoices USING btree (invoice_number);


--
-- TOC entry 5536 (class 1259 OID 152569)
-- Name: invoices_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX invoices_status_idx ON public.invoices USING btree (status);


--
-- TOC entry 5537 (class 1259 OID 152570)
-- Name: invoices_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX invoices_user_id_created_at_idx ON public.invoices USING btree (user_id, created_at);


--
-- TOC entry 5538 (class 1259 OID 152571)
-- Name: lab_assignments_lab_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lab_assignments_lab_id_idx ON public.lab_assignments USING btree (lab_id);


--
-- TOC entry 5543 (class 1259 OID 152572)
-- Name: lab_grades_submission_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX lab_grades_submission_id_key ON public.lab_grades USING btree (submission_id);


--
-- TOC entry 5544 (class 1259 OID 152573)
-- Name: lab_group_assignments_lab_id_user_group_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX lab_group_assignments_lab_id_user_group_id_key ON public.lab_group_assignments USING btree (lab_id, user_group_id);


--
-- TOC entry 5547 (class 1259 OID 152574)
-- Name: lab_submissions_lab_assignment_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lab_submissions_lab_assignment_id_idx ON public.lab_submissions USING btree (lab_assignment_id);


--
-- TOC entry 5550 (class 1259 OID 152575)
-- Name: lab_submissions_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lab_submissions_user_id_idx ON public.lab_submissions USING btree (user_id);


--
-- TOC entry 5551 (class 1259 OID 152576)
-- Name: labs_course_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX labs_course_id_idx ON public.labs USING btree (course_id);


--
-- TOC entry 5552 (class 1259 OID 152577)
-- Name: labs_created_by_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX labs_created_by_user_id_idx ON public.labs USING btree (created_by_user_id);


--
-- TOC entry 5553 (class 1259 OID 152578)
-- Name: labs_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX labs_organization_id_idx ON public.labs USING btree (organization_id);


--
-- TOC entry 5780 (class 1259 OID 196801)
-- Name: mentor_blocked_dates_mentor_profile_id_blocked_date_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX mentor_blocked_dates_mentor_profile_id_blocked_date_key ON public.mentor_blocked_dates USING btree (mentor_profile_id, blocked_date);


--
-- TOC entry 5560 (class 1259 OID 152579)
-- Name: mentor_bookings_mentor_profile_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_bookings_mentor_profile_id_idx ON public.mentor_bookings USING btree (mentor_profile_id);


--
-- TOC entry 5563 (class 1259 OID 152580)
-- Name: mentor_bookings_student_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_bookings_student_user_id_idx ON public.mentor_bookings USING btree (student_user_id);


--
-- TOC entry 5566 (class 1259 OID 152581)
-- Name: mentor_profiles_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX mentor_profiles_user_id_key ON public.mentor_profiles USING btree (user_id);


--
-- TOC entry 5567 (class 1259 OID 152582)
-- Name: mentor_reviews_mentor_booking_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX mentor_reviews_mentor_booking_id_key ON public.mentor_reviews USING btree (mentor_booking_id);


--
-- TOC entry 5774 (class 1259 OID 187176)
-- Name: mentor_session_payments_mentor_session_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_session_payments_mentor_session_id_idx ON public.mentor_session_payments USING btree (mentor_session_id);


--
-- TOC entry 5775 (class 1259 OID 187178)
-- Name: mentor_session_payments_payee_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_session_payments_payee_user_id_idx ON public.mentor_session_payments USING btree (payee_user_id);


--
-- TOC entry 5776 (class 1259 OID 187177)
-- Name: mentor_session_payments_payer_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_session_payments_payer_user_id_idx ON public.mentor_session_payments USING btree (payer_user_id);


--
-- TOC entry 5779 (class 1259 OID 187179)
-- Name: mentor_session_payments_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_session_payments_status_idx ON public.mentor_session_payments USING btree (status);


--
-- TOC entry 5770 (class 1259 OID 187174)
-- Name: mentor_session_status_history_mentor_session_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_session_status_history_mentor_session_id_idx ON public.mentor_session_status_history USING btree (mentor_session_id);


--
-- TOC entry 5773 (class 1259 OID 187175)
-- Name: mentor_session_status_history_timestamp_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_session_status_history_timestamp_idx ON public.mentor_session_status_history USING btree ("timestamp");


--
-- TOC entry 5761 (class 1259 OID 197003)
-- Name: mentor_sessions_mentor_profile_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_sessions_mentor_profile_id_status_idx ON public.mentor_sessions USING btree (mentor_profile_id, status);


--
-- TOC entry 5764 (class 1259 OID 187171)
-- Name: mentor_sessions_requested_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_sessions_requested_at_idx ON public.mentor_sessions USING btree (requested_at);


--
-- TOC entry 5765 (class 1259 OID 187167)
-- Name: mentor_sessions_rescheduled_to_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX mentor_sessions_rescheduled_to_id_key ON public.mentor_sessions USING btree (rescheduled_to_id);


--
-- TOC entry 5766 (class 1259 OID 187172)
-- Name: mentor_sessions_scheduled_from_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_sessions_scheduled_from_idx ON public.mentor_sessions USING btree (scheduled_from);


--
-- TOC entry 5767 (class 1259 OID 197005)
-- Name: mentor_sessions_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_sessions_status_idx ON public.mentor_sessions USING btree (status);


--
-- TOC entry 5768 (class 1259 OID 197006)
-- Name: mentor_sessions_status_scheduled_from_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_sessions_status_scheduled_from_idx ON public.mentor_sessions USING btree (status, scheduled_from);


--
-- TOC entry 5769 (class 1259 OID 197004)
-- Name: mentor_sessions_student_user_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_sessions_student_user_id_status_idx ON public.mentor_sessions USING btree (student_user_id, status);


--
-- TOC entry 5572 (class 1259 OID 152583)
-- Name: node_base_images_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX node_base_images_status_idx ON public.node_base_images USING btree (status);


--
-- TOC entry 5573 (class 1259 OID 152584)
-- Name: node_resource_reservations_node_id_session_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX node_resource_reservations_node_id_session_id_key ON public.node_resource_reservations USING btree (node_id, session_id);


--
-- TOC entry 5574 (class 1259 OID 152585)
-- Name: node_resource_reservations_node_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX node_resource_reservations_node_id_status_idx ON public.node_resource_reservations USING btree (node_id, status);


--
-- TOC entry 5577 (class 1259 OID 152586)
-- Name: node_resource_reservations_released_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX node_resource_reservations_released_at_idx ON public.node_resource_reservations USING btree (released_at);


--
-- TOC entry 5578 (class 1259 OID 152587)
-- Name: node_resource_reservations_session_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX node_resource_reservations_session_id_idx ON public.node_resource_reservations USING btree (session_id);


--
-- TOC entry 5579 (class 1259 OID 152588)
-- Name: node_resource_reservations_session_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX node_resource_reservations_session_id_key ON public.node_resource_reservations USING btree (session_id);


--
-- TOC entry 5580 (class 1259 OID 152589)
-- Name: nodes_hostname_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX nodes_hostname_key ON public.nodes USING btree (hostname);


--
-- TOC entry 5581 (class 1259 OID 152590)
-- Name: nodes_last_heartbeat_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nodes_last_heartbeat_at_idx ON public.nodes USING btree (last_heartbeat_at);


--
-- TOC entry 5582 (class 1259 OID 152591)
-- Name: nodes_last_resource_sync_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nodes_last_resource_sync_at_idx ON public.nodes USING btree (last_resource_sync_at);


--
-- TOC entry 5585 (class 1259 OID 152592)
-- Name: nodes_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nodes_status_idx ON public.nodes USING btree (status);


--
-- TOC entry 5588 (class 1259 OID 152593)
-- Name: notification_templates_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX notification_templates_slug_key ON public.notification_templates USING btree (slug);


--
-- TOC entry 5591 (class 1259 OID 152594)
-- Name: notifications_user_id_status_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notifications_user_id_status_created_at_idx ON public.notifications USING btree (user_id, status, created_at);


--
-- TOC entry 5592 (class 1259 OID 152595)
-- Name: org_contracts_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX org_contracts_organization_id_idx ON public.org_contracts USING btree (organization_id);


--
-- TOC entry 5595 (class 1259 OID 152596)
-- Name: org_contracts_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX org_contracts_status_idx ON public.org_contracts USING btree (status);


--
-- TOC entry 5596 (class 1259 OID 152597)
-- Name: org_resource_quotas_organization_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX org_resource_quotas_organization_id_key ON public.org_resource_quotas USING btree (organization_id);


--
-- TOC entry 5601 (class 1259 OID 152598)
-- Name: organizations_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX organizations_slug_key ON public.organizations USING btree (slug);


--
-- TOC entry 5602 (class 1259 OID 152599)
-- Name: os_switch_history_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX os_switch_history_created_at_idx ON public.os_switch_history USING btree (created_at);


--
-- TOC entry 5605 (class 1259 OID 152600)
-- Name: os_switch_history_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX os_switch_history_user_id_idx ON public.os_switch_history USING btree (user_id);


--
-- TOC entry 5608 (class 1259 OID 152601)
-- Name: payment_transactions_gateway_txn_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX payment_transactions_gateway_txn_id_key ON public.payment_transactions USING btree (gateway_txn_id);


--
-- TOC entry 5611 (class 1259 OID 152602)
-- Name: payment_transactions_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_transactions_status_idx ON public.payment_transactions USING btree (status);


--
-- TOC entry 5612 (class 1259 OID 152603)
-- Name: payment_transactions_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_transactions_user_id_created_at_idx ON public.payment_transactions USING btree (user_id, created_at);


--
-- TOC entry 5613 (class 1259 OID 152604)
-- Name: permissions_code_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX permissions_code_key ON public.permissions USING btree (code);


--
-- TOC entry 5616 (class 1259 OID 152605)
-- Name: project_showcases_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX project_showcases_organization_id_idx ON public.project_showcases USING btree (organization_id);


--
-- TOC entry 5619 (class 1259 OID 152606)
-- Name: project_showcases_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX project_showcases_user_id_idx ON public.project_showcases USING btree (user_id);


--
-- TOC entry 5620 (class 1259 OID 152607)
-- Name: recommendation_sessions_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recommendation_sessions_created_at_idx ON public.recommendation_sessions USING btree (created_at);


--
-- TOC entry 5623 (class 1259 OID 152608)
-- Name: recommendation_sessions_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recommendation_sessions_user_id_idx ON public.recommendation_sessions USING btree (user_id);


--
-- TOC entry 5626 (class 1259 OID 152609)
-- Name: referral_conversions_referral_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_conversions_referral_id_status_idx ON public.referral_conversions USING btree (referral_id, status);


--
-- TOC entry 5627 (class 1259 OID 152610)
-- Name: referral_conversions_referred_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX referral_conversions_referred_user_id_key ON public.referral_conversions USING btree (referred_user_id);


--
-- TOC entry 5628 (class 1259 OID 152611)
-- Name: referral_conversions_referrer_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_conversions_referrer_user_id_idx ON public.referral_conversions USING btree (referrer_user_id);


--
-- TOC entry 5629 (class 1259 OID 152612)
-- Name: referral_conversions_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_conversions_status_idx ON public.referral_conversions USING btree (status);


--
-- TOC entry 5630 (class 1259 OID 152613)
-- Name: referral_events_event_type_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_events_event_type_idx ON public.referral_events USING btree (event_type);


--
-- TOC entry 5633 (class 1259 OID 152614)
-- Name: referral_events_referral_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_events_referral_id_created_at_idx ON public.referral_events USING btree (referral_id, created_at);


--
-- TOC entry 5636 (class 1259 OID 152615)
-- Name: referrals_referral_code_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referrals_referral_code_idx ON public.referrals USING btree (referral_code);


--
-- TOC entry 5637 (class 1259 OID 152616)
-- Name: referrals_referral_code_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX referrals_referral_code_key ON public.referrals USING btree (referral_code);


--
-- TOC entry 5638 (class 1259 OID 152617)
-- Name: referrals_referrer_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referrals_referrer_user_id_idx ON public.referrals USING btree (referrer_user_id);


--
-- TOC entry 5639 (class 1259 OID 152618)
-- Name: referrals_referrer_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX referrals_referrer_user_id_key ON public.referrals USING btree (referrer_user_id);


--
-- TOC entry 5644 (class 1259 OID 152619)
-- Name: roles_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX roles_name_key ON public.roles USING btree (name);


--
-- TOC entry 5647 (class 1259 OID 152620)
-- Name: session_events_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX session_events_created_at_idx ON public.session_events USING btree (created_at);


--
-- TOC entry 5650 (class 1259 OID 152621)
-- Name: session_events_session_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX session_events_session_id_idx ON public.session_events USING btree (session_id);


--
-- TOC entry 5651 (class 1259 OID 152622)
-- Name: sessions_booking_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX sessions_booking_id_key ON public.sessions USING btree (booking_id);


--
-- TOC entry 5652 (class 1259 OID 152623)
-- Name: sessions_compute_config_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_compute_config_id_idx ON public.sessions USING btree (compute_config_id);


--
-- TOC entry 5653 (class 1259 OID 152624)
-- Name: sessions_instance_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_instance_name_idx ON public.sessions USING btree (instance_name);


--
-- TOC entry 5654 (class 1259 OID 152625)
-- Name: sessions_node_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_node_id_status_idx ON public.sessions USING btree (node_id, status);


--
-- TOC entry 5657 (class 1259 OID 152626)
-- Name: sessions_started_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_started_at_idx ON public.sessions USING btree (started_at);


--
-- TOC entry 5658 (class 1259 OID 152627)
-- Name: sessions_storage_mode_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_storage_mode_idx ON public.sessions USING btree (storage_mode);


--
-- TOC entry 5659 (class 1259 OID 152628)
-- Name: sessions_storage_node_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_storage_node_id_idx ON public.sessions USING btree (storage_node_id);


--
-- TOC entry 5660 (class 1259 OID 152629)
-- Name: sessions_user_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_user_id_status_idx ON public.sessions USING btree (user_id, status);


--
-- TOC entry 5661 (class 1259 OID 152630)
-- Name: storage_extensions_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX storage_extensions_created_at_idx ON public.storage_extensions USING btree (created_at);


--
-- TOC entry 5664 (class 1259 OID 152631)
-- Name: storage_extensions_storage_volume_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX storage_extensions_storage_volume_id_idx ON public.storage_extensions USING btree (storage_volume_id);


--
-- TOC entry 5665 (class 1259 OID 152632)
-- Name: storage_extensions_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX storage_extensions_user_id_idx ON public.storage_extensions USING btree (user_id);


--
-- TOC entry 5668 (class 1259 OID 152633)
-- Name: subscription_plans_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX subscription_plans_slug_key ON public.subscription_plans USING btree (slug);


--
-- TOC entry 5669 (class 1259 OID 152634)
-- Name: subscription_plans_sort_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subscription_plans_sort_order_idx ON public.subscription_plans USING btree (sort_order);


--
-- TOC entry 5670 (class 1259 OID 152635)
-- Name: subscriptions_ends_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subscriptions_ends_at_idx ON public.subscriptions USING btree (ends_at);


--
-- TOC entry 5673 (class 1259 OID 152636)
-- Name: subscriptions_user_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subscriptions_user_id_status_idx ON public.subscriptions USING btree (user_id, status);


--
-- TOC entry 5760 (class 1259 OID 163212)
-- Name: support_ticket_attachments_ticketId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "support_ticket_attachments_ticketId_idx" ON public.support_ticket_attachments USING btree ("ticketId");


--
-- TOC entry 5674 (class 1259 OID 152637)
-- Name: support_tickets_assigned_to_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX support_tickets_assigned_to_status_idx ON public.support_tickets USING btree (assigned_to, status);


--
-- TOC entry 5675 (class 1259 OID 152638)
-- Name: support_tickets_organization_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX support_tickets_organization_id_status_idx ON public.support_tickets USING btree (organization_id, status);


--
-- TOC entry 5678 (class 1259 OID 152639)
-- Name: support_tickets_user_id_status_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX support_tickets_user_id_status_created_at_idx ON public.support_tickets USING btree (user_id, status, created_at);


--
-- TOC entry 5679 (class 1259 OID 152640)
-- Name: system_settings_key_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX system_settings_key_key ON public.system_settings USING btree (key);


--
-- TOC entry 5684 (class 1259 OID 152641)
-- Name: ticket_messages_ticket_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ticket_messages_ticket_id_created_at_idx ON public.ticket_messages USING btree (ticket_id, created_at);


--
-- TOC entry 5687 (class 1259 OID 152642)
-- Name: universities_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX universities_slug_key ON public.universities USING btree (slug);


--
-- TOC entry 5690 (class 1259 OID 152643)
-- Name: university_idp_configs_university_id_idp_type_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX university_idp_configs_university_id_idp_type_key ON public.university_idp_configs USING btree (university_id, idp_type);


--
-- TOC entry 5693 (class 1259 OID 152644)
-- Name: user_achievements_user_id_achievement_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_achievements_user_id_achievement_id_key ON public.user_achievements USING btree (user_id, achievement_id);


--
-- TOC entry 5696 (class 1259 OID 152645)
-- Name: user_deletion_requests_scheduled_deletion_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_deletion_requests_scheduled_deletion_at_idx ON public.user_deletion_requests USING btree (scheduled_deletion_at);


--
-- TOC entry 5697 (class 1259 OID 152646)
-- Name: user_deletion_requests_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_deletion_requests_status_idx ON public.user_deletion_requests USING btree (status);


--
-- TOC entry 5698 (class 1259 OID 152647)
-- Name: user_deletion_requests_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_deletion_requests_user_id_idx ON public.user_deletion_requests USING btree (user_id);


--
-- TOC entry 5699 (class 1259 OID 152648)
-- Name: user_departments_department_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_departments_department_id_idx ON public.user_departments USING btree (department_id);


--
-- TOC entry 5702 (class 1259 OID 152649)
-- Name: user_departments_user_id_department_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_departments_user_id_department_id_key ON public.user_departments USING btree (user_id, department_id);


--
-- TOC entry 5703 (class 1259 OID 152650)
-- Name: user_departments_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_departments_user_id_idx ON public.user_departments USING btree (user_id);


--
-- TOC entry 5706 (class 1259 OID 152651)
-- Name: user_feedback_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_feedback_user_id_created_at_idx ON public.user_feedback USING btree (user_id, created_at);


--
-- TOC entry 5707 (class 1259 OID 152652)
-- Name: user_files_deleted_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_files_deleted_at_idx ON public.user_files USING btree (deleted_at);


--
-- TOC entry 5710 (class 1259 OID 152653)
-- Name: user_files_scheduled_deletion_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_files_scheduled_deletion_at_idx ON public.user_files USING btree (scheduled_deletion_at);


--
-- TOC entry 5711 (class 1259 OID 152654)
-- Name: user_files_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_files_user_id_idx ON public.user_files USING btree (user_id);


--
-- TOC entry 5714 (class 1259 OID 152655)
-- Name: user_group_members_user_group_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_group_members_user_group_id_idx ON public.user_group_members USING btree (user_group_id);


--
-- TOC entry 5715 (class 1259 OID 152656)
-- Name: user_group_members_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_group_members_user_id_idx ON public.user_group_members USING btree (user_id);


--
-- TOC entry 5716 (class 1259 OID 152657)
-- Name: user_group_members_user_id_user_group_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_group_members_user_id_user_group_id_key ON public.user_group_members USING btree (user_id, user_group_id);


--
-- TOC entry 5717 (class 1259 OID 152658)
-- Name: user_groups_department_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_groups_department_id_idx ON public.user_groups USING btree (department_id);


--
-- TOC entry 5718 (class 1259 OID 152659)
-- Name: user_groups_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_groups_organization_id_idx ON public.user_groups USING btree (organization_id);


--
-- TOC entry 5719 (class 1259 OID 152660)
-- Name: user_groups_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_groups_parent_id_idx ON public.user_groups USING btree (parent_id);


--
-- TOC entry 5724 (class 1259 OID 152661)
-- Name: user_org_roles_user_id_organization_id_role_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_org_roles_user_id_organization_id_role_id_key ON public.user_org_roles USING btree (user_id, organization_id, role_id);


--
-- TOC entry 5729 (class 1259 OID 152662)
-- Name: user_profiles_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_profiles_user_id_key ON public.user_profiles USING btree (user_id);


--
-- TOC entry 5730 (class 1259 OID 152663)
-- Name: user_storage_volumes_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_storage_volumes_created_at_idx ON public.user_storage_volumes USING btree (created_at);


--
-- TOC entry 5731 (class 1259 OID 152664)
-- Name: user_storage_volumes_node_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_storage_volumes_node_id_idx ON public.user_storage_volumes USING btree (node_id);


--
-- TOC entry 5734 (class 1259 OID 152665)
-- Name: user_storage_volumes_user_id_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_storage_volumes_user_id_name_key ON public.user_storage_volumes USING btree (user_id, name);


--
-- TOC entry 5735 (class 1259 OID 152666)
-- Name: user_storage_volumes_user_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_storage_volumes_user_id_status_idx ON public.user_storage_volumes USING btree (user_id, status);


--
-- TOC entry 5736 (class 1259 OID 152667)
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- TOC entry 5737 (class 1259 OID 152668)
-- Name: users_keycloak_sub_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_keycloak_sub_key ON public.users USING btree (keycloak_sub);


--
-- TOC entry 5740 (class 1259 OID 152669)
-- Name: users_storage_uid_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_storage_uid_key ON public.users USING btree (storage_uid);


--
-- TOC entry 5741 (class 1259 OID 152670)
-- Name: waitlist_entries_createdAt_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "waitlist_entries_createdAt_idx" ON public.waitlist_entries USING btree ("createdAt");


--
-- TOC entry 5742 (class 1259 OID 152671)
-- Name: waitlist_entries_email_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX waitlist_entries_email_idx ON public.waitlist_entries USING btree (email);


--
-- TOC entry 5745 (class 1259 OID 152672)
-- Name: waitlist_entries_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX waitlist_entries_status_idx ON public.waitlist_entries USING btree (status);


--
-- TOC entry 5746 (class 1259 OID 152673)
-- Name: wallet_holds_expires_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallet_holds_expires_at_idx ON public.wallet_holds USING btree (expires_at);


--
-- TOC entry 5749 (class 1259 OID 152674)
-- Name: wallet_holds_wallet_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallet_holds_wallet_id_status_idx ON public.wallet_holds USING btree (wallet_id, status);


--
-- TOC entry 5752 (class 1259 OID 152675)
-- Name: wallet_transactions_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallet_transactions_user_id_created_at_idx ON public.wallet_transactions USING btree (user_id, created_at);


--
-- TOC entry 5753 (class 1259 OID 152676)
-- Name: wallet_transactions_wallet_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallet_transactions_wallet_id_created_at_idx ON public.wallet_transactions USING btree (wallet_id, created_at);


--
-- TOC entry 5754 (class 1259 OID 152677)
-- Name: wallets_balance_cents_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallets_balance_cents_idx ON public.wallets USING btree (balance_cents);


--
-- TOC entry 5757 (class 1259 OID 152678)
-- Name: wallets_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX wallets_user_id_key ON public.wallets USING btree (user_id);


--
-- TOC entry 5783 (class 1259 OID 196826)
-- Name: withdrawal_requests_idempotency_key_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX withdrawal_requests_idempotency_key_key ON public.withdrawal_requests USING btree (idempotency_key);


--
-- TOC entry 5786 (class 1259 OID 196828)
-- Name: withdrawal_requests_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX withdrawal_requests_status_idx ON public.withdrawal_requests USING btree (status);


--
-- TOC entry 5787 (class 1259 OID 196827)
-- Name: withdrawal_requests_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX withdrawal_requests_user_id_created_at_idx ON public.withdrawal_requests USING btree (user_id, created_at);


--
-- TOC entry 5788 (class 2606 OID 152679)
-- Name: announcements announcements_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5789 (class 2606 OID 152684)
-- Name: audit_log audit_log_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5790 (class 2606 OID 152689)
-- Name: audit_log audit_log_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5791 (class 2606 OID 152694)
-- Name: billing_charges billing_charges_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5792 (class 2606 OID 152699)
-- Name: billing_charges billing_charges_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5793 (class 2606 OID 152704)
-- Name: billing_charges billing_charges_storage_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_storage_volume_id_fkey FOREIGN KEY (storage_volume_id) REFERENCES public.user_storage_volumes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5794 (class 2606 OID 152709)
-- Name: billing_charges billing_charges_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5795 (class 2606 OID 152714)
-- Name: billing_charges billing_charges_wallet_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_wallet_transaction_id_fkey FOREIGN KEY (wallet_transaction_id) REFERENCES public.wallet_transactions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5796 (class 2606 OID 152719)
-- Name: bookings bookings_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5797 (class 2606 OID 152724)
-- Name: bookings bookings_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5798 (class 2606 OID 152729)
-- Name: bookings bookings_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5799 (class 2606 OID 152734)
-- Name: bookings bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5800 (class 2606 OID 152739)
-- Name: compute_config_access compute_config_access_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_config_access
    ADD CONSTRAINT compute_config_access_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5801 (class 2606 OID 152744)
-- Name: compute_config_access compute_config_access_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_config_access
    ADD CONSTRAINT compute_config_access_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5802 (class 2606 OID 152749)
-- Name: compute_config_access compute_config_access_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_config_access
    ADD CONSTRAINT compute_config_access_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5803 (class 2606 OID 152754)
-- Name: course_enrollments course_enrollments_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5804 (class 2606 OID 152759)
-- Name: course_enrollments course_enrollments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5805 (class 2606 OID 152764)
-- Name: courses courses_default_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_default_compute_config_id_fkey FOREIGN KEY (default_compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5806 (class 2606 OID 152769)
-- Name: courses courses_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5807 (class 2606 OID 152774)
-- Name: courses courses_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5808 (class 2606 OID 152779)
-- Name: courses courses_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5809 (class 2606 OID 152784)
-- Name: coursework_content coursework_content_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coursework_content
    ADD CONSTRAINT coursework_content_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5810 (class 2606 OID 152789)
-- Name: departments departments_head_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_head_user_id_fkey FOREIGN KEY (head_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5811 (class 2606 OID 152794)
-- Name: departments departments_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5812 (class 2606 OID 152799)
-- Name: departments departments_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5813 (class 2606 OID 152804)
-- Name: discussion_replies discussion_replies_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5814 (class 2606 OID 152809)
-- Name: discussion_replies discussion_replies_discussion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_discussion_id_fkey FOREIGN KEY (discussion_id) REFERENCES public.discussions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5815 (class 2606 OID 152814)
-- Name: discussion_replies discussion_replies_parent_reply_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_parent_reply_id_fkey FOREIGN KEY (parent_reply_id) REFERENCES public.discussion_replies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5816 (class 2606 OID 152819)
-- Name: discussions discussions_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5817 (class 2606 OID 152824)
-- Name: discussions discussions_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5818 (class 2606 OID 152829)
-- Name: discussions discussions_lab_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_lab_id_fkey FOREIGN KEY (lab_id) REFERENCES public.labs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5819 (class 2606 OID 152834)
-- Name: discussions discussions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5820 (class 2606 OID 152839)
-- Name: invoice_line_items invoice_line_items_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_line_items
    ADD CONSTRAINT invoice_line_items_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5821 (class 2606 OID 152844)
-- Name: invoices invoices_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5822 (class 2606 OID 152849)
-- Name: invoices invoices_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5823 (class 2606 OID 152854)
-- Name: lab_assignments lab_assignments_lab_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_assignments
    ADD CONSTRAINT lab_assignments_lab_id_fkey FOREIGN KEY (lab_id) REFERENCES public.labs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5824 (class 2606 OID 152859)
-- Name: lab_grades lab_grades_graded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_grades
    ADD CONSTRAINT lab_grades_graded_by_fkey FOREIGN KEY (graded_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5825 (class 2606 OID 152864)
-- Name: lab_grades lab_grades_submission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_grades
    ADD CONSTRAINT lab_grades_submission_id_fkey FOREIGN KEY (submission_id) REFERENCES public.lab_submissions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5826 (class 2606 OID 152869)
-- Name: lab_group_assignments lab_group_assignments_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_group_assignments
    ADD CONSTRAINT lab_group_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5827 (class 2606 OID 152874)
-- Name: lab_group_assignments lab_group_assignments_lab_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_group_assignments
    ADD CONSTRAINT lab_group_assignments_lab_id_fkey FOREIGN KEY (lab_id) REFERENCES public.labs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5828 (class 2606 OID 152879)
-- Name: lab_group_assignments lab_group_assignments_user_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_group_assignments
    ADD CONSTRAINT lab_group_assignments_user_group_id_fkey FOREIGN KEY (user_group_id) REFERENCES public.user_groups(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5829 (class 2606 OID 152884)
-- Name: lab_submissions lab_submissions_lab_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_submissions
    ADD CONSTRAINT lab_submissions_lab_assignment_id_fkey FOREIGN KEY (lab_assignment_id) REFERENCES public.lab_assignments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5830 (class 2606 OID 152889)
-- Name: lab_submissions lab_submissions_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_submissions
    ADD CONSTRAINT lab_submissions_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5831 (class 2606 OID 152894)
-- Name: lab_submissions lab_submissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_submissions
    ADD CONSTRAINT lab_submissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5832 (class 2606 OID 152899)
-- Name: labs labs_base_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_base_image_id_fkey FOREIGN KEY (base_image_id) REFERENCES public.base_images(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5833 (class 2606 OID 152904)
-- Name: labs labs_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5834 (class 2606 OID 152909)
-- Name: labs labs_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5835 (class 2606 OID 152914)
-- Name: labs labs_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5836 (class 2606 OID 152919)
-- Name: labs labs_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5837 (class 2606 OID 152924)
-- Name: login_history login_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5838 (class 2606 OID 152929)
-- Name: mentor_availability_slots mentor_availability_slots_mentor_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_availability_slots
    ADD CONSTRAINT mentor_availability_slots_mentor_profile_id_fkey FOREIGN KEY (mentor_profile_id) REFERENCES public.mentor_profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5939 (class 2606 OID 196802)
-- Name: mentor_blocked_dates mentor_blocked_dates_mentor_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_blocked_dates
    ADD CONSTRAINT mentor_blocked_dates_mentor_profile_id_fkey FOREIGN KEY (mentor_profile_id) REFERENCES public.mentor_profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5839 (class 2606 OID 152934)
-- Name: mentor_bookings mentor_bookings_mentor_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_bookings
    ADD CONSTRAINT mentor_bookings_mentor_profile_id_fkey FOREIGN KEY (mentor_profile_id) REFERENCES public.mentor_profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5840 (class 2606 OID 152939)
-- Name: mentor_bookings mentor_bookings_payment_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_bookings
    ADD CONSTRAINT mentor_bookings_payment_transaction_id_fkey FOREIGN KEY (payment_transaction_id) REFERENCES public.payment_transactions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5841 (class 2606 OID 152944)
-- Name: mentor_bookings mentor_bookings_student_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_bookings
    ADD CONSTRAINT mentor_bookings_student_user_id_fkey FOREIGN KEY (student_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5842 (class 2606 OID 152949)
-- Name: mentor_profiles mentor_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_profiles
    ADD CONSTRAINT mentor_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5843 (class 2606 OID 152954)
-- Name: mentor_reviews mentor_reviews_mentor_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_reviews
    ADD CONSTRAINT mentor_reviews_mentor_booking_id_fkey FOREIGN KEY (mentor_booking_id) REFERENCES public.mentor_bookings(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5844 (class 2606 OID 152959)
-- Name: mentor_reviews mentor_reviews_reviewer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_reviews
    ADD CONSTRAINT mentor_reviews_reviewer_user_id_fkey FOREIGN KEY (reviewer_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5935 (class 2606 OID 187200)
-- Name: mentor_session_payments mentor_session_payments_mentor_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_session_payments
    ADD CONSTRAINT mentor_session_payments_mentor_session_id_fkey FOREIGN KEY (mentor_session_id) REFERENCES public.mentor_sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5936 (class 2606 OID 187210)
-- Name: mentor_session_payments mentor_session_payments_payee_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_session_payments
    ADD CONSTRAINT mentor_session_payments_payee_user_id_fkey FOREIGN KEY (payee_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5937 (class 2606 OID 187205)
-- Name: mentor_session_payments mentor_session_payments_payer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_session_payments
    ADD CONSTRAINT mentor_session_payments_payer_user_id_fkey FOREIGN KEY (payer_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5938 (class 2606 OID 187215)
-- Name: mentor_session_payments mentor_session_payments_wallet_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_session_payments
    ADD CONSTRAINT mentor_session_payments_wallet_transaction_id_fkey FOREIGN KEY (wallet_transaction_id) REFERENCES public.wallet_transactions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5934 (class 2606 OID 187195)
-- Name: mentor_session_status_history mentor_session_status_history_mentor_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_session_status_history
    ADD CONSTRAINT mentor_session_status_history_mentor_session_id_fkey FOREIGN KEY (mentor_session_id) REFERENCES public.mentor_sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5931 (class 2606 OID 187180)
-- Name: mentor_sessions mentor_sessions_mentor_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_sessions
    ADD CONSTRAINT mentor_sessions_mentor_profile_id_fkey FOREIGN KEY (mentor_profile_id) REFERENCES public.mentor_profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5932 (class 2606 OID 187190)
-- Name: mentor_sessions mentor_sessions_rescheduled_to_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_sessions
    ADD CONSTRAINT mentor_sessions_rescheduled_to_id_fkey FOREIGN KEY (rescheduled_to_id) REFERENCES public.mentor_sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5933 (class 2606 OID 187185)
-- Name: mentor_sessions mentor_sessions_student_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_sessions
    ADD CONSTRAINT mentor_sessions_student_user_id_fkey FOREIGN KEY (student_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5845 (class 2606 OID 152964)
-- Name: node_base_images node_base_images_base_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_base_images
    ADD CONSTRAINT node_base_images_base_image_id_fkey FOREIGN KEY (base_image_id) REFERENCES public.base_images(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5846 (class 2606 OID 152969)
-- Name: node_base_images node_base_images_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_base_images
    ADD CONSTRAINT node_base_images_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5847 (class 2606 OID 152974)
-- Name: node_resource_reservations node_resource_reservations_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_resource_reservations
    ADD CONSTRAINT node_resource_reservations_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5848 (class 2606 OID 152979)
-- Name: node_resource_reservations node_resource_reservations_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_resource_reservations
    ADD CONSTRAINT node_resource_reservations_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5849 (class 2606 OID 152984)
-- Name: notifications notifications_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.notification_templates(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5850 (class 2606 OID 152989)
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5851 (class 2606 OID 152994)
-- Name: org_contracts org_contracts_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_contracts
    ADD CONSTRAINT org_contracts_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5852 (class 2606 OID 152999)
-- Name: org_resource_quotas org_resource_quotas_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_resource_quotas
    ADD CONSTRAINT org_resource_quotas_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5853 (class 2606 OID 153004)
-- Name: organizations organizations_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5854 (class 2606 OID 153009)
-- Name: os_switch_history os_switch_history_new_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_switch_history
    ADD CONSTRAINT os_switch_history_new_volume_id_fkey FOREIGN KEY (new_volume_id) REFERENCES public.user_storage_volumes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5855 (class 2606 OID 153014)
-- Name: os_switch_history os_switch_history_old_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_switch_history
    ADD CONSTRAINT os_switch_history_old_volume_id_fkey FOREIGN KEY (old_volume_id) REFERENCES public.user_storage_volumes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5856 (class 2606 OID 153019)
-- Name: os_switch_history os_switch_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_switch_history
    ADD CONSTRAINT os_switch_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5857 (class 2606 OID 153024)
-- Name: otp_verifications otp_verifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_verifications
    ADD CONSTRAINT otp_verifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5858 (class 2606 OID 153029)
-- Name: payment_transactions payment_transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5859 (class 2606 OID 153034)
-- Name: project_showcases project_showcases_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_showcases
    ADD CONSTRAINT project_showcases_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5860 (class 2606 OID 153039)
-- Name: project_showcases project_showcases_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_showcases
    ADD CONSTRAINT project_showcases_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5861 (class 2606 OID 153044)
-- Name: recommendation_sessions recommendation_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recommendation_sessions
    ADD CONSTRAINT recommendation_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5862 (class 2606 OID 153049)
-- Name: referral_conversions referral_conversions_referral_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_conversions
    ADD CONSTRAINT referral_conversions_referral_id_fkey FOREIGN KEY (referral_id) REFERENCES public.referrals(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5863 (class 2606 OID 153054)
-- Name: referral_conversions referral_conversions_referred_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_conversions
    ADD CONSTRAINT referral_conversions_referred_user_id_fkey FOREIGN KEY (referred_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5864 (class 2606 OID 153059)
-- Name: referral_conversions referral_conversions_referrer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_conversions
    ADD CONSTRAINT referral_conversions_referrer_user_id_fkey FOREIGN KEY (referrer_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5865 (class 2606 OID 153064)
-- Name: referral_events referral_events_referral_conversion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_events
    ADD CONSTRAINT referral_events_referral_conversion_id_fkey FOREIGN KEY (referral_conversion_id) REFERENCES public.referral_conversions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5866 (class 2606 OID 153069)
-- Name: referral_events referral_events_referral_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_events
    ADD CONSTRAINT referral_events_referral_id_fkey FOREIGN KEY (referral_id) REFERENCES public.referrals(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5867 (class 2606 OID 153074)
-- Name: referrals referrals_referrer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_referrer_user_id_fkey FOREIGN KEY (referrer_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5868 (class 2606 OID 153079)
-- Name: refresh_tokens refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5869 (class 2606 OID 153084)
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5870 (class 2606 OID 153089)
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5871 (class 2606 OID 153094)
-- Name: session_events session_events_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_events
    ADD CONSTRAINT session_events_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5872 (class 2606 OID 153099)
-- Name: sessions sessions_base_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_base_image_id_fkey FOREIGN KEY (base_image_id) REFERENCES public.base_images(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5873 (class 2606 OID 153104)
-- Name: sessions sessions_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5874 (class 2606 OID 153109)
-- Name: sessions sessions_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5875 (class 2606 OID 153114)
-- Name: sessions sessions_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5876 (class 2606 OID 153119)
-- Name: sessions sessions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5877 (class 2606 OID 153124)
-- Name: sessions sessions_storage_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_storage_node_id_fkey FOREIGN KEY (storage_node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5878 (class 2606 OID 153129)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5879 (class 2606 OID 153134)
-- Name: storage_extensions storage_extensions_payment_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_payment_transaction_id_fkey FOREIGN KEY (payment_transaction_id) REFERENCES public.payment_transactions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5880 (class 2606 OID 153139)
-- Name: storage_extensions storage_extensions_storage_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_storage_volume_id_fkey FOREIGN KEY (storage_volume_id) REFERENCES public.user_storage_volumes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5881 (class 2606 OID 153144)
-- Name: storage_extensions storage_extensions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5882 (class 2606 OID 153149)
-- Name: storage_extensions storage_extensions_wallet_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_wallet_transaction_id_fkey FOREIGN KEY (wallet_transaction_id) REFERENCES public.wallet_transactions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5883 (class 2606 OID 153154)
-- Name: subscriptions subscriptions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5884 (class 2606 OID 153159)
-- Name: subscriptions subscriptions_payment_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_payment_transaction_id_fkey FOREIGN KEY (payment_transaction_id) REFERENCES public.payment_transactions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5885 (class 2606 OID 153164)
-- Name: subscriptions subscriptions_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.subscription_plans(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5886 (class 2606 OID 153169)
-- Name: subscriptions subscriptions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5930 (class 2606 OID 163213)
-- Name: support_ticket_attachments support_ticket_attachments_ticketId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_ticket_attachments
    ADD CONSTRAINT "support_ticket_attachments_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES public.support_tickets(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5887 (class 2606 OID 153174)
-- Name: support_tickets support_tickets_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5888 (class 2606 OID 153179)
-- Name: support_tickets support_tickets_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5889 (class 2606 OID 153184)
-- Name: support_tickets support_tickets_related_billing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_related_billing_id_fkey FOREIGN KEY (related_billing_id) REFERENCES public.billing_charges(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5890 (class 2606 OID 153189)
-- Name: support_tickets support_tickets_related_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_related_session_id_fkey FOREIGN KEY (related_session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5891 (class 2606 OID 153194)
-- Name: support_tickets support_tickets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5892 (class 2606 OID 153199)
-- Name: ticket_messages ticket_messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_messages
    ADD CONSTRAINT ticket_messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5893 (class 2606 OID 153204)
-- Name: ticket_messages ticket_messages_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_messages
    ADD CONSTRAINT ticket_messages_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.support_tickets(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5894 (class 2606 OID 153209)
-- Name: university_idp_configs university_idp_configs_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.university_idp_configs
    ADD CONSTRAINT university_idp_configs_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5895 (class 2606 OID 153214)
-- Name: user_achievements user_achievements_achievement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_achievement_id_fkey FOREIGN KEY (achievement_id) REFERENCES public.achievements(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5896 (class 2606 OID 153219)
-- Name: user_achievements user_achievements_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5897 (class 2606 OID 153224)
-- Name: user_deletion_requests user_deletion_requests_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_deletion_requests
    ADD CONSTRAINT user_deletion_requests_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5898 (class 2606 OID 153229)
-- Name: user_deletion_requests user_deletion_requests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_deletion_requests
    ADD CONSTRAINT user_deletion_requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5899 (class 2606 OID 153234)
-- Name: user_departments user_departments_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_departments
    ADD CONSTRAINT user_departments_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5900 (class 2606 OID 153239)
-- Name: user_departments user_departments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_departments
    ADD CONSTRAINT user_departments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5901 (class 2606 OID 153244)
-- Name: user_feedback user_feedback_responded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_responded_by_fkey FOREIGN KEY (responded_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5902 (class 2606 OID 153249)
-- Name: user_feedback user_feedback_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5903 (class 2606 OID 153254)
-- Name: user_feedback user_feedback_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5904 (class 2606 OID 153259)
-- Name: user_files user_files_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_files
    ADD CONSTRAINT user_files_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5905 (class 2606 OID 153264)
-- Name: user_files user_files_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_files
    ADD CONSTRAINT user_files_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5906 (class 2606 OID 153269)
-- Name: user_group_members user_group_members_added_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_members
    ADD CONSTRAINT user_group_members_added_by_fkey FOREIGN KEY (added_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5907 (class 2606 OID 153274)
-- Name: user_group_members user_group_members_user_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_members
    ADD CONSTRAINT user_group_members_user_group_id_fkey FOREIGN KEY (user_group_id) REFERENCES public.user_groups(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5908 (class 2606 OID 153279)
-- Name: user_group_members user_group_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_members
    ADD CONSTRAINT user_group_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5909 (class 2606 OID 153284)
-- Name: user_groups user_groups_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5910 (class 2606 OID 153289)
-- Name: user_groups user_groups_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5911 (class 2606 OID 153294)
-- Name: user_groups user_groups_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.user_groups(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5912 (class 2606 OID 153299)
-- Name: user_org_roles user_org_roles_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_org_roles
    ADD CONSTRAINT user_org_roles_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5913 (class 2606 OID 153304)
-- Name: user_org_roles user_org_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_org_roles
    ADD CONSTRAINT user_org_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5914 (class 2606 OID 153309)
-- Name: user_org_roles user_org_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_org_roles
    ADD CONSTRAINT user_org_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5915 (class 2606 OID 153314)
-- Name: user_policy_consents user_policy_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_policy_consents
    ADD CONSTRAINT user_policy_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5916 (class 2606 OID 153319)
-- Name: user_profiles user_profiles_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5917 (class 2606 OID 153324)
-- Name: user_profiles user_profiles_id_proof_verified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_id_proof_verified_by_fkey FOREIGN KEY (id_proof_verified_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5918 (class 2606 OID 153329)
-- Name: user_profiles user_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5919 (class 2606 OID 153334)
-- Name: user_storage_volumes user_storage_volumes_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_storage_volumes
    ADD CONSTRAINT user_storage_volumes_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5920 (class 2606 OID 153339)
-- Name: user_storage_volumes user_storage_volumes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_storage_volumes
    ADD CONSTRAINT user_storage_volumes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5921 (class 2606 OID 153344)
-- Name: users users_default_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_default_org_id_fkey FOREIGN KEY (default_org_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5922 (class 2606 OID 153349)
-- Name: waitlist_entries waitlist_entries_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waitlist_entries
    ADD CONSTRAINT "waitlist_entries_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5923 (class 2606 OID 153354)
-- Name: wallet_holds wallet_holds_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5924 (class 2606 OID 153359)
-- Name: wallet_holds wallet_holds_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5925 (class 2606 OID 153364)
-- Name: wallet_holds wallet_holds_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5926 (class 2606 OID 153369)
-- Name: wallet_holds wallet_holds_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.wallets(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5927 (class 2606 OID 153374)
-- Name: wallet_transactions wallet_transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_transactions
    ADD CONSTRAINT wallet_transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5928 (class 2606 OID 153379)
-- Name: wallet_transactions wallet_transactions_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_transactions
    ADD CONSTRAINT wallet_transactions_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.wallets(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5929 (class 2606 OID 153384)
-- Name: wallets wallets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT wallets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5940 (class 2606 OID 196829)
-- Name: withdrawal_requests withdrawal_requests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.withdrawal_requests
    ADD CONSTRAINT withdrawal_requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5941 (class 2606 OID 196834)
-- Name: withdrawal_requests withdrawal_requests_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.withdrawal_requests
    ADD CONSTRAINT withdrawal_requests_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.wallets(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 6176 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2026-05-31 17:12:04

--
-- PostgreSQL database dump complete
--

\unrestrict lo0SsjafQpT6RxGbtz0V9Pm2xQc6gw72pu7231HBDfbE7iiZ8y9aTrIftZIbyDo

