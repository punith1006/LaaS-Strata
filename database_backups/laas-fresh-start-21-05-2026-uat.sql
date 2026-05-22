--
-- PostgreSQL database dump
--

\restrict P2i5xzdMceImuCmNfYPadx0EcUiGcflcf0agw3sgi7T2A1uzoJpAo1Vx8EnjJGE

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-05-21 20:55:29

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
-- TOC entry 6082 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- TOC entry 927 (class 1247 OID 151083)
-- Name: AuthType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."AuthType" AS ENUM (
    'university_sso',
    'public_local',
    'public_oauth'
);


ALTER TYPE public."AuthType" OWNER TO postgres;

--
-- TOC entry 930 (class 1247 OID 151090)
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
-- TOC entry 933 (class 1247 OID 151104)
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
-- TOC entry 936 (class 1247 OID 151116)
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
-- TOC entry 939 (class 1247 OID 151126)
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
-- TOC entry 942 (class 1247 OID 151140)
-- Name: ReferralRewardStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ReferralRewardStatus" AS ENUM (
    'PENDING',
    'CREDITED',
    'VOIDED'
);


ALTER TYPE public."ReferralRewardStatus" OWNER TO postgres;

--
-- TOC entry 945 (class 1247 OID 151148)
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
-- TOC entry 948 (class 1247 OID 151168)
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
-- TOC entry 951 (class 1247 OID 151196)
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
-- TOC entry 954 (class 1247 OID 151206)
-- Name: StorageBackend; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."StorageBackend" AS ENUM (
    'zfs_dataset',
    'zfs_zvol'
);


ALTER TYPE public."StorageBackend" OWNER TO postgres;

--
-- TOC entry 957 (class 1247 OID 151212)
-- Name: StorageMode; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."StorageMode" AS ENUM (
    'stateful',
    'ephemeral'
);


ALTER TYPE public."StorageMode" OWNER TO postgres;

--
-- TOC entry 960 (class 1247 OID 151218)
-- Name: StorageTransport; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."StorageTransport" AS ENUM (
    'local_zfs',
    'nvmeof_tcp'
);


ALTER TYPE public."StorageTransport" OWNER TO postgres;

--
-- TOC entry 963 (class 1247 OID 151224)
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
-- TOC entry 966 (class 1247 OID 151238)
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
-- TOC entry 969 (class 1247 OID 151248)
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
-- TOC entry 972 (class 1247 OID 151258)
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
-- TOC entry 975 (class 1247 OID 151270)
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
    updated_by uuid
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
    completed_at timestamp(3) without time zone
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
    department_id uuid
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
-- TOC entry 6001 (class 0 OID 151279)
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
\.


--
-- TOC entry 6002 (class 0 OID 151291)
-- Dependencies: 220
-- Data for Name: achievements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.achievements (id, slug, name, description, icon_url, category, criteria, points, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6003 (class 0 OID 151304)
-- Dependencies: 221
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.announcements (id, organization_id, title, body, severity, published_at, expires_at, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6004 (class 0 OID 151315)
-- Dependencies: 222
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_log (id, actor_id, actor_role, org_id, action, resource_type, resource_id, old_data, new_data, client_ip, user_agent, action_reason, request_id, created_at) FROM stdin;
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
89f6db1e-7c4e-4ba2-8992-6db46813bb48	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-18 06:45:44.512
105d9f74-6c88-48cd-9f8b-343640b99c51	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 06:46:23.954
89bff1f7-2332-4547-a2bd-07648e8deecd	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	filestore.create	storage	\N	\N	{"name": "ea10", "quotaGb": 10, "storageUid": "u_962b82c8054e7213ac9a4938"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-18 06:49:22.592
cb458a10-ee63-46b1-b887-422ea5a524da	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 07:03:13.5
c262fabc-0d47-449f-b8a6-eefe5229f26c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 07:29:34.45
3b09cdae-8f3e-4769-8b54-8abd3dcb4c8c	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-18 07:29:54.814
1655a505-9c3f-4974-bb48-9a2081805aa1	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-18 07:30:00.125
bebe351c-5dd4-4a8e-8141-eee585cd9dde	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-18 08:22:26.704
1e12c8d9-4e46-47ca-8e82-3a014a4aa2e0	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 08:22:39.848
6f3de135-cbf7-47e7-9313-b3f1ca2a3c4d	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-18 08:30:00.061
115dd67a-d882-4719-89a1-ba3bc7aa2d02	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 08:40:31.287
b64fe274-6652-4d1e-b728-0524dd9ef501	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 08:57:46.767
6a7df6c8-ff12-41c1-a014-62687f801e4e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 09:13:56.957
702ed177-23f7-43d5-9233-c62bfa516b4b	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-18 09:30:00.142
d7f6775c-898e-4e4b-b636-732f221ebe1c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 09:31:11.269
7d2b5c3b-528f-4e56-b845-6eccff91c54b	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 09:31:37.299
e1f055b2-836e-4dab-a8d9-7e30b078cdbc	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 09:57:26.374
5697e721-f3c5-4900-8b70-6b4c540ca162	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 10:01:28.038
0161e2e0-50fb-4f2b-b27b-8a6e73286152	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 10:06:47.59
be2037a3-e89f-48a7-a5c1-f5ea3e02349f	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 10:22:26.45
6a1cfbe6-252a-4825-a795-22ff6b64ed76	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-18 10:30:00.053
dc5d9e7f-2030-4760-83a6-19d03f45c6a7	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 10:39:24.228
a2780c21-4730-4e04-ac0a-dfb89eb79a1c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 10:49:20.283
c670ec8a-fbe3-49c0-bcb2-bb4d1419beb2	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	filestore.upgrade	storage	\N	\N	{"name": "ea10", "method": "in_place", "volumeId": "ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5", "newQuotaGb": 12, "storageUid": "u_962b82c8054e7213ac9a4938", "previousQuotaGb": 10}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0	success	\N	2026-05-18 10:57:53.775
161dd060-ca67-4079-b015-f76d427dd4f7	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-18 10:59:24.5
d580edc8-4d42-4f9d-85fc-2ec66152d01d	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	filestore.create	storage	\N	\N	{"name": "es1023", "quotaGb": 32, "storageUid": "u_ca53f137ba9f971180a53958"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0	success	\N	2026-05-18 11:00:52.753
86efb9b9-0cd5-4dda-b22b-fbcd1af5982c	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	filestore.delete	storage	\N	\N	{"volumeId": "593577fd-a234-4a8b-9145-b14e68d89f2f", "storageUid": "u_ca53f137ba9f971180a53958"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0	success	\N	2026-05-18 11:01:09.252
36795409-8b90-47df-90eb-eba5acf7fbe9	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	filestore.create	storage	\N	\N	{"name": "ef23", "quotaGb": 19, "storageUid": "u_7d736bf08d7ea480732f9778"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0	success	\N	2026-05-18 11:01:27.081
fcd5198c-96e6-4453-bc60-24781adcccf4	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	filestore.upgrade	storage	\N	\N	{"name": "ef23", "method": "in_place", "volumeId": "a431eb07-a71d-44f9-a0ba-ecac2480a3c2", "newQuotaGb": 26, "storageUid": "u_7d736bf08d7ea480732f9778", "previousQuotaGb": 19}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0	success	\N	2026-05-18 11:01:34.716
719335d7-d1e3-4126-a766-6f861ee16a6d	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	file.mkdir	storage	\N	\N	{"path": "/", "folderName": "zenith"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0	success	\N	2026-05-18 11:01:41.994
5e0bf390-b339-44b4-953f-e7031379128b	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	file.upload	storage	\N	\N	{"path": "/zenith", "fileName": "Claude-Ubuntu_server_installation_errors_on_external_SSD_1.pdf"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0	success	\N	2026-05-18 11:01:54.419
25c6dcda-a272-4eb5-af8c-599b99f190db	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	file.upload	storage	\N	\N	{"path": "/zenith", "fileName": "keycloak-26.2.4.zip"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0	success	\N	2026-05-18 11:02:28.18
590bf67c-f4e9-400d-b77c-24524a8f7166	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	filestore.upgrade	storage	\N	\N	{"name": "ef23", "method": "in_place", "volumeId": "a431eb07-a71d-44f9-a0ba-ecac2480a3c2", "newQuotaGb": 32, "storageUid": "u_7d736bf08d7ea480732f9778", "previousQuotaGb": 26}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0	success	\N	2026-05-18 11:02:48.331
68443686-ee87-4fbf-b09d-42a6b6131e8b	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-18 11:04:59.782
9aaf377a-d9d8-4920-bd86-d852a56c50d2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 11:05:22.382
d8a5a15e-be4f-494c-86c5-8b6f0135fa19	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 11:22:07.091
f6ab79a6-5f2b-4129-a14e-a8f8488d03ad	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-18 11:30:00.097
dda80571-92df-4843-967f-ee9e20b59b69	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-18 11:30:00.121
7de94b06-dbb3-4b94-a8b5-09e05fb93f00	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 11:43:00.527
89b82550-ef87-4c65-93a6-11bd8935d6df	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 11:58:40.932
43aef783-a6cc-4036-aeb6-fdae700489ff	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 12:21:16.657
06b1bf5a-d87e-43fc-80e1-16a13df4ea99	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-18 12:30:00.075
79d5d1d0-a201-4bd4-825c-e93d9cc59f3e	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-18 12:30:00.092
00cc7eda-1066-4bfa-b4b5-773239d55116	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 12:37:32.934
8fe88f98-edcf-46ec-9107-49a12b675563	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-18 12:39:09.001
ddadce15-d557-4975-96c4-ef4ea0bc75af	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 12:57:53.765
c6197d44-1641-4276-ac53-460e426bbf48	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-18 13:49:45.16
c234b156-f4ed-4aab-8901-e099dc3f2b99	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-18 13:49:45.19
ec40b544-376d-41bd-aff9-b199bbdb7c63	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 16:49:01.269
06dc7e0c-5010-463b-9d50-946f157d4d78	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 17:06:50.991
0e3c325b-d128-46ef-b4c7-d987e11db147	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 17:23:58.183
e934fd02-a732-4e93-87f9-b59a3b870e38	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-18 17:30:02.991
7ab21363-84f9-465b-9691-1c6615e06561	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-18 17:30:03.009
60741f93-34ea-41e7-a9db-fab2d11a2256	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 17:41:39.971
e5f88291-f2f5-48dc-b42e-f07543e90ef3	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 17:59:10.458
499ff1da-69f2-4a00-9366-d96b6cb3b39b	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 18:20:56.195
8777b5ef-a7b6-4db1-abb4-11f7b9b425aa	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-18 18:30:00.075
23fa51b0-623e-42d2-82fc-839a83453e88	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-18 18:30:00.095
dc67b382-cdbd-421b-9c69-a14588f69140	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 18:36:48.837
31a35273-c37b-43bf-a774-272d57a7ccde	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 18:58:44.704
bd5b9b42-a0f8-4520-9d9d-e6b9d7353a97	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 19:01:54.571
a97c0a86-5538-4e45-ac3e-78d4e822dc77	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 19:21:45.776
16725b79-9e66-43ad-9789-82b45f4ce3eb	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 19:22:53.065
763d9dd1-27a1-4d99-9593-e6796db904e0	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 19:25:12.742
aa9e9283-75ee-4c38-a7a3-8cc6ca1461bb	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-18 23:43:27.492
f35d772f-3f71-466b-b987-4a9b5a71ed31	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-18 23:43:28.132
6a964966-84ea-431b-a407-3d207d95fb27	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 00:11:15.104
d3bbb6c2-d64a-46fc-b1c3-f18ac72ccd70	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-19 00:15:37.141
0daf471c-f270-4473-a2ec-21b63828857b	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 00:26:51.721
d059e5d6-5d6a-469c-b6db-e44c02c4ce51	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-19 00:30:00.134
f4e897eb-e272-43a0-ae92-3558818af2fb	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-19 00:30:00.155
32fcd006-1386-46a0-a357-5fb9fa2f339a	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 00:44:15.654
8122b092-4282-4174-953c-8c2c2ed0719c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 01:00:18.159
0314e1b0-f664-40b9-8dea-13bdd7fb6cfd	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 01:19:18.315
19cbfcc6-473c-44d6-b58f-f22061395fa1	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-19 01:35:52.805
a63bbc3b-0bf6-40bd-b42e-652f2f2dda97	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 01:36:56.778
ab5614dd-e509-46b6-ad83-4f4c5a61a2c0	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-19 02:40:13.627
6a4cb9cd-dcfb-44ec-a338-ef0e95db08af	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-19 02:40:14.805
200ed5ef-79be-4474-8559-0076c2a860f0	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 02:40:40.555
4a87d45c-c247-420e-8f4c-05740e56c920	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 02:42:38.357
dc61a4b3-798d-4b18-9aa1-3850a9060fc0	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 02:47:01.02
9a843290-fe27-479f-84d4-e25bed2933b7	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 03:14:41.834
29fb28f2-a8af-4898-9f62-d4be4e3b6c8e	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-19 03:30:00.126
5be67044-165f-41b0-af35-ee4e31d8b3ff	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-19 03:30:00.151
7c8d2b97-04a4-4c1f-8e47-c40844512e81	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 03:31:31.552
d2b559b0-f8fc-4132-893a-d6e71d828d4a	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 04:25:50.505
cd10660d-c076-478b-ae55-8aa7af252a9c	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-19 04:26:54.292
7c551c31-7904-4ea5-a342-561c6657de84	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-19 04:30:00.114
0f477bc9-36db-411f-abb5-0f4e83616b39	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-19 04:30:00.136
1b00a0d3-3fbc-4434-9ad9-05c2c602ed0e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 04:50:01.331
ba8b8c5b-01d8-4673-8fa9-cef11391bfa2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 04:58:39.995
81b4f636-4154-4007-9f65-188a35763031	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 05:17:22.46
be2c1046-babf-4b6e-b240-2bcc0236556c	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-19 05:33:00.923
62497f61-1776-486a-a395-9c7430cccd30	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 05:33:14.181
cfae6756-bf07-4a49-b096-b0463276e0a1	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 05:40:16.164
fc73f910-1df9-4de3-b766-bcadcf81a7d5	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 06:01:20.282
78124d7a-5828-4069-9330-4c64a5e86604	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 06:28:50.151
bf29f211-2bfc-4b31-8659-8396975451c9	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-19 06:30:00.187
e1c870ae-1fc5-449e-93b3-d7e5b516a03c	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-19 06:30:00.219
9533c979-2a37-4adf-a398-a10e0e937efc	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 06:48:22.811
9f93351d-7a5b-4240-83c5-68234ce4fc72	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 07:03:48.927
6b39a6ee-d182-432f-8f68-bd56e7c29e4c	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-19 07:30:00.072
25a7e924-e935-4a52-932f-ba55bf9f5a93	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-19 07:30:00.092
b9f64af7-7c86-44d3-8d73-1334b8574c43	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 07:42:31.232
bfe24c43-9956-40b1-b287-4bea89bf2283	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 08:03:49.719
58d796be-4ae4-492c-acb0-ab206a6e9185	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 08:20:51.171
ef8cfc38-b857-4fb8-b91a-29223616d208	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-19 08:30:00.322
0c311c95-0cb2-4ee5-a6cc-3b044ac78bdf	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-19 08:30:00.508
e1d9ea4e-6f28-44f9-9b49-9ce8cea3abb7	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 08:30:08.839
f34bfc5b-ca7b-46a5-a744-94885ca0452d	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 08:51:03.189
d8f33900-03d7-4ced-92b8-b06d97973bbf	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 09:16:49.449
2414867f-e7f1-459c-b661-d829411a821b	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-19 09:30:00.682
7f6207bc-6f42-459d-8385-075bdf361d65	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-19 09:30:00.722
1be1c504-f9f7-43a8-831d-53b8fb6fa69e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 09:40:10.722
1fc5cf86-f8c6-46a9-8d80-371a4c53711b	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 09:59:36.379
8a6f50b0-d62f-439d-a93a-872dc4bb68d5	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 10:18:37.89
fbedaf00-3fb8-4aba-9169-c151e18d59d4	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-19 10:30:00.132
34508970-8c6a-4d18-bba5-91530dcc971f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-19 10:30:00.277
dca5e847-0635-40d9-91d3-0b039ebba9a7	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 10:33:28.667
d99ca951-6d8f-49df-b449-14425f116f2c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 10:51:21.274
585433bd-8039-439b-a3fd-6d52b90657ff	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 11:08:21.002
3f31037e-a53b-46d5-bc6c-462608318ca4	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 11:26:47.259
20fd5315-f1e2-41ee-b5ca-a3179ee8a6b3	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-19 11:30:00.129
612be6ee-9ee6-45f2-9a28-e1dda4f6bcec	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-19 11:30:00.167
98b4aa6d-73e6-4414-b157-1f0cf2bfd20c	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 11:42:36.033
ebd3e54d-10f6-4c8a-8de9-01981bd70889	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 12:03:00.131
8338b928-7a8f-47b9-af39-be440e2383ce	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-19 12:30:00.073
b3f6dcb1-b403-41a1-8bcb-9641cabd2223	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-19 12:30:00.101
3304fabe-8024-4d34-8ea7-4f144641268a	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 12:36:15.953
ab54d401-0678-46c4-8856-88385f5fa5f3	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-19 12:42:15.898
aa0fe880-5e66-4c55-885f-008223cf08c3	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-19 16:26:59.513
f0e2ef53-c599-4c25-bf05-05cdf84952c0	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-19 16:26:59.574
9e87b69e-3962-4514-a593-9b97f8ae2d37	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 16:31:38.562
c84237ec-2497-456c-a1d0-7a998d24ab35	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-19 16:33:21.405
490b1f9c-5909-4bd6-8db3-da9c49802244	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-19 17:37:21.211
e7cdd168-54e4-4fa9-a5f7-86ca7e92bbaf	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 17:45:23.153
f999ed7d-0404-425e-983c-010959e5224e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 18:16:14.963
54698fb8-b736-43d5-b424-bd26d52ea0b8	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-19 18:30:00.286
90049063-335e-4beb-bf14-a35cfb62dcbb	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-19 18:30:00.335
5b133bd3-b4ca-48fc-9b59-1d557cde0b7a	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 18:32:03.949
7a72439f-4947-47a3-983e-5cbf63940787	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 18:36:43.769
2ab1e086-f30d-4458-84dc-975ba659d9b3	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 18:53:15.809
d41e4bbd-6325-4f7c-9b8d-b817b421f4e5	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 19:09:27.866
186236fe-eaeb-46c0-babb-67f36d237eac	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 19:20:12.365
9125c2fa-c422-4a26-9e29-4142669ff507	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-19 19:30:00.139
48638e6f-1503-4a8a-952f-e8164f2c035a	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-19 19:30:00.157
997ee3dc-3eba-4fc6-8fa1-9592b196860d	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-19 19:35:22.788
48b77e36-4882-4fda-b526-7d92b536554f	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-19 23:43:32.178
7f4dad43-7923-4746-9c75-9092e4fb6906	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-19 23:43:32.725
bc257238-1f36-4093-a168-ffe4f4c8951d	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 00:25:52.88
5b899b77-e409-449d-a38a-16198f6f3654	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-20 00:30:00.212
24642a40-ced0-473b-9945-10ebc440e456	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-20 00:30:00.248
66265208-13b4-4cc4-9121-95f042eee275	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-20 00:35:37.32
e8b159b7-cac9-4e1c-91fb-251b801ac73e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 00:45:10.942
1a7a3140-221d-48ac-8d13-542c34445adc	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 01:20:45.017
e4244a50-db0f-444e-962f-8da18c3b3b43	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 01:31:18.826
33eb2ad2-3d7c-42d7-ac14-486db283f319	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 01:50:22.421
1ac3a1c1-0fc4-4aae-a1c4-ad623f9148a9	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 02:11:10.124
a63add79-6cd5-47a1-bf15-ba72689c58ee	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-20 02:30:00.674
3287a9bd-e197-403b-9a53-6f85753fc1fe	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-20 02:30:00.763
40d4dc6d-c1de-453b-b1f0-722a34cf83bb	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 02:32:06.414
ef898488-2147-4df0-bb72-a998721c8b02	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 02:52:08.366
db449f7a-229a-4755-817c-3c1beafbc8e3	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 03:28:38.655
2acc0823-b0d6-4a0e-aa68-ea05b77e65b5	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-20 03:30:00.151
ede77430-2ca7-4dcb-969d-915f94676203	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-20 03:30:00.169
c89fb713-d18e-4546-a03d-9c47ac7a8cc4	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 03:41:40.022
b42757b1-4e38-4a30-9911-37fab6941146	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-20 03:42:43.826
7e65b241-a8ec-452d-9071-b574df1fad93	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-20 04:34:12.329
85a276f9-2fd2-4d13-b27f-a65ef9abc18f	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 04:35:49.431
473070ce-c207-4c91-8421-59f019eb94d5	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-20 04:50:59.203
3e5e3331-16c5-4a34-a619-08663b981a08	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 04:54:23.863
04011477-06fe-4adb-af8e-6843c4113942	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 05:13:53.223
9b30627e-bf6b-4dfc-a824-6b0734bffd98	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 05:31:23.898
f8da447b-7572-4329-a9f3-6066a739c324	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 06:04:21.722
b7862765-74b5-456b-a6b4-40e0a3853e60	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 06:19:50.887
2ef9abad-787c-4ac4-95b1-1699fad01645	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 12}	\N	\N	success	\N	2026-05-20 06:30:00.45
243d8082-8ce3-468a-b702-14a45bec48ba	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-20 06:30:00.56
cb1cfd3b-f0f7-4d18-aada-93cbc3f252d0	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-20 06:30:14.881
6582611e-f18c-49fd-801f-8e19bb7a7f49	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	filestore.delete	storage	\N	\N	{"volumeId": "ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5", "storageUid": "u_962b82c8054e7213ac9a4938"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0	success	\N	2026-05-20 06:30:28.468
7b8991c4-6f63-4d34-a56b-6fdcc8d80c98	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	filestore.create	storage	\N	\N	{"name": "edf1", "quotaGb": 10, "storageUid": "u_80b52988266cafa9ccd98e76"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0	success	\N	2026-05-20 06:30:37.154
59ebe277-9426-4d4b-892a-7bcdb3157309	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 06:36:40.867
0e3391b7-36be-4845-8b9e-77a962fbf750	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 07:20:44.16
3137ac33-447b-4cca-8637-7e9c97f8c5b0	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-20 07:21:48.115
333280a3-e96b-49fa-8d05-b11c51161dbb	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	\N	auth.login	auth	\N	\N	{"authType": "institution_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 07:23:30.765
09c02270-14ab-45c4-a777-c538e00e2d48	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-20 07:30:00.669
6674d1df-abad-4d78-819f-6efb45e1486b	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-20 07:30:00.72
87c69d1d-e920-4ece-b252-cef774fd698a	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	filestore.create	storage	\N	\N	{"name": "ef21", "quotaGb": 16, "storageUid": "u_f15f2564a9c60fe5501e4589"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0	success	\N	2026-05-20 08:06:19.576
07d0e9c0-0aa4-4ff4-83c0-5c1c7549d01f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-20 08:30:00.075
910a5abe-ec14-41e4-bcb9-a690f00aef7f	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-20 08:30:00.106
486682c2-79b9-46eb-9809-26eb02d1d318	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 15}	\N	\N	success	\N	2026-05-20 08:30:00.127
29c78560-71cc-4a7b-8a81-c6f149d44479	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	runway.warning	billing	\N	\N	{"runwayHours": 0.78, "balanceCents": 27985, "burnRateCentsPerHour": 36015}	\N	\N	success	\N	2026-05-20 08:35:01.666
fd0c05b9-727c-4fa6-8c33-cef987a35a4e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 08:38:26.587
f9461cfe-94ef-499d-a43d-f11354aeab43	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-20 09:37:50.832
63fb8b1e-c331-43ce-87f0-9948d48e3694	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-20 09:37:51.282
2cecaf96-3aa9-4536-8f6b-7abfa728a77d	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 15}	\N	\N	success	\N	2026-05-20 09:37:51.443
4175301d-c13d-4e42-a84a-d4defa85dbe6	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 09:42:44.91
98b7ac44-f77f-4d7b-95b5-6e703b86c138	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-20 10:30:00.5
bbb05bfb-93ea-4203-b03b-1991a31bfdce	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-20 10:30:01.167
d5730e04-63bc-49e3-9e0e-4d6cc3660a23	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 15}	\N	\N	success	\N	2026-05-20 10:30:01.217
66db56e7-c8f7-43a6-88ed-e2d07a2047c5	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-20 11:30:00.288
a87930fd-7bce-4fcf-b1ed-664a304044f8	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-20 11:30:01.046
6f6f276e-004f-4464-842e-9430f855d813	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 15}	\N	\N	success	\N	2026-05-20 11:30:01.411
72a21280-d2a0-408e-bd32-ec44333a5fd3	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-20 11:30:29.413
cc5131f3-7195-496d-a395-6dfe21856464	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 11:32:06.886
93d46bae-0819-4064-aba4-1fadd730aef6	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-20 12:30:00.294
bc640c11-56cb-4b6d-8771-9f366454a236	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-20 12:30:00.357
e78687c4-7dca-4dbb-8488-55c433096177	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 15}	\N	\N	success	\N	2026-05-20 12:30:00.414
ff564128-6c61-43d7-8040-3a2c61dfb1df	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 12:41:19.16
5ad282a2-6f14-4dc7-a598-478ef8e16484	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-20 15:59:04.35
48f3d994-3e35-4bd0-a440-160442b4df56	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-20 15:59:07.048
a0affbf0-9901-4a44-9591-c7206f3f00b6	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 15}	\N	\N	success	\N	2026-05-20 15:59:07.935
8a74cb13-2156-40e7-a807-2625b5e875b8	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 16:00:39.271
6df54ac9-0e7b-4420-a1ef-6fc8d816c4ba	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-20 16:16:37.354
11763fc7-0d3f-4c55-a049-afbb44a8d219	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-20 17:01:16.577
1d4220da-c1ed-4123-a691-f6fab1f85337	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-20 17:01:18.115
4541402f-97e2-4d00-9d28-9e27d6b3c06d	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 15}	\N	\N	success	\N	2026-05-20 17:01:19.606
f69e10ea-bb0b-408a-bde8-eccabc93b4c5	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 05:04:17.884
2ee95af4-f2e6-4e4c-a572-69dd239b3ccd	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-21 05:15:20.909
38e07011-24da-4bb6-ab50-5cf6d76caf4d	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 05:17:47.13
d0ed37c6-bb64-49ad-880a-90ff6dd38c7b	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-21 05:30:00.065
77ba79a7-2893-48b6-8b74-767a093be209	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-21 05:30:00.163
3c2c145b-6e65-44a0-a038-6e66a9f97bae	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 15}	\N	\N	success	\N	2026-05-21 05:30:00.181
38fc7592-d489-4f45-8f12-da6f3819dda9	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 05:32:12.062
a8ada6d9-d3b0-4c37-bde4-25f62c490998	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 05:53:03.312
25cc5764-6406-4245-be22-bee852266adf	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 06:24:38.854
9d857e2f-58ad-48ef-8f02-491576fc0fd2	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-21 06:30:00.283
3341b0e2-5bbf-4eb3-be65-c195b7c46574	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-21 06:30:00.567
0fafbf58-6841-4fb0-a658-9cff57cb19e5	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 06:38:26.853
0dd70650-6018-4ff4-b6ec-cc2708086735	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	\N	auth.login	auth	\N	\N	{"authType": "institution_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 07:19:01.883
4327e628-e50a-4d39-9105-556907354a55	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-21 07:30:00.18
97851769-38f9-48c8-a523-90672720c893	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-21 07:30:00.275
1a7f40bf-9805-47d6-a0b5-00cbaf36e3ba	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	\N	filestore.delete	storage	\N	\N	{"volumeId": "6272b69b-c681-4cb4-b373-4a2497c56376", "storageUid": "u_bda5923e2382053b4e4493be"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0	success	\N	2026-05-21 07:34:09.941
c5cbd980-2ef5-4459-933b-ab63292ffb4f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-21 09:13:02.033
e27c8b97-21e9-4aac-8427-aa36e979d7e2	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-21 09:13:02.409
f6857fc6-e11d-43a1-9abb-d703ea7c885c	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-21 09:30:00.187
e11b2b3b-f715-4f0e-a53e-5c84c61a6738	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-21 09:30:00.216
1a9feb8c-e985-4dec-b6e0-fb0a9e827610	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-21 09:34:11.659
73c9f9b0-26d4-467b-a8f3-c03d8f34131d	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-21 10:30:00.154
883891b4-f1d0-40d6-85d6-9370d7192659	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-21 10:30:00.248
9b433d47-cfc8-4bb8-b39e-28ee54a933bd	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 10:35:57.405
4019a358-474e-4072-8444-09162d7dd72d	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-21 10:36:43.816
57cff919-4702-492b-8fc5-376945eb033b	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	\N	auth.login	auth	\N	\N	{"authType": "institution_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 10:37:20.513
35cb4929-6c9e-4ae4-8227-b341620dcbd8	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	\N	auth.login	auth	\N	\N	{"authType": "institution_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 10:38:07.56
1011b8ca-ffa7-4933-9e27-f9b30e0d9a8c	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	\N	runway.termination	billing	\N	\N	{"runwayHours": 0, "balanceCents": -86000, "burnRateCentsPerHour": 42000, "terminatedSessionIds": ["378ec15c-cec4-4864-98da-49821b126fb4", "8095cdef-8105-40bc-84a1-4510c81383d0"], "terminatedSessionCount": 2, "terminatedSessionNames": ["gpu-instance-3jnd", "gpu-instance-5bsk"]}	\N	\N	success	\N	2026-05-21 10:45:20.988
ffacd938-fc7e-433c-80fd-09a3375970c9	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	\N	auth.login	auth	\N	\N	{"authType": "institution_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 10:45:46.092
57369962-f80e-49cb-9302-a3cc9f43c642	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 10:46:05.02
4e52e419-7334-4f9e-a0a8-95546cda4656	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	\N	runway.termination	billing	\N	\N	{"runwayHours": 0, "balanceCents": -86000, "burnRateCentsPerHour": 30000, "terminatedSessionIds": ["d610682f-7028-42ca-93e2-0fbc64499b17"], "terminatedSessionCount": 1, "terminatedSessionNames": ["gpu-instance-kxeb"]}	\N	\N	success	\N	2026-05-21 10:50:03.291
2295eea4-3192-4462-bfde-86ec4c27561e	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 11:07:03.667
724e8c6c-f672-47d5-a601-ed4aa2e5f6e0	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	\N	auth.login	auth	\N	\N	{"authType": "institution_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 11:12:51.314
3e9d7636-5a48-4d8a-bdca-8e4122df4521	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	\N	filestore.delete	storage	\N	\N	{"volumeId": "7e6417b4-df49-472f-8ede-8a054ba28dbc", "storageUid": "u_113129005bb5ebde59837825"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0	success	\N	2026-05-21 11:13:16.458
99a67e44-7273-45dc-9f45-c4d6370cf8f9	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	\N	filestore.create	storage	\N	\N	{"name": "ef1", "quotaGb": 32, "storageUid": "u_685f616624c645ead71f1619"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0	success	\N	2026-05-21 11:13:26.862
46ccba4c-362f-48ba-b354-8ca47a2ea321	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 11:17:33.117
eee7a473-1b94-4829-aa1b-101f2721f682	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	\N	auth.login	auth	\N	\N	{"authType": "institution_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 11:18:56.334
e175e518-849d-4b27-8ad2-e310f5e68f27	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	\N	filestore.create	storage	\N	\N	{"name": "df2", "quotaGb": 32, "storageUid": "u_14629f52052167574ce6e80e"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0	success	\N	2026-05-21 11:24:27.889
79f8c16d-9e05-4654-9061-c642af64d541	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "studentExempt": true, "totalChargeCents": 31, "costClassification": "capex"}	\N	\N	success	\N	2026-05-21 11:30:00.195
5eabb61d-e40d-4b26-9a79-0a9ca19ba77d	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-21 11:30:00.24
ad2b0181-0838-44e9-b222-745bf80ab95b	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-21 11:30:00.267
92668b14-846f-49ac-b079-51f268df697a	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "studentExempt": true, "totalChargeCents": 31, "costClassification": "capex"}	\N	\N	success	\N	2026-05-21 11:30:00.294
14123c81-fca6-46ca-ba2e-311704b5ebb5	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 11:37:26.533
77998595-1ad9-4316-aadd-1a8638a05c17	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	\N	auth.login	auth	\N	\N	{"authType": "institution_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 11:37:54.721
addf290f-3fb0-41d7-8eed-73f78bb31584	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	\N	file.upload	storage	\N	\N	{"path": "/Videos", "fileName": "One_Dance_Velocity_Edit___ft._Jethalal_bully_maguire_etc.__onedancedrakevelocityedit_Trim.mp4"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0	success	\N	2026-05-21 11:50:07.262
f411f8a0-73d1-4a49-95f9-101122e0094e	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	\N	auth.login	auth	\N	\N	{"authType": "institution_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 12:02:02.726
3530a522-df95-4d5b-ad14-1f72351f71c2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 12:02:28.535
280ac81f-ca5c-4bb9-94ef-9a8bc80b2f0f	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 12:20:26.353
c6b68347-c70b-4ed3-b962-6a6abe4a07c1	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-21 12:29:28.825
6a8b6139-1db4-4ac9-9dfc-f8928985f428	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "studentExempt": true, "totalChargeCents": 31, "costClassification": "capex"}	\N	\N	success	\N	2026-05-21 12:30:00.07
99e2d096-6282-43da-a34c-8a812a0d71da	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-21 12:30:00.121
816756a2-5cdd-4f66-a3bc-d1d7208babf6	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-21 12:30:00.191
273be278-e25d-41b1-914c-ba30e5952644	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "studentExempt": true, "totalChargeCents": 31, "costClassification": "capex"}	\N	\N	success	\N	2026-05-21 12:30:00.238
7ef354bf-22ff-4472-bd91-920f46c00087	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "studentExempt": true, "totalChargeCents": 31, "costClassification": "capex"}	\N	\N	success	\N	2026-05-21 13:40:24.373
5d1a4956-bfc2-4392-a192-52b6c7380854	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-21 13:40:29.474
c4dbeba9-4fa2-4c50-86c3-cc71e9365172	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-21 13:40:29.888
1325739e-7c65-4dc8-afa5-5737ced33cb2	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "studentExempt": true, "totalChargeCents": 31, "costClassification": "capex"}	\N	\N	success	\N	2026-05-21 13:40:30.214
9bfd2586-ece7-4bf0-bbde-a5dd2f5c5250	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 13:53:20.193
a1afa78c-1a26-4e7d-a687-ece9630c4d47	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "studentExempt": true, "totalChargeCents": 31, "costClassification": "capex"}	\N	\N	success	\N	2026-05-21 14:30:00.175
6b1539b6-f052-49b0-812a-102aaf610a2a	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 31}	\N	\N	success	\N	2026-05-21 14:30:00.211
e63d158a-3117-40c4-87bd-bbbf3e237194	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "totalChargeCents": 10}	\N	\N	success	\N	2026-05-21 14:30:00.234
c515b253-4cea-45e6-ab9c-d71c80f00f52	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	\N	billing.charge	billing	\N	\N	{"period": "hourly", "volumeCount": 1, "studentExempt": true, "totalChargeCents": 31, "costClassification": "capex"}	\N	\N	success	\N	2026-05-21 14:30:00.26
06d9417f-c135-4365-bfff-7cff5f0816d2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 15:17:10.041
7d91e286-d4b0-45dd-a4b6-1c3f8df791e2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-21 15:18:41.87
\.


--
-- TOC entry 6005 (class 0 OID 151325)
-- Dependencies: 223
-- Data for Name: base_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.base_images (id, tag, os_name, description, size_bytes, software_manifest, is_default, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6006 (class 0 OID 151337)
-- Dependencies: 224
-- Data for Name: billing_charges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.billing_charges (id, user_id, session_id, compute_config_id, duration_seconds, rate_cents_per_hour, amount_cents, currency, wallet_transaction_id, created_at, created_by, charge_type, quota_gb, storage_volume_id, cost_classification) FROM stdin;
9aff6136-0dcd-4a1a-ad05-0439406efdd0	8d40647d-da49-4490-ada6-3bfa2205366c	c4ce3860-7509-47a7-b3d6-60592b593100	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	be097129-0649-4b3d-97b7-f1e4b314a3e2	2026-05-18 07:03:02.467	\N	compute	\N	\N	revenue
26478250-6ecb-4dc5-82c6-e4dd3e564dc5	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	85b58bf2-798b-4d9f-b180-59054ce71538	2026-05-18 07:30:00	\N	storage	10	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
e0963628-5c62-4564-8888-64ee8d436d18	8d40647d-da49-4490-ada6-3bfa2205366c	b3fb45cb-ac62-41bb-b65b-babce27a14fe	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	0fd2cc3e-21ed-4ca5-b95e-570d169b709e	2026-05-18 07:30:52.727	\N	compute	\N	\N	revenue
4803d377-3804-48cd-989c-fe91c56d9b49	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	ffc87569-0d05-45f1-96be-6ac7d1d93410	2026-05-18 07:31:29.703	\N	compute	\N	\N	revenue
83992f03-c1d0-42f1-973e-96de7860ffc4	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	7e306b63-c509-41d3-8225-de8e497bcec3	2026-05-18 08:30:00	\N	storage	10	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
8b7e65a6-b5b9-4631-aa28-ed9938c90ffa	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	22bb8e09-1706-4833-8036-c0c266454534	2026-05-18 08:30:00.1	\N	compute	\N	\N	revenue
c6d947c1-107c-48b0-8417-144bb92a9a75	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	e9ca97e7-5470-4bba-ab15-bfe439e5a783	2026-05-18 09:30:00.082	\N	compute	\N	\N	revenue
dfaece27-61ce-4243-8ec6-b2831448f411	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	71e6b3d6-f5f1-4df1-9d8e-42efea789e8c	2026-05-18 09:30:00	\N	storage	10	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
9f829a76-6d64-4c91-807a-5514eca32226	8d40647d-da49-4490-ada6-3bfa2205366c	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	f6ede85a-732b-49f9-8d87-f404b93007e4	2026-05-18 10:21:28.16	\N	compute	\N	\N	revenue
44b8a605-e131-4115-a513-1d7556315da2	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	97d73234-d5e1-4096-9a21-f7b6616c2988	2026-05-18 10:30:00	\N	storage	10	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
8307cf82-6d16-4268-b22b-c09b103f4f36	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	80b0d04d-5670-4fd0-bdb4-9a804b41e0ee	2026-05-18 10:30:00.098	\N	compute	\N	\N	revenue
42b0453e-f29f-48d5-808c-ce94d90c41c2	8d40647d-da49-4490-ada6-3bfa2205366c	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	e74a87f3-3b8f-47bb-8e3d-d836075dbab0	2026-05-18 10:30:00.116	\N	compute	\N	\N	revenue
aff35201-1f32-4e90-885b-f6006c8109c4	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	4e623047-62f4-4dab-a1ff-13d2e5c70540	2026-05-18 11:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
c15e9b70-acca-4b7e-ae55-680b6edc4144	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	9e590d3e-d7ba-408f-bda8-25da9657d3f7	2026-05-18 11:30:00.078	\N	compute	\N	\N	revenue
4d6ee51d-4fae-4976-862e-850560b9bc67	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	05e4bdfa-2a6c-4e02-b49d-3c65d0a4d0eb	2026-05-18 11:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
31d39253-f9be-4067-a653-a1bd23ee67aa	8d40647d-da49-4490-ada6-3bfa2205366c	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	f6995bc1-efa3-4b9a-a778-f02c3bef7578	2026-05-18 11:30:00.118	\N	compute	\N	\N	revenue
562bc29f-308a-4582-92b3-7d2640164ef6	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	2f1f6370-88c0-41bd-b75f-b2ea40e44a93	2026-05-18 12:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
2e13e989-01ad-492c-854e-f7e5e5a79750	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	817cdb12-c07e-4ebb-af92-d380a3c9c47e	2026-05-18 12:30:00.062	\N	compute	\N	\N	revenue
33b135de-e65d-40a3-9fa6-e847cd429f0d	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	d50b2cb7-a694-4e12-89f9-4346d6749156	2026-05-18 12:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
f583e827-29db-4a89-8e26-3d84e6cdeb5b	8d40647d-da49-4490-ada6-3bfa2205366c	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	023e8780-dced-4c09-bf69-6a96991e39b3	2026-05-18 12:30:00.089	\N	compute	\N	\N	revenue
c8b8aeba-8555-4232-a302-0abab1503f60	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	bb2d2bb6-0612-44cd-a1fb-156ebc4960fd	2026-05-18 13:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
aa114238-2fa8-4f58-92e1-813ca0bc8f88	8d40647d-da49-4490-ada6-3bfa2205366c	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	927af7cf-a7fb-47b6-b09a-19a5101a7e29	2026-05-18 13:49:45.016	\N	compute	\N	\N	revenue
34428601-fa2d-4e2a-8d8c-4edd2dd3d56e	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	5201fdf5-3e55-4b5f-822a-785db5d37c53	2026-05-18 13:49:45.175	\N	compute	\N	\N	revenue
32987d88-88fc-40c3-b831-dbf3c3181e37	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	90677aa1-35c6-45d6-903c-26d2c21334f8	2026-05-18 13:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
cfb6e47c-8da4-44af-b920-d23a46a6233e	8d40647d-da49-4490-ada6-3bfa2205366c	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	7334	36000	108000	INR	5cb0b434-2c2a-4f3e-b899-064b27205268	2026-05-18 17:23:42.447	\N	compute	\N	\N	revenue
288301bb-6dfa-4516-8c82-cd23ec288402	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	5e2676a9-c06a-4a3b-868e-228fef183e41	2026-05-18 17:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
2a0d08cd-2b65-402b-a6de-10feb702ab17	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	ba7d126b-3c44-4d7a-9c07-744300cb933e	2026-05-18 17:30:02.973	\N	compute	\N	\N	revenue
5138cf5f-3208-4e5b-9b48-bf7e4a315928	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	20416aa7-7a4a-461d-a37e-5a790862b5af	2026-05-18 17:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
1b9fbe69-5ad2-4442-a9f6-f781e56190f2	8d40647d-da49-4490-ada6-3bfa2205366c	968bf735-3894-4093-838d-efb4a943315d	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	6a9e8572-81c2-4cd4-8e56-18f24ab8ae9b	2026-05-18 17:36:54.668	\N	compute	\N	\N	revenue
d38370ea-a55a-48ef-9f6b-26889b84d2ca	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	88dfec6e-a3d2-4337-8cab-11fd6edc1762	2026-05-18 18:04:26.451	\N	compute	\N	\N	revenue
63942614-39e5-420f-bd7c-19e56d262dff	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	d1136ac4-8332-4743-9626-b37b5fd2530d	2026-05-18 18:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
3afd1e4d-614b-48ea-a05e-96d34a219ef9	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	dd591601-26ea-4199-9783-e6a21f1cf641	2026-05-18 18:30:00.059	\N	compute	\N	\N	revenue
fa9da5c0-b914-4686-a8da-391ee520fa65	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	08bbc186-5e21-42de-9d7f-9d251bb790c8	2026-05-18 18:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
87ab8e76-ead6-4c92-950e-e70c18a73b9f	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	72535ca4-90f8-434f-bdda-8e887b531586	2026-05-18 18:30:00.265	\N	compute	\N	\N	revenue
5cc1d418-cee5-4e46-ae1b-2c57df0c7748	8d40647d-da49-4490-ada6-3bfa2205366c	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	5c23022a-08d7-4e90-872f-eaa2fe0f3dcb	2026-05-18 18:37:54.466	\N	compute	\N	\N	revenue
8501c577-f596-4976-9cf5-1a67868725a9	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	a3a7f84c-5f18-4ee4-a436-f40d2e3f284d	2026-05-18 20:01:14.479	\N	compute	\N	\N	revenue
0db4bd3c-e174-42f5-aaa1-48bfe23c3a6c	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	3da970c0-ad0a-4436-b537-ffb2c91533a3	2026-05-18 20:01:14.556	\N	compute	\N	\N	revenue
9a4dfe10-87fa-41c0-9115-6eaf64c6420f	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	aca4a607-110c-4b3e-be3a-34f7a3ce6902	2026-05-18 23:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
ee68e16e-99bd-495b-ad88-3ddfcf60bd07	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	51833ecb-ee18-4602-bf03-120e2e9d0475	2026-05-18 23:43:25.807	\N	compute	\N	\N	revenue
dbc0116f-38ca-40cf-bbc2-158133dd2cca	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	f352de78-4f29-4f5c-830f-71eb5e063b58	2026-05-18 23:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
6f7f6c23-265c-441a-82e0-bf49caee7add	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	868b9e04-5e33-4f8b-b740-aa984cf78f04	2026-05-18 23:43:27.674	\N	compute	\N	\N	revenue
6f0f8230-e509-4198-a3e8-b5e5ed555ae0	8d40647d-da49-4490-ada6-3bfa2205366c	aef9cfcc-1747-4572-933e-6cf55bce8993	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	5b26385a-ee40-49ee-8653-a2f95db3d137	2026-05-19 00:22:22.471	\N	compute	\N	\N	revenue
c60c09a9-4f9a-4e5a-8a0a-5e2b95e07624	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	21115	12000	72000	INR	7f4f33a4-fa4e-4805-b994-fd00098ce259	2026-05-19 00:23:24.88	\N	compute	\N	\N	revenue
6c894450-96de-4fcf-ba0c-85d000e7d006	8d40647d-da49-4490-ada6-3bfa2205366c	fae608c4-ed05-41cd-b0b6-4134aaaa6354	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	ab6cae58-3e38-4038-92c9-d44223cc5167	2026-05-19 00:24:59.892	\N	compute	\N	\N	revenue
e3765c2e-b249-40f5-bd38-6b8b92a9f0bf	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	054ede88-4b1e-4092-9a71-9f0f1a29ab0d	2026-05-19 00:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
970fb468-bd6a-4475-927c-47a16ee0606c	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	354d900b-ade1-4fff-82c8-eeae2cb8b476	2026-05-19 00:30:00.116	\N	compute	\N	\N	revenue
a711972f-60e2-4a3a-9eb8-4fe4894959bc	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	d49fdb45-e04b-458d-9ad1-0701477ebc4f	2026-05-19 00:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
c2bc3dc1-1b49-4d91-b447-76d7cff0d33e	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	4318a73b-e913-40ab-abbf-8d502d358680	2026-05-19 02:40:11.471	\N	compute	\N	\N	revenue
6584643a-6322-4ed3-80c6-01a853a8c7d7	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	6e10d9d0-b09b-4a2e-ab00-38c16b568678	2026-05-19 02:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
2e50b104-6d3d-4658-9d32-2323c6855669	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	466b8f63-dded-4416-aa9c-6ac259cde1d7	2026-05-19 02:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
12eb6b29-99b1-48bd-a29d-d8c2929e61a5	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	8c9ff06f-db7c-4578-a386-14fccc035b9f	2026-05-19 03:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
b509c1cf-8a62-4b8f-aa1f-8e2afa6e86d5	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	865d4e85-0757-4df2-a40b-e3bedf7b00e7	2026-05-19 03:30:00.106	\N	compute	\N	\N	revenue
b3f04ac7-1f09-44fe-a1be-64ae7a95dad0	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	e65b8210-dac0-496c-83ef-eee052485b99	2026-05-19 03:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
a7bee3f5-5148-4131-bec6-a599ea651dc6	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	dcddb480-4076-416b-b803-863395e2028a	2026-05-19 04:28:15.245	\N	compute	\N	\N	revenue
603bbeaa-5749-49f9-a90c-70093823d351	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	f7a275ca-a7e4-404c-8dad-da3fbe74f199	2026-05-19 04:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
d7767412-65bc-4bf2-b094-58ef2b02cb4c	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	8bd8cac0-6d64-4128-85c1-f122f0e0d5c0	2026-05-19 04:30:00.121	\N	compute	\N	\N	revenue
286cb7f8-97e4-48c2-bddb-9fa9086d52d6	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	994a4649-0226-4d3d-9ffc-7fc62438f4bf	2026-05-19 04:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
3747f1e6-3594-4db7-9291-43722c50e458	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	66116fe8-95b1-432d-a94b-f61f5427b0e8	2026-05-19 04:30:00.153	\N	compute	\N	\N	revenue
3202de29-aab2-410e-a786-46df02f1d13c	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	0382d574-7e61-438d-9735-1c475a92697f	2026-05-19 06:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
04b99e86-03b2-49ba-96dd-a981f2e36fe1	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	bf61169f-f273-406e-8257-a82bd00edb57	2026-05-19 06:30:00.157	\N	compute	\N	\N	revenue
fefa75f9-cd20-4433-af86-46d7c4027297	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	fc40d17e-28db-4cc5-a0b5-5b84896d4672	2026-05-19 06:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
db0005f0-882d-477f-a2ad-7a10e5b087b5	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	49d9ae9f-5411-4bc6-9740-6bcbe85a87b2	2026-05-19 06:30:00.22	\N	compute	\N	\N	revenue
0788fa58-28ae-4384-884f-53b581a95da2	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	47b876af-797e-4ccf-a771-fcfb9d76e829	2026-05-19 07:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
524870d2-0fc9-4aea-b8eb-cfb60b3a37f5	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	4c06a6f9-6d84-45f0-9ad0-aa59d0688313	2026-05-19 07:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
b66f7bd3-842b-4df8-9920-c97570b49378	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	5f1b9e37-50a9-4ce6-a6de-97050149371c	2026-05-19 07:30:00.129	\N	compute	\N	\N	revenue
b6fa1285-6e7b-4cb8-b616-c89757b73535	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	743050bc-0fad-459b-a3ca-7b420d2ac661	2026-05-19 07:30:00.151	\N	compute	\N	\N	revenue
4c117495-2b7e-4109-8146-13c928867702	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	c46d8016-f4f5-4376-ba5c-adc98e9d8a12	2026-05-19 08:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
31e823a9-a698-4d8b-bfe1-f2f8b8366bc5	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	93b1ba31-9780-4e93-a584-cf0f9f3868c3	2026-05-19 08:30:00.271	\N	compute	\N	\N	revenue
bfab0d88-1e76-4310-8159-2cd246b80fc0	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	be2f3184-0644-4cf4-9b65-b785e4fd4f08	2026-05-19 08:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
2b6bfe18-2120-44bf-902d-8e517f04c193	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	c65a516b-1df5-42c9-9120-344b3d328b55	2026-05-19 08:30:00.619	\N	compute	\N	\N	revenue
23bd6366-3c1d-4d2d-a1f6-626e32abe10e	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	a5794900-4ae4-4622-876e-c39df3dca7cf	2026-05-19 09:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
e9c8a851-e873-4ba0-ae10-577fdb859581	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	585ba430-8b72-4af2-af16-c5320da4271d	2026-05-19 09:30:00.695	\N	compute	\N	\N	revenue
af65ce7e-9828-4e9d-a56e-911ed78d9b66	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	207ed39a-ffb2-492b-9d15-75c4a3e6b516	2026-05-19 09:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
2fd264f1-45a2-41e9-b561-033287ee5390	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	0e2699c3-4221-4135-887b-b311533f631a	2026-05-19 09:30:00.751	\N	compute	\N	\N	revenue
899d4953-89e1-4ad7-b156-40296629527e	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	750e0f6c-bffd-4738-b040-d1927275497e	2026-05-19 10:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
14a4e1ab-51cb-4ed3-b037-c6bfbb3cb90b	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	10aacb5a-1063-4b41-ba1b-a0eaf6533220	2026-05-19 10:30:00.109	\N	compute	\N	\N	revenue
0faf4f63-25e1-4180-b963-0f0e138c9346	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	4ed86f5d-3c13-4188-b315-0fbde206c4e5	2026-05-19 10:30:00.256	\N	compute	\N	\N	revenue
c95fa3bc-8a76-4962-8b5c-0376beee2271	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	46e3f404-f651-4710-9e27-556f067a4f74	2026-05-19 10:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
49d1bcc4-31fc-407e-ade1-57667f6919ca	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	dff6e54a-0cad-4676-a3f2-93e39576e9ed	2026-05-19 11:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
17961b7f-f8c7-4f36-b35c-86af0adaf323	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	f5811d7c-d39f-4a91-8c1e-4ffd3622c643	2026-05-19 11:30:00.105	\N	compute	\N	\N	revenue
6e39c872-5ee7-4367-a17b-ee43e6346966	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	5d783f20-c65e-4950-9001-1924598a8580	2026-05-19 11:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
f73912ab-8597-4178-98fd-f21ddab39d14	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	492f1fda-b9c3-4448-9417-82f1cf4b81c0	2026-05-19 11:30:00.151	\N	compute	\N	\N	revenue
302431f1-000e-49a9-9ae6-6b8ce77d59fd	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	322010f3-bbe3-447b-8f55-6aeac4ceb49a	2026-05-19 12:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
2a1ebabe-3ec0-4786-ba76-69d89f12bede	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	b6efdb92-debe-4e09-8ba1-e117b1393d5f	2026-05-19 12:30:00.061	\N	compute	\N	\N	revenue
4d3c772f-990e-4e49-8ffc-29e839c33c24	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	f8d80c09-077d-420c-8961-5c002b00189c	2026-05-19 12:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
06999b5a-f6fb-4140-b3e8-e0c944780ca1	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	146d1f04-5ae7-4ad7-aa0b-56cddc589ede	2026-05-19 12:30:00.161	\N	compute	\N	\N	revenue
4d48a15a-2a77-4967-8410-d66803a8cf83	8d40647d-da49-4490-ada6-3bfa2205366c	7c24eb9b-cef9-43c9-9874-220745bc7662	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	cf7221db-cf11-4d76-a405-6c0daf76f488	2026-05-19 12:43:34.723	\N	compute	\N	\N	revenue
8496fdfb-cbe9-4677-aed1-640034a192dd	8d40647d-da49-4490-ada6-3bfa2205366c	7c24eb9b-cef9-43c9-9874-220745bc7662	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	a7de1322-75dd-48cc-b1f1-8898860ad232	2026-05-19 16:26:59.02	\N	compute	\N	\N	revenue
ea0482bc-dec7-4767-90c5-b13224c9089f	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	96c4fb19-759e-4022-941e-9c725d9244c7	2026-05-19 15:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
33cb4807-fd75-4850-8b4c-71844b87da76	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	37f251ab-a30d-4180-990a-3e42d59fdb1a	2026-05-19 16:26:59.521	\N	compute	\N	\N	revenue
0549a589-8fa3-45b8-9fca-30bbb37d8f73	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	7f195ac7-7a53-40d4-8227-d2dc86365c4c	2026-05-19 15:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
0a4c7619-40e5-4568-9280-243be5246777	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	a83eb2b3-0089-487f-8573-9745561f7dc8	2026-05-19 16:26:59.801	\N	compute	\N	\N	revenue
6051fa68-3cd2-4fd7-946e-3672b4ce208f	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	7535	30000	90000	INR	297bbb7a-fec5-4308-9dd7-b8dfabfaa6c0	2026-05-19 16:33:50.158	\N	compute	\N	\N	revenue
ab79feaa-6d3f-4c08-9ab7-3728605138b0	8d40647d-da49-4490-ada6-3bfa2205366c	7c24eb9b-cef9-43c9-9874-220745bc7662	d2fb06af-8256-4105-812b-05a10cbe99a1	6645	12000	24000	INR	eb9162b2-01c8-410a-b414-ff73dd1dbbde	2026-05-19 16:34:20.172	\N	compute	\N	\N	revenue
2e43d21e-8ff7-4787-b058-699cee40497d	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	a063461d-7873-4614-9c2f-2149f7da0d7a	2026-05-19 18:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
7377f30b-8cde-4937-af86-a4e51773c3e0	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	9be4dc7c-1162-46d2-bbe6-c748901b518d	2026-05-19 18:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
d8e96309-370d-4635-91f4-0dbe170fa684	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	4e3ad535-ff28-421b-b6d6-5cd7143c85c1	2026-05-19 18:30:00.436	\N	compute	\N	\N	revenue
b64b899d-58f1-4e4d-8554-9dd00b34df0b	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	c2549ddf-3522-4dfb-ac48-dae0e82735de	2026-05-19 19:30:00.08	\N	compute	\N	\N	revenue
c4cfb9e2-00d2-491a-8db3-897509d234a6	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	eaccc32b-6c50-4113-b8ae-fa02624065bd	2026-05-19 19:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
1b56738e-e9b6-454e-836c-5cda220f7378	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	7aacf6f6-7394-472d-b362-5a031bdd0d74	2026-05-19 19:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
8df4339f-11bf-4c7c-89e7-acb5542773b2	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	878a6aec-4573-4d7d-a318-91d8065e76a1	2026-05-19 23:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
f98ff522-6f85-44bc-8d83-be707c02d4b0	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	a46d7dc6-6742-4541-ab8e-534acbb5fe45	2026-05-19 23:43:31.78	\N	compute	\N	\N	revenue
3085ebbe-45cf-4194-adc6-70819ec5d71d	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	4a500327-744d-46a4-b462-16095617b7a5	2026-05-19 23:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
523167ec-b6f0-4013-b29c-ff3f9e3aead8	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	7dc143ea-cddf-43d6-b7c7-f6a7e4195fbd	2026-05-20 00:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
e8322a66-f21e-4cd4-9480-8989adf0492a	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	55231e39-4358-49a0-98b3-46932b601c58	2026-05-20 00:30:00.189	\N	compute	\N	\N	revenue
af441d7c-f998-4a0b-9269-992842de257f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	6e4806ad-e06a-479f-bf9c-951a035ee786	2026-05-20 00:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
d7007015-88cc-4150-bed8-4a489935ff9b	8d40647d-da49-4490-ada6-3bfa2205366c	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	85ca5903-22c7-45f4-bce4-7a3e6d68dad1	2026-05-20 00:43:24.767	\N	compute	\N	\N	revenue
fff86ff2-4760-415a-801b-29dbc9092d99	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	ea1c66d4-2c87-4fe2-8234-f04e5c5fa663	2026-05-20 02:30:00.576	\N	compute	\N	\N	revenue
815013d3-1c08-4f72-ba21-c218f0a523e2	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	18faeb10-6813-4e3e-841e-2650736cf4fd	2026-05-20 02:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
8072a753-5027-4030-b8bd-f7c16211849c	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	ddd2d087-44d3-45b0-b1c1-57c145654918	2026-05-20 02:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
97e9c3dd-1cca-4462-bc5b-270cd9e7ee00	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	70e407b6-56ca-4c6b-b2b7-911708bf5c2f	2026-05-20 03:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
5b355f45-db7c-4615-8112-8e6c8dd2d471	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	0abdbb25-1345-456e-beca-dcbec82e9ef7	2026-05-20 03:30:00.134	\N	compute	\N	\N	revenue
d2df4d7f-bdec-420a-8206-606695232c1b	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	ceaf37cf-ebc4-42d3-a4de-992cfc8af224	2026-05-20 03:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
ca625de5-66ee-41c2-8898-37e9464e6d02	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	347113d1-3572-433d-9f94-924a3a5b0b26	2026-05-20 06:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	revenue
6b897c61-67dc-451b-945d-75933e36e8f0	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	1f47dc00-7a93-49af-ae86-d59b40e56a62	2026-05-20 06:30:00.517	\N	compute	\N	\N	revenue
cda03308-a35a-44e3-a82f-f1f1ae154e87	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	b958a7cb-0b3f-49bb-a4e0-8cfd097c520c	2026-05-20 06:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
3fd017e3-ff2d-4dbf-b329-1262c0099e13	8d40647d-da49-4490-ada6-3bfa2205366c	a580b232-5224-4c8e-b8b5-a1cf39642e0c	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	b601b285-6b6c-437b-8f77-061364eb82f3	2026-05-20 06:31:20.439	\N	compute	\N	\N	revenue
8a4a3613-60ab-493c-8634-a01e3c2be7ac	8d40647d-da49-4490-ada6-3bfa2205366c	c5925ef4-d5dd-4551-9165-50ce29fac9ff	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	3d7e37ae-b52d-4ca3-a97d-e509bee96245	2026-05-20 06:32:15.533	\N	compute	\N	\N	revenue
f4eb4588-6078-451b-9e89-98a79353dcb7	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	f644f81d-3b03-46c3-bfdb-d098923af02c	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	62623c8b-8195-4da9-a86f-c602b9936688	2026-05-20 06:36:21.219	\N	compute	\N	\N	revenue
d20149cf-d4ae-4d3a-9d5a-6e503d68a931	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	51449	12000	180000	INR	e1debadb-631e-4a5e-aab6-2f8a570fc879	2026-05-20 07:21:56.427	\N	compute	\N	\N	revenue
2d3075fa-3d92-4747-a7cb-4cd01917bf9b	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	b7d2dae0-6283-46d3-8ac0-37d5e793a3e3	2026-05-20 07:22:38.968	\N	compute	\N	\N	revenue
36e86788-bd6e-483a-802a-94c412269589	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	00024efe-65d2-46ea-9929-36cc2a737aac	2026-05-20 07:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
5d6253aa-12aa-4a59-8258-39c78d626c91	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	4968cea9-ab22-4f86-9cc2-48a0b865931a	2026-05-20 07:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
dbdb5406-1e47-4755-aa07-51275a5c8d72	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	f644f81d-3b03-46c3-bfdb-d098923af02c	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	ed747fae-77fa-40b1-91a6-124e6943128c	2026-05-20 07:30:01.388	\N	compute	\N	\N	revenue
21e12a11-9eee-4c13-a57b-7d1809d1a912	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	982f085d-1528-4f2b-a0c7-5581ec69b736	2026-05-20 07:30:01.525	\N	compute	\N	\N	revenue
52abd8e3-d695-4947-ada4-3b96b209042d	f3a5cce9-059c-4828-ac18-61164c28e868	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	d5ae54f3-ab66-4cf7-9ace-2b6c75755a13	2026-05-20 08:11:44.123	\N	compute	\N	\N	revenue
938490ef-c409-4078-9b7b-beb572d5a488	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	e0df6974-137a-48b0-b97a-e04c0be7789e	2026-05-20 08:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
a90153f1-eee6-4db1-ad19-becdc05d4594	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	f644f81d-3b03-46c3-bfdb-d098923af02c	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	5afbddb6-6575-40b9-8d5b-0614fe7b95d3	2026-05-20 08:30:00.065	\N	compute	\N	\N	revenue
0a90efc3-7c53-4a19-9e30-cef7d195d382	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	37558755-0a23-4324-a98e-a0158ff6ea53	2026-05-20 08:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
9a1d8a03-fd92-4231-aebd-d0759a3210e3	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	ca2ed591-641e-4430-803b-714304f19aec	2026-05-20 08:30:00.113	\N	compute	\N	\N	revenue
33bf88b5-9114-4c57-b21a-5b0953fcac6b	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	3600	15	15	INR	c402c484-6a97-4b36-ba2d-0d4f08fa1c92	2026-05-20 08:30:00	\N	storage	16	b263377c-f35a-4a23-b6f9-761257b978a5	revenue
37992988-3c86-47ce-ad45-461aa32336d6	f3a5cce9-059c-4828-ac18-61164c28e868	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	ed3e3687-7fcf-482f-88ac-923adc7184ec	2026-05-20 08:30:00.139	\N	compute	\N	\N	revenue
0e50d352-60e0-4889-af79-9fe1609c168e	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	e95d6edc-e319-41a7-8b43-985324036365	2026-05-20 09:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
85b761ab-2411-46a1-a652-2ff8f9bbd555	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	f644f81d-3b03-46c3-bfdb-d098923af02c	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	971b7cfd-e040-4973-bfaf-887fb7fd0a59	2026-05-20 09:37:51.04	\N	compute	\N	\N	revenue
32e34888-42e1-481f-940f-912a2b002438	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	a450e359-8858-4179-9420-753aad8513d3	2026-05-20 09:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
2424f502-3174-427b-9993-811d222d54be	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	3600	15	15	INR	17605d96-4a21-48c3-aeed-5f1063539323	2026-05-20 09:30:00	\N	storage	16	b263377c-f35a-4a23-b6f9-761257b978a5	revenue
abcfa52a-314e-4265-b9f0-fcea2dc29a49	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	9e5e37ab-e18b-4c66-b880-dba8e3a31b08	2026-05-20 09:37:51.492	\N	compute	\N	\N	revenue
68c2d415-cc11-4729-a5bd-5af9f365ae28	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	62797f84-b1e1-4335-a48f-b7b9cbfc1f11	2026-05-20 10:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
a8e08539-81d6-4d3d-8506-8553836557aa	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	f644f81d-3b03-46c3-bfdb-d098923af02c	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	03e8a5b0-023d-48d7-bc07-9bd35eca1349	2026-05-20 10:30:00.505	\N	compute	\N	\N	revenue
92ed0291-f493-48e6-b2c4-634b6e649622	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	4b97d0ba-28db-474f-8e62-01debcc12e2b	2026-05-20 10:30:01.082	\N	compute	\N	\N	revenue
c7a44782-9a30-498a-9fcc-9cfe48a1f9f9	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	522e2b1f-6e9c-4a40-a835-3a7780ef9138	2026-05-20 10:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
54f3d464-6290-4ca1-bc95-21dc349852b2	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	3600	15	15	INR	880259c1-8374-4da5-908e-451e6fe7dccf	2026-05-20 10:30:00	\N	storage	16	b263377c-f35a-4a23-b6f9-761257b978a5	revenue
ba1f61a1-5ba2-4c6b-b334-37079a1ef8e2	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	f644f81d-3b03-46c3-bfdb-d098923af02c	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	d4cb4679-53e8-4c29-8977-ab645897d74e	2026-05-20 11:30:00.224	\N	compute	\N	\N	revenue
5567ea59-74e7-46ca-a4cc-e77dc3c95ac1	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	56139fb6-87fd-4e78-8610-a923d52c7bd8	2026-05-20 11:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
2c7584c6-8bfc-4a89-9f3b-b757bfe6cff2	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	04752121-e3c3-4e45-b54c-754cd94e1624	2026-05-20 11:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
fa9efc56-fdff-49a0-b5c0-ae5aa7ebebb9	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	877ff9ea-5ad9-4243-b447-6a7b71691559	2026-05-20 11:30:00.544	\N	compute	\N	\N	revenue
1be49dcf-5121-4684-a260-7814eafae730	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	3600	15	15	INR	a9a55099-0beb-4906-b430-c82223ff4928	2026-05-20 11:30:00	\N	storage	16	b263377c-f35a-4a23-b6f9-761257b978a5	revenue
5f9a6b9b-b16a-4c9f-ac55-862b1671b41e	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	f50ae7e0-1c64-4226-a74a-31b195c2257c	2026-05-20 12:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
c63b9afd-bd6a-481d-a630-9a2fb7fe71ca	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	f644f81d-3b03-46c3-bfdb-d098923af02c	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	c0db2b0f-fde4-4c2c-8636-b0e31775559b	2026-05-20 12:30:00.271	\N	compute	\N	\N	revenue
0e1f82df-d6dd-427e-aae0-e7995c0c083c	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	622e3a1d-92f9-47d9-b199-c438ea261da0	2026-05-20 12:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
2cc534ca-6fa2-40b5-91b8-93ad4a83ac8b	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	1ee913ba-884d-4615-a1ba-ad6833a3cf2b	2026-05-20 12:30:00.376	\N	compute	\N	\N	revenue
1def4666-bd9c-4782-a40f-cec45edc25c1	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	3600	15	15	INR	6202dc46-9416-4c68-bf78-8cb21b3c8ba8	2026-05-20 12:30:00	\N	storage	16	b263377c-f35a-4a23-b6f9-761257b978a5	revenue
dd908272-f874-43fe-9620-8f5039bebdbc	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	a822315c-b784-4d74-b801-3ce893f36ed3	2026-05-20 15:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
399a92a1-d3b0-4433-b5a4-9e722568c71b	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	69c578e0-462a-43a8-b34f-3fb3e28da8bb	2026-05-20 15:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
4c21cb3b-1590-4e0a-9bd2-8e097940841d	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	3600	15	15	INR	023f4953-560f-4dfe-a1b9-f0110515d953	2026-05-20 15:30:00	\N	storage	16	b263377c-f35a-4a23-b6f9-761257b978a5	revenue
9c32424d-2c15-4f14-b5de-d0c14b662b3d	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	5430b60f-3ee7-4f97-9088-2e402b9446fb	2026-05-20 16:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
aa8a91d0-18b2-477d-a47f-94c8761876cd	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	f644f81d-3b03-46c3-bfdb-d098923af02c	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	1f3dddfe-105a-49c6-ba44-62a86f15c954	2026-05-20 17:01:15.915	\N	compute	\N	\N	revenue
b6000c1f-b7b6-46b3-a468-29326d417fb6	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	bed2cc25-7e79-40be-a8a2-315f1bd1c042	2026-05-20 16:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
0f3c37c4-c36a-421b-ae51-d7387db3bac6	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	3600	15	15	INR	7f8b9c98-632d-4edf-a4e0-a1ecc7baf1df	2026-05-20 16:30:00	\N	storage	16	b263377c-f35a-4a23-b6f9-761257b978a5	revenue
7290f5dc-7793-4066-a291-9558892ad7be	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	8c26f092-7c58-4a72-b465-0088c2caf827	2026-05-20 17:01:19.17	\N	compute	\N	\N	revenue
6a4487e3-536b-4c20-bf43-c8cc08e1295d	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	586540e4-0e41-43e9-8f10-8082430ea743	2026-05-21 05:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
1f09913a-ef73-422b-98a0-92cf4fec3617	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	f644f81d-3b03-46c3-bfdb-d098923af02c	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	4db14869-5d0d-4f47-a315-7baf16f29b27	2026-05-21 05:30:00.058	\N	compute	\N	\N	revenue
6dee2b43-bb01-4cad-adba-9b9520f02377	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	e8fb6900-1705-498c-b2cf-bb11b34d8b28	2026-05-21 05:30:00.113	\N	compute	\N	\N	revenue
58a5bd7f-43f3-49ce-86df-52dfad9e7405	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	cbed80e9-5bd9-46d1-b92d-64d83a4f4193	2026-05-21 05:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
8b06c74a-ed93-49cb-87d6-aaf60cbb1660	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	3600	15	15	INR	6880afb6-58c2-4988-8183-0238d8c4234e	2026-05-21 05:30:00	\N	storage	16	b263377c-f35a-4a23-b6f9-761257b978a5	revenue
aa18a033-f3b2-4306-8a52-d36fa0e20bf1	f3a5cce9-059c-4828-ac18-61164c28e868	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	69834	36000	720000	INR	4d0b3df9-9546-4e54-adf8-e35b891f50e5	2026-05-21 05:35:38.567	\N	compute	\N	\N	revenue
3ff74c81-a8f3-4bbc-a971-22278fd513af	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	6e5d0c84-84de-46fb-9c9e-1f909f86bad3	2026-05-21 06:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
b0a65025-1716-4176-9bda-d9763b4218f3	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	f644f81d-3b03-46c3-bfdb-d098923af02c	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	3bc79173-38bf-48e9-a29a-aefd5398945d	2026-05-21 06:30:00.26	\N	compute	\N	\N	revenue
b49e690a-3168-495e-b66f-e45a388b1dfb	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	0bc0d2aa-5352-4836-9b7c-475ceec3966b	2026-05-21 06:30:00.393	\N	compute	\N	\N	revenue
88ebb46e-64a4-4bde-a799-364b8762ee03	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	a320f464-3fc7-449c-91e2-f21ec9040216	2026-05-21 06:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
0ae1f5d0-1a5c-4de1-9554-0337c009afb6	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	2d8e5d64-fe04-477b-832d-95fa58692ca5	2026-05-21 07:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
25985b2f-b1d1-4bb9-9bb2-2bd0d494eed1	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	f644f81d-3b03-46c3-bfdb-d098923af02c	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	9e241248-6204-4959-b961-92315aa13b28	2026-05-21 07:30:00.172	\N	compute	\N	\N	revenue
2b2ecdb5-34d7-441d-b54e-e59fde197a11	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	0b48935f-112b-40f1-a8ec-d8d9239723a7	2026-05-21 07:30:00.207	\N	compute	\N	\N	revenue
030abe90-83f3-4d92-832d-4af890608691	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	6562bc6b-ed12-4703-b30b-a34b0110e4ef	2026-05-21 07:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
a0f23e4e-dc39-4076-956e-186926a0a803	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	9a7ef5fa-fde8-4651-a403-154f1b37fb87	2026-05-21 08:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
700bf4ee-2279-44b6-be29-38249a91795b	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	f644f81d-3b03-46c3-bfdb-d098923af02c	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	ca9bdb3c-b177-4ca1-bdf4-2045cd73cbc4	2026-05-21 09:13:02.077	\N	compute	\N	\N	revenue
7615deba-2329-458d-b668-8fb9afacdd57	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	e3a05c74-4d58-4df5-aaff-8184ce2978d5	2026-05-21 08:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
cc1099b2-58bb-4bf3-aa0f-f2c7629dde63	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	45283746-66ce-433b-942c-25e00831767f	2026-05-21 09:13:05.341	\N	compute	\N	\N	revenue
ee5bc017-574d-4e65-9e0e-14d8665b8907	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	f644f81d-3b03-46c3-bfdb-d098923af02c	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	86c5e136-e15d-4c18-9d9c-bbb10c6005bd	2026-05-21 09:30:00.072	\N	compute	\N	\N	revenue
ffcc1521-fcd6-45a2-9cfd-6f86ea66482b	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	dc0f52e1-4795-4e00-910b-1455271eb7bf	2026-05-21 09:30:00.114	\N	compute	\N	\N	revenue
dd08dcc7-71b3-4b24-bf26-79fc743df600	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	34946f4a-0bb6-4376-8d29-cd11e170fb83	2026-05-21 09:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
1b36fa43-52d2-4c4e-acb2-ddc6a48bc36a	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	6d64a6be-433a-42ed-98fe-34e5b4fcb208	2026-05-21 09:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
b50edd6b-6c60-464a-a94b-bdeef3efe5ba	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	f644f81d-3b03-46c3-bfdb-d098923af02c	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	\N	2026-05-21 10:30:00.125	\N	compute	\N	\N	capex
c750fbf1-7ceb-48d2-abdf-801d02b8eaf4	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	fe5f9cfc-0b2a-412c-9872-3d3fd7c02481	2026-05-21 10:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
842977c5-7041-4996-b75b-8567afa5935f	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	9d0eac2d-06de-4c9b-ba3e-659d8e7c079e	2026-05-21 10:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
fad154b5-0455-4109-ac02-7c7ef2cc0db6	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	81e26dbb-fa05-46d7-ad9b-9ad44bd38173	2026-05-21 10:30:00.36	\N	compute	\N	\N	revenue
a36ab7cf-eaab-4411-b481-36ff87975c1e	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	f644f81d-3b03-46c3-bfdb-d098923af02c	d2fb06af-8256-4105-812b-05a10cbe99a1	50515	12000	180000	INR	f75f6b8c-ec35-4efd-8720-dc71ad404cab	2026-05-21 10:38:17.219	\N	compute	\N	\N	revenue
00548464-ee65-462f-9766-08ea2f5c7529	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	378ec15c-cec4-4864-98da-49821b126fb4	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	\N	2026-05-21 10:42:53.302	\N	compute	\N	\N	capex
2009f1b5-6dd9-4442-9530-ff77a6f1fae2	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	8095cdef-8105-40bc-84a1-4510c81383d0	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	\N	2026-05-21 10:44:44.215	\N	compute	\N	\N	capex
706e7533-7b23-4d4e-89e6-c3870b9ba515	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	d610682f-7028-42ca-93e2-0fbc64499b17	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	\N	2026-05-21 10:46:52.453	\N	compute	\N	\N	capex
f121c6c2-5312-4e0b-a499-4e1b2c1265ea	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	5474b5dc-6ff2-4688-95b3-b9281bec70de	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	\N	2026-05-21 11:14:53.722	\N	compute	\N	\N	capex
a1270184-d713-4de1-a556-1b85e7731bfb	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	\N	3600	31	31	INR	\N	2026-05-21 11:30:00	\N	storage	32	73bf0b02-b72f-4dd4-a1b8-8f074b857d85	capex
db31b3ee-8a52-4b49-9181-74a5ee9a3838	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	5474b5dc-6ff2-4688-95b3-b9281bec70de	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	\N	2026-05-21 11:30:00.198	\N	compute	\N	\N	capex
86df42fc-6b9a-4f1d-b2ef-fcacb339cdbb	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	97417055-7e31-4b70-bd88-733d5ad95404	2026-05-21 11:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
58942676-ccca-443e-943a-c0ff11ba079b	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	e35d4248-d355-4774-ae25-79bf0aeebb60	2026-05-21 11:30:00.242	\N	compute	\N	\N	revenue
6ef4dd15-49d6-4efe-9787-49f859f64132	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	74f4ba10-282d-48c2-af92-400e0efbf5b2	2026-05-21 11:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
37e41cbd-b43c-46d1-b47a-39897e348743	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	\N	3600	31	31	INR	\N	2026-05-21 11:30:00	\N	storage	32	0e408575-0246-45ee-ac86-b4b5fb767421	capex
6edd59df-8534-473f-bcd6-aeb897aee9d6	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	79e8882e-3f8a-4440-b752-87ce59369923	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	\N	2026-05-21 11:38:30.609	\N	compute	\N	\N	capex
cfaefc09-50cc-4d51-88d8-6f44f89bae11	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	\N	3600	31	31	INR	\N	2026-05-21 12:30:00	\N	storage	32	73bf0b02-b72f-4dd4-a1b8-8f074b857d85	capex
702142a9-b5ae-4d77-b94a-096859aa4331	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	5474b5dc-6ff2-4688-95b3-b9281bec70de	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	\N	2026-05-21 12:30:00.064	\N	compute	\N	\N	capex
60d43040-89b0-451f-bbac-1fd7cc00aeb6	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	e8ac7ea7-7ad0-4ae4-b39f-9fffb06c8889	2026-05-21 12:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
1741f6db-f9b6-4b15-b122-f05a779c87cd	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	c95bc970-3cbe-46eb-b0df-b5ee11b63490	2026-05-21 12:30:00.139	\N	compute	\N	\N	revenue
c041715a-d360-4a98-82fc-67a6b0f875f9	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	816a192e-27da-4294-b9fc-4b596fe13a30	2026-05-21 12:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
187b0cb1-4293-44b2-aa18-3956c930246c	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	79e8882e-3f8a-4440-b752-87ce59369923	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	\N	2026-05-21 12:30:00.204	\N	compute	\N	\N	capex
c0bc155a-80eb-41d1-8102-64c27128e44a	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	\N	3600	31	31	INR	\N	2026-05-21 12:30:00	\N	storage	32	0e408575-0246-45ee-ac86-b4b5fb767421	capex
c93a8e30-e9d7-45f9-98f2-b9eef120b3be	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	5474b5dc-6ff2-4688-95b3-b9281bec70de	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	\N	2026-05-21 13:40:22.331	\N	compute	\N	\N	capex
3a214c42-f09e-43b0-9cb2-f92c20baad2d	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	7b916ab7-a6be-457a-9db9-fc857505f3c5	2026-05-21 13:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
6136e961-b314-4ebc-90f3-72d35b1be376	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	2c071099-2166-47b9-944d-59ca5b2116ec	2026-05-21 13:40:29.329	\N	compute	\N	\N	revenue
7ed3b33a-e487-47c3-b994-881c4a74f522	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	79e8882e-3f8a-4440-b752-87ce59369923	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	\N	2026-05-21 13:40:29.576	\N	compute	\N	\N	capex
787e9f7c-3014-42c8-88c2-8e08ddf8c59f	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	fa8806a1-be8e-4f93-969f-924b0c36611d	2026-05-21 13:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
d4d646af-2d89-4cae-b82d-8b39706ae876	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	\N	3600	31	31	INR	\N	2026-05-21 13:30:00	\N	storage	32	0e408575-0246-45ee-ac86-b4b5fb767421	capex
d6db0790-4a94-4c1c-b865-f5ddd68337f5	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	5474b5dc-6ff2-4688-95b3-b9281bec70de	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	\N	2026-05-21 14:30:00.079	\N	compute	\N	\N	capex
f019dc78-4413-4534-9852-236f1a48f10e	8d40647d-da49-4490-ada6-3bfa2205366c	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	46756643-41f5-4eb1-a161-d5b595b4e0c8	3600	21000	21000	INR	815018bc-fb07-40ff-b75d-073faddb0fcd	2026-05-21 14:30:00.126	\N	compute	\N	\N	revenue
162ed3d8-5043-426d-a302-4441289b6e61	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	79e8882e-3f8a-4440-b752-87ce59369923	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	\N	2026-05-21 14:30:00.146	\N	compute	\N	\N	capex
05af609d-35e5-4c67-8a8b-7b2fd99d4f2e	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	\N	3600	31	31	INR	\N	2026-05-21 14:30:00	\N	storage	32	73bf0b02-b72f-4dd4-a1b8-8f074b857d85	capex
cc60c5f1-acaa-4754-833e-7cb761c3a853	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	17709b84-ee6f-4a2d-862e-03d3117e4637	2026-05-21 14:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	revenue
593f70f0-a5c8-4fce-9778-e6797e1a080d	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	4b675530-cb28-4d8c-854b-b8e410f722de	2026-05-21 14:30:00	\N	storage	10	8d27d0fb-d618-4762-af20-f3d85f039c39	revenue
9bf3dd00-b8d5-44f9-91fa-8d74b3ea8fb0	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	\N	3600	31	31	INR	\N	2026-05-21 14:30:00	\N	storage	32	0e408575-0246-45ee-ac86-b4b5fb767421	capex
\.


--
-- TOC entry 6007 (class 0 OID 151353)
-- Dependencies: 225
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (id, user_id, organization_id, compute_config_id, node_id, required_vcpu, required_memory_mb, required_gpu_vram_mb, scheduled_start_at, scheduled_end_at, status, cancellation_reason, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6008 (class 0 OID 151367)
-- Dependencies: 226
-- Data for Name: compute_config_access; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compute_config_access (id, compute_config_id, organization_id, role_id, is_allowed, price_override_cents, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6009 (class 0 OID 151377)
-- Dependencies: 227
-- Data for Name: compute_configs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compute_configs (id, slug, name, description, session_type, tier, vcpu, memory_mb, gpu_vram_mb, gpu_exclusive, hami_sm_percent, base_price_per_hour_cents, currency, sort_order, is_active, created_at, updated_at, created_by, updated_by, best_for, gpu_model, max_concurrent_per_node) FROM stdin;
d2fb06af-8256-4105-812b-05a10cbe99a1	spark	Spark	Entry-level GPU compute for learning, light inference, and small experiments.	stateful_desktop	gpu	2	4096	2048	f	8	12000	INR	1	t	2026-04-08 01:52:11.975	2026-05-15 07:32:20.584	\N	\N	Small PyTorch inference, Jupyter notebooks with CUDA, educational projects	RTX 4090	8
46756643-41f5-4eb1-a161-d5b595b4e0c8	blaze	Blaze	Standard GPU compute for development, moderate ML training, and data science.	stateful_desktop	gpu	4	8192	4096	f	17	21000	INR	2	t	2026-04-08 01:52:11.994	2026-05-15 07:32:20.596	\N	\N	Model fine-tuning, GPU-accelerated rendering, professional development	RTX 4090	4
73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	inferno	Inferno	Advanced GPU compute for heavy ML training, 3D rendering, and simulations.	stateful_desktop	gpu	8	16384	8192	f	33	30000	INR	3	t	2026-04-08 01:52:11.998	2026-05-15 07:32:20.604	\N	\N	Large model training, complex 3D rendering, GPU-intensive simulations	RTX 4090	2
28a49cc2-a6c4-4387-a93f-9d48c153bb6e	supernova	Supernova	Premium GPU compute with near-exclusive access for research and large-scale workloads.	stateful_desktop	gpu-exclusive	12	32768	16384	f	67	36000	INR	4	t	2026-04-08 01:52:12.005	2026-05-15 07:32:20.61	\N	\N	Large-scale deep learning, exclusive research sessions, production inference	RTX 4090	1
\.


--
-- TOC entry 6010 (class 0 OID 151404)
-- Dependencies: 228
-- Data for Name: course_enrollments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_enrollments (id, course_id, user_id, status, enrolled_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6011 (class 0 OID 151415)
-- Dependencies: 229
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (id, organization_id, department_id, instructor_id, title, code, description, semester, academic_year, status, default_compute_config_id, max_students, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6012 (class 0 OID 151429)
-- Dependencies: 230
-- Data for Name: coursework_content; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coursework_content (id, organization_id, category, title, description, content_url, thumbnail_url, difficulty_level, tags, is_featured, view_count, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6013 (class 0 OID 151444)
-- Dependencies: 231
-- Data for Name: credit_packages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.credit_packages (id, name, amount_cents, credit_cents, bonus_cents, validity_days, is_active, sort_order, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6014 (class 0 OID 151462)
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
67ef63ef-2331-41a3-9abf-c01d56a75d3d	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Artificial Intelligence and Data Science	AIDS	aids	\N	t	2026-05-14 15:10:45.8	2026-05-14 15:10:45.8	\N	\N	\N
66f940dc-4ee5-4d3b-948e-940e1493028e	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Artificial Intelligence and Machine Learning	AIML	aiml	\N	t	2026-05-14 15:10:45.806	2026-05-14 15:10:45.806	\N	\N	\N
893440ea-4b47-45c1-b302-da656e930b0c	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Cyber Security	CS	cyber-security	\N	t	2026-05-14 15:10:45.811	2026-05-14 15:10:45.811	\N	\N	\N
47563591-17ba-4e02-9d7e-fd1c98f950a3	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Biomedical Engineering	BME	bme	\N	t	2026-05-14 15:10:45.816	2026-05-14 15:10:45.816	\N	\N	\N
a0582e92-14f8-4ca0-8d76-148e223dc596	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Master of Business Administration	MBA	mba	\N	t	2026-05-14 15:10:45.821	2026-05-14 15:10:45.821	\N	\N	\N
679de575-40a2-447d-a2fe-0cc200a52836	f213bc95-2fe5-4401-94c1-39efeaa39a5a	\N	Master of Computer Applications	MCA	mca	\N	t	2026-05-14 15:10:45.826	2026-05-14 15:10:45.826	\N	\N	\N
\.


--
-- TOC entry 6015 (class 0 OID 151476)
-- Dependencies: 233
-- Data for Name: discussion_replies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discussion_replies (id, discussion_id, parent_reply_id, author_id, body, is_accepted_answer, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6016 (class 0 OID 151490)
-- Dependencies: 234
-- Data for Name: discussions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discussions (id, organization_id, course_id, lab_id, author_id, title, body, is_pinned, is_locked, reply_count, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6017 (class 0 OID 151508)
-- Dependencies: 235
-- Data for Name: feature_flags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feature_flags (id, key, enabled, rollout_percent, allowed_org_ids, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6018 (class 0 OID 151522)
-- Dependencies: 236
-- Data for Name: invoice_line_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice_line_items (id, invoice_id, description, quantity, unit_price_cents, total_cents, reference_type, reference_id, created_at) FROM stdin;
95b3259e-d9a8-4715-81b2-ee94fa9cc334	272bd948-06d9-49a6-ba10-70281477c9af	Credit Recharge	1	500000	500000	payment_transaction	1acbc4e6-ec5a-4285-9344-d9ef9f71f43e	2026-05-18 06:48:37.668
1da150a2-4ee0-4a8e-bf71-221d2fe874b5	13c507b8-f0f6-4c9f-ba1f-5ce20a053b68	Credit Recharge	1	1000000	1000000	payment_transaction	80b2ca83-1f4f-4abe-aa7c-153fab0f0b7f	2026-05-18 10:55:22.437
132b5a5f-7295-4b1b-9b55-66cd56e72cb6	328dbbed-4fb9-4646-bcf2-84d56ebb240a	Credit Recharge	1	100000	100000	payment_transaction	39891e7a-1510-4e43-92c8-2b8cd34c8479	2026-05-18 11:00:35.661
a1469659-938e-4a45-af5c-b1c836b12aa5	2a16a1f9-9081-4084-83b7-6591f485486d	Credit Recharge	1	500000	500000	payment_transaction	0cf9314e-2df0-4d34-b915-b9378ef9e80e	2026-05-20 00:36:54.709
8955c236-6c20-4a08-865c-c2fd72c0ab9c	0484733c-12b2-4bbd-8c6d-b22de8de2624	Credit Recharge	1	250000	250000	payment_transaction	55235568-d14f-4bf0-ab1e-7881b86c8380	2026-05-20 06:35:55.896
fdda2088-2a7f-4045-81bb-a57b80a446bb	c4495201-d2d5-40de-9c3a-e07016f75fb1	Credit Recharge	1	100000	100000	payment_transaction	002c0ee1-7d59-4080-a8d9-abf6222a321b	2026-05-20 07:49:19.099
\.


--
-- TOC entry 6019 (class 0 OID 151535)
-- Dependencies: 237
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoices (id, user_id, organization_id, invoice_number, period_start, period_end, subtotal_cents, tax_cents, total_cents, currency, status, issued_at, paid_at, pdf_url, created_at, updated_at, created_by, updated_by) FROM stdin;
272bd948-06d9-49a6-ba10-70281477c9af	8d40647d-da49-4490-ada6-3bfa2205366c	\N	INV-20260518-B28596	2026-05-18 06:48:37.639	2026-05-18 06:48:37.639	500000	0	500000	INR	paid	2026-05-18 06:48:37.639	2026-05-18 06:48:37.639	\N	2026-05-18 06:48:37.664	2026-05-18 06:48:37.664	\N	\N
13c507b8-f0f6-4c9f-ba1f-5ce20a053b68	8d40647d-da49-4490-ada6-3bfa2205366c	\N	INV-20260518-C808D2	2026-05-18 10:55:22.411	2026-05-18 10:55:22.411	1000000	0	1000000	INR	paid	2026-05-18 10:55:22.411	2026-05-18 10:55:22.411	\N	2026-05-18 10:55:22.428	2026-05-18 10:55:22.428	\N	\N
328dbbed-4fb9-4646-bcf2-84d56ebb240a	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	INV-20260518-1A4E07	2026-05-18 11:00:35.643	2026-05-18 11:00:35.643	100000	0	100000	INR	paid	2026-05-18 11:00:35.643	2026-05-18 11:00:35.643	\N	2026-05-18 11:00:35.659	2026-05-18 11:00:35.659	\N	\N
2a16a1f9-9081-4084-83b7-6591f485486d	8d40647d-da49-4490-ada6-3bfa2205366c	\N	INV-20260520-6F9426	2026-05-20 00:36:54.68	2026-05-20 00:36:54.68	500000	0	500000	INR	paid	2026-05-20 00:36:54.68	2026-05-20 00:36:54.68	\N	2026-05-20 00:36:54.701	2026-05-20 00:36:54.701	\N	\N
0484733c-12b2-4bbd-8c6d-b22de8de2624	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	INV-20260520-95EA0F	2026-05-20 06:35:55.879	2026-05-20 06:35:55.879	250000	0	250000	INR	paid	2026-05-20 06:35:55.879	2026-05-20 06:35:55.879	\N	2026-05-20 06:35:55.894	2026-05-20 06:35:55.894	\N	\N
c4495201-d2d5-40de-9c3a-e07016f75fb1	f3a5cce9-059c-4828-ac18-61164c28e868	\N	INV-20260520-5DA399	2026-05-20 07:49:19.071	2026-05-20 07:49:19.071	100000	0	100000	INR	paid	2026-05-20 07:49:19.071	2026-05-20 07:49:19.071	\N	2026-05-20 07:49:19.092	2026-05-20 07:49:19.092	\N	\N
\.


--
-- TOC entry 6020 (class 0 OID 151555)
-- Dependencies: 238
-- Data for Name: lab_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_assignments (id, lab_id, title, description, instructions, due_at, max_score, allow_late_submission, late_penalty_percent, max_attempts, rubric, sort_order, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6021 (class 0 OID 151575)
-- Dependencies: 239
-- Data for Name: lab_grades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_grades (id, submission_id, graded_by, score, max_score, feedback, rubric_scores, graded_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6022 (class 0 OID 151586)
-- Dependencies: 240
-- Data for Name: lab_group_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_group_assignments (id, lab_id, user_group_id, assigned_by, available_from, available_until, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6023 (class 0 OID 151596)
-- Dependencies: 241
-- Data for Name: lab_submissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_submissions (id, lab_assignment_id, user_id, session_id, attempt_number, status, submitted_at, file_ids, notes, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6024 (class 0 OID 151610)
-- Dependencies: 242
-- Data for Name: labs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.labs (id, course_id, organization_id, created_by_user_id, title, description, instructions, compute_config_id, base_image_id, preloaded_notebook_url, preloaded_dataset_urls, max_duration_minutes, status, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6025 (class 0 OID 151624)
-- Dependencies: 243
-- Data for Name: login_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login_history (login_method, ip_address, user_agent, "geoLocation", success, failure_reason, created_at, created_by, id, user_id) FROM stdin;
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
oauth	127.0.0.1	\N	\N	t	\N	2026-05-18 06:45:44.503	\N	551cf881-8b2e-48f7-9507-569cffe2c673	8d40647d-da49-4490-ada6-3bfa2205366c
password	127.0.0.1	\N	\N	t	\N	2026-05-18 06:46:23.948	\N	963d8527-f380-4a92-87c4-ff5046b8db17	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 07:03:13.492	\N	9d93bf6f-f40b-4ac8-bb50-0f784127e3a3	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 07:29:34.435	\N	edf88320-0fb3-42ec-bd58-99fc6cc2513f	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-18 07:29:54.805	\N	d56fcfd1-47ac-40d7-a8b9-8748a16157ce	8d40647d-da49-4490-ada6-3bfa2205366c
oauth	127.0.0.1	\N	\N	t	\N	2026-05-18 08:22:26.683	\N	4ec5a2f6-edc2-49d6-8355-4c0ba8392894	8d40647d-da49-4490-ada6-3bfa2205366c
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
oauth	127.0.0.1	\N	\N	t	\N	2026-05-18 10:59:24.485	\N	98711669-6c51-4503-a1e3-c813e9b6c86e	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6
oauth	127.0.0.1	\N	\N	t	\N	2026-05-18 11:04:59.76	\N	2a81054d-7fcd-4ac1-a368-dd58c506dd73	8d40647d-da49-4490-ada6-3bfa2205366c
password	127.0.0.1	\N	\N	t	\N	2026-05-18 11:05:22.377	\N	a4929a1f-77f8-47cd-86a7-4a1e8ed5eb9a	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 11:22:07.084	\N	9cdc0fa9-be66-4598-b13d-d77edf1d41fd	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 11:43:00.516	\N	5374a7bb-98b3-4113-be49-c8f898a33f50	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 11:58:40.923	\N	dddee939-a418-4450-bd6e-4b705d32911c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 12:21:16.65	\N	cff3ab5b-f24e-4444-af9a-338b02207380	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 12:37:32.928	\N	ff9c89fb-8f5d-448e-8043-9f8fa9391c99	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-18 12:39:08.99	\N	c26f8c32-8828-42ac-b8fd-dd6b08c5d6e0	8d40647d-da49-4490-ada6-3bfa2205366c
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
oauth	127.0.0.1	\N	\N	t	\N	2026-05-19 00:15:37.124	\N	8bdd7578-33be-43f4-9e50-b049f2868471	8d40647d-da49-4490-ada6-3bfa2205366c
password	127.0.0.1	\N	\N	t	\N	2026-05-19 00:26:51.716	\N	bc926405-f47a-4b32-81dd-9d8a1fba14b1	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 00:44:15.645	\N	525c7a22-5262-4876-a3dc-2db1a371e812	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 01:00:18.151	\N	28ba4b2b-0fe4-4d46-bdb0-5d232b0c71dc	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 01:19:18.307	\N	96807194-40ee-4c7d-bab1-d61b0928e786	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-19 01:35:52.796	\N	24c0826b-4593-443d-899f-0a84ccb24c20	8d40647d-da49-4490-ada6-3bfa2205366c
password	127.0.0.1	\N	\N	t	\N	2026-05-19 01:36:56.774	\N	d4554e2a-fefe-4dbb-a101-8d21635c1960	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 02:40:40.534	\N	35fd0add-9e77-486c-b01b-cf1030dd347a	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 02:42:38.348	\N	3037c1bb-97a5-4b13-a1c6-5a885e385929	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 02:47:01.002	\N	cc999f45-9ab8-434b-9759-40efafc572d6	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 03:14:41.826	\N	9f2a1416-56e5-45ab-ae6e-f8e3bcacaf53	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 03:31:31.544	\N	e050663e-9e56-4465-aabe-b67d61233fee	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 04:25:50.471	\N	aaaa12df-da3a-4caa-b8f7-7da3dc227558	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-19 04:26:54.279	\N	92494ff4-8462-405d-923e-60da6f640496	8d40647d-da49-4490-ada6-3bfa2205366c
password	127.0.0.1	\N	\N	t	\N	2026-05-19 04:50:01.307	\N	6bc011df-7c21-495a-b657-b0914d08c2b7	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 04:58:39.987	\N	59b52735-5029-4a4c-8e3f-0ab7e304d73c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 05:17:22.439	\N	07cd0869-ed58-4a21-8615-45876d877bb1	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-19 05:33:00.911	\N	20e3d564-7fb5-4a0f-9ceb-060b90602654	8d40647d-da49-4490-ada6-3bfa2205366c
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
oauth	127.0.0.1	\N	\N	t	\N	2026-05-19 12:42:15.887	\N	2496a7ab-220a-4e00-b36a-c31fe7d5a2be	8d40647d-da49-4490-ada6-3bfa2205366c
password	127.0.0.1	\N	\N	t	\N	2026-05-19 16:31:38.551	\N	120c23d5-8bdb-46ea-a493-ae0cf8266961	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-19 16:33:21.397	\N	d5b877cb-fbf1-404a-8233-6aa063286de5	8d40647d-da49-4490-ada6-3bfa2205366c
oauth	127.0.0.1	\N	\N	t	\N	2026-05-19 17:37:21.187	\N	dc618744-3751-416c-a208-df658e2ad245	8d40647d-da49-4490-ada6-3bfa2205366c
password	127.0.0.1	\N	\N	t	\N	2026-05-19 17:45:23.147	\N	5a709657-3255-47bd-a607-36c8329d6737	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 18:16:14.951	\N	cdda1269-574d-400d-9806-f69034ba8a79	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 18:32:03.94	\N	27dd2ff2-c998-4137-81de-4a87f3d5a6a2	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 18:36:43.758	\N	284bba70-f914-45fa-a9bd-d24fbae0c6c8	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 18:53:15.803	\N	021d9376-8eeb-4465-8c74-6b3ea09e69b7	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 19:09:27.861	\N	7ded94de-6faf-4416-a700-ae8f057c6451	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 19:20:12.296	\N	cc7496bb-6c91-4af7-adcc-3bfd7cc4de81	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-19 19:35:22.784	\N	598c92e3-b38e-4f36-993f-cd7fbd1aed2e	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 00:25:52.861	\N	e0bfb639-d8f8-46eb-b33d-55ad1330b7b2	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-20 00:35:37.314	\N	86ec0dda-2e99-4f21-bf6d-94552136cbcd	8d40647d-da49-4490-ada6-3bfa2205366c
password	127.0.0.1	\N	\N	t	\N	2026-05-20 00:45:10.937	\N	148926d2-9350-4cb7-b321-e42e2bc4c288	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 01:20:45.007	\N	26c0387c-4b0d-4d97-b185-0d29fb64b251	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 01:31:18.794	\N	85428e32-fb19-49af-86f3-7b9bd746e816	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 01:50:22.409	\N	f5d56944-970f-444a-9fc8-a2caf56a72db	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 02:11:10.114	\N	f0f8e3f5-fed0-47a3-907c-3a55db059239	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 02:32:06.402	\N	5942e40b-303c-4460-8794-0c16de9c27e6	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 02:52:08.359	\N	a3c32ea1-b87f-4de0-8a2c-858af0da9b87	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 03:28:38.649	\N	d8d27cd3-5b7f-4eed-9723-35f79a826bcf	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 03:41:40.012	\N	c2553e0e-b03c-4745-a735-5f9cd7efce3a	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-20 03:42:43.811	\N	6bc2a9b4-1fda-424d-878e-6506fb79663d	8d40647d-da49-4490-ada6-3bfa2205366c
oauth	127.0.0.1	\N	\N	t	\N	2026-05-20 04:34:12.286	\N	a29a270d-881d-45b8-a8ff-0efad46413cb	8d40647d-da49-4490-ada6-3bfa2205366c
password	127.0.0.1	\N	\N	t	\N	2026-05-20 04:35:49.402	\N	301b9c6a-55d8-4c7b-83e9-92c18a9ef44d	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-20 04:50:59.186	\N	105fcc84-b681-4322-9c84-72f8c7a00517	8d40647d-da49-4490-ada6-3bfa2205366c
password	127.0.0.1	\N	\N	t	\N	2026-05-20 04:54:23.846	\N	d2863d74-b3e6-44bf-ba5f-dea785f3c53c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 05:13:53.214	\N	22b154e9-3f72-4db1-8120-de72fdc649ef	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 05:31:23.893	\N	b4f6190a-e478-488a-9054-5e4a154c1356	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 06:04:21.713	\N	3ac1f9fd-7d1b-4994-8fcd-ce6f0f9fd41c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 06:19:50.876	\N	732b19e8-3e84-4dd9-8bc2-c973b2edf897	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-20 06:30:14.869	\N	2f526d42-e667-4324-9df6-2bec525cf8da	8d40647d-da49-4490-ada6-3bfa2205366c
password	127.0.0.1	\N	\N	t	\N	2026-05-20 06:36:40.863	\N	9257934b-8151-4bf3-a7a9-d7643eb3bfa1	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 07:20:44.154	\N	8bf51cde-0dcc-46eb-846a-8ee0ed2a5f9b	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-20 07:21:48.107	\N	1355010c-7227-4164-aede-5eb3b72cfdaa	8d40647d-da49-4490-ada6-3bfa2205366c
password	127.0.0.1	\N	\N	f	invalid_password	2026-05-20 07:23:27.291	\N	7bc85e2b-9790-417f-b41c-43eeb5dcf542	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
password	127.0.0.1	\N	\N	t	\N	2026-05-20 07:23:30.76	\N	e2e2a271-c8fd-4be7-aa02-0c05adc2bd3d	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
password	127.0.0.1	\N	\N	t	\N	2026-05-20 08:38:26.578	\N	491ccb90-9939-4741-ae45-7c3ee7d42fcd	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 09:42:44.903	\N	7132fa39-bd8a-44fa-9d87-925ce7ecf3d8	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-20 11:30:29.402	\N	8619e910-8329-4089-b81e-5a00b09786f7	8d40647d-da49-4490-ada6-3bfa2205366c
password	127.0.0.1	\N	\N	t	\N	2026-05-20 11:32:06.882	\N	7cadc724-64db-4513-b229-fc62c56b2997	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 12:41:19.145	\N	c2c9ef40-dbee-4aa5-a52c-5b2edaa6e2a6	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 16:00:39.238	\N	7f45bce5-bbe1-411d-a56e-7ee7aeb9ff61	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-20 16:16:37.349	\N	c8c0916c-79c5-4217-8ebf-014fec5256f2	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 05:04:17.87	\N	f0e4a856-1327-41f0-923a-7ac45deb7a9d	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-21 05:15:20.9	\N	6abc9f03-27af-4fa0-8db9-c4e4cf8374c0	8d40647d-da49-4490-ada6-3bfa2205366c
password	127.0.0.1	\N	\N	t	\N	2026-05-21 05:17:47.125	\N	283a9664-26e9-47b3-b75b-0f9afa1b7ae0	f3a5cce9-059c-4828-ac18-61164c28e868
password	127.0.0.1	\N	\N	t	\N	2026-05-21 05:32:12.052	\N	7db9eef0-e6b0-4ef1-b8cc-d3f6850cb3ca	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 05:53:03.302	\N	bc038965-63e9-456c-96f9-8d02c7c4c99c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 06:24:38.849	\N	7424ab88-1d39-402a-9c54-8ef736fb0147	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 06:38:26.847	\N	46e1973a-9922-4860-93e4-d1ca52572d47	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 07:19:01.865	\N	72a254fa-f547-4fa8-b7ce-2bbd97bb449b	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
oauth	127.0.0.1	\N	\N	t	\N	2026-05-21 09:34:11.619	\N	e710179f-b6b8-473e-a4e9-337f1d50f9a3	8d40647d-da49-4490-ada6-3bfa2205366c
password	127.0.0.1	\N	\N	t	\N	2026-05-21 10:35:57.395	\N	5113a617-0c55-40dc-86b5-96895cc6db6f	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-21 10:36:43.806	\N	fef1fc85-1dc6-494b-8cfb-87e23000e16f	8d40647d-da49-4490-ada6-3bfa2205366c
password	127.0.0.1	\N	\N	t	\N	2026-05-21 10:37:20.509	\N	4a7a9678-2575-47e5-a13f-2ec25891a619	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
password	127.0.0.1	\N	\N	t	\N	2026-05-21 10:38:07.556	\N	40afea04-ee61-428d-b4f7-dac65d213a72	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
password	127.0.0.1	\N	\N	t	\N	2026-05-21 10:45:46.088	\N	8e853d89-571d-46eb-a71a-6f2705b011ef	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
password	127.0.0.1	\N	\N	t	\N	2026-05-21 10:46:05.014	\N	1a348f4b-6d44-4056-8c76-f043e0488e23	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 11:07:03.656	\N	c129f2ed-5e2b-4e18-baf9-11805613302b	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 11:12:51.306	\N	43fb6200-cbeb-4d05-b50e-8e1fa56a41d9	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
password	127.0.0.1	\N	\N	t	\N	2026-05-21 11:17:33.111	\N	49aec67d-6ae3-4bb4-85ed-6e898a4faae4	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 11:18:56.328	\N	0bcb5cc9-ddc1-4089-a9b7-b2a600cc1382	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
password	127.0.0.1	\N	\N	t	\N	2026-05-21 11:37:26.527	\N	651cb82a-1b9d-42f4-aa0f-5e9c3107284c	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 11:37:54.717	\N	bbb32b60-45de-488b-8f6a-27a3b3556a70	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
password	127.0.0.1	\N	\N	t	\N	2026-05-21 12:02:02.72	\N	43deeb43-44fc-42b1-b7a7-caedf3c63902	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
password	127.0.0.1	\N	\N	t	\N	2026-05-21 12:02:28.529	\N	d6f1ddf5-5672-4492-bf79-bd29194ef716	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 12:20:26.325	\N	867d2508-9198-4356-9c7e-8b2ed6423942	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-21 12:29:28.806	\N	215f2fa8-ce9a-4c68-9b67-ff6785ec67f1	8d40647d-da49-4490-ada6-3bfa2205366c
password	127.0.0.1	\N	\N	t	\N	2026-05-21 13:53:20.165	\N	f20774db-5166-45ad-8945-54de92dbae96	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 15:17:10.019	\N	86ffcf67-7e93-4222-b4ff-e193bc0b1e50	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-21 15:18:41.857	\N	15b0a918-3183-4b6c-8594-c64872267756	9f08f905-999a-4c6f-87bc-66e29dc6301e
\.


--
-- TOC entry 6026 (class 0 OID 151634)
-- Dependencies: 244
-- Data for Name: mentor_availability_slots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_availability_slots (id, mentor_profile_id, day_of_week, specific_date, start_time, end_time, is_recurring, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6027 (class 0 OID 151648)
-- Dependencies: 245
-- Data for Name: mentor_bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_bookings (id, mentor_profile_id, student_user_id, scheduled_at, duration_minutes, status, meeting_url, payment_transaction_id, amount_cents, notes, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6028 (class 0 OID 151663)
-- Dependencies: 246
-- Data for Name: mentor_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_profiles (id, user_id, headline, bio, expertise_areas, experience_years, price_per_hour_cents, currency, is_available, avg_rating, total_reviews, total_sessions, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6029 (class 0 OID 151683)
-- Dependencies: 247
-- Data for Name: mentor_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_reviews (id, mentor_booking_id, reviewer_user_id, rating, review_text, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6030 (class 0 OID 151695)
-- Dependencies: 248
-- Data for Name: node_base_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.node_base_images (node_id, base_image_id, status, pulled_at, error_message, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6031 (class 0 OID 151706)
-- Dependencies: 249
-- Data for Name: node_resource_reservations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.node_resource_reservations (id, node_id, session_id, reserved_vcpu, reserved_memory_mb, reserved_gpu_vram_mb, reserved_hami_sm_percent, reserved_at, released_at, status, created_at, updated_at) FROM stdin;
ace5c3bb-c83a-439f-ac35-b877972d2d08	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	c4ce3860-7509-47a7-b3d6-60592b593100	12	32768	16384	67	2026-05-18 07:02:40.052	2026-05-18 07:06:38.58	released	2026-05-18 07:02:40.052	2026-05-18 07:06:38.587
4c1995e8-749c-49f9-8786-f7fd2e885f7e	c9868115-ff99-403c-8e87-06124ba7df66	b3fb45cb-ac62-41bb-b65b-babce27a14fe	12	32768	16384	67	2026-05-18 07:30:32.31	2026-05-18 07:32:37.349	released	2026-05-18 07:30:32.31	2026-05-18 07:32:37.362
0538fafd-48ba-4b1d-a10d-5a514e46b332	c9868115-ff99-403c-8e87-06124ba7df66	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	12	32768	16384	67	2026-05-18 10:21:07.593	2026-05-18 17:23:42.383	released	2026-05-18 10:21:07.593	2026-05-18 17:23:42.393
5905ac3a-e556-4d12-878c-5fdbe2b7be21	c9868115-ff99-403c-8e87-06124ba7df66	968bf735-3894-4093-838d-efb4a943315d	2	4096	2048	8	2026-05-18 17:36:32.23	2026-05-18 18:02:49.401	released	2026-05-18 17:36:32.23	2026-05-18 18:02:49.41
0092c6d1-c458-49a6-918d-2d02193a875b	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	2	4096	2048	8	2026-05-18 18:37:31.864	2026-05-18 18:38:26.192	released	2026-05-18 18:37:31.864	2026-05-18 18:38:26.2
945dac32-3103-4c3b-a2d2-c8e6c8a33674	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	a50d4adb-5e31-41ba-9972-91dc118efdc0	2	4096	2048	8	2026-05-18 07:31:09.326	2026-05-19 00:23:24.854	released	2026-05-18 07:31:09.326	2026-05-19 00:23:24.86
031cc081-1a81-47ac-afbc-dc3edf032535	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	aef9cfcc-1747-4572-933e-6cf55bce8993	2	4096	2048	8	2026-05-19 00:22:02.113	2026-05-19 00:24:03.767	released	2026-05-19 00:22:02.113	2026-05-19 00:24:03.772
2da05095-1fc6-48f9-a502-0e4f5afd443e	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	fae608c4-ed05-41cd-b0b6-4134aaaa6354	8	16384	8192	33	2026-05-19 00:24:43.561	2026-05-19 00:26:10.44	released	2026-05-19 00:24:43.561	2026-05-19 00:26:10.444
37c7a6e1-4e0b-4c8f-882d-820741145d08	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	8548fb98-e8da-4f26-85da-e343210f26a2	8	16384	8192	33	2026-05-19 04:27:52.457	2026-05-19 16:33:50.132	released	2026-05-19 04:27:52.457	2026-05-19 16:33:50.138
fbb2f073-5b83-4c9f-9abc-93148cf38aa0	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	7c24eb9b-cef9-43c9-9874-220745bc7662	2	4096	2048	8	2026-05-19 12:43:12.304	2026-05-19 16:34:20.149	released	2026-05-19 12:43:12.304	2026-05-19 16:34:20.156
902f970b-27e1-471a-bf5b-58c810ec617f	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	12	32768	16384	67	2026-05-20 00:43:02.156	2026-05-20 01:21:13.847	released	2026-05-20 00:43:02.156	2026-05-20 01:21:13.855
2e8f7748-aeb8-4801-ada1-aea450cae80b	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	a580b232-5224-4c8e-b8b5-a1cf39642e0c	12	32768	16384	67	2026-05-20 06:30:55.999	2026-05-20 06:32:04.537	released	2026-05-20 06:30:55.999	2026-05-20 06:32:04.544
9afd6465-3a40-4c1c-9264-94bc43f9d1fa	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	c5925ef4-d5dd-4551-9165-50ce29fac9ff	2	4096	2048	8	2026-05-20 06:31:53.032	2026-05-20 06:33:32.213	released	2026-05-20 06:31:53.032	2026-05-20 06:33:32.22
a254566e-442a-4e86-8166-f7fa6a3afe87	c9868115-ff99-403c-8e87-06124ba7df66	46541468-ee50-4fab-bd02-4250162c40e6	2	4096	2048	8	2026-05-18 18:04:03.806	2026-05-20 07:21:56.403	released	2026-05-18 18:04:03.806	2026-05-20 07:21:56.409
bc9d4d57-8178-45dd-a5eb-08f2ec78eadc	c9868115-ff99-403c-8e87-06124ba7df66	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	4	8192	4096	17	2026-05-20 07:22:16.566	\N	reserved	2026-05-20 07:22:16.566	2026-05-20 07:22:16.566
4e667881-fdfb-499e-9859-71c61b239cd5	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	12	32768	16384	67	2026-05-20 08:11:23.218	2026-05-21 05:35:38.524	released	2026-05-20 08:11:23.218	2026-05-21 05:35:38.536
e1a1cc69-4544-471f-b375-8afe18980727	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	f644f81d-3b03-46c3-bfdb-d098923af02c	2	4096	2048	8	2026-05-20 06:36:04.904	2026-05-21 10:38:17.196	released	2026-05-20 06:36:04.904	2026-05-21 10:38:17.201
cf566e33-3cab-4801-a97a-ca0a31f061de	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	378ec15c-cec4-4864-98da-49821b126fb4	2	4096	2048	8	2026-05-21 10:42:11.947	2026-05-21 10:45:00.142	released	2026-05-21 10:42:11.947	2026-05-21 10:45:00.149
7fb39b39-3819-4231-90c6-6fc53fd97336	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	8095cdef-8105-40bc-84a1-4510c81383d0	8	16384	8192	33	2026-05-21 10:44:13.464	2026-05-21 10:45:07.609	released	2026-05-21 10:44:13.464	2026-05-21 10:45:07.634
b2f91b8c-0f83-4901-84b3-f10a309ae02e	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	d610682f-7028-42ca-93e2-0fbc64499b17	8	16384	8192	33	2026-05-21 10:46:21.621	2026-05-21 10:50:00.052	released	2026-05-21 10:46:21.621	2026-05-21 10:50:00.061
6da5fb17-ddc9-45e2-9aad-efdc0dd664e6	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	5474b5dc-6ff2-4688-95b3-b9281bec70de	12	32768	16384	67	2026-05-21 11:14:27.265	\N	reserved	2026-05-21 11:14:27.265	2026-05-21 11:14:27.265
d7706a8e-6c71-4af7-9995-5b97bc1507e5	c9868115-ff99-403c-8e87-06124ba7df66	79e8882e-3f8a-4440-b752-87ce59369923	8	16384	8192	33	2026-05-21 11:38:08.111	\N	reserved	2026-05-21 11:38:08.111	2026-05-21 11:38:08.111
\.


--
-- TOC entry 6032 (class 0 OID 151724)
-- Dependencies: 250
-- Data for Name: nodes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nodes (id, hostname, display_name, ip_management, ip_compute, ip_storage, cpu_model, total_vcpu, total_memory_mb, total_gpu_vram_mb, gpu_model, nvme_total_gb, allocated_vcpu, allocated_memory_mb, allocated_gpu_vram_mb, max_concurrent_sessions, status, last_heartbeat_at, metadata, created_at, updated_at, created_by, updated_by, current_session_count, last_resource_sync_at, session_orchestration_port, storage_provision_port, nvme_of_port, storage_headroom_gb) FROM stdin;
c9868115-ff99-403c-8e87-06124ba7df66	laas-node-01	LaaS Node 01 — RTX 4090	100.88.57.107	100.88.57.107	10.10.100.99	AMD Ryzen 9 7950X3D	16	65536	24576	RTX 4090	2000	12	24576	12288	8	healthy	2026-05-21 15:24:00.494	{"smTotal": 128, "cudaArch": "sm_89", "reservedVcpu": 2, "driverVersion": "565.x", "allocatableVcpu": 14, "reservedMemoryMb": 10240, "reservedGpuVramMb": 1024, "allocatableMemoryMb": 55296, "allocatableGpuVramMb": 23552}	2026-04-08 01:52:12.012	2026-05-21 15:24:00.502	\N	\N	2	\N	9998	9999	4420	15
16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	laas-node-02	LaaS Node 02 — RTX 4090	100.94.157.114	100.94.157.114	10.10.100.88	AMD Ryzen 9 7950X3D	16	65536	24576	RTX 4090	2000	12	32768	16384	8	healthy	2026-05-21 15:24:01.065	{"smTotal": 128, "cudaArch": "sm_89", "reservedVcpu": 2, "driverVersion": "565.x", "allocatableVcpu": 14, "reservedMemoryMb": 10240, "reservedGpuVramMb": 1024, "allocatableMemoryMb": 55296, "allocatableGpuVramMb": 23552}	2026-04-26 12:53:44.426	2026-05-21 15:24:01.068	\N	\N	1	\N	9998	9999	4420	15
\.


--
-- TOC entry 6033 (class 0 OID 151754)
-- Dependencies: 251
-- Data for Name: notification_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_templates (id, slug, channel, subject_template, body_template, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6034 (class 0 OID 151766)
-- Dependencies: 252
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, user_id, template_id, channel, title, body, data, status, sent_at, read_at, delivery_attempts, last_delivery_error, delivery_confirmed_at, created_at) FROM stdin;
\.


--
-- TOC entry 6035 (class 0 OID 151779)
-- Dependencies: 253
-- Data for Name: org_contracts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org_contracts (id, organization_id, contract_name, starts_at, ends_at, max_seats, billing_model, total_credits_cents, used_credits_cents, status, notes, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6036 (class 0 OID 151793)
-- Dependencies: 254
-- Data for Name: org_resource_quotas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org_resource_quotas (id, organization_id, max_concurrent_sessions_per_org, max_concurrent_stateful_per_user, max_concurrent_ephemeral_per_user, max_registered_users, max_storage_per_user_mb, allowed_session_types, max_booking_hours_per_day, max_gpu_vram_mb_total, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6037 (class 0 OID 151809)
-- Dependencies: 255
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (name, slug, logo_url, billing_email, is_active, created_at, updated_at, deleted_at, created_by, updated_by, id, org_type, university_id) FROM stdin;
Public	public	\N	\N	t	2026-04-08 01:52:11.915	2026-04-08 01:52:11.915	\N	\N	\N	07b07401-b326-4045-af3a-44a7c45e56d8	public_	\N
LaaS Academy	laas-academy	\N	\N	t	2026-04-08 01:52:11.93	2026-04-08 01:52:11.93	\N	\N	\N	0cdb29b2-5017-450d-97e4-71b80be8b535	university	\N
KSRCE	ksrce	\N	\N	t	2026-04-08 01:52:11.957	2026-04-08 01:52:11.957	\N	\N	\N	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	university	f213bc95-2fe5-4401-94c1-39efeaa39a5a
\.


--
-- TOC entry 6038 (class 0 OID 151823)
-- Dependencies: 256
-- Data for Name: os_switch_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.os_switch_history (id, user_id, old_os, new_os, old_volume_id, new_volume_id, confirmation_text, ip_address, created_at, created_by) FROM stdin;
\.


--
-- TOC entry 6039 (class 0 OID 151833)
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
\.


--
-- TOC entry 6040 (class 0 OID 151847)
-- Dependencies: 258
-- Data for Name: payment_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_transactions (id, user_id, gateway, gateway_txn_id, gateway_order_id, amount_cents, currency, status, gateway_response, refund_amount_cents, refunded_at, created_at, updated_at, created_by, updated_by) FROM stdin;
1acbc4e6-ec5a-4285-9344-d9ef9f71f43e	8d40647d-da49-4490-ada6-3bfa2205366c	razorpay	pay_SqjXmQhsI6T07I	order_SqjVyj8OktGOoT	500000	INR	completed	{"verified_at": "2026-05-18T06:48:37.639Z", "razorpay_order_id": "order_SqjVyj8OktGOoT", "razorpay_signature": "e4e10a08ef0023fbd8d99fcf86b66c721a8d91fd7469364179b37773c5c7dd3b", "razorpay_payment_id": "pay_SqjXmQhsI6T07I"}	\N	\N	2026-05-18 06:46:36.783	2026-05-18 06:48:37.65	\N	\N
80b2ca83-1f4f-4abe-aa7c-153fab0f0b7f	8d40647d-da49-4490-ada6-3bfa2205366c	razorpay	pay_SqnkNFmFcGZ5Pq	order_SqnkGQeVYCBD0l	1000000	INR	completed	{"verified_at": "2026-05-18T10:55:22.411Z", "razorpay_order_id": "order_SqnkGQeVYCBD0l", "razorpay_signature": "b009ed482310231625b7f528b4fd902221f2d5d81f815434ba542cdc2e2dbee1", "razorpay_payment_id": "pay_SqnkNFmFcGZ5Pq"}	\N	\N	2026-05-18 10:54:54.456	2026-05-18 10:55:22.419	\N	\N
0cd05c85-58c5-4b9e-89d5-c950e6ae2506	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	razorpay	\N	order_Sqnph0BM9PXQRs	500000	INR	pending	\N	\N	\N	2026-05-18 11:00:02.833	2026-05-18 11:00:02.833	\N	\N
39891e7a-1510-4e43-92c8-2b8cd34c8479	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	razorpay	pay_SqnpvbESflrYIa	order_SqnpqPtW55StmE	100000	INR	completed	{"verified_at": "2026-05-18T11:00:35.643Z", "razorpay_order_id": "order_SqnpqPtW55StmE", "razorpay_signature": "e4191ea0ecd88131f335b1b77c3a126052b0e54e073ca60094e4e226b1449f9c", "razorpay_payment_id": "pay_SqnpvbESflrYIa"}	\N	\N	2026-05-18 11:00:11.427	2026-05-18 11:00:35.646	\N	\N
0cf9314e-2df0-4d34-b915-b9378ef9e80e	8d40647d-da49-4490-ada6-3bfa2205366c	razorpay	pay_SrQHMcicWctmok	order_SrQHFMNLq2udMe	500000	INR	completed	{"verified_at": "2026-05-20T00:36:54.680Z", "razorpay_order_id": "order_SrQHFMNLq2udMe", "razorpay_signature": "a0c77e1a815ff25746b2b1ba356677ce0fd51610bff69d929cc34e3b28b992e6", "razorpay_payment_id": "pay_SrQHMcicWctmok"}	\N	\N	2026-05-20 00:36:29.321	2026-05-20 00:36:54.682	\N	\N
55235568-d14f-4bf0-ab1e-7881b86c8380	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	razorpay	pay_SrWOYrhM1Bqmz6	order_SrWOQhOnQ5FfQa	250000	INR	completed	{"verified_at": "2026-05-20T06:35:55.879Z", "razorpay_order_id": "order_SrWOQhOnQ5FfQa", "razorpay_signature": "8776e21ab9fa4878f3d7bb5750c796cd934ae612229e72f3c6d24a38412efe98", "razorpay_payment_id": "pay_SrWOYrhM1Bqmz6"}	\N	\N	2026-05-20 06:35:26.529	2026-05-20 06:35:55.881	\N	\N
002c0ee1-7d59-4080-a8d9-abf6222a321b	f3a5cce9-059c-4828-ac18-61164c28e868	razorpay	pay_SrXe5Qpo4pZxKm	order_SrXdxx240wIdEp	100000	INR	completed	{"verified_at": "2026-05-20T07:49:19.071Z", "razorpay_order_id": "order_SrXdxx240wIdEp", "razorpay_signature": "d8a6de6b653594b7d5a09ba05e67ffe5839b9da8b84e8fce623b5d42e610e867", "razorpay_payment_id": "pay_SrXe5Qpo4pZxKm"}	\N	\N	2026-05-20 07:48:50.731	2026-05-20 07:49:19.073	\N	\N
6f340ec5-8ca1-4005-96cf-e37ef777e84a	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	razorpay	\N	order_Srvw1KVBjNziat	100000	INR	pending	\N	\N	\N	2026-05-21 07:34:34.688	2026-05-21 07:34:34.688	\N	\N
\.


--
-- TOC entry 6041 (class 0 OID 151862)
-- Dependencies: 259
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (code, description, module, created_at, updated_at, created_by, updated_by, id) FROM stdin;
\.


--
-- TOC entry 6042 (class 0 OID 151872)
-- Dependencies: 260
-- Data for Name: project_showcases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_showcases (id, user_id, organization_id, title, description, project_url, thumbnail_url, tags, is_featured, view_count, like_count, status, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6043 (class 0 OID 151891)
-- Dependencies: 261
-- Data for Name: recommendation_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recommendation_sessions (id, user_id, workload_description, document_file_name, document_extracted_text, analysis_result, analysis_quality, analysis_confidence, detected_goal, detected_vram_gb, detected_intensity, detected_frameworks, selected_goal, selected_dataset_size, selected_intensity, selected_budget_type, selected_budget_amount, selected_duration, goal_auto_selected, dataset_auto_selected, intensity_auto_selected, recommendations, selected_config_slug, created_at, updated_at, completed_at) FROM stdin;
33bcc03d-56d3-4e5e-afea-55744edd0f35	f3a5cce9-059c-4828-ac18-61164c28e868	We're building a product that uses AI to remove backgrounds and add VFX effects to user uploaded videos in real time. Need a dev environment to prototype the pipeline — probably ffmpeg + torch + some custom CUDA kernels. Not sure about exact specs yet tbh	\N	\N	{"confidence": 0.8, "keyInsights": ["The project involves real-time video processing, which requires decent compute resources.", "Using AI for background removal and VFX indicates a need for GPU support.", "Prototyping suggests an iterative development environment is necessary."], "suggestions": "Consider specifying the expected volume of video processing to refine compute needs further.", "detectedGoal": "general_dev", "inputQuality": "sufficient", "fieldConfidence": {"goal": 0.9, "vram": 0.8, "intensity": 0.7}, "missingCategories": [], "detectedFrameworks": ["torch", "ffmpeg"], "datasetSizeCategory": "unknown", "estimatedVramNeedGb": 4, "estimatedComputeIntensity": "medium"}	sufficient	0.8	general_dev	4	medium	{torch,ffmpeg}	\N	\N	\N	\N	\N	\N	f	f	f	\N	\N	2026-05-20 07:54:17.136	2026-05-20 07:54:17.136	\N
31ca3fdd-1bc4-4e05-b1bc-067139a7065b	f3a5cce9-059c-4828-ac18-61164c28e868	We're building a product that uses AI to remove backgrounds and add VFX effects to user uploaded videos in real time. Need a dev environment to prototype the pipeline — probably ffmpeg + torch + some custom CUDA kernels. Not sure about exact specs yet tbh	\N	\N	{"confidence": 0.8, "keyInsights": ["The project involves real-time video processing, indicating a need for decent CPU and GPU resources.", "Using CUDA kernels suggests a focus on performance, which may require higher VRAM for efficient processing.", "Prototyping a pipeline indicates a need for a flexible development environment."], "suggestions": "Consider specifying the expected video resolution and the number of concurrent users for better analysis.", "detectedGoal": "general_dev", "inputQuality": "sufficient", "fieldConfidence": {"goal": 0.9, "vram": 0.8, "intensity": 0.7}, "missingCategories": [], "detectedFrameworks": ["torch", "ffmpeg"], "datasetSizeCategory": "unknown", "estimatedVramNeedGb": 4, "estimatedComputeIntensity": "medium"}	sufficient	0.8	general_dev	4	medium	{torch,ffmpeg}	\N	\N	\N	\N	\N	\N	f	f	f	\N	supernova	2026-05-20 07:59:52.286	2026-05-20 08:02:36.984	2026-05-20 08:02:36.961
\.


--
-- TOC entry 6044 (class 0 OID 151908)
-- Dependencies: 262
-- Data for Name: referral_conversions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.referral_conversions (id, referral_id, referrer_user_id, referred_user_id, status, signup_method, signup_completed_at, first_payment_at, first_payment_amount_cents, first_payment_txn_id, reward_amount_cents, reward_status, reward_credited_at, reward_wallet_txn_id, metadata, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 6045 (class 0 OID 151929)
-- Dependencies: 263
-- Data for Name: referral_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.referral_events (id, referral_id, referral_conversion_id, event_type, previous_status, new_status, metadata, actor_type, actor_id, created_at) FROM stdin;
\.


--
-- TOC entry 6046 (class 0 OID 151940)
-- Dependencies: 264
-- Data for Name: referrals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.referrals (id, referrer_user_id, referral_code, referral_url, is_active, total_clicks, total_signups, total_rewards_cents, expires_at, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 6047 (class 0 OID 151960)
-- Dependencies: 265
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refresh_tokens (token_hash, "deviceInfo", ip_address, expires_at, revoked_at, created_at, token_version, id, user_id) FROM stdin;
$2b$10$iKWTf31eYpOO8POjJAVZ4uKE282Pl/.5KEmZafGw2E7C3m6i1AJBy	\N	\N	2026-05-25 06:24:22.415	\N	2026-05-18 06:24:22.416	0	193bb615-7fbf-4367-9835-3728ac7f2ece	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$yns/Px3R4LL4UFLRyqlSBuvQUWpPrclXp35VQuRaL2Pt23hUiAnpm	\N	\N	2026-05-25 06:26:45.324	\N	2026-05-18 06:26:45.327	0	6121e510-fdcd-4d4f-a248-555916fc2b6b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$nJLWp/KidqM4Tdw0F5SYl.wHNk5bxIW7llDvcdHkZhqKvBb.aiPoG	\N	\N	2026-05-25 06:46:24.1	\N	2026-05-18 06:46:24.102	0	41c05e24-cc44-457c-b65e-c8425adb24e4	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$yu3yMnwC8wN8BfNliD0s1eeaeeTe/kTpkVD.q6qOfeouFaj0Wr6Qe	\N	\N	2026-05-25 07:03:13.675	\N	2026-05-18 07:03:13.676	0	0347c4db-0864-4adb-8905-ab53ace67e9e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Bz6jvaVq.PXLaWY6XozcOO4zkLgQfi3zfiHa2SOB25mPvUj7obAuy	\N	\N	2026-05-25 07:29:34.675	\N	2026-05-18 07:29:34.677	0	ca44d574-264f-43fa-aa7e-1584038c94f6	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$hL/d7ZCv9L.VzXe/V47dlO6l.h7ba0fG5985jyA4tytg569C83PAu	\N	\N	2026-05-25 07:29:55.097	\N	2026-05-18 07:29:55.1	0	a604d1ef-b0e1-4f0c-8a69-6d390223bbb4	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$qCRItZ9U1pQr5tjtCmjwOOHrVBk4JVTyXx6./c/H/hfevTe1ZXgZu	\N	\N	2026-05-25 08:22:40.067	\N	2026-05-18 08:22:40.069	0	a89f31aa-b1e8-4c94-98a2-692ae433c0f3	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$tSe8KCgbgIhV/pgfnXycCeubg8KBquXo2EpKPKR3ezyYI/SxmvILO	\N	\N	2026-05-25 08:22:26.941	2026-05-18 08:35:30.705	2026-05-18 08:22:26.944	0	5beff1f7-c111-49b2-87b3-544a541f7d91	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$S/m4sHEor1UZf3bo37lsEO/6T7jD991sUheo8fyMoMkt2/qva9QJC	\N	\N	2026-05-25 08:40:31.504	\N	2026-05-18 08:40:31.506	0	b31a7887-1b8e-4005-b018-db49c360bd90	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$f1D30/PpFl7/iN.vTqedY.QKBaXAaizCQb02T7/h.jc5tpwu12pLi	\N	\N	2026-05-25 08:57:46.998	\N	2026-05-18 08:57:47	0	299b6208-cca3-4c48-aa00-10fa194f6316	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$XMJlqqfV8pozDJNdfXm2j.AGDjTLjsM4wekHU0UJUY1yA97nCOHpK	\N	\N	2026-05-25 09:13:57.215	\N	2026-05-18 09:13:57.216	0	2c5f0ef4-ad0f-4fb2-9210-60177905e81f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$..UG72Fw5pdE3.vRzlbLuOzP6ZnJce12/BUqOZcTGCZZDYEwizIYu	\N	\N	2026-05-25 09:14:30.615	2026-05-18 09:27:30.805	2026-05-18 09:14:30.617	0	1f1eb5a6-7f69-41b0-a96b-54dac97fad22	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$IL5oLC7SYnmSlukJhjwN8ugMf2JmkZKZesqPaw.j8KoGFTdZAPrwy	\N	\N	2026-05-25 09:40:31.068	2026-05-18 09:54:20.495	2026-05-18 09:40:31.07	0	083160cb-d4e7-4155-b168-ffd3cc436ceb	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$pckbocwt8RNFanbyrfqMDecxdrWLSVDHGxckdSwSxVl9jPDitDYH6	\N	\N	2026-05-22 07:58:11.016	\N	2026-05-15 07:58:11.018	0	a4cc127e-4bb6-46ce-9f7b-4995a0228523	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$I0AXh.n1/6J7fTviqrpHd.BAqlLZg8DPBj4CK8AVd/DRdE.BQl0.2	\N	\N	2026-05-22 07:58:44.638	2026-05-15 09:36:04.234	2026-05-15 07:58:44.64	0	bbe29db1-2236-4ee1-bbde-8d9253981a33	bd8f8f80-a9ab-43e9-999f-b653f359e4c9
$2b$10$MhVlU4I5v5uzSy6bOuhuy.cTUkdUyGeE53t.Virl2B9Le/9htcmdy	\N	\N	2026-05-22 09:36:04.906	2026-05-15 09:51:25.155	2026-05-15 09:36:04.908	0	36df00d9-aeca-4a2d-8a25-bc849eeb7b1c	bd8f8f80-a9ab-43e9-999f-b653f359e4c9
$2b$10$CPk2lAkSYGsQBl0DbbHr1.j.E4.7bdglL74zY4AkXZGBD1jQ/55Na	\N	\N	2026-05-22 09:51:25.443	\N	2026-05-15 09:51:25.446	0	392fa428-b474-40fe-bf0c-5e34c3124f1c	bd8f8f80-a9ab-43e9-999f-b653f359e4c9
$2b$10$ECHoZvD5U0IFR/RSVJ6GBuXTOLMlTRmwAuHVZdsbPns7yAWmR2gJ.	\N	\N	2026-05-25 09:57:26.518	\N	2026-05-18 09:57:26.52	0	06fb9553-e07c-4383-9a03-25d18599f7c0	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$lNCj27iKUs5MyA/fK.bmtunKECagi9WtfXCaWhr8hutgxJz6k67zq	\N	\N	2026-05-22 10:00:34.652	\N	2026-05-15 10:00:34.654	0	353f5cf6-9f80-4116-8f0b-fae96a3916a4	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$chYIhwG3niYKkDbYn4CyAewgaTxOjwQVSiOMOyufsfG0vAGTo4kmK	\N	\N	2026-05-25 10:06:47.743	\N	2026-05-18 10:06:47.745	0	c91123cd-aa2f-48ac-89c2-1491a4f1b676	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$NaornSi4f9945/kAThzrduGMpoB2xlYwlCPCgm5cmfKMLI5/7hRNO	\N	\N	2026-05-25 10:20:57.922	2026-05-18 10:34:01.473	2026-05-18 10:20:57.923	0	748c1d5f-203f-475d-ab5c-013fab069371	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$HVzTcs51lFuHgiS4UUd1z.Ffw/WSxy9O2L8FcEPP/jRSh4VjhjJrW	\N	\N	2026-05-22 10:15:56.232	\N	2026-05-15 10:15:56.233	0	d38ac0e4-3d62-4572-94f1-bd94d770abd9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$PIn3Va6apBnMctprmxy85eyHcfxhI5IPwX/sYwY8lKZ/OCpGmCmfi	\N	\N	2026-05-22 11:23:16.622	\N	2026-05-15 11:23:16.624	0	229ee5cc-6e32-42be-9e75-2dc120875065	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$vZ00qxwxLh9AGQoJbysHWez.XoHYKnQ1oCJV/N6NgxEgXQsz0hyPi	\N	\N	2026-05-25 10:34:01.603	2026-05-18 10:47:30.516	2026-05-18 10:34:01.604	0	bcc68738-0e73-4e16-86a9-a13ab5a6887b	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$2R6DffBz3umiiFf9hnJSLOycydoOTwlkHW73rczNqc/eFKPz2h51O	\N	\N	2026-05-22 11:53:45.035	\N	2026-05-15 11:53:45.037	0	667551c1-8fe9-4570-96d6-e01213a4f0fd	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$3N8ZzZWmN0x8rgjEWRSSmuuj39GHOEZY/CGBZuxQN8i3awEnuyaLK	\N	\N	2026-05-22 13:34:01.219	\N	2026-05-15 13:34:01.22	0	7275d5c9-ab2e-4eea-8098-d55fffe935b9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$GcOK97uAz7oqh.bynmVu3.Tv1yjeE0lHywPlce0Tjp5odXXD7MLZC	\N	\N	2026-05-23 06:22:31.815	\N	2026-05-16 06:22:31.816	0	7cfe1415-8d4c-48c7-af67-870261b56a8f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$evYDeAmcw2C51vE7EuUGl.mbvyk.qlM5kMe.XKkwxKsyKoNw33gzu	\N	\N	2026-05-23 07:18:37.636	\N	2026-05-16 07:18:37.638	0	681d4f64-603d-4b27-8383-01fcc1280932	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Mwme/E.VkHWqg9/9Qlw5yemJJcA2mBaJYsfsgnBL.9QOMZ0bEeu1.	\N	\N	2026-05-23 07:37:53.37	\N	2026-05-16 07:37:53.373	0	cb0e8413-9755-4dbd-8314-fd459e844ef9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Y5myUJBzWRfSwIoEJzQUv.broRu67wB8HDctr6qghdEPuXocIoyx.	\N	\N	2026-05-24 08:58:39.838	\N	2026-05-17 08:58:39.84	0	eac30210-c8d9-4d9b-aaef-c675ac7f8b7a	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$tkqCf4KCKx94vK0pkP6ib.J/m5ju/4D4iODLCih6ot.uJPUslXVw6	\N	\N	2026-05-24 09:15:10.648	\N	2026-05-17 09:15:10.651	0	dd24b467-d74c-4cc1-bf48-c0062c0049b9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$KGZa7dkP0bd9YwBQ96jm6.7jbbhIA18cAxVRmaxRoZqD/t69NlTBy	\N	\N	2026-05-25 10:47:30.646	\N	2026-05-18 10:47:30.648	0	67fe3219-2987-4c00-a7dd-f48a54b29630	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$9/KMMguJT9cN09gZ788vIupnAr5hmosy3QyD5vQtA7/L4b3RLoopa	\N	\N	2026-05-25 10:59:24.779	\N	2026-05-18 10:59:24.78	0	45716434-bfc0-4045-b70b-e062e3946438	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6
$2b$10$Q7Wx1WwEvsn9ruuR.zdP3ud1MR.HIHY087Pq98A6NJd.kGLgDju9W	\N	\N	2026-05-24 09:20:18.589	\N	2026-05-17 09:20:18.591	0	e9fee3d8-1518-43f0-bfd8-cc64537653b2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$znBRrfrVgR4RJ7sqgKyQvuT1VesczuXpEQ7PVAxrljiYcf1U0yNpq	\N	\N	2026-05-25 11:05:22.509	\N	2026-05-18 11:05:22.511	0	84bc600d-0e57-4dc0-8bad-503e5004e15b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Fo.YV14ygIixhwckPPTmU.HtHvpXGr8VWkz25pFHIA8TDrgL3vF7e	\N	\N	2026-05-24 10:09:30.424	\N	2026-05-17 10:09:30.426	0	c7b1ac2e-4b48-428c-bd38-8679f8b574f4	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$1AKKc8mlvdqsdZrpw7VK8uS95B6u4s1tmsNB62updFmR4cB078EsK	\N	\N	2026-05-25 11:22:07.285	\N	2026-05-18 11:22:07.286	0	37ec3edd-127a-482d-9761-adeecf6d0c38	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$jYQKjD01uY6a1eCArWl1FOvxh8AkJv3BZpMNj7nooeIJyWaE/1/Jm	\N	\N	2026-05-25 11:43:00.788	\N	2026-05-18 11:43:00.791	0	0180dd50-c4fc-4ee7-864d-c9e4fdec2375	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$RFtHkJVPzjxmcKwN7wQgk./QipElwAVesSNoG0Vh3bV0fTenJKrPC	\N	\N	2026-05-24 10:27:46.041	\N	2026-05-17 10:27:46.042	0	1c416735-1400-4d80-a920-cfe8c5fc3bd9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$bKFCQErd/QZf7YJzcN0hae7NLqLJINK/pzZK0lmyRh2v389xRQJ8C	\N	\N	2026-05-25 11:58:41.109	\N	2026-05-18 11:58:41.11	0	e522abbb-48e7-4bb5-aab5-a566ebda425a	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$liD295j2LwoUAZW9iHxz..K0PC/hF5FdpFlB3cqxA7Qbva9JHq06u	\N	\N	2026-05-25 12:37:33.065	\N	2026-05-18 12:37:33.067	0	eca32cf5-b663-487a-9289-55990d7ec7ae	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$gzc3QFED2sqMvrYyf9o7UeZqfwXuZ0M6m9vF31iS9e7c8HqWf18Oa	\N	\N	2026-05-25 12:52:15.148	2026-05-18 13:05:30.471	2026-05-18 12:52:15.15	0	def6902b-f6e4-4422-aa5d-92f34f0698fe	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$XTMndgZnKKED7Xa4omqF6.8QLQAi.v767coGPdCrJ/7YXwyqIzgdW	\N	\N	2026-05-25 17:06:51.126	\N	2026-05-18 17:06:51.128	0	72bda6ef-f491-42f8-9243-28b04db780ae	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$AdEpeivr9eeWs6dQJ7LJOuhkOgW1b1D3.vtyy9TgKlj9c4z.Wa/fK	\N	\N	2026-05-25 13:05:30.574	2026-05-18 16:46:22.301	2026-05-18 13:05:30.575	0	fb23400b-343f-408d-81d5-efdd1aa9e75d	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$3tfYI3h9l3jZO8w2KqRyF.V2g7.kyuLNn0Quzu/OI39XfGRua/GGW	\N	\N	2026-05-25 16:49:01.482	\N	2026-05-18 16:49:01.484	0	0b602ab0-40c8-47ac-8020-e7ba96718410	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$bXaQPYm.Ku31lhZdSf5.JejtO9otTrobny/.YK/1IqURj/ieIdNUq	\N	\N	2026-05-24 11:57:24.95	\N	2026-05-17 11:57:24.952	0	6b3b4272-30b6-4ebe-b976-36d2aef0f102	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$kRift7kT5kh48Fib1axMxuA7xqZeucxe9BTpw5j4Ht/a4Zcm2uEte	\N	\N	2026-05-25 17:23:58.34	\N	2026-05-18 17:23:58.341	0	5d00aa29-ddfb-47d4-ac20-229550dbeab2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$rtalU/nJmi89r2fIE8Nju.OwnxndI3vnS0K2s2kJ.lQcp59MoEoQW	\N	\N	2026-05-25 17:41:40.091	\N	2026-05-18 17:41:40.092	0	c9619da2-96c2-441c-9fec-2981504cfcd1	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$FJOLsO2iNRz1Q.0tgt2apeA17U2urZYJ3XyHN0qtE6OxFv.N5ME1C	\N	\N	2026-05-25 17:41:23.007	2026-05-18 17:54:22.937	2026-05-18 17:41:23.008	0	95191f91-f4d9-4fa1-96a5-182cad7cefbb	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$9WD71w./M/wgT4kQN1HAUeejeIyXDjV.LQoZB6RtrxuVTsPgIpl.m	\N	\N	2026-05-24 12:28:09.651	\N	2026-05-17 12:28:09.653	0	52f4b781-2cf8-42ef-a0e6-cd4b4c67b4bb	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$CqN9F0lZQ3Cirjg8O9r34OchA..ZWPuay0peofQwEBfPlYHx0hqa.	\N	\N	2026-05-25 06:24:55.378	\N	2026-05-18 06:24:55.38	0	a417cc9d-18b4-46e4-a565-cee81045e37e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$XzCC1TpZyN88fBZ0wuFbqOZ0ShH8zyZ21G0bZ2pHFhtjkawZmaQr2	\N	\N	2026-05-25 06:45:44.695	2026-05-18 06:59:33.452	2026-05-18 06:45:44.697	0	f934c354-a322-4beb-9c89-556dc10c7f0e	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$LNGvbPxtBFs4n7.ewMu9a.Todra39XI2TsV0f9h9qmx317TlJBL3.	\N	\N	2026-05-25 06:59:33.659	2026-05-18 07:12:33.438	2026-05-18 06:59:33.66	0	b9139752-9102-4f7f-a832-4dbcf92d896b	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$KJ/d6Fy4KGPto3dZfntFX.jNIR2E8.1sIxBRI7WeA4dqA7e47duPq	\N	\N	2026-05-24 14:28:37.945	\N	2026-05-17 14:28:37.946	0	25476c0b-05cc-445d-bffd-0606bd9496d8	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$piElnGeYBDRNqTJOHwKTO.KAcUGsJ0PyCCQnZcWckzyMSuEiNyeRy	\N	\N	2026-05-25 07:12:33.578	\N	2026-05-18 07:12:33.579	0	03f98ed3-0d2b-4fad-a79c-ff8ddd4e204c	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$6rDr4XDpj3PIRr6kf1K5yeAYY83IP0XyKVc7Hse3JUUfsh2fQuzq6	\N	\N	2026-05-24 14:53:16.658	\N	2026-05-17 14:53:16.659	0	502bfcd8-010c-4ebc-b330-3f4ee9945c64	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$xwNC1KVPgOHEspK2dxv/q.52esg4zEhdEYvdEVLSRjK.u/XxcpXga	\N	\N	2026-05-25 08:35:31.072	2026-05-18 08:48:30.584	2026-05-18 08:35:31.074	0	ba861b82-fe7a-4b06-b33f-b9b81ad9fe55	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$1Qvx71oFFBfMlSIFrt.Uc.WDN.8wP1OL4i2QS4fJ5Gg2woJsNKfb2	\N	\N	2026-05-25 08:48:30.819	2026-05-18 09:01:30.595	2026-05-18 08:48:30.82	0	9936e0e5-e431-423c-aa89-6111e345325c	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$whNmi3TXf2bMz4g6WiathuVhqQyhBSEbEMd.MgSVDQPX4h7DzZYSO	\N	\N	2026-05-25 09:01:30.839	2026-05-18 09:14:30.489	2026-05-18 09:01:30.84	0	0adabc0c-4b08-4dff-b12d-636e55787274	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$RbuNSfgDky3xABFdCwmQzOkb1WfBc2HdSSyEhRMAmLITn2eZorzG6	\N	\N	2026-05-25 09:31:11.44	\N	2026-05-18 09:31:11.441	0	c8a1f4bd-3736-4802-9562-947e6c3a9046	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$OgRRKcAt2u/Gfxfoifrz/.IooGF.8DmLsoAMrp0DCSyn3cqWuX3EW	\N	\N	2026-05-25 09:31:37.422	\N	2026-05-18 09:31:37.423	0	f592ab2c-0d0f-48c7-a49f-4f3961d13a1d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$.Ntg61DfSv/tlzvcPBogXuhmnFdLyVJPQ5knhoiMJRRo9PwMBtLN2	\N	\N	2026-05-25 09:27:30.94	2026-05-18 09:40:30.72	2026-05-18 09:27:30.942	0	432f56d6-b6f0-4f34-86d6-15fafdc00fc5	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$kw5CpagbLsVKKx9J5OEoiOLlfHzaO9/FfAB8krGzEMrdUITJvb09a	\N	\N	2026-05-25 10:01:28.18	\N	2026-05-18 10:01:28.182	0	1c35d673-ab34-41cb-b09a-e099b02dbf95	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$skNBoD1pu85CeGX8p3cxDOLyiPzwR9/v5MlnozJPA7hWUqolRNYRC	\N	\N	2026-05-25 09:54:20.612	2026-05-18 10:07:30.51	2026-05-18 09:54:20.613	0	5ce96b16-c37b-4de7-98d5-6e011ac738f1	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$.eT.rNz/UD5FbebrFmJvUuh2haseToKWYlmk4RqHOepzqTMS58AeW	\N	\N	2026-05-25 10:07:30.65	2026-05-18 10:20:57.668	2026-05-18 10:07:30.651	0	f8654551-e576-4e75-9cea-f6c07fc2cab2	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$J6tbhUfE0dyQFEnQlHfxDuOVAsjdzVBe9/tAfKwNQmrai.BPWXPe.	\N	\N	2026-05-25 10:22:26.63	\N	2026-05-18 10:22:26.631	0	a9a3169b-2bfa-4038-91d9-56a03184e07a	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$xq58DPDzWcqv49CxhRnfxeQxau82Zt57GqLISpQPsbl5PLIRCzV4e	\N	\N	2026-05-25 10:39:24.364	\N	2026-05-18 10:39:24.367	0	5201135c-adc5-4252-bb9e-13073bd808f2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$I.9qL.MzcvsNd3nheiHfPecf5uZ8y02X2hpo6h.n20CO5A9732sjK	\N	\N	2026-05-25 10:49:20.431	\N	2026-05-18 10:49:20.433	0	aa914a0b-1a09-4d3b-b180-ee9029210c15	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$9T4rBaJGMhy.JFjj5IWpheUFhpjU7JmlabHg1w7iYxdzbbtstfjPq	\N	\N	2026-05-25 11:05:00.126	2026-05-18 11:18:30.554	2026-05-18 11:05:00.128	0	4a116d6a-803a-4cfc-987f-cc98ba37dbec	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$ZsMzk739.yb138/gNeqtJulFKC4REcuVRzXs50/R.H.DuraFDtcF6	\N	\N	2026-05-25 11:18:30.708	2026-05-18 11:31:30.539	2026-05-18 11:18:30.709	0	2b0c3b35-97fe-4dcd-a3c7-b5e27d5e527b	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$Qi1t5q/DXc5f25U4.gcsl.NZa2hYg2XkMgrW9mDWLqI528/JZ4dam	\N	\N	2026-05-25 11:31:30.667	2026-05-18 11:44:49.172	2026-05-18 11:31:30.669	0	9ce9f7e9-475f-4249-8401-4beeedba6d6a	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$eMHpOuVcVvxckYzsGhytmuCYfG6Y4wVzC2KWnx/d63rnMiUofhOAq	\N	\N	2026-05-25 11:44:49.516	\N	2026-05-18 11:44:49.518	0	fff3b762-fa84-40ef-96e1-8ece59459cdd	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$N/1OpDApiYlk/hD6snTaruMADte8FW7ZlB6zTWMzjMFPia3dxTEwO	\N	\N	2026-05-25 12:21:16.795	\N	2026-05-18 12:21:16.798	0	3fdb5fd9-d47c-47d6-b9b4-4ba5dd4a5baf	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$63DkmQC.9YUmZ09yXkyoAeg0f9bZBiqBE4lUI8ok/nGcV5lJWIPBa	\N	\N	2026-05-25 12:39:09.24	2026-05-18 12:52:14.868	2026-05-18 12:39:09.242	0	d7848efc-baf8-4fdf-8a99-d67667b58332	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$npnUIrSITib3k22D4DoMLeum0fcJ3mXiOyYgaRhCl8AnoO.iMzuUS	\N	\N	2026-05-25 12:57:53.895	\N	2026-05-18 12:57:53.896	0	a5ee123f-1fae-4da0-8fef-670d9cf59fa2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$zjWu3QKUUHgibenuOVbgceWfWBh868foUIdNM7HHhEZn.dS0m7PVi	\N	\N	2026-05-24 17:39:38.965	\N	2026-05-17 17:39:38.967	0	ca99e6c5-7385-44ee-ab83-6e26270b789d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$7ZtA0VnzGjVo2Gy.KedkbO7lkFjM8DT/c2e3j0ruFqk63CINRTYS.	\N	\N	2026-05-25 16:46:22.665	\N	2026-05-18 16:46:22.666	0	1c5f5c03-b8b5-4008-a041-011ac70ea275	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$fp2Z9GYX.c6tC/7V9PzFOu7ZXKkTJtIJ68V9Hd8wvx60qE3aUBmM2	\N	\N	2026-05-25 16:46:22.703	2026-05-18 17:00:20.079	2026-05-18 16:46:22.705	0	2f267c76-eaeb-4844-92d4-21cffb483985	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$cm5YSMP5N3ubfTZnIpWK0O9PNbwKTRa6hbVksvXN0WNyDfVNbbUvO	\N	\N	2026-05-24 18:12:51.28	\N	2026-05-17 18:12:51.282	0	db376c80-a448-4528-9281-024c41cc910b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Z/O1xne6VwvOInxM4r/4D.qRs.fKQz3jVxN.Uu8i7L.DZSWIHjjpm	\N	\N	2026-05-24 18:17:18.358	\N	2026-05-17 18:17:18.36	0	ad9875a5-c285-4da0-9933-1b4f23a25805	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$eTD8tRcgLUCkKCgx.0uoQuEdKQMBQ2nQVwaPsnxjuJc1add5tNgfu	\N	\N	2026-05-25 17:00:20.266	2026-05-18 17:14:21.142	2026-05-18 17:00:20.268	0	bd7e6209-fbc1-4a61-a7de-9769f696113e	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$gIDcud.Y0if573CUDmUE2er5vmbkfKbA5/3XZQqkqpyLmKZ7DjKFW	\N	\N	2026-05-24 18:27:54.14	\N	2026-05-17 18:27:54.141	0	9da95577-2136-455d-ba22-934fba268946	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$CxbwsUGJTM.Rmv6X7wmJBeet1kXJGxtbXcMJv6nqQK3Qe8nL70aXG	\N	\N	2026-05-24 18:34:59.482	\N	2026-05-17 18:34:59.483	0	b270a39f-8470-4672-882e-3071271418da	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$WBiKs7UVJZZ.DHTiVaR.wu1fkFH8KqvtRM2c3ogRNqChu0q.ZNT8G	\N	\N	2026-05-25 17:14:21.53	2026-05-18 17:27:22.855	2026-05-18 17:14:21.532	0	f3f7f4fd-234c-4a3b-b782-87b27994a872	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$n7DwrFs4NQcPanoO668R9.cBJjryiCMjcpmfOXdsD3mYDFgIS3bmK	\N	\N	2026-05-24 18:48:59.489	\N	2026-05-17 18:48:59.49	0	3a999925-4ce2-4315-bb9d-c1b73117bed5	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Xrxn5F.8oX2tjsmwP7uPAeksQTz0A6TYnUDjoa0MHdE3YnoQNHA/q	\N	\N	2026-05-25 17:27:22.978	2026-05-18 17:41:22.879	2026-05-18 17:27:22.98	0	1fc84af2-695d-4abf-bf42-e7604ae9b55a	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$WqfRrI4W4UNloL7/eoqy6ufReHBmAAFvJpbq0nFn03vb0hmOc29se	\N	\N	2026-05-24 19:00:12.164	\N	2026-05-17 19:00:12.165	0	acd26203-ea67-4203-a6b0-4ec75b4acf95	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$I1UNnZJrBixUQpzpBoL00.i0ta3hagvYV0yfM7pwnPpGPBXkG.aR2	\N	\N	2026-05-25 04:54:56.176	\N	2026-05-18 04:54:56.177	0	b09f3200-7c10-402a-9caa-5a01570882b9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$JoAXTm5X7uICboWOJQxGzu0Mhuv9s0yifyjDPmjbkPEBUTUcLelIK	\N	\N	2026-05-25 17:59:10.603	\N	2026-05-18 17:59:10.604	0	486e8555-aee7-4868-946a-8ed3a2e18d0f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$KP4NJzboafbyhHPPYGLRxOcq5yw4vTnXsD083S8EJMqFkOyRPmnGe	\N	\N	2026-05-25 04:58:51.224	\N	2026-05-18 04:58:51.225	0	0e0f2bf0-a8d6-45f7-95d3-ed55e620b51b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$nOWV5626KSwzZ49RIXYi6.XKNMlVmxgjjWGknXh.5fcIiijTxbKAi	\N	\N	2026-05-25 17:54:23.107	2026-05-18 18:07:22.864	2026-05-18 17:54:23.109	0	7e7a3002-fcd6-4bc5-8778-cc8d7a729bd2	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$q0IbNhFF1uVWKFPzQTP2a.k4GQObN001B9pOMPTpWSahOfykpmGCy	\N	\N	2026-05-25 05:05:37.58	\N	2026-05-18 05:05:37.591	0	828a52de-0353-4cd7-b6f0-6d6aaef1931e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Q26KfaSXIifnxjFHnrHyXeiFefRivMIIax733Fz0Mi0wH48oHGRPS	\N	\N	2026-05-25 05:08:14.007	\N	2026-05-18 05:08:14.01	0	5441cbf4-96f7-46e4-96f5-62aab4108dcb	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$VYmlNUYJUFXPXTkoLRLoOeo.JUDQ6XYE6fIfpQ3epzh.jMHyRLxPm	\N	\N	2026-05-25 18:07:22.983	2026-05-18 18:20:22.88	2026-05-18 18:07:22.984	0	3537ae16-0f69-4bfb-bb7d-b55856c04c6a	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$sqcVJWc16yIPtQtK1XpC3.ZNJtuRPTd9YtumUPstYqsHoqyPhb3fq	\N	\N	2026-05-25 05:13:52.156	\N	2026-05-18 05:13:52.158	0	8b373861-989b-46d9-b1ef-dc907307dc77	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$hvkxKOHAFTQiWzALwpj4oeVBGwgBN8dtDuft6/RIrIC0wNbXyySoe	\N	\N	2026-05-25 05:21:39.565	\N	2026-05-18 05:21:39.568	0	4c22e200-f931-43af-a3fc-40a2ca674ca7	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$1OzIadbRCLd1Y12cO8OEI.B72xmF7w63.2XuI35AGL3T3s3NKeN4.	\N	\N	2026-05-25 18:20:56.31	\N	2026-05-18 18:20:56.311	0	309234cf-3712-43e0-b1ac-fa61547a7d70	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$t/YizzCkKQO1d9A4281f5uviUx5kUN0Z/g5TWT58lA8qppKAPS3M6	\N	\N	2026-05-25 18:20:23.001	2026-05-18 18:33:38.185	2026-05-18 18:20:23.002	0	e06cc7ae-34a3-440a-9092-8b34f72824c8	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$gH8tHtHuTpY/617qV6EpQubrvEsjTlRHo92JBl2.eaUyj3DZdVsZ.	\N	\N	2026-05-25 18:33:38.288	2026-05-18 18:46:38.285	2026-05-18 18:33:38.289	0	601a95e4-6971-40e8-9af5-3fcd3275f893	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$Qx/3Zs3psU9XDl9hVOWPheNke1tfp/OBAmouXnZdo2ijg8ctjQray	\N	\N	2026-05-25 18:36:48.956	\N	2026-05-18 18:36:48.957	0	10622fdd-ccb1-4162-baee-e7e30f8a883f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$pzC5zT5LrCc5olh/nz0DC.mP.jhNQjaukGNFsfF0ADZ34Y8z4G3FC	\N	\N	2026-05-25 18:58:44.815	\N	2026-05-18 18:58:44.817	0	69e2571a-21d3-4499-8b20-f4118acb0d69	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$SAACBK337ErT9mTUdqlf9O2S94JjT1f1d5Do0OLxE14IwZb.7kYk6	\N	\N	2026-05-25 18:46:38.489	2026-05-18 18:59:38.841	2026-05-18 18:46:38.49	0	6cbc0c28-25b0-425e-867c-cf79b3fd1368	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$y7aetjdRbO1xoQMICG9aAOOTo9woJ67gDiQjzlmyO8Ukd9JzbqQWe	\N	\N	2026-05-25 18:59:38.955	\N	2026-05-18 18:59:38.956	0	7a1bccd4-f81a-4239-9071-294fada2a5a0	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$OEQ4OsYdH1e1JKUk8WPXcOqXLjxrq.VjysXOkZxJ.ev4gm6cD1so6	\N	\N	2026-05-25 19:01:54.68	\N	2026-05-18 19:01:54.682	0	96e2835e-8917-4f61-b84d-029a67fb7aba	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$jCZlG/XGYudBjcxEHYVQv.PZ0oS6lput/T2qca9lLN/Oi7WKxU1ui	\N	\N	2026-05-25 19:21:45.946	\N	2026-05-18 19:21:45.948	0	ff37fb89-36d2-48f6-a570-2a2999503146	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$5QyIAZc5wU3mXjZSFRzrLOB5Dw6UdHY62ceM46xAyFOcUFOnxnt4i	\N	\N	2026-05-25 19:22:53.206	\N	2026-05-18 19:22:53.208	0	167e8d9b-b33f-486b-8ef1-6f890ae87500	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$.0qoOBtmiG3xmSWt7Tl/PunScaB13YC.ak0bD3g37DJYbgF5O.ema	\N	\N	2026-05-26 02:40:32.35	2026-05-19 02:54:12.227	2026-05-19 02:40:32.353	0	7e7e8237-7647-4222-9d94-80d5dea4e538	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$4EgYPW3dJ7FS1kw4jvQIb.hSLSOgRLRW2IkOTxqqQfwfC6ZaSoAJ.	\N	\N	2026-05-25 19:25:12.862	2026-05-18 23:43:40.794	2026-05-18 19:25:12.863	0	739da809-bac5-4247-a0f1-f489efbef8bf	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$9svmg3XuAtygtV87lXeaRuoBJLDNdHY4/7O2VtfnbAVaqz0XAc13u	\N	\N	2026-05-25 23:43:40.92	\N	2026-05-18 23:43:40.922	0	deb16196-d736-446b-af8e-54e517a5ae00	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$eX7S9O2ktaN6im7D5jKz/.1LJ2DJ/j6rbh34YFNxpzs5bvMSmNlva	\N	\N	2026-05-25 23:43:40.921	2026-05-19 00:08:25.536	2026-05-18 23:43:40.923	0	36ea6489-4e04-4a02-87a7-27b627a35d26	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$FoGraa1WgsxzMu.ZOlgb9ewVPgf4Ltz34C9U6nGeTqdBhY.oimbWu	\N	\N	2026-05-26 00:08:25.643	\N	2026-05-19 00:08:25.645	0	3c165834-c0db-4b43-a8ef-38dd8f79cb16	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$.vS7U3YXCe2rAF6EyqwFour1.37FiETBBI38qUgSRxLIz99CBXhNW	\N	\N	2026-05-26 00:08:25.659	\N	2026-05-19 00:08:25.661	0	761ab16a-0768-4183-9b1c-dafaed25c69c	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$2ZACu6ND9YYg1zgjgwdwx.3aPQRjXArUn2F5VBkJmL3aa2W4QJ8ae	\N	\N	2026-05-26 00:11:15.399	\N	2026-05-19 00:11:15.402	0	400be7ec-c772-4143-8e73-16229445a99f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$zkwDvQ5tRq8u2hMfqzxaFuMOvXUny0UqRSeKKKO9CNX7ePQQkOtjC	\N	\N	2026-05-26 00:26:51.84	\N	2026-05-19 00:26:51.842	0	32d7b426-5922-47cd-a7e4-3df2d8cc963a	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$heG6N1Lmg2..NfoouB/yTuhXVhoksNq3ExJWw.Q5zXhu6tOE2746K	\N	\N	2026-05-26 00:15:37.392	2026-05-19 00:28:39.168	2026-05-19 00:15:37.394	0	1a572f86-ed61-4218-9144-f1d3e4914b77	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$AMeFKMguei3QtJB7LY2qB.yN1RR.xu/9.3d8zWR8PGcYg9DBh1xRq	\N	\N	2026-05-26 00:28:39.281	2026-05-19 00:42:12.475	2026-05-19 00:28:39.282	0	75bd6bdb-074b-48ab-8113-4ba05d2869e7	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$CUvsmv9v3TAJIwfzniR/xeQyypBTBfrF4VeM8GzN8fXvvd.GjnDCS	\N	\N	2026-05-26 00:44:15.808	\N	2026-05-19 00:44:15.81	0	b8973ee0-e1e0-40de-9b26-679f5f4ced39	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$12ubnZJY2A.86qbnS6.MCOMVRpvtgdRBOyQjVK/C8OdDaQNa1qqsi	\N	\N	2026-05-26 00:42:12.728	2026-05-19 00:55:12.347	2026-05-19 00:42:12.73	0	17e93b55-58d5-450a-b6ce-593a01507758	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$YJY.3PgDUQenxAccfDY0Qe9tnYD3kjUf5gzAffmwJoihrGU..9MxO	\N	\N	2026-05-26 01:00:18.339	\N	2026-05-19 01:00:18.341	0	72c54aa8-783b-4d3b-af13-2dde6ef58ff2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$nE3/4k1pVGs4mTrz9kb1iuNxuqpoG6Zh4UpAc8zlwZgkF0omunUR.	\N	\N	2026-05-26 00:55:12.509	2026-05-19 01:08:12.285	2026-05-19 00:55:12.51	0	736162b6-983f-45f3-be2e-0fcf085fb089	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$Bc8fLhfYpld0yRovLEgsk.JAEfG8YEqY2Dtcifcw1/Ip4WLyrG41i	\N	\N	2026-05-26 01:19:18.438	\N	2026-05-19 01:19:18.439	0	9d9b6d72-c5e9-42be-8bb3-05f67b3f1a8d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$3WE/xDsOdsQ9KxeUFmHa/uig/C6gRTyKRW0HAEjcoIQl72RX1L16q	\N	\N	2026-05-26 01:08:12.412	2026-05-19 01:21:12.489	2026-05-19 01:08:12.413	0	d935893e-615b-45b6-9bdd-c519fe19d4cf	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$r2YLE8jrVt8WwxQdj3tJEOjetIrdhKBx6eiOLAdXvEths.1gQ7Loa	\N	\N	2026-05-26 01:21:12.736	2026-05-19 01:34:12.414	2026-05-19 01:21:12.738	0	9549a256-22ad-4e4b-a955-09659b43b74e	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$Rc3MlFKh/5FQ4F.3vjsAmeuhYQ40WEC3VmHw8qKEf/bPar3Ga3IKS	\N	\N	2026-05-26 01:34:12.645	\N	2026-05-19 01:34:12.646	0	8824bc6b-149a-4c1e-8625-60fdc5116cef	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$uCNkcPQvo/aZR1eaLqZgvOKB4ZGA.RcqwE1TyEQBgO7RjOUC2lma6	\N	\N	2026-05-26 01:36:56.896	\N	2026-05-19 01:36:56.898	0	9ea59f25-9fad-4e08-ae47-adf5d9043de9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$arVtg6O9aGFNZV/LV7fTT.0JeOqLUQyWj0Nc3y7t9HV5AB8RGd2cq	\N	\N	2026-05-26 01:35:53.045	2026-05-19 01:49:12.226	2026-05-19 01:35:53.047	0	88172bb4-bbc0-4796-8e0c-53e4ddba0ce8	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$kUbMX9F6R9R2y3DNpIlZSezcA5b4b/YkdmTi7V0RDxXJpwZSMS66u	\N	\N	2026-05-26 01:49:12.389	2026-05-19 02:02:12.522	2026-05-19 01:49:12.39	0	68e1bd3d-747e-42a7-826b-967f6a07cfec	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$rkiz76atMkQFSHbxAh3ERO2CzFiU2IV0VgwHVUEgsoog73WuNglx6	\N	\N	2026-05-26 02:54:12.399	2026-05-19 03:07:17.455	2026-05-19 02:54:12.401	0	6b58049c-f095-4d90-86a6-dd6c17d1b458	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$V3kjglbShFhzbhuVXHUpBeucVrsMVJyN/ql.u.FmgJz5DAyPqt9GK	\N	\N	2026-05-26 02:02:12.776	2026-05-19 02:40:31.044	2026-05-19 02:02:12.779	0	a81fccbc-8f64-4c28-afc7-04636e7ba4f0	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$.ptQb3rvztyBeKA4XKIQEe58PCvdl9gLzuj0NhP0yxAmynfhGAYZ.	\N	\N	2026-05-26 02:40:32.205	\N	2026-05-19 02:40:32.207	0	ebb5c285-3c41-497e-8c4a-f4c98fb27f58	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$2qeHNGoEbsqhTbXVnD1D5eO3TCbL6Zj5c.bMEj3kRCliIONob0JKO	\N	\N	2026-05-26 02:40:40.855	\N	2026-05-19 02:40:40.858	0	5340fc19-946b-4aa6-a959-dd93157020ee	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$LTQBdywB4lHbojr/L25MkOzM1xCh8r3nd7exUsZqUioKZwx3g.gNu	\N	\N	2026-05-26 02:42:38.514	\N	2026-05-19 02:42:38.516	0	182e2d73-1379-42e9-8c3b-349cd0384565	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$p7S63UsuLzqJk8yDT4k4EeOzOeRiJ9wAI6wI9PJa1/fdsIfyUSVbK	\N	\N	2026-05-26 02:47:01.191	\N	2026-05-19 02:47:01.192	0	d4beab66-6b0c-41e2-8b5d-e37b4427ef3f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$wxQu17HgVzKKHIP/mgIM4eIJnjOdDULprMyvUhpmjKyiH0zleyXJG	\N	\N	2026-05-26 03:14:42.007	\N	2026-05-19 03:14:42.01	0	c2a6c8fb-6fc8-46e6-afd9-1dadfb87c627	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$krU21I6I7iR3V8g42HMgJ.vVB1LojJT5JqcgUcr89xlw57Nv42eWq	\N	\N	2026-05-26 03:07:17.954	2026-05-19 03:21:12.301	2026-05-19 03:07:17.956	0	038f118f-70f8-4803-8f1e-b30e8bccbb06	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$Q9mKOtlSUTlMxXLL3ms6duoy3U1XiUlKfJYiF7GytGGRVfpb8/Zaq	\N	\N	2026-05-26 03:21:12.682	\N	2026-05-19 03:21:12.684	0	b1c437d2-aed5-4960-bf03-dba7d3d3ea4b	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$pFxgKzObfvHOaj7PRVaTUe2JfJjqhdHQAhnY5jNxtUHQD/C6FsjK6	\N	\N	2026-05-26 03:31:31.737	\N	2026-05-19 03:31:31.739	0	09f34eaf-7857-4775-b986-549626a5fd27	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$.BMT/3jnhqc7oCnfIxlgrOpdEQHHA4pwjRc3cNX556aNHomcct7JW	\N	\N	2026-05-26 04:25:50.86	\N	2026-05-19 04:25:50.862	0	9a02a94e-9942-48ae-8792-ad027efaa99f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$QynVyUgx8rViD44RNGQIXeDxH9n/K2eo7tY4ZvIZDlHogeT9HA8xO	\N	\N	2026-05-26 04:26:54.545	\N	2026-05-19 04:26:54.547	0	d45e189a-afcd-465c-a8ad-1dc57eb3c7f1	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$KEFWQK5.BS4.kYTpuN.gTOA7NAt3L6CIMO.t7NUYVVJlScmrHp.Y6	\N	\N	2026-05-26 04:50:01.759	\N	2026-05-19 04:50:01.763	0	59530980-9444-47fa-aca1-0f287bfb63f2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$uUUjPLOO4Uis/.Dbhl5cv.D5MsUBFVTTa9yXaTLUazYpEb/9oaMqm	\N	\N	2026-05-26 04:58:40.174	\N	2026-05-19 04:58:40.175	0	f06268ac-082d-4a28-a6cd-b2c5e5eff6d9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$9LqKe2wQXRjrLaMuNLTQH.lRnq7q3rubi7X.U28Dstxuk7.ZmruMW	\N	\N	2026-05-26 05:17:22.695	\N	2026-05-19 05:17:22.697	0	bfa08ad9-4831-45f0-aa2f-82b2db202464	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$.cDhwJERGK0txSFBykzk..wcA7r12ORl4G.yZq2Rr9I0zmL.e/57q	\N	\N	2026-05-26 05:33:14.305	\N	2026-05-19 05:33:14.306	0	03ad6928-dc43-47f5-9c2c-bd6f385be00c	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$9WO8mWEJBUb.79gPZtuAHeKx6ZPSWJ.sZxPpaRB7WekmGXNPZdmxa	\N	\N	2026-05-26 05:40:16.289	\N	2026-05-19 05:40:16.29	0	93ce9ae6-bd47-4175-b54f-83466fb5410e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$4STGG2o3og7rcFEqYEDO4eUnXX0bdzKfSO5g4wXf0EZjSnOVIIe5S	\N	\N	2026-05-26 05:33:01.19	2026-05-19 05:46:01.425	2026-05-19 05:33:01.192	0	368b92ba-3152-4f22-9565-2162a632cfee	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$MBufDKzPlOxRfrgeTsyWPug2mGvkfYjMMrecycdKi3LK1YSHnvmjW	\N	\N	2026-05-26 05:46:01.539	2026-05-19 06:00:01.14	2026-05-19 05:46:01.54	0	55ccd3d5-7f33-4ad4-bbb2-990a8d9014eb	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$n5FWTLxZm5TcR22YBTfst./y2hLSy1ZVGdiqMbhKRH4pwlpX2ljIW	\N	\N	2026-05-26 06:01:20.461	\N	2026-05-19 06:01:20.463	0	bbd65915-62b8-4f22-bbb0-ec652e89a34a	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$vsgW5EGsv4gDjVGSYPRl.ehc/IE/paWSsw4NnPZjzph/Fzge9/R36	\N	\N	2026-05-26 06:00:01.269	2026-05-19 06:14:01.378	2026-05-19 06:00:01.27	0	d582eb60-5481-4942-93fe-6b566047a6da	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$51cluCjRed3pFV5Clz4NOOi3HQpwJJne8bQYJfjLV70rXh4kwWJDm	\N	\N	2026-05-26 06:14:01.702	\N	2026-05-19 06:14:01.703	0	f3293f91-53d9-4350-9bfc-6c48f6e08526	8d40647d-da49-4490-ada6-3bfa2205366c
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
$2b$10$WyspJnSPjHOZ3JH5ESH7YeQI4..zY5PwpisHjy8M58Y2WIrsjAmJ6	\N	\N	2026-05-26 12:42:16.166	\N	2026-05-19 12:42:16.168	0	b91f9a59-004e-4dc2-bc39-613a834cc4b7	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$p3rAWGU56exk1bR1.KTOK.dZt1VG9g.ljn.4./pvKMidVK.95XTvm	\N	\N	2026-05-26 16:31:38.693	\N	2026-05-19 16:31:38.695	0	3970ce09-1027-4ad7-81c1-2842f8f5fdaa	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$jUhOCJ48UOkHAhRC6Go3.uftTbmI9K.O94tDmQYYhg.R1S/jdA63G	\N	\N	2026-05-26 16:33:21.719	2026-05-19 16:46:52.578	2026-05-19 16:33:21.722	0	7c419c7f-29c2-4a6d-a710-d899ab83f99e	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$/YzRSGHVi17NViNxb1dT/edqC2ss5hKkzK0i7x39JFdx3cDSQRs3.	\N	\N	2026-05-26 16:46:52.683	2026-05-19 16:59:52.599	2026-05-19 16:46:52.684	0	8c0e592b-3a77-4155-815b-3274a54ea0c4	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$kcRYoeMxuvrOOPjPuSo2M.Lb97J7iv2ooXZdknSFZkRZtMUPu9zfq	\N	\N	2026-05-26 16:59:52.73	2026-05-19 17:12:52.82	2026-05-19 16:59:52.732	0	96484a86-f2b7-41b2-9627-78c7cac2dfee	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$hkusf09ak8dFcSihRFqFcu6m1TZi0n7k155KUszEI8FsbUyYyO5gC	\N	\N	2026-05-26 17:12:53.226	\N	2026-05-19 17:12:53.227	0	f6f99871-7295-4244-a1e1-646369359159	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$ob3m1zJIo8WG7vaTwn952eq7hG5G3b2ZDaDaMV7QS4O8t9WTfA.Ry	\N	\N	2026-05-26 17:45:23.31	\N	2026-05-19 17:45:23.311	0	2ce55283-c96f-4d14-949c-f99e5915dc2f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Z2dgV9G5ed/Nf/hgeW9jduT/G/HR0oTIm3naDoej5erLZ6iakUc4C	\N	\N	2026-05-26 17:37:21.593	2026-05-19 17:50:52.892	2026-05-19 17:37:21.596	0	865228f5-b52f-46b0-9324-1fb1cd80272a	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$MOvoZEPb2TI7IJRlsRs9heNTXEQHUZLJasRZUHvMoy/61dvYKoD/q	\N	\N	2026-05-26 17:50:53.157	2026-05-19 18:04:52.598	2026-05-19 17:50:53.159	0	ca472033-fd83-4502-a6c9-0e1bbc1d36fe	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$f9lTCvrkSlQQ8ed6c0YLfulyGx0.Bp5o/zd/l7lLHWHIqzGAyjrhW	\N	\N	2026-05-26 18:16:15.192	\N	2026-05-19 18:16:15.193	0	ecf2baf0-a11b-43e9-aae1-877418965951	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$raj1gRjZ/.MfocKtE9Rm3u8zi4AC7QbraIb1pyCpoJX88FfjW0p7S	\N	\N	2026-05-26 18:04:52.746	2026-05-19 18:17:52.735	2026-05-19 18:04:52.747	0	1d3584b6-a32f-4d34-a80d-b5bf3253fe68	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$vgThiCBIRi0AlNq4Ils5n.Pbld58v./s4ce31lqjxCb/82s7niIBy	\N	\N	2026-05-26 18:17:53.079	2026-05-19 18:30:53.02	2026-05-19 18:17:53.08	0	d9a2d14a-2ee8-4364-b5a1-57711f981ea0	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$4SVugEmhnwPiK3BKOOxf5uiCPw6EQPpyFekE84PClMrPX9m2J4eny	\N	\N	2026-05-26 18:32:04.219	\N	2026-05-19 18:32:04.221	0	30b24f38-3238-410b-ab31-9fe2c663fc85	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Gcdx2lipUhsapWHC3WeOZ.CRBXdn5Ru6tdX0vmTQtuqMdIoWlAgnu	\N	\N	2026-05-26 18:36:43.982	\N	2026-05-19 18:36:43.984	0	2528ba28-bd3a-4a31-9489-dd6e393c16cf	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$XPrZy9YOUbkUhf/7uHHDqO8zIH/YboBwqjWFAt8ZYAvAMK1fy1yry	\N	\N	2026-05-26 18:30:53.425	2026-05-19 18:44:17.987	2026-05-19 18:30:53.427	0	d8880d22-3b75-46a8-948e-443d57f8f6d1	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$Zw9tx/xA8Nj.EYVyqqjKOO1pud5ny8iZ/w0wpl49jzmWcOxKg6wM2	\N	\N	2026-05-26 18:53:15.93	\N	2026-05-19 18:53:15.931	0	e7988a7a-e71c-4372-82b3-398b503eee01	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$pgZr39NidQhVU4r8vugp0uwm2lD4GXpp/wqupHGjBamf6H733BTWK	\N	\N	2026-05-26 18:44:18.417	2026-05-19 18:57:47.717	2026-05-19 18:44:18.419	0	5f95a2f4-d7ed-40b2-87b5-2c383aecefa9	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$cYrNc0P6Z/5lF2OZ1scXKu1FYdWiI1Am4Z44ih8zEBkD6MoHBr1eG	\N	\N	2026-05-26 19:09:27.99	\N	2026-05-19 19:09:27.991	0	84ef0a98-e873-422b-b407-a0d6eb306f8c	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$ZflWIvEqS.RgeiOQlUQx.O4WTdVfp4sVgCkt3me/iB6VYQllFVYQW	\N	\N	2026-05-26 18:57:47.927	2026-05-19 19:10:47.579	2026-05-19 18:57:47.929	0	5dd9bb0b-8cc5-46cf-98c3-f1174a5fd6f4	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$xZfpzUj38K8oZXolod6.YuVnq2sBN3XPI1HissR1SkF.bkOI6m7tW	\N	\N	2026-05-26 19:20:14.593	\N	2026-05-19 19:20:14.595	0	04f24224-ff37-4630-97bc-0cff5739e0af	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$dVHt6yzP12SA9sfA2pawq.RwFu3HZMTXbEYqMi4F6b6QRtf3KzhPC	\N	\N	2026-05-26 19:10:47.694	2026-05-19 19:23:47.587	2026-05-19 19:10:47.695	0	915dbe6e-ccf7-4c60-8e5f-6e956a4e2f59	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$Yn43z1Anyc2KOX1USGluZ.TzAiVHCxn2CrYUOb6FB229EsGqbobmm	\N	\N	2026-05-26 19:35:22.906	\N	2026-05-19 19:35:22.907	0	a5846176-372f-4ee2-bea8-d4f5101015d2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$2vK54u3uZrJ34lPl94CrKu1D7rjQNCS1USobta1uhiJta4auHdo9i	\N	\N	2026-05-26 19:23:47.817	2026-05-19 19:36:52.597	2026-05-19 19:23:47.819	0	991615f6-2059-4b2e-af72-16927b425040	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$q.lPKIjfXTp6sf3QBBYnveLS0ChrAA/JcUh3MdG0UiQq4/CykSrV2	\N	\N	2026-05-26 19:36:52.742	\N	2026-05-19 19:36:52.744	0	b2a3db63-e209-49c0-b683-2ada32a8ede2	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$rofRb04.tmYS/SZWLpK2iOZXval4P8arnNMe3Os9q49oWxu4Okhku	\N	\N	2026-05-27 00:25:53.071	\N	2026-05-20 00:25:53.072	0	59bc0dc6-0f28-4c2c-aa6a-f57657236bba	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$HmnG3/Ya0saeKW.aLwq11.RHzxx12Ev6yY2j8GZTiTkSvvdxBJ5FK	\N	\N	2026-05-27 00:45:11.064	\N	2026-05-20 00:45:11.066	0	93ffb3b2-2323-47df-9a3f-9c7414b20f26	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$1dD/QiEyo3.88GUTPh5avuS4nxPp4wLtAHaoJ.m.DIFLTbY2WnViK	\N	\N	2026-05-27 00:35:37.532	2026-05-20 00:49:42.215	2026-05-20 00:35:37.533	0	e1ca28e7-f5ca-4fcd-8830-2359f00b42a9	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$acq3eyB9dUuj94itvq3Aku80YbUAShjZTFw0sW8guvTUuHFozWCn6	\N	\N	2026-05-27 00:49:42.51	2026-05-20 01:03:42.153	2026-05-20 00:49:42.512	0	9a8bbfc5-f0d0-4177-9d68-9319d7e568d0	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$q5QZla9Zc5b9wc726YOcMevgJDtdC9oAxEAX/lVPhuu62THEGZOnW	\N	\N	2026-05-27 01:03:42.29	2026-05-20 01:16:48.401	2026-05-20 01:03:42.292	0	4906fa2b-07e9-491a-a519-50f05f6c2963	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$WC3WUvncH6LsR25Z3mvKfuktK.3MQg4Xs6S6PylK3dkjTPUv3s1f2	\N	\N	2026-05-27 01:20:45.166	\N	2026-05-20 01:20:45.167	0	2a5e0e5d-5b7b-4ba3-b018-2328e7c7a893	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$6vDGFvLfmqfJDtmo7.OcoeHExSlLrHodghn7mO./sf58V0RD5NM6O	\N	\N	2026-05-27 01:16:49.465	2026-05-20 01:30:18.929	2026-05-20 01:16:49.469	0	d44ccd5a-5a5b-43f8-b0b7-806d88d7550d	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$zz16SuacYMqBPfujk/hMoOgI560vD3cHEKjI5ElV2uGNLzodqtfpS	\N	\N	2026-05-27 01:31:19.437	\N	2026-05-20 01:31:19.439	0	178ac323-1861-475b-888b-e89759900aee	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$ytXy0mP8zmu3LfO0ojstPej/IFZWNmpgqCqqpMLPWSEmHToeL5MP.	\N	\N	2026-05-27 01:30:19.224	2026-05-20 01:43:34.305	2026-05-20 01:30:19.227	0	f2b0d7d6-f3bd-4546-87d8-f144e188bb40	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$hj78m0GuOIAgYOJ2uRV2ue7FyOCC.O/dBhQYFz8gOI6TK9qxb6lCG	\N	\N	2026-05-27 01:50:22.725	\N	2026-05-20 01:50:22.727	0	37dc5b99-cf0e-4f63-8fed-0ecb82334ffe	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$X5O4aPh4R9mKji968i4hN.UE1bT0h2pRqxjb2G0jXoHda0.fi9b2i	\N	\N	2026-05-27 01:43:36.984	2026-05-20 01:56:42.144	2026-05-20 01:43:36.986	0	28800ebb-932f-4ac7-b39a-d4ba6a4d5b88	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$.RVUIANeXFWlWltX2edMZ.DueOgYNOk2cjHwBdKEOY8x8PzVEAUb2	\N	\N	2026-05-27 01:56:42.319	2026-05-20 02:10:02.231	2026-05-20 01:56:42.321	0	ed61f74f-57f7-4d54-bfed-fcaa89d94ac5	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$VQjUClIt/J/G62i7tS4L6uAiwqRWLD9bEsd9AdRP9fYoUAH0XlBxu	\N	\N	2026-05-27 02:11:10.424	\N	2026-05-20 02:11:10.426	0	aa3c4899-c36a-4073-893a-8b35093b0f1d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$KDmRUIDCygjRrau0QjtenuPwDXDFtdqf.pqhe/lLWVkwe5Nvt03Ma	\N	\N	2026-05-27 02:10:02.466	2026-05-20 02:23:42.295	2026-05-20 02:10:02.467	0	d8597c9d-1d99-4470-b1d1-74952d414f70	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$2YDBx993o8Y4jpbDfGfUAOVTZUqtpjaGMgcMH3HcufkcKtA1d9/wS	\N	\N	2026-05-27 02:32:06.836	\N	2026-05-20 02:32:06.838	0	ca7f0bb6-3616-4d4a-b4af-5062ab013923	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$dnv1UEpWfgLFGGJ5HZ2xWuROYg2PrUx4QlCpUv5iWLo7cSnRIqbC6	\N	\N	2026-05-27 02:23:42.602	2026-05-20 02:37:42.27	2026-05-20 02:23:42.603	0	2d3e7800-44fa-4aab-a39c-67da3d95a3c7	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$H9CPyPHTcAw5Bz8j.ry0XO9mX2xBosibh9mqu1ErDs0S5OmjMrFmO	\N	\N	2026-05-27 02:37:42.453	2026-05-20 02:51:42.165	2026-05-20 02:37:42.456	0	7acfab57-ef73-44e4-baa4-6ddcc34a30c0	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$zJHZ2oWb5nP/xm4ySeBaAuvwMSFqCYBMmfgFaz7xPs6DXo5LBMy9.	\N	\N	2026-05-27 02:52:08.532	\N	2026-05-20 02:52:08.534	0	21cf0def-83d0-4004-909e-feb16c298a03	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$f5LaI80yP9mulKLEILgREuIkCsA2QaP0f/UHqQJ1v1Lry0E3/J6Ii	\N	\N	2026-05-27 02:51:42.294	2026-05-20 03:26:17.538	2026-05-20 02:51:42.296	0	bf3a5291-120a-4933-86b1-624e641aeac6	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$2feXAaZpfmLAB/8Ci1UuauOXDcjsETWl.gkxD2UZG4bc86HyODFo.	\N	\N	2026-05-27 03:26:17.684	2026-05-20 03:26:17.845	2026-05-20 03:26:17.686	0	fc1ba352-3100-490a-9f20-c05996e9ff10	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$szxDQCQYCF5JCQbkGhQXSuEL/bvGre0PLC/WZQfJ0TmzO3Mzlg6tS	\N	\N	2026-05-27 03:26:18.06	\N	2026-05-20 03:26:18.061	0	b5eaf4ae-a2fd-4a16-9779-f3ed2a530510	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$wvdZXOYLmO7BWT4Mlo4rlOSTM3loA05z8zJtz.xS8JhldEsu.HxmW	\N	\N	2026-05-27 03:28:38.842	\N	2026-05-20 03:28:38.843	0	b6296c73-2950-497c-86d5-1da784aa98dc	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$fLe5kOpYexXA28PqZzZdzeL2rkSLaizq6BNzwDjsiMo0Njecd69u6	\N	\N	2026-05-27 03:41:40.205	\N	2026-05-20 03:41:40.206	0	be96e465-cdbe-4d83-99b0-3bfca7370c5d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$pKaZR5oFc7NNuYrIWKeCmeXctqeknbTJyF7krhRtC7FPImxK0bXF2	\N	\N	2026-05-27 03:42:44.093	\N	2026-05-20 03:42:44.094	0	5e861f19-7be2-44d0-a741-e28fcf4f77aa	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$1j63CdUVoLvaAJPVZuw8/egRiRpPEqLmWnVd2AUhaLPBLID165PUe	\N	\N	2026-05-27 04:34:12.674	\N	2026-05-20 04:34:12.676	0	bc3fa486-7826-46ed-946f-cba41a4f72ca	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$CGw8ScMVWW/PVBXr4HBUNuQI3wiZAQGzI8ubL0oqHKayCDHt.pNKW	\N	\N	2026-05-27 04:35:49.745	\N	2026-05-20 04:35:49.748	0	39926b7b-ac22-4dd4-85b9-a0d6e0bc373b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$WD641NIiubE9rarObPUQlenkG1qdB98/R6wJhIMmbI4K2vXetA7RC	\N	\N	2026-05-27 04:54:24.162	\N	2026-05-20 04:54:24.166	0	571b3a4b-3917-4c60-a7d7-93648d763cd8	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$F0KlB/eQuj/4A4Sx6pxTaui8kXyid0wOmc/gieclCZMDasEX7G7tG	\N	\N	2026-05-27 04:50:59.487	2026-05-20 05:04:37.185	2026-05-20 04:50:59.49	0	c5a4d5c9-f7ac-4f43-a719-b3e8ea3514f1	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$eaACi80jmSnbNo7ocgtaKe3r2/wffh7RwsdkMVwdk7uVa48GC51oS	\N	\N	2026-05-27 05:13:53.395	\N	2026-05-20 05:13:53.396	0	13c07f90-aad4-4ab0-8234-829bcc00d3de	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$S9KEtwWm/NN8Wqe8gnLFY.zMX9SeAcodPPRRutvGr7xfxg4/v6O9.	\N	\N	2026-05-27 05:04:37.746	2026-05-20 05:18:32.169	2026-05-20 05:04:37.748	0	b18d7a7e-0302-4e7e-9927-7b2bb8a61a3b	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$YqVi/b/vRDtR8rsIj1vEUuzQAfD6ghnS5N0o7UEqk/l2NUTJzf1JG	\N	\N	2026-05-27 05:31:24.013	\N	2026-05-20 05:31:24.015	0	4e2cb140-1b37-4031-92c9-b4e5618a9593	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$ZnfEswOVXBmU.fQjnvXy.u1EGDqkMHdnbVC3k7ob7qaSCqHNJVp3S	\N	\N	2026-05-27 05:18:32.385	2026-05-20 05:32:32.066	2026-05-20 05:18:32.387	0	9c7972a1-8bd7-41d8-8c50-a64eb0c07110	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$a8fxmISW4d1ZVNZbUKgovOQNd6s7CxhS36sNMzI4VB5S84hPjPWyq	\N	\N	2026-05-27 05:32:32.214	2026-05-20 05:46:01.965	2026-05-20 05:32:32.215	0	9edc08cf-6240-4d1b-a60d-660551c85090	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$13ayh5/V8NsmsmndWP5t1egLPDu6Q2moq4gwcsYtThCsJyE9c8uYq	\N	\N	2026-05-27 05:46:02.236	2026-05-20 05:59:32.299	2026-05-20 05:46:02.238	0	863166ea-16ff-4885-b4ba-098e0f6f06b3	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$Vdx6Wja0YuAoofRaAwHa9OykbFFZlqdWnufcO/6zVbBsvZZTzLPqS	\N	\N	2026-05-27 06:04:21.852	\N	2026-05-20 06:04:21.854	0	149f036a-b4ac-4267-aee9-e733d479ecd7	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$feA5OeZYTuY3hAa0LHNzmOrsTEXT13b6OCaFHu7aFhDsGYKILG5NC	\N	\N	2026-05-27 05:59:32.547	2026-05-20 06:13:32.431	2026-05-20 05:59:32.548	0	a0270858-1eef-4296-935d-4e7519555962	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$HbL/xY59ygybDsePZdTwCOy8N1cClsORiFZW2sKDNhmCXIWVQ3/Ym	\N	\N	2026-05-27 06:13:33.452	\N	2026-05-20 06:13:33.454	0	2595e949-1c3f-4801-b7f9-9b6501d75f4e	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$RuFI.3GnESbsP0Sh4Y45Me//8t7lKq0fCtmaGOCNyNNcmrIpPHiO.	\N	\N	2026-05-27 06:19:51.117	\N	2026-05-20 06:19:51.121	0	e7cac128-e5b8-4cb4-8c27-70ca01ebbeb6	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$AUHmaSA24D6Ttd70HDNq.OTyoroWco3j4crZVVnp2wB.SsER3MBZK	\N	\N	2026-05-27 06:30:15.193	\N	2026-05-20 06:30:15.196	0	86834c41-5afe-44cc-8927-d5d21446cf4e	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$4hcg3yp6KIroP6KhTFM60.pFQBspT8goj.dYLh2N716eOeTD2f1Xm	\N	\N	2026-05-27 06:36:40.983	\N	2026-05-20 06:36:40.984	0	513dd382-4dc6-441c-80ac-464b71ea8add	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$fciL3cvmk0XB5H7nNpc/oOLAN4vAnLIZvSBf46eNOROWmcayqla4q	\N	\N	2026-05-27 06:35:00.78	2026-05-20 06:48:29.115	2026-05-20 06:35:00.781	0	b50ed77b-e8a5-4594-b4e7-fa029bd2b85b	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
$2b$10$U7PbwJLh2Kr48ilLJUQU4.WYHm6KceY5XYVjuYmNLYTM3wgHX.vM6	\N	\N	2026-05-27 06:48:29.275	2026-05-20 07:01:34.334	2026-05-20 06:48:29.277	0	0cb3983c-4610-43ff-8161-4f849a08b35f	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
$2b$10$C7JY2jbE73MHXj2OqUqs1eGVg1aBYA3xJYtLU..8tqvJ3zT6YnWKS	\N	\N	2026-05-27 07:01:35.354	2026-05-20 07:15:32.313	2026-05-20 07:01:35.356	0	a3010fb7-9e32-4081-b525-a0c0f6ee0584	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
$2b$10$RO/xxbDZXFtOoBNfUN2CSekBdYiLmfFvok0BfD4EUnZWDi2XDlUKG	\N	\N	2026-05-27 07:15:32.788	\N	2026-05-20 07:15:32.79	0	17d6024f-d4c2-45b1-a70b-ed431318ab71	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
$2b$10$4WryPcf58vCgitNZ5BWIN.oGogzK5lfI64DhD3/z0q4f.xi6lPewS	\N	\N	2026-05-27 07:20:44.329	\N	2026-05-20 07:20:44.331	0	28b97298-8ce2-4193-a873-a269fd0c19b9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$C.vN39mpmQie2BeSml7mReBBM9EQgIdpafF9uex4XDhXSgtQVotEO	\N	\N	2026-05-27 07:21:48.313	\N	2026-05-20 07:21:48.314	0	210d9042-6e59-48b2-a369-fbd34900e33b	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$N26nF1frnEOcS.Oe5yrmgOASh..nUTDuAAYg0GXiRVH/CSvpkULG2	\N	\N	2026-05-27 07:23:30.882	\N	2026-05-20 07:23:30.883	0	ba4ba409-3a66-43e2-ba6d-1942aeaab68b	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
$2b$10$3ANVTD4E3JkkUg.mSJtBt.I8I4Z2cJDBW5vKS6YncC7jFhXgnkIBO	\N	\N	2026-05-27 07:38:04.154	2026-05-20 07:51:23.392	2026-05-20 07:38:04.155	0	e941edfc-207b-4d55-8cce-68728bfa4fc5	f3a5cce9-059c-4828-ac18-61164c28e868
$2b$10$ujvLMlRAoefGv3dOmQ7b1.inl6dvuzKIQBsTmisatAALWnImSlUVS	\N	\N	2026-05-27 07:51:23.534	2026-05-20 08:04:42.787	2026-05-20 07:51:23.535	0	889e4b13-6e58-4c67-9a12-62432e60c2dc	f3a5cce9-059c-4828-ac18-61164c28e868
$2b$10$ZBwkpenABsqiwjvTSq9wCuDKJuqSFLptsj8TDiv2gH4aiCqTLtXze	\N	\N	2026-05-27 08:04:42.887	2026-05-20 08:18:32.535	2026-05-20 08:04:42.888	0	b2a815e0-b8d5-4112-bf4a-436cca734bfa	f3a5cce9-059c-4828-ac18-61164c28e868
$2b$10$5hzB8YWjffgPGHJoss6oqespU1eOavatIizb7fPjpxzK9xlv/wkTi	\N	\N	2026-05-27 08:18:32.869	\N	2026-05-20 08:18:32.871	0	053426d4-79ed-45c6-a1b1-86145a48d74d	f3a5cce9-059c-4828-ac18-61164c28e868
$2b$10$v16J3/hTc0PgROK6548.3O6x8NePi1CunS4pFL6GXNOzszQzeO3OO	\N	\N	2026-05-27 08:38:26.775	\N	2026-05-20 08:38:26.776	0	7d8fa1a2-14f4-4f38-8762-cd62c3f6629c	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Dx.GFOwFddf1e5iFtQClpen2xavbtW6Cne2wcj8l5NzpO55Kq2Bzq	\N	\N	2026-05-27 08:28:13.009	2026-05-20 08:42:09.286	2026-05-20 08:28:13.011	0	6a297ab4-ed29-4762-b9e5-509d081a479a	5de255a8-d8a8-4749-a624-557da4ed87b9
$2b$10$93256OyhFmm47RJVUaZqT.NciHpWjqYwgtzaYjUv8VzBzQ/zIq4/q	\N	\N	2026-05-27 08:42:09.468	2026-05-20 08:55:23.646	2026-05-20 08:42:09.47	0	a58f0ce8-0697-44c8-a42b-ee88e394ddbe	5de255a8-d8a8-4749-a624-557da4ed87b9
$2b$10$QOBMoCS2zkNFKUbTBS.ALOUmI989iFPZvkmRhpnN/T1YMvk7EfPi.	\N	\N	2026-05-27 08:55:23.803	2026-05-20 09:38:09.925	2026-05-20 08:55:23.805	0	bf855446-3bd5-4894-8203-2847e7f09735	5de255a8-d8a8-4749-a624-557da4ed87b9
$2b$10$jjTmRuC95zOYrQaIWmOme.mtgwZ5shoiuZBpzoXZiDKLK6.T.CiMm	\N	\N	2026-05-27 09:38:10.23	\N	2026-05-20 09:38:10.232	0	3ba49b7d-dfa0-4ea0-9ad9-a105cb6af970	5de255a8-d8a8-4749-a624-557da4ed87b9
$2b$10$Avvg..yjYBpZ2Poq4pnvG.OHk1DjJnJ3vMDtXKDD1GJpAvY9g0Sj2	\N	\N	2026-05-27 09:42:45.036	\N	2026-05-20 09:42:45.037	0	74d80e58-8ec9-471b-a579-7b7844e568b8	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$62htbsyXt6zUXGA0nCNIquDykRed7wz7bBkr2OXHGbZsYfza8f0RK	\N	\N	2026-05-27 09:38:10.374	2026-05-20 09:51:37.557	2026-05-20 09:38:10.376	0	dbe9d6da-33e8-4e80-aa74-85eec10fb804	5de255a8-d8a8-4749-a624-557da4ed87b9
$2b$10$a.O9dXu6xpFqdN1g1qDHrOvM6sggalrs9cRCsbMUOQ6d3VTtzr6fC	\N	\N	2026-05-27 09:51:37.665	2026-05-20 10:05:22.93	2026-05-20 09:51:37.666	0	a2352d17-5a33-484f-9e0f-68917048f113	5de255a8-d8a8-4749-a624-557da4ed87b9
$2b$10$abrJ0NMfCM550SmD8M0BjeTLdzUQsCifPILvd.LzL/5gYl80jRwda	\N	\N	2026-05-27 10:05:23.188	2026-05-20 10:18:33.731	2026-05-20 10:05:23.191	0	86ec1577-aee4-47a5-b05e-62ac5064b3a8	5de255a8-d8a8-4749-a624-557da4ed87b9
$2b$10$4GQomCBDu72VvonckKpbUOfX2Wv6ZDU3Freoj3rMzU.O0TvfTQeby	\N	\N	2026-05-27 10:18:34.01	2026-05-20 10:31:33.868	2026-05-20 10:18:34.011	0	816fc850-33e3-4c94-b2ae-d97454ca9687	5de255a8-d8a8-4749-a624-557da4ed87b9
$2b$10$RrMmDe/86czIQ93PZk5rAOkD1Kbx/vWcq8cQWoCxt6EHSl1CraFya	\N	\N	2026-05-27 10:31:34.226	2026-05-20 10:44:33.652	2026-05-20 10:31:34.228	0	a0daaaf5-a814-46c8-8e8e-c50542b88a43	5de255a8-d8a8-4749-a624-557da4ed87b9
$2b$10$c4vJiiMHrMvr0VK7Kk9mM.euVHIIGFlCd5IWPx8rYRl9Sd.PDI2l6	\N	\N	2026-05-27 10:44:33.849	2026-05-20 10:57:33.76	2026-05-20 10:44:33.851	0	d74c8938-a700-4b82-9d70-602e92a1621a	5de255a8-d8a8-4749-a624-557da4ed87b9
$2b$10$EKI4ddcgg4JqkcYueIuUmukuJ8guCkCQzLt5JdWERRSqYIQEk1yg2	\N	\N	2026-05-27 10:57:34.358	2026-05-20 11:10:33.662	2026-05-20 10:57:34.36	0	4b7fd342-bc27-4399-b856-e15257adf593	5de255a8-d8a8-4749-a624-557da4ed87b9
$2b$10$TVLHUJe2nUNVCf61mA2BYO93tTdcfRuMEyandEI6RT5fXvtHCcAau	\N	\N	2026-05-27 11:10:33.867	2026-05-20 11:23:33.707	2026-05-20 11:10:33.868	0	d65697bc-4579-41e6-b597-b869ef277a3c	5de255a8-d8a8-4749-a624-557da4ed87b9
$2b$10$fgfaxoo7cToCMYbUXtyAQ.Grr2b.3bE.Y.WQk.AeArKHbiF5AwXe6	\N	\N	2026-05-27 11:23:33.9	\N	2026-05-20 11:23:33.902	0	18370cec-c520-47b3-b23c-017100742074	5de255a8-d8a8-4749-a624-557da4ed87b9
$2b$10$kCFYJ11ot87LYXDkLaziROvUXQDUVtm0zawhCfVjIv1HqIcW.O9ke	\N	\N	2026-05-27 11:32:07.012	\N	2026-05-20 11:32:07.013	0	7b078c92-7cf6-46e4-987f-3140b10290c5	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$ggpgsg1N1SAunu0URPmyiOjwJGR6J8kcr5wRyRLI3R.B4GtoJ7uTa	\N	\N	2026-05-27 11:30:29.673	2026-05-20 11:43:34.092	2026-05-20 11:30:29.675	0	574dbdd1-53ac-44c9-acd6-6e772eaca30d	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$cWSURosorph0q2SS5O3r4uCWWSxGlypQq/yRk1DhFJfUrGSeGTtbS	\N	\N	2026-05-27 11:43:34.432	2026-05-20 11:57:33.703	2026-05-20 11:43:34.434	0	d1ec65eb-9af7-42ac-aedf-6ed2154f545f	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$.SgOaWZMYMDHh5ykvXUt6..5/5UAqnYAU3nhfz5FiybBUrPeHuIza	\N	\N	2026-05-27 11:57:33.912	2026-05-20 12:10:33.547	2026-05-20 11:57:33.913	0	52412f0d-361d-44f7-9ec8-17796f49bafd	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$9B8DF/AM/BstXeiQ3XEie.HkoSoEjSo1Sk03kQvm9ceic5nuqyF02	\N	\N	2026-05-27 12:10:33.63	2026-05-20 12:23:33.871	2026-05-20 12:10:33.631	0	e16d3fa3-c558-458b-bf43-d6582839e0ac	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$tA7p.wW4wRbHLOvKkrzmku/pgA6loD2Pz85IL5GlT4LYJn6wbOquS	\N	\N	2026-05-27 12:23:34.25	2026-05-20 12:36:34.161	2026-05-20 12:23:34.259	0	a08eeed4-2a3f-4c37-a87c-05ae52a7b144	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$Gvc6EuK6FqkYSa3YfPyV5uMzjwIX2AL6TogldeiYleQawwiFOzbby	\N	\N	2026-05-27 12:41:19.423	\N	2026-05-20 12:41:19.425	0	0543d0da-dda5-40d9-94c6-667066229bad	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$3Oa/xrvpoTqGzwbNWenpF.0G9GvBT7dCOewoyYzOngdhN6Axc5Q0m	\N	\N	2026-05-27 12:36:34.68	2026-05-20 12:50:33.685	2026-05-20 12:36:34.682	0	6fb24887-b2fa-4036-9c9e-3b039907b7b0	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$UhSdkvfKcKGCdhNkxLJ7l.USZXbC4tPkhxs.YxD2PDZsIiSu.qEK6	\N	\N	2026-05-27 12:50:33.888	2026-05-20 15:59:21.1	2026-05-20 12:50:33.889	0	7dbfdb18-12e8-49e5-aa9f-3f27712dfddc	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$ORSEfVWHXqaIYJcxKzefHu15BHgVnv/FhXCOM7RpNZ1nxhmRKBQc2	\N	\N	2026-05-27 16:00:40.139	\N	2026-05-20 16:00:40.141	0	e2e6547c-833e-47bf-8457-dc9d1667aa32	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$DTnPxRwqcRVZzxfQqmTTmO1hYkLvWnP1J0WidB56kTZ1d1HySTVqW	\N	\N	2026-05-27 15:59:21.219	2026-05-20 16:12:22.607	2026-05-20 15:59:21.22	0	021d0e1e-d0c5-4128-9c03-7f12637e52c5	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$gnjmuZZk3OA.GLkWRR/tzeaGYF3OWaZ9MOZZmtxdd8pUsEPsIcSLm	\N	\N	2026-05-27 16:12:22.831	\N	2026-05-20 16:12:22.832	0	29fd036c-7b21-4b3e-97ae-2c43c40c61f4	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$4bVxEZgZDC4NvccgXFmPvOu4UHRrRbujz3Np279lorqnaLL9MIiJW	\N	\N	2026-05-27 16:16:37.482	\N	2026-05-20 16:16:37.483	0	ceb64b16-1712-4ed9-b41c-e53c5e83d86b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$A8jh88QggRSu56rGKjaup.KFQAbNN7XmnJcEeD2jL81qB8F0VRbMK	\N	\N	2026-05-28 05:04:18.055	\N	2026-05-21 05:04:18.056	0	53f4af5c-1e1c-4a33-8830-e5506bb66e46	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$G8Hg66PvVflDJrnNuKxUpO9hwNfaZhwgIFhR6Flj2HNna1G7X3kNO	\N	\N	2026-05-28 05:15:21.103	\N	2026-05-21 05:15:21.105	0	b38892c9-fdd5-46c9-84f8-c7b54f026189	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$DfmsPQHboIpawgtDD9acCuvLN0OULlGCHAWniyh87cPmTdWuUbtsq	\N	\N	2026-05-28 05:17:47.41	2026-05-21 05:30:52.276	2026-05-21 05:17:47.411	0	de840966-0817-4761-941f-4a24215810ca	f3a5cce9-059c-4828-ac18-61164c28e868
$2b$10$VdZNoOHXuI6oaMpvIEPF5ONBe.1X.2uBlWhp2Pn9TIyG1wjot6omS	\N	\N	2026-05-28 05:32:12.319	\N	2026-05-21 05:32:12.323	0	0f05483a-4333-496c-8f58-a56d1977a94b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$r/PpQtB1XPvbcbRYQHOxqOZY2352j7Bcio1ckA0nAv.BptRE//Szi	\N	\N	2026-05-28 05:30:52.649	2026-05-21 05:44:01.95	2026-05-21 05:30:52.651	0	e6ef9872-3751-48c0-8ad6-94c299364632	f3a5cce9-059c-4828-ac18-61164c28e868
$2b$10$mSn840BFOxTBZtIjJUJaQ.oeFA909Ac9boBvlZf1.hjkayXudSfVO	\N	\N	2026-05-28 05:53:03.499	\N	2026-05-21 05:53:03.501	0	b15d3d08-26bd-42e3-9478-fa8eaeba520a	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$7VLQJaMysGMR2.rOOuUIveacbh05eNM1N5pfIaRSwaNKNSdWK3yXS	\N	\N	2026-05-28 05:44:02.173	2026-05-21 05:57:01.77	2026-05-21 05:44:02.175	0	f69a3e1b-544a-4c69-b1e6-e33cd734732f	f3a5cce9-059c-4828-ac18-61164c28e868
$2b$10$kAE2lUvYoeoZIokObmY.zuyHdVlFodfwS4VoPTPpM.Ldn2CNB9l8O	\N	\N	2026-05-28 05:57:01.931	2026-05-21 06:10:01.789	2026-05-21 05:57:01.933	0	2b25fa45-c6a0-4c80-88ac-e82fceffe013	f3a5cce9-059c-4828-ac18-61164c28e868
$2b$10$gxUuqpl40BGRli/z454OHOakLQ1F4zDrc61sElQcyrw18L4ZMT39.	\N	\N	2026-05-28 06:10:01.907	2026-05-21 06:23:01.937	2026-05-21 06:10:01.908	0	7ac4d17a-bd1b-4057-a9d2-8deaa7beee6a	f3a5cce9-059c-4828-ac18-61164c28e868
$2b$10$T0YyjUKHpJt1oMA/rXaXs.yNmVoAggMH5CRKZ0rXtI5MBrPrEa9N6	\N	\N	2026-05-28 06:24:38.978	\N	2026-05-21 06:24:38.979	0	cf9ee9fb-855f-4d13-92b3-c87e395535f6	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$qZtnV0fhsmWkYYNpdFgyeOQ7GbyGAuxKzWmF6Sj5Ww7F..PG1221.	\N	\N	2026-05-28 06:23:02.175	2026-05-21 06:36:01.712	2026-05-21 06:23:02.178	0	3b41f992-9ba2-4bcf-8e9f-5978d5537328	f3a5cce9-059c-4828-ac18-61164c28e868
$2b$10$Amumzb2vc0xffF5WUP0sq.BudUffw2EfiWAkKwmkFOWUWgCd7Uvmq	\N	\N	2026-05-28 06:38:26.991	\N	2026-05-21 06:38:26.992	0	2bc73730-c6a3-47a1-810e-82a54842441e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Czf/is/FZ.q/ffU8mahTYu96gCMm8Ec.ixMLog0nhxMhM0.r0IExK	\N	\N	2026-05-28 06:36:01.827	2026-05-21 06:49:01.777	2026-05-21 06:36:01.829	0	0d90f429-9df7-45c8-8673-be129ab23ad8	f3a5cce9-059c-4828-ac18-61164c28e868
$2b$10$DEJfiOZ.VXGdMn/9U5SrlOlyNp18sL9RZHVdLAdHvWGpoFetuDUH.	\N	\N	2026-05-28 06:49:01.919	\N	2026-05-21 06:49:01.92	0	1b450388-7a73-406a-b8e5-119249566622	f3a5cce9-059c-4828-ac18-61164c28e868
$2b$10$LPXOQ/i3e.stEEtWZXgete7mv.DnI.QpwKBi6.JAe2FpwdLWvB0Ei	\N	\N	2026-05-28 07:07:41.844	\N	2026-05-21 07:07:41.848	0	2a7bb837-d654-4397-a333-a502d6f769b2	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
$2b$10$rs4tVB4ETn8HZGgwFxjvdexQCQhA/yqeoKxW.jBCO1JPlDWa/MPV2	\N	\N	2026-05-28 07:19:02.202	2026-05-21 07:32:25.997	2026-05-21 07:19:02.204	0	64205893-f5a4-4d29-9d9a-e582a52505c9	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
$2b$10$XyEWlf.NvERW8mxxtT7ZE.EkrQacnbWfmpVasHRWxdEF.86KLrrSy	\N	\N	2026-05-28 07:32:26.204	2026-05-21 07:46:01.738	2026-05-21 07:32:26.205	0	0c5bbb68-0bab-4104-acdc-0d85f1baa149	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
$2b$10$2PxD/rEeoZhlMXPAoW6QZujJw1SwwPveHeoq/1ADSxLMPpJk1A2Em	\N	\N	2026-05-28 07:46:01.848	2026-05-21 07:59:01.713	2026-05-21 07:46:01.849	0	d6e260fc-68d7-40e2-b05e-6982f72d87eb	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
$2b$10$prk.NyPZ0CnTdM3i5zO8Le25xjNSq56/DFVJOS9f.6I1XpbStrUem	\N	\N	2026-05-28 09:13:06.623	2026-05-21 09:26:24.706	2026-05-21 09:13:06.625	0	bd154c95-c7d2-48df-8101-13b09a38907f	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
$2b$10$fukuinWj7REZ7eQq/Jc7ge5/NOAjTRAiKB1nS7G5NAtN18SzTBrY.	\N	\N	2026-05-28 07:59:01.823	2026-05-21 09:13:06.164	2026-05-21 07:59:01.825	0	c120a822-c827-40fc-b1f8-f886ac6b6201	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
$2b$10$SSzYt.496sITodwH0eG.6uOp6FfKodXfskIYdAsF6IEqAQakleC.e	\N	\N	2026-05-28 09:13:06.607	\N	2026-05-21 09:13:06.608	0	034a8baf-6eaf-4a1c-b821-dab18334084e	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
$2b$10$2hnkwYcswHBrKMUFLB.DS.WJSLilK0535RQrHAEPMDZuU4wsPLaz2	\N	\N	2026-05-28 09:26:24.818	\N	2026-05-21 09:26:24.82	0	3dadd563-2116-4efd-ac1a-fd05cde7b3a0	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
$2b$10$VtwXtg6Iy4wNn.7RaRyxhufbouUuziKwJv1pKLK5UdUDTWTh2uiMG	\N	\N	2026-05-28 09:34:11.929	2026-05-21 09:48:01.751	2026-05-21 09:34:11.93	0	ab774350-83e2-4165-99ae-064d817c2c4b	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$90YGhGHn2QVHo4Z9tdQ.5eT9ZAS3mpZaxS.Wu7eBZEvtq/joulyg.	\N	\N	2026-05-28 09:48:01.889	2026-05-21 10:01:01.771	2026-05-21 09:48:01.89	0	4db121bd-7636-4cb5-8b04-376a7825d68c	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$M1Djber6S1iIMUGeUNLe/.PWyTI0.G9cMICVi10gt8tv545S3SWWO	\N	\N	2026-05-28 10:01:01.937	\N	2026-05-21 10:01:01.938	0	948ae4ba-34d7-46d0-8362-b0a02eab0dde	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$uWJao0LcEOaUvrevsXU0EOgxwdM3B4wui8fsGt1qbD5m9i80GSBia	\N	\N	2026-05-28 10:35:57.562	\N	2026-05-21 10:35:57.563	0	8251bb3a-ef90-4ddb-91b5-01435a544617	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$6K6PPkhyNZLtskzbPBXwEe7435NOSzQ1IlcgtIvpLGKbZkNTO035i	\N	\N	2026-05-28 10:36:44.083	\N	2026-05-21 10:36:44.084	0	ebff1924-be70-4910-9714-e7119f5eb6f1	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$vNqMOtUQTZBhFVpghk9Z4OcED2Ub5z7j4sgmt772xk8/th4xppIb6	\N	\N	2026-05-28 10:37:20.628	\N	2026-05-21 10:37:20.629	0	60cb1eb2-a566-463b-93d5-a18eb31f1914	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
$2b$10$TYWMYh/dPHvsIzcsVvYfd.vDHyBaxaxbzhEuJTuhpasebPUrCl1rq	\N	\N	2026-05-28 10:38:07.671	\N	2026-05-21 10:38:07.672	0	dd8b4ae7-6359-4963-bab1-c770f27e8a55	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
$2b$10$hLQrAtPOKaIadUk2pDCQ7ORQxmPV7kxDmfgtZzIpqc2ZT1AG5jHXK	\N	\N	2026-05-28 10:46:05.19	\N	2026-05-21 10:46:05.191	0	3d72682b-b488-43f7-8ec8-ec1c892e2eb8	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$b8IeZJGHiTJs.pjf.1U8cOKVbyH/z/rEzAmrOedF/ocO6NnfbaTIu	\N	\N	2026-05-28 10:45:46.216	2026-05-21 10:58:47.132	2026-05-21 10:45:46.217	0	c9fdda10-f7df-47de-aec4-a0660fcdebbf	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
$2b$10$UTSgLC0r8e9OPL19Yo34f.lT9iEDwDIUV7v7oNHFq1qx3qw4p46La	\N	\N	2026-05-28 11:07:03.886	\N	2026-05-21 11:07:03.887	0	1a81cf48-f1f6-4f2b-8cb3-8d75bda3a5c6	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$qx8zVNSeav5WhVbad2JDfOeP0CCXQwi/Dgp8NXO99AJtybOgtPayi	\N	\N	2026-05-28 10:58:47.558	2026-05-21 11:11:51.233	2026-05-21 10:58:47.561	0	6df43dd0-f75a-4bf0-9b9a-26fa9a7109f2	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
$2b$10$4.X9PrKvuDoC9/Xv.49weeEUGCQAH3nRk5oFn3rCbQdBY.FTT40YS	\N	\N	2026-05-28 11:11:51.831	\N	2026-05-21 11:11:51.834	0	26747b62-e951-477c-852a-0a0c16a558f7	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
$2b$10$3QipiLghqDaJMstU0xuJHuoBfNQfLS3xghSIDgpIq1wUp4VGHs5nG	\N	\N	2026-05-28 11:12:51.478	\N	2026-05-21 11:12:51.479	0	6e467530-5523-4827-a67d-ce9828b6c9cc	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
$2b$10$zO/.x9vPUCkGWqrMqV4i8.d1z7MnXN3uuuPz.KI9iqYpwacWRcqca	\N	\N	2026-05-28 11:17:33.287	\N	2026-05-21 11:17:33.288	0	74123cdc-57b3-40a1-b5dc-bfe0492d38ac	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$p.21zT7hSPnoxs67gAgMeOfmO70Y2vOhm/B1.03SA1H8M59hqNfFe	\N	\N	2026-05-28 11:18:56.472	2026-05-21 11:32:01.712	2026-05-21 11:18:56.474	0	201dab04-505c-414c-9aa6-0bf60ef4256c	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
$2b$10$7omx3c4XavJV9qWBxY7oV.u42XWjyUHnEBqNkOAo/lxVQoGuVIWlW	\N	\N	2026-05-28 11:32:01.829	\N	2026-05-21 11:32:01.83	0	694a5d84-516d-4910-8193-a3d72de2a664	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
$2b$10$8I8MAIR8eapy9JOf/KfHvOoqbq0DzHzQkokfd1JEL/59SiAJgJP2m	\N	\N	2026-05-28 11:37:26.696	\N	2026-05-21 11:37:26.698	0	06f78e02-7031-4128-bbae-99b210325d06	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$24WFKGcSdfc1NGpvEZi6GexOAt4SssxT.Veqv5omtmw4TpNEdKszC	\N	\N	2026-05-28 11:37:54.842	2026-05-21 11:50:55.919	2026-05-21 11:37:54.843	0	4b32a9ea-235f-487a-a98e-5d802c52dbe5	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
$2b$10$Br/cHlyca..Yt8bjE66mWuRcWmg/dw7eIv.GzjXKKhxCOQEzdOC.a	\N	\N	2026-05-28 11:50:56.143	\N	2026-05-21 11:50:56.144	0	5b78b238-2201-4532-bc19-6602f82db196	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
$2b$10$dCPq4KaaGoPDvrzojnQCB.djEa5MzGY2NKbf1UGGu25eC2KOwzakO	\N	\N	2026-05-28 12:02:28.691	\N	2026-05-21 12:02:28.692	0	288d92fb-1453-4a6c-98cc-2e56986a5d9d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$PzXs8iqPCuZZ2eLR8bnIw.4oj4Z0unlb.HpTa841XZeabVtY7/kkW	\N	\N	2026-05-28 12:02:02.872	2026-05-21 12:04:01.864	2026-05-21 12:02:02.873	0	2616445a-cef0-4f69-87dc-a20a90d4c409	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
$2b$10$QAq0fPjkmsQscmgqESjXn.qlcBQsfAfuu0yk7vWLiHxxXdWNboLoG	\N	\N	2026-05-28 12:04:02.093	2026-05-21 12:17:01.758	2026-05-21 12:04:02.095	0	eabc43a6-624b-4c31-bbe2-45e5c8448eff	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
$2b$10$hUY2CNwFMDPb5ZeXasVaBOmbgN6SYgwoOmmnF/n6rkh/i/5OWGpqu	\N	\N	2026-05-28 12:17:01.909	\N	2026-05-21 12:17:01.91	0	20037888-a9ba-4a49-9e14-cc0aea4f4bd2	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
$2b$10$MEi22An/jWhm.52N3a3jB.NM2Wy.AzaIlK72fo9yJAojGkSgRNjHu	\N	\N	2026-05-28 12:20:27.452	\N	2026-05-21 12:20:27.453	0	c0678755-0908-44c3-bc16-6976d44d5d34	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$5LrxqEmVhz4D/sD8ZTBXh.XTxf97uLQFjb7Vk9izusW/9GT/GP3Qq	\N	\N	2026-05-28 12:29:29.454	\N	2026-05-21 12:29:29.455	0	495118e9-169c-44f2-b402-4ab1193300ac	8d40647d-da49-4490-ada6-3bfa2205366c
$2b$10$Wx7Ap6kcq0MnQI064lbEMeseEQsylDoQR1RCuSJM8U/EuxVmugaU.	\N	\N	2026-05-28 13:53:20.463	\N	2026-05-21 13:53:20.466	0	9c69b201-1c62-49c3-b96b-4bb6471aa2e0	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$t45nKmMSQMW8jrGtca10/OZ2DWhkgzWAYOewPD3kaKuIfKZbxnPB6	\N	\N	2026-05-28 15:17:10.213	\N	2026-05-21 15:17:10.214	0	b3fed9d7-3639-44dc-bd40-cc5bbc2d98fa	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$RxNKSSmgJcteji7ucCpukuy8idLZKVaJZwwQ2jDsJec1tdDqMJx4.	\N	\N	2026-05-28 15:18:42.198	\N	2026-05-21 15:18:42.201	0	adf0abb3-2035-4907-8c3d-4724abac2f3e	9f08f905-999a-4c6f-87bc-66e29dc6301e
\.


--
-- TOC entry 6048 (class 0 OID 151973)
-- Dependencies: 266
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (role_id, permission_id) FROM stdin;
\.


--
-- TOC entry 6049 (class 0 OID 151978)
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
-- TOC entry 6050 (class 0 OID 151990)
-- Dependencies: 268
-- Data for Name: session_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.session_events (id, session_id, event_type, payload, client_ip, created_at) FROM stdin;
d4666577-8aaf-487a-8591-b1ec1016e0e4	c4ce3860-7509-47a7-b3d6-60592b593100	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-8gmm", "interfaceMode": "gui"}	\N	2026-05-18 07:02:40.069
08076294-fbbc-4aa8-802e-c9b9388b997a	c4ce3860-7509-47a7-b3d6-60592b593100	launch_initiated	{"launchId": "443194db-8bc0-40a7-978e-acecbbccb14f", "containerName": "laas-c4ce3860"}	\N	2026-05-18 07:02:40.146
fbf9a71a-df67-4652-a3fd-d1d3ca5e7647	c4ce3860-7509-47a7-b3d6-60592b593100	launch_scheduling	{"ts": "2026-05-18T07:02:41.228844+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-18 07:02:42.171
a28e6fcb-dfcd-479c-b38a-74a741acaea5	c4ce3860-7509-47a7-b3d6-60592b593100	launch_scheduling	{"ts": "2026-05-18T07:02:41.329030+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-18 07:02:42.174
917a400c-980b-4da5-86b7-930c1e7c4300	c4ce3860-7509-47a7-b3d6-60592b593100	launch_allocating_ports	{"ts": "2026-05-18T07:02:41.329152+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-18 07:02:42.176
fa74faeb-79b9-4b93-a37e-f28ed7ef4352	c4ce3860-7509-47a7-b3d6-60592b593100	launch_allocating_ports	{"ts": "2026-05-18T07:02:41.350574+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-18 07:02:42.178
bb9f4407-842e-435c-bae4-ddf2f251ed31	c4ce3860-7509-47a7-b3d6-60592b593100	launch_allocating_cpus	{"ts": "2026-05-18T07:02:41.350583+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-18 07:02:42.18
3d37cb3d-434c-4211-9cb9-6297a2a49674	c4ce3860-7509-47a7-b3d6-60592b593100	launch_allocating_cpus	{"ts": "2026-05-18T07:02:41.360318+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-18 07:02:42.181
1a42ea2e-d96e-4349-9b12-e5ae4f2107da	c4ce3860-7509-47a7-b3d6-60592b593100	launch_validating_mount	{"ts": "2026-05-18T07:02:41.360339+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_962b82c8054e7213ac9a4938..."}	\N	2026-05-18 07:02:42.183
6560c85f-8bf4-4833-906d-7240cfb48877	c4ce3860-7509-47a7-b3d6-60592b593100	launch_nvme_preparing	{"ts": "2026-05-18T07:02:41.360436+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 10.10.100.99..."}	\N	2026-05-18 07:02:42.185
4b02a7e5-168d-4a4d-8741-4e73033c043c	c4ce3860-7509-47a7-b3d6-60592b593100	launch_nvme_discovering	{"ts": "2026-05-18T07:02:41.575665+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-18 07:02:42.187
efc7ae70-5caa-4d72-986a-bd02721ce0ed	c4ce3860-7509-47a7-b3d6-60592b593100	launch_nvme_discovering	{"ts": "2026-05-18T07:02:41.604500+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-18 07:02:42.189
482078db-ef37-468c-897c-0091975accc4	c4ce3860-7509-47a7-b3d6-60592b593100	launch_nvme_connecting	{"ts": "2026-05-18T07:02:41.604614+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_962b82c8054e7213ac9a4938..."}	\N	2026-05-18 07:02:42.191
09d27583-0678-414d-b6db-accebcd4b2e0	c4ce3860-7509-47a7-b3d6-60592b593100	launch_nvme_connecting	{"ts": "2026-05-18T07:02:41.646515+00:00", "status": "completed", "message": "NVMe-oF connected"}	\N	2026-05-18 07:02:42.192
525c7d49-13d2-43a2-a1f3-40d8e6dd7d61	c4ce3860-7509-47a7-b3d6-60592b593100	launch_nvme_finding_device	{"ts": "2026-05-18T07:02:41.646547+00:00", "status": "in_progress", "message": "Locating NVMe block device..."}	\N	2026-05-18 07:02:42.194
f0ee0f96-11c3-4712-a139-a1577693a70b	c4ce3860-7509-47a7-b3d6-60592b593100	launch_nvme_finding_device	{"ts": "2026-05-18T07:02:42.157999+00:00", "status": "completed", "message": "Block device found: /dev/nvme2n1"}	\N	2026-05-18 07:02:42.195
1231ffa4-6695-4b20-a9b1-6ffdce3a89ed	c4ce3860-7509-47a7-b3d6-60592b593100	launch_nvme_mounting	{"ts": "2026-05-18T07:02:42.158109+00:00", "status": "in_progress", "message": "Mounting /dev/nvme2n1 to /mnt/nvme/u_962b82c8054e7213ac9a4938..."}	\N	2026-05-18 07:02:42.197
7987b3c8-536d-479a-9be7-10bf303a9e47	c4ce3860-7509-47a7-b3d6-60592b593100	launch_nvme_mounting	{"ts": "2026-05-18T07:02:42.183047+00:00", "status": "completed", "message": "NVMe-oF volume mounted"}	\N	2026-05-18 07:02:42.199
cfe77be8-b5b1-4dfd-9ad4-99aa79c178f7	c4ce3860-7509-47a7-b3d6-60592b593100	launch_nvme_verifying	{"ts": "2026-05-18T07:02:42.183105+00:00", "status": "in_progress", "message": "Verifying storage permissions..."}	\N	2026-05-18 07:02:42.2
b7ebe709-aeee-4098-a62d-0d8f1e2bbf5a	c4ce3860-7509-47a7-b3d6-60592b593100	launch_nvme_verifying	{"ts": "2026-05-18T07:02:42.183616+00:00", "status": "completed", "message": "Permissions verified (UID 1000, read/write OK)"}	\N	2026-05-18 07:02:42.202
adba9748-516c-40e5-8aff-fa362532b1df	c4ce3860-7509-47a7-b3d6-60592b593100	launch_validating_mount	{"ts": "2026-05-18T07:02:42.183674+00:00", "status": "completed", "message": "NVMe-oF storage ready at /mnt/nvme/u_962b82c8054e7213ac9a4938"}	\N	2026-05-18 07:02:42.204
9fae2621-e13f-4b29-99a2-9adab41e3e5f	c4ce3860-7509-47a7-b3d6-60592b593100	launch_creating	{"ts": "2026-05-18T07:02:42.183724+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-18 07:02:42.206
8562cb58-2dbe-4ecd-90a3-7c87fbb6c72b	c4ce3860-7509-47a7-b3d6-60592b593100	launch_creating	{"ts": "2026-05-18T07:02:42.262420+00:00", "status": "completed", "message": "Container created: laas-c4ce3860"}	\N	2026-05-18 07:02:42.208
a6606edf-8899-443f-9194-4b99decf9354	c4ce3860-7509-47a7-b3d6-60592b593100	launch_starting	{"ts": "2026-05-18T07:02:42.262426+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-18 07:02:42.209
9e111193-41a2-4a9e-ac80-717b2cafacc5	c4ce3860-7509-47a7-b3d6-60592b593100	launch_starting	{"ts": "2026-05-18T07:02:42.627424+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-18 07:02:42.211
28e34241-2ceb-409b-ba83-d6c911fb7616	c4ce3860-7509-47a7-b3d6-60592b593100	launch_waiting_desktop	{"ts": "2026-05-18T07:02:42.627438+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-18 07:02:42.213
6f75d51b-3be5-41e9-ab25-dce1ed5adc9f	c4ce3860-7509-47a7-b3d6-60592b593100	launch_waiting_desktop	{"ts": "2026-05-18T07:03:00.821226+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-18 07:03:00.411
2983a689-359f-4288-a1c5-23fcf8277bc6	c4ce3860-7509-47a7-b3d6-60592b593100	launch_waiting_desktop	{"ts": "2026-05-18T07:03:00.821242+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-18 07:03:00.415
d66e06ee-4cb4-4173-90e8-df0626c2e6f4	c4ce3860-7509-47a7-b3d6-60592b593100	launch_health_checking	{"ts": "2026-05-18T07:03:00.821246+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-18 07:03:00.417
cbf2f62c-c6f7-4bd7-8538-64003cd984ed	c4ce3860-7509-47a7-b3d6-60592b593100	launch_health_checking	{"ts": "2026-05-18T07:03:02.830784+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-18 07:03:02.438
42ea8a2b-7fe3-4a85-b65c-43dc1f064b86	c4ce3860-7509-47a7-b3d6-60592b593100	launch_ready	{"ts": "2026-05-18T07:03:02.830800+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-18 07:03:02.44
44f84a1f-588b-4171-ac7e-0a8400085d97	c4ce3860-7509-47a7-b3d6-60592b593100	launch_ready	{"ts": "2026-05-18T07:03:02.830808+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-18 07:03:02.442
bd7f88c4-b41c-481a-a9e0-66136275ca4a	c4ce3860-7509-47a7-b3d6-60592b593100	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-18 07:03:02.451
860fcc29-1b7e-4ec2-b1d5-e0e2c604460c	c4ce3860-7509-47a7-b3d6-60592b593100	session_terminated	{"terminatedBy": "8d40647d-da49-4490-ada6-3bfa2205366c", "totalCostCents": 36000, "durationSeconds": 216, "terminationReason": "user_requested", "alreadyBilledCents": 36000, "remainingChargeCents": 0}	\N	2026-05-18 07:06:38.609
ed94e87c-b3cc-460c-adf5-e6f40f9a81ed	b3fb45cb-ac62-41bb-b65b-babce27a14fe	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-bw3i", "interfaceMode": "gui"}	\N	2026-05-18 07:30:32.324
73707bba-b74e-4db8-a86d-66126456cd45	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_initiated	{"launchId": "750288fa-4c25-45ec-bf60-15fbfc8b6e8c", "containerName": "laas-b3fb45cb"}	\N	2026-05-18 07:30:32.379
d6c617f9-1567-4601-a7ef-f492be051f93	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_scheduling	{"ts": "2026-05-18T07:30:33.449614+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-18 07:30:34.413
0aa30f2e-64a4-4c8a-9d50-0f801b384044	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_scheduling	{"ts": "2026-05-18T07:30:33.550049+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-18 07:30:34.417
97b5fc66-6b61-4a54-8ade-0f5d7f7e0787	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_allocating_ports	{"ts": "2026-05-18T07:30:33.550158+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-18 07:30:34.428
25195f1e-8893-45fa-839e-a1278820fcf2	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_allocating_ports	{"ts": "2026-05-18T07:30:33.572271+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-18 07:30:34.432
10056de6-1e30-4e02-9d19-19f619267e28	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_allocating_cpus	{"ts": "2026-05-18T07:30:33.572277+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-18 07:30:34.435
20c86648-a7a0-4be8-9b51-135c54755b3e	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_allocating_cpus	{"ts": "2026-05-18T07:30:33.580576+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-18 07:30:34.438
a4c19efc-fb64-4025-b9c5-1491fc303ffd	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_validating_mount	{"ts": "2026-05-18T07:30:33.580590+00:00", "status": "in_progress", "message": "Verifying local ZFS zvol for u_962b82c8054e7213ac9a4938..."}	\N	2026-05-18 07:30:34.441
e4e4563a-e879-49b8-b5e4-96be7ab85efd	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_validating_mount	{"ts": "2026-05-18T07:30:33.580711+00:00", "status": "completed", "message": "Local ZFS zvol verified: /datapool/users/u_962b82c8054e7213ac9a4938"}	\N	2026-05-18 07:30:34.444
909977ee-7262-432f-b1f8-3205b092c561	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_creating	{"ts": "2026-05-18T07:30:33.580749+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-18 07:30:34.446
f74bcf67-2770-4cba-a097-2c475fe1fa96	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_creating	{"ts": "2026-05-18T07:30:33.666443+00:00", "status": "completed", "message": "Container created: laas-b3fb45cb"}	\N	2026-05-18 07:30:34.449
980308ad-cc87-47c4-88df-e47a3d1e0eb5	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_starting	{"ts": "2026-05-18T07:30:33.666448+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-18 07:30:34.452
ef125b4f-5a2b-496a-9802-3a4a80e05eb8	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_starting	{"ts": "2026-05-18T07:30:33.994330+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-18 07:30:34.455
65717dee-29e3-47d3-adfc-65bb8cf03a8f	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_waiting_desktop	{"ts": "2026-05-18T07:30:33.994343+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-18 07:30:34.458
c26abb16-ee50-4b95-beb3-4e37c6aa66b1	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_waiting_desktop	{"ts": "2026-05-18T07:30:50.162782+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-18 07:30:50.662
69e1e51c-7e8c-4a2d-ba69-6afdd8468f7d	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_waiting_desktop	{"ts": "2026-05-18T07:30:50.162797+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-18 07:30:50.665
7a378c2c-84f2-436e-9bb3-1ad8ba95f44b	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_health_checking	{"ts": "2026-05-18T07:30:50.162803+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-18 07:30:50.668
52cc9450-53a3-4510-8b9d-1f6ba03c5c69	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_health_checking	{"ts": "2026-05-18T07:30:52.171189+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-18 07:30:52.691
dc82e034-7ffe-4ee4-be31-a75793c8abf9	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_ready	{"ts": "2026-05-18T07:30:52.171205+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-18 07:30:52.694
f58c72be-31cf-47f8-9907-813c13a225ca	b3fb45cb-ac62-41bb-b65b-babce27a14fe	launch_ready	{"ts": "2026-05-18T07:30:52.171218+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-18 07:30:52.696
e186633b-1f53-4453-b372-1f7ecec04085	b3fb45cb-ac62-41bb-b65b-babce27a14fe	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.88.57.107:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-18 07:30:52.708
0d9553a2-075f-49d8-b229-5bce887e8042	a50d4adb-5e31-41ba-9972-91dc118efdc0	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "instanceName": "gpu-instance-5ef5", "interfaceMode": "gui"}	\N	2026-05-18 07:31:09.34
f6e5749d-77ce-485d-9a4e-9550ab04ddf2	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_initiated	{"launchId": "013c2ef6-e213-478c-abfa-0e640020de43", "containerName": "laas-a50d4adb"}	\N	2026-05-18 07:31:09.397
c3d01c19-e03c-4348-963d-5c27dd27ec52	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_scheduling	{"ts": "2026-05-18T07:31:10.456056+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-18 07:31:11.43
9512dd55-9d08-4941-9be3-ce86bf3d23b7	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_scheduling	{"ts": "2026-05-18T07:31:10.556535+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-18 07:31:11.434
6e66e9f7-ffa3-41bb-a7f6-e6306b412369	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_allocating_ports	{"ts": "2026-05-18T07:31:10.556661+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-18 07:31:11.437
ceb02725-d869-4d00-9674-a67d58e7fcb7	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_allocating_ports	{"ts": "2026-05-18T07:31:10.577437+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-18 07:31:11.44
d7af92b3-1b8e-4caf-a52a-54e5deba8fe2	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_allocating_cpus	{"ts": "2026-05-18T07:31:10.577447+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-18 07:31:11.442
5a0694de-2114-47c8-8cc6-0b28fd9dfb3e	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_allocating_cpus	{"ts": "2026-05-18T07:31:10.585997+00:00", "status": "completed", "message": "Allocated CPU cores: 2-3"}	\N	2026-05-18 07:31:11.444
ec3c0c96-f6ba-477f-8e67-87694c7dff3e	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_allocating_storage	{"ts": "2026-05-18T07:31:10.586015+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-18 07:31:11.446
8643ed28-60eb-4313-9f89-391a9997a3c6	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_allocating_storage	{"ts": "2026-05-18T07:31:10.586023+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_a50d4adb-5e31-41ba-9972-91dc118efdc0..."}	\N	2026-05-18 07:31:11.45
9192c6d6-cff2-4ae3-b1ff-9ceb19f3bc4d	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_allocating_storage	{"ts": "2026-05-18T07:31:11.329366+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_a50d4adb-5e31-41ba-9972-91dc118efdc0"}	\N	2026-05-18 07:31:11.453
e1a0537c-9187-48f9-819a-b51b169f7090	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_creating	{"ts": "2026-05-18T07:31:11.329427+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-18 07:31:11.456
ccca2486-c877-4584-98aa-464293b25814	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_creating	{"ts": "2026-05-18T07:31:11.456610+00:00", "status": "completed", "message": "Container created: laas-a50d4adb"}	\N	2026-05-18 07:31:11.458
5bd555fb-f9fd-4e39-aae9-12c76f11ffb5	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_starting	{"ts": "2026-05-18T07:31:11.456625+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-18 07:31:11.46
eea298e8-c44d-421d-bf33-78d85530c0d3	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_starting	{"ts": "2026-05-18T07:31:11.760133+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-18 07:31:11.463
36df1895-90b4-4201-9dcc-89aced598cca	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_waiting_desktop	{"ts": "2026-05-18T07:31:11.760146+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-18 07:31:11.466
0b0f1a26-e54e-483f-9ba2-1b5e14a52531	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_waiting_desktop	{"ts": "2026-05-18T07:31:27.920576+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-18 07:31:27.649
ffa95201-227c-4283-8b44-99031456db5a	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_waiting_desktop	{"ts": "2026-05-18T07:31:27.920588+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-18 07:31:27.653
b7f67c06-8834-492b-a7d0-ba39402576a3	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_health_checking	{"ts": "2026-05-18T07:31:27.920591+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-18 07:31:27.655
4e863416-9802-41c1-a115-aa162527c362	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_health_checking	{"ts": "2026-05-18T07:31:29.929821+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-18 07:31:29.674
75ace163-5bd1-44aa-ba5f-d985c006fb60	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_ready	{"ts": "2026-05-18T07:31:29.929837+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-18 07:31:29.676
82fe61dd-39fc-4a33-9b3f-d180fbf5369c	a50d4adb-5e31-41ba-9972-91dc118efdc0	launch_ready	{"ts": "2026-05-18T07:31:29.929845+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-18 07:31:29.678
673b57bc-52e5-463b-bed0-6a1d45f04a4b	a50d4adb-5e31-41ba-9972-91dc118efdc0	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-18 07:31:29.686
f1e4f5c6-8570-4c96-b0c3-c332e814abbc	b3fb45cb-ac62-41bb-b65b-babce27a14fe	session_terminated	{"terminatedBy": "8d40647d-da49-4490-ada6-3bfa2205366c", "totalCostCents": 36000, "durationSeconds": 104, "terminationReason": "user_requested", "alreadyBilledCents": 36000, "remainingChargeCents": 0}	\N	2026-05-18 07:32:37.397
6b98b535-9aaa-4728-b6a8-ffe5fa40918d	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "instanceName": "gpu-instance-64uh", "interfaceMode": "gui"}	\N	2026-05-18 10:21:07.621
063f1556-0aeb-4cbe-9409-a080da955f28	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_initiated	{"launchId": "9f3149f1-f5cf-498e-86c0-a3aa4733655a", "containerName": "laas-b0dbca4f"}	\N	2026-05-18 10:21:07.685
48fd89ba-7e6e-48ba-8fe0-c1649074dc71	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_scheduling	{"ts": "2026-05-18T10:21:09.057979+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-18 10:21:09.71
a42d2d2e-4b49-44a4-8486-9b78695dd723	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_scheduling	{"ts": "2026-05-18T10:21:09.158158+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-18 10:21:09.712
21a072ee-356a-45ad-a2d2-d06f74f88187	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_allocating_ports	{"ts": "2026-05-18T10:21:09.158267+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-18 10:21:09.714
fb6519ad-5673-4654-83c9-280beb601a05	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_allocating_ports	{"ts": "2026-05-18T10:21:09.180769+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-18 10:21:09.716
ee891138-4a0c-441d-bc18-7022ae30e2ec	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_allocating_cpus	{"ts": "2026-05-18T10:21:09.180774+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-18 10:21:09.719
3a0511e4-68e9-4200-b912-230cfb474500	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_allocating_cpus	{"ts": "2026-05-18T10:21:09.189943+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-18 10:21:09.722
1096e3f2-fec8-47e7-a39c-b8b949d1e43b	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_allocating_storage	{"ts": "2026-05-18T10:21:09.189953+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-18 10:21:09.724
99337514-4ae7-4e89-b18b-4d44425976d5	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_allocating_storage	{"ts": "2026-05-18T10:21:09.189958+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_b0dbca4f-3348-4831-a7a6-fb319b7dfb46..."}	\N	2026-05-18 10:21:09.726
a0a42726-fd0a-4469-93f1-e2c19dc09c43	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_allocating_storage	{"ts": "2026-05-18T10:21:09.884462+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_b0dbca4f-3348-4831-a7a6-fb319b7dfb46"}	\N	2026-05-18 10:21:09.727
3b6692a7-1588-4dd3-90c9-fd82a320eddd	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_creating	{"ts": "2026-05-18T10:21:09.884504+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-18 10:21:09.729
01c0daab-18e9-4edc-95de-64dac6e8ce42	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_creating	{"ts": "2026-05-18T10:21:09.959723+00:00", "status": "completed", "message": "Container created: laas-b0dbca4f"}	\N	2026-05-18 10:21:09.73
4b9a113a-8b0e-4de9-a464-c671253cbb68	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_starting	{"ts": "2026-05-18T10:21:09.959733+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-18 10:21:09.732
5886edc8-9e63-4868-ac2d-84d5b5ad9d0a	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_starting	{"ts": "2026-05-18T10:21:10.269103+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-18 10:21:09.733
c60b610b-5097-4975-ac31-40b088199d62	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_waiting_desktop	{"ts": "2026-05-18T10:21:10.269117+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-18 10:21:09.735
de354e43-ceec-42bc-baee-bd43b760b8b5	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_waiting_desktop	{"ts": "2026-05-18T10:21:26.420145+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-18 10:21:26.038
5f86d5b5-0566-4b11-b71e-24a0a34e503e	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_waiting_desktop	{"ts": "2026-05-18T10:21:26.420160+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-18 10:21:26.041
bf443009-37ea-411e-8356-e4f733c027c0	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_health_checking	{"ts": "2026-05-18T10:21:26.420163+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-18 10:21:26.043
a2cb1660-cf76-48fd-bb11-bf4ba6ff5196	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_health_checking	{"ts": "2026-05-18T10:21:28.429000+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-18 10:21:28.086
babbade6-f657-4e70-b791-d89d50f4871e	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_ready	{"ts": "2026-05-18T10:21:28.429013+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-18 10:21:28.089
7af4259e-eb2a-4727-9f49-df35cf2f12cf	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	launch_ready	{"ts": "2026-05-18T10:21:28.429021+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-18 10:21:28.091
57b4dedb-8037-461f-84b8-aed4f7d40055	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.88.57.107:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-18 10:21:28.108
fe6b6dd2-2001-4d41-8496-49dfad28a54e	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	session_terminated	{"terminatedBy": "8d40647d-da49-4490-ada6-3bfa2205366c", "totalCostCents": 288000, "durationSeconds": 25334, "terminationReason": "user_requested", "alreadyBilledCents": 180000, "remainingChargeCents": 108000}	\N	2026-05-18 17:23:42.47
2928bb03-ab28-445d-85a0-ad461d6acd4a	968bf735-3894-4093-838d-efb4a943315d	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "instanceName": "gpu-instance-i0m9", "interfaceMode": "gui"}	\N	2026-05-18 17:36:32.239
3e5b5279-abf3-4d50-ba2b-acb351f83bb6	968bf735-3894-4093-838d-efb4a943315d	launch_initiated	{"launchId": "09dca83f-edfd-46d2-9edd-11e3d15bf4f3", "containerName": "laas-968bf735"}	\N	2026-05-18 17:36:32.288
b9f40567-d695-4ae7-85a3-6ea67b64f282	968bf735-3894-4093-838d-efb4a943315d	launch_scheduling	{"ts": "2026-05-18T17:36:32.243217+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-18 17:36:34.326
94cfd942-d3f5-416c-9a5f-0b1103bf597a	968bf735-3894-4093-838d-efb4a943315d	launch_scheduling	{"ts": "2026-05-18T17:36:32.343396+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-18 17:36:34.329
e1ff1253-2863-4e15-b85d-0b7900949081	968bf735-3894-4093-838d-efb4a943315d	launch_allocating_ports	{"ts": "2026-05-18T17:36:32.343514+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-18 17:36:34.331
e0379362-9ad0-44c7-9088-e5ada507fabd	968bf735-3894-4093-838d-efb4a943315d	launch_allocating_ports	{"ts": "2026-05-18T17:36:32.364250+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-18 17:36:34.336
f13ff51d-c91d-4e07-b535-91c794895a78	968bf735-3894-4093-838d-efb4a943315d	launch_allocating_cpus	{"ts": "2026-05-18T17:36:32.364255+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-18 17:36:34.339
9f8585c9-6b43-499e-9b26-8fda53a9972a	968bf735-3894-4093-838d-efb4a943315d	launch_allocating_cpus	{"ts": "2026-05-18T17:36:32.373263+00:00", "status": "completed", "message": "Allocated CPU cores: 2-3"}	\N	2026-05-18 17:36:34.343
e23b8c4d-4cae-4639-b36d-7f5d015d3342	968bf735-3894-4093-838d-efb4a943315d	launch_allocating_storage	{"ts": "2026-05-18T17:36:32.373277+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-18 17:36:34.346
83236740-1776-449a-abb7-af72dd741615	968bf735-3894-4093-838d-efb4a943315d	launch_allocating_storage	{"ts": "2026-05-18T17:36:32.373282+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_968bf735-3894-4093-838d-efb4a943315d..."}	\N	2026-05-18 17:36:34.348
ea9d08fe-37fb-415d-830c-f27bde41dcde	968bf735-3894-4093-838d-efb4a943315d	launch_allocating_storage	{"ts": "2026-05-18T17:36:33.188254+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_968bf735-3894-4093-838d-efb4a943315d"}	\N	2026-05-18 17:36:34.351
7d5f978a-1a07-42bf-b718-aa3fb03cd040	968bf735-3894-4093-838d-efb4a943315d	launch_creating	{"ts": "2026-05-18T17:36:33.188296+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-18 17:36:34.354
cdfdfacb-ba59-4386-8044-578753dd32f2	968bf735-3894-4093-838d-efb4a943315d	launch_creating	{"ts": "2026-05-18T17:36:33.263168+00:00", "status": "completed", "message": "Container created: laas-968bf735"}	\N	2026-05-18 17:36:34.358
701da549-580b-4333-b0bc-ec4e73d3534c	968bf735-3894-4093-838d-efb4a943315d	launch_starting	{"ts": "2026-05-18T17:36:33.263174+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-18 17:36:34.361
3c2b63f1-ff62-423d-b574-9d3bab734df9	968bf735-3894-4093-838d-efb4a943315d	launch_starting	{"ts": "2026-05-18T17:36:33.602889+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-18 17:36:34.364
0df02cde-c37d-4556-a921-fd98f6e4466c	968bf735-3894-4093-838d-efb4a943315d	launch_waiting_desktop	{"ts": "2026-05-18T17:36:33.602904+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-18 17:36:34.366
24f14778-513a-4a14-9423-f155fe5790dc	968bf735-3894-4093-838d-efb4a943315d	launch_waiting_desktop	{"ts": "2026-05-18T17:36:51.775887+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-18 17:36:52.627
edf53aa3-dbe3-4941-b307-20d35783bbeb	968bf735-3894-4093-838d-efb4a943315d	launch_waiting_desktop	{"ts": "2026-05-18T17:36:51.775900+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-18 17:36:52.629
8a57fd31-dcfd-454a-99df-3e7e03c88826	968bf735-3894-4093-838d-efb4a943315d	launch_health_checking	{"ts": "2026-05-18T17:36:51.775903+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-18 17:36:52.63
30f1012e-c46b-4d57-af87-cf893ea83159	968bf735-3894-4093-838d-efb4a943315d	launch_health_checking	{"ts": "2026-05-18T17:36:53.783930+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-18 17:36:54.649
0ebffc81-342a-40e5-b300-eb9759dc1d42	968bf735-3894-4093-838d-efb4a943315d	launch_ready	{"ts": "2026-05-18T17:36:53.783945+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-18 17:36:54.65
a65f7e3a-2d41-4b1e-9197-14fc8fd4704f	968bf735-3894-4093-838d-efb4a943315d	launch_ready	{"ts": "2026-05-18T17:36:53.783953+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-18 17:36:54.651
9d34342b-03bf-4a79-ad12-4cbf3b3ebe49	968bf735-3894-4093-838d-efb4a943315d	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.88.57.107:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-18 17:36:54.658
757fa154-222a-496b-bb62-acc8c670d110	968bf735-3894-4093-838d-efb4a943315d	session_terminated	{"terminatedBy": "8d40647d-da49-4490-ada6-3bfa2205366c", "totalCostCents": 12000, "durationSeconds": 1554, "terminationReason": "user_requested", "alreadyBilledCents": 12000, "remainingChargeCents": 0}	\N	2026-05-18 18:02:49.447
f9cac6b5-15ca-4f06-a3b8-b9eaf0abc8d2	46541468-ee50-4fab-bd02-4250162c40e6	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "instanceName": "gpu-instance-06p0", "interfaceMode": "gui"}	\N	2026-05-18 18:04:03.815
da4ede4a-84b4-4a08-9123-6c6b88bf2068	46541468-ee50-4fab-bd02-4250162c40e6	launch_initiated	{"launchId": "43501c74-fb01-4df9-94e7-63d8c7df7de8", "containerName": "laas-46541468"}	\N	2026-05-18 18:04:03.893
362507e1-2ad8-4e04-ab7f-b2beb901eb1e	46541468-ee50-4fab-bd02-4250162c40e6	launch_scheduling	{"ts": "2026-05-18T18:04:03.804588+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-18 18:04:05.931
dc91632e-df70-41a1-9503-fd8ab1146d1a	46541468-ee50-4fab-bd02-4250162c40e6	launch_scheduling	{"ts": "2026-05-18T18:04:03.904771+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-18 18:04:05.933
5e308db5-918e-45e1-8c5c-283c8d971998	46541468-ee50-4fab-bd02-4250162c40e6	launch_allocating_ports	{"ts": "2026-05-18T18:04:03.904889+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-18 18:04:05.935
21af2e3b-96a6-4934-8773-02484f30865d	46541468-ee50-4fab-bd02-4250162c40e6	launch_allocating_ports	{"ts": "2026-05-18T18:04:03.926547+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-18 18:04:05.936
e8b57c85-f3fa-429f-b28e-dd0244407b5a	46541468-ee50-4fab-bd02-4250162c40e6	launch_allocating_cpus	{"ts": "2026-05-18T18:04:03.926552+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-18 18:04:05.938
94e17d8d-eb2b-4b35-8ecd-1e1f81aecd3f	46541468-ee50-4fab-bd02-4250162c40e6	launch_allocating_cpus	{"ts": "2026-05-18T18:04:03.935708+00:00", "status": "completed", "message": "Allocated CPU cores: 2-3"}	\N	2026-05-18 18:04:05.939
7dead283-cbe6-4dda-aa38-a0e1d11ba24f	46541468-ee50-4fab-bd02-4250162c40e6	launch_allocating_storage	{"ts": "2026-05-18T18:04:03.935720+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-18 18:04:05.941
9d7e2ef3-6596-4834-9f78-14829bec5e8f	46541468-ee50-4fab-bd02-4250162c40e6	launch_allocating_storage	{"ts": "2026-05-18T18:04:03.935728+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_46541468-ee50-4fab-bd02-4250162c40e6..."}	\N	2026-05-18 18:04:05.942
1fd9e2a7-9004-4b04-ab37-17a2d4eab802	46541468-ee50-4fab-bd02-4250162c40e6	launch_allocating_storage	{"ts": "2026-05-18T18:04:04.623985+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_46541468-ee50-4fab-bd02-4250162c40e6"}	\N	2026-05-18 18:04:05.944
c88b96f1-fa20-4314-941a-30f20e44ad56	46541468-ee50-4fab-bd02-4250162c40e6	launch_creating	{"ts": "2026-05-18T18:04:04.624029+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-18 18:04:05.945
e9bab0ea-f826-47db-9e5f-506e117bc08e	46541468-ee50-4fab-bd02-4250162c40e6	launch_creating	{"ts": "2026-05-18T18:04:04.701495+00:00", "status": "completed", "message": "Container created: laas-46541468"}	\N	2026-05-18 18:04:05.946
7e91143f-bfec-403a-9d13-c85bc385eb6e	46541468-ee50-4fab-bd02-4250162c40e6	launch_starting	{"ts": "2026-05-18T18:04:04.701501+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-18 18:04:05.947
ba9de620-0a76-4b50-92bf-74aef895ffee	46541468-ee50-4fab-bd02-4250162c40e6	launch_starting	{"ts": "2026-05-18T18:04:05.016370+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-18 18:04:05.948
09b64faa-a08e-4e54-b2fb-80fdb6dc442f	46541468-ee50-4fab-bd02-4250162c40e6	launch_waiting_desktop	{"ts": "2026-05-18T18:04:05.016382+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-18 18:04:05.95
c6f8eb40-f9cb-4fba-b6f3-49cdcac0743e	46541468-ee50-4fab-bd02-4250162c40e6	launch_waiting_desktop	{"ts": "2026-05-18T18:04:23.184329+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-18 18:04:24.403
f7dbd681-d8f0-4384-8d2d-8d0415fc6069	46541468-ee50-4fab-bd02-4250162c40e6	launch_waiting_desktop	{"ts": "2026-05-18T18:04:23.184344+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-18 18:04:24.405
dd5a88f7-60dd-47e5-85eb-c5049dcf03df	46541468-ee50-4fab-bd02-4250162c40e6	launch_health_checking	{"ts": "2026-05-18T18:04:23.184348+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-18 18:04:24.406
de3b0000-300b-4e65-bf11-531da78ccfc5	46541468-ee50-4fab-bd02-4250162c40e6	launch_health_checking	{"ts": "2026-05-18T18:04:25.192058+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-18 18:04:26.431
5aa8d925-6e52-4340-b519-4f6e87b60278	46541468-ee50-4fab-bd02-4250162c40e6	launch_ready	{"ts": "2026-05-18T18:04:25.192073+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-18 18:04:26.432
d781dc6b-4c5e-4118-bc1f-16550a127dc8	46541468-ee50-4fab-bd02-4250162c40e6	launch_ready	{"ts": "2026-05-18T18:04:25.192082+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-18 18:04:26.433
d8313f4d-3c19-422a-a435-c52f56729167	46541468-ee50-4fab-bd02-4250162c40e6	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.88.57.107:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-18 18:04:26.441
d40a4e80-baf0-4fb4-992e-e4575a19a0f1	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "instanceName": "gpu-instance-ytlg", "interfaceMode": "gui"}	\N	2026-05-18 18:37:31.873
4eaf6711-4702-44ee-9a02-f3ccd85e4a78	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_initiated	{"launchId": "fd653dce-37de-4902-a0fd-cc7f5c85738a", "containerName": "laas-b46a1616"}	\N	2026-05-18 18:37:31.929
235b2a38-ffb7-4ca8-a526-c9e5cf1bf5f4	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_scheduling	{"ts": "2026-05-18T18:37:31.780847+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-18 18:37:33.965
d8777053-9573-4be5-9e37-25dcad0411a7	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_scheduling	{"ts": "2026-05-18T18:37:31.881284+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-18 18:37:33.967
54e3e08d-e2e2-42c7-b98e-14cf1500a7d0	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_allocating_ports	{"ts": "2026-05-18T18:37:31.881407+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-18 18:37:33.969
ba9b0966-1c3e-4bfb-adb4-f407239f7eb5	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_allocating_ports	{"ts": "2026-05-18T18:37:31.953498+00:00", "status": "completed", "message": "Allocated ports: nginx=8102, selkies=9102, metrics=19102, display=:21"}	\N	2026-05-18 18:37:33.97
458684b1-cb0a-4560-84e5-9dd0fac19d65	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_allocating_cpus	{"ts": "2026-05-18T18:37:31.953510+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-18 18:37:33.971
f57a3f62-5b54-40bf-9bab-01eea37dd155	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_allocating_cpus	{"ts": "2026-05-18T18:37:31.988197+00:00", "status": "completed", "message": "Allocated CPU cores: 4-5"}	\N	2026-05-18 18:37:33.973
d1963ee3-4d43-4479-b132-59e8def60fa8	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_allocating_storage	{"ts": "2026-05-18T18:37:31.988214+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-18 18:37:33.974
d0916eef-f05f-4222-b186-51ad48d1d9c8	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_allocating_storage	{"ts": "2026-05-18T18:37:31.988218+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe..."}	\N	2026-05-18 18:37:33.975
cfaffdd3-5264-4b69-8e88-fbe986d521f2	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_allocating_storage	{"ts": "2026-05-18T18:37:32.760630+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe"}	\N	2026-05-18 18:37:33.976
85b7f9da-db62-4e96-8d96-f9a932410c86	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_creating	{"ts": "2026-05-18T18:37:32.760672+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-18 18:37:33.978
ad7d41aa-580f-4c1b-a404-c5607404ecd1	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_creating	{"ts": "2026-05-18T18:37:32.879665+00:00", "status": "completed", "message": "Container created: laas-b46a1616"}	\N	2026-05-18 18:37:33.979
0615a504-3c71-4e31-8b09-3f524eaa4a89	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_starting	{"ts": "2026-05-18T18:37:32.879682+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-18 18:37:33.98
bfa44279-ebec-4039-ad46-b8e420340017	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_starting	{"ts": "2026-05-18T18:37:33.216959+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-18 18:37:33.981
37326cd7-3cd4-4875-9e65-e46751055711	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_waiting_desktop	{"ts": "2026-05-18T18:37:33.216976+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8102..."}	\N	2026-05-18 18:37:33.983
641e3deb-9740-40cd-85f7-f5d821489bf6	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_waiting_desktop	{"ts": "2026-05-18T18:37:51.390129+00:00", "status": "completed", "message": "Desktop responding on port 8102 (HTTP 401)"}	\N	2026-05-18 18:37:52.398
402503c6-5d7b-4946-b720-bd42e09ba636	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_waiting_desktop	{"ts": "2026-05-18T18:37:51.390144+00:00", "status": "completed", "message": "Desktop responding on port 8102"}	\N	2026-05-18 18:37:52.399
3a29a19a-e7fd-413b-b03a-644d685bef4a	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_health_checking	{"ts": "2026-05-18T18:37:51.390147+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-18 18:37:52.4
c71860dc-e494-4e22-8825-72bead4f9a8d	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_health_checking	{"ts": "2026-05-18T18:37:53.397663+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-18 18:37:54.444
5101f022-9922-4bfd-a339-4b8444754dd7	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_ready	{"ts": "2026-05-18T18:37:53.397677+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-18 18:37:54.446
8aa42a7a-4548-4165-9bad-d8237400b8fe	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	launch_ready	{"ts": "2026-05-18T18:37:53.397685+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-18 18:37:54.447
0b22e0f2-9fd7-45af-81ac-bef4751b0e3c	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	session_ready	{"nginxPort": 8102, "sessionUrl": "http://100.94.157.114:8102/", "selkiesPort": 9102, "displayNumber": 21}	\N	2026-05-18 18:37:54.454
4998bd34-0c1c-431f-b301-65c389441726	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	session_terminated	{"terminatedBy": "8d40647d-da49-4490-ada6-3bfa2205366c", "totalCostCents": 12000, "durationSeconds": 31, "terminationReason": "user_requested", "alreadyBilledCents": 12000, "remainingChargeCents": 0}	\N	2026-05-18 18:38:26.218
d9b2c9e4-f393-46bd-a4da-2eb6e70d113b	aef9cfcc-1747-4572-933e-6cf55bce8993	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "instanceName": "gpu-instance-fn5b", "interfaceMode": "gui"}	\N	2026-05-19 00:22:02.122
7e732517-aaf8-4d9f-aea9-4c2512ecb0f2	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_initiated	{"launchId": "5ff25752-38f1-4209-b63a-cfa1834a339f", "containerName": "laas-aef9cfcc"}	\N	2026-05-19 00:22:02.169
00620c71-9f4a-4129-bf0b-24e6c60112f2	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_scheduling	{"ts": "2026-05-19T00:22:01.866950+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-19 00:22:04.189
fe2a0ae5-942f-43fe-96b5-4f27658c698d	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_scheduling	{"ts": "2026-05-19T00:22:01.967429+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-19 00:22:04.191
a5260d17-e213-40b9-bed9-4867a921fac8	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_allocating_ports	{"ts": "2026-05-19T00:22:01.967555+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-19 00:22:04.193
644f1008-d345-4476-89fb-fa26fe178aed	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_allocating_ports	{"ts": "2026-05-19T00:22:02.044704+00:00", "status": "completed", "message": "Allocated ports: nginx=8102, selkies=9102, metrics=19102, display=:21"}	\N	2026-05-19 00:22:04.195
cde2db80-3934-4999-9b05-5b3cffaec550	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_allocating_cpus	{"ts": "2026-05-19T00:22:02.044716+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-19 00:22:04.196
2a6e35a3-8b44-4420-bb8d-83b99658355f	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_allocating_cpus	{"ts": "2026-05-19T00:22:02.079112+00:00", "status": "completed", "message": "Allocated CPU cores: 4-5"}	\N	2026-05-19 00:22:04.197
9ae1ad58-e2be-4453-ba3f-8bbf9462b4d2	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_allocating_storage	{"ts": "2026-05-19T00:22:02.079133+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-19 00:22:04.198
a21f9780-a41d-445b-9038-da3424f74505	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_allocating_storage	{"ts": "2026-05-19T00:22:02.079139+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_aef9cfcc-1747-4572-933e-6cf55bce8993..."}	\N	2026-05-19 00:22:04.2
ef55c85f-85a7-4f6d-a66f-923f569b8ab3	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_allocating_storage	{"ts": "2026-05-19T00:22:02.841013+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_aef9cfcc-1747-4572-933e-6cf55bce8993"}	\N	2026-05-19 00:22:04.201
34463be2-cac9-4c0f-9005-dc6aed15448b	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_creating	{"ts": "2026-05-19T00:22:02.841069+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-19 00:22:04.202
76fb2605-39eb-4722-a07b-ae7a5c2f5e95	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_creating	{"ts": "2026-05-19T00:22:02.952160+00:00", "status": "completed", "message": "Container created: laas-aef9cfcc"}	\N	2026-05-19 00:22:04.203
f83abbd2-e532-4b52-8ad5-dfd5d4e3fd47	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_starting	{"ts": "2026-05-19T00:22:02.952175+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-19 00:22:04.204
fd0f213a-e104-4a7b-bf3a-f39cd810675a	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_starting	{"ts": "2026-05-19T00:22:03.251542+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-19 00:22:04.205
6a90c147-85a1-478f-b578-27ca7e7d5a17	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_waiting_desktop	{"ts": "2026-05-19T00:22:03.251562+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8102..."}	\N	2026-05-19 00:22:04.206
02983fd0-7cb0-4e39-934a-6fcef57c0b81	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_waiting_desktop	{"ts": "2026-05-19T00:22:19.405983+00:00", "status": "completed", "message": "Desktop responding on port 8102 (HTTP 401)"}	\N	2026-05-19 00:22:20.414
522f4722-9be1-45d2-8b5e-84010e6ee407	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_waiting_desktop	{"ts": "2026-05-19T00:22:19.405998+00:00", "status": "completed", "message": "Desktop responding on port 8102"}	\N	2026-05-19 00:22:20.415
69bd8cae-d2d3-4b3d-8c4f-ea5dd9010386	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_health_checking	{"ts": "2026-05-19T00:22:19.406001+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-19 00:22:20.417
b299e85c-d6a7-4cbb-a20e-b27dadbe80fe	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_health_checking	{"ts": "2026-05-19T00:22:21.414769+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-19 00:22:22.445
e1dcef8c-1f7a-4214-bd04-d2b0afeb203d	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_ready	{"ts": "2026-05-19T00:22:21.414785+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-19 00:22:22.447
28eddb09-3cb6-4284-a7a6-9311ffe7f119	aef9cfcc-1747-4572-933e-6cf55bce8993	launch_ready	{"ts": "2026-05-19T00:22:21.414793+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-19 00:22:22.449
1f37fed5-134e-4904-8f59-54354ba13e24	aef9cfcc-1747-4572-933e-6cf55bce8993	session_ready	{"nginxPort": 8102, "sessionUrl": "http://100.94.157.114:8102/", "selkiesPort": 9102, "displayNumber": 21}	\N	2026-05-19 00:22:22.458
a673d05b-10ac-487b-a4f2-b9e630786635	a50d4adb-5e31-41ba-9972-91dc118efdc0	session_terminated	{"terminatedBy": "8d40647d-da49-4490-ada6-3bfa2205366c", "totalCostCents": 204000, "durationSeconds": 60715, "terminationReason": "user_requested", "alreadyBilledCents": 132000, "remainingChargeCents": 72000}	\N	2026-05-19 00:23:24.891
046a3b04-2d1d-4614-a4c0-4ef663a68026	aef9cfcc-1747-4572-933e-6cf55bce8993	session_terminated	{"terminatedBy": "8d40647d-da49-4490-ada6-3bfa2205366c", "totalCostCents": 12000, "durationSeconds": 101, "terminationReason": "user_requested", "alreadyBilledCents": 12000, "remainingChargeCents": 0}	\N	2026-05-19 00:24:03.792
25492300-5148-48b3-85ff-cc5e5748c551	fae608c4-ed05-41cd-b0b6-4134aaaa6354	session_created	{"configName": "Inferno", "configSlug": "inferno", "storageType": "ephemeral", "instanceName": "gpu-instance-z09o", "interfaceMode": "gui"}	\N	2026-05-19 00:24:43.567
d7f823ef-2f5b-47cf-a88e-898afcbe088c	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_initiated	{"launchId": "0d5eb0aa-f718-4129-b34d-8f4279efa4b1", "containerName": "laas-fae608c4"}	\N	2026-05-19 00:24:43.62
ae26ade4-ec3a-4a59-986b-d78f65d45e43	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_scheduling	{"ts": "2026-05-19T00:24:43.314105+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-19 00:24:45.656
2c3fc150-6ea1-458a-ba4f-f5e2358374dd	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_scheduling	{"ts": "2026-05-19T00:24:43.414530+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-19 00:24:45.657
3b6cfeab-acbd-41ec-9510-ccc031c5ede2	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_allocating_ports	{"ts": "2026-05-19T00:24:43.414644+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-19 00:24:45.659
7d6d3639-466e-4539-b736-65c9d7c83977	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_allocating_ports	{"ts": "2026-05-19T00:24:43.436849+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-19 00:24:45.66
24e1bfa2-4d2f-48b9-b06b-2fdc834ca72e	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_allocating_cpus	{"ts": "2026-05-19T00:24:43.436854+00:00", "status": "in_progress", "message": "Finding 8 contiguous CPU cores..."}	\N	2026-05-19 00:24:45.662
af61b070-5e28-4c45-addd-a46e52045a73	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_allocating_cpus	{"ts": "2026-05-19T00:24:43.446033+00:00", "status": "completed", "message": "Allocated CPU cores: 2-9"}	\N	2026-05-19 00:24:45.663
04528edb-bc56-49de-a76d-3a81bbd50e44	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_allocating_storage	{"ts": "2026-05-19T00:24:43.446043+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-19 00:24:45.665
e995eed6-2758-4d15-afdd-a0609cc6fe30	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_allocating_storage	{"ts": "2026-05-19T00:24:43.446048+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_fae608c4-ed05-41cd-b0b6-4134aaaa6354..."}	\N	2026-05-19 00:24:45.666
62ffbe36-e64b-4ba3-8c2e-3b7f6e30606e	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_allocating_storage	{"ts": "2026-05-19T00:24:44.145072+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_fae608c4-ed05-41cd-b0b6-4134aaaa6354"}	\N	2026-05-19 00:24:45.668
1661300e-6721-493d-bfd7-098e34b1d046	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_creating	{"ts": "2026-05-19T00:24:44.145127+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-19 00:24:45.669
b64bc4f6-77b8-4005-a3fa-0faa68610497	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_creating	{"ts": "2026-05-19T00:24:44.220180+00:00", "status": "completed", "message": "Container created: laas-fae608c4"}	\N	2026-05-19 00:24:45.67
8ede2707-84df-4ace-9c12-affe84f37e24	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_starting	{"ts": "2026-05-19T00:24:44.220187+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-19 00:24:45.671
cbaba781-9c73-42ee-9a28-32cbd4f31830	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_starting	{"ts": "2026-05-19T00:24:44.516494+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-19 00:24:45.673
2ff273d3-3dc4-4ba5-85f8-9c86b9b8dc76	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_waiting_desktop	{"ts": "2026-05-19T00:24:44.516511+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-19 00:24:45.674
c59f362e-0db1-48a0-ae63-e7ecf0de4055	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_waiting_desktop	{"ts": "2026-05-19T00:24:56.639284+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-19 00:24:57.843
8c48298a-132d-4eb1-9d6f-cff9dd0e0733	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_waiting_desktop	{"ts": "2026-05-19T00:24:56.639299+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-19 00:24:57.844
68dac265-3083-4d34-b4da-14f21fa65cda	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_ready	{"ts": "2026-05-20T07:22:39.647999+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-20 07:22:38.939
d920e4a3-2066-48b2-a9f3-a9539b224559	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_health_checking	{"ts": "2026-05-19T00:24:56.639302+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-19 00:24:57.845
98322329-f7f4-4955-8447-faf7e2bc1863	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_health_checking	{"ts": "2026-05-19T00:24:58.647029+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-19 00:24:59.872
2407b8b2-c437-4e8d-9ebe-6bdb66c1ea99	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_ready	{"ts": "2026-05-19T00:24:58.647049+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-19 00:24:59.875
06d97301-e754-428f-aba1-44b5252fc914	fae608c4-ed05-41cd-b0b6-4134aaaa6354	launch_ready	{"ts": "2026-05-19T00:24:58.647057+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-19 00:24:59.876
0cada58a-9313-4a87-a8e5-624a9741b0ba	fae608c4-ed05-41cd-b0b6-4134aaaa6354	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-19 00:24:59.883
8732ec47-3e05-44fc-ac40-d312836565c3	fae608c4-ed05-41cd-b0b6-4134aaaa6354	session_terminated	{"terminatedBy": "8d40647d-da49-4490-ada6-3bfa2205366c", "totalCostCents": 30000, "durationSeconds": 70, "terminationReason": "user_requested", "alreadyBilledCents": 30000, "remainingChargeCents": 0}	\N	2026-05-19 00:26:10.463
4e5e7798-82e1-4baf-a1d3-58ee5d8d0a64	8548fb98-e8da-4f26-85da-e343210f26a2	session_created	{"configName": "Inferno", "configSlug": "inferno", "storageType": "ephemeral", "instanceName": "gpu-instance-gsim", "interfaceMode": "gui"}	\N	2026-05-19 04:27:52.473
eb8d8a31-012a-46f8-b626-4ce18aeb8ce5	8548fb98-e8da-4f26-85da-e343210f26a2	launch_initiated	{"launchId": "8e86836f-0d27-40f9-a5b9-72efc853fcaf", "containerName": "laas-8548fb98"}	\N	2026-05-19 04:27:52.527
9320fef7-d61c-492c-aee7-4abe8fb78615	8548fb98-e8da-4f26-85da-e343210f26a2	launch_scheduling	{"ts": "2026-05-19T04:27:53.610377+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-19 04:27:54.59
780216ff-b076-47f9-a5df-cf6fa6c2b94e	8548fb98-e8da-4f26-85da-e343210f26a2	launch_scheduling	{"ts": "2026-05-19T04:27:53.710803+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-19 04:27:54.595
304fe0fb-3bb7-4bfd-b90f-1efa61a7c50a	8548fb98-e8da-4f26-85da-e343210f26a2	launch_allocating_ports	{"ts": "2026-05-19T04:27:53.710919+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-19 04:27:54.604
4cabb3a9-cdff-4a32-b563-4106e3ca99f5	8548fb98-e8da-4f26-85da-e343210f26a2	launch_allocating_ports	{"ts": "2026-05-19T04:27:53.734512+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-19 04:27:54.609
61e41457-b55e-4574-b00d-453947e36d3c	8548fb98-e8da-4f26-85da-e343210f26a2	launch_allocating_cpus	{"ts": "2026-05-19T04:27:53.734520+00:00", "status": "in_progress", "message": "Finding 8 contiguous CPU cores..."}	\N	2026-05-19 04:27:54.615
3cbd95f5-d67d-4139-bf79-2166de619de1	8548fb98-e8da-4f26-85da-e343210f26a2	launch_allocating_cpus	{"ts": "2026-05-19T04:27:53.745484+00:00", "status": "completed", "message": "Allocated CPU cores: 2-9"}	\N	2026-05-19 04:27:54.632
80c59699-d0fd-4a36-8628-af114b373fca	8548fb98-e8da-4f26-85da-e343210f26a2	launch_allocating_storage	{"ts": "2026-05-19T04:27:53.745497+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-19 04:27:54.642
44cbfc3a-5ede-4d6a-9c00-f4c9de2a45ce	8548fb98-e8da-4f26-85da-e343210f26a2	launch_allocating_storage	{"ts": "2026-05-19T04:27:53.745504+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_8548fb98-e8da-4f26-85da-e343210f26a2..."}	\N	2026-05-19 04:27:54.653
0255ea41-ab35-47a6-bedd-b6bd752e2734	8548fb98-e8da-4f26-85da-e343210f26a2	launch_allocating_storage	{"ts": "2026-05-19T04:27:54.485168+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_8548fb98-e8da-4f26-85da-e343210f26a2"}	\N	2026-05-19 04:27:54.663
5d429913-a910-4993-b558-c88efe227dcd	8548fb98-e8da-4f26-85da-e343210f26a2	launch_creating	{"ts": "2026-05-19T04:27:54.485208+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-19 04:27:54.683
79ea962d-21bd-4b7c-bb6a-10a745154545	8548fb98-e8da-4f26-85da-e343210f26a2	launch_creating	{"ts": "2026-05-19T04:27:54.560222+00:00", "status": "completed", "message": "Container created: laas-8548fb98"}	\N	2026-05-19 04:27:54.694
05474328-d359-49cc-9cea-e1285fe4bc05	8548fb98-e8da-4f26-85da-e343210f26a2	launch_starting	{"ts": "2026-05-19T04:27:54.560233+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-19 04:27:54.709
997ef7c4-5311-4c59-a047-208a8a64832f	8548fb98-e8da-4f26-85da-e343210f26a2	launch_starting	{"ts": "2026-05-19T04:27:54.857001+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-19 04:27:54.717
58ed499f-f651-46e4-bffa-88616857f4fc	8548fb98-e8da-4f26-85da-e343210f26a2	launch_waiting_desktop	{"ts": "2026-05-19T04:27:54.857016+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-19 04:27:54.726
318647ed-3a1a-4c7d-b596-28e8d88f878d	8548fb98-e8da-4f26-85da-e343210f26a2	launch_waiting_desktop	{"ts": "2026-05-19T04:28:13.039200+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-19 04:28:12.949
e6e51148-e7b8-4019-bc40-23cc2b27bc87	8548fb98-e8da-4f26-85da-e343210f26a2	launch_waiting_desktop	{"ts": "2026-05-19T04:28:13.039214+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-19 04:28:12.952
2046213b-269e-4f24-b1c5-e044f10291a7	8548fb98-e8da-4f26-85da-e343210f26a2	launch_health_checking	{"ts": "2026-05-19T04:28:13.039218+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-19 04:28:12.954
41d141af-7658-4f6c-94cb-488a6b49e8f1	8548fb98-e8da-4f26-85da-e343210f26a2	launch_health_checking	{"ts": "2026-05-19T04:28:15.047183+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-19 04:28:15.025
2ab288fe-5be4-4416-b0d7-ff9e61633f0c	8548fb98-e8da-4f26-85da-e343210f26a2	launch_ready	{"ts": "2026-05-19T04:28:15.047199+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-19 04:28:15.031
78427498-7522-452e-96e4-4bc913df83e3	8548fb98-e8da-4f26-85da-e343210f26a2	launch_ready	{"ts": "2026-05-19T04:28:15.047207+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-19 04:28:15.042
3c063acd-d668-4990-ba7e-ecc2659d85ed	8548fb98-e8da-4f26-85da-e343210f26a2	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-19 04:28:15.137
185f534b-628a-4599-a712-6d9007588212	7c24eb9b-cef9-43c9-9874-220745bc7662	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "instanceName": "gpu-instance-0ybq", "interfaceMode": "gui"}	\N	2026-05-19 12:43:12.321
113670a5-a6e2-4ab7-b46d-852b66352f2e	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_initiated	{"launchId": "b653eca2-db0f-434d-acf7-f80189854811", "containerName": "laas-7c24eb9b"}	\N	2026-05-19 12:43:12.375
6f4756b6-c069-481e-b243-a1e04c11de2c	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_scheduling	{"ts": "2026-05-19T12:43:12.688082+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-19 12:43:14.403
b0e7ac25-d6ed-4362-b3bc-68888a0e9aeb	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_scheduling	{"ts": "2026-05-19T12:43:12.788724+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-19 12:43:14.405
258538b4-af61-4d58-9c51-f8e6881d6129	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_allocating_ports	{"ts": "2026-05-19T12:43:12.788839+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-19 12:43:14.407
45e8f262-8eb8-4852-b46b-243fc3412ba6	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_allocating_ports	{"ts": "2026-05-19T12:43:12.867596+00:00", "status": "completed", "message": "Allocated ports: nginx=8102, selkies=9102, metrics=19102, display=:21"}	\N	2026-05-19 12:43:14.41
29c7322c-1103-42d2-bd00-c4b00ffd00bc	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_allocating_cpus	{"ts": "2026-05-19T12:43:12.867605+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-19 12:43:14.412
d91ea84d-b646-4224-a90e-b42d59d95b23	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_allocating_cpus	{"ts": "2026-05-19T12:43:12.901610+00:00", "status": "completed", "message": "Allocated CPU cores: 10-11"}	\N	2026-05-19 12:43:14.414
8973f163-a7ae-4848-9744-39058749f457	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_allocating_storage	{"ts": "2026-05-19T12:43:12.901630+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-19 12:43:14.416
b3260b50-c816-4c08-b63f-3c49d0e5c08e	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_allocating_storage	{"ts": "2026-05-19T12:43:12.901636+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_7c24eb9b-cef9-43c9-9874-220745bc7662..."}	\N	2026-05-19 12:43:14.419
995bd802-b27b-4b7c-a4eb-4941d18b4557	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_allocating_storage	{"ts": "2026-05-19T12:43:13.662900+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_7c24eb9b-cef9-43c9-9874-220745bc7662"}	\N	2026-05-19 12:43:14.421
c271c38f-9a59-4654-b563-45555697bee6	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_creating	{"ts": "2026-05-19T12:43:13.662952+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-19 12:43:14.424
50616993-07be-48bd-8857-7bdda50e019a	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_creating	{"ts": "2026-05-19T12:43:13.792546+00:00", "status": "completed", "message": "Container created: laas-7c24eb9b"}	\N	2026-05-19 12:43:14.426
62f01243-47de-4577-bad1-fe90a2d76293	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_starting	{"ts": "2026-05-19T12:43:13.792561+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-19 12:43:14.428
4c086013-0ca8-4b8f-a6ae-a8f0df9b52b5	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_starting	{"ts": "2026-05-19T12:43:14.076736+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-19 12:43:14.431
c616b158-a2e0-4940-aa55-077602eecc0f	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_waiting_desktop	{"ts": "2026-05-19T12:43:14.076749+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8102..."}	\N	2026-05-19 12:43:14.44
1818a647-e7fb-40e2-b115-6ae5c56bfe52	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_waiting_desktop	{"ts": "2026-05-19T12:43:32.255566+00:00", "status": "completed", "message": "Desktop responding on port 8102 (HTTP 401)"}	\N	2026-05-19 12:43:32.657
8535786e-da26-4a7d-ac07-d3a1dea27d29	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_waiting_desktop	{"ts": "2026-05-19T12:43:32.255580+00:00", "status": "completed", "message": "Desktop responding on port 8102"}	\N	2026-05-19 12:43:32.66
b003ff9d-1ec5-48a7-a0a5-a6b98643186d	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_health_checking	{"ts": "2026-05-19T12:43:32.255583+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-19 12:43:32.667
d5c17644-d47a-4608-9d93-ef49f2e62659	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_health_checking	{"ts": "2026-05-19T12:43:34.264843+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-19 12:43:34.69
97510594-f451-4eed-a066-7a153c917fc2	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_ready	{"ts": "2026-05-19T12:43:34.264858+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-19 12:43:34.693
9357511e-5a3e-40f4-bf39-0111ffc4331f	7c24eb9b-cef9-43c9-9874-220745bc7662	launch_ready	{"ts": "2026-05-19T12:43:34.264864+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-19 12:43:34.694
016d32d4-6d2f-4abc-892b-0ba6795d9964	7c24eb9b-cef9-43c9-9874-220745bc7662	session_ready	{"nginxPort": 8102, "sessionUrl": "http://100.94.157.114:8102/", "selkiesPort": 9102, "displayNumber": 21}	\N	2026-05-19 12:43:34.705
574b50d1-4ace-4a6b-9bf2-de41a9bc02e1	8548fb98-e8da-4f26-85da-e343210f26a2	session_terminated	{"terminatedBy": "8d40647d-da49-4490-ada6-3bfa2205366c", "totalCostCents": 390000, "durationSeconds": 43535, "terminationReason": "user_requested", "alreadyBilledCents": 300000, "remainingChargeCents": 90000}	\N	2026-05-19 16:33:50.169
eb7b595a-0deb-4395-bcc2-b24d99d7bb38	7c24eb9b-cef9-43c9-9874-220745bc7662	session_terminated	{"terminatedBy": "8d40647d-da49-4490-ada6-3bfa2205366c", "totalCostCents": 48000, "durationSeconds": 13845, "terminationReason": "user_requested", "alreadyBilledCents": 24000, "remainingChargeCents": 24000}	\N	2026-05-19 16:34:20.18
c23ac7c7-911f-4d40-b799-6164fa61830d	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "instanceName": "gpu-instance-ryym", "interfaceMode": "gui"}	\N	2026-05-20 00:43:02.167
8acec1d4-eca4-4f60-bae5-65a51155e965	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_initiated	{"launchId": "651bfb40-8599-4c26-b9b0-2ea7ea3af9ea", "containerName": "laas-dc4bfb83"}	\N	2026-05-20 00:43:02.226
9158ee60-7486-42f8-974d-2b32c1b19c74	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_scheduling	{"ts": "2026-05-20T00:43:03.446735+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-20 00:43:04.257
bfe2c7c7-d6d3-488f-8715-9c8651c0681c	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_scheduling	{"ts": "2026-05-20T00:43:03.547144+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-20 00:43:04.259
12c47cd3-40e5-4c1d-b5b3-2193b3ead66b	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_allocating_ports	{"ts": "2026-05-20T00:43:03.547260+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-20 00:43:04.26
92be7c28-0b4b-4a4c-89c7-ed11449be638	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_allocating_ports	{"ts": "2026-05-20T00:43:03.571365+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-20 00:43:04.262
4e5d10bb-97e1-4595-a40d-ef7efa212ee3	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_allocating_cpus	{"ts": "2026-05-20T00:43:03.571370+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-20 00:43:04.264
f6076437-1381-499c-ba4e-0a32621d8b00	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_allocating_cpus	{"ts": "2026-05-20T00:43:03.580494+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-20 00:43:04.266
590af351-6b33-4fc0-aebe-b6def7f3c1eb	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_allocating_storage	{"ts": "2026-05-20T00:43:03.580505+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-20 00:43:04.267
6a287e71-578f-4190-ba68-ebd42967c25a	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_allocating_storage	{"ts": "2026-05-20T00:43:03.580510+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0..."}	\N	2026-05-20 00:43:04.268
d200d4a9-f4a9-4c57-af45-4c4803441315	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_allocating_storage	{"ts": "2026-05-20T00:43:04.318073+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0"}	\N	2026-05-20 00:43:04.27
8d1975b5-8208-4044-817f-1bc847dac0b8	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_creating	{"ts": "2026-05-20T00:43:04.318128+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-20 00:43:04.271
174c2356-7f38-4420-a19d-8d0c0e5845b1	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_creating	{"ts": "2026-05-20T00:43:04.452378+00:00", "status": "completed", "message": "Container created: laas-dc4bfb83"}	\N	2026-05-20 00:43:04.272
bf774f8d-f539-44d2-8f8a-fc44eead9d22	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_starting	{"ts": "2026-05-20T00:43:04.452391+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-20 00:43:04.273
9f335acc-8546-43b3-8afb-17870489b44e	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_starting	{"ts": "2026-05-20T00:43:04.781960+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-20 00:43:04.274
8a49ed27-94ac-48e0-9472-49ef4cb4a267	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_waiting_desktop	{"ts": "2026-05-20T00:43:04.781976+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-20 00:43:04.276
1dd047f3-c4db-4d0b-ad60-5e68d2705f2d	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_waiting_desktop	{"ts": "2026-05-20T00:43:22.955626+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-20 00:43:22.662
b7a3269f-14ca-49f1-9bb1-cea5556e52da	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_waiting_desktop	{"ts": "2026-05-20T00:43:22.955640+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-20 00:43:22.667
7feb9cc7-051b-4c67-aed2-71c16481ddbd	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_health_checking	{"ts": "2026-05-20T00:43:22.955644+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-20 00:43:22.67
a55b51e4-71fc-4577-ac48-a00ab1598d9c	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_health_checking	{"ts": "2026-05-20T00:43:24.963715+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-20 00:43:24.733
1450b029-d192-47aa-9373-dc820d75eabf	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_ready	{"ts": "2026-05-20T00:43:24.963731+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-20 00:43:24.737
f50436cb-bf59-495b-8ab7-e5987ff24548	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	launch_ready	{"ts": "2026-05-20T00:43:24.963738+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-20 00:43:24.739
4942d09f-b555-4324-a509-c243c182d6c6	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-20 00:43:24.751
e956cdd4-5ed5-460c-8663-78de9e132197	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	session_terminated	{"terminatedBy": "8d40647d-da49-4490-ada6-3bfa2205366c", "totalCostCents": 36000, "durationSeconds": 2269, "terminationReason": "user_requested", "alreadyBilledCents": 36000, "remainingChargeCents": 0}	\N	2026-05-20 01:21:13.889
79f7ab8f-f19f-446e-80f5-558135bae244	a580b232-5224-4c8e-b8b5-a1cf39642e0c	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-n7jv", "interfaceMode": "gui"}	\N	2026-05-20 06:30:56.011
0f78e86f-2b82-492c-975e-a11d502566ee	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_initiated	{"launchId": "39628af4-cf7e-4b86-b60e-d89103fcb643", "containerName": "laas-a580b232"}	\N	2026-05-20 06:30:56.061
9f8b7df3-e81e-42b4-a9bf-3e5e91d3f4e9	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_scheduling	{"ts": "2026-05-20T06:30:57.773445+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-20 06:30:58.081
ac1d6827-44a0-46ba-b361-33850b4f67b9	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_scheduling	{"ts": "2026-05-20T06:30:57.873880+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-20 06:30:58.083
483a45a0-5493-4c94-92aa-5b6777e0f563	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_allocating_ports	{"ts": "2026-05-20T06:30:57.873998+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-20 06:30:58.084
f944eb88-4f1f-43ad-90b3-80ef7f947b91	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_allocating_ports	{"ts": "2026-05-20T06:30:57.897219+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-20 06:30:58.086
8a777db6-433d-4484-b1ab-053ce80c1521	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_allocating_cpus	{"ts": "2026-05-20T06:30:57.897230+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-20 06:30:58.088
df933062-d0e2-4345-b747-cc9913434431	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_allocating_cpus	{"ts": "2026-05-20T06:30:57.905740+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-20 06:30:58.089
3b0a06a3-e3af-45dd-8941-9da8d598eb9d	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_validating_mount	{"ts": "2026-05-20T06:30:57.905759+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_80b52988266cafa9ccd98e76..."}	\N	2026-05-20 06:30:58.091
5b614fa1-efc9-4fa3-aa4e-359bc1f9a1b5	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_nvme_preparing	{"ts": "2026-05-20T06:30:57.905853+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 10.10.100.99..."}	\N	2026-05-20 06:30:58.092
ded142af-677c-4f05-a9a3-5d753cd95c0b	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_nvme_discovering	{"ts": "2026-05-20T06:30:58.092051+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.99..."}	\N	2026-05-20 06:30:58.093
38c89f7e-1e68-4465-920f-3aeb962e4b35	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_nvme_discovering	{"ts": "2026-05-20T06:30:58.116527+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-20 06:30:58.094
4b1ca281-a0b8-4f2c-9e2a-da28ff624554	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_nvme_connecting	{"ts": "2026-05-20T06:30:58.116619+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_80b52988266cafa9ccd98e76..."}	\N	2026-05-20 06:30:58.096
feaba349-2f67-4d45-aecb-98ff17642d53	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_nvme_connecting	{"ts": "2026-05-20T06:30:58.165649+00:00", "status": "completed", "message": "NVMe-oF connected"}	\N	2026-05-20 06:30:58.097
8469e213-d8ce-42c9-a75c-62e4691adf51	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_nvme_finding_device	{"ts": "2026-05-20T06:30:58.165692+00:00", "status": "in_progress", "message": "Locating NVMe block device..."}	\N	2026-05-20 06:30:58.098
879acfc8-ed86-4294-afd6-9ab4b22e289f	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_nvme_finding_device	{"ts": "2026-05-20T06:30:58.676821+00:00", "status": "completed", "message": "Block device found: /dev/nvme2n1"}	\N	2026-05-20 06:30:58.099
65841ac9-f807-4709-90b6-5e869ffed1fd	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_nvme_mounting	{"ts": "2026-05-20T06:30:58.676930+00:00", "status": "in_progress", "message": "Mounting /dev/nvme2n1 to /mnt/nvme/u_80b52988266cafa9ccd98e76..."}	\N	2026-05-20 06:30:58.1
6db58ff1-1a7f-4fa2-853b-b853606c0d6f	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_nvme_mounting	{"ts": "2026-05-20T06:30:58.704759+00:00", "status": "completed", "message": "NVMe-oF volume mounted"}	\N	2026-05-20 06:30:58.101
d463fef3-6525-41cc-bb67-95cab3caebb7	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_nvme_verifying	{"ts": "2026-05-20T06:30:58.704819+00:00", "status": "in_progress", "message": "Verifying storage permissions..."}	\N	2026-05-20 06:30:58.102
cef5b716-24ac-4ca2-a059-b9752138aabf	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_nvme_verifying	{"ts": "2026-05-20T06:30:58.705312+00:00", "status": "completed", "message": "Permissions verified (UID 1000, read/write OK)"}	\N	2026-05-20 06:30:58.103
29cec459-d394-4e1f-b19e-99ce39d45055	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_validating_mount	{"ts": "2026-05-20T06:30:58.705370+00:00", "status": "completed", "message": "NVMe-oF storage ready at /mnt/nvme/u_80b52988266cafa9ccd98e76"}	\N	2026-05-20 06:30:58.104
f11bf320-9f98-4be5-be59-686634b24495	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_creating	{"ts": "2026-05-20T06:30:58.705423+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-20 06:30:58.105
0eb40c43-6cfe-4d2b-8e36-5ec8e38f936e	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_creating	{"ts": "2026-05-20T06:30:58.787264+00:00", "status": "completed", "message": "Container created: laas-a580b232"}	\N	2026-05-20 06:30:58.106
b3c33a08-1f5a-48e0-b5d4-247830b84137	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_starting	{"ts": "2026-05-20T06:30:58.787274+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-20 06:30:58.108
b1ec6f40-91fb-4ea3-bc3b-1a1dfe270e73	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_starting	{"ts": "2026-05-20T06:30:59.101322+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-20 06:30:58.109
70fd4f12-5c78-43bb-9be4-421eb9fb782d	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_waiting_desktop	{"ts": "2026-05-20T06:30:59.101336+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-20 06:30:58.111
c50f6d3b-b7e2-4688-aacc-6161aae0b3a0	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_waiting_desktop	{"ts": "2026-05-20T06:31:19.304364+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-20 06:31:18.386
72138d9a-292c-44c8-ba9c-3f26f359c3fb	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_waiting_desktop	{"ts": "2026-05-20T06:31:19.304376+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-20 06:31:18.388
4f1cd483-947d-4c25-894b-fe145d8be00b	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_health_checking	{"ts": "2026-05-20T06:31:19.304379+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-20 06:31:18.389
f28dfc43-93bb-4e3a-a6c6-d4a5b7fa8c09	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_health_checking	{"ts": "2026-05-20T06:31:21.312777+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-20 06:31:20.415
3fdcf47d-0829-4c74-ba8d-8ebd232afa73	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_ready	{"ts": "2026-05-20T06:31:21.312794+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-20 06:31:20.417
44390585-8794-4364-9782-c848998fe1c9	a580b232-5224-4c8e-b8b5-a1cf39642e0c	launch_ready	{"ts": "2026-05-20T06:31:21.312802+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-20 06:31:20.419
3c90188e-820c-49df-b700-276ca948c4aa	a580b232-5224-4c8e-b8b5-a1cf39642e0c	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-20 06:31:20.427
dfc7054a-1c2a-439d-b12c-3c2d6e732aec	c5925ef4-d5dd-4551-9165-50ce29fac9ff	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "instanceName": "gpu-instance-pwwu", "interfaceMode": "gui"}	\N	2026-05-20 06:31:53.037
f992f3ac-0e60-4faa-a7e2-3879a03a30a1	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_initiated	{"launchId": "a68c2449-07ce-4c24-9d81-ee9c8b06fd66", "containerName": "laas-c5925ef4"}	\N	2026-05-20 06:31:53.087
5709d897-d155-4398-8ab7-50e18524c4cd	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_scheduling	{"ts": "2026-05-20T06:31:54.798213+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-20 06:31:55.113
e8af5f4f-2afb-48db-b169-71b55f4f5ad4	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_scheduling	{"ts": "2026-05-20T06:31:54.898396+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-20 06:31:55.115
b8214fc5-e814-4c43-9a45-bab4304c4e21	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_allocating_ports	{"ts": "2026-05-20T06:31:54.898510+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-20 06:31:55.116
81a6a33a-1b18-467a-924f-ec925bc2a3ce	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_allocating_ports	{"ts": "2026-05-20T06:31:54.977053+00:00", "status": "completed", "message": "Allocated ports: nginx=8102, selkies=9102, metrics=19102, display=:21"}	\N	2026-05-20 06:31:55.118
50d2fbc9-3cdf-4b95-9bb1-1c0cec7b7669	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_allocating_cpus	{"ts": "2026-05-20T06:31:54.977064+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-20 06:31:55.119
df55d7c9-1d5d-46cd-ad41-134d9ec1a0a0	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_allocating_cpus	{"ts": "2026-05-20T06:31:55.013720+00:00", "status": "completed", "message": "Allocated CPU cores: 14-15"}	\N	2026-05-20 06:31:55.121
6523c0ba-5122-4239-b64d-f9e9ba4375ec	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_allocating_storage	{"ts": "2026-05-20T06:31:55.013735+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-20 06:31:55.122
e5ca70be-86e4-4edc-9e23-3e55d014fb64	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_allocating_storage	{"ts": "2026-05-20T06:31:55.013741+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_c5925ef4-d5dd-4551-9165-50ce29fac9ff..."}	\N	2026-05-20 06:31:55.124
53eee1a8-1b7e-4ecd-992e-7493aca8a1cd	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_allocating_storage	{"ts": "2026-05-20T06:31:55.755974+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_c5925ef4-d5dd-4551-9165-50ce29fac9ff"}	\N	2026-05-20 06:31:55.125
277f3d07-4b2a-42d2-8046-54c146d6f18b	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_creating	{"ts": "2026-05-20T06:31:55.756024+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-20 06:31:55.127
876606a7-27e4-4668-a8a1-01d51b8b2232	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_creating	{"ts": "2026-05-20T06:31:55.828577+00:00", "status": "completed", "message": "Container created: laas-c5925ef4"}	\N	2026-05-20 06:31:55.128
6cad6033-ed55-45c3-9fa6-119d81c81842	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_starting	{"ts": "2026-05-20T06:31:55.828591+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-20 06:31:55.13
4743fc92-f967-4cce-81d5-ba9b96808d09	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_starting	{"ts": "2026-05-20T06:31:56.124861+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-20 06:31:55.131
352d2241-a44f-4ba8-b6d0-f1ff6f061af7	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_waiting_desktop	{"ts": "2026-05-20T06:31:56.124875+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8102..."}	\N	2026-05-20 06:31:55.132
8c18db60-0e0b-4cdb-9fb8-a76c5445ffd5	a580b232-5224-4c8e-b8b5-a1cf39642e0c	session_terminated	{"terminatedBy": "8d40647d-da49-4490-ada6-3bfa2205366c", "totalCostCents": 36000, "durationSeconds": 44, "terminationReason": "user_requested", "alreadyBilledCents": 36000, "remainingChargeCents": 0}	\N	2026-05-20 06:32:04.565
35f99b4e-310e-4501-a119-2d5c68ccf06d	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_waiting_desktop	{"ts": "2026-05-20T06:32:14.308780+00:00", "status": "completed", "message": "Desktop responding on port 8102 (HTTP 401)"}	\N	2026-05-20 06:32:13.481
188f6ed0-7d71-4c44-88ba-2dd67e41b5c2	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_waiting_desktop	{"ts": "2026-05-20T06:32:14.308791+00:00", "status": "completed", "message": "Desktop responding on port 8102"}	\N	2026-05-20 06:32:13.484
23e382c7-7174-43de-ac01-8050e1954a5c	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_health_checking	{"ts": "2026-05-20T06:32:14.308794+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-20 06:32:13.487
1ce5d11c-b34e-45ab-9199-4a773c1c7a59	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_health_checking	{"ts": "2026-05-20T06:32:16.319173+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-20 06:32:15.511
144bae16-d850-46ab-9e74-d0ac746f1e5b	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_ready	{"ts": "2026-05-20T06:32:16.319185+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-20 06:32:15.513
06fded63-ddb7-41a4-a7d9-350ec3bc4c74	c5925ef4-d5dd-4551-9165-50ce29fac9ff	launch_ready	{"ts": "2026-05-20T06:32:16.319191+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-20 06:32:15.515
ca4d3974-c2e9-47bc-926b-d26b17e72218	c5925ef4-d5dd-4551-9165-50ce29fac9ff	session_ready	{"nginxPort": 8102, "sessionUrl": "http://100.94.157.114:8102/", "selkiesPort": 9102, "displayNumber": 21}	\N	2026-05-20 06:32:15.522
b67b951c-ceaa-49f4-af6f-a0d1eefc0690	c5925ef4-d5dd-4551-9165-50ce29fac9ff	session_terminated	{"terminatedBy": "8d40647d-da49-4490-ada6-3bfa2205366c", "totalCostCents": 12000, "durationSeconds": 76, "terminationReason": "user_requested", "alreadyBilledCents": 12000, "remainingChargeCents": 0}	\N	2026-05-20 06:33:32.254
7635ba26-493e-4c98-bc64-b4c06f94b9d6	f644f81d-3b03-46c3-bfdb-d098923af02c	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "stateful", "instanceName": "gpu-instance-840a", "interfaceMode": "gui"}	\N	2026-05-20 06:36:04.914
d3d30bb8-93ac-4c6a-825e-acfeb8179381	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_initiated	{"launchId": "7c2ac2a4-c353-4dad-b135-9168e77f9ba7", "containerName": "laas-f644f81d"}	\N	2026-05-20 06:36:04.979
4e4d6b14-1c3a-4939-a543-20683915fe22	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_scheduling	{"ts": "2026-05-20T06:36:06.682876+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-20 06:36:06.996
37570d23-c900-44cf-9876-af44a6ef4107	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_scheduling	{"ts": "2026-05-20T06:36:06.783264+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-20 06:36:06.998
2e98144d-f086-46a1-b696-e07a810bdcad	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_allocating_ports	{"ts": "2026-05-20T06:36:06.783389+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-20 06:36:07.001
7b037534-2df8-4156-bfc1-0bd6edbbb454	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_allocating_ports	{"ts": "2026-05-20T06:36:06.807428+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-20 06:36:07.003
6e10acd9-2c21-4686-9bab-20645aab84e4	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_allocating_cpus	{"ts": "2026-05-20T06:36:06.807438+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-20 06:36:07.004
41d2848a-5ba0-412d-b39f-efdaeda17cb3	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_allocating_cpus	{"ts": "2026-05-20T06:36:06.816389+00:00", "status": "completed", "message": "Allocated CPU cores: 2-3"}	\N	2026-05-20 06:36:07.005
54801c8a-6600-4f74-b57c-6bbf19fa862e	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_validating_mount	{"ts": "2026-05-20T06:36:06.816411+00:00", "status": "in_progress", "message": "Verifying local ZFS zvol for u_113129005bb5ebde59837825..."}	\N	2026-05-20 06:36:07.007
9c742b4c-de05-4427-ac35-100bfa06bdb2	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_validating_mount	{"ts": "2026-05-20T06:36:06.816579+00:00", "status": "completed", "message": "Local ZFS zvol verified: /datapool/users/u_113129005bb5ebde59837825"}	\N	2026-05-20 06:36:07.009
437135d0-111d-4582-a9f4-06a4568bd84d	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_creating	{"ts": "2026-05-20T06:36:06.816633+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-20 06:36:07.01
0c1ff93c-4db8-48b5-8745-cbaea3db97e9	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_creating	{"ts": "2026-05-20T06:36:06.889021+00:00", "status": "completed", "message": "Container created: laas-f644f81d"}	\N	2026-05-20 06:36:07.011
ba451b38-cc29-4b58-9145-ba3fc392590d	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_starting	{"ts": "2026-05-20T06:36:06.889031+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-20 06:36:07.012
2eefbe30-f5ab-42ba-856b-e3124c2dedb3	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_starting	{"ts": "2026-05-20T06:36:07.191873+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-20 06:36:07.014
ef502baa-5a24-4699-86ae-42cc86fb8296	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_waiting_desktop	{"ts": "2026-05-20T06:36:07.191888+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-20 06:36:07.015
0c78d2df-e327-4693-b61e-9a55a93dddcb	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_waiting_desktop	{"ts": "2026-05-20T06:36:19.310206+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-20 06:36:19.167
f0a3f6bc-f31b-4495-98c8-1c5c10f9730a	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_waiting_desktop	{"ts": "2026-05-20T06:36:19.310220+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-20 06:36:19.169
03422737-80ab-4877-8935-0058142a7224	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_health_checking	{"ts": "2026-05-20T06:36:19.310224+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-20 06:36:19.171
951ddb25-f943-4f5f-a7e9-3a632eda0f90	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_health_checking	{"ts": "2026-05-20T06:36:21.319111+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-20 06:36:21.201
d9ab8282-eb16-4179-8033-e941639d0e04	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_ready	{"ts": "2026-05-20T06:36:21.319127+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-20 06:36:21.202
930d8e4d-4abf-4e6b-ab8b-dac584bbd68c	f644f81d-3b03-46c3-bfdb-d098923af02c	launch_ready	{"ts": "2026-05-20T06:36:21.319136+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-20 06:36:21.203
e1afeebc-78e9-4f95-838f-74d45d87cf82	f644f81d-3b03-46c3-bfdb-d098923af02c	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-20 06:36:21.209
fe4950f1-ab33-4ee1-9248-64a0ee1c31e1	46541468-ee50-4fab-bd02-4250162c40e6	session_terminated	{"terminatedBy": "8d40647d-da49-4490-ada6-3bfa2205366c", "totalCostCents": 456000, "durationSeconds": 134249, "terminationReason": "user_requested", "alreadyBilledCents": 276000, "remainingChargeCents": 180000}	\N	2026-05-20 07:21:56.441
f8732990-5abd-490d-9f55-481eaa508fae	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	session_created	{"configName": "Blaze", "configSlug": "blaze", "storageType": "ephemeral", "instanceName": "gpu-instance-dh0j", "interfaceMode": "gui"}	\N	2026-05-20 07:22:16.577
b6249dea-d014-4452-938f-567330932f29	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_initiated	{"launchId": "1da29048-df1f-460f-9e75-8d4156df7aa3", "containerName": "laas-2f072a36"}	\N	2026-05-20 07:22:16.632
26bd6a38-c8b0-4a82-9aa2-b5e0999c392e	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_scheduling	{"ts": "2026-05-20T07:22:18.256365+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-20 07:22:18.654
ced0cae3-03e1-4b21-b501-3db7b02d261f	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_scheduling	{"ts": "2026-05-20T07:22:18.356819+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-20 07:22:18.657
5795171a-b8da-499a-87d3-18864d9059d6	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_allocating_ports	{"ts": "2026-05-20T07:22:18.356940+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-20 07:22:18.658
9e44d803-6ddc-49c9-ae97-5eafb22391ad	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_allocating_ports	{"ts": "2026-05-20T07:22:18.379553+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-20 07:22:18.66
20ec49d1-2b54-40ad-a4b9-80c4a31ae01b	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_allocating_cpus	{"ts": "2026-05-20T07:22:18.379559+00:00", "status": "in_progress", "message": "Finding 4 contiguous CPU cores..."}	\N	2026-05-20 07:22:18.661
26e94eaf-23de-481d-abeb-0c961f90b04d	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_allocating_cpus	{"ts": "2026-05-20T07:22:18.388188+00:00", "status": "completed", "message": "Allocated CPU cores: 2-5"}	\N	2026-05-20 07:22:18.664
77832951-12e6-4440-a7b8-4cfb569cb7c5	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_allocating_storage	{"ts": "2026-05-20T07:22:18.388202+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-20 07:22:18.666
afb0ad92-4dd6-4b7e-921f-57028e7fd1b0	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_allocating_storage	{"ts": "2026-05-20T07:22:18.388207+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_2f072a36-9650-4bbc-bb3d-eb54eecf2a6a..."}	\N	2026-05-20 07:22:18.667
7eecf015-8536-4a4b-ad3e-04c44d0e0f67	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_allocating_storage	{"ts": "2026-05-20T07:22:19.069737+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_2f072a36-9650-4bbc-bb3d-eb54eecf2a6a"}	\N	2026-05-20 07:22:18.67
60475d23-1400-4df0-8845-23573fe8dd10	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_creating	{"ts": "2026-05-20T07:22:19.069791+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-20 07:22:18.672
8a7f8385-fc7c-44e6-925e-044956bb98a3	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_creating	{"ts": "2026-05-20T07:22:19.145120+00:00", "status": "completed", "message": "Container created: laas-2f072a36"}	\N	2026-05-20 07:22:18.674
d4f2a6a2-d011-4f16-86ff-8770e4ae46c1	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_starting	{"ts": "2026-05-20T07:22:19.145133+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-20 07:22:18.675
4a388d98-e847-4c6f-ab40-38268954b2e5	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_starting	{"ts": "2026-05-20T07:22:19.461462+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-20 07:22:18.677
aa9536a2-4a93-4651-8dee-8ab4db949f9e	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_waiting_desktop	{"ts": "2026-05-20T07:22:19.461475+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-20 07:22:18.678
c85de1af-90c6-4786-901b-8441168e0b1b	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_waiting_desktop	{"ts": "2026-05-20T07:22:37.641782+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-20 07:22:36.874
28c9fe4a-418b-4621-a23f-8534c201cea4	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_waiting_desktop	{"ts": "2026-05-20T07:22:37.641796+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-20 07:22:36.878
93d6e98a-ef62-424a-b939-e5d55be6019d	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_health_checking	{"ts": "2026-05-20T07:22:37.641800+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-20 07:22:36.879
32e63280-65c1-46f3-a593-4231a712f1ee	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_health_checking	{"ts": "2026-05-20T07:22:39.647967+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-20 07:22:38.935
c52e2a79-ebbe-4228-8d1e-97a24b6d721b	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	launch_ready	{"ts": "2026-05-20T07:22:39.647987+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-20 07:22:38.937
a587af08-9e2e-4caa-b16f-6947bd8d7012	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.88.57.107:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-20 07:22:38.951
e6be3121-1b61-453b-8108-bee0d74549c9	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-m41z", "interfaceMode": "gui"}	\N	2026-05-20 08:11:23.23
2bff4460-e28e-4fda-a151-47ee76237ef5	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_initiated	{"launchId": "89e89d2b-bc81-4ee9-a0da-680ba0a65025", "containerName": "laas-f5b1efc7"}	\N	2026-05-20 08:11:23.378
be7b4b58-f679-4c6a-8234-9fe8de2c28f6	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_scheduling	{"ts": "2026-05-20T08:11:24.850745+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-20 08:11:25.533
e457b20d-7d46-44d8-acaa-be39d5e6300c	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_scheduling	{"ts": "2026-05-20T08:11:24.951158+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-20 08:11:25.538
3607d969-466b-4724-a8c0-4ad37a1a0618	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_allocating_ports	{"ts": "2026-05-20T08:11:24.951279+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-20 08:11:25.542
aeda904f-bf70-4116-ba30-a8e11f258c40	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_allocating_ports	{"ts": "2026-05-20T08:11:25.025034+00:00", "status": "completed", "message": "Allocated ports: nginx=8102, selkies=9102, metrics=19102, display=:21"}	\N	2026-05-20 08:11:25.545
7f973c80-76b8-4345-87dd-7140f2582b2e	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_allocating_cpus	{"ts": "2026-05-20T08:11:25.025045+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-20 08:11:25.548
5add6378-6661-4ed5-8cdf-399e4c37c030	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_allocating_cpus	{"ts": "2026-05-20T08:11:25.058051+00:00", "status": "completed", "message": "Allocated CPU cores: 4-15"}	\N	2026-05-20 08:11:25.552
41667733-8159-4727-b561-cc076f313fa1	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_validating_mount	{"ts": "2026-05-20T08:11:25.058076+00:00", "status": "in_progress", "message": "Verifying local ZFS zvol for u_f15f2564a9c60fe5501e4589..."}	\N	2026-05-20 08:11:25.558
77159ebd-29df-4ed2-b05d-bd744f81c0aa	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_validating_mount	{"ts": "2026-05-20T08:11:25.058205+00:00", "status": "completed", "message": "Local ZFS zvol verified: /datapool/users/u_f15f2564a9c60fe5501e4589"}	\N	2026-05-20 08:11:25.561
da282d2e-ed66-4519-aba8-2fb217798973	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_creating	{"ts": "2026-05-20T08:11:25.058250+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-20 08:11:25.564
c490c36f-574f-4689-bc56-580bdc4c34e3	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_creating	{"ts": "2026-05-20T08:11:25.132377+00:00", "status": "completed", "message": "Container created: laas-f5b1efc7"}	\N	2026-05-20 08:11:25.567
99fe73cc-d2f6-4a99-8ff6-7af9046fcbd6	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_starting	{"ts": "2026-05-20T08:11:25.132383+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-20 08:11:25.572
f8875e65-068f-4860-8096-6d67c35f9bfd	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_starting	{"ts": "2026-05-20T08:11:25.413042+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-20 08:11:25.575
8c7331d3-5f6a-4dd1-bded-d88e3bb9c7fa	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_waiting_desktop	{"ts": "2026-05-20T08:11:25.413059+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8102..."}	\N	2026-05-20 08:11:25.582
679e66ec-9f20-4675-a73d-44a98ba0f9aa	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_waiting_desktop	{"ts": "2026-05-20T08:11:43.603956+00:00", "status": "completed", "message": "Desktop responding on port 8102 (HTTP 401)"}	\N	2026-05-20 08:11:44.073
c1ca279b-3bdf-4887-bedc-1038b5414059	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_waiting_desktop	{"ts": "2026-05-20T08:11:43.603971+00:00", "status": "completed", "message": "Desktop responding on port 8102"}	\N	2026-05-20 08:11:44.075
b98eea64-87c5-4d8f-acbc-4f5c64f4bc0e	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_health_checking	{"ts": "2026-05-20T08:11:43.603975+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-20 08:11:44.077
ea5a7262-afb7-4220-8b03-51acf2eede38	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_health_checking	{"ts": "2026-05-20T08:11:45.612189+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-20 08:11:44.079
a54ccdce-7b9b-4bc0-b278-10d96ca65a72	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_ready	{"ts": "2026-05-20T08:11:45.612204+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-20 08:11:44.08
80e86af2-8ad9-49fb-a613-0204da162e28	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	launch_ready	{"ts": "2026-05-20T08:11:45.612213+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-20 08:11:44.082
b48d2f47-ef75-4780-9a49-f8e8c84686e0	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	session_ready	{"nginxPort": 8102, "sessionUrl": "http://100.94.157.114:8102/", "selkiesPort": 9102, "displayNumber": 21}	\N	2026-05-20 08:11:44.095
5b22f349-38c4-488d-aae3-ec23f8a5f2bc	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	session_terminated	{"terminatedBy": "f3a5cce9-059c-4828-ac18-61164c28e868", "totalCostCents": 792000, "durationSeconds": 77034, "terminationReason": "user_requested", "alreadyBilledCents": 72000, "remainingChargeCents": 720000}	\N	2026-05-21 05:35:38.585
ace0edaf-b5ad-4bf2-90ff-db7f7e334815	f644f81d-3b03-46c3-bfdb-d098923af02c	session_terminated	{"terminatedBy": "75c1fbf0-8ae8-4aed-b14f-429b8c830ced", "totalCostCents": 348000, "durationSeconds": 100915, "terminationReason": "user_requested", "alreadyBilledCents": 168000, "remainingChargeCents": 180000}	\N	2026-05-21 10:38:17.23
eaca33cb-3937-40c7-a768-5848bd3002fc	378ec15c-cec4-4864-98da-49821b126fb4	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "stateful", "instanceName": "gpu-instance-3jnd", "interfaceMode": "gui"}	\N	2026-05-21 10:42:11.953
83f3f45b-4fca-4c9b-ba66-a27a4bb9c6fd	378ec15c-cec4-4864-98da-49821b126fb4	launch_initiated	{"launchId": "be756b1d-20a7-44b0-b160-2f9f629dcb6a", "containerName": "laas-378ec15c"}	\N	2026-05-21 10:42:12.028
12a24fa8-cea1-44b0-9cc4-92c193e51409	378ec15c-cec4-4864-98da-49821b126fb4	launch_scheduling	{"ts": "2026-05-21T10:42:13.597254+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-21 10:42:14.126
1bf27bc4-5a1e-4033-8af8-920f0f6fbbdb	378ec15c-cec4-4864-98da-49821b126fb4	launch_scheduling	{"ts": "2026-05-21T10:42:13.697438+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-21 10:42:14.128
f803ec74-d31b-4bb8-94b4-7e7a91212b1d	378ec15c-cec4-4864-98da-49821b126fb4	launch_allocating_ports	{"ts": "2026-05-21T10:42:13.697568+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-21 10:42:14.13
8a4cdbef-0fb1-4bb8-a0a6-2e603cb9bead	378ec15c-cec4-4864-98da-49821b126fb4	launch_allocating_ports	{"ts": "2026-05-21T10:42:13.719349+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-21 10:42:14.131
ffb3a5c9-36ab-4b77-9950-b5fac218f0ee	378ec15c-cec4-4864-98da-49821b126fb4	launch_allocating_cpus	{"ts": "2026-05-21T10:42:13.719354+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-21 10:42:14.133
78bb47c6-bfa1-45e4-90a2-4a66ac498568	378ec15c-cec4-4864-98da-49821b126fb4	launch_allocating_cpus	{"ts": "2026-05-21T10:42:13.728804+00:00", "status": "completed", "message": "Allocated CPU cores: 2-3"}	\N	2026-05-21 10:42:14.134
74cec969-fae2-4c5a-bb45-9d615cadb581	378ec15c-cec4-4864-98da-49821b126fb4	launch_validating_mount	{"ts": "2026-05-21T10:42:13.728817+00:00", "status": "in_progress", "message": "Verifying local ZFS zvol for u_113129005bb5ebde59837825..."}	\N	2026-05-21 10:42:14.135
35e8c932-81e3-4712-9387-4042b902dc4d	378ec15c-cec4-4864-98da-49821b126fb4	launch_validating_mount	{"ts": "2026-05-21T10:42:13.728955+00:00", "status": "completed", "message": "Local ZFS zvol verified: /datapool/users/u_113129005bb5ebde59837825"}	\N	2026-05-21 10:42:14.136
9e326bdf-d7db-41b8-9429-fa60db0c3712	378ec15c-cec4-4864-98da-49821b126fb4	launch_creating	{"ts": "2026-05-21T10:42:13.728998+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-21 10:42:14.138
fc302b95-c86a-4c72-bcbb-acd566d9ae0f	378ec15c-cec4-4864-98da-49821b126fb4	launch_creating	{"ts": "2026-05-21T10:42:13.797658+00:00", "status": "completed", "message": "Container created: laas-378ec15c"}	\N	2026-05-21 10:42:14.139
12b2cf3e-6a58-465d-9a60-1f80f4743afe	378ec15c-cec4-4864-98da-49821b126fb4	launch_starting	{"ts": "2026-05-21T10:42:13.797667+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-21 10:42:14.141
77c41a76-7d7e-4195-8046-083a90e03e12	378ec15c-cec4-4864-98da-49821b126fb4	launch_starting	{"ts": "2026-05-21T10:42:14.128683+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-21 10:42:14.143
89be8559-e303-48b2-99f7-c7cecc8c3779	378ec15c-cec4-4864-98da-49821b126fb4	launch_waiting_desktop	{"ts": "2026-05-21T10:42:14.128699+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-21 10:42:14.144
fbf50c89-37f9-4328-a1d6-9b1e2e403e75	378ec15c-cec4-4864-98da-49821b126fb4	launch_waiting_desktop	{"ts": "2026-05-21T10:42:52.514261+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-21 10:42:51.206
2779988d-b77a-44cb-9a8a-f2074f9578bb	378ec15c-cec4-4864-98da-49821b126fb4	launch_waiting_desktop	{"ts": "2026-05-21T10:42:52.514275+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-21 10:42:51.209
ce793d93-d8d8-4d3b-9251-17cee9749dfc	378ec15c-cec4-4864-98da-49821b126fb4	launch_health_checking	{"ts": "2026-05-21T10:42:52.514278+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-21 10:42:51.212
ff3c97ac-6917-47d4-ad86-477aa0098dbd	378ec15c-cec4-4864-98da-49821b126fb4	launch_health_checking	{"ts": "2026-05-21T10:42:54.523062+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-21 10:42:53.273
d73a3380-4569-411e-9883-6314d881af00	378ec15c-cec4-4864-98da-49821b126fb4	launch_ready	{"ts": "2026-05-21T10:42:54.523078+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-21 10:42:53.277
9d8a53f8-f4b5-4f4b-b895-dab90cc4ed03	378ec15c-cec4-4864-98da-49821b126fb4	launch_ready	{"ts": "2026-05-21T10:42:54.523087+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-21 10:42:53.279
7fa7b836-6bf1-4265-8e11-e0a915bc0ea0	378ec15c-cec4-4864-98da-49821b126fb4	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-21 10:42:53.29
5fdf0528-048e-4ffc-926a-e1ffe8caef3b	8095cdef-8105-40bc-84a1-4510c81383d0	session_created	{"configName": "Inferno", "configSlug": "inferno", "storageType": "ephemeral", "instanceName": "gpu-instance-5bsk", "interfaceMode": "gui"}	\N	2026-05-21 10:44:13.475
e5a10f65-97c2-4e65-8833-be5409e04bc5	8095cdef-8105-40bc-84a1-4510c81383d0	launch_initiated	{"launchId": "3fe00474-4728-4d54-95fa-94fa491c0060", "containerName": "laas-8095cdef"}	\N	2026-05-21 10:44:13.57
a170750d-7394-4ad8-96b2-f260f7ea43a1	8095cdef-8105-40bc-84a1-4510c81383d0	launch_scheduling	{"ts": "2026-05-21T10:44:15.133015+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-21 10:44:15.615
441aae68-8ef3-4e5c-9247-dad638491226	8095cdef-8105-40bc-84a1-4510c81383d0	launch_scheduling	{"ts": "2026-05-21T10:44:15.233196+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-21 10:44:15.618
d2f08594-b2af-466e-b2c9-0e32e632ce39	8095cdef-8105-40bc-84a1-4510c81383d0	launch_allocating_ports	{"ts": "2026-05-21T10:44:15.233319+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-21 10:44:15.62
1350351b-dfac-4744-89c0-d17f028426a4	8095cdef-8105-40bc-84a1-4510c81383d0	launch_allocating_ports	{"ts": "2026-05-21T10:44:15.308566+00:00", "status": "completed", "message": "Allocated ports: nginx=8102, selkies=9102, metrics=19102, display=:21"}	\N	2026-05-21 10:44:15.622
209fae08-1757-43ae-83e4-7c3bb29679f9	8095cdef-8105-40bc-84a1-4510c81383d0	launch_allocating_cpus	{"ts": "2026-05-21T10:44:15.308571+00:00", "status": "in_progress", "message": "Finding 8 contiguous CPU cores..."}	\N	2026-05-21 10:44:15.625
cbe21d3f-a7eb-41ea-b7c7-65e4926f49d9	8095cdef-8105-40bc-84a1-4510c81383d0	launch_allocating_cpus	{"ts": "2026-05-21T10:44:15.341958+00:00", "status": "completed", "message": "Allocated CPU cores: 4-11"}	\N	2026-05-21 10:44:15.626
197d0a1d-78cf-4718-9ee2-be47556efa4a	8095cdef-8105-40bc-84a1-4510c81383d0	launch_allocating_storage	{"ts": "2026-05-21T10:44:15.341972+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-21 10:44:15.629
6fbe2633-e065-4c57-8d06-f4a71eaee99d	8095cdef-8105-40bc-84a1-4510c81383d0	launch_allocating_storage	{"ts": "2026-05-21T10:44:15.341978+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_8095cdef-8105-40bc-84a1-4510c81383d0..."}	\N	2026-05-21 10:44:15.631
06ad2685-5cc7-42ad-98db-f143343eff25	8095cdef-8105-40bc-84a1-4510c81383d0	launch_allocating_storage	{"ts": "2026-05-21T10:44:16.037912+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_8095cdef-8105-40bc-84a1-4510c81383d0"}	\N	2026-05-21 10:44:15.632
eea8cf25-10e1-456d-a63a-ea803ccb4fc3	8095cdef-8105-40bc-84a1-4510c81383d0	launch_creating	{"ts": "2026-05-21T10:44:16.037967+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-21 10:44:15.634
487ff0aa-e4e9-49de-8c40-742ae2329317	8095cdef-8105-40bc-84a1-4510c81383d0	launch_creating	{"ts": "2026-05-21T10:44:16.107383+00:00", "status": "completed", "message": "Container created: laas-8095cdef"}	\N	2026-05-21 10:44:15.635
6eb57fd4-6ec5-4728-a743-62c70d2fa36c	8095cdef-8105-40bc-84a1-4510c81383d0	launch_starting	{"ts": "2026-05-21T10:44:16.107391+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-21 10:44:15.637
b0c200ac-022c-409b-92c0-2f64399b036c	8095cdef-8105-40bc-84a1-4510c81383d0	launch_starting	{"ts": "2026-05-21T10:44:16.396169+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-21 10:44:15.639
a994e269-0f35-4090-b042-88f288da4995	8095cdef-8105-40bc-84a1-4510c81383d0	launch_waiting_desktop	{"ts": "2026-05-21T10:44:16.396184+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8102..."}	\N	2026-05-21 10:44:15.64
95012c38-d2b7-452d-a4c8-781abc5af9a2	8095cdef-8105-40bc-84a1-4510c81383d0	launch_waiting_desktop	{"ts": "2026-05-21T10:44:42.647081+00:00", "status": "completed", "message": "Desktop responding on port 8102 (HTTP 401)"}	\N	2026-05-21 10:44:42.159
2b90467d-6b9d-45ce-ab76-66f0b586f008	8095cdef-8105-40bc-84a1-4510c81383d0	launch_waiting_desktop	{"ts": "2026-05-21T10:44:42.647096+00:00", "status": "completed", "message": "Desktop responding on port 8102"}	\N	2026-05-21 10:44:42.161
b9b93141-e129-455e-9584-107a540fc924	8095cdef-8105-40bc-84a1-4510c81383d0	launch_health_checking	{"ts": "2026-05-21T10:44:42.647100+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-21 10:44:42.163
6ffb5980-c0fc-4410-ad93-22f88f154405	8095cdef-8105-40bc-84a1-4510c81383d0	launch_health_checking	{"ts": "2026-05-21T10:44:44.654544+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-21 10:44:44.192
a6405a9f-7762-45fb-9b7c-16f8de33d047	8095cdef-8105-40bc-84a1-4510c81383d0	launch_ready	{"ts": "2026-05-21T10:44:44.654559+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-21 10:44:44.195
1ad28516-0e46-496d-a47f-0c32a8412aa5	8095cdef-8105-40bc-84a1-4510c81383d0	launch_ready	{"ts": "2026-05-21T10:44:44.654568+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-21 10:44:44.197
6e10bb02-85e9-4edf-8952-2d5d5809e15d	8095cdef-8105-40bc-84a1-4510c81383d0	session_ready	{"nginxPort": 8102, "sessionUrl": "http://100.94.157.114:8102/", "selkiesPort": 9102, "displayNumber": 21}	\N	2026-05-21 10:44:44.205
1a4889c2-3a2c-4872-ab4c-7dedd39c9c99	378ec15c-cec4-4864-98da-49821b126fb4	session_terminated	{"terminatedBy": "75c1fbf0-8ae8-4aed-b14f-429b8c830ced", "totalCostCents": 12000, "durationSeconds": 126, "terminationReason": "credit_exhausted", "alreadyBilledCents": 12000, "remainingChargeCents": 0}	\N	2026-05-21 10:45:00.17
7d915c75-d087-40b7-aabf-1f86ec96c2ce	8095cdef-8105-40bc-84a1-4510c81383d0	session_terminated	{"terminatedBy": "75c1fbf0-8ae8-4aed-b14f-429b8c830ced", "totalCostCents": 30000, "durationSeconds": 23, "terminationReason": "credit_exhausted", "alreadyBilledCents": 30000, "remainingChargeCents": 0}	\N	2026-05-21 10:45:07.685
613fa4d6-6dcc-4276-871e-38309e4998d4	d610682f-7028-42ca-93e2-0fbc64499b17	session_created	{"configName": "Inferno", "configSlug": "inferno", "storageType": "ephemeral", "instanceName": "gpu-instance-kxeb", "interfaceMode": "gui"}	\N	2026-05-21 10:46:21.626
71a33c3c-5a04-4f62-98fc-51cbea2ffe9c	d610682f-7028-42ca-93e2-0fbc64499b17	launch_initiated	{"launchId": "4bc85401-3d9b-49bc-9ce8-955b4b7c055b", "containerName": "laas-d610682f"}	\N	2026-05-21 10:46:21.676
3e94836f-f1d3-4d13-8b09-1c6306354525	d610682f-7028-42ca-93e2-0fbc64499b17	launch_scheduling	{"ts": "2026-05-21T10:46:23.254947+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-21 10:46:23.704
9ae5cb53-3d76-41d6-a4ce-68e67633021f	d610682f-7028-42ca-93e2-0fbc64499b17	launch_scheduling	{"ts": "2026-05-21T10:46:23.355139+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-21 10:46:23.706
fee0aa07-dab0-4ba9-a461-0d0c8929be0d	d610682f-7028-42ca-93e2-0fbc64499b17	launch_allocating_ports	{"ts": "2026-05-21T10:46:23.355252+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-21 10:46:23.708
ba20f584-1481-4d6c-a5f7-d17525461462	d610682f-7028-42ca-93e2-0fbc64499b17	launch_allocating_ports	{"ts": "2026-05-21T10:46:23.379515+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-21 10:46:23.71
9374fa4b-7600-4dea-aa72-748f2c32b9bc	d610682f-7028-42ca-93e2-0fbc64499b17	launch_allocating_cpus	{"ts": "2026-05-21T10:46:23.379527+00:00", "status": "in_progress", "message": "Finding 8 contiguous CPU cores..."}	\N	2026-05-21 10:46:23.711
fa6ea904-1ede-4de7-b7c4-35c5603cd7cf	d610682f-7028-42ca-93e2-0fbc64499b17	launch_allocating_cpus	{"ts": "2026-05-21T10:46:23.388374+00:00", "status": "completed", "message": "Allocated CPU cores: 2-9"}	\N	2026-05-21 10:46:23.712
b1439285-51d8-4b0c-a4e5-111b9a9625d7	d610682f-7028-42ca-93e2-0fbc64499b17	launch_allocating_storage	{"ts": "2026-05-21T10:46:23.388393+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-21 10:46:23.714
8845661a-82c0-4382-aa45-9600344a7661	d610682f-7028-42ca-93e2-0fbc64499b17	launch_allocating_storage	{"ts": "2026-05-21T10:46:23.388402+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_d610682f-7028-42ca-93e2-0fbc64499b17..."}	\N	2026-05-21 10:46:23.716
4bc8a0a7-dbaf-49c6-a7a2-b468e7d2ff51	d610682f-7028-42ca-93e2-0fbc64499b17	launch_allocating_storage	{"ts": "2026-05-21T10:46:24.091545+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_d610682f-7028-42ca-93e2-0fbc64499b17"}	\N	2026-05-21 10:46:23.718
f4a4e2e5-f429-4e69-8910-5e97190f8871	d610682f-7028-42ca-93e2-0fbc64499b17	launch_creating	{"ts": "2026-05-21T10:46:24.091596+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-21 10:46:23.72
4c0e8080-1bcb-41a9-b00d-5af3cc8d1aad	d610682f-7028-42ca-93e2-0fbc64499b17	launch_creating	{"ts": "2026-05-21T10:46:24.163934+00:00", "status": "completed", "message": "Container created: laas-d610682f"}	\N	2026-05-21 10:46:23.722
9e3342cb-a5eb-4ebb-935f-07855ec25cb8	d610682f-7028-42ca-93e2-0fbc64499b17	launch_starting	{"ts": "2026-05-21T10:46:24.163944+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-21 10:46:23.723
6b940055-6e71-4010-9248-61ddece9d6e8	d610682f-7028-42ca-93e2-0fbc64499b17	launch_starting	{"ts": "2026-05-21T10:46:24.480826+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-21 10:46:23.725
2becdd70-9bbe-4950-842f-e3d1e8acd9a7	d610682f-7028-42ca-93e2-0fbc64499b17	launch_waiting_desktop	{"ts": "2026-05-21T10:46:24.480843+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-21 10:46:23.726
ef288b4c-2320-4cfb-b8c2-8ac4fecddc88	d610682f-7028-42ca-93e2-0fbc64499b17	launch_waiting_desktop	{"ts": "2026-05-21T10:46:50.735176+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-21 10:46:50.312
d74326ef-a4e7-4e0f-a1c1-05c926a0ed5b	d610682f-7028-42ca-93e2-0fbc64499b17	launch_waiting_desktop	{"ts": "2026-05-21T10:46:50.735191+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-21 10:46:50.327
ca550d44-d2eb-432e-81e4-70f0cbb26f8d	d610682f-7028-42ca-93e2-0fbc64499b17	launch_health_checking	{"ts": "2026-05-21T10:46:50.735195+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-21 10:46:50.332
39340198-94ec-445c-b45c-e8c47026eea1	d610682f-7028-42ca-93e2-0fbc64499b17	launch_health_checking	{"ts": "2026-05-21T10:46:52.743981+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-21 10:46:52.39
b58950df-7b37-4d71-a733-bf0734d080c7	d610682f-7028-42ca-93e2-0fbc64499b17	launch_ready	{"ts": "2026-05-21T10:46:52.743997+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-21 10:46:52.396
767cecee-0f57-4a86-8f07-7970cf2cc57e	d610682f-7028-42ca-93e2-0fbc64499b17	launch_ready	{"ts": "2026-05-21T10:46:52.744007+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-21 10:46:52.398
3739f46a-97e2-4033-9a3f-040429a68fc4	d610682f-7028-42ca-93e2-0fbc64499b17	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-21 10:46:52.424
d2325b33-7177-491e-9ae1-67c3cb2bf6f4	d610682f-7028-42ca-93e2-0fbc64499b17	session_terminated	{"terminatedBy": "75c1fbf0-8ae8-4aed-b14f-429b8c830ced", "totalCostCents": 30000, "durationSeconds": 187, "terminationReason": "credit_exhausted", "alreadyBilledCents": 30000, "remainingChargeCents": 0}	\N	2026-05-21 10:50:00.084
ed17d0c4-79d7-4e6c-a75f-3c01a7020079	5474b5dc-6ff2-4688-95b3-b9281bec70de	session_created	{"configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "instanceName": "gpu-instance-eit5", "interfaceMode": "gui"}	\N	2026-05-21 11:14:27.275
a23ff1e8-f05e-425e-9730-9fc4089d2fa9	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_initiated	{"launchId": "35154c4b-9406-4244-b9c0-84913e35805b", "containerName": "laas-5474b5dc"}	\N	2026-05-21 11:14:27.341
66cce3d5-3636-4355-acc6-2ee98e1802bd	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_scheduling	{"ts": "2026-05-21T11:14:28.865965+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-21 11:14:29.375
0a237127-d379-4bd0-a782-2c9b0a57e878	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_scheduling	{"ts": "2026-05-21T11:14:28.966374+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-21 11:14:29.378
fa518d76-9a63-44ab-ad52-4247df609b85	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_allocating_ports	{"ts": "2026-05-21T11:14:28.966490+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-21 11:14:29.38
843950ac-6b1f-442e-82ed-0db9155354e3	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_allocating_ports	{"ts": "2026-05-21T11:14:28.990410+00:00", "status": "completed", "message": "Allocated ports: nginx=8101, selkies=9101, metrics=19101, display=:20"}	\N	2026-05-21 11:14:29.381
b8a32f42-3767-40cc-942f-04f0a1f3d41c	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_allocating_cpus	{"ts": "2026-05-21T11:14:28.990415+00:00", "status": "in_progress", "message": "Finding 12 contiguous CPU cores..."}	\N	2026-05-21 11:14:29.383
7c878ae0-74fe-427e-8c8e-d859dda1d1cd	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_allocating_cpus	{"ts": "2026-05-21T11:14:28.999601+00:00", "status": "completed", "message": "Allocated CPU cores: 2-13"}	\N	2026-05-21 11:14:29.385
9c6056ad-0801-485e-a72d-04108573041c	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_validating_mount	{"ts": "2026-05-21T11:14:28.999615+00:00", "status": "in_progress", "message": "Verifying local ZFS zvol for u_685f616624c645ead71f1619..."}	\N	2026-05-21 11:14:29.386
3530ecda-0092-4b6e-8488-e080e521b3b2	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_validating_mount	{"ts": "2026-05-21T11:14:28.999748+00:00", "status": "completed", "message": "Local ZFS zvol verified: /datapool/users/u_685f616624c645ead71f1619"}	\N	2026-05-21 11:14:29.388
1aa6ae93-ffa7-4194-9792-0553ab29e146	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_creating	{"ts": "2026-05-21T11:14:28.999781+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-21 11:14:29.389
937aca41-f7ff-4452-bf35-76a44932b405	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_creating	{"ts": "2026-05-21T11:14:29.082843+00:00", "status": "completed", "message": "Container created: laas-5474b5dc"}	\N	2026-05-21 11:14:29.391
d55fa559-bba0-440b-afde-abd1f34f5220	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_starting	{"ts": "2026-05-21T11:14:29.082862+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-21 11:14:29.392
0a81165b-97ff-47f6-8ace-4a260c8884d8	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_starting	{"ts": "2026-05-21T11:14:29.405249+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-21 11:14:29.394
a999268e-7f7d-4033-b5e8-c4190f923cb8	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_waiting_desktop	{"ts": "2026-05-21T11:14:29.405262+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8101..."}	\N	2026-05-21 11:14:29.396
a10a4ed2-3bc2-46ae-950b-62a70c75831d	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_waiting_desktop	{"ts": "2026-05-21T11:14:51.633055+00:00", "status": "completed", "message": "Desktop responding on port 8101 (HTTP 401)"}	\N	2026-05-21 11:14:51.675
7a29dc64-0560-48ba-b023-e228d942b732	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_waiting_desktop	{"ts": "2026-05-21T11:14:51.633069+00:00", "status": "completed", "message": "Desktop responding on port 8101"}	\N	2026-05-21 11:14:51.677
6c8ab106-342a-4327-a36a-517ae91a7db8	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_health_checking	{"ts": "2026-05-21T11:14:51.633072+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-21 11:14:51.679
8958165d-2a7b-4121-a577-c4e2de74052f	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_health_checking	{"ts": "2026-05-21T11:14:53.642624+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-21 11:14:53.705
8c13d535-10df-4130-8dee-8cdebf1b4306	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_ready	{"ts": "2026-05-21T11:14:53.642640+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-21 11:14:53.706
dcff56c8-0043-4227-82a6-c786bb39de24	5474b5dc-6ff2-4688-95b3-b9281bec70de	launch_ready	{"ts": "2026-05-21T11:14:53.642649+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-21 11:14:53.708
6eb4cb20-8e85-4e10-8ac5-d9324f34d4bb	5474b5dc-6ff2-4688-95b3-b9281bec70de	session_ready	{"nginxPort": 8101, "sessionUrl": "http://100.94.157.114:8101/", "selkiesPort": 9101, "displayNumber": 20}	\N	2026-05-21 11:14:53.714
9b9a5334-0c19-4c3c-aa05-e0801b1f365a	79e8882e-3f8a-4440-b752-87ce59369923	session_created	{"configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "instanceName": "gpu-instance-ndjq", "interfaceMode": "gui"}	\N	2026-05-21 11:38:08.117
0e0246ef-b83e-4ffd-8b11-11d88176c745	79e8882e-3f8a-4440-b752-87ce59369923	launch_initiated	{"launchId": "c67f8542-7c54-43b6-a2e4-38c5e6eb7361", "containerName": "laas-79e8882e"}	\N	2026-05-21 11:38:08.175
f969b563-fece-4496-a06d-a0edf22b2bcf	79e8882e-3f8a-4440-b752-87ce59369923	launch_scheduling	{"ts": "2026-05-21T11:38:09.671932+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-21 11:38:10.219
1b0fea2b-e5a6-461d-a450-aad3c4118674	79e8882e-3f8a-4440-b752-87ce59369923	launch_scheduling	{"ts": "2026-05-21T11:38:09.772105+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-21 11:38:10.222
6e778531-7489-4f0f-bd74-30539c4f8e97	79e8882e-3f8a-4440-b752-87ce59369923	launch_allocating_ports	{"ts": "2026-05-21T11:38:09.772217+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-21 11:38:10.224
a7ff4d3d-9f2a-40f4-84dc-6d069197cedd	79e8882e-3f8a-4440-b752-87ce59369923	launch_allocating_ports	{"ts": "2026-05-21T11:38:09.845872+00:00", "status": "completed", "message": "Allocated ports: nginx=8102, selkies=9102, metrics=19102, display=:21"}	\N	2026-05-21 11:38:10.226
62984343-eeba-41fe-8acf-3b5d1e4ab1ca	79e8882e-3f8a-4440-b752-87ce59369923	launch_allocating_cpus	{"ts": "2026-05-21T11:38:09.845879+00:00", "status": "in_progress", "message": "Finding 8 contiguous CPU cores..."}	\N	2026-05-21 11:38:10.227
1eae4010-bafe-4705-8084-7fa5817fc99b	79e8882e-3f8a-4440-b752-87ce59369923	launch_allocating_cpus	{"ts": "2026-05-21T11:38:09.880003+00:00", "status": "completed", "message": "Allocated CPU cores: 6-13"}	\N	2026-05-21 11:38:10.229
7519e566-159e-42db-b954-9a306bc8b115	79e8882e-3f8a-4440-b752-87ce59369923	launch_validating_mount	{"ts": "2026-05-21T11:38:09.880025+00:00", "status": "in_progress", "message": "Setting up NVMe-oF storage for u_14629f52052167574ce6e80e..."}	\N	2026-05-21 11:38:10.23
359a5277-1292-4895-9cff-d34f9126273b	79e8882e-3f8a-4440-b752-87ce59369923	launch_nvme_preparing	{"ts": "2026-05-21T11:38:09.880098+00:00", "status": "in_progress", "message": "Preparing cross-node storage at 10.10.100.88..."}	\N	2026-05-21 11:38:10.231
cd7e60b9-1a67-4fbf-880f-e324ba543df9	79e8882e-3f8a-4440-b752-87ce59369923	launch_nvme_discovering	{"ts": "2026-05-21T11:38:10.056500+00:00", "status": "in_progress", "message": "Discovering NVMe-oF subsystem at 10.10.100.88..."}	\N	2026-05-21 11:38:10.233
dbd6eb6a-8ade-470e-8fe8-e355805755ed	79e8882e-3f8a-4440-b752-87ce59369923	launch_nvme_discovering	{"ts": "2026-05-21T11:38:10.078956+00:00", "status": "completed", "message": "NVMe-oF subsystem discovered"}	\N	2026-05-21 11:38:10.234
73493ef0-d719-4131-bf5e-7447eed49441	79e8882e-3f8a-4440-b752-87ce59369923	launch_nvme_connecting	{"ts": "2026-05-21T11:38:10.079017+00:00", "status": "in_progress", "message": "Connecting to NVMe-oF subsystem laas-u_14629f52052167574ce6e80e..."}	\N	2026-05-21 11:38:10.235
7adf98f2-556a-4597-9f9a-1aaedc2cf91a	79e8882e-3f8a-4440-b752-87ce59369923	launch_nvme_connecting	{"ts": "2026-05-21T11:38:10.134315+00:00", "status": "completed", "message": "NVMe-oF connected"}	\N	2026-05-21 11:38:10.238
e94d852a-4eb4-44ec-b388-5cf31da31691	79e8882e-3f8a-4440-b752-87ce59369923	launch_nvme_finding_device	{"ts": "2026-05-21T11:38:10.134411+00:00", "status": "in_progress", "message": "Locating NVMe block device..."}	\N	2026-05-21 11:38:10.239
d054db13-b386-4b21-aaf3-828bfed640fa	79e8882e-3f8a-4440-b752-87ce59369923	launch_nvme_finding_device	{"ts": "2026-05-21T11:38:10.645933+00:00", "status": "completed", "message": "Block device found: /dev/nvme3n1"}	\N	2026-05-21 11:38:10.242
ae7df1e1-ed69-4e57-b64b-e3c67d9b31ac	79e8882e-3f8a-4440-b752-87ce59369923	launch_nvme_mounting	{"ts": "2026-05-21T11:38:10.646038+00:00", "status": "in_progress", "message": "Mounting /dev/nvme3n1 to /mnt/nvme/u_14629f52052167574ce6e80e..."}	\N	2026-05-21 11:38:10.244
bcfacb0e-3d2c-468e-9635-4f3956744b21	79e8882e-3f8a-4440-b752-87ce59369923	launch_nvme_mounting	{"ts": "2026-05-21T11:38:10.677087+00:00", "status": "completed", "message": "NVMe-oF volume mounted"}	\N	2026-05-21 11:38:10.245
b50d7195-8166-45bf-83b6-a5d3e08b4d15	79e8882e-3f8a-4440-b752-87ce59369923	launch_nvme_verifying	{"ts": "2026-05-21T11:38:10.677132+00:00", "status": "in_progress", "message": "Verifying storage permissions..."}	\N	2026-05-21 11:38:10.246
67a3cf18-822d-4c97-9e22-a1deb2daec94	79e8882e-3f8a-4440-b752-87ce59369923	launch_nvme_verifying	{"ts": "2026-05-21T11:38:10.677625+00:00", "status": "completed", "message": "Permissions verified (UID 1000, read/write OK)"}	\N	2026-05-21 11:38:10.248
91ee00a1-5986-409a-9278-3b12b0a76e83	79e8882e-3f8a-4440-b752-87ce59369923	launch_validating_mount	{"ts": "2026-05-21T11:38:10.677673+00:00", "status": "completed", "message": "NVMe-oF storage ready at /mnt/nvme/u_14629f52052167574ce6e80e"}	\N	2026-05-21 11:38:10.249
361d31f1-60df-4bf7-89dc-1a27e4307512	79e8882e-3f8a-4440-b752-87ce59369923	launch_creating	{"ts": "2026-05-21T11:38:10.677723+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-21 11:38:10.25
899af4f5-671f-417b-87ae-e0094f01ad40	79e8882e-3f8a-4440-b752-87ce59369923	launch_creating	{"ts": "2026-05-21T11:38:10.757672+00:00", "status": "completed", "message": "Container created: laas-79e8882e"}	\N	2026-05-21 11:38:10.251
d8587472-3022-4e9c-8c99-c0dd7e3599b0	79e8882e-3f8a-4440-b752-87ce59369923	launch_starting	{"ts": "2026-05-21T11:38:10.757682+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-21 11:38:10.253
15b1ed40-80ce-43a2-9469-c11d5b01f178	79e8882e-3f8a-4440-b752-87ce59369923	launch_starting	{"ts": "2026-05-21T11:38:11.089859+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-21 11:38:10.255
19959974-6f5d-4c2f-8533-8d6969b6dbde	79e8882e-3f8a-4440-b752-87ce59369923	launch_waiting_desktop	{"ts": "2026-05-21T11:38:11.089871+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8102..."}	\N	2026-05-21 11:38:10.257
f52dabf3-7a81-437f-8541-b76a8ab6ddfe	79e8882e-3f8a-4440-b752-87ce59369923	launch_waiting_desktop	{"ts": "2026-05-21T11:38:29.265437+00:00", "status": "completed", "message": "Desktop responding on port 8102 (HTTP 401)"}	\N	2026-05-21 11:38:28.564
4617569e-f890-4a6e-b7c2-076136cabda8	79e8882e-3f8a-4440-b752-87ce59369923	launch_waiting_desktop	{"ts": "2026-05-21T11:38:29.265450+00:00", "status": "completed", "message": "Desktop responding on port 8102"}	\N	2026-05-21 11:38:28.566
86df1016-b3f6-412e-b10d-f841ddf6bb77	79e8882e-3f8a-4440-b752-87ce59369923	launch_health_checking	{"ts": "2026-05-21T11:38:29.265454+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-21 11:38:28.568
09b92a5c-da27-43d9-bf5e-b6496da57899	79e8882e-3f8a-4440-b752-87ce59369923	launch_health_checking	{"ts": "2026-05-21T11:38:31.272859+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-21 11:38:30.587
0586e666-7e20-4a2a-a7b9-8d41515d4ae4	79e8882e-3f8a-4440-b752-87ce59369923	launch_ready	{"ts": "2026-05-21T11:38:31.272873+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-21 11:38:30.589
a4b9095e-2b22-474a-801e-11d22dcd0ea6	79e8882e-3f8a-4440-b752-87ce59369923	launch_ready	{"ts": "2026-05-21T11:38:31.272885+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-21 11:38:30.591
ef01814c-acb7-4ebc-ac48-2d09cf6263fc	79e8882e-3f8a-4440-b752-87ce59369923	session_ready	{"nginxPort": 8102, "sessionUrl": "http://100.88.57.107:8102/", "selkiesPort": 9102, "displayNumber": 21}	\N	2026-05-21 11:38:30.599
\.


--
-- TOC entry 6051 (class 0 OID 152000)
-- Dependencies: 269
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, user_id, organization_id, compute_config_id, booking_id, node_id, session_type, container_id, container_name, nginx_port, selkies_port, display_number, session_token_hash, session_url, status, started_at, ended_at, scheduled_end_at, last_activity_at, nfs_mount_path, base_image_id, actual_gpu_vram_mb, actual_hami_sm_percent, reconnect_count, last_reconnect_at, auto_preserve_files, avg_rtt_ms, avg_packet_loss_ratio, resource_snapshot, created_at, updated_at, created_by, updated_by, allocated_gpu_vram_mb, allocated_hami_sm_percent, allocated_memory_mb, allocated_vcpu, allocation_snapshot_at, cost_last_updated_at, cumulative_cost_cents, duration_seconds, instance_name, storage_mode, terminated_at, terminated_by, termination_details, termination_reason, storage_node_id, storage_transport, ephemeral_storage_path, ephemeral_storage_size_mb) FROM stdin;
fae608c4-ed05-41cd-b0b6-4134aaaa6354	8d40647d-da49-4490-ada6-3bfa2205366c	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-fae608c4	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-19 00:24:59.878	2026-05-19 00:26:10.44	\N	\N	\N	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 33, "interfaceMode": "gui", "encryptedPassword": "099cad89bc81d43deb57c9205d9b601f", "encryptedPasswordIv": "8e4ab0122f05d0abf13b7267", "encryptedPasswordTag": "4cd98411942818b0e7ae9fff7e02cae9", "basePricePerHourCents": 30000}	2026-05-19 00:24:43.557	2026-05-19 00:26:10.457	\N	\N	8192	33	16384	8	2026-05-19 00:24:43.555	2026-05-19 00:26:10.44	30000	70	gpu-instance-z09o	ephemeral	2026-05-19 00:26:10.44	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_fae608c4-ed05-41cd-b0b6-4134aaaa6354	10240
7c24eb9b-cef9-43c9-9874-220745bc7662	8d40647d-da49-4490-ada6-3bfa2205366c	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-7c24eb9b	8102	9102	21	\N	http://100.94.157.114:8102/	ended	2026-05-19 12:43:34.698	2026-05-19 16:34:20.149	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "eb57876edab503a47892aca91f06a5ee", "encryptedPasswordIv": "3182ab9c96bc3e7b2dd875bc", "encryptedPasswordTag": "16032cf0e1e9a4d5606c99a14391f1f7", "basePricePerHourCents": 12000}	2026-05-19 12:43:12.285	2026-05-19 16:34:20.175	\N	\N	2048	8	4096	2	2026-05-19 12:43:12.282	2026-05-19 16:34:20.149	48000	13845	gpu-instance-0ybq	ephemeral	2026-05-19 16:34:20.149	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_7c24eb9b-cef9-43c9-9874-220745bc7662	10240
a580b232-5224-4c8e-b8b5-a1cf39642e0c	8d40647d-da49-4490-ada6-3bfa2205366c	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-a580b232	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-20 06:31:20.422	2026-05-20 06:32:04.537	\N	\N	/mnt/nfs/users/u_80b52988266cafa9ccd98e76	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "4c1b5360ef37b233b7f3620f1716b0c5", "encryptedPasswordIv": "c3a89ad52b6b0b6d2427cf7c", "encryptedPasswordTag": "c5410bbc5ba0a79e17d7a5344f0b585a", "basePricePerHourCents": 36000}	2026-05-20 06:30:55.992	2026-05-20 06:32:04.555	\N	\N	16384	67	32768	12	2026-05-20 06:30:55.99	2026-05-20 06:32:04.537	36000	44	gpu-instance-n7jv	stateful	2026-05-20 06:32:04.537	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	8d40647d-da49-4490-ada6-3bfa2205366c	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-dc4bfb83	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-20 00:43:24.745	2026-05-20 01:21:13.847	\N	\N	\N	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "350bb0690c3d0a6e5eeb79190aaed6d6", "encryptedPasswordIv": "e9716d23ac27be7aa714f481", "encryptedPasswordTag": "48e674561f5eb378fbc2acd228d887de", "basePricePerHourCents": 36000}	2026-05-20 00:43:02.144	2026-05-20 01:21:13.873	\N	\N	16384	67	32768	12	2026-05-20 00:43:02.143	2026-05-20 01:21:13.847	36000	2269	gpu-instance-ryym	ephemeral	2026-05-20 01:21:13.847	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	10240
c5925ef4-d5dd-4551-9165-50ce29fac9ff	8d40647d-da49-4490-ada6-3bfa2205366c	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-c5925ef4	8102	9102	21	\N	http://100.94.157.114:8102/	ended	2026-05-20 06:32:15.517	2026-05-20 06:33:32.213	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "0c6479fe647eb16c5fca4fc1a33a58e9", "encryptedPasswordIv": "4dc61cad8c6c9f81bc044980", "encryptedPasswordTag": "d5410e2c20aef1813289ab5c2bd7be44", "basePricePerHourCents": 12000}	2026-05-20 06:31:53.027	2026-05-20 06:33:32.24	\N	\N	2048	8	4096	2	2026-05-20 06:31:53.025	2026-05-20 06:33:32.213	12000	76	gpu-instance-pwwu	ephemeral	2026-05-20 06:33:32.213	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_c5925ef4-d5dd-4551-9165-50ce29fac9ff	10240
c4ce3860-7509-47a7-b3d6-60592b593100	8d40647d-da49-4490-ada6-3bfa2205366c	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-c4ce3860	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-18 07:03:02.446	2026-05-18 07:06:38.58	\N	\N	/mnt/nfs/users/u_962b82c8054e7213ac9a4938	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "544a40bb83dcbd9a67b391f43be12bc5", "encryptedPasswordIv": "c91bbc6e16fbecf81d7f2183", "encryptedPasswordTag": "49c7b62673afe8991d7c04aaefd97cb4", "basePricePerHourCents": 36000}	2026-05-18 07:02:40.036	2026-05-18 07:06:38.6	\N	\N	16384	67	32768	12	2026-05-18 07:02:40.033	2026-05-18 07:06:38.58	36000	216	gpu-instance-8gmm	stateful	2026-05-18 07:06:38.58	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
b3fb45cb-ac62-41bb-b65b-babce27a14fe	8d40647d-da49-4490-ada6-3bfa2205366c	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-b3fb45cb	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-18 07:30:52.701	2026-05-18 07:32:37.349	\N	\N	/mnt/nfs/users/u_962b82c8054e7213ac9a4938	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "e9cb8ef9531a5ed57c730eeaaf602a8c", "encryptedPasswordIv": "527c4d0b7764ab5beaf42671", "encryptedPasswordTag": "7f1f870729e272ac06607a8106d854f9", "basePricePerHourCents": 36000}	2026-05-18 07:30:32.3	2026-05-18 07:32:37.383	\N	\N	16384	67	32768	12	2026-05-18 07:30:32.297	2026-05-18 07:32:37.349	36000	104	gpu-instance-bw3i	stateful	2026-05-18 07:32:37.349	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	local_zfs	\N	\N
d610682f-7028-42ca-93e2-0fbc64499b17	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-d610682f	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-21 10:46:52.41	2026-05-21 10:50:00.052	\N	\N	\N	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 33, "interfaceMode": "gui", "encryptedPassword": "2c2c148113714bf46843d48787cf7ac5", "encryptedPasswordIv": "16a0101a2bf37491e65668bf", "encryptedPasswordTag": "69458abcc27b273356865df813ef6550", "basePricePerHourCents": 30000}	2026-05-21 10:46:21.614	2026-05-21 10:50:00.076	\N	\N	8192	33	16384	8	2026-05-21 10:46:21.612	2026-05-21 10:50:00.052	30000	187	gpu-instance-kxeb	ephemeral	2026-05-21 10:50:00.052	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	credit_exhausted	\N	\N	/datapool/ephemeral/sess_d610682f-7028-42ca-93e2-0fbc64499b17	10240
a50d4adb-5e31-41ba-9972-91dc118efdc0	8d40647d-da49-4490-ada6-3bfa2205366c	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-a50d4adb	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-18 07:31:29.681	2026-05-19 00:23:24.854	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "02ff8d3c13fa35a655af76246516a0d2", "encryptedPasswordIv": "98e1aaf672250d07ce2cff0f", "encryptedPasswordTag": "259f69750a3585c17723b5cfd58e87c6", "basePricePerHourCents": 12000}	2026-05-18 07:31:09.313	2026-05-19 00:23:24.885	\N	\N	2048	8	4096	2	2026-05-18 07:31:09.31	2026-05-19 00:23:24.854	204000	60715	gpu-instance-5ef5	ephemeral	2026-05-19 00:23:24.854	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_a50d4adb-5e31-41ba-9972-91dc118efdc0	10240
aef9cfcc-1747-4572-933e-6cf55bce8993	8d40647d-da49-4490-ada6-3bfa2205366c	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-aef9cfcc	8102	9102	21	\N	http://100.94.157.114:8102/	ended	2026-05-19 00:22:22.454	2026-05-19 00:24:03.767	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "e8ee63e24e9dd881bd7fd998c5c9312a", "encryptedPasswordIv": "e23da4c54e25e56d0dc95769", "encryptedPasswordTag": "75a41351d42cb40b2c7726030afd9ce3", "basePricePerHourCents": 12000}	2026-05-19 00:22:02.103	2026-05-19 00:24:03.786	\N	\N	2048	8	4096	2	2026-05-19 00:22:02.101	2026-05-19 00:24:03.767	12000	101	gpu-instance-fn5b	ephemeral	2026-05-19 00:24:03.767	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_aef9cfcc-1747-4572-933e-6cf55bce8993	10240
968bf735-3894-4093-838d-efb4a943315d	8d40647d-da49-4490-ada6-3bfa2205366c	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-968bf735	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-18 17:36:54.654	2026-05-18 18:02:49.401	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "b610a510e2e0383d33b86950fbd026d8", "encryptedPasswordIv": "d678f5992faae2535f70754c", "encryptedPasswordTag": "e485661c43c75f4a53bac50775cc29fe", "basePricePerHourCents": 12000}	2026-05-18 17:36:32.224	2026-05-18 18:02:49.432	\N	\N	2048	8	4096	2	2026-05-18 17:36:32.221	2026-05-18 18:02:49.401	12000	1554	gpu-instance-i0m9	ephemeral	2026-05-18 18:02:49.401	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_968bf735-3894-4093-838d-efb4a943315d	10240
b0dbca4f-3348-4831-a7a6-fb319b7dfb46	8d40647d-da49-4490-ada6-3bfa2205366c	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-b0dbca4f	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-18 10:21:28.098	2026-05-18 17:23:42.383	\N	\N	\N	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "e7c301bc46ecb79dc6efb7be51e55892", "encryptedPasswordIv": "e64bd2b0bab71acd8253df68", "encryptedPasswordTag": "414cbd612c78db1c6004dd877dddc3e6", "basePricePerHourCents": 36000}	2026-05-18 10:21:07.572	2026-05-18 17:23:42.454	\N	\N	16384	67	32768	12	2026-05-18 10:21:07.57	2026-05-18 17:23:42.383	288000	25334	gpu-instance-64uh	ephemeral	2026-05-18 17:23:42.383	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_b0dbca4f-3348-4831-a7a6-fb319b7dfb46	10240
8548fb98-e8da-4f26-85da-e343210f26a2	8d40647d-da49-4490-ada6-3bfa2205366c	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-8548fb98	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-19 04:28:15.105	2026-05-19 16:33:50.132	\N	\N	\N	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 33, "interfaceMode": "gui", "encryptedPassword": "b536b9e8bdcd1a9fd10d9ce8fdced326", "encryptedPasswordIv": "2ece6b8d8e50afa0f5465b88", "encryptedPasswordTag": "1a7182454f92da0c0602cfcff5cf2d7b", "basePricePerHourCents": 30000}	2026-05-19 04:27:52.444	2026-05-19 16:33:50.161	\N	\N	8192	33	16384	8	2026-05-19 04:27:52.44	2026-05-19 16:33:50.132	390000	43535	gpu-instance-gsim	ephemeral	2026-05-19 16:33:50.132	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_8548fb98-e8da-4f26-85da-e343210f26a2	10240
b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	8d40647d-da49-4490-ada6-3bfa2205366c	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-b46a1616	8102	9102	21	\N	http://100.94.157.114:8102/	ended	2026-05-18 18:37:54.449	2026-05-18 18:38:26.192	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "53ee15a3c1942744a75dbdf8efa0fb8d", "encryptedPasswordIv": "6411314de0972c5c518a109f", "encryptedPasswordTag": "38c33ebdba5bf71c2a4da2dc78ef2897", "basePricePerHourCents": 12000}	2026-05-18 18:37:31.856	2026-05-18 18:38:26.21	\N	\N	2048	8	4096	2	2026-05-18 18:37:31.855	2026-05-18 18:38:26.192	12000	31	gpu-instance-ytlg	ephemeral	2026-05-18 18:38:26.192	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	10240
46541468-ee50-4fab-bd02-4250162c40e6	8d40647d-da49-4490-ada6-3bfa2205366c	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-46541468	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-18 18:04:26.436	2026-05-20 07:21:56.403	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "fcf9eedbab0532808ffbe916c39e4bf5", "encryptedPasswordIv": "bc979e511c0636e32be4d238", "encryptedPasswordTag": "b310c85adb23982c2998776ebd5bc0a6", "basePricePerHourCents": 12000}	2026-05-18 18:04:03.796	2026-05-20 07:21:56.432	\N	\N	2048	8	4096	2	2026-05-18 18:04:03.795	2026-05-20 07:21:56.403	456000	134249	gpu-instance-06p0	ephemeral	2026-05-20 07:21:56.403	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_46541468-ee50-4fab-bd02-4250162c40e6	10240
5474b5dc-6ff2-4688-95b3-b9281bec70de	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-5474b5dc	8101	9101	20	\N	http://100.94.157.114:8101/	running	2026-05-21 11:14:53.71	\N	\N	\N	/mnt/nfs/users/u_685f616624c645ead71f1619	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "57bc5eef64a12d8cfc5e007d0257fb48", "encryptedPasswordIv": "a53014b7e982b1025ecabd3b", "encryptedPasswordTag": "e4baf5a98d2e8ddfff203bd6c7903a9a", "basePricePerHourCents": 36000}	2026-05-21 11:14:27.258	2026-05-21 14:30:00.091	\N	\N	16384	67	32768	12	2026-05-21 11:14:27.257	2026-05-21 14:30:00.089	180000	\N	gpu-instance-eit5	stateful	\N	\N	\N	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	local_zfs	\N	\N
f5b1efc7-f4f8-4e0a-acfd-0594db1096da	f3a5cce9-059c-4828-ac18-61164c28e868	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-f5b1efc7	8102	9102	21	\N	http://100.94.157.114:8102/	ended	2026-05-20 08:11:44.088	2026-05-21 05:35:38.524	\N	\N	/mnt/nfs/users/u_f15f2564a9c60fe5501e4589	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "1705e76f3d26388f01272c56f2415a47", "encryptedPasswordIv": "7d916fc847593f32621448ba", "encryptedPasswordTag": "ca03b1296dc9f2635759ff1222d3a724", "basePricePerHourCents": 36000}	2026-05-20 08:11:23.211	2026-05-21 05:35:38.574	\N	\N	16384	67	32768	12	2026-05-20 08:11:23.21	2026-05-21 05:35:38.524	792000	77034	gpu-instance-m41z	stateful	2026-05-21 05:35:38.524	f3a5cce9-059c-4828-ac18-61164c28e868	\N	user_requested	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	local_zfs	\N	\N
8095cdef-8105-40bc-84a1-4510c81383d0	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-8095cdef	8102	9102	21	\N	http://100.94.157.114:8102/	ended	2026-05-21 10:44:44.2	2026-05-21 10:45:07.609	\N	\N	\N	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 33, "interfaceMode": "gui", "encryptedPassword": "2b796e4f47f49fb36768ff528909130b", "encryptedPasswordIv": "da3113549994d96fd77e7148", "encryptedPasswordTag": "061b4baff4eeaa9504b59c3e52ffc865", "basePricePerHourCents": 30000}	2026-05-21 10:44:13.452	2026-05-21 10:45:07.669	\N	\N	8192	33	16384	8	2026-05-21 10:44:13.45	2026-05-21 10:45:07.609	30000	23	gpu-instance-5bsk	ephemeral	2026-05-21 10:45:07.609	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	credit_exhausted	\N	\N	/datapool/ephemeral/sess_8095cdef-8105-40bc-84a1-4510c81383d0	10240
f644f81d-3b03-46c3-bfdb-d098923af02c	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-f644f81d	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-20 06:36:21.205	2026-05-21 10:38:17.196	\N	\N	/mnt/nfs/users/u_113129005bb5ebde59837825	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "2b8a9db14ee4451aa1e6110a3d571b77", "encryptedPasswordIv": "a0fb4a8c702381a77b528e67", "encryptedPasswordTag": "db6c0e37fdf74ff16a081f76ae08a052", "basePricePerHourCents": 12000}	2026-05-20 06:36:04.896	2026-05-21 10:38:17.223	\N	\N	2048	8	4096	2	2026-05-20 06:36:04.894	2026-05-21 10:38:17.196	348000	100915	gpu-instance-840a	stateful	2026-05-21 10:38:17.196	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	user_requested	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	local_zfs	\N	\N
2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	8d40647d-da49-4490-ada6-3bfa2205366c	\N	46756643-41f5-4eb1-a161-d5b595b4e0c8	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-2f072a36	8101	9101	20	\N	http://100.88.57.107:8101/	running	2026-05-20 07:22:38.944	\N	\N	\N	\N	\N	4096	17	0	\N	f	\N	\N	{"vcpu": 4, "gpuModel": "RTX 4090", "memoryMb": 8192, "gpuVramMb": 4096, "configName": "Blaze", "configSlug": "blaze", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 17, "interfaceMode": "gui", "encryptedPassword": "2739fa03535cef3239c711f9f949a039", "encryptedPasswordIv": "5b3832184aee6b167c820944", "encryptedPasswordTag": "79100ba2b6e8054a52230ea385eeb5d0", "basePricePerHourCents": 21000}	2026-05-20 07:22:16.556	2026-05-21 14:30:00.131	\N	\N	4096	17	8192	4	2026-05-20 07:22:16.554	2026-05-21 14:30:00.129	378000	\N	gpu-instance-dh0j	ephemeral	\N	\N	\N	\N	\N	\N	/datapool/ephemeral/sess_2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	10240
378ec15c-cec4-4864-98da-49821b126fb4	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-378ec15c	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-21 10:42:53.283	2026-05-21 10:45:00.142	\N	\N	/mnt/nfs/users/u_113129005bb5ebde59837825	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "f84d9bb080a33be8a939d418223d89fb", "encryptedPasswordIv": "ce0af907ce21393db1f3c959", "encryptedPasswordTag": "c580d612f702db8f44553400efc3bb4d", "basePricePerHourCents": 12000}	2026-05-21 10:42:11.939	2026-05-21 10:45:00.16	\N	\N	2048	8	4096	2	2026-05-21 10:42:11.938	2026-05-21 10:45:00.142	12000	126	gpu-instance-3jnd	stateful	2026-05-21 10:45:00.142	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	credit_exhausted	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	local_zfs	\N	\N
79e8882e-3f8a-4440-b752-87ce59369923	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-79e8882e	8102	9102	21	\N	http://100.88.57.107:8102/	running	2026-05-21 11:38:30.594	\N	\N	\N	/mnt/nfs/users/u_14629f52052167574ce6e80e	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 33, "interfaceMode": "gui", "encryptedPassword": "13bf1d2b69c1a8d1ca7fc9102a0a9efc", "encryptedPasswordIv": "0553ba096fdf269b71b8fdbd", "encryptedPasswordTag": "330f54cfba1fbaff1f52ddd4fd8946ff", "basePricePerHourCents": 30000}	2026-05-21 11:38:08.104	2026-05-21 14:30:00.151	\N	\N	8192	33	16384	8	2026-05-21 11:38:08.102	2026-05-21 14:30:00.15	120000	\N	gpu-instance-ndjq	stateful	\N	\N	\N	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	nvmeof_tcp	\N	\N
\.


--
-- TOC entry 6052 (class 0 OID 152021)
-- Dependencies: 270
-- Data for Name: storage_extensions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.storage_extensions (id, user_id, storage_volume_id, extension_type, previous_quota_bytes, new_quota_bytes, extension_bytes, amount_cents, currency, payment_transaction_id, wallet_transaction_id, notes, created_at, created_by) FROM stdin;
4af803ef-9872-47e4-947d-54984bd35e31	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	user_upgrade	20401094656	27917287424	7516192768	0	INR	\N	\N	\N	2026-05-18 16:31:34.71	\N
908c0bf3-82c5-4dd0-9c47-db836f4e71ad	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	user_upgrade	27917287424	34359738368	6442450944	0	INR	\N	\N	\N	2026-05-18 16:32:48.321	\N
\.


--
-- TOC entry 6053 (class 0 OID 152039)
-- Dependencies: 271
-- Data for Name: subscription_plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscription_plans (id, slug, name, description, price_cents, currency, billing_period, gpu_hours_included, mentor_sessions_included, features, is_active, sort_order, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6054 (class 0 OID 152059)
-- Dependencies: 272
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscriptions (id, user_id, plan_id, organization_id, status, starts_at, ends_at, gpu_hours_remaining, mentor_sessions_remaining, auto_renew, cancellation_requested_at, cancel_at_period_end, grace_period_until, payment_transaction_id, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6076 (class 0 OID 163196)
-- Dependencies: 294
-- Data for Name: support_ticket_attachments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.support_ticket_attachments (id, "ticketId", "fileName", "mimeType", size, data, "createdAt") FROM stdin;
aa276909-0586-4f0d-b953-18164b5e5904	af0c610c-f4ee-429a-b9b7-4a4655e416d9	original-2710ced3a7195ff410c78954b4ddbcc0.webp	image/webp	38410	\\x524946460296000057454250565038580a00000018000000ff0300ff0200414c504865000000011fd0ff8808988a644334d1c4312f92523e37a2ff1350df1ffee33ffee33ffee33ffee33ffee33ffee33ffee33ffee33ffee33ffee33ffee33ffee33ffee33ffee33ffee33ffee33ffee33ffee33ffee33ffee33ffee33ffee33ffee33f2de2bf7edd26390056503820b49400003056029d012a000400033e75389849a4a3252222118940a00e89696de7dbe58f99ce8634062d7e4f144e65ab7acffc7f0991df7568d95bb07eaf653e55a254fb77cba70ef4ccf219fe4e3a352743f64aa9998b1a7f99309bfed3d4af98078e07ec07ba0fdd8fc40f80ffb83fb81ef4be89bfd1fa807f68ffb1d653fbbbec01e5bbfb9df071fd9ffe3fee9fff3f910ff0bfedffffffe8f700ffc1ea01ff8faddfd7bfcfff89fca1f823f33fddbfbaff80ff0bfe57fbf7a7ff8e7ce3f64fefdfb21fdbff6a3efbafc7d747f73e837f25fb49f89fee9fe57fe1ff7ef9bdfd6ffabff1ffbb7fe87d1df8cffd6ff92fef3ff7bfba7c82fe3bfc9bfc0ff69fdc2fed9fbe1f685f8fff53fc37768689ff23fe67a82faa7f3fff39fde3fd3ffd3ff0df073f11fe63fcdff83ff95fbfff26fea7fd8ffceff8dfdc8ff27fffff003f917f34ff25fdbff747fc57ffffff1f7dff9fff8df9ffe933f6aff4bff4ffcb7e4ffd80ff26fe83fe87fbcffa4ffa9fe5bffffff6fc64fe8ffec7f92ff59fb7fed7ff40ff17ff5bfc97faefda4fb05fe53fd33fdaff76ff33ffc3fce7fffffe9f771ffc3fe2fbfefdbeffcffef7e10ff5fbff67e7f8a9be36d3708c73bc6da8a5519b6a295466dae1bc8cdb514aa336d3708c73bc5bf05bc0a8cdb3caab6b6ef2804aae599dd7490ee3ad2a8ccc16601472dc09a77b78ba619aa513c165eb68d92a32cec585936784d8e72d3b9615efe0a1ab79321cfb2729ff1ed80eb5c122c0dea87603d91be19974f5778a351114f235092aa25cd6c07b4c5c7c3f3397efb1c3f5e2b3a490f53ed651ac2a0ef7ed2717b553c62ebf464dd4141ea27a3069508ab44d098c1a5f9ff8f4d82183448f1e9b0430697e697b8058d298218280237d5907d8025f3bfca309a87e8fbd799fa2c61fafd663c03ec014d5e877ca739b4fd9e7ab98a96234b41991100dc19aaa0d4ebafe90aa0ef17e00971bf896892f9125f224be4497aee6a1fa5f2124722caaf2514ee72f1e78f444776cd56382a89d3975a1b5dfca2f966c4dbfd330488bb204cb749feefe9a522ac8eb92740bb04fd5f6dd909d40a6a1427df32a990609d6736dcf1c0d0acdd4428bfddbb28bb7226b4eefe4602be387740e1a6ffa6bfbbfdb0e6c98a26dcc90f40469fb93bc01158e941f2b462bd43e6e58c8f1158801060f7c212091ec4d0fe73d3a8430f6e6512b16f4d6e34efe3387d40f531434dd77ae31ff0d3c8cdb514aa336d452a83e03ddee032eea9aff1f01032d4d0b670dfa64d1ab059f7336d98a399ffdf669a43cc1badc28e992fda3f74c5388803104492fd6fb5623caf1be495ed32bd32f6487ee63709970374606e8c0dd181ba3037460412a8d17540722fdbe03ea77aca7ecda79a51a2284ae9e8d93299417a60adad697020b54941f1993436699c6c1a3b0b111ad1ca1515d3239acd5962baac52e7826446080073bc6d19f043ae039de368b7bbd001cef07af4fad5064850c783f327ec53c8c9d9eb89eed01b9a2c4336e4403d3e69022fce7705f9c823bcc7ae84f436cad85ea5ed6ce00e8b56999db46a11ab28588774902b3b6382ede6a80f064d615d3cac993213a1541856076e262a77b8efb4554d45c8f83bb87794ebbaf1befe6a1ae4c02ae87a2bb0816b91e6f230f2f2035be17bdeaa995363cd4479479fd290763aab9ac025b6bdfec80a1199e40fc1c70db3d8513c2d98bee6ba8742b3f3d0923aff6409178686b47b0af348b9ca689e3802132a03a0be738856f64ed74d041e3f7e6e7a0d07c76561b4817f682b50002c0f6c9e208519bc82f2001a9d007a93d1f597dbace78fa2fb5a175e8184e3d540453b247cc7cee1a414650f405596b1b2aaa3e4b4eda9f3329f3e8f64a2a2a838e6f907c549e04d1512383ca7e575f06082421078c946545544be4a0a58942ae79ea846452e750ecce0b6216c432bdb20a28e8ce3bd11b47181bcb7d1c1eb6d9ac105454719dbb0a4d306cd81e0d62d454d120c0122db3f3dd41c0b122684daac842604d5562c086fccf6075ffe5b4034643ff2b791afddf42452dc3657076fcb01a5916d26d352023ae033b9db55a1c28af90ef27baf26e0f3d009737beb187e13582f8f72a1480c5805b62f9e23bf676ddea93263c6cb1185d7787737c6d740073bc862d2a8cdb937119b6a33b71c30f13ee543070f44e252ffc85f049319faca9e6b783d717aafcf7052f0c72a295466da8a5519b6a295466da8dc47401891d7819060f0d6745e159c9481b8803acc967c377282a04c8e76a3fb45d9cbe989d9e7fbe89f74ee8d44c627961abff82ec5c005288ecbf8d530318256c493c07cec98c713aa40b1ceff527cef1b6a295466da8a48a25e51fb0e531e994c1dea69afd3d7d033b0c0f04cfedfb8461e89f10f7955e87d59004b055e68e23f28049290542fd65ab5d1d50af552219bf1182aea29d4f8d2c490e511f52612c0630617d07d1add1937a17c233209f8107702a0989907eba5037f973bc6da8a5519b6a278be567f323df35b44f069127ebe830aa70004c249ba3f883464789f097211b11dd259ba256f5bb3969438d760ebd3f4f51b749d275bca88e15d5f7ccf6f42f29584dd50d7e66ef923c5d0e8b4a3c275d9dbb41af0b901d558eb08b4b458cc6d0a08985ef74e9fb6931269a9ff4686667bfbd942d9aa0957dcb9d98d13b25168e9e55ee0af9e66a1f7889a6cc2db34c8977743a8822657293b9314f04950f1b6a2963e22a349a1991e5a82a61a952eaf9c96067357a4ccf5841518142027542518e46fd2e854806a869ab7deac748e1e39ea078b80a1fe8b238da801aa92a269f01519bdc4aa3de76f5fe7b847c38aa22bdd2b0c1fa5d1a8fe2d12e74312471edad3cff92b0bf69a7de687c7e478dc4c22dad54f8782de5f618bc99228ee300d2b7cd6959e6a93243ffd855988eb76014f82cbab53e1d3471cc693f26d26ea14cab3bee7a5250eea6c0c21378685563b3b9036da2a66507f25e054c2291208460ec3ffacf85f67bea5b4b3a1d2bd6b237a9c83555d0bf9460f22f1ff88d2b3692cda2e4540d87d90ff4693b5444fbfef8a3072d70539fd9cc9754bdcfe91db4920cef90970e3eca3a5231a23da5437b0d9062d9eec80daed9846ef32a4111e3504a032cd03f3ad99608021104081e9f02b15137bb1d591eeeb4b00050b23e6f5b40e6ab0ba49e8491f40f799b290755e03dd77c4303306274173775a557af58a7eb69fd81fc53b071cda9e37d44deac20e5d27bafd97e136592d13027ccf6944a9990b9c8a2624b05bf156c8bbd4fa5b03553a38ff6d28c79144c55112c6934f6141c55265d7b6b1dd543e9099609071bb8b300c200b0a315581ca9aa1fc54ec8290aa08e8da36ce0762989db332eaa15cb42959848a1df08fb0d1243151c553348e9b0cf57ee5dfabde0967e883d4ececc6eef5360eed38fef1d5b245a5f152702df28113c7e5195c5b381d2fa9662d51c42cf9c8a00fc5fdafca26446f885b164082514d316724544dc8357c153284215bba14035f52f2286e2008178b2d5102c236b794705fac9b0954e38eaae95893b9e01e9e26368de094a83c11c96986d1295c3296878af4bfd568d59adccbf6ccd3397c071b65c1712e0819a67e38d4d488fbe2d2bbb5dff555caf7436b693dbf7000fa7ba19587a3e2454999b7c13345a6b9d302df1923527d807b1b710c391c666e038cde77c0a12ddbfc892bd647b9cbab181dcb1e1aa445c80529568a1e9d9f5b9ae3d251a1a815d3accc4b918bf0d9154068a29e34067f9b20c5b44433da1c076e7b04039adb5653dda76649ebb7fcd48870e835b6b11c7e1dd26261b9e698ffaa19fe360da1ee739f5fc920bd2c1a637d7f48f12dc29b56973b9a14c89df80355e47680b8ba78519ef5ae4c5431e642e057ccdbf8286ba7e8aa91caa4f181e1d9703e60f0d8bf7452e10f841da3b2f2756653265526a42802d6de20c12b1cc2c1975bbc84dbf7c150c7ce51b6a29ffe03db5aa382afcda189facda3bb79616f26c63b6b7913dcd57f060a446e33fb7bbc0814df11ea9c74819b66e1f8d67b561d987e4eb985781306a6ea0ac4408d83e572883790fb278971625d4c3f11d178c01cf452e4cd7e55f321a2fac041bdca7fdc21fa8f8f52523de2aa7e0adf4637354844975b23e2f6736e32014e00fffbc97ea01ef8464b09368becd5e0788a30ca6abed7e39fbf4064fdb4feaffb5708f9d8701775a0b632dfcf738a2df399ae4e59ce2a3a438ca40384399120440ee258fe84d759760c14a2d8bb155a8c996081ffde36d46921e08c4de924f6779dbdeeb52251a02e1a528167679487a70a36f8dd723adab2f080dc0073bc6dc9b221d62a72423f1bc18ad3765e54255c04274d9f6732bdfc78a27c605c7f9bb625adfa25ffc81660d561ce4c77155e0e32c89704995d659bdce62a6b8447d84635ee653d9264fad044c81393acbc8f99809c33549920ab0d15dea53e4fbf205efea632876a4f6974e214805ada64dec581b7be9fd46b1fa4a9c3e7f464180c7e63546487489ce149a74ed1082738da0946b63614365a7364240ade9b4164551171b9bc7386681dfc73136ef0a012c18921d05466da8a89eb8e3e1eb9ab95ef8b4a18398615784a4dd281a562c9e0bde9e7fb5d2a309149f34a96c68463a615f6b93d69dca4df0489cae7302a35349fdda8279b3027e660270cd526482aa01a600461a430a098458e668d2125109b9f7ae8b8a066a93248ca2cbd870bad664e6da8a9c6e6607562893d71d69546805622097830001015d7b77711ef4fb54060cecbaaabdf5371f03060ba0ae0a0f4c1b50b093ad47399073e4c3f8d23e68926d5bbcfe249920a8cdb514aa336d452a8cdb964933cf5a52ccef1b6a2960003adbe9be0860c87e87e873ced2d0e6e04424c424d625f68f5bcaac443b1f22fc1fa349174c82e58a1b37f118fac2dae8fcc22455c667101bf97e9ce43b1de5faa93ccb87a26d40c94c48a7d05666aefb3009264697c26919641d7d9957bf095a8fb196dd0761347aea4204c15b8eff672a2d04657b0a8d5db33bf594bdcf4bd09d1e58f5c342dc381658ea9b502df0ec1236d9e530239ad85edda67210426103d2511fb1aaffcb49988b260198949db2d480b57faf9244b27d5ada544bde190eeeb93b7b8c96482a336d53b8cc3da8715685ece8bde3d7a7c3a6c5be10d7838ebd5a64246819148737ed348511a1828648de827bf3d9d825150c3116ac6bcd83d43491c8674a85542567e2fd85f132dded7c50edd87bf851ca4302b9f3f0695d7b95a7f6973bbe596258e50c545e5bd9e595d9c9800e6c1017b59b019f4d4709fe56f6670037403ea2540a26b4b3a542add4db892df5dce673a9bfed4417a3a6557dfdd9c78c3af4ecc9d18e350c4f5c14765ccb364b44224c86263aafcf588bf0d27a7331d57e7b82978693d3998eabf1de22fc2221a820ab1b33730a4ee4c58ad6a2156d9f4319c3a29e359410831c788846de97040e744be505074b7348ca1e14703c0ffacdd6c6e863a6e88cc798fdc6c4bd63bd565c61e07e20c0d0fa4e5f74dc4857ad6544a9f1cd0e9b0f8f36a379fa4e6cee766bc3c354d456653a591cb2452047bce24ccab1c53de302a5ab8edceb6c99f62c725961a0ecd960ceaffde931e6a0b24e3c584e601c41021c7cef62aeda7dcb2e8e0cc0eac510ca38c3e0dfb9583c99002e5169b8521f2b3e16a1da7980a9c1c034617e53e7ea3aa6fae46635a70cd2a93549239dd4b05b6273689124689f6bbc36d451e3ebe24e76588630fca058d9d1b669d309d399a16a22d225ded3b7a447ae6439f33d8d02b13a1a31dfb7709c77aa4c9aba4b16887021c7c0dd181b85f774606e17ddd181ba1ed94606257dd6da118f4edab2f07fbf68cc40d1062cc86940a99987dd13890bd1963b973ce7b9a5aec05cbedaa1ffc544c5eecdb55528ea770825aaccafb0840588769ee7519dcb98a8d5fb25253cd51e0ecf2a83cd921701279e7a632f5ab0685cedffdd5e388dee5d374111201705c87758cd0f067882714e363dddf335f4f3b624b3fa6e9f30afd96a0a2beb8b504ddd0946d5947e7d0dd539c740dd33f37a5dbb82a06e5f2219a590b5ad2f899588c041092f475e879adaf96dac3b2fb2199dd957efee6d9750d65379d1c5c408d01e8b164fed9d2d299f3c0c0887008c83d37d20c01863037fb09f6472fb1113d4b9f7e1af2e272be1f6c6702ca4e43fe12e600e7abb4b9686759db955c6ace969c6e7301122e8b5e1562af74bf396891173b511c31f1be329e53e4d29408a04381b01f683d2fbaeef9ff019e138362bd022354df33db217d01e91a77e8d523f402fd7ec20a7e7ca0482d1f265cc9262b006a11221b96fc1d68f64445b36d44a22d9f806764a42ef544040109a35232bb95b5b9db546a4648a41de1125f94a64e595495ec12e8b5e224f4e4a3bf9fbac9052ee5a77de7e1dd58f6e4ac0f43f283a09ee0a5dfcc6d72c8b0334ac067b9e44cb7c2743d7825bc1ef6698f820f059925382d13040bc697cfa9566d3d34aed9ef3c9ffb8edde51251db9299f5fa5ebb78e43706c99362718e4748d49e006b5db6a6c415a23b4b2ce8927fc3d2f336d4529e942efe4845cecdb514aa399e52ccb36c2cebc6304874249992f0039dda53319f049325b752a8cdb3dc177d1a68236625c266a931835aac9cdb3ce341519b934eb4aa678771d640000fefd683750f257ba8492feeb6f244dd2ec09ad8d01d251856694527a60b759b8c1ffe947490f677733a921b35807f450ab3d21ce10905042338306168775c67ed41a326f74c0d9ae5f144f1260517a74b93bdfaf7a158e48ea152b788d18c71f8b81c77e5e90adc5203eb732d4e5c96ea8d93a1df504fec7a331d91649219e00ca4f51fc1e914178bfc5bc48976b540aa160c6ff463642374fdec1619d6d937638509ad70bd749a47ac48549ce830c0e9cc188b56d3f16f569e426760e420a25f1a47a044837d3f7b6d36052dfb42f394c85fc90f5354077eef5a8013c7252642081c9f93c3b0abbc30793b66da91a3c071271d95b4194d08422835be8e6aa0854864c4d6ae0f947f6034db464562db9cd36495ae1c56d863f33bbfa76d207bbddd8e4fb579d5e8e675ce636ba59dfbf2c4600ef37612cd4229ea1623529f2065fa85321b9a26d41f1f9851b524a95c9e9a4d3715aba5105ed5e24fe823364fb3b2e9450a86099dd1e1c78e80173cef70025ff699e355b6fc3a899455fb153efece25415e1656fafc3d6fc8f8714bb46cd163740df444b0065ee08b2a1ed8cfaa9d557dc897394c480238d718747dbb74316c09d60aa4bea676b542c8d20d3ca1b589d4214820784910ba00049c281316f36fc4f6c9af940dc0f242566a969385252e8f4e44ec2d5d45fa574d869239dd7fe15009ace79f2faa97c8454f7911fa05a0fca034760d9f6842f52ae68cb20e53055a06c9d94fa2582e17ee77106226914891c261fff15258b5ef4e674424c23c407b8bcbe973a24c3f472cd6f9640c866f8f677417709bb4d630544256fa9d418efa5e07d6fc81996e8d0c0fea41dc9c3aaeb29e8e75f791c72330f3c8f20e154866b22c260da7ee6035a5705d0be078331cb9f3ca527bcd31b642cbbd17d8393d826a4e98ad2cf18a140e11c17a76055c1f44c726a59a56c46d98b8c539e15bb99cc731625ebb5f97cd2a3404bd2389026e442ae1bd33bb42a5367f170b7b6a9d5f6a02bd18aee6256aecb8ec0f41c0f1777392bbd4bbc0f816934ad7aa2c0d3d8fcc31ee8a2b5a04f98fa296d902e7c9f629d1461d69b4720ae2bf5c94872e44d7916843ec7b854b325d46d4dc74bdbf364eb4b0ec7c1bc32b70ca5f6b560639ed155bed00038cfe6bff79620fbc3b3436ef6e1b92ccb5fad199f7cd08675879609c63410f14c100c606ded0c71cee9b4d96803897960d49f5c0069eb68b2246fcaafe8f43fd832013cf0aa84bef36052d819e5ae47cac29aa0ba4088c9b416cc88745efb4165aef018e4bfa1ad8d2aefbcb541c6c3af7c5abe4b248611fecaaab827293597548de15275f4d9405f33e6d9513a111c8e211c9de7e12a478ca1f386eca22a29fdb9161aa713c91650bd0be90038c1613d27d2cb3360f33a35a6bdbab1a8d100cd4069437137f897a030f73cc3e8008d47ef9180a5e41560362f164acaf2a511000ed8a96640ba1106326db9e89f530a5106e45cadbfac3eb9b956c94ff70b2a88455019ab335207868a8dfe74682dfb210d8f83b013deffdd0af54e9e484595c51687154458e5fbbd58e43da8fc4cb8df1753d23824f2fc6a7ae46303c2b4b1a59fcf00d2c6ef57b6a4e7b1e9c3d8f4d71887f56d1db4dc866fe9c37ad7c916bc6a75ebe9f7a82d424f370625dfb3da814c80b43311f1548f45d46700387f88ae76d187a3408ef700c02f32d61bdbc82b2034abc63ed434b647ca52b9ce272f199fe4eddf3cd02f097b0bbf4039ac631b9bc4950583d8e65b01a64652399025bb0e90a856e78a1cc76b0ef6b83000000000031c882f15279545fe3599df531bcef42e1c0a56d5f9c313f3d89ff052f281b4c139f208cc1e19ed231108294ea24145424ed81b1f85aa2ba01f764a125685c5768899be469f28dc32d505c602f8d3eb55e91d15432b4c902258fd7247831df3af529cd33ffb9c7eb3eaeafcce7de2f291aa76ad7980f6dc2519ecfd98ca77d0e5150ec994fcf504e7072ee9b434aae7dc4cd02bedf8f31b4f0750a298651a6c8813d27479c52bdb62864e416c0cdc63a41eee72b339c3e211f68603c9fe01db1645b59268ee465b81166d128b0e8faef0538586238d126f9dbe39c92a5e61e1d1e0560b45a03d358be739433f1f89d727f8eecc4051637ec74d6bdb7fc4466b441fe941bc94afd8c619060cd6b21e7ac82b83af435c400ea4b1f91b532da1c0bb3a8346d50327a4f5c5a84d4943477c1f0b3d45e6ce1f15ed424af58ea25516e4f03411d096f32b9311f1825b59721d06f045e170474fcff908bde3072affe21ffcec7befdfbc7edc67454a7e6266fea33c221ada6076b088fc9d1ceb38078ae9e370538b8ba3da4253ddf3222f1ff54c46612dd51235679ff075a96faefbd8d2c2ee9780974d20970ad9b5bec0a49d97997c6a0b7165d325fe9b650e7ed3c360149ce4981aabb40186c17bbcd4e9df6099ed212201612497cf4ce629fef3d096c6633f43331c20a7caf3096db80e138bee6a784a7b220f89c2fa544d8f506723372b035d72e8453c098a47c132f111766911ccdeb0d2abde2754b68ba8e7ea8d437ef11ba9c85cc81ac7bd00f8c007917ecc8d65c36a33abbd0a6efbc1ae3685587faf388bd576b56b0bc7381805f83df3eeb4722acc1502051b07cd1004f26847440c04028e538ebe4417af206e2f1c63f1ccd5f2da9d98c5a91d30bfe2849bde5822c28f425268103fee6a6617953e97774250f66d555f7da3dda92826b6f39b8234c2935e1400ed624cff59236187a382ef0490129122c3e9db2077c9c40cbcb314c6720d60d0d801bbc816de4c5fe8cf58ff551524110442966be8b70eb50f5297904db18e5ad19108636da73f999b5330f38cf054c2f158026d52c03fb0356e963922762931c7ce1d312317967bf76d57a42e6cff91fb2474c99b7b89be441d500f68b435d2513f31d7468afc92192f26ede5b0b3755e5c7ecb1f48b487e3d92b1b42512eae40110846313e79d4ebbc55c75d9ebfc24bbcab610ff8624b29bdf13afdb002bc9accbcf9af16832b4fc13a3caec25b1f542195f5e6f92f4caae7c44cbf125cbd7fa2d2ab21cffbe634bfaaa49a1e072c2eaa22cd43609eb3ebea9de997588cbf7b2e43fbd256bd203cedb2ad98a0810775aa64e95ff6233cabff8b7eaa2d1822848996757541a54f96dff34a54bf32101e12a254e4a9284133578517d375025244950f7c8d2b971eda655818012958448bb474e47f77a9546b70724ed68a282dc09af8f107c16c63196ce425a49cb191a2b9687f8263c0415a544941f48abf77523fae06c47d2543506961a4df8c4dab79cd9b886ef4e9ad91f9f6a21cfa57ec407c341715b62a50e64410c33aaaf8e1d79a6bbaf7c2469b2db943e9fd4e35556fe13fbb5399ac71b70856689f38f5dc7c116f5226f5c73475ebb1d5b274c5168fa2122d58b52902069c1fb463f20ec58fd6494cc6e337373203a76c00e87706a794155c9c643b2df4c6ee6c5f1b11ebb6133dadb0714de7c0448e823c3ed826dbef7625ed51b4298febcedb5a0e936c16e23379e2547ad3872c82f345cba03b31d6e23646cf0cfd02608c8b05191afa2ca39a1e0fcab2e98a7d12c7d1d1f2065524775d2605b1c30421a69c45155a09afd6614a3ddf611a279aa4bf224de994a24440ef7f6b7eecca9dc5c96f42fc26fb0a7104a819de05382b36397feb94fea469ecc741182793716f3a2f99e10253a82067692f15931e48d2fd946426753701cbdea7782c73af88f416c50cbb898dd214d3ea6ce69f0f27d79f6ed70bf8c9903be63ea1ec89535f91adffe91e6f514e0134dfc723f8c8610f8411dcda38c62a0f958311b126ac483fdd1673ede027d7cd3c46abaccd400d2bc779f35d7b62c64d04120e9964917f227008480c68dc7ea55fccb13c22b696f8a52d95a787f1dd7752ab1311fd1d8329774847df5bab17a2fffc11b525b8fde0ee3300a37020acd9d1e0aa1358137c9be5bf19547521ebb44d8cb3d68ee1a9215e4e261e893a539027ede7bd6c585dc84aac7a6bf4293344cf43cc62b09327cce0c3507c7e84fa49b1c43bc82f72b03d4ba8909f6cf6094a9105ab7ae12ccf90eeaf636222e81a2589fb2835257ae253af7efafde7f9538dce73b31db0144f52070969c8db80531bad44f6e4932592387cdac1357cd33641361e49d6c044104843b95cf8612c0e6bac4d6541c66004ff01d3654e6ecac2900e47018ffaf996bb0a2ec197847609108bbe8d9800864a37779223ff7af5938a61598b50de2e8563000000001202908c28e2d2c73454ad7f97fceb00e8667360c975e105490e7a98dd0c4efd5168cb7bf312d81faafde7e75da402d7337fd1d37f7feb534fb7759041d1638ea3c0248212df0d3394c4028d01c697e1b09713c3f3cfa5b80a1d77f3b781733432f7e40ae401aa6d1483306e2fe079e0bf0d554524255ad33fda804e083da88924c201b04f4fccc533a7c56d09d978d393a11b02e7f0deefe540063c476503b0def974c8bf5b2caa8a034cfdb87806339b543c24087bb0dedcf5c1ca37e99aba8608efa39acc4695544df40e7a0953db9a728f4c830b4a6f471df8b63f799b39c10de85ba6ab660942b8dfbbdf98682b8f69ef84e331eb656b1085d69d349ae4d50a7367adaca7a71aae073f38cca218ab29d3a60e00a7fef191225d3c18934c89b6961dce06448c257ce66ae2c3f6d6d756a29e28847db049a81cc63e94e3c39991cb1ecb12632c6248c5801cd137c260d90a06b91b441ade728320465dbf3e04527b6cf5b1fa2b43a314725c638bc23eaa87f05beb007b38dc6a23b1e5adb794c6cc180fce389a0f9f03afb312f1bdd33bf73ad51a2f58009c1cf5136ddf56404ae8f57f944794c16edec1dfeaa88885f1a3f87f249eeaaf34e83f3d5e4670be0c15664afd17bc0000000c55a8d8dde000000001414ab5c006f1338d21196f4551f183009254563c6fdf2fd9218c39decbac6053dae1b119d91cc6fbedbe2ab34a50cf1151ef54b26ef628af85b22b8abd53577782700aca749e84f01ab95f422f6518a2db42ff9873a3df01f54a2aa9cfa66eaa5c4b63a3332b11e0eab6d6c3e4df30484b67958d7cfca57eda62b4eebdce5dc4b7b0ba60b330a87de9c1e8368709875f8e13e438c9e02f081dd1c291ba597be10dae5926c96118f53bff7f2009464307d2ad4fd03d2d0c0965f63640e7dd02922e67be3f813c7cf4e9ac56e48a73a0a5ecece081ccdc5709f55ba888390a765564c9e0cd164e7ee5605457546cb50c7d9bbb3960daf9c8fd336b0e6d993e096f82dc1e497c95b5e1f9e36475c11e49e3d9660683962897ab56761d4f8ea86bacb205edede06d893c4e34f2b745c3fbe9ec1a4b5c379ebb49c865d0e8e88129aef09a3e0b56424dcd35558a76bf85020bc0e9e0a889c7ae0a22adcf6a24500062368b2f678fbbf2f9749e22ddd443a50d68d5778c24a478e0206464504738caeebb77e1937d357cfa5e6eeecc6b0b81e39fedb98aec999e291a1d75185869c77e84ce90dfcc8b6143d35bb37f67d00bb2e8b2b5edb88000d6e48c00037d802e8bffac681337dd77b23b20d0ba00d451517b0b49086e7cc615207576bca40af42d844e852a340be86cb0e95562e9fb7060d6d5228f1d9cb046a03e5c6f1d62ab1d2e1111546f5ff2d002b20c5240448305a110df7b321d487784631cc08aa6932a26add9b97929ae89a83ddfcd90667e0c6169bf9a60e8e64c1532b9a48d1d5cbd98df55a4b2f6d655d1787b1f12a5906c0dc2b5f7f50fcb27af4ecfd47fb5aaae1cbb8d9eefc4e5c88c9b9bd4845779f21aa47856e002cf145eb2c2c3c7238b5563d0ec703075fc5c69e4be13619023c368d9f13c0c1d5091aa5671b5f003485e54ffd4f94ebe2bccb1b13bc2524457e9433a078d5ec766950786de8f5f29e0e72f9f5c0b1331dc8ce171a7671bc4ff031cce8680bb248bcc5f80db46da245f98e5c76a73e36efa3d45d7adeec1c521e33082b5ed5fb332608de3d7447720b37f425d6692332a583ec9f8c9130f9150ae07998bf7f719303840e2314e7b6623cb205ee08b6ade1bdbd4d0c117a023089d7ce1dd5c54396cd1bfe1f4e252284f678bd687a9a82c12ffba21594095d431f9eaee1aa0113642b642991a76838902395b339a69aa7772daf60cc3b2ed1f358439ccc64bf6610c26894dea94b8c293f6112830fbd23552f5d820ae826259ec9e988c7bd92845bfc7e2a30e7ee0a63a3df0f8abadb1cba3d51c573498a3bf4cf9553e0a369b439fcbd2f6df52a45aa14cf20ceccba586f632fbe360ebbec80248d3647862660ac25642c605369e7115d011710e0daab0573b530ee79a3853f216ff011c58b5eb0b43f88569115c16a64f5c6abefcdc285f75b9b6a122c347f9e475b1fa95f044c9370259f33dcd811cc95e855befe52c9f2253313a613d30423fdc95616d6fc8ee7946f29ab0a8b511a22d3846961598483a24667edbdd5b5648845f0cb1b3b8e8b1cf0db90b5720d7d54afb9fb5ba522e80daf3ea7dbcdf312eb9913e6d38e397e1fe8161edfe4f438657e55ea2f52ea09fd65a7f72872945aef9f2a4f52372a6f6ea38949843bc26bc14be3a378f4cb1194bda3496e64617e6c0880295659ecdd0b6c17afdf064651e80034fc68bd513fc279e9a3e159d7ab4ed5644f27a92b9a49923f70cad08fe87ed4c856d869a49d8862b9ff328cbd264bd2413bfc8e4ebef0b453fbb9ccd394493fab10a600941aad3cd971d8a5b7f2f0596433c2bbbcb834c7aa84b435812ce4d431b29365022ea597b80438de9147d35c5ab46118e845c2d10f6c24b2993b811ebb8dcc9f4a139e86bc864bc2efd48356f4863b1edcca3f582d9dd11e0e3d13cce1efda0f5d17ae9a17ba41ccbbe1bb1902537f830cc72597df99f6ad12b61d7be5e09c77499a32c1c18568084fa87f77e9f6917c6ab820ca0103e24bf3ed408ca022d31cd29a4b94d9e5ac18dc3b52f3eb784fad809185083c05e92b3e91547e6d0f108bc5015b7db6437444a88a5ceeca7d5817d7839c5d492883bca036cd7ebf7f4e341493917e08a68addf4ecd696822deb885b1f8d2794978ee303c5164a2c9f4071660fc7b06c658ec71215ce919f5b073f6f6e6a249a23d87df15310f47ae13bd1734031808b7912897926ef2aaa681b8f0d75bcb3f462c210286793b1ca64a438975eb7966d1fb41734f06fb166ecc5835cb891299398e001dd0319b86385d4df3e1de800bf96d51bf840f3c36493d1db39c91f08d573dc9a4aea21d45d41a3c87a6bd39e978f1f87393bdcaec7ded2cb11fe9669e899a439bf75db08a7f2d330d714bad3d9dce129b60aee62f009a06c117e386965ab23ee32401c592f5a068af86466108c56cb2c810cb72935fda986a9e428381e83f72e2e481c46c38432944cc092407b26cab329033cc5e7d140e2ab430fd79719506c3dc77be5653ecbda6552a53b7166c2a9a6584e9955169f827763964e51446e318dd73f760267ee97fc0d4007bfcf2c839b330d5c5c3254ad1b7c7f16e1143572a24c132dd141b9284212b79e9b4346db12a7f0d2efca218d4332da5609a1cb41721bf1ba428768d8a372197355cfb65efe72ff951b1802d0eb6b410839756b05885bc1d11675647bd9ca0180c18d8346f3a7d18dd4188ff68dcc740cc1ca8000c1f81204798015841fa032f8abfd6dcd9e4617745d28187662cd629af610a9e1565420ac861835e70dd1832ff839bcfc2cbf60fc86abe57f80a11568faebc8d656c73953d893476f54f0956e9ed5da3ad757a47229d23c4828fa81e63ed414189125856488ead3d7dcbf6b1ce5293460e9ed656ba4e492a915d4ee5945f681d65165489f64a8e752c895082bd0034d55f88f1b1b9c6492a75dbfe51dc24cd75702b1c238b359e33ccd0b74428e3e3535abb034e0a3f5bd6ec5721ad3af0d428b0ea14ee6be1d5b7c22d1e26889c450ff93bba098cb019ace5f799e23e71da631abc8e626459ce6edfe040187288d5e77571ad2404bcfbfa9db248bdf9e797c4c94c4261a1f5e178ae880796e034e64b27ead05fa140d1f8e1f3c44cb58236b82f2b4277776b1486d8cab148f4b5bfd74b959a91de69a8878550f1ade98adad7fce28a01759215ea1df17fc17b5daf104f444fc73c6d82d4fce0941b4168cb406acae7511030a07e760dd1935a830a448358fa71f2cfea44e5fe70634ae3d552bb5edbcd8261dcf44602454a010db478f84ca15e483791a84c3482dd4a3f979ea1605df9b4cffd36be9a82c6e859155a47acf9dcff343cd12a380b606741607ce319841912df4169930c1bc7f399ac325628fc52f0e848e36bdbb121d1afe7bcfde7c8b4bf9c67fa5c7eb1e1193c35d08d756f5948245a9748cd9425d4cf515db8edcb74acaf1e94d256f42d8f53be0f56e831b7378769e9d465851637f921ef704e7c3539a88fa194c05a98141992db33ab9740ebfc04bbe5d4823c476879a915ff349facf58d9c9efbde8b6d7fe3f9046ff2eb172d9e2f3152c8c35f1e5c8d671e928755491e0a7707667ef051de8e2b3d0d4b7b920c5225dbbe30e76ada095c8fc73b47201ef22388ba594a5cc4cbf53ea7e32fd5ee44f7add6c4246e06c8356ec1ba06ecf829bfccd0584c9dd4565a7b8488a15487f2ac1622983d6dfae4c7a29e447232ba530c5e67912786a4172e948a361c812c764f071008ed43b6ccf90c2c314a2bc17f3de4ab51292f8493db68c13d3ca0b72ddefe97a5ab449cf5fc54890839c9b0594c4f1bc5e6fc2c2dc579689af448342bc2c9a0e37334acb205f246bb060d9300c9e083050f0ce8e6c48c924ded54b4ec891be8ad1afe29b9e55cb8bd11f49314d33153f14a0b14a39259d2518837948087d0fb3a977ec7a57be206bb6cb48e831e11654a0503b033fbfc61f1ab8bb1cb548fbe142d5bbd95ed8351cff3dd1f7657874e754a03c6bc4a94f5ae402c4420bf735813cd5a3aa5f43217f5504b133a7077d923dff805840f7c949d04f1ace115193720da6cae3253c9ee9caf291e270f90d357a794b98a2962f014cb0e7cf7df2e1f213d7ec51153b0a9ece5f7d2e87f7a07d60fb683229cdad67565382e3f9071e656959eea4ad1e47863ee9a966052abb297c2cbae915c14d1347b46eb3d0a8d81c15f218a170164bc6ad439174fb562eda9e8544e0e4ce1bcca4416575d4994f84e446b62d9283a2f3abdb5b2f80c6b00ed26e7a99b0c3490e9d3099d88818e01d0687426be37f0e18a629287b6fa7e86ee7524decb01b42c68a168eb7cd5d8ad1a95edc32cc27543dc2481fcd39429e782246a19641229aee98a7eaa6398618d02ce7d4e324773420082b1551266c28d4293c975d4a8110be0883415850f8af12314adaf0f5251dc6bc68e34bf47e4e88ae017ae011e94d02e9c274025605909e017285aa5ed0e51940fba68255b8291903efde9d2043ccbe2b632f6b6da516f36c2318cd8edcee6d43a6bc4577562537657685beb205a4741963f9dece0f8afd86a50bc8133865c51e5345cb004d9b24c44af263ca9fd02ffa4197b61524451dd64110576bf86d389e88a85cfbeabd67e7a375304e33d713bb769cba86a5954f3ad6b9da59bf1706dbfb39899e1150b1e7ec1b3d47201ef22388ba594a5cc4cbf53ea7e32fd5ee44eca3b9c9fb5bd33dd9eb46012356a83907510e99598d9e5c5c14afd809ff2a9d0e354c46a2fa1b2ebaf34c3f93faff377d31a4b58e44678fb27d933d443d7db8752708ea58663907555df7932c4db500c509be17d67fb9d6e0c7e50002f50d50f007b2639b6e3701d9d27d5f5dca88d34763ecb607537ba4734dd29d913052d7380563c5642227e233e46646f618dfdd23b49b9cebfdd1cf290b621c6324404720cb07cad3889a8737d32fcd5f79e101267a4000e6f3646b598a29b0727754859e182b3d20733d9f91e3112d97b20c871d8ef66e7816f437fdd1a08e7bddb3dd3b8f88d8feb8bced8c5e7be7629e2719ba3d1a30366928b9c4b1565265d501f6a9edd1f438b0a10f3772a7570e1334f56a37afc5cd30fcf025408f8ce0e3ae683ea1f0dc7c26430a2ed8604441ced8b4d51ebe7a4f14d548d8a7413d501f5997019dd11ed82b28b96e801185c5b92ab836f5f281b91c85db9361b6cd1b48b2b8fe15ab4776f8539754618a1578a6d0e6df92ef7d6e2361e8c407e02f37cd4d2ea30fc3c55ed1048efa3e8f5374d08df0b1a1aec7f23f350d197820dcba8f3975ba86a9197b80562b07d3de66510557d4de9c8428d716900730f6cb3bb7eba3338a3ff4e00965e465b4db71bd745e1065b33428305e4054c2f0c1aeab72f801233d7af5088622a2c3ba7bc73f572c1aa8185e2ca31034b55ffaaea3127b0da0fe05368ab5eae771c7d97293f4b89b5ebf8f7e2c8216ce1d7151bd07c5a89f5e792e5692e0e731836dc76f63a9e4ecc672126fbf2927fd79d25e1a933151dba5e7c604feaa17bdc2b10355e2bde8b5b0c8fe7db7c403e88865bbfb2171f0e3f4481373e90df0c938ab1ada47d56daf89c6a8b6d43d6b2470c5ed9bd71b876fd0b3061e6a3ab0d7b85e0f72379a00db3d4cd250569b441e1f877a3bef9862a222a8995cebd00305c1280fcf31e6577e1233a1948c3a520ddb5a45e891366733217a5c4a5eed67cd8ab4367c146529c4c6d19116853ce0f58c96e3c01144023f09e4ab8ebb196e6499dad85f66d6f12483649c2e1fafd9535e8a076267cc8783b9864684f7c71e1916beefd4236523ffe6ec4ddd7c2e62f01a9d24e2f5c149445d06b9c17b6beb43bbef970ace68014a819282f37a1b534491f5654842f7a6c880ae796da121053011b959b4bb7829e2d9759dd7f00e6dbe3461f338564b2768ba7fa21982e1587881f090d3a4978a16915701ee2919a563ba3ef72d7a3f48e200e9fddd45aaebc8c258d754ab65369a6f08f75f6cc567dd8ab16b2b18ee18f0a7a18acf8c86c7a1fc410368e429a214345992410122b064c66eb4e66ce781819a9afe275bb616078d1b075a8a2351cb2bbcf6bc005847ae90d2947e48c54d8c458cc7e077448d9476c0c17ef197a5ed708007149be12f3939a527a546e2a94a0345bacf31ade86ce9ddd85bd0b1c0c0213257f80f39b2b53d5590a9c17cc8c49888bfcfdab148860bbdb9c3e766c65d7ca6a1e1f984f5cd3476203e6939e589eb4152c0abd7e550a4929818571dc2d149058b2ae14cf1245ddca368240b0f553aaf662ec2b83e60758822b55d7b8c03d69d1f838db692dcd15ec4ccd3004c9b5abd59f68c646e64b93e09f78ed8eb77f374b034722fc7e669f32b5ac7d8ffe53028c47c147cd785747c911a44e63368518df51647f400df2227f635072c616d18185abcc0de031ab3c663b19f22fd60cb2e28ab9ee860deb661448c0c4c745ae5200606498982adb30c053784f43c0d8eb46c8f619e16db14c4b1c0e42de0983612ed18004efeb5ab1c7688dab60efafbcebc5f8a98014ceaa71aedc5d2ceaf04d5a25c2509f818ff4d5fef5e75ba449d0a64983b5ef1273194d8190dbf22f45066bedff2d16816b81d9a72e0fb03c784c68c1178e31c1ef3934254679fa5b8f8ed7515cec5b59490b128c188f8fd0b7f94814471a38a02067217336f3bd2039e28b6725a0515c7a9055900ec3ed7b3a2ee2e8c30b0ecdba30768e75b9a0e833434dd22b2afef1bfc35fac8cc91d9c149ce80689d5d27ee648ee288eb29b17c402ba7f65d57a905044de12f6f27ce251b1d656f5c54a121e88d92696e1a2de0837f741fbb2473cc90c1bb150e85200007241b7379344ce82a94dc798ff67d7e97e8003c26d371d00000024acc002e8e60ef36bc48e419158f5d7c67b0b8695f21017ed72d6735dc79001b42e2609ba399c97a9f7812e3ffeb350254280cd00602ae543ca55f2060000000000000000165642db8ebb1205ec398f9c7393cda73b1fee055102579198080e685cd4dcf5e1a317a7908bb89a261d13c9dd7d1da04743afd864d4a53f67bb577267b14bcb9102013b11fefa38ea47d8683cf3263f9d72fa6f2057c34ae084a2311021fa1f7aa5163d49fc95e4b43bc87af050b9b53edc1707cdc560415c873e9d04601405d86794a2a5e4c693fe2a19db851a3f57212d9fba725b8dffb5cb8b28fa0c789f312ce9d5b18a24089a844571e9794fd861a864e121e05656c6c9e31a29c10aeb12bc4521e796c35f27c8a84055352f31070fab79e294a8f5048653ff64735b6094025d03453252da4732bc707aa8d4eb0f61e24c491b5d455ea92ec9df191c08f26d0d9cb0b8062a1fceb06704ed747fd885b8121f078718bdd2a7a5a69d2ab11120aa35c59d62472ea26eabde1e3e2954cefbe3830f3339bf8d885cd7f4c468950bcaff1949f05ba2e6a9f3c7f9a004eea8d3862120e363cdd99b53a988b390c2a0714f6b602a3adf8c8ef60a42f7dbf5e3b5fe48a2a9bf8360f637692a32d810d622681734cb478f61bad97503b42d9ece2433aa2d631eadc54299d0fb6dbed8dc9e3c10f0d78b4008c98b7ff0b23b75587e65d18e1f2ac6b16fd549a63c4d2f6648d7a2bdf8b7bcb4a0ca8b69c8f281e2031cd5038cf004b3d577ff61ef140cbf915d0c5cb0e45cca0210391f02e51fc4d055c29d274a094c299b904ebec2ffd7ea975f9dc1d41ae247780ef1182ab9270c41d08589cbccf29a5a8f5394b3088d554421e6f4073455233a1b0a4c93f27cc1125cf3c9c95a7ef65d4617fa054bdcb0b637a2efdd3c7c6d7ceed9505da28bc39a2141a78b67e839d02a9288fbacc3b7cc4503880b9ce57cac40b8d69c4dfaeabf3fe343785018c7b53cd09d28c460e2dcc2b770e745e9e67457c683c62c72ad410ebab242a1d725411fd51a331b0265e80174f185d56df7a9c16ea63a93b967c45222203bd2e77ca10982f6d9e5d2cf619e3919705e8a2480fc2f1f35982e6513745ff76be95e5869962f442402baffac3e562521013530d720ad7280e145764bd16d2914e1af8100800fc3a22fd27c96636c1ba451fd40f8caea7138e12581a2ec7a2ff996addd6e9db5fbd9665c5c2a91bdd7134be9e9a1ea17f949c00dfd81b318a701cf32e5db3b4e6c506781cce3a1fcaf9904ff05b27627d11101c0f9e9036f04d32314ab21f566bb1e92b6ead517903d68f7141ea078b63697b3fdf6009c1b23c9d076bcfbb4a368d1c89243a63ecea15a597c664baef115482cafc7f5a9bfc6effdc644da16c9548dad42655c739fee9243561dadc199692685b8d88d74f03a0cf6bb521359e4240000005f9b64234047cf9ec21c40fba7be45ff65010eb2b9e06d6cc55783398da10fef837f1463253c13356af2b536ad719a73c2bd07515c620538e812ba983c6e48678eb939d93d23c467990755d9e6453b0be357aff92c931ef1f6b8f0dbd3f9ed8d6080f3736edc2e8422e89f907ec4adaa94a0a1bb890706952c0a0ad2de4efdb04921a4138bf59e119b3c17a9c880cd6447eecb3220e3e8b3f92d8ad6bbea5fb9ef77208ea95bc2bdf6fd8e69e4a9531d4a7a993c54877a7a28e29b4c5a33203bbd628451753de6509b044a21c797f68d36105e656bcf817064bb7f33412c46080e3105c2a5afd6856622a468ee712223342518f9e160323af36c48f492126dfc7da7654037764afadf7a151c01d88598723692d26f56be3edd783583ea4c00065cdf3017198be542eb08f38a64ce7dd82fce8e7e58c6fc687f58b62f467ae032139dfcf2fc05de61b7b705fb5ab14faa84b4061f4925120efb35675f4a53222a7b87e6c63231c604e5826291b30c493bbf44931105fbb9a8785b76226c9bb5262b8c8fa8ce94efafb649b615d24282fda160546a7110b8e1d65823b0efdc9dfde2d90b27350f008b46243d1fc64d48d1c916c681b147a0f1b8dd5fdd8ee088debd04c4df41ae426521bfa26c24966c580e8084530076e174bf47035da237a359bcd4c8564d2eb25170b8cdcbdb519038767bbf6140a55c9dff36c31d68d7a89aed3a1c65aa471785c5d7c20bb522b0f5b03df9e6443fe5ac9a17297e1a3935a3210ce5cc76477acd6cc3868587151fe5b5b0056961b69f6eeacfdd307dc0b2d1a952f078e7ce3d55314df6c4732443165730d23e521f18431d6c6278402a325f814859f0b309dcb0b59e2a26b928cd5e1e960e786b223f654d438b9f1594031292b6828b4692a14f205cf44385f304ef109183cc4325b21e5efd2491f68b26e65d60fd4a5b7e00307e8f61cecec489f04e88f8b4cdb84c1c10703ad54bc4deade7f5b0590b24b91a4e006482d23118ad185d141a123af584bf2d0daf0a8dff110d5344994baa6c3bd840673ad8d132db4b0d7a91b4b0e27ca7e41aa131b9ebd20a694f7d23a434735280e31d689211370d732b5fcc22286090d17a642fb4edb8750e90e909ee409c711907113fcf8000000020a683c26b994329653489e9c7af8e14fb0775c64a97bb983061baaa0dd102de15920e3db0d59e2dd1cb697f5f675abd7c21ba477157695f887fc7092acd95ecea8bcfc7a7c36e54063ac97bfac5e8304aa068b66191c15f7a19bb4322cb7cdd1f3c74f3024aa2a6b2a317c436be56e183d6f1fe6bb4395276d5f9e055bd0186ff0edf528c912590488275828a9341703865adeb52b78b4733a3da331e9e808d3dc10f4cca95176b6dc375578a6d467be73eebe9077feff4081d226ffa1cf80266ba40a3bca0ce9cb7ab287313ea37068a3170a69e8cb4b5621886ac6496f2c8a73b110da1e651bdf85aae6983d476e853a4a251e153173833dee5795236093a066fd098bc065e3b29569bedcf3c66dadba9d87a0a4bef6bc9a462e0cdc542a23def7befe65b002b6fe986e90b1b7eaa0a4cd4a3d1549032825f7efc0878b3f35e26853388a0a7b43ccb67a760ea68ad5918e22c2effc18d122531c8abf261a4129acacb879ed487d3b48b8cf0bcb23657244899137dc6ee12aba6becfd9094ddc572ebd16acdd466b02f86a0b13d98f120dbb3e11e88780527f018cac194c0cbe1afa6fb8ae07e607dd48691b5366123d929397143b43171fe43985eb0904c1c91eb5f6d1f657103186b72edef98db781f8f570c75d0287ab138f8c5c5b4a9f3bbea5e851b7f9937bdf866833807b4855dd2249d606c58da7471553ac2dbc6100a68ec5e7f8b0492790dd0a8510e97f7750d88d016e469c462566c5275053b1079eefd180cc252b265bb1e97e10a84a4b3a62e5c7bbd66e1b94480d069f780323eaa20b649b80cd1c53bf14596b3e61e2846fbca2a39efbf137314b7fbc894073337c005c1b67256403801fd58339b2da6199b334abac470feae87a19b53e2e1eb41baf9b33694efa9f5382e8eda732522639010c36d7a2176a14e1c86951153eda5b507b2bb9ba127f25c4ad6251195a63f777d40e3ebaa5113ca53a52354145c023aed2432e9e24f095158a00e2df3e78d6fc91eaa65c20fbffa899980019b092610acf43aba33c2acbb8961c07c51959003f787431525e2a78043eeb60d8be6101e04f7c424b84a25dc2ee5beb45cf345a848409e73352e3f57c69ca1b27981110bed1401c83b07e01573bcadeab47619c277c2d40822bd1b4d06523405c10450b6af9a9f63712074108da537ee011145ae8bc9fb824ffdd3baa27e2559f808d0018210bbe6acce81492a84e84429bfec627db60c9a88baeca69f079f0822261a905805247f2f1f3f113e28d8244fd20eed67397ed5a48a4d11e114d74c1ffdfffe33c8a8dee73d1d2adf1f252a07c6cb2c0706372173c53bafacb98e560de08b680c6d1b250539825e04328ad1fd0a49374cbfca443c8121ada81d32aeafb60eaf118c12e14675b1abd02785b20539adcc6f98aceeb67fa671b4f9c6f974fbff5e832a843a05b4756ef8ed15f29b64e18e9cbfbb0e379d5dc75369d34e15cca2f46292dc737b3d65f15e9c28bbcabc361450ea04ad8ff621070d3049c8ebf516519dd6fbb3a524425f0905675eecc3644f891c8eab5c43d0382a34deffe3c9229201696e333ac1f387eb04918c968f9649899fca90ea58ce6c774d0819c90de81fbcd5fac59e3edb4d4ee594f2172d9268ad24589bfb66e2a4af721781e4a95e6bee436f1ec02921d31373a645cf345b9bba23b6e5050b7e42b14766fba993e18366230bacf0866fe2dde65926f5743f2ef92ae2b7a03d9064380000009b005facffd1a7f82e292e50fe62f51c02f63d4c851b4f4524619b700f207a1c41334e484395fd38699cdee1713494664d50990700e3b2c83ee85d207e341d473ef2542a0325f27d85b1130bb833240b7916f6e8e15c2c132b286448dd99df255cc72013361737716505552f3cd294ec02c9d8c16767584b755a9750972ac47cf0a438fd2ae07fc804b8950697b7d1282356550e737728f79cd5f45515687f31eb5dc673f603721ec89f41731e3677479c6dd09dee70ef71a1b28774228b25b06acb67f08f6b2d9e5ed5d9a4f737b624995545eaec6e6511e406743a25fc8679f1c917b9f9341943f549f91c02d65ac58d586b16e6e4efcdfec1f88f3cbd9010c0b4fbd0d69d48e3b92d9f08c89f8697b85b764d11be4a079ddb83c6b6b5b2ac1c7f91104ba3b50d584058a43beabd4d6f6a70ec87fa2ad0a5fa5cf276dd59084ccda9aeffc4297923099df939a8ad53b94a17c52521ebabc9ae6559f9d9c93649b4832977e47844bd13a8de14d0369d6acae4e5228227f19a53f7bd8bca0525c64e9a5845a55bf4cb10404f7deee25dc3457f463bf3dff200bac5557fd593226d33cd44cd291823dba637e25c28af56eabf12aa5aa9e82d1a1c00004181344153a1f7a4a1dcca0cd6f9ac3d3e44c155a42a479770ac44d91b5c914bef6bf4d975949783c059660e1607dcbaf0717dd23cfd9e7aaf3abba12c13d6662857a402d04b7e38acd610080c007fe06b5da9a7e6e736217feabc237aaf0d4f71b93100576bfe62504e58ddb4fc2a2c6adf396a5f51db6bb4d9b18275a1e46eb7f2062005689914e9f341f20187aa39ca7b5f2a433a7bdc6edcd122fabd550d550eca719fe0753b3fb8df7e3da30bcc33240981aaeeb1434f4931bc9646cf03a147c2ca18c895d5e52ca785fa3938702f6b59533bcd736427a7ac34a502022b063d5d5649fc2fc4e25d3d12f12d6dff65e48831dbe57185d51bae43c68e8895853501ab97878371dacbac1b0d2f03df9a22848bf726bd70c951818a70207f35c2391fff9a40bb94b06b63bdc777e38479aec69d4c7018985be7f194d734b8669fd389e7e7a0852fd6062d5e6ea0d5f048ad7948665f825cd1041cd54ee1b20a78fe49b738978dae787ac923a529d0d98051d2000003ff6830376bf3b4a3f2c9ab01e9764cf175c407cd8ec19ecedf57901062cae050f070218204c1b35d4cbd8f7e112cac438a1f5f5c82c7c25dfd58d909507a86f039eac41bd95189433acdd3048469eb11a378db8ae2ade79038b614b7d0f77771787e9ac284115f8a9971bd0bfb70e0a00b2600a32e38c5e505495340981422979d9e79f0c64a008e74c1a45065d4bde12656f0d4f01882ea7d6ea9df78cb98773fb54a81ce80e32835af1c1d3b8e90f19e0ca2ab5936e8ea441a2b0faf3d90fe45dbfdaa2b4729e855c8e71f8942b63e0909b6bc33ba33a997ce7416318c6a23328eff434c73ab6cdffbef13a12d5beb3a38061021b7559638713a27b0549653ac98cba22b8880330165eaa64e870d4dd48d996a4efdcc91acc5e53bdb36362900d6bdf90ee216ac55fdab85ad549af2dd977da37e7c6a49060cdf115d7beb521cee321a2cea928f02c5aac06ebf0fd00039d8b562f0cd2c0b76e6d661379a6138b4eb891da8034aa86044f3493e99c13cd7a78b31f13e9666e55c5e40d24c2aadc79288bab3de469db9cdbbc6a53ee602642c404bace99ccb8c477e200f0146941c1e9b7659b2153ab946ca59cec4a06b438dcd4b05673c8b65d54334038b6591b070bc0be3e5d4a702967d6f7b1a8e4d1d367c80d41fa9b4c46edd704eaacdae57374789c26691403fc4349388f1140c2b3a4a0e4c621acc137559e561f56215f5bd00df895e97ce63763c387d93abe44849306f78492f1b3f0f02b3d2f53bc0c5a8f5cb2290fad6b3a4736a8603aaa45e0b000f87f2e3c2801c9aff34c3963f3d947309f5f8580ffc8d7555f9b2e8f186876c2b93e20f2068fdc161845fb8951011ac03c701991d510e1a0aa14bf6769ed16d4c19280ff98bb3544e4317e32bf4296c96c0d918f7ef4b7c97da69717d508c7b300163a533be7d2834068f12dc243e83686081302dfe6b11348573eaac29af71553a94f6ac1ccdc6bcb303d0b268d81f296624b8b4a368d167440b3e96d72acca2c2f5bd5d1abf9943b62303f251590c6b8687d2c9464a16700f2a613c3b3f0ed247a61f914758d5411c78202568f6b1e319e58ed8fcfaeedde6a11061b60be5622cba6bf8b86ca71e395dd11ed569f478c3731064479ed761c131d47f4435c924fd01ca83509b86bbf8f7eb92485ce1badb5c978d5e3c945edc6c9cc0265cdfec711ce83d8d3c3e9343b78991e88b9c8df7c4c8ab739f904374f9f863e9c9ccc253e6e7e34f33ce7d75ae2e0bd6736c6d38441e087088467936fd81aed89bff2575f833445015ab4a95567ecc3b56438b4bc253631a859327fce60384b5cf689fccdf89c891fafa8e08e47dce95fab98ec7634e5589ac04284c60aaa987979787e7cffec950df209a6a021393974e67e9670ad2f3fddc5175738e4b0324559f9cc5746b06e7ee7e7bb0ea35a62ae3a28ed9678f823577f55205dd3bd13a2ed5fb62ffee5fc7dc18010bc0abc43ecc22ff68b4927056f11ff970532358957b68d35caba28b295ff142f19421717eb673a220764e46ffea0a0297bd1b2643f3784c2b68355aee684ee98e07b81e1b610af4f9cdb9731a5ddeb755e4d1e38f815907e049af09a4db6df24cfdf954fad8fb0ce1ac0ed9df3bc9527a49027ed9c23569a2ce523523a06266f5a37dfc991c0bc7231f80baf724e8ea149a24bea08e34c39fda83351cbec3f38f86cd6d05b9c30006b815d6d38a2fb5f2bb2b32bfc05d5323fc24f05bb42346207cb5a371b2ef73c7a65ae06cedd13399457d12607b46a26c89436482718ed8fa20ef4382d4d2784f20102ade8450fd792c954ed45576cbcb5f77044e39db3f052535c5546e9ec8d14889d8eb648667b1e227772774db3a8c80f98a3484436c50652dc3d2fd2c6839ce9a22d38471bbe37c67d852d8107dcee7ecb3836eda743144d194f66d85783dc5b77d4161ac634ea55308d04e78b65b0111d762fced6720c32f00ae0bdb72accd93eed0fc792dc12d699cdd7927907919e961b6d45d2948cfae2545ea839ba713211be44fadccfdefe9cfd75934a0e98c544041f4136ca8539747dded3da9c20beeff00cb06a84cd964d6fb0de4890eaa0b2acb0537a29209f07d2a82c7a78e6f4ff44768c3accc4c3d11652080db289ea1e8a6804b6fd87512a3ca3a8de60dae06b0c966268582acb34b2016298ef3884c86d5f8f909322f950059120ac87f12266d7f35c24c64263c8f6b4e7b706828971d25650979c1aca2382307917ad2545818c68282eb407f88b4868d7a0757a6bb22d449a351cf67563d6837195f86b4ceb34563e4d861993240023c6a445ad5ed00088cc927f94a3b391db6e9da79df8bbe0a01956892252b768060c897935d8f464ab5c63766b1190dd6fd45551d12cdedcd79184e86c824e69b58bc1be2c2d844587e5e869240208022aacc46feacbf77eb1ae989ae166d510f577ca9eead41870f1c99e113a6ef32eedf88820b973650b6cc0d1ad8a3ccc2ddb1b48bc2414b872df0e0681a72fc66cc8a10b0c9f736f0a2fa06835af21ce54befde30b2b880028e032927954bf62ccbe5118bcb40ac22e9d33a7066f30f1f55b94e603fc61385a24dbf96f6f41681f529062365ac07a5dd9b5d2b879a0a12fde4a32cb0383007937b8a2a2081a03ef2407688f81ee7dda024d60e1fece4d55ecabb7da8cce9364006633fb471c2ff30547c9aa8eb6ca6cab487e2067f081172153d28685db58c4d0272d9b8b70bf17c5a73e71b2de5a9cd60d8949a282104189f44df8fbcb3b7755c6a711fc71844889d6f6fd445a8732877db469bc8cea3f8b79a758ff47e191705bbf4853f20891b120c1a7904357acb484171261c89aba0abe53e6b5f6346c94d0a246db20cf71328513af89416fae05c0767d949ee8a4b32b1a03c101150c9c1ada574bd08df9e4322f39fc58a3e0c2b074ab2d61650191b4832e910a88b4c83f2cdf20fc743f2e1aa06e549dc7fb885591bf3a25ff01a8f0f8d3aa8198838e9a202b75c84009420c3065c1c04bf081eb327ac32ef9cc48fa47c4b4801c05fc2be5989da7717b2ce106e2152c67d3bedb653d802f40d60c24bc675ad1c4955312832eb4d31649052504de076f1506dcd8065efaad4c79a146592b9d2179749f07a949aa908cfe2ec1e1dc5c04b102b9f64c4184d4a25d00d6933c5f89875c9d78119e2bfe2da591256d3a133e12f51f35920986675e7054e0c1ad7c5161072cec0ae76a2a44f2f7374c280369d28a90b2ec83609872c68bb070ede2ed633f2a1ab8486292d0ce546202c66236a98668e207c818a249e5d82f6b7ef0ecfeab2491fff3088e104eac3191f73d164bee2c91e1b374c8b2068752cbf5051f5d2daa1ec9784421c148cfa9880b077301fad88cd69f01dc8f79b545313baf78646b2462b5923f76b15152af92ea64ae8d38a89ee842e579ef95d513945dd718e9ac08e42bc22f74fde4b868b83aa644a363622a02bac7292483a590aa77b3613a41a8cf022247c97400a6249c1c4e161cb70cd9de1903a58409972c14c00328ced612d78eba384a4b283c773a91b61c8c77bd3b24017571b112b644bbf557fda6039125cca2c46cde60c44b582854ec8e0c8c97e25731db341aee6ebd923858a9a838b0b8f1b3145d2dde08e30a80573daee3dba49f76c2d09664de8b679d8c895006b74d8f5b24c94e346f6477fcbe2229be07ebf7ea8d087b558e5a27830ad730d5fa2ad1266e261835c8223995e500b63bb1214884bc19a5cf6a10e7347e625dda5c140e370b19c422ca23f6e2056079a9881ba9d7f101c4f33d773be88edfeb1c6eb0a3499c5206c063da1119f2f26c20af43db58a9ead43c292bf65cc455c5c04d6051a3fbeead62b9f3540f29b24e4ad92f27d5739b5ed04d487bd8f04754005e9a3180706d736eb3aff90d1125f614ec32305fc0cdaf92c61118a6749d673bf62f8ae6ae9b1dd65ce4827dd740e66708c0188fdaf4f7b90bb6d2b389019c5f4dc5f593c4d5602d37668f7979c2204f825b65b39f1037118b67e9bcc0ec11cf680143345ea973a784f0139276600000003a16ed18d2f485f93f18a29fb287edcacf047c286e4477e760ba9345c371ced1f44b0cb1bb091fe091645e554222a5ce3aecf39c4fa54fff6806c11929c7177e59d01ccde4c26c87c98f762291c652e42ddbb375c85f1402a5a752d4ecaafbfa74e642168726da97623abfcb1f319908753d34a41420bdd18c8e396ed90abac34f082d3b2afb4082dd215a2931d95b298c9c814f839d78feae4cbac5706027826655573a7f196213c71b7ea1c584fafd611af5da3738dc98a8906d23f478a84922fddb66808473362ab4c4eaa36987cd3d38e786b1b65fdda1344d280d3b8d2b739bff56e3182c79bd82dd467d5d0aac62048e7ee1ed7305068731756684bdfe982529cf9b134d6925f6cef9bbe2952a6e9d623819bfdcb9b314294856f5deb7cc57aebf5f4699fff6818e941d90f531aa0cb55237750ff0a539f94dd84b18661aaa2b6ffac163e5777f4a4b97b89d1cb3c68d08c60d6213f50e7c60f15b6c11e5c08a6210681db00399ce2315a27b76a8fd2370ad70135f47e50e77042723f06a19659b3ed9a6ad114066772c8d40f0430876e6bda6b8630c2225e8b7b41f21bd23c7dbf2d0d66d4105541c25fbc1b3e8cc1990d463b5e03593b1121a227a578284a2d9ee637bcb7e1298ae4cd95cec633ef4c940062433c772085aba86312fc8839040c39b343cfd09613dff08d9d6b0637181f235abe87820987d3b51611c04af4032b004d9be25cd19cadc43ba5bf3012a0ad1ce7b102996b84306fdfe26fc53b3f8ccea910842eaa85390f53ce31fc811b88faad8c154444ecd76b8a016a44d5ec078f8197be1c938704ccc5be1a27014ccdc57c4c2804d234bdab6eaf7bc00080bf498191e3b90fcb8c302db86a9cb1a663064887512e4d4cb5f1b1843ad9ef37e0205afc7851ec57875e85df8313feb65763d96586b1234564541596ec08690d82f7d390c4ddfaa80d3fa64c2a3a631cb58b19ee6ea5eb27fb5378b062d5564e33aa45e24d280b8465622ea3c4c2ebf876eb7a2c6a413f9ad67be1015726840fe942f4b129710abe6b78bbcd019f2c8d1a2bae5902b9535b8ccc91ac28a359744475d233e7cf05cfff59b52beb81af0846183c8becdcd770c49a11d71c69576f62a1526ae49e9fa21646640691ee969d0ffdc026e22c3cb077e8caafeea51b1a37510a414121fc640b3b6f2d973b33fca57244d4fb1b4eab2a92b25491150ad06206121c577d9a910ef6e10f83e72e96aed62413a0028d8176908f1e1cd64b578531ef32fa27eeb8af92928324862eab401c071533983c36725aaa6589219f38db7e16f0ac0996e67e1837ad4bee250fba9b699efc510a43e455d201c143a9bfea66d9c212613f1980006881e4ff565d093cb6eb4b5ad7fd9a5d062a3730a9a34835ef9fa51272a0f1ba8287c0ae1ce49718c4564b9ad284ba443b1c17bb7272864ff576c2c60821fe70880456d73839a34927205a464c6651bffc1565ce9d2dfdb8da7b1771d36e998d4e6b1e948d05a134f4e0f738dab1116fce1a59317b8d94cc3290adf0ef1baa6d351f55095f92c87c2298a8f3e7dba6d10eb7d27c16f697eb34a997449af71baa139e6771843c1a39ac4ce53f05946aac39632fb58a914088c2f8298ca0fa9ad525d024eda3479a85af75c78ac1dbc958181bd56dfeff1625a8712f87b0fc79ac236ce6a073d88f956f3e3d66c61114f72dc27b9ce83d9fddb61f915ac62bfabde8da402b54a43060a197f1dcbfd3ca74e600da3e32fbb4e03801f3b9047ca03c9405750f0387ac26abc9bf961b3b7bc3910136cb00544d8e57dd724fcd21e362485d1ff0360b605f314173fac99f844d494832d90271126e7f18b1f53fd785fe347239d786b28bc2ba777fe1ff14835fa031262767c8819903e2a7cab67ee077ea9b73df8fadc89c92b4ee9fd4f6c8998de8aca160b1c6a32fec7ab3ff9cde595849ddb6be03b335493b8cf2b0808658c0dc56ccf48d9c3d954559ade2793417c636e979c787fa1205d3f4934c32499e3b31d1c92e63bbb4c38eba04d16a9aa3a1ac123ff67818520ba0ea16625cc57324c55abd11070adbd3b9f4d74576ab5d39f009fdb6c87651948282cba562a7422c39eeb3e440eb373d6ac45bfb113189a1696e94acc57590f5da62e6f124b71f07025eacebdb62062051a2565246055c9667b0b1f23712ebb666360a9da19c5750b4de54990359e3a062da9c45ad9467764f268619e17470ff20495a4135010596656baf21bff7bd7ec179d14ed94bf53a208e1f5ad959ba63feac24b99bd3a16b0069bc7600d947157d5a7f604ec5c61f721b5beaffe71e530a0723d41bc81c291b39ba2e6b7bac5aaea7b9f764bd8daaa01ab5a204e78a3c0b093aa5487d000a1973ef43c78c0ad4340fc085f232b15ced592f057f3c0d6811582e57b54a2955ddd77c509c79a5cfa43dee74dcb3d444ebfa238fd59befbeddfca94148d0414b3fb3c3366f30a4fec8600874a6508eca76a2ff40f2f69d232f89611c76636516c5fbb3e47aaaa31b5106248d141e512feaf386dfb9dafbdb9b66c6dcfc804b9ec4ecba09e6463571a113e3b5f16561488dfa997a83be5d484cc06981e4a0bd86b5fdc68b75e572db76168c3854747459ac370307f1ef7ae6f8097e767d8c5e935c7e2332ab6c7012d1184c10e6353e037868154d6e5e90d7e1083f3de8572ffd29b8b1fd27aeee2393dc8aea64117e6bfc2db22c407f4ae17c27138f8a99e344eda5c72c9050179b03c37f4a656216df77f006d3b65db59122ae6314b5ac782b8cc7e100ca6fa3c6784f966289c4e17bdc8c9b8090134e8743016cadaf4980ffa96dc5f92cc223c036b96697c59f9619884a9e05ec6e26008b6082c51be473734c3eaa03512ce033cf829bebe9f96b94fdb8b5500653c3ef27d43cf3bb3f819caf85ba5be4cd0ea897137965ce4255dcefe92c3c550e2a7c81673c6ef0c9266364f0154b8370ad5bb5621893acdf3db6dd36b54f7ce1565ae0795a5c6e2f5a59fd927146c2e98ab6625a45c0188c7ef9c63d39015c8f0b473ddb17bd8d0b79af340ccc6b2ea9f268b570ea27a3feb83c255d968f8b40ba3047e9d3fec13c6bc710e1eae0c2eb8d4fe7c8c5d9d3b1eddfe212e74ea3a71d16aa2987f77512e1209c699a4a679eedc150f3b52875755763fda681bc594af35966123a8dfab2bcb5fe8b74cd1a902a07f2a871cecbfc1da113cc20a29ca2414a9a812cf8b23a6d33fb53c5fb8132885fef38502fd4448f0b89f3228d812cba81272e4d955213648b030a6f88fd43bc04770e8e0fd792e400075d8b845c6a79cfea072020e282700a0b65a777fc5a8fe8588e8b7d7e2bf1155e5cb1d546318e3906de9d4a7b035246f19b0972b358192d2d8bbdbf78744a0535763c38644e8263763c7a0327b79cd5ff520a404d5657fd56106a8403c30c508184063a622449bfe2c46af6a5f04535262999c2770a785a6f4f27e01414283731662b3ff807375367c34c00994aa0d07d621b9d662fbde7aa4fb87187c968433379af3caf48a608ae7f6a4586d8f075094942684aa153b8555b36b064982776de7d170cfd432764ade89c8cc412bcd54520d73105da7b951b7488238a86a9678a498f05b94e25b5158e1c087b760cda9497fb02a0c94cc3f769823099cc17c35fd972d330f8fd6fc2d9def0848abae75dea039a0a85bd174ca31db4c0fafd8f86bd7c7d57765d713a66871b3506801a5cb6abac1ff1ce88d4f88069bda43646c009ce7961b27f383b2ec86866cc8523ccfbfe7c3a975dc7e77d08fc33b4bb356c91d18507cc25eacd38694849659f99e909eadec17c773d2b43946ebe262b524a6680397b58fedfe76355417b4179f1d52a77db0647868fc93be4a51c73456f09e6aeee508e4b1ace1e618495261218f458b0a6b656d5cbec24c50a5f4b2ead35a3281b024a1568a745ee187bde204748f4f1e6e5ad8421224f5a2c5084ccbe23da0df3f9d2984e0bda745ddab0c427af0700c3b5dd36652f1b528aca6897aa8b33c6bec0b31c308e7e2782a22b04e3ad193fc98eac294d8a9082e555817e017c3f0917ea39f5e3c89aafd88520e2b1dba03964b2349a93637df9ec92d7631d598bc1d7c67f135b80c2910078be62b9870b12fbddb074f139de2fec70bf089519e3cfe8ba51b18546e4dee68b6ed2fa88d2c1fc000fd72272939032d4a93bf2e2bb29a2cea1f45843528a2af06f997a173eb6167f33d689af9ddd1cdf06ecddf1a68c245401b13aceeb8366b0fd9f8e2514069cb6948cd1147c5c4d73aec39a5614f296d19f448d1e88f777cb6514c0a2b8de68f044e5806a8e39ac4539271d1240b57b3cb79b93ab1296147e72ec8460814eac57716492da693e39eed1dafc66d24a762ea6d77afb62ded7c2dbccd55114582697b59e5195c293eadcc68b1bf6ffa3bf4f5e75a9a5e67aa659307bb247ef1501a30f258ca2cdb05b0e8df6b5688a008c91decbd043472141d40a5e662a9a7ac6ea3e05a07fe4e9861982b9b53c2fa277a35226eaed73aba0857f89a1cd2e276baa0c7b4e27584f2ce558c25d640366e198dec269a586f7465e572e0bbfd23b71fadf4e0d1e20648f4f7e3a6b54e02604f978d1054ecc017f4534235f5a0d0740630f4bfa5c384e1f7c3b14df3223d4480097991475b2eb63542fa80d26f139f057d88f4709a2057df999af8e0a97f00130c724858830d944034e1426b58c699f0383921868f8722333c24e0f6e949fc7e1c6eef4b3247ba2e7ee38b1c817c36c37d4f7580000001224c7b737ddfe143489cf4ce0f8e656f64310a238ac723293ced59f9faf112df58fb9f58a5ab121c0b87e950a0523dbb19d1e79cc53769ee5e9abaa3979042c1d8d9e0d02909fe8e58debf350fc3c7b76a480c2914d9f7fc23e9f3c43064697a6e293bf583eac840aaf2067aee8fb199308b611d1f4e32677775f66eb52c50075bced6b8604e5e44ef8593f682f3052610c1f9cdbc65f682c128e2d55963f8e74ba2e9b74cef76de63a8642c613d228b8f8f938c00be4a2514f97b10609fbc5fccfdbd7be3c9363ec174635a2ef98269d4e46d62f21f841f3f97085b8a27a0b2ecd96f206328ccc11edb5d16870b61a392f219e18f6353592b3708d1007661c100c83ade9c138a96b052295a535562c435690dd43b2a31d301583a6be16305d019b5c801ecf62d78f1b216d74aa0698233b29a3bfdf6a22a173ff1a3937c8c6d541f6f4df61d8056382ea70be9c333a7a05f33692aa635bff866d64a7231105e6ec03825bc9186dfe5ef1cb4e71e02665927a500b6b3166811a6eb1d212a4b91e6c9c76d76cffce7bf2016265929051293d3d311de60a8decdc671082cfd1a4cde895cf57972cf7f6310c3bfcf06e86878f36ddc06dbf744c6a7d10ca7d35254963dfeec2ed5c538747bce19d7bfe0208de0bcd9e9c64138ab15556a76b9d1c3c23782aa5bed4c698f6009628fd884a507583e2acc32f2830af139077f0318f889622f4bb27cd62d88ad6481a4ad50a60e4e0e07ee960f3d52df788169209041a9e392911a1d0391960979ce05c85c699625ab286688311b52432cea62892b2d311aa028af3d896fccbd6ac3aab431985b466af340075eaedd095e7b920da4a267f5137ab7b1b4c06423f481c824148802b46bc4d35dda728caaa3f402879f5601a29b8ef89e2b5089367176c07185ad0e6fb1687dbf81f1e1cb0d403550074c9ec5ff1b26cd8f149ba408719c12aaec620d12d0024a809d7ad3b5e294fc2696174455dd994bea37ecffaf5aa7b60e95adb290476c4a60592e05e847c69d3cb1512455a9ccf781bbfb9c8852bd2c94ea4f7bb4b7747b83aea0ebd6f2359fa1ed82011f97460831de0b7fd818cc07586e20634f396ffc069ae9f202e8d64db338710cd05f4c8d37481bc0e92798a51bc4ae53ae08b9154a458bfbce0458c8847118ebb2d71eb0ae48be007e7f73d5000fdfe2cc2843bbaad45b5d4f940ec1663b0ce4534d51baf2d1b2ea51ff54e788c2052037f9cc70635121f0a4e4f1de6f6f5fa17198e3f92730b11edc598b5d9b0fe2ccd34713e1fb545b2c59eef8f7dc73701f20b3dbeaa909bef5a5f500e2a29bbe64c59947536e7b71d91d0a9fbaae8093dc573af39017ad78b60c08860ca6cc6d722d98586d24aed1fb358abcddfe454a329da9a2eb4e326869a12817f44a7837c672c2c47d10da463ae9bdd27701ded86a7465e69b7bb80b79d7426b866408f1672a073d198a3f4749e9c1052fccf25c292b1fbab3acec287d959fdd145566efa717ebddb34469dfab0a7ad9b6c01c9a191a6feab3c96854451784a1f2e76a0b8aa7677ce3a59d6e4a98eda43ee66756ae2ca5a226e561e15d852743270e791cb74355c66a28966a18a7f8f7f462011b3f234eea0a5f1435a3fadf81a2bd7a365183f83cd648504677af6f7461b5cc681ac5fa201bd58cdb61c2d56aec97fb912924a2842678c984ba0202b7b6dcb77a15f759cce0d1e68b52e56a6f07f4215b7bcaab6ba73d1d167eba772db67ba1fe9e610bf085ca35a163301fa82150e7912020c2f2eac1f8a0af27aa5f167623165a90bbcb002c52eacbf605826f3585ccdd385d7ff00de539d697f089871c2b71d971b72f5ee723dd062fe63fcc28c0c250eec1e6dc3c50574aca070965e6a690c71020b297167fbfa4e9e9779aa6cb068b611ddc07c1c13b007d90fe8570d645273154cc872d1637cf0590325dd96e35d7cf50437cc997289e0512e711f8538ced264e34e95f8dcca9bc3e771ecad2291f7bb6e050a6628412cd3f01c72cba77050a4a3bfbfadaf99d2b9c6a8436468a3c867e2ab8fdeacb57a49761593097732b469308c0d4ad0d3115f28192fc353f19f71a6f1618969e4e677d8ff71bbfe9366da9f33c9e3e7fc83238629ef6400b9fc3ed5e57bf30bdb0a2e7b55acd262c294fd402835333eaefdf411fb85a5b310e81a49cc7d65f89aca01d8261e88a8adcd50c496865dd3d5539249ef93ed3b03edebdb5749f2cde945c4a5618b0c4f482cbfb4027452e34ffb99780014e97acb2b39ea1bc92c8e3eeb444e10c811ac038120e91461204410a41176f6cbfd3751cfe45d88932aa768209dd19e6804d7a48ce25cd6255ba1371c4003e9a5a1659ca8b861c9718f81a65c66737f2fa8b5163bc0decc9cdcaf8630fa39dfb6929ff8dc19690a3ac47c13ab0bdef83d3cdbb737d6e91fa4d34edbab318ebce3e4ccb39012f6a24ba6ca2983dde0db6a0d49b33eac278d730d52658092a0e8edf4a57598dd43831096fec1cc2da6f7dac2ef04db2849404063837da9f8d1ace7f8efd5286bacd6b5df6e8eb217e266a54b0524be76e2063e628e359164f4ec0912ed730fc12d211147488a1db494cbe7ab78e0628a33b66f0e878d06be2ee91ce74cacaf2db98160a00289e40faaeaa59aff90e89a4b0bbfb4125ad805d7a9f957c21085d6ed86745b35adde7295b561176cd9a154d3af53b5ec4d3a960cb7162c8db220f43b37fa1229bfbf2671a422830dfc5c15206eac93a5ca2f9c7440784d37df1644c8643c89f4ddeefedbe15842b86012aa20a307ac628b54b10649c050e0c012e89ce90cf12fef3044b8534a580f8d60935d1a507718cb46955d78a7c73517d386197eaf8c85a4d8f5101a01124556742e87f0b08be2016fb43ad8cada47b1ad41d028ce731d608fb7b57f699c6664a4ecd447ac04490be21fea37a68ccbfd8dd98d4b959b4aaf941e76b8108c17ae696412e7a1150daf9c85159e7c04639e8534c8586893525bbd5b3e462fb29559b0588b559b00e204fff8dfc4644aaab190adccac8b8fbf660fb33e3e2053cf993ce95a648d3aab1f9d76c05ed9a680866b30d8bf444cb4e420216464e5b6cf80f6204dccbb151b8b674f31ed0fab139f8aa3febdbe11e38eed2a67748466efa5741ee212b3b69b15db66908d10fece5a95cb5ebab212769ab5f64a572e3c8b6f540ff4749e9c1052fccf25346b3e601c83dd0cc2efee1fd381ca42aadef46e6e247a238cb7dd71f0adc80803488dbfbb301d1eb8f856ec958e69d9c8ad620ff06f71f697b07065dcfd9c12a28ef327567efc34010d8c1d45a2d7e4b3ce26d71e65000e37c7f84598d9f3f71b2eadec034e667cae5ae37c53f081633a0ee58f7a0e6c3e0b7e49411e43e42a058e8f265ba2f2442dc92667cad18be34ac706fdb5c2135709a1aa5eb5050486d4afd4334e1779debc0fb067bbdf4a67a86105566e6681c986aa8d8bac750b2e713396eabc3e3c75eb36b934fd62221ebee42b4575f7653d33ffa43e9137ae84c3e79657cea31d292b37862fdf794e6b2ddf76b5b8210580029185e3665b7b4a35540c7efe144f8ced9001106caf51edc4e9c30a791983bb69f086d982b63ab5f7e474ceacdbceec242a2ec85d35ae35cc46e9c77f2f66e94d65c89bfd28604d4d8834f5619e2f28b9aeb81711c5b4669502d99325c297092cae02aeb069671dc1429c6d9641678d4e29eb6ffbf5cf6847a8ccb5f4750c811d7fb9c3923dc0ea8e6b09b72fe0bf1b8e101df3b3e8fbc7b96a8890c8fd04a406ebd3f0411267ec790bc475a5e342d77cf49874744c9801e050e6e2ca1d2ceb2abd75000692d7ed295363995e148a1b744c26f48307050a963b09c9dcb7fe0dec8f79e2ad6d30bf20de74f5a7091f97a4bee7fa20b1b62a01e32501f1bedd851a0aa5583182b546cb8c88666645bba130a460002e83d94589a1dc3d7ab031b616faee9878f98c16b00bf0a9568ae0e73c3a4d657bf12957552a8cfa6baaa4fedbf0c24960babe3e87623258d7a490b86f8c369e68df0a01325d8285a20253a48d5b6b8c85c13a19820b15b1a3527d367b214301b4be0b8ec86a9bef88bcc4584c69e5824652159b76e329b216a5aa198e8a7a61009467fece3eca2ae51574826b6001acab025e074aa3cdf94743db78cc09256db4be411e5d3867aa94e001ef1f705f2967e203098fe8694729c9750ae9721f7dc6bb1c7cca99a59ce09a34f9be6f015886bd82c6d40b5a310bac594c1cd1297f407301f1cb626af9d513e22a3b845d11ab5e71c45a0672933b8a42b04a4e08de06b883e273a1770256cd80ae5530d0a3ecd65c1bd61869019c353aad21c830c9db586b7e769b2995e49916cdb0b218df6249ff81c764e8c74645955bb2259b300a1c3fe78a619a75de17de7443cbb7a428e1aabedc7c769e563cc6a45e770e8257c3569c4e93eb41206e9c4e0fb7a49c4bbe8e600abe053c26c7814994b1591711c70cd8b2e68056c901c68fb36ee4f7588f2a630d91abad88000000187f18fde3f57a93fc14f63f1fc7c05e9d3c88b9b36325e9044b6bcd91fe5dcbcf9044c4b4fde9a9658c62e770719806c28964e53be71bfe0a2478eb75981171dd329d94ec3d5bd0a9416a7310630fe5babfce34052aa2f9cc4861806abf328eb8ad00000011bb433921f865916078d08270c92fdcb14ad6504591fe835ed1e24a140dad0ac0ef75501178e10e0bdc3c0b0350cbf5e77337466b9b55eddecbc6e8bb4cd4701c4d1065951cae5ced94bdd08e8c49c7518ada7c92a5d79892a8ec4dba478af8ed1516c8d67754040593079b1f912bd1f316537e3ce1e5a00baac47df63f76ddf04de476a8360229ff10a43ea12191e521e67994956b987219b2a0c040ef054289b39cf4f410aaf336973308b6b2c8d031204b04e81c6530216d55824fe7f85c0905670aef252a6030b3ccf30e620a3d75451a97c7818ee8474623acc21cf895fe5ef62bc1bbfe4261b288088302dda3795342b9b02490313558ba6f69083886163d88000001eec70a2af047c0389020d07be6bd6d5e4953d4e8e47edbce14b879ad366ef438c8a636dbd42b880b5d3b64e47005783d1f3b9c7930763bf3002823e6fd401a6b70f5848681de874469ac423f35090c9fa976da1bdd34ac7a3e0320b1d45cb95b34db9e30d5ca4fc62f38fd6b8f402e4c91881a519a2b7dbb7885aa905bf348bc85fbb8b43cea3e0f41e187b9b6237a6f932be8087374a10c6eb21d58780e8de965549086f54f2983731c9e38c92658dd22e912983f003e057d402d7f1390475b8224784884e2578649e5b41bc550c3b10de9dc7122e753bb650ac390b49a51c1b980c16aaa508fe48695d9436bfbc3f5371c1fd1c94c464d7e1f3c2ba44bc206752052d7100ead8d36f29c20ba88398271ce87e41005708d38920e4eb9d8ec05eec1542c896624e50860aff6f78299eee86dea6bbb539d31c8a4be8da31aca8bc3882f88d1cb11795880c2fe26b13a62278088b0be5d01bc0c8d249308f3f6eef11d5f6e65102465dddeb15c367a6181f9fb89418884deccb1253a58122cd6f4536d1551ed31f3df28281d6b2a069c85f2b498223e14c66faf2e8318e1a21a2097b45542e7c0e5b7e1749a4aa3cd4ad642b1a9eb69528d7d737402a61dd40d449d8ff8d00812fb0f9191083541c12a1f4fd2debb421b11ef4baddbf189d2f7f9e64e3f98922d609e116bb6b070e3832032ea19cb3540fa7660476ead27b4966bbd8c7eb69420e361a7f82693b28a0a1aff012d0fc772cfbae86a1f2f71e142844e1b4c35bd700d8747bafed5e08e19e287479cd8079d229aaa500b2fcabcddb3251eb623eb4846472ef639f2bf4d314b59bbcebb75779d203326386cafadf6a2c4819c811b67a12200f49326d75ccab93ef2e93567c91dcf33f540d5f61eb90fab7fc34971dd78b8563dc9ec449a5e9c5e87b296110b78fe40f9beee86dea6bbb539c5b473796912e20dd4bb147cdcd36cbfdf21486fe61218652339ddd28d05be05cc45470cab8571e3001851dba17677d392698da8688205fca4c751ef1900a3f7d2a6812ec9e000000418fcd11d6abcbbb36453206bade529b8ba6c1692b420b410c6e147ec0b041a02d9cbc4ec0da82be752fc6df5b87446319c501ace78b30c747e8e2cd2cd827e697d9ee2cd0116eac471b5ede470935fbe84fab996144fb02a9a1f34a0f04101c74e4df1e801cb5ee0951ba7d824a329225e7f4569114592a1f8d506b26565dddcd3563084d14b3781d44f91f95193ab948a28d26ba6ccf956993827545561f9bc72cf7f9e123d2ff431154b789dd3971bcac118a03f44b8cdabbbf49cb3d24d2456e535ce017b02dcea39f44404e7ce6c2ce3c50c14481636f926b47c927380bd3548da80245ca99af81558ca3d6a9d58de850f7f6245001c61b1b9570181feb0e6d89248cd83d34acf073d42536609c580000a5ec7a677d41243ff9159ce8a1390e09ccac04ce7cd887af3bc8b52c59558a39c70d0cb76fed242d2830640ae3d9f62322b3141ef6db36b67895bc83be6b82617fa027ae8397ee04b626ccfc3107d8cc23ee680d3ea931fee297b23bfe6db0bc4023d3f870285d5af1f261d88d4e164ed44af0b95bb06f88c7a2eae9270ce6c163e63a087f3d647c06233116e65407fbc4bf95278c274040b4cb92138a991f56dbe062bec27513c61bd9cc12cc6acb7073dc2b31dab3ac3218b658ca4b679bc5188b62d807b665929618b558e6e8d536bc386539ebe3565506b4d23f4b4ccc10ce9e74b3f8cdac75144acf9365e229ef101c67a6edf5b52daeb9187215f7045b7c487b299400000000000000011a7df11cc85cd582ddcd59dca96789d56ba6218e5c185467860000a92b4bfa8209755a445b52a9ae7cac20ffa53e94721addb72bb9c1189a04685fa42e3875f67c2be78a08143f47cab462f63cd0634faec72dad288a570bfedfb69102500e9c5ac87826a0636edb3e373211d53ef87486dabf471b3fb7c2a0ed4b5ace52007a31a627cbd0db43f2b95e43857a172528b77a6ce28791c620b48572f7bef4e0d33740f55b912fcb9702a695e939a523fffcf6a378513f392965782a404657225a81989947aca0d2c4025b7bf6b530884d60b3b7f0a0966037802a3b7a35ae04b9f5dacf9bf3add9d014b1d6d93e7defa1bd50ede85e38f8e7d85177073794845b86bd92cd466be5b625d12b13fad3cd04d27272934fcec7ef369df1eb8ad44c061a6bbdc2c7632ae40e284258ade302a83fe07ff010b065b320f29da04b93a05ec7b7191c9814ce7983cf68b6377a7d61d7adfd999546c331e61b0711bfcb7de9203fcc424d279ac1d35875373134ad0baccc9b63222fb08411cc3c2e0f77a0224a705f9f118d6f031e3057bcfc7d737e6624b21a62ccc83d3e67065fea56fa5771ba27f4d4f8b8a1cbb8962e28d4e50f63a3812385cd5db684342c78870fc9906983b485dbc08bae4cc42b2388cd832d86f157af83130116508291c931e35683fee588d1bbf0379caffceac070d51582ef485d2fff4b1cdd5d0c1b434c4b937154773fba5726bd692a59f7378492e2fdb7c5a14b34c669846591a618d74279cbf119115979fd13b403c0000000000001776b72b4734009dc954e1cd4e88057ddedc7aadb3129cf099a3f6c24c0ea850000055a42abc9d6a69ce096d8ad14dcbdab3587a211d56eb303ba7a3c3380ef831d289ffde5fcb4f0d9312d316dcba49786c86e68e23d473ccf4a4f1000ebf2fb1a1fe912217aa4a03c6956931688060cee0f763d24eeabffade47cf72005bfb57f199943960593e1471c6486e92e81dab476119b8aa0a0fcd5e2063c1b0748b192ad1d6b4284c95293ea69149d923345e21e92b10ca00e7ba54e57fc54b6d09e993737f4501b2b6baf1f5a3919f2c7859a99289ade13501e61b24384f9705bb703b9a57f920f5ab15281c6807738fee8bbd696d848fd2ab9e4f822ec43b1046ff43fb8f1c6dc1f9bdd7d452a407dd4ed084d58e630a1125376260db4da3ee0d75aeb0f38eea87b29339a197daa2a6a37dad6b1c9ccf5471ffcc9e2ed12287d1c013aceaffe295420d6974e98286611de07eebf0031455580ed8f1ad979932541ae5f32374a113940c5eb7ed4fb00468f004fdb32bac845897752fca3884b67ee22055de0c417c86b294a20cbb3c58693bcb85b9b4552e01c907bf8fe7b997ae34ae22e8032075678193ef630d6ce38c94f98c504266660d59ed1eee092c686fa700d78c8acdac0efc75bb0c4aca7c15273a35d8f19ea774d0f85cd7b48165cae1799be70dd0f5ba4d59a628cb70fa7b43439606a4f9ba632f56e237b256bb55bd4b6cb164b337a4bf18a3a331ebfd9ebb9d0852bfe67a1e793e5a3af5e487a2848880c709ca8d346b849336c4cb2ef48cd8d5cc8d523af1e47d75377f9811c78424c81dd36135bb390a9ae22eaa8032c9b62d59deac49e81f06a265732ef30242c9d5400ef4b61e291fbfdc8bce4f957d7bbf2735124364f9a8d542b53689bdad6b1e2faefafc94439626fb1adb6629aa1c1c51421efcf98d99f2b022aafc534b0a15ae36b8e76e1f2516af343f8856dc41d396c2cbd50ba7fc020a01eda4244d85ddb795e4eb52ccd35297b12acf5f20bc32e1bf2085ca576c16cef0f4fdfbf206548199582399d393fe179b3cb59d1b3094a4c34e908fccdce96b5a58193632abbaad6a65e9329272bd7702ca104132c1179174b69cf13818419d5afdaef205ee0525201b36721e425c9215e0bb8a9781e92d8e8dcd279b2f1f1fd08f41e8f8fc8be9357118ac8877804d8c5eb695822b850c8f9c2d387297393cdb4a9c1a8a541f2ab86ddb5b9bb803031fb129c8b58dea679f225875a6775f398592d2cf56255058dfe44579949e9014ed5d3729d8b5c59396deed773999b3a23a53cf9c60d9fb1a6a7437644005b7b865517acd1226dad097b9d1999fae6bddc249e4008caed395f2e8be367929a60a2e28f5d0dbbe5910ff2941709ffb2f349d051b592c06b91727204514541595e230763056906022a75ba7276e2bc2e1c6445692b8cc365e7450117094c8a9205728a4e664bf38950f077c85700d0adee7dd88bc294b953ae16039af8d93f3a05b793a8d851e3dd898e0c47b4fdb98059e2d4e9b283691673cde3dd75f656f360dc615ff456cae80ba80003d7cddc9e3af994082cd435f323c701552d627a5417b62491cc4e194ba14473b50b39274e0fc45da0de3937bf2c1bb76fd2faab0621de899bf0d68f158dc6a3c7e1b6c23254c53a06901523c84ed757862cca6733104c4387e179984a300956f5736c549d5670ad24ee729dfacf98cb076adbee411efba3c629b72601ac8824e2e5d2f1cb4ecaeccb8b9ea1854078cae590b84dd1ce43f2b04b19a566f19678667db1bab90edc89b2830802d915650c8a15439e3a7b7d0b676482d56e9b3098cdd95916dfcf8c58e54078c472cbeb1c25a0cc69f6253a7cee2db4cbaa2adeb4feb01137afdb13ef50ce58d484c6a7cbd999d78394dbb44650cb8c45ffd781194acf930092386110aa8d3b1681765f8233f0c5a730f0202582516088829d27350ccb00e87748e0cef1c5c13806d5cc62abe928ebb027c8c395378ce1c5c466540d088e5876e99fa49e32212ec22335deabf61257580af393cb082ff2bc6c310d14090cd97abbb375c275a7d6c77a6401c218a949b649feacd35c94266fe4cbdabb8935b42e047d2eda344767def6ff0b50cd01bafcf7762403f32ae1cd0236c317c7ae080dbbc0a3a2449a69f058cd11742566e07b1a1e303ca749bbd9f29c9f60112961b06656c2c0ddd47d1063d54a919872364f8df55ca7095f6a12a8007bde6df2aba7b3dfed756a96e0e3bc4e6b4ac5cdd061db14345f83bae02b4ac226b22e747a8b4126f3fda79b3d76fd3b7e0eb3e011706981a29ff1821e565aaab9c8fe886b5dcdda91ed0101cd554e30e037da6a19df5d99779ffe450844fc2649be643dcbd0aa71b64a2868308ee892358c9e8fc80649d617ea17fcecce8a1ff8c7e514731daa1983c595761ef0ebc004a68a4f0bdc9376b5611b146022b5798f5f1aca8459b94c09db01dc2b67815169875c88a9431dc7e34098c368622808941f5c91bf08a91fff61282e4d51fb5dc81e40622b7ee150a1562000048a1caaae28531f1f2a7bb021c874c7aec1f7a32722cfd2b2573cc4dc2ec3e99b5403351ff52536759d694f56b82fc5435e7cc4f39ae5d1eaec250adf880643b372462a21c8d4c696b73bd36a5236437be053b0e414a7a4a9d21fc2d3895d73a1b61d130b93fa4c2a184f877fcebedea4f8b63f15d6f0a47538df2e0a56d21787d1b567990a25aba04e88156d982b1e0dc3547f8f1e4931e643854847189094df82c352b3fba7a0109e391800319f8f253d32b00a2ee839ea8491f1c61eab0fa61d8ded94f702dbb8e63bde7013d0224024f9fb5aee2ff82d26a6d38ea9e3828bf7c5f17003f2c7b5cc881d85b10ee1d42c9bbb9676fb0244d6caa283e916073c1944f3582d76a122924819cf5f5ff17bdf01d4331c37e9ca9eee7fa534609c1bb36b8680f45df1100427f4e0d5fd88ad2791a8c445945bbe42a0ef750483d756d5fa2a1cea9fe3e478ec6b505f2bea66f247ede63f2305ecf6b0dd4a018e3c368dcdf71756238c08b6a8614c5558a1aa782072a7da1109c00116cacb8733c7f4c702bce2e82fe644a4fbaae2e6a38e1da6cdd44ec24ed9dc15cb4ca141d2f6a28d7d3f2530e62654665b9922fd94d990821d45f4b8f5fb2215c021bd52e2c8a7a58676e7c0d101ab1c90cc39866b669074b6031c70dda708fecd3ee6aeac8b586266ff8623fe8621350311ea94cb51cfeb1bb7c279c61876aa426d8d9738f94b86f96b886e9b520d492416451664e811b76e091db6616e91147c4d514000144256bf0e7725ddc94e129719328bfc8eae29e358eef3c280cedd8d45979c314b9160641ba5c4714be6b278b07c836da98317051f950912ed81aa7fdd90b261da3a62092164dfdae343d47f1746a874d2009ed7d091ea3912dac05013b74bb4fa74705cd8ad0b648e8ec469ffbe104414218b3cac64576073daa8ddd0ae0879d1cb57dc2326e7c84bb44ebc2a98708dba6bb627c9a2f900065f8698447980a0ee57d49417cdd58e037b28f7a2f53a091665e3a97222e17e57378ea5b55ab175a224cff45793d39ce9bb8d0cdb0ef626259904491da25ae1249f1ce730f5c29743e6c1da23dd803c2591034fcab570a07b3c9d1e36fb49f18d5adc8324d05e6668f44994c4fd87e80480c11025c9a5cbeac3ea5f9dd0f18f6cec187e946abf8046b83cec78b28ab4ce385193047e35eddf84b568e65e395ebd80db586e915159829984b584ee33843d81a1a920f768f756614ef6d20f0cfe550eabbee5d84106dc03d385f8489297254390a42ab35fab65be94efc05c29bcf1165136c9ee6fe628cc0c0f5b98cdd436d9f2f6a4f7d4f8140d59e6c3a27be44a60be5942bec300f1399ae71dbc5f911cd585fb559c99f19f11aaaa0e55b539bde51ddd0df1a2a3fcbaf182da9207375e5d3d87cfa98111465ad71ac85fe7210a68edda805caf60f73c06e114cc1e9ff4a511674e7b42e3e19af3987840000000000000000922a87ded7b4a1e60b370e35fca447f9ac7e97bd242b64e0a1790653adc37ce3afe2d62ae97b06eb40aa3dd6ef0cfb3d4d9c41c276a2019628ef9af4525b20cbebce28a64f0255aa8d6f42c40032f03051aa961b73d7abe0e4e8db6e1a5270074b2f53c6e7ac23a6447c22268371e74fba213f56e4f96e81dbd44e44b435c95bb764061e9bb75686742a5a0f23453ed6fd1e1767a63df98afbd9c9d6e2085de0fe757ff1687b1189373763f71c229d26c26d9473155f06075b2af7e5ce342ada12ab0ae370052803084eebfa4ad47a6f27c69ec4d13ebbf1b74415e023beb373754cd2f9dc2908dd4bed92c6a7159a684046514770566541763ef73457a02ceb9476674e0c2b30a0ea1bb941d8f5231857d5d8cf313625c9b919a5d7841640861f65c2d3824f9c72ec3de0864aa2a3b7e731eb7a452a714cdb65a0a9e273b5aafab9c54dd080befa5da0c09d8dbbe400fe07971ae4c393c853c759862e9e6e048a611c12d19932f260508ad92c0d360f82291c00434e2d849304118417bf16118ab8ed1a3ca40037e6319320ca1f1b14266b2448c281850058969307a746f701b07469ec1baebd78b38c378bc09f62dd85ba4c17ac8ba5ea7ce39e8db7b9cb0438b0864daf6ab3f31d21c6674a386d2a5819698e5636530bd5e27cd0af2428d531c648f369896b2c93d63bb4614723e77cb4994cee383bb6a20c706c61401d1569fb9ff84ca9e0410b4014907b736741eb9d8170cc5eff5233a64b6ba3ad0154d0b4f6f9b07689a8824d4297770a6a7fc1ad99a34f929758038f94f3d3d5d7eddbf7eca97bf442c0ab619a2ba864ae3bcf3b18bd1e929be6e59f02819803e69cbb2bea0a8e15b23fe1a46b562c4557cb38c2eb034e7884dd8373e94de60e6e33679540df32a96b48a62f5a19f8c6cb2a996d8c9bacd649ace8f8bd3aa5a17f8c0069c6071324b0aa0360446fc5ec262188bdffed2723537599d50d5b8fdfd7547b5eafa0aa474ada4b9428cd6ab394bcb3e6d28d3b245c143f92afb61de00131c90ee12f79e3df9badb83143cef8e1ca4905f8d3fbddfb012502390615680c4c1fcde2650584968b363c534eb5083c2d363ec6d8db1824185d5510f59fc448e173d010e4b22deab2a696cda4ecdcf781fbc267f257f107ddf30f75cfa2db2d56301102768722bfd0851bcb04719a0887a0556d7c993fdc7a7fbd733307071f64ce7ab073be2e14c30bc5001c6ec982c3d0c902ae52859e997e77664b8fa3dd1ca812bb77a3390c825c8f5a22b4fb222be6cf201299f7af2db2a387707307df03f95ab0505bf0dbb08e63a3ee57233ee38168acb4607af74911a4a4c6d401370ea3440ed3250eaf1440773bed97143dd8ec1ce02673df3c375b5913718b22badae887bb9676d9743a35c006c65cc084cf121ec45b8b3e80c7e3b99b8e582a90cdc3918a99b71409441f933d8962043da54a938acc998b80c50987d457cafa896d8b4ab9a610ba24e2a2785840b19c80a103c50bfcc664fb42c60b4845c7e1cb64f39ae7147170709cd34fab24fb7163cd597db6c33e8c545f81b258ec02cb0aaea31a5a280647206d5206657de41a4f6e8a2dac87be1dd6c177f313d6ecf03574e71872c6789132142ce0e72bcaf8b3d1e27944392bb55ab3a633413cbc06f4e71b9d2f89b3a16e4383de77a20f4f484bd05e400954579abd46553a81d599850b1104cf96220adcd0705270b11056e6838293858882b7341c149c2c4415b9a0e0a4e16220adcd0705270b11056e71eaf7e19b67715c38833d0a1972663efe4c325aac0c74d21ce30dbcd53a2154d4b8d429fb7513fe8d7354eab3413dde90e79187f34e769bad4ce5619bd357622d85eec94a143fce24802bf1397978cd10db880232bc43ee68c24e508d92a61974b40ce719155ffb804c586aff8001a9bfe311185f41580680b53c358220942bc859cfca6e05b1e2df615e40cb438f90ab636a945da02acfe5a492e5fab0dc3376dab86dfbc615e76075676a3f317ffebfbf358d62bded5da1da4bf7568c5391b524f5fd78ecbbd37daa882fe854a882c74a56c6c83dec2e40d74189a250b143c00deb2390ede040b97722b2a1cf54a38c033897c988afbe956757a2136511994a566286b2a5c9f24bb9b86d64bb4eedd5440d626365607426f9965eeae221f96cc83ae30ed4353e5d5216ddfbf7ac1540687c9c198496277ad1c9398725940b3f2fd6338a0d2772480191f7d78c26df90dd689ea1d841645e7e9152a0c5fb36a8c94af3e44aa211337b023ff0a5ef6bf19c19e3f01be9a686c9d54a0bed261ac8acdd7f9d59e48db70d11c29f73f4ff9ff6f7b97d3fc5caa8d7a23a352910b85c41d74c8c364e3d2f807c693e8c58ec5934fd8a5f13d75687ead3e5ad8fbe050dd2840abc27bcd87a3ee50cc1f3873100861813f34920bd3e95433532652a30eda0ea3c6229d3ca2f648ecc26d9e80cca46f02f6ddf1a8afe347e9dd349fcbf71fdaec01df759603c6478cef75806a2df835d7a224fbd0a85c994b8fcaff8daaa1f33b9f2cf6749ee55ddb2f6aed002d81a1a5f7ca95100eee639661ee97eb42b6f11c511d50bfb8974c1b96cf2c1974b922ab200e7c748c8758eec7bc000889ada976fe3f3dc74aaa2b7f42d14d0e7e71d5835cab2fab19fb0bda8618b2ecb93fc6f440c922f263776c162ca596cde2cc0b5c2506f016e6beabd7fd8016241021a12fd166e6e418835bfd7fc075b79f98c531222515b3d8c1f7d9829f4954aba940ed84cae09006b1d987d006f17e46b10cd1a13302ec36337376382cfad338deaf628260637e81b7002140013caca9ec6e53d4db61fec3e5aac77d23d134dde25f53d5ecbe9a92e0013b318e3665aacda2c396611b07c98a421fc74903a64b0b35ef2b29bba477778706d5e769e2a9f7ffb94bba103bf094d165ac1fb07ea80a28befc6d7c3b01dc64e5e29e77ab9f8922fd98e0ec874eed5ecac96bb42916b8b3d2f45c7900f684c3c3bf18ba606a409e3acadf798000b4d519748f01f5b19eca617901ca7a80dcafc00c37c56fbe6f11632b662ea93cc84a5cfd45e88a778a7266bd37ae84b94474ca59a691dfc0cb499e19cf350015248ecd6ef119f6a6d54c16b87093acac2e5ab6afbeeda19d9f2ae4bbcf70b19ab4d8f0b2e82b1b933523308e2a30e8f4382a6859391eb9ee895df1ef114c870fd72033a370a224c5a2bc3bcfff1994cd1533de85b80d239c209742b4254dbd64c6494148efab6b4c82e7eaa0279eedc3860deb37f4c66af83c5958c901776f9a37697a04c0400d394ad7b6ae63834eb4703693eaa40811bf460842f56ac039178cefe03420fb288c1e7981873d09100a35f97af07a387057867628935d836494d915c540002759e8c611f59d630b467b0a890a2f1eb823c7d12f08d178fce431a961f061d11f1f1f1a873cbd1d1c95887def46a9e6662c16aa151ae1d6a5f35d6c7de1d83e518b3ef035c706534e2af64a6a521e6a7c84b6350523de8465ffe2c0157399826aa1051d5cf093de594b21f671101c63a037f4e72cf4378f3344d9b7474c16c0a7d1273568a47494f31800766f1d9b544b15fdf2befbc0d0064fb6a8d5d17f77cd5df845979441cd851a744a391b52ff02374f4d78dfb3d660e6c2874b3103a8a98e9a46ac78af50f1d2b86c03532b3f443000b6be23d4f1054829739eb630030b68345696ca5546c178a81f81086066e2cbcbe6a87d8ec30c3a1ba2f8f4347f2860020b552870626353fed0816f084bb49ed350dbc4b94dac1207461d1e8b70d02c6b6761e902412d5aaf26d27e790cc82c6b7d6325a261248f1fc9bb84cd29d834cf7c9189bff996394fce4212fde2698aa1a7c5f88d7480c64c75e01b7d4f3821baa03d87625c35ab380b39a29554cad836308804f726c826163e3a61cfcdb9a82952c7c29f428539f2a9889fd1cc3b254cc22d7125cab77db12c477f14d1f139ea32953392aee6c09c9b83ad3420e936804cc8ebd87c336db9bb56ab25802ee70500ea0d160535d29a51862c8d8c249c1b921bf77fabe6ed3c56b6adf4b6f71ec1e1a65ed55aacb85b478e26aa66e0b752dbadc28d3454fa024bbfdf320aeded9892c683c8d1b494f2f1dc184de78c431d4363529ba7c2cf46682f85100664530ba65ef79b3598c3cf19e2b62e42837e3d19e3e5849680fa01903398e776a9b33c8955df72aa056d0e6812c97b94bb1bdec5cf3dd8b528186dfa966f37fd70fcffd781fe0b578b86bd4c8bb2741779a7db0c5e777c78a6b1e77ddd4ef26ac4d3d3fdc0b7e99f06b1a7f6aba51590b6934c207ac710248561d6e7ea93434e4ac4d9bbfae913b4dae4236cc007289f622786d9a354fb3bb4729c3754a3c3cdebc7fd9f3d06f4eb1587f9ebd9fa4b0ad591efc35cef8b819285a4f6ee37f2f05eb648d7fae1003efe009168c61d458c07c1bb6d156591c2d10156a6217d48519428eaa81f2f78c24e94f7ad0f51ecc14d8317f483048d33bf85f8804a85aa8be5498ba4dd063bb73c446cff79ba6457c46069f208111e047332a002c6ba84ac5e4d0cc9d7325ad915c0461f46eae6bb283a9d9f388947153beb8652b9fd5e6294204489d10c943f685f728cccccfe9f3f2c6b63a3a2beb806117e0a849ebda6418b69dce459df81ab81382b3eedda5e8395a3fc240e9ebb4c39ecf34601deb2a9cbfb34a9de30ddb5adddada4684bc628b461a8fa4334055c88dbb21aa33b1e69e1f14b22a81f8d06cf180129e1216617d7f53281279e19662564cc772bf1d795b9357c6b51fcc04fb7a04487003a7fad60c4cce6d89f2cdc8c4b6b996b3021ac0be079008b94ade87d28dc819dc5407d2d55c3100822517201af12c20e0af71e60e4a201d241c89411a5588bcc1c1f6eb117ac3e36c4997844de40149c394ed1cab41f0b0a90093b9f79dd643b49ac7fbda2186b706319c4f01e334d490e2acff57d6e56d168c8d6988a185542ab293daa45f20e344955f483a95c20c82199b86bc71763f8049e9867320baf8cf2949009432fa0f63412e8b7ee5aca99699c17cc63ec67f913007c953a399ff0d223c9e2f8d31927a3343f9545a307f7cac80b6c9aa343f3e8e6359de39b78cf2d48471c5a9e1a9f67c3ea691b7589af2227bd2d24e4ed9d7c2d7c81ba9ae8e95fa386c26602145af1ff173cb157d4972f83ebeb20ed8517da1906b913879fbe2656327548b695c9494c4768481d2a379f82814e7ef76e5fbb5ea6f4a8d37c122517d2c90a12be1df3c594c7163f42d1e7094a35866821ec7934009b4129fc149f07c360c4badadcede11fb4035b16479f3765683630eed8b7da7e0e698a9e455df0f1cae6291ec38af605f32300d64e7b9cee710d8e78bbd165c1b84a433b17a0a01944d8221d708c7d106b5d62b9f728ab882bf4519e818c12c422b2e714ff545d7141fd50f135a8e89c3bae4aa827a925cc996bfdc54bb49d028dea76dbc399de7cd21cfbb31b946b11b339d576e591fdd2493d81e201cca71837352cb07feaeb525fda9fd8286b160c31800358c911293b077f14b53ef0ca644ca404e10001a878e6d5f7e6493416d8bd869194352cb159ca739c96e0133293baca842021fa8abaf1ed548908bf63c8c002d798d3354eb0747f35fdfa321c615907fcfe532a33a011d321cc40094add2aa683e8a492eff656b1287c5c05856b3a4a7cf2d0c88aa2656093e5f5bade50d28a3f0d246fe8401ada1e51ef5fdd2594cfb3d9e2d1e9febb1d1b9bc905404ebc0599d1f63c6313567a488d34ee7bd1cd8cfd244ec6035349501690c599c236d8f667fad4e45cb5f098ef43f60f43424f39ef4f4f1ef642a4edb6271ffb8cfb39c58a420898e71b278ba759ce1b47ef7736a31f7e1abb12afb49c0e1fb695439212b769c3776cb8994f3dec2e4d10e6767f1ab9547e1df3c0ff2acfe7e509d657d399a667b6f5e8cfb0682fe454c2c1ce47fbe91bd3ea0dc5339165ab6854425c7d5ceb6c67bd99496c29a5bbc28ddc4a3992ca949a2f7ee313137f968b5cdf4253e0b2e8119f026d52dded7717ab666c3e4a2624afff13ddc6118aea930bfec03ec61b832798d2170383d041af8b255b20d9f61422a92520c821ccc43a17d7182dec34ad7fab8682f867ff4131d7f5be658877ddec6ae46f2e0e7a47115f1ea9e5f4f73abdfdc0868eed93bfb6282e979401dc807498868eae4c1df9b7a19ad7f646b1c01901fa422b900cc05434bac9e46140e6d1602ab79804f159be3f22cbc1933e2b9a36f6517b5fe5f833ebe9cfa061ceedffaa76f6914110d9defa4518e4201839d7a8c269994848f5d101c775207d46f92d56ff5f8f13ce054ebe4b65f703aa109ccf846f0265f4020bde421f2f003fcd5bee94de7c6f22698a7d9817d9d0ece37dd7459dff1503b30418d83991d7e4b05149ffc34b64731712963fb25ab869c357abfc669924bd32bf57c20329c81511b7543a5479420ff5fe1e5448389a95602e9e1231ec82d2994332bd761421198047a8e38ecab823e3654ca370909800320c7be5f256ec42f9a1a4d9228bbb161fb64e273c814f28664f981588b87a104010cb76f092965e21bbb71e1db46d1b7b66ff717d7a575021bfe572c9fdebbc6a7f1efea17b7c2f4f4bc4500884dc32854dfcad0cf0f7eac298f20c2c1c5499716d401c92fc281dd56c81d7a38dee3ef629389b312486455fc657e3d33d148215ae49cd6e80378e606e49e4a8011c7e47b4596438f15a77ba29b9d74d3dcb8823a0cbb96a92808d35944419d751386bcf70ba78fa68d7ef35ed70300da21560bc83e810157a82de04ad963008caf0a704865b88225dc7837f33a9da562488f11beaacc10b62438a2b56d648329833d5715824da2da19a3ad81aa9f08eeb23d0b9095c9e13039d77c2e25ec80afe18ec1ec0a0c979a8c79ce45ef14b5b06cc99db48521cc21b5001c047cd10bf4795ed23b7f5994de8b6cf7bb6335c90d7de4610808ef787e6148ec7d68712564f6b5e4aac216ca1b3ffa7e130800a3fec236e335efc8c2f22037f8456621c6579a34dcb76fbaae05ae2a177382945c4cecf8a8bc97212add4063e9da623b93e382a705c2003f8df8dba4487062b64fb74d34dee55830c61930fc8e488897715df0f704cd8c2f4cdd017a2f3117ef8bdb3af08f1f2bf52948263eaaecdb2dc8f204d2c95d45eded6bafc3d376d0ff085a44186eedfa065e97929d439c7dd547c13eb2d2c206ab765266ad66af021e2fd1785c7a32f51cbe9ea3b3df69e306830ee8ac0c9cfcf85d74b2e001a924eb047db2f38d9128b055b94c26fba12f11a10b487d47dc6d7ab6f8aa560eb9b41aa47fa928cf4c49232fe2bb44d8934a157e476ce348083f620017c4d0e81caffa5d88a79312a199e67a6588add64052d8fc9efb249b1e169375b9478ca90d9e50ccf3e7bdec30c454ecc27df13329c032959c000c788513b85f7bcfadacd2b4d4c750c9acd9934842e3a2aef909ec85795d426febb6c10e0d5d4af3ea2cea089b812a2bd425a786a4c270ddeef6e757789c1cf003a3e0c8f7c9ceee50f1dadd994426b38e59cfd46523b249ae84b53b632f898104989cea143d8300ec546d7bdc3d8ba66c2c10a6387dad86ce11e4e71aecd1510f58992502418f93344b4c4b6896931df49d6dc03b147fa2b341089458c6ff3281bf52d5111f5887b0dd3c2b7788d31dccfc73c0922a494df155fec25df2d7001977f82f263fff6ceacc8c3535920f5123e20c33f758a0faf67e5abb236569bb2f98fb29f5d2ed576be7650685e6aa2fb829d7c922f2534dce02e9f5e532cb491382259b06aab2a718651beb39574cea88995646418beda19ed0f3f199d7e414f59908ba9ae7611767843fc94e40ca89e2691376f81eaa56d81611f29c5887722ea7b056067ea017801654d3ce648190f4dae3d9cfd9318a43d4d8d1b1216908b780db7f7188f5110d26623c511291c11143bbd42131cf7624030598b6cd9f33eced15f4a5e4b3607f46100045a3e013220471e05b775ab48f0f5130e8f6812bdd003b95004c47628bdfea3c25af97bb59aa6c4e0f9692a72b0f91d267dc7ff46ded622e9b19bb1901db211e6f32a0e8fa2fc91f68622da56fd628d62d780cf6ed4f44cfd2c49e0e3324646f04ce28dcb5c2b380678fb157f4239992b63fd94c7397f4a6b4e24e4a988cded9d84a1dd4efe082c04c4d33a9ce7788ffc81a7159e254017dbfeed4f1263469b67495bc25da6eb9192157dbd94c6717a9723afc8be4740097863a9645438869f6bfef62395448094196bf5674ef6b70e25f937e3cc35444541c03a75728c1264089393289db43806c9ea5e39a88283afd7852c378f5a4e958c293d2ad46dd6d7267f54bce3acc823ba92eb792f455864e832d0930372f55dbe3225b5a5e68e01b5df0694cde3fb5ecfc90acfdeb5a9152ea0f0394a9a50c9af6ee2a439dfae818ba951ecff858d01fe1b1538d2841e391b89d5c6001ed185c99507464d2e679775c1000992dcfa5e38813bde95f1fa130596ec1924f2920c5cd54f083c171f4e39e7b2f63eb8ba81a6ab325d438c50d02a1efca7c9c95f0978f22801892436e0126d0519948ebdb590164f9edfb6c76e63d39976875f20b1c8ed41340ffcf81db4f5f9ad22050df389824791f04ee6ca3044612a2fb4563029b4e8e42980399b6bd508eb56e0dff3375c889b619257ec8706ef635021de917db692f8a810d4887a8c304abbf52b5f95748a60d07ef4bd3782c8f0aa3c137cead04fb032ffda4844368a412b631e7cdd14fe513abbb6ca3cf71865be0d7653e29127f69dfa84abf4fec3e90146e00896b3d2b43ed040e2e18f99168712b107c8b0a904e0cc437d8c0910506716d194e1c82c868e28416ba21ef7b0f1ef99dbd67d58fdd71aca00000045584946ba00000045786966000049492a000800000006001201030001000000010000001a01050001000000560000001b010500010000005e0000002801030001000000020000001302030001000000010000006987040001000000660000000000000048000000010000004800000001000000060000900700040000003032313001910700040000000102030000a00700040000003031303001a0030001000000ffff000002a00400010000000004000003a00400010000000003000000000000	2026-05-19 23:08:24.904+05:30
33c6c927-9629-4e50-8315-bd131135c8ec	1d06444e-5d54-4653-a2e6-b1651c4318ec	ref-2.png	image/png	23810	\\x52494646fa5c000057454250565038580a00000008000000ff0300ff0200565038201a5c000070cb019d012a000400033e75369849a4a2a5222191c9e0a00e89696efbc16da1ec7a9fed557a966e3606fb4bbefd00f400fd49ebbde59b5e1a624bfb509a6f84e4e7044e5aef5e7cf05e765be99d14beabdfedfa4037e77ccffd2bfacfec27bf0effbec5fd9bf63bfbcfa67f89fcaff59fedbfb2bfd53f6d3e3132e7d6fff6dfe0fd48fe39f5ebf11fdbffc87fcfff23f33ff7dff3ffe3bf737cddf85dfc8ff79fca5f905fc5ff8fff7cfec9fbadfdffd4bffcdedbad1ffd87f8aff0fec0bea9fcd3fcbff76ff4dff6bfd4fa1eff01fdb7f767f7ffe4dfcdbfaa7f78fef5fb8ffe3bffffff0fd00fe37fcdbfc9ff72fddbff0bffffff77d7ffe4ffe7f8c97d13fc77fb0ff55f915f603fc67f9f7f8dfecffe4ffe57f8affffffb7f147f85ff8ffe33fcdfed5fb47fcd3fc07fc9ff2ffe9fff77fa7ffffffbff413f937f49ff6bfddbfcbfff4ff37ffffffffdde7fdaf6c9fb45ffafdcc3f567fe47e7fffc01812187b74045b9807808b7300f0116e601e022dcc03c045b9807808b7300f0116e601e022dcc03c045b9807808b7300f0116e601e022dcc03c045b9807808b7300f0116e601e022dcc03c045b9807808b7300f0116e601e022dcc03c045b92aede296bc4a92b199daf12a4ac6676bc4a92b199daf12a4ac6676bc4a92b199daf12a4ac6676bc4a92b199daf12a4abf118a6e594a617e1192ec888d7dda2abfc4963d44bb779bd55fe24b1ea25dbbcdeaaff1258f512edde6e6bd9ec76e1f099fa70e411ef8c78be6de685685a2eefd7fac773c542f063142a29785e6e856d31d11d5f4e020610441a8b63e2ee00eb01066d2afe81d893c7b7dfce4b74678869f407cef57b34d0bc9b58b06563d067a27667bcefd5f1a7887b31e85120f620dc4d620573cb93e9d4b4e4680573cb93e9d4b4e01e2041e63ce996f8e86b2094747ac47dab77f59ebe32c9f181c049eb7b5817d86dbbc4c8aed8d11883c045b5cae543a0e1a0875b7523c3924e08dfdcb29ab5fb965356bf72ca69407001a722b30e820599d1879bf649681822c068861edd0116e601e022dcc03c045b9807808b7300f01164233a2f6203a85cc712fde1c4a698072cacbc1c373a0937045b9224d1e607c647e811be92005b6ef87e24c7b37e6f7eb3062a99e6867f8029d66d2080010a53803e0bc0046116cb33e861edd0116e5e8912f78196d702e4bd25a20f623e2f2d4087098280fc5d4b80bda106d5804bc0818faa2f4c065580dcbc244274219cb536125a979fe511a1b1846b20a81883964905ef5731bad7ee64c13335cacc29133ee594d5afdcb29ab5f2ee31a1e46db4b686465e41a57563bc45764a30c1249fc102312fb620e5914df032e83721262ae532d92fd3d6c537980ef92f1b4598342e45ec10d7ba54715769067f6f07b561386828605e9a73cbb65e6b1e792c4d4537f7858f45627af2f12c6a6b6b1082d82e540426cb499d5a188040c686cf70e7c334124551394b34300f0392005a44dfb067aeec320e32c665bf28e599fbfcafee313243540f34f1a8155808b89fa0060a2558f94c49ddee421bc56c0c4600b72daef3a340c1160301ab25a7f2b4a800bc4df470c154bfe95c52baf4fe2ca686201c14a0af353c913421770ef2a02214ddae2fd11ca431ec0197c2fa01f21882e161816a9beb0f176344da5e67d364bcce3e03debd06ccc2ff8c16085976da7bed88395a8dd7cddeffedabb6c377b5a1b869a7a95aa38408aef5a21d06911f348ccb25e105a038d63eeadd2fb286675a4a8346608e79acf6dd9cb786e81e04d2f6cad2a36aeed9584cc245acbd2c96c66d6a18998667b704f5d542019d6ecaaf27ee016b484461f89259a13d2316e7a518f3ac14e7fac1c07d665d5487a343ef8199cf8eb3e413dec8c05cb27eabf9359d997df971acecafd3a169307822388a398dfa3cd5965ca2d2b86eb7007b241226ddfefc1362f89a0fd4e53d81fd6acff8422edfc9bc8a57686ac0c80b49256833267e71061253a9391befbceb2c005eca10b321443137400b82af93f9ab5ef2b1d7c6b426a969fc9073b60c82828f275bbce5ec93e4485d42c14a35cc9dd9252649e3723540ed732983223355f5825f97b68e4368359294753ae6dd470d3c346f2fe8abe9289beb70998c6a687f4ceaf67ca7eca51a7f770903b962f7186674d5299be96efedc5e3c78cd72beb2a4d7c23e47f9d9b29637bbc0aabd7871e9746f2e53fb201ed347861dc0edb8fe33000735fc2698463cc2691c5a0361f13f13029794d20e88d1915276153032133f19b0e9fc4963d439b1f9bd55fe244dcb1489e41a7c3a142c35d7045b5ada8a1a615b0860b1dc84d2fd1a16a99c1c1e22fa3a706eae27269fc4963d44bb779bd55fe24b0eb68c4e37021f31bca6962d10b9eb70312ce0ede6e57d7b6c03c04d14996665d8dfb965356bf72ca6ad7ee594d5afdcb29ab56ab290628480509b1f5a1693dfb965356dcc116bd071cdcb29ab5fb965356bf72ca6ab7fe5967bf91537e36b5bd6a6ad18d37e8f35659732dd0116e6049000e759410a5d06de08b7300f0116e601e022dcbd1fd88b0746bddc9daf8a3d3c875dcfe8acc4b7ab4a6e319775f348e189a98bac1aa5e112e653072a0620e596954c41e026700a03ca96372d95945713c6099f27fdb066322b72f994b1ea25dbbcdea9e29577431022cb903dd808f59c3d6a99d41b856f95123ab43032321a2f9e28f0c741df6ecc5461b999a58bdfedd01170627a1164627ff72c460683e8ee8e86ddd99f54dea25dbbc7ae4e29aa23eb84a2871cb9dddd52dfb7d911e3d2987d03a8c71385041ed7eeedc3b4187d7711f63958f17ad9e13f40c1160375a6ad7ee5e5c20139320cf847056d1624bccbeded0ca8851a03c045b97c709aec098e5d49a6892e533f0dc07a1d09cb673e49cac7974141cddf3a2e18edcb43c4178f35659732dd0116e604860ff4e42f360a620ef716a61051d91800860cc03f2af26fbf0a2e967be76c68450f861ad72b1db96870c2e21b9ce8b953072a0620e594599f430f7ca5b98078028fe8822e16b958edcb43ed5445c31db96870c2e221d203372dcd341cfd0304580dd69ab5fb98008b7300ef24ba38b1af9bdf82215525455ca7440edaaa8bb838c59e96b489d813f322ae034e2c9531a08946c22a10fabfa4a0f0101069c322667fdf278d9d300af1705489c97597854020c0f7e3d03d6e48d7fcce53de1903c93cc082f0a40e99c820c6f00f105af2034dde50aa7cd9376ac80b6b65f01ce787340b4903bedc3eafb32888f9e4bc915022021365994d5afdd7a045b980710615a7e6df20c9d6a7817e6687c6325c99af2c9f1899b28ce11006ec0e50547582554087a05bc241016278a1363eb42d288e808b72fcff02f6194a5295f70eca52bee1d94a57dc3b294afb8765295f70eca52bd106c7414a42a045654d38afdc7c3865f376ad70b46a2dcb3232255e6f557f8913730963291e6d1e4eb822dad6b2ed9667d0c3dba022dcc03c045b9807808b7300f0116e601e022c079dcb2385a79afde4b1ea25dbbcdeaaff1258f512edde6f557f892c7a8976ef37aabfc4963d44bb761aa7285bca6962a808b73002000afa5394163ef670857cd4e30bdb19acf8e5e38d05bc6f0843eee3e1c8ef850f6809d3aacec676780415470365420ea39930030136972348ee19c01cee3564d77872c95ef0b54303a7c4683102a52ca6ad7ec2a77448b6ec7f68398777ebbdcc58f14d33683587793c4a92a0ace4f12a31c2b393c4a8c70ace3b1d131c2b53623ee8116034430f6e80091c0f72b233a51753574b929029953e70af93956f03d7b9e8939cb7dc93369157a34f215f06ac1d456acff8a519cea9e0c7c8b147f7f794d2c550116e6002e9920fb790f6edd99b88743cca4db3aca80c703bfb356caa87a9b08e10aa04e584317d28483cf1ca200013232ce9394d30e6091d00e605cb58a6e6b8e4a44f468aeb37e362c382bde73ef24ff68e660cd3abe5f66e10e1b05649a90db2a9a3eb42d27bf72ca6acca305fde92c7a87363f35ca73c495cb629b779bd55fe18cdea25dcce74529114d300e594599f430f0a0404fdd7c5b18a52d3acf7e811371c9c86faa133c3f12abf7c65bc2310efa4ae419d77d139ab05702f369bfcc42525d77528d89e00c259b9ead65e11b6cb569037275632dd965156a598e1f322aa1017b8035284d14d93e59303a6e0fdd022c068861edd0088fe52c2a89836381d3f32329e8858ab8fd7aeb190d0a4658d684c20f640b0671b7780657fe244a5b1dda6d15b166eedfb7ca52380fe81822c068861edd01599f86c775713934ec18831db464c7b44bb4e304b1e1ab9a7f1258f512edde6f5538e322ebf46af88f46aed8d11883c045b4f9571436b0cb8165aea3b7dd001987f9919e261e74ee8887a2318af3ca1e2127833dee88934f66e2f202bb614549faafdde21d35f635a50251ad984136330467f357456ab9275319605c89c983f6d4bfdccdc84ed4d07921d7659a2764707c88ae2a45edfea616164cfcd095b2cbe850153fabf151513cfdabe19898de534b154045b980468ec27269fc4963d44b13c93d55d654b1ea25dbbcdeaaff1258f5466540b42f6403da68f9fb83e2f5e18395157a10115bd18b3ab360a3734ec1813e213f0b02dd74c9f9167053e5e36fb95669cf95669d4cbe733a6d21f49ff472898b9224b03448d72c0e98db08d7074086068240497c2474e0ef84e6edd8b9930ce5d8c68450dafffd87131af5e2c7af579e5087554894996fe8ace84032b7f62e6840a3114eaf2a4cab96529843a76048613e1116e5c3280188dc963aeecf07f9999b56d12e5e9092aa840f822fb1e35f6db78d48ec679ba03703ee2b840e082603be5651183be8aaba5653d8de534b154045b98066ba9bf878eeadf1169fc4894f44b19781555d79931ea1c8cbcdeaafef8edfced8be57a4b3b5e254958cced76e8a56333b5e254958cced7895256333b5e254958cced7895256333b5e254958cced7895255ff83740ccd5afdcb29ab5fb965356bf72ca6ad7ee594d5afdcb29ab5fb965356bf72ca6ad7ee594d5afdcb29ab5fb965356bf72ca6ad7ee594d5afdcb29ab5fb965356bf72ca6ad7ee594d5afdcb29ab5fb965356bf72ca6ad7ee594d5afdcb29aad000feff982c00000000000000000001eb6145dc0fc4f56f2db7c000000287515f7d9d030389d2651283c3fe23a975d11f30dc2322e29c001cd1d23bc02c392c5a8aa2a5409ea5409ea5409ea5409ea5409ea5409ea5409ea5409ea5409ea5409ea5409ea5409ea5409ea5409e8cce81e7903fbd10850adddd0dfb6741501f6acdac1fa7353662bef93e03b7dbff7025c58e60822b5e56ec597eeb5c5a3b025fd050b148ac366697dec6ffab74988be536aeb253fe7a082b2df7306a5ff5ad7bb6c2edfc67d6a019d12d5204358989c7f142cdaa4123d3aa625a0f4fdf2e072aab0c68a7635972539cb481104c3019fe24ca10ca1fa69bdbf3d6acf444f7720a477ef464640b27f9ab9dc6d6480c341ad948eb69c90810c47f31686b2b3092bb72138cd9ea768dc4b025d91f5d6783c5e0b254d368e91f2b91fa6b442d195e6f273faadd15e7a48cfeb20ce1527d087a58e53aa3bfc5c23b4ffbda43dc7b6f30ed4c0ddf3fcf78ca9d8a00bcffd6a7406a3ccc14f92acef0bff775c77c57381bb44985be5969f38e7e7c63221ff3d96eb35b32cba27b72946b750cfbe110e45f161fa3eca3a69e7162b59b60efb94711cb143324268cf2d4141370170d7bd74dc670aafd3a27044cc5234f23556b27b46c0e7e3cc01ea3adbe994f70790e213c5c73c7043488fd463a17df3de3a30676c5b801957bf3337c387003176ff31a4ad0b0872ae5f4dd3d3a4fec7167726c92fe26fd310d955770d5fd7f430bc3e7cb03982f08b183076c1b1d8140017b232702fc5c29d36b8ce3509c2d14e49eb56b825d1721f031b29dee51deb6759f54a59201b03d0ab4443b47c733ca1b2dc4255eaf1ccde9ba6f73ed5d961c07723f93bf41aec845b30bb974da67f5e5d836b9bcf03ea1cbbca210d8fe97e42c482dfb960501b6691721d81643d414db3de2c63874a66de47ca9353830b677833a88938e16f2170def635b590267674995ae85d350bef6a83dcceefa766cd20f8978984c1a57714ebc3182f9eb279f4e0a999bf4cef24a5cf27c500ba5566bd302c9fe63f8597b6213538aec4e9ec98ece291c015efaafdffac2f3db2be209ef600db13a8086b0201fbf49bb5e6536e9678fafb2b6cbcea19767a59bcdc05f7681644a5ab89b51256d4cd19ad038e22aa28d2d467860dc67fc1bf97d79c353a270ff0e1d78396dc0fd656da00c51f5ce9829ddb94aac3a4528c3e2f805c3e859c5202a4962522a888957c523d2b7e30785b856b15155624ed39edfabab35b4560840c72b9b4c8a2f856ee3dff5e867f656de5a8a32b7ea5f6e587e57a14fd7dc25a9dd8663894a573d1e1124473471142b2130dba9df72d3169afee2a6f3c72bac6853dbaecaedab9e3e31bf684c7b31bf31fcf5bebff88fc36ba54cf9eb6f851045e2265fcb0c785088554c14df8d8a1cbebc44a971e16049a6710572d07d3835fdc464eaabd2f2ba5e234c50934c6e362ff391a3c6012cc534f91f43ec906325a09b800001512fe823e72b4829e9c5bf6ac17f80eb15cef48407cee71732688ba04c64db68f2144b4f18ffcd013f5f643c9faccaba8ec7d59f92f432fc864500514b395ff8bb48e86d76447a8783fd69984e543992e5877850620f1b12d11bcaf0d094197f513b2d4206820ff595dac397454686c69744c81155edae4be5f9edbf1b3ab407ad1fc9e48eeb84d0348f0fe16aa587b6e2fc391259b7b0c4ffbb03c138ed525475bb81561a8f7394824d195030900361ef1290a0cc6d45e9e7128edfbf6167c6753717080b9a7a7cac9d14bc14f53e303772b4b1e083a842bdb4674d2a00729b38efdce18211bc2c44706f9eb9d482d8b75ecc8eef443f8e1a7022f6883a87e5c48ec63c294eb8cc073a209324aebdb71e2f5cfd69ddefb5eb5794fba02c78203dab9e8757e25efdcf514eee207e418829f3695073604f57eb4a804a8e0d9c326554d15c1d471e1f4a8c02e99c3e96de3205853deb9066e04f5b859befb80a02dac1d97f689d20cd644f46c5d63a522f23fddcb21cf2077a3e20b5bd84eeb6c84169876730858925b88a1c6ade97aca5e7595210d7701e3f2edd75f6bea675e19526a03e31bf01d5b41e403629e5abf72bef0cb315704dd6b7e3472c0722d5d001152210036a4e4d85d642537bd6a26eeb31dcba7e5449a8acf04b0bb67daa0000007a497cab747c173e65801093b8162f8cd2ac0e1fca602029e9438495aa42a50762f984b2d46dafe891db0382d5cc6edb5c0e491c666baf5a05444851b1e7eac5110f2a8a66cbf19a77894bfdaba2800000181c14b5073489a80d4372838e970337bbb21db878806ff20168c38f884345d35729bf94616f27cbec2d8c8ec6d1ceb15b174fe0e7dd257874ca8a309046793bbb326253b45297288f0edd4a41240baece9e657f301ab4097a8137f8675b2af67354daece3ae9f518364f3edb07675ccd7f534b21f344b77511bfde46269effbce7c6fe63c6e731617899895a785a4d03717e7eaa2e40dc8893fca8091477a296faddcbbdbc5748091e08bfe0446e187a56f51811ab0428d8175534bf18ae0fc4b93e20600e137ff96907eb5be2df1dd71701ca7c8c5d75454b6bd31a301fc00a4eb40d424e99c2c4acb474ec6e933298f9667a80dfbea64bbb2f82fbb1e63ec45e415ae1dbd9539546fdf97c68cf421249ef7486500fa84761089fb0c8109812aeef5d73fdb74e1c138491673cabb6b1e8bad0da5ee06e661e06593225cc62402cdf11fa3fd8b0cea99701b4cb38634caa9f99c592db64f2c61f4f1423f69466dfbab2d203c6b4758d4dcb4d5a624aa39b8fd96abc215ffe0d4399f43d10598eb2bdaf561cba18eaecb71e6d3bea693a5ef2711bb52857454e855c86125b03c4e8ea7136ac7d4137aa3b9388bed1fe967fddf7a017f319a630aa1dd82d189eb8124b22b0c1ec7756f8ff6c9b7d5313c57f93e42301a505b9e13c42233237239feabc384207db160ee2a2ce60acd0231eef59ddb0cd8508ca1efa41d66de9419ec74d27b4db5039f490ffe948790beaed78eadabcedfd66ec59400bf9a6cebd70327c89ed1ea028f6ae9284b0bfb524d1cf55ee5d211f6b293bd19a1ca48324c033eec35cad4f7394236ee93107b3f4afe88bc6b73ef890a1547e1315218270819fc08fc53552a5fe98cadedb4a58f91ca5891ee3025da08d1cbdbe9e36c3f0cb18d72a0840057522585ca4f44102635bc0c4120af4b5e3b2b54e7fe11c722fef312adc84753743d617d7124c1a342c5ed475d998c5cbaa6d47006817679ab1e580319b8e904bff0cb3a1e656336d16ed4214435191985eddb9a34ebab8976f2eb7e61bd63afa7de31487b339622645b04f720afaa2e65116657a4662cd84afdef9da32585304b213f358928ffbe0497bfd82cf2cb1f348d801a939139869ba215223fb731b739992475bae4d70dd243a17ffbe1071160e25f0fc15999d08ccdb28737676f413990c7dd90d537e2eea80fd6831350e6cadb4d8415233e9fef87ac4ea0005448762e5dd666934858de235622a84fb88ba91050d93f1f8c0d9742c0684c40f6deec23545760f5e6ad76eedf496d00f5615c8265b453698a6055cf85c5f8d63a70df26b9f6a3042cd474681476917bcd94113179bfdd71173fbb4463e53e1d186daec554d42815e9ddbf05d30704ab79027c874bb42d004e816111220b6591206e6202a91a8f668f573c948bb8acab2d99afd32c57f366b58848510334dcc5684993c2b085737fa532e2c5df6ea5109e62dea29a4d41fd26f501a1c585a47d2c9bb447bcfc9796e237bd1981e8c9fb2c2c2d8c96794ec1ffb3d995b61813ee6afe6337c142ead90b134863be1998b12fdd12e22c0b819f20f9dd2c3dcfff18f1221e29f68ce4abfe8bba4634a4cbf65836cfc95c904dcd59008aaa9d661521bba7ee5daae1d3b0b1b2184530f74565992850e6b7e517d7e56a30a99088d6de54810b76616c3ecacf85c476330be6752c54c9baaabc58c18c5098efe4f651c00d92c572279b53443627a573131557bfb8d40e65a49fcfa830961de71e00e05d9ce192d98d24eb0734f469d5108fb0c5b47ebbd02191039dc2e66f1b30f5c923b4c4fffd1f9857c1963b6118d1891b056b51e737b6516b0c3f906be9ec35635eb10aff189e51445cb1d6d49a1b5cbe600bbfa13f533732f0c76f97bfca965b2ab4f5f43850dedd4c494f2a1fc21eda4f67a30bb33032c91fa40f940d8acf841e8801453d97a89e9dba5d3e04af222a56bc9d1cbe50bef91c0c20ff14046657221270a9ba36181b5a35a4a3307f3ff8f5a5221b1b855cfbed4f396656fca3679bcadce1e62c997a0e92545c8b18a7179b63bd0b281170c474a34980a770f3924d789702d28dc90827ee4000b33e05d42782763ae14651d1178f6c95208af5ca9db0ea974994405a7225251598405646ba4e6cf305989e445e570718978e86ef021d9e48b735c95d4bfb312771440758f9b40f56ff16bacd2f52a45fcca63e30439b4b7a57e973006449e7c2be26b1583ceade2886adafb27e9d509a6dff6e69b068cc49b0bea7094740da3cf503efc35080064e000d16091e1348dbd5b19838b1ca2d424f4c417f0580022a4fae4c299ed0b8e3b257d1e8310ea692dd80a368fb2580358852a166cf5703348a12ea5806e909d58f474da412ddb75dda1cf4978f08940b0a05f2404a435c1b3452f2d274f0fcb67ac09f770882fe4788c29f85c3e7e75f3f74e8624c6fca28dd830467c92a0a836164284d3f3166ea5c4c74268793059c3abc747baa3684867b8dd5c10d292e9f14a4c50d1c20c44b1873baa87b1968f8b23a4f844d6b1db11a172a43d4aab429923820ef454ebce27027fafd9f03d59574f156fc371e332de4f3040f5789fc8b18776cb13eb4d7e19f9381fe204bcafa0cba468b6f8c7c6cfdeb83d38f5418d7731e18f86b022506b0d56f8af59f395929c8b350a510664851bbae0773339403fd42609e970835491f9f009d2e109391474bfdb9d005c295ad0bf72cf2db245972d8e811c1752bb9639fcedf5ec58c497af531e3a0a19adcce2d7a87707ffe2db4e36077955a291a2dbac79ad4bb881d6db2d6d830d63d24b580431ac58e5d5d3604d08153ff42d9f10b8d971b2e365c6e3b27a8e58322a165a5418bbcdc139f905f20be417c82f937891caa9ae2515f9d1fb87d388f80cbf20be417c5d9572c6ba68189fcf88d2cd895d4270d068b14bc5d95927905f17e5574f41400447d6a968b59a157d8b99346f205da4eca272f299261431dc5f6658bf84a801ee3eec86390fd9181b454741d77ddfa33fca1eab240f2f47fbce643a86ff1c2d04b960c998f2cffeed6770e1942dbff172280bbe0a683984370d84e24f1eb170e0d7240654a2d137772652ad210bbde71e5864845740eedcd4ed8b59f3f29f4d42830178ca33285fff3ef271e42054f496f1878a22c13bcf4b729ca0fb8ed8a8056af913a89ba0351416a2a05cda2d744b7f6917d995a98a8f42ab0d5c6a9df7ebce1bb477da3d5e59d78516fc2f8855c0e60ef5208a81ee986a0843bd98f4c8e108a76a61b17656b7527b33a9e558a65db319de9c2cc9472a662e1050fa256bd1019af5bd12033b207555e6ae7d987996f483fdd015c3f7bcec7af3ec439ca039e4d6b8d0f66fbbf081bd3b72716d8936d273f27639fc067f93f736a93de61d2a50c017ff16bc9dcb6fe061e929bddb4eab05700989e537ec8a0900e0cd9bb85a585f0a542b8abcc4921a053d24887849d059acac741636124e09f8c554c0d07ae80fabdca8a7906f568a9e0254e8794d60d2298dfbab27784648ddce58d8d3cdb401311d586f19de50a33575136ea878d8209583183e4a7c4b9f72a932e01c262f97ad58cb30af9a145909401f10499a289a84277f805ff176f04f30be398f02bf2a92bd611edc44857e8d1e1bfd390258a62916508b5df63efb2e97d9b2920945f7542b830229d6e9d0061c1d6be69540229339062e60aca8cce9cc9f267d057ca071f6e1b0f30baac07dad1ca4b329dd76553fbb6c731fabdd5bd1319bf2b6f43b64375443ca8f65b52f2d4e0d75387e4de3dd01466a9493d950b2f61c3e0b7eda61a172d09bb07818df346fe3c027d8cf5ce3f44f95d23417995ef56a2b35861ea999671a2f15bbce5fbfe3a693b79766742882d32f5267f6842c242acfe025a77882b4b51800275a844144da564e2b6b0e5f5f53786356c94259a53ef321a23358dc6f06cd83832c2e3cc190ea382902f13c1a650815650ee78aabc1b77ce98968a46f716e5af9be729a91ef4fbb3deb852d96330d5e4940253fed214df0c734f4f96f84047b40ae273f2a5df21fb8048f1cdf1bcaccb099f7d4ad9691cb84825fddc4cfc65974f9a62d9d2e36f1673969a3464bb71e83ff165be943fe25b6b1a4064714ee98136b32ed1ade0f8b9a41a960d0a617374ec28232d5995c48755650a37b61cd0846f6f019ebe3d6df4211563ae826aaf22db24ea47b18699a6ca083cf14ddfbe0bb274f2307f6b3d219d2603517c04a82af833ada7d6d721176c22411c52ad8d3362ea3e8ec5f50a5972da2393cf60e21f340a94f627561137a847415689f6c0aff33ac30f63010885bb75eb0c479192cb4a518bb5545b525718208fd8efbf6f848e6c952d10e2e12fda4cfb6cb831045c212292f0fdb23b07843900ed4e11032fc16581e3a4a1936d82eb5f3a5accc5e9a12047dfa98277c11f678e2647485b76b838ff4cec47c68f288de7bb6109e619021844d52ccfc408e069e29228d1c9cfe076978c77b5fc0f263a5f76003c302389a7a8cfda407ecfd2dfa522650c9275f0124eb519c939eb9b6aa7ee147df14ee7e83fa9e011f0f4f72e14078bbeefb438308ac3819dba8a1c7a911548c6388134d08a5e4e061189545c9d525513d1120f3095dbc48321bd14baf5fa977c9a29afa42e8da339c5c7676012d6de606f01f899c13e01d34015568ba4486de2b93c55d133d9656edf99109c2ef81c3ef9c3700fe531bff661262353ee2ecee805de44789f4c26660907a3e7a33fb2780a958d182ee928a563da4d1f8b59333a775d351ce74718392431270ffff7b3c7e2275b1759764c5871a4edd9f71cd617d968077c4abb0c3fc420d38da3a1104d6f0f28e228dbfb066319bb9e9b7c145d81f13a764c65bfc47606674232a59fb5902ef8093c046275a923c2b14bfa653383b2cdb8a1fbb85776a65e00cd41e3d93b17da62e5b4e85684628d0047b4964798c9ecb83383ae1a61226430661acc4c3d6104dfccd629b4b886566d9a9dd428761b54460c78b00707e5860d97a594634b2317bac877fca7170d9a6b6b41507e18134401f6c0efdd073d64c2a47aca662cb7d215538022ad71a43152023a73b008e28cddec637b4da1bad67b68b7df338572b352d198d33272c7013bff9bdb0bf123b8999047821325eb65be8205fd0aa2ac757d6a40ed44feab3114145704bb6e502d39115efb757b3bd9daededc88ccded02ad6a273c3ba1194381a0524d796329448ab5666bf28d6f82754bb94f5dcba55cfd849ac338c3485e058d34b07bf85cc6be9cdcca2137a9417e1b1484b508d02937dcf71bb0682148b946f6e8ac4da99bbeec191b67e1a842a7c8172064446a4d207cc5199a06f6438e935ddc34cbf956d92052af27e7cd14798a69ccc9adc9fc41808fea6c47a3921196696e58aa89dae0baf3cc2f706c20295a2eed1716b936aea5ab80bf6580cf467115050f07abf6560f70a948d97d8406bf63310e2c0efb651c9dcfa70bd0b5ad67380b1b5285b33f4e636bc8bee6e92158e103fc58f37bc7ed4137122e300b9d78df2e8ecd4321c74a26fe6ac8ce8ceb77db8255587c38790f6e85c094e4829ccf08445b07b682de59e5f56790d3a99627b260c2edfa27c8c6d2d3a97b7e150bb008ef794fc59feabf391beae158cdfeac83cce7c49f73cc1b363dd1b654c6a89c3baec3737a7f2d17e673ad27e99d5ee765c3f98db6705062eb039048837cecfc1d5d4aadfd642193d41307c5fbabe37395bc18b237f2610bc1954459abec8e259debd64e0a7db0094e5a5f83035b215cd9bf9d0c74a62e2cbf2f70316f8ea8b953aec6c04ab99a649e1e8d602d578c9d6b642b9f6e2989c99e19cc23d144018f7edd9d0f3fc29256645c1416471c621df3f0dd85a79753406447d271127636336026504afea902153a73ab1a7ec016ea530bbfa53e989ae1266176393195a9f10fc7e7cec0ba9bc2a724f1f58448472f5bd23411385376599bedb444d189157f019156bf2021bbb3a4c52ea5e854315c601c1bc7b20d18c5a2b1fe6c2c04f2a3f80a82841a588950c63cbd0f7cffac8f0f8287d113036f1872120bb33ea36232813757c2eca157899187e44e88040eab6e6ee7bc81a2ae458e60f049d9f8bd6f42bff638ac3bdd388f16f949ce1f0e73a6c7d701893115ce5f07f186fd4b43548bdf32b529f7662f8561d82073cbe059881c1f84911bef65a7dcc7e3707d040c4756f5e58e503fc69a90545da7658e0c812d83254391f927e1e05e882e513890f6442902f1e1e2da28a898d15f1ce668e4533f11db616e3847631ced972f1158d57dbed5926c5a7ab9f7ce632c8f567a2e33d4a1121afe1883517a0bbe8811878d12bf95b6be96eb1fdb709915a7fd0988edb970ce0ba327ece9e5fe740f5badf06c019f5cf2e1f71ce4cb3c521951fdbbfe18b6f275ef751b1d63bf7ca024b35b2e45105092dac4874b1d2ad10bfe81207ee12682411fa3256e1cdf06be4223047b8b9d6802099741b98651f66f2afe20ea5f3d8b0e24fb29b84f7ca3ccdfe00470fdf13d8d7d8f9943aa5ce278a03628391e42c876c0582855d0c9edd8c89297fbe41caf6db9b51d5f21d8adf96cdb5366cb5a033174b21846f1ed0bca7326b9caff9036166d61e3bccd7af1d9aa62ac8d93230e4d7b70ee33407f5e44112abba26b5254ddc1cb80c028162c6f3f117a798b478936412169b6ed99cb52d65917c8f260495c0deb6437e84aa5ec863a26f039695ca4ca422a8c7e85742ab415233ee06ad0cb2783216a8c75e416ad714deddb921bd6cdf12e8d808060b15e4f0009bd734c0273b43b6147edcd6d394bb3080580949ed0bbc24c7329544cd8997ec65d80d84f8825904b1097cb0b22c5fc083e7c9ad9657d7d55d279574cb674a09b5bcde358d3739c0000718b2ede9375793d217637bca0762fdd05cf80b7fe6185b7f5148ea69886f73b643c70a15bd829e4102581958c62c6094fe20725c6ba6aaa4ed92e36706100c5635a4b2e0987c604b58f8bca83df212f1d793431dd5ddac00c46761ac625dbcc2bf2f9361270971724059e4b46a8b62441ff42a47f745a8009713d32a54ccb13c7fd5ba9b6e1aa6cdd5f81c7f56ba9f5bcf98dcbc667ea0267679c764b98b3fc526dc330f8fef26dab88c8976417f52efe5fecc7a2a1cba99f7493569c8e34c0dd9a79236078a28ea683d5c3a8f4ac6aa895bae9a3b3bf48712db452be324308c887b8f0bc82bdb1a5a562072629f3373dcbdea96f2b046ae0ee820c2bd2065b55242c389f20a231f6441f98b6b63e2077bcb91355bcfdf316865ff488dbfc4683bc6ee4313b442f7bd6a58584625e23c8b06acb7d6c575ff0e4f6761e817c1027e974faee9ed07d30975ab16321726e9089fa1e014a7c3bdbf67786414863c4515344f219b80b1ca9865740d1cbcd7acb617bb0c0047f08fcd5b4b3fd40aff958d9f9243999e8ec9caabc77b921b2cbd97d57c7deafaf18984b1a658476b9ccd6711a0e2a3e938b99234b1acbc02cb2d35d6ecd86bdd7a2fbf84ef950241bf30c210806f9875493d58cf4c33cbea1c9effe5abfe641e97b0740801bf7c48ec177c9ad26ef822852d1840c7f546c06db68bf45a0cb213a55c03c0b6432f5ce30be258eb0da37145ad581631f8a99e26bc8ffc0a40bcbfb4438d5893f939a6bdb05b7acfa6c888a21f543b264a038923f945e679be89fbbcd3a70ffe24fe2b106ae7894a4ebc46ff3855f93400b66b735cc0d13ff9a2bc1ca8934f456383a02f56cb2c78e75a58b740fa9311f42c361fc3806031be81ef026509439613e9738ab9925a05f9d70ea67ac40e954615c285902e158f664c7f6cb21bbec50f37c4b932b362ef427722a1835915019aec3320461fb48a8ba047cb0222a357e32e3b48fed4888f0347b27a8353840fdd1911046997e0bdad46a92c08b1804469b2df30a4288584b2dcba61dc5de7af7d34544c5db428c255fc9ac315d8d1b66e27a6f687d38fdc47e1662a99258634d5578250bab4c4e221532bdb7cd68be0d459f0ffbf602aa83de7924222d0cac59d8f45452ab0cec1ef07d7102aa0e647649d2d1caa773480b4c69356b9f49a03adf5cadaa370fffc4067d478a8fffef4d63cb158de1957dc9b9ac48c23f1661597d0744c05aa4991b9e9e2e62541239091216f503f51087b0940368a8f3d02ba60c12efe3c53c0c028c92aadd130996aa39bcf8903d0df6dc13ab4363d9437aa20984772f4aabfc6e35115e283ed1f22bd3604131d3ac6f2a357625da8b69b21a1d529dca6292c5f0049f872bef570708f07a48bc6ece8c5a50e1978e6ff4524dff062245b91c0656930e23fcdc45f81e3ec514adf791d85696c50e72d533c6588d53197b9ff28deb1a19a7e165ef7e04546eb50116c6d6f4626671224273654822355c5532dda1208bd426841d21ec8a060d1a8fdc4d4c7560ae06ec920a447d4f7fe6707c8f76dfb270b90567ad2f12aa4e9ca5d68a5f1b80d5eef33c09fccfbf7515a931429f94f84c99f5c1b5b6b96264e6e805394ed415341ac8cf8ec457dd9cf2cde13bf9f2c7846a4d6b70c46187ccef8089ddcc1983ea9992254fbe4e367871e0bfc1e1f7421040d58d2fd50e089068bb515b553519bad46ec7ae29abefae6d8d361b527f51e2b52283778c9a58cb38a5815b8a906ed5d5488e8ee80523980e7bc1b8b20a056d9b07c1eba545ab596d76fc9278fae4268377383ecf6ad27e2eb094018864553ac1f551f6e35161d9a3d4ac861f0b8999b7287b422a5c118d5402738a55c71e7fae621b49f9b90f66cdd06121517952415cd716403d0234555aa700e6a14476b7fee940a4cfc79d7c16eaaaba43b5d6ec205eb7604dd4e10614c32a6b597f2f8ffe79c735d4ce365c059bb4322b336c520aca0c90d6468fe1d9369847308a20897dacb8694bf6e7ca5ee797b37aa1f5f6695b2083208328092faa2faa2faa2faa30cc5fcda701ae063a015322e06bc077faf4ba7974f2e9e5d3cb85b26a2e90d09a19c94375a67b427501691a2b75c46198bfae230cc5fd7118627296f6a9e9c3f0c4ac1e2970ac4b3dcf2b659c5826f6a47d6ef8ea0c1962beb9b4e1227622f0546abe396e2f0babb8426ad9331a59891398fa018d08701dd7f3a67c80a310583470ab2da4a3df6fdd468b4cbe955c5a4d3920ef18d34fb025e10862c395e1ad26cf608edd5167f5b811a7a996a7505a03150c06b07b3bd3b8291afbcb36f6ca87a41198f02951e5056d8d3bc710586e8f1e72db32b27a9ca1cbdb1603fde3838d4df2234f0a4c0da0726c187a62b022b5d08b1355e157d21cfa249607b1d1dc1de9e58d31e5f3d2f4cca7e8bb721c19f3fb9bf050deb3af26ce014251ae2b1b105c65f5a5a7adf2ff5849a84f91b8c05372fba4cc42720008886014da433715daa4582ea129268cc5cf3f8a47fb8a35e4f91970acf3f23c081de314f14d5aa91483e098d8d25193f8bcb63de4127408bd0067eb56c24631ff933b6b65b9d322a4854f033f60a98c4b7019115a3ef4c86b1a35f7cb50f8466907aeedaad726998c6feae5f600a74502abb4beac5bb07342e9e21c1b89e012ec747300c3b978dbd8f3f9c000000000000000e78209b0000e9aad7c8dd88dd172ecebedb05e379ba52350b34b11b151ed849fff91cc1aec4ab053ceae9a46c4b52022616e88f3bbdf6c4c03127cd9bc44ab79ebc55a9c997f3f06f43a7ab92d8be9e6ac46f16e8a7d3e6aab3ec8d7bf0d7ff85aa1d7b973ab9b0a043ee887cf7e8d2a3a169a1611f45687dc71307927e280a108e113432dd8eb43d88236af71b67ab61afdb6b7ecdee476f48e445e4b910659b4b76a07241001663e9cfa225876737ec1383842842862671eebb5bccb97b8ca7e6d8e5b1e1d40b4e00879ac38c90d09bed01c7aedd06a06dbab9350adde521e07c6dc8465c80d265bbaee0823c9473d81c2d73ba37fd1a0913d703fe9f33ff4156e165a69608fb7997349797c9928179d83e9c512f2b958158fe5b04a5f64bfe074497714dc43d67dd1cb83f99c96ee7723eaf2ed07293fce0d8068465d9463e34511dfb33e3ca4c45485a44864f7164d2fa17e58cb35b0a526238144182ba6e5ec10cf822acb98a9509826eaa9a9d410caa959c9aba62cacd7f652b56ec68ac8101478a0805ec959012e71a324a1b590ee230a93ba7a44d99cbd23694f18c17bfcf7d45af8cb39c6ca789946b69be5577c97a7bd3c24789eb22e39518ad1bc328ee9fb19f2770009a088d87303380e4062f5e92193c5edff58000ab736ec8de6c97a6883e10c6f7e6151c560002d193dc1d6922ed290174416f77f571bef71f4e9ad7eddbe29676a7f0d8c78b0f8d904616680ae28a41143e5485546bd50b16d008117c5fdb5ad599cef79d3c931724dcd79f11e7e2186d63fe97e5b9ee81fb2a5e6725eb67edae5dc82017219ba7305794ceb4ab75a1137a9831760410e34036c4b6b4483769f29627c004bd7bca5e183f2e4692ebd518728a9bf848ccd9006eb2cd8139c9767646b1b5cb642522e72afa3677efa35ebe0a9b744afb9f2f15f7c8151d8bd8d909fe228782888234050f931b581646731a451ba1cae38a8b3df3114562c79c0da1b340ff1fa16bf74688897596031681d5384fef9f41910375afe65edca772313d27b7edb03cc4cfdbe3702662363e2cb5d7a21efca17d63c31b06289d808e06e63676c8eae5923dac05521bfa0c6c86c62a9561ae988111df49d2f43392f94ca85e5e5e55789818de8a5ca861998ecc651264074b7ce5b6a620b0be16dd75094b35f68221c501a0d2efcfdabef355de8d67ab151d37831648cc8d7885908599d2000cce398d9992a1dc26dd1de9c7ed5d427989ab5b7e1fb4ded940364b208469f2ef962bbd8d2c3554e6f0d9adff2787859e145fbc83b8be6fd869c8b1a79e301885d409539b9c03327e9442c5c4ba08c98473a9724ec77ee543a7c521cab46a304bb9311c3ba2d41ad17fcf61a4a10f9e1cfac0756b9e0906ea82812630f91712a85fd8fbe4b0b34f57cddce1f0785e21a15147737edc9829e8632e11fac821c42e9f7cf1fb8ac9d60e1be37f6d1f3e0e7a3d33a4e233681baf6e1d15a3399e9fa66b02a795aefeccebc096d8abe2649e2afa603a986af08686eb54c7f209940c1a0aecd297880e00c2b5398432fad9b18c3725b41281fdc1adc6e55a650e202c7afc294cef58e0f5d62daa1808635280cb37295583d8a271f3d4d21f101f36b5ab6e59c2f830b1b8ae332bf18efe13022342026bb70af99cee2623494ae3aff2706dea220762f9eae5c86cd9f9f2c56c074f132d188dba2219542ab29f60ee7b6856fdebd95469f1371d13bb1b317d45df52898b0d4fbf53e2f863cc3c1c16f2793f379bd9b2f2f481d850d81b4fadc20a29071068471c99e4fef7213fa59071a1dd10703569e298a9f9edc4dc7c7f270cbb86f45bc9e75bb8eb464c2111dac99431734f4c79215140747c6a1539376a20d9867d09a0875e3dd027870e622cffafe324aabdfad0fbf77a8e6b3101fdad8be878db1112a3f2a7fecc0879192a816c67f1e1d9c632e707443099d2b027d0a3eec39842e2f7a60a229ace8a916144ce22db8702dbc0bdf91d31edab830ae26a6c7fdfc3403d1aeccc0abdbb384576c96a828213cc9b702810eb1ac938e333454d1dc34fb3cc501a568803fdca7e71d71430eef7db68e50b795276865c5995e3021e4c3e98ad5b745b6a1dc73777458f452d89e52447be2c1f5bf0067bf9b9006eb8787af57afab899a8421ffbc289fd654b653205fdcca96f1d603357892f2ae8ad81996fc3de7c6a658f03d450592936c24f24977487d8f83124de711b2886a10f5956cd353a262907d784f446ebeacd84e50aa01ea76e8c08fc29e45f1a4a97ba0930c94a373748030250f1ddba488e877c7d9cc6d703e89a0e3145996eef70b2c5a335c47650effeb9e3449740001333c91e43a20a21fdfa8f666c1e271c60135741966a18d771dc1a1441a20d5c817986be565d59085082adc75c15cc072ff084a739ae6038cc9635bd5cc073b46d9e031ec5f61005216dbe88372afe7b9179d65801252783aaaa0b16160969202c01047e1ba8a211046d237f42c8cb693080037c4c3daa649288037630aee54ca47f390ffd7b31243dfb4f863a9304a61de24f9b21aa0afd91f17a939d1e67247e86ffa814b062fbcd581b3c90e773467d9c5447100cf86cb63c44b65debe01f760c877e02fa7f2b407c41aa98ee5a7782d37f0de20f87e6fb21b74cb086d2d641ae6e6e214377448307a1160e6c6fa173b21db78ccd743ae16dec40e6bf4d757557915f6eeb7360242d8545c7b7461a052ba71c8801c0bd520d5cfede9651ada2b2b4e80f5c2a127156baef86e9f030ea8be2a00009b411b3f5de5c78abcc44b62e32b1a23c2c1378b3f8e1efe9bdf25d30fa1e1ef6011054d36a0163cf498e24cab1dbc99bf67bde1771d6d5ece5ca9b3fd0530b2c65f2c0936b29b868602cdc052dcd51048920c6c859e31d7fcd0c20770ad23a697f3221c6180dfcade3100b09ca3c6747087f5051ad8042c9334e0b77d2f91f2a2e40dde186562293cddd7e28c2a3ca41b3c1792c98604cf888ad11b898e157942191de668a21da29cc6cd9519f1a31b2ad54a37059ee37cedb5b89c19a63172224295f59031f45253dc4588af1e53a0f2c9546a5e62532b20278a4f7e71006b74a87eadc54b8a5a2d709b16966f23d880088448b9e4abe46e3b3106e1feeb90b17149a826da06314560cf80cf55adc9d962759a8c7e69bd3c5c5223eabe44bea444eea1e1b51792cf9b7a6e7b8f7643327ebccca6e63f79f0a345baf677d8c9c9114f1023b712906ea3d15f44b68db3c9c6126c7f910feaafe19dc1a88556f570ac66d51d077c8cd1d374b0e52c188315a81c4bed0446f98e6636a02def2dad780f09d6e1540241f00b94909650f4d6d1da07f0d88d238efb02b49177a977cc38504292d7d2fd7f3d115c94eda9044433c2d3798471252c63abc26d9a4273146723aa5a940d7fc83cb8d67baf06f27608e976856a0623adcbafb8dd735170ab9141625d5116210e36a4645613593821db0a78d90b2d6497280a3d1950129f57359c346004e078eedd244754e141c45076a5918ec5040a9bc8ddc1d9ea78127473a2c719a1fa56532880151ece613f27035754a981c45a73fc7ab154deb4fe013df56b44f83bb84487a76c12f2580250e8a5a0f1d6e69226ac8ce8be5af05f68f14c589fb6fcef5321c69e8911517376c94f68c839779ca6d674e469672b02e1a7d1779d69cb35ce3243319f6c7971c244eddbb4c62df8259771da36a5b5617bd7f5c57f4de6aae7c4aa9557a2c016fa1ef3f320b5619a89380f79d3967d8c032050f441478784c96200aecf4be4297167b63288b0f16be7eb1177151a791d298c63882962f10b0ab56782cb9a4bc5d54f42cdd8cc01eb4e44ed72ecc445766ce4b3fa5db1c71708c9caa6635f83ab188f155dd665f9dd7e2dd0613df48389b5704017af916cb5e245222968369cbafb04044d3669974d9094c075033d84903234290f0a7e4a66024d2e4f3c7fffcf38746c45917ba65cf38bad6b80a42d8ee640023a29360e74fb9d1c8fc72e7b9d4a6143c3cef0ed2ce06a6625196e5801610097d7c1e36994bfe71227a33a55cca3ba82e4ddf6469c730a78e1a2c6a22077c23aed903f0292debb36e05c5b45e9d5b0ba178b775b17793e2f878952c459744b6431a970fdba1b85b9bcd10fea6f7c30afea607f9b86a416211e49dd288c81a488c782d74e143615f4f805b6956072fa3d1a174cdc4ad78b48e387dd1ab44a91f5a88c64a609b969f4218d969703e10e228f6ff6eef6918a4013d6712bfe6944a33a0270731583914b680a1b73201ad60a6ab69af388f88b0e0e232e7659ce48f2bac39a4ebdc287a14d82c438d48409c88f2bc5955400a89feed37b00eb3200fc33c1a83741dc07f225846815e87fcb0b482ca16ff7bc92c5cd356985a5006b43037d92ea66723c2ac07a4b5d413195652c6fb639933c0aed4b6447601d177767adf9b4064c11016ce63808745fb1b00d09766f23150639b9e1f3fe0d67ba7983429e791f14ea15a354ef0c305daba058a744d756c097d2010d028247b9f6fc1d3f9f44d4a69e497461a00bdcd893338e6b12b7fc734fbd5cc02d72f87c4b61e83111dc88b449fda54fbd0f051a93facb011e47cbc572a0faa5e7704134d0965a66058356d2914a92eb2041b6ed23a0139b52612f17edb34b35262ab3f084006adbf6db51a4f839405b6956072efa6c5f236d0045a74daecda4d110d27a58490379ec7bf76e08a616ca58f986b7cc1cbc1c1b5336e803d93e313943341ad1d0b793ea67ba344096d11795283dd41ba35121f8d6fb852e0f9e442b95815cf090575b450604fbebb6f24bd5422ab014c3edb866e5ca7c94860c7e5b8d54f4dfe5d52f3fc9e5b9223ddf03ccf08bfc11c40145c3794961ab645b2d83ac9d8064750a466cfb174082bcea831cf406b08a092d7725b7f04435d6ca5d5181863b37ca470467459e846c2767601e2269d6dbb07b0286fcbd06325301ffb4c85b34251f8d65d9b945af116b91a081bf0a55070a58150eea4fdc27359b62fb4e4d53a747de4f934babe619383e6fc27bb227bacfe56308d07d42bf9ec7e1129b9b16dc26c8a11aad3c17272cb15f905a2259610a129962fd8290c6001bdc41a54a52d1aeda83b47681e4979f91ebcfcbe1a105f11a5528836d92303af29ccbdb4755c73dab84e5f84b42520297c8e53aff030120c669e8e55bb8e882df88061ed5ed5c94cef0f1807889a760abf772a844b710d21e7cae87dd233cd5216ddc00af0c74c4cc345900f4b0d07fe4320a47b8f231c7dffd4e5352d1e14493ecce7af4d91f5837d9ca80e44bbd2b7e5f4854ccbc9d875c9042bb955ddafec02b3c22053946b052f1a264baaf9f2ca8c10cb47c8a6128d19ff49955aee3c47d24d13668fdf08a1cbf086e5a7f2c1c261932a40003e06b6832161b0154b677c27c3399227983ecc95a60802a52e1358a673763ddc6805b65fd872c0c9df7634f817b14deb5e50f705c697e5504b38c0dcff9f6c07e4171ea1f4bf29598edbd5667cfd986e108a8dba6b8dfde7c66a09eb0876dd6eaa8d5648979b451ecd16d19701f00e47e84fa243f3507676bfca669bc8b1ba08f15546704bf0698320081b764cb9de98d3624b0a2105d361b70e2668eee42ea891ee6f57f47a9aa79ad0a1b484627b9843eb41891336f27f8d7bc9b924b71453fc1d08affc33646d141b3d7d2875f0702d3f22c0b90b4a531a6b09a61b80245a206649177c3271ad814eb20a15b918521d3f75707042d942a6af7b165c300a59ab5aa1ae2fd9cf20a322a131e519fb935d3c7cd64e3025a99d19b0572f32d4a80bf78e19abcc72b23de637c7d1f58288115a21405533c5648c06dd58f4be0d0c906a46ea3cbbdd5e178a27b211c3de8f5ee2e7077de81766c425e85b587cfa8b3289db02c3f40e2d987a8b848007adabc2d8393801285136717e717e717e717e717e717e717e717e717e717ef3643f1e1f9c5f9c5f9c5f9c5f9c5f9c5f9c5f9c5f9c5f9c5f9c5f9c5f9c5fc3b26d308e603591a3f5f1847308e6035936980d64da611cc239847308e611cc47bc8698fb2a972361f00829108000000000005b7052e8f96348f68450000257b7f005ed538b53196fdf8bfe4807357ba59cdbea9ed345cc057c590ae74a549f34fc058ff7d16cb14e56ed528ee5d4f5d469e1a85315c1c2a0f3e5584daf6a0609f4320aaeb26c89be2f5e4e724df194bfdd127d850fb6d5d7aa1f159a8d035626dba44ce10c171e2451f792c90facb8f0f45c5813dd1edab5626c6773f4844d9a903bfc15af637b82ee0f7e5ad2e18602af016aba7841fe166e904c977b7875f7542679bc467c941da887612d2f9e343c1e4ac6bc18908ced5b668723fb0cd360839799f24ec87eb1db6829674c3bcd7893bce553c57fc2315acbed3eb41a83619af05d9356d21e16e5477bac7bf3186fb54b4ddfe3361475807150e0c0dacf4d6ebafdb91b83e4774ccf83c917fbc9c0882fcbcf1d61a51d5e44267dbcb957fc246e584c2ee1f3191f95dbc2cdc61b7935b2610f7f3fa3348fb5c6289ee4926538770a0338c029297c091394baf7e8b367ae858cfe463201def7077148dab9da9a66805c6bcea8b7dd7af8c5f577debf14a60a9892fbc4617519aa71e4d9c9ac400586dc33c213941fe924478f441b2807021b58604ea79b2fe754a7e30048449c00b2ea27e28918d993af293fb13af398c90cdb528b158ba661e4dd18dee50cbfd72be58f20ec491a952bded2080d07526062ad364441870d91c320d27860541d55412062420133a8b3683370f1de61b261a74bfc9f759028af7c2ac77c0e496c1fdc60c9292c21782cd9e404587c24f6eff05c0345946636fc9346f9015b92e5d22bd8b74202da8f13bf95e4f7efc799b26720ab14ebc761a719540f505f41177db72c41c0e1a0a3be3e67ee8f3ae20a5404d032a792691f13185de2c8f710f4add013a5d758c8587322fe649e08caea26464693a41e08533417b452e93666eb9e3a8593288c44d694d00962748b2b990d9f64a308058a67697856eefc7cb92d95d170b7d7542a795351bcd8a4da27aceffc62829bcf9f49dc197105f82d04e85aae36c6c5a54ca93f870c89b46d7aa1fc2bfbab91c5f08659fc7139ff7b4bdbab85f524c4e3392d5d03cab1cc357d38fec49a62f957c7f0c732011a2dc93354de469af45181361460f625e8d926c752d2450e95f22e00bb51f5b07ca95589c872176dd127c794359fdc063eb8888f98fde0a865b9eba27a00063746694dbd00dd00db44f438aa3dc542c438faaf3e5f32dd20d01438b6ef5560bd5b0bc893a439ad32729adcf67de371071066de51258ab070cd18d68d288af64c227447cec8d607b856bba3577566fd2ad85d2ffc4253cea153376910a1c25d78155ad274102c1cec6f387cc45f6b6c0174ff0c16235ed47f2c56c558abe8d06e39db0b673b7a038576ba84b7ca835f9c0e683e1b4679d17a034e6e55a92d79c957bc3cfdc396cf2457232a6724b1d3d827f6e80a9fbf22a3abf9692d7f17563d8f83976ac98835247c76a816f083cb2df66a48410f4631cd7ab835d9db9b094fc5e81e8289719d1bd27618a5add95e9cb78abea736cabc30fd7aa88b4be3de02cd59ddf5e3485446135b5540016eabcf6a6a6409560601775e34da3310c8d29000000002021058be3375ee4700e44c05377cfc67e53a9712694111485c0021ff81d2b996f9ecda48e1530fadb95a0eeaae30a98a4b0ee2ccef4319ebf2e80700cdbfa8714b2e622bc6b410068cb77674ef922bd88045001d54295ffb8d6af891b4b55b47e68c6f6bda78e80cf7f28ca8724725945b1971e262c8acaa18583fcf96d12c48592538d17a352b164b1c5fd32b3bb0e9867030ca52eed0ecd2ca95421376fc04d71a13a92caa5721764c8fe13a73ddb5f35839da249ceb9c8c172b786698a30a2333c86991a98848dcd06a74fdfd530f4bbf8794732642ffe26cdb066302643566501b3367caaa79ba4808dba04d6a1b4eb6eccbdba6ad267a2b3bfb99312b82374dca8b0f98234a76b019c89f8d664fb6cfb6f776e310cf758c954aa44ba4af578dda19e276578bd2dd20fb97a0a32edd794197b4ee7a1f63a07c716b24b6a37f923163beace6fe0b95bc335249ec8c5823e1513845a085d4343f28d850bb82fc0adf33d5c8d1a674f957f160a724e809f9b36ab97262f5f2a3f99787971f8f7e1513845a085a0d143765c256c0bdf98da0444d6d9265ee2185870eef307c6fe361168fa61ba8a0393525e6fa780408e16269c34818aa33f200d59f052e3b3fe56b13835d45f624162aa43e3eaba03a107d0b99f29a5911b0def9834a3461c2132226cfecf2953e47723aa5e25ee58bb9eb3f7e01fe49f8b8bba5819bf09217d342c527af4969dc9c2336da7c60572d70a788bf3f71bdeabdd8aad4c941de7e1d296244e6f8087a25d01b81eb16845091ecd6f45c372eacf74309448d8496759ea63f53822361d1d2be8cfab5d41a320df7e103bb33d3a31216ab6b5d59fd9775759c5e46840b77f90e756d6923396232f22972a360065170c7bf7fe11989902f70396ae3f6488bacea5f2d977af3323d6ddd8140f57d779cc39d5c86f1e0b2f9db36619d51f941fa5fa9085307bfc24365824a6c08a5b226f770b349332bf93a117cde1f729d9688e74d049f14ffc1c6a4ea9d2535e149620de65bc6aad2e55421d84d46652c5e63ff9a05dd414240fa850ff82ac28983743e75ac7ce99f0dab2895d3838d6a08d241d74e4081b90288da510889d47149aa6d27b00f0f9c0cb199b4c0e66cb0dd77a5af40f549ea02979573f7fe3a76928e3e089741e5f03b9346e5472c6747147fac1a1545f7e9a4cf05660349efa55850bf0cf807fe171896eb1730d1ba6284ff1f3d5e3cdd4136186c0ae0cbab0bebb5bdc32d78badef3ae373c0cac8b9e47f1aabfba283c486aa5f03b6f3f4a27ec535bb76ab3604db829a86afaad97b48392eda4f13ccdbf9cf9cfcdc163eca2f5d7e2ade72750f2c88d81efb638384c6a2ee552d1d44dbec1d76bd8aff3a43d64fec9c6853aab144881f66f169098a547bb0434043b09ccf6390765c987e7a8404855ba9dc0efea794e9c0274aec0687ed7ade21a2b064d98563c67107d2c64677b58de05db9b1ef99b461661f033e3a25ba5d3a8ecdcf9dc64af604812099a007c53c4146dd85d32ce5983b9d79772c0814105c895a8d1a7e9b4f5cf6314e8b15743426f2a368af22d8ff105461319cfafbf60877d78c49f7f846abccadc970492e6faf8d3a0259c8f809b2d5343bfd89ef0fc04c261709837c6364bb41cb4abc19084853bd39dc4dd9a742f9e2f1c8113089113012b603b0078db2474be49b48233e242f5db286a06addada41effea4db9f0be1c395481e8b4b96cd21044237cfa6001d2594442c75ed17097e85d397bf2e09d7ac882b4f2e818c41e7b0fc6336c9874030b79de678e4bf1c0fe7db4a0b0dd429e103c9ac60ec33e780c870eb9fa7aa9e4ceb38dc5edc8a66fd09633a3e9fca89caaff0d16536d6b9124499afbbeef0debde7513d67146998bf0ff147a8f8504118be35baefcd49392dabb90c025f9003fbc01345052a5eac73374f4c6923f39705fca671e83fa52989813be7b72df5f8ca16a4ad340d3d696c6fab43622e879db8bebc87be1045fe88605201bc95bafe930224242460a14a2300a0faf5e8d55f716df514985219ed9f3cc2f9dcae0416d516ed3ea000000993cbccfafa037357d28a9ae4eb5ddef309ac98a33596c7432afd8f45eceeb11f84ad24149e90d5886a4d9b435947cc9892efff754ccd61345a5b524e482d4ba77c9415cacb019b5494051c6147d37adeffdc45fa54955c3f6fbe1e3d83bee5cb00f2f1b8abf8e8de37d091dfb1c128191e465958d42d438e2f5de4cfccc2817a5ed97509ea7ee2d0a8651d6d768b6d37f92db863419a015a0885fa25971a4c1295da3b6eef90eb626975d43dd7f68c67d79f6f6947fa078450f799bfec76d7fc0183ac3afd598ec7eadfbd6279ddb7ce75fea0e9a4f603c08aa5418d4722806659d8cb6817e286d30c1c0a156b9ad1c38a5f9d4658e840f355a83068208325446e3b96024e6309a075be5827e24b6d5e0eafc7a661da45271144b7f284e5c22214cbe0dbd9c0cb34109b91a77cf23454bc3999f7d511a940e6aa5128cdece0d68893adb32b3db616d9b36286d8e396f5704d58055b52c975e755d03ad1fc3533ffb2b19ce96cdc908739164ba58b9d310e804085f51858451bd78b762fcbdb899acc3357ccbb781855d4e0ff87aeeaa927b18a51a56300f6b3b0aee5bebc7cf1cb6000c7a980778541d218454b1b270bfc6d68438cb199ce916f32e895f86aa8391239bf657cf19d11eb1ef948ea4fb1e9fa3fa748d1f6db00346b2ca63ad33a87e4dbc39a303b786a0aab65ece3c200f805cf8e1fabe36ff091da51780958faeb2428aeea6b899357ceb3a651663b734b4ed40cb1d1279af1e7cf00e28dd2b1bf84dfc6a8cb776c457734d6cebe1b8ca7bdcd3839425074f783b057a41115f3c8c7d34e899b381f4e3adf253fd22d0f5e0198fc406906d6f982449498186ebacb8ac65cb928f627ff9ab5bc3d9b1630912caf57f6925ee9aad3bfad34dacc52539e7a9188d97bef221a79514b7e4d9bad97cdc8dd953f012bb4d64a2198f0067fbfde75cba7bb6b742f40eefa43601408127b57b280787bcaa7c0e72bfa31aa4f4f2fb4aff733754755fef8b27caa3a3b97b2b6252e416af0bcb84b8e97382636dfd5675ca66f2eac38ce1b671c1bd1856b78ec0974834b15dd1db431206d8064e0fb33c6cea8b929fd327dd0126cc31cc88d36ca14bb2a484a9d3e303ef636649727fe3951c7747d8ddc26a7bb023e7f0f539db7f2631c598811f676f0db18792d9251b42728a811a927473aec3e85c2c7c73b3f571fa7705cb4612948684b741be5bdd927231e57452fbacfb26f8dd1a26454526c9715b3a33d328a3d89587c5264198ed961a2072ce919d7a9f3c44e5f1a4dbdeb4bc73197a138de5a909aab1139d2150c9edcc0bafcdbfc4abc43a396229a4cc7674f6148f940d20bafcf998c98a0caefe1a1356895bd186ba913fe5cfb0a79ad63b3efbd6ca1f3245e37351718d7a53cf5e65f3c7c338dd4d12d9c336527af522d0322d846bafe7556a1846fc5ddbe629c8f3f3721ea52f0f17c19f49f94af48cf47c7758ee169dbe8bf140f9d16924f22d94fd3fac9b9a1a8c5a2f293c5750bb9378f69a42ccfc516b00f372e06dfc0c6bcc5e1cba21c5d273549f3fd6236946e2762c152b4fb49a7f749842f0347fa8c4ef9b31736be8b50ef5a690ebf4f93ea33285e8b04665e9b3160c31b516bac0053f51d53193c3c7ec01b1f44a93b75abbfd578aca1869e3b218bf5f6cedcba22db4b3ed85287cff7eba16e98bcf69c0b74d4e8a59541ca4fd51f2034d268098d46206ced911a5ec64c7582a03444b0f66472f4eabcbd4f41d57c810b0d1bd31237681cfd08856d7ee6979b77aab7c6a2047755cf5fa3380e222bb859051ccada2f31498110c5a190a2e7c29ec04d62954cf0021b538a2cfbc9a21ffee64cd7002036055502c9f3a9c0c67a3bde4a281a704096ef8aa91b296b206c07cf97eaa54d406cb626cb841db5a5a663ba74019a7e98e9568ac47391bd3fd09ddb4086e40c280d5e73d985852c8222d8f798000514182f51014f9ec5cd9a4d545728ea1edcee98723061254aa2e6d6b828009080c1c1077fcdd2a6a9378f9a29c35b0782dce66a624f900823c79593330691eacee2acab4cf59e4f7907bf4487ce4e5cbe36297b31446b2c916a49c05fd7e3ed6f2f70901c131cff7584b7b6306073aa0b29877ccfa268fc63cd33cc3c8315e0df24f803cd8d866700f8bd420fc5e8dbc17c507d34e4108c81935f33a244700910e754dfc03c3e4d201457d3852e7186f973423c6f31dc57213e3783fa363ee52265651a0bdeac8215c6f5d9a41f24bf744d6fd288ac73b841263feddcd558c9937f8f73ee8a83bf8924c992270737c94d9cbdebf2471ae700aac23c32cbf765c63461e12e6357fa832612225a5e2791b35e712a5f57144fe004120d359303b71b4ea9a1f5d625b12ffda75cb717851f273dc5ed39a46f99db30d28836859178d04c6e89b3273010edd40b92ef341bd7826074d5300cee3066996a5578d84115438378529a0320048a9deded06eda7de577f30b390b1114e7813cb7c996a3e5583f3c18d4653c5cc465c63df527ecb1e7f8398337385ac632199c7b39cf51ffa8a0e6b36f241024d40f7d9bd318573d36b501df372bf70fd7ad5ccb1f657899ef35605b9e23a3989cfcfd899195e7cd5b8aca939a325410b2ab42595fb36771ba3cc9385726d44db21e1b51780750fd257047318fc8105adc7f4ec457e7059216b5de71682fff4384fc9829dac2a5c96918265f39f9142ac8d07ebe2deb3c651ccbcd694aaf74cec714697a0485827a00e8a2e83aea994436cc8390338e032201f0e4f7a413e57a6aa4097f3c87523fba757fc7274a434fe5ab7258eb95fdce83e8984f5863f7e10da570f39096db6b07c22df12d2604de9c6120144791d1ba049d649e0669593e3e967e89a0631460405ff2b4b8b45ff4f0baf8c23e2fd04cd4bff382ec2578f06066a86f5be0e814e973035ac093eb004bcf5453297286a57b29830c06d3d18c6c6aadfe7953e9edfe0640e3a19f18fefd9dbb1abf6445da9e29338130e34e60e2f9c90597a0867ed98d4cbddb714b7c76d33f5573e1dd5246792125dacd9b2f6ea6af9288faa6067b7cf57d3d326333ca5c72bdd540cd8ded14b3419ce607398dfac1d15b3012b6d0dbd26f269756a3b49aa08f085ee58225867dfdc7de16a0a61dc6e8fcf5c7323e281babaf0b266043942978b4d83b38592bd004ac28ab5dc4ac45a96ea7b96b3da304aaa3bfd53dfa95ff93219e287ddf43bdbd0043b4c3011a7e9aa2d5c9a4214e320fc7ff9dcebd9c20420522426d46cc3a382aac82a6238349fb1943e00f38a0e2694f26718653fb7fdc30423c706f75f616b5ca3474b0ab17e39a5044a7d227b965a6443c020556723d563362729bbd9f688a023ff469770c12a2a9c6807944c57dbddd296940679d03ee3a1be97b974434495c310bfc006491f7ed7458b0dc31f7c71f02db34cea95e4bc1246610ad7bcb9d1c31c55beeaca039f38bb0d8a36d50a83a1df2f4b2707a44290a2fe5feea17c541cc0fdd1a48cafcb6c05ff95282377cccd33b0c35b0c837a9098e362ffe9e00a2b3f3c36c67773f81ebdf3f772548dac51aab576d3839e8fb922e8dd26eb06999370ecf88e6a101408782c42c7be82ef55fffd66a3987d4d5ab1241604111a6ad3af2e84de759b6d036d9d81d3481fe439bd6c9128201a1a19f2a44ee425a09f1af2cdcd10c7eb14b139268bab62afc8593ff6242f0c2e0af670c4b5dad03dca93041e647211c780311068e336cc56f5c80df19ee29494015dd053cb4525067584992781e1e63d748a5b0655e729e2a8cb106cad62627df06965fecc35a12672584b4d9b95941d65f852f67cad75cba3e72b737892e2a227702bd21ea96bd878f524af693f82f9e74e649bb82024bbc0367093fe8da5e2fe7f227c103b91ba500de32c405f60b2ce6e72157e5bbd89da2fb686b34712750e6631348e2e5cc1a985b4703422a2c403c13b62fcc80e78a2000000f23402af228be5ebf387fb5798cf92c4a370a0f60640e04867b40c6bb754c6b054f22a34f240c45622d1a47fb9ef3c6285f3e2fd34c0cd9ad991ec304b008b31780fa05039f1b4be7d2c9cd1910d76b02dbf2867142886cd2e50c449ffbc483989b866d1ad3d9326c1db6edd095697e7800defff726055a62cf2fab38478d535e8942e02c046bdab4d7ef08ec7d7477f33ac12ef1bc999fcb0dce54e03c9c929150463a169e01695a9c0dab3a52069cd0692fb29eca0326f164fd9bf3ca33d1be77ef621ec38f0f454f308bbf67cfb41eac65dce28f8a64e45832ab8d6d26dcb73dd20c5cf078917c3e7cd79b135308b180335e849b307134a5f7396c4b23a5911b9ca29e969dafdefe93f929f9d4a74855182d803aebd7eebe051c1fb8dda19ff995a5638e0d523496d72b4be007d384a34049108d7ed5cb34b65fcddeb44ca71527d7c2bbe6202b78d1884ed5019b2296b7c1c79657b44361c44a95cda5fc88ec175bb53d9ffe470bf6ed7e8b0c2e4a317a2325e2a1513fb02480d3789e856acb8a34b63a3c12bf84a9c0d1f2471022084b2f8523b6c07db47b49d6daafa3c60817307037d22f5aa0392e8301e0e28eba671fe54f59bfef558f60b1e00a8124598a2914e8f6635776ae554dc35e10b768f514cf11b9cf39451192f90f2f550cb69f4a974611094fb71384caeb591a619f71f60fabf251f213672375d822c95975bc20005b371e321e09259db3739a7f95ec21b8c9ce560d2b9364f266d9249f287205f1249dc7b742a32861ec17a5b1d962ef1f6e251c5edee5b87d8f57dbe5ab05542528c156d8d9752ddbfc578307756c4a5906ca5871a3ac77e3de6175a8a83a66f05b2e50a7889e4a800a209914dfd8943697c790f546e75651aeb27e478a758baf6111f6b3f0a71c5c62dca637a3ccbc250d82189dbccf7227415a75195788e13766dc3e3d2bda8b7afae04892e68fe328a503dbc75fca4f38c3eb540bb5fbfa7e61de71aaeec7bc519baa3b4fdbfd9c0465655fa64caab32343633fc7c48efc8d8f01a997e0cb156fe417df21ef47dcb0c21725a330d2918b2c9a01585a1cc5008958bf3b004a5bc269d88ba3a058c2ce9016cfce2b4b9568b8dd845668ca2129807483d3d8971e588bc9aa4e0ee1f990ef13a382c7cf190fa11f62ca39a9da9b2296a56d01132eb3f8e1dee7a5ae44ac0c977902f48d89530a63600c2efc8b24a556472a1ad0a7228a41d04a8534037467caf95e73374e13eb383fcc89896057dbebdae651824bce6f61c4eeba840a3da7ca4afc84c6ae969a733dbbe9229e27363f6fa92d79cea53a1e54af845b32927c7a7b5ce3e82112e9344395bd8349be9db9dc915784d3ca63c92beb2a1a1ece9cc2ab5965b96c10426d7cacc041074602785a280d0719210bb82de1604d773c8fede5aa5d95306a8391186430569c3e74ba5928b2dc7736407c2e2f2b2300df8525866fcbefbef7ef400883c51563bbfee4cc41aca4d131c7b6454381572a42c061c5bf71ae80907d3c35c03364abf350a60bc200293b8ade6d3fbaa1b3700c6fe429023857533eeef9e7080b59fdfdea769a2f1d5240b2e901f8fc370fc4d452165c1ad853f1946a058941237f6ac9cdcd57e243e87283d69b4891b5fe1341d6181d99cf7a6ed4711e0b17c98396ed751274fc3e5515cbd499fa4665b1ecfed0d7de909cd451ff248f2ea67f2c0ac9f07dba446a554c18bce43471244a34504c41efb968edb9567c5b805a2f2c5e41f346c90ec9e34b01ecb0699c5c6d9ab0015837bc5b9d4173281b36a262d4065df4dce0610e8640d04b1b223dde5f3abcaf39f6b2e894f7c0eab2e7e37df7030a5cc00e9ee493ab9562bdbb50e1142ced7fcaef05eaae0184501305688504db3188d50f5dcf48d8be91c284ad833fc1c786f74219ae1b63b466b0312ec3b66377b501bf9f36763e17fa03ecfd0298d9418b1a4e01e01c2f6e32c276f7277fcc50b0a9d4eebd2648e047effdb4ad265ed7c2b2323c71c0d57e67265c8d11140ee454c64882543b3e2df969d4c9afa9afc50adf495d9d4a411db8f4833025ea96d80bfb807a7b20dda1693f7a5ba01d0fdccdcdf3381d03212525dd39e00ecbcb95c8f8b6dda72df61ebcbbb2427207a74005640be919583bb2fd687f7c5ef06abfbb8f18f86869a12382a8409cba35969a135836df68a0bf3b87af7cdffc10d562be62081cf65e9420705d78316a6eb3460c1e06c87aa67d62ef0f83cdc48d8809a4d20004ea8d649cdff35d29fedb27777b80129e48725b00001af6c79a28000000000000000000000000000045584946ba00000045786966000049492a000800000006001201030001000000010000001a01050001000000560000001b010500010000005e0000002801030001000000020000001302030001000000010000006987040001000000660000000000000048000000010000004800000001000000060000900700040000003032313001910700040000000102030000a00700040000003031303001a0030001000000ffff000002a00400010000000004000003a00400010000000003000000000000	2026-05-20 00:26:13.732+05:30
a4fad7a5-a310-49f6-9a18-9c9437b71b77	478fc7bf-e202-4b4a-800b-51302f303782	image_2026-05-20_102335695.png	image/png	8360	\\x89504e470d0a1a0a0000000d494844520000017300000151080200000009bcdaf80000100049444154789cecdd097054d79deff1d34642a0a50109a9851684254401920003631b3002c7c684601b6c1808153b2f64423198a9a9cc8372e6d53c4c1cde92782066a6c28b293c26cf61ca81e02db1431ce20a12e085b01a0961a416a0cd5a9004ad964008a1f9f7bdadd6d66a2d1cc92de9fba92eeaf4dd74af6edf5fffcfb94d2b20242444018056f72900d08d6401a01fc902403f9205807e240b00fd481600fa912c00f4235900e847b200d08f6401a01fc902403f9205807e240b00fd481600fa912c00f4235900e847b200d08f6401a01fc902403f9205807e240b00fd481600fa912c00f4235900e847b200d08f6401a01fc902403f9205807e240b00fd481600fa912c00f4235900e847b200d08f6401a01fc902403f9205807e240b00fd481600fa912c00f4235900e847b200d08f6401a01fc902403f9205807e240b00fd481600fa912c00f4235900e847b200d08f6401a01fc902403f9205807e240b00fd481600fa052425252900e8b6a6a6a69b376f565555d5d7d777b60c350b809eb1582cc1c1c17171714141419d2d43b200e8a5f0f0f0ce66052800e89591234776368b6401d04bd22dea6c16bd2100fa912c00f4235900e847b200d08f6401a01fc902403f9205807e240b00fd481600fa912c00f4235900e847b200d08f6401a01fffd7199d099db1243d29b8cda48a337fc8ac4d59fa48428d34f28d496113173d915075ece3536531e92b66449acb35d657e6fdf54896439a110f2c5c98e8d94a9dfd2f47ce56a9a16dccdf3c35677c60f9d9774fda9b5a4d0e084d7e68668a2d749845a9db95178f7f9e3d7af68a07a2daac5a9777e4d0a5caf049df7c74629de7145882931e9c39799c75c430a5ee384b2f9cfe2cd7d968cc317ff9b5f9997f3ce334379094fead19eaecdb9925ae27232266cc9931614c90fcc4c65b574f7c985da2b42159d0196776c6c7b952d4c6cdf8668acafee86ca124c62d79ed5ebee248989c101f985fd8a054e4a404ab23fff332f73ab70a3e3f92e30c8e9b312fe5a139370e7f5a684eae345717b76bd550179f10ab1c8e86a8d8fb953dbf79e28898794fcc8856d557ce1cbb581598347366c468a50acefdb15c4e40e8d4f487a22a5cbf5875f74e87df5f70cae30b2707575f3977ec62858a983869465afaa2d0637f3ce370cf6f5221f7cf48c93b965dd361c5f90f25055cfdebc779958d4131d363872b9de80da1530d75f5b5cefadadbf2fed7d8e074b56fdd91c975d95f963486274c099377cba849f101a55f5e6e7e15abc63baec52a2ee614de0c1c3536d433d95c5d1e0d4d6a881b1f67bb5b9a7dbeb43e52d2b9796264ca94684bf9d93f7d7aeab2a3f646e517474e5e9208b9d3e0f9a599bfd8dabac60e9b9b946cadbb72cc58d1e928387bf248ae23e4fe29c92d39e1b85e634d9e153fa2fd9aa323aceafae54b053764cb8edce33957944e240b7aae20ef4a9dd536213830f9fee8facb170b14bacb12156fbbf35561756941e9ad313113dcd7ff98093141b70a2fd96f352fd6545d5ad6aded45db2286d5955ca96c99e22828afb58c1e6bf3fcc45b574ee5dd8a98fc407cbb552b0a4a1b464f9d372f397498d28f64412f38b3ed95d6f153e74c88a8b45fae6c3f7798357952fcc8fa8a1267f394a8192bbeb5421e4b2645a8a12d3e26b2b1b4b054a9b292d2fa88d80966d53272e4705573dda17a2e646490aa75b63905379c756a586060ab295597ce16dc8d499d12d1e61be01aae7c72fc6c998a9e96befce93929ba4f0ce32ce88d86dccb255366c70494fc35b7a1f5f490c4f41589f296db70fdcbcf4fb5bceb368fb3781926185a9226c40c1baee6ad48703f8f8b09bc74b541ba3d8d6a94553a8fce9e6eb041d61c1d2a6332d73d93468506abfacaba368b959e3c5ff2f4ec992957f35b4f6daab31f3f72252c2aeda1e993173c74fb83cf736f2b5d4816f44a537979b58a51e5056dc74dcc11dcdbb5edc6538c711635e4596262c736969e3d72d6ccdcb1931e9b159d34fceac5dbd5d76ea89871f111e7722a7b380ef555e5751513931471e95473dd12911813d25879a15d67aaa9fc4c56f937a7a74d90c2a86d7c34d6949fcdbc14f154cab838959baf74a137049dcc81c60ec3b4c3024383428cc78821fc5e16981c1fa92a4bf3dd83d9b557ca2a1a23e22705b94ac07379b523ef5fb8446e1e8786845ac7a7cd9c31be5bdb6cb8946daf0b9ef0c89c59f75b65c509b3e6ccbb3fd89177a9a04342ddb25fc8ad89183dca33217ad6c2491322e5a4848e4f8d0f9381de0aa511350bfa4144cae2c7528c5685e75318434ee084d808559353da72cd97974bc1312e2624eb726dd5a5c37fb9f9f0839353e6a6a7b8eeee3bf24f7673b3ceb387336b1f9a99f2c023132cc6e759ce1d396eaff3b6645df6a9bcf8472786b89fd63704c6cf983f7198b9d6d9935fd4288d2cd3a64d5300d02b76bbddeb747a4300f4235900e847b200d08f6401a01fc902403f9205807e240b00fd481600fa912c00f4235900e847b200d08f6401a01fc902403f9205807e240b00fd481600fa059496962a00e8b9e8e8e8ce6651b300d08f6401a01fc902403f9205807e240b00fd481600fa912c00f4235900e847b200d08f6401a01fc90240bf0005a0bf0406068686860e1f3edc62b1281d9a9a9a6edfbeed743a1b1a1a943f2159807e22b1121e1eae2b534cb2b5a0a02089aaaaaa2abf0a177a43403f916a456fac78c86665e3ca9f50b300fd442a0bd567fa74e3bd40b200fda48f0a967ed8782fd01b02a01fc902403f9205807e240b00fd481600fa716f08f03bc1c123e7cf7f501a478f9ea8abbba906206a16f493b4e5df7f7ec128856e183366546868883ca4a106266a16f8302afdbb2bd2c29a9f151fd9f55ebe42df2b2e2ecdcbbb6236d4c044b2c0b79af3077f9b59a6cc94797e41e5af336e28f4bd73e72ea8818c644137ddc83c5db871628434a45f9394f7c67b59c6e4d4451b27da5db58c6dd6f32bc3af668d4e4b0d2bce70cd8d5ef0b72b528d82a7e6dcdb6f9e32968e682e823c8195b87ce3c258639e23eb6d776cb93635ddea6a1566ee3a7cdeeb94c16eecd870f9f7dab52a3530912cd0283e41bdbd6b972b1d5cb19290fff6ae5352cda72d9865ceb6a6ce5207dfd855e61a73499f93982979949aa432ded8956566c713e917256e1297af4cbc7af00d23774cada648907d7756c59ba706f7df0c965859b0e0616964647c3640c385115c7453e2f205f1c579bec7590acfbafb4aa32625a8f31fb9affff319ee8623eb4f665e9ccf2b54d631aebf099c75d85dfb94e55dad313752595513161ed9b2d1e805b3628b4fb98326cb5edc6626fc14350b7c0b4b5bf9fd34a365f671ba27223cecbabdacf3f915550e77abf520718dd1cdb991f9e691e51bbfbf7141ab9f18bb70e3c685cd2bd754d92489d42026758a542b8ade10062fcf80484f8d1ed3f5f5ef8a95f0d3466fc8d57ea2797afe7bbbf28d2198bf4daff8eda5d6433043c6c0cd1413bd21f45845754decc444a3e9ea22795b245f3a2d698b67451b4f649c25dafb96a4b4a9a9aa309ab6890961ede6babb45a5176538e689749b1a52a64f9f2a0f356051b3a0c74a334e156f34bb2785991985b113bd2c73febd37d4f2efafd838ddf5a4f8c82ea5bc0d8ee4bf9791b4d1ec6dd51416bbc759dade2d729533a77e9d11beb1b95336143e56131b1b3d71e20465542e03f4232d96a8a82805a0ef4547477773c9de7dbabfb4b4bf33488ec86eb77b9d45cd02f81d49938f3eca500319e32c00f4235900e847b200d08f6401a01fc902403fee0d01fde4eeddbb7df757819a9a9a943fa16601fac9eddbb7559fe9d38df702c902f413a7d3d94795856c5636aefc09bd21e8e16fd5b81f6a6868a8aaaa0a0d0d1d3e7cb8ae6e91fcdaa55a9158918db79bf5f5fe3d569205bd418ef48e5cffd5d5d5aa5f743c47fd9935240b7a804019d03ca7af1f22866441b7902983897936fb345f481674814c19acfa345f4816f862bef802030365dc312828e8eb1d14842e725aebebebcd715f69f7c5692559d0294fac4444445cbb76ada4a484fa65709028090b0b1b3b766c6565651f850bc902ef3c2122d58ac48ac3e150182ce4e49a2754f2c5bc57a53d5cf8a41cbc685d9b4827a8a6a64661d091d32a27d7f3546f414ab2a0bd76af30792ba313342875ac53349e689205807e240bdaa03c19e274bd00481600fa0574ff2f156050f2fa1e45e53274d86c2d7f23ceebeda1dedd330ae8ffbf5102bfe53550c68d1ba73078959579f913b9dd4c131f7509bd2100fa912c70a307048f7b7f31902c00f4235900e847b200d08fff91883e1112123c61c278d5a4ae5c2dacadad551862a859a0597272d22f7ef1af97be3c75e80f070f1d3a78e9cb93bb7eb17de2c444d57bdb8e14e51cd9a1fc8c67afa471e2c03a85d64816b874762fa0a7f708beb564d1ef7ff79b5a67dd934fad1e9f902a8f279f5ced74d67ef0fbfd4b962cf2bdeef68c9c9c036bdb4cdaf161f185bdebd596857153166e52f766ed810b39c5452d8f2ea3cacbfeb4a165afbe7eba4e7d3b240bb459bdfad93d7bfe7dc78e5ffce89fb79e39f3c5a38fce97c799b35fc85399f8fa9e7f97057cacbef964be35357d7dab29db6727e61e5abb5be95273fce529b171e6e3a05a9d539cb14da16f902cd063faf4d4edffba6dd3a67fd9f3faff97a7bf7e73f7ce9d3f958734e4a94c94593bb6ffaf19d3d33addc4a6d3b9d694c73cdd8a757b9726e59f7415056dba1b524a9845875950c8d3e6eac35595345719d2f6dd43918ae3606ed2e2e6655c5d1b63b3e65aae4dad4952d6b92f16177db8ddd8999cf6c58eb74e50cb62c65a4318c9023db6bef4a3fff88f5fff66ff3bd2965265daf4d439731e978734e4a94c9459afbffee64b2fbdd8f936b69cb487a52d727740d62f4ab1da4f6f6ebbc4fa0327d6a88346d1f1caf9d417e522974a2779b6597a2446a91a65330674d6a5a7a9ec8ff7289f3c3f4e7264a5da6fd4322f67a76d9550d8bb6aea94b7eccaf1c92bb1714b37bb7626eabc59efeccf4f5edd596a6c3bb235c5bd98b1d65046b2c08f6cdef799727788d63e961a967b724bdbf9dbd6cc55c7f79913f77e9c55638b5fab2e963b9266ba2ef51d336d59d965667b7294cacaecb21b955b667c57de8e95f3d4676f9923267b32cf3b22c777287676af5abacacc2929ac3add5e7eb9232c6ab282e2ae3374f9c94f5ef9e083fd172f5e92dae42f7f39fac5b9ac4f3ffdb34c97863c95c6b7573ffb777ff7bc8cecfada8a5cd8fff4e29a1d6af745293a3edbe9657c346cded69ce2adcdcfec89c62a1b240bb6cf8e3cbf6f6981ed84d14e2c3bb9577525d916662cb652591f7ea928e7a5e6e9b95ed241fa3e2b93ddedfc93deb727954ea2ab57b55ae5ee1f0c83bbf78264811e67cf9ddfb4f97ffe7cc7ff0e0b0b935195e7bfbbdeec0499b1b2ee07ffedc73ffee7ffbee95fce9dcbf2b919a94436bc347bdbfaf81495f54b6f4547fe5b1d3a1ab2ca0f174987c8e8fe2c524ba51d690ed0f8648ce37cb8406a1649a883b10bb674bea8c4cae2f297a72cdc63b66776bea40cdf6c710fc15c7c705517ddb1c18cde10b4d9bfff9d1facfbc74d9bfee1673f7df98119d32453e4f1c003d3e4a94c5cb7ee1ff71ba330beed3e9ced485afcc35475fe70c7a243464612d774b8a1b3bbb0c29aba384d15ed365657d2ae38ddb51ae93d0000100049444154c530870cb56e7db86cbf1152d2c1495ae9eb26f4ba389baa28306362c7cc64d525ba45240bb43a74e8b0f477424343a4675470354b1e1ffc7e7f4868f0534f7ffb0f870e776b13ae918e306b27e3af9b17bc723c7265719bfb38e64d25e9d76c71afaec25459beb74d1b3d2973ddad511fb67c1a65cbc2973fb3ad6e9ee5fa048df1b364d0c7bc37b467edce4f22d7987367abcec7593c37985e4ccb7a6588f7862c5151510a439e8f8f4bc5c4c4d8ed76d5432121211312e295455db952505b5ba7e0979292924a4a4a3afb9ea72ebfff293a3abab3d706e32ce813b5b5b5d9172e2a0c55f48600e847b200d08f6401a01fc902403f9205807e240b7cb0cefdf6730ae839ee3ac3b71a05f41c350b00fd481600fa912c00f4639c05be8529a0e74816f8c6082e7a83de1000fd481600fa912cf0c1f1c96fde5740cf912c00f4235900e847b200d08f6401a01fc902403f9205807e240b00fd481600fa912c00f4235900e847b200d08f6f51405f9933e76fe4df4f3ffdabc2d043b2a0af3cf5e41245b20c55f48630b4ac3f70a238639bba07b2859c036b551f59b737a7e8c481756aa0a36681ff587be0c28bf3ac2dcf73f74f59b8490d04b2e71bd4ab0faedaa3eed59eb553ee7d237e809a05fa3df68d05ad9f7ee3d174d55d35c75f9e121b673e0eaad539f7585fe0eb42b240335b54e4bffddb4fb7bef423f3e9cb3ffe1fafbefa7f222323548f6d5918773037697173d760db91a29c62f3e18e1ba9144eb49e7b6487a7fde176a5b667e4e41cd876e082b9966b4a7baeae877b9b2d1d9c56139b37d86ae285bdc9bef6d9dddb921f6d6cc1bd7bc69e783a50eeddf37644e60ff2eceadae69df7acee59c5df7b4c240b342b2baf787ad99a65cb97ce9df3e0bcb90f3df5f492679e7daea2a252f5c69693f6b0b4456b8d6b6ca5ed9357cc72e62db5d2b8d2f67e9ca58cb97241c629478d2dde68ef98996c3fbdd958df3a77b17ad558c59eb8a67df9b3edc8d687cbf69bf5d12be7535f347364fda2a8f366ddb43f3f797573046c4d714f7c552d9ddbd5df33485a39fba46be19f7ca2e6fdd3def54a6d3e996f4d4d5f6fce75ef9ed7236acdd5374ccb32173878de3d65a53277f8e5ecb4addeb2d26f902cd066c68cb488887069e4e75f79e699efc4c5c5c4c48e93863c9589324b16503d945b66fcf1801d2be7a9cf76aeda6b4edcbcef33655ca8bb0b2bcc2b76fda21495956d4e5c1f1f997b728bb9a4e3935f9a631f726dabc8b8f5adb6bcfec0e264fbc1e6719cbdab0ee527cf7645cfee554bddc3259b4ee7b62cf9917be29eb53b3fe9eaef19346f76f7e16c87352ad9dc94d990fa6576a26bf73a39a216ebd2d35a16d8b24a1ac62a6f993bbc27f3bc2372bc1f972d240bb4d9b9f3a7e66758c4d5ab85df78fce947bff1a434cc2973e73ef8eaabff57f550b22dacacd0b8ba2a8a767ba6ee292a6b73c5ae7d2cb5e2e4aaccf3ca6cabf28b1d3674b1dcd1619aa32cbfcd02eee8f1f43856267b5db2fb643fdd2d29be1267ef707576964636a783d723f2981c656dbd80c9faf04bee7d93a1eeb0a8c9ca6f912ce82b050545454525ea5ec87598947fd2bc0e5b571cebe26c8e72a3a030afd8c4a80ae95fec2da830da2afbe3eedd5eb1da125b9eb8af648995c5e5ee51e483b9de9694b0533d274593d444466d95e9ce0bef47d44adb22cbc57eb07978dbf5f0e71b67240bb4b970e1a2dc159a33e741af8fc71f7f3427e7cb1e6c4ec6325de3204b5d2326aedae4e11f368f446c7fee61cff529dd25db92c536a3a690abd7d5f65cba3eb9ba2a492b9bc768d71e58627452e40a5715056630c98048cb92cd03c9aeb053bd21879034738d4d9d3fbc57f93ca296e55b16d876401aae2dac6c1954f66f01d1d1d10a435553535367533aceead2cf7eb6f3850d3fd8bce91fbccecdcbbbfcf39fbfded536c2e66dcd29de6ab6f3df8a9bb2d93d5dee13a923452f4a2f40b9464f5e99d23c422197fd0fe7a6782ed7b2d52b55e15ed51d7bd64e51125e39c5ab5dcf9a3f3bb376e7a213d2e358234d7b7eae67c9c91f169b3be6f8ecad4f6a96aa5e90f22a678d7485f6747144cadb21cbeec9bf0b5f8ef3ecb0ecc94fa6aeed4e86fa66b3d9cc86c56269d7f0e838a54b96a8a8288521afb31c91e931313176bb5d61304a4a4a2a2929e92c38ba0c14a94b3a7b6dd01b02a01fc902403f9205807e240b00fd481600fa912c70e9f5dd010c747d74ea491600fa912c00f4235900e847b200d08f6441179a9a9a18c71d94e4b4f6e27f877513c902b7cee2a3bebe3e2cac37df1b003f27a7554eaed759f7fe5e42b2a00b4ea773ecd8b156ab95ca65d090532927544eab9c5cd537f8ab20e8424343436565a5bcbfc90b9170191ca41324d58a9c5639b9aa6f902c68d159c75b5e7fd5d5d5aa575fda023fe4fb1d42cbfb07bd21f40035cb20d03f27919a056d7479bfc07c5d52bc0c44ddc9145db943b2a037c89781a5ff8b4d9205ed75ff630ead5fafa48cbfe9cd97d7ea0b2092055ef4e233540cc10c747acf2023b8f08ea41852b49f6e6a1674aa4f3ffd0d1f4242829f7cf209697cf0c19f6a6beb541feb8b77116a16f8a2f13597f2d477d73c6255e8069b2d72d428ab3ca4a1fa581f15a7d42cf0c13affb9675342cd76932ac9fce5fbbdfaf3c61ef4b0ba273fff6a76f645b3a1fa4c9f76784916f820afbc9aec77de3e5a2e6deb23cf3dfb9df4caffccbca17ac5c2c84d4f1c3f7e42f5997e3815240b7c6a79093a8e9d29fafba4088bc591faf4f712f3f6be9f6d4c4e797cc3c47c572d639bf99d67c20b2e8c4a991a5672f457bfcb56d1e92b964f35fe93b4f38bf7f69d365ecfe1f39f7bc628826ab2df7dfb689934ee7ffaef17c4185baab9f0ae3bb65c9b9a66ac5974ecb53f67799d32d8c5c4b8fe2c724949a9d2a73fb39d64410fb4bc303d1588c5fdcc35d26b891bafde7ded35573a48ac3c33fef2bbaf9d962b23357da6b9a43565a67ae757af95a9d465df9bff70e251c9a39424cbd15fbd966d64c7b38fcfff52e22671d9b3f717bcf32b23774cada648903d37f3dabed33a2f38ff23b1b26cd937a5f1fefb7fec75b87cbd352223b8e88afbf579ffb2f4f812fbe58eb39b13461a455f1c75b832c7322a39c19275f84c99f124fba8d150969aec3f1f2b37a6d88b94754cb4b42e7cfcbb0bc642e5f602a7c5b81c2aab9cd6f0488b4774facc989233e68a960bf92561ad670e4ecdbf778b3233bcf71bf9da50b3c0b7b0b4156bd38c567146730fa8ddcbd6f3a465724478d88dfcf20e1bf3ccafa8ae71b75c83c4a9ee2f96aa31ba398e63fb329edef0bd0de9aa38d3d5ab728556ec820d1b1634af5c531da554c78d0f225f7d55f6fefb87cc861a984816f862b138b3defe6d66f75ede9636edd163da5dffae3c6add9d927f46cd7ffed9f0d37b7f996db61735cfbcfcbb5f5e7655491b56ceaf3878c955ecbcbbafb723c703d4c0cd1413bd21f4d8b5ea9ad88989463371d98278775e585a47cb657b4958dae299d1c6131967896eb709f71a52dad4545d33a6d89212c2da8693aaaa724acf47957d99af5217cdb7a921e591471e92871ab0a859d063a599a74b5e58f8c20b0b952ac8cc288c9de86599acf7f7aa656b9f7d61baeb4971c6ff536aac97a5f2dfcf487cc1ec6dd51416bb3b4889cb5e58106bb41c59efec739533a7f76584bfd0dc29736ded1e3f56e3f79292264c9b365519958bdd7e450d4096a8a82805c09f8486862c5fbe441aefbd77c8e9ac55fe2a3a3ada6eb77b9d45b200e8251fc9c2380b00fd481600fa912c00f4235900e847b200d08f6401a01fc902403f9205807e240b00fd481600fa912c00f4235900e847b200d08f6401a01fc902403f9205807e240b00fd481600fa912c00f4e3bbfb01f486c562696a6aea6c2ec902a037468e1c79f3e6cdcee6064447472b00e8b9a2a2a2ce6651b300e819e90449b5525555555f5fdfd9329690901005005a716f08807e240b00fd481600fa912c00f4235900e847b200d08f6401a01fc902403f9205807e240b00fd481600fa912c00f4235900e847b200d08f6401a01fdffc047f171010101c1c2cfffaf8d6d501c462b1dcb973a7aeae4efef5b198bf1d753777db63d8f0e1c315e0afe4d2b25aadf2b25683c87df7dd3762c488868686bb77ef7a5dc03f8fbacbdd6eb3b002fc98bc6f0f8e52a51d392839b4cee6faed51fbdeedd64816f83579f75683948f43f3e7a3eee6be31ce02bf36280b16938f43f3e7a3eee6be51b300d08f6401a01fc902403f9205807e240b00fd481600fa912c00f423598036a2a3a392921202028629dc033e2987c160f8f0e11326c479e2a0aaea466969b9ea955eafd8ffe4781312e2a471f56ad19d3b8de6444946d593a3080d0d19372eeaead5e2dbb76f2b7d48160c128d8d8d57ae14c9e561a64c7d7d7d75f50d35d8ddbd7b37303070ecd8087f0b449205838d848bc3e10c0a0a9288494888adabbb396a549859c5c8fb7978f82859a6b6b64edea5c78c19151e3edaf3862f0b9b2b060505ca5c65bcff9bcbdfbddb5454f495d359eb59cc8c2dd982d51a2a0b7b8aa6d64bf68f8a8acab163c39dce908e3f54ea91b8b871f7dd67910394d89529b293b2bcecbccc8a89b1391c35f21b90e9132726dc4ba1d711c982c1cc62b1c8d57ee142ae3252202464e4a54bf97299493a486a54555d976b72c48811724d4a34040404d4d6de945c31d73553232fefaa4495ef2e83fc88f8f871e615abfa5d43c39d6bd7aa6cb6b1b76eddf2f48994d143947d36634e8e45f65032547652a2a4a6c61911315af2b1b4b4c2e9aceb8bde1023b8186c24052411cc37f0a6a6a6cacaebcab8f8e58a922831af3da33609bc6d080c74bdbf4ae8dcb973c7737599cbcb75684e91ad494396f1fa13659bb2ae2792fa9f249aec80f4895a4f94fd977d367f0f9298caf5052bc3cc256db6c8fbeebbefdab54ad567a85930480c1b364c4a7ad5aae7d2f15bcde4cd591e66bbbefeb6c487448cc490bc878f1e6dada8a86abdb00c614839e0795a5fdfe0233b8a8b4b653075ead464bd7d8aeefbeaab0a29c4a44fd47a624848b0ec92d9965fcbf0e1ae3095a8957e50494959eb02473b920583846704b7b30524290a0a4ada0d46c89bb9bcb78785854a5b7a13ad67c9bbba59ce98a4c69118ea6ce37295daed57cd9b35d2f5e8ff6e911c78739fa8beb1d1fd9d6f5e634efa4132bcddb1f7a417bd210c097209ddbce9ba9cda7d50452e48e91d48d922735b5f66d296d0898c8c300b1fe96149c3ec5348f122cb2b6320431668f753bec66e91d9d391e16af3a964a8eca7ec79eb6524f56438490a1c699b79da47a8593054c8bbb7f417264d4a349f7ef555b95959482522e30ee6704cbbe59571d3441991e1298864b046eeb0482f43265ebfee183932c82c55e4669432ee3a7d8d3780253264dfccb6248b8c138d1f1f633e951d93639428947e901c4859d935e9134977cf1c42d27e6fc8121212a2007f3566cc1835785557577b9deee747ddd96eb7466f08807e240b00fd481600fa912c00f4235900e847b200d08f6401a01fc902bf36c8fe567c6b3e0ecd9f8fba9bfb46b2c0afddb973470d523e0ecd9f8fba9bfb46b2c0afd5d5d50dcab2450e4a0eadb3b97e7bd4be77bbb5611dffa739e03f8caf326808080818366c907ce5b55c9c8d8d8d4ea7d3c79bbf1f1e757776bbcdf2fcbf2100da4b2809bf0000004549444154d11b02a01fc902403f9205807e240b00fd481600fa912c00f4235900e847b200d08f6401a01fc902403f9205807e240b00fd481600fa912c00f4235900e8f75f000000ffff9e96e7fe000000064944415403003c203fd603bc374a0000000049454e44ae426082	2026-05-20 10:23:51.695+05:30
\.


--
-- TOC entry 6055 (class 0 OID 152074)
-- Dependencies: 273
-- Data for Name: support_tickets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.support_tickets (id, user_id, organization_id, subject, description, category, priority, status, assigned_to, related_session_id, related_billing_id, resolved_at, resolution_notes, satisfaction_rating, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
af0c610c-f4ee-429a-b9b7-4a4655e416d9	8d40647d-da49-4490-ada6-3bfa2205366c	07b07401-b326-4045-af3a-44a7c45e56d8	issue in starting it	cant start, saying server is not free	serverless_issue	high	resolved	\N	\N	\N	2026-05-19 18:54:56.891	\N	\N	2026-05-19 17:38:24.891	2026-05-19 18:54:56.893	\N	\N	\N
1d06444e-5d54-4653-a2e6-b1651c4318ec	8d40647d-da49-4490-ada6-3bfa2205366c	07b07401-b326-4045-af3a-44a7c45e56d8	want to	its not good	serverless_issue	high	resolved	\N	\N	\N	2026-05-20 02:11:37.527	\N	\N	2026-05-19 18:56:13.726	2026-05-20 02:11:37.529	\N	\N	\N
478fc7bf-e202-4b4a-800b-51302f303782	8d40647d-da49-4490-ada6-3bfa2205366c	07b07401-b326-4045-af3a-44a7c45e56d8	issue	unable to start my instance	serverless_issue	high	resolved	\N	\N	\N	2026-05-21 05:37:22.019	\N	\N	2026-05-20 04:53:51.678	2026-05-21 05:37:22.02	\N	\N	\N
\.


--
-- TOC entry 6056 (class 0 OID 152090)
-- Dependencies: 274
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_settings (id, key, value, value_type, description, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6057 (class 0 OID 152101)
-- Dependencies: 275
-- Data for Name: ticket_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ticket_messages (id, ticket_id, sender_id, body, is_internal, attachments, created_at) FROM stdin;
\.


--
-- TOC entry 6058 (class 0 OID 152114)
-- Dependencies: 276
-- Data for Name: universities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.universities (id, name, short_name, slug, domain_suffixes, logo_url, website_url, contact_email, contact_phone, city, state, country, timezone, is_active, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
f213bc95-2fe5-4401-94c1-39efeaa39a5a	K.S. Rangasamy College of Engineering	KSRCE	ksrce	{@ksrce.in}	\N	\N	\N	\N	\N	\N	IN	Asia/Kolkata	t	2026-04-08 01:52:11.94	2026-05-15 07:32:20.399	\N	\N	\N
\.


--
-- TOC entry 6059 (class 0 OID 152129)
-- Dependencies: 277
-- Data for Name: university_idp_configs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.university_idp_configs (id, university_id, idp_type, idp_entity_id, idp_metadata_url, idp_config, keycloak_idp_alias, display_name, is_primary, is_active, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6060 (class 0 OID 152144)
-- Dependencies: 278
-- Data for Name: user_achievements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_achievements (id, user_id, achievement_id, earned_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6061 (class 0 OID 152154)
-- Dependencies: 279
-- Data for Name: user_deletion_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_deletion_requests (id, user_id, requested_at, requested_by, reason, grace_period_days, scheduled_deletion_at, status, cancelled_at, completed_at, completion_details, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6062 (class 0 OID 152169)
-- Dependencies: 280
-- Data for Name: user_departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_departments (id, user_id, department_id, is_primary, created_at, updated_at, created_by, updated_by) FROM stdin;
5b52dbbf-f230-451d-9a51-c0c01ee67f6b	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	47563591-17ba-4e02-9d7e-fd1c98f950a3	t	2026-05-20 06:35:12.409	2026-05-20 06:35:12.409	\N	\N
6fb31cc8-227d-4202-b52b-7767bc658524	5de255a8-d8a8-4749-a624-557da4ed87b9	66f940dc-4ee5-4d3b-948e-940e1493028e	t	2026-05-20 08:28:40.526	2026-05-20 08:28:40.526	\N	\N
188866c5-825f-4807-aa46-3b609ae3921b	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	67ef63ef-2331-41a3-9abf-c01d56a75d3d	t	2026-05-21 07:08:37.807	2026-05-21 07:08:37.807	\N	\N
\.


--
-- TOC entry 6063 (class 0 OID 152180)
-- Dependencies: 281
-- Data for Name: user_feedback; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_feedback (id, user_id, session_id, feedback_type, rating, subject, body, status, admin_response, responded_by, responded_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6064 (class 0 OID 152193)
-- Dependencies: 282
-- Data for Name: user_files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_files (id, user_id, file_name, file_path, file_size_bytes, mime_type, file_type, session_id, is_pinned, storage_backend, retention_days, scheduled_deletion_at, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6065 (class 0 OID 152207)
-- Dependencies: 283
-- Data for Name: user_group_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_group_members (id, user_id, user_group_id, added_by, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6066 (class 0 OID 152216)
-- Dependencies: 284
-- Data for Name: user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_groups (id, organization_id, department_id, parent_id, group_type, name, slug, description, keycloak_group_id, max_members, is_active, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6067 (class 0 OID 152229)
-- Dependencies: 285
-- Data for Name: user_org_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_org_roles (expires_at, created_at, updated_at, created_by, updated_by, id, user_id, organization_id, role_id, granted_by) FROM stdin;
\N	2026-05-15 07:33:03.993	2026-05-15 07:33:03.993	\N	\N	61ff92ba-a2c2-49ec-8aed-009e74d51569	9f08f905-999a-4c6f-87bc-66e29dc6301e	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	c99954e1-3820-442c-a1cb-33f9cde68672	\N
\N	2026-05-15 07:33:04.025	2026-05-15 07:33:04.025	\N	\N	a8b4dec5-8557-420f-ba33-3363c93a0993	bd8f8f80-a9ab-43e9-999f-b653f359e4c9	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	ee7518c5-3ed0-4025-8aa5-d5c0eca54787	\N
\N	2026-05-18 06:45:42.647	2026-05-18 06:45:42.647	\N	\N	27799c01-1abb-4b47-9967-0eb31637a3cd	8d40647d-da49-4490-ada6-3bfa2205366c	07b07401-b326-4045-af3a-44a7c45e56d8	42abadfe-edfa-4b0e-985d-adaa65091959	\N
\N	2026-05-18 10:59:22.7	2026-05-18 10:59:22.7	\N	\N	40a89406-8ef3-4080-87f5-4d7d0a8f4b43	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	07b07401-b326-4045-af3a-44a7c45e56d8	42abadfe-edfa-4b0e-985d-adaa65091959	\N
\N	2026-05-20 06:34:58.137	2026-05-20 06:34:58.137	\N	\N	e15dbba7-3c80-45a2-a6ad-1fb27a2662f6	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	f231dfb8-cb4c-4942-bb56-852cf0884569	\N
\N	2026-05-20 07:38:01.638	2026-05-20 07:38:01.638	\N	\N	06b16452-6122-4758-808a-6d2f44de7979	f3a5cce9-059c-4828-ac18-61164c28e868	07b07401-b326-4045-af3a-44a7c45e56d8	42abadfe-edfa-4b0e-985d-adaa65091959	\N
\N	2026-05-20 08:28:09.245	2026-05-20 08:28:09.245	\N	\N	8078875b-0640-4db5-8212-5d89deb35441	5de255a8-d8a8-4749-a624-557da4ed87b9	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	f231dfb8-cb4c-4942-bb56-852cf0884569	\N
\N	2026-05-21 07:07:36.882	2026-05-21 07:07:36.882	\N	\N	bd887ca3-d0a1-4e5c-b4d0-c69554087889	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	f231dfb8-cb4c-4942-bb56-852cf0884569	\N
\.


--
-- TOC entry 6068 (class 0 OID 152239)
-- Dependencies: 286
-- Data for Name: user_policy_consents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_policy_consents (policy_slug, policy_version, agreed_at, ip_address, created_at, created_by, id, user_id) FROM stdin;
acceptable_use	\N	2026-05-20 06:34:58.141	127.0.0.1	2026-05-20 06:34:58.142	\N	a06e7261-3e3f-4bd0-bfbc-c5eb2fe75896	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
user_content_disclaimer	\N	2026-05-20 06:34:58.146	127.0.0.1	2026-05-20 06:34:58.148	\N	7acd787d-a84f-4642-a55d-50925439f72f	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
console_tos	\N	2026-05-20 06:34:58.149	127.0.0.1	2026-05-20 06:34:58.15	\N	254e12b3-62c1-4d27-a8b1-7bd6ad036895	75c1fbf0-8ae8-4aed-b14f-429b8c830ced
acceptable_use	\N	2026-05-20 07:38:01.64	127.0.0.1	2026-05-20 07:38:01.641	\N	5748b006-9990-48dc-8c13-9987a0814bba	f3a5cce9-059c-4828-ac18-61164c28e868
user_content_disclaimer	\N	2026-05-20 07:38:01.645	127.0.0.1	2026-05-20 07:38:01.646	\N	357cd50e-2db9-4ff2-8045-920c58682610	f3a5cce9-059c-4828-ac18-61164c28e868
console_tos	\N	2026-05-20 07:38:01.647	127.0.0.1	2026-05-20 07:38:01.648	\N	b9629b6a-1467-4ff5-8d2e-f73794aa735a	f3a5cce9-059c-4828-ac18-61164c28e868
acceptable_use	\N	2026-05-20 08:28:09.249	127.0.0.1	2026-05-20 08:28:09.251	\N	767c4f95-49c4-4206-9272-451c19bee634	5de255a8-d8a8-4749-a624-557da4ed87b9
user_content_disclaimer	\N	2026-05-20 08:28:09.253	127.0.0.1	2026-05-20 08:28:09.255	\N	d8d40702-1a1f-4c01-807d-dbcbb106d642	5de255a8-d8a8-4749-a624-557da4ed87b9
console_tos	\N	2026-05-20 08:28:09.256	127.0.0.1	2026-05-20 08:28:09.257	\N	c19b4c1b-d89c-4d82-b064-e3c89d21fee9	5de255a8-d8a8-4749-a624-557da4ed87b9
acceptable_use	\N	2026-05-21 07:07:36.887	127.0.0.1	2026-05-21 07:07:36.889	\N	ce0fd433-9f7d-4543-984a-7f046ed88ed3	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
user_content_disclaimer	\N	2026-05-21 07:07:36.891	127.0.0.1	2026-05-21 07:07:36.893	\N	240da375-5473-40cc-a563-2a018d1a0ceb	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
console_tos	\N	2026-05-21 07:07:36.894	127.0.0.1	2026-05-21 07:07:36.896	\N	88efa205-c594-4979-ab91-0324520d8e0b	fb9e2b49-d504-4495-a0ca-40b75cfcaafc
\.


--
-- TOC entry 6069 (class 0 OID 152250)
-- Dependencies: 287
-- Data for Name: user_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profiles (id, user_id, bio, enrollment_number, id_proof_url, id_proof_verified_at, id_proof_verified_by, college_name, graduation_year, github_url, linkedin_url, website_url, skills, theme_preference, notification_preferences, created_at, updated_at, created_by, updated_by, country, expertise_level, onboarding_complete, operational_domains, profession, use_case_other, use_case_purposes, years_of_experience, academic_year, course_name, department_id) FROM stdin;
96edc69d-088e-484e-a30c-2e8c19c43068	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	dark	{}	2026-05-18 06:24:46.859	2026-05-18 06:24:46.859	\N	\N	IN	beginner	t	{video_editing}	researcher	\N	{ai_ml_training,FFmpeg}	1	\N	\N	\N
7282be68-0846-46b9-90a5-6e3badaab0bf	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	dark	{}	2026-05-18 06:45:42.628	2026-05-18 06:45:57.371	\N	\N	IN	beginner	t	{software_eng}	engineer	\N	{ai_ml_training,Docker}	1	\N	\N	\N
f2872790-6011-43ae-8a52-152016ace508	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	dark	{}	2026-05-18 10:59:22.689	2026-05-18 10:59:44.246	\N	\N	IN	beginner	t	{data_science}	engineer	\N	{ai_ml_training,Jupyter}	1	\N	\N	\N
258672bc-cc14-4476-b481-b80cc21ae5b6	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	\N	\N	\N	\N	\N	K.S. Rangasamy College of Engineering	\N	\N	\N	\N	\N	dark	{}	2026-05-20 06:35:00.672	2026-05-20 06:35:12.406	\N	\N	IN	beginner	t	{software_eng}	student	\N	{data_processing,Docker}	\N	1	B.E.	47563591-17ba-4e02-9d7e-fd1c98f950a3
d0b5a77a-220e-4942-8a35-e89a5296be2c	f3a5cce9-059c-4828-ac18-61164c28e868	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	dark	{}	2026-05-20 07:46:06.976	2026-05-20 07:46:06.976	\N	\N	IN	beginner	t	{video_editing}	student	\N	{development,"After Effects"}	0	\N	\N	\N
da6677af-7153-4952-9c5c-20243336f0f2	5de255a8-d8a8-4749-a624-557da4ed87b9	\N	\N	\N	\N	\N	K.S. Rangasamy College of Engineering	\N	\N	\N	\N	\N	dark	{}	2026-05-20 08:28:12.788	2026-05-20 08:28:40.519	\N	\N	IN	beginner	t	{architecture}	student	\N	{data_processing,AutoCAD}	\N	1	B.E.	66f940dc-4ee5-4d3b-948e-940e1493028e
d4d51b0a-75bd-4006-8fb8-a7a0ec3e9d28	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	\N	\N	\N	\N	\N	K.S. Rangasamy College of Engineering	\N	\N	\N	\N	\N	dark	{}	2026-05-21 07:07:41.538	2026-05-21 07:08:37.778	\N	\N	IN	beginner	t	{deep_learning}	student	\N	{data_processing,CUDA}	\N	1	B.Tech	67ef63ef-2331-41a3-9abf-c01d56a75d3d
\.


--
-- TOC entry 6070 (class 0 OID 152266)
-- Dependencies: 288
-- Data for Name: user_storage_volumes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_storage_volumes (id, user_id, storage_uid, zfs_dataset_path, nfs_export_path, container_mount_path, os_choice, quota_bytes, used_bytes, used_bytes_updated_at, status, provisioned_at, wiped_at, wipe_reason, quota_warning_sent_at, created_at, updated_at, created_by, updated_by, allocation_type, name, price_per_gb_cents_month, node_id, storage_backend) FROM stdin;
7e6417b4-df49-472f-8ede-8a054ba28dbc	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	u_113129005bb5ebde59837825	datapool/users/u_113129005bb5ebde59837825	/mnt/nfs/users/u_113129005bb5ebde59837825	\N	ubuntu22	10737418240	0	\N	wiped	2026-05-20 12:05:00.67	2026-05-21 16:43:16.426	User requested deletion via API	\N	2026-05-20 12:05:00.67	2026-05-21 16:43:16.426	\N	\N	institution_signup	default	0	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	zfs_zvol
593577fd-a234-4a8b-9145-b14e68d89f2f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	u_ca53f137ba9f971180a53958	datapool/users/u_ca53f137ba9f971180a53958	/mnt/nfs/users/u_ca53f137ba9f971180a53958	\N	ubuntu22	34359738368	0	\N	wiped	2026-05-18 16:30:52.72	2026-05-18 16:31:09.243	User requested deletion via API	\N	2026-05-18 16:30:52.72	2026-05-18 16:31:09.243	\N	\N	user_created	es1023	700	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	zfs_zvol
73bf0b02-b72f-4dd4-a1b8-8f074b857d85	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	u_685f616624c645ead71f1619	datapool/users/u_685f616624c645ead71f1619	/mnt/nfs/users/u_685f616624c645ead71f1619	\N	ubuntu22	34359738368	0	\N	active	2026-05-21 16:43:26.854	\N	\N	\N	2026-05-21 16:43:26.854	2026-05-21 16:43:26.854	\N	\N	user_created	ef1	700	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	zfs_zvol
a431eb07-a71d-44f9-a0ba-ecac2480a3c2	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	u_7d736bf08d7ea480732f9778	datapool/users/u_7d736bf08d7ea480732f9778	/mnt/nfs/users/u_7d736bf08d7ea480732f9778	\N	ubuntu22	34359738368	0	\N	active	2026-05-18 16:31:27.074	\N	\N	\N	2026-05-18 16:31:27.074	2026-05-18 16:32:48.321	\N	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	user_created	ef23	700	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	zfs_zvol
ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	8d40647d-da49-4490-ada6-3bfa2205366c	u_962b82c8054e7213ac9a4938	datapool/users/u_962b82c8054e7213ac9a4938	/mnt/nfs/users/u_962b82c8054e7213ac9a4938	\N	ubuntu22	12884901888	0	\N	wiped	2026-05-18 12:19:22.583	2026-05-20 12:00:28.458	User requested deletion via API	\N	2026-05-18 12:19:22.583	2026-05-20 12:00:28.458	\N	8d40647d-da49-4490-ada6-3bfa2205366c	user_created	ea10	700	c9868115-ff99-403c-8e87-06124ba7df66	zfs_zvol
8d27d0fb-d618-4762-af20-f3d85f039c39	8d40647d-da49-4490-ada6-3bfa2205366c	u_80b52988266cafa9ccd98e76	datapool/users/u_80b52988266cafa9ccd98e76	/mnt/nfs/users/u_80b52988266cafa9ccd98e76	\N	ubuntu22	10737418240	0	\N	active	2026-05-20 12:00:37.15	\N	\N	\N	2026-05-20 12:00:37.15	2026-05-20 12:00:37.15	\N	\N	user_created	edf1	700	c9868115-ff99-403c-8e87-06124ba7df66	zfs_zvol
b263377c-f35a-4a23-b6f9-761257b978a5	f3a5cce9-059c-4828-ac18-61164c28e868	u_f15f2564a9c60fe5501e4589	datapool/users/u_f15f2564a9c60fe5501e4589	/mnt/nfs/users/u_f15f2564a9c60fe5501e4589	\N	ubuntu22	17179869184	0	\N	active	2026-05-20 13:36:19.566	\N	\N	\N	2026-05-20 13:36:19.566	2026-05-20 13:36:19.566	\N	\N	user_created	ef21	700	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	zfs_zvol
f2e105d9-d519-4023-894a-f14f5c04a58a	5de255a8-d8a8-4749-a624-557da4ed87b9	u_8d227bb4a08ca8b4bdc96511	datapool/users/u_8d227bb4a08ca8b4bdc96511	/mnt/nfs/users/u_8d227bb4a08ca8b4bdc96511	\N	ubuntu22	10737418240	0	\N	active	2026-05-20 13:58:12.782	\N	\N	\N	2026-05-20 13:58:12.782	2026-05-20 13:58:12.782	\N	\N	institution_signup	default	0	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	zfs_zvol
6272b69b-c681-4cb4-b373-4a2497c56376	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	u_bda5923e2382053b4e4493be	datapool/users/u_bda5923e2382053b4e4493be	/mnt/nfs/users/u_bda5923e2382053b4e4493be	\N	ubuntu22	10737418240	0	\N	wiped	2026-05-21 12:37:41.529	2026-05-21 13:04:09.927	User requested deletion via API	\N	2026-05-21 12:37:41.529	2026-05-21 13:04:09.927	\N	\N	institution_signup	default	0	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	zfs_zvol
0e408575-0246-45ee-ac86-b4b5fb767421	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	u_14629f52052167574ce6e80e	datapool/users/u_14629f52052167574ce6e80e	/mnt/nfs/users/u_14629f52052167574ce6e80e	\N	ubuntu22	34359738368	0	\N	active	2026-05-21 16:54:27.881	\N	\N	\N	2026-05-21 16:54:27.881	2026-05-21 16:54:27.881	\N	\N	user_created	df2	700	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	zfs_zvol
\.


--
-- TOC entry 6071 (class 0 OID 152288)
-- Dependencies: 289
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (email, email_verified_at, password_hash, first_name, last_name, display_name, avatar_url, phone, timezone, keycloak_sub, auth_type, oauth_provider, storage_uid, token_version, two_factor_enabled, last_login_at, last_login_ip, onboarding_completed_at, is_active, created_at, updated_at, deleted_at, storage_provisioned_at, storage_provisioning_error, storage_provisioning_status, created_by, keycloak_last_sync_at, lock_expires_at, lock_reason, locked_at, os_choice, pending_email, updated_by, id, default_org_id, referred_by_code) FROM stdin;
it_admin@ksrce.in	\N	$2b$10$JTOY2w1Bt8D2YbJYeRBaPueFREpcgRtBDgb3WRvTP0mLd.FcPMlh2	IT	Administrator	\N	\N	\N	Asia/Kolkata	\N	public_local	\N	\N	0	f	2026-05-15 07:58:44.492	127.0.0.1	\N	t	2026-05-15 07:33:04.015	2026-05-15 07:58:44.494	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	bd8f8f80-a9ab-43e9-999f-b653f359e4c9	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	\N
test-user@ksrce.in	2026-05-20 06:34:58.129	$2b$10$phc1.YO1qKGnvEduHBqr3usO/iQ92inWjjLBW464ZFSOs/vTYhCZe	test-user	KSRCE	\N	\N	\N	Asia/Kolkata	\N	institution_local	\N	u_685f616624c645ead71f1619	0	f	2026-05-21 11:12:51.299	127.0.0.1	\N	t	2026-05-20 06:34:58.13	2026-05-21 16:43:26.858	\N	2026-05-21 16:43:26.858	\N	provisioned	\N	\N	\N	\N	\N	\N	\N	\N	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	\N
ttdinesh@gmail.com	2026-05-20 07:38:01.632	$2b$10$gYxTYXP6O1yhVBcY38I/FeoYgtAhVn1fb1ZlevzTIkDBaO1zurr/y	dinesh	t	\N	\N	\N	Asia/Kolkata	\N	public_local	\N	u_f15f2564a9c60fe5501e4589	0	f	2026-05-21 05:17:47.121	127.0.0.1	\N	t	2026-05-20 07:38:01.633	2026-05-21 05:17:47.123	\N	2026-05-20 13:36:19.57	\N	provisioned	\N	\N	\N	\N	\N	\N	\N	\N	f3a5cce9-059c-4828-ac18-61164c28e868	07b07401-b326-4045-af3a-44a7c45e56d8	\N
viswanaths365@gmail.com	\N	\N	Punith	VS	\N	\N	\N	Asia/Kolkata	3fe2b6fe-6c48-47a7-ae6b-da52eef70660	public_oauth	keycloak	u_7d736bf08d7ea480732f9778	0	f	2026-05-18 10:59:24.467	127.0.0.1	\N	t	2026-05-18 10:59:22.677	2026-05-18 16:31:27.078	\N	2026-05-18 16:31:27.078	\N	provisioned	\N	\N	\N	\N	\N	\N	\N	\N	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	07b07401-b326-4045-af3a-44a7c45e56d8	\N
test-user10@ksrce.in	2026-05-21 07:07:36.873	$2b$10$8f74qYb.zGvAWsZQphGRJOYkvUeIsaSMX9YtP.E6cNyp49jJqLK/2	test-user	10	\N	\N	\N	Asia/Kolkata	\N	institution_local	\N	u_14629f52052167574ce6e80e	0	f	2026-05-21 12:02:02.714	127.0.0.1	\N	t	2026-05-21 07:07:36.875	2026-05-21 12:02:02.715	\N	2026-05-21 16:54:27.885	\N	provisioned	\N	\N	\N	\N	\N	\N	\N	\N	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	\N
test-user123@ksrce.in	2026-05-20 08:28:09.235	$2b$10$mQf4WAGVfY0sX5g9ekSWY.JvKjvabO/7chnmYnf2UmVSy6jM5SYk6	test-user	23	\N	\N	\N	Asia/Kolkata	\N	institution_local	\N	u_8d227bb4a08ca8b4bdc96511	0	f	\N	\N	\N	t	2026-05-20 08:28:09.237	2026-05-20 08:28:12.768	\N	2026-05-20 08:28:12.764	\N	provisioned	\N	\N	\N	\N	\N	\N	\N	\N	5de255a8-d8a8-4749-a624-557da4ed87b9	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	\N
punith.vs74064@gmail.com	\N	\N	Punith	VS	\N	\N	\N	Asia/Kolkata	0fbe8ba9-74c2-4b3a-9d22-5cde9d40ee64	public_oauth	keycloak	u_80b52988266cafa9ccd98e76	0	f	2026-05-21 12:29:28.791	127.0.0.1	\N	t	2026-05-18 06:45:42.602	2026-05-21 12:29:28.797	\N	2026-05-20 12:00:37.152	\N	provisioned	\N	\N	\N	\N	\N	\N	\N	\N	8d40647d-da49-4490-ada6-3bfa2205366c	07b07401-b326-4045-af3a-44a7c45e56d8	\N
business_lead@ksrce.in	\N	$2b$10$JTOY2w1Bt8D2YbJYeRBaPueFREpcgRtBDgb3WRvTP0mLd.FcPMlh2	Business-Lead	Lead	\N	\N	\N	Asia/Kolkata	\N	public_local	\N	\N	0	f	2026-05-21 15:18:41.843	127.0.0.1	\N	t	2026-05-15 07:33:03.975	2026-05-21 15:18:41.846	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	9f08f905-999a-4c6f-87bc-66e29dc6301e	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	\N
\.


--
-- TOC entry 6072 (class 0 OID 152308)
-- Dependencies: 290
-- Data for Name: waitlist_entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.waitlist_entries (id, "userId", email, "firstName", "lastName", "currentStatus", "organizationName", "jobTitle", "computeNeeds", "expectedDuration", urgency, expectations, "primaryWorkload", "workloadDescription", "agreedToPolicy", "policyAgreedAt", "agreedToComms", status, "createdAt", "updatedAt") FROM stdin;
\.


--
-- TOC entry 6073 (class 0 OID 152324)
-- Dependencies: 291
-- Data for Name: wallet_holds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wallet_holds (id, wallet_id, user_id, amount_cents, hold_reason, booking_id, session_id, status, expires_at, released_at, release_reason, captured_amount, created_at) FROM stdin;
a5f1600e-18d3-44ec-bdd4-a6fbd0661517	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	36000	compute_session_hold	\N	c4ce3860-7509-47a7-b3d6-60592b593100	captured	2026-05-18 08:02:40.062	2026-05-18 07:03:02.474	prepaid_hour_charged	36000	2026-05-18 07:02:40.064
47db6d32-5162-4b7c-b2d9-fc28131a0301	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	36000	compute_session_hold	\N	b3fb45cb-ac62-41bb-b65b-babce27a14fe	captured	2026-05-18 08:30:32.318	2026-05-18 07:30:52.735	prepaid_hour_charged	36000	2026-05-18 07:30:32.32
6217af28-fea3-454d-a9b3-483b2937ce04	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	12000	compute_session_hold	\N	a50d4adb-5e31-41ba-9972-91dc118efdc0	captured	2026-05-18 08:31:09.335	2026-05-18 07:31:29.709	prepaid_hour_charged	12000	2026-05-18 07:31:09.336
2caf6589-5d75-4131-9a78-f587870a96df	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	36000	compute_session_hold	\N	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	captured	2026-05-18 11:21:07.612	2026-05-18 10:21:28.171	prepaid_hour_charged	36000	2026-05-18 10:21:07.614
515b216e-123b-484d-9c80-3f881c560a92	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	12000	compute_session_hold	\N	968bf735-3894-4093-838d-efb4a943315d	captured	2026-05-18 18:36:32.235	2026-05-18 17:36:54.672	prepaid_hour_charged	12000	2026-05-18 17:36:32.236
a27d161b-72bf-46ee-b4b8-bd0a0888b320	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	12000	compute_session_hold	\N	46541468-ee50-4fab-bd02-4250162c40e6	captured	2026-05-18 19:04:03.811	2026-05-18 18:04:26.456	prepaid_hour_charged	12000	2026-05-18 18:04:03.812
7648bd4c-d042-4bdf-8f05-26594fd4b2af	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	12000	compute_session_hold	\N	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	captured	2026-05-18 19:37:31.869	2026-05-18 18:37:54.469	prepaid_hour_charged	12000	2026-05-18 18:37:31.871
7ba220ae-50a0-40e8-9ba5-e52966c9c54c	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	12000	compute_session_hold	\N	aef9cfcc-1747-4572-933e-6cf55bce8993	captured	2026-05-19 01:22:02.119	2026-05-19 00:22:22.476	prepaid_hour_charged	12000	2026-05-19 00:22:02.12
f7cb7bc6-b69a-49a3-88d2-3d80195908d3	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	30000	compute_session_hold	\N	fae608c4-ed05-41cd-b0b6-4134aaaa6354	captured	2026-05-19 01:24:43.563	2026-05-19 00:24:59.895	prepaid_hour_charged	30000	2026-05-19 00:24:43.564
64295b19-a815-4a58-926e-e31be06d12c3	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	30000	compute_session_hold	\N	8548fb98-e8da-4f26-85da-e343210f26a2	captured	2026-05-19 05:27:52.466	2026-05-19 04:28:15.286	prepaid_hour_charged	30000	2026-05-19 04:27:52.468
f91f61b6-f304-4b13-8bf3-fc575c4db5d3	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	12000	compute_session_hold	\N	7c24eb9b-cef9-43c9-9874-220745bc7662	captured	2026-05-19 13:43:12.314	2026-05-19 12:43:34.729	prepaid_hour_charged	12000	2026-05-19 12:43:12.316
67dff2ab-b025-4a50-b63d-69c6b5c5c228	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	36000	compute_session_hold	\N	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	captured	2026-05-20 01:43:02.162	2026-05-20 00:43:24.773	prepaid_hour_charged	36000	2026-05-20 00:43:02.164
e117cf09-1570-497c-9efc-39b221f9197c	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	36000	compute_session_hold	\N	a580b232-5224-4c8e-b8b5-a1cf39642e0c	captured	2026-05-20 07:30:56.006	2026-05-20 06:31:20.444	prepaid_hour_charged	36000	2026-05-20 06:30:56.008
f21f25d2-abef-4d31-8c60-6f2a33c07770	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	12000	compute_session_hold	\N	c5925ef4-d5dd-4551-9165-50ce29fac9ff	captured	2026-05-20 07:31:53.034	2026-05-20 06:32:15.535	prepaid_hour_charged	12000	2026-05-20 06:31:53.035
f4676786-e648-4670-9305-605346e7ac5c	f9c9deed-f0c2-4261-b4b3-530b94fbf283	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	12000	compute_session_hold	\N	f644f81d-3b03-46c3-bfdb-d098923af02c	captured	2026-05-20 07:36:04.91	2026-05-20 06:36:21.222	prepaid_hour_charged	12000	2026-05-20 06:36:04.911
e04fc267-067b-4a86-9f28-2267cb208308	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	21000	compute_session_hold	\N	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	captured	2026-05-20 08:22:16.572	2026-05-20 07:22:38.975	prepaid_hour_charged	21000	2026-05-20 07:22:16.574
5cc4dcef-10ec-4e1a-8da7-801061c90b65	2c611ab8-caab-42c7-97f4-9b7e6306972b	f3a5cce9-059c-4828-ac18-61164c28e868	36000	compute_session_hold	\N	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	captured	2026-05-20 09:11:23.226	2026-05-20 08:11:44.139	prepaid_hour_charged	36000	2026-05-20 08:11:23.227
\.


--
-- TOC entry 6074 (class 0 OID 152336)
-- Dependencies: 292
-- Data for Name: wallet_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wallet_transactions (id, wallet_id, user_id, txn_type, amount_cents, balance_after_cents, reference_type, reference_id, description, created_at, created_by) FROM stdin;
60b9c46a-ce17-4a0b-97bd-1d21360a5a89	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	credit	500000	500000	payment	1acbc4e6-ec5a-4285-9344-d9ef9f71f43e	Credit recharge via Razorpay	2026-05-18 06:48:37.661	\N
be097129-0649-4b3d-97b7-f1e4b314a3e2	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	36000	464000	compute_billing	c4ce3860-7509-47a7-b3d6-60592b593100	Compute charge - session launch (prepaid hour 1)	2026-05-18 07:03:02.461	\N
85b58bf2-798b-4d9f-b180-59054ce71538	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	463990	storage_billing	\N	Storage billing: 10GB for 2026-05-18T07:30:00.000Z	2026-05-18 07:30:00.104	\N
0fd2cc3e-21ed-4ca5-b95e-570d169b709e	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	36000	427990	compute_billing	b3fb45cb-ac62-41bb-b65b-babce27a14fe	Compute charge - session launch (prepaid hour 1)	2026-05-18 07:30:52.721	\N
ffc87569-0d05-45f1-96be-6ac7d1d93410	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	415990	compute_billing	a50d4adb-5e31-41ba-9972-91dc118efdc0	Compute charge - session launch (prepaid hour 1)	2026-05-18 07:31:29.695	\N
7e306b63-c509-41d3-8225-de8e497bcec3	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	415980	storage_billing	\N	Storage billing: 10GB for 2026-05-18T08:30:00.000Z	2026-05-18 08:30:00.048	\N
22bb8e09-1706-4833-8036-c0c266454534	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	403980	compute_billing	a50d4adb-5e31-41ba-9972-91dc118efdc0	Prepaid compute - Hour 2: gpu-instance-5ef5	2026-05-18 08:30:00.096	\N
e9ca97e7-5470-4bba-ab15-bfe439e5a783	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	391980	compute_billing	a50d4adb-5e31-41ba-9972-91dc118efdc0	Prepaid compute - Hour 3: gpu-instance-5ef5	2026-05-18 09:30:00.073	\N
71e6b3d6-f5f1-4df1-9d8e-42efea789e8c	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	391970	storage_billing	\N	Storage billing: 10GB for 2026-05-18T09:30:00.000Z	2026-05-18 09:30:00.129	\N
f6ede85a-732b-49f9-8d87-f404b93007e4	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	36000	355970	compute_billing	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	Compute charge - session launch (prepaid hour 1)	2026-05-18 10:21:28.148	\N
97d73234-d5e1-4096-9a21-f7b6616c2988	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	355960	storage_billing	\N	Storage billing: 10GB for 2026-05-18T10:30:00.000Z	2026-05-18 10:30:00.038	\N
80b0d04d-5670-4fd0-bdb4-9a804b41e0ee	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	343960	compute_billing	a50d4adb-5e31-41ba-9972-91dc118efdc0	Prepaid compute - Hour 4: gpu-instance-5ef5	2026-05-18 10:30:00.093	\N
e74a87f3-3b8f-47bb-8e3d-d836075dbab0	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	36000	307960	compute_billing	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	Prepaid compute - Hour 2: gpu-instance-64uh	2026-05-18 10:30:00.113	\N
e5ac4c0f-1deb-4dde-aeed-34469ebe572e	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	credit	1000000	1307960	payment	80b2ca83-1f4f-4abe-aa7c-153fab0f0b7f	Credit recharge via Razorpay	2026-05-18 10:55:22.425	\N
dc015937-20fe-4ca2-91df-0eac8a005730	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	credit	100000	100000	payment	39891e7a-1510-4e43-92c8-2b8cd34c8479	Credit recharge via Razorpay	2026-05-18 11:00:35.656	\N
4e623047-62f4-4dab-a1ff-13d2e5c70540	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	1307948	storage_billing	\N	Storage billing: 12GB for 2026-05-18T11:30:00.000Z	2026-05-18 11:30:00.062	\N
9e590d3e-d7ba-408f-bda8-25da9657d3f7	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	1295960	compute_billing	a50d4adb-5e31-41ba-9972-91dc118efdc0	Prepaid compute - Hour 5: gpu-instance-5ef5	2026-05-18 11:30:00.064	\N
05e4bdfa-2a6c-4e02-b49d-3c65d0a4d0eb	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99969	storage_billing	\N	Storage billing: 32GB for 2026-05-18T11:30:00.000Z	2026-05-18 11:30:00.111	\N
f6995bc1-efa3-4b9a-a778-f02c3bef7578	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	36000	1271948	compute_billing	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	Prepaid compute - Hour 3: gpu-instance-64uh	2026-05-18 11:30:00.11	\N
2f1f6370-88c0-41bd-b75f-b2ea40e44a93	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	1271936	storage_billing	\N	Storage billing: 12GB for 2026-05-18T12:30:00.000Z	2026-05-18 12:30:00.054	\N
817cdb12-c07e-4ebb-af92-d380a3c9c47e	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	1259948	compute_billing	a50d4adb-5e31-41ba-9972-91dc118efdc0	Prepaid compute - Hour 6: gpu-instance-5ef5	2026-05-18 12:30:00.055	\N
d50b2cb7-a694-4e12-89f9-4346d6749156	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99938	storage_billing	\N	Storage billing: 32GB for 2026-05-18T12:30:00.000Z	2026-05-18 12:30:00.084	\N
023e8780-dced-4c09-bf69-6a96991e39b3	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	36000	1235936	compute_billing	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	Prepaid compute - Hour 4: gpu-instance-64uh	2026-05-18 12:30:00.085	\N
bb2d2bb6-0612-44cd-a1fb-156ebc4960fd	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	1235924	storage_billing	\N	Storage billing: 12GB for 2026-05-18T13:30:00.000Z	2026-05-18 13:49:44.993	\N
927af7cf-a7fb-47b6-b09a-19a5101a7e29	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	36000	1199936	compute_billing	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	Prepaid compute - Hour 5: gpu-instance-64uh	2026-05-18 13:49:44.995	\N
5201fdf5-3e55-4b5f-822a-785db5d37c53	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	1187936	compute_billing	a50d4adb-5e31-41ba-9972-91dc118efdc0	Prepaid compute - Hour 7: gpu-instance-5ef5	2026-05-18 13:49:45.169	\N
90677aa1-35c6-45d6-903c-26d2c21334f8	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99907	storage_billing	\N	Storage billing: 32GB for 2026-05-18T13:30:00.000Z	2026-05-18 13:49:45.177	\N
5cb0b434-2c2a-4f3e-b899-064b27205268	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	108000	1079936	compute_billing	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	Final compute charge: gpu-instance-64uh	2026-05-18 17:23:42.433	\N
5e2676a9-c06a-4a3b-868e-228fef183e41	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	1079924	storage_billing	\N	Storage billing: 12GB for 2026-05-18T17:30:00.000Z	2026-05-18 17:30:02.965	\N
ba7d126b-3c44-4d7a-9c07-744300cb933e	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	1067936	compute_billing	a50d4adb-5e31-41ba-9972-91dc118efdc0	Prepaid compute - Hour 8: gpu-instance-5ef5	2026-05-18 17:30:02.969	\N
20416aa7-7a4a-461d-a37e-5a790862b5af	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99876	storage_billing	\N	Storage billing: 32GB for 2026-05-18T17:30:00.000Z	2026-05-18 17:30:03	\N
6a9e8572-81c2-4cd4-8e56-18f24ab8ae9b	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	1067924	compute_billing	968bf735-3894-4093-838d-efb4a943315d	Compute charge - session launch (prepaid hour 1)	2026-05-18 17:36:54.665	\N
88dfec6e-a3d2-4337-8cab-11fd6edc1762	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	1055924	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Compute charge - session launch (prepaid hour 1)	2026-05-18 18:04:26.447	\N
d1136ac4-8332-4743-9626-b37b5fd2530d	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	1055912	storage_billing	\N	Storage billing: 12GB for 2026-05-18T18:30:00.000Z	2026-05-18 18:30:00.051	\N
dd591601-26ea-4199-9783-e6a21f1cf641	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	1043924	compute_billing	a50d4adb-5e31-41ba-9972-91dc118efdc0	Prepaid compute - Hour 9: gpu-instance-5ef5	2026-05-18 18:30:00.052	\N
08bbc186-5e21-42de-9d7f-9d251bb790c8	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99845	storage_billing	\N	Storage billing: 32GB for 2026-05-18T18:30:00.000Z	2026-05-18 18:30:00.086	\N
72535ca4-90f8-434f-bdda-8e887b531586	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	1043912	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 2: gpu-instance-06p0	2026-05-18 18:30:00.258	\N
5c23022a-08d7-4e90-872f-eaa2fe0f3dcb	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	1031912	compute_billing	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	Compute charge - session launch (prepaid hour 1)	2026-05-18 18:37:54.461	\N
a3a7f84c-5f18-4ee4-a436-f40d2e3f284d	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	1019912	compute_billing	a50d4adb-5e31-41ba-9972-91dc118efdc0	Prepaid compute - Hour 10: gpu-instance-5ef5	2026-05-18 20:01:14.457	\N
3da970c0-ad0a-4436-b537-ffb2c91533a3	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	1007912	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 3: gpu-instance-06p0	2026-05-18 20:01:14.541	\N
aca4a607-110c-4b3e-be3a-34f7a3ce6902	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	1007900	storage_billing	\N	Storage billing: 12GB for 2026-05-18T23:30:00.000Z	2026-05-18 23:43:25.556	\N
51833ecb-ee18-4602-bf03-120e2e9d0475	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	995912	compute_billing	a50d4adb-5e31-41ba-9972-91dc118efdc0	Prepaid compute - Hour 11: gpu-instance-5ef5	2026-05-18 23:43:25.601	\N
868b9e04-5e33-4f8b-b740-aa984cf78f04	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	995900	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 4: gpu-instance-06p0	2026-05-18 23:43:27.579	\N
f352de78-4f29-4f5c-830f-71eb5e063b58	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99814	storage_billing	\N	Storage billing: 32GB for 2026-05-18T23:30:00.000Z	2026-05-18 23:43:27.618	\N
5b26385a-ee40-49ee-8653-a2f95db3d137	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	983900	compute_billing	aef9cfcc-1747-4572-933e-6cf55bce8993	Compute charge - session launch (prepaid hour 1)	2026-05-19 00:22:22.467	\N
7f4f33a4-fa4e-4805-b994-fd00098ce259	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	72000	911900	compute_billing	a50d4adb-5e31-41ba-9972-91dc118efdc0	Final compute charge: gpu-instance-5ef5	2026-05-19 00:23:24.873	\N
ab6cae58-3e38-4038-92c9-d44223cc5167	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	30000	881900	compute_billing	fae608c4-ed05-41cd-b0b6-4134aaaa6354	Compute charge - session launch (prepaid hour 1)	2026-05-19 00:24:59.889	\N
054ede88-4b1e-4092-9a71-9f0f1a29ab0d	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	881888	storage_billing	\N	Storage billing: 12GB for 2026-05-19T00:30:00.000Z	2026-05-19 00:30:00.098	\N
354d900b-ade1-4fff-82c8-eeae2cb8b476	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	869900	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 5: gpu-instance-06p0	2026-05-19 00:30:00.104	\N
d49fdb45-e04b-458d-9ad1-0701477ebc4f	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99783	storage_billing	\N	Storage billing: 32GB for 2026-05-19T00:30:00.000Z	2026-05-19 00:30:00.147	\N
4318a73b-e913-40ab-abbf-8d502d358680	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	869888	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 6: gpu-instance-06p0	2026-05-19 02:40:11.3	\N
6e10d9d0-b09b-4a2e-ab00-38c16b568678	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	881876	storage_billing	\N	Storage billing: 12GB for 2026-05-19T02:30:00.000Z	2026-05-19 02:40:11.637	\N
466b8f63-dded-4416-aa9c-6ac259cde1d7	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99752	storage_billing	\N	Storage billing: 32GB for 2026-05-19T02:30:00.000Z	2026-05-19 02:40:14.386	\N
8c9ff06f-db7c-4578-a386-14fccc035b9f	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	881864	storage_billing	\N	Storage billing: 12GB for 2026-05-19T03:30:00.000Z	2026-05-19 03:30:00.096	\N
865d4e85-0757-4df2-a40b-e3bedf7b00e7	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	869876	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 7: gpu-instance-06p0	2026-05-19 03:30:00.096	\N
e65b8210-dac0-496c-83ef-eee052485b99	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99721	storage_billing	\N	Storage billing: 32GB for 2026-05-19T03:30:00.000Z	2026-05-19 03:30:00.139	\N
dcddb480-4076-416b-b803-863395e2028a	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	30000	851864	compute_billing	8548fb98-e8da-4f26-85da-e343210f26a2	Compute charge - session launch (prepaid hour 1)	2026-05-19 04:28:15.212	\N
f7a275ca-a7e4-404c-8dad-da3fbe74f199	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	851852	storage_billing	\N	Storage billing: 12GB for 2026-05-19T04:30:00.000Z	2026-05-19 04:30:00.1	\N
8bd8cac0-6d64-4128-85c1-f122f0e0d5c0	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	839864	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 8: gpu-instance-06p0	2026-05-19 04:30:00.105	\N
994a4649-0226-4d3d-9ffc-7fc62438f4bf	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99690	storage_billing	\N	Storage billing: 32GB for 2026-05-19T04:30:00.000Z	2026-05-19 04:30:00.124	\N
66116fe8-95b1-432d-a94b-f61f5427b0e8	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	30000	809864	compute_billing	8548fb98-e8da-4f26-85da-e343210f26a2	Prepaid compute - Hour 2: gpu-instance-gsim	2026-05-19 04:30:00.149	\N
0382d574-7e61-438d-9735-1c475a92697f	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	809852	storage_billing	\N	Storage billing: 12GB for 2026-05-19T06:30:00.000Z	2026-05-19 06:30:00.133	\N
bf61169f-f273-406e-8257-a82bd00edb57	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	30000	779864	compute_billing	8548fb98-e8da-4f26-85da-e343210f26a2	Prepaid compute - Hour 3: gpu-instance-gsim	2026-05-19 06:30:00.138	\N
fc40d17e-28db-4cc5-a0b5-5b84896d4672	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99659	storage_billing	\N	Storage billing: 32GB for 2026-05-19T06:30:00.000Z	2026-05-19 06:30:00.203	\N
49d9ae9f-5411-4bc6-9740-6bcbe85a87b2	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	797852	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 9: gpu-instance-06p0	2026-05-19 06:30:00.202	\N
47b876af-797e-4ccf-a771-fcfb9d76e829	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	797840	storage_billing	\N	Storage billing: 12GB for 2026-05-19T07:30:00.000Z	2026-05-19 07:30:00.055	\N
4c06a6f9-6d84-45f0-9ad0-aa59d0688313	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99628	storage_billing	\N	Storage billing: 32GB for 2026-05-19T07:30:00.000Z	2026-05-19 07:30:00.085	\N
5f1b9e37-50a9-4ce6-a6de-97050149371c	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	785840	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 10: gpu-instance-06p0	2026-05-19 07:30:00.123	\N
743050bc-0fad-459b-a3ca-7b420d2ac661	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	30000	755840	compute_billing	8548fb98-e8da-4f26-85da-e343210f26a2	Prepaid compute - Hour 4: gpu-instance-gsim	2026-05-19 07:30:00.148	\N
93b1ba31-9780-4e93-a584-cf0f9f3868c3	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	30000	725840	compute_billing	8548fb98-e8da-4f26-85da-e343210f26a2	Prepaid compute - Hour 5: gpu-instance-gsim	2026-05-19 08:30:00.244	\N
c46d8016-f4f5-4376-ba5c-adc98e9d8a12	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	755828	storage_billing	\N	Storage billing: 12GB for 2026-05-19T08:30:00.000Z	2026-05-19 08:30:00.245	\N
be2f3184-0644-4cf4-9b65-b785e4fd4f08	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99597	storage_billing	\N	Storage billing: 32GB for 2026-05-19T08:30:00.000Z	2026-05-19 08:30:00.441	\N
c65a516b-1df5-42c9-9120-344b3d328b55	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	743828	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 11: gpu-instance-06p0	2026-05-19 08:30:00.602	\N
a5794900-4ae4-4622-876e-c39df3dca7cf	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	743816	storage_billing	\N	Storage billing: 12GB for 2026-05-19T09:30:00.000Z	2026-05-19 09:30:00.644	\N
585ba430-8b72-4af2-af16-c5320da4271d	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	731828	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 12: gpu-instance-06p0	2026-05-19 09:30:00.672	\N
207ed39a-ffb2-492b-9d15-75c4a3e6b516	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99566	storage_billing	\N	Storage billing: 32GB for 2026-05-19T09:30:00.000Z	2026-05-19 09:30:00.7	\N
0e2699c3-4221-4135-887b-b311533f631a	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	30000	701828	compute_billing	8548fb98-e8da-4f26-85da-e343210f26a2	Prepaid compute - Hour 6: gpu-instance-gsim	2026-05-19 09:30:00.743	\N
750e0f6c-bffd-4738-b040-d1927275497e	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	701816	storage_billing	\N	Storage billing: 12GB for 2026-05-19T10:30:00.000Z	2026-05-19 10:30:00.086	\N
10aacb5a-1063-4b41-ba1b-a0eaf6533220	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	30000	671828	compute_billing	8548fb98-e8da-4f26-85da-e343210f26a2	Prepaid compute - Hour 7: gpu-instance-gsim	2026-05-19 10:30:00.093	\N
4ed86f5d-3c13-4188-b315-0fbde206c4e5	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	659828	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 13: gpu-instance-06p0	2026-05-19 10:30:00.149	\N
46e3f404-f651-4710-9e27-556f067a4f74	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99535	storage_billing	\N	Storage billing: 32GB for 2026-05-19T10:30:00.000Z	2026-05-19 10:30:00.264	\N
dff6e54a-0cad-4676-a3f2-93e39576e9ed	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	659816	storage_billing	\N	Storage billing: 12GB for 2026-05-19T11:30:00.000Z	2026-05-19 11:30:00.089	\N
f5811d7c-d39f-4a91-8c1e-4ffd3622c643	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	30000	629828	compute_billing	8548fb98-e8da-4f26-85da-e343210f26a2	Prepaid compute - Hour 8: gpu-instance-gsim	2026-05-19 11:30:00.091	\N
492f1fda-b9c3-4448-9417-82f1cf4b81c0	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	647816	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 14: gpu-instance-06p0	2026-05-19 11:30:00.144	\N
5d783f20-c65e-4950-9001-1924598a8580	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99504	storage_billing	\N	Storage billing: 32GB for 2026-05-19T11:30:00.000Z	2026-05-19 11:30:00.149	\N
b6efdb92-debe-4e09-8ba1-e117b1393d5f	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	30000	617816	compute_billing	8548fb98-e8da-4f26-85da-e343210f26a2	Prepaid compute - Hour 9: gpu-instance-gsim	2026-05-19 12:30:00.05	\N
322010f3-bbe3-447b-8f55-6aeac4ceb49a	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	647804	storage_billing	\N	Storage billing: 12GB for 2026-05-19T12:30:00.000Z	2026-05-19 12:30:00.052	\N
f8d80c09-077d-420c-8961-5c002b00189c	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99473	storage_billing	\N	Storage billing: 32GB for 2026-05-19T12:30:00.000Z	2026-05-19 12:30:00.089	\N
146d1f04-5ae7-4ad7-aa0b-56cddc589ede	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	635804	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 15: gpu-instance-06p0	2026-05-19 12:30:00.152	\N
cf7221db-cf11-4d76-a405-6c0daf76f488	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	623804	compute_billing	7c24eb9b-cef9-43c9-9874-220745bc7662	Compute charge - session launch (prepaid hour 1)	2026-05-19 12:43:34.716	\N
a7de1322-75dd-48cc-b1f1-8898860ad232	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	611804	compute_billing	7c24eb9b-cef9-43c9-9874-220745bc7662	Prepaid compute - Hour 2: gpu-instance-0ybq	2026-05-19 16:26:58.596	\N
96c4fb19-759e-4022-941e-9c725d9244c7	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	623792	storage_billing	\N	Storage billing: 12GB for 2026-05-19T15:30:00.000Z	2026-05-19 16:26:59.249	\N
37f251ab-a30d-4180-990a-3e42d59fdb1a	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	30000	581804	compute_billing	8548fb98-e8da-4f26-85da-e343210f26a2	Prepaid compute - Hour 10: gpu-instance-gsim	2026-05-19 16:26:59.516	\N
7f195ac7-7a53-40d4-8227-d2dc86365c4c	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99442	storage_billing	\N	Storage billing: 32GB for 2026-05-19T15:30:00.000Z	2026-05-19 16:26:59.524	\N
a83eb2b3-0089-487f-8573-9745561f7dc8	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	569804	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 16: gpu-instance-06p0	2026-05-19 16:26:59.729	\N
297bbb7a-fec5-4308-9dd7-b8dfabfaa6c0	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	90000	479804	compute_billing	8548fb98-e8da-4f26-85da-e343210f26a2	Final compute charge: gpu-instance-gsim	2026-05-19 16:33:50.15	\N
eb9162b2-01c8-410a-b414-ff73dd1dbbde	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	24000	455804	compute_billing	7c24eb9b-cef9-43c9-9874-220745bc7662	Final compute charge: gpu-instance-0ybq	2026-05-19 16:34:20.167	\N
a063461d-7873-4614-9c2f-2149f7da0d7a	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	455792	storage_billing	\N	Storage billing: 12GB for 2026-05-19T18:30:00.000Z	2026-05-19 18:30:00.229	\N
9be4dc7c-1162-46d2-bbe6-c748901b518d	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99411	storage_billing	\N	Storage billing: 32GB for 2026-05-19T18:30:00.000Z	2026-05-19 18:30:00.311	\N
4e3ad535-ff28-421b-b6d6-5cd7143c85c1	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	443792	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 17: gpu-instance-06p0	2026-05-19 18:30:00.418	\N
c2549ddf-3522-4dfb-ac48-dae0e82735de	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	431792	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 18: gpu-instance-06p0	2026-05-19 19:30:00.072	\N
eaccc32b-6c50-4113-b8ae-fa02624065bd	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	431780	storage_billing	\N	Storage billing: 12GB for 2026-05-19T19:30:00.000Z	2026-05-19 19:30:00.127	\N
7aacf6f6-7394-472d-b362-5a031bdd0d74	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99380	storage_billing	\N	Storage billing: 32GB for 2026-05-19T19:30:00.000Z	2026-05-19 19:30:00.147	\N
878a6aec-4573-4d7d-a318-91d8065e76a1	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	431768	storage_billing	\N	Storage billing: 12GB for 2026-05-19T23:30:00.000Z	2026-05-19 23:43:31.684	\N
a46d7dc6-6742-4541-ab8e-534acbb5fe45	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	419780	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 19: gpu-instance-06p0	2026-05-19 23:43:31.731	\N
4a500327-744d-46a4-b462-16095617b7a5	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99349	storage_billing	\N	Storage billing: 32GB for 2026-05-19T23:30:00.000Z	2026-05-19 23:43:32.308	\N
7dc143ea-cddf-43d6-b7c7-f6a7e4195fbd	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	431756	storage_billing	\N	Storage billing: 12GB for 2026-05-20T00:30:00.000Z	2026-05-20 00:30:00.168	\N
55231e39-4358-49a0-98b3-46932b601c58	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	419768	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 20: gpu-instance-06p0	2026-05-20 00:30:00.178	\N
6e4806ad-e06a-479f-bf9c-951a035ee786	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99318	storage_billing	\N	Storage billing: 32GB for 2026-05-20T00:30:00.000Z	2026-05-20 00:30:00.229	\N
9c137b04-6c2d-4acf-b642-b38c47567290	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	credit	500000	931756	payment	0cf9314e-2df0-4d34-b915-b9378ef9e80e	Credit recharge via Razorpay	2026-05-20 00:36:54.693	\N
85ca5903-22c7-45f4-bce4-7a3e6d68dad1	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	36000	895756	compute_billing	dc4bfb83-8bdc-47c9-a5fb-e8affbbea4d0	Compute charge - session launch (prepaid hour 1)	2026-05-20 00:43:24.761	\N
ea1c66d4-2c87-4fe2-8234-f04e5c5fa663	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	883756	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 21: gpu-instance-06p0	2026-05-20 02:30:00.509	\N
18faeb10-6813-4e3e-841e-2650736cf4fd	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	895744	storage_billing	\N	Storage billing: 12GB for 2026-05-20T02:30:00.000Z	2026-05-20 02:30:00.507	\N
ddd2d087-44d3-45b0-b1c1-57c145654918	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99287	storage_billing	\N	Storage billing: 32GB for 2026-05-20T02:30:00.000Z	2026-05-20 02:30:00.713	\N
70e407b6-56ca-4c6b-b2b7-911708bf5c2f	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	895732	storage_billing	\N	Storage billing: 12GB for 2026-05-20T03:30:00.000Z	2026-05-20 03:30:00.12	\N
0abdbb25-1345-456e-beca-dcbec82e9ef7	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	883744	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 22: gpu-instance-06p0	2026-05-20 03:30:00.126	\N
ceaf37cf-ebc4-42d3-a4de-992cfc8af224	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99256	storage_billing	\N	Storage billing: 32GB for 2026-05-20T03:30:00.000Z	2026-05-20 03:30:00.161	\N
347113d1-3572-433d-9f94-924a3a5b0b26	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12	895720	storage_billing	\N	Storage billing: 12GB for 2026-05-20T06:30:00.000Z	2026-05-20 06:30:00.3	\N
1f47dc00-7a93-49af-ae86-d59b40e56a62	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	883720	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Prepaid compute - Hour 23: gpu-instance-06p0	2026-05-20 06:30:00.497	\N
b958a7cb-0b3f-49bb-a4e0-8cfd097c520c	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99225	storage_billing	\N	Storage billing: 32GB for 2026-05-20T06:30:00.000Z	2026-05-20 06:30:00.516	\N
b601b285-6b6c-437b-8f77-061364eb82f3	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	36000	847720	compute_billing	a580b232-5224-4c8e-b8b5-a1cf39642e0c	Compute charge - session launch (prepaid hour 1)	2026-05-20 06:31:20.434	\N
3d7e37ae-b52d-4ca3-a97d-e509bee96245	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	12000	835720	compute_billing	c5925ef4-d5dd-4551-9165-50ce29fac9ff	Compute charge - session launch (prepaid hour 1)	2026-05-20 06:32:15.529	\N
7d434a06-2148-462b-b751-a2f000efd99f	f9c9deed-f0c2-4261-b4b3-530b94fbf283	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	credit	250000	250000	payment	55235568-d14f-4bf0-ab1e-7881b86c8380	Credit recharge via Razorpay	2026-05-20 06:35:55.89	\N
62623c8b-8195-4da9-a86f-c602b9936688	f9c9deed-f0c2-4261-b4b3-530b94fbf283	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	debit	12000	238000	compute_billing	f644f81d-3b03-46c3-bfdb-d098923af02c	Compute charge - session launch (prepaid hour 1)	2026-05-20 06:36:21.214	\N
e1debadb-631e-4a5e-aab6-2f8a570fc879	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	180000	655720	compute_billing	46541468-ee50-4fab-bd02-4250162c40e6	Final compute charge: gpu-instance-06p0	2026-05-20 07:21:56.421	\N
b7d2dae0-6283-46d3-8ac0-37d5e793a3e3	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	634720	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Compute charge - session launch (prepaid hour 1)	2026-05-20 07:22:38.961	\N
00024efe-65d2-46ea-9929-36cc2a737aac	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99194	storage_billing	\N	Storage billing: 32GB for 2026-05-20T07:30:00.000Z	2026-05-20 07:30:00.585	\N
4968cea9-ab22-4f86-9cc2-48a0b865931a	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	634710	storage_billing	\N	Storage billing: 10GB for 2026-05-20T07:30:00.000Z	2026-05-20 07:30:00.703	\N
ed747fae-77fa-40b1-91a6-124e6943128c	f9c9deed-f0c2-4261-b4b3-530b94fbf283	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	debit	12000	226000	compute_billing	f644f81d-3b03-46c3-bfdb-d098923af02c	Prepaid compute - Hour 2: gpu-instance-840a	2026-05-20 07:30:01.371	\N
982f085d-1528-4f2b-a0c7-5581ec69b736	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	613710	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Prepaid compute - Hour 2: gpu-instance-dh0j	2026-05-20 07:30:01.461	\N
077e9b5e-60ee-4668-9a51-b1665e00b029	2c611ab8-caab-42c7-97f4-9b7e6306972b	f3a5cce9-059c-4828-ac18-61164c28e868	credit	100000	100000	payment	002c0ee1-7d59-4080-a8d9-abf6222a321b	Credit recharge via Razorpay	2026-05-20 07:49:19.088	\N
d5ae54f3-ab66-4cf7-9ace-2b6c75755a13	2c611ab8-caab-42c7-97f4-9b7e6306972b	f3a5cce9-059c-4828-ac18-61164c28e868	debit	36000	64000	compute_billing	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	Compute charge - session launch (prepaid hour 1)	2026-05-20 08:11:44.111	\N
e0df6974-137a-48b0-b97a-e04c0be7789e	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99163	storage_billing	\N	Storage billing: 32GB for 2026-05-20T08:30:00.000Z	2026-05-20 08:30:00.055	\N
5afbddb6-6575-40b9-8d5b-0614fe7b95d3	f9c9deed-f0c2-4261-b4b3-530b94fbf283	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	debit	12000	214000	compute_billing	f644f81d-3b03-46c3-bfdb-d098923af02c	Prepaid compute - Hour 3: gpu-instance-840a	2026-05-20 08:30:00.057	\N
37558755-0a23-4324-a98e-a0158ff6ea53	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	613700	storage_billing	\N	Storage billing: 10GB for 2026-05-20T08:30:00.000Z	2026-05-20 08:30:00.096	\N
ca2ed591-641e-4430-803b-714304f19aec	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	592710	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Prepaid compute - Hour 3: gpu-instance-dh0j	2026-05-20 08:30:00.099	\N
c402c484-6a97-4b36-ba2d-0d4f08fa1c92	2c611ab8-caab-42c7-97f4-9b7e6306972b	f3a5cce9-059c-4828-ac18-61164c28e868	debit	15	63985	storage_billing	\N	Storage billing: 16GB for 2026-05-20T08:30:00.000Z	2026-05-20 08:30:00.118	\N
ed3e3687-7fcf-482f-88ac-923adc7184ec	2c611ab8-caab-42c7-97f4-9b7e6306972b	f3a5cce9-059c-4828-ac18-61164c28e868	debit	36000	27985	compute_billing	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	Prepaid compute - Hour 2: gpu-instance-m41z	2026-05-20 08:30:00.134	\N
e95d6edc-e319-41a7-8b43-985324036365	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99132	storage_billing	\N	Storage billing: 32GB for 2026-05-20T09:30:00.000Z	2026-05-20 09:37:50.58	\N
971b7cfd-e040-4973-bfaf-887fb7fd0a59	f9c9deed-f0c2-4261-b4b3-530b94fbf283	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	debit	12000	202000	compute_billing	f644f81d-3b03-46c3-bfdb-d098923af02c	Prepaid compute - Hour 4: gpu-instance-840a	2026-05-20 09:37:50.967	\N
a450e359-8858-4179-9420-753aad8513d3	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	592700	storage_billing	\N	Storage billing: 10GB for 2026-05-20T09:30:00.000Z	2026-05-20 09:37:51.055	\N
17605d96-4a21-48c3-aeed-5f1063539323	2c611ab8-caab-42c7-97f4-9b7e6306972b	f3a5cce9-059c-4828-ac18-61164c28e868	debit	15	27970	storage_billing	\N	Storage billing: 16GB for 2026-05-20T09:30:00.000Z	2026-05-20 09:37:51.343	\N
9e5e37ab-e18b-4c66-b880-dba8e3a31b08	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	571700	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Prepaid compute - Hour 4: gpu-instance-dh0j	2026-05-20 09:37:51.446	\N
62797f84-b1e1-4335-a48f-b7b9cbfc1f11	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99101	storage_billing	\N	Storage billing: 32GB for 2026-05-20T10:30:00.000Z	2026-05-20 10:30:00.431	\N
03e8a5b0-023d-48d7-bc07-9bd35eca1349	f9c9deed-f0c2-4261-b4b3-530b94fbf283	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	debit	12000	190000	compute_billing	f644f81d-3b03-46c3-bfdb-d098923af02c	Prepaid compute - Hour 5: gpu-instance-840a	2026-05-20 10:30:00.45	\N
4b97d0ba-28db-474f-8e62-01debcc12e2b	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	550700	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Prepaid compute - Hour 5: gpu-instance-dh0j	2026-05-20 10:30:01.053	\N
522e2b1f-6e9c-4a40-a835-3a7780ef9138	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	571690	storage_billing	\N	Storage billing: 10GB for 2026-05-20T10:30:00.000Z	2026-05-20 10:30:01.13	\N
880259c1-8374-4da5-908e-451e6fe7dccf	2c611ab8-caab-42c7-97f4-9b7e6306972b	f3a5cce9-059c-4828-ac18-61164c28e868	debit	15	27955	storage_billing	\N	Storage billing: 16GB for 2026-05-20T10:30:00.000Z	2026-05-20 10:30:01.191	\N
d4cb4679-53e8-4c29-8977-ab645897d74e	f9c9deed-f0c2-4261-b4b3-530b94fbf283	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	debit	12000	178000	compute_billing	f644f81d-3b03-46c3-bfdb-d098923af02c	Prepaid compute - Hour 6: gpu-instance-840a	2026-05-20 11:30:00.207	\N
56139fb6-87fd-4e78-8610-a923d52c7bd8	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99070	storage_billing	\N	Storage billing: 32GB for 2026-05-20T11:30:00.000Z	2026-05-20 11:30:00.215	\N
04752121-e3c3-4e45-b54c-754cd94e1624	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	571680	storage_billing	\N	Storage billing: 10GB for 2026-05-20T11:30:00.000Z	2026-05-20 11:30:00.461	\N
877ff9ea-5ad9-4243-b447-6a7b71691559	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	550690	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Prepaid compute - Hour 6: gpu-instance-dh0j	2026-05-20 11:30:00.502	\N
a9a55099-0beb-4906-b430-c82223ff4928	2c611ab8-caab-42c7-97f4-9b7e6306972b	f3a5cce9-059c-4828-ac18-61164c28e868	debit	15	27940	storage_billing	\N	Storage billing: 16GB for 2026-05-20T11:30:00.000Z	2026-05-20 11:30:01.374	\N
f50ae7e0-1c64-4226-a74a-31b195c2257c	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99039	storage_billing	\N	Storage billing: 32GB for 2026-05-20T12:30:00.000Z	2026-05-20 12:30:00.245	\N
c0db2b0f-fde4-4c2c-8636-b0e31775559b	f9c9deed-f0c2-4261-b4b3-530b94fbf283	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	debit	12000	166000	compute_billing	f644f81d-3b03-46c3-bfdb-d098923af02c	Prepaid compute - Hour 7: gpu-instance-840a	2026-05-20 12:30:00.255	\N
622e3a1d-92f9-47d9-b199-c438ea261da0	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	571670	storage_billing	\N	Storage billing: 10GB for 2026-05-20T12:30:00.000Z	2026-05-20 12:30:00.329	\N
1ee913ba-884d-4615-a1ba-ad6833a3cf2b	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	550680	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Prepaid compute - Hour 7: gpu-instance-dh0j	2026-05-20 12:30:00.363	\N
6202dc46-9416-4c68-bf78-8cb21b3c8ba8	2c611ab8-caab-42c7-97f4-9b7e6306972b	f3a5cce9-059c-4828-ac18-61164c28e868	debit	15	27925	storage_billing	\N	Storage billing: 16GB for 2026-05-20T12:30:00.000Z	2026-05-20 12:30:00.384	\N
a822315c-b784-4d74-b801-3ce893f36ed3	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	99008	storage_billing	\N	Storage billing: 32GB for 2026-05-20T15:30:00.000Z	2026-05-20 15:59:03.446	\N
69c578e0-462a-43a8-b34f-3fb3e28da8bb	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	550670	storage_billing	\N	Storage billing: 10GB for 2026-05-20T15:30:00.000Z	2026-05-20 15:59:06.258	\N
023f4953-560f-4dfe-a1b9-f0110515d953	2c611ab8-caab-42c7-97f4-9b7e6306972b	f3a5cce9-059c-4828-ac18-61164c28e868	debit	15	27910	storage_billing	\N	Storage billing: 16GB for 2026-05-20T15:30:00.000Z	2026-05-20 15:59:07.396	\N
1f3dddfe-105a-49c6-ba44-62a86f15c954	f9c9deed-f0c2-4261-b4b3-530b94fbf283	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	debit	12000	154000	compute_billing	f644f81d-3b03-46c3-bfdb-d098923af02c	Prepaid compute - Hour 8: gpu-instance-840a	2026-05-20 17:01:15.72	\N
5430b60f-3ee7-4f97-9088-2e402b9446fb	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	98977	storage_billing	\N	Storage billing: 32GB for 2026-05-20T16:30:00.000Z	2026-05-20 17:01:15.722	\N
bed2cc25-7e79-40be-a8a2-315f1bd1c042	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	550660	storage_billing	\N	Storage billing: 10GB for 2026-05-20T16:30:00.000Z	2026-05-20 17:01:17.067	\N
8c26f092-7c58-4a72-b465-0088c2caf827	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	529660	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Prepaid compute - Hour 8: gpu-instance-dh0j	2026-05-20 17:01:19.034	\N
7f8b9c98-632d-4edf-a4e0-a1ecc7baf1df	2c611ab8-caab-42c7-97f4-9b7e6306972b	f3a5cce9-059c-4828-ac18-61164c28e868	debit	15	27895	storage_billing	\N	Storage billing: 16GB for 2026-05-20T16:30:00.000Z	2026-05-20 17:01:19.083	\N
586540e4-0e41-43e9-8f10-8082430ea743	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	98946	storage_billing	\N	Storage billing: 32GB for 2026-05-21T05:30:00.000Z	2026-05-21 05:30:00.044	\N
4db14869-5d0d-4f47-a315-7baf16f29b27	f9c9deed-f0c2-4261-b4b3-530b94fbf283	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	debit	12000	142000	compute_billing	f644f81d-3b03-46c3-bfdb-d098923af02c	Prepaid compute - Hour 9: gpu-instance-840a	2026-05-21 05:30:00.049	\N
e8fb6900-1705-498c-b2cf-bb11b34d8b28	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	508660	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Prepaid compute - Hour 9: gpu-instance-dh0j	2026-05-21 05:30:00.103	\N
cbed80e9-5bd9-46d1-b92d-64d83a4f4193	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	508650	storage_billing	\N	Storage billing: 10GB for 2026-05-21T05:30:00.000Z	2026-05-21 05:30:00.153	\N
6880afb6-58c2-4988-8183-0238d8c4234e	2c611ab8-caab-42c7-97f4-9b7e6306972b	f3a5cce9-059c-4828-ac18-61164c28e868	debit	15	27880	storage_billing	\N	Storage billing: 16GB for 2026-05-21T05:30:00.000Z	2026-05-21 05:30:00.172	\N
4d0b3df9-9546-4e54-adf8-e35b891f50e5	2c611ab8-caab-42c7-97f4-9b7e6306972b	f3a5cce9-059c-4828-ac18-61164c28e868	debit	720000	-692120	compute_billing	f5b1efc7-f4f8-4e0a-acfd-0594db1096da	Final compute charge: gpu-instance-m41z	2026-05-21 05:35:38.56	\N
6e5d0c84-84de-46fb-9c9e-1f909f86bad3	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	98915	storage_billing	\N	Storage billing: 32GB for 2026-05-21T06:30:00.000Z	2026-05-21 06:30:00.207	\N
3bc79173-38bf-48e9-a29a-aefd5398945d	f9c9deed-f0c2-4261-b4b3-530b94fbf283	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	debit	12000	130000	compute_billing	f644f81d-3b03-46c3-bfdb-d098923af02c	Prepaid compute - Hour 10: gpu-instance-840a	2026-05-21 06:30:00.23	\N
0bc0d2aa-5352-4836-9b7c-475ceec3966b	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	487650	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Prepaid compute - Hour 10: gpu-instance-dh0j	2026-05-21 06:30:00.378	\N
a320f464-3fc7-449c-91e2-f21ec9040216	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	487640	storage_billing	\N	Storage billing: 10GB for 2026-05-21T06:30:00.000Z	2026-05-21 06:30:00.538	\N
2d8e5d64-fe04-477b-832d-95fa58692ca5	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	98884	storage_billing	\N	Storage billing: 32GB for 2026-05-21T07:30:00.000Z	2026-05-21 07:30:00.162	\N
9e241248-6204-4959-b961-92315aa13b28	f9c9deed-f0c2-4261-b4b3-530b94fbf283	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	debit	12000	118000	compute_billing	f644f81d-3b03-46c3-bfdb-d098923af02c	Prepaid compute - Hour 11: gpu-instance-840a	2026-05-21 07:30:00.165	\N
0b48935f-112b-40f1-a8ec-d8d9239723a7	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	466640	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Prepaid compute - Hour 11: gpu-instance-dh0j	2026-05-21 07:30:00.203	\N
6562bc6b-ed12-4703-b30b-a34b0110e4ef	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	466630	storage_billing	\N	Storage billing: 10GB for 2026-05-21T07:30:00.000Z	2026-05-21 07:30:00.267	\N
9a7ef5fa-fde8-4651-a403-154f1b37fb87	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	98853	storage_billing	\N	Storage billing: 32GB for 2026-05-21T08:30:00.000Z	2026-05-21 09:13:01.855	\N
ca9bdb3c-b177-4ca1-bdf4-2045cd73cbc4	f9c9deed-f0c2-4261-b4b3-530b94fbf283	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	debit	12000	106000	compute_billing	f644f81d-3b03-46c3-bfdb-d098923af02c	Prepaid compute - Hour 12: gpu-instance-840a	2026-05-21 09:13:01.883	\N
e3a05c74-4d58-4df5-aaff-8184ce2978d5	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	466620	storage_billing	\N	Storage billing: 10GB for 2026-05-21T08:30:00.000Z	2026-05-21 09:13:02.205	\N
45283746-66ce-433b-942c-25e00831767f	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	445630	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Prepaid compute - Hour 12: gpu-instance-dh0j	2026-05-21 09:13:02.409	\N
86c5e136-e15d-4c18-9d9c-bbb10c6005bd	f9c9deed-f0c2-4261-b4b3-530b94fbf283	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	debit	12000	94000	compute_billing	f644f81d-3b03-46c3-bfdb-d098923af02c	Prepaid compute - Hour 13: gpu-instance-840a	2026-05-21 09:30:00.058	\N
dc0f52e1-4795-4e00-910b-1455271eb7bf	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	424630	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Prepaid compute - Hour 13: gpu-instance-dh0j	2026-05-21 09:30:00.107	\N
34946f4a-0bb6-4376-8d29-cd11e170fb83	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	98822	storage_billing	\N	Storage billing: 32GB for 2026-05-21T09:30:00.000Z	2026-05-21 09:30:00.167	\N
6d64a6be-433a-42ed-98fe-34e5b4fcb208	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	424620	storage_billing	\N	Storage billing: 10GB for 2026-05-21T09:30:00.000Z	2026-05-21 09:30:00.205	\N
fe5f9cfc-0b2a-412c-9872-3d3fd7c02481	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	98791	storage_billing	\N	Storage billing: 32GB for 2026-05-21T10:30:00.000Z	2026-05-21 10:30:00.115	\N
9d0eac2d-06de-4c9b-ba3e-659d8e7c079e	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	424610	storage_billing	\N	Storage billing: 10GB for 2026-05-21T10:30:00.000Z	2026-05-21 10:30:00.218	\N
81e26dbb-fa05-46d7-ad9b-9ad44bd38173	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	403610	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Prepaid compute - Hour 14: gpu-instance-dh0j	2026-05-21 10:30:00.348	\N
f75f6b8c-ec35-4efd-8720-dc71ad404cab	f9c9deed-f0c2-4261-b4b3-530b94fbf283	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	debit	180000	-86000	compute_billing	f644f81d-3b03-46c3-bfdb-d098923af02c	Final compute charge: gpu-instance-840a	2026-05-21 10:38:17.214	\N
97417055-7e31-4b70-bd88-733d5ad95404	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	98760	storage_billing	\N	Storage billing: 32GB for 2026-05-21T11:30:00.000Z	2026-05-21 11:30:00.218	\N
e35d4248-d355-4774-ae25-79bf0aeebb60	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	382610	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Prepaid compute - Hour 15: gpu-instance-dh0j	2026-05-21 11:30:00.229	\N
74f4ba10-282d-48c2-af92-400e0efbf5b2	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	403600	storage_billing	\N	Storage billing: 10GB for 2026-05-21T11:30:00.000Z	2026-05-21 11:30:00.258	\N
e8ac7ea7-7ad0-4ae4-b39f-9fffb06c8889	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	98729	storage_billing	\N	Storage billing: 32GB for 2026-05-21T12:30:00.000Z	2026-05-21 12:30:00.093	\N
c95bc970-3cbe-46eb-b0df-b5ee11b63490	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	382600	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Prepaid compute - Hour 16: gpu-instance-dh0j	2026-05-21 12:30:00.122	\N
816a192e-27da-4294-b9fc-4b596fe13a30	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	403590	storage_billing	\N	Storage billing: 10GB for 2026-05-21T12:30:00.000Z	2026-05-21 12:30:00.167	\N
2c071099-2166-47b9-944d-59ca5b2116ec	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	382590	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Prepaid compute - Hour 17: gpu-instance-dh0j	2026-05-21 13:40:29.302	\N
7b916ab7-a6be-457a-9db9-fc857505f3c5	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	98698	storage_billing	\N	Storage billing: 32GB for 2026-05-21T13:30:00.000Z	2026-05-21 13:40:29.301	\N
fa8806a1-be8e-4f93-969f-924b0c36611d	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	382580	storage_billing	\N	Storage billing: 10GB for 2026-05-21T13:30:00.000Z	2026-05-21 13:40:29.568	\N
815018bc-fb07-40ff-b75d-073faddb0fcd	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	21000	361580	compute_billing	2f072a36-9650-4bbc-bb3d-eb54eecf2a6a	Prepaid compute - Hour 18: gpu-instance-dh0j	2026-05-21 14:30:00.115	\N
17709b84-ee6f-4a2d-862e-03d3117e4637	a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	debit	31	98667	storage_billing	\N	Storage billing: 32GB for 2026-05-21T14:30:00.000Z	2026-05-21 14:30:00.196	\N
4b675530-cb28-4d8c-854b-b8e410f722de	59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	debit	10	361570	storage_billing	\N	Storage billing: 10GB for 2026-05-21T14:30:00.000Z	2026-05-21 14:30:00.223	\N
\.


--
-- TOC entry 6075 (class 0 OID 152349)
-- Dependencies: 293
-- Data for Name: wallets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wallets (id, user_id, balance_cents, currency, lifetime_credits_cents, lifetime_spent_cents, low_balance_threshold_cents, is_frozen, created_at, updated_at, created_by, updated_by, spend_limit_cents, spend_limit_enabled, spend_limit_period, spend_limit_consented_at, spend_limit_end_date, spend_limit_start_date, spend_limit_warning_85_sent, runway_warning_1hour_sent) FROM stdin;
2c611ab8-caab-42c7-97f4-9b7e6306972b	f3a5cce9-059c-4828-ac18-61164c28e868	-692120	INR	100000	792120	10000	f	2026-05-20 07:49:19.078	2026-05-21 05:35:38.564	\N	\N	\N	f	\N	\N	\N	\N	f	t
f9c9deed-f0c2-4261-b4b3-530b94fbf283	75c1fbf0-8ae8-4aed-b14f-429b8c830ced	-86000	INR	250000	336000	10000	f	2026-05-20 06:35:55.884	2026-05-21 10:50:03.295	\N	\N	\N	f	\N	\N	\N	\N	f	f
0fb8db1c-b75a-4ff4-a52f-31c011966569	fb9e2b49-d504-4495-a0ca-40b75cfcaafc	0	INR	0	0	10000	f	2026-05-21 11:38:08.092	2026-05-21 11:38:08.092	\N	\N	\N	f	\N	\N	\N	\N	f	f
a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	98667	INR	100000	1333	10000	f	2026-05-18 11:00:35.649	2026-05-21 14:30:00.204	\N	\N	\N	f	\N	\N	\N	\N	f	f
59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	361570	INR	2000000	1986520	10000	f	2026-05-18 06:48:37.655	2026-05-21 14:30:00.229	\N	\N	\N	f	\N	\N	\N	\N	f	f
\.


--
-- TOC entry 5407 (class 2606 OID 152378)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 5409 (class 2606 OID 152380)
-- Name: achievements achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- TOC entry 5413 (class 2606 OID 152382)
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- TOC entry 5420 (class 2606 OID 152384)
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- TOC entry 5424 (class 2606 OID 152386)
-- Name: base_images base_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_images
    ADD CONSTRAINT base_images_pkey PRIMARY KEY (id);


--
-- TOC entry 5427 (class 2606 OID 152388)
-- Name: billing_charges billing_charges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_pkey PRIMARY KEY (id);


--
-- TOC entry 5433 (class 2606 OID 152390)
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- TOC entry 5438 (class 2606 OID 152392)
-- Name: compute_config_access compute_config_access_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_config_access
    ADD CONSTRAINT compute_config_access_pkey PRIMARY KEY (id);


--
-- TOC entry 5442 (class 2606 OID 152394)
-- Name: compute_configs compute_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_configs
    ADD CONSTRAINT compute_configs_pkey PRIMARY KEY (id);


--
-- TOC entry 5449 (class 2606 OID 152396)
-- Name: course_enrollments course_enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_pkey PRIMARY KEY (id);


--
-- TOC entry 5454 (class 2606 OID 152398)
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- TOC entry 5459 (class 2606 OID 152400)
-- Name: coursework_content coursework_content_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coursework_content
    ADD CONSTRAINT coursework_content_pkey PRIMARY KEY (id);


--
-- TOC entry 5462 (class 2606 OID 152402)
-- Name: credit_packages credit_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_packages
    ADD CONSTRAINT credit_packages_pkey PRIMARY KEY (id);


--
-- TOC entry 5466 (class 2606 OID 152404)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- TOC entry 5472 (class 2606 OID 152406)
-- Name: discussion_replies discussion_replies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_pkey PRIMARY KEY (id);


--
-- TOC entry 5477 (class 2606 OID 152408)
-- Name: discussions discussions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_pkey PRIMARY KEY (id);


--
-- TOC entry 5480 (class 2606 OID 152410)
-- Name: feature_flags feature_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_flags
    ADD CONSTRAINT feature_flags_pkey PRIMARY KEY (id);


--
-- TOC entry 5482 (class 2606 OID 152412)
-- Name: invoice_line_items invoice_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_line_items
    ADD CONSTRAINT invoice_line_items_pkey PRIMARY KEY (id);


--
-- TOC entry 5485 (class 2606 OID 152414)
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- TOC entry 5490 (class 2606 OID 152416)
-- Name: lab_assignments lab_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_assignments
    ADD CONSTRAINT lab_assignments_pkey PRIMARY KEY (id);


--
-- TOC entry 5492 (class 2606 OID 152418)
-- Name: lab_grades lab_grades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_grades
    ADD CONSTRAINT lab_grades_pkey PRIMARY KEY (id);


--
-- TOC entry 5496 (class 2606 OID 152420)
-- Name: lab_group_assignments lab_group_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_group_assignments
    ADD CONSTRAINT lab_group_assignments_pkey PRIMARY KEY (id);


--
-- TOC entry 5499 (class 2606 OID 152422)
-- Name: lab_submissions lab_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_submissions
    ADD CONSTRAINT lab_submissions_pkey PRIMARY KEY (id);


--
-- TOC entry 5505 (class 2606 OID 152424)
-- Name: labs labs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_pkey PRIMARY KEY (id);


--
-- TOC entry 5507 (class 2606 OID 152426)
-- Name: login_history login_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_pkey PRIMARY KEY (id);


--
-- TOC entry 5509 (class 2606 OID 152428)
-- Name: mentor_availability_slots mentor_availability_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_availability_slots
    ADD CONSTRAINT mentor_availability_slots_pkey PRIMARY KEY (id);


--
-- TOC entry 5512 (class 2606 OID 152430)
-- Name: mentor_bookings mentor_bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_bookings
    ADD CONSTRAINT mentor_bookings_pkey PRIMARY KEY (id);


--
-- TOC entry 5515 (class 2606 OID 152432)
-- Name: mentor_profiles mentor_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_profiles
    ADD CONSTRAINT mentor_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 5519 (class 2606 OID 152434)
-- Name: mentor_reviews mentor_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_reviews
    ADD CONSTRAINT mentor_reviews_pkey PRIMARY KEY (id);


--
-- TOC entry 5521 (class 2606 OID 152436)
-- Name: node_base_images node_base_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_base_images
    ADD CONSTRAINT node_base_images_pkey PRIMARY KEY (node_id, base_image_id);


--
-- TOC entry 5526 (class 2606 OID 152438)
-- Name: node_resource_reservations node_resource_reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_resource_reservations
    ADD CONSTRAINT node_resource_reservations_pkey PRIMARY KEY (id);


--
-- TOC entry 5534 (class 2606 OID 152440)
-- Name: nodes nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nodes
    ADD CONSTRAINT nodes_pkey PRIMARY KEY (id);


--
-- TOC entry 5537 (class 2606 OID 152442)
-- Name: notification_templates notification_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_templates
    ADD CONSTRAINT notification_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 5540 (class 2606 OID 152444)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 5544 (class 2606 OID 152446)
-- Name: org_contracts org_contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_contracts
    ADD CONSTRAINT org_contracts_pkey PRIMARY KEY (id);


--
-- TOC entry 5548 (class 2606 OID 152448)
-- Name: org_resource_quotas org_resource_quotas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_resource_quotas
    ADD CONSTRAINT org_resource_quotas_pkey PRIMARY KEY (id);


--
-- TOC entry 5550 (class 2606 OID 152450)
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- TOC entry 5554 (class 2606 OID 152452)
-- Name: os_switch_history os_switch_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_switch_history
    ADD CONSTRAINT os_switch_history_pkey PRIMARY KEY (id);


--
-- TOC entry 5557 (class 2606 OID 152454)
-- Name: otp_verifications otp_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_verifications
    ADD CONSTRAINT otp_verifications_pkey PRIMARY KEY (id);


--
-- TOC entry 5560 (class 2606 OID 152456)
-- Name: payment_transactions payment_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 5565 (class 2606 OID 152458)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 5568 (class 2606 OID 152460)
-- Name: project_showcases project_showcases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_showcases
    ADD CONSTRAINT project_showcases_pkey PRIMARY KEY (id);


--
-- TOC entry 5572 (class 2606 OID 152462)
-- Name: recommendation_sessions recommendation_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recommendation_sessions
    ADD CONSTRAINT recommendation_sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 5575 (class 2606 OID 152464)
-- Name: referral_conversions referral_conversions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_conversions
    ADD CONSTRAINT referral_conversions_pkey PRIMARY KEY (id);


--
-- TOC entry 5582 (class 2606 OID 152466)
-- Name: referral_events referral_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_events
    ADD CONSTRAINT referral_events_pkey PRIMARY KEY (id);


--
-- TOC entry 5585 (class 2606 OID 152468)
-- Name: referrals referrals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_pkey PRIMARY KEY (id);


--
-- TOC entry 5591 (class 2606 OID 152470)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 5593 (class 2606 OID 152472)
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- TOC entry 5596 (class 2606 OID 152474)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 5599 (class 2606 OID 152476)
-- Name: session_events session_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_events
    ADD CONSTRAINT session_events_pkey PRIMARY KEY (id);


--
-- TOC entry 5606 (class 2606 OID 152478)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 5613 (class 2606 OID 152480)
-- Name: storage_extensions storage_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_pkey PRIMARY KEY (id);


--
-- TOC entry 5617 (class 2606 OID 152482)
-- Name: subscription_plans subscription_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_plans
    ADD CONSTRAINT subscription_plans_pkey PRIMARY KEY (id);


--
-- TOC entry 5622 (class 2606 OID 152484)
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- TOC entry 5709 (class 2606 OID 163211)
-- Name: support_ticket_attachments support_ticket_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_ticket_attachments
    ADD CONSTRAINT support_ticket_attachments_pkey PRIMARY KEY (id);


--
-- TOC entry 5627 (class 2606 OID 152486)
-- Name: support_tickets support_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_pkey PRIMARY KEY (id);


--
-- TOC entry 5631 (class 2606 OID 152488)
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 5633 (class 2606 OID 152490)
-- Name: ticket_messages ticket_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_messages
    ADD CONSTRAINT ticket_messages_pkey PRIMARY KEY (id);


--
-- TOC entry 5636 (class 2606 OID 152492)
-- Name: universities universities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.universities
    ADD CONSTRAINT universities_pkey PRIMARY KEY (id);


--
-- TOC entry 5639 (class 2606 OID 152494)
-- Name: university_idp_configs university_idp_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.university_idp_configs
    ADD CONSTRAINT university_idp_configs_pkey PRIMARY KEY (id);


--
-- TOC entry 5642 (class 2606 OID 152496)
-- Name: user_achievements user_achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_pkey PRIMARY KEY (id);


--
-- TOC entry 5645 (class 2606 OID 152498)
-- Name: user_deletion_requests user_deletion_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_deletion_requests
    ADD CONSTRAINT user_deletion_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 5651 (class 2606 OID 152500)
-- Name: user_departments user_departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_departments
    ADD CONSTRAINT user_departments_pkey PRIMARY KEY (id);


--
-- TOC entry 5655 (class 2606 OID 152502)
-- Name: user_feedback user_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_pkey PRIMARY KEY (id);


--
-- TOC entry 5659 (class 2606 OID 152504)
-- Name: user_files user_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_files
    ADD CONSTRAINT user_files_pkey PRIMARY KEY (id);


--
-- TOC entry 5663 (class 2606 OID 152506)
-- Name: user_group_members user_group_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_members
    ADD CONSTRAINT user_group_members_pkey PRIMARY KEY (id);


--
-- TOC entry 5671 (class 2606 OID 152508)
-- Name: user_groups user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 5673 (class 2606 OID 152510)
-- Name: user_org_roles user_org_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_org_roles
    ADD CONSTRAINT user_org_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 5676 (class 2606 OID 152512)
-- Name: user_policy_consents user_policy_consents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_policy_consents
    ADD CONSTRAINT user_policy_consents_pkey PRIMARY KEY (id);


--
-- TOC entry 5678 (class 2606 OID 152514)
-- Name: user_profiles user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 5683 (class 2606 OID 152516)
-- Name: user_storage_volumes user_storage_volumes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_storage_volumes
    ADD CONSTRAINT user_storage_volumes_pkey PRIMARY KEY (id);


--
-- TOC entry 5689 (class 2606 OID 152518)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 5694 (class 2606 OID 152520)
-- Name: waitlist_entries waitlist_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waitlist_entries
    ADD CONSTRAINT waitlist_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 5698 (class 2606 OID 152522)
-- Name: wallet_holds wallet_holds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_pkey PRIMARY KEY (id);


--
-- TOC entry 5701 (class 2606 OID 152524)
-- Name: wallet_transactions wallet_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_transactions
    ADD CONSTRAINT wallet_transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 5706 (class 2606 OID 152526)
-- Name: wallets wallets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT wallets_pkey PRIMARY KEY (id);


--
-- TOC entry 5410 (class 1259 OID 152527)
-- Name: achievements_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX achievements_slug_key ON public.achievements USING btree (slug);


--
-- TOC entry 5411 (class 1259 OID 152528)
-- Name: announcements_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX announcements_organization_id_idx ON public.announcements USING btree (organization_id);


--
-- TOC entry 5414 (class 1259 OID 152529)
-- Name: announcements_published_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX announcements_published_at_idx ON public.announcements USING btree (published_at);


--
-- TOC entry 5415 (class 1259 OID 152530)
-- Name: audit_log_action_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_action_idx ON public.audit_log USING btree (action);


--
-- TOC entry 5416 (class 1259 OID 152531)
-- Name: audit_log_actor_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_actor_id_idx ON public.audit_log USING btree (actor_id);


--
-- TOC entry 5417 (class 1259 OID 152532)
-- Name: audit_log_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_created_at_idx ON public.audit_log USING btree (created_at);


--
-- TOC entry 5418 (class 1259 OID 152533)
-- Name: audit_log_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_org_id_idx ON public.audit_log USING btree (org_id);


--
-- TOC entry 5421 (class 1259 OID 152534)
-- Name: audit_log_resource_type_resource_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_resource_type_resource_id_idx ON public.audit_log USING btree (resource_type, resource_id);


--
-- TOC entry 5422 (class 1259 OID 152535)
-- Name: base_images_is_default_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX base_images_is_default_idx ON public.base_images USING btree (is_default);


--
-- TOC entry 5425 (class 1259 OID 152536)
-- Name: base_images_tag_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX base_images_tag_key ON public.base_images USING btree (tag);


--
-- TOC entry 5428 (class 1259 OID 152537)
-- Name: billing_charges_session_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX billing_charges_session_id_idx ON public.billing_charges USING btree (session_id);


--
-- TOC entry 5429 (class 1259 OID 152538)
-- Name: billing_charges_storage_volume_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX billing_charges_storage_volume_id_idx ON public.billing_charges USING btree (storage_volume_id);


--
-- TOC entry 5430 (class 1259 OID 152539)
-- Name: billing_charges_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX billing_charges_user_id_created_at_idx ON public.billing_charges USING btree (user_id, created_at);


--
-- TOC entry 5431 (class 1259 OID 152540)
-- Name: bookings_node_id_scheduled_start_at_scheduled_end_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bookings_node_id_scheduled_start_at_scheduled_end_at_idx ON public.bookings USING btree (node_id, scheduled_start_at, scheduled_end_at);


--
-- TOC entry 5434 (class 1259 OID 152541)
-- Name: bookings_user_id_status_scheduled_start_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bookings_user_id_status_scheduled_start_at_idx ON public.bookings USING btree (user_id, status, scheduled_start_at);


--
-- TOC entry 5435 (class 1259 OID 152542)
-- Name: compute_config_access_compute_config_id_organization_id_rol_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX compute_config_access_compute_config_id_organization_id_rol_key ON public.compute_config_access USING btree (compute_config_id, organization_id, role_id);


--
-- TOC entry 5436 (class 1259 OID 152543)
-- Name: compute_config_access_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_config_access_organization_id_idx ON public.compute_config_access USING btree (organization_id);


--
-- TOC entry 5439 (class 1259 OID 152544)
-- Name: compute_config_access_role_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_config_access_role_id_idx ON public.compute_config_access USING btree (role_id);


--
-- TOC entry 5440 (class 1259 OID 152545)
-- Name: compute_configs_is_active_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_configs_is_active_idx ON public.compute_configs USING btree (is_active);


--
-- TOC entry 5443 (class 1259 OID 152546)
-- Name: compute_configs_session_type_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_configs_session_type_idx ON public.compute_configs USING btree (session_type);


--
-- TOC entry 5444 (class 1259 OID 152547)
-- Name: compute_configs_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX compute_configs_slug_key ON public.compute_configs USING btree (slug);


--
-- TOC entry 5445 (class 1259 OID 152548)
-- Name: compute_configs_sort_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_configs_sort_order_idx ON public.compute_configs USING btree (sort_order);


--
-- TOC entry 5446 (class 1259 OID 152549)
-- Name: course_enrollments_course_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX course_enrollments_course_id_idx ON public.course_enrollments USING btree (course_id);


--
-- TOC entry 5447 (class 1259 OID 152550)
-- Name: course_enrollments_course_id_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX course_enrollments_course_id_user_id_key ON public.course_enrollments USING btree (course_id, user_id);


--
-- TOC entry 5450 (class 1259 OID 152551)
-- Name: course_enrollments_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX course_enrollments_user_id_idx ON public.course_enrollments USING btree (user_id);


--
-- TOC entry 5451 (class 1259 OID 152552)
-- Name: courses_instructor_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX courses_instructor_id_idx ON public.courses USING btree (instructor_id);


--
-- TOC entry 5452 (class 1259 OID 152553)
-- Name: courses_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX courses_organization_id_idx ON public.courses USING btree (organization_id);


--
-- TOC entry 5455 (class 1259 OID 152554)
-- Name: courses_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX courses_status_idx ON public.courses USING btree (status);


--
-- TOC entry 5456 (class 1259 OID 152555)
-- Name: coursework_content_category_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX coursework_content_category_idx ON public.coursework_content USING btree (category);


--
-- TOC entry 5457 (class 1259 OID 152556)
-- Name: coursework_content_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX coursework_content_organization_id_idx ON public.coursework_content USING btree (organization_id);


--
-- TOC entry 5460 (class 1259 OID 152557)
-- Name: credit_packages_is_active_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX credit_packages_is_active_idx ON public.credit_packages USING btree (is_active);


--
-- TOC entry 5463 (class 1259 OID 152558)
-- Name: credit_packages_sort_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX credit_packages_sort_order_idx ON public.credit_packages USING btree (sort_order);


--
-- TOC entry 5464 (class 1259 OID 152559)
-- Name: departments_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX departments_parent_id_idx ON public.departments USING btree (parent_id);


--
-- TOC entry 5467 (class 1259 OID 152560)
-- Name: departments_university_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX departments_university_id_idx ON public.departments USING btree (university_id);


--
-- TOC entry 5468 (class 1259 OID 152561)
-- Name: departments_university_id_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX departments_university_id_slug_key ON public.departments USING btree (university_id, slug);


--
-- TOC entry 5469 (class 1259 OID 152562)
-- Name: discussion_replies_author_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussion_replies_author_id_idx ON public.discussion_replies USING btree (author_id);


--
-- TOC entry 5470 (class 1259 OID 152563)
-- Name: discussion_replies_discussion_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussion_replies_discussion_id_idx ON public.discussion_replies USING btree (discussion_id);


--
-- TOC entry 5473 (class 1259 OID 152564)
-- Name: discussions_author_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussions_author_id_idx ON public.discussions USING btree (author_id);


--
-- TOC entry 5474 (class 1259 OID 152565)
-- Name: discussions_course_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussions_course_id_idx ON public.discussions USING btree (course_id);


--
-- TOC entry 5475 (class 1259 OID 152566)
-- Name: discussions_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussions_organization_id_idx ON public.discussions USING btree (organization_id);


--
-- TOC entry 5478 (class 1259 OID 152567)
-- Name: feature_flags_key_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX feature_flags_key_key ON public.feature_flags USING btree (key);


--
-- TOC entry 5483 (class 1259 OID 152568)
-- Name: invoices_invoice_number_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX invoices_invoice_number_key ON public.invoices USING btree (invoice_number);


--
-- TOC entry 5486 (class 1259 OID 152569)
-- Name: invoices_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX invoices_status_idx ON public.invoices USING btree (status);


--
-- TOC entry 5487 (class 1259 OID 152570)
-- Name: invoices_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX invoices_user_id_created_at_idx ON public.invoices USING btree (user_id, created_at);


--
-- TOC entry 5488 (class 1259 OID 152571)
-- Name: lab_assignments_lab_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lab_assignments_lab_id_idx ON public.lab_assignments USING btree (lab_id);


--
-- TOC entry 5493 (class 1259 OID 152572)
-- Name: lab_grades_submission_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX lab_grades_submission_id_key ON public.lab_grades USING btree (submission_id);


--
-- TOC entry 5494 (class 1259 OID 152573)
-- Name: lab_group_assignments_lab_id_user_group_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX lab_group_assignments_lab_id_user_group_id_key ON public.lab_group_assignments USING btree (lab_id, user_group_id);


--
-- TOC entry 5497 (class 1259 OID 152574)
-- Name: lab_submissions_lab_assignment_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lab_submissions_lab_assignment_id_idx ON public.lab_submissions USING btree (lab_assignment_id);


--
-- TOC entry 5500 (class 1259 OID 152575)
-- Name: lab_submissions_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lab_submissions_user_id_idx ON public.lab_submissions USING btree (user_id);


--
-- TOC entry 5501 (class 1259 OID 152576)
-- Name: labs_course_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX labs_course_id_idx ON public.labs USING btree (course_id);


--
-- TOC entry 5502 (class 1259 OID 152577)
-- Name: labs_created_by_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX labs_created_by_user_id_idx ON public.labs USING btree (created_by_user_id);


--
-- TOC entry 5503 (class 1259 OID 152578)
-- Name: labs_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX labs_organization_id_idx ON public.labs USING btree (organization_id);


--
-- TOC entry 5510 (class 1259 OID 152579)
-- Name: mentor_bookings_mentor_profile_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_bookings_mentor_profile_id_idx ON public.mentor_bookings USING btree (mentor_profile_id);


--
-- TOC entry 5513 (class 1259 OID 152580)
-- Name: mentor_bookings_student_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_bookings_student_user_id_idx ON public.mentor_bookings USING btree (student_user_id);


--
-- TOC entry 5516 (class 1259 OID 152581)
-- Name: mentor_profiles_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX mentor_profiles_user_id_key ON public.mentor_profiles USING btree (user_id);


--
-- TOC entry 5517 (class 1259 OID 152582)
-- Name: mentor_reviews_mentor_booking_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX mentor_reviews_mentor_booking_id_key ON public.mentor_reviews USING btree (mentor_booking_id);


--
-- TOC entry 5522 (class 1259 OID 152583)
-- Name: node_base_images_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX node_base_images_status_idx ON public.node_base_images USING btree (status);


--
-- TOC entry 5523 (class 1259 OID 152584)
-- Name: node_resource_reservations_node_id_session_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX node_resource_reservations_node_id_session_id_key ON public.node_resource_reservations USING btree (node_id, session_id);


--
-- TOC entry 5524 (class 1259 OID 152585)
-- Name: node_resource_reservations_node_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX node_resource_reservations_node_id_status_idx ON public.node_resource_reservations USING btree (node_id, status);


--
-- TOC entry 5527 (class 1259 OID 152586)
-- Name: node_resource_reservations_released_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX node_resource_reservations_released_at_idx ON public.node_resource_reservations USING btree (released_at);


--
-- TOC entry 5528 (class 1259 OID 152587)
-- Name: node_resource_reservations_session_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX node_resource_reservations_session_id_idx ON public.node_resource_reservations USING btree (session_id);


--
-- TOC entry 5529 (class 1259 OID 152588)
-- Name: node_resource_reservations_session_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX node_resource_reservations_session_id_key ON public.node_resource_reservations USING btree (session_id);


--
-- TOC entry 5530 (class 1259 OID 152589)
-- Name: nodes_hostname_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX nodes_hostname_key ON public.nodes USING btree (hostname);


--
-- TOC entry 5531 (class 1259 OID 152590)
-- Name: nodes_last_heartbeat_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nodes_last_heartbeat_at_idx ON public.nodes USING btree (last_heartbeat_at);


--
-- TOC entry 5532 (class 1259 OID 152591)
-- Name: nodes_last_resource_sync_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nodes_last_resource_sync_at_idx ON public.nodes USING btree (last_resource_sync_at);


--
-- TOC entry 5535 (class 1259 OID 152592)
-- Name: nodes_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nodes_status_idx ON public.nodes USING btree (status);


--
-- TOC entry 5538 (class 1259 OID 152593)
-- Name: notification_templates_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX notification_templates_slug_key ON public.notification_templates USING btree (slug);


--
-- TOC entry 5541 (class 1259 OID 152594)
-- Name: notifications_user_id_status_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notifications_user_id_status_created_at_idx ON public.notifications USING btree (user_id, status, created_at);


--
-- TOC entry 5542 (class 1259 OID 152595)
-- Name: org_contracts_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX org_contracts_organization_id_idx ON public.org_contracts USING btree (organization_id);


--
-- TOC entry 5545 (class 1259 OID 152596)
-- Name: org_contracts_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX org_contracts_status_idx ON public.org_contracts USING btree (status);


--
-- TOC entry 5546 (class 1259 OID 152597)
-- Name: org_resource_quotas_organization_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX org_resource_quotas_organization_id_key ON public.org_resource_quotas USING btree (organization_id);


--
-- TOC entry 5551 (class 1259 OID 152598)
-- Name: organizations_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX organizations_slug_key ON public.organizations USING btree (slug);


--
-- TOC entry 5552 (class 1259 OID 152599)
-- Name: os_switch_history_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX os_switch_history_created_at_idx ON public.os_switch_history USING btree (created_at);


--
-- TOC entry 5555 (class 1259 OID 152600)
-- Name: os_switch_history_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX os_switch_history_user_id_idx ON public.os_switch_history USING btree (user_id);


--
-- TOC entry 5558 (class 1259 OID 152601)
-- Name: payment_transactions_gateway_txn_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX payment_transactions_gateway_txn_id_key ON public.payment_transactions USING btree (gateway_txn_id);


--
-- TOC entry 5561 (class 1259 OID 152602)
-- Name: payment_transactions_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_transactions_status_idx ON public.payment_transactions USING btree (status);


--
-- TOC entry 5562 (class 1259 OID 152603)
-- Name: payment_transactions_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_transactions_user_id_created_at_idx ON public.payment_transactions USING btree (user_id, created_at);


--
-- TOC entry 5563 (class 1259 OID 152604)
-- Name: permissions_code_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX permissions_code_key ON public.permissions USING btree (code);


--
-- TOC entry 5566 (class 1259 OID 152605)
-- Name: project_showcases_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX project_showcases_organization_id_idx ON public.project_showcases USING btree (organization_id);


--
-- TOC entry 5569 (class 1259 OID 152606)
-- Name: project_showcases_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX project_showcases_user_id_idx ON public.project_showcases USING btree (user_id);


--
-- TOC entry 5570 (class 1259 OID 152607)
-- Name: recommendation_sessions_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recommendation_sessions_created_at_idx ON public.recommendation_sessions USING btree (created_at);


--
-- TOC entry 5573 (class 1259 OID 152608)
-- Name: recommendation_sessions_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recommendation_sessions_user_id_idx ON public.recommendation_sessions USING btree (user_id);


--
-- TOC entry 5576 (class 1259 OID 152609)
-- Name: referral_conversions_referral_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_conversions_referral_id_status_idx ON public.referral_conversions USING btree (referral_id, status);


--
-- TOC entry 5577 (class 1259 OID 152610)
-- Name: referral_conversions_referred_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX referral_conversions_referred_user_id_key ON public.referral_conversions USING btree (referred_user_id);


--
-- TOC entry 5578 (class 1259 OID 152611)
-- Name: referral_conversions_referrer_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_conversions_referrer_user_id_idx ON public.referral_conversions USING btree (referrer_user_id);


--
-- TOC entry 5579 (class 1259 OID 152612)
-- Name: referral_conversions_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_conversions_status_idx ON public.referral_conversions USING btree (status);


--
-- TOC entry 5580 (class 1259 OID 152613)
-- Name: referral_events_event_type_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_events_event_type_idx ON public.referral_events USING btree (event_type);


--
-- TOC entry 5583 (class 1259 OID 152614)
-- Name: referral_events_referral_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_events_referral_id_created_at_idx ON public.referral_events USING btree (referral_id, created_at);


--
-- TOC entry 5586 (class 1259 OID 152615)
-- Name: referrals_referral_code_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referrals_referral_code_idx ON public.referrals USING btree (referral_code);


--
-- TOC entry 5587 (class 1259 OID 152616)
-- Name: referrals_referral_code_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX referrals_referral_code_key ON public.referrals USING btree (referral_code);


--
-- TOC entry 5588 (class 1259 OID 152617)
-- Name: referrals_referrer_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referrals_referrer_user_id_idx ON public.referrals USING btree (referrer_user_id);


--
-- TOC entry 5589 (class 1259 OID 152618)
-- Name: referrals_referrer_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX referrals_referrer_user_id_key ON public.referrals USING btree (referrer_user_id);


--
-- TOC entry 5594 (class 1259 OID 152619)
-- Name: roles_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX roles_name_key ON public.roles USING btree (name);


--
-- TOC entry 5597 (class 1259 OID 152620)
-- Name: session_events_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX session_events_created_at_idx ON public.session_events USING btree (created_at);


--
-- TOC entry 5600 (class 1259 OID 152621)
-- Name: session_events_session_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX session_events_session_id_idx ON public.session_events USING btree (session_id);


--
-- TOC entry 5601 (class 1259 OID 152622)
-- Name: sessions_booking_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX sessions_booking_id_key ON public.sessions USING btree (booking_id);


--
-- TOC entry 5602 (class 1259 OID 152623)
-- Name: sessions_compute_config_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_compute_config_id_idx ON public.sessions USING btree (compute_config_id);


--
-- TOC entry 5603 (class 1259 OID 152624)
-- Name: sessions_instance_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_instance_name_idx ON public.sessions USING btree (instance_name);


--
-- TOC entry 5604 (class 1259 OID 152625)
-- Name: sessions_node_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_node_id_status_idx ON public.sessions USING btree (node_id, status);


--
-- TOC entry 5607 (class 1259 OID 152626)
-- Name: sessions_started_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_started_at_idx ON public.sessions USING btree (started_at);


--
-- TOC entry 5608 (class 1259 OID 152627)
-- Name: sessions_storage_mode_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_storage_mode_idx ON public.sessions USING btree (storage_mode);


--
-- TOC entry 5609 (class 1259 OID 152628)
-- Name: sessions_storage_node_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_storage_node_id_idx ON public.sessions USING btree (storage_node_id);


--
-- TOC entry 5610 (class 1259 OID 152629)
-- Name: sessions_user_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_user_id_status_idx ON public.sessions USING btree (user_id, status);


--
-- TOC entry 5611 (class 1259 OID 152630)
-- Name: storage_extensions_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX storage_extensions_created_at_idx ON public.storage_extensions USING btree (created_at);


--
-- TOC entry 5614 (class 1259 OID 152631)
-- Name: storage_extensions_storage_volume_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX storage_extensions_storage_volume_id_idx ON public.storage_extensions USING btree (storage_volume_id);


--
-- TOC entry 5615 (class 1259 OID 152632)
-- Name: storage_extensions_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX storage_extensions_user_id_idx ON public.storage_extensions USING btree (user_id);


--
-- TOC entry 5618 (class 1259 OID 152633)
-- Name: subscription_plans_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX subscription_plans_slug_key ON public.subscription_plans USING btree (slug);


--
-- TOC entry 5619 (class 1259 OID 152634)
-- Name: subscription_plans_sort_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subscription_plans_sort_order_idx ON public.subscription_plans USING btree (sort_order);


--
-- TOC entry 5620 (class 1259 OID 152635)
-- Name: subscriptions_ends_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subscriptions_ends_at_idx ON public.subscriptions USING btree (ends_at);


--
-- TOC entry 5623 (class 1259 OID 152636)
-- Name: subscriptions_user_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subscriptions_user_id_status_idx ON public.subscriptions USING btree (user_id, status);


--
-- TOC entry 5710 (class 1259 OID 163212)
-- Name: support_ticket_attachments_ticketId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "support_ticket_attachments_ticketId_idx" ON public.support_ticket_attachments USING btree ("ticketId");


--
-- TOC entry 5624 (class 1259 OID 152637)
-- Name: support_tickets_assigned_to_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX support_tickets_assigned_to_status_idx ON public.support_tickets USING btree (assigned_to, status);


--
-- TOC entry 5625 (class 1259 OID 152638)
-- Name: support_tickets_organization_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX support_tickets_organization_id_status_idx ON public.support_tickets USING btree (organization_id, status);


--
-- TOC entry 5628 (class 1259 OID 152639)
-- Name: support_tickets_user_id_status_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX support_tickets_user_id_status_created_at_idx ON public.support_tickets USING btree (user_id, status, created_at);


--
-- TOC entry 5629 (class 1259 OID 152640)
-- Name: system_settings_key_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX system_settings_key_key ON public.system_settings USING btree (key);


--
-- TOC entry 5634 (class 1259 OID 152641)
-- Name: ticket_messages_ticket_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ticket_messages_ticket_id_created_at_idx ON public.ticket_messages USING btree (ticket_id, created_at);


--
-- TOC entry 5637 (class 1259 OID 152642)
-- Name: universities_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX universities_slug_key ON public.universities USING btree (slug);


--
-- TOC entry 5640 (class 1259 OID 152643)
-- Name: university_idp_configs_university_id_idp_type_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX university_idp_configs_university_id_idp_type_key ON public.university_idp_configs USING btree (university_id, idp_type);


--
-- TOC entry 5643 (class 1259 OID 152644)
-- Name: user_achievements_user_id_achievement_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_achievements_user_id_achievement_id_key ON public.user_achievements USING btree (user_id, achievement_id);


--
-- TOC entry 5646 (class 1259 OID 152645)
-- Name: user_deletion_requests_scheduled_deletion_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_deletion_requests_scheduled_deletion_at_idx ON public.user_deletion_requests USING btree (scheduled_deletion_at);


--
-- TOC entry 5647 (class 1259 OID 152646)
-- Name: user_deletion_requests_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_deletion_requests_status_idx ON public.user_deletion_requests USING btree (status);


--
-- TOC entry 5648 (class 1259 OID 152647)
-- Name: user_deletion_requests_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_deletion_requests_user_id_idx ON public.user_deletion_requests USING btree (user_id);


--
-- TOC entry 5649 (class 1259 OID 152648)
-- Name: user_departments_department_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_departments_department_id_idx ON public.user_departments USING btree (department_id);


--
-- TOC entry 5652 (class 1259 OID 152649)
-- Name: user_departments_user_id_department_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_departments_user_id_department_id_key ON public.user_departments USING btree (user_id, department_id);


--
-- TOC entry 5653 (class 1259 OID 152650)
-- Name: user_departments_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_departments_user_id_idx ON public.user_departments USING btree (user_id);


--
-- TOC entry 5656 (class 1259 OID 152651)
-- Name: user_feedback_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_feedback_user_id_created_at_idx ON public.user_feedback USING btree (user_id, created_at);


--
-- TOC entry 5657 (class 1259 OID 152652)
-- Name: user_files_deleted_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_files_deleted_at_idx ON public.user_files USING btree (deleted_at);


--
-- TOC entry 5660 (class 1259 OID 152653)
-- Name: user_files_scheduled_deletion_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_files_scheduled_deletion_at_idx ON public.user_files USING btree (scheduled_deletion_at);


--
-- TOC entry 5661 (class 1259 OID 152654)
-- Name: user_files_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_files_user_id_idx ON public.user_files USING btree (user_id);


--
-- TOC entry 5664 (class 1259 OID 152655)
-- Name: user_group_members_user_group_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_group_members_user_group_id_idx ON public.user_group_members USING btree (user_group_id);


--
-- TOC entry 5665 (class 1259 OID 152656)
-- Name: user_group_members_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_group_members_user_id_idx ON public.user_group_members USING btree (user_id);


--
-- TOC entry 5666 (class 1259 OID 152657)
-- Name: user_group_members_user_id_user_group_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_group_members_user_id_user_group_id_key ON public.user_group_members USING btree (user_id, user_group_id);


--
-- TOC entry 5667 (class 1259 OID 152658)
-- Name: user_groups_department_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_groups_department_id_idx ON public.user_groups USING btree (department_id);


--
-- TOC entry 5668 (class 1259 OID 152659)
-- Name: user_groups_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_groups_organization_id_idx ON public.user_groups USING btree (organization_id);


--
-- TOC entry 5669 (class 1259 OID 152660)
-- Name: user_groups_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_groups_parent_id_idx ON public.user_groups USING btree (parent_id);


--
-- TOC entry 5674 (class 1259 OID 152661)
-- Name: user_org_roles_user_id_organization_id_role_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_org_roles_user_id_organization_id_role_id_key ON public.user_org_roles USING btree (user_id, organization_id, role_id);


--
-- TOC entry 5679 (class 1259 OID 152662)
-- Name: user_profiles_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_profiles_user_id_key ON public.user_profiles USING btree (user_id);


--
-- TOC entry 5680 (class 1259 OID 152663)
-- Name: user_storage_volumes_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_storage_volumes_created_at_idx ON public.user_storage_volumes USING btree (created_at);


--
-- TOC entry 5681 (class 1259 OID 152664)
-- Name: user_storage_volumes_node_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_storage_volumes_node_id_idx ON public.user_storage_volumes USING btree (node_id);


--
-- TOC entry 5684 (class 1259 OID 152665)
-- Name: user_storage_volumes_user_id_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_storage_volumes_user_id_name_key ON public.user_storage_volumes USING btree (user_id, name);


--
-- TOC entry 5685 (class 1259 OID 152666)
-- Name: user_storage_volumes_user_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_storage_volumes_user_id_status_idx ON public.user_storage_volumes USING btree (user_id, status);


--
-- TOC entry 5686 (class 1259 OID 152667)
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- TOC entry 5687 (class 1259 OID 152668)
-- Name: users_keycloak_sub_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_keycloak_sub_key ON public.users USING btree (keycloak_sub);


--
-- TOC entry 5690 (class 1259 OID 152669)
-- Name: users_storage_uid_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_storage_uid_key ON public.users USING btree (storage_uid);


--
-- TOC entry 5691 (class 1259 OID 152670)
-- Name: waitlist_entries_createdAt_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "waitlist_entries_createdAt_idx" ON public.waitlist_entries USING btree ("createdAt");


--
-- TOC entry 5692 (class 1259 OID 152671)
-- Name: waitlist_entries_email_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX waitlist_entries_email_idx ON public.waitlist_entries USING btree (email);


--
-- TOC entry 5695 (class 1259 OID 152672)
-- Name: waitlist_entries_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX waitlist_entries_status_idx ON public.waitlist_entries USING btree (status);


--
-- TOC entry 5696 (class 1259 OID 152673)
-- Name: wallet_holds_expires_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallet_holds_expires_at_idx ON public.wallet_holds USING btree (expires_at);


--
-- TOC entry 5699 (class 1259 OID 152674)
-- Name: wallet_holds_wallet_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallet_holds_wallet_id_status_idx ON public.wallet_holds USING btree (wallet_id, status);


--
-- TOC entry 5702 (class 1259 OID 152675)
-- Name: wallet_transactions_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallet_transactions_user_id_created_at_idx ON public.wallet_transactions USING btree (user_id, created_at);


--
-- TOC entry 5703 (class 1259 OID 152676)
-- Name: wallet_transactions_wallet_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallet_transactions_wallet_id_created_at_idx ON public.wallet_transactions USING btree (wallet_id, created_at);


--
-- TOC entry 5704 (class 1259 OID 152677)
-- Name: wallets_balance_cents_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallets_balance_cents_idx ON public.wallets USING btree (balance_cents);


--
-- TOC entry 5707 (class 1259 OID 152678)
-- Name: wallets_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX wallets_user_id_key ON public.wallets USING btree (user_id);


--
-- TOC entry 5711 (class 2606 OID 152679)
-- Name: announcements announcements_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5712 (class 2606 OID 152684)
-- Name: audit_log audit_log_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5713 (class 2606 OID 152689)
-- Name: audit_log audit_log_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5714 (class 2606 OID 152694)
-- Name: billing_charges billing_charges_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5715 (class 2606 OID 152699)
-- Name: billing_charges billing_charges_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5716 (class 2606 OID 152704)
-- Name: billing_charges billing_charges_storage_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_storage_volume_id_fkey FOREIGN KEY (storage_volume_id) REFERENCES public.user_storage_volumes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5717 (class 2606 OID 152709)
-- Name: billing_charges billing_charges_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5718 (class 2606 OID 152714)
-- Name: billing_charges billing_charges_wallet_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_wallet_transaction_id_fkey FOREIGN KEY (wallet_transaction_id) REFERENCES public.wallet_transactions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5719 (class 2606 OID 152719)
-- Name: bookings bookings_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5720 (class 2606 OID 152724)
-- Name: bookings bookings_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5721 (class 2606 OID 152729)
-- Name: bookings bookings_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5722 (class 2606 OID 152734)
-- Name: bookings bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5723 (class 2606 OID 152739)
-- Name: compute_config_access compute_config_access_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_config_access
    ADD CONSTRAINT compute_config_access_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5724 (class 2606 OID 152744)
-- Name: compute_config_access compute_config_access_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_config_access
    ADD CONSTRAINT compute_config_access_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5725 (class 2606 OID 152749)
-- Name: compute_config_access compute_config_access_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_config_access
    ADD CONSTRAINT compute_config_access_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5726 (class 2606 OID 152754)
-- Name: course_enrollments course_enrollments_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5727 (class 2606 OID 152759)
-- Name: course_enrollments course_enrollments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5728 (class 2606 OID 152764)
-- Name: courses courses_default_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_default_compute_config_id_fkey FOREIGN KEY (default_compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5729 (class 2606 OID 152769)
-- Name: courses courses_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5730 (class 2606 OID 152774)
-- Name: courses courses_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5731 (class 2606 OID 152779)
-- Name: courses courses_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5732 (class 2606 OID 152784)
-- Name: coursework_content coursework_content_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coursework_content
    ADD CONSTRAINT coursework_content_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5733 (class 2606 OID 152789)
-- Name: departments departments_head_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_head_user_id_fkey FOREIGN KEY (head_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5734 (class 2606 OID 152794)
-- Name: departments departments_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5735 (class 2606 OID 152799)
-- Name: departments departments_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5736 (class 2606 OID 152804)
-- Name: discussion_replies discussion_replies_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5737 (class 2606 OID 152809)
-- Name: discussion_replies discussion_replies_discussion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_discussion_id_fkey FOREIGN KEY (discussion_id) REFERENCES public.discussions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5738 (class 2606 OID 152814)
-- Name: discussion_replies discussion_replies_parent_reply_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_parent_reply_id_fkey FOREIGN KEY (parent_reply_id) REFERENCES public.discussion_replies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5739 (class 2606 OID 152819)
-- Name: discussions discussions_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5740 (class 2606 OID 152824)
-- Name: discussions discussions_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5741 (class 2606 OID 152829)
-- Name: discussions discussions_lab_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_lab_id_fkey FOREIGN KEY (lab_id) REFERENCES public.labs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5742 (class 2606 OID 152834)
-- Name: discussions discussions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5743 (class 2606 OID 152839)
-- Name: invoice_line_items invoice_line_items_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_line_items
    ADD CONSTRAINT invoice_line_items_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5744 (class 2606 OID 152844)
-- Name: invoices invoices_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5745 (class 2606 OID 152849)
-- Name: invoices invoices_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5746 (class 2606 OID 152854)
-- Name: lab_assignments lab_assignments_lab_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_assignments
    ADD CONSTRAINT lab_assignments_lab_id_fkey FOREIGN KEY (lab_id) REFERENCES public.labs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5747 (class 2606 OID 152859)
-- Name: lab_grades lab_grades_graded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_grades
    ADD CONSTRAINT lab_grades_graded_by_fkey FOREIGN KEY (graded_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5748 (class 2606 OID 152864)
-- Name: lab_grades lab_grades_submission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_grades
    ADD CONSTRAINT lab_grades_submission_id_fkey FOREIGN KEY (submission_id) REFERENCES public.lab_submissions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5749 (class 2606 OID 152869)
-- Name: lab_group_assignments lab_group_assignments_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_group_assignments
    ADD CONSTRAINT lab_group_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5750 (class 2606 OID 152874)
-- Name: lab_group_assignments lab_group_assignments_lab_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_group_assignments
    ADD CONSTRAINT lab_group_assignments_lab_id_fkey FOREIGN KEY (lab_id) REFERENCES public.labs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5751 (class 2606 OID 152879)
-- Name: lab_group_assignments lab_group_assignments_user_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_group_assignments
    ADD CONSTRAINT lab_group_assignments_user_group_id_fkey FOREIGN KEY (user_group_id) REFERENCES public.user_groups(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5752 (class 2606 OID 152884)
-- Name: lab_submissions lab_submissions_lab_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_submissions
    ADD CONSTRAINT lab_submissions_lab_assignment_id_fkey FOREIGN KEY (lab_assignment_id) REFERENCES public.lab_assignments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5753 (class 2606 OID 152889)
-- Name: lab_submissions lab_submissions_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_submissions
    ADD CONSTRAINT lab_submissions_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5754 (class 2606 OID 152894)
-- Name: lab_submissions lab_submissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_submissions
    ADD CONSTRAINT lab_submissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5755 (class 2606 OID 152899)
-- Name: labs labs_base_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_base_image_id_fkey FOREIGN KEY (base_image_id) REFERENCES public.base_images(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5756 (class 2606 OID 152904)
-- Name: labs labs_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5757 (class 2606 OID 152909)
-- Name: labs labs_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5758 (class 2606 OID 152914)
-- Name: labs labs_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5759 (class 2606 OID 152919)
-- Name: labs labs_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5760 (class 2606 OID 152924)
-- Name: login_history login_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5761 (class 2606 OID 152929)
-- Name: mentor_availability_slots mentor_availability_slots_mentor_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_availability_slots
    ADD CONSTRAINT mentor_availability_slots_mentor_profile_id_fkey FOREIGN KEY (mentor_profile_id) REFERENCES public.mentor_profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5762 (class 2606 OID 152934)
-- Name: mentor_bookings mentor_bookings_mentor_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_bookings
    ADD CONSTRAINT mentor_bookings_mentor_profile_id_fkey FOREIGN KEY (mentor_profile_id) REFERENCES public.mentor_profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5763 (class 2606 OID 152939)
-- Name: mentor_bookings mentor_bookings_payment_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_bookings
    ADD CONSTRAINT mentor_bookings_payment_transaction_id_fkey FOREIGN KEY (payment_transaction_id) REFERENCES public.payment_transactions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5764 (class 2606 OID 152944)
-- Name: mentor_bookings mentor_bookings_student_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_bookings
    ADD CONSTRAINT mentor_bookings_student_user_id_fkey FOREIGN KEY (student_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5765 (class 2606 OID 152949)
-- Name: mentor_profiles mentor_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_profiles
    ADD CONSTRAINT mentor_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5766 (class 2606 OID 152954)
-- Name: mentor_reviews mentor_reviews_mentor_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_reviews
    ADD CONSTRAINT mentor_reviews_mentor_booking_id_fkey FOREIGN KEY (mentor_booking_id) REFERENCES public.mentor_bookings(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5767 (class 2606 OID 152959)
-- Name: mentor_reviews mentor_reviews_reviewer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_reviews
    ADD CONSTRAINT mentor_reviews_reviewer_user_id_fkey FOREIGN KEY (reviewer_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5768 (class 2606 OID 152964)
-- Name: node_base_images node_base_images_base_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_base_images
    ADD CONSTRAINT node_base_images_base_image_id_fkey FOREIGN KEY (base_image_id) REFERENCES public.base_images(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5769 (class 2606 OID 152969)
-- Name: node_base_images node_base_images_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_base_images
    ADD CONSTRAINT node_base_images_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5770 (class 2606 OID 152974)
-- Name: node_resource_reservations node_resource_reservations_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_resource_reservations
    ADD CONSTRAINT node_resource_reservations_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5771 (class 2606 OID 152979)
-- Name: node_resource_reservations node_resource_reservations_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_resource_reservations
    ADD CONSTRAINT node_resource_reservations_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5772 (class 2606 OID 152984)
-- Name: notifications notifications_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.notification_templates(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5773 (class 2606 OID 152989)
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5774 (class 2606 OID 152994)
-- Name: org_contracts org_contracts_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_contracts
    ADD CONSTRAINT org_contracts_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5775 (class 2606 OID 152999)
-- Name: org_resource_quotas org_resource_quotas_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_resource_quotas
    ADD CONSTRAINT org_resource_quotas_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5776 (class 2606 OID 153004)
-- Name: organizations organizations_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5777 (class 2606 OID 153009)
-- Name: os_switch_history os_switch_history_new_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_switch_history
    ADD CONSTRAINT os_switch_history_new_volume_id_fkey FOREIGN KEY (new_volume_id) REFERENCES public.user_storage_volumes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5778 (class 2606 OID 153014)
-- Name: os_switch_history os_switch_history_old_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_switch_history
    ADD CONSTRAINT os_switch_history_old_volume_id_fkey FOREIGN KEY (old_volume_id) REFERENCES public.user_storage_volumes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5779 (class 2606 OID 153019)
-- Name: os_switch_history os_switch_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_switch_history
    ADD CONSTRAINT os_switch_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5780 (class 2606 OID 153024)
-- Name: otp_verifications otp_verifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_verifications
    ADD CONSTRAINT otp_verifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5781 (class 2606 OID 153029)
-- Name: payment_transactions payment_transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5782 (class 2606 OID 153034)
-- Name: project_showcases project_showcases_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_showcases
    ADD CONSTRAINT project_showcases_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5783 (class 2606 OID 153039)
-- Name: project_showcases project_showcases_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_showcases
    ADD CONSTRAINT project_showcases_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5784 (class 2606 OID 153044)
-- Name: recommendation_sessions recommendation_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recommendation_sessions
    ADD CONSTRAINT recommendation_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5785 (class 2606 OID 153049)
-- Name: referral_conversions referral_conversions_referral_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_conversions
    ADD CONSTRAINT referral_conversions_referral_id_fkey FOREIGN KEY (referral_id) REFERENCES public.referrals(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5786 (class 2606 OID 153054)
-- Name: referral_conversions referral_conversions_referred_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_conversions
    ADD CONSTRAINT referral_conversions_referred_user_id_fkey FOREIGN KEY (referred_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5787 (class 2606 OID 153059)
-- Name: referral_conversions referral_conversions_referrer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_conversions
    ADD CONSTRAINT referral_conversions_referrer_user_id_fkey FOREIGN KEY (referrer_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5788 (class 2606 OID 153064)
-- Name: referral_events referral_events_referral_conversion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_events
    ADD CONSTRAINT referral_events_referral_conversion_id_fkey FOREIGN KEY (referral_conversion_id) REFERENCES public.referral_conversions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5789 (class 2606 OID 153069)
-- Name: referral_events referral_events_referral_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_events
    ADD CONSTRAINT referral_events_referral_id_fkey FOREIGN KEY (referral_id) REFERENCES public.referrals(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5790 (class 2606 OID 153074)
-- Name: referrals referrals_referrer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_referrer_user_id_fkey FOREIGN KEY (referrer_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5791 (class 2606 OID 153079)
-- Name: refresh_tokens refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5792 (class 2606 OID 153084)
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5793 (class 2606 OID 153089)
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5794 (class 2606 OID 153094)
-- Name: session_events session_events_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_events
    ADD CONSTRAINT session_events_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5795 (class 2606 OID 153099)
-- Name: sessions sessions_base_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_base_image_id_fkey FOREIGN KEY (base_image_id) REFERENCES public.base_images(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5796 (class 2606 OID 153104)
-- Name: sessions sessions_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5797 (class 2606 OID 153109)
-- Name: sessions sessions_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5798 (class 2606 OID 153114)
-- Name: sessions sessions_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5799 (class 2606 OID 153119)
-- Name: sessions sessions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5800 (class 2606 OID 153124)
-- Name: sessions sessions_storage_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_storage_node_id_fkey FOREIGN KEY (storage_node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5801 (class 2606 OID 153129)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5802 (class 2606 OID 153134)
-- Name: storage_extensions storage_extensions_payment_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_payment_transaction_id_fkey FOREIGN KEY (payment_transaction_id) REFERENCES public.payment_transactions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5803 (class 2606 OID 153139)
-- Name: storage_extensions storage_extensions_storage_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_storage_volume_id_fkey FOREIGN KEY (storage_volume_id) REFERENCES public.user_storage_volumes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5804 (class 2606 OID 153144)
-- Name: storage_extensions storage_extensions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5805 (class 2606 OID 153149)
-- Name: storage_extensions storage_extensions_wallet_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_wallet_transaction_id_fkey FOREIGN KEY (wallet_transaction_id) REFERENCES public.wallet_transactions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5806 (class 2606 OID 153154)
-- Name: subscriptions subscriptions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5807 (class 2606 OID 153159)
-- Name: subscriptions subscriptions_payment_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_payment_transaction_id_fkey FOREIGN KEY (payment_transaction_id) REFERENCES public.payment_transactions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5808 (class 2606 OID 153164)
-- Name: subscriptions subscriptions_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.subscription_plans(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5809 (class 2606 OID 153169)
-- Name: subscriptions subscriptions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5853 (class 2606 OID 163213)
-- Name: support_ticket_attachments support_ticket_attachments_ticketId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_ticket_attachments
    ADD CONSTRAINT "support_ticket_attachments_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES public.support_tickets(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5810 (class 2606 OID 153174)
-- Name: support_tickets support_tickets_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5811 (class 2606 OID 153179)
-- Name: support_tickets support_tickets_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5812 (class 2606 OID 153184)
-- Name: support_tickets support_tickets_related_billing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_related_billing_id_fkey FOREIGN KEY (related_billing_id) REFERENCES public.billing_charges(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5813 (class 2606 OID 153189)
-- Name: support_tickets support_tickets_related_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_related_session_id_fkey FOREIGN KEY (related_session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5814 (class 2606 OID 153194)
-- Name: support_tickets support_tickets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5815 (class 2606 OID 153199)
-- Name: ticket_messages ticket_messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_messages
    ADD CONSTRAINT ticket_messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5816 (class 2606 OID 153204)
-- Name: ticket_messages ticket_messages_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_messages
    ADD CONSTRAINT ticket_messages_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.support_tickets(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5817 (class 2606 OID 153209)
-- Name: university_idp_configs university_idp_configs_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.university_idp_configs
    ADD CONSTRAINT university_idp_configs_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5818 (class 2606 OID 153214)
-- Name: user_achievements user_achievements_achievement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_achievement_id_fkey FOREIGN KEY (achievement_id) REFERENCES public.achievements(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5819 (class 2606 OID 153219)
-- Name: user_achievements user_achievements_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5820 (class 2606 OID 153224)
-- Name: user_deletion_requests user_deletion_requests_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_deletion_requests
    ADD CONSTRAINT user_deletion_requests_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5821 (class 2606 OID 153229)
-- Name: user_deletion_requests user_deletion_requests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_deletion_requests
    ADD CONSTRAINT user_deletion_requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5822 (class 2606 OID 153234)
-- Name: user_departments user_departments_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_departments
    ADD CONSTRAINT user_departments_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5823 (class 2606 OID 153239)
-- Name: user_departments user_departments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_departments
    ADD CONSTRAINT user_departments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5824 (class 2606 OID 153244)
-- Name: user_feedback user_feedback_responded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_responded_by_fkey FOREIGN KEY (responded_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5825 (class 2606 OID 153249)
-- Name: user_feedback user_feedback_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5826 (class 2606 OID 153254)
-- Name: user_feedback user_feedback_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5827 (class 2606 OID 153259)
-- Name: user_files user_files_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_files
    ADD CONSTRAINT user_files_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5828 (class 2606 OID 153264)
-- Name: user_files user_files_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_files
    ADD CONSTRAINT user_files_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5829 (class 2606 OID 153269)
-- Name: user_group_members user_group_members_added_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_members
    ADD CONSTRAINT user_group_members_added_by_fkey FOREIGN KEY (added_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5830 (class 2606 OID 153274)
-- Name: user_group_members user_group_members_user_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_members
    ADD CONSTRAINT user_group_members_user_group_id_fkey FOREIGN KEY (user_group_id) REFERENCES public.user_groups(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5831 (class 2606 OID 153279)
-- Name: user_group_members user_group_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_members
    ADD CONSTRAINT user_group_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5832 (class 2606 OID 153284)
-- Name: user_groups user_groups_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5833 (class 2606 OID 153289)
-- Name: user_groups user_groups_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5834 (class 2606 OID 153294)
-- Name: user_groups user_groups_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.user_groups(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5835 (class 2606 OID 153299)
-- Name: user_org_roles user_org_roles_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_org_roles
    ADD CONSTRAINT user_org_roles_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5836 (class 2606 OID 153304)
-- Name: user_org_roles user_org_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_org_roles
    ADD CONSTRAINT user_org_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5837 (class 2606 OID 153309)
-- Name: user_org_roles user_org_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_org_roles
    ADD CONSTRAINT user_org_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5838 (class 2606 OID 153314)
-- Name: user_policy_consents user_policy_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_policy_consents
    ADD CONSTRAINT user_policy_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5839 (class 2606 OID 153319)
-- Name: user_profiles user_profiles_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5840 (class 2606 OID 153324)
-- Name: user_profiles user_profiles_id_proof_verified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_id_proof_verified_by_fkey FOREIGN KEY (id_proof_verified_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5841 (class 2606 OID 153329)
-- Name: user_profiles user_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5842 (class 2606 OID 153334)
-- Name: user_storage_volumes user_storage_volumes_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_storage_volumes
    ADD CONSTRAINT user_storage_volumes_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5843 (class 2606 OID 153339)
-- Name: user_storage_volumes user_storage_volumes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_storage_volumes
    ADD CONSTRAINT user_storage_volumes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5844 (class 2606 OID 153344)
-- Name: users users_default_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_default_org_id_fkey FOREIGN KEY (default_org_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5845 (class 2606 OID 153349)
-- Name: waitlist_entries waitlist_entries_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waitlist_entries
    ADD CONSTRAINT "waitlist_entries_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5846 (class 2606 OID 153354)
-- Name: wallet_holds wallet_holds_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5847 (class 2606 OID 153359)
-- Name: wallet_holds wallet_holds_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5848 (class 2606 OID 153364)
-- Name: wallet_holds wallet_holds_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5849 (class 2606 OID 153369)
-- Name: wallet_holds wallet_holds_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.wallets(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5850 (class 2606 OID 153374)
-- Name: wallet_transactions wallet_transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_transactions
    ADD CONSTRAINT wallet_transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5851 (class 2606 OID 153379)
-- Name: wallet_transactions wallet_transactions_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_transactions
    ADD CONSTRAINT wallet_transactions_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.wallets(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5852 (class 2606 OID 153384)
-- Name: wallets wallets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT wallets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 6083 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2026-05-21 20:55:29

--
-- PostgreSQL database dump complete
--

\unrestrict P2i5xzdMceImuCmNfYPadx0EcUiGcflcf0agw3sgi7T2A1uzoJpAo1Vx8EnjJGE

