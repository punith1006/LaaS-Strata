--
-- PostgreSQL database dump
--

\restrict Fze8aLozQfTNiNNR0xKHrsDIXGxeFCHUVfPDt7CFacPX7rL32woQVMlPRfeigVb

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-05-06 09:55:47

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
-- TOC entry 5 (class 2615 OID 118019)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 6071 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- TOC entry 959 (class 1247 OID 118233)
-- Name: AuthType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."AuthType" AS ENUM (
    'university_sso',
    'public_local',
    'public_oauth'
);


ALTER TYPE public."AuthType" OWNER TO postgres;

--
-- TOC entry 974 (class 1247 OID 118292)
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
-- TOC entry 980 (class 1247 OID 118316)
-- Name: NodeStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."NodeStatus" AS ENUM (
    'healthy',
    'degraded',
    'offline',
    'maintenance',
    'draining'
);


ALTER TYPE public."NodeStatus" OWNER TO postgres;

--
-- TOC entry 962 (class 1247 OID 118240)
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
-- TOC entry 1175 (class 1247 OID 124564)
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
-- TOC entry 1178 (class 1247 OID 124578)
-- Name: ReferralRewardStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ReferralRewardStatus" AS ENUM (
    'PENDING',
    'CREDITED',
    'VOIDED'
);


ALTER TYPE public."ReferralRewardStatus" OWNER TO postgres;

--
-- TOC entry 965 (class 1247 OID 118250)
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
-- TOC entry 1169 (class 1247 OID 120138)
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
-- TOC entry 968 (class 1247 OID 118270)
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
-- TOC entry 1196 (class 1247 OID 137625)
-- Name: StorageBackend; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."StorageBackend" AS ENUM (
    'zfs_dataset',
    'zfs_zvol'
);


ALTER TYPE public."StorageBackend" OWNER TO postgres;

--
-- TOC entry 1166 (class 1247 OID 120132)
-- Name: StorageMode; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."StorageMode" AS ENUM (
    'stateful',
    'ephemeral'
);


ALTER TYPE public."StorageMode" OWNER TO postgres;

--
-- TOC entry 1199 (class 1247 OID 137630)
-- Name: StorageTransport; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."StorageTransport" AS ENUM (
    'local_zfs',
    'nvmeof_tcp'
);


ALTER TYPE public."StorageTransport" OWNER TO postgres;

--
-- TOC entry 971 (class 1247 OID 118280)
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
-- TOC entry 983 (class 1247 OID 118328)
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
-- TOC entry 989 (class 1247 OID 118350)
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
-- TOC entry 986 (class 1247 OID 118338)
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
-- TOC entry 977 (class 1247 OID 118306)
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
-- TOC entry 219 (class 1259 OID 118020)
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
-- TOC entry 275 (class 1259 OID 119155)
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
-- TOC entry 283 (class 1259 OID 119269)
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
-- TOC entry 279 (class 1259 OID 119211)
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
-- TOC entry 241 (class 1259 OID 118573)
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
-- TOC entry 257 (class 1259 OID 118849)
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
    storage_volume_id uuid
);


ALTER TABLE public.billing_charges OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 118639)
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
-- TOC entry 244 (class 1259 OID 118627)
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
-- TOC entry 243 (class 1259 OID 118600)
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
-- TOC entry 261 (class 1259 OID 118920)
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
-- TOC entry 260 (class 1259 OID 118904)
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
-- TOC entry 267 (class 1259 OID 119012)
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
-- TOC entry 251 (class 1259 OID 118739)
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
-- TOC entry 232 (class 1259 OID 118433)
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
-- TOC entry 273 (class 1259 OID 119118)
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
-- TOC entry 272 (class 1259 OID 119098)
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
-- TOC entry 282 (class 1259 OID 119253)
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
-- TOC entry 259 (class 1259 OID 118889)
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
-- TOC entry 258 (class 1259 OID 118867)
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
-- TOC entry 264 (class 1259 OID 118961)
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
-- TOC entry 266 (class 1259 OID 118999)
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
-- TOC entry 263 (class 1259 OID 118949)
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
-- TOC entry 265 (class 1259 OID 118983)
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
-- TOC entry 262 (class 1259 OID 118933)
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
-- TOC entry 224 (class 1259 OID 118098)
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
-- TOC entry 269 (class 1259 OID 119051)
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
-- TOC entry 270 (class 1259 OID 119067)
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
-- TOC entry 268 (class 1259 OID 119029)
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
    updated_by uuid
);


ALTER TABLE public.mentor_profiles OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 119084)
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
-- TOC entry 242 (class 1259 OID 118587)
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
-- TOC entry 288 (class 1259 OID 120169)
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
-- TOC entry 240 (class 1259 OID 118551)
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
-- TOC entry 277 (class 1259 OID 119182)
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
-- TOC entry 278 (class 1259 OID 119196)
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
-- TOC entry 254 (class 1259 OID 118798)
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
-- TOC entry 255 (class 1259 OID 118814)
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
-- TOC entry 225 (class 1259 OID 118110)
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
-- TOC entry 238 (class 1259 OID 118523)
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
-- TOC entry 221 (class 1259 OID 118056)
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
-- TOC entry 256 (class 1259 OID 118832)
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
-- TOC entry 227 (class 1259 OID 118140)
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
-- TOC entry 274 (class 1259 OID 119134)
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
-- TOC entry 292 (class 1259 OID 124649)
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
    completed_at timestamp(3) without time zone
);


ALTER TABLE public.recommendation_sessions OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 124613)
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
-- TOC entry 291 (class 1259 OID 124636)
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
-- TOC entry 289 (class 1259 OID 124591)
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
-- TOC entry 223 (class 1259 OID 118085)
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
-- TOC entry 228 (class 1259 OID 118152)
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 118126)
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
-- TOC entry 247 (class 1259 OID 118674)
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
-- TOC entry 246 (class 1259 OID 118655)
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
-- TOC entry 287 (class 1259 OID 120067)
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
-- TOC entry 252 (class 1259 OID 118759)
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
-- TOC entry 253 (class 1259 OID 118781)
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
-- TOC entry 284 (class 1259 OID 119282)
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
-- TOC entry 281 (class 1259 OID 119240)
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
-- TOC entry 285 (class 1259 OID 119300)
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
-- TOC entry 230 (class 1259 OID 118399)
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
-- TOC entry 231 (class 1259 OID 118416)
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
-- TOC entry 276 (class 1259 OID 119170)
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
-- TOC entry 280 (class 1259 OID 119223)
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
-- TOC entry 235 (class 1259 OID 118480)
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
-- TOC entry 286 (class 1259 OID 119315)
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
-- TOC entry 239 (class 1259 OID 118535)
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
-- TOC entry 236 (class 1259 OID 118493)
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
-- TOC entry 233 (class 1259 OID 118449)
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
-- TOC entry 229 (class 1259 OID 118161)
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
-- TOC entry 222 (class 1259 OID 118072)
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
-- TOC entry 234 (class 1259 OID 118464)
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
    department_id uuid
);


ALTER TABLE public.user_profiles OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 118504)
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
-- TOC entry 220 (class 1259 OID 118034)
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
-- TOC entry 293 (class 1259 OID 129402)
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
-- TOC entry 249 (class 1259 OID 118710)
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
-- TOC entry 250 (class 1259 OID 118724)
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
-- TOC entry 248 (class 1259 OID 118686)
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
-- TOC entry 5991 (class 0 OID 118020)
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
\.


--
-- TOC entry 6047 (class 0 OID 119155)
-- Dependencies: 275
-- Data for Name: achievements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.achievements (id, slug, name, description, icon_url, category, criteria, points, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6055 (class 0 OID 119269)
-- Dependencies: 283
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.announcements (id, organization_id, title, body, severity, published_at, expires_at, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6051 (class 0 OID 119211)
-- Dependencies: 279
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_log (id, actor_id, actor_role, org_id, action, resource_type, resource_id, old_data, new_data, client_ip, user_agent, action_reason, request_id, created_at) FROM stdin;
ba2edc23-8e92-44b5-b0b6-26f01631212e	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-04 07:40:55.924
c4168c9c-fd9a-4193-8980-51efc6ebd971	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	filestore.create	storage	\N	\N	{"name": "ef1", "quotaGb": 5, "storageUid": "u_84a91b77c6bca47707b0c580"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 07:42:07.458
7b638040-2174-4938-8dad-3f5ede9bcc22	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	file.mkdir	storage	\N	\N	{"path": "/", "folderName": "zenith"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 07:42:18.714
8a79c288-7a10-4d5a-8a8a-71d4fbadc22b	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	file.upload	storage	\N	\N	{"path": "/zenith", "fileName": "FortiClientInstaller_1.exe"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 07:42:24.148
5cd62286-3d16-4c4d-b067-90cc8efb0dce	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	file.upload	storage	\N	\N	{"path": "/zenith", "fileName": "video.mp4"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 07:42:45.726
a35a894c-9666-4d5c-9500-81eb74fae3e9	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	filestore.upgrade	storage	\N	\N	{"name": "ef1", "method": "in_place", "volumeId": "ccec291b-4633-4e45-8453-52f933cc991d", "newQuotaGb": 7, "storageUid": "u_84a91b77c6bca47707b0c580", "previousQuotaGb": 5}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 07:42:59.766
e8205757-1c05-470e-91de-1115f8fabad7	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-04 07:50:41.374
59f920ad-3b6e-4256-b6c9-00af6b93c2dc	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	filestore.delete	storage	\N	\N	{"volumeId": "ccec291b-4633-4e45-8453-52f933cc991d", "storageUid": "u_84a91b77c6bca47707b0c580"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 07:50:50.063
0a105933-4533-4d29-8d81-a8f336159d45	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	filestore.create	storage	\N	\N	{"name": "ed1", "quotaGb": 5, "storageUid": "u_f7053a8b16cd55e38b838e79"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 07:51:08.73
99b52dba-681e-4ed5-8bfa-d319c471921a	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	filestore.upgrade	storage	\N	\N	{"name": "ed1", "method": "in_place", "volumeId": "744a5e38-9ebd-45fb-a12f-308bc6c281a4", "newQuotaGb": 9, "storageUid": "u_f7053a8b16cd55e38b838e79", "previousQuotaGb": 5}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 07:53:02.305
20214d5d-0c6d-4b23-b92c-97437918d39d	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	file.mkdir	storage	\N	\N	{"path": "/", "folderName": "zenith"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 07:53:16.82
e5c6621b-1998-473d-bfa1-4f9f1b46162a	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	file.upload	storage	\N	\N	{"path": "/zenith", "fileName": "matrimony_backend_2.zip"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 07:53:41.365
ae316492-3097-4c42-9b78-614bb0270091	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	filestore.upgrade	storage	\N	\N	{"name": "ed1", "method": "in_place", "volumeId": "744a5e38-9ebd-45fb-a12f-308bc6c281a4", "newQuotaGb": 10, "storageUid": "u_f7053a8b16cd55e38b838e79", "previousQuotaGb": 9}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 07:53:49.323
c34dc9d1-9509-4e87-b748-24dd7f10f0ea	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-04 08:23:13.463
d13cde25-22c6-49c0-a9a6-92a30d0c779b	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389	\N	\N	filestore.create	storage	\N	\N	{"name": "ed2", "quotaGb": 10, "storageUid": "u_67351641e9df7b1f476b151e"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 08:24:55.559
b697d351-9ad1-499c-bb10-09ac409caddb	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-04 08:26:53.095
d4d3ee8b-835b-4b1c-89b2-bacdf8a49fd6	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	filestore.delete	storage	\N	\N	{"volumeId": "744a5e38-9ebd-45fb-a12f-308bc6c281a4", "storageUid": "u_f7053a8b16cd55e38b838e79"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 08:27:09.868
1d317463-a53f-4c92-9864-a5e14b20fc92	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-04 08:27:26.826
85e9bb37-0c24-4f05-90ec-329f637ac01e	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-04 08:27:36.614
8d1dd41e-0765-4a36-8da0-51a55b5dec00	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389	\N	\N	filestore.delete	storage	\N	\N	{"volumeId": "106c4422-a4f2-49d7-b06e-f3e3d156e13d", "storageUid": "u_67351641e9df7b1f476b151e"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 08:27:47.36
91e5b094-5996-47f0-81a3-3948304bdd6b	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-04 08:58:40.001
57726912-2552-4c25-b59c-07aefc36cb1b	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	filestore.create	storage	\N	\N	{"name": "ef2", "quotaGb": 10, "storageUid": "u_c1e2324f5a10e9f2dbb54508"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 08:59:00.139
58d1fca7-07ee-4632-b15b-ab953623a2a2	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-04 09:30:00.095
5a9f1e2f-2996-4e86-aa10-f2725c12a642	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-04 10:30:00.263
819953ba-78a5-4be7-8277-169391fb5fe3	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-04 10:50:06.497
5ae6592f-e055-45cf-8855-4ddc368dc200	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-04 11:02:45.714
0c16e86e-c326-41bf-a215-ee074841426e	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-04 11:30:00.042
9606bf5c-0d2c-49b4-86ac-8be01ec5c6d3	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-04 12:30:00.058
b27157bc-cc2d-446c-9959-4534e14c5125	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-04 14:05:44.827
78cf3cf7-e54b-4ffd-b516-1cd5dec1bdc6	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-04 14:36:37.306
0908ec13-11dc-45d2-90a3-fa392374e886	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	filestore.delete	storage	\N	\N	{"volumeId": "0bb083a9-b83c-4dc4-87ee-844b8b75bba6", "storageUid": "u_c1e2324f5a10e9f2dbb54508"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 15:00:32.768
f335ad73-55d4-4535-894d-94e79ba1985e	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	filestore.create	storage	\N	\N	{"name": "ef10", "quotaGb": 10, "storageUid": "u_ec8ab0e4da1e4cd21f8e57f8"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 15:01:02.839
15b81743-7bb7-4b1c-b710-730ae7c614ce	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-04 15:30:00.141
8bfcb94a-58d4-43dd-8fc3-89b14d2bfb8d	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-04 16:30:00.055
96daa596-152f-4c73-b91e-f88aa7963565	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-04 16:33:44.048
393c703a-2391-4eba-aab6-c26f287768a3	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	file.mkdir	storage	\N	\N	{"path": "/", "folderName": "zenith"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 16:36:28.089
7e0d8b69-7152-42c1-abc5-94f73f681755	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	file.upload	storage	\N	\N	{"path": "/zenith", "fileName": "FortiClientInstaller_1.exe"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-04 16:36:35.77
fbf2d08c-9e40-459a-a636-c72778725c95	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-04 17:38:07.558
659f1e99-9cfd-4544-9283-13acbfec62a1	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-04 23:43:19.055
285bdf80-563f-4972-86a4-c85e79b7b2db	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-04 23:57:39.919
939f9d81-b08d-4258-9c15-821a7f602aa7	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-05 00:30:00.052
cd015b2a-59eb-4405-97e8-6f17dabea1b2	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-05 01:30:00.077
6d3616cd-1472-4945-9bca-c0bc73d2793a	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	file.upload	storage	\N	\N	{"path": "/zenith", "fileName": "2511.17127v2.pdf"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-05 01:30:42.989
6302e297-40a7-4fea-85e1-91163e8d37a4	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-05 02:30:00.187
8eeccbdc-69c3-410d-b00f-61c36aeb9370	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-05 03:30:00.165
e339269b-351b-4246-950e-f97fc74160a6	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-05 04:38:45.998
49879590-de99-48b4-b86b-0bd8d0041d47	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-05 05:11:30.697
8ed4db05-452d-4ab8-8da8-f5acc710251c	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	filestore.delete	storage	\N	\N	{"volumeId": "da558457-599c-42ad-9aaa-e94dd64ddc58", "storageUid": "u_ec8ab0e4da1e4cd21f8e57f8"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-05 05:13:08.896
3ea6c7ba-3854-4ce2-8f41-dc94844051fe	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	filestore.create	storage	\N	\N	{"name": "ef3", "quotaGb": 8, "storageUid": "u_a83c0ea547ffbfb60c5b80d9"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-05 05:13:51.321
ef3307aa-9db4-4316-a85c-dfe26f5b096e	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	filestore.upgrade	storage	\N	\N	{"name": "ef3", "method": "in_place", "volumeId": "82cc3fb0-b6ad-4adc-91ef-caaabe772f8b", "newQuotaGb": 10, "storageUid": "u_a83c0ea547ffbfb60c5b80d9", "previousQuotaGb": 8}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-05 05:14:03.774
117c44ec-7eb9-42d1-9fe0-fece33e74e08	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-05 05:30:00.21
7c97c759-2463-4a9b-8029-967a9f768f48	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	filestore.delete	storage	\N	\N	{"volumeId": "82cc3fb0-b6ad-4adc-91ef-caaabe772f8b", "storageUid": "u_a83c0ea547ffbfb60c5b80d9"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-05 05:44:37.514
0c1a280d-657b-4b8e-ad6f-f440154583ea	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	filestore.create	storage	\N	\N	{"name": "ef4", "quotaGb": 8, "storageUid": "u_66dda4c5b14682acbb7239b9"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-05 05:44:58.505
e7e75497-32de-4679-80fb-15bb5bf05e78	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	filestore.delete	storage	\N	\N	{"volumeId": "95a31862-7972-4a10-b56c-5a02905230e1", "storageUid": "u_66dda4c5b14682acbb7239b9"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-05 06:00:45.337
7a5f9f05-2f3c-4a7c-8e23-cdd763e6c4cb	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	filestore.create	storage	\N	\N	{"name": "ef101", "quotaGb": 9, "storageUid": "u_ec2de1aa873a3894dcf5c1ad"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-05 06:01:32.596
1561239c-badc-4db7-910e-3c913fd935a1	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 9}	\N	\N	success	\N	2026-05-05 06:30:00.113
335aa7af-74f2-4f08-8e69-dca1b53907d6	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-05 07:18:40.569
59cbef84-6cc3-4e61-9cbc-77ea6da622ae	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 9}	\N	\N	success	\N	2026-05-05 07:30:00.06
40ce6b3c-6003-471f-b3be-7e2e70e48ea7	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 9}	\N	\N	success	\N	2026-05-05 08:30:50.626
3fd3065f-531f-4684-adea-36655508eb62	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	file.mkdir	storage	\N	\N	{"path": "/", "folderName": "zenith"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-05 08:51:21.034
5dc4f985-0806-4f5f-a79d-ce300ec4b1d0	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	file.upload	storage	\N	\N	{"path": "/zenith", "fileName": "2511.17127v2.pdf"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-05 09:01:43.971
1d61d562-f24a-4b5d-aefe-963501ae48f3	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 9}	\N	\N	success	\N	2026-05-05 09:30:00.052
133a0f64-a129-44cc-b3c5-5d6e20b56c1d	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 9}	\N	\N	success	\N	2026-05-05 10:30:00.189
88db1bac-df73-4323-bab1-ee22e9ec1208	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 9}	\N	\N	success	\N	2026-05-05 11:30:00.118
af5c63de-927b-4fa4-8a8d-9158a115ee62	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-05 12:09:46.495
6ac8b9e8-d163-4b3f-aac6-fd59ef05c732	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 9}	\N	\N	success	\N	2026-05-05 12:46:48.296
198a32cc-a72a-40d3-bcd3-3703d24ee549	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-05 13:08:03.124
9bb56578-cb99-4334-9a72-4dedde311a4e	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 9}	\N	\N	success	\N	2026-05-05 13:34:16.892
e3c596f0-1f65-4c2d-9f96-dc957d503a60	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 9}	\N	\N	success	\N	2026-05-05 15:26:13.53
7ff151f9-0b2e-4896-8230-2eff372d4e93	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 9}	\N	\N	success	\N	2026-05-05 15:30:04.985
402acc69-0270-49c0-95f3-55c5820d88c2	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-05 15:34:33.191
77390a9f-cfbc-469b-b89d-9039bed88531	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 9}	\N	\N	success	\N	2026-05-05 16:30:00.071
93624a8f-b9a5-4dc3-90eb-06fb652f84ec	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 9}	\N	\N	success	\N	2026-05-05 17:30:00.111
\.


--
-- TOC entry 6013 (class 0 OID 118573)
-- Dependencies: 241
-- Data for Name: base_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.base_images (id, tag, os_name, description, size_bytes, software_manifest, is_default, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6029 (class 0 OID 118849)
-- Dependencies: 257
-- Data for Name: billing_charges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.billing_charges (id, user_id, session_id, compute_config_id, duration_seconds, rate_cents_per_hour, amount_cents, currency, wallet_transaction_id, created_at, created_by, charge_type, quota_gb, storage_volume_id) FROM stdin;
b6fd478e-dc59-4f6c-be88-2838dda38068	ae95fb83-2551-437f-8fac-dcd84b751a1d	f3345614-394f-49e8-99e1-30804f314627	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	a635b6c6-b410-463c-bd6a-5d836b2bc4b3	2026-05-04 08:04:14.146	\N	compute	\N	\N
4a3ced5d-8406-46bc-a85f-f17a440e3943	ae95fb83-2551-437f-8fac-dcd84b751a1d	58582e3f-f8bd-4147-b9ed-38a510ceb745	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	3500	3500	INR	d565f78a-ded1-47c4-a6a8-422a8043ba5d	2026-05-04 09:01:53.994	\N	compute	\N	\N
bcff2b0f-c5f2-4e88-a95f-aa5626d9809f	ae95fb83-2551-437f-8fac-dcd84b751a1d	892af945-7115-46cb-885e-2f44d9988218	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	10500	10500	INR	dad615f8-6510-47b7-b39c-84fc19340b1d	2026-05-04 09:03:59.052	\N	compute	\N	\N
a6318afa-0845-43cd-8ada-6a65726265fd	ae95fb83-2551-437f-8fac-dcd84b751a1d	68dd70a4-c61f-4fb1-85a4-9939e4643493	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	ace2edc3-c6cf-44a8-a1a6-009752e24af4	2026-05-04 09:16:57.534	\N	compute	\N	\N
397d55f5-ef02-4ec0-b434-6accc2fa5f48	ae95fb83-2551-437f-8fac-dcd84b751a1d	79446928-3d68-4633-ae84-6febe94609fc	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	cb4074b6-d50e-4d95-94ff-f3791f5e4719	2026-05-04 09:19:54.681	\N	compute	\N	\N
ba566a19-e23a-42e4-b983-14db91e9b5e3	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	10	10	INR	33d3c62b-765c-413b-b0c0-e63495bb6905	2026-05-04 09:30:00	\N	storage	10	0bb083a9-b83c-4dc4-87ee-844b8b75bba6
2d735674-961d-4b9d-a500-bd0a3f8a0b2e	ae95fb83-2551-437f-8fac-dcd84b751a1d	1df95352-8d8e-4ba9-874d-5380c3902827	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	59fe508d-d5be-4308-8afb-dea74bb7f79d	2026-05-04 09:31:25.685	\N	compute	\N	\N
051791b5-c220-415f-8455-37239f8aab1c	ae95fb83-2551-437f-8fac-dcd84b751a1d	1df95352-8d8e-4ba9-874d-5380c3902827	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	f9895c0b-436b-4c1f-943a-2aef6c9e98a4	2026-05-04 10:30:00.095	\N	compute	\N	\N
ded1baa5-e168-42e9-854e-7d2730c15c69	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	10	10	INR	04697b15-ae5f-4b97-948e-bf1f31820fca	2026-05-04 10:30:00	\N	storage	10	0bb083a9-b83c-4dc4-87ee-844b8b75bba6
2ad4f7a9-4fa5-419b-af70-e10f121fbfe3	ae95fb83-2551-437f-8fac-dcd84b751a1d	5abe4167-7866-4fb9-ab65-0a536167658b	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	f58b6315-9b62-4210-80ee-078af97dac35	2026-05-04 10:55:01.873	\N	compute	\N	\N
7b27eeb9-0a2f-48f8-8e4d-f471dd0fcbfe	ae95fb83-2551-437f-8fac-dcd84b751a1d	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	9f78e647-380f-482f-8ceb-a6fd5ab35096	2026-05-04 11:01:04.401	\N	compute	\N	\N
51fa7a76-cee6-4d4a-b3e7-359f099dd390	ae95fb83-2551-437f-8fac-dcd84b751a1d	e0688d0b-1645-4bae-a644-7a408007f2d8	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	10500	10500	INR	766f618d-b17b-4d30-8356-c223ad5ee3db	2026-05-04 11:21:17.523	\N	compute	\N	\N
f06b6e36-9465-4c19-a18b-1f48bfc58486	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	10	10	INR	b1374dca-6128-4ff2-8a94-cf49c53cbb7c	2026-05-04 11:30:00	\N	storage	10	0bb083a9-b83c-4dc4-87ee-844b8b75bba6
9cd54f5f-1aff-48a1-8ed8-42927b996d77	ae95fb83-2551-437f-8fac-dcd84b751a1d	9e90358e-7497-46a8-b21c-57b3846377df	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	3500	3500	INR	e615c690-cf3d-44cc-a366-d9ff35d4ca75	2026-05-04 12:14:35.078	\N	compute	\N	\N
df297b72-9a11-4993-8bc7-7ef912a9b437	ae95fb83-2551-437f-8fac-dcd84b751a1d	04944419-863d-4b3a-a89e-fa3e87e77c84	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	6c1fb194-2544-4739-a0b9-2ed0127827b7	2026-05-04 12:19:49.878	\N	compute	\N	\N
057f224d-f293-405e-aa43-692ceb41b085	ae95fb83-2551-437f-8fac-dcd84b751a1d	24aea730-aef0-476f-8dc4-b96743f901f8	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	f0531d67-e42d-481f-b3d4-9d7667aef92c	2026-05-04 12:21:42.36	\N	compute	\N	\N
e9e1e75d-8007-4cd4-a53d-fdaaf55f030d	ae95fb83-2551-437f-8fac-dcd84b751a1d	2a2e5950-b550-469f-a47e-7958132b6657	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	10500	10500	INR	77b7ec6b-2804-4c10-a1cd-0f227c66b3ee	2026-05-04 12:24:20.553	\N	compute	\N	\N
27751b38-94d3-40b4-9c5f-ca8f43e71883	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	10	10	INR	43db65e9-421d-4f99-a31c-73d7030224af	2026-05-04 12:30:00	\N	storage	10	0bb083a9-b83c-4dc4-87ee-844b8b75bba6
b898932a-bb07-4503-89d1-324b9e7a3e1b	ae95fb83-2551-437f-8fac-dcd84b751a1d	04944419-863d-4b3a-a89e-fa3e87e77c84	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	ff97c389-6d46-49a4-8011-fc6221a26612	2026-05-04 12:30:00.115	\N	compute	\N	\N
b37d38c9-d757-4a5b-a0da-5c265221bdaa	ae95fb83-2551-437f-8fac-dcd84b751a1d	04944419-863d-4b3a-a89e-fa3e87e77c84	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	fd4edf9f-4e28-403c-957c-bdda93091654	2026-05-04 14:05:44.767	\N	compute	\N	\N
60cba863-20ab-4c55-85b3-bc80f00093ae	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	10	10	INR	e8109429-652e-4bd7-9a2b-507c035b3db4	2026-05-04 13:30:00	\N	storage	10	0bb083a9-b83c-4dc4-87ee-844b8b75bba6
cb80f583-249f-40ba-8447-ce766fc96e07	ae95fb83-2551-437f-8fac-dcd84b751a1d	58eb9143-5c78-4bd5-b9e2-882db758ff1f	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	9ee79ab8-4054-4a58-bb12-be924f5e8065	2026-05-04 14:43:13.718	\N	compute	\N	\N
d2296013-665b-4813-86e5-87efce7b68b6	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	10	10	INR	c05de521-ed3e-4690-bfe7-f935783648ac	2026-05-04 15:30:00	\N	storage	10	da558457-599c-42ad-9aaa-e94dd64ddc58
01f0a9d6-d34a-48bd-9922-394f66328483	ae95fb83-2551-437f-8fac-dcd84b751a1d	04944419-863d-4b3a-a89e-fa3e87e77c84	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	186ffccc-aa61-44de-8e94-c4a5f1398969	2026-05-04 15:30:00.091	\N	compute	\N	\N
aa119575-401f-475c-9cfe-a0194217c406	ae95fb83-2551-437f-8fac-dcd84b751a1d	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	10500	10500	INR	39796965-c249-4655-94e9-f1468aea8c2d	2026-05-04 16:12:23.044	\N	compute	\N	\N
e0e70257-b4e7-45d6-9b05-1cea1908bc0c	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	10	10	INR	88ee03a3-bd78-47d6-a75d-3e085a458d1e	2026-05-04 16:30:00	\N	storage	10	da558457-599c-42ad-9aaa-e94dd64ddc58
037023a3-69ac-4c76-aa3d-01cffea7a373	ae95fb83-2551-437f-8fac-dcd84b751a1d	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	d7765a3d-2a4e-4ce8-93d9-b01ae04da73a	2026-05-04 16:34:50.998	\N	compute	\N	\N
f75cdcdd-5db7-4dfa-a579-73a419d21496	ae95fb83-2551-437f-8fac-dcd84b751a1d	4c7ac79c-bce6-4f29-b793-21774cbebbc2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	10500	10500	INR	fe4d7f3e-382d-44e0-a187-3fe68252f5b3	2026-05-04 16:35:44.734	\N	compute	\N	\N
e138a2ea-2ad3-474f-98de-9e6d91346320	ae95fb83-2551-437f-8fac-dcd84b751a1d	0ccd7449-8e06-45ce-94a0-7ed143546716	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	e7b2cd7f-74e7-4760-97aa-c5ab44d7a529	2026-05-04 16:37:19.461	\N	compute	\N	\N
c513245e-ee01-4d12-af0e-dc27e6635ad7	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	10	10	INR	22b7752a-6c49-4d54-8827-8e093f26ac82	2026-05-04 17:30:00	\N	storage	10	da558457-599c-42ad-9aaa-e94dd64ddc58
b5e64c2f-3802-47df-8b48-98a41bb7c775	ae95fb83-2551-437f-8fac-dcd84b751a1d	4c7ac79c-bce6-4f29-b793-21774cbebbc2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	10500	10500	INR	8b2c798c-e8e9-4b7a-a86e-35f1f7bb5cad	2026-05-04 17:38:06.871	\N	compute	\N	\N
c620cdb9-fcfe-408b-93f1-eef42e940a53	ae95fb83-2551-437f-8fac-dcd84b751a1d	0ccd7449-8e06-45ce-94a0-7ed143546716	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	b29b0c96-349c-4725-81bd-d35aa6ffcca8	2026-05-04 17:38:08.08	\N	compute	\N	\N
57175e2c-ca1b-42be-82e2-1f40da084c6a	ae95fb83-2551-437f-8fac-dcd84b751a1d	0ccd7449-8e06-45ce-94a0-7ed143546716	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	7bd08fdc-ac81-415e-9078-2fac87bad9d7	2026-05-04 23:43:18.062	\N	compute	\N	\N
28a17697-6a1c-4964-a62c-8a79d6056683	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	10	10	INR	69a4282b-adff-4be1-b4d2-6c7a219d8ade	2026-05-04 23:30:00	\N	storage	10	da558457-599c-42ad-9aaa-e94dd64ddc58
1aad4d03-8847-4fc2-a28a-7268e13c2fa6	ae95fb83-2551-437f-8fac-dcd84b751a1d	4c7ac79c-bce6-4f29-b793-21774cbebbc2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	10500	10500	INR	fca57e03-9b50-43ea-a211-b63c2d43e5f3	2026-05-04 23:43:20.015	\N	compute	\N	\N
96efe133-bf54-491a-80f4-a17c5cb6ced5	ae95fb83-2551-437f-8fac-dcd84b751a1d	0ccd7449-8e06-45ce-94a0-7ed143546716	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	15674	15500	77500	INR	4c48e83f-18a1-4e0d-a8bc-e998476fdd81	2026-05-04 23:58:34.352	\N	compute	\N	\N
97882fde-862d-4b60-a4c8-8bf955a71c84	ae95fb83-2551-437f-8fac-dcd84b751a1d	4c7ac79c-bce6-4f29-b793-21774cbebbc2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	15790	10500	52500	INR	1cb82804-2e01-46f7-a3e2-e8e371e12490	2026-05-04 23:58:55.642	\N	compute	\N	\N
dcbaaf19-2af0-47a7-8f57-be3cf71ceb21	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	10	10	INR	f20adfba-0fc0-4717-b118-5317ee59cde7	2026-05-05 00:30:00	\N	storage	10	da558457-599c-42ad-9aaa-e94dd64ddc58
bd72b50b-45c3-4d55-bbee-6f38e802d819	ae95fb83-2551-437f-8fac-dcd84b751a1d	407b2a0b-a8a7-42c7-b34b-142d57c8089e	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	e1265ac2-684f-428e-8ca7-0ee3eb89ad77	2026-05-05 01:04:19.669	\N	compute	\N	\N
637fd829-9d45-47a1-913e-58735d9bb2ac	ae95fb83-2551-437f-8fac-dcd84b751a1d	3f659e62-8075-4437-a67b-9c9f9d07502b	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	a6d60a27-ea0e-4fa0-9d3f-6f98872f5512	2026-05-05 01:06:06.319	\N	compute	\N	\N
46f9a93d-7684-4dfc-8659-6e8b21645773	ae95fb83-2551-437f-8fac-dcd84b751a1d	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	10500	10500	INR	1b25a466-9af5-402d-bd70-7d2b17012b9a	2026-05-05 01:20:39.165	\N	compute	\N	\N
5d5b888c-c0bd-4515-94d8-281ca0e2fa4d	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	10	10	INR	52d8ed4d-9985-4649-91d3-8299ba04a84f	2026-05-05 01:30:00	\N	storage	10	da558457-599c-42ad-9aaa-e94dd64ddc58
c5793862-cfc9-4214-b9de-b964ee71c4be	ae95fb83-2551-437f-8fac-dcd84b751a1d	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	10500	10500	INR	f22be9d2-d8c5-4f18-87be-2f6452dd5898	2026-05-05 01:30:00.188	\N	compute	\N	\N
5857e1d3-7d22-4b7a-b9e8-635752c0c3ce	ae95fb83-2551-437f-8fac-dcd84b751a1d	3f659e62-8075-4437-a67b-9c9f9d07502b	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	28fc589f-853c-4096-860e-0490931cd16c	2026-05-05 01:30:00.225	\N	compute	\N	\N
0aa1b94e-c89e-49cd-9fa8-7039042327b2	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	10	10	INR	638a9743-9260-4375-aa61-ddcbadde8f12	2026-05-05 02:30:00	\N	storage	10	da558457-599c-42ad-9aaa-e94dd64ddc58
e16a4676-155d-4b75-8027-bcced16dffbc	ae95fb83-2551-437f-8fac-dcd84b751a1d	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	10500	10500	INR	e20b6b87-cf46-47dc-bd4b-78797dd03a2e	2026-05-05 02:30:00.169	\N	compute	\N	\N
ed276b24-878e-4e5e-91aa-19c5fa49c84a	ae95fb83-2551-437f-8fac-dcd84b751a1d	3f659e62-8075-4437-a67b-9c9f9d07502b	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	d38164e0-3370-4ef6-bf64-776f567998b3	2026-05-05 02:30:00.202	\N	compute	\N	\N
e382c9e5-1113-44f4-9d59-7f65c9c7d0ac	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	10	10	INR	394eb5ac-9e48-4dba-a12f-e4036b73693c	2026-05-05 03:30:00	\N	storage	10	da558457-599c-42ad-9aaa-e94dd64ddc58
57878f77-33cd-4bad-9659-e7a1b4160427	ae95fb83-2551-437f-8fac-dcd84b751a1d	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	10500	10500	INR	ff5f6cf7-8b32-469c-834b-c3e331c0182c	2026-05-05 03:30:00.15	\N	compute	\N	\N
919d9540-8b13-4794-9d54-b977bd6fc374	ae95fb83-2551-437f-8fac-dcd84b751a1d	3f659e62-8075-4437-a67b-9c9f9d07502b	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	71e007b9-1a65-47c9-8cb7-e657587291f6	2026-05-05 03:30:00.18	\N	compute	\N	\N
5324e315-6e8d-4e8d-ab72-20d9de649d2c	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	10	10	INR	c2671cdd-f008-46fb-a408-1a85e7a66717	2026-05-05 04:30:00	\N	storage	10	da558457-599c-42ad-9aaa-e94dd64ddc58
0faee8c4-0745-4776-9a0d-50f133d5f4a7	ae95fb83-2551-437f-8fac-dcd84b751a1d	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	10500	10500	INR	2fb8c1fd-ee51-4d39-8441-a4ce53496b29	2026-05-05 04:38:46.291	\N	compute	\N	\N
bd39ca99-f6fe-48d7-a5ea-4498e076ec4c	ae95fb83-2551-437f-8fac-dcd84b751a1d	3f659e62-8075-4437-a67b-9c9f9d07502b	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	f3b9be4c-2d9f-43f6-824f-3e2396ce0ca7	2026-05-05 04:38:47.306	\N	compute	\N	\N
1ed15325-0829-44ae-824a-40872efd0efb	ae95fb83-2551-437f-8fac-dcd84b751a1d	f4ebd53c-e856-43d6-b735-f72c0999c56b	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	134ce8df-4d43-416d-ace6-f3554d79fb9e	2026-05-05 05:14:50.827	\N	compute	\N	\N
1285774c-5c52-4868-9f4e-df951e7a3d8f	ae95fb83-2551-437f-8fac-dcd84b751a1d	50003a90-973a-4998-b722-4e75c934f5d3	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	e779d4dc-2080-45e6-b544-96db838bad7c	2026-05-05 05:15:51.226	\N	compute	\N	\N
37aaa669-dfd7-4264-9e4e-86c2e08e2a4f	ae95fb83-2551-437f-8fac-dcd84b751a1d	21e006dd-20c2-4e16-8032-42a267f1084f	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	14b64e17-f6a9-4a4b-bde6-1e72811c4a80	2026-05-05 05:17:12.017	\N	compute	\N	\N
d1bddf8d-408e-4821-b1a2-a73ee9f807e1	ae95fb83-2551-437f-8fac-dcd84b751a1d	d95f2adf-135b-420e-b3ff-fc150228ded8	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	684f43c0-9af5-434e-b6a5-67cce89474fe	2026-05-05 05:17:58.025	\N	compute	\N	\N
06aeccf8-3259-4baa-a717-70492a01cef8	ae95fb83-2551-437f-8fac-dcd84b751a1d	49b75056-41c8-4ea7-8d06-7292d3a1bff9	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	982547d8-aab5-49a9-8d58-367f31534d80	2026-05-05 05:18:32.908	\N	compute	\N	\N
718e6017-d991-482a-94b8-2880673cf2fa	ae95fb83-2551-437f-8fac-dcd84b751a1d	22354ffb-9b8e-4851-b4c2-66b44b328eb3	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	10500	10500	INR	30c65e5e-e51f-4852-8e3e-08f945a61dce	2026-05-05 05:21:00.306	\N	compute	\N	\N
9cd39ea1-dc21-4a83-a8e1-ccf291861bdb	ae95fb83-2551-437f-8fac-dcd84b751a1d	49b75056-41c8-4ea7-8d06-7292d3a1bff9	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	cad54813-4e4d-4cbc-90f8-a780470e8118	2026-05-05 05:30:00.083	\N	compute	\N	\N
295ceb2e-978e-4feb-b7d1-164d716c73be	ae95fb83-2551-437f-8fac-dcd84b751a1d	22354ffb-9b8e-4851-b4c2-66b44b328eb3	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	10500	10500	INR	3dc7ec26-eed9-42aa-9cab-7d7afb90cd9b	2026-05-05 05:30:00.125	\N	compute	\N	\N
46be8d1a-cc6b-4454-b845-65828308cc53	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	10	10	INR	69d7040b-fc8d-441e-a8c4-35d23bd70091	2026-05-05 05:30:00	\N	storage	10	82cc3fb0-b6ad-4adc-91ef-caaabe772f8b
57be8e76-d72e-42d2-b94d-ad0220c93d41	ae95fb83-2551-437f-8fac-dcd84b751a1d	748e1240-b6ff-40ea-8fe6-35093a4088a9	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	58d64369-edec-4175-9b12-1161edda27b8	2026-05-05 06:15:04.574	\N	compute	\N	\N
4a64b887-1368-4e35-84c0-78b84786859e	ae95fb83-2551-437f-8fac-dcd84b751a1d	aee03291-4ca9-4613-a396-de0251fe57bf	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	3500	3500	INR	238da00c-5611-4380-994b-e9e1c0695465	2026-05-05 06:15:41.057	\N	compute	\N	\N
a5cae416-3dd8-4f75-ab6a-cf8892f57cfe	ae95fb83-2551-437f-8fac-dcd84b751a1d	2d87be54-82ea-4d73-9128-262be3f3dddd	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	10500	10500	INR	525b4d83-e686-4baa-a44f-0d46ad78461c	2026-05-05 06:29:20.133	\N	compute	\N	\N
e6545061-8c9b-4df4-bc7c-8c2c72cb0ad4	ae95fb83-2551-437f-8fac-dcd84b751a1d	2d87be54-82ea-4d73-9128-262be3f3dddd	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	10500	10500	INR	744d5e88-bfe7-4b57-ac79-6bbd31900da3	2026-05-05 06:30:00.055	\N	compute	\N	\N
be7f5ff1-fefa-4ea0-9c7d-e98115a4900b	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	9	9	INR	0b914891-76b9-4527-bd41-7c9e31108340	2026-05-05 06:30:00	\N	storage	9	8d76221d-e9fb-4cc0-8f8f-ab2fada926cc
650fcf74-90ed-4227-8cd2-ea3ed898f398	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	9	9	INR	2d82f3b3-2430-48fa-a29e-cb1fdc79a972	2026-05-05 07:30:00	\N	storage	9	8d76221d-e9fb-4cc0-8f8f-ab2fada926cc
f5ad29a4-d591-4031-a1b8-726a21b5e14e	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	9	9	INR	674b95ba-7a0d-4a69-987c-2f35d160e023	2026-05-05 08:30:00	\N	storage	9	8d76221d-e9fb-4cc0-8f8f-ab2fada926cc
45ff7e6f-d4dd-43a2-91c3-c6d682c4bc74	ae95fb83-2551-437f-8fac-dcd84b751a1d	a3673281-5fd2-4636-b0d9-58f475e0f82b	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	15500	15500	INR	2b0a1138-d5d8-40fe-bf1e-2c9624fb22a3	2026-05-05 08:41:20.127	\N	compute	\N	\N
d53b83ce-d147-491f-ace5-b788582d5d88	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	9	9	INR	3199924e-f216-4382-96bf-ea9d4915f95d	2026-05-05 09:30:00	\N	storage	9	8d76221d-e9fb-4cc0-8f8f-ab2fada926cc
f4fe6bbc-9e1a-4244-9eb3-9dbddda3e06b	ae95fb83-2551-437f-8fac-dcd84b751a1d	c676954a-51a2-44b7-b923-534534f320f7	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	3500	3500	INR	0dc0e93c-55eb-422f-892c-f08999c214f3	2026-05-05 10:09:13.816	\N	compute	\N	\N
3fb36632-9e9b-47e6-8f86-c0455ae2b855	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	9	9	INR	40e58325-878e-4e02-a0fd-eb5533219a69	2026-05-05 10:30:00	\N	storage	9	8d76221d-e9fb-4cc0-8f8f-ab2fada926cc
9a1d0669-c95c-4ef3-a818-0136916f9933	ae95fb83-2551-437f-8fac-dcd84b751a1d	c676954a-51a2-44b7-b923-534534f320f7	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	3500	3500	INR	30f235d9-bb6b-45af-aea8-5c231e500687	2026-05-05 10:30:00.196	\N	compute	\N	\N
24f23be3-e375-4854-b3ed-306653da5a6a	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	9	9	INR	a6513cda-666a-4ac6-aa2f-5b059d899d98	2026-05-05 11:30:00	\N	storage	9	8d76221d-e9fb-4cc0-8f8f-ab2fada926cc
77ed4130-9060-4b08-be16-706cb9dac171	ae95fb83-2551-437f-8fac-dcd84b751a1d	c676954a-51a2-44b7-b923-534534f320f7	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	3500	3500	INR	b8f7c9f2-57ab-419f-bc02-29115135d50d	2026-05-05 11:30:00.211	\N	compute	\N	\N
0e3dd5d9-382b-49e7-b75d-59f769c1b687	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	9	9	INR	936b28ad-5818-47c8-b2e4-da2b09de02d5	2026-05-05 12:30:00	\N	storage	9	8d76221d-e9fb-4cc0-8f8f-ab2fada926cc
387ea3d9-b4b6-4742-9df4-5b452ff9599f	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	9	9	INR	91ce5761-96bb-4f92-bb5d-2c665d3f9269	2026-05-05 13:30:00	\N	storage	9	8d76221d-e9fb-4cc0-8f8f-ab2fada926cc
00ca563a-5582-4815-8b2c-7bcc7d2930a8	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	9	9	INR	9f892c0a-0c85-4d90-8181-2c994d9b5d80	2026-05-05 14:30:00	\N	storage	9	8d76221d-e9fb-4cc0-8f8f-ab2fada926cc
9398e67e-6406-4dae-933f-f53ced6eedd0	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	9	9	INR	ee4e28da-e998-4365-802b-bf2c0b08dd9e	2026-05-05 15:30:00	\N	storage	9	8d76221d-e9fb-4cc0-8f8f-ab2fada926cc
a6f0b850-a3eb-43f3-93a9-4529e37d44bf	ae95fb83-2551-437f-8fac-dcd84b751a1d	ec3f0ced-027a-4e05-bc13-4eee83a759a0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	3500	3500	INR	f0b3f429-9a94-4c02-bbcc-1615249f3ee6	2026-05-05 15:35:11.024	\N	compute	\N	\N
d6816757-9f0f-4539-b00a-4ce36b22aa73	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	9	9	INR	dfbc0496-5d1c-4fbe-b15d-bca41b2e7b8e	2026-05-05 16:30:00	\N	storage	9	8d76221d-e9fb-4cc0-8f8f-ab2fada926cc
5cf90690-a921-4b88-a002-3031223bd16a	ae95fb83-2551-437f-8fac-dcd84b751a1d	ec3f0ced-027a-4e05-bc13-4eee83a759a0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	3500	3500	INR	70a658c9-80bb-4662-9765-9ab2a55a59d9	2026-05-05 16:30:00.053	\N	compute	\N	\N
b0c11599-ee6d-42d5-8c2a-e1a3db1d40ea	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	3600	9	9	INR	61e01778-5da6-4621-bf6c-2918b580448e	2026-05-05 17:30:00	\N	storage	9	8d76221d-e9fb-4cc0-8f8f-ab2fada926cc
3bdfcc8b-f570-4a1d-896b-fb3c28da8658	ae95fb83-2551-437f-8fac-dcd84b751a1d	ec3f0ced-027a-4e05-bc13-4eee83a759a0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	3500	3500	INR	50ad8c8c-99c0-4f3f-b829-f5b98f4e0090	2026-05-05 17:30:00.087	\N	compute	\N	\N
\.


--
-- TOC entry 6017 (class 0 OID 118639)
-- Dependencies: 245
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (id, user_id, organization_id, compute_config_id, node_id, required_vcpu, required_memory_mb, required_gpu_vram_mb, scheduled_start_at, scheduled_end_at, status, cancellation_reason, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6016 (class 0 OID 118627)
-- Dependencies: 244
-- Data for Name: compute_config_access; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compute_config_access (id, compute_config_id, organization_id, role_id, is_allowed, price_override_cents, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6015 (class 0 OID 118600)
-- Dependencies: 243
-- Data for Name: compute_configs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compute_configs (id, slug, name, description, session_type, tier, vcpu, memory_mb, gpu_vram_mb, gpu_exclusive, hami_sm_percent, base_price_per_hour_cents, currency, sort_order, is_active, created_at, updated_at, created_by, updated_by, best_for, gpu_model, max_concurrent_per_node) FROM stdin;
d2fb06af-8256-4105-812b-05a10cbe99a1	spark	Spark	Entry-level GPU compute for learning, light inference, and small experiments.	stateful_desktop	gpu	2	4096	2048	f	8	3500	INR	1	t	2026-04-08 01:52:11.975	2026-04-08 10:30:07.831	\N	\N	Small PyTorch inference, Jupyter notebooks with CUDA, educational projects	RTX 4090	8
46756643-41f5-4eb1-a161-d5b595b4e0c8	blaze	Blaze	Standard GPU compute for development, moderate ML training, and data science.	stateful_desktop	gpu	4	8192	4096	f	17	6500	INR	2	t	2026-04-08 01:52:11.994	2026-04-08 10:30:07.841	\N	\N	Model fine-tuning, GPU-accelerated rendering, professional development	RTX 4090	4
73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	inferno	Inferno	Advanced GPU compute for heavy ML training, 3D rendering, and simulations.	stateful_desktop	gpu	8	16384	8192	f	33	10500	INR	3	t	2026-04-08 01:52:11.998	2026-04-08 10:30:07.846	\N	\N	Large model training, complex 3D rendering, GPU-intensive simulations	RTX 4090	2
28a49cc2-a6c4-4387-a93f-9d48c153bb6e	supernova	Supernova	Premium GPU compute with near-exclusive access for research and large-scale workloads.	stateful_desktop	gpu-exclusive	12	32768	16384	f	67	15500	INR	4	t	2026-04-08 01:52:12.005	2026-04-08 10:30:07.851	\N	\N	Large-scale deep learning, exclusive research sessions, production inference	RTX 4090	1
\.


--
-- TOC entry 6033 (class 0 OID 118920)
-- Dependencies: 261
-- Data for Name: course_enrollments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_enrollments (id, course_id, user_id, status, enrolled_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6032 (class 0 OID 118904)
-- Dependencies: 260
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (id, organization_id, department_id, instructor_id, title, code, description, semester, academic_year, status, default_compute_config_id, max_students, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6039 (class 0 OID 119012)
-- Dependencies: 267
-- Data for Name: coursework_content; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coursework_content (id, organization_id, category, title, description, content_url, thumbnail_url, difficulty_level, tags, is_featured, view_count, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6023 (class 0 OID 118739)
-- Dependencies: 251
-- Data for Name: credit_packages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.credit_packages (id, name, amount_cents, credit_cents, bonus_cents, validity_days, is_active, sort_order, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6004 (class 0 OID 118433)
-- Dependencies: 232
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (id, university_id, parent_id, name, code, slug, head_user_id, is_active, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6045 (class 0 OID 119118)
-- Dependencies: 273
-- Data for Name: discussion_replies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discussion_replies (id, discussion_id, parent_reply_id, author_id, body, is_accepted_answer, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6044 (class 0 OID 119098)
-- Dependencies: 272
-- Data for Name: discussions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discussions (id, organization_id, course_id, lab_id, author_id, title, body, is_pinned, is_locked, reply_count, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6054 (class 0 OID 119253)
-- Dependencies: 282
-- Data for Name: feature_flags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feature_flags (id, key, enabled, rollout_percent, allowed_org_ids, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6031 (class 0 OID 118889)
-- Dependencies: 259
-- Data for Name: invoice_line_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice_line_items (id, invoice_id, description, quantity, unit_price_cents, total_cents, reference_type, reference_id, created_at) FROM stdin;
63a965cd-6894-4637-afa6-9262e4cfc037	b02ab0fe-4503-411d-9aad-044f3f11554f	Credit Recharge	1	50000	50000	payment_transaction	90a5eac3-9446-4b76-a73e-d730df921073	2026-05-04 07:41:59.614
b83ef7ae-eb20-47c7-9088-b845822770a0	8faa99ed-bd3e-4cf0-b4c1-a3dc54bceaa9	Credit Recharge	1	100000	100000	payment_transaction	09220e4c-97b1-44eb-bd23-f6bfd4df4672	2026-05-04 08:24:01.211
1a044d6f-6733-4fe2-afa0-b243d2aff3a7	ad092414-ed05-497e-8a24-f67cd3489e8b	Credit Recharge	1	100000	100000	payment_transaction	a117b47c-29b6-4816-ad6c-d098c1371488	2026-05-04 09:19:19.299
2431f2bb-a6e8-4fc4-8614-382996116ac6	57c16d24-e47c-4eea-a417-4668cfc3845b	Credit Recharge	1	100000	100000	payment_transaction	03485faa-865c-45fe-bb28-82ef2748bdd6	2026-05-04 09:30:15.558
14f446f6-94b7-40c8-9796-6565805ebe4b	85d3baed-d05f-423d-ab48-edc85e005975	Credit Recharge	1	100000	100000	payment_transaction	c300a59c-feaa-4369-a937-3d611c34ec67	2026-05-04 14:59:40.167
d2501428-8b09-4036-b575-70f2d007b815	d5732396-9d8e-4b9f-bd20-15aa753f44fd	Credit Recharge	1	100000	100000	payment_transaction	77f56d9a-5031-41fa-b903-8fc2f2e09db5	2026-05-04 15:00:09.162
f56621c8-115e-49d9-9462-15e9da695a72	da7f4e2b-4ade-4194-939b-76996b4e4ac6	Credit Recharge	1	100000	100000	payment_transaction	222ed01f-b5c2-4beb-82df-22c496e9dc20	2026-05-04 23:59:54.672
2a4a8eb2-b0f9-474a-a8db-43a6a321d83f	04d607e8-1318-472e-9772-ef624ef484c9	Credit Recharge	1	100000	100000	payment_transaction	9b46e2ac-ecd1-4209-99f0-e5e73c77c477	2026-05-05 00:00:40.767
e6e7f4d7-66a1-4c37-be8e-1e163a808a4a	e9ff8cdf-b63e-4746-9ccb-68e0e8fc686b	Credit Recharge	1	100000	100000	payment_transaction	39806bef-b4b7-4787-a42c-e06193df42f2	2026-05-05 05:19:34.89
a9c33d70-3096-422e-95e0-5e6df5dd0845	2762b784-043a-4e44-974b-74c43a6422ca	Credit Recharge	1	100000	100000	payment_transaction	06b4c4a4-d419-4a01-be43-c0e2da4c079d	2026-05-05 05:20:06.123
\.


--
-- TOC entry 6030 (class 0 OID 118867)
-- Dependencies: 258
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoices (id, user_id, organization_id, invoice_number, period_start, period_end, subtotal_cents, tax_cents, total_cents, currency, status, issued_at, paid_at, pdf_url, created_at, updated_at, created_by, updated_by) FROM stdin;
b02ab0fe-4503-411d-9aad-044f3f11554f	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	INV-20260504-2916A7	2026-05-04 07:41:59.597	2026-05-04 07:41:59.597	50000	0	50000	INR	paid	2026-05-04 07:41:59.597	2026-05-04 07:41:59.597	\N	2026-05-04 07:41:59.611	2026-05-04 07:41:59.611	\N	\N
8faa99ed-bd3e-4cf0-b4c1-a3dc54bceaa9	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389	\N	INV-20260504-1F4F80	2026-05-04 08:24:01.196	2026-05-04 08:24:01.196	100000	0	100000	INR	paid	2026-05-04 08:24:01.196	2026-05-04 08:24:01.196	\N	2026-05-04 08:24:01.207	2026-05-04 08:24:01.207	\N	\N
ad092414-ed05-497e-8a24-f67cd3489e8b	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	INV-20260504-438DAE	2026-05-04 09:19:19.279	2026-05-04 09:19:19.279	100000	0	100000	INR	paid	2026-05-04 09:19:19.279	2026-05-04 09:19:19.279	\N	2026-05-04 09:19:19.295	2026-05-04 09:19:19.295	\N	\N
57c16d24-e47c-4eea-a417-4668cfc3845b	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	INV-20260504-11B0F9	2026-05-04 09:30:15.546	2026-05-04 09:30:15.546	100000	0	100000	INR	paid	2026-05-04 09:30:15.546	2026-05-04 09:30:15.546	\N	2026-05-04 09:30:15.556	2026-05-04 09:30:15.556	\N	\N
85d3baed-d05f-423d-ab48-edc85e005975	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	INV-20260504-AB50B6	2026-05-04 14:59:40.138	2026-05-04 14:59:40.138	100000	0	100000	INR	paid	2026-05-04 14:59:40.138	2026-05-04 14:59:40.138	\N	2026-05-04 14:59:40.157	2026-05-04 14:59:40.157	\N	\N
d5732396-9d8e-4b9f-bd20-15aa753f44fd	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	INV-20260504-F2F66A	2026-05-04 15:00:09.143	2026-05-04 15:00:09.143	100000	0	100000	INR	paid	2026-05-04 15:00:09.143	2026-05-04 15:00:09.143	\N	2026-05-04 15:00:09.159	2026-05-04 15:00:09.159	\N	\N
da7f4e2b-4ade-4194-939b-76996b4e4ac6	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	INV-20260504-AAD542	2026-05-04 23:59:54.628	2026-05-04 23:59:54.628	100000	0	100000	INR	paid	2026-05-04 23:59:54.628	2026-05-04 23:59:54.628	\N	2026-05-04 23:59:54.664	2026-05-04 23:59:54.664	\N	\N
04d607e8-1318-472e-9772-ef624ef484c9	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	INV-20260505-6F24DC	2026-05-05 00:00:40.703	2026-05-05 00:00:40.703	100000	0	100000	INR	paid	2026-05-05 00:00:40.703	2026-05-05 00:00:40.703	\N	2026-05-05 00:00:40.758	2026-05-05 00:00:40.758	\N	\N
e9ff8cdf-b63e-4746-9ccb-68e0e8fc686b	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	INV-20260505-3E4C15	2026-05-05 05:19:34.867	2026-05-05 05:19:34.867	100000	0	100000	INR	paid	2026-05-05 05:19:34.867	2026-05-05 05:19:34.867	\N	2026-05-05 05:19:34.884	2026-05-05 05:19:34.884	\N	\N
2762b784-043a-4e44-974b-74c43a6422ca	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	INV-20260505-E45D16	2026-05-05 05:20:06.105	2026-05-05 05:20:06.105	100000	0	100000	INR	paid	2026-05-05 05:20:06.105	2026-05-05 05:20:06.105	\N	2026-05-05 05:20:06.12	2026-05-05 05:20:06.12	\N	\N
\.


--
-- TOC entry 6036 (class 0 OID 118961)
-- Dependencies: 264
-- Data for Name: lab_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_assignments (id, lab_id, title, description, instructions, due_at, max_score, allow_late_submission, late_penalty_percent, max_attempts, rubric, sort_order, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6038 (class 0 OID 118999)
-- Dependencies: 266
-- Data for Name: lab_grades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_grades (id, submission_id, graded_by, score, max_score, feedback, rubric_scores, graded_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6035 (class 0 OID 118949)
-- Dependencies: 263
-- Data for Name: lab_group_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_group_assignments (id, lab_id, user_group_id, assigned_by, available_from, available_until, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6037 (class 0 OID 118983)
-- Dependencies: 265
-- Data for Name: lab_submissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_submissions (id, lab_assignment_id, user_id, session_id, attempt_number, status, submitted_at, file_ids, notes, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6034 (class 0 OID 118933)
-- Dependencies: 262
-- Data for Name: labs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.labs (id, course_id, organization_id, created_by_user_id, title, description, instructions, compute_config_id, base_image_id, preloaded_notebook_url, preloaded_dataset_urls, max_duration_minutes, status, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 5996 (class 0 OID 118098)
-- Dependencies: 224
-- Data for Name: login_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login_history (login_method, ip_address, user_agent, "geoLocation", success, failure_reason, created_at, created_by, id, user_id) FROM stdin;
oauth	127.0.0.1	\N	\N	t	\N	2026-05-04 07:40:55.92	\N	206ef67f-c5cb-453c-93aa-64b2fe8f722c	ae95fb83-2551-437f-8fac-dcd84b751a1d
oauth	127.0.0.1	\N	\N	t	\N	2026-05-04 07:50:41.365	\N	3dfeee0c-bb07-482d-91ca-5860fb0bed16	ae95fb83-2551-437f-8fac-dcd84b751a1d
oauth	127.0.0.1	\N	\N	t	\N	2026-05-04 08:23:13.455	\N	b85b3962-28f4-4f69-b661-7e30657cccfa	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389
oauth	127.0.0.1	\N	\N	t	\N	2026-05-04 08:26:53.086	\N	2327fc8f-2036-4105-a1fa-05473bcba820	ae95fb83-2551-437f-8fac-dcd84b751a1d
oauth	127.0.0.1	\N	\N	t	\N	2026-05-04 08:27:26.822	\N	31aa327d-2868-4747-8637-4fc572855e64	ae95fb83-2551-437f-8fac-dcd84b751a1d
oauth	127.0.0.1	\N	\N	t	\N	2026-05-04 08:27:36.61	\N	dcb0c6d9-65fb-4bb9-b83f-4f6397a617fe	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389
oauth	127.0.0.1	\N	\N	t	\N	2026-05-04 08:58:39.994	\N	a0dca386-1afd-41ff-a553-992f927bf2c0	ae95fb83-2551-437f-8fac-dcd84b751a1d
oauth	127.0.0.1	\N	\N	t	\N	2026-05-04 10:50:06.477	\N	344e79e7-ab60-4c83-8e07-cca7710c9c31	ae95fb83-2551-437f-8fac-dcd84b751a1d
oauth	127.0.0.1	\N	\N	t	\N	2026-05-04 11:02:45.707	\N	5656a768-a62e-4d28-91fa-b0434ec7f263	ae95fb83-2551-437f-8fac-dcd84b751a1d
oauth	127.0.0.1	\N	\N	t	\N	2026-05-04 14:36:37.281	\N	02d1dc59-d29b-45e5-bf45-1c66d078f47f	ae95fb83-2551-437f-8fac-dcd84b751a1d
oauth	127.0.0.1	\N	\N	t	\N	2026-05-04 16:33:44.039	\N	cb7c945c-7f9e-4572-a60b-e0d5b68b65ed	ae95fb83-2551-437f-8fac-dcd84b751a1d
oauth	127.0.0.1	\N	\N	t	\N	2026-05-04 23:57:39.902	\N	2f224076-345e-4311-b284-f17af0152d29	ae95fb83-2551-437f-8fac-dcd84b751a1d
oauth	127.0.0.1	\N	\N	t	\N	2026-05-05 05:11:30.688	\N	28a47baa-efcd-40ce-98c5-162a440d6784	ae95fb83-2551-437f-8fac-dcd84b751a1d
oauth	127.0.0.1	\N	\N	t	\N	2026-05-05 07:18:40.561	\N	eacad89b-7874-4252-ac10-9a297ec7e27d	ae95fb83-2551-437f-8fac-dcd84b751a1d
oauth	127.0.0.1	\N	\N	t	\N	2026-05-05 12:09:46.468	\N	aa30fb33-3b53-47ed-8995-0ea9d78d99ff	ae95fb83-2551-437f-8fac-dcd84b751a1d
oauth	127.0.0.1	\N	\N	t	\N	2026-05-05 13:08:03.119	\N	0d224ee0-449e-4d00-97e7-98652a3efa39	ae95fb83-2551-437f-8fac-dcd84b751a1d
oauth	127.0.0.1	\N	\N	t	\N	2026-05-05 15:34:33.176	\N	ac30ae31-ef2a-4853-8598-b1fddf279345	ae95fb83-2551-437f-8fac-dcd84b751a1d
\.


--
-- TOC entry 6041 (class 0 OID 119051)
-- Dependencies: 269
-- Data for Name: mentor_availability_slots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_availability_slots (id, mentor_profile_id, day_of_week, specific_date, start_time, end_time, is_recurring, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6042 (class 0 OID 119067)
-- Dependencies: 270
-- Data for Name: mentor_bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_bookings (id, mentor_profile_id, student_user_id, scheduled_at, duration_minutes, status, meeting_url, payment_transaction_id, amount_cents, notes, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6040 (class 0 OID 119029)
-- Dependencies: 268
-- Data for Name: mentor_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_profiles (id, user_id, headline, bio, expertise_areas, experience_years, price_per_hour_cents, currency, is_available, avg_rating, total_reviews, total_sessions, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6043 (class 0 OID 119084)
-- Dependencies: 271
-- Data for Name: mentor_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_reviews (id, mentor_booking_id, reviewer_user_id, rating, review_text, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6014 (class 0 OID 118587)
-- Dependencies: 242
-- Data for Name: node_base_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.node_base_images (node_id, base_image_id, status, pulled_at, error_message, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6060 (class 0 OID 120169)
-- Dependencies: 288
-- Data for Name: node_resource_reservations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.node_resource_reservations (id, node_id, session_id, reserved_vcpu, reserved_memory_mb, reserved_gpu_vram_mb, reserved_hami_sm_percent, reserved_at, released_at, status, created_at, updated_at) FROM stdin;
cbe153d9-5182-4dc2-86e8-1f62b822bfc4	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	ec3f0ced-027a-4e05-bc13-4eee83a759a0	2	4096	2048	8	2026-05-05 15:34:49.194	\N	reserved	2026-05-05 15:34:49.194	2026-05-05 15:34:49.194
4e949368-a716-448f-8aec-7dc1907c899a	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	6c5b8d4d-2827-4e05-b551-bd397301b575	12	32768	16384	67	2026-05-04 08:25:08.4	2026-05-04 08:25:08.448	released	2026-05-04 08:25:08.4	2026-05-04 08:25:08.452
1d2a4927-e624-4071-a8e5-9a7c874ef0db	c9868115-ff99-403c-8e87-06124ba7df66	f3345614-394f-49e8-99e1-30804f314627	12	32768	16384	67	2026-05-04 08:03:53.83	2026-05-04 08:27:01.172	released	2026-05-04 08:03:53.83	2026-05-04 08:27:01.177
69840751-b824-466a-8cd2-9fc5c5f875da	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	ae38510e-ab6b-408c-b1be-eac0988fbc93	12	32768	16384	67	2026-05-04 08:59:14.371	2026-05-04 08:59:14.428	released	2026-05-04 08:59:14.371	2026-05-04 08:59:14.434
d28c17e1-f658-4b65-9dee-b0250cfa96ea	c9868115-ff99-403c-8e87-06124ba7df66	58582e3f-f8bd-4147-b9ed-38a510ceb745	2	4096	2048	8	2026-05-04 09:01:29.586	2026-05-04 09:03:28.707	released	2026-05-04 09:01:29.586	2026-05-04 09:03:28.715
fc09272f-c3be-459f-900b-0f78db00a3ab	c9868115-ff99-403c-8e87-06124ba7df66	892af945-7115-46cb-885e-2f44d9988218	8	16384	8192	33	2026-05-04 09:03:40.741	2026-05-04 09:16:20.633	released	2026-05-04 09:03:40.741	2026-05-04 09:16:20.643
d86f1b96-c66c-43b4-91c8-b3ca0d886cd0	c9868115-ff99-403c-8e87-06124ba7df66	68dd70a4-c61f-4fb1-85a4-9939e4643493	12	32768	16384	67	2026-05-04 09:16:35.143	2026-05-04 09:27:57.704	released	2026-05-04 09:16:35.143	2026-05-04 09:27:57.711
be1f4f28-512f-43b2-ab2a-007fbcac28d1	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	79446928-3d68-4633-ae84-6febe94609fc	12	32768	16384	67	2026-05-04 09:19:36.33	2026-05-04 09:29:17.702	released	2026-05-04 09:19:36.33	2026-05-04 09:29:17.708
0e94c04c-b0a0-4f23-947e-6d9a63374015	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	2bf80869-f34a-44dd-88c6-9d70dcbe6522	12	32768	16384	67	2026-05-04 09:33:16.879	2026-05-04 09:33:16.915	released	2026-05-04 09:33:16.879	2026-05-04 09:33:16.919
536be3c9-aa59-408e-9c52-0e1b21794892	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	e8abcaec-ced4-4ad3-802c-e426049aa03a	12	32768	16384	67	2026-05-04 10:13:58.588	2026-05-04 10:14:00.764	released	2026-05-04 10:13:58.588	2026-05-04 10:14:00.77
198e1bcb-f879-425b-9b1a-e1edfa29fe63	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	c981876b-8aab-49ce-95c2-718f19c1180d	12	32768	16384	67	2026-05-04 10:27:36.305	2026-05-04 10:27:38.421	released	2026-05-04 10:27:36.305	2026-05-04 10:27:38.425
12c97990-cc05-4161-ad2a-99a891f8848e	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	e361492d-7c2b-4e11-8e45-79fb1fe9085b	12	32768	16384	67	2026-05-04 10:32:09.769	2026-05-04 10:32:11.877	released	2026-05-04 10:32:09.769	2026-05-04 10:32:11.881
868e89f3-b6c1-46bf-a578-888d04b3810e	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	c356bb92-018c-421b-bbab-41b4817bac74	12	32768	16384	67	2026-05-04 10:38:58.183	2026-05-04 10:39:00.406	released	2026-05-04 10:38:58.183	2026-05-04 10:39:00.413
d4f58a5c-3d6c-4fa1-8530-420fb9610ac2	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	81c1ac01-1b20-445a-90f1-2cec8796087b	12	32768	16384	67	2026-05-04 10:50:18.014	2026-05-04 10:50:20.133	released	2026-05-04 10:50:18.014	2026-05-04 10:50:20.138
7071128b-7f6b-4914-87bf-37874d2923da	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	5abe4167-7866-4fb9-ab65-0a536167658b	12	32768	16384	67	2026-05-04 10:54:37.233	2026-05-04 11:00:20.893	released	2026-05-04 10:54:37.233	2026-05-04 11:00:20.901
89916c64-ef90-4922-ab0d-43e7d640aec9	c9868115-ff99-403c-8e87-06124ba7df66	1df95352-8d8e-4ba9-874d-5380c3902827	12	32768	16384	67	2026-05-04 09:31:03.232	2026-05-04 11:20:23.27	released	2026-05-04 09:31:03.232	2026-05-04 11:20:23.281
5a68632e-d56c-4791-b7b8-c9b3f5bc3c6a	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	12	32768	16384	67	2026-05-04 11:00:41.699	2026-05-04 11:20:35.226	released	2026-05-04 11:00:41.699	2026-05-04 11:20:35.23
6afdf792-d0e2-4e8b-9882-7cd066e47006	c9868115-ff99-403c-8e87-06124ba7df66	e0688d0b-1645-4bae-a644-7a408007f2d8	8	16384	8192	33	2026-05-04 11:20:55.101	2026-05-04 11:22:48.51	released	2026-05-04 11:20:55.101	2026-05-04 11:22:48.515
9ad7f59f-af2d-480d-a48f-9b72f45b90da	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	9e90358e-7497-46a8-b21c-57b3846377df	2	4096	2048	8	2026-05-04 12:14:12.732	2026-05-04 12:18:54.671	released	2026-05-04 12:14:12.732	2026-05-04 12:18:54.678
1149b156-66f5-4dac-91ec-a6a7cc0a1f98	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	97c1e395-d713-4755-a94d-98f161d50f4c	12	32768	16384	67	2026-05-04 12:20:26.392	2026-05-04 12:20:28.481	released	2026-05-04 12:20:26.392	2026-05-04 12:20:28.485
61150da2-9e05-4aed-80b8-8a19bd64dffa	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	24aea730-aef0-476f-8dc4-b96743f901f8	12	32768	16384	67	2026-05-04 12:21:22.071	2026-05-04 12:23:24.576	released	2026-05-04 12:21:22.071	2026-05-04 12:23:24.585
7722756d-cf91-4435-ac2b-7d46bc56321e	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	2a2e5950-b550-469f-a47e-7958132b6657	8	16384	8192	33	2026-05-04 12:24:02.238	2026-05-04 12:26:26.834	released	2026-05-04 12:24:02.238	2026-05-04 12:26:26.844
1a816bbf-78f5-4cb5-8f42-4f945083fceb	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	58eb9143-5c78-4bd5-b9e2-882db758ff1f	12	32768	16384	67	2026-05-04 14:42:50.747	2026-05-04 14:43:58.877	released	2026-05-04 14:42:50.747	2026-05-04 14:43:58.887
b6b21490-6f13-4557-afb0-1ac0d1cd2e49	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	01c999aa-fb37-4f3b-aac3-d0e7c30a3f94	8	16384	8192	33	2026-05-04 15:01:19.122	2026-05-04 15:01:21.308	released	2026-05-04 15:01:19.122	2026-05-04 15:01:21.317
d6106f3d-1dbe-4217-95f6-35bbd863e067	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	3c8cf962-2d36-4672-9268-910b6870e188	12	32768	16384	67	2026-05-04 15:29:25.859	2026-05-04 15:29:28.042	released	2026-05-04 15:29:25.859	2026-05-04 15:29:28.05
b31004f7-7d60-4b07-9a46-157c5a5a61c8	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	87393c22-0a61-4707-8816-8e36f854eb5d	8	16384	8192	33	2026-05-04 15:37:59.789	2026-05-04 15:38:01.974	released	2026-05-04 15:37:59.789	2026-05-04 15:38:01.981
be61fafc-0653-49e2-b14e-5f1e512db3a4	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	4a90a7ed-d8db-4284-ab65-d2a9918206bb	12	32768	16384	67	2026-05-04 15:43:08.988	2026-05-04 15:43:11.167	released	2026-05-04 15:43:08.988	2026-05-04 15:43:11.174
0ae361de-be08-49cd-b0ef-4558ca655efc	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	0a3df555-2b1f-4f5b-8c54-f22f5478d470	12	32768	16384	67	2026-05-04 15:46:46.136	2026-05-04 15:46:48.288	released	2026-05-04 15:46:46.136	2026-05-04 15:46:48.296
d85ce7b2-4a51-438e-8fc8-647ad82c1469	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	8	16384	8192	33	2026-05-04 16:12:00.362	2026-05-04 16:13:57.282	released	2026-05-04 16:12:00.362	2026-05-04 16:13:57.29
5ea385c6-8b82-4222-9564-ff877d7cbaa0	c9868115-ff99-403c-8e87-06124ba7df66	04944419-863d-4b3a-a89e-fa3e87e77c84	12	32768	16384	67	2026-05-04 12:19:29.588	2026-05-04 16:14:43.535	released	2026-05-04 12:19:29.588	2026-05-04 16:14:43.541
56bd3a2c-6682-4056-9ab1-7416d25c33f2	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	12	32768	16384	67	2026-05-04 16:34:30.297	2026-05-04 16:35:05.63	released	2026-05-04 16:34:30.297	2026-05-04 16:35:05.636
5540c496-1646-4a6d-9a9b-1b01084b8c2a	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	0ccd7449-8e06-45ce-94a0-7ed143546716	12	32768	16384	67	2026-05-04 16:37:02.89	2026-05-04 23:58:34.31	released	2026-05-04 16:37:02.89	2026-05-04 23:58:34.322
2be019b4-560c-441a-83fe-8926ce32fe88	c9868115-ff99-403c-8e87-06124ba7df66	4c7ac79c-bce6-4f29-b793-21774cbebbc2	8	16384	8192	33	2026-05-04 16:35:19.944	2026-05-04 23:58:55.602	released	2026-05-04 16:35:19.944	2026-05-04 23:58:55.611
b6649e68-529b-444e-965e-0d5c7f6640a5	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	407b2a0b-a8a7-42c7-b34b-142d57c8089e	12	32768	16384	67	2026-05-05 01:03:56.723	2026-05-05 01:04:25.457	released	2026-05-05 01:03:56.723	2026-05-05 01:04:25.463
2d19d03f-33e6-4f23-9df1-ef64547eb0cc	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	8	16384	8192	33	2026-05-05 01:20:17.661	2026-05-05 05:11:44.477	released	2026-05-05 01:20:17.661	2026-05-05 05:11:44.482
90412b51-a94b-4789-84a0-1c4c6b0a4542	c9868115-ff99-403c-8e87-06124ba7df66	3f659e62-8075-4437-a67b-9c9f9d07502b	12	32768	16384	67	2026-05-05 01:04:44.109	2026-05-05 05:12:13.403	released	2026-05-05 01:04:44.109	2026-05-05 05:12:13.409
ab88aff9-3874-42b1-9066-6511e09d6294	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	f4ebd53c-e856-43d6-b735-f72c0999c56b	12	32768	16384	67	2026-05-05 05:14:26.434	2026-05-05 05:15:13.72	released	2026-05-05 05:14:26.434	2026-05-05 05:15:13.726
0dc20260-6cb1-4ead-a16b-b700904a1786	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	50003a90-973a-4998-b722-4e75c934f5d3	12	32768	16384	67	2026-05-05 05:15:32.853	2026-05-05 05:16:17.977	released	2026-05-05 05:15:32.853	2026-05-05 05:16:17.984
9b1d6d33-eda6-4476-bf1f-11b4ff72db27	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	21e006dd-20c2-4e16-8032-42a267f1084f	12	32768	16384	67	2026-05-05 05:16:53.708	2026-05-05 05:17:24.073	released	2026-05-05 05:16:53.708	2026-05-05 05:17:24.079
3c0d4bcf-a566-494c-915c-9894e033a0e6	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	d95f2adf-135b-420e-b3ff-fc150228ded8	12	32768	16384	67	2026-05-05 05:17:39.721	2026-05-05 05:18:45.211	released	2026-05-05 05:17:39.721	2026-05-05 05:18:45.258
2ecdd2cf-6244-43f8-b7fc-f20215262489	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	22354ffb-9b8e-4851-b4c2-66b44b328eb3	8	16384	8192	33	2026-05-05 05:20:37.883	2026-05-05 05:35:57.644	released	2026-05-05 05:20:37.883	2026-05-05 05:35:57.656
4ac6c02c-d9fa-4b39-833f-c3139f12d928	c9868115-ff99-403c-8e87-06124ba7df66	49b75056-41c8-4ea7-8d06-7292d3a1bff9	12	32768	16384	67	2026-05-05 05:18:14.527	2026-05-05 05:43:53.137	released	2026-05-05 05:18:14.527	2026-05-05 05:43:53.143
43f10993-9369-45e4-9e13-912a6d68b20c	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	7695af26-9ec9-400c-8836-1415bdc28bce	8	16384	8192	33	2026-05-05 05:45:11.867	2026-05-05 05:45:13.979	released	2026-05-05 05:45:11.867	2026-05-05 05:45:13.985
746238c9-c1ab-4576-8102-ce602430c5db	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	4e21897d-ac74-4a45-9998-ef2db1c96b68	2	4096	2048	8	2026-05-05 05:59:40.304	2026-05-05 05:59:56.628	released	2026-05-05 05:59:40.304	2026-05-05 05:59:56.633
a7565297-e782-41cf-ac57-9124c6625ce2	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	265f90b2-01bf-4c25-ab9d-925034e9634e	2	4096	2048	8	2026-05-05 06:02:00.165	2026-05-05 06:02:16.493	released	2026-05-05 06:02:00.165	2026-05-05 06:02:16.499
514f0774-623b-4b6e-80d3-4b27e145604c	c9868115-ff99-403c-8e87-06124ba7df66	aee03291-4ca9-4613-a396-de0251fe57bf	2	4096	2048	8	2026-05-05 06:15:24.718	2026-05-05 06:28:23.237	released	2026-05-05 06:15:24.718	2026-05-05 06:28:23.243
60c4819e-c51c-4d7d-bc77-0fb781020b25	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	748e1240-b6ff-40ea-8fe6-35093a4088a9	12	32768	16384	67	2026-05-05 06:14:40.083	2026-05-05 06:28:32.666	released	2026-05-05 06:14:40.083	2026-05-05 06:28:32.67
48ee2b8b-0368-41d5-9bf8-fb91d8ee05d8	c9868115-ff99-403c-8e87-06124ba7df66	2d87be54-82ea-4d73-9128-262be3f3dddd	8	16384	8192	33	2026-05-05 06:28:59.778	2026-05-05 06:41:52.779	released	2026-05-05 06:28:59.778	2026-05-05 06:41:52.788
e6a348a4-61b3-4547-932c-80bec99e05d2	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	3bafc61f-6305-41e4-bff1-92c190cb7cb3	12	32768	16384	67	2026-05-05 06:42:20.043	2026-05-05 06:42:36.363	released	2026-05-05 06:42:20.043	2026-05-05 06:42:36.367
cb44926d-73e8-44a6-a3f5-76e1e5197999	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	e5c99fe9-54ef-4267-8f73-ea3a603e0488	12	32768	16384	67	2026-05-05 07:19:00.42	2026-05-05 07:19:16.75	released	2026-05-05 07:19:00.42	2026-05-05 07:19:16.756
88e954e9-9801-43bc-96bc-96cce4f68290	c9868115-ff99-403c-8e87-06124ba7df66	a5fb62a4-83e4-4d39-9bc2-9c6d4035c8ef	12	32768	16384	67	2026-05-05 07:34:10.427	2026-05-05 07:34:12.801	released	2026-05-05 07:34:10.427	2026-05-05 07:34:12.808
6fca3b4a-87a6-45b6-ba8b-e208445ad777	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	40c571d1-2a7d-4700-b8b2-ee7d7c501401	12	32768	16384	67	2026-05-05 07:35:32.653	2026-05-05 07:35:48.929	released	2026-05-05 07:35:32.653	2026-05-05 07:35:48.933
e323badf-62b5-4052-954e-428d88d3fd09	c9868115-ff99-403c-8e87-06124ba7df66	5d8a4603-2a56-4e10-9884-d38da2423450	12	32768	16384	67	2026-05-05 08:36:39.557	2026-05-05 08:36:41.625	released	2026-05-05 08:36:39.557	2026-05-05 08:36:41.631
9030163e-dd3f-4647-a393-80840a86b20d	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	a3673281-5fd2-4636-b0d9-58f475e0f82b	12	32768	16384	67	2026-05-05 08:40:57.683	2026-05-05 09:25:56.867	released	2026-05-05 08:40:57.683	2026-05-05 09:25:56.876
f7b149f9-36c5-44f8-a24a-8d24c8e9fa66	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	c676954a-51a2-44b7-b923-534534f320f7	2	4096	2048	8	2026-05-05 10:08:53.25	2026-05-05 12:09:55.271	released	2026-05-05 10:08:53.25	2026-05-05 12:09:55.285
\.


--
-- TOC entry 6012 (class 0 OID 118551)
-- Dependencies: 240
-- Data for Name: nodes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nodes (id, hostname, display_name, ip_management, ip_compute, ip_storage, cpu_model, total_vcpu, total_memory_mb, total_gpu_vram_mb, gpu_model, nvme_total_gb, allocated_vcpu, allocated_memory_mb, allocated_gpu_vram_mb, max_concurrent_sessions, status, last_heartbeat_at, metadata, created_at, updated_at, created_by, updated_by, current_session_count, last_resource_sync_at, session_orchestration_port, storage_provision_port, nvme_of_port, storage_headroom_gb) FROM stdin;
16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	laas-node-02	LaaS Node 02 — RTX 4090	100.94.157.114	100.94.157.114	10.10.100.88	AMD Ryzen 9 7950X3D	16	65536	24576	RTX 4090	2000	0	0	0	8	healthy	\N	{"smTotal": 128, "cudaArch": "sm_89", "reservedVcpu": 2, "driverVersion": "565.x", "allocatableVcpu": 14, "reservedMemoryMb": 10240, "reservedGpuVramMb": 1024, "allocatableMemoryMb": 55296, "allocatableGpuVramMb": 23552}	2026-04-26 12:53:44.426	2026-05-05 15:34:49.198	\N	\N	0	\N	9998	9999	4420	15
c9868115-ff99-403c-8e87-06124ba7df66	laas-node-01	LaaS Node 01 — RTX 4090	100.88.57.107	100.88.57.107	10.10.100.99	AMD Ryzen 9 7950X3D	16	65536	24576	RTX 4090	2000	0	0	0	8	healthy	\N	{"smTotal": 128, "cudaArch": "sm_89", "reservedVcpu": 2, "driverVersion": "565.x", "allocatableVcpu": 14, "reservedMemoryMb": 10240, "reservedGpuVramMb": 1024, "allocatableMemoryMb": 55296, "allocatableGpuVramMb": 23552}	2026-04-08 01:52:12.012	2026-05-05 08:36:41.633	\N	\N	0	\N	9998	9999	4420	15
\.


--
-- TOC entry 6049 (class 0 OID 119182)
-- Dependencies: 277
-- Data for Name: notification_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_templates (id, slug, channel, subject_template, body_template, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6050 (class 0 OID 119196)
-- Dependencies: 278
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, user_id, template_id, channel, title, body, data, status, sent_at, read_at, delivery_attempts, last_delivery_error, delivery_confirmed_at, created_at) FROM stdin;
\.


--
-- TOC entry 6026 (class 0 OID 118798)
-- Dependencies: 254
-- Data for Name: org_contracts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org_contracts (id, organization_id, contract_name, starts_at, ends_at, max_seats, billing_model, total_credits_cents, used_credits_cents, status, notes, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6027 (class 0 OID 118814)
-- Dependencies: 255
-- Data for Name: org_resource_quotas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org_resource_quotas (id, organization_id, max_concurrent_sessions_per_org, max_concurrent_stateful_per_user, max_concurrent_ephemeral_per_user, max_registered_users, max_storage_per_user_mb, allowed_session_types, max_booking_hours_per_day, max_gpu_vram_mb_total, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 5997 (class 0 OID 118110)
-- Dependencies: 225
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (name, slug, logo_url, billing_email, is_active, created_at, updated_at, deleted_at, created_by, updated_by, id, org_type, university_id) FROM stdin;
Public	public	\N	\N	t	2026-04-08 01:52:11.915	2026-04-08 01:52:11.915	\N	\N	\N	07b07401-b326-4045-af3a-44a7c45e56d8	public_	\N
LaaS Academy	laas-academy	\N	\N	t	2026-04-08 01:52:11.93	2026-04-08 01:52:11.93	\N	\N	\N	0cdb29b2-5017-450d-97e4-71b80be8b535	university	\N
KSRCE	ksrce	\N	\N	t	2026-04-08 01:52:11.957	2026-04-08 01:52:11.957	\N	\N	\N	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	university	f213bc95-2fe5-4401-94c1-39efeaa39a5a
\.


--
-- TOC entry 6010 (class 0 OID 118523)
-- Dependencies: 238
-- Data for Name: os_switch_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.os_switch_history (id, user_id, old_os, new_os, old_volume_id, new_volume_id, confirmation_text, ip_address, created_at, created_by) FROM stdin;
\.


--
-- TOC entry 5993 (class 0 OID 118056)
-- Dependencies: 221
-- Data for Name: otp_verifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.otp_verifications (email, code_hash, purpose, attempts, expires_at, used_at, created_at, id, user_id) FROM stdin;
\.


--
-- TOC entry 6028 (class 0 OID 118832)
-- Dependencies: 256
-- Data for Name: payment_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_transactions (id, user_id, gateway, gateway_txn_id, gateway_order_id, amount_cents, currency, status, gateway_response, refund_amount_cents, refunded_at, created_at, updated_at, created_by, updated_by) FROM stdin;
90a5eac3-9446-4b76-a73e-d730df921073	ae95fb83-2551-437f-8fac-dcd84b751a1d	razorpay	pay_SlCyRPMqqmwAcP	order_SlCyENmc2UabRI	50000	INR	completed	{"verified_at": "2026-05-04T07:41:59.597Z", "razorpay_order_id": "order_SlCyENmc2UabRI", "razorpay_signature": "356482a632b764e3dec9a607e6ec45194de018a30f8ca78b43a78eaf287ea3d1", "razorpay_payment_id": "pay_SlCyRPMqqmwAcP"}	\N	\N	2026-05-04 07:41:27.221	2026-05-04 07:41:59.601	\N	\N
09220e4c-97b1-44eb-bd23-f6bfd4df4672	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389	razorpay	pay_SlDgoAFGTdbyWl	order_SlDgi4O0LB0lrt	100000	INR	completed	{"verified_at": "2026-05-04T08:24:01.196Z", "razorpay_order_id": "order_SlDgi4O0LB0lrt", "razorpay_signature": "2e62ddac42c12e1e7408e845f27edd81604341660f8549a5c37148d4a832ae1c", "razorpay_payment_id": "pay_SlDgoAFGTdbyWl"}	\N	\N	2026-05-04 08:23:33.603	2026-05-04 08:24:01.199	\N	\N
a117b47c-29b6-4816-ad6c-d098c1371488	ae95fb83-2551-437f-8fac-dcd84b751a1d	razorpay	pay_SlEdEheA48PC2k	order_SlEd8ZtcABQi9P	100000	INR	completed	{"verified_at": "2026-05-04T09:19:19.279Z", "razorpay_order_id": "order_SlEd8ZtcABQi9P", "razorpay_signature": "f4363274625151a42090ca3b9904ff6961b9ce735a76d44863c4036a6e8573d8", "razorpay_payment_id": "pay_SlEdEheA48PC2k"}	\N	\N	2026-05-04 09:18:52.233	2026-05-04 09:19:19.282	\N	\N
03485faa-865c-45fe-bb28-82ef2748bdd6	ae95fb83-2551-437f-8fac-dcd84b751a1d	razorpay	pay_SlEomgrtOMRVaP	order_SlEohiR5FYdyaW	100000	INR	completed	{"verified_at": "2026-05-04T09:30:15.546Z", "razorpay_order_id": "order_SlEohiR5FYdyaW", "razorpay_signature": "dc2190cbb41719c35eba6c022b47b17157b9ef874ae899bb8108deaa7a74b07a", "razorpay_payment_id": "pay_SlEomgrtOMRVaP"}	\N	\N	2026-05-04 09:29:49.194	2026-05-04 09:30:15.549	\N	\N
c300a59c-feaa-4369-a937-3d611c34ec67	ae95fb83-2551-437f-8fac-dcd84b751a1d	razorpay	pay_SlKQn44oRH4g01	order_SlKQfx7h4CxMkQ	100000	INR	completed	{"verified_at": "2026-05-04T14:59:40.138Z", "razorpay_order_id": "order_SlKQfx7h4CxMkQ", "razorpay_signature": "a045322d929c4dbcefd5096fbc0f3d91ef95451597ad553bf74bc7a26b2eb8c3", "razorpay_payment_id": "pay_SlKQn44oRH4g01"}	\N	\N	2026-05-04 14:59:13.41	2026-05-04 14:59:40.144	\N	\N
77f56d9a-5031-41fa-b903-8fc2f2e09db5	ae95fb83-2551-437f-8fac-dcd84b751a1d	razorpay	pay_SlKRKkisgZ5S9a	order_SlKREOwx850oao	100000	INR	completed	{"verified_at": "2026-05-04T15:00:09.143Z", "razorpay_order_id": "order_SlKREOwx850oao", "razorpay_signature": "8d35ebf58107641143f9620b1f000992082973fcf2d0873390f5d44d60cdc304", "razorpay_payment_id": "pay_SlKRKkisgZ5S9a"}	\N	\N	2026-05-04 14:59:44.953	2026-05-04 15:00:09.146	\N	\N
222ed01f-b5c2-4beb-82df-22c496e9dc20	ae95fb83-2551-437f-8fac-dcd84b751a1d	razorpay	pay_SlTdTd2BOWWw5q	order_SlTdA20nn5MEyv	100000	INR	completed	{"verified_at": "2026-05-04T23:59:54.628Z", "razorpay_order_id": "order_SlTdA20nn5MEyv", "razorpay_signature": "703efab9fc4cc93d3688a1018fc869aed266dec3944b1902fae1a7191b3e299f", "razorpay_payment_id": "pay_SlTdTd2BOWWw5q"}	\N	\N	2026-05-04 23:59:16.827	2026-05-04 23:59:54.635	\N	\N
9b46e2ac-ecd1-4209-99f0-e5e73c77c477	ae95fb83-2551-437f-8fac-dcd84b751a1d	razorpay	pay_SlTeFI6NYSGezT	order_SlTe1EcjbbQGUY	100000	INR	completed	{"verified_at": "2026-05-05T00:00:40.703Z", "razorpay_order_id": "order_SlTe1EcjbbQGUY", "razorpay_signature": "f8353785b3af736eb6585c33ee0dc6429136c1d7857ec2d86484e67ec55c5859", "razorpay_payment_id": "pay_SlTeFI6NYSGezT"}	\N	\N	2026-05-05 00:00:05.551	2026-05-05 00:00:40.709	\N	\N
39806bef-b4b7-4787-a42c-e06193df42f2	ae95fb83-2551-437f-8fac-dcd84b751a1d	razorpay	pay_SlZ5D89LvZcofu	order_SlZ567CB9yf23z	100000	INR	completed	{"verified_at": "2026-05-05T05:19:34.867Z", "razorpay_order_id": "order_SlZ567CB9yf23z", "razorpay_signature": "f2cfaa8551aca813e34b6cb10875ccedb3b384cb4942a1bac7228befe377ff7a", "razorpay_payment_id": "pay_SlZ5D89LvZcofu"}	\N	\N	2026-05-05 05:19:10.74	2026-05-05 05:19:34.87	\N	\N
06b4c4a4-d419-4a01-be43-c0e2da4c079d	ae95fb83-2551-437f-8fac-dcd84b751a1d	razorpay	pay_SlZ5jQbcE2EcLm	order_SlZ5cKMcSuFad9	100000	INR	completed	{"verified_at": "2026-05-05T05:20:06.105Z", "razorpay_order_id": "order_SlZ5cKMcSuFad9", "razorpay_signature": "1cebe8a8a0059e38ae8a19f80078847134a50511515d1d7e42f525b34a3686bf", "razorpay_payment_id": "pay_SlZ5jQbcE2EcLm"}	\N	\N	2026-05-05 05:19:40.24	2026-05-05 05:20:06.108	\N	\N
\.


--
-- TOC entry 5999 (class 0 OID 118140)
-- Dependencies: 227
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (code, description, module, created_at, updated_at, created_by, updated_by, id) FROM stdin;
\.


--
-- TOC entry 6046 (class 0 OID 119134)
-- Dependencies: 274
-- Data for Name: project_showcases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_showcases (id, user_id, organization_id, title, description, project_url, thumbnail_url, tags, is_featured, view_count, like_count, status, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6064 (class 0 OID 124649)
-- Dependencies: 292
-- Data for Name: recommendation_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recommendation_sessions (id, user_id, workload_description, document_file_name, document_extracted_text, analysis_result, analysis_quality, analysis_confidence, detected_goal, detected_vram_gb, detected_intensity, detected_frameworks, selected_goal, selected_dataset_size, selected_intensity, selected_budget_type, selected_budget_amount, selected_duration, goal_auto_selected, dataset_auto_selected, intensity_auto_selected, recommendations, selected_config_slug, created_at, updated_at, completed_at) FROM stdin;
\.


--
-- TOC entry 6062 (class 0 OID 124613)
-- Dependencies: 290
-- Data for Name: referral_conversions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.referral_conversions (id, referral_id, referrer_user_id, referred_user_id, status, signup_method, signup_completed_at, first_payment_at, first_payment_amount_cents, first_payment_txn_id, reward_amount_cents, reward_status, reward_credited_at, reward_wallet_txn_id, metadata, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 6063 (class 0 OID 124636)
-- Dependencies: 291
-- Data for Name: referral_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.referral_events (id, referral_id, referral_conversion_id, event_type, previous_status, new_status, metadata, actor_type, actor_id, created_at) FROM stdin;
037ea661-f9ad-40bd-ac93-9a023e7fbd3c	8de89edc-5400-4618-b6f4-77347d50a770	\N	LINK_GENERATED	\N	\N	{"url": "http://localhost:3000/ref/Ag9o9oI9", "code": "Ag9o9oI9"}	user	ae95fb83-2551-437f-8fac-dcd84b751a1d	2026-05-04 09:29:30.028
\.


--
-- TOC entry 6061 (class 0 OID 124591)
-- Dependencies: 289
-- Data for Name: referrals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.referrals (id, referrer_user_id, referral_code, referral_url, is_active, total_clicks, total_signups, total_rewards_cents, expires_at, created_at, updated_at) FROM stdin;
8de89edc-5400-4618-b6f4-77347d50a770	ae95fb83-2551-437f-8fac-dcd84b751a1d	Ag9o9oI9	http://localhost:3000/ref/Ag9o9oI9	t	0	0	0	\N	2026-05-04 09:29:30.023	2026-05-04 09:29:30.023
\.


--
-- TOC entry 5995 (class 0 OID 118085)
-- Dependencies: 223
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refresh_tokens (token_hash, "deviceInfo", ip_address, expires_at, revoked_at, created_at, token_version, id, user_id) FROM stdin;
$2b$10$9mcipwBaPBbCp6EKIiQ3p.y9Nmc44TH7Dq/FfgAPhTUKs4okmT9Xe	\N	\N	2026-05-11 07:40:56.017	\N	2026-05-04 07:40:56.018	0	d9793e49-919c-4fdf-ab08-0bbb71e9de07	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$AsINF58Xf0w5vKgN76lFe.X4EIZL.BZ4reJ3izhr6RupP8GpoN9NW	\N	\N	2026-05-11 07:50:41.526	2026-05-04 08:03:58.437	2026-05-04 07:50:41.528	0	bd63754b-07b1-4d99-bdef-4169326318b2	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$C65ysx1tmHU8eCew2mO1pum0mzL6uM49tjwimRWuMnSN/i7fAlt.G	\N	\N	2026-05-11 08:03:58.52	2026-05-04 08:17:51.294	2026-05-04 08:03:58.522	0	4b101c29-60f0-464d-954f-e0c624012488	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$Xjg6zm4e2lze4PO.wjS3YOccx9ZI9Q3dmPue/6oUoJmXmhxQeYPim	\N	\N	2026-05-11 08:17:51.39	\N	2026-05-04 08:17:51.396	0	6d8a5017-2b8e-46ba-9da5-5f305083ecfb	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$H76Fgm2scmB17JPe2wADUeFkGiZz1k.LiNc.k8SGuWtbNum9WfbCi	\N	\N	2026-05-11 08:23:13.644	\N	2026-05-04 08:23:13.646	0	478a8a4b-f6fd-4d9a-b77a-6734ae806968	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389
$2b$10$QrI6z3u8fJNXvi8ZaGDg1uG37zXwx8A.KpSCxyI2ac46E.8nmjr5a	\N	\N	2026-05-11 08:26:53.285	\N	2026-05-04 08:26:53.287	0	cb18f91b-8d8c-4525-a1cd-e03ba16ba571	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$zc9n3bR0mrF.V61QAfb6IO0lv.ZRCKFyC3nqwQ21ovpSBk7V3zAHu	\N	\N	2026-05-11 08:27:26.974	\N	2026-05-04 08:27:26.975	0	57744d2f-2541-4c0e-b60d-48fe01bfac6e	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$zbkquv/mL2pTsSVdr2gHDOOMlaJfXxSN/f/xsUHL/V1l/IYOkksnG	\N	\N	2026-05-11 08:27:36.743	2026-05-04 08:40:51.615	2026-05-04 08:27:36.744	0	95ad336f-5bf0-4101-bf52-9ba01e6a827a	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389
$2b$10$04DZeQ/e225gYDPK6ZR.ZerJpSJQqTYh1WFaf7ejs4owEwcf4t1u.	\N	\N	2026-05-11 08:40:51.803	2026-05-04 08:53:51.288	2026-05-04 08:40:51.805	0	a2065958-abfc-49ce-b3aa-f597002eefae	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389
$2b$10$b/.8QuskZaNBrSr5dCbHneWqVDh93pV.gCJx7BoDDV4n82O.zMWoO	\N	\N	2026-05-11 08:53:51.393	\N	2026-05-04 08:53:51.395	0	d9e75150-e0dc-4d1c-a07d-1c786eb4c68e	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389
$2b$10$/lEsni2VBhphPzvC/tld.ek7EgP5kUUtCSj5uRokdODNF1.3nzduu	\N	\N	2026-05-11 08:58:40.174	2026-05-04 09:11:51.308	2026-05-04 08:58:40.177	0	3b9f8be3-0566-42c3-a016-b8c4fcc4f0b9	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$FbXo946ry8N0mc3Bfo2MoeHlY4ew5tw/BIdWfRrtOMqNvpjs7zc0O	\N	\N	2026-05-11 09:11:51.411	2026-05-04 09:24:53.589	2026-05-04 09:11:51.412	0	4a210ac8-e039-4ccf-a152-62443dc31b6e	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$DCHWw6pcO8GA2T9.3Qnumuwfj7xnT3PHwLzg/Rwv7V.tBOQCsSP3m	\N	\N	2026-05-11 09:24:53.954	2026-05-04 09:38:49.3	2026-05-04 09:24:53.956	0	70a512e2-c565-42f9-acce-5093d328f755	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$bCwoWxMMt8HaP9qHommEGO9n3jMmtayIQKVMKQc.89BjIfgAfuC6G	\N	\N	2026-05-11 09:38:49.404	2026-05-04 09:51:51.392	2026-05-04 09:38:49.405	0	8ce09077-5e66-4d72-8914-5d33117f8bdb	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$NKqzute71vMw7e06zSxsvuF/snzUrODmTF6YvD3bTjbMyYIGQNjEW	\N	\N	2026-05-11 09:51:51.594	2026-05-04 10:04:51.355	2026-05-04 09:51:51.596	0	aca58f53-9006-4467-b60e-3b2ad8ee050c	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$gimvij.G9Xz5frh3QctHxOGV2yiEgefhshoeVlKxNrQrU8c1OlPuO	\N	\N	2026-05-11 10:04:51.499	2026-05-04 10:17:51.399	2026-05-04 10:04:51.501	0	ba558b6d-5dfc-49c8-b1b7-21960d3b9ef1	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$pNyVqhW1Ruj/5PKYEydB9egtDAn0Mwaoh/MJde44v9A6uqbWTQc4y	\N	\N	2026-05-11 10:17:51.578	2026-05-04 10:30:51.506	2026-05-04 10:17:51.579	0	a485ffb1-bc82-4031-9e8e-1a57239fa6d1	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$XigjvwzNYfiuH3tCvn6EoOjUdo0gImDXE1OWAyyRicw1xwIvkfZtO	\N	\N	2026-05-11 10:30:51.75	2026-05-04 10:43:51.357	2026-05-04 10:30:51.752	0	ff0e8483-de68-4664-a5b3-dc1625cc7af4	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$FGNJvrybuKE7SbTQZGy3Tec9ECm9O43/OFudoth/Z1uLKM0O32aLC	\N	\N	2026-05-11 10:43:51.529	\N	2026-05-04 10:43:51.531	0	cd3c72f4-13d7-43ca-930a-7cdc989b2511	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$R6kpD8TMNSJ5hRRzE2xmZ.IY0XIlQHe7OgXKhKcRON6dWm.zNlJ5W	\N	\N	2026-05-11 10:50:06.732	\N	2026-05-04 10:50:06.733	0	74f6b1ed-2a40-4c8a-881b-51a641aa6c1b	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$huQA90sg/GX95y50Q4k3KuvhvXnOeOCwYSG.3yvCxMfLbKpYfHuxS	\N	\N	2026-05-11 11:02:45.914	2026-05-04 11:15:51.509	2026-05-04 11:02:45.916	0	32ff9af3-275b-47a1-aa78-f4a772a2b4d6	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$6M8vRcx1ncLf/N0WCk8e6.itreNzc3UoHHQVPAKjM7gWh991aVh3C	\N	\N	2026-05-11 11:15:51.745	2026-05-04 11:28:51.373	2026-05-04 11:15:51.747	0	e01a39dd-5222-4716-9671-75720bfa4e99	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$eBekqme03eK0p.UwIyxDS.WtBlVgAGGYKtIB9L/ZaDiqj5TIB1r0y	\N	\N	2026-05-11 11:28:51.532	2026-05-04 11:41:51.364	2026-05-04 11:28:51.534	0	7b6a855b-a80b-4faa-a44c-db9e00cec8b8	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$vCIEiGbLtzG/jGJ.JsT5A.vK2FdhSjuWCjjlS2aAWViOlIq2/87gy	\N	\N	2026-05-11 11:41:51.516	2026-05-04 11:54:52.529	2026-05-04 11:41:51.517	0	608e700d-6dd5-4bf6-96a5-9ba195ed94c2	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$2qsPGhMTBleo6jwOag7Jg.AK4M1Vp7koZfhsP8dYH9XWzGZDK5HUO	\N	\N	2026-05-11 11:54:53.099	2026-05-04 12:08:51.298	2026-05-04 11:54:53.103	0	2867a431-1be5-467e-a78f-b3990bc9e927	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$O2wpc9vDa8BuFYoPr6jdo.u7V6C0.Haz.cfYojBUY5gyvrknj1WdK	\N	\N	2026-05-11 12:08:51.389	2026-05-04 12:22:04.26	2026-05-04 12:08:51.39	0	ace7c85c-f1f5-45b3-9544-b16a959eac31	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$Soim//cmEPVYmNeyPKKvGu/eyjvJJU2RGlueYZYiS6cdzZsdi/Xey	\N	\N	2026-05-11 12:22:04.348	2026-05-04 12:35:51.306	2026-05-04 12:22:04.349	0	97f30511-242f-4c30-813f-6483b79984dc	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$Syo/hzi5pOFQgs32C.4TjODM45smsGI9TrMdkn7E0McnqK0dS24tO	\N	\N	2026-05-11 12:35:51.402	\N	2026-05-04 12:35:51.404	0	c2b6c377-c6e6-4616-b62b-b854ee6ddac6	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$vEb948qgiP.h4GrZzCcqcuB1D4Dd4Dq5ZpyG84q5dhTZtF7x/gFKK	\N	\N	2026-05-11 14:36:37.575	2026-05-04 14:50:36.491	2026-05-04 14:36:37.577	0	b5fd0ea4-d3d5-4d9c-ba66-b269e6b95bde	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$cKlKVRv/wRmeayB1wwWBh.1DMfVhJcF8VnWFgMVnY6zIVb9Exh8Ei	\N	\N	2026-05-11 14:50:36.598	2026-05-04 15:04:36.573	2026-05-04 14:50:36.599	0	f7c669c9-2e67-4f93-a576-2a9a1be92cdf	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$jlqEstA09AWfpkzTU6HIfeJB4Whe.wf9BaZeW3xWONOGrWNz2GLLK	\N	\N	2026-05-11 15:04:36.708	2026-05-04 15:17:36.481	2026-05-04 15:04:36.71	0	df0246fc-d72b-494b-ad7f-b6945b6a3e7e	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$qTAqCb7sS/Owy1haNeHQOeTjbm72TyvG5Xx91RT2kEJGIojoI/2i.	\N	\N	2026-05-11 15:17:36.573	2026-05-04 15:30:36.551	2026-05-04 15:17:36.574	0	b88cc314-a009-4649-beae-eaddda4a026f	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$32HK1AycRLuEixuyfTNaFuiTbFgOBF7B85Wttm9RxoFAt1uKbWkkK	\N	\N	2026-05-11 15:30:36.699	2026-05-04 15:43:36.573	2026-05-04 15:30:36.701	0	b35815b2-1b4a-4e04-8c6b-7865e4d4dd89	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$70Ntlds5Wa0RarhItxPh.uJiZTYZFYSH4Dv/IYUMPjvpMGRLYtW0O	\N	\N	2026-05-11 15:43:36.808	2026-05-04 15:56:36.519	2026-05-04 15:43:36.81	0	eba9c3d6-2b22-44f7-a3d1-d1fc6ec70fce	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$YnGKKuwTYujrHUfGiqAo2ufuXTQtGVredpayikNNhIQ0RV4Kd1knm	\N	\N	2026-05-11 15:56:36.67	2026-05-04 16:09:36.551	2026-05-04 15:56:36.672	0	752d1076-b432-464b-8dff-2ccbf5daa035	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$XyQGt3K2NKULw28ehATvteWhCfpejBMHdy5ocRXC4K90J/VNVNddi	\N	\N	2026-05-11 16:09:36.729	2026-05-04 16:22:36.488	2026-05-04 16:09:36.731	0	369ebe59-00dd-4fa5-8106-348ce39ecdb9	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$YLsFk2IC3lgeaEJF9.xn.eC1uzNe9AKtHlvyhT.DfvJZgM.kxOxkq	\N	\N	2026-05-11 16:22:36.583	\N	2026-05-04 16:22:36.584	0	fd61ac2c-2cda-4ce4-a57c-d35862a61edc	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$ogCv34I/3matSQqsxCESZOzAERUeIrK6hHHspanRc.N5m1mBUeQ72	\N	\N	2026-05-11 16:33:44.25	2026-05-04 16:47:16.493	2026-05-04 16:33:44.252	0	3b6911f8-f34f-41a8-8cba-c9769ac00c9f	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$VXEcui50fqEvf.bVyHmwjO4GngM/9oFBlrCADWhQrnH3xKU9zwVXC	\N	\N	2026-05-11 16:47:16.599	2026-05-04 17:00:29.595	2026-05-04 16:47:16.6	0	bcfa92d5-8b11-4fb0-9594-7016057c2d5e	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$7pHFenXZTuKF1..9NIrf/.EbyyP3zxz8YM2pNRmsMOAY1Pqu9qlYa	\N	\N	2026-05-11 17:00:29.758	\N	2026-05-04 17:00:29.759	0	9dfbc8b7-0709-407e-8f82-5c831ac830e8	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$6E5PmnZxA3Py.pZjra86iubDliJYpC.oFxDJvUkPmxJhZfbOFNska	\N	\N	2026-05-11 23:57:40.232	2026-05-05 00:10:45.357	2026-05-04 23:57:40.234	0	00625f8a-0cde-479b-b572-0fec801fad58	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$Z255SPEa1d5k/lx5IThAku7iOAzapJfe077avSnDlvXLoi5.Hf9Ru	\N	\N	2026-05-12 00:10:45.454	2026-05-05 00:24:23.527	2026-05-05 00:10:45.455	0	eff1aa5f-0fff-4350-af07-b0890ba79f9c	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$N68UCDVJ9Ubd2LWIZI8vh.IXBC7LA6Gvavj/YksMPWyDMZqFJYWo.	\N	\N	2026-05-12 00:24:23.663	2026-05-05 00:37:23.541	2026-05-05 00:24:23.664	0	f3a35d8f-cc14-4802-a409-c07501680990	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$qxom3aUIJb39Du6.irFgtOOZ.9pHStNJ.nd5FSR4iwErlA1fDgJDu	\N	\N	2026-05-12 00:37:23.646	2026-05-05 00:50:23.524	2026-05-05 00:37:23.648	0	1c6ca0cb-b4b8-4399-8ea9-c6a191930eb7	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$.ur7GI2Vn8wqvO5EBi73l.kBzrqzayxUP9GzMXOunXyj9SIdPF3WK	\N	\N	2026-05-12 00:50:23.619	2026-05-05 01:03:23.587	2026-05-05 00:50:23.62	0	bda2d8c8-6e7b-4303-a9ef-8a54eb633ef4	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$eH/tCHquIzfKEfTFnEtSXe1ZW77Jb1KxaUaW6cLkekr9sTIh12AEu	\N	\N	2026-05-12 01:03:23.717	2026-05-05 01:16:23.63	2026-05-05 01:03:23.718	0	19571d59-6d7b-4743-8d08-b1696691ac34	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$vwUgcXEy4Fz9RYGnLLnLtuNoTmRjHimn0ziKXiVLBqDX1qDGHIJsK	\N	\N	2026-05-12 01:16:23.777	2026-05-05 01:29:23.67	2026-05-05 01:16:23.778	0	227d7da0-8818-4a23-afc6-a34cbc81b5c0	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$oqS.jX3Dg2Oxb/WXj/opku1WV1Mhqvyooykx11cyEcIKay9r2Heue	\N	\N	2026-05-12 01:29:23.867	2026-05-05 01:43:18.684	2026-05-05 01:29:23.868	0	7098bbaa-a79b-4c3e-b0d1-c680cc4df6b0	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$liq7Q6QyqVrt//UM8909H.JyZaxvJNdvqDvJjQacJ2.4Z.A8KV5TC	\N	\N	2026-05-12 01:43:18.9	2026-05-05 01:56:23.678	2026-05-05 01:43:18.902	0	07806231-b526-446b-bff3-3be0769a1f13	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$k8Ucdn0dT05I9hkzPqY1Z.VR5mosdb4RzK2PlC7O2NbHeiPl4P0JG	\N	\N	2026-05-12 01:56:23.892	2026-05-05 02:09:23.618	2026-05-05 01:56:23.893	0	b10ebdab-ded8-4e16-9cfd-de75ba726417	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$j9shfFa6KolFw1/4lH3rTOD9Po/uS4NCgrvSSr8na80/gQlLuR42S	\N	\N	2026-05-12 02:09:23.813	2026-05-05 02:22:23.531	2026-05-05 02:09:23.815	0	6473524f-ec09-4a94-aead-ed66af41a469	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$wUDNKAuOl2Z1C8yNq1B1QuI3WVAN3F2XVnYqK.U6F5q13VmOAo4WS	\N	\N	2026-05-12 02:22:23.64	2026-05-05 02:35:23.6	2026-05-05 02:22:23.642	0	2d65e0fd-8c86-4af4-b73d-832321f2e184	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$R6kruJ/FoTO0kWqJb6aQD.y8DIJQyHhe0vVHH5vRr1jl6PuIWNpAK	\N	\N	2026-05-12 02:35:23.709	2026-05-05 02:48:23.549	2026-05-05 02:35:23.71	0	c52304e5-e14f-4888-b502-445d615480b8	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$4F6yPJcHbWp.enh4NGAmau0KMy5mi5LCthqJ2EFBzM1kJP08SANi.	\N	\N	2026-05-12 02:48:23.678	2026-05-05 03:01:23.613	2026-05-05 02:48:23.68	0	c33ef78f-db4c-4290-b67d-a78c99362dc5	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$NsiClt6xpwuj2cHetmqUJ.hjC3fo0cdj4DxAeXLq5d6gNvKyDIpTy	\N	\N	2026-05-12 03:01:23.795	2026-05-05 03:14:23.606	2026-05-05 03:01:23.796	0	3cac7659-d0fc-40af-a17f-f787b7640a5f	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$GLAJVKplgdS9m2rB2xO2..lL84x7l4A0s7KaLQwWa9hHz5TUmdHDu	\N	\N	2026-05-12 03:14:23.73	2026-05-05 03:27:23.533	2026-05-05 03:14:23.731	0	0fc74b12-3856-448f-9db7-d5abec12f495	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$hTnlcPBHX0KIP6TAKQrAKep5tCrNds3x4fIiXWgrFR9XIBBbvCsuW	\N	\N	2026-05-12 03:27:23.648	2026-05-05 03:40:23.597	2026-05-05 03:27:23.649	0	da6be7f9-865c-4c98-90dc-9e44168a47a8	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$Q2ip7eOO0uDKX3QAd.hIkOS/RGTwxrmGBMr1D/WRlYXdxUzHPaB5e	\N	\N	2026-05-12 03:40:23.721	2026-05-05 03:53:23.573	2026-05-05 03:40:23.722	0	aa9c4045-3262-464d-8022-90f6fb5fdfca	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$mmdzmbHVE0ZGSnFJroNTK.iUCawXYi0HWcecCFH6GjqVfEqzCcU.O	\N	\N	2026-05-12 07:45:11.69	2026-05-05 07:58:11.506	2026-05-05 07:45:11.691	0	9a9c8411-aa51-400d-92f6-568393f91e00	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$WCl3ZXm.a/5aC3aA3ajV6.LkWRXfw4xS0ueuyuWEiYTiBojh/XmVu	\N	\N	2026-05-12 04:08:06.719	\N	2026-05-05 04:08:06.72	0	41f2da8f-22c9-422f-a06b-a3f2a5506854	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$DvgU/3FsKygEnP4hSk/5uubK4ZWXnTyR49vmvyJeKFs94UJ6O6qGy	\N	\N	2026-05-12 03:53:23.719	2026-05-05 04:08:06.768	2026-05-05 03:53:23.72	0	901bd79c-ce35-49a5-bb00-f37550a8ced8	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$tiLMzG3h5xz.pewYaqNUN.nNubSBEmHjZLUiNP5GdVthZI9fofafO	\N	\N	2026-05-12 04:08:07.29	\N	2026-05-05 04:08:07.291	0	268a46fa-4f44-40c7-a673-0cadb400b168	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$TXZro.whaAFbIICQoEjVQudyo5vXhB.MsdRKNXVPW28PykurxZ4ym	\N	\N	2026-05-12 05:11:30.921	2026-05-05 05:25:11.707	2026-05-05 05:11:30.922	0	5e6246ea-51a6-405c-b2a2-ae2db90501e6	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$gs0SNug6X7DB3b4BQ1Hq1OJzwkMsZ5MUPhVvMdm9jhvHJBJqvqpni	\N	\N	2026-05-12 05:25:11.938	2026-05-05 05:38:12.999	2026-05-05 05:25:11.942	0	32aa66bf-5667-4bec-97dd-b12d94d41a7e	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$q8JZGHq1XStv1wUQRSnIXu942bspwDjGU69BVZICDA4g8mH/ga/6e	\N	\N	2026-05-12 05:38:13.135	2026-05-05 05:51:38.519	2026-05-05 05:38:13.137	0	6e6106b6-4ed6-4bd6-87d3-d3f12b1d446a	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$Gj2wd9qZZunAuHVUHGxr4.u4egJO0AsxLbf./YoEjM4E92X9wQE5O	\N	\N	2026-05-12 05:51:38.63	2026-05-05 06:04:53.49	2026-05-05 05:51:38.631	0	1dc2af77-7ac8-4406-8bd3-2470877f608c	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$zpNDkd.te21H9YYWqOBZMeDWGnu26HopnllmNpKB.G.i5d0/tQkmu	\N	\N	2026-05-12 06:04:53.585	2026-05-05 06:18:18.647	2026-05-05 06:04:53.586	0	56804f35-a71b-4f28-8991-d98ad605e00a	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$pHIZmEvPl68mJ3yvyEYsGOpJQwgEwhW5wbXskgJNCaYfLBmRk3Xry	\N	\N	2026-05-12 06:18:18.87	2026-05-05 06:31:43.143	2026-05-05 06:18:18.872	0	734e90fb-3ff6-43fe-94a6-cff0d572a91a	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$utUGctCIFi/YiTNtcqss6uedEYhN3q.KNgc3IN6Ei6OVt85EFkVfK	\N	\N	2026-05-12 06:31:43.382	2026-05-05 06:44:43.498	2026-05-05 06:31:43.384	0	cb8e4d93-cf3d-41a6-8bd4-17bad934b39b	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$05/4G4qlt.CWGhI26OHkF.5Y1nltLOytiCb92QIjovuaNYu2q1bOu	\N	\N	2026-05-12 06:44:43.597	2026-05-05 06:58:11.531	2026-05-05 06:44:43.598	0	b77bec87-3063-4f12-a5b1-6edf20903f84	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$v91HgLqnmPnmyTHR/tG.POXTxet/2eafJFpT33gVDuWjuFFniD8nW	\N	\N	2026-05-12 06:58:11.655	\N	2026-05-05 06:58:11.656	0	f0874009-ed65-4fff-a975-29e6d1f206da	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$D//2jfvK0LzLB6ffcoOzYexS/7Gh.8/gEok7C1gJRhisTf9EqaIW6	\N	\N	2026-05-12 07:18:40.771	2026-05-05 07:32:11.534	2026-05-05 07:18:40.773	0	78f8da98-bfbc-4767-8226-d1c97f9b1add	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$JTh4luKeZ1KhQ36noZkZ4.51NP8kRBuJ8pDdISWLHukm4jpVg9aka	\N	\N	2026-05-12 07:32:11.649	2026-05-05 07:45:11.578	2026-05-05 07:32:11.651	0	765f2d07-a9de-48f5-994f-2f3800528347	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$qN/wTf8VkvsbnSJKdKQlh.yleNqSbKD7dzKF94MXl6Xp5A156Ui.e	\N	\N	2026-05-12 09:53:16	2026-05-05 10:07:03.689	2026-05-05 09:53:16.002	0	a2da659a-507c-452d-a255-867b15891826	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$QFo/VU4Es2id2Xr5rcVxiO1XAaPJVC5dRLMDRxnYeoRfTzTKISaIu	\N	\N	2026-05-12 07:58:11.6	2026-05-05 08:30:52.612	2026-05-05 07:58:11.601	0	92038eb7-7ced-4c21-a33b-dfe9a989e12b	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$YVv5uiDpeqoQkgPItgJJL.KM7DnKxoHikKb.6ZCafc1r4EV6M0dna	\N	\N	2026-05-12 08:30:52.793	\N	2026-05-05 08:30:52.795	0	d3cf381f-63e2-4f8e-85e6-8f476fc25ebe	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$ny1UodTCZEB7wAnUcnUFK.LC3jrPRRN.cF/BkAIXeaGxZSul8XEVO	\N	\N	2026-05-12 08:30:52.804	2026-05-05 08:44:13.368	2026-05-05 08:30:52.806	0	8f14126c-c99d-4ec7-95e9-45e51d399eb2	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$gmFhc.qoI/QbLYoOmzTtEeyevQRYMFoN93TS3VR5aPJztQXqd6evq	\N	\N	2026-05-12 08:44:13.838	2026-05-05 08:57:58.553	2026-05-05 08:44:13.842	0	2d0b1842-d58c-414f-b440-225cf42662f7	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$DnWw1E98y0hdmid2nBCFZ.FWXSV0ZovMypIFsayLSJthqU.Hjapby	\N	\N	2026-05-12 08:57:58.683	2026-05-05 09:11:11.569	2026-05-05 08:57:58.685	0	fd45aaaa-7d7c-417d-bd4a-d8ce473812b4	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$LXA927w4Ry5mTGy2fktB.egOPRKQiyrfKq2TIQwsFTN6LXbjN.J4q	\N	\N	2026-05-12 09:11:11.723	2026-05-05 09:24:13.49	2026-05-05 09:11:11.725	0	a9a3f10b-0882-498d-95ec-0174538285d9	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$SVkMYhDhFLEkLfbhtxYP1OMVWXwL6dCWGnWlj449dgIXsLs2esajS	\N	\N	2026-05-12 09:24:13.92	2026-05-05 09:37:28.479	2026-05-05 09:24:13.922	0	8d36c5c6-a045-4096-adc6-8ecdd4b642f7	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$tT.cDJnD5FQ/5GeMW4xYaerLTB5vUm9nYV4nB./eVAloHLj16bac.	\N	\N	2026-05-12 09:53:15.768	\N	2026-05-05 09:53:15.769	0	cbc2e781-4848-45cb-bfef-72fa13c042e7	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$sNJwP046fsPmebq92Ti/MudSS6R/Yjr.16LKfEs/6D4IEIqrdL/7C	\N	\N	2026-05-12 09:37:28.569	2026-05-05 09:53:15.809	2026-05-05 09:37:28.57	0	00237ae8-49b3-4bcd-89ac-d1a8d1fd4815	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$fzWWaGbWUp/loAgp1GMUlu386DcSzjseWK9EIygcdX4dQs9sZvMAy	\N	\N	2026-05-12 10:07:03.938	2026-05-05 10:20:11.991	2026-05-05 10:07:03.941	0	bf5dc1f0-98ef-440c-a6eb-4b190618cd64	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$WjVqRoth7ZnmqpJSztWApOKglyW3Gbi86q4nxPi6CGh4zsuean2GS	\N	\N	2026-05-12 10:20:12.274	2026-05-05 10:34:11.589	2026-05-05 10:20:12.276	0	c292b789-3bb6-4983-9154-fb62a563cd6d	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$LRX0THnKEdUWhWLhD3jhneJB11zD0r8GZ4tjUqwEYroPL5VwfpW5y	\N	\N	2026-05-12 10:34:11.697	2026-05-05 10:47:11.702	2026-05-05 10:34:11.698	0	a025b28f-5086-41b1-a655-f7d4ce1d1860	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$FP/JdGreUVE9ksxHRXaie.f54lAJODP3.XoeChm.UWWjdPJ1yBkA6	\N	\N	2026-05-12 10:47:11.933	2026-05-05 11:00:11.725	2026-05-05 10:47:11.935	0	d3fddb31-056e-4ea3-bace-8a60688c9a66	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$xCwI2he/4xBjEG//jp0PNetqNowyqgrNJj9YDtVfbNNnnUy/NUTPq	\N	\N	2026-05-12 11:00:11.965	2026-05-05 11:13:11.629	2026-05-05 11:00:11.968	0	66a406b8-2b5b-4a9d-a42d-c297448b1099	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$oFJgV7D2rdG3wEKgQKkCJuXeZXxgwXxW07JpxnOMXY0hdyCYGAw1e	\N	\N	2026-05-12 11:13:11.83	2026-05-05 11:26:11.692	2026-05-05 11:13:11.831	0	f4dfd467-859b-4f86-9d68-3b49ded8c632	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$RBAQhaf7dYese7iDaimVK.aoIADozD3E0so/H7/N0utZpRrlepU3y	\N	\N	2026-05-12 11:26:11.891	2026-05-05 11:39:11.623	2026-05-05 11:26:11.893	0	97c9fac1-a343-4b3f-abe3-0f7b681641f3	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$JRthwjhgE8Od0ENKdXl7PueBMEqIDOQU1Ci8U.pdOQxdUUbTg8QzC	\N	\N	2026-05-12 11:39:11.814	\N	2026-05-05 11:39:11.815	0	83bb44c6-82c8-4c58-8054-8459c43c321b	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$VvTnVtdllXcPl8AjpC6z1uPwYk67TPzaEx4AQkZ3NrPglAOpNNyIS	\N	\N	2026-05-12 12:09:46.854	\N	2026-05-05 12:09:46.857	0	a18c8b85-9385-494a-a6ed-06e10ac538d2	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$sBv/8Bc6.bBBFJXPJ4nc2.QizCZZfEHB.33bvIsTJNG0YO9cWvap.	\N	\N	2026-05-12 13:08:03.268	2026-05-05 13:21:58.702	2026-05-05 13:08:03.269	0	853bca5d-9c11-49b8-9c64-33cca565d99f	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$epnJdyYLE8OgUBTfvx7VJu6e6emsloZXE3uHgoonnpT.iQGcjJo.m	\N	\N	2026-05-12 13:21:58.822	\N	2026-05-05 13:21:58.823	0	f3ca36c1-7613-4854-a2c3-2acc12f1a7af	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$/3CxndP/0rjUdLMjRr308.iFfEuXT61GJqWCbyrLtxdziGejeH4vi	\N	\N	2026-05-12 15:34:33.454	2026-05-05 15:48:03.679	2026-05-05 15:34:33.457	0	301c81ec-0d42-4534-90aa-b148cf561ead	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$fpso4eBgPFhOs4i5uMfhhearD6c7tAEh9w37LYcHZKBsDb2uzECPq	\N	\N	2026-05-12 15:48:03.806	2026-05-05 16:01:03.715	2026-05-05 15:48:03.807	0	fbfd0d7a-a70a-4bf3-a3b5-999e6759bd8c	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$TEbiHmrKLwow2BID6p0KheYAiR4v.NumLCL.vNF844u8A49Srv2Nq	\N	\N	2026-05-12 16:01:03.866	2026-05-05 16:14:03.69	2026-05-05 16:01:03.868	0	e0293e72-d1db-4df0-9f21-429acbe6e7ad	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$XAFjRqFE3yHkaZZtl4Giyuhv.J77B9SlEtLEwUJVXasWH6yrOzHSq	\N	\N	2026-05-12 16:14:03.815	2026-05-05 16:27:03.75	2026-05-05 16:14:03.817	0	52a16aa0-0280-4f11-bf86-13ce6f000927	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$eaOJJC0RztL4fIARmUEZ/upLLQSltFq8YiY4yFuZigFEcabYfmKBK	\N	\N	2026-05-12 16:27:03.912	2026-05-05 16:40:03.656	2026-05-05 16:27:03.913	0	c483185c-dfc1-432b-85e5-cfcb60aa89bd	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$tKARdn30x.w7Otz2ZUSbW.B1.wZbKmxtd8QD.awulWLct4UaaEI3K	\N	\N	2026-05-12 16:40:03.773	2026-05-05 16:53:03.679	2026-05-05 16:40:03.774	0	5d3c5a86-9e53-4ff2-a282-8076b0109a96	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$H2LoIoKgjl6WmWoOp.dGsObggRTGD6Ej5Bz7gDiYYyVU1WeG4O942	\N	\N	2026-05-12 16:53:03.799	2026-05-05 17:06:03.664	2026-05-05 16:53:03.8	0	7be2d4cb-ba6d-4211-957b-a5eb05c32434	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$3bq7nsATJFJzzyMZKadLYeuulvlUW/SZ4yPVq69nMKVFYsNBD6hii	\N	\N	2026-05-12 17:06:03.848	2026-05-05 17:19:03.81	2026-05-05 17:06:03.85	0	644cbc7b-4ed7-449b-9fd9-f82a37ee9300	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$8iR4yZi7kWOSZnxP/CEHJe/U6GfUDRZnUmP1ZTTPGgUfYLqSoE4fO	\N	\N	2026-05-12 17:19:03.975	2026-05-05 17:32:03.68	2026-05-05 17:19:03.977	0	34fd728d-3fda-4021-aeaa-24ffb354a452	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$kh8OpDyJ.jjLZZnI5liS1u90FxcxmNj3wF7JL6nbXfJrLfRip/Nrm	\N	\N	2026-05-12 17:32:03.788	2026-05-05 17:45:03.673	2026-05-05 17:32:03.79	0	ece18ec3-2eac-409a-b081-77eebb439b55	ae95fb83-2551-437f-8fac-dcd84b751a1d
$2b$10$na0xOtoZrfDWgYYU1.9xGel71sK/MDjXbc1socsXWmmlVUp0jC8rq	\N	\N	2026-05-12 17:45:03.796	\N	2026-05-05 17:45:03.797	0	8a72611e-f09d-4cb5-8639-1667315d861e	ae95fb83-2551-437f-8fac-dcd84b751a1d
\.


--
-- TOC entry 6000 (class 0 OID 118152)
-- Dependencies: 228
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (role_id, permission_id) FROM stdin;
\.


--
-- TOC entry 5998 (class 0 OID 118126)
-- Dependencies: 226
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
\.


--
-- TOC entry 6019 (class 0 OID 118674)
-- Dependencies: 247
-- Data for Name: session_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.session_events (id, session_id, event_type, payload, client_ip, created_at) FROM stdin;
e794e9a0-8835-427f-881a-6e751fcde51e	f3345614-394f-49e8-99e1-30804f314627	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-rz6t", "interfaceMode": "gui"}	\N	2026-05-04 08:03:53.839
ec8d4034-f32a-4893-a8ca-67e3430e9878	f3345614-394f-49e8-99e1-30804f314627	launch_initiated	{"launchId": "26d209f3-ed8a-4f03-b736-84cbbeab84d5", "containerName": "laas-f3345614"}	\N	2026-05-04 08:03:53.888
c4e705b3-deb8-4736-be94-6a1e1a361dda	f3345614-394f-49e8-99e1-30804f314627	launch_scheduling	{"ts": "2026-05-04T08:03:55.525128+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 08:03:55.911
d761a919-9351-49ff-bde0-0f5428651883	f3345614-394f-49e8-99e1-30804f314627	launch_scheduling	{"ts": "2026-05-04T08:03:55.625565+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 08:03:55.912
1e8f2bb0-8499-48a7-a6b0-977dc1caf2c6	f3345614-394f-49e8-99e1-30804f314627	launch_allocating_ports	{"ts": "2026-05-04T08:03:55.625680+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 08:03:55.914
acbd0d69-e042-4722-b716-2b0931c8b9c5	f3345614-394f-49e8-99e1-30804f314627	launch_allocating_ports	{"ts": "2026-05-04T08:03:55.647917+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 08:03:55.915
23b165fc-ff70-42ee-9f86-0ec87b6fdf13	f3345614-394f-49e8-99e1-30804f314627	launch_allocating_cpus	{"ts": "2026-05-04T08:03:55.647932+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 08:03:55.916
c0fd09bb-94de-4b4e-b085-8eb9a882352e	f3345614-394f-49e8-99e1-30804f314627	launch_allocating_cpus	{"ts": "2026-05-04T08:03:55.658631+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 08:03:55.917
ba38e16e-89d1-4981-85c8-92cc407a9078	f3345614-394f-49e8-99e1-30804f314627	launch_validating_mount	{"ts": "2026-05-04T08:03:55.658646+00:00", "status": "in_progress", "message": "Verifying local ZFS zvol for u_f7053a8b16cd55e38b838e79..."}	\N	2026-05-04 08:03:55.917
98fa5ec7-f285-4c22-9b57-c8d557cd6c1e	f3345614-394f-49e8-99e1-30804f314627	launch_validating_mount	{"ts": "2026-05-04T08:03:55.658762+00:00", "status": "completed", "message": "Local ZFS zvol verified: /datapool/users/u_f7053a8b16cd55e38b838e79"}	\N	2026-05-04 08:03:55.918
0a5f847f-f034-459e-a997-0842e3809bc9	f3345614-394f-49e8-99e1-30804f314627	launch_creating	{"ts": "2026-05-04T08:03:55.658799+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 08:03:55.918
70f80df4-cf95-4aac-8b13-5ec55a9da241	f3345614-394f-49e8-99e1-30804f314627	launch_creating	{"ts": "2026-05-04T08:03:55.737185+00:00", "status": "completed", "message": "Container created: laas-f3345614"}	\N	2026-05-04 08:03:55.919
bf09b220-e32c-4ea5-884e-d42d2fe4d3b1	f3345614-394f-49e8-99e1-30804f314627	launch_starting	{"ts": "2026-05-04T08:03:55.737200+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 08:03:55.92
d1cc7bdb-f3e6-4e23-b175-74a0d71817e5	f3345614-394f-49e8-99e1-30804f314627	launch_starting	{"ts": "2026-05-04T08:03:56.074111+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 08:03:55.92
ba75c608-9884-489c-b3a3-ea5eb0685765	f3345614-394f-49e8-99e1-30804f314627	launch_waiting_desktop	{"ts": "2026-05-04T08:03:56.074123+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 08:03:55.921
745de4b6-81da-4b93-89c2-61983da536f2	f3345614-394f-49e8-99e1-30804f314627	launch_waiting_desktop	{"ts": "2026-05-04T08:04:12.225479+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 08:04:12.108
1e940128-62e6-47e4-a3da-9f7850e92860	f3345614-394f-49e8-99e1-30804f314627	launch_waiting_desktop	{"ts": "2026-05-04T08:04:12.225489+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 08:04:12.11
638091a5-4d24-41ec-8cda-2f721c04950e	f3345614-394f-49e8-99e1-30804f314627	launch_health_checking	{"ts": "2026-05-04T08:04:12.225492+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 08:04:12.111
20c70187-82e7-4c79-bc6b-b90a850b7eef	f3345614-394f-49e8-99e1-30804f314627	launch_health_checking	{"ts": "2026-05-04T08:04:14.231750+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 08:04:14.126
e58e32bb-3249-455e-a857-9d26a28f9a87	f3345614-394f-49e8-99e1-30804f314627	launch_ready	{"ts": "2026-05-04T08:04:14.231765+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 08:04:14.128
3ce0a053-fd47-425f-a317-b73b7076d990	f3345614-394f-49e8-99e1-30804f314627	launch_ready	{"ts": "2026-05-04T08:04:14.231773+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 08:04:14.129
727e185c-9679-4c99-9bc6-ce05c251e0a4	f3345614-394f-49e8-99e1-30804f314627	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.88.57.107:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 08:04:14.136
e25e40d4-4ba3-45a2-8847-ef8c2bf5758a	6c5b8d4d-2827-4e05-b551-bd397301b575	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-veus", "interfaceMode": "gui"}	\N	2026-05-04 08:25:08.408
f077112d-9a1a-487e-b5e9-eccf645acd21	f3345614-394f-49e8-99e1-30804f314627	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 15500, "durationSeconds": 1367, "terminationReason": "user_requested", "alreadyBilledCents": 15500, "remainingChargeCents": 0}	\N	2026-05-04 08:27:01.197
32c73dc3-8ec5-4073-88c4-009e2ddfbc49	ae38510e-ab6b-408c-b1be-eac0988fbc93	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-3vy7", "interfaceMode": "gui"}	\N	2026-05-04 08:59:14.379
17ff531f-b3de-4f79-96ef-e4d58ecdfcfc	58582e3f-f8bd-4147-b9ed-38a510ceb745	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "instanceName": "gpu-instance-3vy7", "interfaceMode": "gui"}	\N	2026-05-04 09:01:29.591
072f3d91-82e0-4b33-af67-ea8f450709cf	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_initiated	{"launchId": "7d6f4200-09f2-45f6-bbfe-9f5b8e57f6ac", "containerName": "laas-58582e3f"}	\N	2026-05-04 09:01:29.636
1013ec9f-b50f-4058-8a50-fc7d563c3f52	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_scheduling	{"ts": "2026-05-04T09:01:31.339760+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 09:01:31.663
4edccf24-63e6-44da-9896-923b3d30e866	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_scheduling	{"ts": "2026-05-04T09:01:31.439961+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 09:01:31.665
73cf1dce-003d-4b20-98a2-b9671705d3d6	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_allocating_ports	{"ts": "2026-05-04T09:01:31.440078+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 09:01:31.666
e05ab6db-4ebb-4011-ad32-c42d31c8541e	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_allocating_ports	{"ts": "2026-05-04T09:01:31.461853+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 09:01:31.668
f09b2c1d-bf14-4837-980d-e4dd5e67f0e1	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_allocating_cpus	{"ts": "2026-05-04T09:01:31.461859+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-04 09:01:31.669
e48eaaae-c70b-4288-b0ac-ab133dbd2760	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_allocating_cpus	{"ts": "2026-05-04T09:01:31.471607+00:00", "status": "completed", "message": "Allocated CPU cores: 2-3"}	\N	2026-05-04 09:01:31.67
88c274f7-448e-46d9-a444-aeae901ea37b	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_allocating_storage	{"ts": "2026-05-04T09:01:31.471618+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-04 09:01:31.671
8577dd80-e739-4b76-8e3d-941572576fe1	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_allocating_storage	{"ts": "2026-05-04T09:01:31.471622+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_58582e3f-f8bd-4147-b9ed-38a510ceb745..."}	\N	2026-05-04 09:01:31.672
f981d912-5f5f-4fac-b5e5-3866c6ce6cf7	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_allocating_storage	{"ts": "2026-05-04T09:01:32.208654+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_58582e3f-f8bd-4147-b9ed-38a510ceb745"}	\N	2026-05-04 09:01:31.674
97befb15-538a-4ce2-83e6-bb530cbd8e61	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_creating	{"ts": "2026-05-04T09:01:32.208709+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 09:01:31.675
14f3e5a4-c0e4-4854-b34c-61523c354d19	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_creating	{"ts": "2026-05-04T09:01:32.279819+00:00", "status": "completed", "message": "Container created: laas-58582e3f"}	\N	2026-05-04 09:01:31.677
a2550f79-fb08-4085-97ed-4e9b9de84bb0	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_starting	{"ts": "2026-05-04T09:01:32.279827+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 09:01:31.678
d82bfca1-ae10-42f7-bc3a-d897552c361c	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_starting	{"ts": "2026-05-04T09:01:32.634567+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 09:01:31.679
eee3d373-2ee7-41e2-91ca-9d5385578f7d	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_waiting_desktop	{"ts": "2026-05-04T09:01:32.634579+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 09:01:31.68
80423ff6-40f8-47e2-b0c9-6e1ca819323e	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_waiting_desktop	{"ts": "2026-05-04T09:01:52.825057+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 09:01:51.921
147a6812-6586-4d96-ac6e-77452f4d548d	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_waiting_desktop	{"ts": "2026-05-04T09:01:52.825069+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 09:01:51.924
8e0c36fe-ab2a-48aa-a84c-bac4b3f7cca2	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_health_checking	{"ts": "2026-05-04T09:01:52.825072+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 09:01:51.927
ac044e99-e9d8-4d88-8cc0-6885d5425cab	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_health_checking	{"ts": "2026-05-04T09:01:54.833970+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 09:01:53.975
bec1b53e-7c4b-437f-bcfd-c7a50a83ce83	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_ready	{"ts": "2026-05-04T09:01:54.833985+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 09:01:53.977
cdcfa615-4e4e-46f3-be9a-93ca3f45c03a	58582e3f-f8bd-4147-b9ed-38a510ceb745	launch_ready	{"ts": "2026-05-04T09:01:54.833994+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 09:01:53.978
a3b8c71b-7fa6-460f-b2fa-59abb24b404f	58582e3f-f8bd-4147-b9ed-38a510ceb745	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.88.57.107:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 09:01:53.984
56d8873c-1a80-402b-98e3-617dd7c7dc4d	58582e3f-f8bd-4147-b9ed-38a510ceb745	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 3500, "durationSeconds": 94, "terminationReason": "user_requested", "alreadyBilledCents": 3500, "remainingChargeCents": 0}	\N	2026-05-04 09:03:28.745
6662e2e3-60d6-4230-8a2f-7213cc2aea77	892af945-7115-46cb-885e-2f44d9988218	session_created	{"configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "instanceName": "gpu-instance-o2tr", "interfaceMode": "gui"}	\N	2026-05-04 09:03:40.747
8ae39a99-9a34-4128-af42-aac3e2c8e37c	892af945-7115-46cb-885e-2f44d9988218	launch_initiated	{"launchId": "eb800e36-2ac7-44fa-8c21-4e6ecdd3f206", "containerName": "laas-892af945"}	\N	2026-05-04 09:03:40.793
e75aea61-2f3b-4cd5-b08d-df34c47bd879	892af945-7115-46cb-885e-2f44d9988218	launch_scheduling	{"ts": "2026-05-04T09:03:42.500096+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 09:03:42.823
a2e2b108-61b8-4d9f-8646-c5bf7a1468a8	892af945-7115-46cb-885e-2f44d9988218	launch_scheduling	{"ts": "2026-05-04T09:03:42.600258+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 09:03:42.824
241b6c4d-45cd-4af4-9929-08a8f9d92619	892af945-7115-46cb-885e-2f44d9988218	launch_allocating_ports	{"ts": "2026-05-04T09:03:42.600359+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 09:03:42.825
7a264e52-6729-4b25-afaa-3d77aee01b20	892af945-7115-46cb-885e-2f44d9988218	launch_allocating_ports	{"ts": "2026-05-04T09:03:42.621695+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 09:03:42.826
a69ed0dd-826c-4876-8f8e-0b65020eef41	892af945-7115-46cb-885e-2f44d9988218	launch_allocating_cpus	{"ts": "2026-05-04T09:03:42.621700+00:00", "status": "in_progress", "message": "Finding 8 contiguous CPU cores..."}	\N	2026-05-04 09:03:42.827
a00f6946-79ee-4b07-8478-b92d9249c97d	892af945-7115-46cb-885e-2f44d9988218	launch_allocating_cpus	{"ts": "2026-05-04T09:03:42.631583+00:00", "status": "completed", "message": "Allocated CPU cores: 2-9"}	\N	2026-05-04 09:03:42.828
ccc9dad0-24a9-4ff9-9545-a0d7edb54324	892af945-7115-46cb-885e-2f44d9988218	launch_validating_mount	{"ts": "2026-05-04T09:03:42.631594+00:00", "status": "in_progress", "message": "Verifying local ZFS zvol for u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 09:03:42.829
4968de22-a952-4296-8314-355e35b4dcb8	892af945-7115-46cb-885e-2f44d9988218	launch_validating_mount	{"ts": "2026-05-04T09:03:42.631706+00:00", "status": "completed", "message": "Local ZFS zvol verified: /datapool/users/u_c1e2324f5a10e9f2dbb54508"}	\N	2026-05-04 09:03:42.83
cd4ad79f-ed14-4d5a-b708-e59b797482e2	892af945-7115-46cb-885e-2f44d9988218	launch_creating	{"ts": "2026-05-04T09:03:42.631740+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 09:03:42.831
ed8c3c60-5831-4fe8-8012-4e593ebfd88b	892af945-7115-46cb-885e-2f44d9988218	launch_creating	{"ts": "2026-05-04T09:03:42.718830+00:00", "status": "completed", "message": "Container created: laas-892af945"}	\N	2026-05-04 09:03:42.831
533eb8ce-1c8c-4f51-b13d-480bc1ace038	892af945-7115-46cb-885e-2f44d9988218	launch_starting	{"ts": "2026-05-04T09:03:42.718841+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 09:03:42.832
c07d3818-d4c1-4ccd-a4b9-f791a2f6f640	892af945-7115-46cb-885e-2f44d9988218	launch_starting	{"ts": "2026-05-04T09:03:43.039106+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 09:03:42.833
17743754-9562-48be-85e7-f5b2f744ed12	892af945-7115-46cb-885e-2f44d9988218	launch_waiting_desktop	{"ts": "2026-05-04T09:03:43.039118+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 09:03:42.833
4a46848e-f859-47a3-aa79-780498ef162e	892af945-7115-46cb-885e-2f44d9988218	launch_waiting_desktop	{"ts": "2026-05-04T09:03:57.177112+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 09:03:56.994
05b99b51-5534-44b7-be31-4111cbad055c	892af945-7115-46cb-885e-2f44d9988218	launch_waiting_desktop	{"ts": "2026-05-04T09:03:57.177126+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 09:03:56.996
f7badc51-1252-45b4-a8f3-f1f0d7d3c848	892af945-7115-46cb-885e-2f44d9988218	launch_health_checking	{"ts": "2026-05-04T09:03:57.177129+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 09:03:56.998
4dd36b12-9290-4a03-8377-0446ac4ee21d	892af945-7115-46cb-885e-2f44d9988218	launch_health_checking	{"ts": "2026-05-04T09:03:59.185613+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 09:03:59.03
b9982806-dec7-499a-b062-b8d93a5269b5	892af945-7115-46cb-885e-2f44d9988218	launch_ready	{"ts": "2026-05-04T09:03:59.185628+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 09:03:59.031
04ae5bcc-dde8-424d-ab6b-587791b8dd89	892af945-7115-46cb-885e-2f44d9988218	launch_ready	{"ts": "2026-05-04T09:03:59.185638+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 09:03:59.033
df846a11-4bf8-41d8-933b-5146d3332842	892af945-7115-46cb-885e-2f44d9988218	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.88.57.107:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 09:03:59.039
322d3ece-7ebc-46e3-8c83-a2761c306052	892af945-7115-46cb-885e-2f44d9988218	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 10500, "durationSeconds": 741, "terminationReason": "user_requested", "alreadyBilledCents": 10500, "remainingChargeCents": 0}	\N	2026-05-04 09:16:20.679
8486c980-e484-46a7-9397-ba742543d43c	68dd70a4-c61f-4fb1-85a4-9939e4643493	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-7155", "interfaceMode": "gui"}	\N	2026-05-04 09:16:35.149
c76bf30d-c5b4-44dc-918c-0c72b93c4748	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_initiated	{"launchId": "bda8f6bd-3a8f-4ae4-bf3c-8598605f058f", "containerName": "laas-68dd70a4"}	\N	2026-05-04 09:16:35.196
6aac6724-6a75-4b95-a6a0-2f2079aa90a9	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_scheduling	{"ts": "2026-05-04T09:16:36.917956+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 09:16:37.237
0495121c-189e-4b1d-802c-11249674bd13	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_scheduling	{"ts": "2026-05-04T09:16:37.018127+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 09:16:37.239
598940eb-92f5-422a-b5de-94f93b155cfd	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_allocating_ports	{"ts": "2026-05-04T09:16:37.018240+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 09:16:37.241
4619c4a5-36e3-49f6-b40a-dc6843187655	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_allocating_ports	{"ts": "2026-05-04T09:16:37.039633+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 09:16:37.242
6222470b-731e-4d19-b423-6bada6d27a8c	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_allocating_cpus	{"ts": "2026-05-04T09:16:37.039638+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 09:16:37.244
4713d273-a764-4d79-a2a5-89e413a6a354	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_allocating_cpus	{"ts": "2026-05-04T09:16:37.048765+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 09:16:37.246
515066c4-91a0-47ce-bb3b-164dce1ec907	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_validating_mount	{"ts": "2026-05-04T09:16:37.048780+00:00", "status": "in_progress", "message": "Verifying local ZFS zvol for u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 09:16:37.247
5f16f5b9-bcb6-4907-8274-58b640696497	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_validating_mount	{"ts": "2026-05-04T09:16:37.048917+00:00", "status": "completed", "message": "Local ZFS zvol verified: /datapool/users/u_c1e2324f5a10e9f2dbb54508"}	\N	2026-05-04 09:16:37.249
53a3bea6-0c42-448b-99b4-57ebc761098a	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_creating	{"ts": "2026-05-04T09:16:37.048961+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 09:16:37.25
801508ab-0f67-41b3-bd38-86b825c2bac8	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_creating	{"ts": "2026-05-04T09:16:37.124343+00:00", "status": "completed", "message": "Container created: laas-68dd70a4"}	\N	2026-05-04 09:16:37.252
c0865e79-7b80-4500-8eaa-ff0f77cf276f	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_starting	{"ts": "2026-05-04T09:16:37.124351+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 09:16:37.254
620c618e-39cc-4c97-8da3-1a5d7299993b	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_starting	{"ts": "2026-05-04T09:16:37.416977+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 09:16:37.256
e6ef9f03-45e0-4322-9529-de2d59031ddc	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_waiting_desktop	{"ts": "2026-05-04T09:16:37.416994+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 09:16:37.257
701e89a1-85a4-402b-b289-716ff60fe67b	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_waiting_desktop	{"ts": "2026-05-04T09:16:55.594234+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 09:16:55.491
5408184c-2b22-4996-a86c-6b166f95b7a1	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_waiting_desktop	{"ts": "2026-05-04T09:16:55.594250+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 09:16:55.493
4eebe244-906e-4b05-9bca-c88d5d21611a	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_health_checking	{"ts": "2026-05-04T09:16:55.594254+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 09:16:55.494
889a0c06-7d02-4e92-bb12-489133c754b7	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_health_checking	{"ts": "2026-05-04T09:16:57.602842+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 09:16:57.519
2aa49d0c-6e6f-48ae-b382-1965bbfe7124	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_ready	{"ts": "2026-05-04T09:16:57.602857+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 09:16:57.52
51dda51d-32a6-47b3-aaa9-7eff0378709a	68dd70a4-c61f-4fb1-85a4-9939e4643493	launch_ready	{"ts": "2026-05-04T09:16:57.602865+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 09:16:57.521
3d3e85f2-8262-4b18-b91a-27b35f8d217c	68dd70a4-c61f-4fb1-85a4-9939e4643493	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.88.57.107:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 09:16:57.526
cef2a697-39e9-4e0f-91bb-bf3fa1bb1d38	79446928-3d68-4633-ae84-6febe94609fc	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "instanceName": "gpu-instance-nkd5", "interfaceMode": "gui"}	\N	2026-05-04 09:19:36.337
87c5f388-2f4c-4f7b-b4e8-2e04bb0c6be8	79446928-3d68-4633-ae84-6febe94609fc	launch_initiated	{"launchId": "f5cd0ab1-0c74-471c-8985-2ec61ecb7779", "containerName": "laas-79446928"}	\N	2026-05-04 09:19:36.408
4540c084-94d0-4ec3-b5b6-802dbbca2dca	79446928-3d68-4633-ae84-6febe94609fc	launch_scheduling	{"ts": "2026-05-04T09:19:38.131729+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 09:19:38.425
4a94e5ee-27ea-4f10-8b84-d1582fdedb75	79446928-3d68-4633-ae84-6febe94609fc	launch_scheduling	{"ts": "2026-05-04T09:19:38.232144+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 09:19:38.429
bcd12e9d-83b7-4951-8e5f-4429736a397e	79446928-3d68-4633-ae84-6febe94609fc	launch_allocating_ports	{"ts": "2026-05-04T09:19:38.232280+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 09:19:38.432
9f992583-7d8a-4878-8de1-be47c3666523	79446928-3d68-4633-ae84-6febe94609fc	launch_allocating_ports	{"ts": "2026-05-04T09:19:38.256264+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 09:19:38.434
905b7b6e-5726-4a19-8100-4c4b164a5fc2	79446928-3d68-4633-ae84-6febe94609fc	launch_allocating_cpus	{"ts": "2026-05-04T09:19:38.256271+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 09:19:38.438
ede4eb71-5408-428b-9704-ec3fb9a679c4	79446928-3d68-4633-ae84-6febe94609fc	launch_allocating_cpus	{"ts": "2026-05-04T09:19:38.267586+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 09:19:38.441
0905a948-760f-42f6-87a2-b94653ec72e0	79446928-3d68-4633-ae84-6febe94609fc	launch_allocating_storage	{"ts": "2026-05-04T09:19:38.267596+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-04 09:19:38.444
44b8ff8a-2c24-49fd-8ec2-0db53a3c5d46	79446928-3d68-4633-ae84-6febe94609fc	launch_allocating_storage	{"ts": "2026-05-04T09:19:38.267601+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_79446928-3d68-4633-ae84-6febe94609fc..."}	\N	2026-05-04 09:19:38.448
b6d7ab07-148e-48a6-9709-3ad32d4f5a01	79446928-3d68-4633-ae84-6febe94609fc	launch_allocating_storage	{"ts": "2026-05-04T09:19:38.963799+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_79446928-3d68-4633-ae84-6febe94609fc"}	\N	2026-05-04 09:19:38.45
c5245645-07b6-4e52-b1c8-5d57e4bc9c58	79446928-3d68-4633-ae84-6febe94609fc	launch_creating	{"ts": "2026-05-04T09:19:38.963847+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 09:19:38.452
5e9d3ad2-902c-4868-8dab-0618b1627d4c	79446928-3d68-4633-ae84-6febe94609fc	launch_creating	{"ts": "2026-05-04T09:19:39.036326+00:00", "status": "completed", "message": "Container created: laas-79446928"}	\N	2026-05-04 09:19:38.454
a707cdb6-41b3-462e-a6d9-7ceafc54dab8	79446928-3d68-4633-ae84-6febe94609fc	launch_starting	{"ts": "2026-05-04T09:19:39.036335+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 09:19:38.458
4ca1d8a6-cef2-41ca-9055-bcebcd7a7f44	79446928-3d68-4633-ae84-6febe94609fc	launch_starting	{"ts": "2026-05-04T09:19:39.340474+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 09:19:38.461
9923feda-6d52-4f20-98a7-c00ca2ceb451	79446928-3d68-4633-ae84-6febe94609fc	launch_waiting_desktop	{"ts": "2026-05-04T09:19:39.340486+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 09:19:38.463
f14f55ce-8200-4ad7-92dd-a861ed5621ea	79446928-3d68-4633-ae84-6febe94609fc	launch_waiting_desktop	{"ts": "2026-05-04T09:19:53.475256+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 09:19:52.622
ceaea88c-af3c-4609-ad3a-99a91415bb9c	79446928-3d68-4633-ae84-6febe94609fc	launch_waiting_desktop	{"ts": "2026-05-04T09:19:53.475271+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 09:19:52.624
65394773-dd1c-4ac2-8d7a-b9be52c35b7f	79446928-3d68-4633-ae84-6febe94609fc	launch_health_checking	{"ts": "2026-05-04T09:19:53.475276+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 09:19:52.626
75a4a78f-6e57-4f42-a8d8-2d9b7b8b5aa1	79446928-3d68-4633-ae84-6febe94609fc	launch_health_checking	{"ts": "2026-05-04T09:19:55.484173+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 09:19:54.647
de07b4a2-1a12-46a4-90f0-e90a53fa6497	79446928-3d68-4633-ae84-6febe94609fc	launch_ready	{"ts": "2026-05-04T09:19:55.484192+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 09:19:54.65
5378b6ca-6ece-4bb6-b726-8486944294ed	79446928-3d68-4633-ae84-6febe94609fc	launch_ready	{"ts": "2026-05-04T09:19:55.484202+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 09:19:54.652
5bd9b894-72c1-4595-a462-970eb0ffce47	79446928-3d68-4633-ae84-6febe94609fc	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 09:19:54.664
0320c65a-5c08-442c-80c0-cf75e8159e3c	68dd70a4-c61f-4fb1-85a4-9939e4643493	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 15500, "durationSeconds": 660, "terminationReason": "user_requested", "alreadyBilledCents": 15500, "remainingChargeCents": 0}	\N	2026-05-04 09:27:57.733
7e6676ae-23dc-466e-b01b-ec46d8a5b5a8	79446928-3d68-4633-ae84-6febe94609fc	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 15500, "durationSeconds": 563, "terminationReason": "user_requested", "alreadyBilledCents": 15500, "remainingChargeCents": 0}	\N	2026-05-04 09:29:17.726
32c10619-e635-41bc-afeb-6b0608cee8d6	1df95352-8d8e-4ba9-874d-5380c3902827	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "instanceName": "gpu-instance-80zn", "interfaceMode": "gui"}	\N	2026-05-04 09:31:03.242
3bec2766-9288-4694-9f27-f074cddf9724	1df95352-8d8e-4ba9-874d-5380c3902827	launch_initiated	{"launchId": "22fc7a42-b8f3-4706-aedd-47dec0908222", "containerName": "laas-1df95352"}	\N	2026-05-04 09:31:03.301
b44947bf-ca9d-49c9-b531-641087a48e64	1df95352-8d8e-4ba9-874d-5380c3902827	launch_scheduling	{"ts": "2026-05-04T09:31:05.032996+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 09:31:05.369
75a3d90c-a334-4b4f-8bfe-ca5a79f78635	1df95352-8d8e-4ba9-874d-5380c3902827	launch_scheduling	{"ts": "2026-05-04T09:31:05.133179+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 09:31:05.371
c38cef4c-d6e3-4d8f-aead-8d0ee9fded39	1df95352-8d8e-4ba9-874d-5380c3902827	launch_allocating_ports	{"ts": "2026-05-04T09:31:05.133288+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 09:31:05.372
ef18fa31-2f46-4385-9121-7c6f53e019b9	1df95352-8d8e-4ba9-874d-5380c3902827	launch_allocating_ports	{"ts": "2026-05-04T09:31:05.154123+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 09:31:05.374
909dc738-9070-44a8-b81c-f3f78135368d	1df95352-8d8e-4ba9-874d-5380c3902827	launch_allocating_cpus	{"ts": "2026-05-04T09:31:05.154130+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 09:31:05.375
a0ed3880-28ae-439b-81ee-7e937fd5402f	1df95352-8d8e-4ba9-874d-5380c3902827	launch_allocating_cpus	{"ts": "2026-05-04T09:31:05.165476+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 09:31:05.376
9ad8b944-2dc8-4397-a652-80cdb5d1f4d7	1df95352-8d8e-4ba9-874d-5380c3902827	launch_allocating_storage	{"ts": "2026-05-04T09:31:05.165486+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-04 09:31:05.377
02e54c22-41be-4937-8732-21870b032716	1df95352-8d8e-4ba9-874d-5380c3902827	launch_allocating_storage	{"ts": "2026-05-04T09:31:05.165492+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_1df95352-8d8e-4ba9-874d-5380c3902827..."}	\N	2026-05-04 09:31:05.378
8656252a-343a-43af-849c-408eb4509c34	1df95352-8d8e-4ba9-874d-5380c3902827	launch_allocating_storage	{"ts": "2026-05-04T09:31:05.872028+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_1df95352-8d8e-4ba9-874d-5380c3902827"}	\N	2026-05-04 09:31:05.379
cb3cc3f0-43df-4b59-8179-a9068f1bcf95	1df95352-8d8e-4ba9-874d-5380c3902827	launch_creating	{"ts": "2026-05-04T09:31:05.872072+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 09:31:05.38
1c80d198-71cf-4fa2-bc30-36768a0dda25	1df95352-8d8e-4ba9-874d-5380c3902827	launch_creating	{"ts": "2026-05-04T09:31:05.946335+00:00", "status": "completed", "message": "Container created: laas-1df95352"}	\N	2026-05-04 09:31:05.381
e341f4b7-08a6-426e-ae1f-5dd60404bd4e	1df95352-8d8e-4ba9-874d-5380c3902827	launch_starting	{"ts": "2026-05-04T09:31:05.946346+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 09:31:05.382
2c27c885-cfbe-4853-b7fa-2cc7c49552a7	1df95352-8d8e-4ba9-874d-5380c3902827	launch_starting	{"ts": "2026-05-04T09:31:06.271790+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 09:31:05.382
a5082c26-9507-4152-a59f-516cc822f66f	1df95352-8d8e-4ba9-874d-5380c3902827	launch_waiting_desktop	{"ts": "2026-05-04T09:31:06.271802+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 09:31:05.383
f1782384-10aa-41d3-abed-02d1ab95a672	1df95352-8d8e-4ba9-874d-5380c3902827	launch_waiting_desktop	{"ts": "2026-05-04T09:31:24.451454+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 09:31:23.633
51aa54c0-5458-4ae2-a335-c17ffe1a00ab	1df95352-8d8e-4ba9-874d-5380c3902827	launch_waiting_desktop	{"ts": "2026-05-04T09:31:24.451464+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 09:31:23.634
05a5bc70-7ef7-4dfd-95c5-ccd455a13202	1df95352-8d8e-4ba9-874d-5380c3902827	launch_health_checking	{"ts": "2026-05-04T09:31:24.451467+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 09:31:23.636
e9da2c33-7ce5-449d-9211-274964521c30	1df95352-8d8e-4ba9-874d-5380c3902827	launch_health_checking	{"ts": "2026-05-04T09:31:26.459095+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 09:31:25.668
263317b6-5b3b-4859-bad1-37ae27508d77	1df95352-8d8e-4ba9-874d-5380c3902827	launch_ready	{"ts": "2026-05-04T09:31:26.459108+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 09:31:25.669
c2994983-ec72-474c-9b6e-35f0f284d56f	1df95352-8d8e-4ba9-874d-5380c3902827	launch_ready	{"ts": "2026-05-04T09:31:26.459114+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 09:31:25.67
ab174ffd-efe6-4869-8eea-c8ea103d2bcb	1df95352-8d8e-4ba9-874d-5380c3902827	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.88.57.107:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 09:31:25.676
6ed35536-77de-489d-b486-f29816070e71	2bf80869-f34a-44dd-88c6-9d70dcbe6522	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-1rep", "interfaceMode": "gui"}	\N	2026-05-04 09:33:16.884
8a421f00-cc2e-47f3-b61d-f458db89214a	e8abcaec-ced4-4ad3-802c-e426049aa03a	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-9w0r", "interfaceMode": "gui"}	\N	2026-05-04 10:13:58.614
62d83fb3-2aa8-460d-9e9f-662bfda77784	e8abcaec-ced4-4ad3-802c-e426049aa03a	launch_initiated	{"launchId": "c17a980e-e762-4d21-98eb-5223499bd39d", "containerName": "laas-e8abcaec"}	\N	2026-05-04 10:13:58.7
5a843c3a-4a14-416d-b31d-51e68d92a3fa	e8abcaec-ced4-4ad3-802c-e426049aa03a	launch_scheduling	{"ts": "2026-05-04T10:14:00.472362+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 10:14:00.731
caa7cbea-9996-48b5-9df9-d1f4c48bdb80	e8abcaec-ced4-4ad3-802c-e426049aa03a	launch_scheduling	{"ts": "2026-05-04T10:14:00.572786+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 10:14:00.737
86f1def1-9223-4c13-b27c-5b3ae47dafbd	e8abcaec-ced4-4ad3-802c-e426049aa03a	launch_allocating_ports	{"ts": "2026-05-04T10:14:00.572909+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 10:14:00.739
07596a22-806e-4394-ac7d-cfe648bef65f	e8abcaec-ced4-4ad3-802c-e426049aa03a	launch_allocating_ports	{"ts": "2026-05-04T10:14:00.595854+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 10:14:00.742
9dbdd150-281c-4b97-8e70-f953540a6244	e8abcaec-ced4-4ad3-802c-e426049aa03a	launch_allocating_cpus	{"ts": "2026-05-04T10:14:00.595859+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 10:14:00.744
8dbc2b64-f61b-43b2-be60-c013863fd249	e8abcaec-ced4-4ad3-802c-e426049aa03a	launch_allocating_cpus	{"ts": "2026-05-04T10:14:00.605378+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 10:14:00.746
5db4a63a-3680-4c4c-8690-16c7c3ae6582	e8abcaec-ced4-4ad3-802c-e426049aa03a	launch_validating_mount	{"ts": "2026-05-04T10:14:00.605391+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 10:14:00.748
aeef9a77-06f1-4165-bfec-7b647f01f125	e8abcaec-ced4-4ad3-802c-e426049aa03a	launch_nvme_discovering	{"ts": "2026-05-04T10:14:00.605477+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-04 10:14:00.75
c03c1568-e5ee-452e-af12-a85d6ff02f1b	e8abcaec-ced4-4ad3-802c-e426049aa03a	launch_nvme_discover	{"ts": "2026-05-04T10:14:00.606462+00:00", "status": "failed", "message": "NVMe-oF failed at discover: Subsystem laas-u_c1e2324f5a10e9f2dbb54508 not found in discovery output"}	\N	2026-05-04 10:14:00.752
00c0f286-8c90-4a5c-a13c-a1af21f6c807	e8abcaec-ced4-4ad3-802c-e426049aa03a	launch_failed	{"reason": "NVMe-oF failed at discover: Subsystem laas-u_c1e2324f5a10e9f2dbb54508 not found in discovery output"}	\N	2026-05-04 10:14:00.778
d30ec212-2b23-47aa-a9a1-a4a2444769c8	c981876b-8aab-49ce-95c2-718f19c1180d	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-cxr3", "interfaceMode": "gui"}	\N	2026-05-04 10:27:36.318
ab0c4d10-a422-4c81-84d9-1ede564d7e5c	c981876b-8aab-49ce-95c2-718f19c1180d	launch_initiated	{"launchId": "388f9711-d260-4d74-a636-d39ccda3e0c9", "containerName": "laas-c981876b"}	\N	2026-05-04 10:27:36.384
9dc9ee5f-ac04-40b3-ba39-c62d35503506	c981876b-8aab-49ce-95c2-718f19c1180d	launch_scheduling	{"ts": "2026-05-04T10:27:38.183098+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 10:27:38.403
1033c086-03c6-4e25-8f0a-bc53cb7c0875	c981876b-8aab-49ce-95c2-718f19c1180d	launch_scheduling	{"ts": "2026-05-04T10:27:38.283296+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 10:27:38.405
2e8b5854-ce4f-42c3-b969-aa854ecb5903	c981876b-8aab-49ce-95c2-718f19c1180d	launch_allocating_ports	{"ts": "2026-05-04T10:27:38.283409+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 10:27:38.406
81d4f937-c9ac-4629-be48-4e7339206551	c981876b-8aab-49ce-95c2-718f19c1180d	launch_allocating_ports	{"ts": "2026-05-04T10:27:38.304699+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 10:27:38.408
00bfd594-db2b-4d75-a4ef-9942cb1a30cd	c981876b-8aab-49ce-95c2-718f19c1180d	launch_allocating_cpus	{"ts": "2026-05-04T10:27:38.304709+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 10:27:38.409
f0ccc603-bac5-4d4f-bf79-646ac69d1370	c981876b-8aab-49ce-95c2-718f19c1180d	launch_allocating_cpus	{"ts": "2026-05-04T10:27:38.313620+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 10:27:38.409
2d548e8b-212f-4ba5-8a8c-076c6db33931	c981876b-8aab-49ce-95c2-718f19c1180d	launch_validating_mount	{"ts": "2026-05-04T10:27:38.313643+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 10:27:38.411
40e9b298-c28d-4142-ac02-5d35d2d3d087	c981876b-8aab-49ce-95c2-718f19c1180d	launch_nvme_discovering	{"ts": "2026-05-04T10:27:38.313774+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-04 10:27:38.412
aa37c85a-d761-4fde-833c-96b12e28def6	c981876b-8aab-49ce-95c2-718f19c1180d	launch_nvme_discovering	{"ts": "2026-05-04T10:27:38.337490+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-04 10:27:38.413
456aeab6-d6ac-4ace-8be7-8cf6e95f19c7	c981876b-8aab-49ce-95c2-718f19c1180d	launch_nvme_connecting	{"ts": "2026-05-04T10:27:38.337567+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 10:27:38.414
20c5ca69-1168-444a-9b10-00804bcd26d4	c981876b-8aab-49ce-95c2-718f19c1180d	launch_nvme_connecting	{"ts": "2026-05-04T10:27:38.360074+00:00", "status": "completed", "message": "NVMe-oF connected"}	\N	2026-05-04 10:27:38.415
8626efd6-f367-429c-91ce-cae408dc55c4	c981876b-8aab-49ce-95c2-718f19c1180d	launch_nvme_finding_device	{"ts": "2026-05-04T10:27:38.360115+00:00", "status": "in_progress", "message": "Locating NVMe block device..."}	\N	2026-05-04 10:27:38.415
53907e87-ccaa-4c5e-bcf9-7026542a0e71	c981876b-8aab-49ce-95c2-718f19c1180d	launch_nvme_find_device	{"ts": "2026-05-04T10:27:38.863026+00:00", "status": "failed", "message": "NVMe-oF failed at find_device: Block device not found for laas-u_c1e2324f5a10e9f2dbb54508"}	\N	2026-05-04 10:27:38.416
303a6c3d-7d3c-465e-b356-f7e18f4ab8a6	c981876b-8aab-49ce-95c2-718f19c1180d	launch_failed	{"reason": "NVMe-oF failed at find_device: Block device not found for laas-u_c1e2324f5a10e9f2dbb54508"}	\N	2026-05-04 10:27:38.433
543b8c7d-580c-4b77-b98c-ce64be2d0918	e361492d-7c2b-4e11-8e45-79fb1fe9085b	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-gjm2", "interfaceMode": "gui"}	\N	2026-05-04 10:32:09.781
e798c340-d513-44c3-b673-8d3a6d7b7d5a	e361492d-7c2b-4e11-8e45-79fb1fe9085b	launch_initiated	{"launchId": "7c3d4082-6641-4452-a0a4-f42697487b77", "containerName": "laas-e361492d"}	\N	2026-05-04 10:32:09.834
c2e795ac-75c0-4063-8eb9-9847da624e19	e361492d-7c2b-4e11-8e45-79fb1fe9085b	launch_scheduling	{"ts": "2026-05-04T10:32:11.640792+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 10:32:11.861
22a0fb6c-c3b1-49ae-ae8b-f9fc445f7eba	e361492d-7c2b-4e11-8e45-79fb1fe9085b	launch_scheduling	{"ts": "2026-05-04T10:32:11.741227+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 10:32:11.862
f8522a3b-426d-4522-8333-f852f55b3320	e361492d-7c2b-4e11-8e45-79fb1fe9085b	launch_allocating_ports	{"ts": "2026-05-04T10:32:11.741338+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 10:32:11.864
dfaff5e8-b30b-4ef0-bdc5-2f9e520eb7cb	e361492d-7c2b-4e11-8e45-79fb1fe9085b	launch_allocating_ports	{"ts": "2026-05-04T10:32:11.761884+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 10:32:11.865
f146ebb7-bb90-459c-8c3d-bc1c1e06302c	e361492d-7c2b-4e11-8e45-79fb1fe9085b	launch_allocating_cpus	{"ts": "2026-05-04T10:32:11.761894+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 10:32:11.866
d6afd9fe-210c-4b3c-91ac-30501037e061	e361492d-7c2b-4e11-8e45-79fb1fe9085b	launch_allocating_cpus	{"ts": "2026-05-04T10:32:11.770223+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 10:32:11.867
dadc84dd-268d-4b94-9030-43ad46b5100c	e361492d-7c2b-4e11-8e45-79fb1fe9085b	launch_validating_mount	{"ts": "2026-05-04T10:32:11.770246+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 10:32:11.868
d818d1be-153a-4b9e-92c8-c16009c11ba9	e361492d-7c2b-4e11-8e45-79fb1fe9085b	launch_nvme_discovering	{"ts": "2026-05-04T10:32:11.770368+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-04 10:32:11.868
750130af-d8ed-465e-9e1c-f92cea3be508	e361492d-7c2b-4e11-8e45-79fb1fe9085b	launch_nvme_discovering	{"ts": "2026-05-04T10:32:11.793293+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-04 10:32:11.87
6c9dc682-3a7a-4cad-9276-ed702e9ae856	e361492d-7c2b-4e11-8e45-79fb1fe9085b	launch_nvme_connecting	{"ts": "2026-05-04T10:32:11.793372+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 10:32:11.87
8233d87a-79e3-444a-a4ff-e7b98f04dc4e	e361492d-7c2b-4e11-8e45-79fb1fe9085b	launch_nvme_connect	{"ts": "2026-05-04T10:32:11.802511+00:00", "status": "failed", "message": "NVMe-oF failed at connect: Connect failed: "}	\N	2026-05-04 10:32:11.872
0adc0582-3ecd-4ac1-bca8-63a2cb86b3dc	e361492d-7c2b-4e11-8e45-79fb1fe9085b	launch_failed	{"reason": "NVMe-oF failed at connect: Connect failed: "}	\N	2026-05-04 10:32:11.886
46efb29f-5e62-49fa-ba41-61cbe4a902c3	c356bb92-018c-421b-bbab-41b4817bac74	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-3hj2", "interfaceMode": "gui"}	\N	2026-05-04 10:38:58.221
67d24e72-3bd4-4225-8bf1-383d57f51866	c356bb92-018c-421b-bbab-41b4817bac74	launch_initiated	{"launchId": "39e1b75c-671c-4500-a5df-bd93bc5359df", "containerName": "laas-c356bb92"}	\N	2026-05-04 10:38:58.343
46c556a1-34f3-4cc4-818d-dbdf13aa6790	c356bb92-018c-421b-bbab-41b4817bac74	launch_scheduling	{"ts": "2026-05-04T10:39:00.124765+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 10:39:00.367
9a9fecf0-5463-437c-b371-5d3b8d6cbcc3	c356bb92-018c-421b-bbab-41b4817bac74	launch_scheduling	{"ts": "2026-05-04T10:39:00.225221+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 10:39:00.372
e874b864-b207-4032-bb95-06463fa8dafc	c356bb92-018c-421b-bbab-41b4817bac74	launch_allocating_ports	{"ts": "2026-05-04T10:39:00.225332+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 10:39:00.375
c5d9dd11-5c88-43e4-97c6-48e78ad4e6c5	c356bb92-018c-421b-bbab-41b4817bac74	launch_allocating_ports	{"ts": "2026-05-04T10:39:00.248482+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 10:39:00.378
9f6a1e1e-8621-4ffd-8f35-25e8183b7aca	c356bb92-018c-421b-bbab-41b4817bac74	launch_allocating_cpus	{"ts": "2026-05-04T10:39:00.248489+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 10:39:00.381
d9bcbfad-7614-4193-89ce-c92904358f05	c356bb92-018c-421b-bbab-41b4817bac74	launch_allocating_cpus	{"ts": "2026-05-04T10:39:00.259765+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 10:39:00.385
d19b4253-6521-4f3a-ba57-5e5050a0f6c5	c356bb92-018c-421b-bbab-41b4817bac74	launch_validating_mount	{"ts": "2026-05-04T10:39:00.259786+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 10:39:00.388
d9834307-755b-4ef3-af00-a870cf7e39e2	c356bb92-018c-421b-bbab-41b4817bac74	launch_nvme_discovering	{"ts": "2026-05-04T10:39:00.259902+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-04 10:39:00.39
c1392f79-2871-42fa-b1a3-5f0b4289d782	c356bb92-018c-421b-bbab-41b4817bac74	launch_nvme_discovering	{"ts": "2026-05-04T10:39:00.282614+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-04 10:39:00.393
86052d02-c238-439c-82b5-761e1debdccc	c356bb92-018c-421b-bbab-41b4817bac74	launch_nvme_connecting	{"ts": "2026-05-04T10:39:00.282689+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 10:39:00.395
41bd1011-c3f7-4174-8572-9ff802802c57	c356bb92-018c-421b-bbab-41b4817bac74	launch_nvme_connect	{"ts": "2026-05-04T10:39:00.306709+00:00", "status": "failed", "message": "NVMe-oF failed at connect: Connect failed: stdout=, stderr="}	\N	2026-05-04 10:39:00.397
edc3a263-33e1-4424-abd9-dca00d94788d	c356bb92-018c-421b-bbab-41b4817bac74	launch_failed	{"reason": "NVMe-oF failed at connect: Connect failed: stdout=, stderr="}	\N	2026-05-04 10:39:00.426
ae77a3f2-adb1-4118-96b5-21af4477b877	81c1ac01-1b20-445a-90f1-2cec8796087b	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-fbyh", "interfaceMode": "gui"}	\N	2026-05-04 10:50:18.022
68b56feb-70a7-4926-b1c7-947f056f300a	81c1ac01-1b20-445a-90f1-2cec8796087b	launch_initiated	{"launchId": "afa6e79b-6552-4240-b9b4-a874956843e2", "containerName": "laas-81c1ac01"}	\N	2026-05-04 10:50:18.086
3ae285a2-3940-41d7-a4a1-e2bbc39d1fa6	81c1ac01-1b20-445a-90f1-2cec8796087b	launch_scheduling	{"ts": "2026-05-04T10:50:19.915659+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 10:50:20.109
d8a5f2ad-1ee4-4586-ac85-35951fd30a7f	81c1ac01-1b20-445a-90f1-2cec8796087b	launch_scheduling	{"ts": "2026-05-04T10:50:20.016107+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 10:50:20.111
12dd83a2-120f-4499-98af-9b7d1389f34f	81c1ac01-1b20-445a-90f1-2cec8796087b	launch_allocating_ports	{"ts": "2026-05-04T10:50:20.016219+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 10:50:20.112
aa1a1df5-9ffc-492f-b519-4373d736fa1d	81c1ac01-1b20-445a-90f1-2cec8796087b	launch_allocating_ports	{"ts": "2026-05-04T10:50:20.037964+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 10:50:20.113
75bdafbb-2af4-479f-9e28-69071745f5fe	81c1ac01-1b20-445a-90f1-2cec8796087b	launch_allocating_cpus	{"ts": "2026-05-04T10:50:20.037974+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 10:50:20.115
863de72c-b2c8-4f80-be35-a2e4e9d992de	81c1ac01-1b20-445a-90f1-2cec8796087b	launch_allocating_cpus	{"ts": "2026-05-04T10:50:20.047846+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 10:50:20.116
013a0307-d3d7-4838-b476-7390c5a8568b	81c1ac01-1b20-445a-90f1-2cec8796087b	launch_validating_mount	{"ts": "2026-05-04T10:50:20.047866+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 10:50:20.118
5d6a9e92-0238-433a-b464-08b1e47200e2	81c1ac01-1b20-445a-90f1-2cec8796087b	launch_nvme_discovering	{"ts": "2026-05-04T10:50:20.047979+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-04 10:50:20.119
7c450040-162f-4cd8-a083-59f7da900eeb	81c1ac01-1b20-445a-90f1-2cec8796087b	launch_nvme_discovering	{"ts": "2026-05-04T10:50:20.065229+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-04 10:50:20.12
dd188e7a-06b3-40e5-9c31-05529e98b86c	81c1ac01-1b20-445a-90f1-2cec8796087b	launch_nvme_connecting	{"ts": "2026-05-04T10:50:20.065310+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 10:50:20.121
61d88eac-b7b8-4682-a97e-b250aa0e32c7	81c1ac01-1b20-445a-90f1-2cec8796087b	launch_nvme_connecting	{"ts": "2026-05-04T10:50:20.097954+00:00", "status": "completed", "message": "NVMe-oF connected"}	\N	2026-05-04 10:50:20.122
ac4712d9-bb77-4589-854e-1aa777820b21	81c1ac01-1b20-445a-90f1-2cec8796087b	launch_nvme_finding_device	{"ts": "2026-05-04T10:50:20.098005+00:00", "status": "in_progress", "message": "Locating NVMe block device..."}	\N	2026-05-04 10:50:20.123
6f409344-cc62-4cb9-8ea7-8cfd7e3f3ae1	81c1ac01-1b20-445a-90f1-2cec8796087b	launch_nvme_finding_device	{"ts": "2026-05-04T10:50:20.608592+00:00", "status": "completed", "message": "Block device found: /dev/nvme1n1"}	\N	2026-05-04 10:50:20.124
f8f873a2-92cb-416c-9656-5ee3e6b805ee	81c1ac01-1b20-445a-90f1-2cec8796087b	launch_nvme_mounting	{"ts": "2026-05-04T10:50:20.608699+00:00", "status": "in_progress", "message": "Mounting /dev/nvme1n1 to /mnt/nvme/u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 10:50:20.126
85f3c199-0921-43cd-838a-89a5dd8c7eaf	81c1ac01-1b20-445a-90f1-2cec8796087b	launch_validating_mount	{"ts": "2026-05-04T10:50:20.608738+00:00", "status": "failed", "message": "NVMe-oF setup unexpected error: [Errno 13] Permission denied: '/mnt/nvme'"}	\N	2026-05-04 10:50:20.127
7c75f39e-113a-49aa-bcd6-0136f5682a15	81c1ac01-1b20-445a-90f1-2cec8796087b	launch_failed	{"reason": "NVMe-oF setup unexpected error: [Errno 13] Permission denied: '/mnt/nvme'"}	\N	2026-05-04 10:50:20.147
ccaffbf5-7f13-4a42-aa9a-f7f958abb1b0	5abe4167-7866-4fb9-ab65-0a536167658b	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-fl3c", "interfaceMode": "gui"}	\N	2026-05-04 10:54:37.239
a1c5390a-46bb-40bb-9733-970ab525c145	5abe4167-7866-4fb9-ab65-0a536167658b	launch_initiated	{"launchId": "495bb5c4-760f-4e19-9f2f-ea04261ec0d6", "containerName": "laas-5abe4167"}	\N	2026-05-04 10:54:37.294
f1fe1ea4-3d53-4769-b713-6f282d6fab04	5abe4167-7866-4fb9-ab65-0a536167658b	launch_scheduling	{"ts": "2026-05-04T10:54:39.126798+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 10:54:39.338
114e4919-3cd9-4113-9dfc-a2e79cac8a84	5abe4167-7866-4fb9-ab65-0a536167658b	launch_scheduling	{"ts": "2026-05-04T10:54:39.227254+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 10:54:39.345
c01a5f07-9c25-441f-985e-867a82b1fb5d	5abe4167-7866-4fb9-ab65-0a536167658b	launch_allocating_ports	{"ts": "2026-05-04T10:54:39.227374+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 10:54:39.352
d8549c5f-b129-4554-9e1e-ce05e3161caa	5abe4167-7866-4fb9-ab65-0a536167658b	launch_allocating_ports	{"ts": "2026-05-04T10:54:39.247094+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 10:54:39.359
616d475d-f5d5-4ce7-83f5-3cfa57eb2860	5abe4167-7866-4fb9-ab65-0a536167658b	launch_allocating_cpus	{"ts": "2026-05-04T10:54:39.247104+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 10:54:39.37
bf338cb2-bb34-4f60-946c-4665cd7628c9	5abe4167-7866-4fb9-ab65-0a536167658b	launch_allocating_cpus	{"ts": "2026-05-04T10:54:39.256146+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 10:54:39.382
06b48dbf-729f-47c5-b940-dec1f5762fc7	5abe4167-7866-4fb9-ab65-0a536167658b	launch_validating_mount	{"ts": "2026-05-04T10:54:39.256163+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 10:54:39.389
3cf9ffb2-dd73-4971-a523-37dcc8292217	5abe4167-7866-4fb9-ab65-0a536167658b	launch_nvme_discovering	{"ts": "2026-05-04T10:54:39.256285+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-04 10:54:39.397
af7ea575-7f27-4049-a4ba-ab06b13cd5b4	5abe4167-7866-4fb9-ab65-0a536167658b	launch_nvme_discovering	{"ts": "2026-05-04T10:54:39.277395+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-04 10:54:39.409
46658611-9ec6-4480-a85f-36c73e575d6d	5abe4167-7866-4fb9-ab65-0a536167658b	launch_nvme_connecting	{"ts": "2026-05-04T10:54:39.277492+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 10:54:39.428
9421cad8-68c4-4639-a45c-b557cdd98abd	5abe4167-7866-4fb9-ab65-0a536167658b	launch_nvme_connecting	{"ts": "2026-05-04T10:54:39.295830+00:00", "status": "completed", "message": "NVMe-oF already connected at /dev/nvme1n1"}	\N	2026-05-04 10:54:39.458
82a01802-af54-498a-94c8-19742a0a9b2b	5abe4167-7866-4fb9-ab65-0a536167658b	launch_nvme_finding_device	{"ts": "2026-05-04T10:54:39.295858+00:00", "status": "in_progress", "message": "Locating NVMe block device..."}	\N	2026-05-04 10:54:39.475
0dc5a13c-177c-48f0-98e6-60de17126f3a	5abe4167-7866-4fb9-ab65-0a536167658b	launch_nvme_finding_device	{"ts": "2026-05-04T10:54:39.815755+00:00", "status": "completed", "message": "Block device found: /dev/nvme1n1"}	\N	2026-05-04 10:54:39.489
c2b86c3b-3789-4f89-afc9-fd7d654ea55c	5abe4167-7866-4fb9-ab65-0a536167658b	launch_nvme_mounting	{"ts": "2026-05-04T10:54:39.815866+00:00", "status": "in_progress", "message": "Mounting /dev/nvme1n1 to /mnt/nvme/u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 10:54:39.5
963eb6d6-63d4-4dc8-ab31-86e2c0b2d885	5abe4167-7866-4fb9-ab65-0a536167658b	launch_nvme_mounting	{"ts": "2026-05-04T10:54:39.856969+00:00", "status": "completed", "message": "NVMe-oF volume mounted"}	\N	2026-05-04 10:54:39.517
41c625fc-108e-4be4-9e6f-d89048dd5ba3	5abe4167-7866-4fb9-ab65-0a536167658b	launch_nvme_verifying	{"ts": "2026-05-04T10:54:39.857005+00:00", "status": "in_progress", "message": "Verifying storage permissions..."}	\N	2026-05-04 10:54:39.542
5c094583-7acc-45b2-b1af-dc48bd58eb60	5abe4167-7866-4fb9-ab65-0a536167658b	launch_nvme_verifying	{"ts": "2026-05-04T10:54:39.857413+00:00", "status": "completed", "message": "Permissions verified (UID 1000, read/write OK)"}	\N	2026-05-04 10:54:39.551
c4bb1d48-3ca8-4511-85d4-23fbd05f46a7	5abe4167-7866-4fb9-ab65-0a536167658b	launch_validating_mount	{"ts": "2026-05-04T10:54:39.857445+00:00", "status": "completed", "message": "NVMe-oF storage ready at /mnt/nvme/u_c1e2324f5a10e9f2dbb54508"}	\N	2026-05-04 10:54:39.573
abd53555-57d6-4798-a7c6-02e02d74e9d6	5abe4167-7866-4fb9-ab65-0a536167658b	launch_creating	{"ts": "2026-05-04T10:54:39.857487+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 10:54:39.582
8fb257c9-c012-4abf-9867-c13b50e21370	5abe4167-7866-4fb9-ab65-0a536167658b	launch_creating	{"ts": "2026-05-04T10:54:39.930786+00:00", "status": "completed", "message": "Container created: laas-5abe4167"}	\N	2026-05-04 10:54:39.596
22f4f958-9c82-4d5d-9833-ea3a4b62f3d5	5abe4167-7866-4fb9-ab65-0a536167658b	launch_starting	{"ts": "2026-05-04T10:54:39.930799+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 10:54:39.608
dcff2445-7bc9-4d96-adb8-1826f7c23a1e	5abe4167-7866-4fb9-ab65-0a536167658b	launch_starting	{"ts": "2026-05-04T10:54:40.262265+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 10:54:39.617
190239be-b1e0-405a-9a83-ebe63802fa93	5abe4167-7866-4fb9-ab65-0a536167658b	launch_waiting_desktop	{"ts": "2026-05-04T10:54:40.262278+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 10:54:39.627
165ca61c-95f3-4acc-91ae-d07fb2ecd86c	5abe4167-7866-4fb9-ab65-0a536167658b	launch_waiting_desktop	{"ts": "2026-05-04T10:55:00.460371+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 10:54:59.823
ece1f491-c28f-40bf-92bd-ba0a6225434e	5abe4167-7866-4fb9-ab65-0a536167658b	launch_waiting_desktop	{"ts": "2026-05-04T10:55:00.460387+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 10:54:59.826
5b71c6a4-7e3f-4f7e-beaf-bb6f2c062ff2	5abe4167-7866-4fb9-ab65-0a536167658b	launch_health_checking	{"ts": "2026-05-04T10:55:00.460392+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 10:54:59.827
05219cf6-6953-4118-811b-83758733b7ec	5abe4167-7866-4fb9-ab65-0a536167658b	launch_health_checking	{"ts": "2026-05-04T10:55:02.466692+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 10:55:01.843
b3443bdb-e8e5-45d7-8ef6-8642a4434d52	5abe4167-7866-4fb9-ab65-0a536167658b	launch_ready	{"ts": "2026-05-04T10:55:02.466708+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 10:55:01.845
5aede289-beee-47be-8977-3874fe81ca6f	5abe4167-7866-4fb9-ab65-0a536167658b	launch_ready	{"ts": "2026-05-04T10:55:02.466717+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 10:55:01.847
715cdfe0-d750-49f4-bfba-29bc8a20227b	5abe4167-7866-4fb9-ab65-0a536167658b	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 10:55:01.859
e91215e9-7b17-41e7-b679-7adfe439902d	5abe4167-7866-4fb9-ab65-0a536167658b	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 15500, "durationSeconds": 319, "terminationReason": "user_requested", "alreadyBilledCents": 15500, "remainingChargeCents": 0}	\N	2026-05-04 11:00:20.928
5523536e-baad-4331-8902-d1610edeb707	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-1s7q", "interfaceMode": "gui"}	\N	2026-05-04 11:00:41.711
ed46fc57-997c-4242-b48b-2cb8ad184f7b	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_initiated	{"launchId": "c9489a0a-63fb-4d66-8bfe-31b201864e56", "containerName": "laas-3fe5bba2"}	\N	2026-05-04 11:00:41.761
2ffaf498-477d-4bd2-9d51-62f74b82b8d0	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_scheduling	{"ts": "2026-05-04T11:00:43.601761+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 11:00:43.784
c39c26e0-9b8a-4b33-9c0c-3c061e6e87f4	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_scheduling	{"ts": "2026-05-04T11:00:43.702208+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 11:00:43.786
63e16d8d-427d-443c-b27c-d1d2caab1287	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_allocating_ports	{"ts": "2026-05-04T11:00:43.702320+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 11:00:43.788
b200ed6d-36f4-498e-9a05-5269d383cb6e	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_allocating_cpus	{"ts": "2026-05-04T11:20:57.154212+00:00", "status": "completed", "message": "Allocated CPU cores: 2-9"}	\N	2026-05-04 11:20:57.185
58491fbe-8dcc-4214-bf80-0d91d585e9ab	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_allocating_ports	{"ts": "2026-05-04T11:00:43.724857+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 11:00:43.791
27b23d5e-a7b1-42ba-b9cd-075d54d13650	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_allocating_cpus	{"ts": "2026-05-04T11:00:43.724865+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 11:00:43.794
8f667129-8a9d-492f-9600-7ead5d08de65	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_allocating_cpus	{"ts": "2026-05-04T11:00:43.734815+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 11:00:43.796
836143e6-c07a-45db-89cf-3915195d48cc	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_validating_mount	{"ts": "2026-05-04T11:00:43.734834+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 11:00:43.798
4452f702-a4a5-43d9-8c4d-938b9600b6e8	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_nvme_discovering	{"ts": "2026-05-04T11:00:43.734925+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-04 11:00:43.8
0a3fdebb-b26f-4d0c-b422-cecf119d3916	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_nvme_discovering	{"ts": "2026-05-04T11:00:43.753366+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-04 11:00:43.802
1fedf009-778a-46fd-8988-95e531bc743f	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_nvme_connecting	{"ts": "2026-05-04T11:00:43.753445+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 11:00:43.804
99e77b8a-b069-4079-b2e7-622b0ca03788	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_nvme_connecting	{"ts": "2026-05-04T11:00:43.771245+00:00", "status": "completed", "message": "NVMe-oF already connected at /dev/nvme1n1"}	\N	2026-05-04 11:00:43.806
4d260820-8e5d-44eb-be3b-29cb57765f7b	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_nvme_finding_device	{"ts": "2026-05-04T11:00:43.771272+00:00", "status": "in_progress", "message": "Locating NVMe block device..."}	\N	2026-05-04 11:00:43.807
64c1e286-0793-4adf-bb4b-87be091663df	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_nvme_finding_device	{"ts": "2026-05-04T11:00:44.291564+00:00", "status": "completed", "message": "Block device found: /dev/nvme1n1"}	\N	2026-05-04 11:00:43.809
6f2f8453-23a3-404b-a698-0f8a960e0dbb	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_nvme_mounting	{"ts": "2026-05-04T11:00:44.291654+00:00", "status": "in_progress", "message": "Mounting /dev/nvme1n1 to /mnt/nvme/u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 11:00:43.811
50b90810-4fbc-4fd7-a320-2b8b75c27ed6	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_nvme_mounting	{"ts": "2026-05-04T11:00:44.299158+00:00", "status": "completed", "message": "NVMe-oF volume mounted"}	\N	2026-05-04 11:00:43.813
4fec7718-91fb-4524-90d5-016c065e5033	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_nvme_verifying	{"ts": "2026-05-04T11:00:44.299178+00:00", "status": "in_progress", "message": "Verifying storage permissions..."}	\N	2026-05-04 11:00:43.814
befbb6ae-1c28-4109-b805-05c0bd788384	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_nvme_verifying	{"ts": "2026-05-04T11:00:44.299254+00:00", "status": "completed", "message": "Permissions verified (UID 1000, read/write OK)"}	\N	2026-05-04 11:00:43.816
7b0348b1-61c2-4b90-99e9-568fb7e6ec4a	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_validating_mount	{"ts": "2026-05-04T11:00:44.299284+00:00", "status": "completed", "message": "NVMe-oF storage ready at /mnt/nvme/u_c1e2324f5a10e9f2dbb54508"}	\N	2026-05-04 11:00:43.818
e0df508e-6eb0-4833-82e1-f843375fcdd2	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_creating	{"ts": "2026-05-04T11:00:44.299314+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 11:00:43.819
a67ee5d0-f1f0-454b-bf8a-d875c19778c0	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_creating	{"ts": "2026-05-04T11:00:44.381474+00:00", "status": "completed", "message": "Container created: laas-3fe5bba2"}	\N	2026-05-04 11:00:43.821
10cabe51-ba5c-4d4c-901c-41243a10d40f	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_starting	{"ts": "2026-05-04T11:00:44.381480+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 11:00:43.823
3b684e6a-2c78-4b1d-b7c4-06c948f775fb	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_starting	{"ts": "2026-05-04T11:00:44.677600+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 11:00:43.826
49e09ac2-f71d-4df6-8b9b-cd3a564c42e7	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_waiting_desktop	{"ts": "2026-05-04T11:00:44.677616+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 11:00:43.828
6a3d0d29-fc70-4241-93d8-ef2f575a50bf	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_waiting_desktop	{"ts": "2026-05-04T11:01:02.856316+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 11:01:02.275
8e7b1e78-454a-4ab4-9467-572aea700242	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_waiting_desktop	{"ts": "2026-05-04T11:01:02.856329+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 11:01:02.278
a43361bc-2e85-4a5a-a568-bd6882fb6b02	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_health_checking	{"ts": "2026-05-04T11:01:02.856332+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 11:01:02.285
363a6755-2057-47e2-a271-da03b1a0cb51	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_health_checking	{"ts": "2026-05-04T11:01:04.864210+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 11:01:04.316
c61041f1-b123-414e-b1da-e5693d1fa3fe	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_ready	{"ts": "2026-05-04T11:01:04.864222+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 11:01:04.325
94bf8c67-eb7a-484d-93ca-f85deff426e0	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	launch_ready	{"ts": "2026-05-04T11:01:04.864229+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 11:01:04.328
406bf5cf-c838-4879-96a5-e5086f3b23d8	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 11:01:04.359
7a470baa-725c-4f04-8896-62f08c28b000	1df95352-8d8e-4ba9-874d-5380c3902827	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 31000, "durationSeconds": 6537, "terminationReason": "user_requested", "alreadyBilledCents": 31000, "remainingChargeCents": 0}	\N	2026-05-04 11:20:23.306
831b381a-d6fe-438c-87c8-ba580ca8c3cf	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 15500, "durationSeconds": 1170, "terminationReason": "user_requested", "alreadyBilledCents": 15500, "remainingChargeCents": 0}	\N	2026-05-04 11:20:35.245
76612687-f809-4170-a43e-4544a1af9139	e0688d0b-1645-4bae-a644-7a408007f2d8	session_created	{"configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "instanceName": "gpu-instance-g7vq", "interfaceMode": "gui"}	\N	2026-05-04 11:20:55.108
fe142e28-a277-477a-a8fe-b4af9da4f2ab	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_initiated	{"launchId": "1e005efa-f748-4122-9c30-1f8e5375bc2b", "containerName": "laas-e0688d0b"}	\N	2026-05-04 11:20:55.155
6ea58cdf-8eb5-44ee-8546-fb6936e5991f	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_scheduling	{"ts": "2026-05-04T11:20:57.022406+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 11:20:57.176
f261dbba-31cb-4697-b3a6-589b27b8d0f8	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_scheduling	{"ts": "2026-05-04T11:20:57.122586+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 11:20:57.178
c47bf1f8-d84f-43c7-9846-19d4ad6da8b6	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_allocating_ports	{"ts": "2026-05-04T11:20:57.122699+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 11:20:57.18
a90f8b2e-d852-48e9-87a0-5fda4815031b	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_allocating_ports	{"ts": "2026-05-04T11:20:57.144206+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 11:20:57.183
101f7f5d-6461-4c0f-aa11-e1ecf227b99f	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_allocating_cpus	{"ts": "2026-05-04T11:20:57.144215+00:00", "status": "in_progress", "message": "Finding 8 contiguous CPU cores..."}	\N	2026-05-04 11:20:57.184
1c1def86-6008-45bb-9b83-8e6621d183d3	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_validating_mount	{"ts": "2026-05-04T11:20:57.154232+00:00", "status": "in_progress", "message": "Verifying local ZFS zvol for u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 11:20:57.187
e45b46bf-8f28-42b1-bcdb-175dcb107b10	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_validating_mount	{"ts": "2026-05-04T11:20:57.154396+00:00", "status": "completed", "message": "Local ZFS zvol verified: /datapool/users/u_c1e2324f5a10e9f2dbb54508"}	\N	2026-05-04 11:20:57.189
f5145fe6-6f20-4516-99ec-3eadd95643c4	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_creating	{"ts": "2026-05-04T11:20:57.154450+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 11:20:57.19
e5910ed7-3609-42af-94a9-686f1a75b483	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_creating	{"ts": "2026-05-04T11:20:57.239629+00:00", "status": "completed", "message": "Container created: laas-e0688d0b"}	\N	2026-05-04 11:20:57.191
4561a66a-88d0-4372-ab99-21c1112e9b61	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_starting	{"ts": "2026-05-04T11:20:57.239639+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 11:20:57.192
7f4db245-b73a-4b97-a4ad-14445c7fb4a9	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_starting	{"ts": "2026-05-04T11:20:57.566674+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 11:20:57.193
34d7800b-0b9d-4099-9781-74c3f9c36b65	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_waiting_desktop	{"ts": "2026-05-04T11:20:57.566686+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 11:20:57.194
41d5aaf2-3348-4174-8ea5-fae004eb0d7f	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_waiting_desktop	{"ts": "2026-05-04T11:21:15.745482+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 11:21:15.476
a23e3d5b-8bee-4f68-93da-3216dd32a15e	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_waiting_desktop	{"ts": "2026-05-04T11:21:15.745495+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 11:21:15.477
eee7ac7c-5cf1-424b-8e04-6cf6a98fae2d	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_health_checking	{"ts": "2026-05-04T11:21:15.745498+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 11:21:15.478
593931ed-e7e2-45e8-8c3d-121be71681fa	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_health_checking	{"ts": "2026-05-04T11:21:17.751143+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 11:21:17.499
cbcec505-e01f-467b-b62b-e5903dc63be8	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_ready	{"ts": "2026-05-04T11:21:17.751157+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 11:21:17.501
f502edbb-7648-4e4c-81b3-8818dc044554	e0688d0b-1645-4bae-a644-7a408007f2d8	launch_ready	{"ts": "2026-05-04T11:21:17.751164+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 11:21:17.503
1ce8b659-28ca-44c3-965a-b86ecf614ba9	e0688d0b-1645-4bae-a644-7a408007f2d8	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.88.57.107:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 11:21:17.511
f3c1e11a-4811-4c18-9089-903876691235	e0688d0b-1645-4bae-a644-7a408007f2d8	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 10500, "durationSeconds": 91, "terminationReason": "user_requested", "alreadyBilledCents": 10500, "remainingChargeCents": 0}	\N	2026-05-04 11:22:48.53
76e0df92-8e66-489c-aa8a-3629916da609	9e90358e-7497-46a8-b21c-57b3846377df	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "instanceName": "gpu-instance-uarc", "interfaceMode": "gui"}	\N	2026-05-04 12:14:12.745
7262b519-f2dc-42ab-888d-a959d6a21a95	9e90358e-7497-46a8-b21c-57b3846377df	launch_initiated	{"launchId": "04e2cea6-12e3-439d-b7ce-efd7f1efd356", "containerName": "laas-9e90358e"}	\N	2026-05-04 12:14:12.805
04b57225-e1db-4bae-a1c0-8d575046f8ec	9e90358e-7497-46a8-b21c-57b3846377df	launch_scheduling	{"ts": "2026-05-04T12:14:14.730928+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 12:14:14.834
8228e6e9-b625-4e16-9c14-87e61f0a672c	9e90358e-7497-46a8-b21c-57b3846377df	launch_scheduling	{"ts": "2026-05-04T12:14:14.831107+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 12:14:14.835
ec5a0c81-cc4f-46b8-9d9b-692b7b4e326c	9e90358e-7497-46a8-b21c-57b3846377df	launch_allocating_ports	{"ts": "2026-05-04T12:14:14.831222+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 12:14:14.837
3a499783-1bac-42d4-847a-51c27cbff727	9e90358e-7497-46a8-b21c-57b3846377df	launch_allocating_ports	{"ts": "2026-05-04T12:14:14.852669+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 12:14:14.839
e4b09707-aaef-42c9-b62d-a0b7c152ade8	9e90358e-7497-46a8-b21c-57b3846377df	launch_allocating_cpus	{"ts": "2026-05-04T12:14:14.852678+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-04 12:14:14.841
2cbf7c4e-1190-4be1-9f6b-eab541370559	9e90358e-7497-46a8-b21c-57b3846377df	launch_allocating_cpus	{"ts": "2026-05-04T12:14:14.862309+00:00", "status": "completed", "message": "Allocated CPU cores: 2-3"}	\N	2026-05-04 12:14:14.844
80a7d699-ef61-4c0d-8fb7-1a2b1f077741	9e90358e-7497-46a8-b21c-57b3846377df	launch_allocating_storage	{"ts": "2026-05-04T12:14:14.862326+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-04 12:14:14.845
ebff0f93-eb76-416d-b0eb-2fc7459fad58	9e90358e-7497-46a8-b21c-57b3846377df	launch_allocating_storage	{"ts": "2026-05-04T12:14:14.862335+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_9e90358e-7497-46a8-b21c-57b3846377df..."}	\N	2026-05-04 12:14:14.846
1b8a8091-7afd-4b6a-90dd-5823fd823a09	9e90358e-7497-46a8-b21c-57b3846377df	launch_allocating_storage	{"ts": "2026-05-04T12:14:15.560762+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_9e90358e-7497-46a8-b21c-57b3846377df"}	\N	2026-05-04 12:14:14.848
4cae164c-b2d2-4d81-a94d-584931705e6e	9e90358e-7497-46a8-b21c-57b3846377df	launch_creating	{"ts": "2026-05-04T12:14:15.560808+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 12:14:14.849
fc50b9c8-49da-433f-a39f-c597c98b6f2b	9e90358e-7497-46a8-b21c-57b3846377df	launch_creating	{"ts": "2026-05-04T12:14:15.636826+00:00", "status": "completed", "message": "Container created: laas-9e90358e"}	\N	2026-05-04 12:14:14.85
b176416e-da22-402c-9a62-6685f2cfa549	9e90358e-7497-46a8-b21c-57b3846377df	launch_starting	{"ts": "2026-05-04T12:14:15.636836+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 12:14:14.852
8187c145-3016-4d5f-8d27-2f76b42d84c1	9e90358e-7497-46a8-b21c-57b3846377df	launch_starting	{"ts": "2026-05-04T12:14:15.954526+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 12:14:14.853
82cb930c-3c4b-4af7-bb89-8ccad2544da0	9e90358e-7497-46a8-b21c-57b3846377df	launch_waiting_desktop	{"ts": "2026-05-04T12:14:15.954540+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 12:14:14.854
35c3e2cf-fcb7-42e7-9e80-3d379b776df1	9e90358e-7497-46a8-b21c-57b3846377df	launch_waiting_desktop	{"ts": "2026-05-04T12:14:34.128303+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 12:14:33.028
db18b459-bd09-46ec-8adf-9a819f556572	9e90358e-7497-46a8-b21c-57b3846377df	launch_waiting_desktop	{"ts": "2026-05-04T12:14:34.128319+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 12:14:33.029
b423de13-1f5e-40e8-903d-e087fb92dcce	9e90358e-7497-46a8-b21c-57b3846377df	launch_health_checking	{"ts": "2026-05-04T12:14:34.128322+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 12:14:33.03
6cb6b329-0bbe-4124-98d0-8b5e2bc50823	9e90358e-7497-46a8-b21c-57b3846377df	launch_health_checking	{"ts": "2026-05-04T12:14:36.133709+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 12:14:35.055
262324e9-c21e-4687-b8f1-848b176e9d42	9e90358e-7497-46a8-b21c-57b3846377df	launch_ready	{"ts": "2026-05-04T12:14:36.133723+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 12:14:35.057
0241a2b3-4599-4b34-8723-a91a66c63485	9e90358e-7497-46a8-b21c-57b3846377df	launch_ready	{"ts": "2026-05-04T12:14:36.133731+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 12:14:35.058
8ec0cf63-e965-46b0-91d5-802920044b96	9e90358e-7497-46a8-b21c-57b3846377df	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 12:14:35.067
f79b83a5-eb0a-4231-8a47-432bbbb744c4	9e90358e-7497-46a8-b21c-57b3846377df	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 3500, "durationSeconds": 259, "terminationReason": "user_requested", "alreadyBilledCents": 3500, "remainingChargeCents": 0}	\N	2026-05-04 12:18:54.699
9d0c5054-d558-46e5-a2eb-5d4ae9c0735d	04944419-863d-4b3a-a89e-fa3e87e77c84	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "instanceName": "gpu-instance-xha8", "interfaceMode": "gui"}	\N	2026-05-04 12:19:29.595
b00c8e27-0e2f-447a-b589-79d1794788ce	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_initiated	{"launchId": "e8eced93-bf2d-4e08-b736-af2927daf00d", "containerName": "laas-04944419"}	\N	2026-05-04 12:19:29.642
c309f80a-339f-4dec-8318-9cb89a2ef23a	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_scheduling	{"ts": "2026-05-04T12:19:31.574527+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 12:19:31.658
1f2ec7e0-83a1-462c-9b22-af3e9f8e9ac9	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_scheduling	{"ts": "2026-05-04T12:19:31.675067+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 12:19:31.66
3eda7bb4-751a-43dd-b427-489c9fe28e52	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_allocating_ports	{"ts": "2026-05-04T12:19:31.675186+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 12:19:31.661
9ea6742b-13f8-48fa-92e8-dfbf48152d15	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_allocating_ports	{"ts": "2026-05-04T12:19:31.693823+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 12:19:31.663
5171a594-aeb2-4622-aded-16ab0b1db6a1	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_allocating_cpus	{"ts": "2026-05-04T12:19:31.693831+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 12:19:31.664
643b27c7-4215-4e1c-972a-a1728b61546e	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_allocating_cpus	{"ts": "2026-05-04T12:19:31.703400+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 12:19:31.665
0345c532-56b3-4131-82dd-a421ff49ff2d	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_allocating_storage	{"ts": "2026-05-04T12:19:31.703418+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-04 12:19:31.666
8169eddb-db29-43b0-89e5-20a21317c391	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_allocating_storage	{"ts": "2026-05-04T12:19:31.703427+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_04944419-863d-4b3a-a89e-fa3e87e77c84..."}	\N	2026-05-04 12:19:31.666
e64806dd-5da4-41b9-8a89-469907bd3384	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_allocating_storage	{"ts": "2026-05-04T12:19:32.518865+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_04944419-863d-4b3a-a89e-fa3e87e77c84"}	\N	2026-05-04 12:19:31.667
9399569f-df8f-4e51-86f7-fd8ee0e8a898	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_creating	{"ts": "2026-05-04T12:19:32.518909+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 12:19:31.668
ac8f192b-4372-4b99-bca4-3c13ef17932e	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_creating	{"ts": "2026-05-04T12:19:32.592646+00:00", "status": "completed", "message": "Container created: laas-04944419"}	\N	2026-05-04 12:19:31.668
5936f903-4222-4769-8f55-54d325eb2854	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_starting	{"ts": "2026-05-04T12:19:32.592660+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 12:19:31.669
7e793c72-63f4-4c45-88eb-87d01654af5d	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_starting	{"ts": "2026-05-04T12:19:32.929520+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 12:19:31.671
a968dd97-4532-4022-bb30-5dbae2f2ab0d	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_waiting_desktop	{"ts": "2026-05-04T12:19:32.929532+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 12:19:31.671
6cd4a0f8-c7e5-4a01-af8b-02d24c94ed11	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_waiting_desktop	{"ts": "2026-05-04T12:19:49.087407+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 12:19:47.832
2eefbdd5-b563-4cb9-a7b4-c37719e989d9	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_waiting_desktop	{"ts": "2026-05-04T12:19:49.087418+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 12:19:47.833
e6034245-c6b0-47b9-a838-f17fff3c5457	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_health_checking	{"ts": "2026-05-04T12:19:49.087421+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 12:19:47.835
bcbfdbb7-1fd2-4772-812d-e4191a400312	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_health_checking	{"ts": "2026-05-04T12:19:51.094354+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 12:19:49.861
dc5c0e65-e588-480f-919f-a89a50b4d614	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_ready	{"ts": "2026-05-04T12:19:51.094371+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 12:19:49.862
4ea6c630-488e-43cc-b075-8cad2c730155	04944419-863d-4b3a-a89e-fa3e87e77c84	launch_ready	{"ts": "2026-05-04T12:19:51.094376+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 12:19:49.864
1ba9de51-504a-4d78-82db-825e0ec6d210	04944419-863d-4b3a-a89e-fa3e87e77c84	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.88.57.107:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 12:19:49.87
9688d299-513e-4422-8cf5-964601cc67df	97c1e395-d713-4755-a94d-98f161d50f4c	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-x6m0", "interfaceMode": "gui"}	\N	2026-05-04 12:20:26.399
ae7f9df3-6a5c-4ebd-808d-dcd98e1751e7	97c1e395-d713-4755-a94d-98f161d50f4c	launch_initiated	{"launchId": "b820f4b7-afc6-4cdf-8bc3-c6f9bc2992e0", "containerName": "laas-97c1e395"}	\N	2026-05-04 12:20:26.448
430e906c-a4f8-475b-ace8-878dafdb17b0	97c1e395-d713-4755-a94d-98f161d50f4c	launch_scheduling	{"ts": "2026-05-04T12:20:28.379886+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 12:20:28.468
25d4c953-4a2e-475b-a2a7-6019d093e4d5	97c1e395-d713-4755-a94d-98f161d50f4c	launch_scheduling	{"ts": "2026-05-04T12:20:28.480323+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 12:20:28.47
c974c99b-2bdb-4249-a880-ada22e5c37cb	97c1e395-d713-4755-a94d-98f161d50f4c	launch_allocating_ports	{"ts": "2026-05-04T12:20:28.480444+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 12:20:28.471
96993d87-6a8c-42ee-96a7-228f181511d3	97c1e395-d713-4755-a94d-98f161d50f4c	launch_allocating_ports	{"ts": "2026-05-04T12:20:28.503419+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 12:20:28.472
1bf2c044-ebd2-43f4-8903-87013fcc67fc	97c1e395-d713-4755-a94d-98f161d50f4c	launch_allocating_cpus	{"ts": "2026-05-04T12:20:28.503430+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 12:20:28.473
d905cade-4312-4d22-b096-6613e5f06e78	97c1e395-d713-4755-a94d-98f161d50f4c	launch_allocating_cpus	{"ts": "2026-05-04T12:20:28.512356+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 12:20:28.474
a41a650b-eed8-4f50-b06f-71eaa3df00d3	97c1e395-d713-4755-a94d-98f161d50f4c	launch_validating_mount	{"ts": "2026-05-04T12:20:28.512374+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 12:20:28.475
e47acfe9-3272-4e99-b696-6f380b0c7ed7	97c1e395-d713-4755-a94d-98f161d50f4c	launch_nvme_preparing	{"ts": "2026-05-04T12:20:28.512463+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 10.10.100.99..."}	\N	2026-05-04 12:20:28.476
eaccc486-c810-44b6-b594-d037c7cb122a	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_initiated	{"launchId": "67e8defc-8685-43b5-b8bb-2dce9f4e00ac", "containerName": "laas-58eb9143"}	\N	2026-05-04 14:42:50.863
b18e642c-54ac-4ec0-a03b-2e4f66cf35f4	97c1e395-d713-4755-a94d-98f161d50f4c	launch_validating_mount	{"ts": "2026-05-04T12:20:28.512598+00:00", "status": "failed", "message": "NVMe-oF setup unexpected error: No module named 'requests'"}	\N	2026-05-04 12:20:28.477
6f8d32dc-c8cd-4058-aadf-aec2d54dd76c	97c1e395-d713-4755-a94d-98f161d50f4c	launch_failed	{"reason": "NVMe-oF setup unexpected error: No module named 'requests'"}	\N	2026-05-04 12:20:28.49
10c8d5c5-27f8-4e40-86cb-054e1e896938	2a2e5950-b550-469f-a47e-7958132b6657	session_created	{"configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "instanceName": "gpu-instance-xydh", "interfaceMode": "gui"}	\N	2026-05-04 12:24:02.243
5ee9cce0-1bfb-433e-a269-6c46dce5f151	2a2e5950-b550-469f-a47e-7958132b6657	launch_initiated	{"launchId": "5ec6d928-abae-4ec2-9f2c-229444776685", "containerName": "laas-2a2e5950"}	\N	2026-05-04 12:24:02.29
7727fc50-8380-4098-b583-cef659bc038f	2a2e5950-b550-469f-a47e-7958132b6657	launch_scheduling	{"ts": "2026-05-04T12:24:04.228912+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 12:24:04.317
ba670b8e-40ce-444c-aa3c-83becfa5497c	2a2e5950-b550-469f-a47e-7958132b6657	launch_scheduling	{"ts": "2026-05-04T12:24:04.329446+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 12:24:04.319
4c515ba2-0f71-4d0a-a3cb-a21cb4a9fff3	2a2e5950-b550-469f-a47e-7958132b6657	launch_allocating_ports	{"ts": "2026-05-04T12:24:04.329558+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 12:24:04.32
7decf04e-e865-442c-afb8-4e02d8cb59a7	2a2e5950-b550-469f-a47e-7958132b6657	launch_allocating_ports	{"ts": "2026-05-04T12:24:04.351102+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 12:24:04.322
9151a145-ce94-46bf-a678-b81b17454bd7	2a2e5950-b550-469f-a47e-7958132b6657	launch_allocating_cpus	{"ts": "2026-05-04T12:24:04.351111+00:00", "status": "in_progress", "message": "Finding 8 contiguous CPU cores..."}	\N	2026-05-04 12:24:04.323
bf540f32-7a9a-46fe-906f-be9062a3e301	2a2e5950-b550-469f-a47e-7958132b6657	launch_allocating_cpus	{"ts": "2026-05-04T12:24:04.360588+00:00", "status": "completed", "message": "Allocated CPU cores: 2-9"}	\N	2026-05-04 12:24:04.324
60cb63a6-3117-410d-9753-2fef9296e25c	2a2e5950-b550-469f-a47e-7958132b6657	launch_validating_mount	{"ts": "2026-05-04T12:24:04.360610+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 12:24:04.326
65a39e0e-46e2-43cf-aafd-5a466b0b9a8d	2a2e5950-b550-469f-a47e-7958132b6657	launch_nvme_preparing	{"ts": "2026-05-04T12:24:04.360710+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 10.10.100.99..."}	\N	2026-05-04 12:24:04.327
67e8d4c5-ce88-41c9-8ce1-050d085e1686	2a2e5950-b550-469f-a47e-7958132b6657	launch_nvme_discovering	{"ts": "2026-05-04T12:24:04.362190+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-04 12:24:04.328
96d2ae25-0388-4773-ab0a-ceed3f8d052f	2a2e5950-b550-469f-a47e-7958132b6657	launch_nvme_discovering	{"ts": "2026-05-04T12:24:04.385383+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-04 12:24:04.331
02e9a66e-b58e-4d51-a09c-a1cbe8593fff	2a2e5950-b550-469f-a47e-7958132b6657	launch_nvme_connecting	{"ts": "2026-05-04T12:24:04.385460+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 12:24:04.332
3fd735f0-ee97-4486-ad89-45a01004442c	2a2e5950-b550-469f-a47e-7958132b6657	launch_nvme_connecting	{"ts": "2026-05-04T12:24:04.403589+00:00", "status": "completed", "message": "NVMe-oF already connected at /dev/nvme1n1"}	\N	2026-05-04 12:24:04.333
735b0649-5584-4f60-989e-0bbc8b99b554	2a2e5950-b550-469f-a47e-7958132b6657	launch_nvme_finding_device	{"ts": "2026-05-04T12:24:04.403615+00:00", "status": "in_progress", "message": "Locating NVMe block device..."}	\N	2026-05-04 12:24:04.335
9250b5f0-65ee-4097-bf8c-c92e5aeac5da	2a2e5950-b550-469f-a47e-7958132b6657	launch_nvme_finding_device	{"ts": "2026-05-04T12:24:04.915710+00:00", "status": "completed", "message": "Block device found: /dev/nvme1n1"}	\N	2026-05-04 12:24:04.336
75b1b665-7ef4-42f5-98c7-5150e58008f7	2a2e5950-b550-469f-a47e-7958132b6657	launch_nvme_mounting	{"ts": "2026-05-04T12:24:04.915834+00:00", "status": "in_progress", "message": "Mounting /dev/nvme1n1 to /mnt/nvme/u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 12:24:04.336
0dbeb247-eba2-442b-8459-fdfcd0834263	2a2e5950-b550-469f-a47e-7958132b6657	launch_nvme_mounting	{"ts": "2026-05-04T12:24:04.923674+00:00", "status": "completed", "message": "NVMe-oF volume mounted"}	\N	2026-05-04 12:24:04.337
828e8044-11ab-42f5-8867-44316ad73683	2a2e5950-b550-469f-a47e-7958132b6657	launch_nvme_verifying	{"ts": "2026-05-04T12:24:04.923708+00:00", "status": "in_progress", "message": "Verifying storage permissions..."}	\N	2026-05-04 12:24:04.338
01c24cb3-57c2-4bb4-a886-86f6861aa63e	2a2e5950-b550-469f-a47e-7958132b6657	launch_nvme_verifying	{"ts": "2026-05-04T12:24:04.923831+00:00", "status": "completed", "message": "Permissions verified (UID 1000, read/write OK)"}	\N	2026-05-04 12:24:04.339
6fbb745c-1bb9-40bb-9d4e-341c5e2c26d2	2a2e5950-b550-469f-a47e-7958132b6657	launch_validating_mount	{"ts": "2026-05-04T12:24:04.923866+00:00", "status": "completed", "message": "NVMe-oF storage ready at /mnt/nvme/u_c1e2324f5a10e9f2dbb54508"}	\N	2026-05-04 12:24:04.34
314c93f3-be58-4e41-984b-75eca31c04b2	2a2e5950-b550-469f-a47e-7958132b6657	launch_creating	{"ts": "2026-05-04T12:24:04.923911+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 12:24:04.341
916fad25-2c51-4944-bf4a-7f29bd18efa2	2a2e5950-b550-469f-a47e-7958132b6657	launch_creating	{"ts": "2026-05-04T12:24:05.003894+00:00", "status": "completed", "message": "Container created: laas-2a2e5950"}	\N	2026-05-04 12:24:04.342
459362dd-b61f-4b3a-9611-2f9ae23b0894	2a2e5950-b550-469f-a47e-7958132b6657	launch_starting	{"ts": "2026-05-04T12:24:05.003910+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 12:24:04.343
0f340ad7-ed6c-4d94-8a10-171eab33bc49	2a2e5950-b550-469f-a47e-7958132b6657	launch_starting	{"ts": "2026-05-04T12:24:05.312524+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 12:24:04.345
dd327488-4d77-46cf-bacd-53fd67aaf120	2a2e5950-b550-469f-a47e-7958132b6657	launch_waiting_desktop	{"ts": "2026-05-04T12:24:05.312537+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 12:24:04.346
11239c0d-1f47-49f2-bf1f-6c44b0071175	2a2e5950-b550-469f-a47e-7958132b6657	launch_waiting_desktop	{"ts": "2026-05-04T12:24:19.459503+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 12:24:18.504
c1cfd8e0-8e14-4344-a5a0-b9a0ca27d81f	2a2e5950-b550-469f-a47e-7958132b6657	launch_waiting_desktop	{"ts": "2026-05-04T12:24:19.459518+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 12:24:18.505
1e404c74-1e3c-4f40-ae9f-ec6f45f8d364	2a2e5950-b550-469f-a47e-7958132b6657	launch_health_checking	{"ts": "2026-05-04T12:24:19.459522+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 12:24:18.507
08e32209-3d32-42e0-9e22-f6cae01a1f28	2a2e5950-b550-469f-a47e-7958132b6657	launch_health_checking	{"ts": "2026-05-04T12:24:21.468125+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 12:24:20.534
55c126aa-9611-4b38-a1c7-926ff06cd8dd	2a2e5950-b550-469f-a47e-7958132b6657	launch_ready	{"ts": "2026-05-04T12:24:21.468140+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 12:24:20.535
eaee05fe-cbc5-4f94-ba42-7a8c05dd0162	2a2e5950-b550-469f-a47e-7958132b6657	launch_ready	{"ts": "2026-05-04T12:24:21.468148+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 12:24:20.537
b5d9dc96-036a-4315-ba55-87216d6598d7	2a2e5950-b550-469f-a47e-7958132b6657	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 12:24:20.543
d65c3ee7-6dbe-4a53-bcb6-7e118b3614b6	24aea730-aef0-476f-8dc4-b96743f901f8	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-9n7e", "interfaceMode": "gui"}	\N	2026-05-04 12:21:22.075
a6623d2f-7e48-4f1c-b0fd-4479d2e763d3	24aea730-aef0-476f-8dc4-b96743f901f8	launch_initiated	{"launchId": "95ed840b-d6fd-484c-9653-55b1aac84343", "containerName": "laas-24aea730"}	\N	2026-05-04 12:21:22.117
230a59c1-cc8f-4c60-9208-49950e8f434b	24aea730-aef0-476f-8dc4-b96743f901f8	launch_scheduling	{"ts": "2026-05-04T12:21:24.052231+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 12:21:24.148
f544b982-42e8-4ebb-86ab-a8f600c3f0b0	24aea730-aef0-476f-8dc4-b96743f901f8	launch_scheduling	{"ts": "2026-05-04T12:21:24.152406+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 12:21:24.149
8192e11f-4c93-47c7-b540-11a4386581c7	24aea730-aef0-476f-8dc4-b96743f901f8	launch_allocating_ports	{"ts": "2026-05-04T12:21:24.152499+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 12:21:24.15
465dc49f-dadb-4ec7-9d98-f3329e6b86bc	24aea730-aef0-476f-8dc4-b96743f901f8	launch_allocating_ports	{"ts": "2026-05-04T12:21:24.177760+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 12:21:24.152
397dbdd4-1884-440d-a83d-f4f10d239e2c	24aea730-aef0-476f-8dc4-b96743f901f8	launch_allocating_cpus	{"ts": "2026-05-04T12:21:24.177770+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 12:21:24.153
38e48944-7864-4b54-bbe3-ee5dae2f2a22	24aea730-aef0-476f-8dc4-b96743f901f8	launch_allocating_cpus	{"ts": "2026-05-04T12:21:24.187478+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 12:21:24.154
9bd56943-b6dc-4b98-b93d-d3b6b9481559	24aea730-aef0-476f-8dc4-b96743f901f8	launch_validating_mount	{"ts": "2026-05-04T12:21:24.187500+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 12:21:24.155
22454d72-db93-47eb-ba83-d49e5495f354	24aea730-aef0-476f-8dc4-b96743f901f8	launch_nvme_preparing	{"ts": "2026-05-04T12:21:24.187620+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 10.10.100.99..."}	\N	2026-05-04 12:21:24.156
309c9521-d9ab-4250-bfc2-c98d6cb51cdd	24aea730-aef0-476f-8dc4-b96743f901f8	launch_nvme_discovering	{"ts": "2026-05-04T12:21:24.241957+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-04 12:21:24.158
0870f367-c405-430e-8985-31295875c9cb	24aea730-aef0-476f-8dc4-b96743f901f8	launch_nvme_discovering	{"ts": "2026-05-04T12:21:24.261339+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-04 12:21:24.16
4950f8cf-8e3b-45ce-8f57-472c4ad2fbe9	24aea730-aef0-476f-8dc4-b96743f901f8	launch_nvme_connecting	{"ts": "2026-05-04T12:21:24.261416+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 12:21:24.161
53456416-c4b3-4b1a-b721-a4543af29709	24aea730-aef0-476f-8dc4-b96743f901f8	launch_nvme_connecting	{"ts": "2026-05-04T12:21:24.267789+00:00", "status": "completed", "message": "NVMe-oF already connected at /dev/nvme1n1"}	\N	2026-05-04 12:21:24.163
fe693dcb-4974-403d-a92c-0a18645138e4	24aea730-aef0-476f-8dc4-b96743f901f8	launch_nvme_finding_device	{"ts": "2026-05-04T12:21:24.267820+00:00", "status": "in_progress", "message": "Locating NVMe block device..."}	\N	2026-05-04 12:21:24.165
644177cd-a333-41fb-817c-4a6ae4e220a0	24aea730-aef0-476f-8dc4-b96743f901f8	launch_nvme_finding_device	{"ts": "2026-05-04T12:21:24.778367+00:00", "status": "completed", "message": "Block device found: /dev/nvme1n1"}	\N	2026-05-04 12:21:24.166
c54f0421-6849-457e-aafb-a7a834f32bdb	24aea730-aef0-476f-8dc4-b96743f901f8	launch_nvme_mounting	{"ts": "2026-05-04T12:21:24.778475+00:00", "status": "in_progress", "message": "Mounting /dev/nvme1n1 to /mnt/nvme/u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 12:21:24.167
06e51b6d-cbf4-41cc-be0e-af6661d3ea95	24aea730-aef0-476f-8dc4-b96743f901f8	launch_nvme_mounting	{"ts": "2026-05-04T12:21:24.786631+00:00", "status": "completed", "message": "NVMe-oF volume mounted"}	\N	2026-05-04 12:21:24.169
1b171b40-ad6f-46ed-bcf8-4a2c8a23d36a	24aea730-aef0-476f-8dc4-b96743f901f8	launch_nvme_verifying	{"ts": "2026-05-04T12:21:24.786651+00:00", "status": "in_progress", "message": "Verifying storage permissions..."}	\N	2026-05-04 12:21:24.17
2bcc7ede-926a-46e1-9b4e-a056a7da51cd	24aea730-aef0-476f-8dc4-b96743f901f8	launch_nvme_verifying	{"ts": "2026-05-04T12:21:24.786730+00:00", "status": "completed", "message": "Permissions verified (UID 1000, read/write OK)"}	\N	2026-05-04 12:21:24.171
d256bb1d-2011-4974-a4b6-9aed73997285	24aea730-aef0-476f-8dc4-b96743f901f8	launch_validating_mount	{"ts": "2026-05-04T12:21:24.786755+00:00", "status": "completed", "message": "NVMe-oF storage ready at /mnt/nvme/u_c1e2324f5a10e9f2dbb54508"}	\N	2026-05-04 12:21:24.172
42e20272-cdc4-4f88-80e1-f475273f4144	24aea730-aef0-476f-8dc4-b96743f901f8	launch_creating	{"ts": "2026-05-04T12:21:24.786792+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 12:21:24.173
540a5bc0-c1a9-4e0d-999c-0e263ae639b3	24aea730-aef0-476f-8dc4-b96743f901f8	launch_creating	{"ts": "2026-05-04T12:21:24.867810+00:00", "status": "completed", "message": "Container created: laas-24aea730"}	\N	2026-05-04 12:21:24.174
837a014c-38cc-4d57-a028-9b0dd6e1a52d	24aea730-aef0-476f-8dc4-b96743f901f8	launch_starting	{"ts": "2026-05-04T12:21:24.867820+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 12:21:24.175
64166282-d511-4fa9-8207-d421e6931e2c	24aea730-aef0-476f-8dc4-b96743f901f8	launch_starting	{"ts": "2026-05-04T12:21:25.163464+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 12:21:24.176
23253fd9-3496-44b9-825f-2f8ceb147f98	24aea730-aef0-476f-8dc4-b96743f901f8	launch_waiting_desktop	{"ts": "2026-05-04T12:21:25.163478+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 12:21:24.177
b36e62f7-8745-4520-afe6-8ad02159aafb	24aea730-aef0-476f-8dc4-b96743f901f8	launch_waiting_desktop	{"ts": "2026-05-04T12:21:41.332437+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 12:21:40.319
31e2aefb-71ef-4662-9a49-ee63c1b3e4ab	24aea730-aef0-476f-8dc4-b96743f901f8	launch_waiting_desktop	{"ts": "2026-05-04T12:21:41.332451+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 12:21:40.321
5b55e0c5-0fa4-4be9-b097-f861a1d071d5	24aea730-aef0-476f-8dc4-b96743f901f8	launch_health_checking	{"ts": "2026-05-04T12:21:41.332455+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 12:21:40.321
2500d510-c631-4a77-ae6e-e7b9425b2079	24aea730-aef0-476f-8dc4-b96743f901f8	launch_health_checking	{"ts": "2026-05-04T12:21:43.341626+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 12:21:42.343
005889c7-d939-4e73-9946-f14e5c645757	24aea730-aef0-476f-8dc4-b96743f901f8	launch_ready	{"ts": "2026-05-04T12:21:43.341641+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 12:21:42.345
25306025-537b-4081-bbbb-58ef841eb500	24aea730-aef0-476f-8dc4-b96743f901f8	launch_ready	{"ts": "2026-05-04T12:21:43.341650+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 12:21:42.346
cad02459-be52-4b96-8fd1-a73f7779c428	24aea730-aef0-476f-8dc4-b96743f901f8	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 12:21:42.351
ffc17602-dec9-4cc2-8eaa-8298baa542c5	24aea730-aef0-476f-8dc4-b96743f901f8	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 15500, "durationSeconds": 102, "terminationReason": "user_requested", "alreadyBilledCents": 15500, "remainingChargeCents": 0}	\N	2026-05-04 12:23:24.605
9cd09dd2-3a20-48f1-81b9-f48402d1d598	2a2e5950-b550-469f-a47e-7958132b6657	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 10500, "durationSeconds": 126, "terminationReason": "user_requested", "alreadyBilledCents": 10500, "remainingChargeCents": 0}	\N	2026-05-04 12:26:26.88
a2d141a7-bdec-4c06-84f4-1ba912f2f471	58eb9143-5c78-4bd5-b9e2-882db758ff1f	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-fcpq", "interfaceMode": "gui"}	\N	2026-05-04 14:42:50.777
d81fcd15-eb0d-439b-8db5-8ec9905bf928	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_scheduling	{"ts": "2026-05-04T14:42:53.246522+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 14:42:52.928
9a658b0a-8e53-48f1-8dba-4946d9d6951b	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_scheduling	{"ts": "2026-05-04T14:42:53.346910+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 14:42:52.933
33da120d-d7d1-4024-a507-d7b33b73032b	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_allocating_ports	{"ts": "2026-05-04T14:42:53.347026+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 14:42:52.935
3442bea2-6518-44cd-ab03-7b6272e351b1	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_allocating_ports	{"ts": "2026-05-04T14:42:53.370839+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 14:42:52.938
8d5c1403-1db5-4ed8-941f-1fc956cb68fc	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_allocating_cpus	{"ts": "2026-05-04T14:42:53.370844+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 14:42:52.94
7908283c-97fc-437d-901a-75fbb1e395c5	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_allocating_cpus	{"ts": "2026-05-04T14:42:53.380226+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 14:42:52.942
464e8f3a-9af2-4a44-9c39-f4778d41f9bc	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_validating_mount	{"ts": "2026-05-04T14:42:53.380242+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 14:42:52.944
eabe4196-8a63-4825-97cb-cf043bd7d282	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_nvme_preparing	{"ts": "2026-05-04T14:42:53.380347+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 10.10.100.99..."}	\N	2026-05-04 14:42:52.947
eb45c313-fe69-45a5-9caf-58bc801656dd	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_nvme_discovering	{"ts": "2026-05-04T14:42:53.405977+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-04 14:42:52.949
bf0c6480-b3fc-4616-89eb-7f1ac019066b	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_nvme_discovering	{"ts": "2026-05-04T14:42:53.429314+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-04 14:42:52.951
bc4b6b7c-d5a9-4b9a-9b8d-801fb4e68557	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_nvme_connecting	{"ts": "2026-05-04T14:42:53.429396+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 14:42:52.954
2719e361-add9-4a4e-a566-56535f04b6d1	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_nvme_connecting	{"ts": "2026-05-04T14:42:53.435381+00:00", "status": "completed", "message": "NVMe-oF already connected at /dev/nvme1n1"}	\N	2026-05-04 14:42:52.956
af4508f8-fc00-4a18-ae3f-9f5e11964e2a	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_nvme_finding_device	{"ts": "2026-05-04T14:42:53.435412+00:00", "status": "in_progress", "message": "Locating NVMe block device..."}	\N	2026-05-04 14:42:52.958
6e896500-12de-47c9-8f51-d337e3477eef	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_nvme_finding_device	{"ts": "2026-05-04T14:42:53.947949+00:00", "status": "completed", "message": "Block device found: /dev/nvme1n1"}	\N	2026-05-04 14:42:52.96
1e56fed7-eba4-4728-8639-04c48b6368f9	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_nvme_mounting	{"ts": "2026-05-04T14:42:53.948069+00:00", "status": "in_progress", "message": "Mounting /dev/nvme1n1 to /mnt/nvme/u_c1e2324f5a10e9f2dbb54508..."}	\N	2026-05-04 14:42:52.962
dbeb7d68-f8b0-403b-bb0b-a138ecddf876	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_nvme_mounting	{"ts": "2026-05-04T14:42:53.954206+00:00", "status": "completed", "message": "NVMe-oF volume mounted"}	\N	2026-05-04 14:42:52.964
dbe357b3-b376-4f09-9e84-bcd488a70f40	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_nvme_verifying	{"ts": "2026-05-04T14:42:53.954245+00:00", "status": "in_progress", "message": "Verifying storage permissions..."}	\N	2026-05-04 14:42:52.966
62277672-2da0-421e-b0ad-356dfc363f86	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_nvme_verifying	{"ts": "2026-05-04T14:42:53.954371+00:00", "status": "completed", "message": "Permissions verified (UID 1000, read/write OK)"}	\N	2026-05-04 14:42:52.968
cfede6b7-8f22-4672-a14b-3c91dd655469	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_validating_mount	{"ts": "2026-05-04T14:42:53.954410+00:00", "status": "completed", "message": "NVMe-oF storage ready at /mnt/nvme/u_c1e2324f5a10e9f2dbb54508"}	\N	2026-05-04 14:42:52.97
f22c8986-c2fa-4cff-acc7-2b7c15ba34ce	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_creating	{"ts": "2026-05-04T14:42:53.954460+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 14:42:52.972
fbcc5c44-0def-4323-a9b1-b44d9a464c7c	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_creating	{"ts": "2026-05-04T14:42:54.034829+00:00", "status": "completed", "message": "Container created: laas-58eb9143"}	\N	2026-05-04 14:42:52.974
81abff4e-6f74-46ec-80aa-68b66132e952	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_starting	{"ts": "2026-05-04T14:42:54.034834+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 14:42:52.976
fd032627-4a35-4022-a02c-e2eb3bce3f7b	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_starting	{"ts": "2026-05-04T14:42:54.338176+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 14:42:52.977
2d152591-3753-4640-8153-0379c9be82a8	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_waiting_desktop	{"ts": "2026-05-04T14:42:54.338190+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 14:42:52.98
268c9c43-b656-4943-a27c-0d47dde93e15	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_waiting_desktop	{"ts": "2026-05-04T14:43:12.513173+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 14:43:11.615
2a920565-d884-4cd0-be10-2af5e1832c18	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_waiting_desktop	{"ts": "2026-05-04T14:43:12.513186+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 14:43:11.618
5ea4a19a-569b-4144-bb05-f8425afeca5c	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_health_checking	{"ts": "2026-05-04T14:43:12.513189+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 14:43:11.62
82b99ec0-9e81-40ca-a931-df324be22012	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_health_checking	{"ts": "2026-05-04T14:43:14.521771+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 14:43:13.683
86fc235c-bffa-4ff8-902d-9632ddd3ce68	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_ready	{"ts": "2026-05-04T14:43:14.521786+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 14:43:13.686
6d6d4c71-f255-408d-80f6-a39269b0315c	58eb9143-5c78-4bd5-b9e2-882db758ff1f	launch_ready	{"ts": "2026-05-04T14:43:14.521794+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 14:43:13.688
f33a66cf-e4af-4155-996e-40839b16273b	58eb9143-5c78-4bd5-b9e2-882db758ff1f	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 14:43:13.699
46ac6704-e5af-4a0b-8126-946c52fd43f1	58eb9143-5c78-4bd5-b9e2-882db758ff1f	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 15500, "durationSeconds": 45, "terminationReason": "user_requested", "alreadyBilledCents": 15500, "remainingChargeCents": 0}	\N	2026-05-04 14:43:58.927
b9cab165-fa84-4d5a-b0aa-ffb84b2a1a0c	01c999aa-fb37-4f3b-aac3-d0e7c30a3f94	session_created	{"configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "instanceName": "gpu-instance-4h9m", "interfaceMode": "gui"}	\N	2026-05-04 15:01:19.143
f205f29e-c421-4337-99a7-1e8c3cac6da4	01c999aa-fb37-4f3b-aac3-d0e7c30a3f94	launch_initiated	{"launchId": "e87edd9d-d8d1-423b-b1df-4f5dee71f76f", "containerName": "laas-01c999aa"}	\N	2026-05-04 15:01:19.231
399aa848-1c15-4a8a-81f9-c8f9c4d12b9c	01c999aa-fb37-4f3b-aac3-d0e7c30a3f94	launch_scheduling	{"ts": "2026-05-04T15:01:21.627596+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 15:01:21.277
96192b4b-91a5-4eff-b3a9-5abba8a7d1f9	01c999aa-fb37-4f3b-aac3-d0e7c30a3f94	launch_scheduling	{"ts": "2026-05-04T15:01:21.728013+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 15:01:21.28
9e92e19f-e4d3-4a33-9beb-99ead5f21043	4a90a7ed-d8db-4284-ab65-d2a9918206bb	launch_initiated	{"launchId": "4a3aafde-1b7a-401c-8d08-9e6d4c49c96a", "containerName": "laas-4a90a7ed"}	\N	2026-05-04 15:43:09.086
d210f19d-25e6-4d88-8e7b-426840bda32b	01c999aa-fb37-4f3b-aac3-d0e7c30a3f94	launch_allocating_ports	{"ts": "2026-05-04T15:01:21.728140+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 15:01:21.283
8a4e011e-e1ca-4df1-89d1-634241bcfc8f	01c999aa-fb37-4f3b-aac3-d0e7c30a3f94	launch_allocating_ports	{"ts": "2026-05-04T15:01:21.748933+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 15:01:21.285
65b3c5b6-8cb4-4ce9-a979-bd2e99170a24	01c999aa-fb37-4f3b-aac3-d0e7c30a3f94	launch_allocating_cpus	{"ts": "2026-05-04T15:01:21.748939+00:00", "status": "in_progress", "message": "Finding 8 contiguous CPU cores..."}	\N	2026-05-04 15:01:21.288
ae6f5472-ce64-4560-bbcf-7377121e192f	01c999aa-fb37-4f3b-aac3-d0e7c30a3f94	launch_allocating_cpus	{"ts": "2026-05-04T15:01:21.758394+00:00", "status": "completed", "message": "Allocated CPU cores: 2-9"}	\N	2026-05-04 15:01:21.289
853bd0f1-5bf0-4692-a1dd-8e23d9c7afe4	01c999aa-fb37-4f3b-aac3-d0e7c30a3f94	launch_validating_mount	{"ts": "2026-05-04T15:01:21.758410+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_ec8ab0e4da1e4cd21f8e57f8..."}	\N	2026-05-04 15:01:21.292
6e9d4496-749f-4097-89a4-def1da5f1866	01c999aa-fb37-4f3b-aac3-d0e7c30a3f94	launch_nvme_preparing	{"ts": "2026-05-04T15:01:21.758492+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 100.88.57.107..."}	\N	2026-05-04 15:01:21.294
d4b305a9-73da-4984-b4be-a7ffe9e00017	01c999aa-fb37-4f3b-aac3-d0e7c30a3f94	launch_nvme_discovering	{"ts": "2026-05-04T15:01:21.764217+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 100.88.57.107..."}	\N	2026-05-04 15:01:21.296
630faf2d-6592-4e31-aaff-a7a7a7117f30	01c999aa-fb37-4f3b-aac3-d0e7c30a3f94	launch_nvme_discover	{"ts": "2026-05-04T15:01:21.777475+00:00", "status": "failed", "message": "NVMe-oF failed at discover: Subsystem laas-u_ec8ab0e4da1e4cd21f8e57f8 not found in discovery output"}	\N	2026-05-04 15:01:21.298
74853b6e-5588-4c2a-a357-b3e877546159	01c999aa-fb37-4f3b-aac3-d0e7c30a3f94	launch_failed	{"reason": "NVMe-oF failed at discover: Subsystem laas-u_ec8ab0e4da1e4cd21f8e57f8 not found in discovery output"}	\N	2026-05-04 15:01:21.329
58d4e229-ffe0-405a-812a-ac21e9e11dab	3c8cf962-2d36-4672-9268-910b6870e188	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-a9o0", "interfaceMode": "gui"}	\N	2026-05-04 15:29:25.872
4d68a90d-692c-4306-82fb-db8389b77ae8	3c8cf962-2d36-4672-9268-910b6870e188	launch_initiated	{"launchId": "9b1ee013-153c-445c-b828-cc6d0a3c2f2c", "containerName": "laas-3c8cf962"}	\N	2026-05-04 15:29:25.957
51e3de50-3669-4830-ba0a-6a7668950be3	3c8cf962-2d36-4672-9268-910b6870e188	launch_scheduling	{"ts": "2026-05-04T15:29:28.367117+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 15:29:28.008
d4acf35e-7615-4d10-acb8-d6abc2104f29	3c8cf962-2d36-4672-9268-910b6870e188	launch_scheduling	{"ts": "2026-05-04T15:29:28.467539+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 15:29:28.01
2b5d7dd0-37eb-4ea7-b1c9-8c9f56d7fa75	3c8cf962-2d36-4672-9268-910b6870e188	launch_allocating_ports	{"ts": "2026-05-04T15:29:28.467653+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 15:29:28.013
b1d4f8d1-d648-418d-84e8-6455ddf11b0f	3c8cf962-2d36-4672-9268-910b6870e188	launch_allocating_ports	{"ts": "2026-05-04T15:29:28.491933+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 15:29:28.015
e4648209-4c41-4d95-91b9-a40e5a0239eb	3c8cf962-2d36-4672-9268-910b6870e188	launch_allocating_cpus	{"ts": "2026-05-04T15:29:28.491941+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 15:29:28.017
d468aa78-8bd8-4a43-851d-060366d8d783	3c8cf962-2d36-4672-9268-910b6870e188	launch_allocating_cpus	{"ts": "2026-05-04T15:29:28.501861+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 15:29:28.019
fc0fccc6-2c39-49c5-8dfb-7c79e351fe16	3c8cf962-2d36-4672-9268-910b6870e188	launch_validating_mount	{"ts": "2026-05-04T15:29:28.501872+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_ec8ab0e4da1e4cd21f8e57f8..."}	\N	2026-05-04 15:29:28.022
1d5c98e2-2eae-4fe8-8a74-52506011b05d	3c8cf962-2d36-4672-9268-910b6870e188	launch_nvme_preparing	{"ts": "2026-05-04T15:29:28.501960+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 100.88.57.107..."}	\N	2026-05-04 15:29:28.026
0555b416-7aea-43a6-b883-43222925c8e3	3c8cf962-2d36-4672-9268-910b6870e188	launch_nvme_discovering	{"ts": "2026-05-04T15:29:28.530670+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 100.88.57.107..."}	\N	2026-05-04 15:29:28.029
478ab037-d1a9-4497-a253-800e4e6a0669	3c8cf962-2d36-4672-9268-910b6870e188	launch_nvme_discover	{"ts": "2026-05-04T15:29:28.543333+00:00", "status": "failed", "message": "NVMe-oF failed at discover: Subsystem laas-u_ec8ab0e4da1e4cd21f8e57f8 not found in discovery output"}	\N	2026-05-04 15:29:28.031
432f6dfb-5ed0-4ade-b0c3-54b3d526779a	3c8cf962-2d36-4672-9268-910b6870e188	launch_failed	{"reason": "NVMe-oF failed at discover: Subsystem laas-u_ec8ab0e4da1e4cd21f8e57f8 not found in discovery output"}	\N	2026-05-04 15:29:28.06
82a46cca-9153-4661-ac6b-fb5ce04221c8	87393c22-0a61-4707-8816-8e36f854eb5d	session_created	{"configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "instanceName": "gpu-instance-heed", "interfaceMode": "gui"}	\N	2026-05-04 15:37:59.801
f78a7fc4-4406-465c-a049-35fb7272ee17	87393c22-0a61-4707-8816-8e36f854eb5d	launch_initiated	{"launchId": "64c6fbe4-5266-4ee9-8388-6d80ed012dae", "containerName": "laas-87393c22"}	\N	2026-05-04 15:37:59.866
0621df85-c83c-4ef5-a371-5a086d98b71f	87393c22-0a61-4707-8816-8e36f854eb5d	launch_scheduling	{"ts": "2026-05-04T15:38:02.286794+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 15:38:01.944
d5efd915-d0ed-40c1-a990-da5c8fb706d0	87393c22-0a61-4707-8816-8e36f854eb5d	launch_scheduling	{"ts": "2026-05-04T15:38:02.387391+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 15:38:01.948
e8a057a6-1129-4d43-9ef1-8e5c38831f98	87393c22-0a61-4707-8816-8e36f854eb5d	launch_allocating_ports	{"ts": "2026-05-04T15:38:02.387502+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 15:38:01.951
8e462e91-a208-4d0f-85fe-da04ea2526e7	87393c22-0a61-4707-8816-8e36f854eb5d	launch_allocating_ports	{"ts": "2026-05-04T15:38:02.407777+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 15:38:01.954
1ea17ce1-130d-4481-a883-515a41a95173	87393c22-0a61-4707-8816-8e36f854eb5d	launch_allocating_cpus	{"ts": "2026-05-04T15:38:02.407782+00:00", "status": "in_progress", "message": "Finding 8 contiguous CPU cores..."}	\N	2026-05-04 15:38:01.956
33a5a5ab-321e-4b44-98ae-5f8bd54adb3b	87393c22-0a61-4707-8816-8e36f854eb5d	launch_allocating_cpus	{"ts": "2026-05-04T15:38:02.416693+00:00", "status": "completed", "message": "Allocated CPU cores: 2-9"}	\N	2026-05-04 15:38:01.958
63f1571a-0c6b-4654-a925-c131a22915d1	87393c22-0a61-4707-8816-8e36f854eb5d	launch_validating_mount	{"ts": "2026-05-04T15:38:02.416708+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_ec8ab0e4da1e4cd21f8e57f8..."}	\N	2026-05-04 15:38:01.96
1eacb633-4446-43c7-9cd3-e05c6667cac4	87393c22-0a61-4707-8816-8e36f854eb5d	launch_nvme_preparing	{"ts": "2026-05-04T15:38:02.416810+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 100.88.57.107..."}	\N	2026-05-04 15:38:01.963
626e337a-abf7-4723-b264-b1b421972857	87393c22-0a61-4707-8816-8e36f854eb5d	launch_nvme_discovering	{"ts": "2026-05-04T15:38:02.444526+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 100.88.57.107..."}	\N	2026-05-04 15:38:01.965
96345000-3078-454d-81ff-91ef0e8d75f2	87393c22-0a61-4707-8816-8e36f854eb5d	launch_nvme_discover	{"ts": "2026-05-04T15:38:02.458516+00:00", "status": "failed", "message": "NVMe-oF failed at discover: Subsystem laas-u_ec8ab0e4da1e4cd21f8e57f8 not found in discovery output"}	\N	2026-05-04 15:38:01.967
f9713911-465e-4ebf-8c04-762fbcf94392	87393c22-0a61-4707-8816-8e36f854eb5d	launch_failed	{"reason": "NVMe-oF failed at discover: Subsystem laas-u_ec8ab0e4da1e4cd21f8e57f8 not found in discovery output"}	\N	2026-05-04 15:38:01.989
e326a5f7-37de-4618-bdd1-5d2a997cfe59	4a90a7ed-d8db-4284-ab65-d2a9918206bb	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-7lje", "interfaceMode": "gui"}	\N	2026-05-04 15:43:09.008
c28071b1-b17b-4459-91d1-e3ab69ec055f	4a90a7ed-d8db-4284-ab65-d2a9918206bb	launch_scheduling	{"ts": "2026-05-04T15:43:11.503325+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 15:43:11.127
2251da55-32eb-48b6-9a5b-03c2c896ddfc	4a90a7ed-d8db-4284-ab65-d2a9918206bb	launch_scheduling	{"ts": "2026-05-04T15:43:11.603946+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 15:43:11.132
2efb7ff8-5943-4105-9e40-0c31234c0f1b	4a90a7ed-d8db-4284-ab65-d2a9918206bb	launch_allocating_ports	{"ts": "2026-05-04T15:43:11.604059+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 15:43:11.135
42619020-144c-4f34-b8fb-98784205d9af	4a90a7ed-d8db-4284-ab65-d2a9918206bb	launch_allocating_ports	{"ts": "2026-05-04T15:43:11.626957+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 15:43:11.139
507b6414-55df-4db0-a618-c42354fcdc36	4a90a7ed-d8db-4284-ab65-d2a9918206bb	launch_allocating_cpus	{"ts": "2026-05-04T15:43:11.626964+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 15:43:11.141
d77a9b19-9622-41cd-8e79-8d6b06c99eb1	4a90a7ed-d8db-4284-ab65-d2a9918206bb	launch_allocating_cpus	{"ts": "2026-05-04T15:43:11.635881+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 15:43:11.145
36f2bc43-9af4-445e-b509-91447db0cd0b	4a90a7ed-d8db-4284-ab65-d2a9918206bb	launch_validating_mount	{"ts": "2026-05-04T15:43:11.635896+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_ec8ab0e4da1e4cd21f8e57f8..."}	\N	2026-05-04 15:43:11.148
b356f305-f30a-4802-84c4-711f307e60dc	4a90a7ed-d8db-4284-ab65-d2a9918206bb	launch_nvme_preparing	{"ts": "2026-05-04T15:43:11.635991+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 100.88.57.107..."}	\N	2026-05-04 15:43:11.15
4d16ad25-9f28-45a6-bc22-3a93a61e2925	4a90a7ed-d8db-4284-ab65-d2a9918206bb	launch_nvme_discovering	{"ts": "2026-05-04T15:43:11.658245+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 100.88.57.107..."}	\N	2026-05-04 15:43:11.152
a61ca96f-99af-4006-b410-71090f36a892	4a90a7ed-d8db-4284-ab65-d2a9918206bb	launch_nvme_discover	{"ts": "2026-05-04T15:43:11.671534+00:00", "status": "failed", "message": "NVMe-oF failed at discover: Subsystem laas-u_ec8ab0e4da1e4cd21f8e57f8 not found in discovery output"}	\N	2026-05-04 15:43:11.154
b319b7fc-e669-4099-ac12-b2865b9ebd01	4a90a7ed-d8db-4284-ab65-d2a9918206bb	launch_failed	{"reason": "NVMe-oF failed at discover: Subsystem laas-u_ec8ab0e4da1e4cd21f8e57f8 not found in discovery output"}	\N	2026-05-04 15:43:11.188
e9ca07b9-99b8-49ac-985c-a8ef08f5f4ee	0a3df555-2b1f-4f5b-8c54-f22f5478d470	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-5kz9", "interfaceMode": "gui"}	\N	2026-05-04 15:46:46.153
40f38c91-25d8-4f65-b2b2-2f5019388494	0a3df555-2b1f-4f5b-8c54-f22f5478d470	launch_initiated	{"launchId": "b2f41f20-37fc-430d-9272-6d0ecf77e283", "containerName": "laas-0a3df555"}	\N	2026-05-04 15:46:46.228
506bcc9d-5560-4632-b7d1-808354454591	0a3df555-2b1f-4f5b-8c54-f22f5478d470	launch_scheduling	{"ts": "2026-05-04T15:46:48.654144+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 15:46:48.26
79aacfbb-be6e-4f8a-9f0e-f76785df0c5b	0a3df555-2b1f-4f5b-8c54-f22f5478d470	launch_scheduling	{"ts": "2026-05-04T15:46:48.754334+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 15:46:48.263
b552f06e-e461-4e97-ad8a-3fc7fc847947	0a3df555-2b1f-4f5b-8c54-f22f5478d470	launch_allocating_ports	{"ts": "2026-05-04T15:46:48.754445+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 15:46:48.266
c86b5122-0498-4138-b990-de2506e13bbd	0a3df555-2b1f-4f5b-8c54-f22f5478d470	launch_allocating_ports	{"ts": "2026-05-04T15:46:48.775949+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 15:46:48.268
017bcf82-0d3a-4f9f-a866-f879d2bd9352	0a3df555-2b1f-4f5b-8c54-f22f5478d470	launch_allocating_cpus	{"ts": "2026-05-04T15:46:48.775954+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 15:46:48.27
82b7123b-9cf1-4685-bd09-e63db111ff11	0a3df555-2b1f-4f5b-8c54-f22f5478d470	launch_allocating_cpus	{"ts": "2026-05-04T15:46:48.785138+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 15:46:48.272
dd1c9480-f9e3-4747-ac9d-9719a94ad9c5	0a3df555-2b1f-4f5b-8c54-f22f5478d470	launch_validating_mount	{"ts": "2026-05-04T15:46:48.785150+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_ec8ab0e4da1e4cd21f8e57f8..."}	\N	2026-05-04 15:46:48.274
2ee0c32d-4cd9-4e6c-bd9f-ba69fd8837b7	0a3df555-2b1f-4f5b-8c54-f22f5478d470	launch_nvme_preparing	{"ts": "2026-05-04T15:46:48.785234+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 100.88.57.107..."}	\N	2026-05-04 15:46:48.276
8e4c1965-eee3-421e-9403-47befc24c37a	0a3df555-2b1f-4f5b-8c54-f22f5478d470	launch_nvme_discovering	{"ts": "2026-05-04T15:46:48.807971+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 100.88.57.107..."}	\N	2026-05-04 15:46:48.278
9b8bba00-33f2-45d9-ad9b-d84a17c25b46	0a3df555-2b1f-4f5b-8c54-f22f5478d470	launch_nvme_discover	{"ts": "2026-05-04T15:46:48.820215+00:00", "status": "failed", "message": "NVMe-oF failed at discover: Subsystem laas-u_ec8ab0e4da1e4cd21f8e57f8 not found in discovery output"}	\N	2026-05-04 15:46:48.28
2114da76-5174-47b4-bbf6-d6c68924b0d7	0a3df555-2b1f-4f5b-8c54-f22f5478d470	launch_failed	{"reason": "NVMe-oF failed at discover: Subsystem laas-u_ec8ab0e4da1e4cd21f8e57f8 not found in discovery output"}	\N	2026-05-04 15:46:48.306
ff864611-18d8-49be-9f04-0b21504138d7	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	session_created	{"configName": "Inferno", "configSlug": "inferno", "storageType": "ephemeral", "instanceName": "gpu-instance-xlmu", "interfaceMode": "gui"}	\N	2026-05-04 16:12:00.373
eebc7ad1-2cdb-499b-a459-51b006507460	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_initiated	{"launchId": "60527802-1d0e-4065-ba77-7f1110c334f0", "containerName": "laas-bf30b9ad"}	\N	2026-05-04 16:12:00.521
ea20058e-7263-4d89-9691-6be8ae27b518	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_scheduling	{"ts": "2026-05-04T16:12:02.957194+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 16:12:02.561
7d4e8994-a599-4bbb-a887-8964ff09471a	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_scheduling	{"ts": "2026-05-04T16:12:03.057682+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 16:12:02.563
6990ae1a-3fe8-420e-aa6e-14f5d3225134	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_allocating_ports	{"ts": "2026-05-04T16:12:03.057805+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 16:12:02.565
2edce091-6c43-4fc8-87d3-8dfdc1d8501b	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_allocating_ports	{"ts": "2026-05-04T16:12:03.078588+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 16:12:02.568
87267dd1-5613-4ca8-83aa-2d7c9a3b25d1	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_allocating_cpus	{"ts": "2026-05-04T16:12:03.078595+00:00", "status": "in_progress", "message": "Finding 8 contiguous CPU cores..."}	\N	2026-05-04 16:12:02.57
947110d9-0878-47fe-aad9-a3b37727a040	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_allocating_cpus	{"ts": "2026-05-04T16:12:03.088639+00:00", "status": "completed", "message": "Allocated CPU cores: 2-9"}	\N	2026-05-04 16:12:02.572
91253327-d5b4-42bb-a439-27f95dd74417	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_allocating_storage	{"ts": "2026-05-04T16:12:03.088654+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-04 16:12:02.573
c4e9db6c-398a-4c03-abad-758177953af9	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_allocating_storage	{"ts": "2026-05-04T16:12:03.088660+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_bf30b9ad-136f-4362-8a5a-c8a8bc8ec045..."}	\N	2026-05-04 16:12:02.575
b7101429-4273-4757-9fde-96f6c6663a9d	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_allocating_storage	{"ts": "2026-05-04T16:12:03.798174+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_bf30b9ad-136f-4362-8a5a-c8a8bc8ec045"}	\N	2026-05-04 16:12:02.576
7289b696-20d6-4135-8256-1dec75304faa	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_creating	{"ts": "2026-05-04T16:12:03.798217+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 16:12:02.578
8fb9e396-4d0f-46d6-80c3-080cbd29a71b	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_creating	{"ts": "2026-05-04T16:12:03.874062+00:00", "status": "completed", "message": "Container created: laas-bf30b9ad"}	\N	2026-05-04 16:12:02.58
8bd1a00e-d1e2-4543-b641-3fade8009d5f	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_starting	{"ts": "2026-05-04T16:12:03.874072+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 16:12:02.582
105fe78d-9a99-4bc7-9ec2-b23d7e99f126	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_starting	{"ts": "2026-05-04T16:12:04.176718+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 16:12:02.584
4518a680-4a9d-43e5-a3bf-2af492d61594	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_waiting_desktop	{"ts": "2026-05-04T16:12:04.176733+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 16:12:02.586
b1f85a68-f9cb-4028-8e5e-6035b55c0af9	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_waiting_desktop	{"ts": "2026-05-04T16:12:22.347724+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 16:12:20.951
39faa39e-a7d7-4340-af25-33293d1aad81	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_waiting_desktop	{"ts": "2026-05-04T16:12:22.347740+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 16:12:20.953
57d919ae-d185-4f78-98fa-83f7f4d880a2	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_health_checking	{"ts": "2026-05-04T16:12:22.347744+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 16:12:20.956
9a5f0387-033b-4079-ae7f-bcde2d6eb6d0	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_health_checking	{"ts": "2026-05-04T16:12:24.354753+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 16:12:23.009
dbb71e48-ffb6-4a24-b56b-19e58e7bc497	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_ready	{"ts": "2026-05-04T16:12:24.354767+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 16:12:23.011
24f62475-27af-41fa-933d-e4b14f9de467	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	launch_ready	{"ts": "2026-05-04T16:12:24.354775+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 16:12:23.012
79f5d593-58d4-4fa1-a532-114e47c2b310	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 16:12:23.025
539f1272-b49b-433c-b953-30ef1b8c24b4	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 10500, "durationSeconds": 94, "terminationReason": "user_requested", "alreadyBilledCents": 10500, "remainingChargeCents": 0}	\N	2026-05-04 16:13:57.324
64b2b1e3-2c4d-4bf5-a232-23d641e3381d	04944419-863d-4b3a-a89e-fa3e87e77c84	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 62000, "durationSeconds": 14093, "terminationReason": "user_requested", "alreadyBilledCents": 62000, "remainingChargeCents": 0}	\N	2026-05-04 16:14:43.562
1e578e07-cd10-4aee-92e0-bc4a6abbf706	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-j7um", "interfaceMode": "gui"}	\N	2026-05-04 16:34:30.305
7e483163-62e5-4f43-8e12-3f151e2dbd75	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_initiated	{"launchId": "e08baaca-9ec1-405f-952d-766eb0fa3fe3", "containerName": "laas-4b9c660c"}	\N	2026-05-04 16:34:30.362
a11604b0-bc4d-4abd-8609-396f144075eb	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_scheduling	{"ts": "2026-05-04T16:34:32.823401+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 16:34:32.404
497859f7-ae65-46df-844f-d19e15cd976c	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_scheduling	{"ts": "2026-05-04T16:34:32.923824+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 16:34:32.406
86198256-1f2e-41a8-8809-5ebcf1384a74	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_allocating_ports	{"ts": "2026-05-04T16:34:32.923936+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 16:34:32.408
0d25dbd3-ab1f-4b0a-b6d3-6742d327ae34	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_allocating_ports	{"ts": "2026-05-04T16:34:32.944744+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 16:34:32.41
cbb7869c-27c0-4261-9a61-29d1a6e8a855	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_allocating_cpus	{"ts": "2026-05-04T16:34:32.944749+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 16:34:32.412
1ab24d2c-5346-40a7-ad11-52d1cf185a01	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_allocating_cpus	{"ts": "2026-05-04T16:34:32.954202+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 16:34:32.413
bea5ca15-4379-49ef-a637-457d884d35a3	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_validating_mount	{"ts": "2026-05-04T16:34:32.954214+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_ec8ab0e4da1e4cd21f8e57f8..."}	\N	2026-05-04 16:34:32.415
5b9794d9-350c-49ca-a992-d8981db5abc8	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_nvme_preparing	{"ts": "2026-05-04T16:34:32.954295+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 100.88.57.107..."}	\N	2026-05-04 16:34:32.416
1af74b00-c3cf-4147-aa14-3e4752b88520	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_nvme_discovering	{"ts": "2026-05-04T16:34:33.229919+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-04 16:34:32.418
55e4b5e3-ebf9-4005-8eac-d95f6a30b6e7	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_nvme_discovering	{"ts": "2026-05-04T16:34:33.253475+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-04 16:34:32.419
a631c1db-09d5-49c2-99be-6de8deee845f	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_nvme_connecting	{"ts": "2026-05-04T16:34:33.253576+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_ec8ab0e4da1e4cd21f8e57f8..."}	\N	2026-05-04 16:34:32.42
11797065-935e-4540-8b04-8fc5f964373a	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_nvme_connecting	{"ts": "2026-05-04T16:34:33.303634+00:00", "status": "completed", "message": "NVMe-oF connected"}	\N	2026-05-04 16:34:32.422
25168913-1941-4f6e-ad60-f79b71a20810	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_nvme_finding_device	{"ts": "2026-05-04T16:34:33.303680+00:00", "status": "in_progress", "message": "Locating NVMe block device..."}	\N	2026-05-04 16:34:32.423
70e26374-f8b7-45ef-9e00-31d40072d66b	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_nvme_finding_device	{"ts": "2026-05-04T16:34:33.814678+00:00", "status": "completed", "message": "Block device found: /dev/nvme1n1"}	\N	2026-05-04 16:34:32.424
728ab6ea-d04b-4933-97b6-a3f942f1260e	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_nvme_mounting	{"ts": "2026-05-04T16:34:33.814774+00:00", "status": "in_progress", "message": "Mounting /dev/nvme1n1 to /mnt/nvme/u_ec8ab0e4da1e4cd21f8e57f8..."}	\N	2026-05-04 16:34:32.425
0f52008a-e486-49bc-88d2-47257e246a7a	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_nvme_mounting	{"ts": "2026-05-04T16:34:33.839291+00:00", "status": "completed", "message": "NVMe-oF volume mounted"}	\N	2026-05-04 16:34:32.427
3dd4383a-274f-411b-84a6-72e505888ab7	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_nvme_verifying	{"ts": "2026-05-04T16:34:33.839358+00:00", "status": "in_progress", "message": "Verifying storage permissions..."}	\N	2026-05-04 16:34:32.428
75aca70c-4a30-41d9-8d25-f7ade7f92a65	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_nvme_verifying	{"ts": "2026-05-04T16:34:33.839860+00:00", "status": "completed", "message": "Permissions verified (UID 1000, read/write OK)"}	\N	2026-05-04 16:34:32.429
ec91158d-a243-4064-9353-509466d4351f	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_validating_mount	{"ts": "2026-05-04T16:34:33.839932+00:00", "status": "completed", "message": "NVMe-oF storage ready at /mnt/nvme/u_ec8ab0e4da1e4cd21f8e57f8"}	\N	2026-05-04 16:34:32.43
2bcacbeb-fc9e-4f42-889c-8bed20a2dc9c	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_creating	{"ts": "2026-05-04T16:34:33.840002+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 16:34:32.431
4694187d-1316-4541-b42a-8a5de84225c3	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_creating	{"ts": "2026-05-04T16:34:33.932077+00:00", "status": "completed", "message": "Container created: laas-4b9c660c"}	\N	2026-05-04 16:34:32.433
4f539a9b-56e1-4a32-b4f2-96063118ddea	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_starting	{"ts": "2026-05-04T16:34:33.932083+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 16:34:32.434
f7a1faad-8ae5-4472-a2cd-f62ca75f4040	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_starting	{"ts": "2026-05-04T16:34:34.242369+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 16:34:32.436
fe077c40-6643-46c5-be6e-5104c46433ba	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_waiting_desktop	{"ts": "2026-05-04T16:34:34.242382+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 16:34:32.437
a28f8e75-f0d5-4b77-befe-294fc6dcc621	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_waiting_desktop	{"ts": "2026-05-04T16:34:50.398186+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 16:34:48.92
0a0136af-a7c8-4b02-a659-50e781ce5968	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_waiting_desktop	{"ts": "2026-05-04T16:34:50.398198+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 16:34:48.922
d0d6e2d2-3072-4f59-9b4f-56878403943b	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_health_checking	{"ts": "2026-05-04T16:34:50.398200+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 16:34:48.924
be895199-fded-40c7-ab72-23b21c412d73	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_health_checking	{"ts": "2026-05-04T16:34:52.407289+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 16:34:50.975
9270edf1-16d4-4313-b9f0-571493c4ef10	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_ready	{"ts": "2026-05-04T16:34:52.407308+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 16:34:50.977
a505008a-278d-426d-95f2-41ebd8d9b364	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	launch_ready	{"ts": "2026-05-04T16:34:52.407316+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 16:34:50.978
1d7822d1-96c6-4520-8b25-6942351d4094	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 16:34:50.985
f2b3fa11-9c58-4e34-9333-ca8ffb73465b	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 15500, "durationSeconds": 14, "terminationReason": "user_requested", "alreadyBilledCents": 15500, "remainingChargeCents": 0}	\N	2026-05-04 16:35:05.659
8e7db1f6-3ed2-42f7-bac6-8be61a5d1a58	4c7ac79c-bce6-4f29-b793-21774cbebbc2	session_created	{"configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "instanceName": "gpu-instance-mgbx", "interfaceMode": "gui"}	\N	2026-05-04 16:35:19.951
35b4e5d8-ffea-4114-80ad-c0ccfbc6de5f	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_initiated	{"launchId": "ca3b1930-9417-4b2a-8cdc-ae74194b1864", "containerName": "laas-4c7ac79c"}	\N	2026-05-04 16:35:20.004
6a4e9a98-58d4-4c3b-9ff8-56fa62ce13de	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_scheduling	{"ts": "2026-05-04T16:35:22.465361+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 16:35:22.035
af5e3db7-5001-45e2-8595-4b733422cfef	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_scheduling	{"ts": "2026-05-04T16:35:22.565556+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 16:35:22.037
3ba144fb-390a-4122-a430-16da8801828b	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_allocating_ports	{"ts": "2026-05-04T16:35:22.565672+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 16:35:22.038
7614cedc-f55c-4da8-8758-76309fdc595a	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_allocating_ports	{"ts": "2026-05-04T16:35:22.585654+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 16:35:22.04
99191e29-a876-4fda-848b-d080a5af5b09	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_allocating_cpus	{"ts": "2026-05-04T16:35:22.585663+00:00", "status": "in_progress", "message": "Finding 8 contiguous CPU cores..."}	\N	2026-05-04 16:35:22.041
61c1ba8a-f774-4244-915d-a2bd5ba81e82	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_allocating_cpus	{"ts": "2026-05-04T16:35:22.594715+00:00", "status": "completed", "message": "Allocated CPU cores: 2-9"}	\N	2026-05-04 16:35:22.044
2a07b1bd-a7ca-4b2c-9ea5-9b3ab992eb60	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_validating_mount	{"ts": "2026-05-04T16:35:22.594738+00:00", "status": "in_progress", "message": "Verifying local ZFS zvol for u_ec8ab0e4da1e4cd21f8e57f8..."}	\N	2026-05-04 16:35:22.045
d81d6917-314d-4d7d-9d1c-60a792f07252	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_validating_mount	{"ts": "2026-05-04T16:35:22.594889+00:00", "status": "completed", "message": "Local ZFS zvol verified: /datapool/users/u_ec8ab0e4da1e4cd21f8e57f8"}	\N	2026-05-04 16:35:22.047
83955321-ec8a-4c75-be37-2d0fd8bef457	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_creating	{"ts": "2026-05-04T16:35:22.594943+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 16:35:22.048
2c8c1e41-d9e5-4463-baab-f2d4f6aa1a8a	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_creating	{"ts": "2026-05-04T16:35:22.672952+00:00", "status": "completed", "message": "Container created: laas-4c7ac79c"}	\N	2026-05-04 16:35:22.05
ef21cb97-848a-4373-a27b-a8914e580642	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_starting	{"ts": "2026-05-04T16:35:22.672960+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 16:35:22.051
19362d3a-61fc-49d0-958f-26c319a871ed	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_starting	{"ts": "2026-05-04T16:35:23.009752+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 16:35:22.053
1def5865-fae2-482d-8cbb-47a5c8bad088	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_waiting_desktop	{"ts": "2026-05-04T16:35:23.009768+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 16:35:22.055
a4f689bc-9534-4630-8d03-a3b962da646d	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_waiting_desktop	{"ts": "2026-05-04T16:35:43.201161+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 16:35:42.622
e06e531f-cb2b-467b-aad7-0d2e267ef428	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_waiting_desktop	{"ts": "2026-05-04T16:35:43.201175+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 16:35:42.624
16dc8ecd-3751-4786-bca5-1334a0c0bba3	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_health_checking	{"ts": "2026-05-04T16:35:43.201178+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 16:35:42.626
92513323-5f58-4e3e-84e8-ac11f50a677b	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_health_checking	{"ts": "2026-05-04T16:35:45.208424+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 16:35:44.71
af267884-d89b-4ad8-b065-3db64f2beb52	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_ready	{"ts": "2026-05-04T16:35:45.208439+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 16:35:44.712
dec3d7d7-d999-4dc4-8963-26e0b248796d	4c7ac79c-bce6-4f29-b793-21774cbebbc2	launch_ready	{"ts": "2026-05-04T16:35:45.208448+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 16:35:44.715
786dc9ea-35c1-43bb-910f-744df59ff749	4c7ac79c-bce6-4f29-b793-21774cbebbc2	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.88.57.107:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 16:35:44.722
504cb56e-4fa3-4871-8400-512f76b2fd1b	0ccd7449-8e06-45ce-94a0-7ed143546716	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "instanceName": "gpu-instance-lbfl", "interfaceMode": "gui"}	\N	2026-05-04 16:37:02.9
a9d159d3-8412-449b-8573-8250fbb4d79b	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_initiated	{"launchId": "c23ee9e0-3d6c-4f45-b910-1f6d61ab7dd2", "containerName": "laas-0ccd7449"}	\N	2026-05-04 16:37:02.991
80a9bc8f-67d6-421f-88a5-48f18cbbabda	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_scheduling	{"ts": "2026-05-04T16:37:05.449740+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-04 16:37:05.036
20031197-3c7a-45b2-91e6-8ac28fc59930	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_scheduling	{"ts": "2026-05-04T16:37:05.550174+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-04 16:37:05.039
85d567bf-7830-4dbd-a60b-ac503b2aa315	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_allocating_ports	{"ts": "2026-05-04T16:37:05.550285+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-04 16:37:05.043
5daaf662-5139-4472-9d5c-deb15f592b77	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_allocating_ports	{"ts": "2026-05-04T16:37:05.570777+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-04 16:37:05.046
8f4b92c7-c384-4dc1-8658-85ef95686da3	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_allocating_cpus	{"ts": "2026-05-04T16:37:05.570784+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-04 16:37:05.049
04d86f8d-bdfc-4278-a9f0-871ac349e7a2	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_allocating_cpus	{"ts": "2026-05-04T16:37:05.579834+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-04 16:37:05.051
0f246a74-9c1b-4ffc-ac94-763c58f928dc	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_allocating_storage	{"ts": "2026-05-04T16:37:05.579849+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-04 16:37:05.054
73d25215-099d-4611-9cb1-8240a624b33b	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_allocating_storage	{"ts": "2026-05-04T16:37:05.579857+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_0ccd7449-8e06-45ce-94a0-7ed143546716..."}	\N	2026-05-04 16:37:05.056
92fac5c4-31ce-43d2-90a4-eb123bf6c5d3	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_allocating_storage	{"ts": "2026-05-04T16:37:06.289716+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_0ccd7449-8e06-45ce-94a0-7ed143546716"}	\N	2026-05-04 16:37:05.059
bace7e59-e955-4888-8706-d2dcc6453d99	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_creating	{"ts": "2026-05-04T16:37:06.289759+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-04 16:37:05.061
177e0a38-2b00-463b-945f-9595fb8e4c91	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_creating	{"ts": "2026-05-04T16:37:06.362416+00:00", "status": "completed", "message": "Container created: laas-0ccd7449"}	\N	2026-05-04 16:37:05.064
196b90c1-9ba7-490b-b674-4498be120b96	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_starting	{"ts": "2026-05-04T16:37:06.362425+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-04 16:37:05.066
d1a4663b-2ec2-4f7d-99ae-85902dbf6435	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_starting	{"ts": "2026-05-04T16:37:06.656938+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-04 16:37:05.068
27cacdfd-936b-4041-af5a-aebe5420f1c7	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_waiting_desktop	{"ts": "2026-05-04T16:37:06.656951+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-04 16:37:05.07
b66a1468-9524-42f5-b9c0-a8b1f6252830	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_waiting_desktop	{"ts": "2026-05-04T16:37:18.772945+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-04 16:37:17.374
f2ed2b0b-1225-40fa-a100-367538f07738	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_waiting_desktop	{"ts": "2026-05-04T16:37:18.772959+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-04 16:37:17.376
a851c0e1-c2b8-4cb7-9a04-f208e97525bb	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_health_checking	{"ts": "2026-05-04T16:37:18.772962+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-04 16:37:17.378
9ea8bc36-2efb-425e-a780-660b570559cd	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_health_checking	{"ts": "2026-05-04T16:37:20.782045+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-04 16:37:19.435
7e191e68-aa3a-43c4-aac1-a3be407ef917	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_ready	{"ts": "2026-05-04T16:37:20.782061+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-04 16:37:19.437
17cf6cd1-04ff-4bd6-a282-315e7cafdc20	0ccd7449-8e06-45ce-94a0-7ed143546716	launch_ready	{"ts": "2026-05-04T16:37:20.782066+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-04 16:37:19.439
dac9534b-8371-441e-97c9-aacc064514e2	0ccd7449-8e06-45ce-94a0-7ed143546716	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-04 16:37:19.447
70b4cd21-538b-460b-8638-c06a557f5121	0ccd7449-8e06-45ce-94a0-7ed143546716	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 124000, "durationSeconds": 26474, "terminationReason": "user_requested", "alreadyBilledCents": 46500, "remainingChargeCents": 77500}	\N	2026-05-04 23:58:34.373
d295215d-3a18-4e17-afbb-5a71303438da	4c7ac79c-bce6-4f29-b793-21774cbebbc2	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 84000, "durationSeconds": 26590, "terminationReason": "user_requested", "alreadyBilledCents": 31500, "remainingChargeCents": 52500}	\N	2026-05-04 23:58:55.663
f7bf218b-f1d5-42f4-8baf-af9ecf90fc50	407b2a0b-a8a7-42c7-b34b-142d57c8089e	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "instanceName": "gpu-instance-iofu", "interfaceMode": "gui"}	\N	2026-05-05 01:03:56.735
0cb3a3f2-bdb7-419b-8711-e9b0ed1f74c9	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_initiated	{"launchId": "c553918c-1a9d-41ba-99c3-ba66c46c6a9a", "containerName": "laas-407b2a0b"}	\N	2026-05-05 01:03:56.821
52a86c53-3989-47e8-a401-3157b1bc0dd9	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_scheduling	{"ts": "2026-05-05T01:03:59.536870+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 01:03:58.852
f696bc28-f360-48a8-a7dd-1dae86b771ec	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_scheduling	{"ts": "2026-05-05T01:03:59.637303+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 01:03:58.854
f5ee72c6-d959-43a7-8a78-6ae7b54eb081	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_allocating_ports	{"ts": "2026-05-05T01:03:59.637419+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 01:03:58.857
0cd146be-0a34-4864-97c7-a977a771b5aa	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_allocating_ports	{"ts": "2026-05-05T01:03:59.658516+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 01:03:58.859
9b5379de-649e-4ba8-a19d-39fb053abd5f	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_allocating_cpus	{"ts": "2026-05-05T01:03:59.658526+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-05 01:03:58.862
22980bb4-7021-4c12-a2fe-53924f4a850f	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_allocating_cpus	{"ts": "2026-05-05T01:03:59.666629+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-05 01:03:58.864
9dbe0136-d4ab-4029-8176-87f8348e7561	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_allocating_storage	{"ts": "2026-05-05T01:03:59.666644+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-05 01:03:58.866
b7dcb16b-1c7a-4da1-87d3-eec7fe0edea8	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_allocating_storage	{"ts": "2026-05-05T01:03:59.666652+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_407b2a0b-a8a7-42c7-b34b-142d57c8089e..."}	\N	2026-05-05 01:03:58.867
1df2db84-6b71-4c49-9fe1-af2210a8d0ae	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_allocating_storage	{"ts": "2026-05-05T01:04:00.365732+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_407b2a0b-a8a7-42c7-b34b-142d57c8089e"}	\N	2026-05-05 01:03:58.869
17623016-df06-4579-8daa-3f36b045548e	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_creating	{"ts": "2026-05-05T01:04:00.365772+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-05 01:03:58.871
3ee1a82a-99b4-4e7f-a2e0-518d070ace45	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_creating	{"ts": "2026-05-05T01:04:00.443493+00:00", "status": "completed", "message": "Container created: laas-407b2a0b"}	\N	2026-05-05 01:03:58.872
87513508-1a46-457d-aa46-7e04b7a63629	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_starting	{"ts": "2026-05-05T01:04:00.443503+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-05 01:03:58.874
b9cb4301-6a60-4745-8e75-f484cb08b08d	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_starting	{"ts": "2026-05-05T01:04:00.745808+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-05 01:03:58.876
f81eae55-057d-4552-b5a7-3a07329eaf8c	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_waiting_desktop	{"ts": "2026-05-05T01:04:00.745821+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-05 01:03:58.879
fafba2db-d35f-4082-8fe3-6d073923a223	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_waiting_desktop	{"ts": "2026-05-05T01:04:18.919321+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-05 01:04:17.614
6a073e8a-847e-4da0-82a6-97cd09d7e17a	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_waiting_desktop	{"ts": "2026-05-05T01:04:18.919334+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-05 01:04:17.617
e21c4223-f1aa-4c63-98a0-e7a4c72a171e	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_health_checking	{"ts": "2026-05-05T01:04:18.919336+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-05 01:04:17.619
cb5a295d-7e24-40ce-9f8c-df62f875a9a9	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_health_checking	{"ts": "2026-05-05T01:04:20.927616+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-05 01:04:19.639
cec52d86-c25e-42f8-925f-8fd4e42e3e82	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_ready	{"ts": "2026-05-05T01:04:20.927627+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-05 01:04:19.642
d56c6659-7d94-40e0-920f-b89250c856b7	407b2a0b-a8a7-42c7-b34b-142d57c8089e	launch_ready	{"ts": "2026-05-05T01:04:20.927632+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-05 01:04:19.644
bd07173d-f3d8-466f-b275-aed29ae9c934	407b2a0b-a8a7-42c7-b34b-142d57c8089e	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-05 01:04:19.654
d1babfcf-17be-40c5-8cdb-a6b37da9cee2	407b2a0b-a8a7-42c7-b34b-142d57c8089e	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 15500, "durationSeconds": 5, "terminationReason": "user_requested", "alreadyBilledCents": 15500, "remainingChargeCents": 0}	\N	2026-05-05 01:04:25.491
e79ec5da-c7ec-469e-b5c1-c9e7cf738a5a	3f659e62-8075-4437-a67b-9c9f9d07502b	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "instanceName": "gpu-instance-6opt", "interfaceMode": "gui"}	\N	2026-05-05 01:04:44.119
344c4011-51cf-4e67-bfb5-8003a925bcf6	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_initiated	{"launchId": "332f7ae3-f7bb-4573-aa63-08db5e592914", "containerName": "laas-3f659e62"}	\N	2026-05-05 01:04:44.177
f9f832fe-1477-4c22-9825-8e477df8460f	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_scheduling	{"ts": "2026-05-05T01:04:46.892248+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 01:04:46.209
77572740-625c-478e-ba49-d87c07af43d3	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_scheduling	{"ts": "2026-05-05T01:04:46.992425+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 01:04:46.211
6e0697a7-3e37-41d3-9dd2-a65520cd7001	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_allocating_ports	{"ts": "2026-05-05T01:04:46.992543+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 01:04:46.213
0ccd06f4-f9a7-4a83-98fe-e3f80b48e2f9	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_allocating_ports	{"ts": "2026-05-05T01:04:47.014815+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 01:04:46.215
047c64e6-2b5e-4d39-b4dc-375a2810b827	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_allocating_cpus	{"ts": "2026-05-05T01:04:47.014820+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-05 01:04:46.217
3ca22dc2-3dec-4c94-b22a-5faa24ada780	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_allocating_cpus	{"ts": "2026-05-05T01:04:47.024415+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-05 01:04:46.218
8c3e54fc-e283-411b-a987-ef5922713bd1	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_allocating_storage	{"ts": "2026-05-05T01:04:47.024431+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-05 01:04:46.22
2555bb28-9a1c-4783-8003-a7eda7daaf21	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_allocating_storage	{"ts": "2026-05-05T01:04:47.024437+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_3f659e62-8075-4437-a67b-9c9f9d07502b..."}	\N	2026-05-05 01:04:46.221
fc930531-d780-4e2b-b02d-e06bc6756e92	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_allocating_storage	{"ts": "2026-05-05T01:04:47.843913+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_3f659e62-8075-4437-a67b-9c9f9d07502b"}	\N	2026-05-05 01:04:46.223
c4280aeb-17ae-4504-b93e-be9e3804c99d	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_creating	{"ts": "2026-05-05T01:04:47.843956+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-05 01:04:46.224
6c9d4582-a6bb-4c26-87b8-703f00d8a746	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_creating	{"ts": "2026-05-05T01:04:47.911389+00:00", "status": "completed", "message": "Container created: laas-3f659e62"}	\N	2026-05-05 01:04:46.225
972cee2e-6aca-4bc1-8c24-00c9c9df9d6b	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_starting	{"ts": "2026-05-05T01:04:47.911400+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-05 01:04:46.227
c617b1df-896c-4a38-81ea-8fe36b151886	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_starting	{"ts": "2026-05-05T01:04:48.237843+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-05 01:04:46.229
d2422232-8f56-4011-9901-5b62877ff808	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_waiting_desktop	{"ts": "2026-05-05T01:04:48.237860+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-05 01:04:46.231
a0a26a1a-1827-4529-b3f7-365483f8c108	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_waiting_desktop	{"ts": "2026-05-05T01:06:06.996108+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-05 01:06:06.299
f12a0777-4ce1-4713-ad52-81d656048a82	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_waiting_desktop	{"ts": "2026-05-05T01:06:06.996116+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-05 01:06:06.301
114acca7-8e08-4f46-a00d-0103a90c13d6	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_health_checking	{"ts": "2026-05-05T01:06:06.996119+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-05 01:06:06.303
7d8e445b-f2a4-4461-b042-84959b03450d	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_health_checking	{"ts": "2026-05-05T01:06:09.005162+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-05 01:06:06.304
d2c6077d-5850-4aab-a6d6-7684ddaa398d	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_ready	{"ts": "2026-05-05T01:06:09.005178+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-05 01:06:06.305
92064edc-f7ab-4611-974c-5ca7cce62d62	3f659e62-8075-4437-a67b-9c9f9d07502b	launch_ready	{"ts": "2026-05-05T01:06:09.005186+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-05 01:06:06.306
42d43bac-0546-45b6-842c-f255e6c05a47	3f659e62-8075-4437-a67b-9c9f9d07502b	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.88.57.107:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-05 01:06:06.311
bcbaa1c1-1de3-4ff2-ae39-b205dfcb6087	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	session_created	{"configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "instanceName": "gpu-instance-mtp3", "interfaceMode": "gui"}	\N	2026-05-05 01:20:17.673
76fb942c-7303-4e46-9729-060c37d5f58e	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_initiated	{"launchId": "547a325f-f6af-4aed-ac12-b832954f202d", "containerName": "laas-8eafc0ac"}	\N	2026-05-05 01:20:17.74
e39bad9e-0418-4f2b-94ef-ac5ba151cd29	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_scheduling	{"ts": "2026-05-05T01:20:20.463084+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 01:20:19.769
4d987497-5652-4672-95d6-efbd6afefca7	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_scheduling	{"ts": "2026-05-05T01:20:20.563525+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 01:20:19.772
d10a2700-0f71-4e36-8600-549b90dea3b7	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_allocating_ports	{"ts": "2026-05-05T01:20:20.563637+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 01:20:19.775
c25113ad-81fe-466e-bfa4-172b4fe0d46c	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_allocating_ports	{"ts": "2026-05-05T01:20:20.583265+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 01:20:19.777
9751dec3-31e6-4c77-8792-b8f12263f465	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_allocating_cpus	{"ts": "2026-05-05T01:20:20.583274+00:00", "status": "in_progress", "message": "Finding 8 contiguous CPU cores..."}	\N	2026-05-05 01:20:19.779
ee7f31a1-c48f-4668-bccc-002412a1d6b5	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_allocating_cpus	{"ts": "2026-05-05T01:20:20.595518+00:00", "status": "completed", "message": "Allocated CPU cores: 2-9"}	\N	2026-05-05 01:20:19.781
148093a0-b188-4056-bfd4-8c8fb464aa6c	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_validating_mount	{"ts": "2026-05-05T01:20:20.595537+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_ec8ab0e4da1e4cd21f8e57f8..."}	\N	2026-05-05 01:20:19.783
14b906f3-c82f-487b-9807-33e7515a9a71	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_nvme_preparing	{"ts": "2026-05-05T01:20:20.595630+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 100.88.57.107..."}	\N	2026-05-05 01:20:19.785
3d673b8d-c1a2-43c7-9a71-ada3bd1a817f	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_nvme_discovering	{"ts": "2026-05-05T01:20:21.135058+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-05 01:20:19.787
d30dd71d-ab78-4cf5-8adb-fda825da8f28	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_nvme_discovering	{"ts": "2026-05-05T01:20:21.153553+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-05 01:20:19.789
cc6cecba-80ff-43ad-bc63-671932540a20	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_nvme_connecting	{"ts": "2026-05-05T01:20:21.153630+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_ec8ab0e4da1e4cd21f8e57f8..."}	\N	2026-05-05 01:20:19.791
c6323fb6-649f-4f05-9759-1f98035bd9df	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_nvme_connecting	{"ts": "2026-05-05T01:20:21.199648+00:00", "status": "completed", "message": "NVMe-oF connected"}	\N	2026-05-05 01:20:19.794
682481e3-6e4f-483c-af93-3b4e5727fde8	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_nvme_finding_device	{"ts": "2026-05-05T01:20:21.199715+00:00", "status": "in_progress", "message": "Locating NVMe block device..."}	\N	2026-05-05 01:20:19.796
f020fa9e-3382-453e-a32d-d666d7053d78	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_nvme_finding_device	{"ts": "2026-05-05T01:20:21.719991+00:00", "status": "completed", "message": "Block device found: /dev/nvme1n1"}	\N	2026-05-05 01:20:19.798
a4ea419a-9706-4870-9995-ab09328f0d31	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_nvme_mounting	{"ts": "2026-05-05T01:20:21.720109+00:00", "status": "in_progress", "message": "Mounting /dev/nvme1n1 to /mnt/nvme/u_ec8ab0e4da1e4cd21f8e57f8..."}	\N	2026-05-05 01:20:19.8
b0d12300-d08c-4768-aca1-cb8f27d0b547	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_nvme_mounting	{"ts": "2026-05-05T01:20:21.748162+00:00", "status": "completed", "message": "NVMe-oF volume mounted"}	\N	2026-05-05 01:20:19.802
d42696ac-9571-4ca0-ba98-9f0760fbe657	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_nvme_verifying	{"ts": "2026-05-05T01:20:21.748193+00:00", "status": "in_progress", "message": "Verifying storage permissions..."}	\N	2026-05-05 01:20:19.804
d08b1730-68b8-4a31-b954-c88a46759e06	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_nvme_verifying	{"ts": "2026-05-05T01:20:21.748622+00:00", "status": "completed", "message": "Permissions verified (UID 1000, read/write OK)"}	\N	2026-05-05 01:20:19.806
6acd429a-0363-449c-a8dd-1fc4c3851f95	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_validating_mount	{"ts": "2026-05-05T01:20:21.748655+00:00", "status": "completed", "message": "NVMe-oF storage ready at /mnt/nvme/u_ec8ab0e4da1e4cd21f8e57f8"}	\N	2026-05-05 01:20:19.808
8bd584ac-02dd-4500-87e4-e48839c37e0e	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_creating	{"ts": "2026-05-05T01:20:21.748689+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-05 01:20:19.811
56c47a8c-a926-4893-8f61-df58fbf10388	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_creating	{"ts": "2026-05-05T01:20:21.838757+00:00", "status": "completed", "message": "Container created: laas-8eafc0ac"}	\N	2026-05-05 01:20:19.813
3c06e189-7ed9-49ac-9d69-195849d9c603	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_starting	{"ts": "2026-05-05T01:20:21.838764+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-05 01:20:19.815
5eab597e-56b5-4a4b-a31c-1b5fbc19ee4a	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_starting	{"ts": "2026-05-05T01:20:22.221191+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-05 01:20:19.817
adc71af7-aec8-4ac6-b1c2-0218fd3de817	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_waiting_desktop	{"ts": "2026-05-05T01:20:22.221204+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-05 01:20:19.819
37209399-3bb9-4bd0-a723-d3ed9aa503d4	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_waiting_desktop	{"ts": "2026-05-05T01:20:38.387197+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-05 01:20:37.095
bdfcc2ff-0886-41d5-8bb9-9b22d41aa31e	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_waiting_desktop	{"ts": "2026-05-05T01:20:38.387212+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-05 01:20:37.098
e4339c30-4a17-4615-bda3-f76634a50893	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_health_checking	{"ts": "2026-05-05T01:20:38.387215+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-05 01:20:37.101
c87fbbdc-46a6-4cd8-92e5-7e2e3d60c7df	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_health_checking	{"ts": "2026-05-05T01:20:40.395805+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-05 01:20:39.134
48ac25c2-ff88-4f49-a4e8-5135c737cc02	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_ready	{"ts": "2026-05-05T01:20:40.395820+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-05 01:20:39.136
79a614e4-82bf-47fd-8a21-fcd662ff13cd	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	launch_ready	{"ts": "2026-05-05T01:20:40.395832+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-05 01:20:39.138
c3535863-0312-4bd2-b712-f1bf3f372e00	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-05 01:20:39.148
373e275f-dcf4-44ff-91cc-318e1b8766c7	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 42000, "durationSeconds": 13865, "terminationReason": "user_requested", "alreadyBilledCents": 52500, "remainingChargeCents": 0}	\N	2026-05-05 05:11:44.502
378bb470-1829-4436-b3be-70f55fafe810	3f659e62-8075-4437-a67b-9c9f9d07502b	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 77500, "durationSeconds": 14767, "terminationReason": "user_requested", "alreadyBilledCents": 77500, "remainingChargeCents": 0}	\N	2026-05-05 05:12:13.424
d311da9f-fa40-4272-b735-3e15bdb6a8e1	f4ebd53c-e856-43d6-b735-f72c0999c56b	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "instanceName": "gpu-instance-5rjj", "interfaceMode": "gui"}	\N	2026-05-05 05:14:26.441
163aa814-de0d-436e-b486-5e8d30b07a13	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_initiated	{"launchId": "2147919c-8008-4087-809c-a295403f1b6c", "containerName": "laas-f4ebd53c"}	\N	2026-05-05 05:14:26.496
b8d182e6-db8e-4709-9691-5f7fc083109e	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_scheduling	{"ts": "2026-05-05T05:14:30.139836+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 05:14:28.518
0eab904d-9243-477e-9a52-cbd82a74662b	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_scheduling	{"ts": "2026-05-05T05:14:30.240029+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 05:14:28.52
c2e9b8d8-bf00-4a33-ad23-172e87e1c609	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_allocating_ports	{"ts": "2026-05-05T05:14:30.240144+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 05:14:28.521
beff617c-69f3-4196-8346-41683d9afb42	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_allocating_ports	{"ts": "2026-05-05T05:14:30.262842+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 05:14:28.522
c99fee24-95ce-4ea4-8f13-f27d3b914aff	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_allocating_cpus	{"ts": "2026-05-05T05:14:30.262847+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-05 05:14:28.524
cde06546-cc16-477e-81c7-e17fda71afcb	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_allocating_cpus	{"ts": "2026-05-05T05:14:30.271882+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-05 05:14:28.525
24b3e28d-2c9b-48c3-a6c5-01e506abed54	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_allocating_storage	{"ts": "2026-05-05T05:14:30.271896+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-05 05:14:28.526
56761e98-3c1b-4f84-b174-dbeef20d1050	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_allocating_storage	{"ts": "2026-05-05T05:14:30.271902+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_f4ebd53c-e856-43d6-b735-f72c0999c56b..."}	\N	2026-05-05 05:14:28.527
0ceebdf5-b802-44e3-b4df-eb8b40207102	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_allocating_storage	{"ts": "2026-05-05T05:14:30.970149+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_f4ebd53c-e856-43d6-b735-f72c0999c56b"}	\N	2026-05-05 05:14:28.528
1f323fdb-34e4-4db1-833d-fcddf4bfc384	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_creating	{"ts": "2026-05-05T05:14:30.970191+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-05 05:14:28.529
ded6fc48-ab04-4c88-8a8b-6d67d0a330fc	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_creating	{"ts": "2026-05-05T05:14:31.047489+00:00", "status": "completed", "message": "Container created: laas-f4ebd53c"}	\N	2026-05-05 05:14:28.53
19551315-286b-432f-be69-985bef9a3e1c	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_starting	{"ts": "2026-05-05T05:14:31.047496+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-05 05:14:28.531
bb2f6a21-3b57-4d93-a528-cea13b7948c4	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_starting	{"ts": "2026-05-05T05:14:31.337192+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-05 05:14:28.532
37d03766-d513-4e1f-a036-689f17ff7614	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_waiting_desktop	{"ts": "2026-05-05T05:14:31.337207+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-05 05:14:28.533
6e5e6bcd-5b61-484c-9fa6-6dd0abbe966d	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_waiting_desktop	{"ts": "2026-05-05T05:14:51.531435+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-05 05:14:48.781
ddb0e1de-17fe-46fb-8691-6952518a0766	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_waiting_desktop	{"ts": "2026-05-05T05:14:51.531449+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-05 05:14:48.783
8e36abcd-0096-4439-976b-fd12fde1a090	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_health_checking	{"ts": "2026-05-05T05:14:51.531452+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-05 05:14:48.784
baf1bd9a-1705-4f22-b4dc-fc29e7a1f635	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_health_checking	{"ts": "2026-05-05T05:14:53.540043+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-05 05:14:50.809
aed56c76-d6bd-4836-9e60-96c209f4e38f	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_ready	{"ts": "2026-05-05T05:14:53.540059+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-05 05:14:50.811
ae232704-9039-4847-b71b-8b3479a02e69	f4ebd53c-e856-43d6-b735-f72c0999c56b	launch_ready	{"ts": "2026-05-05T05:14:53.540067+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-05 05:14:50.812
0d2e5d74-834c-4a42-be42-d6f808f08fc9	f4ebd53c-e856-43d6-b735-f72c0999c56b	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-05 05:14:50.817
ba736130-18bf-4b90-ab7d-689f0c1efd11	f4ebd53c-e856-43d6-b735-f72c0999c56b	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 15500, "durationSeconds": 22, "terminationReason": "user_requested", "alreadyBilledCents": 15500, "remainingChargeCents": 0}	\N	2026-05-05 05:15:13.744
daa0af51-2791-448f-9b41-978b421c7b29	50003a90-973a-4998-b722-4e75c934f5d3	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-vjkj", "interfaceMode": "gui"}	\N	2026-05-05 05:15:32.868
fdfc165a-8975-4049-bb36-f5626c293669	50003a90-973a-4998-b722-4e75c934f5d3	launch_initiated	{"launchId": "5ce242e8-56ee-4fbb-97d2-23fb86e64c78", "containerName": "laas-50003a90"}	\N	2026-05-05 05:15:32.92
056e16fe-20ff-4c3d-8333-9a6a657ff92d	50003a90-973a-4998-b722-4e75c934f5d3	launch_scheduling	{"ts": "2026-05-05T05:15:36.560564+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 05:15:34.95
c21cf418-4ad0-4ad3-b67a-b810ac9a6c39	50003a90-973a-4998-b722-4e75c934f5d3	launch_scheduling	{"ts": "2026-05-05T05:15:36.661144+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 05:15:34.953
d85ec37f-478c-4ad4-927b-ba6a382d18f7	50003a90-973a-4998-b722-4e75c934f5d3	launch_allocating_ports	{"ts": "2026-05-05T05:15:36.661260+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 05:15:34.956
218b6b5d-1ae9-4291-9ece-95193ffd21ea	50003a90-973a-4998-b722-4e75c934f5d3	launch_allocating_ports	{"ts": "2026-05-05T05:15:36.682516+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 05:15:34.959
a6412294-3c05-4f15-8e57-7709bbd633df	50003a90-973a-4998-b722-4e75c934f5d3	launch_allocating_cpus	{"ts": "2026-05-05T05:15:36.682522+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-05 05:15:34.961
66d6eff2-60d7-47d5-a2de-f39f67ffdf2b	50003a90-973a-4998-b722-4e75c934f5d3	launch_allocating_cpus	{"ts": "2026-05-05T05:15:36.692582+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-05 05:15:34.963
0cd59586-771a-4838-bd9b-ffd1aa658eb3	50003a90-973a-4998-b722-4e75c934f5d3	launch_validating_mount	{"ts": "2026-05-05T05:15:36.692594+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_a83c0ea547ffbfb60c5b80d9..."}	\N	2026-05-05 05:15:34.965
661bec98-8789-42c0-a0be-91e761b08609	50003a90-973a-4998-b722-4e75c934f5d3	launch_nvme_preparing	{"ts": "2026-05-05T05:15:36.692665+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 100.88.57.107..."}	\N	2026-05-05 05:15:34.967
0e3c745b-e095-4388-8e54-4690b72897e7	50003a90-973a-4998-b722-4e75c934f5d3	launch_nvme_discovering	{"ts": "2026-05-05T05:15:36.966013+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-05 05:15:34.97
2b2cede9-88f0-489b-9636-e502be8b3451	50003a90-973a-4998-b722-4e75c934f5d3	launch_nvme_discovering	{"ts": "2026-05-05T05:15:36.985546+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-05 05:15:34.973
3c4d37ff-cb8d-4830-ba33-07fbfde63a91	50003a90-973a-4998-b722-4e75c934f5d3	launch_nvme_connecting	{"ts": "2026-05-05T05:15:36.985646+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_a83c0ea547ffbfb60c5b80d9..."}	\N	2026-05-05 05:15:34.975
2845f3c9-c115-4d4c-9b77-30c7bc7a490f	50003a90-973a-4998-b722-4e75c934f5d3	launch_nvme_connecting	{"ts": "2026-05-05T05:15:37.033255+00:00", "status": "completed", "message": "NVMe-oF connected"}	\N	2026-05-05 05:15:34.977
bb94b076-acb0-4476-b2eb-824fc6e0e130	50003a90-973a-4998-b722-4e75c934f5d3	launch_nvme_finding_device	{"ts": "2026-05-05T05:15:37.033349+00:00", "status": "in_progress", "message": "Locating NVMe block device..."}	\N	2026-05-05 05:15:34.978
21b09b63-1325-4f22-8328-ec0de5686f88	50003a90-973a-4998-b722-4e75c934f5d3	launch_nvme_finding_device	{"ts": "2026-05-05T05:15:37.553749+00:00", "status": "completed", "message": "Block device found: /dev/nvme2n1"}	\N	2026-05-05 05:15:34.981
7e6b3af3-019d-433e-b9a8-168f2b38e1d9	50003a90-973a-4998-b722-4e75c934f5d3	launch_nvme_mounting	{"ts": "2026-05-05T05:15:37.553866+00:00", "status": "in_progress", "message": "Mounting /dev/nvme2n1 to /mnt/nvme/u_a83c0ea547ffbfb60c5b80d9..."}	\N	2026-05-05 05:15:34.983
50dcca86-56a6-4f45-97bf-0173d0abf93a	50003a90-973a-4998-b722-4e75c934f5d3	launch_nvme_mounting	{"ts": "2026-05-05T05:15:37.578688+00:00", "status": "completed", "message": "NVMe-oF volume mounted"}	\N	2026-05-05 05:15:34.986
505f028c-0d83-4b91-9c99-0281cdbf40c8	50003a90-973a-4998-b722-4e75c934f5d3	launch_nvme_verifying	{"ts": "2026-05-05T05:15:37.578747+00:00", "status": "in_progress", "message": "Verifying storage permissions..."}	\N	2026-05-05 05:15:34.988
4ec95b56-a02a-43bc-bc82-eecfeec26042	50003a90-973a-4998-b722-4e75c934f5d3	launch_nvme_verifying	{"ts": "2026-05-05T05:15:37.579286+00:00", "status": "completed", "message": "Permissions verified (UID 1000, read/write OK)"}	\N	2026-05-05 05:15:34.99
dd4cc467-bec9-4781-919b-dfeffe86c415	50003a90-973a-4998-b722-4e75c934f5d3	launch_validating_mount	{"ts": "2026-05-05T05:15:37.579363+00:00", "status": "completed", "message": "NVMe-oF storage ready at /mnt/nvme/u_a83c0ea547ffbfb60c5b80d9"}	\N	2026-05-05 05:15:34.993
ab317008-6573-4ba0-8ed5-0c25297a64f6	50003a90-973a-4998-b722-4e75c934f5d3	launch_creating	{"ts": "2026-05-05T05:15:37.579418+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-05 05:15:34.995
9d3b0d73-8c7f-4c20-82ab-292433fc9013	50003a90-973a-4998-b722-4e75c934f5d3	launch_creating	{"ts": "2026-05-05T05:15:37.668779+00:00", "status": "completed", "message": "Container created: laas-50003a90"}	\N	2026-05-05 05:15:34.998
69d079b0-de99-41bc-a8f2-ee089332aa68	50003a90-973a-4998-b722-4e75c934f5d3	launch_starting	{"ts": "2026-05-05T05:15:37.668786+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-05 05:15:35
f49a3887-a9f8-4f77-a349-01d23f7f7e82	50003a90-973a-4998-b722-4e75c934f5d3	launch_starting	{"ts": "2026-05-05T05:15:37.984832+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-05 05:15:35.003
01676300-bb5c-41ec-86c4-0a1c6ccf7c8b	50003a90-973a-4998-b722-4e75c934f5d3	launch_waiting_desktop	{"ts": "2026-05-05T05:15:37.984846+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-05 05:15:35.005
6a453c6a-a1e7-4a7f-9298-471a8e6fb93b	50003a90-973a-4998-b722-4e75c934f5d3	launch_waiting_desktop	{"ts": "2026-05-05T05:15:52.127092+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-05 05:15:49.171
22e731c2-7a00-473d-9420-821f2d661961	50003a90-973a-4998-b722-4e75c934f5d3	launch_waiting_desktop	{"ts": "2026-05-05T05:15:52.127105+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-05 05:15:49.173
dcaf816b-9104-4c26-ad2d-70f675748033	50003a90-973a-4998-b722-4e75c934f5d3	launch_health_checking	{"ts": "2026-05-05T05:15:52.127109+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-05 05:15:49.174
9f7b0b66-6236-44b6-a02e-6f5e5a0eb847	50003a90-973a-4998-b722-4e75c934f5d3	launch_health_checking	{"ts": "2026-05-05T05:15:54.135925+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-05 05:15:51.206
4bab3966-4673-4968-b75a-4090ed71fb95	50003a90-973a-4998-b722-4e75c934f5d3	launch_ready	{"ts": "2026-05-05T05:15:54.135940+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-05 05:15:51.208
cc837f8b-bef9-4aa3-b489-1be9385b75c0	50003a90-973a-4998-b722-4e75c934f5d3	launch_ready	{"ts": "2026-05-05T05:15:54.135949+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-05 05:15:51.209
468f4033-789a-4fed-bd45-835147b8157a	50003a90-973a-4998-b722-4e75c934f5d3	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-05 05:15:51.216
d1638a19-311b-4667-8f5c-95474693b480	50003a90-973a-4998-b722-4e75c934f5d3	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 15500, "durationSeconds": 26, "terminationReason": "user_requested", "alreadyBilledCents": 15500, "remainingChargeCents": 0}	\N	2026-05-05 05:16:18.002
cb477c02-8621-42ea-bf98-2f4d29201a46	21e006dd-20c2-4e16-8032-42a267f1084f	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "instanceName": "gpu-instance-ztg0", "interfaceMode": "gui"}	\N	2026-05-05 05:16:53.716
aad73418-950d-42f1-8e87-4c6313842f99	21e006dd-20c2-4e16-8032-42a267f1084f	launch_initiated	{"launchId": "78da505d-9a5f-4d5d-bdaf-5d274c413c5d", "containerName": "laas-21e006dd"}	\N	2026-05-05 05:16:53.765
a2ea9c76-7a8c-4606-8212-d0c0e937dbe0	21e006dd-20c2-4e16-8032-42a267f1084f	launch_scheduling	{"ts": "2026-05-05T05:16:57.410649+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 05:16:55.793
05ec49dc-07a2-4a79-a2c0-4ed56afef2ff	21e006dd-20c2-4e16-8032-42a267f1084f	launch_scheduling	{"ts": "2026-05-05T05:16:57.510828+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 05:16:55.795
726d4a7f-3fb0-49b6-848d-d37e92b57f2d	21e006dd-20c2-4e16-8032-42a267f1084f	launch_allocating_ports	{"ts": "2026-05-05T05:16:57.510940+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 05:16:55.797
bd482b96-faf1-4a65-944a-936a63aa12a3	21e006dd-20c2-4e16-8032-42a267f1084f	launch_allocating_ports	{"ts": "2026-05-05T05:16:57.531392+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 05:16:55.798
25f2bc0b-dbae-47f6-9053-b414b5d9d617	21e006dd-20c2-4e16-8032-42a267f1084f	launch_allocating_cpus	{"ts": "2026-05-05T05:16:57.531403+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-05 05:16:55.8
2e9bf65e-e2a7-4aa8-8d03-7373b34b5ae1	21e006dd-20c2-4e16-8032-42a267f1084f	launch_allocating_cpus	{"ts": "2026-05-05T05:16:57.539596+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-05 05:16:55.801
af4d6ac2-5389-41fd-a39f-c737d9be6e3b	21e006dd-20c2-4e16-8032-42a267f1084f	launch_allocating_storage	{"ts": "2026-05-05T05:16:57.539611+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-05 05:16:55.802
7c3f3171-eca3-42af-8202-f2b76d6e480c	21e006dd-20c2-4e16-8032-42a267f1084f	launch_allocating_storage	{"ts": "2026-05-05T05:16:57.539618+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_21e006dd-20c2-4e16-8032-42a267f1084f..."}	\N	2026-05-05 05:16:55.803
269bd4de-dad3-4b96-9976-0b111456b270	21e006dd-20c2-4e16-8032-42a267f1084f	launch_allocating_storage	{"ts": "2026-05-05T05:16:58.233549+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_21e006dd-20c2-4e16-8032-42a267f1084f"}	\N	2026-05-05 05:16:55.804
bce55d61-22f0-49b8-9cf4-33b00736cd99	21e006dd-20c2-4e16-8032-42a267f1084f	launch_creating	{"ts": "2026-05-05T05:16:58.233592+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-05 05:16:55.805
5b444989-be44-4497-81c6-e39f04f52798	21e006dd-20c2-4e16-8032-42a267f1084f	launch_creating	{"ts": "2026-05-05T05:16:58.312851+00:00", "status": "completed", "message": "Container created: laas-21e006dd"}	\N	2026-05-05 05:16:55.806
b0310e9b-3cee-48d4-b939-c39bdc5eb52a	21e006dd-20c2-4e16-8032-42a267f1084f	launch_starting	{"ts": "2026-05-05T05:16:58.312863+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-05 05:16:55.807
ded02353-ef57-4165-ba8d-c1391dba602b	21e006dd-20c2-4e16-8032-42a267f1084f	launch_starting	{"ts": "2026-05-05T05:16:58.632342+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-05 05:16:55.808
082d15b6-d6a3-4dd6-a7fd-2f3f01b414d5	21e006dd-20c2-4e16-8032-42a267f1084f	launch_waiting_desktop	{"ts": "2026-05-05T05:16:58.632358+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-05 05:16:55.809
45399c9b-0033-451f-bbce-2214b74656c7	21e006dd-20c2-4e16-8032-42a267f1084f	launch_waiting_desktop	{"ts": "2026-05-05T05:17:12.768245+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-05 05:17:09.975
c421d15c-c58c-40d6-9823-597877cfb512	21e006dd-20c2-4e16-8032-42a267f1084f	launch_waiting_desktop	{"ts": "2026-05-05T05:17:12.768265+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-05 05:17:09.977
78c5780c-bc86-43e9-bdcd-ba8fad73f688	21e006dd-20c2-4e16-8032-42a267f1084f	launch_health_checking	{"ts": "2026-05-05T05:17:12.768269+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-05 05:17:09.978
b80222af-7bb4-4702-84b0-451bdd99de85	21e006dd-20c2-4e16-8032-42a267f1084f	launch_health_checking	{"ts": "2026-05-05T05:17:14.777200+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-05 05:17:11.998
0059f621-54a8-4142-b3fb-ac16255e6f23	21e006dd-20c2-4e16-8032-42a267f1084f	launch_ready	{"ts": "2026-05-05T05:17:14.777215+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-05 05:17:11.999
f15670a0-0760-483b-9ed0-7b97662320fa	21e006dd-20c2-4e16-8032-42a267f1084f	launch_ready	{"ts": "2026-05-05T05:17:14.777226+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-05 05:17:12.001
89cab861-f425-4429-8635-9b32603fd79e	21e006dd-20c2-4e16-8032-42a267f1084f	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-05 05:17:12.007
a88a3ca9-2447-4e9e-91f0-91c76edea95b	21e006dd-20c2-4e16-8032-42a267f1084f	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 15500, "durationSeconds": 12, "terminationReason": "user_requested", "alreadyBilledCents": 15500, "remainingChargeCents": 0}	\N	2026-05-05 05:17:24.1
2f962992-2da4-4d6b-90f2-0ab7a0095d79	d95f2adf-135b-420e-b3ff-fc150228ded8	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "instanceName": "gpu-instance-sqz2", "interfaceMode": "gui"}	\N	2026-05-05 05:17:39.73
fe592c7e-f57b-42e0-9020-af809453de5b	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_initiated	{"launchId": "f0b3359f-11be-4a42-98f9-07b2ec688c4e", "containerName": "laas-d95f2adf"}	\N	2026-05-05 05:17:39.776
4beeea16-ddd6-4278-af9c-faa180110f9e	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_scheduling	{"ts": "2026-05-05T05:17:43.422593+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 05:17:41.795
16f6922f-db60-4d46-8382-1e7999f95ebb	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_scheduling	{"ts": "2026-05-05T05:17:43.523101+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 05:17:41.796
62f20d01-83a3-4db7-a5c1-a30dc401b3c8	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_allocating_ports	{"ts": "2026-05-05T05:17:43.523224+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 05:17:41.798
9049f797-9f2d-4843-9341-0f22229306be	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_allocating_ports	{"ts": "2026-05-05T05:17:43.547130+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 05:17:41.799
9226fef2-ce5d-419e-b06e-c00b08a1a64d	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_allocating_cpus	{"ts": "2026-05-05T05:17:43.547139+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-05 05:17:41.801
d2df67b7-6c72-452f-8201-7bc63423ff67	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_allocating_cpus	{"ts": "2026-05-05T05:17:43.556474+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-05 05:17:41.802
363bb57e-6a58-4d27-9d38-d4ca7ba4a3c2	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_allocating_storage	{"ts": "2026-05-05T05:17:43.556492+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-05 05:17:41.804
3a3ca0b1-1ab3-440a-ae1e-916ed2648d3e	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_allocating_storage	{"ts": "2026-05-05T05:17:43.556499+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_d95f2adf-135b-420e-b3ff-fc150228ded8..."}	\N	2026-05-05 05:17:41.805
0756b794-77d9-4076-bc08-9fb2db993300	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_allocating_storage	{"ts": "2026-05-05T05:17:44.259754+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_d95f2adf-135b-420e-b3ff-fc150228ded8"}	\N	2026-05-05 05:17:41.806
0aedbd5c-48a8-4815-8b23-84b7298a4a62	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_creating	{"ts": "2026-05-05T05:17:44.259797+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-05 05:17:41.807
65932933-f454-4608-ba5c-53eac3e689a9	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_creating	{"ts": "2026-05-05T05:17:44.333700+00:00", "status": "completed", "message": "Container created: laas-d95f2adf"}	\N	2026-05-05 05:17:41.808
5f20f75c-f720-43e2-ac7c-909713590e58	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_starting	{"ts": "2026-05-05T05:17:44.333707+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-05 05:17:41.809
a0d5218a-ded6-48b9-8833-30137a4897ef	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_starting	{"ts": "2026-05-05T05:17:44.640241+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-05 05:17:41.81
d00602e4-bdfb-4bf9-8196-2c196bef3eae	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_waiting_desktop	{"ts": "2026-05-05T05:17:44.640264+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-05 05:17:41.81
9cf61700-46b3-4772-a82b-e62bd277dfca	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_waiting_desktop	{"ts": "2026-05-05T05:17:58.779276+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-05 05:17:55.969
a073176f-1166-4d4c-a269-948e59a51c88	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_waiting_desktop	{"ts": "2026-05-05T05:17:58.779289+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-05 05:17:55.971
e77ae6b0-d751-440c-8e47-b21a2247727a	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_health_checking	{"ts": "2026-05-05T05:17:58.779292+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-05 05:17:55.972
f45fe435-823d-4502-91cf-319f25ad0de4	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_health_checking	{"ts": "2026-05-05T05:18:00.788621+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-05 05:17:58.002
8822df89-1489-4221-9830-742077da62a6	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_ready	{"ts": "2026-05-05T05:18:00.788636+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-05 05:17:58.004
f8ca9719-df64-4539-aa9d-f645cefc1105	d95f2adf-135b-420e-b3ff-fc150228ded8	launch_ready	{"ts": "2026-05-05T05:18:00.788645+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-05 05:17:58.005
f9ebb4fb-589b-47fa-9425-59bc16738622	d95f2adf-135b-420e-b3ff-fc150228ded8	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-05 05:17:58.013
37a72eae-2e64-48ad-8c79-d5893b4acc2e	49b75056-41c8-4ea7-8d06-7292d3a1bff9	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "instanceName": "gpu-instance-f7a5", "interfaceMode": "gui"}	\N	2026-05-05 05:18:14.534
903a4154-609a-4b4e-b257-283ed72f6e7b	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_initiated	{"launchId": "8b4b585c-86c8-4af5-ae39-4f27fe80b299", "containerName": "laas-49b75056"}	\N	2026-05-05 05:18:14.638
3f24122c-a4e4-47f7-9efc-717233a1ee72	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_scheduling	{"ts": "2026-05-05T05:18:18.284906+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 05:18:16.661
c708257c-9e38-4cbd-b5d5-92a1c12b1c0d	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_scheduling	{"ts": "2026-05-05T05:18:18.385100+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 05:18:16.663
2ef32d62-d376-4131-a946-2556de0d9f1d	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_allocating_ports	{"ts": "2026-05-05T05:18:18.385207+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 05:18:16.664
fb1b5914-0987-4e8f-8fbc-e19a719495a6	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_allocating_ports	{"ts": "2026-05-05T05:18:18.408970+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 05:18:16.666
ad6405b7-760a-44f8-b04f-329f84b9710b	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_allocating_cpus	{"ts": "2026-05-05T05:18:18.408975+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-05 05:18:16.668
c10a857e-4914-4d8b-9e04-a7c1a506b7e0	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_allocating_cpus	{"ts": "2026-05-05T05:18:18.418951+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-05 05:18:16.669
b1e8126b-fe2b-470b-a392-ca200683adc4	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_allocating_storage	{"ts": "2026-05-05T05:18:18.418962+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-05 05:18:16.67
12eb92ee-9025-4a6a-bb02-3daceb9f7808	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_allocating_storage	{"ts": "2026-05-05T05:18:18.418967+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_49b75056-41c8-4ea7-8d06-7292d3a1bff9..."}	\N	2026-05-05 05:18:16.671
ad5585a5-4b9b-440d-80f9-bbd329769581	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_allocating_storage	{"ts": "2026-05-05T05:18:19.112796+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_49b75056-41c8-4ea7-8d06-7292d3a1bff9"}	\N	2026-05-05 05:18:16.673
663b3e89-fc14-4b75-93ef-1db440a3754d	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_creating	{"ts": "2026-05-05T05:18:19.112859+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-05 05:18:16.674
2588c292-9982-480f-87dc-7c837f85124d	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_creating	{"ts": "2026-05-05T05:18:19.194041+00:00", "status": "completed", "message": "Container created: laas-49b75056"}	\N	2026-05-05 05:18:16.675
19e1561c-a059-44fd-bb3e-605b261eea48	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_starting	{"ts": "2026-05-05T05:18:19.194047+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-05 05:18:16.676
24a2bda7-3c37-4baa-b841-8cc656f29d84	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_starting	{"ts": "2026-05-05T05:18:19.501831+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-05 05:18:16.677
2b8ca1d5-c9eb-4ba9-891e-637e68e963d5	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_waiting_desktop	{"ts": "2026-05-05T05:18:19.501842+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-05 05:18:16.679
82775ad7-17a8-48e6-8fc6-c7cec2808b83	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_waiting_desktop	{"ts": "2026-05-05T05:18:33.644666+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-05 05:18:30.861
a7f2ff6f-4bd8-4da1-a3e7-5b1686111095	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_waiting_desktop	{"ts": "2026-05-05T05:18:33.644682+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-05 05:18:30.863
3307f9c7-c4e3-40bc-b2c7-b0836a8aa252	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_health_checking	{"ts": "2026-05-05T05:18:33.644685+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-05 05:18:30.865
da614969-39a0-42a8-a687-8f0128cc36ac	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_health_checking	{"ts": "2026-05-05T05:18:35.652163+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-05 05:18:32.894
32221114-1eda-4eee-98be-319460fc2ba6	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_ready	{"ts": "2026-05-05T05:18:35.652174+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-05 05:18:32.896
d7bf292b-3254-4e01-ac78-c0c89505a0da	49b75056-41c8-4ea7-8d06-7292d3a1bff9	launch_ready	{"ts": "2026-05-05T05:18:35.652182+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-05 05:18:32.897
e04d39e7-2f0c-4c40-9ebf-8bdf1acfed36	49b75056-41c8-4ea7-8d06-7292d3a1bff9	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.88.57.107:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-05 05:18:32.902
0aa7be61-fefe-4c2d-b856-b83b0e8c7ff9	d95f2adf-135b-420e-b3ff-fc150228ded8	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 15500, "durationSeconds": 47, "terminationReason": "user_requested", "alreadyBilledCents": 15500, "remainingChargeCents": 0}	\N	2026-05-05 05:18:45.335
e7ca8e9b-4e59-4261-a94b-e904a6b9156b	22354ffb-9b8e-4851-b4c2-66b44b328eb3	session_created	{"configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "instanceName": "gpu-instance-p54r", "interfaceMode": "gui"}	\N	2026-05-05 05:20:37.899
6216938e-399c-4e90-be34-16d15743ec77	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_initiated	{"launchId": "dca8b618-e713-4474-bb85-1b19a6625b9a", "containerName": "laas-22354ffb"}	\N	2026-05-05 05:20:37.958
96a36ef2-4852-4944-916c-29860f5922eb	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_scheduling	{"ts": "2026-05-05T05:20:41.605037+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 05:20:39.988
ab4a0593-fe4a-45ce-92ae-a2c2292dffe1	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_scheduling	{"ts": "2026-05-05T05:20:41.705215+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 05:20:39.99
2d9280c1-7014-4004-b848-8234bd455631	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_allocating_ports	{"ts": "2026-05-05T05:20:41.705328+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 05:20:39.992
adf10f83-03a8-4c8e-b03f-c22122946833	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_allocating_ports	{"ts": "2026-05-05T05:20:41.725000+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 05:20:39.994
546c7895-ac06-4f10-8639-2a3f6fa2f54b	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_allocating_cpus	{"ts": "2026-05-05T05:20:41.725010+00:00", "status": "in_progress", "message": "Finding 8 contiguous CPU cores..."}	\N	2026-05-05 05:20:39.995
8c8aeb4c-f730-4982-8c71-4a40be8e98d4	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_allocating_cpus	{"ts": "2026-05-05T05:20:41.733312+00:00", "status": "completed", "message": "Allocated CPU cores: 2-9"}	\N	2026-05-05 05:20:39.996
47e7bf8c-bca8-4bfd-84f0-94584fba768e	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_validating_mount	{"ts": "2026-05-05T05:20:41.733326+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_a83c0ea547ffbfb60c5b80d9..."}	\N	2026-05-05 05:20:39.998
46fcea26-504b-41e8-ba9c-1086d777d32c	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_nvme_preparing	{"ts": "2026-05-05T05:20:41.733402+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 100.88.57.107..."}	\N	2026-05-05 05:20:39.999
bfa828f2-7c89-4a54-a33a-fc946a60a4d9	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_nvme_discovering	{"ts": "2026-05-05T05:20:42.072034+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-05 05:20:40
293de31b-7f7b-41b2-8cc7-f309f222c87c	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_nvme_discovering	{"ts": "2026-05-05T05:20:42.089466+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-05 05:20:40.001
e0db6832-15fa-4c9a-b5e2-b1f608d7a6a5	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_nvme_connecting	{"ts": "2026-05-05T05:20:42.089523+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_a83c0ea547ffbfb60c5b80d9..."}	\N	2026-05-05 05:20:40.003
c8449689-2e86-4a45-ab31-37d6bca60095	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_nvme_connecting	{"ts": "2026-05-05T05:20:42.140745+00:00", "status": "completed", "message": "NVMe-oF connected"}	\N	2026-05-05 05:20:40.004
11d3bdc3-cb17-4a2a-a8a2-0f1babea98d1	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_nvme_finding_device	{"ts": "2026-05-05T05:20:42.140778+00:00", "status": "in_progress", "message": "Locating NVMe block device..."}	\N	2026-05-05 05:20:40.005
0a362f8e-e3cc-405a-afd7-b2c510506cc2	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_nvme_finding_device	{"ts": "2026-05-05T05:20:42.661402+00:00", "status": "completed", "message": "Block device found: /dev/nvme2n1"}	\N	2026-05-05 05:20:40.006
55053188-77f2-4ffc-94e5-40fc377c11b5	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_nvme_mounting	{"ts": "2026-05-05T05:20:42.661514+00:00", "status": "in_progress", "message": "Mounting /dev/nvme2n1 to /mnt/nvme/u_a83c0ea547ffbfb60c5b80d9..."}	\N	2026-05-05 05:20:40.007
871f8ad2-a08e-45a8-88eb-3b0433dbdf5b	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_nvme_mounting	{"ts": "2026-05-05T05:20:42.684842+00:00", "status": "completed", "message": "NVMe-oF volume mounted"}	\N	2026-05-05 05:20:40.008
0cc822b3-ed8e-4b63-b619-3a986893e689	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_nvme_verifying	{"ts": "2026-05-05T05:20:42.684904+00:00", "status": "in_progress", "message": "Verifying storage permissions..."}	\N	2026-05-05 05:20:40.008
39d26eba-f7e3-4f40-b494-1f44dd328176	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_nvme_verifying	{"ts": "2026-05-05T05:20:42.685382+00:00", "status": "completed", "message": "Permissions verified (UID 1000, read/write OK)"}	\N	2026-05-05 05:20:40.009
db1c9839-23a3-428c-b2af-8f43b592f829	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_validating_mount	{"ts": "2026-05-05T05:20:42.685448+00:00", "status": "completed", "message": "NVMe-oF storage ready at /mnt/nvme/u_a83c0ea547ffbfb60c5b80d9"}	\N	2026-05-05 05:20:40.01
3fdc17d6-ba3e-4a25-96fd-4ecdfc3d4179	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_creating	{"ts": "2026-05-05T05:20:42.685512+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-05 05:20:40.011
70606d30-4302-446c-bf03-7986f6b5f2ee	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_creating	{"ts": "2026-05-05T05:20:42.774111+00:00", "status": "completed", "message": "Container created: laas-22354ffb"}	\N	2026-05-05 05:20:40.012
c4a8bdf4-f6c1-4731-abb0-127bbb50e697	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_starting	{"ts": "2026-05-05T05:20:42.774117+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-05 05:20:40.013
b6dd8f64-e407-4892-8309-cbcd3ac8be96	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_starting	{"ts": "2026-05-05T05:20:43.081190+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-05 05:20:40.015
d97eaeca-9a0a-4e28-b769-2b255acb59ca	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_waiting_desktop	{"ts": "2026-05-05T05:20:43.081204+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-05 05:20:40.017
bc0bd6be-2018-42c4-a453-a9d14bc0e809	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_waiting_desktop	{"ts": "2026-05-05T05:21:01.260217+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-05 05:20:58.24
250f4461-28d3-490c-868c-58a40daf3d3e	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_waiting_desktop	{"ts": "2026-05-05T05:21:01.260231+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-05 05:20:58.242
7e8f495f-094b-4159-8e12-ea7e24c13267	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_health_checking	{"ts": "2026-05-05T05:21:01.260234+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-05 05:20:58.244
5164a9f8-e808-4577-b64c-c4dcbd75dc0c	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_health_checking	{"ts": "2026-05-05T05:21:03.267807+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-05 05:21:00.268
46e8f1fe-fba8-4201-b87f-5c9b77018c7f	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_ready	{"ts": "2026-05-05T05:21:03.267823+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-05 05:21:00.271
fb32b8b8-d7e2-45a0-8737-b34fec3cdf97	22354ffb-9b8e-4851-b4c2-66b44b328eb3	launch_ready	{"ts": "2026-05-05T05:21:03.267831+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-05 05:21:00.273
25894c96-526b-4fa3-a2b7-51d74d99afcd	22354ffb-9b8e-4851-b4c2-66b44b328eb3	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-05 05:21:00.287
b63d63d4-dba5-4e66-8814-71f504d6ef77	22354ffb-9b8e-4851-b4c2-66b44b328eb3	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 10500, "durationSeconds": 897, "terminationReason": "user_requested", "alreadyBilledCents": 21000, "remainingChargeCents": 0}	\N	2026-05-05 05:35:57.693
afb0da2c-2413-4734-a0f8-80ee42ab9266	49b75056-41c8-4ea7-8d06-7292d3a1bff9	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 15500, "durationSeconds": 1520, "terminationReason": "user_requested", "alreadyBilledCents": 31000, "remainingChargeCents": 0}	\N	2026-05-05 05:43:53.166
5bfface5-dbc0-4d53-8e19-b00a6b913e53	7695af26-9ec9-400c-8836-1415bdc28bce	session_created	{"configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "instanceName": "gpu-instance-69ny", "interfaceMode": "gui"}	\N	2026-05-05 05:45:11.875
8d84b497-5c88-4532-a2ec-f75a01684186	7695af26-9ec9-400c-8836-1415bdc28bce	launch_initiated	{"launchId": "d5b90a67-47ee-442b-b336-882110b50310", "containerName": "laas-7695af26"}	\N	2026-05-05 05:45:11.93
8dc3fa1a-fadd-48f4-86a0-040a33544be1	7695af26-9ec9-400c-8836-1415bdc28bce	launch_scheduling	{"ts": "2026-05-05T05:45:15.592149+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 05:45:13.964
2649018f-ff7d-4bc4-8b9a-daafe4984a06	7695af26-9ec9-400c-8836-1415bdc28bce	launch_scheduling	{"ts": "2026-05-05T05:45:15.692582+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 05:45:13.967
0ca397eb-4e3f-4ce6-b279-acdc73c61ae3	7695af26-9ec9-400c-8836-1415bdc28bce	launch_allocating_ports	{"ts": "2026-05-05T05:45:15.692691+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 05:45:13.968
df51fc09-004b-400f-b3fd-211a864b493b	7695af26-9ec9-400c-8836-1415bdc28bce	launch_allocating_ports	{"ts": "2026-05-05T05:45:15.767645+00:00", "status": "completed", "message": "Allocated ports: nginx=8102, selkies=9102, metrics=19102, display=:21"}	\N	2026-05-05 05:45:13.97
d3b50be0-76aa-4c55-bbc8-6fec4518265f	7695af26-9ec9-400c-8836-1415bdc28bce	launch_allocating_cpus	{"ts": "2026-05-05T05:45:15.767652+00:00", "status": "in_progress", "message": "Finding 8 contiguous CPU cores..."}	\N	2026-05-05 05:45:13.971
10755949-1d95-4c5f-985c-797d70b5681e	7695af26-9ec9-400c-8836-1415bdc28bce	launch_allocating_cpus	{"ts": "2026-05-05T05:45:15.803188+00:00", "status": "failed", "message": "No contiguous block of 8 cores available"}	\N	2026-05-05 05:45:13.973
11a25608-444a-49ed-925a-1c0b9ba4f867	7695af26-9ec9-400c-8836-1415bdc28bce	launch_failed	{"reason": "No contiguous block of 8 cores available"}	\N	2026-05-05 05:45:13.993
b991d41e-bc54-4d45-983b-cffdda05b8eb	4e21897d-ac74-4a45-9998-ef2db1c96b68	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "stateful", "instanceName": "gpu-instance-sfdd", "interfaceMode": "gui"}	\N	2026-05-05 05:59:40.325
bef92525-04f6-4fbd-a63b-91b0ad60e096	4e21897d-ac74-4a45-9998-ef2db1c96b68	launch_initiated	{"launchId": "3f7712aa-a3df-4969-802e-6428c2cb33ce", "containerName": "laas-4e21897d"}	\N	2026-05-05 05:59:40.4
ffc2f53b-bd2d-4c7d-b745-8212f52b67ec	4e21897d-ac74-4a45-9998-ef2db1c96b68	launch_scheduling	{"ts": "2026-05-05T05:59:44.062325+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 05:59:42.423
d9d72902-88cb-44bf-b34e-7560328b5c2f	4e21897d-ac74-4a45-9998-ef2db1c96b68	launch_scheduling	{"ts": "2026-05-05T05:59:44.162753+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 05:59:42.426
021e3b93-30d9-4158-9ea8-7a7075e798cf	4e21897d-ac74-4a45-9998-ef2db1c96b68	launch_allocating_ports	{"ts": "2026-05-05T05:59:44.162870+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 05:59:42.429
1b47b3c9-b56d-45a5-ba5f-057bdaf07661	4e21897d-ac74-4a45-9998-ef2db1c96b68	launch_allocating_ports	{"ts": "2026-05-05T05:59:44.184682+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 05:59:42.433
05da65da-db95-4cc8-867b-c8060b9242f4	4e21897d-ac74-4a45-9998-ef2db1c96b68	launch_allocating_cpus	{"ts": "2026-05-05T05:59:44.184689+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-05 05:59:42.436
2b281b5a-fbdf-4c48-9bb1-1a0e93f7b57c	4e21897d-ac74-4a45-9998-ef2db1c96b68	launch_allocating_cpus	{"ts": "2026-05-05T05:59:44.193905+00:00", "status": "completed", "message": "Allocated CPU cores: 2-3"}	\N	2026-05-05 05:59:42.439
e05eee1a-a110-4c6b-a557-6358aa4a741e	4e21897d-ac74-4a45-9998-ef2db1c96b68	launch_validating_mount	{"ts": "2026-05-05T05:59:44.193917+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_66dda4c5b14682acbb7239b9..."}	\N	2026-05-05 05:59:42.441
7887a4ab-4290-4337-8730-59898038b39a	4e21897d-ac74-4a45-9998-ef2db1c96b68	launch_nvme_preparing	{"ts": "2026-05-05T05:59:44.194001+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 100.88.57.107..."}	\N	2026-05-05 05:59:42.443
02175dd8-b5a7-4e49-9283-30dd38223695	4e21897d-ac74-4a45-9998-ef2db1c96b68	launch_nvme_discovering	{"ts": "2026-05-05T05:59:44.465711+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-05 05:59:42.445
77446f14-50e8-458b-9295-5e0a699f5439	4e21897d-ac74-4a45-9998-ef2db1c96b68	launch_nvme_discovering	{"ts": "2026-05-05T05:59:44.497688+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-05 05:59:42.447
bb1abdfb-ec50-44f4-90ff-fec9a4739b62	4e21897d-ac74-4a45-9998-ef2db1c96b68	launch_nvme_connecting	{"ts": "2026-05-05T05:59:44.497733+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_66dda4c5b14682acbb7239b9..."}	\N	2026-05-05 05:59:42.449
d9b1c28c-c208-43c1-b8a4-11ddf45fb365	4e21897d-ac74-4a45-9998-ef2db1c96b68	launch_validating_mount	{"ts": "2026-05-05T05:59:59.537136+00:00", "status": "failed", "message": "NVMe-oF setup unexpected error: Command '['sudo', 'nvme', 'connect', '-t', 'tcp', '-n', 'laas-u_66dda4c5b14682acbb7239b9', '-a', '10.10.100.99', '-s', '4420']' timed out after 15 seconds"}	\N	2026-05-05 05:59:56.622
5574b416-3439-47f3-acf9-65796d784f38	4e21897d-ac74-4a45-9998-ef2db1c96b68	launch_failed	{"reason": "NVMe-oF setup unexpected error: Command '['sudo', 'nvme', 'connect', '-t', 'tcp', '-n', 'laas-u_66dda4c5b14682acbb7239b9', '-a', '10.10.100.99', '-s', '4420']' timed out after 15 seconds"}	\N	2026-05-05 05:59:56.64
7aebf4b1-4442-4386-b514-38b93dbfa658	265f90b2-01bf-4c25-ab9d-925034e9634e	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "stateful", "instanceName": "gpu-instance-nyka", "interfaceMode": "gui"}	\N	2026-05-05 06:02:00.174
21ce93f5-4380-47c2-86b0-1e8809910eaf	265f90b2-01bf-4c25-ab9d-925034e9634e	launch_initiated	{"launchId": "e4293e93-401f-4b32-a90d-b94df68d0292", "containerName": "laas-265f90b2"}	\N	2026-05-05 06:02:00.224
22c8a82a-aae5-49a5-934a-59d82f2031d0	265f90b2-01bf-4c25-ab9d-925034e9634e	launch_scheduling	{"ts": "2026-05-05T06:02:03.895284+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 06:02:02.246
690cacb6-0a7a-4a00-b96f-a47cde2205a4	265f90b2-01bf-4c25-ab9d-925034e9634e	launch_scheduling	{"ts": "2026-05-05T06:02:03.995700+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 06:02:02.248
4e1347cc-61b2-4d13-a0be-b701fe648a7c	265f90b2-01bf-4c25-ab9d-925034e9634e	launch_allocating_ports	{"ts": "2026-05-05T06:02:03.995812+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 06:02:02.25
6437051f-f839-4e56-a24b-c523e87d5a4f	265f90b2-01bf-4c25-ab9d-925034e9634e	launch_allocating_ports	{"ts": "2026-05-05T06:02:04.020178+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 06:02:02.252
060d5203-44f7-45aa-bd97-ce7d85f64580	265f90b2-01bf-4c25-ab9d-925034e9634e	launch_allocating_cpus	{"ts": "2026-05-05T06:02:04.020184+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-05 06:02:02.254
a77f3b77-4bf5-443e-9d45-0401db6e6036	265f90b2-01bf-4c25-ab9d-925034e9634e	launch_allocating_cpus	{"ts": "2026-05-05T06:02:04.030010+00:00", "status": "completed", "message": "Allocated CPU cores: 2-3"}	\N	2026-05-05 06:02:02.255
b62eb9c9-efe7-4860-a272-751c4dbc57f4	265f90b2-01bf-4c25-ab9d-925034e9634e	launch_validating_mount	{"ts": "2026-05-05T06:02:04.030022+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_ec2de1aa873a3894dcf5c1ad..."}	\N	2026-05-05 06:02:02.257
295f20e5-46c4-40f5-bc70-ce1ca06e804b	265f90b2-01bf-4c25-ab9d-925034e9634e	launch_nvme_preparing	{"ts": "2026-05-05T06:02:04.030093+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 100.88.57.107..."}	\N	2026-05-05 06:02:02.258
102ab399-e238-4788-85e7-308dec0d966e	265f90b2-01bf-4c25-ab9d-925034e9634e	launch_nvme_discovering	{"ts": "2026-05-05T06:02:04.236672+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-05 06:02:02.26
15b8e8a5-1260-4087-aed7-77412e43fb94	265f90b2-01bf-4c25-ab9d-925034e9634e	launch_validating_mount	{"ts": "2026-05-05T06:02:19.253292+00:00", "status": "failed", "message": "NVMe-oF setup unexpected error: Command '['sudo', 'nvme', 'discover', '-t', 'tcp', '-a', '10.10.100.99', '-s', '4420']' timed out after 15 seconds"}	\N	2026-05-05 06:02:16.488
cee1f05b-8c14-4f26-b083-549560f0c179	265f90b2-01bf-4c25-ab9d-925034e9634e	launch_failed	{"reason": "NVMe-oF setup unexpected error: Command '['sudo', 'nvme', 'discover', '-t', 'tcp', '-a', '10.10.100.99', '-s', '4420']' timed out after 15 seconds"}	\N	2026-05-05 06:02:16.506
e170cdf6-d957-4873-bc98-15ee2c84fee5	748e1240-b6ff-40ea-8fe6-35093a4088a9	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "instanceName": "gpu-instance-07qg", "interfaceMode": "gui"}	\N	2026-05-05 06:14:40.09
2ecbb85d-3499-43f7-81f6-952778fb786f	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_initiated	{"launchId": "dce996d2-cc02-4985-9a11-f2abdf66e0b3", "containerName": "laas-748e1240"}	\N	2026-05-05 06:14:40.137
fc91eecd-a8f2-4820-a994-298feca7edb5	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_scheduling	{"ts": "2026-05-05T06:14:43.815760+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 06:14:42.168
dfa8e98e-c2dd-4281-8ec6-f87e7837fa63	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_scheduling	{"ts": "2026-05-05T06:14:43.916170+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 06:14:42.17
ddfe33fe-3a31-4a04-8d4a-75707a22dc6d	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_allocating_ports	{"ts": "2026-05-05T06:14:43.916295+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 06:14:42.171
12534561-11a5-4b66-8d67-af02a2fc94ed	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_allocating_ports	{"ts": "2026-05-05T06:14:43.939335+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 06:14:42.173
b0590a4a-d3ce-4349-bc32-b8af193413da	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_allocating_cpus	{"ts": "2026-05-05T06:14:43.939345+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-05 06:14:42.175
444ba700-38ed-4998-83f2-f794c13a29cc	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_allocating_cpus	{"ts": "2026-05-05T06:14:43.949132+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-05 06:14:42.176
bf1b0611-bb24-4f29-8f19-47b9aa5f8d9a	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_allocating_storage	{"ts": "2026-05-05T06:14:43.949143+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-05 06:14:42.177
fda4fb06-eda9-4d46-8f8e-1404d8fad297	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_allocating_storage	{"ts": "2026-05-05T06:14:43.949147+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_748e1240-b6ff-40ea-8fe6-35093a4088a9..."}	\N	2026-05-05 06:14:42.179
db97ea04-b52a-4ad5-b496-a469c0252a78	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_allocating_storage	{"ts": "2026-05-05T06:14:44.662932+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_748e1240-b6ff-40ea-8fe6-35093a4088a9"}	\N	2026-05-05 06:14:42.18
5b1fa3e4-e233-4412-96f7-4190083e0b64	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_creating	{"ts": "2026-05-05T06:14:44.662987+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-05 06:14:42.182
7fd7b5a2-fee1-44f8-a0bc-e75666d1f66e	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_creating	{"ts": "2026-05-05T06:14:44.744206+00:00", "status": "completed", "message": "Container created: laas-748e1240"}	\N	2026-05-05 06:14:42.183
98b8b706-30e9-44f2-92a2-8128a64a98fc	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_starting	{"ts": "2026-05-05T06:14:44.744216+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-05 06:14:42.184
d81a7a5e-6514-4e2b-94fb-a31955ad6e94	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_starting	{"ts": "2026-05-05T06:14:45.062809+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-05 06:14:42.186
f8cd5f86-707c-4d04-85b0-8b50b8b49610	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_waiting_desktop	{"ts": "2026-05-05T06:14:45.062821+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-05 06:14:42.187
bae95731-0d1d-4db8-b7e6-aa850e201b5f	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_waiting_desktop	{"ts": "2026-05-05T06:15:05.258047+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-05 06:15:02.432
a93d726b-f9f9-43ab-836f-a3c6cc279e89	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_waiting_desktop	{"ts": "2026-05-05T06:15:05.258060+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-05 06:15:02.436
0e0068c6-30b4-44c6-acad-cf9a58573ed8	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_health_checking	{"ts": "2026-05-05T06:15:05.258063+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-05 06:15:02.438
cb3b9fce-e3b6-4388-b9aa-069470b9cb5f	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_health_checking	{"ts": "2026-05-05T06:15:07.266952+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-05 06:15:04.538
2267fc32-ef3e-435b-8f5c-53d9a0f96914	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_ready	{"ts": "2026-05-05T06:15:07.266973+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-05 06:15:04.541
04ffd8af-8d9c-45c4-a447-da9760731c07	748e1240-b6ff-40ea-8fe6-35093a4088a9	launch_ready	{"ts": "2026-05-05T06:15:07.266981+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-05 06:15:04.543
154e59b4-bfdc-406d-9aca-6bda5ac200ec	748e1240-b6ff-40ea-8fe6-35093a4088a9	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-05 06:15:04.555
0e3c3698-794e-4560-a480-5ef5b9e51a96	aee03291-4ca9-4613-a396-de0251fe57bf	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "stateful", "instanceName": "gpu-instance-ziuj", "interfaceMode": "gui"}	\N	2026-05-05 06:15:24.735
6d9c36e2-c952-4019-a8d1-4840f70efbd1	aee03291-4ca9-4613-a396-de0251fe57bf	launch_initiated	{"launchId": "2a3f353a-ed8e-47f3-96f1-42aadc4281fb", "containerName": "laas-aee03291"}	\N	2026-05-05 06:15:24.8
89a7ff0e-cccc-45a7-b033-bb8434fae16a	aee03291-4ca9-4613-a396-de0251fe57bf	launch_scheduling	{"ts": "2026-05-05T06:15:28.477610+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 06:15:26.824
d78e530d-e194-4cf4-b5f6-f8e66256f6d5	aee03291-4ca9-4613-a396-de0251fe57bf	launch_scheduling	{"ts": "2026-05-05T06:15:28.577802+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 06:15:26.826
5e59aa8c-cfaa-4348-91c4-86897e28a521	aee03291-4ca9-4613-a396-de0251fe57bf	launch_allocating_ports	{"ts": "2026-05-05T06:15:28.577922+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 06:15:26.827
1287681c-fe6a-499d-879f-ddeac547b187	aee03291-4ca9-4613-a396-de0251fe57bf	launch_allocating_ports	{"ts": "2026-05-05T06:15:28.601284+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 06:15:26.829
56ab2149-b3ac-4bd0-a431-399d54800095	aee03291-4ca9-4613-a396-de0251fe57bf	launch_allocating_cpus	{"ts": "2026-05-05T06:15:28.601291+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-05 06:15:26.831
1e0d5561-9297-4b1e-ac3d-7d90719e4950	aee03291-4ca9-4613-a396-de0251fe57bf	launch_allocating_cpus	{"ts": "2026-05-05T06:15:28.611850+00:00", "status": "completed", "message": "Allocated CPU cores: 2-3"}	\N	2026-05-05 06:15:26.832
a35114d3-cf73-45c2-8c5f-4562ba4574a5	aee03291-4ca9-4613-a396-de0251fe57bf	launch_validating_mount	{"ts": "2026-05-05T06:15:28.611871+00:00", "status": "in_progress", "message": "Verifying local ZFS zvol for u_ec2de1aa873a3894dcf5c1ad..."}	\N	2026-05-05 06:15:26.833
91da228f-a074-428b-bed9-7f2b4dc77054	aee03291-4ca9-4613-a396-de0251fe57bf	launch_validating_mount	{"ts": "2026-05-05T06:15:28.612060+00:00", "status": "completed", "message": "Local ZFS zvol verified: /datapool/users/u_ec2de1aa873a3894dcf5c1ad"}	\N	2026-05-05 06:15:26.835
c3573125-68d3-4cd7-933d-a0e3d373ab66	aee03291-4ca9-4613-a396-de0251fe57bf	launch_creating	{"ts": "2026-05-05T06:15:28.612108+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-05 06:15:26.836
c0d8f1ed-02d4-4e47-ae61-af0b4c1eb28b	aee03291-4ca9-4613-a396-de0251fe57bf	launch_creating	{"ts": "2026-05-05T06:15:28.695955+00:00", "status": "completed", "message": "Container created: laas-aee03291"}	\N	2026-05-05 06:15:26.837
6592cad4-e2d8-4d50-b804-60bd6dfef42c	aee03291-4ca9-4613-a396-de0251fe57bf	launch_starting	{"ts": "2026-05-05T06:15:28.695960+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-05 06:15:26.838
59e29b46-9875-4990-a965-e0be8622d7ce	aee03291-4ca9-4613-a396-de0251fe57bf	launch_starting	{"ts": "2026-05-05T06:15:29.013889+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-05 06:15:26.839
a4514e19-b27e-48c7-bc52-92765f6d71d7	aee03291-4ca9-4613-a396-de0251fe57bf	launch_waiting_desktop	{"ts": "2026-05-05T06:15:29.013901+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-05 06:15:26.84
e1174f81-8e14-4870-a4d3-1543665137c9	aee03291-4ca9-4613-a396-de0251fe57bf	launch_waiting_desktop	{"ts": "2026-05-05T06:15:41.136748+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-05 06:15:39.001
98c6e9a1-85a0-4946-b6a7-0231fd1dce2f	aee03291-4ca9-4613-a396-de0251fe57bf	launch_waiting_desktop	{"ts": "2026-05-05T06:15:41.136761+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-05 06:15:39.003
36945b2e-3e24-468f-bf59-7226c6708f95	aee03291-4ca9-4613-a396-de0251fe57bf	launch_health_checking	{"ts": "2026-05-05T06:15:41.136764+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-05 06:15:39.004
4ecca69f-35a7-450d-94f6-de5ddc49ceac	aee03291-4ca9-4613-a396-de0251fe57bf	launch_health_checking	{"ts": "2026-05-05T06:15:43.144626+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-05 06:15:41.029
7545a75c-acb7-4f72-9e00-0fcd55508ae5	aee03291-4ca9-4613-a396-de0251fe57bf	launch_ready	{"ts": "2026-05-05T06:15:43.144640+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-05 06:15:41.031
d2201aaf-5fea-402b-a29d-55c2986b0a08	aee03291-4ca9-4613-a396-de0251fe57bf	launch_ready	{"ts": "2026-05-05T06:15:43.144648+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-05 06:15:41.033
e495215e-5083-4ad7-aeba-f49aeb9d40e2	aee03291-4ca9-4613-a396-de0251fe57bf	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.88.57.107:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-05 06:15:41.043
e6ebcc6e-cf0a-48b0-8398-ce9e3eac50e3	aee03291-4ca9-4613-a396-de0251fe57bf	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 3500, "durationSeconds": 762, "terminationReason": "user_requested", "alreadyBilledCents": 3500, "remainingChargeCents": 0}	\N	2026-05-05 06:28:23.262
c924e9ea-106f-44a4-9a4a-4deb11422cd1	748e1240-b6ff-40ea-8fe6-35093a4088a9	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 15500, "durationSeconds": 808, "terminationReason": "user_requested", "alreadyBilledCents": 15500, "remainingChargeCents": 0}	\N	2026-05-05 06:28:32.684
4917bd0e-d0ab-45ba-921e-8a25535791c5	2d87be54-82ea-4d73-9128-262be3f3dddd	session_created	{"configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "instanceName": "gpu-instance-wwoh", "interfaceMode": "gui"}	\N	2026-05-05 06:28:59.784
1a6aacbb-076e-4e6f-95f0-11770540f88a	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_initiated	{"launchId": "18634d27-eb0c-4bb4-b958-c2ff5da6935a", "containerName": "laas-2d87be54"}	\N	2026-05-05 06:28:59.834
6f2e926f-4708-432d-aec7-05fc37101ce8	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_scheduling	{"ts": "2026-05-05T06:29:03.520783+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 06:29:01.861
cf716853-9d8d-489b-b5ea-897a507a2ccf	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_scheduling	{"ts": "2026-05-05T06:29:03.621360+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 06:29:01.863
7b9b0b66-6b2d-4000-a873-1980c61ff32f	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_allocating_ports	{"ts": "2026-05-05T06:29:03.621469+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 06:29:01.865
a2537c72-9903-46d4-a2a8-285e9c6c477a	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_allocating_ports	{"ts": "2026-05-05T06:29:03.644225+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 06:29:01.866
e404651a-7a06-407c-9ea5-5bb1e21a3051	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_allocating_cpus	{"ts": "2026-05-05T06:29:03.644232+00:00", "status": "in_progress", "message": "Finding 8 contiguous CPU cores..."}	\N	2026-05-05 06:29:01.868
3360ba1c-721b-4fe4-bafc-d1c12ab5bb9c	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_allocating_cpus	{"ts": "2026-05-05T06:29:03.653878+00:00", "status": "completed", "message": "Allocated CPU cores: 2-9"}	\N	2026-05-05 06:29:01.869
0653f392-9818-46e3-aced-f8cfa17873db	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_validating_mount	{"ts": "2026-05-05T06:29:03.653891+00:00", "status": "in_progress", "message": "Verifying local ZFS zvol for u_ec2de1aa873a3894dcf5c1ad..."}	\N	2026-05-05 06:29:01.871
1a820a69-78e7-470d-9cb0-b3ef5a65a25d	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_validating_mount	{"ts": "2026-05-05T06:29:03.654009+00:00", "status": "completed", "message": "Local ZFS zvol verified: /datapool/users/u_ec2de1aa873a3894dcf5c1ad"}	\N	2026-05-05 06:29:01.872
2be3d846-7fa6-443c-810c-a99543f71ba5	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_creating	{"ts": "2026-05-05T06:29:03.654048+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-05 06:29:01.873
d7076336-eaa1-4468-8715-91762b356bf1	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_creating	{"ts": "2026-05-05T06:29:03.746509+00:00", "status": "completed", "message": "Container created: laas-2d87be54"}	\N	2026-05-05 06:29:01.874
590425ab-1571-4b5f-8e82-91fc232a03b6	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_starting	{"ts": "2026-05-05T06:29:03.746517+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-05 06:29:01.875
16f5c315-2fe8-4e72-a93e-137a96e411a4	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_starting	{"ts": "2026-05-05T06:29:04.069098+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-05 06:29:01.877
cd577842-60f9-414f-bd21-5d580f104156	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_waiting_desktop	{"ts": "2026-05-05T06:29:04.069110+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-05 06:29:01.878
164c85f5-c118-493f-9e99-fbce587fd598	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_waiting_desktop	{"ts": "2026-05-05T06:29:20.230905+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-05 06:29:18.085
87209f39-fd30-44ba-9c19-174ad58954cd	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_waiting_desktop	{"ts": "2026-05-05T06:29:20.230916+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-05 06:29:18.087
15c9b966-7747-4413-99bd-e7a9730ee207	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_health_checking	{"ts": "2026-05-05T06:29:20.230919+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-05 06:29:18.089
d9d7c162-cfdf-4c96-b2b0-8aec3b5e4377	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_health_checking	{"ts": "2026-05-05T06:29:22.239167+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-05 06:29:20.112
f3979305-1647-4cce-b488-80946aa42713	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_ready	{"ts": "2026-05-05T06:29:22.239184+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-05 06:29:20.114
e1773e99-a361-423c-b5ec-3f96a7f69d29	2d87be54-82ea-4d73-9128-262be3f3dddd	launch_ready	{"ts": "2026-05-05T06:29:22.239197+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-05 06:29:20.115
1a5627d7-72a9-4755-aef8-cd032f8f4fd5	2d87be54-82ea-4d73-9128-262be3f3dddd	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.88.57.107:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-05 06:29:20.121
443cf8f4-b577-4708-843d-aaaec11ca60b	2d87be54-82ea-4d73-9128-262be3f3dddd	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 10500, "durationSeconds": 752, "terminationReason": "user_requested", "alreadyBilledCents": 21000, "remainingChargeCents": 0}	\N	2026-05-05 06:41:52.81
2aa44faf-667e-4e95-86d5-f605bdf2b55f	3bafc61f-6305-41e4-bff1-92c190cb7cb3	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-9ldd", "interfaceMode": "gui"}	\N	2026-05-05 06:42:20.052
355104ab-6cbd-4aa7-8e35-f499b756ac30	3bafc61f-6305-41e4-bff1-92c190cb7cb3	launch_initiated	{"launchId": "386a3064-a88f-47c9-a76b-0ab33bc49378", "containerName": "laas-3bafc61f"}	\N	2026-05-05 06:42:20.112
5342587f-324d-4570-9950-c319527dec51	3bafc61f-6305-41e4-bff1-92c190cb7cb3	launch_scheduling	{"ts": "2026-05-05T06:42:23.803939+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 06:42:22.152
9bb35363-a177-406d-9e3d-813767f21140	3bafc61f-6305-41e4-bff1-92c190cb7cb3	launch_scheduling	{"ts": "2026-05-05T06:42:23.904347+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 06:42:22.155
7e1f670d-063b-4fe6-b852-3afcf090b751	3bafc61f-6305-41e4-bff1-92c190cb7cb3	launch_allocating_ports	{"ts": "2026-05-05T06:42:23.904458+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 06:42:22.157
57222e1c-2d92-48bd-9a06-02e4aeb43b0b	3bafc61f-6305-41e4-bff1-92c190cb7cb3	launch_allocating_ports	{"ts": "2026-05-05T06:42:23.928495+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 06:42:22.159
b1ca7971-3cd0-4953-a7f3-20a1065cb2c2	3bafc61f-6305-41e4-bff1-92c190cb7cb3	launch_allocating_cpus	{"ts": "2026-05-05T06:42:23.928500+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-05 06:42:22.161
86eb9ca4-bfbf-45b8-a7bb-5ebc6bc4b7fe	3bafc61f-6305-41e4-bff1-92c190cb7cb3	launch_allocating_cpus	{"ts": "2026-05-05T06:42:23.937428+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-05 06:42:22.162
f9c0609c-b312-4a8f-9c43-6bc583829dc9	3bafc61f-6305-41e4-bff1-92c190cb7cb3	launch_validating_mount	{"ts": "2026-05-05T06:42:23.937440+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_ec2de1aa873a3894dcf5c1ad..."}	\N	2026-05-05 06:42:22.164
7e136547-44e3-4251-9187-91b9f7948ae4	3bafc61f-6305-41e4-bff1-92c190cb7cb3	launch_nvme_preparing	{"ts": "2026-05-05T06:42:23.937511+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 100.88.57.107..."}	\N	2026-05-05 06:42:22.165
9faae6d5-27f4-4b21-9470-7d997512f872	3bafc61f-6305-41e4-bff1-92c190cb7cb3	launch_nvme_discovering	{"ts": "2026-05-05T06:42:24.314439+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 100.88.57.107..."}	\N	2026-05-05 06:42:22.167
c6fb4f23-2bf6-4501-92db-443883d7f14f	3bafc61f-6305-41e4-bff1-92c190cb7cb3	launch_validating_mount	{"ts": "2026-05-05T06:42:39.331049+00:00", "status": "failed", "message": "NVMe-oF setup unexpected error: Command '['sudo', 'nvme', 'discover', '-t', 'tcp', '-a', '100.88.57.107', '-s', '4420']' timed out after 15 seconds"}	\N	2026-05-05 06:42:36.358
21218fab-e4fb-461a-97d5-558df4148b07	3bafc61f-6305-41e4-bff1-92c190cb7cb3	launch_failed	{"reason": "NVMe-oF setup unexpected error: Command '['sudo', 'nvme', 'discover', '-t', 'tcp', '-a', '100.88.57.107', '-s', '4420']' timed out after 15 seconds"}	\N	2026-05-05 06:42:36.373
1c34ed3f-493a-4391-b1ce-930feb15811a	e5c99fe9-54ef-4267-8f73-ea3a603e0488	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-5ng6", "interfaceMode": "gui"}	\N	2026-05-05 07:19:00.431
22671b67-074d-4fb9-9a39-d4c07c1c2afa	e5c99fe9-54ef-4267-8f73-ea3a603e0488	launch_initiated	{"launchId": "62de529e-ade5-4925-95a4-99c79929a87d", "containerName": "laas-e5c99fe9"}	\N	2026-05-05 07:19:00.49
38e3dddf-bdfb-468d-978a-59c713c44f6e	e5c99fe9-54ef-4267-8f73-ea3a603e0488	launch_scheduling	{"ts": "2026-05-05T07:19:04.204327+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 07:19:02.533
3030aa7e-eac8-4284-bd40-18c5bfe6d35e	e5c99fe9-54ef-4267-8f73-ea3a603e0488	launch_scheduling	{"ts": "2026-05-05T07:19:04.304558+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 07:19:02.535
7b2f8881-d2a8-4b75-a0d3-e7588d0ccd26	e5c99fe9-54ef-4267-8f73-ea3a603e0488	launch_allocating_ports	{"ts": "2026-05-05T07:19:04.304669+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 07:19:02.537
d58f7342-02b1-414c-9992-0fedd7c1a12b	e5c99fe9-54ef-4267-8f73-ea3a603e0488	launch_allocating_ports	{"ts": "2026-05-05T07:19:04.328482+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 07:19:02.538
5ea2a5bd-3850-4486-a66f-5dcc2f026d0e	e5c99fe9-54ef-4267-8f73-ea3a603e0488	launch_allocating_cpus	{"ts": "2026-05-05T07:19:04.328487+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-05 07:19:02.539
03624513-7c23-4763-849c-47cf8b09dab7	e5c99fe9-54ef-4267-8f73-ea3a603e0488	launch_allocating_cpus	{"ts": "2026-05-05T07:19:04.338065+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-05 07:19:02.541
1a5ace92-75fd-491f-b246-77858130c615	e5c99fe9-54ef-4267-8f73-ea3a603e0488	launch_validating_mount	{"ts": "2026-05-05T07:19:04.338085+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_ec2de1aa873a3894dcf5c1ad..."}	\N	2026-05-05 07:19:02.543
86f020ba-5b1c-41f3-a1d6-f73e4e64ae3a	e5c99fe9-54ef-4267-8f73-ea3a603e0488	launch_nvme_preparing	{"ts": "2026-05-05T07:19:04.338183+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 10.10.100.99..."}	\N	2026-05-05 07:19:02.544
b91c3bbf-1d2d-479c-8222-cfdb6455eeea	e5c99fe9-54ef-4267-8f73-ea3a603e0488	launch_nvme_discovering	{"ts": "2026-05-05T07:19:04.631163+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-05 07:19:02.545
06492a04-972b-4b81-884b-8f247ec1d98d	e5c99fe9-54ef-4267-8f73-ea3a603e0488	launch_validating_mount	{"ts": "2026-05-05T07:19:19.647689+00:00", "status": "failed", "message": "NVMe-oF setup unexpected error: Command '['sudo', 'nvme', 'discover', '-t', 'tcp', '-a', '10.10.100.99', '-s', '4420']' timed out after 15 seconds"}	\N	2026-05-05 07:19:16.744
32fdf9a7-5d85-45e5-aa7a-3e25ab243abb	e5c99fe9-54ef-4267-8f73-ea3a603e0488	launch_failed	{"reason": "NVMe-oF setup unexpected error: Command '['sudo', 'nvme', 'discover', '-t', 'tcp', '-a', '10.10.100.99', '-s', '4420']' timed out after 15 seconds"}	\N	2026-05-05 07:19:16.764
023d654a-c4d5-426b-9a21-df7f5c9f974b	a5fb62a4-83e4-4d39-9bc2-9c6d4035c8ef	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-ey2e", "interfaceMode": "gui"}	\N	2026-05-05 07:34:10.434
9da49b4e-c1dc-420a-bf89-1d9e54887fcd	40c571d1-2a7d-4700-b8b2-ee7d7c501401	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-ey2e", "interfaceMode": "gui"}	\N	2026-05-05 07:35:32.662
43acc720-ae76-49eb-a8a1-7a9a75b5903b	40c571d1-2a7d-4700-b8b2-ee7d7c501401	launch_initiated	{"launchId": "89b16b55-6e67-457f-b822-fd77449d3387", "containerName": "laas-40c571d1"}	\N	2026-05-05 07:35:32.717
260ef4f0-b060-4373-a530-e3224c13ca7a	40c571d1-2a7d-4700-b8b2-ee7d7c501401	launch_scheduling	{"ts": "2026-05-05T07:35:36.442350+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 07:35:34.74
60cf0260-ce6a-41d0-a440-dea61fc295cb	40c571d1-2a7d-4700-b8b2-ee7d7c501401	launch_scheduling	{"ts": "2026-05-05T07:35:36.542546+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 07:35:34.743
6af5781d-07fa-4549-9e80-825dfebdb5df	40c571d1-2a7d-4700-b8b2-ee7d7c501401	launch_allocating_ports	{"ts": "2026-05-05T07:35:36.542662+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 07:35:34.745
754525be-f763-4a32-9d95-5cbcd6b3c25e	40c571d1-2a7d-4700-b8b2-ee7d7c501401	launch_allocating_ports	{"ts": "2026-05-05T07:35:36.564314+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 07:35:34.747
63349b65-1333-4747-85dd-824ffe1013a8	40c571d1-2a7d-4700-b8b2-ee7d7c501401	launch_allocating_cpus	{"ts": "2026-05-05T07:35:36.564320+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-05 07:35:34.749
875732b8-0122-4d2f-9cad-4f66a643e758	40c571d1-2a7d-4700-b8b2-ee7d7c501401	launch_allocating_cpus	{"ts": "2026-05-05T07:35:36.573478+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-05 07:35:34.751
03c42c61-8d7a-4ad5-a3e7-df7104a10071	40c571d1-2a7d-4700-b8b2-ee7d7c501401	launch_validating_mount	{"ts": "2026-05-05T07:35:36.573490+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_ec2de1aa873a3894dcf5c1ad..."}	\N	2026-05-05 07:35:34.754
b0cf1d6b-7a8f-44b2-9f4c-2626f6f544ce	40c571d1-2a7d-4700-b8b2-ee7d7c501401	launch_nvme_preparing	{"ts": "2026-05-05T07:35:36.573575+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 10.10.100.99..."}	\N	2026-05-05 07:35:34.757
296c49a7-3e11-4362-9acf-a911dbb91aa2	40c571d1-2a7d-4700-b8b2-ee7d7c501401	launch_nvme_discovering	{"ts": "2026-05-05T07:35:36.847565+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-05 07:35:34.759
e22afa45-5be3-4b6a-aca3-8197e63736b2	40c571d1-2a7d-4700-b8b2-ee7d7c501401	launch_validating_mount	{"ts": "2026-05-05T07:35:51.864195+00:00", "status": "failed", "message": "NVMe-oF setup unexpected error: Command '['sudo', 'nvme', 'discover', '-t', 'tcp', '-a', '10.10.100.99', '-s', '4420']' timed out after 15 seconds"}	\N	2026-05-05 07:35:48.922
7db1f932-af25-4d4f-9cc3-984b36022116	40c571d1-2a7d-4700-b8b2-ee7d7c501401	launch_failed	{"reason": "NVMe-oF setup unexpected error: Command '['sudo', 'nvme', 'discover', '-t', 'tcp', '-a', '10.10.100.99', '-s', '4420']' timed out after 15 seconds"}	\N	2026-05-05 07:35:48.941
fb3a09e0-4c31-4944-877e-dc95307411e0	5d8a4603-2a56-4e10-9884-d38da2423450	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-xriq", "interfaceMode": "gui"}	\N	2026-05-05 08:36:39.566
b3a950e1-6350-49ec-a60a-94ffc630f290	a3673281-5fd2-4636-b0d9-58f475e0f82b	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-xriq", "interfaceMode": "gui"}	\N	2026-05-05 08:40:57.69
2b6dbffe-bda9-4dc0-bcd1-6966d07e8393	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_initiated	{"launchId": "2f74f24a-1152-4b6a-b1c1-a25185f63d31", "containerName": "laas-a3673281"}	\N	2026-05-05 08:40:57.771
34d99334-ad6b-4cd9-a5a9-ad0f8ee8687b	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_scheduling	{"ts": "2026-05-05T08:41:01.509884+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 08:40:59.812
01bcbc52-519c-4bcd-8247-ddd7d06adb7b	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_scheduling	{"ts": "2026-05-05T08:41:01.610472+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 08:40:59.814
a21b45c1-082f-460c-a72c-7d3277f99238	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_allocating_ports	{"ts": "2026-05-05T08:41:01.610593+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 08:40:59.816
63ed57d8-4819-4e63-ac0b-2259cc8b1ff7	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_allocating_ports	{"ts": "2026-05-05T08:41:01.631628+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 08:40:59.817
8f5d1263-e12f-4929-a332-961a5a8b3392	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_allocating_cpus	{"ts": "2026-05-05T08:41:01.631639+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-05 08:40:59.818
4f4f0dff-b14d-461d-acd1-d2dbd504b697	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_allocating_cpus	{"ts": "2026-05-05T08:41:01.640842+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-05 08:40:59.82
18efb019-2969-4d99-84a0-2d42ea7d661f	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_validating_mount	{"ts": "2026-05-05T08:41:01.640862+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_ec2de1aa873a3894dcf5c1ad..."}	\N	2026-05-05 08:40:59.821
85c6202b-0ed2-476a-8d1d-d798788f95a8	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_nvme_preparing	{"ts": "2026-05-05T08:41:01.640972+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 10.10.100.99..."}	\N	2026-05-05 08:40:59.822
c61406b8-25ad-4ecc-9b60-48d1f059a8d3	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_nvme_discovering	{"ts": "2026-05-05T08:41:01.938375+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-05 08:40:59.823
5fc4a557-3ce0-49fd-b57e-e17805c461a9	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_nvme_discovering	{"ts": "2026-05-05T08:41:01.964236+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-05 08:40:59.825
a6caf3f0-05f6-466c-9785-f70a0dcf7fbb	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_nvme_connecting	{"ts": "2026-05-05T08:41:01.964313+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_ec2de1aa873a3894dcf5c1ad..."}	\N	2026-05-05 08:40:59.826
f513d35d-08ee-4a9d-8449-9de64d8f638d	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_nvme_connecting	{"ts": "2026-05-05T08:41:02.000345+00:00", "status": "completed", "message": "NVMe-oF connected"}	\N	2026-05-05 08:40:59.828
7d316a99-5e12-4cc6-99e2-1d7520daf618	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_nvme_finding_device	{"ts": "2026-05-05T08:41:02.000377+00:00", "status": "in_progress", "message": "Locating NVMe block device..."}	\N	2026-05-05 08:40:59.829
9df6eb4e-5a66-4cfc-b53e-30e6c6331881	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_nvme_finding_device	{"ts": "2026-05-05T08:41:02.511709+00:00", "status": "completed", "message": "Block device found: /dev/nvme1n1"}	\N	2026-05-05 08:40:59.83
79cd5e31-e6f7-45fb-b5a3-c98b2c876406	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_nvme_mounting	{"ts": "2026-05-05T08:41:02.511818+00:00", "status": "in_progress", "message": "Mounting /dev/nvme1n1 to /mnt/nvme/u_ec2de1aa873a3894dcf5c1ad..."}	\N	2026-05-05 08:40:59.831
ae21374d-9baf-4b10-952d-851a50bf4735	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_nvme_mounting	{"ts": "2026-05-05T08:41:02.539781+00:00", "status": "completed", "message": "NVMe-oF volume mounted"}	\N	2026-05-05 08:40:59.832
85045e3e-1265-4695-bf63-22256ea88b4e	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_nvme_verifying	{"ts": "2026-05-05T08:41:02.539830+00:00", "status": "in_progress", "message": "Verifying storage permissions..."}	\N	2026-05-05 08:40:59.833
56ec8d77-1067-498b-92d8-1e89ee19ade3	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_nvme_verifying	{"ts": "2026-05-05T08:41:02.540357+00:00", "status": "completed", "message": "Permissions verified (UID 1000, read/write OK)"}	\N	2026-05-05 08:40:59.834
9af5eed2-1a99-40b2-a39d-eea4fff39952	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_validating_mount	{"ts": "2026-05-05T08:41:02.540410+00:00", "status": "completed", "message": "NVMe-oF storage ready at /mnt/nvme/u_ec2de1aa873a3894dcf5c1ad"}	\N	2026-05-05 08:40:59.835
4bf0077e-924c-4d31-907c-6d2bd1ea434a	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_creating	{"ts": "2026-05-05T08:41:02.540465+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-05 08:40:59.836
23673c6a-6e04-49cb-867b-8d0b0a0c6f21	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_creating	{"ts": "2026-05-05T08:41:02.628126+00:00", "status": "completed", "message": "Container created: laas-a3673281"}	\N	2026-05-05 08:40:59.838
89bbd944-5dd5-4c73-a135-92254565b38d	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_starting	{"ts": "2026-05-05T08:41:02.628137+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-05 08:40:59.839
3856fe43-ee9b-48fd-9dc2-e0a3587b6c01	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_starting	{"ts": "2026-05-05T08:41:03.538491+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-05 08:40:59.84
3f5541be-8a95-4b7a-ae8c-2d87ed8a0a26	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_waiting_desktop	{"ts": "2026-05-05T08:41:03.538509+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-05 08:40:59.841
9dc07f84-aeb0-4890-b7a3-b77bb50b8c1b	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_waiting_desktop	{"ts": "2026-05-05T08:41:21.726911+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-05 08:41:18.068
7a976e6e-d14e-4bdf-a016-b98ce8470340	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_waiting_desktop	{"ts": "2026-05-05T08:41:21.726923+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-05 08:41:18.071
ccccf07e-8001-4a07-b088-c44379d39245	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_health_checking	{"ts": "2026-05-05T08:41:21.726925+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-05 08:41:18.072
dddd9ef0-dc89-4cc1-92e5-f200b405cbdf	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_health_checking	{"ts": "2026-05-05T08:41:23.735004+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-05 08:41:20.102
0d1ed750-b62d-44ab-897a-f6a0e5482f91	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_ready	{"ts": "2026-05-05T08:41:23.735023+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-05 08:41:20.104
45ae9946-684e-462c-b50b-9c21056521a6	a3673281-5fd2-4636-b0d9-58f475e0f82b	launch_ready	{"ts": "2026-05-05T08:41:23.735034+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-05 08:41:20.106
5018868b-a11c-4742-8184-b0bacb76f98a	a3673281-5fd2-4636-b0d9-58f475e0f82b	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-05 08:41:20.115
52670771-4691-43f8-95f7-aa3c53399cc2	a3673281-5fd2-4636-b0d9-58f475e0f82b	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 15500, "durationSeconds": 2676, "terminationReason": "user_requested", "alreadyBilledCents": 15500, "remainingChargeCents": 0}	\N	2026-05-05 09:25:56.909
83c7bf82-6861-4279-8813-b193f68927f6	c676954a-51a2-44b7-b923-534534f320f7	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "stateful", "instanceName": "gpu-instance-okk0", "interfaceMode": "gui"}	\N	2026-05-05 10:08:53.265
6d0d9ffb-130e-46d8-84e1-7d946a3b9ae8	c676954a-51a2-44b7-b923-534534f320f7	launch_initiated	{"launchId": "a92e3737-2f63-42ee-bd39-9e3f0683bc3c", "containerName": "laas-c676954a"}	\N	2026-05-05 10:08:53.34
c2b7af2d-f8b6-48ec-9842-9f5bb994808f	c676954a-51a2-44b7-b923-534534f320f7	launch_scheduling	{"ts": "2026-05-05T10:08:57.127474+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 10:08:55.363
1d80395c-cf6d-4abd-94a2-5255fc6b7219	c676954a-51a2-44b7-b923-534534f320f7	launch_scheduling	{"ts": "2026-05-05T10:08:57.227658+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 10:08:55.367
3dbfdf50-8eff-4f19-aae5-a1b35c2c68a6	c676954a-51a2-44b7-b923-534534f320f7	launch_allocating_ports	{"ts": "2026-05-05T10:08:57.227784+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 10:08:55.37
2e2e1142-a414-48f0-bc69-50a8e2071bb0	c676954a-51a2-44b7-b923-534534f320f7	launch_allocating_ports	{"ts": "2026-05-05T10:08:57.251653+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 10:08:55.373
e9aa9853-8f38-4737-97a6-83df93eb41da	c676954a-51a2-44b7-b923-534534f320f7	launch_allocating_cpus	{"ts": "2026-05-05T10:08:57.251658+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-05 10:08:55.376
4492b4c5-2f1b-46bc-aa10-9b147f708860	c676954a-51a2-44b7-b923-534534f320f7	launch_allocating_cpus	{"ts": "2026-05-05T10:08:57.260945+00:00", "status": "completed", "message": "Allocated CPU cores: 2-3"}	\N	2026-05-05 10:08:55.379
707027b2-f60e-4f90-9474-fb2e718ad33a	c676954a-51a2-44b7-b923-534534f320f7	launch_validating_mount	{"ts": "2026-05-05T10:08:57.260957+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_ec2de1aa873a3894dcf5c1ad..."}	\N	2026-05-05 10:08:55.382
ccba7384-52a0-47f5-8e2e-946dbb91e096	c676954a-51a2-44b7-b923-534534f320f7	launch_nvme_preparing	{"ts": "2026-05-05T10:08:57.261028+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 10.10.100.99..."}	\N	2026-05-05 10:08:55.385
48cf62a7-53e1-4ad8-8dfb-368073d77f43	c676954a-51a2-44b7-b923-534534f320f7	launch_nvme_discovering	{"ts": "2026-05-05T10:08:57.576187+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-05 10:08:55.387
16718739-faa1-441d-9f3e-bd2b8b7cfa51	c676954a-51a2-44b7-b923-534534f320f7	launch_nvme_discovering	{"ts": "2026-05-05T10:08:57.596200+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-05 10:08:55.39
3927d014-fe88-426c-be9c-1aad4004688b	c676954a-51a2-44b7-b923-534534f320f7	launch_nvme_connecting	{"ts": "2026-05-05T10:08:57.596297+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_ec2de1aa873a3894dcf5c1ad..."}	\N	2026-05-05 10:08:55.393
bdaf9bae-169a-44e7-8e75-08d05dc91e6e	c676954a-51a2-44b7-b923-534534f320f7	launch_nvme_connecting	{"ts": "2026-05-05T10:08:57.631812+00:00", "status": "completed", "message": "NVMe-oF connected"}	\N	2026-05-05 10:08:55.395
b5fb88b7-1918-4325-a5df-398e65019d83	c676954a-51a2-44b7-b923-534534f320f7	launch_nvme_finding_device	{"ts": "2026-05-05T10:08:57.631875+00:00", "status": "in_progress", "message": "Locating NVMe block device..."}	\N	2026-05-05 10:08:55.398
5f6f8c0c-9038-4346-a562-786cdeb141cc	c676954a-51a2-44b7-b923-534534f320f7	launch_nvme_finding_device	{"ts": "2026-05-05T10:08:58.141490+00:00", "status": "completed", "message": "Block device found: /dev/nvme1n1"}	\N	2026-05-05 10:08:55.401
4737c377-f024-4222-a94a-83f5d5bf151c	c676954a-51a2-44b7-b923-534534f320f7	launch_nvme_mounting	{"ts": "2026-05-05T10:08:58.141592+00:00", "status": "in_progress", "message": "Mounting /dev/nvme1n1 to /mnt/nvme/u_ec2de1aa873a3894dcf5c1ad..."}	\N	2026-05-05 10:08:55.403
5793a272-38ca-44b1-a9bc-e3c7085c8b3b	c676954a-51a2-44b7-b923-534534f320f7	launch_nvme_mounting	{"ts": "2026-05-05T10:08:58.168847+00:00", "status": "completed", "message": "NVMe-oF volume mounted"}	\N	2026-05-05 10:08:55.405
27169874-d0c4-4f02-959c-d245dd258830	c676954a-51a2-44b7-b923-534534f320f7	launch_nvme_verifying	{"ts": "2026-05-05T10:08:58.168876+00:00", "status": "in_progress", "message": "Verifying storage permissions..."}	\N	2026-05-05 10:08:55.408
3d732041-349c-4304-a7b8-39cff204d258	c676954a-51a2-44b7-b923-534534f320f7	launch_nvme_verifying	{"ts": "2026-05-05T10:08:58.169235+00:00", "status": "completed", "message": "Permissions verified (UID 1000, read/write OK)"}	\N	2026-05-05 10:08:55.411
0f63bf36-cfb4-4e11-b6fb-922454b3740e	c676954a-51a2-44b7-b923-534534f320f7	launch_validating_mount	{"ts": "2026-05-05T10:08:58.169262+00:00", "status": "completed", "message": "NVMe-oF storage ready at /mnt/nvme/u_ec2de1aa873a3894dcf5c1ad"}	\N	2026-05-05 10:08:55.413
5c90d34f-05b8-4cf3-8eb9-24022d197f5a	c676954a-51a2-44b7-b923-534534f320f7	launch_creating	{"ts": "2026-05-05T10:08:58.169293+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-05 10:08:55.416
08413c1a-7e2b-448d-8c53-b2edda48913f	c676954a-51a2-44b7-b923-534534f320f7	launch_creating	{"ts": "2026-05-05T10:08:58.248464+00:00", "status": "completed", "message": "Container created: laas-c676954a"}	\N	2026-05-05 10:08:55.419
28412dbe-6783-4778-b621-e5a549360dbd	c676954a-51a2-44b7-b923-534534f320f7	launch_starting	{"ts": "2026-05-05T10:08:58.248473+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-05 10:08:55.421
f3a3c5b8-7bfc-45fc-9311-b82b32daa03b	c676954a-51a2-44b7-b923-534534f320f7	launch_starting	{"ts": "2026-05-05T10:08:58.591484+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-05 10:08:55.424
3f0be62f-8f5c-4962-ad13-263f034ab1d3	c676954a-51a2-44b7-b923-534534f320f7	launch_waiting_desktop	{"ts": "2026-05-05T10:08:58.591498+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-05 10:08:55.426
34b56441-3a5a-47fe-a711-da3ef434b832	c676954a-51a2-44b7-b923-534534f320f7	launch_waiting_desktop	{"ts": "2026-05-05T10:09:14.745880+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-05 10:09:11.751
e85e8f32-d738-469d-a077-2e3bcd9a7124	c676954a-51a2-44b7-b923-534534f320f7	launch_waiting_desktop	{"ts": "2026-05-05T10:09:14.745895+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-05 10:09:11.754
ec430486-3e89-4c04-b634-f26b576964bc	c676954a-51a2-44b7-b923-534534f320f7	launch_health_checking	{"ts": "2026-05-05T10:09:14.745899+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-05 10:09:11.757
214882a3-c441-4dd4-b221-2fdddc6d8de2	c676954a-51a2-44b7-b923-534534f320f7	launch_health_checking	{"ts": "2026-05-05T10:09:16.755048+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-05 10:09:13.784
73d9b41e-5bd5-4eab-86d8-0b5347433e27	c676954a-51a2-44b7-b923-534534f320f7	launch_ready	{"ts": "2026-05-05T10:09:16.755064+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-05 10:09:13.786
23f32805-9aa1-49b6-9e60-b7c721ad0f75	c676954a-51a2-44b7-b923-534534f320f7	launch_ready	{"ts": "2026-05-05T10:09:16.755071+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-05 10:09:13.788
9660ef8b-8a4b-418c-9dff-626d2fe35c0a	c676954a-51a2-44b7-b923-534534f320f7	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-05 10:09:13.799
a23fe992-158a-4206-96a7-64bed9f0dac1	c676954a-51a2-44b7-b923-534534f320f7	session_terminated	{"terminatedBy": "ae95fb83-2551-437f-8fac-dcd84b751a1d", "totalCostCents": 10500, "durationSeconds": 7241, "terminationReason": "user_requested", "alreadyBilledCents": 10500, "remainingChargeCents": 0}	\N	2026-05-05 12:09:55.324
0e6f2af9-a8c6-45f1-9919-2e442c72c253	ec3f0ced-027a-4e05-bc13-4eee83a759a0	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "stateful", "instanceName": "gpu-instance-zgxl", "interfaceMode": "gui"}	\N	2026-05-05 15:34:49.205
006bcb43-2504-4569-9007-efe401cd4f46	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_initiated	{"launchId": "6f48c2d0-4b2c-4ef1-ab52-6a08d21a1021", "containerName": "laas-ec3f0ced"}	\N	2026-05-05 15:34:49.281
bd1d6443-f413-44f4-8135-780a0c481660	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_scheduling	{"ts": "2026-05-05T15:34:49.255862+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-05 15:34:51.518
8ad8ee88-cce3-488c-8abe-957e5eba3271	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_scheduling	{"ts": "2026-05-05T15:34:49.356030+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-05 15:34:51.52
b18e2a68-9875-4b49-8df4-32949dca947b	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_allocating_ports	{"ts": "2026-05-05T15:34:49.356147+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-05 15:34:51.523
4ca33e80-d79f-4c9e-a82c-8a3940e11e87	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_allocating_ports	{"ts": "2026-05-05T15:34:49.375999+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-05 15:34:51.525
9eb86b42-318d-4a76-b2d1-ea709d88a7fe	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_allocating_cpus	{"ts": "2026-05-05T15:34:49.376004+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-05 15:34:51.527
6c066dda-a0cb-4f16-bc4e-378f2b82a24b	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_allocating_cpus	{"ts": "2026-05-05T15:34:49.385069+00:00", "status": "completed", "message": "Allocated CPU cores: 2-3"}	\N	2026-05-05 15:34:51.529
a2ecdfa1-5f9f-4ed7-b6aa-047dd2090c1e	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_validating_mount	{"ts": "2026-05-05T15:34:49.385081+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_ec2de1aa873a3894dcf5c1ad..."}	\N	2026-05-05 15:34:51.53
d1218b73-82c2-446f-b183-46b7c3b1a149	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_nvme_preparing	{"ts": "2026-05-05T15:34:49.385151+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 10.10.100.99..."}	\N	2026-05-05 15:34:51.532
ca624377-8658-4312-ba98-12eefb5cb0aa	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_nvme_discovering	{"ts": "2026-05-05T15:34:49.697937+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-05 15:34:51.534
aa6a7185-6047-4c5e-af2c-5f8695343dca	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_nvme_discovering	{"ts": "2026-05-05T15:34:49.720162+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-05 15:34:51.536
25c413f2-e7bd-4f0c-bdfe-b896e7f23b69	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_nvme_connecting	{"ts": "2026-05-05T15:34:49.720261+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_ec2de1aa873a3894dcf5c1ad..."}	\N	2026-05-05 15:34:51.538
64aaf260-c191-4373-ad4d-217f7ec56a4d	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_nvme_connecting	{"ts": "2026-05-05T15:34:49.757102+00:00", "status": "completed", "message": "NVMe-oF connected"}	\N	2026-05-05 15:34:51.539
e817a8af-b41f-4df8-bed0-f4acbc8f01bd	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_nvme_finding_device	{"ts": "2026-05-05T15:34:49.757144+00:00", "status": "in_progress", "message": "Locating NVMe block device..."}	\N	2026-05-05 15:34:51.541
bc54a990-21ba-4005-afe0-5c0da8e29ca8	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_nvme_finding_device	{"ts": "2026-05-05T15:34:50.267815+00:00", "status": "completed", "message": "Block device found: /dev/nvme1n1"}	\N	2026-05-05 15:34:51.543
5cb6212e-ffcd-4783-b839-377429b1ac09	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_nvme_mounting	{"ts": "2026-05-05T15:34:50.267929+00:00", "status": "in_progress", "message": "Mounting /dev/nvme1n1 to /mnt/nvme/u_ec2de1aa873a3894dcf5c1ad..."}	\N	2026-05-05 15:34:51.545
0be64fe0-c84e-44b9-9610-f893f4f240eb	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_nvme_mounting	{"ts": "2026-05-05T15:34:50.294586+00:00", "status": "completed", "message": "NVMe-oF volume mounted"}	\N	2026-05-05 15:34:51.546
9ccc7adc-f7b4-4d54-a802-2e69c280cc63	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_nvme_verifying	{"ts": "2026-05-05T15:34:50.294630+00:00", "status": "in_progress", "message": "Verifying storage permissions..."}	\N	2026-05-05 15:34:51.547
bdff3750-55a6-476d-847f-0af1b7861bde	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_nvme_verifying	{"ts": "2026-05-05T15:34:50.295083+00:00", "status": "completed", "message": "Permissions verified (UID 1000, read/write OK)"}	\N	2026-05-05 15:34:51.549
7cc52fc6-f087-42ad-8f65-b130b0c3840e	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_validating_mount	{"ts": "2026-05-05T15:34:50.295126+00:00", "status": "completed", "message": "NVMe-oF storage ready at /mnt/nvme/u_ec2de1aa873a3894dcf5c1ad"}	\N	2026-05-05 15:34:51.551
40fcd5b7-e9d1-410a-882c-4a93b4ef3856	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_creating	{"ts": "2026-05-05T15:34:50.295166+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-05 15:34:51.552
f4366c18-e0e4-45e7-8f3b-ffe1db5a62cd	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_creating	{"ts": "2026-05-05T15:34:50.376120+00:00", "status": "completed", "message": "Container created: laas-ec3f0ced"}	\N	2026-05-05 15:34:51.554
d6ae57ca-85a1-4cf6-9e08-1d716ef15161	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_starting	{"ts": "2026-05-05T15:34:50.376127+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-05 15:34:51.555
e04323bc-d8aa-4ce2-acd6-0f6e7d226c19	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_starting	{"ts": "2026-05-05T15:34:50.701048+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-05 15:34:51.557
7b8baa4f-89b8-42fc-a591-f05682abd114	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_waiting_desktop	{"ts": "2026-05-05T15:34:50.701062+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-05 15:34:51.558
e9583dd4-a96c-4a38-8a39-d0538a0c4110	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_waiting_desktop	{"ts": "2026-05-05T15:35:08.869542+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-05 15:35:10.953
c80e3a61-f511-4cd1-b0d8-4dd4d839c070	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_waiting_desktop	{"ts": "2026-05-05T15:35:08.869560+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-05 15:35:10.958
8dd41933-dafe-49c7-af9b-b6e821a300ed	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_health_checking	{"ts": "2026-05-05T15:35:08.869567+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-05 15:35:10.961
2355f3a6-0c22-43a1-bc62-5d09f9084f1e	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_health_checking	{"ts": "2026-05-05T15:35:10.878498+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-05 15:35:10.965
1bd50e78-900d-4259-bb35-03d6a9629904	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_ready	{"ts": "2026-05-05T15:35:10.878513+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-05 15:35:10.969
404780d5-3652-4e25-baaf-7f4c1035e1dd	ec3f0ced-027a-4e05-bc13-4eee83a759a0	launch_ready	{"ts": "2026-05-05T15:35:10.878523+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-05 15:35:10.973
98ee494e-217d-4906-bad8-b9bf7055dbe3	ec3f0ced-027a-4e05-bc13-4eee83a759a0	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-05 15:35:10.993
\.


--
-- TOC entry 6018 (class 0 OID 118655)
-- Dependencies: 246
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, user_id, organization_id, compute_config_id, booking_id, node_id, session_type, container_id, container_name, nginx_port, selkies_port, display_number, session_token_hash, session_url, status, started_at, ended_at, scheduled_end_at, last_activity_at, nfs_mount_path, base_image_id, actual_gpu_vram_mb, actual_hami_sm_percent, reconnect_count, last_reconnect_at, auto_preserve_files, avg_rtt_ms, avg_packet_loss_ratio, resource_snapshot, created_at, updated_at, created_by, updated_by, allocated_gpu_vram_mb, allocated_hami_sm_percent, allocated_memory_mb, allocated_vcpu, allocation_snapshot_at, cost_last_updated_at, cumulative_cost_cents, duration_seconds, instance_name, storage_mode, terminated_at, terminated_by, termination_details, termination_reason, storage_node_id, storage_transport, ephemeral_storage_path, ephemeral_storage_size_mb) FROM stdin;
e0688d0b-1645-4bae-a644-7a408007f2d8	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-e0688d0b	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-04 11:21:17.506	2026-05-04 11:22:48.51	\N	\N	/mnt/nfs/users/u_c1e2324f5a10e9f2dbb54508	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 33, "interfaceMode": "gui", "encryptedPassword": "e8ffe47604fdfe06829c625245ef3883", "encryptedPasswordIv": "8cc13c586fe52240c7e3861e", "encryptedPasswordTag": "5ededcf9136477b4ba196faf00774966", "basePricePerHourCents": 10500}	2026-05-04 11:20:55.095	2026-05-04 11:22:48.524	\N	\N	8192	33	16384	8	2026-05-04 11:20:55.094	2026-05-04 11:22:48.51	10500	91	gpu-instance-g7vq	stateful	2026-05-04 11:22:48.51	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	local_zfs	\N	\N
6c5b8d4d-2827-4e05-b551-bd397301b575	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	\N	\N	\N	\N	\N	\N	failed	\N	2026-05-04 08:25:08.448	\N	\N	/mnt/nfs/users/u_67351641e9df7b1f476b151e	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "basePricePerHourCents": 15500}	2026-05-04 08:25:08.395	2026-05-04 08:25:08.449	\N	\N	16384	67	32768	12	2026-05-04 08:25:08.393	\N	0	\N	gpu-instance-veus	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
f3345614-394f-49e8-99e1-30804f314627	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-f3345614	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-04 08:04:14.131	2026-05-04 08:27:01.172	\N	\N	/mnt/nfs/users/u_f7053a8b16cd55e38b838e79	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "833ee9fed1538dd0d01d466d7338c427", "encryptedPasswordIv": "4e54fd3910c8ebf32ba0d264", "encryptedPasswordTag": "e4b6605a65905a1464e0c358430cde27", "basePricePerHourCents": 15500}	2026-05-04 08:03:53.819	2026-05-04 08:27:01.189	\N	\N	16384	67	32768	12	2026-05-04 08:03:53.817	2026-05-04 08:27:01.172	15500	1367	gpu-instance-rz6t	stateful	2026-05-04 08:27:01.172	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	local_zfs	\N	\N
ae38510e-ab6b-408c-b1be-eac0988fbc93	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	\N	\N	\N	\N	\N	\N	failed	\N	2026-05-04 08:59:14.428	\N	\N	/mnt/nfs/users/u_c1e2324f5a10e9f2dbb54508	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "basePricePerHourCents": 15500}	2026-05-04 08:59:14.366	2026-05-04 08:59:14.431	\N	\N	16384	67	32768	12	2026-05-04 08:59:14.364	\N	0	\N	gpu-instance-3vy7	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
58582e3f-f8bd-4147-b9ed-38a510ceb745	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-58582e3f	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-04 09:01:53.98	2026-05-04 09:03:28.707	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "2171a848af4b3ab82172713a13fc7169", "encryptedPasswordIv": "bcab2a88b986d0c3376f9a18", "encryptedPasswordTag": "e8b6bfbd41633219ee3b0a8ae196683a", "basePricePerHourCents": 3500}	2026-05-04 09:01:29.582	2026-05-04 09:03:28.732	\N	\N	2048	8	4096	2	2026-05-04 09:01:29.577	2026-05-04 09:03:28.707	3500	94	gpu-instance-3vy7	ephemeral	2026-05-04 09:03:28.707	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	\N	\N	/datapool/ephemeral/sess_58582e3f-f8bd-4147-b9ed-38a510ceb745	10240
892af945-7115-46cb-885e-2f44d9988218	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-892af945	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-04 09:03:59.034	2026-05-04 09:16:20.633	\N	\N	/mnt/nfs/users/u_c1e2324f5a10e9f2dbb54508	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 33, "interfaceMode": "gui", "encryptedPassword": "acdfdafbf5859ad47cef9d9c9d83da51", "encryptedPasswordIv": "43ec4853f50a5868a4364808", "encryptedPasswordTag": "f77dcb133e46a32f46ac72191f43af5f", "basePricePerHourCents": 10500}	2026-05-04 09:03:40.738	2026-05-04 09:16:20.665	\N	\N	8192	33	16384	8	2026-05-04 09:03:40.737	2026-05-04 09:16:20.633	10500	741	gpu-instance-o2tr	stateful	2026-05-04 09:16:20.633	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	local_zfs	\N	\N
68dd70a4-c61f-4fb1-85a4-9939e4643493	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-68dd70a4	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-04 09:16:57.522	2026-05-04 09:27:57.704	\N	\N	/mnt/nfs/users/u_c1e2324f5a10e9f2dbb54508	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "a59e088439efbaacd8b694d55f816afb", "encryptedPasswordIv": "f7cd4aedaaa5e6cd292d3841", "encryptedPasswordTag": "ce261c5c4ee75450251abef6ebfb15ea", "basePricePerHourCents": 15500}	2026-05-04 09:16:35.138	2026-05-04 09:27:57.725	\N	\N	16384	67	32768	12	2026-05-04 09:16:35.137	2026-05-04 09:27:57.704	15500	660	gpu-instance-7155	stateful	2026-05-04 09:27:57.704	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	local_zfs	\N	\N
79446928-3d68-4633-ae84-6febe94609fc	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-79446928	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-04 09:19:54.657	2026-05-04 09:29:17.702	\N	\N	\N	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "597c87106325e5398a38ba200787a461", "encryptedPasswordIv": "85c024f970b287341260e281", "encryptedPasswordTag": "ad7211e113ecc2df2e9c877e8dce2362", "basePricePerHourCents": 15500}	2026-05-04 09:19:36.325	2026-05-04 09:29:17.718	\N	\N	16384	67	32768	12	2026-05-04 09:19:36.324	2026-05-04 09:29:17.702	15500	563	gpu-instance-nkd5	ephemeral	2026-05-04 09:29:17.702	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	\N	\N	/datapool/ephemeral/sess_79446928-3d68-4633-ae84-6febe94609fc	10240
2bf80869-f34a-44dd-88c6-9d70dcbe6522	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	\N	\N	\N	\N	\N	\N	failed	\N	2026-05-04 09:33:16.915	\N	\N	/mnt/nfs/users/u_c1e2324f5a10e9f2dbb54508	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "basePricePerHourCents": 15500}	2026-05-04 09:33:16.874	2026-05-04 09:33:16.916	\N	\N	16384	67	32768	12	2026-05-04 09:33:16.873	\N	0	\N	gpu-instance-1rep	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
e8abcaec-ced4-4ad3-802c-e426049aa03a	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-e8abcaec	\N	\N	\N	\N	\N	failed	\N	2026-05-04 10:14:00.764	\N	\N	/mnt/nfs/users/u_c1e2324f5a10e9f2dbb54508	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "basePricePerHourCents": 15500}	2026-05-04 10:13:58.568	2026-05-04 10:14:00.766	\N	\N	16384	67	32768	12	2026-05-04 10:13:58.566	\N	0	\N	gpu-instance-9w0r	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
e5c99fe9-54ef-4267-8f73-ea3a603e0488	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-e5c99fe9	\N	\N	\N	\N	\N	failed	\N	2026-05-05 07:19:16.75	\N	\N	/mnt/nfs/users/u_ec2de1aa873a3894dcf5c1ad	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "basePricePerHourCents": 15500}	2026-05-05 07:19:00.412	2026-05-05 07:19:16.752	\N	\N	16384	67	32768	12	2026-05-05 07:19:00.41	\N	0	\N	gpu-instance-5ng6	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
c981876b-8aab-49ce-95c2-718f19c1180d	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-c981876b	\N	\N	\N	\N	\N	failed	\N	2026-05-04 10:27:38.421	\N	\N	/mnt/nfs/users/u_c1e2324f5a10e9f2dbb54508	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "basePricePerHourCents": 15500}	2026-05-04 10:27:36.296	2026-05-04 10:27:38.422	\N	\N	16384	67	32768	12	2026-05-04 10:27:36.294	\N	0	\N	gpu-instance-cxr3	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
5d8a4603-2a56-4e10-9884-d38da2423450	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	\N	\N	\N	\N	\N	\N	failed	\N	2026-05-05 08:36:41.625	\N	\N	/mnt/nfs/users/u_ec2de1aa873a3894dcf5c1ad	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 67, "interfaceMode": "gui", "basePricePerHourCents": 15500}	2026-05-05 08:36:39.551	2026-05-05 08:36:41.627	\N	\N	16384	67	32768	12	2026-05-05 08:36:39.549	\N	0	\N	gpu-instance-xriq	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	local_zfs	\N	\N
e361492d-7c2b-4e11-8e45-79fb1fe9085b	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-e361492d	\N	\N	\N	\N	\N	failed	\N	2026-05-04 10:32:11.877	\N	\N	/mnt/nfs/users/u_c1e2324f5a10e9f2dbb54508	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "basePricePerHourCents": 15500}	2026-05-04 10:32:09.763	2026-05-04 10:32:11.879	\N	\N	16384	67	32768	12	2026-05-04 10:32:09.761	\N	0	\N	gpu-instance-gjm2	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
c356bb92-018c-421b-bbab-41b4817bac74	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-c356bb92	\N	\N	\N	\N	\N	failed	\N	2026-05-04 10:39:00.406	\N	\N	/mnt/nfs/users/u_c1e2324f5a10e9f2dbb54508	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "basePricePerHourCents": 15500}	2026-05-04 10:38:58.166	2026-05-04 10:39:00.408	\N	\N	16384	67	32768	12	2026-05-04 10:38:58.164	\N	0	\N	gpu-instance-3hj2	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
81c1ac01-1b20-445a-90f1-2cec8796087b	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-81c1ac01	\N	\N	\N	\N	\N	failed	\N	2026-05-04 10:50:20.133	\N	\N	/mnt/nfs/users/u_c1e2324f5a10e9f2dbb54508	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "basePricePerHourCents": 15500}	2026-05-04 10:50:18.006	2026-05-04 10:50:20.134	\N	\N	16384	67	32768	12	2026-05-04 10:50:18.005	\N	0	\N	gpu-instance-fbyh	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
5abe4167-7866-4fb9-ab65-0a536167658b	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-5abe4167	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-04 10:55:01.854	2026-05-04 11:00:20.893	\N	\N	/mnt/nfs/users/u_c1e2324f5a10e9f2dbb54508	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "a29c4ee9805747e7104f401fd2ae8bfc", "encryptedPasswordIv": "2f7e6958a4d4d14a37ac8c39", "encryptedPasswordTag": "73043924bb1afd72dbf6f519c1163fdd", "basePricePerHourCents": 15500}	2026-05-04 10:54:37.227	2026-05-04 11:00:20.915	\N	\N	16384	67	32768	12	2026-05-04 10:54:37.226	2026-05-04 11:00:20.893	15500	319	gpu-instance-fl3c	stateful	2026-05-04 11:00:20.893	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
1df95352-8d8e-4ba9-874d-5380c3902827	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-1df95352	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-04 09:31:25.672	2026-05-04 11:20:23.27	\N	\N	\N	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "bac74f24ee13996617a3a7b6188fdf2d", "encryptedPasswordIv": "bfd6985f2bb73b7cb9025def", "encryptedPasswordTag": "2853a267a13654a0b7395cc9fadb2074", "basePricePerHourCents": 15500}	2026-05-04 09:31:03.224	2026-05-04 11:20:23.298	\N	\N	16384	67	32768	12	2026-05-04 09:31:03.222	2026-05-04 11:20:23.27	31000	6537	gpu-instance-80zn	ephemeral	2026-05-04 11:20:23.27	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	\N	\N	/datapool/ephemeral/sess_1df95352-8d8e-4ba9-874d-5380c3902827	10240
3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-3fe5bba2	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-04 11:01:04.34	2026-05-04 11:20:35.226	\N	\N	/mnt/nfs/users/u_c1e2324f5a10e9f2dbb54508	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "bdeaec6e6a62bf7c003921aa2a642591", "encryptedPasswordIv": "927d9fdbe628d80df6de9e0b", "encryptedPasswordTag": "d3f8990a21c0fb23da21566bd985a6f2", "basePricePerHourCents": 15500}	2026-05-04 11:00:41.691	2026-05-04 11:20:35.239	\N	\N	16384	67	32768	12	2026-05-04 11:00:41.689	2026-05-04 11:20:35.226	15500	1170	gpu-instance-1s7q	stateful	2026-05-04 11:20:35.226	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
9e90358e-7497-46a8-b21c-57b3846377df	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-9e90358e	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-04 12:14:35.063	2026-05-04 12:18:54.671	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "fb570f9a9cd523b929da3ffca6c8b13b", "encryptedPasswordIv": "84afda639bcef40759115c3b", "encryptedPasswordTag": "c5c1409bef2d79d1574c0da9b78db384", "basePricePerHourCents": 3500}	2026-05-04 12:14:12.716	2026-05-04 12:18:54.691	\N	\N	2048	8	4096	2	2026-05-04 12:14:12.714	2026-05-04 12:18:54.671	3500	259	gpu-instance-uarc	ephemeral	2026-05-04 12:18:54.671	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	\N	\N	/datapool/ephemeral/sess_9e90358e-7497-46a8-b21c-57b3846377df	10240
8eafc0ac-cd0c-4cb5-8960-618b96f862a4	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-8eafc0ac	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-05 01:20:39.142	2026-05-05 05:11:44.477	\N	\N	/mnt/nfs/users/u_ec8ab0e4da1e4cd21f8e57f8	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 33, "interfaceMode": "gui", "encryptedPassword": "63f354493e006bbdadbe3386a03b49d4", "encryptedPasswordIv": "31fc7e75641a7143fbd3a682", "encryptedPasswordTag": "dad175b5a7d2adec77878310d46ac243", "basePricePerHourCents": 10500}	2026-05-05 01:20:17.652	2026-05-05 05:11:44.494	\N	\N	8192	33	16384	8	2026-05-05 01:20:17.651	2026-05-05 05:11:44.477	52500	13865	gpu-instance-mtp3	stateful	2026-05-05 05:11:44.477	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
04944419-863d-4b3a-a89e-fa3e87e77c84	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-04944419	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-04 12:19:49.866	2026-05-04 16:14:43.535	\N	\N	\N	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "b30bf7bde106823e5cac58664dae9927", "encryptedPasswordIv": "136c670ea7a837e3fbb758dc", "encryptedPasswordTag": "f4dac4dccad251319db76ef603951537", "basePricePerHourCents": 15500}	2026-05-04 12:19:29.582	2026-05-04 16:14:43.554	\N	\N	16384	67	32768	12	2026-05-04 12:19:29.58	2026-05-04 16:14:43.535	62000	14093	gpu-instance-xha8	ephemeral	2026-05-04 16:14:43.535	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	\N	\N	/datapool/ephemeral/sess_04944419-863d-4b3a-a89e-fa3e87e77c84	10240
f4ebd53c-e856-43d6-b735-f72c0999c56b	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-f4ebd53c	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-05 05:14:50.814	2026-05-05 05:15:13.72	\N	\N	\N	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "c750dbf6c552f5186cff7e77ca1ae962", "encryptedPasswordIv": "b20ed871e80058c2527f68fa", "encryptedPasswordTag": "4f7abc72bc19cdddfe354a0e5a2e5594", "basePricePerHourCents": 15500}	2026-05-05 05:14:26.428	2026-05-05 05:15:13.738	\N	\N	16384	67	32768	12	2026-05-05 05:14:26.426	2026-05-05 05:15:13.72	15500	22	gpu-instance-5rjj	ephemeral	2026-05-05 05:15:13.72	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	\N	\N	/datapool/ephemeral/sess_f4ebd53c-e856-43d6-b735-f72c0999c56b	10240
21e006dd-20c2-4e16-8032-42a267f1084f	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-21e006dd	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-05 05:17:12.003	2026-05-05 05:17:24.073	\N	\N	\N	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "e6f8d21cf2c8b5fcc3abb3f86f5800eb", "encryptedPasswordIv": "c3f6db2c20228aee32552f3b", "encryptedPasswordTag": "8af7048d508e6b06816bcc05b32a60e6", "basePricePerHourCents": 15500}	2026-05-05 05:16:53.7	2026-05-05 05:17:24.092	\N	\N	16384	67	32768	12	2026-05-05 05:16:53.698	2026-05-05 05:17:24.073	15500	12	gpu-instance-ztg0	ephemeral	2026-05-05 05:17:24.073	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	\N	\N	/datapool/ephemeral/sess_21e006dd-20c2-4e16-8032-42a267f1084f	10240
24aea730-aef0-476f-8dc4-b96743f901f8	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-24aea730	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-04 12:21:42.344	2026-05-04 12:23:24.576	\N	\N	/mnt/nfs/users/u_c1e2324f5a10e9f2dbb54508	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "7d37b4e26d94538c5bd4a03409d14438", "encryptedPasswordIv": "9245e1b9d4de899b15e35dc6", "encryptedPasswordTag": "e49eba04e9dfb6d54b79200ae7c11858", "basePricePerHourCents": 15500}	2026-05-04 12:21:22.067	2026-05-04 12:23:24.597	\N	\N	16384	67	32768	12	2026-05-04 12:21:22.062	2026-05-04 12:23:24.576	15500	102	gpu-instance-9n7e	stateful	2026-05-04 12:23:24.576	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
49b75056-41c8-4ea7-8d06-7292d3a1bff9	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-49b75056	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-05 05:18:32.899	2026-05-05 05:43:53.137	\N	\N	\N	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "332ab5db4d62775121806efbe6deb827", "encryptedPasswordIv": "8bf0e762adff318e5cf669c2", "encryptedPasswordTag": "60e11ba0ce71b7bb8ce651c84a8d5ade", "basePricePerHourCents": 15500}	2026-05-05 05:18:14.523	2026-05-05 05:43:53.157	\N	\N	16384	67	32768	12	2026-05-05 05:18:14.521	2026-05-05 05:43:53.137	31000	1520	gpu-instance-f7a5	ephemeral	2026-05-05 05:43:53.137	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	\N	\N	/datapool/ephemeral/sess_49b75056-41c8-4ea7-8d06-7292d3a1bff9	10240
7695af26-9ec9-400c-8836-1415bdc28bce	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-7695af26	\N	\N	\N	\N	\N	failed	\N	2026-05-05 05:45:13.979	\N	\N	/mnt/nfs/users/u_66dda4c5b14682acbb7239b9	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 33, "interfaceMode": "gui", "basePricePerHourCents": 10500}	2026-05-05 05:45:11.862	2026-05-05 05:45:13.98	\N	\N	8192	33	16384	8	2026-05-05 05:45:11.86	\N	0	\N	gpu-instance-69ny	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
97c1e395-d713-4755-a94d-98f161d50f4c	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-97c1e395	\N	\N	\N	\N	\N	failed	\N	2026-05-04 12:20:28.481	\N	\N	/mnt/nfs/users/u_c1e2324f5a10e9f2dbb54508	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "basePricePerHourCents": 15500}	2026-05-04 12:20:26.386	2026-05-04 12:20:28.482	\N	\N	16384	67	32768	12	2026-05-04 12:20:26.385	\N	0	\N	gpu-instance-x6m0	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
2a2e5950-b550-469f-a47e-7958132b6657	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-2a2e5950	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-04 12:24:20.539	2026-05-04 12:26:26.834	\N	\N	/mnt/nfs/users/u_c1e2324f5a10e9f2dbb54508	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 33, "interfaceMode": "gui", "encryptedPassword": "c47c7b968e328b13c7807f7ef6d43a07", "encryptedPasswordIv": "18a1b7890a0daf5a67f62cf7", "encryptedPasswordTag": "7e3150224c470e9cd3c8dac6d5db3aae", "basePricePerHourCents": 10500}	2026-05-04 12:24:02.234	2026-05-04 12:26:26.866	\N	\N	8192	33	16384	8	2026-05-04 12:24:02.232	2026-05-04 12:26:26.834	10500	126	gpu-instance-xydh	stateful	2026-05-04 12:26:26.834	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
22354ffb-9b8e-4851-b4c2-66b44b328eb3	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-22354ffb	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-05 05:21:00.277	2026-05-05 05:35:57.644	\N	\N	/mnt/nfs/users/u_a83c0ea547ffbfb60c5b80d9	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 33, "interfaceMode": "gui", "encryptedPassword": "2dd38cc76042b42b408e5fa43f1db186", "encryptedPasswordIv": "1ff62c2140ad96f8a24b6e1b", "encryptedPasswordTag": "ac2568c5bc9421e11d3ef40a37e8ad3a", "basePricePerHourCents": 10500}	2026-05-05 05:20:37.874	2026-05-05 05:35:57.678	\N	\N	8192	33	16384	8	2026-05-05 05:20:37.872	2026-05-05 05:35:57.644	21000	897	gpu-instance-p54r	stateful	2026-05-05 05:35:57.644	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
58eb9143-5c78-4bd5-b9e2-882db758ff1f	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-58eb9143	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-04 14:43:13.693	2026-05-04 14:43:58.877	\N	\N	/mnt/nfs/users/u_c1e2324f5a10e9f2dbb54508	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "789f063250f6cc45e43b5ce1f534ba82", "encryptedPasswordIv": "4ee358e17eadac40f3ac751d", "encryptedPasswordTag": "4957dc3ba9c5a0dfb23a723baa1bc23d", "basePricePerHourCents": 15500}	2026-05-04 14:42:50.728	2026-05-04 14:43:58.912	\N	\N	16384	67	32768	12	2026-05-04 14:42:50.726	2026-05-04 14:43:58.877	15500	45	gpu-instance-fcpq	stateful	2026-05-04 14:43:58.877	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
4e21897d-ac74-4a45-9998-ef2db1c96b68	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-4e21897d	\N	\N	\N	\N	\N	failed	\N	2026-05-05 05:59:56.628	\N	\N	/mnt/nfs/users/u_66dda4c5b14682acbb7239b9	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "basePricePerHourCents": 3500}	2026-05-05 05:59:40.286	2026-05-05 05:59:56.629	\N	\N	2048	8	4096	2	2026-05-05 05:59:40.282	\N	0	\N	gpu-instance-sfdd	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
265f90b2-01bf-4c25-ab9d-925034e9634e	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-265f90b2	\N	\N	\N	\N	\N	failed	\N	2026-05-05 06:02:16.493	\N	\N	/mnt/nfs/users/u_ec2de1aa873a3894dcf5c1ad	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "basePricePerHourCents": 3500}	2026-05-05 06:02:00.159	2026-05-05 06:02:16.495	\N	\N	2048	8	4096	2	2026-05-05 06:02:00.157	\N	0	\N	gpu-instance-nyka	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
01c999aa-fb37-4f3b-aac3-d0e7c30a3f94	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-01c999aa	\N	\N	\N	\N	\N	failed	\N	2026-05-04 15:01:21.308	\N	\N	/mnt/nfs/users/u_ec8ab0e4da1e4cd21f8e57f8	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 33, "interfaceMode": "gui", "basePricePerHourCents": 10500}	2026-05-04 15:01:19.105	2026-05-04 15:01:21.31	\N	\N	8192	33	16384	8	2026-05-04 15:01:19.098	\N	0	\N	gpu-instance-4h9m	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
3c8cf962-2d36-4672-9268-910b6870e188	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-3c8cf962	\N	\N	\N	\N	\N	failed	\N	2026-05-04 15:29:28.042	\N	\N	/mnt/nfs/users/u_ec8ab0e4da1e4cd21f8e57f8	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "basePricePerHourCents": 15500}	2026-05-04 15:29:25.85	2026-05-04 15:29:28.044	\N	\N	16384	67	32768	12	2026-05-04 15:29:25.848	\N	0	\N	gpu-instance-a9o0	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
87393c22-0a61-4707-8816-8e36f854eb5d	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-87393c22	\N	\N	\N	\N	\N	failed	\N	2026-05-04 15:38:01.974	\N	\N	/mnt/nfs/users/u_ec8ab0e4da1e4cd21f8e57f8	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 33, "interfaceMode": "gui", "basePricePerHourCents": 10500}	2026-05-04 15:37:59.781	2026-05-04 15:38:01.976	\N	\N	8192	33	16384	8	2026-05-04 15:37:59.779	\N	0	\N	gpu-instance-heed	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
4a90a7ed-d8db-4284-ab65-d2a9918206bb	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-4a90a7ed	\N	\N	\N	\N	\N	failed	\N	2026-05-04 15:43:11.167	\N	\N	/mnt/nfs/users/u_ec8ab0e4da1e4cd21f8e57f8	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "basePricePerHourCents": 15500}	2026-05-04 15:43:08.975	2026-05-04 15:43:11.169	\N	\N	16384	67	32768	12	2026-05-04 15:43:08.973	\N	0	\N	gpu-instance-7lje	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
0a3df555-2b1f-4f5b-8c54-f22f5478d470	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-0a3df555	\N	\N	\N	\N	\N	failed	\N	2026-05-04 15:46:48.288	\N	\N	/mnt/nfs/users/u_ec8ab0e4da1e4cd21f8e57f8	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "basePricePerHourCents": 15500}	2026-05-04 15:46:46.123	2026-05-04 15:46:48.291	\N	\N	16384	67	32768	12	2026-05-04 15:46:46.121	\N	0	\N	gpu-instance-5kz9	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-bf30b9ad	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-04 16:12:23.019	2026-05-04 16:13:57.282	\N	\N	\N	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 33, "interfaceMode": "gui", "encryptedPassword": "928dbb1320992b494ad6522138c36644", "encryptedPasswordIv": "02392731c1db2e6af85c9f5f", "encryptedPasswordTag": "ce4a9ded3c83e27c1255bd4b59716034", "basePricePerHourCents": 10500}	2026-05-04 16:12:00.353	2026-05-04 16:13:57.309	\N	\N	8192	33	16384	8	2026-05-04 16:12:00.352	2026-05-04 16:13:57.282	10500	94	gpu-instance-xlmu	ephemeral	2026-05-04 16:13:57.282	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	\N	\N	/datapool/ephemeral/sess_bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	10240
a5fb62a4-83e4-4d39-9bc2-9c6d4035c8ef	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	\N	\N	\N	\N	\N	\N	failed	\N	2026-05-05 07:34:12.801	\N	\N	/mnt/nfs/users/u_ec2de1aa873a3894dcf5c1ad	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 67, "interfaceMode": "gui", "basePricePerHourCents": 15500}	2026-05-05 07:34:10.421	2026-05-05 07:34:12.803	\N	\N	16384	67	32768	12	2026-05-05 07:34:10.42	\N	0	\N	gpu-instance-ey2e	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	local_zfs	\N	\N
d95f2adf-135b-420e-b3ff-fc150228ded8	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-d95f2adf	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-05 05:17:58.009	2026-05-05 05:18:45.211	\N	\N	\N	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "7edbc3f67874048979e6533315215a95", "encryptedPasswordIv": "f378c5d424fe474b064238bd", "encryptedPasswordTag": "af653f58ad057a24521b5f71fd529907", "basePricePerHourCents": 15500}	2026-05-05 05:17:39.713	2026-05-05 05:18:45.305	\N	\N	16384	67	32768	12	2026-05-05 05:17:39.711	2026-05-05 05:18:45.211	15500	47	gpu-instance-sqz2	ephemeral	2026-05-05 05:18:45.211	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	\N	\N	/datapool/ephemeral/sess_d95f2adf-135b-420e-b3ff-fc150228ded8	10240
3f659e62-8075-4437-a67b-9c9f9d07502b	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-3f659e62	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-05 01:06:06.308	2026-05-05 05:12:13.403	\N	\N	\N	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "5643f0ba24cceda88aca88dcab97bcf9", "encryptedPasswordIv": "e9433ecbd1d8ef8471b08716", "encryptedPasswordTag": "88e6e0fcc97f73b2c9e0e59a8b821e77", "basePricePerHourCents": 15500}	2026-05-05 01:04:44.102	2026-05-05 05:12:13.418	\N	\N	16384	67	32768	12	2026-05-05 01:04:44.099	2026-05-05 05:12:13.403	77500	14767	gpu-instance-6opt	ephemeral	2026-05-05 05:12:13.403	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	\N	\N	/datapool/ephemeral/sess_3f659e62-8075-4437-a67b-9c9f9d07502b	10240
4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-4b9c660c	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-04 16:34:50.981	2026-05-04 16:35:05.63	\N	\N	/mnt/nfs/users/u_ec8ab0e4da1e4cd21f8e57f8	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "6bc3309719720eb006ffbc55e01d6fe6", "encryptedPasswordIv": "2dd12a1996240b58056b301f", "encryptedPasswordTag": "799757f33ce8a872ca0b7115a3f75cc3", "basePricePerHourCents": 15500}	2026-05-04 16:34:30.29	2026-05-04 16:35:05.65	\N	\N	16384	67	32768	12	2026-05-04 16:34:30.289	2026-05-04 16:35:05.63	15500	14	gpu-instance-j7um	stateful	2026-05-04 16:35:05.63	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
50003a90-973a-4998-b722-4e75c934f5d3	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-50003a90	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-05 05:15:51.212	2026-05-05 05:16:17.977	\N	\N	/mnt/nfs/users/u_a83c0ea547ffbfb60c5b80d9	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "eae2695b7a98edcb93bf4c90e2e88b3f", "encryptedPasswordIv": "88b6562834033901681fea24", "encryptedPasswordTag": "e8654dc952f2729cb0bd30a723619798", "basePricePerHourCents": 15500}	2026-05-05 05:15:32.843	2026-05-05 05:16:17.995	\N	\N	16384	67	32768	12	2026-05-05 05:15:32.841	2026-05-05 05:16:17.977	15500	26	gpu-instance-vjkj	stateful	2026-05-05 05:16:17.977	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
4c7ac79c-bce6-4f29-b793-21774cbebbc2	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-4c7ac79c	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-04 16:35:44.718	2026-05-04 23:58:55.602	\N	\N	/mnt/nfs/users/u_ec8ab0e4da1e4cd21f8e57f8	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 33, "interfaceMode": "gui", "encryptedPassword": "109e2155c47be966505b0b218e2ad82b", "encryptedPasswordIv": "b35e679613d83ddddbf2d78d", "encryptedPasswordTag": "89f8d51090ff6a53a4ea9ad7195b3c77", "basePricePerHourCents": 10500}	2026-05-04 16:35:19.939	2026-05-04 23:58:55.65	\N	\N	8192	33	16384	8	2026-05-04 16:35:19.937	2026-05-04 23:58:55.602	84000	26590	gpu-instance-mgbx	stateful	2026-05-04 23:58:55.602	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	local_zfs	\N	\N
0ccd7449-8e06-45ce-94a0-7ed143546716	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-0ccd7449	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-04 16:37:19.442	2026-05-04 23:58:34.31	\N	\N	\N	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "303c36a305dcbade346c8c33967827da", "encryptedPasswordIv": "4647b22ee9fad7e0725aa357", "encryptedPasswordTag": "825f0554482eaea5a8d8b8c6aa0dec54", "basePricePerHourCents": 15500}	2026-05-04 16:37:02.883	2026-05-04 23:58:34.359	\N	\N	16384	67	32768	12	2026-05-04 16:37:02.881	2026-05-04 23:58:34.31	124000	26474	gpu-instance-lbfl	ephemeral	2026-05-04 23:58:34.31	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	\N	\N	/datapool/ephemeral/sess_0ccd7449-8e06-45ce-94a0-7ed143546716	10240
407b2a0b-a8a7-42c7-b34b-142d57c8089e	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-407b2a0b	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-05 01:04:19.649	2026-05-05 01:04:25.457	\N	\N	\N	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "15672159d57b6003c443e13da4171939", "encryptedPasswordIv": "d24de85431f6d57f57d22ba2", "encryptedPasswordTag": "b943f36855a811143c6aada0d24551a2", "basePricePerHourCents": 15500}	2026-05-05 01:03:56.712	2026-05-05 01:04:25.48	\N	\N	16384	67	32768	12	2026-05-05 01:03:56.71	2026-05-05 01:04:25.457	15500	5	gpu-instance-iofu	ephemeral	2026-05-05 01:04:25.457	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	\N	\N	/datapool/ephemeral/sess_407b2a0b-a8a7-42c7-b34b-142d57c8089e	10240
40c571d1-2a7d-4700-b8b2-ee7d7c501401	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-40c571d1	\N	\N	\N	\N	\N	failed	\N	2026-05-05 07:35:48.929	\N	\N	/mnt/nfs/users/u_ec2de1aa873a3894dcf5c1ad	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "basePricePerHourCents": 15500}	2026-05-05 07:35:32.645	2026-05-05 07:35:48.93	\N	\N	16384	67	32768	12	2026-05-05 07:35:32.644	\N	0	\N	gpu-instance-ey2e	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
3bafc61f-6305-41e4-bff1-92c190cb7cb3	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-3bafc61f	\N	\N	\N	\N	\N	failed	\N	2026-05-05 06:42:36.363	\N	\N	/mnt/nfs/users/u_ec2de1aa873a3894dcf5c1ad	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "basePricePerHourCents": 15500}	2026-05-05 06:42:20.034	2026-05-05 06:42:36.365	\N	\N	16384	67	32768	12	2026-05-05 06:42:20.031	\N	0	\N	gpu-instance-9ldd	stateful	\N	\N	\N	error_unrecoverable	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
aee03291-4ca9-4613-a396-de0251fe57bf	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-aee03291	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-05 06:15:41.038	2026-05-05 06:28:23.237	\N	\N	/mnt/nfs/users/u_ec2de1aa873a3894dcf5c1ad	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "642a1d62cd239e33b72b8c20d231b646", "encryptedPasswordIv": "2005c0945cae631582439632", "encryptedPasswordTag": "4a8aed9dc7a9afdb749decdfe1be0e6c", "basePricePerHourCents": 3500}	2026-05-05 06:15:24.709	2026-05-05 06:28:23.255	\N	\N	2048	8	4096	2	2026-05-05 06:15:24.707	2026-05-05 06:28:23.237	3500	762	gpu-instance-ziuj	stateful	2026-05-05 06:28:23.237	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	local_zfs	\N	\N
748e1240-b6ff-40ea-8fe6-35093a4088a9	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-748e1240	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-05 06:15:04.548	2026-05-05 06:28:32.666	\N	\N	\N	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "38f1074aa62b05f285cacae83ae3a63c", "encryptedPasswordIv": "a53e848865fc0f8950d25ac2", "encryptedPasswordTag": "7918ffbe84db945197186ad81e1a481a", "basePricePerHourCents": 15500}	2026-05-05 06:14:40.075	2026-05-05 06:28:32.678	\N	\N	16384	67	32768	12	2026-05-05 06:14:40.073	2026-05-05 06:28:32.666	15500	808	gpu-instance-07qg	ephemeral	2026-05-05 06:28:32.666	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	\N	\N	/datapool/ephemeral/sess_748e1240-b6ff-40ea-8fe6-35093a4088a9	10240
a3673281-5fd2-4636-b0d9-58f475e0f82b	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-a3673281	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-05 08:41:20.11	2026-05-05 09:25:56.867	\N	\N	/mnt/nfs/users/u_ec2de1aa873a3894dcf5c1ad	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "c33ba1328e174ad9fb5bf559dca6dabe", "encryptedPasswordIv": "16c88144726c3d1be4d38665", "encryptedPasswordTag": "847687d03aaa5c7eee8348597230efd5", "basePricePerHourCents": 15500}	2026-05-05 08:40:57.678	2026-05-05 09:25:56.897	\N	\N	16384	67	32768	12	2026-05-05 08:40:57.676	2026-05-05 09:25:56.867	15500	2676	gpu-instance-xriq	stateful	2026-05-05 09:25:56.867	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
c676954a-51a2-44b7-b923-534534f320f7	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-c676954a	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-05 10:09:13.792	2026-05-05 12:09:55.271	\N	\N	/mnt/nfs/users/u_ec2de1aa873a3894dcf5c1ad	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "bd63966586ff388cfc757e777b345a17", "encryptedPasswordIv": "739ef668c99dcec67e1ab4aa", "encryptedPasswordTag": "851fb8098f31f57a23f825d2ea5d681d", "basePricePerHourCents": 3500}	2026-05-05 10:08:53.238	2026-05-05 12:09:55.309	\N	\N	2048	8	4096	2	2026-05-05 10:08:53.235	2026-05-05 12:09:55.271	10500	7241	gpu-instance-okk0	stateful	2026-05-05 12:09:55.271	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
2d87be54-82ea-4d73-9128-262be3f3dddd	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-2d87be54	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-05 06:29:20.118	2026-05-05 06:41:52.779	\N	\N	/mnt/nfs/users/u_ec2de1aa873a3894dcf5c1ad	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 33, "interfaceMode": "gui", "encryptedPassword": "842398b54f5a6f87cb2ae99791bd834c", "encryptedPasswordIv": "4c138b2fb704ebe6bfbfa165", "encryptedPasswordTag": "030bb380a3416d8c5133e1202b51b965", "basePricePerHourCents": 10500}	2026-05-05 06:28:59.773	2026-05-05 06:41:52.801	\N	\N	8192	33	16384	8	2026-05-05 06:28:59.771	2026-05-05 06:41:52.779	21000	752	gpu-instance-wwoh	stateful	2026-05-05 06:41:52.779	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	local_zfs	\N	\N
ec3f0ced-027a-4e05-bc13-4eee83a759a0	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-ec3f0ced	8101	9101	20	\N	http://100.94.157.114:8101/	running	2026-05-05 15:35:10.984	\N	\N	\N	/mnt/nfs/users/u_ec2de1aa873a3894dcf5c1ad	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "74f9577e0f447910968e063655f52d23", "encryptedPasswordIv": "86911ac08b526a273562ddd9", "encryptedPasswordTag": "6a71f8b907ff62512518fd667edf5a29", "basePricePerHourCents": 3500}	2026-05-05 15:34:49.185	2026-05-05 17:30:00.095	\N	\N	2048	8	4096	2	2026-05-05 15:34:49.184	2026-05-05 17:30:00.092	10500	\N	gpu-instance-zgxl	stateful	\N	\N	\N	\N	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
\.


--
-- TOC entry 6059 (class 0 OID 120067)
-- Dependencies: 287
-- Data for Name: storage_extensions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.storage_extensions (id, user_id, storage_volume_id, extension_type, previous_quota_bytes, new_quota_bytes, extension_bytes, amount_cents, currency, payment_transaction_id, wallet_transaction_id, notes, created_at, created_by) FROM stdin;
\.


--
-- TOC entry 6024 (class 0 OID 118759)
-- Dependencies: 252
-- Data for Name: subscription_plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscription_plans (id, slug, name, description, price_cents, currency, billing_period, gpu_hours_included, mentor_sessions_included, features, is_active, sort_order, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6025 (class 0 OID 118781)
-- Dependencies: 253
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscriptions (id, user_id, plan_id, organization_id, status, starts_at, ends_at, gpu_hours_remaining, mentor_sessions_remaining, auto_renew, cancellation_requested_at, cancel_at_period_end, grace_period_until, payment_transaction_id, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6056 (class 0 OID 119282)
-- Dependencies: 284
-- Data for Name: support_tickets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.support_tickets (id, user_id, organization_id, subject, description, category, priority, status, assigned_to, related_session_id, related_billing_id, resolved_at, resolution_notes, satisfaction_rating, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6053 (class 0 OID 119240)
-- Dependencies: 281
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_settings (id, key, value, value_type, description, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6057 (class 0 OID 119300)
-- Dependencies: 285
-- Data for Name: ticket_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ticket_messages (id, ticket_id, sender_id, body, is_internal, attachments, created_at) FROM stdin;
\.


--
-- TOC entry 6002 (class 0 OID 118399)
-- Dependencies: 230
-- Data for Name: universities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.universities (id, name, short_name, slug, domain_suffixes, logo_url, website_url, contact_email, contact_phone, city, state, country, timezone, is_active, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
f213bc95-2fe5-4401-94c1-39efeaa39a5a	K.S. Rangasamy College of Engineering	KSRCE	ksrce	{@ksrc.in}	\N	\N	\N	\N	\N	\N	IN	Asia/Kolkata	t	2026-04-08 01:52:11.94	2026-04-08 01:52:11.94	\N	\N	\N
\.


--
-- TOC entry 6003 (class 0 OID 118416)
-- Dependencies: 231
-- Data for Name: university_idp_configs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.university_idp_configs (id, university_id, idp_type, idp_entity_id, idp_metadata_url, idp_config, keycloak_idp_alias, display_name, is_primary, is_active, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6048 (class 0 OID 119170)
-- Dependencies: 276
-- Data for Name: user_achievements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_achievements (id, user_id, achievement_id, earned_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6052 (class 0 OID 119223)
-- Dependencies: 280
-- Data for Name: user_deletion_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_deletion_requests (id, user_id, requested_at, requested_by, reason, grace_period_days, scheduled_deletion_at, status, cancelled_at, completed_at, completion_details, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6007 (class 0 OID 118480)
-- Dependencies: 235
-- Data for Name: user_departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_departments (id, user_id, department_id, is_primary, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6058 (class 0 OID 119315)
-- Dependencies: 286
-- Data for Name: user_feedback; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_feedback (id, user_id, session_id, feedback_type, rating, subject, body, status, admin_response, responded_by, responded_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6011 (class 0 OID 118535)
-- Dependencies: 239
-- Data for Name: user_files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_files (id, user_id, file_name, file_path, file_size_bytes, mime_type, file_type, session_id, is_pinned, storage_backend, retention_days, scheduled_deletion_at, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6008 (class 0 OID 118493)
-- Dependencies: 236
-- Data for Name: user_group_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_group_members (id, user_id, user_group_id, added_by, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6005 (class 0 OID 118449)
-- Dependencies: 233
-- Data for Name: user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_groups (id, organization_id, department_id, parent_id, group_type, name, slug, description, keycloak_group_id, max_members, is_active, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6001 (class 0 OID 118161)
-- Dependencies: 229
-- Data for Name: user_org_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_org_roles (expires_at, created_at, updated_at, created_by, updated_by, id, user_id, organization_id, role_id, granted_by) FROM stdin;
\N	2026-05-04 07:40:54.656	2026-05-04 07:40:54.656	\N	\N	5a7e05c7-7249-48af-9e78-e5f2e19d731b	ae95fb83-2551-437f-8fac-dcd84b751a1d	07b07401-b326-4045-af3a-44a7c45e56d8	42abadfe-edfa-4b0e-985d-adaa65091959	\N
\N	2026-05-04 08:23:12.082	2026-05-04 08:23:12.082	\N	\N	2d94264b-dc04-47e8-abf0-476371147bb8	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389	07b07401-b326-4045-af3a-44a7c45e56d8	42abadfe-edfa-4b0e-985d-adaa65091959	\N
\.


--
-- TOC entry 5994 (class 0 OID 118072)
-- Dependencies: 222
-- Data for Name: user_policy_consents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_policy_consents (policy_slug, policy_version, agreed_at, ip_address, created_at, created_by, id, user_id) FROM stdin;
\.


--
-- TOC entry 6006 (class 0 OID 118464)
-- Dependencies: 234
-- Data for Name: user_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profiles (id, user_id, bio, enrollment_number, id_proof_url, id_proof_verified_at, id_proof_verified_by, college_name, graduation_year, github_url, linkedin_url, website_url, skills, theme_preference, notification_preferences, created_at, updated_at, created_by, updated_by, country, expertise_level, onboarding_complete, operational_domains, profession, use_case_other, use_case_purposes, years_of_experience, academic_year, course_name, department_id) FROM stdin;
dd0d2a4e-4555-4541-b282-a964493d827d	ae95fb83-2551-437f-8fac-dcd84b751a1d	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	dark	{}	2026-05-04 07:40:54.649	2026-05-04 07:41:08.664	\N	\N	IN	beginner	t	{video_editing}	researcher	\N	{data_processing,"After Effects"}	2	\N	\N	\N
ebd8ef42-ece8-4ccd-85f3-385ae7fdc966	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	dark	{}	2026-05-04 08:23:12.075	2026-05-04 08:23:24.453	\N	\N	IN	beginner	t	{data_science}	engineer	\N	{data_processing,Jupyter}	1	\N	\N	\N
\.


--
-- TOC entry 6009 (class 0 OID 118504)
-- Dependencies: 237
-- Data for Name: user_storage_volumes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_storage_volumes (id, user_id, storage_uid, zfs_dataset_path, nfs_export_path, container_mount_path, os_choice, quota_bytes, used_bytes, used_bytes_updated_at, status, provisioned_at, wiped_at, wipe_reason, quota_warning_sent_at, created_at, updated_at, created_by, updated_by, allocation_type, name, price_per_gb_cents_month, node_id, storage_backend) FROM stdin;
8d76221d-e9fb-4cc0-8f8f-ab2fada926cc	ae95fb83-2551-437f-8fac-dcd84b751a1d	u_ec2de1aa873a3894dcf5c1ad	datapool/users/u_ec2de1aa873a3894dcf5c1ad	/mnt/nfs/users/u_ec2de1aa873a3894dcf5c1ad	\N	ubuntu22	9663676416	0	\N	active	2026-05-05 11:31:32.59	\N	\N	\N	2026-05-05 11:31:32.59	2026-05-05 11:31:32.59	\N	\N	user_created	ef101	700	c9868115-ff99-403c-8e87-06124ba7df66	zfs_zvol
ccec291b-4633-4e45-8453-52f933cc991d	ae95fb83-2551-437f-8fac-dcd84b751a1d	u_84a91b77c6bca47707b0c580	datapool/users/u_84a91b77c6bca47707b0c580	/mnt/nfs/users/u_84a91b77c6bca47707b0c580	\N	ubuntu22	7516192768	0	\N	wiped	2026-05-04 13:12:07.451	2026-05-04 13:20:50.038	User requested deletion via API	\N	2026-05-04 13:12:07.451	2026-05-04 13:20:50.038	\N	ae95fb83-2551-437f-8fac-dcd84b751a1d	user_created	ef1	700	c9868115-ff99-403c-8e87-06124ba7df66	zfs_dataset
744a5e38-9ebd-45fb-a12f-308bc6c281a4	ae95fb83-2551-437f-8fac-dcd84b751a1d	u_f7053a8b16cd55e38b838e79	datapool/users/u_f7053a8b16cd55e38b838e79	/mnt/nfs/users/u_f7053a8b16cd55e38b838e79	\N	ubuntu22	10737418240	0	\N	wiped	2026-05-04 13:21:08.722	2026-05-04 13:57:09.858	User requested deletion via API	\N	2026-05-04 13:21:08.722	2026-05-04 13:57:09.858	\N	ae95fb83-2551-437f-8fac-dcd84b751a1d	user_created	ed1	700	c9868115-ff99-403c-8e87-06124ba7df66	zfs_zvol
106c4422-a4f2-49d7-b06e-f3e3d156e13d	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389	u_67351641e9df7b1f476b151e	datapool/users/u_67351641e9df7b1f476b151e	/mnt/nfs/users/u_67351641e9df7b1f476b151e	\N	ubuntu22	10737418240	0	\N	wiped	2026-05-04 13:54:55.553	2026-05-04 13:57:47.354	User requested deletion via API	\N	2026-05-04 13:54:55.553	2026-05-04 13:57:47.354	\N	\N	user_created	ed2	700	c9868115-ff99-403c-8e87-06124ba7df66	zfs_zvol
0bb083a9-b83c-4dc4-87ee-844b8b75bba6	ae95fb83-2551-437f-8fac-dcd84b751a1d	u_c1e2324f5a10e9f2dbb54508	datapool/users/u_c1e2324f5a10e9f2dbb54508	/mnt/nfs/users/u_c1e2324f5a10e9f2dbb54508	\N	ubuntu22	10737418240	0	\N	wiped	2026-05-04 14:29:00.134	2026-05-04 20:30:32.751	User requested deletion via API	\N	2026-05-04 14:29:00.134	2026-05-04 20:30:32.751	\N	\N	user_created	ef2	700	c9868115-ff99-403c-8e87-06124ba7df66	zfs_zvol
da558457-599c-42ad-9aaa-e94dd64ddc58	ae95fb83-2551-437f-8fac-dcd84b751a1d	u_ec8ab0e4da1e4cd21f8e57f8	datapool/users/u_ec8ab0e4da1e4cd21f8e57f8	/mnt/nfs/users/u_ec8ab0e4da1e4cd21f8e57f8	\N	ubuntu22	10737418240	0	\N	wiped	2026-05-04 20:31:02.831	2026-05-05 10:43:08.884	User requested deletion via API	\N	2026-05-04 20:31:02.831	2026-05-05 10:43:08.884	\N	\N	user_created	ef10	700	c9868115-ff99-403c-8e87-06124ba7df66	zfs_zvol
82cc3fb0-b6ad-4adc-91ef-caaabe772f8b	ae95fb83-2551-437f-8fac-dcd84b751a1d	u_a83c0ea547ffbfb60c5b80d9	datapool/users/u_a83c0ea547ffbfb60c5b80d9	/mnt/nfs/users/u_a83c0ea547ffbfb60c5b80d9	\N	ubuntu22	10737418240	0	\N	wiped	2026-05-05 10:43:51.315	2026-05-05 11:14:37.505	User requested deletion via API	\N	2026-05-05 10:43:51.315	2026-05-05 11:14:37.505	\N	ae95fb83-2551-437f-8fac-dcd84b751a1d	user_created	ef3	700	c9868115-ff99-403c-8e87-06124ba7df66	zfs_zvol
95a31862-7972-4a10-b56c-5a02905230e1	ae95fb83-2551-437f-8fac-dcd84b751a1d	u_66dda4c5b14682acbb7239b9	datapool/users/u_66dda4c5b14682acbb7239b9	/mnt/nfs/users/u_66dda4c5b14682acbb7239b9	\N	ubuntu22	8589934592	0	\N	wiped	2026-05-05 11:14:58.499	2026-05-05 11:30:45.326	User requested deletion via API	\N	2026-05-05 11:14:58.499	2026-05-05 11:30:45.326	\N	\N	user_created	ef4	700	c9868115-ff99-403c-8e87-06124ba7df66	zfs_zvol
\.


--
-- TOC entry 5992 (class 0 OID 118034)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (email, email_verified_at, password_hash, first_name, last_name, display_name, avatar_url, phone, timezone, keycloak_sub, auth_type, oauth_provider, storage_uid, token_version, two_factor_enabled, last_login_at, last_login_ip, onboarding_completed_at, is_active, created_at, updated_at, deleted_at, storage_provisioned_at, storage_provisioning_error, storage_provisioning_status, created_by, keycloak_last_sync_at, lock_expires_at, lock_reason, locked_at, os_choice, pending_email, updated_by, id, default_org_id, referred_by_code) FROM stdin;
punith.vs74064@gmail.com	\N	\N	Punith	VS	\N	\N	\N	Asia/Kolkata	0fbe8ba9-74c2-4b3a-9d22-5cde9d40ee64	public_oauth	keycloak	u_ec2de1aa873a3894dcf5c1ad	0	f	2026-05-05 15:34:33.158	127.0.0.1	\N	t	2026-05-04 07:40:54.643	2026-05-05 15:34:33.16	\N	2026-05-05 11:31:32.593	\N	provisioned	\N	\N	\N	\N	\N	\N	\N	\N	ae95fb83-2551-437f-8fac-dcd84b751a1d	07b07401-b326-4045-af3a-44a7c45e56d8	\N
viswanaths365@gmail.com	\N	\N	Punith	VS	\N	\N	\N	Asia/Kolkata	3fe2b6fe-6c48-47a7-ae6b-da52eef70660	public_oauth	keycloak	\N	0	f	2026-05-04 08:27:36.606	127.0.0.1	\N	t	2026-05-04 08:23:12.063	2026-05-04 13:57:47.354	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389	07b07401-b326-4045-af3a-44a7c45e56d8	\N
\.


--
-- TOC entry 6065 (class 0 OID 129402)
-- Dependencies: 293
-- Data for Name: waitlist_entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.waitlist_entries (id, "userId", email, "firstName", "lastName", "currentStatus", "organizationName", "jobTitle", "computeNeeds", "expectedDuration", urgency, expectations, "primaryWorkload", "workloadDescription", "agreedToPolicy", "policyAgreedAt", "agreedToComms", status, "createdAt", "updatedAt") FROM stdin;
\.


--
-- TOC entry 6021 (class 0 OID 118710)
-- Dependencies: 249
-- Data for Name: wallet_holds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wallet_holds (id, wallet_id, user_id, amount_cents, hold_reason, booking_id, session_id, status, expires_at, released_at, release_reason, captured_amount, created_at) FROM stdin;
6fb250a4-b8e1-4aa6-aa80-9fd33dc73377	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	f3345614-394f-49e8-99e1-30804f314627	captured	2026-05-04 09:03:53.834	2026-05-04 08:04:14.149	prepaid_hour_charged	15500	2026-05-04 08:03:53.837
0287221f-9f59-499c-86b0-11059468129f	ec5deedc-e3b3-4bb8-a5f9-1e990ca0a55f	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389	15500	compute_session_hold	\N	6c5b8d4d-2827-4e05-b551-bd397301b575	released	2026-05-04 09:25:08.403	2026-05-04 08:25:08.448	session_failed	\N	2026-05-04 08:25:08.405
0d9bf306-49da-45de-9f6c-0d046afd2c83	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	ae38510e-ab6b-408c-b1be-eac0988fbc93	released	2026-05-04 09:59:14.375	2026-05-04 08:59:14.428	session_failed	\N	2026-05-04 08:59:14.377
7e888406-bf7e-478d-b57f-34d8e1cc7a37	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	3500	compute_session_hold	\N	58582e3f-f8bd-4147-b9ed-38a510ceb745	released	2026-05-04 10:01:29.585	2026-05-04 09:01:30.067	session_failed	\N	2026-05-04 09:01:29.589
f532f044-17b9-4d03-917d-d058515ad42f	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	10500	compute_session_hold	\N	892af945-7115-46cb-885e-2f44d9988218	captured	2026-05-04 10:03:40.744	2026-05-04 09:03:59.057	prepaid_hour_charged	10500	2026-05-04 09:03:40.745
1a531ab9-0671-4c94-94a7-45e4f0cd1223	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	68dd70a4-c61f-4fb1-85a4-9939e4643493	captured	2026-05-04 10:16:35.146	2026-05-04 09:16:57.538	prepaid_hour_charged	15500	2026-05-04 09:16:35.147
9843cb3d-808a-4df5-86a4-46be65ef39c7	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	79446928-3d68-4633-ae84-6febe94609fc	captured	2026-05-04 10:19:36.334	2026-05-04 09:19:54.69	prepaid_hour_charged	15500	2026-05-04 09:19:36.335
c77ef7e6-ac8d-4c8d-88ed-4b3892d2542f	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	1df95352-8d8e-4ba9-874d-5380c3902827	captured	2026-05-04 10:31:03.238	2026-05-04 09:31:25.688	prepaid_hour_charged	15500	2026-05-04 09:31:03.239
96e4d8b5-58f2-44eb-a7cf-d101eb67ba32	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	2bf80869-f34a-44dd-88c6-9d70dcbe6522	released	2026-05-04 10:33:16.881	2026-05-04 09:33:16.915	session_failed	\N	2026-05-04 09:33:16.882
6af80f5a-47b3-4718-848a-2ade3985d554	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	e8abcaec-ced4-4ad3-802c-e426049aa03a	released	2026-05-04 11:13:58.604	2026-05-04 10:14:00.115	session_failed	\N	2026-05-04 10:13:58.606
332bf86b-be66-494d-9eb9-04119afb37ad	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	c981876b-8aab-49ce-95c2-718f19c1180d	released	2026-05-04 11:27:36.313	2026-05-04 10:27:38.421	session_failed	\N	2026-05-04 10:27:36.314
ba43b472-94b3-41f9-aefe-bdd3e83ff93d	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	e361492d-7c2b-4e11-8e45-79fb1fe9085b	released	2026-05-04 11:32:09.776	2026-05-04 10:32:11.877	session_failed	\N	2026-05-04 10:32:09.778
842ea23e-1fd4-48f0-9950-d8bf71eff9a7	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	c356bb92-018c-421b-bbab-41b4817bac74	released	2026-05-04 11:38:58.207	2026-05-04 10:39:00.151	session_failed	\N	2026-05-04 10:38:58.21
ba7f85ff-d79e-45ad-a6b4-2b7e1c82e4c7	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	81c1ac01-1b20-445a-90f1-2cec8796087b	released	2026-05-04 11:50:18.018	2026-05-04 10:50:20.133	session_failed	\N	2026-05-04 10:50:18.02
22c7ca7b-33fc-4169-b199-37ce829d853c	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	5abe4167-7866-4fb9-ab65-0a536167658b	captured	2026-05-04 11:54:37.236	2026-05-04 10:55:01.878	prepaid_hour_charged	15500	2026-05-04 10:54:37.237
0bffbb2b-705a-4322-a929-90840cb14776	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	captured	2026-05-04 12:00:41.705	2026-05-04 11:01:04.417	prepaid_hour_charged	15500	2026-05-04 11:00:41.707
aacdeec1-1cce-4877-ad4d-981ec0a9624c	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	10500	compute_session_hold	\N	e0688d0b-1645-4bae-a644-7a408007f2d8	captured	2026-05-04 12:20:55.105	2026-05-04 11:21:17.528	prepaid_hour_charged	10500	2026-05-04 11:20:55.106
9eeebb19-f5b8-4145-b2d5-69601fdf9767	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	3500	compute_session_hold	\N	9e90358e-7497-46a8-b21c-57b3846377df	captured	2026-05-04 13:14:12.739	2026-05-04 12:14:35.082	prepaid_hour_charged	3500	2026-05-04 12:14:12.741
3b42090f-5dc0-4d80-b7c8-7a2695da4ab7	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	04944419-863d-4b3a-a89e-fa3e87e77c84	released	2026-05-04 13:19:29.591	2026-05-04 12:19:30.057	session_failed	\N	2026-05-04 12:19:29.592
91526aa7-0fc7-4409-9df3-1c2a600d38ba	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	97c1e395-d713-4755-a94d-98f161d50f4c	released	2026-05-04 13:20:26.396	2026-05-04 12:20:28.481	session_failed	\N	2026-05-04 12:20:26.397
9b69a76f-7aea-4ef8-b716-3b05e2a2467f	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	24aea730-aef0-476f-8dc4-b96743f901f8	captured	2026-05-04 13:21:22.069	2026-05-04 12:21:42.361	prepaid_hour_charged	15500	2026-05-04 12:21:22.074
c21aa71c-8cfb-4928-839d-b25d39fede44	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	10500	compute_session_hold	\N	2a2e5950-b550-469f-a47e-7958132b6657	captured	2026-05-04 13:24:02.241	2026-05-04 12:24:20.558	prepaid_hour_charged	10500	2026-05-04 12:24:02.242
18b9a1ec-8427-44e1-9503-1cf437ba3b8e	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	58eb9143-5c78-4bd5-b9e2-882db758ff1f	captured	2026-05-04 15:42:50.769	2026-05-04 14:43:13.725	prepaid_hour_charged	15500	2026-05-04 14:42:50.771
71b76895-adb3-4ba4-8526-beae38f02b52	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	10500	compute_session_hold	\N	01c999aa-fb37-4f3b-aac3-d0e7c30a3f94	released	2026-05-04 16:01:19.134	2026-05-04 15:01:21.308	session_failed	\N	2026-05-04 15:01:19.136
11e9cbd4-0f81-42c2-bb30-78d681a32323	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	3c8cf962-2d36-4672-9268-910b6870e188	released	2026-05-04 16:29:25.867	2026-05-04 15:29:28.042	session_failed	\N	2026-05-04 15:29:25.868
85baa9c4-1942-42d8-a6cb-a0b5cff111fd	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	10500	compute_session_hold	\N	87393c22-0a61-4707-8816-8e36f854eb5d	released	2026-05-04 16:37:59.795	2026-05-04 15:38:00.181	session_failed	\N	2026-05-04 15:37:59.797
6a3171e2-60b2-45e5-b836-e6fb77306abb	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	4a90a7ed-d8db-4284-ab65-d2a9918206bb	released	2026-05-04 16:43:08.998	2026-05-04 15:43:11.167	session_failed	\N	2026-05-04 15:43:09
67b9080d-e8e0-4c65-9bdc-ed9138097d7d	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	0a3df555-2b1f-4f5b-8c54-f22f5478d470	released	2026-05-04 16:46:46.146	2026-05-04 15:46:48.288	session_failed	\N	2026-05-04 15:46:46.148
9c844cea-d296-4673-8c49-700aec9a592b	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	10500	compute_session_hold	\N	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	captured	2026-05-04 17:12:00.368	2026-05-04 16:12:23.051	prepaid_hour_charged	10500	2026-05-04 16:12:00.369
2ee17746-25fb-4f63-b364-b6c6e987e40d	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	captured	2026-05-04 17:34:30.302	2026-05-04 16:34:51.004	prepaid_hour_charged	15500	2026-05-04 16:34:30.303
24521d0b-c0b2-42fc-bf2e-7327e21d2ecd	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	10500	compute_session_hold	\N	4c7ac79c-bce6-4f29-b793-21774cbebbc2	captured	2026-05-04 17:35:19.947	2026-05-04 16:35:44.738	prepaid_hour_charged	10500	2026-05-04 16:35:19.949
a9ada020-e9ef-4168-811b-48dab60b07e9	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	0ccd7449-8e06-45ce-94a0-7ed143546716	captured	2026-05-04 17:37:02.895	2026-05-04 16:37:19.467	prepaid_hour_charged	15500	2026-05-04 16:37:02.896
d9d98e4f-581a-429b-a7ad-644492eb0827	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	407b2a0b-a8a7-42c7-b34b-142d57c8089e	captured	2026-05-05 02:03:56.731	2026-05-05 01:04:19.675	prepaid_hour_charged	15500	2026-05-05 01:03:56.732
813180e9-35ae-483e-99bd-51c2bcf7b3f4	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	3f659e62-8075-4437-a67b-9c9f9d07502b	captured	2026-05-05 02:04:44.114	2026-05-05 01:06:06.322	prepaid_hour_charged	15500	2026-05-05 01:04:44.116
769ed96d-e421-41ad-b6f1-edd2d52bd2d9	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	10500	compute_session_hold	\N	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	captured	2026-05-05 02:20:17.668	2026-05-05 01:20:39.172	prepaid_hour_charged	10500	2026-05-05 01:20:17.669
9f093178-3380-4300-8400-e799c8e4dace	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	f4ebd53c-e856-43d6-b735-f72c0999c56b	captured	2026-05-05 06:14:26.437	2026-05-05 05:14:50.832	prepaid_hour_charged	15500	2026-05-05 05:14:26.439
85c5c590-bb4e-4911-9f78-0f97aee1e86e	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	50003a90-973a-4998-b722-4e75c934f5d3	captured	2026-05-05 06:15:32.862	2026-05-05 05:15:51.229	prepaid_hour_charged	15500	2026-05-05 05:15:32.863
c04d08f3-4325-4b9e-a39f-55b90b52edad	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	21e006dd-20c2-4e16-8032-42a267f1084f	captured	2026-05-05 06:16:53.712	2026-05-05 05:17:12.022	prepaid_hour_charged	15500	2026-05-05 05:16:53.713
fbbf012e-ff02-4853-bdb3-bbb4ccd392b7	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	d95f2adf-135b-420e-b3ff-fc150228ded8	captured	2026-05-05 06:17:39.726	2026-05-05 05:17:58.029	prepaid_hour_charged	15500	2026-05-05 05:17:39.727
9e88e9e4-0c7c-4acf-afcf-83c12e42745e	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	49b75056-41c8-4ea7-8d06-7292d3a1bff9	captured	2026-05-05 06:18:14.531	2026-05-05 05:18:32.911	prepaid_hour_charged	15500	2026-05-05 05:18:14.532
fc0c6a3d-3649-4eaf-a7c4-dfd824956aba	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	10500	compute_session_hold	\N	22354ffb-9b8e-4851-b4c2-66b44b328eb3	captured	2026-05-05 06:20:37.891	2026-05-05 05:21:00.313	prepaid_hour_charged	10500	2026-05-05 05:20:37.893
cc4a5b71-318a-4c3b-b59a-4130440c5859	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	10500	compute_session_hold	\N	7695af26-9ec9-400c-8836-1415bdc28bce	released	2026-05-05 06:45:11.87	2026-05-05 05:45:13.979	session_failed	\N	2026-05-05 05:45:11.872
d8da0879-28c8-48fa-bfb1-73dd9adc0b7c	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	3500	compute_session_hold	\N	4e21897d-ac74-4a45-9998-ef2db1c96b68	released	2026-05-05 06:59:40.316	2026-05-05 05:59:56.628	session_failed	\N	2026-05-05 05:59:40.318
1b55da9e-e619-409b-98fc-510466376a4d	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	3500	compute_session_hold	\N	265f90b2-01bf-4c25-ab9d-925034e9634e	released	2026-05-05 07:02:00.17	2026-05-05 06:02:16.493	session_failed	\N	2026-05-05 06:02:00.172
713da1a3-c104-43de-9739-e2513625dd75	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	748e1240-b6ff-40ea-8fe6-35093a4088a9	captured	2026-05-05 07:14:40.087	2026-05-05 06:15:04.582	prepaid_hour_charged	15500	2026-05-05 06:14:40.088
d7be86e1-8126-4852-b655-2ba387d64a32	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	3500	compute_session_hold	\N	aee03291-4ca9-4613-a396-de0251fe57bf	captured	2026-05-05 07:15:24.726	2026-05-05 06:15:41.063	prepaid_hour_charged	3500	2026-05-05 06:15:24.728
e4cfcd81-a7c3-48bc-93a9-862eff6f7fda	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	10500	compute_session_hold	\N	2d87be54-82ea-4d73-9128-262be3f3dddd	captured	2026-05-05 07:28:59.78	2026-05-05 06:29:20.137	prepaid_hour_charged	10500	2026-05-05 06:28:59.782
c2e9f0d6-e244-4274-8759-1852b4ad3dcc	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	3bafc61f-6305-41e4-bff1-92c190cb7cb3	released	2026-05-05 07:42:20.047	2026-05-05 06:42:30.059	session_failed	\N	2026-05-05 06:42:20.049
37aa3275-8348-45db-bfe9-eca0870c09b9	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	e5c99fe9-54ef-4267-8f73-ea3a603e0488	released	2026-05-05 08:19:00.426	2026-05-05 07:19:16.75	session_failed	\N	2026-05-05 07:19:00.427
4c0dca8a-17c1-4aa8-9f4f-bdb1a558ccac	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	a5fb62a4-83e4-4d39-9bc2-9c6d4035c8ef	released	2026-05-05 08:34:10.431	2026-05-05 07:34:12.801	session_failed	\N	2026-05-05 07:34:10.432
6cbd2fed-0bf3-44e0-af64-aee275795087	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	40c571d1-2a7d-4700-b8b2-ee7d7c501401	released	2026-05-05 08:35:32.658	2026-05-05 07:35:48.929	session_failed	\N	2026-05-05 07:35:32.659
6453ab68-5c27-4708-8ef6-730a23b3ca6f	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	5d8a4603-2a56-4e10-9884-d38da2423450	released	2026-05-05 09:36:39.562	2026-05-05 08:36:41.625	session_failed	\N	2026-05-05 08:36:39.564
4af67fd4-6693-4f0a-b091-c5254f84e116	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	15500	compute_session_hold	\N	a3673281-5fd2-4636-b0d9-58f475e0f82b	captured	2026-05-05 09:40:57.687	2026-05-05 08:41:20.13	prepaid_hour_charged	15500	2026-05-05 08:40:57.688
d6be6984-1982-43d4-a520-355f527adffa	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	3500	compute_session_hold	\N	c676954a-51a2-44b7-b923-534534f320f7	captured	2026-05-05 11:08:53.258	2026-05-05 10:09:13.822	prepaid_hour_charged	3500	2026-05-05 10:08:53.26
baad02c9-55e3-4ad9-a699-16ff805cb75c	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	3500	compute_session_hold	\N	ec3f0ced-027a-4e05-bc13-4eee83a759a0	captured	2026-05-05 16:34:49.2	2026-05-05 15:35:11.037	prepaid_hour_charged	3500	2026-05-05 15:34:49.201
\.


--
-- TOC entry 6022 (class 0 OID 118724)
-- Dependencies: 250
-- Data for Name: wallet_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wallet_transactions (id, wallet_id, user_id, txn_type, amount_cents, balance_after_cents, reference_type, reference_id, description, created_at, created_by) FROM stdin;
d839110f-de5c-45ae-b754-8b759537bed4	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	credit	50000	50000	payment	90a5eac3-9446-4b76-a73e-d730df921073	Credit recharge via Razorpay	2026-05-04 07:41:59.609	\N
a635b6c6-b410-463c-bd6a-5d836b2bc4b3	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	34500	compute_billing	f3345614-394f-49e8-99e1-30804f314627	Compute charge - session launch (prepaid hour 1)	2026-05-04 08:04:14.142	\N
00ec9469-712c-43d7-bb79-518d5ecf5e29	ec5deedc-e3b3-4bb8-a5f9-1e990ca0a55f	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389	credit	100000	100000	payment	09220e4c-97b1-44eb-bd23-f6bfd4df4672	Credit recharge via Razorpay	2026-05-04 08:24:01.205	\N
d565f78a-ded1-47c4-a6a8-422a8043ba5d	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	3500	31000	compute_billing	58582e3f-f8bd-4147-b9ed-38a510ceb745	Compute charge - session launch (prepaid hour 1)	2026-05-04 09:01:53.99	\N
dad615f8-6510-47b7-b39c-84fc19340b1d	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10500	20500	compute_billing	892af945-7115-46cb-885e-2f44d9988218	Compute charge - session launch (prepaid hour 1)	2026-05-04 09:03:59.047	\N
ace2edc3-c6cf-44a8-a1a6-009752e24af4	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	5000	compute_billing	68dd70a4-c61f-4fb1-85a4-9939e4643493	Compute charge - session launch (prepaid hour 1)	2026-05-04 09:16:57.531	\N
f8c4a94b-668d-44e4-9875-084f2f198522	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	credit	100000	105000	payment	a117b47c-29b6-4816-ad6c-d098c1371488	Credit recharge via Razorpay	2026-05-04 09:19:19.291	\N
cb4074b6-d50e-4d95-94ff-f3791f5e4719	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	89500	compute_billing	79446928-3d68-4633-ae84-6febe94609fc	Compute charge - session launch (prepaid hour 1)	2026-05-04 09:19:54.676	\N
33d3c62b-765c-413b-b0c0-e63495bb6905	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10	89490	storage_billing	\N	Storage billing: 10GB for 2026-05-04T09:30:00.000Z	2026-05-04 09:30:00.073	\N
480c5602-50d3-4eb8-a8dc-1d5c5e024fbd	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	credit	100000	189490	payment	03485faa-865c-45fe-bb28-82ef2748bdd6	Credit recharge via Razorpay	2026-05-04 09:30:15.554	\N
59fe508d-d5be-4308-8afb-dea74bb7f79d	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	173990	compute_billing	1df95352-8d8e-4ba9-874d-5380c3902827	Compute charge - session launch (prepaid hour 1)	2026-05-04 09:31:25.681	\N
f9895c0b-436b-4c1f-943a-2aef6c9e98a4	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	158490	compute_billing	1df95352-8d8e-4ba9-874d-5380c3902827	Prepaid compute - Hour 2: gpu-instance-80zn	2026-05-04 10:30:00.074	\N
04697b15-ae5f-4b97-948e-bf1f31820fca	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10	158480	storage_billing	\N	Storage billing: 10GB for 2026-05-04T10:30:00.000Z	2026-05-04 10:30:00.237	\N
f58b6315-9b62-4210-80ee-078af97dac35	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	142980	compute_billing	5abe4167-7866-4fb9-ab65-0a536167658b	Compute charge - session launch (prepaid hour 1)	2026-05-04 10:55:01.867	\N
9f78e647-380f-482f-8ceb-a6fd5ab35096	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	127480	compute_billing	3fe5bba2-2a7c-44f6-a2c0-3761fd7d8f24	Compute charge - session launch (prepaid hour 1)	2026-05-04 11:01:04.38	\N
766f618d-b17b-4d30-8356-c223ad5ee3db	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10500	116980	compute_billing	e0688d0b-1645-4bae-a644-7a408007f2d8	Compute charge - session launch (prepaid hour 1)	2026-05-04 11:21:17.518	\N
b1374dca-6128-4ff2-8a94-cf49c53cbb7c	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10	116970	storage_billing	\N	Storage billing: 10GB for 2026-05-04T11:30:00.000Z	2026-05-04 11:30:00.027	\N
e615c690-cf3d-44cc-a366-d9ff35d4ca75	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	3500	113470	compute_billing	9e90358e-7497-46a8-b21c-57b3846377df	Compute charge - session launch (prepaid hour 1)	2026-05-04 12:14:35.073	\N
6c1fb194-2544-4739-a0b9-2ed0127827b7	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	97970	compute_billing	04944419-863d-4b3a-a89e-fa3e87e77c84	Compute charge - session launch (prepaid hour 1)	2026-05-04 12:19:49.874	\N
f0531d67-e42d-481f-b3d4-9d7667aef92c	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	82470	compute_billing	24aea730-aef0-476f-8dc4-b96743f901f8	Compute charge - session launch (prepaid hour 1)	2026-05-04 12:21:42.357	\N
77b7ec6b-2804-4c10-a1cd-0f227c66b3ee	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10500	71970	compute_billing	2a2e5950-b550-469f-a47e-7958132b6657	Compute charge - session launch (prepaid hour 1)	2026-05-04 12:24:20.548	\N
43db65e9-421d-4f99-a31c-73d7030224af	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10	71960	storage_billing	\N	Storage billing: 10GB for 2026-05-04T12:30:00.000Z	2026-05-04 12:30:00.038	\N
ff97c389-6d46-49a4-8011-fc6221a26612	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	56460	compute_billing	04944419-863d-4b3a-a89e-fa3e87e77c84	Prepaid compute - Hour 2: gpu-instance-xha8	2026-05-04 12:30:00.109	\N
fd4edf9f-4e28-403c-957c-bdda93091654	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	40960	compute_billing	04944419-863d-4b3a-a89e-fa3e87e77c84	Prepaid compute - Hour 3: gpu-instance-xha8	2026-05-04 14:05:44.726	\N
e8109429-652e-4bd7-9a2b-507c035b3db4	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10	40950	storage_billing	\N	Storage billing: 10GB for 2026-05-04T13:30:00.000Z	2026-05-04 14:05:44.797	\N
9ee79ab8-4054-4a58-bb12-be924f5e8065	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	25450	compute_billing	58eb9143-5c78-4bd5-b9e2-882db758ff1f	Compute charge - session launch (prepaid hour 1)	2026-05-04 14:43:13.71	\N
c210f90e-628f-411f-870b-63af1d286c50	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	credit	100000	125450	payment	c300a59c-feaa-4369-a937-3d611c34ec67	Credit recharge via Razorpay	2026-05-04 14:59:40.152	\N
5ee5f4ba-d1a1-4e3f-9459-931e8db935b0	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	credit	100000	225450	payment	77f56d9a-5031-41fa-b903-8fc2f2e09db5	Credit recharge via Razorpay	2026-05-04 15:00:09.155	\N
c05de521-ed3e-4690-bfe7-f935783648ac	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10	225440	storage_billing	\N	Storage billing: 10GB for 2026-05-04T15:30:00.000Z	2026-05-04 15:30:00.077	\N
186ffccc-aa61-44de-8e94-c4a5f1398969	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	209950	compute_billing	04944419-863d-4b3a-a89e-fa3e87e77c84	Prepaid compute - Hour 4: gpu-instance-xha8	2026-05-04 15:30:00.079	\N
39796965-c249-4655-94e9-f1468aea8c2d	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10500	214940	compute_billing	bf30b9ad-136f-4362-8a5a-c8a8bc8ec045	Compute charge - session launch (prepaid hour 1)	2026-05-04 16:12:23.036	\N
88ee03a3-bd78-47d6-a75d-3e085a458d1e	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10	214930	storage_billing	\N	Storage billing: 10GB for 2026-05-04T16:30:00.000Z	2026-05-04 16:30:00.039	\N
d7765a3d-2a4e-4ce8-93d9-b01ae04da73a	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	199430	compute_billing	4b9c660c-8b13-4d39-8f96-5c84b3bdeacd	Compute charge - session launch (prepaid hour 1)	2026-05-04 16:34:50.994	\N
fe4d7f3e-382d-44e0-a187-3fe68252f5b3	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10500	188930	compute_billing	4c7ac79c-bce6-4f29-b793-21774cbebbc2	Compute charge - session launch (prepaid hour 1)	2026-05-04 16:35:44.731	\N
e7b2cd7f-74e7-4760-97aa-c5ab44d7a529	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	173430	compute_billing	0ccd7449-8e06-45ce-94a0-7ed143546716	Compute charge - session launch (prepaid hour 1)	2026-05-04 16:37:19.455	\N
8b2c798c-e8e9-4b7a-a86e-35f1f7bb5cad	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10500	162930	compute_billing	4c7ac79c-bce6-4f29-b793-21774cbebbc2	Prepaid compute - Hour 2: gpu-instance-mgbx	2026-05-04 17:38:06.663	\N
22b7752a-6c49-4d54-8827-8e093f26ac82	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10	173420	storage_billing	\N	Storage billing: 10GB for 2026-05-04T17:30:00.000Z	2026-05-04 17:38:06.732	\N
b29b0c96-349c-4725-81bd-d35aa6ffcca8	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	157920	compute_billing	0ccd7449-8e06-45ce-94a0-7ed143546716	Prepaid compute - Hour 2: gpu-instance-lbfl	2026-05-04 17:38:07.936	\N
7bd08fdc-ac81-415e-9078-2fac87bad9d7	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	142420	compute_billing	0ccd7449-8e06-45ce-94a0-7ed143546716	Prepaid compute - Hour 3: gpu-instance-lbfl	2026-05-04 23:43:17.921	\N
69a4282b-adff-4be1-b4d2-6c7a219d8ade	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10	157910	storage_billing	\N	Storage billing: 10GB for 2026-05-04T23:30:00.000Z	2026-05-04 23:43:18.335	\N
fca57e03-9b50-43ea-a211-b63c2d43e5f3	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10500	147410	compute_billing	4c7ac79c-bce6-4f29-b793-21774cbebbc2	Prepaid compute - Hour 3: gpu-instance-mgbx	2026-05-04 23:43:20.009	\N
4c48e83f-18a1-4e0d-a8bc-e998476fdd81	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	77500	69910	compute_billing	0ccd7449-8e06-45ce-94a0-7ed143546716	Final compute charge: gpu-instance-lbfl	2026-05-04 23:58:34.341	\N
1cb82804-2e01-46f7-a3e2-e8e371e12490	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	52500	17410	compute_billing	4c7ac79c-bce6-4f29-b793-21774cbebbc2	Final compute charge: gpu-instance-mgbx	2026-05-04 23:58:55.632	\N
63ee1885-c8e3-4834-954b-36c182f7db01	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	credit	100000	117410	payment	222ed01f-b5c2-4beb-82df-22c496e9dc20	Credit recharge via Razorpay	2026-05-04 23:59:54.655	\N
f2b05bdb-6ed6-406c-bf8f-b28d105de896	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	credit	100000	217410	payment	9b46e2ac-ecd1-4209-99f0-e5e73c77c477	Credit recharge via Razorpay	2026-05-05 00:00:40.752	\N
f20adfba-0fc0-4717-b118-5317ee59cde7	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10	217400	storage_billing	\N	Storage billing: 10GB for 2026-05-05T00:30:00.000Z	2026-05-05 00:30:00.036	\N
e1265ac2-684f-428e-8ca7-0ee3eb89ad77	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	201900	compute_billing	407b2a0b-a8a7-42c7-b34b-142d57c8089e	Compute charge - session launch (prepaid hour 1)	2026-05-05 01:04:19.663	\N
a6d60a27-ea0e-4fa0-9d3f-6f98872f5512	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	186400	compute_billing	3f659e62-8075-4437-a67b-9c9f9d07502b	Compute charge - session launch (prepaid hour 1)	2026-05-05 01:06:06.315	\N
1b25a466-9af5-402d-bd70-7d2b17012b9a	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10500	175900	compute_billing	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	Compute charge - session launch (prepaid hour 1)	2026-05-05 01:20:39.158	\N
52d8ed4d-9985-4649-91d3-8299ba04a84f	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10	175890	storage_billing	\N	Storage billing: 10GB for 2026-05-05T01:30:00.000Z	2026-05-05 01:30:00.058	\N
f22be9d2-d8c5-4f18-87be-2f6452dd5898	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10500	165390	compute_billing	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	Prepaid compute - Hour 2: gpu-instance-mtp3	2026-05-05 01:30:00.176	\N
28fc589f-853c-4096-860e-0490931cd16c	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	149890	compute_billing	3f659e62-8075-4437-a67b-9c9f9d07502b	Prepaid compute - Hour 2: gpu-instance-6opt	2026-05-05 01:30:00.219	\N
638a9743-9260-4375-aa61-ddcbadde8f12	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10	149880	storage_billing	\N	Storage billing: 10GB for 2026-05-05T02:30:00.000Z	2026-05-05 02:30:00.157	\N
e20b6b87-cf46-47dc-bd4b-78797dd03a2e	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10500	139390	compute_billing	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	Prepaid compute - Hour 3: gpu-instance-mtp3	2026-05-05 02:30:00.158	\N
d38164e0-3370-4ef6-bf64-776f567998b3	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	134380	compute_billing	3f659e62-8075-4437-a67b-9c9f9d07502b	Prepaid compute - Hour 3: gpu-instance-6opt	2026-05-05 02:30:00.197	\N
394eb5ac-9e48-4dba-a12f-e4036b73693c	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10	134370	storage_billing	\N	Storage billing: 10GB for 2026-05-05T03:30:00.000Z	2026-05-05 03:30:00.139	\N
ff5f6cf7-8b32-469c-834b-c3e331c0182c	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10500	123880	compute_billing	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	Prepaid compute - Hour 4: gpu-instance-mtp3	2026-05-05 03:30:00.144	\N
71e007b9-1a65-47c9-8cb7-e657587291f6	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	118870	compute_billing	3f659e62-8075-4437-a67b-9c9f9d07502b	Prepaid compute - Hour 4: gpu-instance-6opt	2026-05-05 03:30:00.174	\N
c2671cdd-f008-46fb-a408-1a85e7a66717	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10	118860	storage_billing	\N	Storage billing: 10GB for 2026-05-05T04:30:00.000Z	2026-05-05 04:38:45.443	\N
2fb8c1fd-ee51-4d39-8441-a4ce53496b29	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10500	108370	compute_billing	8eafc0ac-cd0c-4cb5-8960-618b96f862a4	Prepaid compute - Hour 5: gpu-instance-mtp3	2026-05-05 04:38:45.605	\N
f3b9be4c-2d9f-43f6-824f-3e2396ce0ca7	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	92870	compute_billing	3f659e62-8075-4437-a67b-9c9f9d07502b	Prepaid compute - Hour 5: gpu-instance-6opt	2026-05-05 04:38:47.201	\N
134ce8df-4d43-416d-ace6-f3554d79fb9e	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	77370	compute_billing	f4ebd53c-e856-43d6-b735-f72c0999c56b	Compute charge - session launch (prepaid hour 1)	2026-05-05 05:14:50.823	\N
e779d4dc-2080-45e6-b544-96db838bad7c	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	61870	compute_billing	50003a90-973a-4998-b722-4e75c934f5d3	Compute charge - session launch (prepaid hour 1)	2026-05-05 05:15:51.222	\N
14b64e17-f6a9-4a4b-bde6-1e72811c4a80	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	46370	compute_billing	21e006dd-20c2-4e16-8032-42a267f1084f	Compute charge - session launch (prepaid hour 1)	2026-05-05 05:17:12.013	\N
684f43c0-9af5-434e-b6a5-67cce89474fe	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	30870	compute_billing	d95f2adf-135b-420e-b3ff-fc150228ded8	Compute charge - session launch (prepaid hour 1)	2026-05-05 05:17:58.02	\N
982547d8-aab5-49a9-8d58-367f31534d80	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	15370	compute_billing	49b75056-41c8-4ea7-8d06-7292d3a1bff9	Compute charge - session launch (prepaid hour 1)	2026-05-05 05:18:32.906	\N
f1167eb5-264e-4b9e-87f8-e6f905e2dd37	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	credit	100000	115370	payment	39806bef-b4b7-4787-a42c-e06193df42f2	Credit recharge via Razorpay	2026-05-05 05:19:34.878	\N
1c6eab3b-1550-4053-995f-f124fc79719c	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	credit	100000	215370	payment	06b4c4a4-d419-4a01-be43-c0e2da4c079d	Credit recharge via Razorpay	2026-05-05 05:20:06.117	\N
30c65e5e-e51f-4852-8e3e-08f945a61dce	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10500	204870	compute_billing	22354ffb-9b8e-4851-b4c2-66b44b328eb3	Compute charge - session launch (prepaid hour 1)	2026-05-05 05:21:00.298	\N
cad54813-4e4d-4cbc-90f8-a780470e8118	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	189370	compute_billing	49b75056-41c8-4ea7-8d06-7292d3a1bff9	Prepaid compute - Hour 2: gpu-instance-f7a5	2026-05-05 05:30:00.069	\N
3dc7ec26-eed9-42aa-9cab-7d7afb90cd9b	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10500	178870	compute_billing	22354ffb-9b8e-4851-b4c2-66b44b328eb3	Prepaid compute - Hour 2: gpu-instance-p54r	2026-05-05 05:30:00.119	\N
69d7040b-fc8d-441e-a8c4-35d23bd70091	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10	178860	storage_billing	\N	Storage billing: 10GB for 2026-05-05T05:30:00.000Z	2026-05-05 05:30:00.184	\N
58d64369-edec-4175-9b12-1161edda27b8	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	163360	compute_billing	748e1240-b6ff-40ea-8fe6-35093a4088a9	Compute charge - session launch (prepaid hour 1)	2026-05-05 06:15:04.567	\N
238da00c-5611-4380-994b-e9e1c0695465	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	3500	159860	compute_billing	aee03291-4ca9-4613-a396-de0251fe57bf	Compute charge - session launch (prepaid hour 1)	2026-05-05 06:15:41.051	\N
525b4d83-e686-4baa-a44f-0d46ad78461c	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10500	149360	compute_billing	2d87be54-82ea-4d73-9128-262be3f3dddd	Compute charge - session launch (prepaid hour 1)	2026-05-05 06:29:20.128	\N
744d5e88-bfe7-4b57-ac79-6bbd31900da3	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	10500	138860	compute_billing	2d87be54-82ea-4d73-9128-262be3f3dddd	Prepaid compute - Hour 2: gpu-instance-wwoh	2026-05-05 06:30:00.046	\N
0b914891-76b9-4527-bd41-7c9e31108340	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	9	138851	storage_billing	\N	Storage billing: 9GB for 2026-05-05T06:30:00.000Z	2026-05-05 06:30:00.103	\N
2d82f3b3-2430-48fa-a29e-cb1fdc79a972	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	9	138842	storage_billing	\N	Storage billing: 9GB for 2026-05-05T07:30:00.000Z	2026-05-05 07:30:00.049	\N
674b95ba-7a0d-4a69-987c-2f35d160e023	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	9	138833	storage_billing	\N	Storage billing: 9GB for 2026-05-05T08:30:00.000Z	2026-05-05 08:30:50.309	\N
2b0a1138-d5d8-40fe-bf1e-2c9624fb22a3	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	15500	123333	compute_billing	a3673281-5fd2-4636-b0d9-58f475e0f82b	Compute charge - session launch (prepaid hour 1)	2026-05-05 08:41:20.122	\N
3199924e-f216-4382-96bf-ea9d4915f95d	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	9	123324	storage_billing	\N	Storage billing: 9GB for 2026-05-05T09:30:00.000Z	2026-05-05 09:30:00.041	\N
0dc0e93c-55eb-422f-892c-f08999c214f3	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	3500	119824	compute_billing	c676954a-51a2-44b7-b923-534534f320f7	Compute charge - session launch (prepaid hour 1)	2026-05-05 10:09:13.808	\N
40e58325-878e-4e02-a0fd-eb5533219a69	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	9	119815	storage_billing	\N	Storage billing: 9GB for 2026-05-05T10:30:00.000Z	2026-05-05 10:30:00.169	\N
30f235d9-bb6b-45af-aea8-5c231e500687	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	3500	116324	compute_billing	c676954a-51a2-44b7-b923-534534f320f7	Prepaid compute - Hour 2: gpu-instance-okk0	2026-05-05 10:30:00.181	\N
a6513cda-666a-4ac6-aa2f-5b059d899d98	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	9	116315	storage_billing	\N	Storage billing: 9GB for 2026-05-05T11:30:00.000Z	2026-05-05 11:30:00.088	\N
b8f7c9f2-57ab-419f-bc02-29115135d50d	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	3500	112815	compute_billing	c676954a-51a2-44b7-b923-534534f320f7	Prepaid compute - Hour 3: gpu-instance-okk0	2026-05-05 11:30:00.199	\N
936b28ad-5818-47c8-b2e4-da2b09de02d5	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	9	112806	storage_billing	\N	Storage billing: 9GB for 2026-05-05T12:30:00.000Z	2026-05-05 12:46:46.718	\N
91ce5761-96bb-4f92-bb5d-2c665d3f9269	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	9	112797	storage_billing	\N	Storage billing: 9GB for 2026-05-05T13:30:00.000Z	2026-05-05 13:34:16.794	\N
9f892c0a-0c85-4d90-8181-2c994d9b5d80	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	9	112788	storage_billing	\N	Storage billing: 9GB for 2026-05-05T14:30:00.000Z	2026-05-05 15:26:13.294	\N
ee4e28da-e998-4365-802b-bf2c0b08dd9e	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	9	112779	storage_billing	\N	Storage billing: 9GB for 2026-05-05T15:30:00.000Z	2026-05-05 15:30:04.971	\N
f0b3f429-9a94-4c02-bbcc-1615249f3ee6	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	3500	109279	compute_billing	ec3f0ced-027a-4e05-bc13-4eee83a759a0	Compute charge - session launch (prepaid hour 1)	2026-05-05 15:35:11.01	\N
dfbc0496-5d1c-4fbe-b15d-bca41b2e7b8e	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	9	109270	storage_billing	\N	Storage billing: 9GB for 2026-05-05T16:30:00.000Z	2026-05-05 16:30:00.041	\N
70a658c9-80bb-4662-9765-9ab2a55a59d9	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	3500	105779	compute_billing	ec3f0ced-027a-4e05-bc13-4eee83a759a0	Prepaid compute - Hour 2: gpu-instance-zgxl	2026-05-05 16:30:00.043	\N
61e01778-5da6-4621-bf6c-2918b580448e	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	9	109261	storage_billing	\N	Storage billing: 9GB for 2026-05-05T17:30:00.000Z	2026-05-05 17:30:00.069	\N
50ad8c8c-99c0-4f3f-b829-f5b98f4e0090	3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	debit	3500	105770	compute_billing	ec3f0ced-027a-4e05-bc13-4eee83a759a0	Prepaid compute - Hour 3: gpu-instance-zgxl	2026-05-05 17:30:00.076	\N
\.


--
-- TOC entry 6020 (class 0 OID 118686)
-- Dependencies: 248
-- Data for Name: wallets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wallets (id, user_id, balance_cents, currency, lifetime_credits_cents, lifetime_spent_cents, low_balance_threshold_cents, is_frozen, created_at, updated_at, created_by, updated_by, spend_limit_cents, spend_limit_enabled, spend_limit_period, spend_limit_consented_at, spend_limit_end_date, spend_limit_start_date, spend_limit_warning_85_sent, runway_warning_1hour_sent) FROM stdin;
ec5deedc-e3b3-4bb8-a5f9-1e990ca0a55f	a09cf71b-1e9f-4737-bfe6-e5e20ce4f389	100000	INR	100000	0	10000	f	2026-05-04 08:24:01.202	2026-05-04 08:24:01.204	\N	\N	\N	f	\N	\N	\N	\N	f	f
3f09ccb3-da55-4328-ac15-395c0e9dd106	ae95fb83-2551-437f-8fac-dcd84b751a1d	109261	INR	850000	810258	10000	f	2026-05-04 07:41:59.604	2026-05-05 17:30:00.084	\N	\N	\N	f	\N	\N	\N	\N	f	f
\.


--
-- TOC entry 5401 (class 2606 OID 118033)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 5621 (class 2606 OID 119169)
-- Name: achievements achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- TOC entry 5652 (class 2606 OID 119281)
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- TOC entry 5637 (class 2606 OID 119222)
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- TOC entry 5481 (class 2606 OID 118586)
-- Name: base_images base_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_images
    ADD CONSTRAINT base_images_pkey PRIMARY KEY (id);


--
-- TOC entry 5552 (class 2606 OID 118866)
-- Name: billing_charges billing_charges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_pkey PRIMARY KEY (id);


--
-- TOC entry 5499 (class 2606 OID 118654)
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- TOC entry 5495 (class 2606 OID 118638)
-- Name: compute_config_access compute_config_access_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_config_access
    ADD CONSTRAINT compute_config_access_pkey PRIMARY KEY (id);


--
-- TOC entry 5488 (class 2606 OID 118626)
-- Name: compute_configs compute_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_configs
    ADD CONSTRAINT compute_configs_pkey PRIMARY KEY (id);


--
-- TOC entry 5571 (class 2606 OID 118932)
-- Name: course_enrollments course_enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_pkey PRIMARY KEY (id);


--
-- TOC entry 5566 (class 2606 OID 118919)
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- TOC entry 5594 (class 2606 OID 119028)
-- Name: coursework_content coursework_content_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coursework_content
    ADD CONSTRAINT coursework_content_pkey PRIMARY KEY (id);


--
-- TOC entry 5529 (class 2606 OID 118758)
-- Name: credit_packages credit_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_packages
    ADD CONSTRAINT credit_packages_pkey PRIMARY KEY (id);


--
-- TOC entry 5437 (class 2606 OID 118448)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- TOC entry 5615 (class 2606 OID 119133)
-- Name: discussion_replies discussion_replies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_pkey PRIMARY KEY (id);


--
-- TOC entry 5611 (class 2606 OID 119117)
-- Name: discussions discussions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_pkey PRIMARY KEY (id);


--
-- TOC entry 5649 (class 2606 OID 119268)
-- Name: feature_flags feature_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_flags
    ADD CONSTRAINT feature_flags_pkey PRIMARY KEY (id);


--
-- TOC entry 5562 (class 2606 OID 118903)
-- Name: invoice_line_items invoice_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_line_items
    ADD CONSTRAINT invoice_line_items_pkey PRIMARY KEY (id);


--
-- TOC entry 5558 (class 2606 OID 118888)
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- TOC entry 5583 (class 2606 OID 118982)
-- Name: lab_assignments lab_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_assignments
    ADD CONSTRAINT lab_assignments_pkey PRIMARY KEY (id);


--
-- TOC entry 5589 (class 2606 OID 119011)
-- Name: lab_grades lab_grades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_grades
    ADD CONSTRAINT lab_grades_pkey PRIMARY KEY (id);


--
-- TOC entry 5580 (class 2606 OID 118960)
-- Name: lab_group_assignments lab_group_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_group_assignments
    ADD CONSTRAINT lab_group_assignments_pkey PRIMARY KEY (id);


--
-- TOC entry 5586 (class 2606 OID 118998)
-- Name: lab_submissions lab_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_submissions
    ADD CONSTRAINT lab_submissions_pkey PRIMARY KEY (id);


--
-- TOC entry 5577 (class 2606 OID 118948)
-- Name: labs labs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_pkey PRIMARY KEY (id);


--
-- TOC entry 5414 (class 2606 OID 118362)
-- Name: login_history login_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_pkey PRIMARY KEY (id);


--
-- TOC entry 5599 (class 2606 OID 119066)
-- Name: mentor_availability_slots mentor_availability_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_availability_slots
    ADD CONSTRAINT mentor_availability_slots_pkey PRIMARY KEY (id);


--
-- TOC entry 5602 (class 2606 OID 119083)
-- Name: mentor_bookings mentor_bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_bookings
    ADD CONSTRAINT mentor_bookings_pkey PRIMARY KEY (id);


--
-- TOC entry 5596 (class 2606 OID 119050)
-- Name: mentor_profiles mentor_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_profiles
    ADD CONSTRAINT mentor_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 5606 (class 2606 OID 119097)
-- Name: mentor_reviews mentor_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_reviews
    ADD CONSTRAINT mentor_reviews_pkey PRIMARY KEY (id);


--
-- TOC entry 5484 (class 2606 OID 118599)
-- Name: node_base_images node_base_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_base_images
    ADD CONSTRAINT node_base_images_pkey PRIMARY KEY (node_id, base_image_id);


--
-- TOC entry 5673 (class 2606 OID 120188)
-- Name: node_resource_reservations node_resource_reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_resource_reservations
    ADD CONSTRAINT node_resource_reservations_pkey PRIMARY KEY (id);


--
-- TOC entry 5477 (class 2606 OID 118572)
-- Name: nodes nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nodes
    ADD CONSTRAINT nodes_pkey PRIMARY KEY (id);


--
-- TOC entry 5627 (class 2606 OID 119195)
-- Name: notification_templates notification_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_templates
    ADD CONSTRAINT notification_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 5630 (class 2606 OID 119210)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 5541 (class 2606 OID 118813)
-- Name: org_contracts org_contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_contracts
    ADD CONSTRAINT org_contracts_pkey PRIMARY KEY (id);


--
-- TOC entry 5545 (class 2606 OID 118831)
-- Name: org_resource_quotas org_resource_quotas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_resource_quotas
    ADD CONSTRAINT org_resource_quotas_pkey PRIMARY KEY (id);


--
-- TOC entry 5416 (class 2606 OID 118366)
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- TOC entry 5466 (class 2606 OID 118534)
-- Name: os_switch_history os_switch_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_switch_history
    ADD CONSTRAINT os_switch_history_pkey PRIMARY KEY (id);


--
-- TOC entry 5408 (class 2606 OID 118369)
-- Name: otp_verifications otp_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_verifications
    ADD CONSTRAINT otp_verifications_pkey PRIMARY KEY (id);


--
-- TOC entry 5548 (class 2606 OID 118848)
-- Name: payment_transactions payment_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 5423 (class 2606 OID 118372)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 5618 (class 2606 OID 119154)
-- Name: project_showcases project_showcases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_showcases
    ADD CONSTRAINT project_showcases_pkey PRIMARY KEY (id);


--
-- TOC entry 5695 (class 2606 OID 124667)
-- Name: recommendation_sessions recommendation_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recommendation_sessions
    ADD CONSTRAINT recommendation_sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 5684 (class 2606 OID 124635)
-- Name: referral_conversions referral_conversions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_conversions
    ADD CONSTRAINT referral_conversions_pkey PRIMARY KEY (id);


--
-- TOC entry 5691 (class 2606 OID 124648)
-- Name: referral_events referral_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_events
    ADD CONSTRAINT referral_events_pkey PRIMARY KEY (id);


--
-- TOC entry 5678 (class 2606 OID 124612)
-- Name: referrals referrals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_pkey PRIMARY KEY (id);


--
-- TOC entry 5412 (class 2606 OID 118378)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 5425 (class 2606 OID 118382)
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- TOC entry 5420 (class 2606 OID 118385)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 5513 (class 2606 OID 118685)
-- Name: session_events session_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_events
    ADD CONSTRAINT session_events_pkey PRIMARY KEY (id);


--
-- TOC entry 5506 (class 2606 OID 118673)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 5667 (class 2606 OID 120086)
-- Name: storage_extensions storage_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_pkey PRIMARY KEY (id);


--
-- TOC entry 5532 (class 2606 OID 118780)
-- Name: subscription_plans subscription_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_plans
    ADD CONSTRAINT subscription_plans_pkey PRIMARY KEY (id);


--
-- TOC entry 5537 (class 2606 OID 118797)
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- TOC entry 5657 (class 2606 OID 119299)
-- Name: support_tickets support_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_pkey PRIMARY KEY (id);


--
-- TOC entry 5646 (class 2606 OID 119252)
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 5660 (class 2606 OID 119314)
-- Name: ticket_messages ticket_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_messages
    ADD CONSTRAINT ticket_messages_pkey PRIMARY KEY (id);


--
-- TOC entry 5430 (class 2606 OID 118415)
-- Name: universities universities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.universities
    ADD CONSTRAINT universities_pkey PRIMARY KEY (id);


--
-- TOC entry 5433 (class 2606 OID 118432)
-- Name: university_idp_configs university_idp_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.university_idp_configs
    ADD CONSTRAINT university_idp_configs_pkey PRIMARY KEY (id);


--
-- TOC entry 5624 (class 2606 OID 119181)
-- Name: user_achievements user_achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_pkey PRIMARY KEY (id);


--
-- TOC entry 5640 (class 2606 OID 119239)
-- Name: user_deletion_requests user_deletion_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_deletion_requests
    ADD CONSTRAINT user_deletion_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 5450 (class 2606 OID 118492)
-- Name: user_departments user_departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_departments
    ADD CONSTRAINT user_departments_pkey PRIMARY KEY (id);


--
-- TOC entry 5663 (class 2606 OID 119329)
-- Name: user_feedback user_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_pkey PRIMARY KEY (id);


--
-- TOC entry 5470 (class 2606 OID 118550)
-- Name: user_files user_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_files
    ADD CONSTRAINT user_files_pkey PRIMARY KEY (id);


--
-- TOC entry 5454 (class 2606 OID 118503)
-- Name: user_group_members user_group_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_members
    ADD CONSTRAINT user_group_members_pkey PRIMARY KEY (id);


--
-- TOC entry 5444 (class 2606 OID 118463)
-- Name: user_groups user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 5427 (class 2606 OID 118391)
-- Name: user_org_roles user_org_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_org_roles
    ADD CONSTRAINT user_org_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 5410 (class 2606 OID 118395)
-- Name: user_policy_consents user_policy_consents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_policy_consents
    ADD CONSTRAINT user_policy_consents_pkey PRIMARY KEY (id);


--
-- TOC entry 5446 (class 2606 OID 118479)
-- Name: user_profiles user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 5461 (class 2606 OID 118522)
-- Name: user_storage_volumes user_storage_volumes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_storage_volumes
    ADD CONSTRAINT user_storage_volumes_pkey PRIMARY KEY (id);


--
-- TOC entry 5405 (class 2606 OID 118398)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 5700 (class 2606 OID 129419)
-- Name: waitlist_entries waitlist_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waitlist_entries
    ADD CONSTRAINT waitlist_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 5521 (class 2606 OID 118723)
-- Name: wallet_holds wallet_holds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_pkey PRIMARY KEY (id);


--
-- TOC entry 5524 (class 2606 OID 118738)
-- Name: wallet_transactions wallet_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_transactions
    ADD CONSTRAINT wallet_transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 5517 (class 2606 OID 118709)
-- Name: wallets wallets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT wallets_pkey PRIMARY KEY (id);


--
-- TOC entry 5622 (class 1259 OID 119424)
-- Name: achievements_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX achievements_slug_key ON public.achievements USING btree (slug);


--
-- TOC entry 5650 (class 1259 OID 119438)
-- Name: announcements_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX announcements_organization_id_idx ON public.announcements USING btree (organization_id);


--
-- TOC entry 5653 (class 1259 OID 119439)
-- Name: announcements_published_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX announcements_published_at_idx ON public.announcements USING btree (published_at);


--
-- TOC entry 5632 (class 1259 OID 119429)
-- Name: audit_log_action_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_action_idx ON public.audit_log USING btree (action);


--
-- TOC entry 5633 (class 1259 OID 119428)
-- Name: audit_log_actor_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_actor_id_idx ON public.audit_log USING btree (actor_id);


--
-- TOC entry 5634 (class 1259 OID 119432)
-- Name: audit_log_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_created_at_idx ON public.audit_log USING btree (created_at);


--
-- TOC entry 5635 (class 1259 OID 119431)
-- Name: audit_log_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_org_id_idx ON public.audit_log USING btree (org_id);


--
-- TOC entry 5638 (class 1259 OID 119430)
-- Name: audit_log_resource_type_resource_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_resource_type_resource_id_idx ON public.audit_log USING btree (resource_type, resource_id);


--
-- TOC entry 5479 (class 1259 OID 119356)
-- Name: base_images_is_default_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX base_images_is_default_idx ON public.base_images USING btree (is_default);


--
-- TOC entry 5482 (class 1259 OID 119355)
-- Name: base_images_tag_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX base_images_tag_key ON public.base_images USING btree (tag);


--
-- TOC entry 5553 (class 1259 OID 119393)
-- Name: billing_charges_session_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX billing_charges_session_id_idx ON public.billing_charges USING btree (session_id);


--
-- TOC entry 5554 (class 1259 OID 120123)
-- Name: billing_charges_storage_volume_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX billing_charges_storage_volume_id_idx ON public.billing_charges USING btree (storage_volume_id);


--
-- TOC entry 5555 (class 1259 OID 119392)
-- Name: billing_charges_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX billing_charges_user_id_created_at_idx ON public.billing_charges USING btree (user_id, created_at);


--
-- TOC entry 5497 (class 1259 OID 119366)
-- Name: bookings_node_id_scheduled_start_at_scheduled_end_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bookings_node_id_scheduled_start_at_scheduled_end_at_idx ON public.bookings USING btree (node_id, scheduled_start_at, scheduled_end_at);


--
-- TOC entry 5500 (class 1259 OID 119365)
-- Name: bookings_user_id_status_scheduled_start_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bookings_user_id_status_scheduled_start_at_idx ON public.bookings USING btree (user_id, status, scheduled_start_at);


--
-- TOC entry 5492 (class 1259 OID 119364)
-- Name: compute_config_access_compute_config_id_organization_id_rol_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX compute_config_access_compute_config_id_organization_id_rol_key ON public.compute_config_access USING btree (compute_config_id, organization_id, role_id);


--
-- TOC entry 5493 (class 1259 OID 119362)
-- Name: compute_config_access_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_config_access_organization_id_idx ON public.compute_config_access USING btree (organization_id);


--
-- TOC entry 5496 (class 1259 OID 119363)
-- Name: compute_config_access_role_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_config_access_role_id_idx ON public.compute_config_access USING btree (role_id);


--
-- TOC entry 5486 (class 1259 OID 119361)
-- Name: compute_configs_is_active_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_configs_is_active_idx ON public.compute_configs USING btree (is_active);


--
-- TOC entry 5489 (class 1259 OID 119359)
-- Name: compute_configs_session_type_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_configs_session_type_idx ON public.compute_configs USING btree (session_type);


--
-- TOC entry 5490 (class 1259 OID 119358)
-- Name: compute_configs_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX compute_configs_slug_key ON public.compute_configs USING btree (slug);


--
-- TOC entry 5491 (class 1259 OID 119360)
-- Name: compute_configs_sort_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_configs_sort_order_idx ON public.compute_configs USING btree (sort_order);


--
-- TOC entry 5568 (class 1259 OID 119400)
-- Name: course_enrollments_course_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX course_enrollments_course_id_idx ON public.course_enrollments USING btree (course_id);


--
-- TOC entry 5569 (class 1259 OID 119402)
-- Name: course_enrollments_course_id_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX course_enrollments_course_id_user_id_key ON public.course_enrollments USING btree (course_id, user_id);


--
-- TOC entry 5572 (class 1259 OID 119401)
-- Name: course_enrollments_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX course_enrollments_user_id_idx ON public.course_enrollments USING btree (user_id);


--
-- TOC entry 5563 (class 1259 OID 119398)
-- Name: courses_instructor_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX courses_instructor_id_idx ON public.courses USING btree (instructor_id);


--
-- TOC entry 5564 (class 1259 OID 119397)
-- Name: courses_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX courses_organization_id_idx ON public.courses USING btree (organization_id);


--
-- TOC entry 5567 (class 1259 OID 119399)
-- Name: courses_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX courses_status_idx ON public.courses USING btree (status);


--
-- TOC entry 5591 (class 1259 OID 119411)
-- Name: coursework_content_category_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX coursework_content_category_idx ON public.coursework_content USING btree (category);


--
-- TOC entry 5592 (class 1259 OID 119412)
-- Name: coursework_content_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX coursework_content_organization_id_idx ON public.coursework_content USING btree (organization_id);


--
-- TOC entry 5527 (class 1259 OID 119381)
-- Name: credit_packages_is_active_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX credit_packages_is_active_idx ON public.credit_packages USING btree (is_active);


--
-- TOC entry 5530 (class 1259 OID 119380)
-- Name: credit_packages_sort_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX credit_packages_sort_order_idx ON public.credit_packages USING btree (sort_order);


--
-- TOC entry 5435 (class 1259 OID 119333)
-- Name: departments_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX departments_parent_id_idx ON public.departments USING btree (parent_id);


--
-- TOC entry 5438 (class 1259 OID 119332)
-- Name: departments_university_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX departments_university_id_idx ON public.departments USING btree (university_id);


--
-- TOC entry 5439 (class 1259 OID 119334)
-- Name: departments_university_id_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX departments_university_id_slug_key ON public.departments USING btree (university_id, slug);


--
-- TOC entry 5612 (class 1259 OID 119421)
-- Name: discussion_replies_author_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussion_replies_author_id_idx ON public.discussion_replies USING btree (author_id);


--
-- TOC entry 5613 (class 1259 OID 119420)
-- Name: discussion_replies_discussion_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussion_replies_discussion_id_idx ON public.discussion_replies USING btree (discussion_id);


--
-- TOC entry 5607 (class 1259 OID 119419)
-- Name: discussions_author_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussions_author_id_idx ON public.discussions USING btree (author_id);


--
-- TOC entry 5608 (class 1259 OID 119418)
-- Name: discussions_course_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussions_course_id_idx ON public.discussions USING btree (course_id);


--
-- TOC entry 5609 (class 1259 OID 119417)
-- Name: discussions_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussions_organization_id_idx ON public.discussions USING btree (organization_id);


--
-- TOC entry 5647 (class 1259 OID 119437)
-- Name: feature_flags_key_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX feature_flags_key_key ON public.feature_flags USING btree (key);


--
-- TOC entry 5556 (class 1259 OID 119394)
-- Name: invoices_invoice_number_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX invoices_invoice_number_key ON public.invoices USING btree (invoice_number);


--
-- TOC entry 5559 (class 1259 OID 119396)
-- Name: invoices_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX invoices_status_idx ON public.invoices USING btree (status);


--
-- TOC entry 5560 (class 1259 OID 119395)
-- Name: invoices_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX invoices_user_id_created_at_idx ON public.invoices USING btree (user_id, created_at);


--
-- TOC entry 5581 (class 1259 OID 119407)
-- Name: lab_assignments_lab_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lab_assignments_lab_id_idx ON public.lab_assignments USING btree (lab_id);


--
-- TOC entry 5590 (class 1259 OID 119410)
-- Name: lab_grades_submission_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX lab_grades_submission_id_key ON public.lab_grades USING btree (submission_id);


--
-- TOC entry 5578 (class 1259 OID 119406)
-- Name: lab_group_assignments_lab_id_user_group_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX lab_group_assignments_lab_id_user_group_id_key ON public.lab_group_assignments USING btree (lab_id, user_group_id);


--
-- TOC entry 5584 (class 1259 OID 119408)
-- Name: lab_submissions_lab_assignment_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lab_submissions_lab_assignment_id_idx ON public.lab_submissions USING btree (lab_assignment_id);


--
-- TOC entry 5587 (class 1259 OID 119409)
-- Name: lab_submissions_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lab_submissions_user_id_idx ON public.lab_submissions USING btree (user_id);


--
-- TOC entry 5573 (class 1259 OID 119403)
-- Name: labs_course_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX labs_course_id_idx ON public.labs USING btree (course_id);


--
-- TOC entry 5574 (class 1259 OID 119405)
-- Name: labs_created_by_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX labs_created_by_user_id_idx ON public.labs USING btree (created_by_user_id);


--
-- TOC entry 5575 (class 1259 OID 119404)
-- Name: labs_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX labs_organization_id_idx ON public.labs USING btree (organization_id);


--
-- TOC entry 5600 (class 1259 OID 119414)
-- Name: mentor_bookings_mentor_profile_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_bookings_mentor_profile_id_idx ON public.mentor_bookings USING btree (mentor_profile_id);


--
-- TOC entry 5603 (class 1259 OID 119415)
-- Name: mentor_bookings_student_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_bookings_student_user_id_idx ON public.mentor_bookings USING btree (student_user_id);


--
-- TOC entry 5597 (class 1259 OID 119413)
-- Name: mentor_profiles_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX mentor_profiles_user_id_key ON public.mentor_profiles USING btree (user_id);


--
-- TOC entry 5604 (class 1259 OID 119416)
-- Name: mentor_reviews_mentor_booking_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX mentor_reviews_mentor_booking_id_key ON public.mentor_reviews USING btree (mentor_booking_id);


--
-- TOC entry 5485 (class 1259 OID 119357)
-- Name: node_base_images_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX node_base_images_status_idx ON public.node_base_images USING btree (status);


--
-- TOC entry 5670 (class 1259 OID 120193)
-- Name: node_resource_reservations_node_id_session_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX node_resource_reservations_node_id_session_id_key ON public.node_resource_reservations USING btree (node_id, session_id);


--
-- TOC entry 5671 (class 1259 OID 120190)
-- Name: node_resource_reservations_node_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX node_resource_reservations_node_id_status_idx ON public.node_resource_reservations USING btree (node_id, status);


--
-- TOC entry 5674 (class 1259 OID 120192)
-- Name: node_resource_reservations_released_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX node_resource_reservations_released_at_idx ON public.node_resource_reservations USING btree (released_at);


--
-- TOC entry 5675 (class 1259 OID 120191)
-- Name: node_resource_reservations_session_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX node_resource_reservations_session_id_idx ON public.node_resource_reservations USING btree (session_id);


--
-- TOC entry 5676 (class 1259 OID 120189)
-- Name: node_resource_reservations_session_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX node_resource_reservations_session_id_key ON public.node_resource_reservations USING btree (session_id);


--
-- TOC entry 5473 (class 1259 OID 119352)
-- Name: nodes_hostname_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX nodes_hostname_key ON public.nodes USING btree (hostname);


--
-- TOC entry 5474 (class 1259 OID 119354)
-- Name: nodes_last_heartbeat_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nodes_last_heartbeat_at_idx ON public.nodes USING btree (last_heartbeat_at);


--
-- TOC entry 5475 (class 1259 OID 120194)
-- Name: nodes_last_resource_sync_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nodes_last_resource_sync_at_idx ON public.nodes USING btree (last_resource_sync_at);


--
-- TOC entry 5478 (class 1259 OID 119353)
-- Name: nodes_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nodes_status_idx ON public.nodes USING btree (status);


--
-- TOC entry 5628 (class 1259 OID 119426)
-- Name: notification_templates_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX notification_templates_slug_key ON public.notification_templates USING btree (slug);


--
-- TOC entry 5631 (class 1259 OID 119427)
-- Name: notifications_user_id_status_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notifications_user_id_status_created_at_idx ON public.notifications USING btree (user_id, status, created_at);


--
-- TOC entry 5539 (class 1259 OID 119386)
-- Name: org_contracts_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX org_contracts_organization_id_idx ON public.org_contracts USING btree (organization_id);


--
-- TOC entry 5542 (class 1259 OID 119387)
-- Name: org_contracts_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX org_contracts_status_idx ON public.org_contracts USING btree (status);


--
-- TOC entry 5543 (class 1259 OID 119388)
-- Name: org_resource_quotas_organization_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX org_resource_quotas_organization_id_key ON public.org_resource_quotas USING btree (organization_id);


--
-- TOC entry 5417 (class 1259 OID 118178)
-- Name: organizations_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX organizations_slug_key ON public.organizations USING btree (slug);


--
-- TOC entry 5464 (class 1259 OID 119348)
-- Name: os_switch_history_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX os_switch_history_created_at_idx ON public.os_switch_history USING btree (created_at);


--
-- TOC entry 5467 (class 1259 OID 119347)
-- Name: os_switch_history_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX os_switch_history_user_id_idx ON public.os_switch_history USING btree (user_id);


--
-- TOC entry 5546 (class 1259 OID 119389)
-- Name: payment_transactions_gateway_txn_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX payment_transactions_gateway_txn_id_key ON public.payment_transactions USING btree (gateway_txn_id);


--
-- TOC entry 5549 (class 1259 OID 119391)
-- Name: payment_transactions_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_transactions_status_idx ON public.payment_transactions USING btree (status);


--
-- TOC entry 5550 (class 1259 OID 119390)
-- Name: payment_transactions_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_transactions_user_id_created_at_idx ON public.payment_transactions USING btree (user_id, created_at);


--
-- TOC entry 5421 (class 1259 OID 118180)
-- Name: permissions_code_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX permissions_code_key ON public.permissions USING btree (code);


--
-- TOC entry 5616 (class 1259 OID 119423)
-- Name: project_showcases_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX project_showcases_organization_id_idx ON public.project_showcases USING btree (organization_id);


--
-- TOC entry 5619 (class 1259 OID 119422)
-- Name: project_showcases_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX project_showcases_user_id_idx ON public.project_showcases USING btree (user_id);


--
-- TOC entry 5693 (class 1259 OID 124679)
-- Name: recommendation_sessions_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recommendation_sessions_created_at_idx ON public.recommendation_sessions USING btree (created_at);


--
-- TOC entry 5696 (class 1259 OID 124678)
-- Name: recommendation_sessions_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recommendation_sessions_user_id_idx ON public.recommendation_sessions USING btree (user_id);


--
-- TOC entry 5685 (class 1259 OID 124674)
-- Name: referral_conversions_referral_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_conversions_referral_id_status_idx ON public.referral_conversions USING btree (referral_id, status);


--
-- TOC entry 5686 (class 1259 OID 124672)
-- Name: referral_conversions_referred_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX referral_conversions_referred_user_id_key ON public.referral_conversions USING btree (referred_user_id);


--
-- TOC entry 5687 (class 1259 OID 124673)
-- Name: referral_conversions_referrer_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_conversions_referrer_user_id_idx ON public.referral_conversions USING btree (referrer_user_id);


--
-- TOC entry 5688 (class 1259 OID 124675)
-- Name: referral_conversions_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_conversions_status_idx ON public.referral_conversions USING btree (status);


--
-- TOC entry 5689 (class 1259 OID 124677)
-- Name: referral_events_event_type_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_events_event_type_idx ON public.referral_events USING btree (event_type);


--
-- TOC entry 5692 (class 1259 OID 124676)
-- Name: referral_events_referral_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_events_referral_id_created_at_idx ON public.referral_events USING btree (referral_id, created_at);


--
-- TOC entry 5679 (class 1259 OID 124670)
-- Name: referrals_referral_code_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referrals_referral_code_idx ON public.referrals USING btree (referral_code);


--
-- TOC entry 5680 (class 1259 OID 124669)
-- Name: referrals_referral_code_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX referrals_referral_code_key ON public.referrals USING btree (referral_code);


--
-- TOC entry 5681 (class 1259 OID 124671)
-- Name: referrals_referrer_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referrals_referrer_user_id_idx ON public.referrals USING btree (referrer_user_id);


--
-- TOC entry 5682 (class 1259 OID 124668)
-- Name: referrals_referrer_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX referrals_referrer_user_id_key ON public.referrals USING btree (referrer_user_id);


--
-- TOC entry 5418 (class 1259 OID 118179)
-- Name: roles_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX roles_name_key ON public.roles USING btree (name);


--
-- TOC entry 5511 (class 1259 OID 119373)
-- Name: session_events_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX session_events_created_at_idx ON public.session_events USING btree (created_at);


--
-- TOC entry 5514 (class 1259 OID 119372)
-- Name: session_events_session_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX session_events_session_id_idx ON public.session_events USING btree (session_id);


--
-- TOC entry 5501 (class 1259 OID 119367)
-- Name: sessions_booking_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX sessions_booking_id_key ON public.sessions USING btree (booking_id);


--
-- TOC entry 5502 (class 1259 OID 119371)
-- Name: sessions_compute_config_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_compute_config_id_idx ON public.sessions USING btree (compute_config_id);


--
-- TOC entry 5503 (class 1259 OID 120196)
-- Name: sessions_instance_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_instance_name_idx ON public.sessions USING btree (instance_name);


--
-- TOC entry 5504 (class 1259 OID 119369)
-- Name: sessions_node_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_node_id_status_idx ON public.sessions USING btree (node_id, status);


--
-- TOC entry 5507 (class 1259 OID 119370)
-- Name: sessions_started_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_started_at_idx ON public.sessions USING btree (started_at);


--
-- TOC entry 5508 (class 1259 OID 120195)
-- Name: sessions_storage_mode_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_storage_mode_idx ON public.sessions USING btree (storage_mode);


--
-- TOC entry 5509 (class 1259 OID 137656)
-- Name: sessions_storage_node_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_storage_node_id_idx ON public.sessions USING btree (storage_node_id);


--
-- TOC entry 5510 (class 1259 OID 119368)
-- Name: sessions_user_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_user_id_status_idx ON public.sessions USING btree (user_id, status);


--
-- TOC entry 5665 (class 1259 OID 120089)
-- Name: storage_extensions_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX storage_extensions_created_at_idx ON public.storage_extensions USING btree (created_at);


--
-- TOC entry 5668 (class 1259 OID 120088)
-- Name: storage_extensions_storage_volume_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX storage_extensions_storage_volume_id_idx ON public.storage_extensions USING btree (storage_volume_id);


--
-- TOC entry 5669 (class 1259 OID 120087)
-- Name: storage_extensions_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX storage_extensions_user_id_idx ON public.storage_extensions USING btree (user_id);


--
-- TOC entry 5533 (class 1259 OID 119382)
-- Name: subscription_plans_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX subscription_plans_slug_key ON public.subscription_plans USING btree (slug);


--
-- TOC entry 5534 (class 1259 OID 119383)
-- Name: subscription_plans_sort_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subscription_plans_sort_order_idx ON public.subscription_plans USING btree (sort_order);


--
-- TOC entry 5535 (class 1259 OID 119385)
-- Name: subscriptions_ends_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subscriptions_ends_at_idx ON public.subscriptions USING btree (ends_at);


--
-- TOC entry 5538 (class 1259 OID 119384)
-- Name: subscriptions_user_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subscriptions_user_id_status_idx ON public.subscriptions USING btree (user_id, status);


--
-- TOC entry 5654 (class 1259 OID 119441)
-- Name: support_tickets_assigned_to_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX support_tickets_assigned_to_status_idx ON public.support_tickets USING btree (assigned_to, status);


--
-- TOC entry 5655 (class 1259 OID 119442)
-- Name: support_tickets_organization_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX support_tickets_organization_id_status_idx ON public.support_tickets USING btree (organization_id, status);


--
-- TOC entry 5658 (class 1259 OID 119440)
-- Name: support_tickets_user_id_status_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX support_tickets_user_id_status_created_at_idx ON public.support_tickets USING btree (user_id, status, created_at);


--
-- TOC entry 5644 (class 1259 OID 119436)
-- Name: system_settings_key_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX system_settings_key_key ON public.system_settings USING btree (key);


--
-- TOC entry 5661 (class 1259 OID 119443)
-- Name: ticket_messages_ticket_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ticket_messages_ticket_id_created_at_idx ON public.ticket_messages USING btree (ticket_id, created_at);


--
-- TOC entry 5431 (class 1259 OID 119330)
-- Name: universities_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX universities_slug_key ON public.universities USING btree (slug);


--
-- TOC entry 5434 (class 1259 OID 119331)
-- Name: university_idp_configs_university_id_idp_type_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX university_idp_configs_university_id_idp_type_key ON public.university_idp_configs USING btree (university_id, idp_type);


--
-- TOC entry 5625 (class 1259 OID 119425)
-- Name: user_achievements_user_id_achievement_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_achievements_user_id_achievement_id_key ON public.user_achievements USING btree (user_id, achievement_id);


--
-- TOC entry 5641 (class 1259 OID 119435)
-- Name: user_deletion_requests_scheduled_deletion_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_deletion_requests_scheduled_deletion_at_idx ON public.user_deletion_requests USING btree (scheduled_deletion_at);


--
-- TOC entry 5642 (class 1259 OID 119434)
-- Name: user_deletion_requests_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_deletion_requests_status_idx ON public.user_deletion_requests USING btree (status);


--
-- TOC entry 5643 (class 1259 OID 119433)
-- Name: user_deletion_requests_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_deletion_requests_user_id_idx ON public.user_deletion_requests USING btree (user_id);


--
-- TOC entry 5448 (class 1259 OID 119340)
-- Name: user_departments_department_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_departments_department_id_idx ON public.user_departments USING btree (department_id);


--
-- TOC entry 5451 (class 1259 OID 119341)
-- Name: user_departments_user_id_department_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_departments_user_id_department_id_key ON public.user_departments USING btree (user_id, department_id);


--
-- TOC entry 5452 (class 1259 OID 119339)
-- Name: user_departments_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_departments_user_id_idx ON public.user_departments USING btree (user_id);


--
-- TOC entry 5664 (class 1259 OID 119444)
-- Name: user_feedback_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_feedback_user_id_created_at_idx ON public.user_feedback USING btree (user_id, created_at);


--
-- TOC entry 5468 (class 1259 OID 119350)
-- Name: user_files_deleted_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_files_deleted_at_idx ON public.user_files USING btree (deleted_at);


--
-- TOC entry 5471 (class 1259 OID 119351)
-- Name: user_files_scheduled_deletion_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_files_scheduled_deletion_at_idx ON public.user_files USING btree (scheduled_deletion_at);


--
-- TOC entry 5472 (class 1259 OID 119349)
-- Name: user_files_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_files_user_id_idx ON public.user_files USING btree (user_id);


--
-- TOC entry 5455 (class 1259 OID 119343)
-- Name: user_group_members_user_group_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_group_members_user_group_id_idx ON public.user_group_members USING btree (user_group_id);


--
-- TOC entry 5456 (class 1259 OID 119342)
-- Name: user_group_members_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_group_members_user_id_idx ON public.user_group_members USING btree (user_id);


--
-- TOC entry 5457 (class 1259 OID 119344)
-- Name: user_group_members_user_id_user_group_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_group_members_user_id_user_group_id_key ON public.user_group_members USING btree (user_id, user_group_id);


--
-- TOC entry 5440 (class 1259 OID 119336)
-- Name: user_groups_department_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_groups_department_id_idx ON public.user_groups USING btree (department_id);


--
-- TOC entry 5441 (class 1259 OID 119335)
-- Name: user_groups_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_groups_organization_id_idx ON public.user_groups USING btree (organization_id);


--
-- TOC entry 5442 (class 1259 OID 119337)
-- Name: user_groups_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_groups_parent_id_idx ON public.user_groups USING btree (parent_id);


--
-- TOC entry 5428 (class 1259 OID 119445)
-- Name: user_org_roles_user_id_organization_id_role_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_org_roles_user_id_organization_id_role_id_key ON public.user_org_roles USING btree (user_id, organization_id, role_id);


--
-- TOC entry 5447 (class 1259 OID 119338)
-- Name: user_profiles_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_profiles_user_id_key ON public.user_profiles USING btree (user_id);


--
-- TOC entry 5458 (class 1259 OID 119346)
-- Name: user_storage_volumes_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_storage_volumes_created_at_idx ON public.user_storage_volumes USING btree (created_at);


--
-- TOC entry 5459 (class 1259 OID 137655)
-- Name: user_storage_volumes_node_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_storage_volumes_node_id_idx ON public.user_storage_volumes USING btree (node_id);


--
-- TOC entry 5462 (class 1259 OID 120118)
-- Name: user_storage_volumes_user_id_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_storage_volumes_user_id_name_key ON public.user_storage_volumes USING btree (user_id, name);


--
-- TOC entry 5463 (class 1259 OID 119345)
-- Name: user_storage_volumes_user_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_storage_volumes_user_id_status_idx ON public.user_storage_volumes USING btree (user_id, status);


--
-- TOC entry 5402 (class 1259 OID 118175)
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- TOC entry 5403 (class 1259 OID 118176)
-- Name: users_keycloak_sub_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_keycloak_sub_key ON public.users USING btree (keycloak_sub);


--
-- TOC entry 5406 (class 1259 OID 118177)
-- Name: users_storage_uid_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_storage_uid_key ON public.users USING btree (storage_uid);


--
-- TOC entry 5697 (class 1259 OID 129422)
-- Name: waitlist_entries_createdAt_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "waitlist_entries_createdAt_idx" ON public.waitlist_entries USING btree ("createdAt");


--
-- TOC entry 5698 (class 1259 OID 129420)
-- Name: waitlist_entries_email_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX waitlist_entries_email_idx ON public.waitlist_entries USING btree (email);


--
-- TOC entry 5701 (class 1259 OID 129421)
-- Name: waitlist_entries_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX waitlist_entries_status_idx ON public.waitlist_entries USING btree (status);


--
-- TOC entry 5519 (class 1259 OID 119377)
-- Name: wallet_holds_expires_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallet_holds_expires_at_idx ON public.wallet_holds USING btree (expires_at);


--
-- TOC entry 5522 (class 1259 OID 119376)
-- Name: wallet_holds_wallet_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallet_holds_wallet_id_status_idx ON public.wallet_holds USING btree (wallet_id, status);


--
-- TOC entry 5525 (class 1259 OID 119379)
-- Name: wallet_transactions_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallet_transactions_user_id_created_at_idx ON public.wallet_transactions USING btree (user_id, created_at);


--
-- TOC entry 5526 (class 1259 OID 119378)
-- Name: wallet_transactions_wallet_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallet_transactions_wallet_id_created_at_idx ON public.wallet_transactions USING btree (wallet_id, created_at);


--
-- TOC entry 5515 (class 1259 OID 119375)
-- Name: wallets_balance_cents_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallets_balance_cents_idx ON public.wallets USING btree (balance_cents);


--
-- TOC entry 5518 (class 1259 OID 119374)
-- Name: wallets_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX wallets_user_id_key ON public.wallets USING btree (user_id);


--
-- TOC entry 5819 (class 2606 OID 120011)
-- Name: announcements announcements_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5815 (class 2606 OID 119991)
-- Name: audit_log audit_log_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5816 (class 2606 OID 119996)
-- Name: audit_log audit_log_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5766 (class 2606 OID 119761)
-- Name: billing_charges billing_charges_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5767 (class 2606 OID 119756)
-- Name: billing_charges billing_charges_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5768 (class 2606 OID 120124)
-- Name: billing_charges billing_charges_storage_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_storage_volume_id_fkey FOREIGN KEY (storage_volume_id) REFERENCES public.user_storage_volumes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5769 (class 2606 OID 119751)
-- Name: billing_charges billing_charges_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5770 (class 2606 OID 119766)
-- Name: billing_charges billing_charges_wallet_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_wallet_transaction_id_fkey FOREIGN KEY (wallet_transaction_id) REFERENCES public.wallet_transactions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5740 (class 2606 OID 119636)
-- Name: bookings bookings_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5741 (class 2606 OID 119641)
-- Name: bookings bookings_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5742 (class 2606 OID 119631)
-- Name: bookings bookings_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5743 (class 2606 OID 119626)
-- Name: bookings bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5737 (class 2606 OID 119611)
-- Name: compute_config_access compute_config_access_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_config_access
    ADD CONSTRAINT compute_config_access_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5738 (class 2606 OID 119616)
-- Name: compute_config_access compute_config_access_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_config_access
    ADD CONSTRAINT compute_config_access_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5739 (class 2606 OID 119621)
-- Name: compute_config_access compute_config_access_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_config_access
    ADD CONSTRAINT compute_config_access_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5778 (class 2606 OID 119806)
-- Name: course_enrollments course_enrollments_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5779 (class 2606 OID 119811)
-- Name: course_enrollments course_enrollments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5774 (class 2606 OID 119801)
-- Name: courses courses_default_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_default_compute_config_id_fkey FOREIGN KEY (default_compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5775 (class 2606 OID 119791)
-- Name: courses courses_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5776 (class 2606 OID 119796)
-- Name: courses courses_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5777 (class 2606 OID 119786)
-- Name: courses courses_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5794 (class 2606 OID 119886)
-- Name: coursework_content coursework_content_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coursework_content
    ADD CONSTRAINT coursework_content_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5714 (class 2606 OID 119516)
-- Name: departments departments_head_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_head_user_id_fkey FOREIGN KEY (head_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5715 (class 2606 OID 119511)
-- Name: departments departments_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5716 (class 2606 OID 119506)
-- Name: departments departments_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5806 (class 2606 OID 119956)
-- Name: discussion_replies discussion_replies_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5807 (class 2606 OID 119946)
-- Name: discussion_replies discussion_replies_discussion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_discussion_id_fkey FOREIGN KEY (discussion_id) REFERENCES public.discussions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5808 (class 2606 OID 119951)
-- Name: discussion_replies discussion_replies_parent_reply_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_parent_reply_id_fkey FOREIGN KEY (parent_reply_id) REFERENCES public.discussion_replies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5802 (class 2606 OID 119941)
-- Name: discussions discussions_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5803 (class 2606 OID 119931)
-- Name: discussions discussions_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5804 (class 2606 OID 119936)
-- Name: discussions discussions_lab_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_lab_id_fkey FOREIGN KEY (lab_id) REFERENCES public.labs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5805 (class 2606 OID 119926)
-- Name: discussions discussions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5773 (class 2606 OID 119781)
-- Name: invoice_line_items invoice_line_items_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_line_items
    ADD CONSTRAINT invoice_line_items_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5771 (class 2606 OID 119776)
-- Name: invoices invoices_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5772 (class 2606 OID 119771)
-- Name: invoices invoices_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5788 (class 2606 OID 119856)
-- Name: lab_assignments lab_assignments_lab_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_assignments
    ADD CONSTRAINT lab_assignments_lab_id_fkey FOREIGN KEY (lab_id) REFERENCES public.labs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5792 (class 2606 OID 119881)
-- Name: lab_grades lab_grades_graded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_grades
    ADD CONSTRAINT lab_grades_graded_by_fkey FOREIGN KEY (graded_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5793 (class 2606 OID 119876)
-- Name: lab_grades lab_grades_submission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_grades
    ADD CONSTRAINT lab_grades_submission_id_fkey FOREIGN KEY (submission_id) REFERENCES public.lab_submissions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5785 (class 2606 OID 119851)
-- Name: lab_group_assignments lab_group_assignments_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_group_assignments
    ADD CONSTRAINT lab_group_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5786 (class 2606 OID 119841)
-- Name: lab_group_assignments lab_group_assignments_lab_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_group_assignments
    ADD CONSTRAINT lab_group_assignments_lab_id_fkey FOREIGN KEY (lab_id) REFERENCES public.labs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5787 (class 2606 OID 119846)
-- Name: lab_group_assignments lab_group_assignments_user_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_group_assignments
    ADD CONSTRAINT lab_group_assignments_user_group_id_fkey FOREIGN KEY (user_group_id) REFERENCES public.user_groups(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5789 (class 2606 OID 119861)
-- Name: lab_submissions lab_submissions_lab_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_submissions
    ADD CONSTRAINT lab_submissions_lab_assignment_id_fkey FOREIGN KEY (lab_assignment_id) REFERENCES public.lab_assignments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5790 (class 2606 OID 119871)
-- Name: lab_submissions lab_submissions_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_submissions
    ADD CONSTRAINT lab_submissions_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5791 (class 2606 OID 119866)
-- Name: lab_submissions lab_submissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_submissions
    ADD CONSTRAINT lab_submissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5780 (class 2606 OID 119836)
-- Name: labs labs_base_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_base_image_id_fkey FOREIGN KEY (base_image_id) REFERENCES public.base_images(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5781 (class 2606 OID 119831)
-- Name: labs labs_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5782 (class 2606 OID 119816)
-- Name: labs labs_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5783 (class 2606 OID 119826)
-- Name: labs labs_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5784 (class 2606 OID 119821)
-- Name: labs labs_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5706 (class 2606 OID 119466)
-- Name: login_history login_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5796 (class 2606 OID 119896)
-- Name: mentor_availability_slots mentor_availability_slots_mentor_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_availability_slots
    ADD CONSTRAINT mentor_availability_slots_mentor_profile_id_fkey FOREIGN KEY (mentor_profile_id) REFERENCES public.mentor_profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5797 (class 2606 OID 119901)
-- Name: mentor_bookings mentor_bookings_mentor_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_bookings
    ADD CONSTRAINT mentor_bookings_mentor_profile_id_fkey FOREIGN KEY (mentor_profile_id) REFERENCES public.mentor_profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5798 (class 2606 OID 119911)
-- Name: mentor_bookings mentor_bookings_payment_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_bookings
    ADD CONSTRAINT mentor_bookings_payment_transaction_id_fkey FOREIGN KEY (payment_transaction_id) REFERENCES public.payment_transactions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5799 (class 2606 OID 119906)
-- Name: mentor_bookings mentor_bookings_student_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_bookings
    ADD CONSTRAINT mentor_bookings_student_user_id_fkey FOREIGN KEY (student_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5795 (class 2606 OID 119891)
-- Name: mentor_profiles mentor_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_profiles
    ADD CONSTRAINT mentor_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5800 (class 2606 OID 119916)
-- Name: mentor_reviews mentor_reviews_mentor_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_reviews
    ADD CONSTRAINT mentor_reviews_mentor_booking_id_fkey FOREIGN KEY (mentor_booking_id) REFERENCES public.mentor_bookings(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5801 (class 2606 OID 119921)
-- Name: mentor_reviews mentor_reviews_reviewer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_reviews
    ADD CONSTRAINT mentor_reviews_reviewer_user_id_fkey FOREIGN KEY (reviewer_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5735 (class 2606 OID 119606)
-- Name: node_base_images node_base_images_base_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_base_images
    ADD CONSTRAINT node_base_images_base_image_id_fkey FOREIGN KEY (base_image_id) REFERENCES public.base_images(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5736 (class 2606 OID 119601)
-- Name: node_base_images node_base_images_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_base_images
    ADD CONSTRAINT node_base_images_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5834 (class 2606 OID 120197)
-- Name: node_resource_reservations node_resource_reservations_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_resource_reservations
    ADD CONSTRAINT node_resource_reservations_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5835 (class 2606 OID 120202)
-- Name: node_resource_reservations node_resource_reservations_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_resource_reservations
    ADD CONSTRAINT node_resource_reservations_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5813 (class 2606 OID 119986)
-- Name: notifications notifications_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.notification_templates(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5814 (class 2606 OID 119981)
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5763 (class 2606 OID 119736)
-- Name: org_contracts org_contracts_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_contracts
    ADD CONSTRAINT org_contracts_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5764 (class 2606 OID 119741)
-- Name: org_resource_quotas org_resource_quotas_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_resource_quotas
    ADD CONSTRAINT org_resource_quotas_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5707 (class 2606 OID 119471)
-- Name: organizations organizations_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5730 (class 2606 OID 119586)
-- Name: os_switch_history os_switch_history_new_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_switch_history
    ADD CONSTRAINT os_switch_history_new_volume_id_fkey FOREIGN KEY (new_volume_id) REFERENCES public.user_storage_volumes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5731 (class 2606 OID 119581)
-- Name: os_switch_history os_switch_history_old_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_switch_history
    ADD CONSTRAINT os_switch_history_old_volume_id_fkey FOREIGN KEY (old_volume_id) REFERENCES public.user_storage_volumes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5732 (class 2606 OID 119576)
-- Name: os_switch_history os_switch_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_switch_history
    ADD CONSTRAINT os_switch_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5703 (class 2606 OID 119451)
-- Name: otp_verifications otp_verifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_verifications
    ADD CONSTRAINT otp_verifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5765 (class 2606 OID 119746)
-- Name: payment_transactions payment_transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5809 (class 2606 OID 119966)
-- Name: project_showcases project_showcases_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_showcases
    ADD CONSTRAINT project_showcases_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5810 (class 2606 OID 119961)
-- Name: project_showcases project_showcases_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_showcases
    ADD CONSTRAINT project_showcases_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5842 (class 2606 OID 124710)
-- Name: recommendation_sessions recommendation_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recommendation_sessions
    ADD CONSTRAINT recommendation_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5837 (class 2606 OID 124685)
-- Name: referral_conversions referral_conversions_referral_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_conversions
    ADD CONSTRAINT referral_conversions_referral_id_fkey FOREIGN KEY (referral_id) REFERENCES public.referrals(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5838 (class 2606 OID 124695)
-- Name: referral_conversions referral_conversions_referred_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_conversions
    ADD CONSTRAINT referral_conversions_referred_user_id_fkey FOREIGN KEY (referred_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5839 (class 2606 OID 124690)
-- Name: referral_conversions referral_conversions_referrer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_conversions
    ADD CONSTRAINT referral_conversions_referrer_user_id_fkey FOREIGN KEY (referrer_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5840 (class 2606 OID 124705)
-- Name: referral_events referral_events_referral_conversion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_events
    ADD CONSTRAINT referral_events_referral_conversion_id_fkey FOREIGN KEY (referral_conversion_id) REFERENCES public.referral_conversions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5841 (class 2606 OID 124700)
-- Name: referral_events referral_events_referral_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_events
    ADD CONSTRAINT referral_events_referral_id_fkey FOREIGN KEY (referral_id) REFERENCES public.referrals(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5836 (class 2606 OID 124680)
-- Name: referrals referrals_referrer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_referrer_user_id_fkey FOREIGN KEY (referrer_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5705 (class 2606 OID 119461)
-- Name: refresh_tokens refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5708 (class 2606 OID 119481)
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5709 (class 2606 OID 119476)
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5751 (class 2606 OID 119676)
-- Name: session_events session_events_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_events
    ADD CONSTRAINT session_events_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5744 (class 2606 OID 119671)
-- Name: sessions sessions_base_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_base_image_id_fkey FOREIGN KEY (base_image_id) REFERENCES public.base_images(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5745 (class 2606 OID 119661)
-- Name: sessions sessions_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5746 (class 2606 OID 119656)
-- Name: sessions sessions_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5747 (class 2606 OID 119666)
-- Name: sessions sessions_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5748 (class 2606 OID 119651)
-- Name: sessions sessions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5749 (class 2606 OID 137650)
-- Name: sessions sessions_storage_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_storage_node_id_fkey FOREIGN KEY (storage_node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5750 (class 2606 OID 119646)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5830 (class 2606 OID 120100)
-- Name: storage_extensions storage_extensions_payment_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_payment_transaction_id_fkey FOREIGN KEY (payment_transaction_id) REFERENCES public.payment_transactions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5831 (class 2606 OID 120095)
-- Name: storage_extensions storage_extensions_storage_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_storage_volume_id_fkey FOREIGN KEY (storage_volume_id) REFERENCES public.user_storage_volumes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5832 (class 2606 OID 120090)
-- Name: storage_extensions storage_extensions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5833 (class 2606 OID 120105)
-- Name: storage_extensions storage_extensions_wallet_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_wallet_transaction_id_fkey FOREIGN KEY (wallet_transaction_id) REFERENCES public.wallet_transactions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5759 (class 2606 OID 119726)
-- Name: subscriptions subscriptions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5760 (class 2606 OID 119731)
-- Name: subscriptions subscriptions_payment_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_payment_transaction_id_fkey FOREIGN KEY (payment_transaction_id) REFERENCES public.payment_transactions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5761 (class 2606 OID 119721)
-- Name: subscriptions subscriptions_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.subscription_plans(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5762 (class 2606 OID 119716)
-- Name: subscriptions subscriptions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5820 (class 2606 OID 120026)
-- Name: support_tickets support_tickets_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5821 (class 2606 OID 120021)
-- Name: support_tickets support_tickets_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5822 (class 2606 OID 120036)
-- Name: support_tickets support_tickets_related_billing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_related_billing_id_fkey FOREIGN KEY (related_billing_id) REFERENCES public.billing_charges(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5823 (class 2606 OID 120031)
-- Name: support_tickets support_tickets_related_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_related_session_id_fkey FOREIGN KEY (related_session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5824 (class 2606 OID 120016)
-- Name: support_tickets support_tickets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5825 (class 2606 OID 120046)
-- Name: ticket_messages ticket_messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_messages
    ADD CONSTRAINT ticket_messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5826 (class 2606 OID 120041)
-- Name: ticket_messages ticket_messages_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_messages
    ADD CONSTRAINT ticket_messages_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.support_tickets(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5713 (class 2606 OID 119501)
-- Name: university_idp_configs university_idp_configs_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.university_idp_configs
    ADD CONSTRAINT university_idp_configs_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5811 (class 2606 OID 119976)
-- Name: user_achievements user_achievements_achievement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_achievement_id_fkey FOREIGN KEY (achievement_id) REFERENCES public.achievements(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5812 (class 2606 OID 119971)
-- Name: user_achievements user_achievements_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5817 (class 2606 OID 120006)
-- Name: user_deletion_requests user_deletion_requests_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_deletion_requests
    ADD CONSTRAINT user_deletion_requests_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5818 (class 2606 OID 120001)
-- Name: user_deletion_requests user_deletion_requests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_deletion_requests
    ADD CONSTRAINT user_deletion_requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5723 (class 2606 OID 119551)
-- Name: user_departments user_departments_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_departments
    ADD CONSTRAINT user_departments_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5724 (class 2606 OID 119546)
-- Name: user_departments user_departments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_departments
    ADD CONSTRAINT user_departments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5827 (class 2606 OID 120061)
-- Name: user_feedback user_feedback_responded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_responded_by_fkey FOREIGN KEY (responded_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5828 (class 2606 OID 120056)
-- Name: user_feedback user_feedback_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5829 (class 2606 OID 120051)
-- Name: user_feedback user_feedback_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5733 (class 2606 OID 119596)
-- Name: user_files user_files_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_files
    ADD CONSTRAINT user_files_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5734 (class 2606 OID 119591)
-- Name: user_files user_files_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_files
    ADD CONSTRAINT user_files_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5725 (class 2606 OID 119566)
-- Name: user_group_members user_group_members_added_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_members
    ADD CONSTRAINT user_group_members_added_by_fkey FOREIGN KEY (added_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5726 (class 2606 OID 119561)
-- Name: user_group_members user_group_members_user_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_members
    ADD CONSTRAINT user_group_members_user_group_id_fkey FOREIGN KEY (user_group_id) REFERENCES public.user_groups(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5727 (class 2606 OID 119556)
-- Name: user_group_members user_group_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_members
    ADD CONSTRAINT user_group_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5717 (class 2606 OID 119526)
-- Name: user_groups user_groups_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5718 (class 2606 OID 119521)
-- Name: user_groups user_groups_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5719 (class 2606 OID 119531)
-- Name: user_groups user_groups_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.user_groups(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5710 (class 2606 OID 119491)
-- Name: user_org_roles user_org_roles_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_org_roles
    ADD CONSTRAINT user_org_roles_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5711 (class 2606 OID 119496)
-- Name: user_org_roles user_org_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_org_roles
    ADD CONSTRAINT user_org_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5712 (class 2606 OID 119486)
-- Name: user_org_roles user_org_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_org_roles
    ADD CONSTRAINT user_org_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5704 (class 2606 OID 119456)
-- Name: user_policy_consents user_policy_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_policy_consents
    ADD CONSTRAINT user_policy_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5720 (class 2606 OID 129387)
-- Name: user_profiles user_profiles_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5721 (class 2606 OID 119541)
-- Name: user_profiles user_profiles_id_proof_verified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_id_proof_verified_by_fkey FOREIGN KEY (id_proof_verified_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5722 (class 2606 OID 119536)
-- Name: user_profiles user_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5728 (class 2606 OID 137645)
-- Name: user_storage_volumes user_storage_volumes_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_storage_volumes
    ADD CONSTRAINT user_storage_volumes_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5729 (class 2606 OID 119571)
-- Name: user_storage_volumes user_storage_volumes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_storage_volumes
    ADD CONSTRAINT user_storage_volumes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5702 (class 2606 OID 119446)
-- Name: users users_default_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_default_org_id_fkey FOREIGN KEY (default_org_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5843 (class 2606 OID 129423)
-- Name: waitlist_entries waitlist_entries_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waitlist_entries
    ADD CONSTRAINT "waitlist_entries_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5753 (class 2606 OID 119696)
-- Name: wallet_holds wallet_holds_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5754 (class 2606 OID 119701)
-- Name: wallet_holds wallet_holds_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5755 (class 2606 OID 119691)
-- Name: wallet_holds wallet_holds_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5756 (class 2606 OID 119686)
-- Name: wallet_holds wallet_holds_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.wallets(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5757 (class 2606 OID 119711)
-- Name: wallet_transactions wallet_transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_transactions
    ADD CONSTRAINT wallet_transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5758 (class 2606 OID 119706)
-- Name: wallet_transactions wallet_transactions_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_transactions
    ADD CONSTRAINT wallet_transactions_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.wallets(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5752 (class 2606 OID 119681)
-- Name: wallets wallets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT wallets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 6072 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2026-05-06 09:55:48

--
-- PostgreSQL database dump complete
--

\unrestrict Fze8aLozQfTNiNNR0xKHrsDIXGxeFCHUVfPDt7CFacPX7rL32woQVMlPRfeigVb

