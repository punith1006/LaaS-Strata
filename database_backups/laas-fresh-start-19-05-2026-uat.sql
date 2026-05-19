--
-- PostgreSQL database dump
--

\restrict 4atNcefBMpaCoH4T2Ym7ojr86Aw99zu1Ob8cF4qRJUKfDzDWTqJm7FEGRVQ1lB1

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-05-19 22:41:49

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
-- TOC entry 6071 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- TOC entry 926 (class 1247 OID 151083)
-- Name: AuthType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."AuthType" AS ENUM (
    'university_sso',
    'public_local',
    'public_oauth'
);


ALTER TYPE public."AuthType" OWNER TO postgres;

--
-- TOC entry 929 (class 1247 OID 151090)
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
-- TOC entry 932 (class 1247 OID 151104)
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
-- TOC entry 935 (class 1247 OID 151116)
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
-- TOC entry 938 (class 1247 OID 151126)
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
-- TOC entry 941 (class 1247 OID 151140)
-- Name: ReferralRewardStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ReferralRewardStatus" AS ENUM (
    'PENDING',
    'CREDITED',
    'VOIDED'
);


ALTER TYPE public."ReferralRewardStatus" OWNER TO postgres;

--
-- TOC entry 944 (class 1247 OID 151148)
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
-- TOC entry 947 (class 1247 OID 151168)
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
-- TOC entry 950 (class 1247 OID 151196)
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
-- TOC entry 953 (class 1247 OID 151206)
-- Name: StorageBackend; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."StorageBackend" AS ENUM (
    'zfs_dataset',
    'zfs_zvol'
);


ALTER TYPE public."StorageBackend" OWNER TO postgres;

--
-- TOC entry 956 (class 1247 OID 151212)
-- Name: StorageMode; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."StorageMode" AS ENUM (
    'stateful',
    'ephemeral'
);


ALTER TYPE public."StorageMode" OWNER TO postgres;

--
-- TOC entry 959 (class 1247 OID 151218)
-- Name: StorageTransport; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."StorageTransport" AS ENUM (
    'local_zfs',
    'nvmeof_tcp'
);


ALTER TYPE public."StorageTransport" OWNER TO postgres;

