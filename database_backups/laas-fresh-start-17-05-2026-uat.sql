--
-- PostgreSQL database dump
--

\restrict 1dA6dqYBhWVPi0VKrDn815WLfZl09sR0Tpr401akYdabFEpCLgadnMstNWBdUus

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-05-18 11:08:07

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
3a1e68a5-0321-4594-aa71-567ea8608b69	89b2ee87-2a07-4fe9-82e7-72a9addb7299	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-14 15:57:42.756
d131d4b5-0202-4e25-b102-85aa8bd51154	54d2f9e7-c608-45e2-b740-2abafa15abc5	\N	\N	file.mkdir	storage	\N	\N	{"path": "/", "folderName": "zenitt"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-14 16:00:08.039
78f49c2b-e105-4689-b49f-6777c6830718	54d2f9e7-c608-45e2-b740-2abafa15abc5	\N	\N	file.upload	storage	\N	\N	{"path": "/zenitt", "fileName": "Invoice.pdf"}	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	success	\N	2026-05-14 16:00:14.211
26973f0c-e090-4203-abaf-e2c052bfb7fd	89b2ee87-2a07-4fe9-82e7-72a9addb7299	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-15 05:30:12.514
35ebcc71-927e-4f69-b246-1e51a4f55377	89b2ee87-2a07-4fe9-82e7-72a9addb7299	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-15 05:49:13.089
cd49679d-aa08-4924-9cce-55a5ff0b0576	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-15 07:58:10.787
71f6c814-f802-4c15-ba38-bfeda87bef4a	bd8f8f80-a9ab-43e9-999f-b653f359e4c9	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-15 07:58:44.503
be222a74-8ff5-49a1-9881-ad01d02e02a3	89b2ee87-2a07-4fe9-82e7-72a9addb7299	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-15 09:52:20.624
88137993-9e8c-4b11-b37e-60c735541ac8	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-15 10:00:34.38
69c61c29-89eb-4535-b421-34bf2e333f15	89b2ee87-2a07-4fe9-82e7-72a9addb7299	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-15 10:01:33.19
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
f428b31f-8164-4ffd-a864-71401f04724d	89b2ee87-2a07-4fe9-82e7-72a9addb7299	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-17 10:06:17.615
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
add2aa28-b860-4a03-addf-b6f5df291c8a	89b2ee87-2a07-4fe9-82e7-72a9addb7299	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-18 04:58:03.622
aaddc786-cfaf-4816-912f-3a88adbd7262	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 04:58:51.035
a3627776-bae2-4a70-ae56-00784b12e4e2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 05:05:37.167
74553c1e-8d5c-4e99-b5a0-559840b4c7f8	89b2ee87-2a07-4fe9-82e7-72a9addb7299	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-18 05:07:10.015
842a7a38-9d89-40fd-a9be-7027ee35c723	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 05:08:13.804
b49c2188-967d-469a-bdcf-1663352cc1d0	92e50b41-bfb7-41cb-92c5-c8a26fcd5221	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 05:09:44.504
7d77eac2-5d9d-457f-91e9-5984fd0bcbd2	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 05:13:51.957
4bb3370e-ac40-445c-a818-cd641ec6a38e	89b2ee87-2a07-4fe9-82e7-72a9addb7299	\N	\N	auth.login	auth	\N	\N	{"authType": "public_oauth", "loginMethod": "oauth", "oauthProvider": "keycloak"}	127.0.0.1	\N	success	\N	2026-05-18 05:19:31.464
fe2f899d-6f56-4543-b0f4-859e113259d8	9f08f905-999a-4c6f-87bc-66e29dc6301e	\N	\N	auth.login	auth	\N	\N	{"authType": "public_local", "loginMethod": "password"}	127.0.0.1	\N	success	\N	2026-05-18 05:21:39.337
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
4bc88856-fa7d-4412-bffb-0970d5c1faa2	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	f2579d97-59fb-4b9d-b47c-af3b9f67beab	2026-05-15 06:32:11.819	\N	compute	\N	\N
2a309d6d-4eee-4551-a969-52ad6322b03a	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	40969150-3e24-4f46-a50a-d6033e5f41cf	2026-05-15 07:30:00.331	\N	compute	\N	\N
501c14f8-2be4-4830-b43f-3b52c581e739	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	84b8b7cc-f987-4fd4-94b8-f49ebe34b095	2026-05-15 08:30:00.164	\N	compute	\N	\N
6e19168f-fc1c-4647-b65d-37d5ef7070de	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	9c67ab3e-ff0c-4ccb-a0d7-0409c3f00b54	2026-05-15 09:30:00.689	\N	compute	\N	\N
08fa8ffc-3809-491c-a317-346da8c13c1b	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	0bd6699d-33d3-4e73-b4c8-deb2e6f5689c	2026-05-15 10:30:00.171	\N	compute	\N	\N
c48e60bd-e47f-45d3-b6e7-3783dc26c877	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	e223787d-2a75-486a-9de6-e14227c99ba7	2026-05-15 11:30:00.183	\N	compute	\N	\N
41e97237-b99d-4245-a9a8-1a7ff6ee618b	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	b444f521-9768-4720-b09c-af1fa8e5e108	2026-05-15 12:30:00.113	\N	compute	\N	\N
38f20c76-2605-41bb-bffb-644e907fe7f3	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	56c0e138-a180-4739-89bc-85cddb036c19	2026-05-15 13:30:00.966	\N	compute	\N	\N
d99471da-006e-4799-841f-b8746a99c7b4	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	1c266679-504e-437d-a350-480f72e3bf88	2026-05-15 14:53:45.797	\N	compute	\N	\N
9e79abe8-78c7-4379-b7a8-392d61b01507	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	ff19e231-e556-42f1-960b-1784ecec6b25	2026-05-16 03:13:59.958	\N	compute	\N	\N
514359c8-2685-4271-a19d-c0295cc25f1e	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	623e2965-9395-44a5-ab01-d5287278b9c7	2026-05-16 03:48:05.821	\N	compute	\N	\N
1f5f0e47-0665-4944-b177-d7af539f676a	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	cec0006e-ae8f-4d01-8ec9-004541412300	2026-05-16 05:42:53.863	\N	compute	\N	\N
5b3b70c5-0dfb-4872-b333-be06038be463	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	c3377038-fa9d-4f59-b144-f42dd16b80e4	2026-05-16 06:30:02.749	\N	compute	\N	\N
c621c995-49b4-4b68-9f20-ab2153ac05f6	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	55b3f8b5-1a79-45f2-83a2-7d8cb099a2bd	2026-05-16 07:30:00.371	\N	compute	\N	\N
ad58d76c-e1a4-4eff-beac-e2a6ae74faf6	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	564c0a7f-d1a8-4db2-803f-608757df685a	2026-05-16 09:04:52.869	\N	compute	\N	\N
eede0640-3ab5-4367-9d5b-c14ae9653c6b	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	5cf1b816-1e9d-48ea-8e1f-6d2d07137978	2026-05-16 09:59:26.66	\N	compute	\N	\N
6c65e744-b1cb-4ae0-9556-056a77d7f197	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	e1b94b9e-ac8f-4e16-998a-21a1246ea105	2026-05-16 14:33:48.451	\N	compute	\N	\N
b9f73f4c-a496-4cb5-b668-da699e694756	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	bae6e1c1-2080-4760-a852-6938c655e04c	2026-05-16 16:30:00.092	\N	compute	\N	\N
f9587fa6-bddd-44ff-a8be-18072768c7ae	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	5fed4cf8-74fb-43d3-bdc2-dc5b6bf256b1	2026-05-16 17:30:01.619	\N	compute	\N	\N
ce33dec0-7f62-41f4-a632-4502d3d9e309	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	07dba317-d980-4550-8ef3-d857004d4bb9	2026-05-16 18:38:37.871	\N	compute	\N	\N
68ccc67b-e52e-482d-8dfe-b37f6a3c566f	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	1a82cb8a-f853-40fd-b646-49896deeb740	2026-05-17 02:32:58.466	\N	compute	\N	\N
aa5ab5d7-ff32-4b70-915d-3d6e91aebd82	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	f099123a-32ac-4d46-b12d-838f3875a0ef	2026-05-17 03:53:15.922	\N	compute	\N	\N
3143b214-eaa6-48ab-8d03-91ea01706a20	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	febf3030-5fbe-44c5-bf78-68025787e6fe	2026-05-17 04:30:00.123	\N	compute	\N	\N
f795b9c9-6720-434e-961d-8fa86752ac91	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	03aa2b99-09c8-405c-aacf-e892dfb40806	2026-05-17 05:52:48.596	\N	compute	\N	\N
e0c68a31-e998-45ca-a6f2-b6cc3298cc98	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	6eccdfcd-e209-4e56-a82b-0234ab3dd66b	2026-05-17 07:58:52.642	\N	compute	\N	\N
9640a10f-64e9-4749-9791-4be13fc3e016	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	9b2e1478-b645-4d8e-9727-2fdd96b511de	2026-05-17 08:30:00.091	\N	compute	\N	\N
18af9f3b-9ec6-4c6c-8091-9994ca3b3990	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	a1b7afe8-bbe1-4c69-a14b-afaebbcf99cb	2026-05-17 09:30:00.07	\N	compute	\N	\N
ca3084d6-14fc-4a35-ba36-51a6f61032a9	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	300717fa-11ed-45b6-9dec-cd6244d9d485	2026-05-17 10:30:00.578	\N	compute	\N	\N
fa067c02-19ef-4b79-a771-0481621a0cd6	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	9b801a86-16a4-48f0-ad28-42f8bda19d84	2026-05-17 11:54:39.232	\N	compute	\N	\N
358203a5-b158-4061-8d91-48bc352387d7	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	5d417ee5-eeb9-44d6-a105-0fe563ba4085	2026-05-17 12:30:00.069	\N	compute	\N	\N
f9093b54-bf71-43c8-b193-a80e3dec03c4	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	d56ebfca-119a-4df5-9c07-e8b3e86e0f85	2026-05-17 13:30:00.08	\N	compute	\N	\N
f12d8209-d234-4431-bd29-669136dac9a0	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	619e5123-935d-471e-a64a-40f6969e98ba	2026-05-17 14:30:00.055	\N	compute	\N	\N
da0b0b53-8a01-493a-ac93-4c12202a5992	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	b20b4c71-39aa-4da3-8c9f-6b90ec46c5ff	2026-05-17 15:30:00.09	\N	compute	\N	\N
ea624b4e-f085-41e2-9f96-fd105655cf61	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	5eb5824b-0bc3-497f-a518-51ce365615e1	2026-05-17 16:30:00.107	\N	compute	\N	\N
63891bdd-7bb2-4d1c-8828-2c45391d849a	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	4155e172-2c7e-40c1-a57b-15c7b92d55c3	2026-05-17 17:30:00.075	\N	compute	\N	\N
db62135c-19c7-4237-adf6-ed2c170c2ebe	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	8e4bb07d-cf9c-4edc-8622-3c284590bd04	2026-05-17 18:30:00.081	\N	compute	\N	\N
a31a6ae2-5a3c-48e5-b669-a784d0584ed8	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	757d83d2-98e1-4c10-ba34-ac3e64b687e2	2026-05-17 19:38:31.253	\N	compute	\N	\N
ff222d00-e667-4da4-be33-12eb095201f0	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	69cf42e2-8a07-452d-9cbd-81dcfdf0cbfe	2026-05-18 04:35:50.823	\N	compute	\N	\N
6fd52459-34da-4cf8-86e5-baaa4d6a43ef	89b2ee87-2a07-4fe9-82e7-72a9addb7299	ace083ca-0ae6-4876-89e0-e9fb56f8d851	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	1854e66e-2c51-46f0-af7b-52990e9705f6	2026-05-18 05:07:53.448	\N	compute	\N	\N
7b35c52e-7642-4203-baf8-5cfaa64cd5d2	92e50b41-bfb7-41cb-92c5-c8a26fcd5221	ad712de6-33f4-4292-82fe-e1c11b056f34	d2fb06af-8256-4105-812b-05a10cbe99a1	3600	12000	12000	INR	8d08a76d-6007-41f6-a327-a135f26e6df8	2026-05-18 05:12:16.593	\N	compute	\N	\N
723c538a-e101-4b83-b774-f3f5b5926d0f	89b2ee87-2a07-4fe9-82e7-72a9addb7299	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	d2fb06af-8256-4105-812b-05a10cbe99a1	118140	12000	396000	INR	5cc039f3-f029-43a5-8d3d-ed586e4f19f1	2026-05-18 05:21:12.12	\N	compute	\N	\N
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
f21dc0b5-47bd-4dea-a336-8922ebf9908c	16fc534c-f41c-4336-9fc9-2e69a89b790b	Credit Recharge	1	1000000	1000000	payment_transaction	16720231-6285-4ba5-9322-c79b063d1d9a	2026-05-15 06:27:37.296
3b046863-9b42-4754-90a8-d9ca03fe2cdc	9ea7ffdd-aef5-4021-a1dc-532e2406e8c5	Credit Recharge	1	1000000	1000000	payment_transaction	cfdbe9b4-e6e7-487b-9ab1-239ca1c3d1d2	2026-05-18 05:05:11.551
\.


--
-- TOC entry 6009 (class 0 OID 151535)
-- Dependencies: 237
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoices (id, user_id, organization_id, invoice_number, period_start, period_end, subtotal_cents, tax_cents, total_cents, currency, status, issued_at, paid_at, pdf_url, created_at, updated_at, created_by, updated_by) FROM stdin;
16fc534c-f41c-4336-9fc9-2e69a89b790b	89b2ee87-2a07-4fe9-82e7-72a9addb7299	\N	INV-20260515-B9AE80	2026-05-15 06:27:37.228	2026-05-15 06:27:37.228	1000000	0	1000000	INR	paid	2026-05-15 06:27:37.228	2026-05-15 06:27:37.228	\N	2026-05-15 06:27:37.282	2026-05-15 06:27:37.282	\N	\N
9ea7ffdd-aef5-4021-a1dc-532e2406e8c5	92e50b41-bfb7-41cb-92c5-c8a26fcd5221	\N	INV-20260518-075110	2026-05-18 05:05:11.521	2026-05-18 05:05:11.521	1000000	0	1000000	INR	paid	2026-05-18 05:05:11.521	2026-05-18 05:05:11.521	\N	2026-05-18 05:05:11.546	2026-05-18 05:05:11.546	\N	\N
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
oauth	127.0.0.1	\N	\N	t	\N	2026-05-14 15:57:42.743	\N	3982f53e-c16e-43bd-8319-55a0c7ca3278	89b2ee87-2a07-4fe9-82e7-72a9addb7299
oauth	127.0.0.1	\N	\N	t	\N	2026-05-15 05:30:12.491	\N	670fecc7-993c-419e-9ca3-628bdbe5ea9a	89b2ee87-2a07-4fe9-82e7-72a9addb7299
oauth	127.0.0.1	\N	\N	t	\N	2026-05-15 05:49:13.079	\N	2c082b5a-045f-46b8-ac48-b002c8bea400	89b2ee87-2a07-4fe9-82e7-72a9addb7299
password	127.0.0.1	\N	\N	t	\N	2026-05-15 07:58:10.753	\N	817c6594-e1a5-4f43-93e7-955591afc64f	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	f	invalid_password	2026-05-15 07:58:38.753	\N	a342fabd-f507-49b0-bc1b-950a722593a5	bd8f8f80-a9ab-43e9-999f-b653f359e4c9
password	127.0.0.1	\N	\N	t	\N	2026-05-15 07:58:44.498	\N	cf3a37f1-1774-48c3-9962-20d087b79e7d	bd8f8f80-a9ab-43e9-999f-b653f359e4c9
oauth	127.0.0.1	\N	\N	t	\N	2026-05-15 09:52:20.594	\N	d9a314d2-6808-4ddc-b8fa-fe4426df06d1	89b2ee87-2a07-4fe9-82e7-72a9addb7299
password	127.0.0.1	\N	\N	f	invalid_password	2026-05-15 10:00:27.846	\N	6b490931-322f-4948-8d7a-1b2447840cf1	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-15 10:00:34.353	\N	a9edc755-d5a1-4da4-83ee-bc17aab087f8	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-15 10:01:33.169	\N	20ff6b9d-9fed-4a82-abdf-dfb12211ddbc	89b2ee87-2a07-4fe9-82e7-72a9addb7299
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
oauth	127.0.0.1	\N	\N	t	\N	2026-05-17 10:06:17.583	\N	94fcae6b-4937-4ded-b1d4-b0527a09162d	89b2ee87-2a07-4fe9-82e7-72a9addb7299
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
oauth	127.0.0.1	\N	\N	t	\N	2026-05-18 04:58:03.613	\N	7e3008d1-a0a5-40c9-980c-a702e8e0d0d7	89b2ee87-2a07-4fe9-82e7-72a9addb7299
password	127.0.0.1	\N	\N	t	\N	2026-05-18 04:58:51.03	\N	43223635-f56f-4a62-9f54-ba15a7abe149	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 05:05:37.138	\N	5d8f724b-7aed-4f47-978c-b8a188941c29	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-18 05:07:10.001	\N	fd644c8c-18b7-41d6-92da-3faa7d4d8f29	89b2ee87-2a07-4fe9-82e7-72a9addb7299
password	127.0.0.1	\N	\N	t	\N	2026-05-18 05:08:13.796	\N	9240e490-d126-4d0f-9435-fed6aead72d8	9f08f905-999a-4c6f-87bc-66e29dc6301e
password	127.0.0.1	\N	\N	t	\N	2026-05-18 05:09:44.498	\N	c51c4952-1601-48ad-9527-a8c3b13697ba	92e50b41-bfb7-41cb-92c5-c8a26fcd5221
password	127.0.0.1	\N	\N	t	\N	2026-05-18 05:13:51.949	\N	d5a8d87f-619c-4688-bf2b-c4ebacfbb575	9f08f905-999a-4c6f-87bc-66e29dc6301e
oauth	127.0.0.1	\N	\N	t	\N	2026-05-18 05:19:31.422	\N	19803ed0-c727-4afb-8c95-c7dfbe5ae705	89b2ee87-2a07-4fe9-82e7-72a9addb7299
password	127.0.0.1	\N	\N	t	\N	2026-05-18 05:21:39.328	\N	88e2b5f2-000a-487b-a34f-b5369e0f01b7	9f08f905-999a-4c6f-87bc-66e29dc6301e
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
05bfe4bf-1a47-4801-8a87-94c3b75a884d	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	3eeef689-38d9-401f-ae54-5c1369f6a554	8	16384	8192	33	2026-05-18 05:09:55.143	2026-05-18 05:09:57.337	released	2026-05-18 05:09:55.143	2026-05-18 05:09:57.344
ebea68e4-9a1a-4b20-841e-9eb272fe19be	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	a6511603-d97c-4241-a118-dd0c66c87dc8	4	8192	4096	17	2026-05-18 05:13:23.256	2026-05-18 05:13:25.369	released	2026-05-18 05:13:23.256	2026-05-18 05:13:25.375
70f309e7-6000-471d-b735-300f49bf5238	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	ad712de6-33f4-4292-82fe-e1c11b056f34	2	4096	2048	8	2026-05-18 05:11:56.008	2026-05-18 05:18:59.999	released	2026-05-18 05:11:56.008	2026-05-18 05:19:00.024
3167e3e5-99c8-4361-a6ad-0e095794d217	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	ace083ca-0ae6-4876-89e0-e9fb56f8d851	2	4096	2048	8	2026-05-18 05:07:30.687	2026-05-18 05:19:39.21	released	2026-05-18 05:07:30.687	2026-05-18 05:19:39.219
a40fd995-4110-4b7f-95fc-4e3117a8f7da	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	2	4096	2048	8	2026-05-15 06:31:51.372	2026-05-18 05:21:12.078	released	2026-05-15 06:31:51.372	2026-05-18 05:21:12.09
\.


--
-- TOC entry 6022 (class 0 OID 151724)
-- Dependencies: 250
-- Data for Name: nodes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nodes (id, hostname, display_name, ip_management, ip_compute, ip_storage, cpu_model, total_vcpu, total_memory_mb, total_gpu_vram_mb, gpu_model, nvme_total_gb, allocated_vcpu, allocated_memory_mb, allocated_gpu_vram_mb, max_concurrent_sessions, status, last_heartbeat_at, metadata, created_at, updated_at, created_by, updated_by, current_session_count, last_resource_sync_at, session_orchestration_port, storage_provision_port, nvme_of_port, storage_headroom_gb) FROM stdin;
16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	laas-node-02	LaaS Node 02 — RTX 4090	100.94.157.114	100.94.157.114	10.10.100.88	AMD Ryzen 9 7950X3D	16	65536	24576	RTX 4090	2000	0	0	0	8	healthy	2026-05-18 05:22:00.225	{"smTotal": 128, "cudaArch": "sm_89", "reservedVcpu": 2, "driverVersion": "565.x", "allocatableVcpu": 14, "reservedMemoryMb": 10240, "reservedGpuVramMb": 1024, "allocatableMemoryMb": 55296, "allocatableGpuVramMb": 23552}	2026-04-26 12:53:44.426	2026-05-18 05:22:00.227	\N	\N	0	\N	9998	9999	4420	15
c9868115-ff99-403c-8e87-06124ba7df66	laas-node-01	LaaS Node 01 — RTX 4090	100.88.57.107	100.88.57.107	10.10.100.99	AMD Ryzen 9 7950X3D	16	65536	24576	RTX 4090	2000	0	0	0	8	healthy	2026-05-18 05:22:00.374	{"smTotal": 128, "cudaArch": "sm_89", "reservedVcpu": 2, "driverVersion": "565.x", "allocatableVcpu": 14, "reservedMemoryMb": 10240, "reservedGpuVramMb": 1024, "allocatableMemoryMb": 55296, "allocatableGpuVramMb": 23552}	2026-04-08 01:52:12.012	2026-05-18 05:22:00.377	\N	\N	0	\N	9998	9999	4420	15
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
16720231-6285-4ba5-9322-c79b063d1d9a	89b2ee87-2a07-4fe9-82e7-72a9addb7299	razorpay	pay_SpXaBQ1s2ByI36	order_SpXWfd2Zyjik9K	1000000	INR	completed	{"verified_at": "2026-05-15T06:27:37.228Z", "razorpay_order_id": "order_SpXWfd2Zyjik9K", "razorpay_signature": "d61e7d1c051fccedc17aff9ef661cada6b736d968acf6df73f22111ad1b232ce", "razorpay_payment_id": "pay_SpXaBQ1s2ByI36"}	\N	\N	2026-05-15 06:23:57.713	2026-05-15 06:27:37.243	\N	\N
cfdbe9b4-e6e7-487b-9ab1-239ca1c3d1d2	92e50b41-bfb7-41cb-92c5-c8a26fcd5221	razorpay	pay_SqhmU90f3txqvZ	order_SqhkmjffxIVYzF	1000000	INR	completed	{"verified_at": "2026-05-18T05:05:11.521Z", "razorpay_order_id": "order_SqhkmjffxIVYzF", "razorpay_signature": "9b2602a58151a318ae95836c924f930602c3b5e761891c0f901476254b2d194e", "razorpay_payment_id": "pay_SqhmU90f3txqvZ"}	\N	\N	2026-05-18 05:03:14.431	2026-05-18 05:05:11.531	\N	\N
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
$2b$10$5JG/qZTQ6QTumQyKEVfYyO27akiFlUBMN9LhRps1ZzLxlQHYmJeQG	\N	\N	2026-05-21 15:57:42.931	\N	2026-05-14 15:57:42.933	0	3ecdd7b6-0d9c-44d0-a1b5-b5fe11262175	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$AQ9VPQVa4TXFgEAAD6Svaeul9qsnDyN6E2GDDOzu1CYoWa7KnFGiq	\N	\N	2026-05-21 15:59:42.245	\N	2026-05-14 15:59:42.246	0	352dc603-f43c-4103-9d40-c09e74922524	54d2f9e7-c608-45e2-b740-2abafa15abc5
$2b$10$K..Q9wl4wi5kos/xtjxpJ.Uo4l9Ar88in7mS1chqDSJVahY97FWUu	\N	\N	2026-05-22 05:30:12.749	2026-05-15 05:43:13.189	2026-05-15 05:30:12.75	0	93210e19-778e-43e5-8e22-d5dbb004bed0	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$iFeJk5qhrtjqRqTW2ng31uu8D2fiqMUlYcgDfqEehYP2aFpG36M2y	\N	\N	2026-05-22 05:43:13.32	\N	2026-05-15 05:43:13.321	0	c9217438-89b7-4eb9-b9fb-e1812291a83f	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$7G5L0JIJBwz11shgNhkZredTeXUYvFivG9fNGCKtuBcTAfdUlDOny	\N	\N	2026-05-22 05:49:13.352	2026-05-15 06:03:01.708	2026-05-15 05:49:13.354	0	30a3f09a-9e1e-47a5-ba05-ca1542119152	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$cDheC2ur9efqvCMIDRXbXObr5rly2ludsY82rOSdPdc87eqcIWIEq	\N	\N	2026-05-22 06:03:01.921	2026-05-15 06:16:01.49	2026-05-15 06:03:01.923	0	a4015707-37df-4324-b6b3-f6b4047de15a	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$A.e2J74XLhwHw.QApd4DZ.0TfuPspZnSjL1kN895c0pHSGEdi7o.C	\N	\N	2026-05-22 06:16:01.635	2026-05-15 06:29:01.507	2026-05-15 06:16:01.636	0	abfe9a11-2794-47d9-ac58-2ae8bbe7bf36	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$18nMkAtiV0X.bUiu3UjKD.V82E8ZkI59H7EfnKgsNCLQMnolHiWvW	\N	\N	2026-05-22 06:29:01.655	2026-05-15 06:42:48.601	2026-05-15 06:29:01.656	0	0fc086c6-42de-4c72-8d48-d725fed8bd17	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$9N/jSdH70emcEom46H/enuwwDSVMNupQfIX4MTu882qlDNGnoZU9K	\N	\N	2026-05-22 06:42:48.82	2026-05-15 06:56:01.573	2026-05-15 06:42:48.822	0	2af6f6cd-8b95-4748-a684-77bd8481bbae	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$7oWzGCJ0Q.6oeVyZPzPUZOnCNoz0XQXiTBWrNgBLEDqu.fcgGwF1a	\N	\N	2026-05-22 06:56:01.797	\N	2026-05-15 06:56:01.799	0	9d7daa02-8716-4d44-b906-5559e7fd4126	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$pckbocwt8RNFanbyrfqMDecxdrWLSVDHGxckdSwSxVl9jPDitDYH6	\N	\N	2026-05-22 07:58:11.016	\N	2026-05-15 07:58:11.018	0	a4cc127e-4bb6-46ce-9f7b-4995a0228523	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$I0AXh.n1/6J7fTviqrpHd.BAqlLZg8DPBj4CK8AVd/DRdE.BQl0.2	\N	\N	2026-05-22 07:58:44.638	2026-05-15 09:36:04.234	2026-05-15 07:58:44.64	0	bbe29db1-2236-4ee1-bbde-8d9253981a33	bd8f8f80-a9ab-43e9-999f-b653f359e4c9
$2b$10$MhVlU4I5v5uzSy6bOuhuy.cTUkdUyGeE53t.Virl2B9Le/9htcmdy	\N	\N	2026-05-22 09:36:04.906	2026-05-15 09:51:25.155	2026-05-15 09:36:04.908	0	36df00d9-aeca-4a2d-8a25-bc849eeb7b1c	bd8f8f80-a9ab-43e9-999f-b653f359e4c9
$2b$10$CPk2lAkSYGsQBl0DbbHr1.j.E4.7bdglL74zY4AkXZGBD1jQ/55Na	\N	\N	2026-05-22 09:51:25.443	\N	2026-05-15 09:51:25.446	0	392fa428-b474-40fe-bf0c-5e34c3124f1c	bd8f8f80-a9ab-43e9-999f-b653f359e4c9
$2b$10$Fw7QLc1DS.CUEsOIYX56MOpJ5nw2v1qlvEfmB4KB/gOiKxTZLPpsS	\N	\N	2026-05-22 09:52:20.886	\N	2026-05-15 09:52:20.887	0	fdbf8588-9027-4dbc-aec1-52d1e00d6ccf	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$lNCj27iKUs5MyA/fK.bmtunKECagi9WtfXCaWhr8hutgxJz6k67zq	\N	\N	2026-05-22 10:00:34.652	\N	2026-05-15 10:00:34.654	0	353f5cf6-9f80-4116-8f0b-fae96a3916a4	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$399NjylhnUUk21axjErZAOxvFOsuxGyFcx/gB2PAF.kFeadfkLfxm	\N	\N	2026-05-22 10:01:33.475	2026-05-15 10:14:47.495	2026-05-15 10:01:33.476	0	c03ce0a6-1151-4fdd-a016-f76a75d67c9a	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$HVzTcs51lFuHgiS4UUd1z.Ffw/WSxy9O2L8FcEPP/jRSh4VjhjJrW	\N	\N	2026-05-22 10:15:56.232	\N	2026-05-15 10:15:56.233	0	d38ac0e4-3d62-4572-94f1-bd94d770abd9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$PIn3Va6apBnMctprmxy85eyHcfxhI5IPwX/sYwY8lKZ/OCpGmCmfi	\N	\N	2026-05-22 11:23:16.622	\N	2026-05-15 11:23:16.624	0	229ee5cc-6e32-42be-9e75-2dc120875065	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$pBol3.r.wvmRdVIbDVekjOiDPXVw/AzHhpsnLToKMwDoD9Wc9bADa	\N	\N	2026-05-22 10:14:47.859	2026-05-15 11:23:49.535	2026-05-15 10:14:47.862	0	2c1e3d9d-438b-49ea-b577-3079e0c064a7	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$2R6DffBz3umiiFf9hnJSLOycydoOTwlkHW73rczNqc/eFKPz2h51O	\N	\N	2026-05-22 11:53:45.035	\N	2026-05-15 11:53:45.037	0	667551c1-8fe9-4570-96d6-e01213a4f0fd	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$3N8ZzZWmN0x8rgjEWRSSmuuj39GHOEZY/CGBZuxQN8i3awEnuyaLK	\N	\N	2026-05-22 13:34:01.219	\N	2026-05-15 13:34:01.22	0	7275d5c9-ab2e-4eea-8098-d55fffe935b9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$GcOK97uAz7oqh.bynmVu3.Tv1yjeE0lHywPlce0Tjp5odXXD7MLZC	\N	\N	2026-05-23 06:22:31.815	\N	2026-05-16 06:22:31.816	0	7cfe1415-8d4c-48c7-af67-870261b56a8f	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$evYDeAmcw2C51vE7EuUGl.mbvyk.qlM5kMe.XKkwxKsyKoNw33gzu	\N	\N	2026-05-23 07:18:37.636	\N	2026-05-16 07:18:37.638	0	681d4f64-603d-4b27-8383-01fcc1280932	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Mwme/E.VkHWqg9/9Qlw5yemJJcA2mBaJYsfsgnBL.9QOMZ0bEeu1.	\N	\N	2026-05-23 07:37:53.37	\N	2026-05-16 07:37:53.373	0	cb0e8413-9755-4dbd-8314-fd459e844ef9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Y5myUJBzWRfSwIoEJzQUv.broRu67wB8HDctr6qghdEPuXocIoyx.	\N	\N	2026-05-24 08:58:39.838	\N	2026-05-17 08:58:39.84	0	eac30210-c8d9-4d9b-aaef-c675ac7f8b7a	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$tkqCf4KCKx94vK0pkP6ib.J/m5ju/4D4iODLCih6ot.uJPUslXVw6	\N	\N	2026-05-24 09:15:10.648	\N	2026-05-17 09:15:10.651	0	dd24b467-d74c-4cc1-bf48-c0062c0049b9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$1XjE9Qa.tqfrKyXWUDf/RuOSRLwYgACosgfvwdezcu8RmK2y6jCz2	\N	\N	2026-05-22 11:23:49.774	2026-05-17 09:18:27.134	2026-05-15 11:23:49.776	0	10c2b0b4-8fab-4546-99b6-4a462ec2223e	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$OIza7y2n59LJGXf2QmDD5.9nrm9LIj1nu9BDPX/WEZ5fWA.JMxSqm	\N	\N	2026-05-24 09:18:27.432	\N	2026-05-17 09:18:27.434	0	98f840cb-0317-4434-be4f-80277c7fd389	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$Q7Wx1WwEvsn9ruuR.zdP3ud1MR.HIHY087Pq98A6NJd.kGLgDju9W	\N	\N	2026-05-24 09:20:18.589	\N	2026-05-17 09:20:18.591	0	e9fee3d8-1518-43f0-bfd8-cc64537653b2	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Fo.YV14ygIixhwckPPTmU.HtHvpXGr8VWkz25pFHIA8TDrgL3vF7e	\N	\N	2026-05-24 10:09:30.424	\N	2026-05-17 10:09:30.426	0	c7b1ac2e-4b48-428c-bd38-8679f8b574f4	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$JP2N5yUW6IJeVpY.qpimheeF1Rj7Bz53dlBEVLPId2YpmjyfHPrCS	\N	\N	2026-05-24 10:06:17.907	2026-05-17 10:19:43.329	2026-05-17 10:06:17.909	0	53710d90-40e2-4c29-b755-95197bd450ea	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$RFtHkJVPzjxmcKwN7wQgk./QipElwAVesSNoG0Vh3bV0fTenJKrPC	\N	\N	2026-05-24 10:27:46.041	\N	2026-05-17 10:27:46.042	0	1c416735-1400-4d80-a920-cfe8c5fc3bd9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$rNDptJFJGB3xqVGKq4Bnf.4M9GQLrN/6qNqUlKzZphjpN9s53Ssk6	\N	\N	2026-05-24 10:19:43.498	2026-05-17 10:32:53.731	2026-05-17 10:19:43.5	0	79df2259-797e-4c68-a91a-7a61494c9ebc	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$8886bBCIPQmnTlHDY8WXkOHY1.td/dKcY7KbRpJVT9qkDyyEFHic.	\N	\N	2026-05-24 12:20:54.002	2026-05-17 12:33:53.59	2026-05-17 12:20:54.003	0	6022950d-4710-438f-9f51-df07c2bb30fe	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$AeC94/K36ZM0biXNXw1cFuiOvtci10WRRudUkzGa5ZljlUPBCUS6W	\N	\N	2026-05-24 10:32:53.925	2026-05-17 10:56:03.704	2026-05-17 10:32:53.927	0	4199d3e8-fc8d-4421-8d40-672c45fe9b07	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$mKvGJEITKASfWzyz4IYhSOcyc4m.yKhJAe4KLtck8Qz3x7yS9PUMS	\N	\N	2026-05-24 10:56:03.88	\N	2026-05-17 10:56:03.882	0	33243505-9c8e-44bc-b1be-6aeecd9254de	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$83jFakg6DHRZEnh3gDpUE.YPUmdwUaKtKarotfw.3JWoz/lK0vyMC	\N	\N	2026-05-24 10:56:03.979	2026-05-17 11:54:52.718	2026-05-17 10:56:03.981	0	86901fb7-4e95-49dd-b8a1-9cbb4b39730c	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$bXaQPYm.Ku31lhZdSf5.JejtO9otTrobny/.YK/1IqURj/ieIdNUq	\N	\N	2026-05-24 11:57:24.95	\N	2026-05-17 11:57:24.952	0	6b3b4272-30b6-4ebe-b976-36d2aef0f102	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$MtvOe4tSUGmm1jXX0sXMG.g5gReY/T5zgBeDTwg6g4EvYF5D95Xge	\N	\N	2026-05-24 11:54:53.35	2026-05-17 12:07:53.676	2026-05-17 11:54:53.353	0	e0ad9bbf-4a64-450a-9b9d-e21d8a9e44c4	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$ioI9XqMJKM5x/AME9F/7jOeYz5jOpCDyCjLtSRk13rymMAoouT3Xy	\N	\N	2026-05-24 12:07:53.853	2026-05-17 12:20:53.674	2026-05-17 12:07:53.855	0	ef4b8e0c-f05c-4092-9a37-fa61e3ecf195	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$9WD71w./M/wgT4kQN1HAUeejeIyXDjV.LQoZB6RtrxuVTsPgIpl.m	\N	\N	2026-05-24 12:28:09.651	\N	2026-05-17 12:28:09.653	0	52f4b781-2cf8-42ef-a0e6-cd4b4c67b4bb	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$ZIi.EDBPsyKoDN7DxERk3unwc4m3KmTAZg5K6Q1iIXIvM33QVJNpG	\N	\N	2026-05-24 12:33:53.724	2026-05-17 12:46:53.621	2026-05-17 12:33:53.727	0	cca54199-493a-48de-aa17-6a8bb5ab907e	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$/0CSFzqmpGjveXo9Py0EzulEZ4p46fMkt/0e4Jav9BFv3vNVcZJ1a	\N	\N	2026-05-24 12:46:53.752	2026-05-17 12:59:53.984	2026-05-17 12:46:53.753	0	0c675de3-3534-4444-8b2a-9e7a29e8db9b	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$fNVI5SrFVlluBtuSJ7Q65eQvKpoldtHAmv1ft.zcTBpi/BMfO/wFi	\N	\N	2026-05-24 12:59:54.124	2026-05-17 13:12:53.592	2026-05-17 12:59:54.126	0	42ee01da-203a-4ff5-92a6-73f2181f30c9	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$aUdW/XNRjAiXPv3sY8Ws9ugcVCvtPuBe9fSy1gwENZQYwgYWrCbDu	\N	\N	2026-05-24 13:12:53.728	2026-05-17 13:25:53.663	2026-05-17 13:12:53.729	0	bf866683-4f1f-4598-afa1-7aa59515a89e	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$yy1TJqWKsoVF5ZKNLTT0EeXjUXfFRNPgpVFZGKDlx3INcRRIgzu0.	\N	\N	2026-05-24 13:25:53.818	2026-05-17 13:38:53.685	2026-05-17 13:25:53.821	0	2e843d96-5110-41a0-820e-b8f36ed2386c	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$bTCQ.kj8azsogR6fXVCUleMns6iW23bSW8du1DLmdjA09xbOyCHLi	\N	\N	2026-05-24 13:38:53.825	2026-05-17 14:05:34.649	2026-05-17 13:38:53.827	0	9c472309-f5b2-436d-aaaf-b266d3562c7d	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$aLcpVui8qTplzJICU1z4e.0GqOdKB52W9PgBatGSa8I72RQlVcVnC	\N	\N	2026-05-24 14:05:34.777	\N	2026-05-17 14:05:34.778	0	31f2ce29-f228-4516-99fa-0eaae8d01cc7	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$01bglfY54dWdS.hORKUmSuMVlZaSvUiAnR0TLMNClpCWu0qdNVwuO	\N	\N	2026-05-24 18:18:53.758	2026-05-17 18:31:53.608	2026-05-17 18:18:53.76	0	8560d749-fb32-40d4-a35c-43e2576aa882	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$encvXVvHzl0vk8SMu/pQP.SXdRHUaI38Q2EeciPonnTLmrw.frGPG	\N	\N	2026-05-24 14:05:34.811	2026-05-17 14:28:02.47	2026-05-17 14:05:34.813	0	45a71d41-1a92-4a80-beac-3bb3f70facc7	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$LdY/6Nprox28Hmh7qKVpXOiB1QJ7O.YXL.28FTnwuFjZnkafa4rKG	\N	\N	2026-05-24 14:28:02.505	\N	2026-05-17 14:28:02.506	0	ee8c1f99-be0c-41d7-bce6-bd11d0bd7591	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$KJ/d6Fy4KGPto3dZfntFX.jNIR2E8.1sIxBRI7WeA4dqA7e47duPq	\N	\N	2026-05-24 14:28:37.945	\N	2026-05-17 14:28:37.946	0	25476c0b-05cc-445d-bffd-0606bd9496d8	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$uwnI9b.by3Y1V1oGIwxkku3emSXSlgYWLqyahBhczAGNQcr233nDa	\N	\N	2026-05-24 14:28:02.611	2026-05-17 14:41:53.661	2026-05-17 14:28:02.612	0	c246ab80-f44d-487d-a4d6-39b532f5168d	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$6rDr4XDpj3PIRr6kf1K5yeAYY83IP0XyKVc7Hse3JUUfsh2fQuzq6	\N	\N	2026-05-24 14:53:16.658	\N	2026-05-17 14:53:16.659	0	502bfcd8-010c-4ebc-b330-3f4ee9945c64	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$dO35LwAiTvoBprtPgW7p1O59oLDjFRutwqQeq0L2uCbwVFgRegLtG	\N	\N	2026-05-24 14:41:53.824	2026-05-17 14:54:54.94	2026-05-17 14:41:53.826	0	5e02e9f3-4409-4790-bb38-d2d57a1f0fe4	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$AhIXY.bO46LzniRoIInES.G5VwgTmAJxBFoPv1Cp2poZrifzo2FV2	\N	\N	2026-05-24 14:54:55.524	2026-05-17 15:08:30	2026-05-17 14:54:55.526	0	441d5398-7158-444c-8922-47339dcd622b	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$rwrrTjWbXNDql5gyHXgJOOCowVM1xplOv2pXm.NOGS/j2HyEQDITi	\N	\N	2026-05-24 15:08:30.556	2026-05-17 15:21:53.561	2026-05-17 15:08:30.558	0	dec77652-08bd-4d8f-8dd3-76d99edeeeb3	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$W6YlSSzZ0w3AHpM0UOTrcuc6PLK6uVWl316iavr0muqj704FG8D/6	\N	\N	2026-05-24 15:21:53.688	2026-05-17 15:39:49.022	2026-05-17 15:21:53.689	0	e3c24e0f-e504-4623-8e45-de726fd60c55	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$KYPlytINm8zf3kTac2IBEeZ5BiZYhLrLrGdx8cIP0CAmYzizVqqX6	\N	\N	2026-05-24 15:39:49.196	\N	2026-05-17 15:39:49.198	0	bc628b34-b306-4384-a1b5-2c939b0433df	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$U/t/MXwvpiqhgfnBCp1QGe4qez5NKMjC6D5SVv.v3JpuJ4C/sn7rm	\N	\N	2026-05-24 15:39:49.224	2026-05-17 15:52:53.982	2026-05-17 15:39:49.226	0	137f7b47-8606-4718-8c18-a23976612003	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$utIqwFwL.nM.GqFJ7FzVCuvbZUnPVEQUDktkUDqTZcKWt8BaQu57K	\N	\N	2026-05-24 15:52:54.262	2026-05-17 16:05:53.827	2026-05-17 15:52:54.264	0	dd653757-6488-4352-9667-15f7dbee6bab	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$WlTzwy84dm4Ux7hsakWQZOYU0C4gXhXvY9V4lDhgXlh6ySQDvgEum	\N	\N	2026-05-24 16:05:54.122	2026-05-17 16:18:53.678	2026-05-17 16:05:54.126	0	3a05fdc8-bd4c-4298-8ab3-4cab735b949b	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$a7bMbuFg3JUq83QwAkPAp.eyaM/1TMF9QN6pg8OxvzIdpZq/6Juv.	\N	\N	2026-05-24 16:18:53.852	2026-05-17 16:31:53.662	2026-05-17 16:18:53.853	0	c794f774-b313-4887-a811-ce40734e67fe	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$4k3fD95vha1cN2tUvUW2MuRZvRjcbMWiawUV83Tc1pirZTtKirDEm	\N	\N	2026-05-24 16:31:53.879	2026-05-17 16:44:53.993	2026-05-17 16:31:53.881	0	0f3bbc81-1a2d-4738-a53d-e374ebd47a4a	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$l9leoHhuSEelBffK0cyMKeM1U4UBjpaK5dGrE6MOuZD7Vj6l2Lzzi	\N	\N	2026-05-24 16:44:54.44	2026-05-17 16:58:53.664	2026-05-17 16:44:54.441	0	e7ed33f5-da97-41f6-905a-c6c8ba76b202	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$6vbVav7eZ9cWOHY4aZA1z.4D4dL20b5aTl8M7ZeCp8Y14B3sFo/tW	\N	\N	2026-05-24 16:58:53.881	2026-05-17 17:11:53.718	2026-05-17 16:58:53.883	0	bac85443-1eaa-430e-be8b-27b8d34d9cfd	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$GiApzMIQ/apeyROjdCVp1Oqwnm6oR93ecaGDd44mwUptRW/ewZaI6	\N	\N	2026-05-24 17:11:53.856	2026-05-17 17:24:53.569	2026-05-17 17:11:53.857	0	5f249091-010d-411e-8657-3196df5c00b0	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$IRo/OhKHPKOJGEixdXRO6.NpYvQpg2qGBZ4I5dau0xayyO1WrRCwy	\N	\N	2026-05-24 17:24:53.709	2026-05-17 17:38:53.97	2026-05-17 17:24:53.71	0	1280fa72-63ea-4b46-a4aa-d6592987286b	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$zjWu3QKUUHgibenuOVbgceWfWBh868foUIdNM7HHhEZn.dS0m7PVi	\N	\N	2026-05-24 17:39:38.965	\N	2026-05-17 17:39:38.967	0	ca99e6c5-7385-44ee-ab83-6e26270b789d	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$7Me630Q3TW0BG8E3.XduzeahmHr/zHiKT1xBlTaCVyFpLgg3uAAGW	\N	\N	2026-05-24 17:38:54.205	2026-05-17 17:51:53.594	2026-05-17 17:38:54.207	0	13b3c641-5ca5-4ce3-8615-89cd38035785	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$y/CDXtLAVGPf3eV.LdXhSu.M32TbN4t.7BKlTCBGgoyHUFX1FDNtG	\N	\N	2026-05-24 17:51:53.736	2026-05-17 18:04:54.075	2026-05-17 17:51:53.737	0	104c4f4e-c162-4be8-9f8f-50c29824396b	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$cm5YSMP5N3ubfTZnIpWK0O9PNbwKTRa6hbVksvXN0WNyDfVNbbUvO	\N	\N	2026-05-24 18:12:51.28	\N	2026-05-17 18:12:51.282	0	db376c80-a448-4528-9281-024c41cc910b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$Z/O1xne6VwvOInxM4r/4D.qRs.fKQz3jVxN.Uu8i7L.DZSWIHjjpm	\N	\N	2026-05-24 18:17:18.358	\N	2026-05-17 18:17:18.36	0	ad9875a5-c285-4da0-9933-1b4f23a25805	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$6oMbuNamNSgcwFru8fR6muPBfCVLKbsLRazuaAEdVRFbaytlqUUKW	\N	\N	2026-05-24 18:04:54.284	2026-05-17 18:18:53.614	2026-05-17 18:04:54.285	0	7e367faa-95cd-4fe1-8b4b-476a0eb87c22	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$gIDcud.Y0if573CUDmUE2er5vmbkfKbA5/3XZQqkqpyLmKZ7DjKFW	\N	\N	2026-05-24 18:27:54.14	\N	2026-05-17 18:27:54.141	0	9da95577-2136-455d-ba22-934fba268946	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$CxbwsUGJTM.Rmv6X7wmJBeet1kXJGxtbXcMJv6nqQK3Qe8nL70aXG	\N	\N	2026-05-24 18:34:59.482	\N	2026-05-17 18:34:59.483	0	b270a39f-8470-4672-882e-3071271418da	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$oBgJIPRrE432yFQ9.fGVrOH1.Ic0oZJHPquPIpt/qIG/Q/j/37o9G	\N	\N	2026-05-24 18:31:53.753	2026-05-17 18:44:53.715	2026-05-17 18:31:53.755	0	ce7b0d14-08d7-4157-ad1e-8b64be5d05b2	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$n7DwrFs4NQcPanoO668R9.cBJjryiCMjcpmfOXdsD3mYDFgIS3bmK	\N	\N	2026-05-24 18:48:59.489	\N	2026-05-17 18:48:59.49	0	3a999925-4ce2-4315-bb9d-c1b73117bed5	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$gczLOTYmGnXSg1VUhSIiYOlpnb0ch07Hv6dAx4CO5E2BUGFztgUOS	\N	\N	2026-05-24 18:44:53.892	2026-05-17 18:57:53.74	2026-05-17 18:44:53.894	0	9c678277-b106-4b6a-b4a3-0a7ee86fcbe0	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$OjWtiWm5L.JuzvgOns1RnexnfEXQDhZqW0/IpR6iLyBPr0R12pd1a	\N	\N	2026-05-24 18:57:53.881	\N	2026-05-17 18:57:53.882	0	9b6f9547-b81b-4a66-9160-d6dc9bdc8a74	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$WqfRrI4W4UNloL7/eoqy6ufReHBmAAFvJpbq0nFn03vb0hmOc29se	\N	\N	2026-05-24 19:00:12.164	\N	2026-05-17 19:00:12.165	0	acd26203-ea67-4203-a6b0-4ec75b4acf95	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$I1UNnZJrBixUQpzpBoL00.i0ta3hagvYV0yfM7pwnPpGPBXkG.aR2	\N	\N	2026-05-25 04:54:56.176	\N	2026-05-18 04:54:56.177	0	b09f3200-7c10-402a-9caa-5a01570882b9	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$jzUaCRUengIVdD2ChFQJpOEw1HKDum.L3W7COUEoPQbAP6j6QcqFe	\N	\N	2026-05-25 04:58:03.864	\N	2026-05-18 04:58:03.866	0	1d6aa134-7352-4664-bc9b-b380ecd6d02c	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$KP4NJzboafbyhHPPYGLRxOcq5yw4vTnXsD083S8EJMqFkOyRPmnGe	\N	\N	2026-05-25 04:58:51.224	\N	2026-05-18 04:58:51.225	0	0e0f2bf0-a8d6-45f7-95d3-ed55e620b51b	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$kIbYRcHElFYnHBet76xN8.Npc2nVIuiWFP26urNV.Si2hbVgBgvy6	\N	\N	2026-05-25 05:02:54.394	\N	2026-05-18 05:02:54.395	0	31b00cf2-7af9-4769-9b2d-d63ef0fb9cfe	92e50b41-bfb7-41cb-92c5-c8a26fcd5221
$2b$10$q0IbNhFF1uVWKFPzQTP2a.k4GQObN001B9pOMPTpWSahOfykpmGCy	\N	\N	2026-05-25 05:05:37.58	\N	2026-05-18 05:05:37.591	0	828a52de-0353-4cd7-b6f0-6d6aaef1931e	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$CTEzpEsRUsgb271HfkYW4Ochq2Hp2udVdKXygbjWNI2fq44izcfUS	\N	\N	2026-05-25 05:07:10.269	\N	2026-05-18 05:07:10.27	0	c337a667-62c8-47c6-b315-7eaa33326f91	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$Q26KfaSXIifnxjFHnrHyXeiFefRivMIIax733Fz0Mi0wH48oHGRPS	\N	\N	2026-05-25 05:08:14.007	\N	2026-05-18 05:08:14.01	0	5441cbf4-96f7-46e4-96f5-62aab4108dcb	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$JNhA8wJWvNgh7aKbFTmZ8uBXYfd60taWURtg1FQAwl/qfq7JOxO16	\N	\N	2026-05-25 05:09:44.658	\N	2026-05-18 05:09:44.659	0	740cf7d3-adad-425a-b388-6db06e06a2c9	92e50b41-bfb7-41cb-92c5-c8a26fcd5221
$2b$10$sqcVJWc16yIPtQtK1XpC3.ZNJtuRPTd9YtumUPstYqsHoqyPhb3fq	\N	\N	2026-05-25 05:13:52.156	\N	2026-05-18 05:13:52.158	0	8b373861-989b-46d9-b1ef-dc907307dc77	9f08f905-999a-4c6f-87bc-66e29dc6301e
$2b$10$YdS1eze1fWGB.878Lnu2H.QftZL3kgb5OXeA383vE9xV7UJCXAmvK	\N	\N	2026-05-25 05:19:31.917	\N	2026-05-18 05:19:31.918	0	91879c06-fe5f-4e53-8bb0-688816b0ad1f	89b2ee87-2a07-4fe9-82e7-72a9addb7299
$2b$10$hvkxKOHAFTQiWzALwpj4oeVBGwgBN8dtDuft6/RIrIC0wNbXyySoe	\N	\N	2026-05-25 05:21:39.565	\N	2026-05-18 05:21:39.568	0	4c22e200-f931-43af-a3fc-40a2ca674ca7	9f08f905-999a-4c6f-87bc-66e29dc6301e
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
248644d0-54e1-4832-9f8c-0ca12117ec74	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "instanceName": "gpu-instance-7463", "interfaceMode": "gui"}	\N	2026-05-15 06:31:51.399
773b114f-6add-4eb2-8a39-151571eb206d	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_initiated	{"launchId": "a311e1c4-bbfa-473e-9e1d-70c1e915fd61", "containerName": "laas-2193b82f"}	\N	2026-05-15 06:31:51.469
831c470b-0c08-460d-836d-c3d7e1c7a037	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_scheduling	{"ts": "2026-05-15T06:31:51.473730+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-15 06:31:53.49
fffbc9e4-dc1d-4aa1-93c8-8d2a59b307c2	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_scheduling	{"ts": "2026-05-15T06:31:51.573880+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-15 06:31:53.493
e4019785-6a50-4d98-83c1-50db612d456d	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_allocating_ports	{"ts": "2026-05-15T06:31:51.574008+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-15 06:31:53.495
f8e08a10-7c73-4ca1-8623-dc9c7f2b709b	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_allocating_ports	{"ts": "2026-05-15T06:31:51.648955+00:00", "status": "completed", "message": "Allocated ports: nginx=8102, selkies=9102, metrics=19102, display=:21"}	\N	2026-05-15 06:31:53.497
cbde8bdc-8643-4880-a9b7-373a343a5595	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_allocating_cpus	{"ts": "2026-05-15T06:31:51.648967+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-15 06:31:53.5
46391f17-a44f-41c6-b719-418e35f38c32	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_allocating_cpus	{"ts": "2026-05-15T06:31:51.684177+00:00", "status": "completed", "message": "Allocated CPU cores: 10-11"}	\N	2026-05-15 06:31:53.502
bc2e0714-8a04-47cb-a6a1-dd116bbd53e3	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_allocating_storage	{"ts": "2026-05-15T06:31:51.684193+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-15 06:31:53.503
40b09e44-73b9-4422-b89d-613bba926ae8	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_allocating_storage	{"ts": "2026-05-15T06:31:51.684204+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_2193b82f-48ff-4f31-89a1-dc45b2d1efa2..."}	\N	2026-05-15 06:31:53.505
ea049416-c304-430b-912c-4cc22ce68653	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_allocating_storage	{"ts": "2026-05-15T06:31:52.398895+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_2193b82f-48ff-4f31-89a1-dc45b2d1efa2"}	\N	2026-05-15 06:31:53.51
9adef4cf-d462-436d-8828-2237ec12f381	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_creating	{"ts": "2026-05-15T06:31:52.398958+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-15 06:31:53.512
fda92704-eb9a-4d8c-8de4-d50b150ab454	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_creating	{"ts": "2026-05-15T06:31:52.486150+00:00", "status": "completed", "message": "Container created: laas-2193b82f"}	\N	2026-05-15 06:31:53.514
4cc632d9-d41d-4144-a6be-d5532970c1ac	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_starting	{"ts": "2026-05-15T06:31:52.486162+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-15 06:31:53.516
5e6f286d-1c5a-4bc5-8b4a-5e7f88ece692	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_starting	{"ts": "2026-05-15T06:31:52.929871+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-15 06:31:53.518
83c9c779-594f-4430-a4fb-f3d84267ec95	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_waiting_desktop	{"ts": "2026-05-15T06:31:52.929890+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8102..."}	\N	2026-05-15 06:31:53.519
c9a6c534-9acf-4179-9563-a8868e0e76af	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_waiting_desktop	{"ts": "2026-05-15T06:32:09.091560+00:00", "status": "completed", "message": "Desktop responding on port 8102 (HTTP 401)"}	\N	2026-05-15 06:32:09.717
374980b3-a661-44f2-93ea-50d705f534a4	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_waiting_desktop	{"ts": "2026-05-15T06:32:09.091578+00:00", "status": "completed", "message": "Desktop responding on port 8102"}	\N	2026-05-15 06:32:09.722
b144645a-38d5-437e-a477-62bb1eb7bd46	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_health_checking	{"ts": "2026-05-15T06:32:09.091583+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-15 06:32:09.725
eb21bcb5-b9f3-4f51-92fd-e6922fcdd9d9	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_health_checking	{"ts": "2026-05-15T06:32:11.100298+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-15 06:32:11.766
bdbde1de-29c6-4302-9a93-fbbd56455fa1	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_ready	{"ts": "2026-05-15T06:32:11.100314+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-15 06:32:11.769
cddeba61-67ee-42f2-a141-248abb20ae1a	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	launch_ready	{"ts": "2026-05-15T06:32:11.100323+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-15 06:32:11.772
d68eb015-e441-487a-8d66-943af5024ee2	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	session_ready	{"nginxPort": 8102, "sessionUrl": "http://100.94.157.114:8102/", "selkiesPort": 9102, "displayNumber": 21}	\N	2026-05-15 06:32:11.79
442c61c3-b015-4a56-81f2-ee38afff1f88	ace083ca-0ae6-4876-89e0-e9fb56f8d851	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "instanceName": "gpu-instance-buf4", "interfaceMode": "gui"}	\N	2026-05-18 05:07:30.701
7ac44e0e-424c-4cd8-88c8-b0034368f9f9	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_initiated	{"launchId": "158bd134-2b00-4a1e-96c8-eb8565869068", "containerName": "laas-ace083ca"}	\N	2026-05-18 05:07:30.811
7d951bdd-8b7c-4ebe-92fd-bb7ee3edb7e4	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_scheduling	{"ts": "2026-05-18T05:07:32.042147+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-18 05:07:32.978
80e67e52-a438-4dee-9111-4dacbd566885	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_scheduling	{"ts": "2026-05-18T05:07:32.142309+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-18 05:07:32.98
dc0ed9ce-6afb-455d-92e8-90628db954dd	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_allocating_ports	{"ts": "2026-05-18T05:07:32.142394+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-18 05:07:32.982
22a4c6bb-9a26-46ee-b458-ce28ec7695ca	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_allocating_ports	{"ts": "2026-05-18T05:07:32.268287+00:00", "status": "completed", "message": "Allocated ports: nginx=8103, selkies=9103, metrics=19103, display=:22"}	\N	2026-05-18 05:07:32.984
014a264f-e868-457a-b3ab-e56577ad3085	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_allocating_cpus	{"ts": "2026-05-18T05:07:32.268299+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-18 05:07:32.986
f027db49-12ef-4b3e-abf8-9079d36e5367	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_allocating_cpus	{"ts": "2026-05-18T05:07:32.325032+00:00", "status": "completed", "message": "Allocated CPU cores: 12-13"}	\N	2026-05-18 05:07:32.988
63d50831-512d-4d26-9804-d31e50f324b7	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_allocating_storage	{"ts": "2026-05-18T05:07:32.325053+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-18 05:07:32.99
77d0c0d9-4a20-4f66-89b9-72ec124f2281	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_allocating_storage	{"ts": "2026-05-18T05:07:32.325058+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_ace083ca-0ae6-4876-89e0-e9fb56f8d851..."}	\N	2026-05-18 05:07:32.992
1b85013a-83ab-486f-84d3-6cfe113f2185	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_allocating_storage	{"ts": "2026-05-18T05:07:33.026409+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_ace083ca-0ae6-4876-89e0-e9fb56f8d851"}	\N	2026-05-18 05:07:32.994
e68c76f0-28c7-4bd8-a4f7-393ed75a7cf7	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_creating	{"ts": "2026-05-18T05:07:33.026464+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-18 05:07:32.996
83dfa500-b1ea-4c15-a00a-402842d033f6	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_creating	{"ts": "2026-05-18T05:07:33.104928+00:00", "status": "completed", "message": "Container created: laas-ace083ca"}	\N	2026-05-18 05:07:32.998
65bca58e-b612-4443-89b3-ea277c431324	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_starting	{"ts": "2026-05-18T05:07:33.104935+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-18 05:07:32.999
20d3d1cd-d845-4945-821c-e827c273565c	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_starting	{"ts": "2026-05-18T05:07:33.403435+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-18 05:07:33.001
a43ed473-0598-4977-828d-00b241f612be	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_waiting_desktop	{"ts": "2026-05-18T05:07:33.403450+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8103..."}	\N	2026-05-18 05:07:33.007
01f40bf7-a534-41bc-bf4a-dd8cf13602de	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_waiting_desktop	{"ts": "2026-05-18T05:07:51.594783+00:00", "status": "completed", "message": "Desktop responding on port 8103 (HTTP 401)"}	\N	2026-05-18 05:07:51.373
bb8d856d-9114-4fbd-a9bf-b912412a181d	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_waiting_desktop	{"ts": "2026-05-18T05:07:51.594797+00:00", "status": "completed", "message": "Desktop responding on port 8103"}	\N	2026-05-18 05:07:51.375
70989a3b-50cf-47ce-9777-5f13c57f29b6	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_health_checking	{"ts": "2026-05-18T05:07:51.594799+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-18 05:07:51.377
8f2ece4f-2b01-43f2-9e09-d987ca2b9003	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_health_checking	{"ts": "2026-05-18T05:07:53.603984+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-18 05:07:53.418
0aa0331f-dd90-4c16-a79b-1d82136aff9c	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_ready	{"ts": "2026-05-18T05:07:53.603999+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-18 05:07:53.42
bc01d23e-92b5-43dc-9661-1dd8b0704524	ace083ca-0ae6-4876-89e0-e9fb56f8d851	launch_ready	{"ts": "2026-05-18T05:07:53.604007+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-18 05:07:53.421
10b02cfc-849c-44c6-8992-e47e7a3474b2	ace083ca-0ae6-4876-89e0-e9fb56f8d851	session_ready	{"nginxPort": 8103, "sessionUrl": "http://100.94.157.114:8103/", "selkiesPort": 9103, "displayNumber": 22}	\N	2026-05-18 05:07:53.431
0c9a6060-d663-4a58-b50a-ada5d7be3ec2	3eeef689-38d9-401f-ae54-5c1369f6a554	session_created	{"configName": "Inferno", "configSlug": "inferno", "storageType": "ephemeral", "instanceName": "gpu-instance-2c9s", "interfaceMode": "gui"}	\N	2026-05-18 05:09:55.154
cc65ba39-adcb-4527-9d9d-283b5c455219	3eeef689-38d9-401f-ae54-5c1369f6a554	launch_initiated	{"launchId": "9c33b4f2-dcf8-45b2-b704-dfcddd7d8995", "containerName": "laas-3eeef689"}	\N	2026-05-18 05:09:55.287
5812f66c-55f7-417c-ae6e-f40916b239f3	3eeef689-38d9-401f-ae54-5c1369f6a554	launch_scheduling	{"ts": "2026-05-18T05:09:56.548390+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-18 05:09:57.315
f9a196fa-f7a1-4416-acd0-7812c44d21e7	3eeef689-38d9-401f-ae54-5c1369f6a554	launch_scheduling	{"ts": "2026-05-18T05:09:56.648523+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-18 05:09:57.318
d830abfe-4e8f-49df-b3b9-f821375de4b3	3eeef689-38d9-401f-ae54-5c1369f6a554	launch_allocating_ports	{"ts": "2026-05-18T05:09:56.648571+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-18 05:09:57.32
08b15f30-65e1-4625-9828-fd829bcabf79	3eeef689-38d9-401f-ae54-5c1369f6a554	launch_allocating_ports	{"ts": "2026-05-18T05:09:56.809440+00:00", "status": "completed", "message": "Allocated ports: nginx=8104, selkies=9104, metrics=19104, display=:23"}	\N	2026-05-18 05:09:57.322
44864778-4220-4174-95d8-37e7e5cf7b0f	3eeef689-38d9-401f-ae54-5c1369f6a554	launch_allocating_cpus	{"ts": "2026-05-18T05:09:56.809453+00:00", "status": "in_progress", "message": "Finding 8 contiguous CPU cores..."}	\N	2026-05-18 05:09:57.324
c6e7c9ef-4143-466b-8688-7648564942f1	3eeef689-38d9-401f-ae54-5c1369f6a554	launch_allocating_cpus	{"ts": "2026-05-18T05:09:56.886176+00:00", "status": "failed", "message": "No contiguous block of 8 cores available"}	\N	2026-05-18 05:09:57.326
8f4c8252-3e83-4f68-b9b6-e0e8a4bb4ae2	3eeef689-38d9-401f-ae54-5c1369f6a554	launch_failed	{"reason": "No contiguous block of 8 cores available"}	\N	2026-05-18 05:09:57.358
56635bb8-e7c4-47bc-9360-1b6b394122a5	ad712de6-33f4-4292-82fe-e1c11b056f34	session_created	{"configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "instanceName": "gpu-instance-q7zg", "interfaceMode": "gui"}	\N	2026-05-18 05:11:56.013
abb5ec4d-d349-47cb-b247-f04d4987e42a	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_initiated	{"launchId": "3b056e18-d5b3-4bde-b7c8-ede8b1b15864", "containerName": "laas-ad712de6"}	\N	2026-05-18 05:11:56.062
943897d3-4a79-45e4-bfc9-4e4a75395760	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_scheduling	{"ts": "2026-05-18T05:11:57.325132+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-18 05:11:58.084
02cf0b6a-b23c-4e0d-a1ab-4354f2c685e8	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_scheduling	{"ts": "2026-05-18T05:11:57.425301+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-18 05:11:58.086
527f15e9-555c-45a7-ab67-dc655b9b8fca	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_allocating_ports	{"ts": "2026-05-18T05:11:57.425416+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-18 05:11:58.088
4e95c3e7-36b3-4957-9363-f35ed5eeaca0	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_allocating_ports	{"ts": "2026-05-18T05:11:57.588601+00:00", "status": "completed", "message": "Allocated ports: nginx=8104, selkies=9104, metrics=19104, display=:23"}	\N	2026-05-18 05:11:58.09
f52b0b6e-b5ad-4d89-8a38-1b4249afd841	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_allocating_cpus	{"ts": "2026-05-18T05:11:57.588610+00:00", "status": "in_progress", "message": "Finding 2 contiguous CPU cores..."}	\N	2026-05-18 05:11:58.091
1807f661-37bd-40ae-bfa4-cce19943b5af	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_allocating_cpus	{"ts": "2026-05-18T05:11:57.668189+00:00", "status": "completed", "message": "Allocated CPU cores: 14-15"}	\N	2026-05-18 05:11:58.093
4af7ac78-9bb2-44fe-878c-a272fe862e8b	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_allocating_storage	{"ts": "2026-05-18T05:11:57.668205+00:00", "status": "in_progress", "message": "Creating 10240MB ephemeral zvol..."}	\N	2026-05-18 05:11:58.094
0abb4cfe-6f12-4b18-bf61-d184635b7dce	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_allocating_storage	{"ts": "2026-05-18T05:11:57.668211+00:00", "status": "in_progress", "message": "Creating 10G zvol datapool/ephemeral/sess_ad712de6-33f4-4292-82fe-e1c11b056f34..."}	\N	2026-05-18 05:11:58.096
c140174d-d9da-43c4-b888-2c9276723dbd	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_allocating_storage	{"ts": "2026-05-18T05:11:58.369093+00:00", "status": "completed", "message": "Ephemeral zvol created at /datapool/ephemeral/sess_ad712de6-33f4-4292-82fe-e1c11b056f34"}	\N	2026-05-18 05:11:58.097
11018205-91c5-4700-bf76-0f86ae0068cf	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_creating	{"ts": "2026-05-18T05:11:58.369143+00:00", "status": "in_progress", "message": "Building Docker command and creating container..."}	\N	2026-05-18 05:11:58.099
079b212d-cc53-435d-b361-cbde4f3a61a4	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_creating	{"ts": "2026-05-18T05:11:58.455886+00:00", "status": "completed", "message": "Container created: laas-ad712de6"}	\N	2026-05-18 05:11:58.101
c6733659-f2aa-44bb-9b97-0c298bf94f91	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_starting	{"ts": "2026-05-18T05:11:58.455901+00:00", "status": "in_progress", "message": "Starting container..."}	\N	2026-05-18 05:11:58.103
db2e9aff-6067-4e92-b6c4-0914e3dac073	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_starting	{"ts": "2026-05-18T05:11:58.758165+00:00", "status": "completed", "message": "Container started successfully"}	\N	2026-05-18 05:11:58.105
a3c7723e-d108-47b5-8533-f7222f11e2be	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_waiting_desktop	{"ts": "2026-05-18T05:11:58.758180+00:00", "status": "in_progress", "message": "Waiting for desktop to initialize on port 8104..."}	\N	2026-05-18 05:11:58.107
fe634825-4074-4472-95f3-0032fea1642c	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_waiting_desktop	{"ts": "2026-05-18T05:12:14.916313+00:00", "status": "completed", "message": "Desktop responding on port 8104 (HTTP 401)"}	\N	2026-05-18 05:12:14.323
c395c5b5-93b1-4339-b94a-f66b2e4f4920	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_waiting_desktop	{"ts": "2026-05-18T05:12:14.916328+00:00", "status": "completed", "message": "Desktop responding on port 8104"}	\N	2026-05-18 05:12:14.439
a24c0152-a244-4125-b504-3c2a8c55bb0e	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_health_checking	{"ts": "2026-05-18T05:12:14.916331+00:00", "status": "in_progress", "message": "Verifying WebRTC stream accessibility..."}	\N	2026-05-18 05:12:14.442
66b7519b-2202-4f7c-8682-17334d6e2744	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_health_checking	{"ts": "2026-05-18T05:12:16.924713+00:00", "status": "completed", "message": "WebRTC stream health check passed"}	\N	2026-05-18 05:12:16.562
b29995ce-2ad8-45ed-a77a-958381211a70	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_ready	{"ts": "2026-05-18T05:12:16.924730+00:00", "status": "in_progress", "message": "Session is live and ready for connection"}	\N	2026-05-18 05:12:16.565
8406c420-2868-493f-8145-bc3f2766f3db	ad712de6-33f4-4292-82fe-e1c11b056f34	launch_ready	{"ts": "2026-05-18T05:12:16.924739+00:00", "status": "completed", "message": "Session ready for connection"}	\N	2026-05-18 05:12:16.566
4150b299-48af-41ad-ba01-6e9503b02a05	ad712de6-33f4-4292-82fe-e1c11b056f34	session_ready	{"nginxPort": 8104, "sessionUrl": "http://100.94.157.114:8104/", "selkiesPort": 9104, "displayNumber": 23}	\N	2026-05-18 05:12:16.576
2f6fbec7-d2f2-4eb2-b571-4997237ee73e	a6511603-d97c-4241-a118-dd0c66c87dc8	session_created	{"configName": "Blaze", "configSlug": "blaze", "storageType": "ephemeral", "instanceName": "gpu-instance-szdu", "interfaceMode": "gui"}	\N	2026-05-18 05:13:23.268
6ebf980d-43e6-45bc-a82b-0ad1f0b1d98b	a6511603-d97c-4241-a118-dd0c66c87dc8	launch_initiated	{"launchId": "b90585cc-9ad2-4d46-bcd0-4418e9256887", "containerName": "laas-a6511603"}	\N	2026-05-18 05:13:23.318
b0a09e9d-55a9-4500-a39d-45296870e324	a6511603-d97c-4241-a118-dd0c66c87dc8	launch_scheduling	{"ts": "2026-05-18T05:13:24.577744+00:00", "status": "in_progress", "message": "Validating launch parameters..."}	\N	2026-05-18 05:13:25.35
83d09083-b0c1-4f01-8f3c-0e1de8a0a6db	a6511603-d97c-4241-a118-dd0c66c87dc8	launch_scheduling	{"ts": "2026-05-18T05:13:24.678354+00:00", "status": "completed", "message": "Parameters validated successfully"}	\N	2026-05-18 05:13:25.352
dbc7fec1-e6ad-46c7-b606-3e1753f7ac5f	a6511603-d97c-4241-a118-dd0c66c87dc8	launch_allocating_ports	{"ts": "2026-05-18T05:13:24.678483+00:00", "status": "in_progress", "message": "Finding available port triplet..."}	\N	2026-05-18 05:13:25.355
31e65fc9-72ad-494b-91b4-724a5ef8bbbe	a6511603-d97c-4241-a118-dd0c66c87dc8	launch_allocating_ports	{"ts": "2026-05-18T05:13:24.883743+00:00", "status": "completed", "message": "Allocated ports: nginx=8105, selkies=9105, metrics=19105, display=:24"}	\N	2026-05-18 05:13:25.357
e6b43c6c-ecc2-47ae-83f7-47315970f6e9	a6511603-d97c-4241-a118-dd0c66c87dc8	launch_allocating_cpus	{"ts": "2026-05-18T05:13:24.883756+00:00", "status": "in_progress", "message": "Finding 4 contiguous CPU cores..."}	\N	2026-05-18 05:13:25.359
b84efa00-ae84-4db1-9a7f-58019b4b6168	a6511603-d97c-4241-a118-dd0c66c87dc8	launch_allocating_cpus	{"ts": "2026-05-18T05:13:24.983982+00:00", "status": "failed", "message": "No contiguous block of 4 cores available"}	\N	2026-05-18 05:13:25.361
ef5a3bf2-d19d-4f6f-b3d7-ba51d27183ee	a6511603-d97c-4241-a118-dd0c66c87dc8	launch_failed	{"reason": "No contiguous block of 4 cores available"}	\N	2026-05-18 05:13:25.384
0d47e05d-c8c3-4267-80b0-2b82d02bb8ad	ad712de6-33f4-4292-82fe-e1c11b056f34	session_terminated	{"terminatedBy": "92e50b41-bfb7-41cb-92c5-c8a26fcd5221", "totalCostCents": 12000, "durationSeconds": 403, "terminationReason": "user_requested", "alreadyBilledCents": 12000, "remainingChargeCents": 0}	\N	2026-05-18 05:19:00.089
0af72e1c-74a7-4c08-94cc-ec6cb6e595e1	ace083ca-0ae6-4876-89e0-e9fb56f8d851	session_terminated	{"terminatedBy": "89b2ee87-2a07-4fe9-82e7-72a9addb7299", "totalCostCents": 12000, "durationSeconds": 705, "terminationReason": "user_requested", "alreadyBilledCents": 12000, "remainingChargeCents": 0}	\N	2026-05-18 05:19:39.247
c10d7c65-5957-43e8-9b8d-24b4a643e914	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	session_terminated	{"terminatedBy": "89b2ee87-2a07-4fe9-82e7-72a9addb7299", "totalCostCents": 852000, "durationSeconds": 254940, "terminationReason": "user_requested", "alreadyBilledCents": 456000, "remainingChargeCents": 396000}	\N	2026-05-18 05:21:12.143
\.


--
-- TOC entry 6041 (class 0 OID 152000)
-- Dependencies: 269
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, user_id, organization_id, compute_config_id, booking_id, node_id, session_type, container_id, container_name, nginx_port, selkies_port, display_number, session_token_hash, session_url, status, started_at, ended_at, scheduled_end_at, last_activity_at, nfs_mount_path, base_image_id, actual_gpu_vram_mb, actual_hami_sm_percent, reconnect_count, last_reconnect_at, auto_preserve_files, avg_rtt_ms, avg_packet_loss_ratio, resource_snapshot, created_at, updated_at, created_by, updated_by, allocated_gpu_vram_mb, allocated_hami_sm_percent, allocated_memory_mb, allocated_vcpu, allocation_snapshot_at, cost_last_updated_at, cumulative_cost_cents, duration_seconds, instance_name, storage_mode, terminated_at, terminated_by, termination_details, termination_reason, storage_node_id, storage_transport, ephemeral_storage_path, ephemeral_storage_size_mb) FROM stdin;
3eeef689-38d9-401f-ae54-5c1369f6a554	92e50b41-bfb7-41cb-92c5-c8a26fcd5221	\N	73119ef1-e3eb-48a3-be9a-8e2f55c11ba8	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-3eeef689	\N	\N	\N	\N	\N	failed	\N	2026-05-18 05:09:57.337	\N	\N	\N	\N	8192	33	0	\N	f	\N	\N	{"vcpu": 8, "gpuModel": "RTX 4090", "memoryMb": 16384, "gpuVramMb": 8192, "configName": "Inferno", "configSlug": "inferno", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 33, "interfaceMode": "gui", "basePricePerHourCents": 30000}	2026-05-18 05:09:55.134	2026-05-18 05:09:57.339	\N	\N	8192	33	16384	8	2026-05-18 05:09:55.132	\N	0	\N	gpu-instance-2c9s	ephemeral	\N	\N	\N	error_unrecoverable	\N	\N	/datapool/ephemeral/sess_3eeef689-38d9-401f-ae54-5c1369f6a554	10240
a6511603-d97c-4241-a118-dd0c66c87dc8	92e50b41-bfb7-41cb-92c5-c8a26fcd5221	\N	46756643-41f5-4eb1-a161-d5b595b4e0c8	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-a6511603	\N	\N	\N	\N	\N	failed	\N	2026-05-18 05:13:25.369	\N	\N	\N	\N	4096	17	0	\N	f	\N	\N	{"vcpu": 4, "gpuModel": "RTX 4090", "memoryMb": 8192, "gpuVramMb": 4096, "configName": "Blaze", "configSlug": "blaze", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 17, "interfaceMode": "gui", "basePricePerHourCents": 21000}	2026-05-18 05:13:23.246	2026-05-18 05:13:25.371	\N	\N	4096	17	8192	4	2026-05-18 05:13:23.244	\N	0	\N	gpu-instance-szdu	ephemeral	\N	\N	\N	error_unrecoverable	\N	\N	/datapool/ephemeral/sess_a6511603-d97c-4241-a118-dd0c66c87dc8	10240
ad712de6-33f4-4292-82fe-e1c11b056f34	92e50b41-bfb7-41cb-92c5-c8a26fcd5221	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-ad712de6	8104	9104	23	\N	http://100.94.157.114:8104/	ended	2026-05-18 05:12:16.57	2026-05-18 05:18:59.999	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "289cdd916faf02b0ada77acc5c5a7c7c", "encryptedPasswordIv": "d6635fd7fc2fb7f229a1597f", "encryptedPasswordTag": "0adc36d9f7a5012ffdb73015cfc1b2f3", "basePricePerHourCents": 12000}	2026-05-18 05:11:56.003	2026-05-18 05:19:00.068	\N	\N	2048	8	4096	2	2026-05-18 05:11:56.001	2026-05-18 05:18:59.999	12000	403	gpu-instance-q7zg	ephemeral	2026-05-18 05:18:59.999	92e50b41-bfb7-41cb-92c5-c8a26fcd5221	\N	user_requested	\N	\N	/datapool/ephemeral/sess_ad712de6-33f4-4292-82fe-e1c11b056f34	10240
ace083ca-0ae6-4876-89e0-e9fb56f8d851	89b2ee87-2a07-4fe9-82e7-72a9addb7299	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-ace083ca	8103	9103	22	\N	http://100.94.157.114:8103/	ended	2026-05-18 05:07:53.426	2026-05-18 05:19:39.21	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "d43707b12d723fac1557ee2cc3aa696b", "encryptedPasswordIv": "3b16e8c66d275f54db90817a", "encryptedPasswordTag": "8b5da4b0dbc1319837173110141d9992", "basePricePerHourCents": 12000}	2026-05-18 05:07:30.674	2026-05-18 05:19:39.235	\N	\N	2048	8	4096	2	2026-05-18 05:07:30.673	2026-05-18 05:19:39.21	12000	705	gpu-instance-buf4	ephemeral	2026-05-18 05:19:39.21	89b2ee87-2a07-4fe9-82e7-72a9addb7299	\N	user_requested	\N	\N	/datapool/ephemeral/sess_ace083ca-0ae6-4876-89e0-e9fb56f8d851	10240
2193b82f-48ff-4f31-89a1-dc45b2d1efa2	89b2ee87-2a07-4fe9-82e7-72a9addb7299	\N	d2fb06af-8256-4105-812b-05a10cbe99a1	\N	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	stateful_desktop	\N	laas-2193b82f	8102	9102	21	\N	http://100.94.157.114:8102/	ended	2026-05-15 06:32:11.779	2026-05-18 05:21:12.078	\N	\N	\N	\N	2048	8	0	\N	f	\N	\N	{"vcpu": 2, "gpuModel": "RTX 4090", "memoryMb": 4096, "gpuVramMb": 2048, "configName": "Spark", "configSlug": "spark", "storageType": "ephemeral", "nodeGpuModel": "RTX 4090", "nodeHostname": "laas-node-02", "hamiSmPercent": 8, "interfaceMode": "gui", "encryptedPassword": "c98dbc38872fa5ef516e9a2cd9858fcc", "encryptedPasswordIv": "04aa20ea2f4875f5049b422b", "encryptedPasswordTag": "f3b6ff55fbf90cf156a06403cc34aeca", "basePricePerHourCents": 12000}	2026-05-15 06:31:51.35	2026-05-18 05:21:12.127	\N	\N	2048	8	4096	2	2026-05-15 06:31:51.347	2026-05-18 05:21:12.078	852000	254940	gpu-instance-7463	ephemeral	2026-05-18 05:21:12.078	89b2ee87-2a07-4fe9-82e7-72a9addb7299	\N	user_requested	\N	\N	/datapool/ephemeral/sess_2193b82f-48ff-4f31-89a1-dc45b2d1efa2	10240
\.


--
-- TOC entry 6042 (class 0 OID 152021)
-- Dependencies: 270
-- Data for Name: storage_extensions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.storage_extensions (id, user_id, storage_volume_id, extension_type, previous_quota_bytes, new_quota_bytes, extension_bytes, amount_cents, currency, payment_transaction_id, wallet_transaction_id, notes, created_at, created_by) FROM stdin;
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
f51c2f40-158b-4412-857d-c0675a160f04	54d2f9e7-c608-45e2-b740-2abafa15abc5	66f940dc-4ee5-4d3b-948e-940e1493028e	t	2026-05-14 15:59:53.402	2026-05-14 15:59:53.402	\N	\N
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
\N	2026-05-14 15:57:40.086	2026-05-14 15:57:40.086	\N	\N	04a94108-bcbd-4eab-9807-a3959a0b31cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	07b07401-b326-4045-af3a-44a7c45e56d8	42abadfe-edfa-4b0e-985d-adaa65091959	\N
\N	2026-05-14 15:59:38.764	2026-05-14 15:59:38.764	\N	\N	94793b3f-105a-4e78-adfa-2f1fc7fa345f	54d2f9e7-c608-45e2-b740-2abafa15abc5	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	f231dfb8-cb4c-4942-bb56-852cf0884569	\N
\N	2026-05-15 07:33:03.993	2026-05-15 07:33:03.993	\N	\N	61ff92ba-a2c2-49ec-8aed-009e74d51569	9f08f905-999a-4c6f-87bc-66e29dc6301e	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	c99954e1-3820-442c-a1cb-33f9cde68672	\N
\N	2026-05-15 07:33:04.025	2026-05-15 07:33:04.025	\N	\N	a8b4dec5-8557-420f-ba33-3363c93a0993	bd8f8f80-a9ab-43e9-999f-b653f359e4c9	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	ee7518c5-3ed0-4025-8aa5-d5c0eca54787	\N
\N	2026-05-18 05:02:53.102	2026-05-18 05:02:53.102	\N	\N	f8eb57c7-0179-44da-8d75-3f5b3c09d652	92e50b41-bfb7-41cb-92c5-c8a26fcd5221	07b07401-b326-4045-af3a-44a7c45e56d8	42abadfe-edfa-4b0e-985d-adaa65091959	\N
\.


--
-- TOC entry 6058 (class 0 OID 152239)
-- Dependencies: 286
-- Data for Name: user_policy_consents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_policy_consents (policy_slug, policy_version, agreed_at, ip_address, created_at, created_by, id, user_id) FROM stdin;
acceptable_use	\N	2026-05-14 15:59:38.767	127.0.0.1	2026-05-14 15:59:38.768	\N	2713dd2f-54a3-4538-9b83-26c412f81bc7	54d2f9e7-c608-45e2-b740-2abafa15abc5
user_content_disclaimer	\N	2026-05-14 15:59:38.773	127.0.0.1	2026-05-14 15:59:38.774	\N	67832deb-b603-41a0-8c6b-bf4040dee31a	54d2f9e7-c608-45e2-b740-2abafa15abc5
console_tos	\N	2026-05-14 15:59:38.776	127.0.0.1	2026-05-14 15:59:38.777	\N	de8a134d-7703-4c39-b834-613a7c0e1323	54d2f9e7-c608-45e2-b740-2abafa15abc5
acceptable_use	\N	2026-05-18 05:02:53.106	127.0.0.1	2026-05-18 05:02:53.107	\N	d551f161-5bfb-432e-bb3c-a8a55956f544	92e50b41-bfb7-41cb-92c5-c8a26fcd5221
user_content_disclaimer	\N	2026-05-18 05:02:53.11	127.0.0.1	2026-05-18 05:02:53.111	\N	108504c7-82d7-472b-b384-25e7b5b57e13	92e50b41-bfb7-41cb-92c5-c8a26fcd5221
console_tos	\N	2026-05-18 05:02:53.112	127.0.0.1	2026-05-18 05:02:53.113	\N	8bd4a1a9-3336-451d-bae1-ce5b80ca1dfd	92e50b41-bfb7-41cb-92c5-c8a26fcd5221
\.


--
-- TOC entry 6059 (class 0 OID 152250)
-- Dependencies: 287
-- Data for Name: user_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profiles (id, user_id, bio, enrollment_number, id_proof_url, id_proof_verified_at, id_proof_verified_by, college_name, graduation_year, github_url, linkedin_url, website_url, skills, theme_preference, notification_preferences, created_at, updated_at, created_by, updated_by, country, expertise_level, onboarding_complete, operational_domains, profession, use_case_other, use_case_purposes, years_of_experience, academic_year, course_name, department_id) FROM stdin;
5ef22443-4c58-4180-916b-b7db77d8ebed	89b2ee87-2a07-4fe9-82e7-72a9addb7299	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	dark	{}	2026-05-14 15:57:40.068	2026-05-14 15:58:35.997	\N	\N	IN	beginner	t	{software_eng}	researcher	\N	{ai_ml_training,Docker}	1	\N	\N	\N
e7dab042-5990-4ace-a91f-96dbe6bd707d	54d2f9e7-c608-45e2-b740-2abafa15abc5	\N	\N	\N	\N	\N	K.S. Rangasamy College of Engineering	\N	\N	\N	\N	\N	dark	{}	2026-05-14 15:59:42.085	2026-05-14 15:59:53.398	\N	\N	IN	intermediate	t	{software_eng}	student	\N	{data_processing,Docker}	\N	1	B.Tech	66f940dc-4ee5-4d3b-948e-940e1493028e
4ecabbfa-470e-4767-99f6-5ed71b0ab431	92e50b41-bfb7-41cb-92c5-c8a26fcd5221	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	dark	{}	2026-05-18 05:03:06.158	2026-05-18 05:03:06.158	\N	\N	IN	beginner	t	{architecture}	engineer	\N	{data_processing,AutoCAD}	1	\N	\N	\N
\.


--
-- TOC entry 6060 (class 0 OID 152266)
-- Dependencies: 288
-- Data for Name: user_storage_volumes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_storage_volumes (id, user_id, storage_uid, zfs_dataset_path, nfs_export_path, container_mount_path, os_choice, quota_bytes, used_bytes, used_bytes_updated_at, status, provisioned_at, wiped_at, wipe_reason, quota_warning_sent_at, created_at, updated_at, created_by, updated_by, allocation_type, name, price_per_gb_cents_month, node_id, storage_backend) FROM stdin;
c06b7d7c-0325-40b3-ac14-f700a29c4bcc	54d2f9e7-c608-45e2-b740-2abafa15abc5	u_b77b809a694bd965301869dc	datapool/users/u_b77b809a694bd965301869dc	/mnt/nfs/users/u_b77b809a694bd965301869dc	\N	ubuntu22	10737418240	0	\N	active	2026-05-14 21:29:42.081	\N	\N	\N	2026-05-14 21:29:42.081	2026-05-14 21:29:42.081	\N	\N	institution_signup	default	0	16a6c6a8-aca5-40b5-b0bd-a4f908f35bbf	zfs_zvol
\.


--
-- TOC entry 6061 (class 0 OID 152288)
-- Dependencies: 289
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (email, email_verified_at, password_hash, first_name, last_name, display_name, avatar_url, phone, timezone, keycloak_sub, auth_type, oauth_provider, storage_uid, token_version, two_factor_enabled, last_login_at, last_login_ip, onboarding_completed_at, is_active, created_at, updated_at, deleted_at, storage_provisioned_at, storage_provisioning_error, storage_provisioning_status, created_by, keycloak_last_sync_at, lock_expires_at, lock_reason, locked_at, os_choice, pending_email, updated_by, id, default_org_id, referred_by_code) FROM stdin;
test@ksrce.in	2026-05-14 15:59:38.756	$2b$10$pzi4nIsT3WtOk9BoKlEbxeqzvbbtyER8UGQSQZVfyJqi7sZPC.qBq	test	ksrc	\N	\N	\N	Asia/Kolkata	\N	institution_local	\N	u_b77b809a694bd965301869dc	0	f	\N	\N	\N	t	2026-05-14 15:59:38.758	2026-05-14 15:59:42.068	\N	2026-05-14 15:59:42.066	\N	provisioned	\N	\N	\N	\N	\N	\N	\N	\N	54d2f9e7-c608-45e2-b740-2abafa15abc5	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	\N
it_admin@ksrce.in	\N	$2b$10$JTOY2w1Bt8D2YbJYeRBaPueFREpcgRtBDgb3WRvTP0mLd.FcPMlh2	IT	Administrator	\N	\N	\N	Asia/Kolkata	\N	public_local	\N	\N	0	f	2026-05-15 07:58:44.492	127.0.0.1	\N	t	2026-05-15 07:33:04.015	2026-05-15 07:58:44.494	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	bd8f8f80-a9ab-43e9-999f-b653f359e4c9	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	\N
testuser1023@gmail.com	2026-05-18 05:02:53.095	$2b$10$zUcjEEoiexsUsFjE2a4nFO5giTQYzeBSuEwJGMgNePsG4OOSG7NGy	test-user	10	\N	\N	\N	Asia/Kolkata	\N	public_local	\N	\N	0	f	2026-05-18 05:09:44.492	127.0.0.1	\N	t	2026-05-18 05:02:53.097	2026-05-18 05:09:44.494	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	92e50b41-bfb7-41cb-92c5-c8a26fcd5221	07b07401-b326-4045-af3a-44a7c45e56d8	\N
punith.vs74064@gmail.com	\N	\N	Punith	VS	\N	\N	\N	Asia/Kolkata	0fbe8ba9-74c2-4b3a-9d22-5cde9d40ee64	public_oauth	keycloak	\N	0	f	2026-05-18 05:19:31.392	127.0.0.1	\N	t	2026-05-14 15:57:40.027	2026-05-18 05:19:31.394	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	89b2ee87-2a07-4fe9-82e7-72a9addb7299	07b07401-b326-4045-af3a-44a7c45e56d8	\N
business_lead@ksrce.in	\N	$2b$10$JTOY2w1Bt8D2YbJYeRBaPueFREpcgRtBDgb3WRvTP0mLd.FcPMlh2	Business	Lead	\N	\N	\N	Asia/Kolkata	\N	public_local	\N	\N	0	f	2026-05-18 05:21:39.32	127.0.0.1	\N	t	2026-05-15 07:33:03.975	2026-05-18 05:21:39.322	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	9f08f905-999a-4c6f-87bc-66e29dc6301e	ab1a510d-296b-49d2-9faf-5fb7b5ac1332	\N
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
41c38c0f-f180-4f27-b967-d99e7d315077	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	12000	compute_session_hold	\N	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	captured	2026-05-15 07:31:51.391	2026-05-15 06:32:11.832	prepaid_hour_charged	12000	2026-05-15 06:31:51.393
9cf63f0d-ae6c-43b1-88eb-07079537b3b0	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	12000	compute_session_hold	\N	ace083ca-0ae6-4876-89e0-e9fb56f8d851	captured	2026-05-18 06:07:30.697	2026-05-18 05:07:53.454	prepaid_hour_charged	12000	2026-05-18 05:07:30.698
e7e5da41-0125-4483-a925-84066f10c222	510e8cdf-0420-4e99-9477-c854465ca52a	92e50b41-bfb7-41cb-92c5-c8a26fcd5221	30000	compute_session_hold	\N	3eeef689-38d9-401f-ae54-5c1369f6a554	released	2026-05-18 06:09:55.149	2026-05-18 05:09:57.337	session_failed	\N	2026-05-18 05:09:55.151
b74cf6ba-5c95-4566-8fba-985f5a7109b0	510e8cdf-0420-4e99-9477-c854465ca52a	92e50b41-bfb7-41cb-92c5-c8a26fcd5221	12000	compute_session_hold	\N	ad712de6-33f4-4292-82fe-e1c11b056f34	captured	2026-05-18 06:11:56.01	2026-05-18 05:12:16.598	prepaid_hour_charged	12000	2026-05-18 05:11:56.012
1e4145b3-c447-4e70-ab26-ab6de0a15b15	510e8cdf-0420-4e99-9477-c854465ca52a	92e50b41-bfb7-41cb-92c5-c8a26fcd5221	21000	compute_session_hold	\N	a6511603-d97c-4241-a118-dd0c66c87dc8	released	2026-05-18 06:13:23.262	2026-05-18 05:13:25.369	session_failed	\N	2026-05-18 05:13:23.264
\.


--
-- TOC entry 6064 (class 0 OID 152336)
-- Dependencies: 292
-- Data for Name: wallet_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wallet_transactions (id, wallet_id, user_id, txn_type, amount_cents, balance_after_cents, reference_type, reference_id, description, created_at, created_by) FROM stdin;
275fd86b-374a-461c-a0b6-c8aee465eda5	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	credit	1000000	1000000	payment	16720231-6285-4ba5-9322-c79b063d1d9a	Credit recharge via Razorpay	2026-05-15 06:27:37.274	\N
f2579d97-59fb-4b9d-b47c-af3b9f67beab	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	988000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Compute charge - session launch (prepaid hour 1)	2026-05-15 06:32:11.808	\N
40969150-3e24-4f46-a50a-d6033e5f41cf	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	976000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 2: gpu-instance-7463	2026-05-15 07:30:00.249	\N
84b8b7cc-f987-4fd4-94b8-f49ebe34b095	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	964000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 3: gpu-instance-7463	2026-05-15 08:30:00.141	\N
9c67ab3e-ff0c-4ccb-a0d7-0409c3f00b54	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	952000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 4: gpu-instance-7463	2026-05-15 09:30:00.669	\N
0bd6699d-33d3-4e73-b4c8-deb2e6f5689c	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	940000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 5: gpu-instance-7463	2026-05-15 10:30:00.154	\N
e223787d-2a75-486a-9de6-e14227c99ba7	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	928000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 6: gpu-instance-7463	2026-05-15 11:30:00.171	\N
b444f521-9768-4720-b09c-af1fa8e5e108	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	916000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 7: gpu-instance-7463	2026-05-15 12:30:00.098	\N
56c0e138-a180-4739-89bc-85cddb036c19	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	904000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 8: gpu-instance-7463	2026-05-15 13:30:00.83	\N
1c266679-504e-437d-a350-480f72e3bf88	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	892000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 9: gpu-instance-7463	2026-05-15 14:53:45.373	\N
ff19e231-e556-42f1-960b-1784ecec6b25	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	880000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 10: gpu-instance-7463	2026-05-16 03:13:59.672	\N
623e2965-9395-44a5-ab01-d5287278b9c7	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	868000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 11: gpu-instance-7463	2026-05-16 03:48:05.765	\N
cec0006e-ae8f-4d01-8ec9-004541412300	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	856000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 12: gpu-instance-7463	2026-05-16 05:42:53.855	\N
c3377038-fa9d-4f59-b144-f42dd16b80e4	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	844000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 13: gpu-instance-7463	2026-05-16 06:30:02.726	\N
55b3f8b5-1a79-45f2-83a2-7d8cb099a2bd	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	832000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 14: gpu-instance-7463	2026-05-16 07:30:00.354	\N
564c0a7f-d1a8-4db2-803f-608757df685a	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	820000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 15: gpu-instance-7463	2026-05-16 09:04:52.1	\N
5cf1b816-1e9d-48ea-8e1f-6d2d07137978	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	808000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 16: gpu-instance-7463	2026-05-16 09:59:26.587	\N
e1b94b9e-ac8f-4e16-998a-21a1246ea105	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	796000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 17: gpu-instance-7463	2026-05-16 14:33:48.431	\N
bae6e1c1-2080-4760-a852-6938c655e04c	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	784000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 18: gpu-instance-7463	2026-05-16 16:30:00.069	\N
5fed4cf8-74fb-43d3-bdc2-dc5b6bf256b1	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	772000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 19: gpu-instance-7463	2026-05-16 17:30:01.607	\N
07dba317-d980-4550-8ef3-d857004d4bb9	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	760000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 20: gpu-instance-7463	2026-05-16 18:38:37.249	\N
1a82cb8a-f853-40fd-b646-49896deeb740	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	748000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 21: gpu-instance-7463	2026-05-17 02:32:58.442	\N
f099123a-32ac-4d46-b12d-838f3875a0ef	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	736000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 22: gpu-instance-7463	2026-05-17 03:53:15.828	\N
febf3030-5fbe-44c5-bf78-68025787e6fe	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	724000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 23: gpu-instance-7463	2026-05-17 04:30:00.092	\N
03aa2b99-09c8-405c-aacf-e892dfb40806	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	712000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 24: gpu-instance-7463	2026-05-17 05:52:48.567	\N
6eccdfcd-e209-4e56-a82b-0234ab3dd66b	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	700000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 25: gpu-instance-7463	2026-05-17 07:58:52.471	\N
9b2e1478-b645-4d8e-9727-2fdd96b511de	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	688000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 26: gpu-instance-7463	2026-05-17 08:30:00.08	\N
a1b7afe8-bbe1-4c69-a14b-afaebbcf99cb	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	676000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 27: gpu-instance-7463	2026-05-17 09:30:00.058	\N
300717fa-11ed-45b6-9dec-cd6244d9d485	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	664000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 28: gpu-instance-7463	2026-05-17 10:30:00.523	\N
9b801a86-16a4-48f0-ad28-42f8bda19d84	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	652000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 29: gpu-instance-7463	2026-05-17 11:54:39.129	\N
5d417ee5-eeb9-44d6-a105-0fe563ba4085	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	640000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 30: gpu-instance-7463	2026-05-17 12:30:00.061	\N
d56ebfca-119a-4df5-9c07-e8b3e86e0f85	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	628000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 31: gpu-instance-7463	2026-05-17 13:30:00.07	\N
619e5123-935d-471e-a64a-40f6969e98ba	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	616000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 32: gpu-instance-7463	2026-05-17 14:30:00.047	\N
b20b4c71-39aa-4da3-8c9f-6b90ec46c5ff	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	604000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 33: gpu-instance-7463	2026-05-17 15:30:00.068	\N
5eb5824b-0bc3-497f-a518-51ce365615e1	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	592000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 34: gpu-instance-7463	2026-05-17 16:30:00.092	\N
4155e172-2c7e-40c1-a57b-15c7b92d55c3	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	580000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 35: gpu-instance-7463	2026-05-17 17:30:00.062	\N
8e4bb07d-cf9c-4edc-8622-3c284590bd04	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	568000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 36: gpu-instance-7463	2026-05-17 18:30:00.072	\N
757d83d2-98e1-4c10-ba34-ac3e64b687e2	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	556000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 37: gpu-instance-7463	2026-05-17 19:38:31.237	\N
69cf42e2-8a07-452d-9cbd-81dcfdf0cbfe	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	544000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Prepaid compute - Hour 38: gpu-instance-7463	2026-05-18 04:35:50.802	\N
f83be90f-d822-45e7-b091-d5267fcc0bff	510e8cdf-0420-4e99-9477-c854465ca52a	92e50b41-bfb7-41cb-92c5-c8a26fcd5221	credit	1000000	1000000	payment	cfdbe9b4-e6e7-487b-9ab1-239ca1c3d1d2	Credit recharge via Razorpay	2026-05-18 05:05:11.544	\N
1854e66e-2c51-46f0-af7b-52990e9705f6	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	12000	532000	compute_billing	ace083ca-0ae6-4876-89e0-e9fb56f8d851	Compute charge - session launch (prepaid hour 1)	2026-05-18 05:07:53.44	\N
8d08a76d-6007-41f6-a327-a135f26e6df8	510e8cdf-0420-4e99-9477-c854465ca52a	92e50b41-bfb7-41cb-92c5-c8a26fcd5221	debit	12000	988000	compute_billing	ad712de6-33f4-4292-82fe-e1c11b056f34	Compute charge - session launch (prepaid hour 1)	2026-05-18 05:12:16.587	\N
5cc039f3-f029-43a5-8d3d-ed586e4f19f1	e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	debit	396000	136000	compute_billing	2193b82f-48ff-4f31-89a1-dc45b2d1efa2	Final compute charge: gpu-instance-7463	2026-05-18 05:21:12.109	\N
\.


--
-- TOC entry 6065 (class 0 OID 152349)
-- Dependencies: 293
-- Data for Name: wallets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wallets (id, user_id, balance_cents, currency, lifetime_credits_cents, lifetime_spent_cents, low_balance_threshold_cents, is_frozen, created_at, updated_at, created_by, updated_by, spend_limit_cents, spend_limit_enabled, spend_limit_period, spend_limit_consented_at, spend_limit_end_date, spend_limit_start_date, spend_limit_warning_85_sent, runway_warning_1hour_sent) FROM stdin;
510e8cdf-0420-4e99-9477-c854465ca52a	92e50b41-bfb7-41cb-92c5-c8a26fcd5221	988000	INR	1000000	12000	10000	f	2026-05-18 05:05:11.538	2026-05-18 05:12:16.59	\N	\N	\N	f	\N	\N	\N	\N	f	f
e20c9d1b-3603-418c-be7e-bc5126a924cc	89b2ee87-2a07-4fe9-82e7-72a9addb7299	136000	INR	1000000	864000	10000	f	2026-05-15 06:27:37.255	2026-05-18 05:21:12.114	\N	\N	\N	f	\N	\N	\N	\N	f	f
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


-- Completed on 2026-05-18 11:08:08

--
-- PostgreSQL database dump complete
--

\unrestrict 1dA6dqYBhWVPi0VKrDn815WLfZl09sR0Tpr401akYdabFEpCLgadnMstNWBdUus