--
-- TOC entry 962 (class 1247 OID 151224)
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
-- TOC entry 965 (class 1247 OID 151238)
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
-- TOC entry 968 (class 1247 OID 151248)
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
-- TOC entry 971 (class 1247 OID 151258)
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
-- TOC entry 974 (class 1247 OID 151270)
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
    storage_volume_id uuid
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
-- TOC entry 5991 (class 0 OID 151279)
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
-- TOC entry 5992 (class 0 OID 151291)
-- Dependencies: 220
-- Data for Name: achievements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.achievements (id, slug, name, description, icon_url, category, criteria, points, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 5993 (class 0 OID 151304)
-- Dependencies: 221
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.announcements (id, organization_id, title, body, severity, published_at, expires_at, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 5994 (class 0 OID 151315)
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
\.


--
-- TOC entry 5995 (class 0 OID 151325)
-- Dependencies: 223
-- Data for Name: base_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.base_images (id, tag, os_name, description, size_bytes, software_manifest, is_default, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 5996 (class 0 OID 151337)
-- Dependencies: 224
-- Data for Name: billing_charges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.billing_charges (id, user_id, session_id, compute_config_id, duration_seconds, rate_cents_per_hour, amount_cents, currency, wallet_transaction_id, created_at, created_by, charge_type, quota_gb, storage_volume_id) FROM stdin;
9aff6136-0dcd-4a1a-ad05-0439406efdd0	8d40647d-da49-4490-ada6-3bfa2205366c	c4ce3860-7509-47a7-b3d6-60592b593100	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	be097129-0649-4b3d-97b7-f1e4b314a3e2	2026-05-18 07:03:02.467	\N	compute	\N	\N
26478250-6ecb-4dc5-82c6-e4dd3e564dc5	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	85b58bf2-798b-4d9f-b180-59054ce71538	2026-05-18 07:30:00	\N	storage	10	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
e0963628-5c62-4564-8888-64ee8d436d18	8d40647d-da49-4490-ada6-3bfa2205366c	b3fb45cb-ac62-41bb-b65b-babce27a14fe	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	0fd2cc3e-21ed-4ca5-b95e-570d169b709e	2026-05-18 07:30:52.727	\N	compute	\N	\N
4803d377-3804-48cd-989c-fe91c56d9b49	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	ffc87569-0d05-45f1-96be-6ac7d1d93410	2026-05-18 07:31:29.703	\N	compute	\N	\N
83992f03-c1d0-42f1-973e-96de7860ffc4	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	7e306b63-c509-41d3-8225-de8e497bcec3	2026-05-18 08:30:00	\N	storage	10	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
8b7e65a6-b5b9-4631-aa28-ed9938c90ffa	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	22bb8e09-1706-4833-8036-c0c266454534	2026-05-18 08:30:00.1	\N	compute	\N	\N
c6d947c1-107c-48b0-8417-144bb92a9a75	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	e9ca97e7-5470-4bba-ab15-bfe439e5a783	2026-05-18 09:30:00.082	\N	compute	\N	\N
dfaece27-61ce-4243-8ec6-b2831448f411	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	71e6b3d6-f5f1-4df1-9d8e-42efea789e8c	2026-05-18 09:30:00	\N	storage	10	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
9f829a76-6d64-4c91-807a-5514eca32226	8d40647d-da49-4490-ada6-3bfa2205366c	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	f6ede85a-732b-49f9-8d87-f404b93007e4	2026-05-18 10:21:28.16	\N	compute	\N	\N
44b8a605-e131-4115-a513-1d7556315da2	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	10	10	INR	97d73234-d5e1-4096-9a21-f7b6616c2988	2026-05-18 10:30:00	\N	storage	10	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
8307cf82-6d16-4268-b22b-c09b103f4f36	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	80b0d04d-5670-4fd0-bdb4-9a804b41e0ee	2026-05-18 10:30:00.098	\N	compute	\N	\N
42b0453e-f29f-48d5-808c-ce94d90c41c2	8d40647d-da49-4490-ada6-3bfa2205366c	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	e74a87f3-3b8f-47bb-8e3d-d836075dbab0	2026-05-18 10:30:00.116	\N	compute	\N	\N
aff35201-1f32-4e90-885b-f6006c8109c4	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	4e623047-62f4-4dab-a1ff-13d2e5c70540	2026-05-18 11:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
c15e9b70-acca-4b7e-ae55-680b6edc4144	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	9e590d3e-d7ba-408f-bda8-25da9657d3f7	2026-05-18 11:30:00.078	\N	compute	\N	\N
4d6ee51d-4fae-4976-862e-850560b9bc67	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	05e4bdfa-2a6c-4e02-b49d-3c65d0a4d0eb	2026-05-18 11:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
31d39253-f9be-4067-a653-a1bd23ee67aa	8d40647d-da49-4490-ada6-3bfa2205366c	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	f6995bc1-efa3-4b9a-a778-f02c3bef7578	2026-05-18 11:30:00.118	\N	compute	\N	\N
562bc29f-308a-4582-92b3-7d2640164ef6	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	2f1f6370-88c0-41bd-b75f-b2ea40e44a93	2026-05-18 12:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
2e13e989-01ad-492c-854e-f7e5e5a79750	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	817cdb12-c07e-4ebb-af92-d380a3c9c47e	2026-05-18 12:30:00.062	\N	compute	\N	\N
33b135de-e65d-40a3-9fa6-e847cd429f0d	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	d50b2cb7-a694-4e12-89f9-4346d6749156	2026-05-18 12:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
f583e827-29db-4a89-8e26-3d84e6cdeb5b	8d40647d-da49-4490-ada6-3bfa2205366c	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	023e8780-dced-4c09-bf69-6a96991e39b3	2026-05-18 12:30:00.089	\N	compute	\N	\N
c8b8aeba-8555-4232-a302-0abab1503f60	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	bb2d2bb6-0612-44cd-a1fb-156ebc4960fd	2026-05-18 13:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
aa114238-2fa8-4f58-92e1-813ca0bc8f88	8d40647d-da49-4490-ada6-3bfa2205366c	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	3600	36000	36000	INR	927af7cf-a7fb-47b6-b09a-19a5101a7e29	2026-05-18 13:49:45.016	\N	compute	\N	\N
34428601-fa2d-4e2a-8d8c-4edd2dd3d56e	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	5201fdf5-3e55-4b5f-822a-785db5d37c53	2026-05-18 13:49:45.175	\N	compute	\N	\N
32987d88-88fc-40c3-b831-dbf3c3181e37	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	90677aa1-35c6-45d6-903c-26d2c21334f8	2026-05-18 13:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
cfb6e47c-8da4-44af-b920-d23a46a6233e	8d40647d-da49-4490-ada6-3bfa2205366c	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	7334	36000	108000	INR	5cb0b434-2c2a-4f3e-b899-064b27205268	2026-05-18 17:23:42.447	\N	compute	\N	\N
288301bb-6dfa-4516-8c82-cd23ec288402	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	5e2676a9-c06a-4a3b-868e-228fef183e41	2026-05-18 17:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
2a0d08cd-2b65-402b-a6de-10feb702ab17	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	ba7d126b-3c44-4d7a-9c07-744300cb933e	2026-05-18 17:30:02.973	\N	compute	\N	\N
5138cf5f-3208-4e5b-9b48-bf7e4a315928	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	20416aa7-7a4a-461d-a37e-5a790862b5af	2026-05-18 17:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
1b9fbe69-5ad2-4442-a9f6-f781e56190f2	8d40647d-da49-4490-ada6-3bfa2205366c	968bf735-3894-4093-838d-efb4a943315d	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	6a9e8572-81c2-4cd4-8e56-18f24ab8ae9b	2026-05-18 17:36:54.668	\N	compute	\N	\N
d38370ea-a55a-48ef-9f6b-26889b84d2ca	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	88dfec6e-a3d2-4337-8cab-11fd6edc1762	2026-05-18 18:04:26.451	\N	compute	\N	\N
63942614-39e5-420f-bd7c-19e56d262dff	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	d1136ac4-8332-4743-9626-b37b5fd2530d	2026-05-18 18:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
3afd1e4d-614b-48ea-a05e-96d34a219ef9	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	dd591601-26ea-4199-9783-e6a21f1cf641	2026-05-18 18:30:00.059	\N	compute	\N	\N
fa9da5c0-b914-4686-a8da-391ee520fa65	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	08bbc186-5e21-42de-9d7f-9d251bb790c8	2026-05-18 18:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
87ab8e76-ead6-4c92-950e-e70c18a73b9f	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	72535ca4-90f8-434f-bdda-8e887b531586	2026-05-18 18:30:00.265	\N	compute	\N	\N
5cc1d418-cee5-4e46-ae1b-2c57df0c7748	8d40647d-da49-4490-ada6-3bfa2205366c	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	5c23022a-08d7-4e90-872f-eaa2fe0f3dcb	2026-05-18 18:37:54.466	\N	compute	\N	\N
8501c577-f596-4976-9cf5-1a67868725a9	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	a3a7f84c-5f18-4ee4-a436-f40d2e3f284d	2026-05-18 20:01:14.479	\N	compute	\N	\N
0db4bd3c-e174-42f5-aaa1-48bfe23c3a6c	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	3da970c0-ad0a-4436-b537-ffb2c91533a3	2026-05-18 20:01:14.556	\N	compute	\N	\N
9a4dfe10-87fa-41c0-9115-6eaf64c6420f	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	aca4a607-110c-4b3e-be3a-34f7a3ce6902	2026-05-18 23:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
ee68e16e-99bd-495b-ad88-3ddfcf60bd07	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	51833ecb-ee18-4602-bf03-120e2e9d0475	2026-05-18 23:43:25.807	\N	compute	\N	\N
dbc0116f-38ca-40cf-bbc2-158133dd2cca	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	f352de78-4f29-4f5c-830f-71eb5e063b58	2026-05-18 23:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
6f7f6c23-265c-441a-82e0-bf49caee7add	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	868b9e04-5e33-4f8b-b740-aa984cf78f04	2026-05-18 23:43:27.674	\N	compute	\N	\N
6f0f8230-e509-4198-a3e8-b5e5ed555ae0	8d40647d-da49-4490-ada6-3bfa2205366c	aef9cfcc-1747-4572-933e-6cf55bce8993	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	5b26385a-ee40-49ee-8653-a2f95db3d137	2026-05-19 00:22:22.471	\N	compute	\N	\N
c60c09a9-4f9a-4e5a-8a0a-5e2b95e07624	8d40647d-da49-4490-ada6-3bfa2205366c	a50d4adb-5e31-41ba-9972-91dc118efdc0	d2fb06af-8256-4105-812b-05a10cbe99a1	21115	12000	72000	INR	7f4f33a4-fa4e-4805-b994-fd00098ce259	2026-05-19 00:23:24.88	\N	compute	\N	\N
6c894450-96de-4fcf-ba0c-85d000e7d006	8d40647d-da49-4490-ada6-3bfa2205366c	fae608c4-ed05-41cd-b0b6-4134aaaa6354	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	ab6cae58-3e38-4038-92c9-d44223cc5167	2026-05-19 00:24:59.892	\N	compute	\N	\N
e3765c2e-b249-40f5-bd38-6b8b92a9f0bf	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	054ede88-4b1e-4092-9a71-9f0f1a29ab0d	2026-05-19 00:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
970fb468-bd6a-4475-927c-47a16ee0606c	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	354d900b-ade1-4fff-82c8-eeae2cb8b476	2026-05-19 00:30:00.116	\N	compute	\N	\N
a711972f-60e2-4a3a-9eb8-4fe4894959bc	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	d49fdb45-e04b-458d-9ad1-0701477ebc4f	2026-05-19 00:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
c2bc3dc1-1b49-4d91-b447-76d7cff0d33e	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	4318a73b-e913-40ab-abbf-8d502d358680	2026-05-19 02:40:11.471	\N	compute	\N	\N
6584643a-6322-4ed3-80c6-01a853a8c7d7	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	6e10d9d0-b09b-4a2e-ab00-38c16b568678	2026-05-19 02:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
2e50b104-6d3d-4658-9d32-2323c6855669	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	466b8f63-dded-4416-aa9c-6ac259cde1d7	2026-05-19 02:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
12eb6b29-99b1-48bd-a29d-d8c2929e61a5	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	8c9ff06f-db7c-4578-a386-14fccc035b9f	2026-05-19 03:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
b509c1cf-8a62-4b8f-aa1f-8e2afa6e86d5	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	865d4e85-0757-4df2-a40b-e3bedf7b00e7	2026-05-19 03:30:00.106	\N	compute	\N	\N
b3f04ac7-1f09-44fe-a1be-64ae7a95dad0	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	e65b8210-dac0-496c-83ef-eee052485b99	2026-05-19 03:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
a7bee3f5-5148-4131-bec6-a599ea651dc6	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	dcddb480-4076-416b-b803-863395e2028a	2026-05-19 04:28:15.245	\N	compute	\N	\N
603bbeaa-5749-49f9-a90c-70093823d351	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	f7a275ca-a7e4-404c-8dad-da3fbe74f199	2026-05-19 04:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
d7767412-65bc-4bf2-b094-58ef2b02cb4c	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	8bd8cac0-6d64-4128-85c1-f122f0e0d5c0	2026-05-19 04:30:00.121	\N	compute	\N	\N
286cb7f8-97e4-48c2-bddb-9fa9086d52d6	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	994a4649-0226-4d3d-9ffc-7fc62438f4bf	2026-05-19 04:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
3747f1e6-3594-4db7-9291-43722c50e458	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	66116fe8-95b1-432d-a94b-f61f5427b0e8	2026-05-19 04:30:00.153	\N	compute	\N	\N
3202de29-aab2-410e-a786-46df02f1d13c	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	0382d574-7e61-438d-9735-1c475a92697f	2026-05-19 06:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
04b99e86-03b2-49ba-96dd-a981f2e36fe1	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	bf61169f-f273-406e-8257-a82bd00edb57	2026-05-19 06:30:00.157	\N	compute	\N	\N
fefa75f9-cd20-4433-af86-46d7c4027297	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	fc40d17e-28db-4cc5-a0b5-5b84896d4672	2026-05-19 06:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
db0005f0-882d-477f-a2ad-7a10e5b087b5	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	49d9ae9f-5411-4bc6-9740-6bcbe85a87b2	2026-05-19 06:30:00.22	\N	compute	\N	\N
0788fa58-28ae-4384-884f-53b581a95da2	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	47b876af-797e-4ccf-a771-fcfb9d76e829	2026-05-19 07:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
524870d2-0fc9-4aea-b8eb-cfb60b3a37f5	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	4c06a6f9-6d84-45f0-9ad0-aa59d0688313	2026-05-19 07:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
b66f7bd3-842b-4df8-9920-c97570b49378	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	5f1b9e37-50a9-4ce6-a6de-97050149371c	2026-05-19 07:30:00.129	\N	compute	\N	\N
b6fa1285-6e7b-4cb8-b616-c89757b73535	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	743050bc-0fad-459b-a3ca-7b420d2ac661	2026-05-19 07:30:00.151	\N	compute	\N	\N
4c117495-2b7e-4109-8146-13c928867702	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	c46d8016-f4f5-4376-ba5c-adc98e9d8a12	2026-05-19 08:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
31e823a9-a698-4d8b-bfe1-f2f8b8366bc5	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	93b1ba31-9780-4e93-a584-cf0f9f3868c3	2026-05-19 08:30:00.271	\N	compute	\N	\N
bfab0d88-1e76-4310-8159-2cd246b80fc0	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	be2f3184-0644-4cf4-9b65-b785e4fd4f08	2026-05-19 08:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
2b6bfe18-2120-44bf-902d-8e517f04c193	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	c65a516b-1df5-42c9-9120-344b3d328b55	2026-05-19 08:30:00.619	\N	compute	\N	\N
23bd6366-3c1d-4d2d-a1f6-626e32abe10e	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	a5794900-4ae4-4622-876e-c39df3dca7cf	2026-05-19 09:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
e9c8a851-e873-4ba0-ae10-577fdb859581	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	585ba430-8b72-4af2-af16-c5320da4271d	2026-05-19 09:30:00.695	\N	compute	\N	\N
af65ce7e-9828-4e9d-a56e-911ed78d9b66	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	207ed39a-ffb2-492b-9d15-75c4a3e6b516	2026-05-19 09:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
2fd264f1-45a2-41e9-b561-033287ee5390	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	0e2699c3-4221-4135-887b-b311533f631a	2026-05-19 09:30:00.751	\N	compute	\N	\N
899d4953-89e1-4ad7-b156-40296629527e	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	750e0f6c-bffd-4738-b040-d1927275497e	2026-05-19 10:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
14a4e1ab-51cb-4ed3-b037-c6bfbb3cb90b	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	10aacb5a-1063-4b41-ba1b-a0eaf6533220	2026-05-19 10:30:00.109	\N	compute	\N	\N
0faf4f63-25e1-4180-b963-0f0e138c9346	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	4ed86f5d-3c13-4188-b315-0fbde206c4e5	2026-05-19 10:30:00.256	\N	compute	\N	\N
c95fa3bc-8a76-4962-8b5c-0376beee2271	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	46e3f404-f651-4710-9e27-556f067a4f74	2026-05-19 10:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
49d1bcc4-31fc-407e-ade1-57667f6919ca	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	dff6e54a-0cad-4676-a3f2-93e39576e9ed	2026-05-19 11:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
17961b7f-f8c7-4f36-b35c-86af0adaf323	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	f5811d7c-d39f-4a91-8c1e-4ffd3622c643	2026-05-19 11:30:00.105	\N	compute	\N	\N
6e39c872-5ee7-4367-a17b-ee43e6346966	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	5d783f20-c65e-4950-9001-1924598a8580	2026-05-19 11:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
f73912ab-8597-4178-98fd-f21ddab39d14	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	492f1fda-b9c3-4448-9417-82f1cf4b81c0	2026-05-19 11:30:00.151	\N	compute	\N	\N
302431f1-000e-49a9-9ae6-6b8ce77d59fd	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	322010f3-bbe3-447b-8f55-6aeac4ceb49a	2026-05-19 12:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
2a1ebabe-3ec0-4786-ba76-69d89f12bede	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	b6efdb92-debe-4e09-8ba1-e117b1393d5f	2026-05-19 12:30:00.061	\N	compute	\N	\N
4d3c772f-990e-4e49-8ffc-29e839c33c24	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	f8d80c09-077d-420c-8961-5c002b00189c	2026-05-19 12:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
06999b5a-f6fb-4140-b3e8-e0c944780ca1	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	146d1f04-5ae7-4ad7-aa0b-56cddc589ede	2026-05-19 12:30:00.161	\N	compute	\N	\N
4d48a15a-2a77-4967-8410-d66803a8cf83	8d40647d-da49-4490-ada6-3bfa2205366c	7c24eb9b-cef9-43c9-9874-220745bc7662	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	cf7221db-cf11-4d76-a405-6c0daf76f488	2026-05-19 12:43:34.723	\N	compute	\N	\N
8496fdfb-cbe9-4677-aed1-640034a192dd	8d40647d-da49-4490-ada6-3bfa2205366c	7c24eb9b-cef9-43c9-9874-220745bc7662	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	a7de1322-75dd-48cc-b1f1-8898860ad232	2026-05-19 16:26:59.02	\N	compute	\N	\N
ea0482bc-dec7-4767-90c5-b13224c9089f	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	3600	12	12	INR	96c4fb19-759e-4022-941e-9c725d9244c7	2026-05-19 15:30:00	\N	storage	12	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5
33cb4807-fd75-4850-8b4c-71844b87da76	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	3600	30000	30000	INR	37f251ab-a30d-4180-990a-3e42d59fdb1a	2026-05-19 16:26:59.521	\N	compute	\N	\N
0549a589-8fa3-45b8-9fca-30bbb37d8f73	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	3600	31	31	INR	7f195ac7-7a53-40d4-8227-d2dc86365c4c	2026-05-19 15:30:00	\N	storage	32	a431eb07-a71d-44f9-a0ba-ecac2480a3c2
0a4c7619-40e5-4568-9280-243be5246777	8d40647d-da49-4490-ada6-3bfa2205366c	46541468-ee50-4fab-bd02-4250162c40e6	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	a83eb2b3-0089-487f-8573-9745561f7dc8	2026-05-19 16:26:59.801	\N	compute	\N	\N
6051fa68-3cd2-4fd7-946e-3672b4ce208f	8d40647d-da49-4490-ada6-3bfa2205366c	8548fb98-e8da-4f26-85da-e343210f26a2	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	7535	30000	90000	INR	297bbb7a-fec5-4308-9dd7-b8dfabfaa6c0	2026-05-19 16:33:50.158	\N	compute	\N	\N
ab79feaa-6d3f-4c08-9ab7-3728605138b0	8d40647d-da49-4490-ada6-3bfa2205366c	7c24eb9b-cef9-43c9-9874-220745bc7662	d2fb06af-8256-4105-812b-05a10cbe99a1	6645	12000	24000	INR	eb9162b2-01c8-410a-b414-ff73dd1dbbde	2026-05-19 16:34:20.172	\N	compute	\N	\N
\.


--
-- TOC entry 5997 (class 0 OID 151353)
-- Dependencies: 225
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (id, user_id, organization_id, compute_config_id, node_id, required_vcpu, required_memory_mb, required_gpu_vram_mb, scheduled_start_at, scheduled_end_at, status, cancellation_reason, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 5998 (class 0 OID 151367)
-- Dependencies: 226
-- Data for Name: compute_config_access; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compute_config_access (id, compute_config_id, organization_id, role_id, is_allowed, price_override_cents, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 5999 (class 0 OID 151377)
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
-- TOC entry 6000 (class 0 OID 151404)
-- Dependencies: 228
-- Data for Name: course_enrollments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_enrollments (id, course_id, user_id, status, enrolled_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6001 (class 0 OID 151415)
-- Dependencies: 229
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (id, organization_id, department_id, instructor_id, title, code, description, semester, academic_year, status, default_compute_config_id, max_students, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6002 (class 0 OID 151429)
-- Dependencies: 230
-- Data for Name: coursework_content; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coursework_content (id, organization_id, category, title, description, content_url, thumbnail_url, difficulty_level, tags, is_featured, view_count, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6003 (class 0 OID 151444)
-- Dependencies: 231
-- Data for Name: credit_packages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.credit_packages (id, name, amount_cents, credit_cents, bonus_cents, validity_days, is_active, sort_order, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6004 (class 0 OID 151462)
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
-- TOC entry 6005 (class 0 OID 151476)
-- Dependencies: 233
-- Data for Name: discussion_replies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discussion_replies (id, discussion_id, parent_reply_id, author_id, body, is_accepted_answer, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6006 (class 0 OID 151490)
-- Dependencies: 234
-- Data for Name: discussions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discussions (id, organization_id, course_id, lab_id, author_id, title, body, is_pinned, is_locked, reply_count, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6007 (class 0 OID 151508)
-- Dependencies: 235
-- Data for Name: feature_flags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feature_flags (id, key, enabled, rollout_percent, allowed_org_ids, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6008 (class 0 OID 151522)
-- Dependencies: 236
-- Data for Name: invoice_line_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice_line_items (id, invoice_id, description, quantity, unit_price_cents, total_cents, reference_type, reference_id, created_at) FROM stdin;
95b3259e-d9a8-4715-81b2-ee94fa9cc334	272bd948-06d9-49a6-ba10-70281477c9af	Credit Recharge	1	500000	500000	payment_transaction	1acbc4e6-ec5a-4285-9344-d9ef9f71f43e	2026-05-18 06:48:37.668
1da150a2-4ee0-4a8e-bf71-221d2fe874b5	13c507b8-f0f6-4c9f-ba1f-5ce20a053b68	Credit Recharge	1	1000000	1000000	payment_transaction	80b2ca83-1f4f-4abe-aa7c-153fab0f0b7f	2026-05-18 10:55:22.437
132b5a5f-7295-4b1b-9b55-66cd56e72cb6	328dbbed-4fb9-4646-bcf2-84d56ebb240a	Credit Recharge	1	100000	100000	payment_transaction	39891e7a-1510-4e43-92c8-2b8cd34c8479	2026-05-18 11:00:35.661
\.


--
-- TOC entry 6009 (class 0 OID 151535)
-- Dependencies: 237
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoices (id, user_id, organization_id, invoice_number, period_start, period_end, subtotal_cents, tax_cents, total_cents, currency, status, issued_at, paid_at, pdf_url, created_at, updated_at, created_by, updated_by) FROM stdin;
272bd948-06d9-49a6-ba10-70281477c9af	8d40647d-da49-4490-ada6-3bfa2205366c	\N	INV-20260518-B28596	2026-05-18 06:48:37.639	2026-05-18 06:48:37.639	500000	0	500000	INR	paid	2026-05-18 06:48:37.639	2026-05-18 06:48:37.639	\N	2026-05-18 06:48:37.664	2026-05-18 06:48:37.664	\N	\N
13c507b8-f0f6-4c9f-ba1f-5ce20a053b68	8d40647d-da49-4490-ada6-3bfa2205366c	\N	INV-20260518-C808D2	2026-05-18 10:55:22.411	2026-05-18 10:55:22.411	1000000	0	1000000	INR	paid	2026-05-18 10:55:22.411	2026-05-18 10:55:22.411	\N	2026-05-18 10:55:22.428	2026-05-18 10:55:22.428	\N	\N
328dbbed-4fb9-4646-bcf2-84d56ebb240a	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	INV-20260518-1A4E07	2026-05-18 11:00:35.643	2026-05-18 11:00:35.643	100000	0	100000	INR	paid	2026-05-18 11:00:35.643	2026-05-18 11:00:35.643	\N	2026-05-18 11:00:35.659	2026-05-18 11:00:35.659	\N	\N
\.


--
-- TOC entry 6010 (class 0 OID 151555)
-- Dependencies: 238
-- Data for Name: lab_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_assignments (id, lab_id, title, description, instructions, due_at, max_score, allow_late_submission, late_penalty_percent, max_attempts, rubric, sort_order, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6011 (class 0 OID 151575)
-- Dependencies: 239
-- Data for Name: lab_grades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_grades (id, submission_id, graded_by, score, max_score, feedback, rubric_scores, graded_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6012 (class 0 OID 151586)
-- Dependencies: 240
-- Data for Name: lab_group_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_group_assignments (id, lab_id, user_group_id, assigned_by, available_from, available_until, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6013 (class 0 OID 151596)
-- Dependencies: 241
-- Data for Name: lab_submissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_submissions (id, lab_assignment_id, user_id, session_id, attempt_number, status, submitted_at, file_ids, notes, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6014 (class 0 OID 151610)
-- Dependencies: 242
-- Data for Name: labs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.labs (id, course_id, organization_id, created_by_user_id, title, description, instructions, compute_config_id, base_image_id, preloaded_notebook_url, preloaded_dataset_urls, max_duration_minutes, status, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6015 (class 0 OID 151624)
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
\.


--
-- TOC entry 6016 (class 0 OID 151634)
-- Dependencies: 244
-- Data for Name: mentor_availability_slots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_availability_slots (id, mentor_profile_id, day_of_week, specific_date, start_time, end_time, is_recurring, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6017 (class 0 OID 151648)
-- Dependencies: 245
-- Data for Name: mentor_bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_bookings (id, mentor_profile_id, student_user_id, scheduled_at, duration_minutes, status, meeting_url, payment_transaction_id, amount_cents, notes, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6018 (class 0 OID 151663)
-- Dependencies: 246
-- Data for Name: mentor_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_profiles (id, user_id, headline, bio, expertise_areas, experience_years, price_per_hour_cents, currency, is_available, avg_rating, total_reviews, total_sessions, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6019 (class 0 OID 151683)
-- Dependencies: 247
-- Data for Name: mentor_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_reviews (id, mentor_booking_id, reviewer_user_id, rating, review_text, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6020 (class 0 OID 151695)
-- Dependencies: 248
-- Data for Name: node_base_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.node_base_images (node_id, base_image_id, status, pulled_at, error_message, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6021 (class 0 OID 151706)
-- Dependencies: 249
-- Data for Name: node_resource_reservations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.node_resource_reservations (id, node_id, session_id, reserved_vcpu, reserved_memory_mb, reserved_gpu_vram_mb, reserved_hami_sm_percent, reserved_at, released_at, status, created_at, updated_at) FROM stdin;
ace5c3bb-c83a-439f-ac35-b877972d2d08	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	c4ce3860-7509-47a7-b3d6-60592b593100	12	32768	16384	67	2026-05-18 07:02:40.052	2026-05-18 07:06:38.58	released	2026-05-18 07:02:40.052	2026-05-18 07:06:38.587
4c1995e8-749c-49f9-8786-f7fd2e885f7e	c9868115-ff99-403c-8e87-06124ba7df66	b3fb45cb-ac62-41bb-b65b-babce27a14fe	12	32768	16384	67	2026-05-18 07:30:32.31	2026-05-18 07:32:37.349	released	2026-05-18 07:30:32.31	2026-05-18 07:32:37.362
0538fafd-48ba-4b1d-a10d-5a514e46b332	c9868115-ff99-403c-8e87-06124ba7df66	b0dbca4f-3348-4831-a7a6-fb319b7dfb46	12	32768	16384	67	2026-05-18 10:21:07.593	2026-05-18 17:23:42.383	released	2026-05-18 10:21:07.593	2026-05-18 17:23:42.393
5905ac3a-e556-4d12-878c-5fdbe2b7be21	c9868115-ff99-403c-8e87-06124ba7df66	968bf735-3894-4093-838d-efb4a943315d	2	4096	2048	8	2026-05-18 17:36:32.23	2026-05-18 18:02:49.401	released	2026-05-18 17:36:32.23	2026-05-18 18:02:49.41
a254566e-442a-4e86-8166-f7fa6a3afe87	c9868115-ff99-403c-8e87-06124ba7df66	46541468-ee50-4fab-bd02-4250162c40e6	2	4096	2048	8	2026-05-18 18:04:03.806	\N	reserved	2026-05-18 18:04:03.806	2026-05-18 18:04:03.806
0092c6d1-c458-49a6-918d-2d02193a875b	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	2	4096	2048	8	2026-05-18 18:37:31.864	2026-05-18 18:38:26.192	released	2026-05-18 18:37:31.864	2026-05-18 18:38:26.2
945dac32-3103-4c3b-a2d2-c8e6c8a33674	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	a50d4adb-5e31-41ba-9972-91dc118efdc0	2	4096	2048	8	2026-05-18 07:31:09.326	2026-05-19 00:23:24.854	released	2026-05-18 07:31:09.326	2026-05-19 00:23:24.86
031cc081-1a81-47ac-afbc-dc3edf032535	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	aef9cfcc-1747-4572-933e-6cf55bce8993	2	4096	2048	8	2026-05-19 00:22:02.113	2026-05-19 00:24:03.767	released	2026-05-19 00:22:02.113	2026-05-19 00:24:03.772
2da05095-1fc6-48f9-a502-0e4f5afd443e	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	fae608c4-ed05-41cd-b0b6-4134aaaa6354	8	16384	8192	33	2026-05-19 00:24:43.561	2026-05-19 00:26:10.44	released	2026-05-19 00:24:43.561	2026-05-19 00:26:10.444
37c7a6e1-4e0b-4c8f-882d-820741145d08	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	8548fb98-e8da-4f26-85da-e343210f26a2	8	16384	8192	33	2026-05-19 04:27:52.457	2026-05-19 16:33:50.132	released	2026-05-19 04:27:52.457	2026-05-19 16:33:50.138
fbb2f073-5b83-4c9f-9abc-93148cf38aa0	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	7c24eb9b-cef9-43c9-9874-220745bc7662	2	4096	2048	8	2026-05-19 12:43:12.304	2026-05-19 16:34:20.149	released	2026-05-19 12:43:12.304	2026-05-19 16:34:20.156
\.


--
-- TOC entry 6022 (class 0 OID 151724)
-- Dependencies: 250
-- Data for Name: nodes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nodes (id, hostname, display_name, ip_management, ip_compute, ip_storage, cpu_model, total_vcpu, total_memory_mb, total_gpu_vram_mb, gpu_model, nvme_total_gb, allocated_vcpu, allocated_memory_mb, allocated_gpu_vram_mb, max_concurrent_sessions, status, last_heartbeat_at, metadata, created_at, updated_at, created_by, updated_by, current_session_count, last_resource_sync_at, session_orchestration_port, storage_provision_port, nvme_of_port, storage_headroom_gb) FROM stdin;
16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	laas-node-02	LaaS Node 02 — RTX 4090	100.94.157.114	100.94.157.114	10.10.100.88	AMD Ryzen 9 7950X3D	16	65536	24576	RTX 4090	2000	0	0	0	8	healthy	2026-05-19 17:11:00.169	{"smTotal": 128, "cudaArch": "sm_89", "reservedVcpu": 2, "driverVersion": "565.x", "allocatableVcpu": 14, "reservedMemoryMb": 10240, "reservedGpuVramMb": 1024, "allocatableMemoryMb": 55296, "allocatableGpuVramMb": 23552}	2026-04-26 12:53:44.426	2026-05-19 17:11:00.171	\N	\N	0	\N	9998	9999	4420	15
c9868115-ff99-403c-8e87-06124ba7df66	laas-node-01	LaaS Node 01 — RTX 4090	100.88.57.107	100.88.57.107	10.10.100.99	AMD Ryzen 9 7950X3D	16	65536	24576	RTX 4090	2000	2	4096	2048	8	healthy	2026-05-19 17:11:00.367	{"smTotal": 128, "cudaArch": "sm_89", "reservedVcpu": 2, "driverVersion": "565.x", "allocatableVcpu": 14, "reservedMemoryMb": 10240, "reservedGpuVramMb": 1024, "allocatableMemoryMb": 55296, "allocatableGpuVramMb": 23552}	2026-04-08 01:52:12.012	2026-05-19 17:11:00.369	\N	\N	1	\N	9998	9999	4420	15
\.


--
-- TOC entry 6023 (class 0 OID 151754)
-- Dependencies: 251
-- Data for Name: notification_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_templates (id, slug, channel, subject_template, body_template, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6024 (class 0 OID 151766)
-- Dependencies: 252
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, user_id, template_id, channel, title, body, data, status, sent_at, read_at, delivery_attempts, last_delivery_error, delivery_confirmed_at, created_at) FROM stdin;
\.


--
-- TOC entry 6025 (class 0 OID 151779)
-- Dependencies: 253
-- Data for Name: org_contracts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org_contracts (id, organization_id, contract_name, starts_at, ends_at, max_seats, billing_model, total_credits_cents, used_credits_cents, status, notes, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6026 (class 0 OID 151793)
-- Dependencies: 254
-- Data for Name: org_resource_quotas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.org_resource_quotas (id, organization_id, max_concurrent_sessions_per_org, max_concurrent_stateful_per_user, max_concurrent_ephemeral_per_user, max_registered_users, max_storage_per_user_mb, allowed_session_types, max_booking_hours_per_day, max_gpu_vram_mb_total, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6027 (class 0 OID 151809)
-- Dependencies: 255
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (name, slug, logo_url, billing_email, is_active, created_at, updated_at, deleted_at, created_by, updated_by, id, org_type, university_id) FROM stdin;
Public	public	\N	\N	t	2026-04-08 01:52:11.915	2026-04-08 01:52:11.915	\N	\N	\N	07b07401-b326-4045-af3a-44a7c45e56d8	public_	\N
LaaS Academy	laas-academy	\N	\N	t	2026-04-08 01:52:11.93	2026-04-08 01:52:11.93	\N	\N	\N	0cdb29b2-5017-450d-97e4-71b80be8b535	university	\N
KSRCE	ksrce	\N	\N	t	2026-04-08 01:52:11.957	2026-04-08 01:52:11.957	\N	\N	\N	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	university	f213bc95-2fe5-4401-94c1-39efeaa39a5a
\.


--
-- TOC entry 6028 (class 0 OID 151823)
-- Dependencies: 256
-- Data for Name: os_switch_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.os_switch_history (id, user_id, old_os, new_os, old_volume_id, new_volume_id, confirmation_text, ip_address, created_at, created_by) FROM stdin;
\.


--
-- TOC entry 6029 (class 0 OID 151833)
-- Dependencies: 257
-- Data for Name: otp_verifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.otp_verifications (email, code_hash, purpose, attempts, expires_at, used_at, created_at, id, user_id) FROM stdin;
test@ksrce.in	$2b$10$ZpScYJWdj7TUsFxwM3l5QeZ5e.BEExU0IcD9N7uS7rapjxXYOg4lm	email_verification	0	2026-05-14 16:09:17.038	2026-05-14 15:59:38.553	2026-05-14 15:59:17.04	800f7b02-6b91-435c-b903-4571804be8db	\N
testuser1023@gmail.com	$2b$10$RWiTsVdB/YEojwOaFQTuPOrk8kzUMEyLlqCRJpjQK5bZEe7KkeGhG	email_verification	0	2026-05-18 05:11:24.744	2026-05-18 05:02:52.906	2026-05-18 05:01:24.745	468c9e8c-29cb-475b-aef7-d06ffe3be681	\N
\.


--
-- TOC entry 6030 (class 0 OID 151847)
-- Dependencies: 258
-- Data for Name: payment_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_transactions (id, user_id, gateway, gateway_txn_id, gateway_order_id, amount_cents, currency, status, gateway_response, refund_amount_cents, refunded_at, created_at, updated_at, created_by, updated_by) FROM stdin;
1acbc4e6-ec5a-4285-9344-d9ef9f71f43e	8d40647d-da49-4490-ada6-3bfa2205366c	razorpay	pay_SqjXmQhsI6T07I	order_SqjVyj8OktGOoT	500000	INR	completed	{"verified_at": "2026-05-18T06:48:37.639Z", "razorpay_order_id": "order_SqjVyj8OktGOoT", "razorpay_signature": "e4e10a08ef0023fbd8d99fcf86b66c721a8d91fd7469364179b37773c5c7dd3b", "razorpay_payment_id": "pay_SqjXmQhsI6T07I"}	\N	\N	2026-05-18 06:46:36.783	2026-05-18 06:48:37.65	\N	\N
80b2ca83-1f4f-4abe-aa7c-153fab0f0b7f	8d40647d-da49-4490-ada6-3bfa2205366c	razorpay	pay_SqnkNFmFcGZ5Pq	order_SqnkGQeVYCBD0l	1000000	INR	completed	{"verified_at": "2026-05-18T10:55:22.411Z", "razorpay_order_id": "order_SqnkGQeVYCBD0l", "razorpay_signature": "b009ed482310231625b7f528b4fd902221f2d5d81f815434ba542cdc2e2dbee1", "razorpay_payment_id": "pay_SqnkNFmFcGZ5Pq"}	\N	\N	2026-05-18 10:54:54.456	2026-05-18 10:55:22.419	\N	\N
0cd05c85-58c5-4b9e-89d5-c950e6ae2506	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	razorpay	\N	order_Sqnph0BM9PXQRs	500000	INR	pending	\N	\N	\N	2026-05-18 11:00:02.833	2026-05-18 11:00:02.833	\N	\N
39891e7a-1510-4e43-92c8-2b8cd34c8479	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	razorpay	pay_SqnpvbESflrYIa	order_SqnpqPtW55StmE	100000	INR	completed	{"verified_at": "2026-05-18T11:00:35.643Z", "razorpay_order_id": "order_SqnpqPtW55StmE", "razorpay_signature": "e4191ea0ecd88131f335b1b77c3a126052b0e54e073ca60094e4e226b1449f9c", "razorpay_payment_id": "pay_SqnpvbESflrYIa"}	\N	\N	2026-05-18 11:00:11.427	2026-05-18 11:00:35.646	\N	\N
\.


--
-- TOC entry 6031 (class 0 OID 151862)
-- Dependencies: 259
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (code, description, module, created_at, updated_at, created_by, updated_by, id) FROM stdin;
\.


--
-- TOC entry 6032 (class 0 OID 151872)
-- Dependencies: 260
-- Data for Name: project_showcases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_showcases (id, user_id, organization_id, title, description, project_url, thumbnail_url, tags, is_featured, view_count, like_count, status, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6033 (class 0 OID 151891)
-- Dependencies: 261
-- Data for Name: recommendation_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recommendation_sessions (id, user_id, workload_description, document_file_name, document_extracted_text, analysis_result, analysis_quality, analysis_confidence, detected_goal, detected_vram_gb, detected_intensity, detected_frameworks, selected_goal, selected_dataset_size, selected_intensity, selected_budget_type, selected_budget_amount, selected_duration, goal_auto_selected, dataset_auto_selected, intensity_auto_selected, recommendations, selected_config_slug, created_at, updated_at, completed_at) FROM stdin;
\.


--
-- TOC entry 6034 (class 0 OID 151908)
-- Dependencies: 262
-- Data for Name: referral_conversions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.referral_conversions (id, referral_id, referrer_user_id, referred_user_id, status, signup_method, signup_completed_at, first_payment_at, first_payment_amount_cents, first_payment_txn_id, reward_amount_cents, reward_status, reward_credited_at, reward_wallet_txn_id, metadata, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 6035 (class 0 OID 151929)
-- Dependencies: 263
-- Data for Name: referral_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.referral_events (id, referral_id, referral_conversion_id, event_type, previous_status, new_status, metadata, actor_type, actor_id, created_at) FROM stdin;
\.


--
-- TOC entry 6036 (class 0 OID 151940)
-- Dependencies: 264
-- Data for Name: referrals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.referrals (id, referrer_user_id, referral_code, referral_url, is_active, total_clicks, total_signups, total_rewards_cents, expires_at, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 6037 (class 0 OID 151960)
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
$2b$10$kcRYoeMxuvrOOPjPuSo2M.Lb97J7iv2ooXZdknSFZkRZtMUPu9zfq	\N	\N	2026-05-26 16:59:52.73	\N	2026-05-19 16:59:52.732	0	96484a86-f2b7-41b2-9627-78c7cac2dfee	8d40647d-da49-4490-ada6-3bfa2205366c
\.


--
-- TOC entry 6038 (class 0 OID 151973)
-- Dependencies: 266
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (role_id, permission_id) FROM stdin;
\.


--
-- TOC entry 6039 (class 0 OID 151978)
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
-- TOC entry 6040 (class 0 OID 151990)
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
\.


--
-- TOC entry 6041 (class 0 OID 152000)
-- Dependencies: 269
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, user_id, organization_id, compute_config_id, booking_id, node_id, session_type, container_id, container_name, nginx_port, selkies_port, display_number, session_token_hash, session_url, status, started_at, ended_at, scheduled_end_at, last_activity_at, nfs_mount_path, base_image_id, actual_gpu_vram_mb, actual_hami_sm_percent, reconnect_count, last_reconnect_at, auto_preserve_files, avg_rtt_ms, avg_packet_loss_ratio, resource_snapshot, created_at, updated_at, created_by, updated_by, allocated_gpu_vram_mb, allocated_hami_sm_percent, allocated_memory_mb, allocated_vcpu, allocation_snapshot_at, cost_last_updated_at, cumulative_cost_cents, duration_seconds, instance_name, storage_mode, terminated_at, terminated_by, termination_details, termination_reason, storage_node_id, storage_transport, ephemeral_storage_path, ephemeral_storage_size_mb) FROM stdin;
fae608c4-ed05-41cd-b0b6-4134aaaa6354	8d40647d-da49-4490-ada6-3bfa2205366c	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-fae608c4	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-19 00:24:59.878	2026-05-19 00:26:10.44	\N	\N	\N	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 33, "interfaceMode": "gui", "encryptedPassword": "099cad89bc81d43deb57c9205d9b601f", "encryptedPasswordIv": "8e4ab0122f05d0abf13b7267", "encryptedPasswordTag": "4cd98411942818b0e7ae9fff7e02cae9", "basePricePerHourCents": 30000}	2026-05-19 00:24:43.557	2026-05-19 00:26:10.457	\N	\N	8192	33	16384	8	2026-05-19 00:24:43.555	2026-05-19 00:26:10.44	30000	70	gpu-instance-z09o	ephemeral	2026-05-19 00:26:10.44	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_fae608c4-ed05-41cd-b0b6-4134aaaa6354	10240
7c24eb9b-cef9-43c9-9874-220745bc7662	8d40647d-da49-4490-ada6-3bfa2205366c	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-7c24eb9b	8102	9102	21	\N	http://100.94.157.114:8102/	ended	2026-05-19 12:43:34.698	2026-05-19 16:34:20.149	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "eb57876edab503a47892aca91f06a5ee", "encryptedPasswordIv": "3182ab9c96bc3e7b2dd875bc", "encryptedPasswordTag": "16032cf0e1e9a4d5606c99a14391f1f7", "basePricePerHourCents": 12000}	2026-05-19 12:43:12.285	2026-05-19 16:34:20.175	\N	\N	2048	8	4096	2	2026-05-19 12:43:12.282	2026-05-19 16:34:20.149	48000	13845	gpu-instance-0ybq	ephemeral	2026-05-19 16:34:20.149	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_7c24eb9b-cef9-43c9-9874-220745bc7662	10240
c4ce3860-7509-47a7-b3d6-60592b593100	8d40647d-da49-4490-ada6-3bfa2205366c	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-c4ce3860	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-18 07:03:02.446	2026-05-18 07:06:38.58	\N	\N	/mnt/nfs/users/u_962b82c8054e7213ac9a4938	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "544a40bb83dcbd9a67b391f43be12bc5", "encryptedPasswordIv": "c91bbc6e16fbecf81d7f2183", "encryptedPasswordTag": "49c7b62673afe8991d7c04aaefd97cb4", "basePricePerHourCents": 36000}	2026-05-18 07:02:40.036	2026-05-18 07:06:38.6	\N	\N	16384	67	32768	12	2026-05-18 07:02:40.033	2026-05-18 07:06:38.58	36000	216	gpu-instance-8gmm	stateful	2026-05-18 07:06:38.58	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	nvmeof_tcp	\N	\N
b3fb45cb-ac62-41bb-b65b-babce27a14fe	8d40647d-da49-4490-ada6-3bfa2205366c	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-b3fb45cb	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-18 07:30:52.701	2026-05-18 07:32:37.349	\N	\N	/mnt/nfs/users/u_962b82c8054e7213ac9a4938	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "stateful", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "e9cb8ef9531a5ed57c730eeaaf602a8c", "encryptedPasswordIv": "527c4d0b7764ab5beaf42671", "encryptedPasswordTag": "7f1f870729e272ac06607a8106d854f9", "basePricePerHourCents": 36000}	2026-05-18 07:30:32.3	2026-05-18 07:32:37.383	\N	\N	16384	67	32768	12	2026-05-18 07:30:32.297	2026-05-18 07:32:37.349	36000	104	gpu-instance-bw3i	stateful	2026-05-18 07:32:37.349	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	c9868115-ff99-403c-8e87-06124ba7df66	local_zfs	\N	\N
a50d4adb-5e31-41ba-9972-91dc118efdc0	8d40647d-da49-4490-ada6-3bfa2205366c	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-a50d4adb	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-18 07:31:29.681	2026-05-19 00:23:24.854	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "02ff8d3c13fa35a655af76246516a0d2", "encryptedPasswordIv": "98e1aaf672250d07ce2cff0f", "encryptedPasswordTag": "259f69750a3585c17723b5cfd58e87c6", "basePricePerHourCents": 12000}	2026-05-18 07:31:09.313	2026-05-19 00:23:24.885	\N	\N	2048	8	4096	2	2026-05-18 07:31:09.31	2026-05-19 00:23:24.854	204000	60715	gpu-instance-5ef5	ephemeral	2026-05-19 00:23:24.854	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_a50d4adb-5e31-41ba-9972-91dc118efdc0	10240
aef9cfcc-1747-4572-933e-6cf55bce8993	8d40647d-da49-4490-ada6-3bfa2205366c	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-aef9cfcc	8102	9102	21	\N	http://100.94.157.114:8102/	ended	2026-05-19 00:22:22.454	2026-05-19 00:24:03.767	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "e8ee63e24e9dd881bd7fd998c5c9312a", "encryptedPasswordIv": "e23da4c54e25e56d0dc95769", "encryptedPasswordTag": "75a41351d42cb40b2c7726030afd9ce3", "basePricePerHourCents": 12000}	2026-05-19 00:22:02.103	2026-05-19 00:24:03.786	\N	\N	2048	8	4096	2	2026-05-19 00:22:02.101	2026-05-19 00:24:03.767	12000	101	gpu-instance-fn5b	ephemeral	2026-05-19 00:24:03.767	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_aef9cfcc-1747-4572-933e-6cf55bce8993	10240
968bf735-3894-4093-838d-efb4a943315d	8d40647d-da49-4490-ada6-3bfa2205366c	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-968bf735	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-18 17:36:54.654	2026-05-18 18:02:49.401	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "b610a510e2e0383d33b86950fbd026d8", "encryptedPasswordIv": "d678f5992faae2535f70754c", "encryptedPasswordTag": "e485661c43c75f4a53bac50775cc29fe", "basePricePerHourCents": 12000}	2026-05-18 17:36:32.224	2026-05-18 18:02:49.432	\N	\N	2048	8	4096	2	2026-05-18 17:36:32.221	2026-05-18 18:02:49.401	12000	1554	gpu-instance-i0m9	ephemeral	2026-05-18 18:02:49.401	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_968bf735-3894-4093-838d-efb4a943315d	10240
b0dbca4f-3348-4831-a7a6-fb319b7dfb46	8d40647d-da49-4490-ada6-3bfa2205366c	\N	28a49cc2-a6c4-4387-a93f-9d48c153bb6e	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-b0dbca4f	8101	9101	20	\N	http://100.88.57.107:8101/	ended	2026-05-18 10:21:28.098	2026-05-18 17:23:42.383	\N	\N	\N	\N	16384	67	0	\N	f	\N	\N	{"vcpu": 12, "gpuModel": "RTX 4090", "memoryMb": 32768, "gpuVramMb": 16384, "configName": "Supernova", "configSlug": "supernova", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 67, "interfaceMode": "gui", "encryptedPassword": "e7c301bc46ecb79dc6efb7be51e55892", "encryptedPasswordIv": "e64bd2b0bab71acd8253df68", "encryptedPasswordTag": "414cbd612c78db1c6004dd877dddc3e6", "basePricePerHourCents": 36000}	2026-05-18 10:21:07.572	2026-05-18 17:23:42.454	\N	\N	16384	67	32768	12	2026-05-18 10:21:07.57	2026-05-18 17:23:42.383	288000	25334	gpu-instance-64uh	ephemeral	2026-05-18 17:23:42.383	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_b0dbca4f-3348-4831-a7a6-fb319b7dfb46	10240
8548fb98-e8da-4f26-85da-e343210f26a2	8d40647d-da49-4490-ada6-3bfa2205366c	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-8548fb98	8101	9101	20	\N	http://100.94.157.114:8101/	ended	2026-05-19 04:28:15.105	2026-05-19 16:33:50.132	\N	\N	\N	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 33, "interfaceMode": "gui", "encryptedPassword": "b536b9e8bdcd1a9fd10d9ce8fdced326", "encryptedPasswordIv": "2ece6b8d8e50afa0f5465b88", "encryptedPasswordTag": "1a7182454f92da0c0602cfcff5cf2d7b", "basePricePerHourCents": 30000}	2026-05-19 04:27:52.444	2026-05-19 16:33:50.161	\N	\N	8192	33	16384	8	2026-05-19 04:27:52.44	2026-05-19 16:33:50.132	390000	43535	gpu-instance-gsim	ephemeral	2026-05-19 16:33:50.132	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_8548fb98-e8da-4f26-85da-e343210f26a2	10240
46541468-ee50-4fab-bd02-4250162c40e6	8d40647d-da49-4490-ada6-3bfa2205366c	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	c9868115-ff99-403c-8e87-06124ba7df66	stateful_desktop	\N	laas-46541468	8101	9101	20	\N	http://100.88.57.107:8101/	running	2026-05-18 18:04:26.436	\N	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-01", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "fcf9eedbab0532808ffbe916c39e4bf5", "encryptedPasswordIv": "bc979e511c0636e32be4d238", "encryptedPasswordTag": "b310c85adb23982c2998776ebd5bc0a6", "basePricePerHourCents": 12000}	2026-05-18 18:04:03.796	2026-05-19 16:26:59.938	\N	\N	2048	8	4096	2	2026-05-18 18:04:03.795	2026-05-19 16:26:59.935	192000	\N	gpu-instance-06p0	ephemeral	\N	\N	\N	\N	\N	\N	/datapool/ephemeral/sess_46541468-ee50-4fab-bd02-4250162c40e6	10240
b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	8d40647d-da49-4490-ada6-3bfa2205366c	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-b46a1616	8102	9102	21	\N	http://100.94.157.114:8102/	ended	2026-05-18 18:37:54.449	2026-05-18 18:38:26.192	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "53ee15a3c1942744a75dbdf8efa0fb8d", "encryptedPasswordIv": "6411314de0972c5c518a109f", "encryptedPasswordTag": "38c33ebdba5bf71c2a4da2dc78ef2897", "basePricePerHourCents": 12000}	2026-05-18 18:37:31.856	2026-05-18 18:38:26.21	\N	\N	2048	8	4096	2	2026-05-18 18:37:31.855	2026-05-18 18:38:26.192	12000	31	gpu-instance-ytlg	ephemeral	2026-05-18 18:38:26.192	8d40647d-da49-4490-ada6-3bfa2205366c	\N	user_requested	\N	\N	/datapool/ephemeral/sess_b46a1616-26bc-4ab6-ad34-5bf01f2ff0fe	10240
\.


--
-- TOC entry 6042 (class 0 OID 152021)
-- Dependencies: 270
-- Data for Name: storage_extensions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.storage_extensions (id, user_id, storage_volume_id, extension_type, previous_quota_bytes, new_quota_bytes, extension_bytes, amount_cents, currency, payment_transaction_id, wallet_transaction_id, notes, created_at, created_by) FROM stdin;
0d44515f-42fb-4167-ab33-5054cbaf706a	8d40647d-da49-4490-ada6-3bfa2205366c	ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	user_upgrade	10737418240	12884901888	2147483648	0	INR	\N	\N	\N	2026-05-18 16:27:53.761	\N
4af803ef-9872-47e4-947d-54984bd35e31	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	user_upgrade	20401094656	27917287424	7516192768	0	INR	\N	\N	\N	2026-05-18 16:31:34.71	\N
908c0bf3-82c5-4dd0-9c47-db836f4e71ad	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	a431eb07-a71d-44f9-a0ba-ecac2480a3c2	user_upgrade	27917287424	34359738368	6442450944	0	INR	\N	\N	\N	2026-05-18 16:32:48.321	\N
\.


--
-- TOC entry 6043 (class 0 OID 152039)
-- Dependencies: 271
-- Data for Name: subscription_plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscription_plans (id, slug, name, description, price_cents, currency, billing_period, gpu_hours_included, mentor_sessions_included, features, is_active, sort_order, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6044 (class 0 OID 152059)
-- Dependencies: 272
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscriptions (id, user_id, plan_id, organization_id, status, starts_at, ends_at, gpu_hours_remaining, mentor_sessions_remaining, auto_renew, cancellation_requested_at, cancel_at_period_end, grace_period_until, payment_transaction_id, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6045 (class 0 OID 152074)
-- Dependencies: 273
-- Data for Name: support_tickets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.support_tickets (id, user_id, organization_id, subject, description, category, priority, status, assigned_to, related_session_id, related_billing_id, resolved_at, resolution_notes, satisfaction_rating, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6046 (class 0 OID 152090)
-- Dependencies: 274
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_settings (id, key, value, value_type, description, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6047 (class 0 OID 152101)
-- Dependencies: 275
-- Data for Name: ticket_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ticket_messages (id, ticket_id, sender_id, body, is_internal, attachments, created_at) FROM stdin;
\.


--
-- TOC entry 6048 (class 0 OID 152114)
-- Dependencies: 276
-- Data for Name: universities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.universities (id, name, short_name, slug, domain_suffixes, logo_url, website_url, contact_email, contact_phone, city, state, country, timezone, is_active, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
f213bc95-2fe5-4401-94c1-39efeaa39a5a	K.S. Rangasamy College of Engineering	KSRCE	ksrce	{@ksrce.in}	\N	\N	\N	\N	\N	\N	IN	Asia/Kolkata	t	2026-04-08 01:52:11.94	2026-05-15 07:32:20.399	\N	\N	\N
\.


--
-- TOC entry 6049 (class 0 OID 152129)
-- Dependencies: 277
-- Data for Name: university_idp_configs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.university_idp_configs (id, university_id, idp_type, idp_entity_id, idp_metadata_url, idp_config, keycloak_idp_alias, display_name, is_primary, is_active, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6050 (class 0 OID 152144)
-- Dependencies: 278
-- Data for Name: user_achievements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_achievements (id, user_id, achievement_id, earned_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6051 (class 0 OID 152154)
-- Dependencies: 279
-- Data for Name: user_deletion_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_deletion_requests (id, user_id, requested_at, requested_by, reason, grace_period_days, scheduled_deletion_at, status, cancelled_at, completed_at, completion_details, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6052 (class 0 OID 152169)
-- Dependencies: 280
-- Data for Name: user_departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_departments (id, user_id, department_id, is_primary, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6053 (class 0 OID 152180)
-- Dependencies: 281
-- Data for Name: user_feedback; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_feedback (id, user_id, session_id, feedback_type, rating, subject, body, status, admin_response, responded_by, responded_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6054 (class 0 OID 152193)
-- Dependencies: 282
-- Data for Name: user_files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_files (id, user_id, file_name, file_path, file_size_bytes, mime_type, file_type, session_id, is_pinned, storage_backend, retention_days, scheduled_deletion_at, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6055 (class 0 OID 152207)
-- Dependencies: 283
-- Data for Name: user_group_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_group_members (id, user_id, user_group_id, added_by, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6056 (class 0 OID 152216)
-- Dependencies: 284
-- Data for Name: user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_groups (id, organization_id, department_id, parent_id, group_type, name, slug, description, keycloak_group_id, max_members, is_active, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- TOC entry 6057 (class 0 OID 152229)
-- Dependencies: 285
-- Data for Name: user_org_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_org_roles (expires_at, created_at, updated_at, created_by, updated_by, id, user_id, organization_id, role_id, granted_by) FROM stdin;
\N	2026-05-15 07:33:03.993	2026-05-15 07:33:03.993	\N	\N	61ff92ba-a2c2-49ec-8aed-009e74d51569	9f08f905-999a-4c6f-87bc-66e29dc6301e	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	c99954e1-3820-442c-a1cb-33f9cde68672	\N
\N	2026-05-15 07:33:04.025	2026-05-15 07:33:04.025	\N	\N	a8b4dec5-8557-420f-ba33-3363c93a0993	bd8f8f80-a9ab-43e9-999f-b653f359e4c9	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	ee7518c5-3ed0-4025-8aa5-d5c0eca54787	\N
\N	2026-05-18 06:45:42.647	2026-05-18 06:45:42.647	\N	\N	27799c01-1abb-4b47-9967-0eb31637a3cd	8d40647d-da49-4490-ada6-3bfa2205366c	07b07401-b326-4045-af3a-44a7c45e56d8	42abadfe-edfa-4b0e-985d-adaa65091959	\N
\N	2026-05-18 10:59:22.7	2026-05-18 10:59:22.7	\N	\N	40a89406-8ef3-4080-87f5-4d7d0a8f4b43	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	07b07401-b326-4045-af3a-44a7c45e56d8	42abadfe-edfa-4b0e-985d-adaa65091959	\N
\.


--
-- TOC entry 6058 (class 0 OID 152239)
-- Dependencies: 286
-- Data for Name: user_policy_consents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_policy_consents (policy_slug, policy_version, agreed_at, ip_address, created_at, created_by, id, user_id) FROM stdin;
\.


--
-- TOC entry 6059 (class 0 OID 152250)
-- Dependencies: 287
-- Data for Name: user_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profiles (id, user_id, bio, enrollment_number, id_proof_url, id_proof_verified_at, id_proof_verified_by, college_name, graduation_year, github_url, linkedin_url, website_url, skills, theme_preference, notification_preferences, created_at, updated_at, created_by, updated_by, country, expertise_level, onboarding_complete, operational_domains, profession, use_case_other, use_case_purposes, years_of_experience, academic_year, course_name, department_id) FROM stdin;
96edc69d-088e-484e-a30c-2e8c19c43068	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	dark	{}	2026-05-18 06:24:46.859	2026-05-18 06:24:46.859	\N	\N	IN	beginner	t	{video_editing}	researcher	\N	{ai_ml_training,FFmpeg}	1	\N	\N	\N
7282be68-0846-46b9-90a5-6e3badaab0bf	8d40647d-da49-4490-ada6-3bfa2205366c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	dark	{}	2026-05-18 06:45:42.628	2026-05-18 06:45:57.371	\N	\N	IN	beginner	t	{software_eng}	engineer	\N	{ai_ml_training,Docker}	1	\N	\N	\N
f2872790-6011-43ae-8a52-152016ace508	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	dark	{}	2026-05-18 10:59:22.689	2026-05-18 10:59:44.246	\N	\N	IN	beginner	t	{data_science}	engineer	\N	{ai_ml_training,Jupyter}	1	\N	\N	\N
\.


--
-- TOC entry 6060 (class 0 OID 152266)
-- Dependencies: 288
-- Data for Name: user_storage_volumes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_storage_volumes (id, user_id, storage_uid, zfs_dataset_path, nfs_export_path, container_mount_path, os_choice, quota_bytes, used_bytes, used_bytes_updated_at, status, provisioned_at, wiped_at, wipe_reason, quota_warning_sent_at, created_at, updated_at, created_by, updated_by, allocation_type, name, price_per_gb_cents_month, node_id, storage_backend) FROM stdin;
ddfb6075-3dc0-4d41-bb24-d6b0c7b721f5	8d40647d-da49-4490-ada6-3bfa2205366c	u_962b82c8054e7213ac9a4938	datapool/users/u_962b82c8054e7213ac9a4938	/mnt/nfs/users/u_962b82c8054e7213ac9a4938	\N	ubuntu22	12884901888	0	\N	active	2026-05-18 12:19:22.583	\N	\N	\N	2026-05-18 12:19:22.583	2026-05-18 16:28:05.054	\N	8d40647d-da49-4490-ada6-3bfa2205366c	user_created	ea10	700	c9868115-ff99-403c-8e87-06124ba7df66	zfs_zvol
593577fd-a234-4a8b-9145-b14e68d89f2f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	u_ca53f137ba9f971180a53958	datapool/users/u_ca53f137ba9f971180a53958	/mnt/nfs/users/u_ca53f137ba9f971180a53958	\N	ubuntu22	34359738368	0	\N	wiped	2026-05-18 16:30:52.72	2026-05-18 16:31:09.243	User requested deletion via API	\N	2026-05-18 16:30:52.72	2026-05-18 16:31:09.243	\N	\N	user_created	es1023	700	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	zfs_zvol
a431eb07-a71d-44f9-a0ba-ecac2480a3c2	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	u_7d736bf08d7ea480732f9778	datapool/users/u_7d736bf08d7ea480732f9778	/mnt/nfs/users/u_7d736bf08d7ea480732f9778	\N	ubuntu22	34359738368	0	\N	active	2026-05-18 16:31:27.074	\N	\N	\N	2026-05-18 16:31:27.074	2026-05-18 16:32:48.321	\N	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	user_created	ef23	700	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	zfs_zvol
\.


--
-- TOC entry 6061 (class 0 OID 152288)
-- Dependencies: 289
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (email, email_verified_at, password_hash, first_name, last_name, display_name, avatar_url, phone, timezone, keycloak_sub, auth_type, oauth_provider, storage_uid, token_version, two_factor_enabled, last_login_at, last_login_ip, onboarding_completed_at, is_active, created_at, updated_at, deleted_at, storage_provisioned_at, storage_provisioning_error, storage_provisioning_status, created_by, keycloak_last_sync_at, lock_expires_at, lock_reason, locked_at, os_choice, pending_email, updated_by, id, default_org_id, referred_by_code) FROM stdin;
punith.vs74064@gmail.com	\N	\N	Punith	VS	\N	\N	\N	Asia/Kolkata	0fbe8ba9-74c2-4b3a-9d22-5cde9d40ee64	public_oauth	keycloak	u_962b82c8054e7213ac9a4938	0	f	2026-05-19 16:33:21.387	127.0.0.1	\N	t	2026-05-18 06:45:42.602	2026-05-19 16:33:21.39	\N	2026-05-18 12:19:22.588	\N	provisioned	\N	\N	\N	\N	\N	\N	\N	\N	8d40647d-da49-4490-ada6-3bfa2205366c	07b07401-b326-4045-af3a-44a7c45e56d8	\N
it_admin@ksrce.in	\N	$2b$10$JTOY2w1Bt8D2YbJYeRBaPueFREpcgRtBDgb3WRvTP0mLd.FcPMlh2	IT	Administrator	\N	\N	\N	Asia/Kolkata	\N	public_local	\N	\N	0	f	2026-05-15 07:58:44.492	127.0.0.1	\N	t	2026-05-15 07:33:04.015	2026-05-15 07:58:44.494	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	bd8f8f80-a9ab-43e9-999f-b653f359e4c9	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	\N
business_lead@ksrce.in	\N	$2b$10$JTOY2w1Bt8D2YbJYeRBaPueFREpcgRtBDgb3WRvTP0mLd.FcPMlh2	Business-Lead	Lead	\N	\N	\N	Asia/Kolkata	\N	public_local	\N	\N	0	f	2026-05-19 16:31:38.535	127.0.0.1	\N	t	2026-05-15 07:33:03.975	2026-05-19 16:31:38.537	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	9f08f905-999a-4c6f-87bc-66e29dc6301e	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	\N
viswanaths365@gmail.com	\N	\N	Punith	VS	\N	\N	\N	Asia/Kolkata	3fe2b6fe-6c48-47a7-ae6b-da52eef70660	public_oauth	keycloak	u_7d736bf08d7ea480732f9778	0	f	2026-05-18 10:59:24.467	127.0.0.1	\N	t	2026-05-18 10:59:22.677	2026-05-18 16:31:27.078	\N	2026-05-18 16:31:27.078	\N	provisioned	\N	\N	\N	\N	\N	\N	\N	\N	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	07b07401-b326-4045-af3a-44a7c45e56d8	\N
\.


--
-- TOC entry 6062 (class 0 OID 152308)
-- Dependencies: 290
-- Data for Name: waitlist_entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.waitlist_entries (id, "userId", email, "firstName", "lastName", "currentStatus", "organizationName", "jobTitle", "computeNeeds", "expectedDuration", urgency, expectations, "primaryWorkload", "workloadDescription", "agreedToPolicy", "policyAgreedAt", "agreedToComms", status, "createdAt", "updatedAt") FROM stdin;
\.


--
-- TOC entry 6063 (class 0 OID 152324)
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
\.


--
-- TOC entry 6064 (class 0 OID 152336)
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
\.


--
-- TOC entry 6065 (class 0 OID 152349)
-- Dependencies: 293
-- Data for Name: wallets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wallets (id, user_id, balance_cents, currency, lifetime_credits_cents, lifetime_spent_cents, low_balance_threshold_cents, is_frozen, created_at, updated_at, created_by, updated_by, spend_limit_cents, spend_limit_enabled, spend_limit_period, spend_limit_consented_at, spend_limit_end_date, spend_limit_start_date, spend_limit_warning_85_sent, runway_warning_1hour_sent) FROM stdin;
a1082b1c-426e-4c23-bac1-22163e41d27f	a980afc8-0b97-4300-97e1-bfd7ecd4b0b6	99442	INR	100000	558	10000	f	2026-05-18 11:00:35.649	2026-05-19 16:26:59.545	\N	\N	\N	f	\N	\N	\N	\N	f	f
59cacef5-8bc3-4eba-aaa1-c8e70ac9ce3c	8d40647d-da49-4490-ada6-3bfa2205366c	455804	INR	1500000	1260256	10000	f	2026-05-18 06:48:37.655	2026-05-19 16:34:20.17	\N	\N	\N	f	\N	\N	\N	\N	f	f
\.


--
-- TOC entry 5401 (class 2606 OID 152378)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 5403 (class 2606 OID 152380)
-- Name: achievements achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- TOC entry 5407 (class 2606 OID 152382)
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- TOC entry 5414 (class 2606 OID 152384)
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- TOC entry 5418 (class 2606 OID 152386)
-- Name: base_images base_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_images
    ADD CONSTRAINT base_images_pkey PRIMARY KEY (id);


--
-- TOC entry 5421 (class 2606 OID 152388)
-- Name: billing_charges billing_charges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_pkey PRIMARY KEY (id);


--
-- TOC entry 5427 (class 2606 OID 152390)
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- TOC entry 5432 (class 2606 OID 152392)
-- Name: compute_config_access compute_config_access_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_config_access
    ADD CONSTRAINT compute_config_access_pkey PRIMARY KEY (id);


--
-- TOC entry 5436 (class 2606 OID 152394)
-- Name: compute_configs compute_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_configs
    ADD CONSTRAINT compute_configs_pkey PRIMARY KEY (id);


--
-- TOC entry 5443 (class 2606 OID 152396)
-- Name: course_enrollments course_enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_pkey PRIMARY KEY (id);


--
-- TOC entry 5448 (class 2606 OID 152398)
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- TOC entry 5453 (class 2606 OID 152400)
-- Name: coursework_content coursework_content_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coursework_content
    ADD CONSTRAINT coursework_content_pkey PRIMARY KEY (id);


--
-- TOC entry 5456 (class 2606 OID 152402)
-- Name: credit_packages credit_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_packages
    ADD CONSTRAINT credit_packages_pkey PRIMARY KEY (id);


--
-- TOC entry 5460 (class 2606 OID 152404)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- TOC entry 5466 (class 2606 OID 152406)
-- Name: discussion_replies discussion_replies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_pkey PRIMARY KEY (id);


--
-- TOC entry 5471 (class 2606 OID 152408)
-- Name: discussions discussions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_pkey PRIMARY KEY (id);


--
-- TOC entry 5474 (class 2606 OID 152410)
-- Name: feature_flags feature_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_flags
    ADD CONSTRAINT feature_flags_pkey PRIMARY KEY (id);


--
-- TOC entry 5476 (class 2606 OID 152412)
-- Name: invoice_line_items invoice_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_line_items
    ADD CONSTRAINT invoice_line_items_pkey PRIMARY KEY (id);


--
-- TOC entry 5479 (class 2606 OID 152414)
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- TOC entry 5484 (class 2606 OID 152416)
-- Name: lab_assignments lab_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_assignments
    ADD CONSTRAINT lab_assignments_pkey PRIMARY KEY (id);


--
-- TOC entry 5486 (class 2606 OID 152418)
-- Name: lab_grades lab_grades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_grades
    ADD CONSTRAINT lab_grades_pkey PRIMARY KEY (id);


--
-- TOC entry 5490 (class 2606 OID 152420)
-- Name: lab_group_assignments lab_group_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_group_assignments
    ADD CONSTRAINT lab_group_assignments_pkey PRIMARY KEY (id);


--
-- TOC entry 5493 (class 2606 OID 152422)
-- Name: lab_submissions lab_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_submissions
    ADD CONSTRAINT lab_submissions_pkey PRIMARY KEY (id);


--
-- TOC entry 5499 (class 2606 OID 152424)
-- Name: labs labs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_pkey PRIMARY KEY (id);


--
-- TOC entry 5501 (class 2606 OID 152426)
-- Name: login_history login_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_pkey PRIMARY KEY (id);


--
-- TOC entry 5503 (class 2606 OID 152428)
-- Name: mentor_availability_slots mentor_availability_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_availability_slots
    ADD CONSTRAINT mentor_availability_slots_pkey PRIMARY KEY (id);


--
-- TOC entry 5506 (class 2606 OID 152430)
-- Name: mentor_bookings mentor_bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_bookings
    ADD CONSTRAINT mentor_bookings_pkey PRIMARY KEY (id);


--
-- TOC entry 5509 (class 2606 OID 152432)
-- Name: mentor_profiles mentor_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_profiles
    ADD CONSTRAINT mentor_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 5513 (class 2606 OID 152434)
-- Name: mentor_reviews mentor_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_reviews
    ADD CONSTRAINT mentor_reviews_pkey PRIMARY KEY (id);


--
-- TOC entry 5515 (class 2606 OID 152436)
-- Name: node_base_images node_base_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_base_images
    ADD CONSTRAINT node_base_images_pkey PRIMARY KEY (node_id, base_image_id);


--
-- TOC entry 5520 (class 2606 OID 152438)
-- Name: node_resource_reservations node_resource_reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_resource_reservations
    ADD CONSTRAINT node_resource_reservations_pkey PRIMARY KEY (id);


--
-- TOC entry 5528 (class 2606 OID 152440)
-- Name: nodes nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nodes
    ADD CONSTRAINT nodes_pkey PRIMARY KEY (id);


--
-- TOC entry 5531 (class 2606 OID 152442)
-- Name: notification_templates notification_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_templates
    ADD CONSTRAINT notification_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 5534 (class 2606 OID 152444)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 5538 (class 2606 OID 152446)
-- Name: org_contracts org_contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_contracts
    ADD CONSTRAINT org_contracts_pkey PRIMARY KEY (id);


--
-- TOC entry 5542 (class 2606 OID 152448)
-- Name: org_resource_quotas org_resource_quotas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_resource_quotas
    ADD CONSTRAINT org_resource_quotas_pkey PRIMARY KEY (id);


--
-- TOC entry 5544 (class 2606 OID 152450)
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- TOC entry 5548 (class 2606 OID 152452)
-- Name: os_switch_history os_switch_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_switch_history
    ADD CONSTRAINT os_switch_history_pkey PRIMARY KEY (id);


--
-- TOC entry 5551 (class 2606 OID 152454)
-- Name: otp_verifications otp_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_verifications
    ADD CONSTRAINT otp_verifications_pkey PRIMARY KEY (id);


--
-- TOC entry 5554 (class 2606 OID 152456)
-- Name: payment_transactions payment_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 5559 (class 2606 OID 152458)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 5562 (class 2606 OID 152460)
-- Name: project_showcases project_showcases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_showcases
    ADD CONSTRAINT project_showcases_pkey PRIMARY KEY (id);


--
-- TOC entry 5566 (class 2606 OID 152462)
-- Name: recommendation_sessions recommendation_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recommendation_sessions
    ADD CONSTRAINT recommendation_sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 5569 (class 2606 OID 152464)
-- Name: referral_conversions referral_conversions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_conversions
    ADD CONSTRAINT referral_conversions_pkey PRIMARY KEY (id);


--
-- TOC entry 5576 (class 2606 OID 152466)
-- Name: referral_events referral_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_events
    ADD CONSTRAINT referral_events_pkey PRIMARY KEY (id);


--
-- TOC entry 5579 (class 2606 OID 152468)
-- Name: referrals referrals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_pkey PRIMARY KEY (id);


--
-- TOC entry 5585 (class 2606 OID 152470)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 5587 (class 2606 OID 152472)
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- TOC entry 5590 (class 2606 OID 152474)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 5593 (class 2606 OID 152476)
-- Name: session_events session_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_events
    ADD CONSTRAINT session_events_pkey PRIMARY KEY (id);


--
-- TOC entry 5600 (class 2606 OID 152478)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 5607 (class 2606 OID 152480)
-- Name: storage_extensions storage_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_pkey PRIMARY KEY (id);


--
-- TOC entry 5611 (class 2606 OID 152482)
-- Name: subscription_plans subscription_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_plans
    ADD CONSTRAINT subscription_plans_pkey PRIMARY KEY (id);


--
-- TOC entry 5616 (class 2606 OID 152484)
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- TOC entry 5621 (class 2606 OID 152486)
-- Name: support_tickets support_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_pkey PRIMARY KEY (id);


--
-- TOC entry 5625 (class 2606 OID 152488)
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 5627 (class 2606 OID 152490)
-- Name: ticket_messages ticket_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_messages
    ADD CONSTRAINT ticket_messages_pkey PRIMARY KEY (id);


--
-- TOC entry 5630 (class 2606 OID 152492)
-- Name: universities universities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.universities
    ADD CONSTRAINT universities_pkey PRIMARY KEY (id);


--
-- TOC entry 5633 (class 2606 OID 152494)
-- Name: university_idp_configs university_idp_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.university_idp_configs
    ADD CONSTRAINT university_idp_configs_pkey PRIMARY KEY (id);


--
-- TOC entry 5636 (class 2606 OID 152496)
-- Name: user_achievements user_achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_pkey PRIMARY KEY (id);


--
-- TOC entry 5639 (class 2606 OID 152498)
-- Name: user_deletion_requests user_deletion_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_deletion_requests
    ADD CONSTRAINT user_deletion_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 5645 (class 2606 OID 152500)
-- Name: user_departments user_departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_departments
    ADD CONSTRAINT user_departments_pkey PRIMARY KEY (id);


--
-- TOC entry 5649 (class 2606 OID 152502)
-- Name: user_feedback user_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_pkey PRIMARY KEY (id);


--
-- TOC entry 5653 (class 2606 OID 152504)
-- Name: user_files user_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_files
    ADD CONSTRAINT user_files_pkey PRIMARY KEY (id);


--
-- TOC entry 5657 (class 2606 OID 152506)
-- Name: user_group_members user_group_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_members
    ADD CONSTRAINT user_group_members_pkey PRIMARY KEY (id);


--
-- TOC entry 5665 (class 2606 OID 152508)
-- Name: user_groups user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 5667 (class 2606 OID 152510)
-- Name: user_org_roles user_org_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_org_roles
    ADD CONSTRAINT user_org_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 5670 (class 2606 OID 152512)
-- Name: user_policy_consents user_policy_consents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_policy_consents
    ADD CONSTRAINT user_policy_consents_pkey PRIMARY KEY (id);


--
-- TOC entry 5672 (class 2606 OID 152514)
-- Name: user_profiles user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 5677 (class 2606 OID 152516)
-- Name: user_storage_volumes user_storage_volumes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_storage_volumes
    ADD CONSTRAINT user_storage_volumes_pkey PRIMARY KEY (id);


--
-- TOC entry 5683 (class 2606 OID 152518)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 5688 (class 2606 OID 152520)
-- Name: waitlist_entries waitlist_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waitlist_entries
    ADD CONSTRAINT waitlist_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 5692 (class 2606 OID 152522)
-- Name: wallet_holds wallet_holds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_pkey PRIMARY KEY (id);


--
-- TOC entry 5695 (class 2606 OID 152524)
-- Name: wallet_transactions wallet_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_transactions
    ADD CONSTRAINT wallet_transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 5700 (class 2606 OID 152526)
-- Name: wallets wallets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT wallets_pkey PRIMARY KEY (id);


--
-- TOC entry 5404 (class 1259 OID 152527)
-- Name: achievements_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX achievements_slug_key ON public.achievements USING btree (slug);


--
-- TOC entry 5405 (class 1259 OID 152528)
-- Name: announcements_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX announcements_organization_id_idx ON public.announcements USING btree (organization_id);


--
-- TOC entry 5408 (class 1259 OID 152529)
-- Name: announcements_published_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX announcements_published_at_idx ON public.announcements USING btree (published_at);


--
-- TOC entry 5409 (class 1259 OID 152530)
-- Name: audit_log_action_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_action_idx ON public.audit_log USING btree (action);


--
-- TOC entry 5410 (class 1259 OID 152531)
-- Name: audit_log_actor_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_actor_id_idx ON public.audit_log USING btree (actor_id);


--
-- TOC entry 5411 (class 1259 OID 152532)
-- Name: audit_log_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_created_at_idx ON public.audit_log USING btree (created_at);


--
-- TOC entry 5412 (class 1259 OID 152533)
-- Name: audit_log_org_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_org_id_idx ON public.audit_log USING btree (org_id);


--
-- TOC entry 5415 (class 1259 OID 152534)
-- Name: audit_log_resource_type_resource_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_log_resource_type_resource_id_idx ON public.audit_log USING btree (resource_type, resource_id);


--
-- TOC entry 5416 (class 1259 OID 152535)
-- Name: base_images_is_default_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX base_images_is_default_idx ON public.base_images USING btree (is_default);


--
-- TOC entry 5419 (class 1259 OID 152536)
-- Name: base_images_tag_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX base_images_tag_key ON public.base_images USING btree (tag);


--
-- TOC entry 5422 (class 1259 OID 152537)
-- Name: billing_charges_session_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX billing_charges_session_id_idx ON public.billing_charges USING btree (session_id);


--
-- TOC entry 5423 (class 1259 OID 152538)
-- Name: billing_charges_storage_volume_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX billing_charges_storage_volume_id_idx ON public.billing_charges USING btree (storage_volume_id);


--
-- TOC entry 5424 (class 1259 OID 152539)
-- Name: billing_charges_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX billing_charges_user_id_created_at_idx ON public.billing_charges USING btree (user_id, created_at);


--
-- TOC entry 5425 (class 1259 OID 152540)
-- Name: bookings_node_id_scheduled_start_at_scheduled_end_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bookings_node_id_scheduled_start_at_scheduled_end_at_idx ON public.bookings USING btree (node_id, scheduled_start_at, scheduled_end_at);


--
-- TOC entry 5428 (class 1259 OID 152541)
-- Name: bookings_user_id_status_scheduled_start_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bookings_user_id_status_scheduled_start_at_idx ON public.bookings USING btree (user_id, status, scheduled_start_at);


--
-- TOC entry 5429 (class 1259 OID 152542)
-- Name: compute_config_access_compute_config_id_organization_id_rol_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX compute_config_access_compute_config_id_organization_id_rol_key ON public.compute_config_access USING btree (compute_config_id, organization_id, role_id);


--
-- TOC entry 5430 (class 1259 OID 152543)
-- Name: compute_config_access_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_config_access_organization_id_idx ON public.compute_config_access USING btree (organization_id);


--
-- TOC entry 5433 (class 1259 OID 152544)
-- Name: compute_config_access_role_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_config_access_role_id_idx ON public.compute_config_access USING btree (role_id);


--
-- TOC entry 5434 (class 1259 OID 152545)
-- Name: compute_configs_is_active_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_configs_is_active_idx ON public.compute_configs USING btree (is_active);


--
-- TOC entry 5437 (class 1259 OID 152546)
-- Name: compute_configs_session_type_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_configs_session_type_idx ON public.compute_configs USING btree (session_type);


--
-- TOC entry 5438 (class 1259 OID 152547)
-- Name: compute_configs_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX compute_configs_slug_key ON public.compute_configs USING btree (slug);


--
-- TOC entry 5439 (class 1259 OID 152548)
-- Name: compute_configs_sort_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX compute_configs_sort_order_idx ON public.compute_configs USING btree (sort_order);


--
-- TOC entry 5440 (class 1259 OID 152549)
-- Name: course_enrollments_course_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX course_enrollments_course_id_idx ON public.course_enrollments USING btree (course_id);


--
-- TOC entry 5441 (class 1259 OID 152550)
-- Name: course_enrollments_course_id_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX course_enrollments_course_id_user_id_key ON public.course_enrollments USING btree (course_id, user_id);


--
-- TOC entry 5444 (class 1259 OID 152551)
-- Name: course_enrollments_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX course_enrollments_user_id_idx ON public.course_enrollments USING btree (user_id);


--
-- TOC entry 5445 (class 1259 OID 152552)
-- Name: courses_instructor_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX courses_instructor_id_idx ON public.courses USING btree (instructor_id);


--
-- TOC entry 5446 (class 1259 OID 152553)
-- Name: courses_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX courses_organization_id_idx ON public.courses USING btree (organization_id);


--
-- TOC entry 5449 (class 1259 OID 152554)
-- Name: courses_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX courses_status_idx ON public.courses USING btree (status);


--
-- TOC entry 5450 (class 1259 OID 152555)
-- Name: coursework_content_category_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX coursework_content_category_idx ON public.coursework_content USING btree (category);


--
-- TOC entry 5451 (class 1259 OID 152556)
-- Name: coursework_content_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX coursework_content_organization_id_idx ON public.coursework_content USING btree (organization_id);


--
-- TOC entry 5454 (class 1259 OID 152557)
-- Name: credit_packages_is_active_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX credit_packages_is_active_idx ON public.credit_packages USING btree (is_active);


--
-- TOC entry 5457 (class 1259 OID 152558)
-- Name: credit_packages_sort_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX credit_packages_sort_order_idx ON public.credit_packages USING btree (sort_order);


--
-- TOC entry 5458 (class 1259 OID 152559)
-- Name: departments_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX departments_parent_id_idx ON public.departments USING btree (parent_id);


--
-- TOC entry 5461 (class 1259 OID 152560)
-- Name: departments_university_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX departments_university_id_idx ON public.departments USING btree (university_id);


--
-- TOC entry 5462 (class 1259 OID 152561)
-- Name: departments_university_id_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX departments_university_id_slug_key ON public.departments USING btree (university_id, slug);


--
-- TOC entry 5463 (class 1259 OID 152562)
-- Name: discussion_replies_author_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussion_replies_author_id_idx ON public.discussion_replies USING btree (author_id);


--
-- TOC entry 5464 (class 1259 OID 152563)
-- Name: discussion_replies_discussion_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussion_replies_discussion_id_idx ON public.discussion_replies USING btree (discussion_id);


--
-- TOC entry 5467 (class 1259 OID 152564)
-- Name: discussions_author_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussions_author_id_idx ON public.discussions USING btree (author_id);


--
-- TOC entry 5468 (class 1259 OID 152565)
-- Name: discussions_course_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussions_course_id_idx ON public.discussions USING btree (course_id);


--
-- TOC entry 5469 (class 1259 OID 152566)
-- Name: discussions_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discussions_organization_id_idx ON public.discussions USING btree (organization_id);


--
-- TOC entry 5472 (class 1259 OID 152567)
-- Name: feature_flags_key_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX feature_flags_key_key ON public.feature_flags USING btree (key);


--
-- TOC entry 5477 (class 1259 OID 152568)
-- Name: invoices_invoice_number_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX invoices_invoice_number_key ON public.invoices USING btree (invoice_number);


--
-- TOC entry 5480 (class 1259 OID 152569)
-- Name: invoices_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX invoices_status_idx ON public.invoices USING btree (status);


--
-- TOC entry 5481 (class 1259 OID 152570)
-- Name: invoices_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX invoices_user_id_created_at_idx ON public.invoices USING btree (user_id, created_at);


--
-- TOC entry 5482 (class 1259 OID 152571)
-- Name: lab_assignments_lab_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lab_assignments_lab_id_idx ON public.lab_assignments USING btree (lab_id);


--
-- TOC entry 5487 (class 1259 OID 152572)
-- Name: lab_grades_submission_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX lab_grades_submission_id_key ON public.lab_grades USING btree (submission_id);


--
-- TOC entry 5488 (class 1259 OID 152573)
-- Name: lab_group_assignments_lab_id_user_group_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX lab_group_assignments_lab_id_user_group_id_key ON public.lab_group_assignments USING btree (lab_id, user_group_id);


--
-- TOC entry 5491 (class 1259 OID 152574)
-- Name: lab_submissions_lab_assignment_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lab_submissions_lab_assignment_id_idx ON public.lab_submissions USING btree (lab_assignment_id);


--
-- TOC entry 5494 (class 1259 OID 152575)
-- Name: lab_submissions_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lab_submissions_user_id_idx ON public.lab_submissions USING btree (user_id);


--
-- TOC entry 5495 (class 1259 OID 152576)
-- Name: labs_course_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX labs_course_id_idx ON public.labs USING btree (course_id);


--
-- TOC entry 5496 (class 1259 OID 152577)
-- Name: labs_created_by_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX labs_created_by_user_id_idx ON public.labs USING btree (created_by_user_id);


--
-- TOC entry 5497 (class 1259 OID 152578)
-- Name: labs_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX labs_organization_id_idx ON public.labs USING btree (organization_id);


--
-- TOC entry 5504 (class 1259 OID 152579)
-- Name: mentor_bookings_mentor_profile_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_bookings_mentor_profile_id_idx ON public.mentor_bookings USING btree (mentor_profile_id);


--
-- TOC entry 5507 (class 1259 OID 152580)
-- Name: mentor_bookings_student_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mentor_bookings_student_user_id_idx ON public.mentor_bookings USING btree (student_user_id);


--
-- TOC entry 5510 (class 1259 OID 152581)
-- Name: mentor_profiles_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX mentor_profiles_user_id_key ON public.mentor_profiles USING btree (user_id);


--
-- TOC entry 5511 (class 1259 OID 152582)
-- Name: mentor_reviews_mentor_booking_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX mentor_reviews_mentor_booking_id_key ON public.mentor_reviews USING btree (mentor_booking_id);


--
-- TOC entry 5516 (class 1259 OID 152583)
-- Name: node_base_images_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX node_base_images_status_idx ON public.node_base_images USING btree (status);


--
-- TOC entry 5517 (class 1259 OID 152584)
-- Name: node_resource_reservations_node_id_session_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX node_resource_reservations_node_id_session_id_key ON public.node_resource_reservations USING btree (node_id, session_id);


--
-- TOC entry 5518 (class 1259 OID 152585)
-- Name: node_resource_reservations_node_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX node_resource_reservations_node_id_status_idx ON public.node_resource_reservations USING btree (node_id, status);


--
-- TOC entry 5521 (class 1259 OID 152586)
-- Name: node_resource_reservations_released_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX node_resource_reservations_released_at_idx ON public.node_resource_reservations USING btree (released_at);


--
-- TOC entry 5522 (class 1259 OID 152587)
-- Name: node_resource_reservations_session_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX node_resource_reservations_session_id_idx ON public.node_resource_reservations USING btree (session_id);


--
-- TOC entry 5523 (class 1259 OID 152588)
-- Name: node_resource_reservations_session_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX node_resource_reservations_session_id_key ON public.node_resource_reservations USING btree (session_id);


--
-- TOC entry 5524 (class 1259 OID 152589)
-- Name: nodes_hostname_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX nodes_hostname_key ON public.nodes USING btree (hostname);


--
-- TOC entry 5525 (class 1259 OID 152590)
-- Name: nodes_last_heartbeat_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nodes_last_heartbeat_at_idx ON public.nodes USING btree (last_heartbeat_at);


--
-- TOC entry 5526 (class 1259 OID 152591)
-- Name: nodes_last_resource_sync_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nodes_last_resource_sync_at_idx ON public.nodes USING btree (last_resource_sync_at);


--
-- TOC entry 5529 (class 1259 OID 152592)
-- Name: nodes_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nodes_status_idx ON public.nodes USING btree (status);


--
-- TOC entry 5532 (class 1259 OID 152593)
-- Name: notification_templates_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX notification_templates_slug_key ON public.notification_templates USING btree (slug);


--
-- TOC entry 5535 (class 1259 OID 152594)
-- Name: notifications_user_id_status_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notifications_user_id_status_created_at_idx ON public.notifications USING btree (user_id, status, created_at);


--
-- TOC entry 5536 (class 1259 OID 152595)
-- Name: org_contracts_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX org_contracts_organization_id_idx ON public.org_contracts USING btree (organization_id);


--
-- TOC entry 5539 (class 1259 OID 152596)
-- Name: org_contracts_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX org_contracts_status_idx ON public.org_contracts USING btree (status);


--
-- TOC entry 5540 (class 1259 OID 152597)
-- Name: org_resource_quotas_organization_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX org_resource_quotas_organization_id_key ON public.org_resource_quotas USING btree (organization_id);


--
-- TOC entry 5545 (class 1259 OID 152598)
-- Name: organizations_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX organizations_slug_key ON public.organizations USING btree (slug);


--
-- TOC entry 5546 (class 1259 OID 152599)
-- Name: os_switch_history_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX os_switch_history_created_at_idx ON public.os_switch_history USING btree (created_at);


--
-- TOC entry 5549 (class 1259 OID 152600)
-- Name: os_switch_history_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX os_switch_history_user_id_idx ON public.os_switch_history USING btree (user_id);


--
-- TOC entry 5552 (class 1259 OID 152601)
-- Name: payment_transactions_gateway_txn_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX payment_transactions_gateway_txn_id_key ON public.payment_transactions USING btree (gateway_txn_id);


--
-- TOC entry 5555 (class 1259 OID 152602)
-- Name: payment_transactions_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_transactions_status_idx ON public.payment_transactions USING btree (status);


--
-- TOC entry 5556 (class 1259 OID 152603)
-- Name: payment_transactions_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_transactions_user_id_created_at_idx ON public.payment_transactions USING btree (user_id, created_at);


--
-- TOC entry 5557 (class 1259 OID 152604)
-- Name: permissions_code_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX permissions_code_key ON public.permissions USING btree (code);


--
-- TOC entry 5560 (class 1259 OID 152605)
-- Name: project_showcases_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX project_showcases_organization_id_idx ON public.project_showcases USING btree (organization_id);


--
-- TOC entry 5563 (class 1259 OID 152606)
-- Name: project_showcases_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX project_showcases_user_id_idx ON public.project_showcases USING btree (user_id);


--
-- TOC entry 5564 (class 1259 OID 152607)
-- Name: recommendation_sessions_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recommendation_sessions_created_at_idx ON public.recommendation_sessions USING btree (created_at);


--
-- TOC entry 5567 (class 1259 OID 152608)
-- Name: recommendation_sessions_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recommendation_sessions_user_id_idx ON public.recommendation_sessions USING btree (user_id);


--
-- TOC entry 5570 (class 1259 OID 152609)
-- Name: referral_conversions_referral_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_conversions_referral_id_status_idx ON public.referral_conversions USING btree (referral_id, status);


--
-- TOC entry 5571 (class 1259 OID 152610)
-- Name: referral_conversions_referred_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX referral_conversions_referred_user_id_key ON public.referral_conversions USING btree (referred_user_id);


--
-- TOC entry 5572 (class 1259 OID 152611)
-- Name: referral_conversions_referrer_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_conversions_referrer_user_id_idx ON public.referral_conversions USING btree (referrer_user_id);


--
-- TOC entry 5573 (class 1259 OID 152612)
-- Name: referral_conversions_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_conversions_status_idx ON public.referral_conversions USING btree (status);


--
-- TOC entry 5574 (class 1259 OID 152613)
-- Name: referral_events_event_type_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_events_event_type_idx ON public.referral_events USING btree (event_type);


--
-- TOC entry 5577 (class 1259 OID 152614)
-- Name: referral_events_referral_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referral_events_referral_id_created_at_idx ON public.referral_events USING btree (referral_id, created_at);


--
-- TOC entry 5580 (class 1259 OID 152615)
-- Name: referrals_referral_code_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referrals_referral_code_idx ON public.referrals USING btree (referral_code);


--
-- TOC entry 5581 (class 1259 OID 152616)
-- Name: referrals_referral_code_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX referrals_referral_code_key ON public.referrals USING btree (referral_code);


--
-- TOC entry 5582 (class 1259 OID 152617)
-- Name: referrals_referrer_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX referrals_referrer_user_id_idx ON public.referrals USING btree (referrer_user_id);


--
-- TOC entry 5583 (class 1259 OID 152618)
-- Name: referrals_referrer_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX referrals_referrer_user_id_key ON public.referrals USING btree (referrer_user_id);


--
-- TOC entry 5588 (class 1259 OID 152619)
-- Name: roles_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX roles_name_key ON public.roles USING btree (name);


--
-- TOC entry 5591 (class 1259 OID 152620)
-- Name: session_events_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX session_events_created_at_idx ON public.session_events USING btree (created_at);


--
-- TOC entry 5594 (class 1259 OID 152621)
-- Name: session_events_session_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX session_events_session_id_idx ON public.session_events USING btree (session_id);


--
-- TOC entry 5595 (class 1259 OID 152622)
-- Name: sessions_booking_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX sessions_booking_id_key ON public.sessions USING btree (booking_id);


--
-- TOC entry 5596 (class 1259 OID 152623)
-- Name: sessions_compute_config_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_compute_config_id_idx ON public.sessions USING btree (compute_config_id);


--
-- TOC entry 5597 (class 1259 OID 152624)
-- Name: sessions_instance_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_instance_name_idx ON public.sessions USING btree (instance_name);


--
-- TOC entry 5598 (class 1259 OID 152625)
-- Name: sessions_node_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_node_id_status_idx ON public.sessions USING btree (node_id, status);


--
-- TOC entry 5601 (class 1259 OID 152626)
-- Name: sessions_started_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_started_at_idx ON public.sessions USING btree (started_at);


--
-- TOC entry 5602 (class 1259 OID 152627)
-- Name: sessions_storage_mode_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_storage_mode_idx ON public.sessions USING btree (storage_mode);


--
-- TOC entry 5603 (class 1259 OID 152628)
-- Name: sessions_storage_node_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_storage_node_id_idx ON public.sessions USING btree (storage_node_id);


--
-- TOC entry 5604 (class 1259 OID 152629)
-- Name: sessions_user_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_user_id_status_idx ON public.sessions USING btree (user_id, status);


--
-- TOC entry 5605 (class 1259 OID 152630)
-- Name: storage_extensions_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX storage_extensions_created_at_idx ON public.storage_extensions USING btree (created_at);


--
-- TOC entry 5608 (class 1259 OID 152631)
-- Name: storage_extensions_storage_volume_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX storage_extensions_storage_volume_id_idx ON public.storage_extensions USING btree (storage_volume_id);


--
-- TOC entry 5609 (class 1259 OID 152632)
-- Name: storage_extensions_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX storage_extensions_user_id_idx ON public.storage_extensions USING btree (user_id);


--
-- TOC entry 5612 (class 1259 OID 152633)
-- Name: subscription_plans_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX subscription_plans_slug_key ON public.subscription_plans USING btree (slug);


--
-- TOC entry 5613 (class 1259 OID 152634)
-- Name: subscription_plans_sort_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subscription_plans_sort_order_idx ON public.subscription_plans USING btree (sort_order);


--
-- TOC entry 5614 (class 1259 OID 152635)
-- Name: subscriptions_ends_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subscriptions_ends_at_idx ON public.subscriptions USING btree (ends_at);


--
-- TOC entry 5617 (class 1259 OID 152636)
-- Name: subscriptions_user_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subscriptions_user_id_status_idx ON public.subscriptions USING btree (user_id, status);


--
-- TOC entry 5618 (class 1259 OID 152637)
-- Name: support_tickets_assigned_to_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX support_tickets_assigned_to_status_idx ON public.support_tickets USING btree (assigned_to, status);


--
-- TOC entry 5619 (class 1259 OID 152638)
-- Name: support_tickets_organization_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX support_tickets_organization_id_status_idx ON public.support_tickets USING btree (organization_id, status);


--
-- TOC entry 5622 (class 1259 OID 152639)
-- Name: support_tickets_user_id_status_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX support_tickets_user_id_status_created_at_idx ON public.support_tickets USING btree (user_id, status, created_at);


--
-- TOC entry 5623 (class 1259 OID 152640)
-- Name: system_settings_key_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX system_settings_key_key ON public.system_settings USING btree (key);


--
-- TOC entry 5628 (class 1259 OID 152641)
-- Name: ticket_messages_ticket_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ticket_messages_ticket_id_created_at_idx ON public.ticket_messages USING btree (ticket_id, created_at);


--
-- TOC entry 5631 (class 1259 OID 152642)
-- Name: universities_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX universities_slug_key ON public.universities USING btree (slug);


--
-- TOC entry 5634 (class 1259 OID 152643)
-- Name: university_idp_configs_university_id_idp_type_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX university_idp_configs_university_id_idp_type_key ON public.university_idp_configs USING btree (university_id, idp_type);


--
-- TOC entry 5637 (class 1259 OID 152644)
-- Name: user_achievements_user_id_achievement_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_achievements_user_id_achievement_id_key ON public.user_achievements USING btree (user_id, achievement_id);


--
-- TOC entry 5640 (class 1259 OID 152645)
-- Name: user_deletion_requests_scheduled_deletion_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_deletion_requests_scheduled_deletion_at_idx ON public.user_deletion_requests USING btree (scheduled_deletion_at);


--
-- TOC entry 5641 (class 1259 OID 152646)
-- Name: user_deletion_requests_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_deletion_requests_status_idx ON public.user_deletion_requests USING btree (status);


--
-- TOC entry 5642 (class 1259 OID 152647)
-- Name: user_deletion_requests_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_deletion_requests_user_id_idx ON public.user_deletion_requests USING btree (user_id);


--
-- TOC entry 5643 (class 1259 OID 152648)
-- Name: user_departments_department_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_departments_department_id_idx ON public.user_departments USING btree (department_id);


--
-- TOC entry 5646 (class 1259 OID 152649)
-- Name: user_departments_user_id_department_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_departments_user_id_department_id_key ON public.user_departments USING btree (user_id, department_id);


--
-- TOC entry 5647 (class 1259 OID 152650)
-- Name: user_departments_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_departments_user_id_idx ON public.user_departments USING btree (user_id);


--
-- TOC entry 5650 (class 1259 OID 152651)
-- Name: user_feedback_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_feedback_user_id_created_at_idx ON public.user_feedback USING btree (user_id, created_at);


--
-- TOC entry 5651 (class 1259 OID 152652)
-- Name: user_files_deleted_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_files_deleted_at_idx ON public.user_files USING btree (deleted_at);


--
-- TOC entry 5654 (class 1259 OID 152653)
-- Name: user_files_scheduled_deletion_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_files_scheduled_deletion_at_idx ON public.user_files USING btree (scheduled_deletion_at);


--
-- TOC entry 5655 (class 1259 OID 152654)
-- Name: user_files_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_files_user_id_idx ON public.user_files USING btree (user_id);


--
-- TOC entry 5658 (class 1259 OID 152655)
-- Name: user_group_members_user_group_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_group_members_user_group_id_idx ON public.user_group_members USING btree (user_group_id);


--
-- TOC entry 5659 (class 1259 OID 152656)
-- Name: user_group_members_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_group_members_user_id_idx ON public.user_group_members USING btree (user_id);


--
-- TOC entry 5660 (class 1259 OID 152657)
-- Name: user_group_members_user_id_user_group_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_group_members_user_id_user_group_id_key ON public.user_group_members USING btree (user_id, user_group_id);


--
-- TOC entry 5661 (class 1259 OID 152658)
-- Name: user_groups_department_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_groups_department_id_idx ON public.user_groups USING btree (department_id);


--
-- TOC entry 5662 (class 1259 OID 152659)
-- Name: user_groups_organization_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_groups_organization_id_idx ON public.user_groups USING btree (organization_id);


--
-- TOC entry 5663 (class 1259 OID 152660)
-- Name: user_groups_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_groups_parent_id_idx ON public.user_groups USING btree (parent_id);


--
-- TOC entry 5668 (class 1259 OID 152661)
-- Name: user_org_roles_user_id_organization_id_role_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_org_roles_user_id_organization_id_role_id_key ON public.user_org_roles USING btree (user_id, organization_id, role_id);


--
-- TOC entry 5673 (class 1259 OID 152662)
-- Name: user_profiles_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_profiles_user_id_key ON public.user_profiles USING btree (user_id);


--
-- TOC entry 5674 (class 1259 OID 152663)
-- Name: user_storage_volumes_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_storage_volumes_created_at_idx ON public.user_storage_volumes USING btree (created_at);


--
-- TOC entry 5675 (class 1259 OID 152664)
-- Name: user_storage_volumes_node_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_storage_volumes_node_id_idx ON public.user_storage_volumes USING btree (node_id);


--
-- TOC entry 5678 (class 1259 OID 152665)
-- Name: user_storage_volumes_user_id_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_storage_volumes_user_id_name_key ON public.user_storage_volumes USING btree (user_id, name);


--
-- TOC entry 5679 (class 1259 OID 152666)
-- Name: user_storage_volumes_user_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_storage_volumes_user_id_status_idx ON public.user_storage_volumes USING btree (user_id, status);


--
-- TOC entry 5680 (class 1259 OID 152667)
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- TOC entry 5681 (class 1259 OID 152668)
-- Name: users_keycloak_sub_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_keycloak_sub_key ON public.users USING btree (keycloak_sub);


--
-- TOC entry 5684 (class 1259 OID 152669)
-- Name: users_storage_uid_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_storage_uid_key ON public.users USING btree (storage_uid);


--
-- TOC entry 5685 (class 1259 OID 152670)
-- Name: waitlist_entries_createdAt_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "waitlist_entries_createdAt_idx" ON public.waitlist_entries USING btree ("createdAt");


--
-- TOC entry 5686 (class 1259 OID 152671)
-- Name: waitlist_entries_email_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX waitlist_entries_email_idx ON public.waitlist_entries USING btree (email);


--
-- TOC entry 5689 (class 1259 OID 152672)
-- Name: waitlist_entries_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX waitlist_entries_status_idx ON public.waitlist_entries USING btree (status);


--
-- TOC entry 5690 (class 1259 OID 152673)
-- Name: wallet_holds_expires_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallet_holds_expires_at_idx ON public.wallet_holds USING btree (expires_at);


--
-- TOC entry 5693 (class 1259 OID 152674)
-- Name: wallet_holds_wallet_id_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallet_holds_wallet_id_status_idx ON public.wallet_holds USING btree (wallet_id, status);


--
-- TOC entry 5696 (class 1259 OID 152675)
-- Name: wallet_transactions_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallet_transactions_user_id_created_at_idx ON public.wallet_transactions USING btree (user_id, created_at);


--
-- TOC entry 5697 (class 1259 OID 152676)
-- Name: wallet_transactions_wallet_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallet_transactions_wallet_id_created_at_idx ON public.wallet_transactions USING btree (wallet_id, created_at);


--
-- TOC entry 5698 (class 1259 OID 152677)
-- Name: wallets_balance_cents_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wallets_balance_cents_idx ON public.wallets USING btree (balance_cents);


--
-- TOC entry 5701 (class 1259 OID 152678)
-- Name: wallets_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX wallets_user_id_key ON public.wallets USING btree (user_id);


--
-- TOC entry 5702 (class 2606 OID 152679)
-- Name: announcements announcements_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5703 (class 2606 OID 152684)
-- Name: audit_log audit_log_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5704 (class 2606 OID 152689)
-- Name: audit_log audit_log_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5705 (class 2606 OID 152694)
-- Name: billing_charges billing_charges_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5706 (class 2606 OID 152699)
-- Name: billing_charges billing_charges_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5707 (class 2606 OID 152704)
-- Name: billing_charges billing_charges_storage_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_storage_volume_id_fkey FOREIGN KEY (storage_volume_id) REFERENCES public.user_storage_volumes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5708 (class 2606 OID 152709)
-- Name: billing_charges billing_charges_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5709 (class 2606 OID 152714)
-- Name: billing_charges billing_charges_wallet_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_wallet_transaction_id_fkey FOREIGN KEY (wallet_transaction_id) REFERENCES public.wallet_transactions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5710 (class 2606 OID 152719)
-- Name: bookings bookings_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5711 (class 2606 OID 152724)
-- Name: bookings bookings_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5712 (class 2606 OID 152729)
-- Name: bookings bookings_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5713 (class 2606 OID 152734)
-- Name: bookings bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5714 (class 2606 OID 152739)
-- Name: compute_config_access compute_config_access_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_config_access
    ADD CONSTRAINT compute_config_access_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5715 (class 2606 OID 152744)
-- Name: compute_config_access compute_config_access_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_config_access
    ADD CONSTRAINT compute_config_access_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5716 (class 2606 OID 152749)
-- Name: compute_config_access compute_config_access_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compute_config_access
    ADD CONSTRAINT compute_config_access_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5717 (class 2606 OID 152754)
-- Name: course_enrollments course_enrollments_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5718 (class 2606 OID 152759)
-- Name: course_enrollments course_enrollments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5719 (class 2606 OID 152764)
-- Name: courses courses_default_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_default_compute_config_id_fkey FOREIGN KEY (default_compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5720 (class 2606 OID 152769)
-- Name: courses courses_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5721 (class 2606 OID 152774)
-- Name: courses courses_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5722 (class 2606 OID 152779)
-- Name: courses courses_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5723 (class 2606 OID 152784)
-- Name: coursework_content coursework_content_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coursework_content
    ADD CONSTRAINT coursework_content_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5724 (class 2606 OID 152789)
-- Name: departments departments_head_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_head_user_id_fkey FOREIGN KEY (head_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5725 (class 2606 OID 152794)
-- Name: departments departments_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5726 (class 2606 OID 152799)
-- Name: departments departments_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5727 (class 2606 OID 152804)
-- Name: discussion_replies discussion_replies_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5728 (class 2606 OID 152809)
-- Name: discussion_replies discussion_replies_discussion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_discussion_id_fkey FOREIGN KEY (discussion_id) REFERENCES public.discussions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5729 (class 2606 OID 152814)
-- Name: discussion_replies discussion_replies_parent_reply_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_parent_reply_id_fkey FOREIGN KEY (parent_reply_id) REFERENCES public.discussion_replies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5730 (class 2606 OID 152819)
-- Name: discussions discussions_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5731 (class 2606 OID 152824)
-- Name: discussions discussions_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5732 (class 2606 OID 152829)
-- Name: discussions discussions_lab_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_lab_id_fkey FOREIGN KEY (lab_id) REFERENCES public.labs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5733 (class 2606 OID 152834)
-- Name: discussions discussions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5734 (class 2606 OID 152839)
-- Name: invoice_line_items invoice_line_items_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_line_items
    ADD CONSTRAINT invoice_line_items_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5735 (class 2606 OID 152844)
-- Name: invoices invoices_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5736 (class 2606 OID 152849)
-- Name: invoices invoices_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5737 (class 2606 OID 152854)
-- Name: lab_assignments lab_assignments_lab_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_assignments
    ADD CONSTRAINT lab_assignments_lab_id_fkey FOREIGN KEY (lab_id) REFERENCES public.labs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5738 (class 2606 OID 152859)
-- Name: lab_grades lab_grades_graded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_grades
    ADD CONSTRAINT lab_grades_graded_by_fkey FOREIGN KEY (graded_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5739 (class 2606 OID 152864)
-- Name: lab_grades lab_grades_submission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_grades
    ADD CONSTRAINT lab_grades_submission_id_fkey FOREIGN KEY (submission_id) REFERENCES public.lab_submissions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5740 (class 2606 OID 152869)
-- Name: lab_group_assignments lab_group_assignments_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_group_assignments
    ADD CONSTRAINT lab_group_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5741 (class 2606 OID 152874)
-- Name: lab_group_assignments lab_group_assignments_lab_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_group_assignments
    ADD CONSTRAINT lab_group_assignments_lab_id_fkey FOREIGN KEY (lab_id) REFERENCES public.labs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5742 (class 2606 OID 152879)
-- Name: lab_group_assignments lab_group_assignments_user_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_group_assignments
    ADD CONSTRAINT lab_group_assignments_user_group_id_fkey FOREIGN KEY (user_group_id) REFERENCES public.user_groups(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5743 (class 2606 OID 152884)
-- Name: lab_submissions lab_submissions_lab_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_submissions
    ADD CONSTRAINT lab_submissions_lab_assignment_id_fkey FOREIGN KEY (lab_assignment_id) REFERENCES public.lab_assignments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5744 (class 2606 OID 152889)
-- Name: lab_submissions lab_submissions_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_submissions
    ADD CONSTRAINT lab_submissions_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5745 (class 2606 OID 152894)
-- Name: lab_submissions lab_submissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_submissions
    ADD CONSTRAINT lab_submissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5746 (class 2606 OID 152899)
-- Name: labs labs_base_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_base_image_id_fkey FOREIGN KEY (base_image_id) REFERENCES public.base_images(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5747 (class 2606 OID 152904)
-- Name: labs labs_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5748 (class 2606 OID 152909)
-- Name: labs labs_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5749 (class 2606 OID 152914)
-- Name: labs labs_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5750 (class 2606 OID 152919)
-- Name: labs labs_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labs
    ADD CONSTRAINT labs_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5751 (class 2606 OID 152924)
-- Name: login_history login_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5752 (class 2606 OID 152929)
-- Name: mentor_availability_slots mentor_availability_slots_mentor_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_availability_slots
    ADD CONSTRAINT mentor_availability_slots_mentor_profile_id_fkey FOREIGN KEY (mentor_profile_id) REFERENCES public.mentor_profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5753 (class 2606 OID 152934)
-- Name: mentor_bookings mentor_bookings_mentor_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_bookings
    ADD CONSTRAINT mentor_bookings_mentor_profile_id_fkey FOREIGN KEY (mentor_profile_id) REFERENCES public.mentor_profiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5754 (class 2606 OID 152939)
-- Name: mentor_bookings mentor_bookings_payment_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_bookings
    ADD CONSTRAINT mentor_bookings_payment_transaction_id_fkey FOREIGN KEY (payment_transaction_id) REFERENCES public.payment_transactions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5755 (class 2606 OID 152944)
-- Name: mentor_bookings mentor_bookings_student_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_bookings
    ADD CONSTRAINT mentor_bookings_student_user_id_fkey FOREIGN KEY (student_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5756 (class 2606 OID 152949)
-- Name: mentor_profiles mentor_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_profiles
    ADD CONSTRAINT mentor_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5757 (class 2606 OID 152954)
-- Name: mentor_reviews mentor_reviews_mentor_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_reviews
    ADD CONSTRAINT mentor_reviews_mentor_booking_id_fkey FOREIGN KEY (mentor_booking_id) REFERENCES public.mentor_bookings(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5758 (class 2606 OID 152959)
-- Name: mentor_reviews mentor_reviews_reviewer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_reviews
    ADD CONSTRAINT mentor_reviews_reviewer_user_id_fkey FOREIGN KEY (reviewer_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5759 (class 2606 OID 152964)
-- Name: node_base_images node_base_images_base_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_base_images
    ADD CONSTRAINT node_base_images_base_image_id_fkey FOREIGN KEY (base_image_id) REFERENCES public.base_images(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5760 (class 2606 OID 152969)
-- Name: node_base_images node_base_images_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_base_images
    ADD CONSTRAINT node_base_images_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5761 (class 2606 OID 152974)
-- Name: node_resource_reservations node_resource_reservations_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_resource_reservations
    ADD CONSTRAINT node_resource_reservations_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5762 (class 2606 OID 152979)
-- Name: node_resource_reservations node_resource_reservations_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_resource_reservations
    ADD CONSTRAINT node_resource_reservations_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5763 (class 2606 OID 152984)
-- Name: notifications notifications_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.notification_templates(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5764 (class 2606 OID 152989)
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5765 (class 2606 OID 152994)
-- Name: org_contracts org_contracts_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_contracts
    ADD CONSTRAINT org_contracts_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5766 (class 2606 OID 152999)
-- Name: org_resource_quotas org_resource_quotas_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.org_resource_quotas
    ADD CONSTRAINT org_resource_quotas_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5767 (class 2606 OID 153004)
-- Name: organizations organizations_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5768 (class 2606 OID 153009)
-- Name: os_switch_history os_switch_history_new_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_switch_history
    ADD CONSTRAINT os_switch_history_new_volume_id_fkey FOREIGN KEY (new_volume_id) REFERENCES public.user_storage_volumes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5769 (class 2606 OID 153014)
-- Name: os_switch_history os_switch_history_old_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_switch_history
    ADD CONSTRAINT os_switch_history_old_volume_id_fkey FOREIGN KEY (old_volume_id) REFERENCES public.user_storage_volumes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5770 (class 2606 OID 153019)
-- Name: os_switch_history os_switch_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_switch_history
    ADD CONSTRAINT os_switch_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5771 (class 2606 OID 153024)
-- Name: otp_verifications otp_verifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_verifications
    ADD CONSTRAINT otp_verifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5772 (class 2606 OID 153029)
-- Name: payment_transactions payment_transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5773 (class 2606 OID 153034)
-- Name: project_showcases project_showcases_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_showcases
    ADD CONSTRAINT project_showcases_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5774 (class 2606 OID 153039)
-- Name: project_showcases project_showcases_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_showcases
    ADD CONSTRAINT project_showcases_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5775 (class 2606 OID 153044)
-- Name: recommendation_sessions recommendation_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recommendation_sessions
    ADD CONSTRAINT recommendation_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5776 (class 2606 OID 153049)
-- Name: referral_conversions referral_conversions_referral_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_conversions
    ADD CONSTRAINT referral_conversions_referral_id_fkey FOREIGN KEY (referral_id) REFERENCES public.referrals(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5777 (class 2606 OID 153054)
-- Name: referral_conversions referral_conversions_referred_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_conversions
    ADD CONSTRAINT referral_conversions_referred_user_id_fkey FOREIGN KEY (referred_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5778 (class 2606 OID 153059)
-- Name: referral_conversions referral_conversions_referrer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_conversions
    ADD CONSTRAINT referral_conversions_referrer_user_id_fkey FOREIGN KEY (referrer_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5779 (class 2606 OID 153064)
-- Name: referral_events referral_events_referral_conversion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_events
    ADD CONSTRAINT referral_events_referral_conversion_id_fkey FOREIGN KEY (referral_conversion_id) REFERENCES public.referral_conversions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5780 (class 2606 OID 153069)
-- Name: referral_events referral_events_referral_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referral_events
    ADD CONSTRAINT referral_events_referral_id_fkey FOREIGN KEY (referral_id) REFERENCES public.referrals(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5781 (class 2606 OID 153074)
-- Name: referrals referrals_referrer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_referrer_user_id_fkey FOREIGN KEY (referrer_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5782 (class 2606 OID 153079)
-- Name: refresh_tokens refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5783 (class 2606 OID 153084)
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5784 (class 2606 OID 153089)
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5785 (class 2606 OID 153094)
-- Name: session_events session_events_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_events
    ADD CONSTRAINT session_events_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5786 (class 2606 OID 153099)
-- Name: sessions sessions_base_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_base_image_id_fkey FOREIGN KEY (base_image_id) REFERENCES public.base_images(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5787 (class 2606 OID 153104)
-- Name: sessions sessions_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5788 (class 2606 OID 153109)
-- Name: sessions sessions_compute_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_compute_config_id_fkey FOREIGN KEY (compute_config_id) REFERENCES public.compute_configs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5789 (class 2606 OID 153114)
-- Name: sessions sessions_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5790 (class 2606 OID 153119)
-- Name: sessions sessions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5791 (class 2606 OID 153124)
-- Name: sessions sessions_storage_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_storage_node_id_fkey FOREIGN KEY (storage_node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5792 (class 2606 OID 153129)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5793 (class 2606 OID 153134)
-- Name: storage_extensions storage_extensions_payment_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_payment_transaction_id_fkey FOREIGN KEY (payment_transaction_id) REFERENCES public.payment_transactions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5794 (class 2606 OID 153139)
-- Name: storage_extensions storage_extensions_storage_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_storage_volume_id_fkey FOREIGN KEY (storage_volume_id) REFERENCES public.user_storage_volumes(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5795 (class 2606 OID 153144)
-- Name: storage_extensions storage_extensions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5796 (class 2606 OID 153149)
-- Name: storage_extensions storage_extensions_wallet_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage_extensions
    ADD CONSTRAINT storage_extensions_wallet_transaction_id_fkey FOREIGN KEY (wallet_transaction_id) REFERENCES public.wallet_transactions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5797 (class 2606 OID 153154)
-- Name: subscriptions subscriptions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5798 (class 2606 OID 153159)
-- Name: subscriptions subscriptions_payment_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_payment_transaction_id_fkey FOREIGN KEY (payment_transaction_id) REFERENCES public.payment_transactions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5799 (class 2606 OID 153164)
-- Name: subscriptions subscriptions_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.subscription_plans(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5800 (class 2606 OID 153169)
-- Name: subscriptions subscriptions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5801 (class 2606 OID 153174)
-- Name: support_tickets support_tickets_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5802 (class 2606 OID 153179)
-- Name: support_tickets support_tickets_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5803 (class 2606 OID 153184)
-- Name: support_tickets support_tickets_related_billing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_related_billing_id_fkey FOREIGN KEY (related_billing_id) REFERENCES public.billing_charges(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5804 (class 2606 OID 153189)
-- Name: support_tickets support_tickets_related_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_related_session_id_fkey FOREIGN KEY (related_session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5805 (class 2606 OID 153194)
-- Name: support_tickets support_tickets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5806 (class 2606 OID 153199)
-- Name: ticket_messages ticket_messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_messages
    ADD CONSTRAINT ticket_messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5807 (class 2606 OID 153204)
-- Name: ticket_messages ticket_messages_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_messages
    ADD CONSTRAINT ticket_messages_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.support_tickets(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5808 (class 2606 OID 153209)
-- Name: university_idp_configs university_idp_configs_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.university_idp_configs
    ADD CONSTRAINT university_idp_configs_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5809 (class 2606 OID 153214)
-- Name: user_achievements user_achievements_achievement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_achievement_id_fkey FOREIGN KEY (achievement_id) REFERENCES public.achievements(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5810 (class 2606 OID 153219)
-- Name: user_achievements user_achievements_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5811 (class 2606 OID 153224)
-- Name: user_deletion_requests user_deletion_requests_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_deletion_requests
    ADD CONSTRAINT user_deletion_requests_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5812 (class 2606 OID 153229)
-- Name: user_deletion_requests user_deletion_requests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_deletion_requests
    ADD CONSTRAINT user_deletion_requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5813 (class 2606 OID 153234)
-- Name: user_departments user_departments_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_departments
    ADD CONSTRAINT user_departments_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5814 (class 2606 OID 153239)
-- Name: user_departments user_departments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_departments
    ADD CONSTRAINT user_departments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5815 (class 2606 OID 153244)
-- Name: user_feedback user_feedback_responded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_responded_by_fkey FOREIGN KEY (responded_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5816 (class 2606 OID 153249)
-- Name: user_feedback user_feedback_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5817 (class 2606 OID 153254)
-- Name: user_feedback user_feedback_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5818 (class 2606 OID 153259)
-- Name: user_files user_files_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_files
    ADD CONSTRAINT user_files_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5819 (class 2606 OID 153264)
-- Name: user_files user_files_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_files
    ADD CONSTRAINT user_files_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5820 (class 2606 OID 153269)
-- Name: user_group_members user_group_members_added_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_members
    ADD CONSTRAINT user_group_members_added_by_fkey FOREIGN KEY (added_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5821 (class 2606 OID 153274)
-- Name: user_group_members user_group_members_user_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_members
    ADD CONSTRAINT user_group_members_user_group_id_fkey FOREIGN KEY (user_group_id) REFERENCES public.user_groups(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5822 (class 2606 OID 153279)
-- Name: user_group_members user_group_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_members
    ADD CONSTRAINT user_group_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5823 (class 2606 OID 153284)
-- Name: user_groups user_groups_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5824 (class 2606 OID 153289)
-- Name: user_groups user_groups_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5825 (class 2606 OID 153294)
-- Name: user_groups user_groups_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.user_groups(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5826 (class 2606 OID 153299)
-- Name: user_org_roles user_org_roles_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_org_roles
    ADD CONSTRAINT user_org_roles_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5827 (class 2606 OID 153304)
-- Name: user_org_roles user_org_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_org_roles
    ADD CONSTRAINT user_org_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5828 (class 2606 OID 153309)
-- Name: user_org_roles user_org_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_org_roles
    ADD CONSTRAINT user_org_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5829 (class 2606 OID 153314)
-- Name: user_policy_consents user_policy_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_policy_consents
    ADD CONSTRAINT user_policy_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5830 (class 2606 OID 153319)
-- Name: user_profiles user_profiles_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5831 (class 2606 OID 153324)
-- Name: user_profiles user_profiles_id_proof_verified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_id_proof_verified_by_fkey FOREIGN KEY (id_proof_verified_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5832 (class 2606 OID 153329)
-- Name: user_profiles user_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5833 (class 2606 OID 153334)
-- Name: user_storage_volumes user_storage_volumes_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_storage_volumes
    ADD CONSTRAINT user_storage_volumes_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.nodes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5834 (class 2606 OID 153339)
-- Name: user_storage_volumes user_storage_volumes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_storage_volumes
    ADD CONSTRAINT user_storage_volumes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5835 (class 2606 OID 153344)
-- Name: users users_default_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_default_org_id_fkey FOREIGN KEY (default_org_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5836 (class 2606 OID 153349)
-- Name: waitlist_entries waitlist_entries_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waitlist_entries
    ADD CONSTRAINT "waitlist_entries_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5837 (class 2606 OID 153354)
-- Name: wallet_holds wallet_holds_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5838 (class 2606 OID 153359)
-- Name: wallet_holds wallet_holds_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5839 (class 2606 OID 153364)
-- Name: wallet_holds wallet_holds_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5840 (class 2606 OID 153369)
-- Name: wallet_holds wallet_holds_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_holds
    ADD CONSTRAINT wallet_holds_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.wallets(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5841 (class 2606 OID 153374)
-- Name: wallet_transactions wallet_transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_transactions
    ADD CONSTRAINT wallet_transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5842 (class 2606 OID 153379)
-- Name: wallet_transactions wallet_transactions_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_transactions
    ADD CONSTRAINT wallet_transactions_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.wallets(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5843 (class 2606 OID 153384)
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


-- Completed on 2026-05-19 22:41:49

--
-- PostgreSQL database dump complete
--

\unrestrict 4atNcefBMpaCoH4T2Ym7ojr86Aw99zu1Ob8cF4qRJUKfDzDWTqJm7FEGRVQ1lB1

