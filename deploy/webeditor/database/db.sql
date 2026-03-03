--
-- PostgreSQL database dump
--

\restrict SRzOzfI5tmAQdI70A048c66glbQQMeXqCL4DiVbX7rIQrGUY1hGA7lDTCJK8D6s

-- Dumped from database version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: change_log_action; Type: TYPE; Schema: public; Owner: farai
--

CREATE TYPE public.change_log_action AS ENUM (
    'create',
    'update',
    'delete',
    'publish',
    'restore',
    'rollback',
    'merge'
);


ALTER TYPE public.change_log_action OWNER TO farai;

--
-- Name: change_log_entity; Type: TYPE; Schema: public; Owner: farai
--

CREATE TYPE public.change_log_entity AS ENUM (
    'script',
    'screen',
    'diagnosis',
    'config_key',
    'drugs_library',
    'data_key',
    'alias',
    'hospital',
    'release'
);


ALTER TYPE public.change_log_entity OWNER TO farai;

--
-- Name: dff_item_validation_type; Type: TYPE; Schema: public; Owner: farai
--

CREATE TYPE public.dff_item_validation_type AS ENUM (
    'default',
    'condition'
);


ALTER TYPE public.dff_item_validation_type OWNER TO farai;

--
-- Name: drug_type; Type: TYPE; Schema: public; Owner: farai
--

CREATE TYPE public.drug_type AS ENUM (
    'drug',
    'fluid',
    'feed'
);


ALTER TYPE public.drug_type OWNER TO farai;

--
-- Name: list_style; Type: TYPE; Schema: public; Owner: farai
--

CREATE TYPE public.list_style AS ENUM (
    'none',
    'number',
    'bullet'
);


ALTER TYPE public.list_style OWNER TO farai;

--
-- Name: mailer_service; Type: TYPE; Schema: public; Owner: farai
--

CREATE TYPE public.mailer_service AS ENUM (
    'gmail',
    'smtp'
);


ALTER TYPE public.mailer_service OWNER TO farai;

--
-- Name: role_name; Type: TYPE; Schema: public; Owner: farai
--

CREATE TYPE public.role_name AS ENUM (
    'user',
    'admin',
    'super_user'
);


ALTER TYPE public.role_name OWNER TO farai;

--
-- Name: screen_type; Type: TYPE; Schema: public; Owner: farai
--

CREATE TYPE public.screen_type AS ENUM (
    'diagnosis',
    'checklist',
    'form',
    'management',
    'multi_select',
    'single_select',
    'progress',
    'timer',
    'yesno',
    'drugs',
    'zw_edliz_summary_table',
    'mwi_edliz_summary_table',
    'fluids',
    'feeds',
    'problems'
);


ALTER TYPE public.screen_type OWNER TO farai;

--
-- Name: script_type; Type: TYPE; Schema: public; Owner: farai
--

CREATE TYPE public.script_type AS ENUM (
    'admission',
    'discharge',
    'neolab',
    'drecord',
    'dff_calculator'
);


ALTER TYPE public.script_type OWNER TO farai;

--
-- Name: site_env; Type: TYPE; Schema: public; Owner: farai
--

CREATE TYPE public.site_env AS ENUM (
    'production',
    'stage',
    'development',
    'demo'
);


ALTER TYPE public.site_env OWNER TO farai;

--
-- Name: site_type; Type: TYPE; Schema: public; Owner: farai
--

CREATE TYPE public.site_type AS ENUM (
    'nodeapi',
    'webeditor'
);


ALTER TYPE public.site_type OWNER TO farai;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Session; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public."Session" (
    sid character varying(36) NOT NULL,
    expires timestamp with time zone,
    data text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Session" OWNER TO farai;

--
-- Name: Sessions; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public."Sessions" (
    sid character varying(36) NOT NULL,
    expires timestamp with time zone,
    data text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Sessions" OWNER TO farai;

--
-- Name: activity; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.activity (
    id integer NOT NULL,
    topic character varying(32) NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    user_id integer,
    model character varying(16),
    model_id integer,
    database_id integer,
    table_id integer,
    custom_id character varying(48),
    details character varying NOT NULL
);


ALTER TABLE public.activity OWNER TO farai;

--
-- Name: activity_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.activity_id_seq OWNER TO farai;

--
-- Name: activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.activity_id_seq OWNED BY public.activity.id;


--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.api_keys (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public.api_keys OWNER TO farai;

--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.api_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.api_keys_id_seq OWNER TO farai;

--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.api_keys_id_seq OWNED BY public.api_keys.id;


--
-- Name: apps; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.apps (
    id integer NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    last_backup_date timestamp with time zone,
    data json DEFAULT '"{}"'::json,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    should_track_usage boolean DEFAULT false
);


ALTER TABLE public.apps OWNER TO farai;

--
-- Name: apps_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.apps_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.apps_id_seq OWNER TO farai;

--
-- Name: apps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.apps_id_seq OWNED BY public.apps.id;


--
-- Name: card_label; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.card_label (
    id integer NOT NULL,
    card_id integer NOT NULL,
    label_id integer NOT NULL
);


ALTER TABLE public.card_label OWNER TO farai;

--
-- Name: card_label_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.card_label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.card_label_id_seq OWNER TO farai;

--
-- Name: card_label_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.card_label_id_seq OWNED BY public.card_label.id;


--
-- Name: collection; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.collection (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    color character(7) NOT NULL,
    archived boolean DEFAULT false NOT NULL,
    location character varying(254) DEFAULT '/'::character varying NOT NULL,
    personal_owner_id integer,
    slug character varying(254) NOT NULL
);


ALTER TABLE public.collection OWNER TO farai;

--
-- Name: TABLE collection; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.collection IS 'Collections are an optional way to organize Cards and handle permissions for them.';


--
-- Name: COLUMN collection.name; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.collection.name IS 'The user-facing name of this Collection.';


--
-- Name: COLUMN collection.description; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.collection.description IS 'Optional description for this Collection.';


--
-- Name: COLUMN collection.color; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.collection.color IS 'Seven-character hex color for this Collection, including the preceding hash sign.';


--
-- Name: COLUMN collection.archived; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.collection.archived IS 'Whether this Collection has been archived and should be hidden from users.';


--
-- Name: COLUMN collection.location; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.collection.location IS 'Directory-structure path of ancestor Collections. e.g. "/1/2/" means our Parent is Collection 2, and their parent is Collection 1.';


--
-- Name: COLUMN collection.personal_owner_id; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.collection.personal_owner_id IS 'If set, this Collection is a personal Collection, for exclusive use of the User with this ID.';


--
-- Name: COLUMN collection.slug; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.collection.slug IS 'Sluggified version of the Collection name. Used only for display purposes in URL; not unique or indexed.';


--
-- Name: collection_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.collection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.collection_id_seq OWNER TO farai;

--
-- Name: collection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.collection_id_seq OWNED BY public.collection.id;


--
-- Name: collection_revision; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.collection_revision (
    id integer NOT NULL,
    before text NOT NULL,
    after text NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    remark text
);


ALTER TABLE public.collection_revision OWNER TO farai;

--
-- Name: TABLE collection_revision; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.collection_revision IS 'Used to keep track of changes made to collections.';


--
-- Name: COLUMN collection_revision.before; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.collection_revision.before IS 'Serialized JSON of the collections graph before the changes.';


--
-- Name: COLUMN collection_revision.after; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.collection_revision.after IS 'Serialized JSON of the collections graph after the changes.';


--
-- Name: COLUMN collection_revision.user_id; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.collection_revision.user_id IS 'The ID of the admin who made this set of changes.';


--
-- Name: COLUMN collection_revision.created_at; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.collection_revision.created_at IS 'The timestamp of when these changes were made.';


--
-- Name: COLUMN collection_revision.remark; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.collection_revision.remark IS 'Optional remarks explaining why these changes were made.';


--
-- Name: collection_revision_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.collection_revision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.collection_revision_id_seq OWNER TO farai;

--
-- Name: collection_revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.collection_revision_id_seq OWNED BY public.collection_revision.id;


--
-- Name: computation_job; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.computation_job (
    id integer NOT NULL,
    creator_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type character varying(254) NOT NULL,
    status character varying(254) NOT NULL,
    context text,
    ended_at timestamp without time zone
);


ALTER TABLE public.computation_job OWNER TO farai;

--
-- Name: TABLE computation_job; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.computation_job IS 'Stores submitted async computation jobs.';


--
-- Name: computation_job_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.computation_job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.computation_job_id_seq OWNER TO farai;

--
-- Name: computation_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.computation_job_id_seq OWNED BY public.computation_job.id;


--
-- Name: computation_job_result; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.computation_job_result (
    id integer NOT NULL,
    job_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    permanence character varying(254) NOT NULL,
    payload text NOT NULL
);


ALTER TABLE public.computation_job_result OWNER TO farai;

--
-- Name: TABLE computation_job_result; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.computation_job_result IS 'Stores results of async computation jobs.';


--
-- Name: computation_job_result_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.computation_job_result_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.computation_job_result_id_seq OWNER TO farai;

--
-- Name: computation_job_result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.computation_job_result_id_seq OWNED BY public.computation_job_result.id;


--
-- Name: config_keys; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.config_keys (
    id integer NOT NULL,
    config_key_id character varying(255) NOT NULL,
    "position" integer,
    data json DEFAULT '"{}"'::json,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.config_keys OWNER TO farai;

--
-- Name: config_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.config_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.config_keys_id_seq OWNER TO farai;

--
-- Name: config_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.config_keys_id_seq OWNED BY public.config_keys.id;


--
-- Name: configurations; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.configurations (
    id integer NOT NULL,
    unique_key character varying(255) NOT NULL,
    data json DEFAULT '"{}"'::json,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.configurations OWNER TO farai;

--
-- Name: configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.configurations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.configurations_id_seq OWNER TO farai;

--
-- Name: configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.configurations_id_seq OWNED BY public.configurations.id;


--
-- Name: core_session; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.core_session (
    id character varying(254) NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.core_session OWNER TO farai;

--
-- Name: core_user; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.core_user (
    id integer NOT NULL,
    email character varying(254) NOT NULL,
    first_name character varying(254) NOT NULL,
    last_name character varying(254) NOT NULL,
    password character varying(254) NOT NULL,
    password_salt character varying(254) DEFAULT 'default'::character varying NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    is_active boolean NOT NULL,
    reset_token character varying(254),
    reset_triggered bigint,
    is_qbnewb boolean DEFAULT true NOT NULL,
    google_auth boolean DEFAULT false NOT NULL,
    ldap_auth boolean DEFAULT false NOT NULL,
    login_attributes text,
    updated_at timestamp without time zone
);


ALTER TABLE public.core_user OWNER TO farai;

--
-- Name: COLUMN core_user.login_attributes; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.core_user.login_attributes IS 'JSON serialized map with attributes used for row level permissions';


--
-- Name: COLUMN core_user.updated_at; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.core_user.updated_at IS 'When was this User last updated?';


--
-- Name: core_user_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.core_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.core_user_id_seq OWNER TO farai;

--
-- Name: core_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.core_user_id_seq OWNED BY public.core_user.id;


--
-- Name: dashboard_favorite; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.dashboard_favorite (
    id integer NOT NULL,
    user_id integer NOT NULL,
    dashboard_id integer NOT NULL
);


ALTER TABLE public.dashboard_favorite OWNER TO farai;

--
-- Name: TABLE dashboard_favorite; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.dashboard_favorite IS 'Presence of a row here indicates a given User has favorited a given Dashboard.';


--
-- Name: COLUMN dashboard_favorite.user_id; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.dashboard_favorite.user_id IS 'ID of the User who favorited the Dashboard.';


--
-- Name: COLUMN dashboard_favorite.dashboard_id; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.dashboard_favorite.dashboard_id IS 'ID of the Dashboard favorited by the User.';


--
-- Name: dashboard_favorite_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.dashboard_favorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dashboard_favorite_id_seq OWNER TO farai;

--
-- Name: dashboard_favorite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.dashboard_favorite_id_seq OWNED BY public.dashboard_favorite.id;


--
-- Name: dashboardcard_series; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.dashboardcard_series (
    id integer NOT NULL,
    dashboardcard_id integer NOT NULL,
    card_id integer NOT NULL,
    "position" integer NOT NULL
);


ALTER TABLE public.dashboardcard_series OWNER TO farai;

--
-- Name: dashboardcard_series_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.dashboardcard_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dashboardcard_series_id_seq OWNER TO farai;

--
-- Name: dashboardcard_series_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.dashboardcard_series_id_seq OWNED BY public.dashboardcard_series.id;


--
-- Name: data_migrations; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.data_migrations (
    id character varying(254) NOT NULL,
    "timestamp" timestamp without time zone NOT NULL
);


ALTER TABLE public.data_migrations OWNER TO farai;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO farai;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO farai;

--
-- Name: dependency; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.dependency (
    id integer NOT NULL,
    model character varying(32) NOT NULL,
    model_id integer NOT NULL,
    dependent_on_model character varying(32) NOT NULL,
    dependent_on_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.dependency OWNER TO farai;

--
-- Name: dependency_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.dependency_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dependency_id_seq OWNER TO farai;

--
-- Name: dependency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.dependency_id_seq OWNED BY public.dependency.id;


--
-- Name: devices; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.devices (
    id integer NOT NULL,
    device_id character varying(255) NOT NULL,
    device_hash character varying(255) NOT NULL,
    details json DEFAULT '"{}"'::json,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public.devices OWNER TO farai;

--
-- Name: devices_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.devices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.devices_id_seq OWNER TO farai;

--
-- Name: devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.devices_id_seq OWNED BY public.devices.id;


--
-- Name: diagnoses; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.diagnoses (
    id integer NOT NULL,
    diagnosis_id character varying(255) NOT NULL,
    data json DEFAULT '"{}"'::json,
    "position" integer,
    script_id character varying(255),
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.diagnoses OWNER TO farai;

--
-- Name: diagnoses_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.diagnoses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.diagnoses_id_seq OWNER TO farai;

--
-- Name: diagnoses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.diagnoses_id_seq OWNED BY public.diagnoses.id;


--
-- Name: dimension; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.dimension (
    id integer NOT NULL,
    field_id integer NOT NULL,
    name character varying(254) NOT NULL,
    type character varying(254) NOT NULL,
    human_readable_field_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.dimension OWNER TO farai;

--
-- Name: TABLE dimension; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.dimension IS 'Stores references to alternate views of existing fields, such as remapping an integer to a description, like an enum';


--
-- Name: COLUMN dimension.field_id; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.dimension.field_id IS 'ID of the field this dimension row applies to';


--
-- Name: COLUMN dimension.name; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.dimension.name IS 'Short description used as the display name of this new column';


--
-- Name: COLUMN dimension.type; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.dimension.type IS 'Either internal for a user defined remapping or external for a foreign key based remapping';


--
-- Name: COLUMN dimension.human_readable_field_id; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.dimension.human_readable_field_id IS 'Only used with external type remappings. Indicates which field on the FK related table to use for display';


--
-- Name: COLUMN dimension.created_at; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.dimension.created_at IS 'The timestamp of when the dimension was created.';


--
-- Name: COLUMN dimension.updated_at; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.dimension.updated_at IS 'The timestamp of when these dimension was last updated.';


--
-- Name: dimension_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.dimension_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dimension_id_seq OWNER TO farai;

--
-- Name: dimension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.dimension_id_seq OWNED BY public.dimension.id;


--
-- Name: files; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.files (
    id character varying(255) NOT NULL,
    metadata json DEFAULT '"{}"'::json,
    filename character varying(255),
    content_type character varying(255),
    size bigint,
    data bytea,
    uploaded_by uuid,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public.files OWNER TO farai;

--
-- Name: hospitals; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.hospitals (
    id integer NOT NULL,
    hospital_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    country character varying(255),
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.hospitals OWNER TO farai;

--
-- Name: hospitals_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.hospitals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hospitals_id_seq OWNER TO farai;

--
-- Name: hospitals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.hospitals_id_seq OWNED BY public.hospitals.id;


--
-- Name: label; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.label (
    id integer NOT NULL,
    name character varying(254) NOT NULL,
    slug character varying(254) NOT NULL,
    icon character varying(128)
);


ALTER TABLE public.label OWNER TO farai;

--
-- Name: label_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.label_id_seq OWNER TO farai;

--
-- Name: label_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.label_id_seq OWNED BY public.label.id;


--
-- Name: logs; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.logs (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    data json DEFAULT '"{}"'::json,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.logs OWNER TO farai;

--
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logs_id_seq OWNER TO farai;

--
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.logs_id_seq OWNED BY public.logs.id;


--
-- Name: metabase_database; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.metabase_database (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    details text,
    engine character varying(254) NOT NULL,
    is_sample boolean DEFAULT false NOT NULL,
    is_full_sync boolean DEFAULT true NOT NULL,
    points_of_interest text,
    caveats text,
    metadata_sync_schedule character varying(254) DEFAULT '0 50 * * * ? *'::character varying NOT NULL,
    cache_field_values_schedule character varying(254) DEFAULT '0 50 0 * * ? *'::character varying NOT NULL,
    timezone character varying(254),
    is_on_demand boolean DEFAULT false NOT NULL,
    options text,
    auto_run_queries boolean DEFAULT true NOT NULL
);


ALTER TABLE public.metabase_database OWNER TO farai;

--
-- Name: COLUMN metabase_database.metadata_sync_schedule; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.metabase_database.metadata_sync_schedule IS 'The cron schedule string for when this database should undergo the metadata sync process (and analysis for new fields).';


--
-- Name: COLUMN metabase_database.cache_field_values_schedule; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.metabase_database.cache_field_values_schedule IS 'The cron schedule string for when FieldValues for eligible Fields should be updated.';


--
-- Name: COLUMN metabase_database.timezone; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.metabase_database.timezone IS 'Timezone identifier for the database, set by the sync process';


--
-- Name: COLUMN metabase_database.is_on_demand; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.metabase_database.is_on_demand IS 'Whether we should do On-Demand caching of FieldValues for this DB. This means FieldValues are updated when their Field is used in a Dashboard or Card param.';


--
-- Name: COLUMN metabase_database.options; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.metabase_database.options IS 'Serialized JSON containing various options like QB behavior.';


--
-- Name: COLUMN metabase_database.auto_run_queries; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.metabase_database.auto_run_queries IS 'Whether to automatically run queries when doing simple filtering and summarizing in the Query Builder.';


--
-- Name: metabase_database_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.metabase_database_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.metabase_database_id_seq OWNER TO farai;

--
-- Name: metabase_database_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.metabase_database_id_seq OWNED BY public.metabase_database.id;


--
-- Name: metabase_field; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.metabase_field (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    base_type character varying(255) NOT NULL,
    special_type character varying(255),
    active boolean DEFAULT true NOT NULL,
    description text,
    preview_display boolean DEFAULT true NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    table_id integer NOT NULL,
    parent_id integer,
    display_name character varying(254),
    visibility_type character varying(32) DEFAULT 'normal'::character varying NOT NULL,
    fk_target_field_id integer,
    last_analyzed timestamp with time zone,
    points_of_interest text,
    caveats text,
    fingerprint text,
    fingerprint_version integer DEFAULT 0 NOT NULL,
    database_type text NOT NULL,
    has_field_values text,
    settings text
);


ALTER TABLE public.metabase_field OWNER TO farai;

--
-- Name: COLUMN metabase_field.fingerprint; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.metabase_field.fingerprint IS 'Serialized JSON containing non-identifying information about this Field, such as min, max, and percent JSON. Used for classification.';


--
-- Name: COLUMN metabase_field.fingerprint_version; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.metabase_field.fingerprint_version IS 'The version of the fingerprint for this Field. Used so we can keep track of which Fields need to be analyzed again when new things are added to fingerprints.';


--
-- Name: COLUMN metabase_field.database_type; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.metabase_field.database_type IS 'The actual type of this column in the database. e.g. VARCHAR or TEXT.';


--
-- Name: COLUMN metabase_field.has_field_values; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.metabase_field.has_field_values IS 'Whether we have FieldValues ("list"), should ad-hoc search ("search"), disable entirely ("none"), or infer dynamically (null)"';


--
-- Name: COLUMN metabase_field.settings; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.metabase_field.settings IS 'Serialized JSON FE-specific settings like formatting, etc. Scope of what is stored here may increase in future.';


--
-- Name: metabase_field_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.metabase_field_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.metabase_field_id_seq OWNER TO farai;

--
-- Name: metabase_field_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.metabase_field_id_seq OWNED BY public.metabase_field.id;


--
-- Name: metabase_fieldvalues; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.metabase_fieldvalues (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    "values" text,
    human_readable_values text,
    field_id integer NOT NULL
);


ALTER TABLE public.metabase_fieldvalues OWNER TO farai;

--
-- Name: metabase_fieldvalues_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.metabase_fieldvalues_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.metabase_fieldvalues_id_seq OWNER TO farai;

--
-- Name: metabase_fieldvalues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.metabase_fieldvalues_id_seq OWNED BY public.metabase_fieldvalues.id;


--
-- Name: metabase_table; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.metabase_table (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    rows bigint,
    description text,
    entity_name character varying(254),
    entity_type character varying(254),
    active boolean NOT NULL,
    db_id integer NOT NULL,
    display_name character varying(254),
    visibility_type character varying(254),
    schema character varying(254),
    points_of_interest text,
    caveats text,
    show_in_getting_started boolean DEFAULT false NOT NULL,
    fields_hash text
);


ALTER TABLE public.metabase_table OWNER TO farai;

--
-- Name: COLUMN metabase_table.fields_hash; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.metabase_table.fields_hash IS 'Computed hash of all of the fields associated to this table';


--
-- Name: metabase_table_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.metabase_table_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.metabase_table_id_seq OWNER TO farai;

--
-- Name: metabase_table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.metabase_table_id_seq OWNED BY public.metabase_table.id;


--
-- Name: metric; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.metric (
    id integer NOT NULL,
    table_id integer NOT NULL,
    creator_id integer NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    archived boolean DEFAULT false NOT NULL,
    definition text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    points_of_interest text,
    caveats text,
    how_is_this_calculated text,
    show_in_getting_started boolean DEFAULT false NOT NULL
);


ALTER TABLE public.metric OWNER TO farai;

--
-- Name: metric_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.metric_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.metric_id_seq OWNER TO farai;

--
-- Name: metric_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.metric_id_seq OWNED BY public.metric.id;


--
-- Name: metric_important_field; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.metric_important_field (
    id integer NOT NULL,
    metric_id integer NOT NULL,
    field_id integer NOT NULL
);


ALTER TABLE public.metric_important_field OWNER TO farai;

--
-- Name: metric_important_field_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.metric_important_field_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.metric_important_field_id_seq OWNER TO farai;

--
-- Name: metric_important_field_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.metric_important_field_id_seq OWNED BY public.metric_important_field.id;


--
-- Name: nt_aliases; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_aliases (
    id integer NOT NULL,
    uuid uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    name text NOT NULL,
    alias text NOT NULL,
    script text NOT NULL,
    old_script text,
    publish_date timestamp without time zone DEFAULT now() NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.nt_aliases OWNER TO farai;

--
-- Name: nt_aliases_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_aliases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_aliases_id_seq OWNER TO farai;

--
-- Name: nt_aliases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_aliases_id_seq OWNED BY public.nt_aliases.id;


--
-- Name: nt_api_keys; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_api_keys (
    id integer NOT NULL,
    api_key_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    api_key text NOT NULL,
    valid_until timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_api_keys OWNER TO farai;

--
-- Name: nt_api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_api_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_api_keys_id_seq OWNER TO farai;

--
-- Name: nt_api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_api_keys_id_seq OWNED BY public.nt_api_keys.id;


--
-- Name: nt_auth_clients; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_auth_clients (
    id integer NOT NULL,
    client_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    client_token text NOT NULL,
    user_id uuid,
    valid_until timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_auth_clients OWNER TO farai;

--
-- Name: nt_auth_clients_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_auth_clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_auth_clients_id_seq OWNER TO farai;

--
-- Name: nt_auth_clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_auth_clients_id_seq OWNED BY public.nt_auth_clients.id;


--
-- Name: nt_change_logs; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_change_logs (
    id integer NOT NULL,
    change_log_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    version integer NOT NULL,
    entity_type public.change_log_entity NOT NULL,
    entity_id uuid NOT NULL,
    parent_version integer,
    merged_from_version integer,
    script_id uuid,
    screen_id uuid,
    diagnosis_id uuid,
    config_key_id uuid,
    drugs_library_item_id uuid,
    data_key_id uuid,
    alias_id uuid,
    action public.change_log_action NOT NULL,
    changes jsonb DEFAULT '[]'::jsonb NOT NULL,
    full_snapshot jsonb NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    change_reason text DEFAULT ''::text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    superseded_by integer,
    superseded_at timestamp without time zone,
    user_id uuid NOT NULL,
    date_of_change timestamp without time zone DEFAULT now() NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    data_version integer,
    hospital_id uuid,
    snapshot_hash text,
    previous_snapshot jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE public.nt_change_logs OWNER TO farai;

--
-- Name: nt_change_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_change_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_change_logs_id_seq OWNER TO farai;

--
-- Name: nt_change_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_change_logs_id_seq OWNED BY public.nt_change_logs.id;


--
-- Name: nt_config_keys; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_config_keys (
    id integer NOT NULL,
    config_key_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    old_config_key_id text,
    "position" integer NOT NULL,
    version integer NOT NULL,
    key text NOT NULL,
    label text NOT NULL,
    summary text NOT NULL,
    source text DEFAULT 'editor'::text,
    publish_date timestamp without time zone DEFAULT now() NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    preferences jsonb DEFAULT '{"fontSize": {}, "fontStyle": {}, "highlight": {}, "textColor": {}, "fontWeight": {}, "backgroundColor": {}}'::jsonb NOT NULL
);


ALTER TABLE public.nt_config_keys OWNER TO farai;

--
-- Name: nt_config_keys_drafts; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_config_keys_drafts (
    id integer NOT NULL,
    config_key_draft_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    config_key_id uuid,
    "position" integer NOT NULL,
    data jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by_user_id uuid
);


ALTER TABLE public.nt_config_keys_drafts OWNER TO farai;

--
-- Name: nt_config_keys_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_config_keys_drafts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_config_keys_drafts_id_seq OWNER TO farai;

--
-- Name: nt_config_keys_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_config_keys_drafts_id_seq OWNED BY public.nt_config_keys_drafts.id;


--
-- Name: nt_config_keys_history; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_config_keys_history (
    id integer NOT NULL,
    version integer NOT NULL,
    config_key_id uuid NOT NULL,
    restore_key uuid,
    data jsonb DEFAULT '[]'::jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_config_keys_history OWNER TO farai;

--
-- Name: nt_config_keys_history_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_config_keys_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_config_keys_history_id_seq OWNER TO farai;

--
-- Name: nt_config_keys_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_config_keys_history_id_seq OWNED BY public.nt_config_keys_history.id;


--
-- Name: nt_config_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_config_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_config_keys_id_seq OWNER TO farai;

--
-- Name: nt_config_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_config_keys_id_seq OWNED BY public.nt_config_keys.id;


--
-- Name: nt_data_keys; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_data_keys (
    id integer NOT NULL,
    uuid uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    unique_key uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    name text NOT NULL,
    label text DEFAULT ''::text NOT NULL,
    ref_id text,
    data_type text,
    options jsonb DEFAULT '[]'::jsonb NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    version integer NOT NULL,
    publish_date timestamp without time zone DEFAULT now() NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.nt_data_keys OWNER TO farai;

--
-- Name: nt_data_keys_drafts; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_data_keys_drafts (
    id integer NOT NULL,
    uuid uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    name text NOT NULL,
    unique_key uuid NOT NULL,
    data_key_id uuid,
    data jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by_user_id uuid
);


ALTER TABLE public.nt_data_keys_drafts OWNER TO farai;

--
-- Name: nt_data_keys_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_data_keys_drafts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_data_keys_drafts_id_seq OWNER TO farai;

--
-- Name: nt_data_keys_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_data_keys_drafts_id_seq OWNED BY public.nt_data_keys_drafts.id;


--
-- Name: nt_data_keys_history; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_data_keys_history (
    id integer NOT NULL,
    version integer NOT NULL,
    data_key_id uuid NOT NULL,
    restore_key uuid,
    data jsonb DEFAULT '[]'::jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_data_keys_history OWNER TO farai;

--
-- Name: nt_data_keys_history_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_data_keys_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_data_keys_history_id_seq OWNER TO farai;

--
-- Name: nt_data_keys_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_data_keys_history_id_seq OWNED BY public.nt_data_keys_history.id;


--
-- Name: nt_data_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_data_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_data_keys_id_seq OWNER TO farai;

--
-- Name: nt_data_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_data_keys_id_seq OWNED BY public.nt_data_keys.id;


--
-- Name: nt_devices; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_devices (
    id integer NOT NULL,
    device_id text NOT NULL,
    device_hash text NOT NULL,
    details jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.nt_devices OWNER TO farai;

--
-- Name: nt_devices_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_devices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_devices_id_seq OWNER TO farai;

--
-- Name: nt_devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_devices_id_seq OWNED BY public.nt_devices.id;


--
-- Name: nt_diagnoses; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_diagnoses (
    id integer NOT NULL,
    diagnosis_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    old_diagnosis_id text,
    old_script_id text,
    version integer NOT NULL,
    script_id uuid NOT NULL,
    "position" integer NOT NULL,
    source text DEFAULT 'editor'::text,
    expression text NOT NULL,
    name text DEFAULT ''::text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    key text DEFAULT ''::text,
    severity_order integer,
    expression_meaning text DEFAULT ''::text NOT NULL,
    symptoms jsonb DEFAULT '[]'::jsonb NOT NULL,
    text1 text DEFAULT ''::text NOT NULL,
    text2 text DEFAULT ''::text NOT NULL,
    text3 text DEFAULT ''::text NOT NULL,
    image1 jsonb,
    image2 jsonb,
    image3 jsonb,
    publish_date timestamp without time zone DEFAULT now() NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    preferences jsonb DEFAULT '{"fontSize": {}, "fontStyle": {}, "highlight": {}, "textColor": {}, "fontWeight": {}, "backgroundColor": {}}'::jsonb NOT NULL,
    key_id text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.nt_diagnoses OWNER TO farai;

--
-- Name: nt_diagnoses_drafts; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_diagnoses_drafts (
    id integer NOT NULL,
    diagnosis_draft_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    diagnosis_id uuid,
    script_id uuid,
    script_draft_id uuid,
    "position" integer NOT NULL,
    data jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by_user_id uuid
);


ALTER TABLE public.nt_diagnoses_drafts OWNER TO farai;

--
-- Name: nt_diagnoses_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_diagnoses_drafts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_diagnoses_drafts_id_seq OWNER TO farai;

--
-- Name: nt_diagnoses_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_diagnoses_drafts_id_seq OWNED BY public.nt_diagnoses_drafts.id;


--
-- Name: nt_diagnoses_history; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_diagnoses_history (
    id integer NOT NULL,
    version integer NOT NULL,
    diagnosis_id uuid NOT NULL,
    script_id uuid NOT NULL,
    restore_key text,
    data jsonb DEFAULT '[]'::jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_diagnoses_history OWNER TO farai;

--
-- Name: nt_diagnoses_history_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_diagnoses_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_diagnoses_history_id_seq OWNER TO farai;

--
-- Name: nt_diagnoses_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_diagnoses_history_id_seq OWNED BY public.nt_diagnoses_history.id;


--
-- Name: nt_diagnoses_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_diagnoses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_diagnoses_id_seq OWNER TO farai;

--
-- Name: nt_diagnoses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_diagnoses_id_seq OWNED BY public.nt_diagnoses.id;


--
-- Name: nt_drugs_library; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_drugs_library (
    id integer NOT NULL,
    item_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    key text NOT NULL,
    drug text DEFAULT ''::text NOT NULL,
    min_gestation double precision,
    max_gestation double precision,
    min_weight double precision,
    max_weight double precision,
    min_age double precision,
    max_age double precision,
    dosage double precision,
    dosage_multiplier double precision,
    day_of_life text DEFAULT ''::text NOT NULL,
    dosage_text text DEFAULT ''::text NOT NULL,
    management_text text DEFAULT ''::text NOT NULL,
    gestation_key text DEFAULT ''::text NOT NULL,
    weight_key text DEFAULT ''::text NOT NULL,
    diagnosis_key text DEFAULT ''::text NOT NULL,
    age_key text DEFAULT ''::text NOT NULL,
    administration_frequency text DEFAULT ''::text NOT NULL,
    drug_unit text DEFAULT ''::text NOT NULL,
    route_of_administration text DEFAULT ''::text NOT NULL,
    "position" integer NOT NULL,
    condition text DEFAULT ''::text NOT NULL,
    version integer NOT NULL,
    publish_date timestamp without time zone DEFAULT now() NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    type public.drug_type DEFAULT 'drug'::public.drug_type NOT NULL,
    hourly_feed double precision,
    hourly_feed_divider double precision,
    validation_type public.dff_item_validation_type DEFAULT 'default'::public.dff_item_validation_type,
    key_id text DEFAULT ''::text NOT NULL,
    gestation_key_id text DEFAULT ''::text NOT NULL,
    weight_key_id text DEFAULT ''::text NOT NULL,
    age_key_id text DEFAULT ''::text NOT NULL,
    diagnosis_key_id text DEFAULT ''::text NOT NULL,
    calculator_condition text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.nt_drugs_library OWNER TO farai;

--
-- Name: nt_drugs_library_drafts; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_drugs_library_drafts (
    id integer NOT NULL,
    item_draft_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    item_id uuid,
    key text NOT NULL,
    "position" integer NOT NULL,
    data jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    type public.drug_type DEFAULT 'drug'::public.drug_type NOT NULL,
    created_by_user_id uuid
);


ALTER TABLE public.nt_drugs_library_drafts OWNER TO farai;

--
-- Name: nt_drugs_library_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_drugs_library_drafts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_drugs_library_drafts_id_seq OWNER TO farai;

--
-- Name: nt_drugs_library_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_drugs_library_drafts_id_seq OWNED BY public.nt_drugs_library_drafts.id;


--
-- Name: nt_drugs_library_history; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_drugs_library_history (
    id integer NOT NULL,
    version integer NOT NULL,
    item_id uuid NOT NULL,
    restore_key uuid,
    data jsonb DEFAULT '[]'::jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_drugs_library_history OWNER TO farai;

--
-- Name: nt_drugs_library_history_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_drugs_library_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_drugs_library_history_id_seq OWNER TO farai;

--
-- Name: nt_drugs_library_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_drugs_library_history_id_seq OWNED BY public.nt_drugs_library_history.id;


--
-- Name: nt_drugs_library_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_drugs_library_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_drugs_library_id_seq OWNER TO farai;

--
-- Name: nt_drugs_library_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_drugs_library_id_seq OWNED BY public.nt_drugs_library.id;


--
-- Name: nt_editor_info; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_editor_info (
    id integer NOT NULL,
    data_version integer DEFAULT 1 NOT NULL,
    last_publish_date timestamp without time zone,
    last_data_keys_sync_date timestamp without time zone
);


ALTER TABLE public.nt_editor_info OWNER TO farai;

--
-- Name: nt_editor_info_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_editor_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_editor_info_id_seq OWNER TO farai;

--
-- Name: nt_editor_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_editor_info_id_seq OWNED BY public.nt_editor_info.id;


--
-- Name: nt_email_templates; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_email_templates (
    id integer NOT NULL,
    template_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    name text NOT NULL,
    data jsonb NOT NULL
);


ALTER TABLE public.nt_email_templates OWNER TO farai;

--
-- Name: nt_email_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_email_templates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_email_templates_id_seq OWNER TO farai;

--
-- Name: nt_email_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_email_templates_id_seq OWNED BY public.nt_email_templates.id;


--
-- Name: nt_files; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_files (
    id integer NOT NULL,
    file_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    owner_id uuid,
    filename text NOT NULL,
    content_type text NOT NULL,
    size integer NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    data bytea NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.nt_files OWNER TO farai;

--
-- Name: nt_files_chunks; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_files_chunks (
    id integer NOT NULL,
    chunk_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    file_id uuid NOT NULL,
    data bytea NOT NULL
);


ALTER TABLE public.nt_files_chunks OWNER TO farai;

--
-- Name: nt_files_chunks_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_files_chunks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_files_chunks_id_seq OWNER TO farai;

--
-- Name: nt_files_chunks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_files_chunks_id_seq OWNED BY public.nt_files_chunks.id;


--
-- Name: nt_files_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_files_id_seq OWNER TO farai;

--
-- Name: nt_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_files_id_seq OWNED BY public.nt_files.id;


--
-- Name: nt_hospitals; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_hospitals (
    id integer NOT NULL,
    hospital_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    old_hospital_id text,
    name text NOT NULL,
    country text DEFAULT ''::text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    version integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.nt_hospitals OWNER TO farai;

--
-- Name: nt_hospitals_drafts; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_hospitals_drafts (
    id integer NOT NULL,
    hospital_draft_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    hospital_id uuid,
    data jsonb NOT NULL,
    created_by_user_id uuid,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_hospitals_drafts OWNER TO farai;

--
-- Name: nt_hospitals_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_hospitals_drafts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_hospitals_drafts_id_seq OWNER TO farai;

--
-- Name: nt_hospitals_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_hospitals_drafts_id_seq OWNED BY public.nt_hospitals_drafts.id;


--
-- Name: nt_hospitals_history; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_hospitals_history (
    id integer NOT NULL,
    version integer NOT NULL,
    hospital_id uuid NOT NULL,
    restore_key uuid,
    data jsonb DEFAULT '[]'::jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_hospitals_history OWNER TO farai;

--
-- Name: nt_hospitals_history_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_hospitals_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_hospitals_history_id_seq OWNER TO farai;

--
-- Name: nt_hospitals_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_hospitals_history_id_seq OWNED BY public.nt_hospitals_history.id;


--
-- Name: nt_hospitals_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_hospitals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_hospitals_id_seq OWNER TO farai;

--
-- Name: nt_hospitals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_hospitals_id_seq OWNED BY public.nt_hospitals.id;


--
-- Name: nt_languages; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_languages (
    id integer NOT NULL,
    name text NOT NULL,
    iso text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.nt_languages OWNER TO farai;

--
-- Name: nt_languages_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_languages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_languages_id_seq OWNER TO farai;

--
-- Name: nt_languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_languages_id_seq OWNED BY public.nt_languages.id;


--
-- Name: nt_lock; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_lock (
    lock_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    locked_at timestamp without time zone NOT NULL,
    script_id uuid,
    lock_type character varying(20) DEFAULT 'script'::character varying NOT NULL,
    new_script_id uuid,
    CONSTRAINT nt_lock_lock_type_check CHECK (((lock_type)::text = ANY (ARRAY[('script'::character varying)::text, ('data_key'::character varying)::text, ('drug_library'::character varying)::text])))
);


ALTER TABLE public.nt_lock OWNER TO farai;

--
-- Name: nt_mailer_settings; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_mailer_settings (
    id integer NOT NULL,
    setting_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    name text NOT NULL,
    service public.mailer_service NOT NULL,
    auth_username text NOT NULL,
    auth_password text NOT NULL,
    auth_type text,
    auth_method text,
    host text DEFAULT ''::text NOT NULL,
    port integer,
    encryption text DEFAULT ''::text NOT NULL,
    from_address text DEFAULT ''::text NOT NULL,
    from_name text DEFAULT ''::text NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    secure boolean DEFAULT false NOT NULL
);


ALTER TABLE public.nt_mailer_settings OWNER TO farai;

--
-- Name: nt_mailer_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_mailer_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_mailer_settings_id_seq OWNER TO farai;

--
-- Name: nt_mailer_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_mailer_settings_id_seq OWNED BY public.nt_mailer_settings.id;


--
-- Name: nt_pending_deletion; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_pending_deletion (
    id integer NOT NULL,
    script_id uuid,
    screen_id uuid,
    screen_script_id uuid,
    diagnosis_id uuid,
    diagnosis_script_id uuid,
    config_key_id uuid,
    script_draft_id uuid,
    screen_draft_id uuid,
    diagnosis_draft_id uuid,
    config_key_draft_id uuid,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    drugs_library_item_id uuid,
    drugs_library_item_draft_id uuid,
    alias_id uuid,
    data_key_id uuid,
    data_key_draft_id uuid,
    created_by_user_id uuid,
    hospital_id uuid,
    hospital_draft_id uuid
);


ALTER TABLE public.nt_pending_deletion OWNER TO farai;

--
-- Name: nt_pending_deletion_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_pending_deletion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_pending_deletion_id_seq OWNER TO farai;

--
-- Name: nt_pending_deletion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_pending_deletion_id_seq OWNED BY public.nt_pending_deletion.id;


--
-- Name: nt_screens; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_screens (
    id integer NOT NULL,
    screen_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    old_screen_id text,
    old_script_id text,
    version integer NOT NULL,
    script_id uuid NOT NULL,
    type public.screen_type NOT NULL,
    "position" integer NOT NULL,
    source text DEFAULT 'editor'::text,
    section_title text NOT NULL,
    preview_title text DEFAULT ''::text NOT NULL,
    preview_print_title text DEFAULT ''::text NOT NULL,
    condition text DEFAULT ''::text NOT NULL,
    epic_id text DEFAULT ''::text NOT NULL,
    story_id text DEFAULT ''::text NOT NULL,
    ref_id text DEFAULT ''::text NOT NULL,
    ref_key text DEFAULT ''::text NOT NULL,
    step text DEFAULT ''::text NOT NULL,
    action_text text DEFAULT ''::text NOT NULL,
    content_text text DEFAULT ''::text NOT NULL,
    info_text text DEFAULT ''::text NOT NULL,
    title text NOT NULL,
    title1 text DEFAULT ''::text NOT NULL,
    title2 text DEFAULT ''::text NOT NULL,
    title3 text DEFAULT ''::text NOT NULL,
    title4 text DEFAULT ''::text NOT NULL,
    text1 text DEFAULT ''::text NOT NULL,
    text2 text DEFAULT ''::text NOT NULL,
    text3 text DEFAULT ''::text NOT NULL,
    image1 jsonb,
    image2 jsonb,
    image3 jsonb,
    instructions text DEFAULT ''::text NOT NULL,
    instructions2 text DEFAULT ''::text NOT NULL,
    instructions3 text DEFAULT ''::text NOT NULL,
    instructions4 text DEFAULT ''::text NOT NULL,
    hcw_diagnoses_instructions text DEFAULT ''::text NOT NULL,
    suggested_diagnoses_instructions text DEFAULT ''::text NOT NULL,
    notes text DEFAULT ''::text NOT NULL,
    data_type text DEFAULT ''::text NOT NULL,
    key text DEFAULT ''::text NOT NULL,
    label text DEFAULT ''::text NOT NULL,
    negative_label text DEFAULT ''::text NOT NULL,
    positive_label text DEFAULT ''::text NOT NULL,
    timer_value integer,
    multiplier integer,
    min_value integer,
    max_value integer,
    exportable boolean DEFAULT true NOT NULL,
    printable boolean,
    skippable boolean DEFAULT false NOT NULL,
    confidential boolean DEFAULT false NOT NULL,
    pre_populate jsonb DEFAULT '[]'::jsonb NOT NULL,
    fields jsonb DEFAULT '[]'::jsonb NOT NULL,
    items jsonb DEFAULT '[]'::jsonb NOT NULL,
    publish_date timestamp without time zone DEFAULT now() NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    preferences jsonb DEFAULT '{"fontSize": {}, "fontStyle": {}, "highlight": {}, "textColor": {}, "fontWeight": {}, "backgroundColor": {}}'::jsonb NOT NULL,
    skip_to_condition text DEFAULT ''::text NOT NULL,
    skip_to_screen_id text,
    drugs jsonb DEFAULT '[]'::jsonb NOT NULL,
    fluids jsonb DEFAULT '[]'::jsonb NOT NULL,
    feeds jsonb DEFAULT '[]'::jsonb NOT NULL,
    reasons jsonb DEFAULT '[]'::jsonb NOT NULL,
    repeatable boolean,
    collection_label text DEFAULT ''::text NOT NULL,
    collection_name text DEFAULT ''::text NOT NULL,
    content_text_image jsonb,
    list_style public.list_style DEFAULT 'none'::public.list_style NOT NULL,
    key_id text DEFAULT ''::text NOT NULL,
    ref_id_data_key text DEFAULT ''::text NOT NULL,
    ref_key_data_key text DEFAULT ''::text NOT NULL,
    print_display_columns integer DEFAULT 2 NOT NULL,
    rank_items boolean DEFAULT false NOT NULL
);


ALTER TABLE public.nt_screens OWNER TO farai;

--
-- Name: nt_screens_drafts; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_screens_drafts (
    id integer NOT NULL,
    screen_draft_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    screen_id uuid,
    script_id uuid,
    script_draft_id uuid,
    type public.screen_type NOT NULL,
    "position" integer NOT NULL,
    data jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by_user_id uuid
);


ALTER TABLE public.nt_screens_drafts OWNER TO farai;

--
-- Name: nt_screens_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_screens_drafts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_screens_drafts_id_seq OWNER TO farai;

--
-- Name: nt_screens_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_screens_drafts_id_seq OWNED BY public.nt_screens_drafts.id;


--
-- Name: nt_screens_history; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_screens_history (
    id integer NOT NULL,
    version integer NOT NULL,
    screen_id uuid NOT NULL,
    script_id uuid NOT NULL,
    restore_key text,
    data jsonb DEFAULT '[]'::jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_screens_history OWNER TO farai;

--
-- Name: nt_screens_history_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_screens_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_screens_history_id_seq OWNER TO farai;

--
-- Name: nt_screens_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_screens_history_id_seq OWNED BY public.nt_screens_history.id;


--
-- Name: nt_screens_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_screens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_screens_id_seq OWNER TO farai;

--
-- Name: nt_screens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_screens_id_seq OWNED BY public.nt_screens.id;


--
-- Name: nt_scripts; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_scripts (
    id integer NOT NULL,
    script_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    old_script_id text,
    version integer NOT NULL,
    type public.script_type DEFAULT 'admission'::public.script_type NOT NULL,
    "position" integer NOT NULL,
    source text DEFAULT 'editor'::text,
    title text NOT NULL,
    print_title text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    hospital_id uuid,
    exportable boolean DEFAULT true NOT NULL,
    nuid_search_enabled boolean DEFAULT false NOT NULL,
    nuid_search_fields jsonb DEFAULT '[]'::jsonb NOT NULL,
    publish_date timestamp without time zone DEFAULT now() NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    preferences jsonb DEFAULT '{"fontSize": {}, "fontStyle": {}, "highlight": {}, "textColor": {}, "fontWeight": {}, "backgroundColor": {}}'::jsonb NOT NULL,
    print_sections jsonb DEFAULT '[]'::jsonb NOT NULL,
    review_configurations jsonb DEFAULT '[]'::jsonb NOT NULL,
    reviewable boolean,
    print_config jsonb DEFAULT '{"sections": [], "footerFields": [], "headerFields": []}'::jsonb NOT NULL
);


ALTER TABLE public.nt_scripts OWNER TO farai;

--
-- Name: nt_scripts_drafts; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_scripts_drafts (
    id integer NOT NULL,
    script_draft_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    script_id uuid,
    "position" integer NOT NULL,
    data jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    hospital_id uuid,
    created_by_user_id uuid
);


ALTER TABLE public.nt_scripts_drafts OWNER TO farai;

--
-- Name: nt_scripts_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_scripts_drafts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_scripts_drafts_id_seq OWNER TO farai;

--
-- Name: nt_scripts_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_scripts_drafts_id_seq OWNED BY public.nt_scripts_drafts.id;


--
-- Name: nt_scripts_history; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_scripts_history (
    id integer NOT NULL,
    version integer NOT NULL,
    script_id uuid NOT NULL,
    restore_key uuid,
    data jsonb DEFAULT '[]'::jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_scripts_history OWNER TO farai;

--
-- Name: nt_scripts_history_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_scripts_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_scripts_history_id_seq OWNER TO farai;

--
-- Name: nt_scripts_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_scripts_history_id_seq OWNED BY public.nt_scripts_history.id;


--
-- Name: nt_scripts_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_scripts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_scripts_id_seq OWNER TO farai;

--
-- Name: nt_scripts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_scripts_id_seq OWNED BY public.nt_scripts.id;


--
-- Name: nt_sites; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_sites (
    id integer NOT NULL,
    site_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    name text NOT NULL,
    link text NOT NULL,
    api_key text NOT NULL,
    type public.site_type NOT NULL,
    env public.site_env DEFAULT 'production'::public.site_env NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    display_name text,
    country_iso text DEFAULT 'zw'::text NOT NULL,
    country_name text DEFAULT 'Zimbabwe'::text NOT NULL
);


ALTER TABLE public.nt_sites OWNER TO farai;

--
-- Name: nt_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_sites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_sites_id_seq OWNER TO farai;

--
-- Name: nt_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_sites_id_seq OWNED BY public.nt_sites.id;


--
-- Name: nt_sys; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_sys (
    _id integer NOT NULL,
    id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    key text NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.nt_sys OWNER TO farai;

--
-- Name: nt_sys__id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_sys__id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_sys__id_seq OWNER TO farai;

--
-- Name: nt_sys__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_sys__id_seq OWNED BY public.nt_sys._id;


--
-- Name: nt_tokens; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_tokens (
    id integer NOT NULL,
    code integer NOT NULL,
    secret text NOT NULL,
    valid_until timestamp without time zone NOT NULL
);


ALTER TABLE public.nt_tokens OWNER TO farai;

--
-- Name: nt_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_tokens_id_seq OWNER TO farai;

--
-- Name: nt_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_tokens_id_seq OWNED BY public.nt_tokens.id;


--
-- Name: nt_user_roles; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_user_roles (
    id integer NOT NULL,
    name public.role_name NOT NULL,
    description text
);


ALTER TABLE public.nt_user_roles OWNER TO farai;

--
-- Name: nt_user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_user_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_user_roles_id_seq OWNER TO farai;

--
-- Name: nt_user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_user_roles_id_seq OWNED BY public.nt_user_roles.id;


--
-- Name: nt_users; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.nt_users (
    id integer NOT NULL,
    user_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    role public.role_name DEFAULT 'user'::public.role_name NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    display_name text NOT NULL,
    first_name text,
    last_name text,
    avatar text,
    avatar_sm text,
    avatar_md text,
    activation_date timestamp without time zone,
    last_login_date timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.nt_users OWNER TO farai;

--
-- Name: nt_users_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.nt_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_users_id_seq OWNER TO farai;

--
-- Name: nt_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.nt_users_id_seq OWNED BY public.nt_users.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    object character varying(254) NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.permissions OWNER TO farai;

--
-- Name: permissions_group; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.permissions_group (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.permissions_group OWNER TO farai;

--
-- Name: permissions_group_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.permissions_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permissions_group_id_seq OWNER TO farai;

--
-- Name: permissions_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.permissions_group_id_seq OWNED BY public.permissions_group.id;


--
-- Name: permissions_group_membership; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.permissions_group_membership (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.permissions_group_membership OWNER TO farai;

--
-- Name: permissions_group_membership_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.permissions_group_membership_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permissions_group_membership_id_seq OWNER TO farai;

--
-- Name: permissions_group_membership_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.permissions_group_membership_id_seq OWNED BY public.permissions_group_membership.id;


--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permissions_id_seq OWNER TO farai;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: permissions_revision; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.permissions_revision (
    id integer NOT NULL,
    before text NOT NULL,
    after text NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    remark text
);


ALTER TABLE public.permissions_revision OWNER TO farai;

--
-- Name: TABLE permissions_revision; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.permissions_revision IS 'Used to keep track of changes made to permissions.';


--
-- Name: COLUMN permissions_revision.before; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.permissions_revision.before IS 'Serialized JSON of the permissions before the changes.';


--
-- Name: COLUMN permissions_revision.after; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.permissions_revision.after IS 'Serialized JSON of the permissions after the changes.';


--
-- Name: COLUMN permissions_revision.user_id; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.permissions_revision.user_id IS 'The ID of the admin who made this set of changes.';


--
-- Name: COLUMN permissions_revision.created_at; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.permissions_revision.created_at IS 'The timestamp of when these changes were made.';


--
-- Name: COLUMN permissions_revision.remark; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.permissions_revision.remark IS 'Optional remarks explaining why these changes were made.';


--
-- Name: permissions_revision_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.permissions_revision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permissions_revision_id_seq OWNER TO farai;

--
-- Name: permissions_revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.permissions_revision_id_seq OWNED BY public.permissions_revision.id;


--
-- Name: pulse; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.pulse (
    id integer NOT NULL,
    creator_id integer NOT NULL,
    name character varying(254),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    skip_if_empty boolean DEFAULT false NOT NULL,
    alert_condition character varying(254),
    alert_first_only boolean,
    alert_above_goal boolean,
    collection_id integer,
    collection_position smallint,
    archived boolean DEFAULT false
);


ALTER TABLE public.pulse OWNER TO farai;

--
-- Name: COLUMN pulse.skip_if_empty; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.pulse.skip_if_empty IS 'Skip a scheduled Pulse if none of its questions have any results';


--
-- Name: COLUMN pulse.alert_condition; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.pulse.alert_condition IS 'Condition (i.e. "rows" or "goal") used as a guard for alerts';


--
-- Name: COLUMN pulse.alert_first_only; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.pulse.alert_first_only IS 'True if the alert should be disabled after the first notification';


--
-- Name: COLUMN pulse.alert_above_goal; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.pulse.alert_above_goal IS 'For a goal condition, alert when above the goal';


--
-- Name: COLUMN pulse.collection_id; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.pulse.collection_id IS 'Options ID of Collection this Pulse belongs to.';


--
-- Name: COLUMN pulse.collection_position; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.pulse.collection_position IS 'Optional pinned position for this item in its Collection. NULL means item is not pinned.';


--
-- Name: COLUMN pulse.archived; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.pulse.archived IS 'Has this pulse been archived?';


--
-- Name: pulse_card; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.pulse_card (
    id integer NOT NULL,
    pulse_id integer NOT NULL,
    card_id integer NOT NULL,
    "position" integer NOT NULL,
    include_csv boolean DEFAULT false NOT NULL,
    include_xls boolean DEFAULT false NOT NULL
);


ALTER TABLE public.pulse_card OWNER TO farai;

--
-- Name: COLUMN pulse_card.include_csv; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.pulse_card.include_csv IS 'True if a CSV of the data should be included for this pulse card';


--
-- Name: COLUMN pulse_card.include_xls; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.pulse_card.include_xls IS 'True if a XLS of the data should be included for this pulse card';


--
-- Name: pulse_card_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.pulse_card_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pulse_card_id_seq OWNER TO farai;

--
-- Name: pulse_card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.pulse_card_id_seq OWNED BY public.pulse_card.id;


--
-- Name: pulse_channel; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.pulse_channel (
    id integer NOT NULL,
    pulse_id integer NOT NULL,
    channel_type character varying(32) NOT NULL,
    details text NOT NULL,
    schedule_type character varying(32) NOT NULL,
    schedule_hour integer,
    schedule_day character varying(64),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    schedule_frame character varying(32),
    enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.pulse_channel OWNER TO farai;

--
-- Name: pulse_channel_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.pulse_channel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pulse_channel_id_seq OWNER TO farai;

--
-- Name: pulse_channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.pulse_channel_id_seq OWNED BY public.pulse_channel.id;


--
-- Name: pulse_channel_recipient; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.pulse_channel_recipient (
    id integer NOT NULL,
    pulse_channel_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.pulse_channel_recipient OWNER TO farai;

--
-- Name: pulse_channel_recipient_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.pulse_channel_recipient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pulse_channel_recipient_id_seq OWNER TO farai;

--
-- Name: pulse_channel_recipient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.pulse_channel_recipient_id_seq OWNED BY public.pulse_channel_recipient.id;


--
-- Name: pulse_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.pulse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pulse_id_seq OWNER TO farai;

--
-- Name: pulse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.pulse_id_seq OWNED BY public.pulse.id;


--
-- Name: qrtz_blob_triggers; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.qrtz_blob_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    blob_data bytea
);


ALTER TABLE public.qrtz_blob_triggers OWNER TO farai;

--
-- Name: TABLE qrtz_blob_triggers; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.qrtz_blob_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_calendars; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.qrtz_calendars (
    sched_name character varying(120) NOT NULL,
    calendar_name character varying(200) NOT NULL,
    calendar bytea NOT NULL
);


ALTER TABLE public.qrtz_calendars OWNER TO farai;

--
-- Name: TABLE qrtz_calendars; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.qrtz_calendars IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_cron_triggers; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.qrtz_cron_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    cron_expression character varying(120) NOT NULL,
    time_zone_id character varying(80)
);


ALTER TABLE public.qrtz_cron_triggers OWNER TO farai;

--
-- Name: TABLE qrtz_cron_triggers; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.qrtz_cron_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_fired_triggers; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.qrtz_fired_triggers (
    sched_name character varying(120) NOT NULL,
    entry_id character varying(95) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    instance_name character varying(200) NOT NULL,
    fired_time bigint NOT NULL,
    sched_time bigint,
    priority integer NOT NULL,
    state character varying(16) NOT NULL,
    job_name character varying(200),
    job_group character varying(200),
    is_nonconcurrent boolean,
    requests_recovery boolean
);


ALTER TABLE public.qrtz_fired_triggers OWNER TO farai;

--
-- Name: TABLE qrtz_fired_triggers; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.qrtz_fired_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_job_details; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.qrtz_job_details (
    sched_name character varying(120) NOT NULL,
    job_name character varying(200) NOT NULL,
    job_group character varying(200) NOT NULL,
    description character varying(250),
    job_class_name character varying(250) NOT NULL,
    is_durable boolean NOT NULL,
    is_nonconcurrent boolean NOT NULL,
    is_update_data boolean NOT NULL,
    requests_recovery boolean NOT NULL,
    job_data bytea
);


ALTER TABLE public.qrtz_job_details OWNER TO farai;

--
-- Name: TABLE qrtz_job_details; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.qrtz_job_details IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_locks; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.qrtz_locks (
    sched_name character varying(120) NOT NULL,
    lock_name character varying(40) NOT NULL
);


ALTER TABLE public.qrtz_locks OWNER TO farai;

--
-- Name: TABLE qrtz_locks; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.qrtz_locks IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_paused_trigger_grps; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.qrtz_paused_trigger_grps (
    sched_name character varying(120) NOT NULL,
    trigger_group character varying(200) NOT NULL
);


ALTER TABLE public.qrtz_paused_trigger_grps OWNER TO farai;

--
-- Name: TABLE qrtz_paused_trigger_grps; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.qrtz_paused_trigger_grps IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_scheduler_state; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.qrtz_scheduler_state (
    sched_name character varying(120) NOT NULL,
    instance_name character varying(200) NOT NULL,
    last_checkin_time bigint NOT NULL,
    checkin_interval bigint NOT NULL
);


ALTER TABLE public.qrtz_scheduler_state OWNER TO farai;

--
-- Name: TABLE qrtz_scheduler_state; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.qrtz_scheduler_state IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_simple_triggers; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.qrtz_simple_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    repeat_count bigint NOT NULL,
    repeat_interval bigint NOT NULL,
    times_triggered bigint NOT NULL
);


ALTER TABLE public.qrtz_simple_triggers OWNER TO farai;

--
-- Name: TABLE qrtz_simple_triggers; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.qrtz_simple_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_simprop_triggers; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.qrtz_simprop_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    str_prop_1 character varying(512),
    str_prop_2 character varying(512),
    str_prop_3 character varying(512),
    int_prop_1 integer,
    int_prop_2 integer,
    long_prop_1 bigint,
    long_prop_2 bigint,
    dec_prop_1 numeric(13,4),
    dec_prop_2 numeric(13,4),
    bool_prop_1 boolean,
    bool_prop_2 boolean
);


ALTER TABLE public.qrtz_simprop_triggers OWNER TO farai;

--
-- Name: TABLE qrtz_simprop_triggers; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.qrtz_simprop_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_triggers; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.qrtz_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    job_name character varying(200) NOT NULL,
    job_group character varying(200) NOT NULL,
    description character varying(250),
    next_fire_time bigint,
    prev_fire_time bigint,
    priority integer,
    trigger_state character varying(16) NOT NULL,
    trigger_type character varying(8) NOT NULL,
    start_time bigint NOT NULL,
    end_time bigint,
    calendar_name character varying(200),
    misfire_instr smallint,
    job_data bytea
);


ALTER TABLE public.qrtz_triggers OWNER TO farai;

--
-- Name: TABLE qrtz_triggers; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.qrtz_triggers IS 'Used for Quartz scheduler.';


--
-- Name: query; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.query (
    query_hash bytea NOT NULL,
    average_execution_time integer NOT NULL,
    query text
);


ALTER TABLE public.query OWNER TO farai;

--
-- Name: TABLE query; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.query IS 'Information (such as average execution time) for different queries that have been previously ran.';


--
-- Name: COLUMN query.query_hash; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query.query_hash IS 'The hash of the query dictionary. (This is a 256-bit SHA3 hash of the query dict.)';


--
-- Name: COLUMN query.average_execution_time; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query.average_execution_time IS 'Average execution time for the query, round to nearest number of milliseconds. This is updated as a rolling average.';


--
-- Name: COLUMN query.query; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query.query IS 'The actual "query dictionary" for this query.';


--
-- Name: query_cache; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.query_cache (
    query_hash bytea NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    results bytea NOT NULL
);


ALTER TABLE public.query_cache OWNER TO farai;

--
-- Name: TABLE query_cache; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.query_cache IS 'Cached results of queries are stored here when using the DB-based query cache.';


--
-- Name: COLUMN query_cache.query_hash; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query_cache.query_hash IS 'The hash of the query dictionary. (This is a 256-bit SHA3 hash of the query dict).';


--
-- Name: COLUMN query_cache.updated_at; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query_cache.updated_at IS 'The timestamp of when these query results were last refreshed.';


--
-- Name: COLUMN query_cache.results; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query_cache.results IS 'Cached, compressed results of running the query with the given hash.';


--
-- Name: query_execution; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.query_execution (
    id integer NOT NULL,
    hash bytea NOT NULL,
    started_at timestamp without time zone NOT NULL,
    running_time integer NOT NULL,
    result_rows integer NOT NULL,
    native boolean NOT NULL,
    context character varying(32),
    error text,
    executor_id integer,
    card_id integer,
    dashboard_id integer,
    pulse_id integer,
    database_id integer
);


ALTER TABLE public.query_execution OWNER TO farai;

--
-- Name: TABLE query_execution; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.query_execution IS 'A log of executed queries, used for calculating historic execution times, auditing, and other purposes.';


--
-- Name: COLUMN query_execution.hash; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query_execution.hash IS 'The hash of the query dictionary. This is a 256-bit SHA3 hash of the query.';


--
-- Name: COLUMN query_execution.started_at; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query_execution.started_at IS 'Timestamp of when this query started running.';


--
-- Name: COLUMN query_execution.running_time; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query_execution.running_time IS 'The time, in milliseconds, this query took to complete.';


--
-- Name: COLUMN query_execution.result_rows; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query_execution.result_rows IS 'Number of rows in the query results.';


--
-- Name: COLUMN query_execution.native; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query_execution.native IS 'Whether the query was a native query, as opposed to an MBQL one (e.g., created with the GUI).';


--
-- Name: COLUMN query_execution.context; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query_execution.context IS 'Short string specifying how this query was executed, e.g. in a Dashboard or Pulse.';


--
-- Name: COLUMN query_execution.error; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query_execution.error IS 'Error message returned by failed query, if any.';


--
-- Name: COLUMN query_execution.executor_id; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query_execution.executor_id IS 'The ID of the User who triggered this query execution, if any.';


--
-- Name: COLUMN query_execution.card_id; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query_execution.card_id IS 'The ID of the Card (Question) associated with this query execution, if any.';


--
-- Name: COLUMN query_execution.dashboard_id; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query_execution.dashboard_id IS 'The ID of the Dashboard associated with this query execution, if any.';


--
-- Name: COLUMN query_execution.pulse_id; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query_execution.pulse_id IS 'The ID of the Pulse associated with this query execution, if any.';


--
-- Name: COLUMN query_execution.database_id; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.query_execution.database_id IS 'ID of the database this query was ran against.';


--
-- Name: query_execution_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.query_execution_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.query_execution_id_seq OWNER TO farai;

--
-- Name: query_execution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.query_execution_id_seq OWNED BY public.query_execution.id;


--
-- Name: report_card; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.report_card (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    display character varying(254) NOT NULL,
    dataset_query text NOT NULL,
    visualization_settings text NOT NULL,
    creator_id integer NOT NULL,
    database_id integer,
    table_id integer,
    query_type character varying(16),
    archived boolean DEFAULT false NOT NULL,
    collection_id integer,
    public_uuid character(36),
    made_public_by_id integer,
    enable_embedding boolean DEFAULT false NOT NULL,
    embedding_params text,
    cache_ttl integer,
    result_metadata text,
    read_permissions text,
    collection_position smallint
);


ALTER TABLE public.report_card OWNER TO farai;

--
-- Name: COLUMN report_card.collection_id; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.report_card.collection_id IS 'Optional ID of Collection this Card belongs to.';


--
-- Name: COLUMN report_card.public_uuid; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.report_card.public_uuid IS 'Unique UUID used to in publically-accessible links to this Card.';


--
-- Name: COLUMN report_card.made_public_by_id; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.report_card.made_public_by_id IS 'The ID of the User who first publically shared this Card.';


--
-- Name: COLUMN report_card.enable_embedding; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.report_card.enable_embedding IS 'Is this Card allowed to be embedded in different websites (using a signed JWT)?';


--
-- Name: COLUMN report_card.embedding_params; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.report_card.embedding_params IS 'Serialized JSON containing information about required parameters that must be supplied when embedding this Card.';


--
-- Name: COLUMN report_card.cache_ttl; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.report_card.cache_ttl IS 'The maximum time, in seconds, to return cached results for this Card rather than running a new query.';


--
-- Name: COLUMN report_card.result_metadata; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.report_card.result_metadata IS 'Serialized JSON containing metadata about the result columns from running the query.';


--
-- Name: COLUMN report_card.read_permissions; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.report_card.read_permissions IS 'Permissions required to view this Card and run its query.';


--
-- Name: COLUMN report_card.collection_position; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.report_card.collection_position IS 'Optional pinned position for this item in its Collection. NULL means item is not pinned.';


--
-- Name: report_card_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.report_card_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.report_card_id_seq OWNER TO farai;

--
-- Name: report_card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.report_card_id_seq OWNED BY public.report_card.id;


--
-- Name: report_cardfavorite; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.report_cardfavorite (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    card_id integer NOT NULL,
    owner_id integer NOT NULL
);


ALTER TABLE public.report_cardfavorite OWNER TO farai;

--
-- Name: report_cardfavorite_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.report_cardfavorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.report_cardfavorite_id_seq OWNER TO farai;

--
-- Name: report_cardfavorite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.report_cardfavorite_id_seq OWNED BY public.report_cardfavorite.id;


--
-- Name: report_dashboard; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.report_dashboard (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    creator_id integer NOT NULL,
    parameters text NOT NULL,
    points_of_interest text,
    caveats text,
    show_in_getting_started boolean DEFAULT false NOT NULL,
    public_uuid character(36),
    made_public_by_id integer,
    enable_embedding boolean DEFAULT false NOT NULL,
    embedding_params text,
    archived boolean DEFAULT false NOT NULL,
    "position" integer,
    collection_id integer,
    collection_position smallint
);


ALTER TABLE public.report_dashboard OWNER TO farai;

--
-- Name: COLUMN report_dashboard.public_uuid; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.report_dashboard.public_uuid IS 'Unique UUID used to in publically-accessible links to this Dashboard.';


--
-- Name: COLUMN report_dashboard.made_public_by_id; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.report_dashboard.made_public_by_id IS 'The ID of the User who first publically shared this Dashboard.';


--
-- Name: COLUMN report_dashboard.enable_embedding; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.report_dashboard.enable_embedding IS 'Is this Dashboard allowed to be embedded in different websites (using a signed JWT)?';


--
-- Name: COLUMN report_dashboard.embedding_params; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.report_dashboard.embedding_params IS 'Serialized JSON containing information about required parameters that must be supplied when embedding this Dashboard.';


--
-- Name: COLUMN report_dashboard.archived; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.report_dashboard.archived IS 'Is this Dashboard archived (effectively treated as deleted?)';


--
-- Name: COLUMN report_dashboard."position"; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.report_dashboard."position" IS 'The position this Dashboard should appear in the Dashboards list, lower-numbered positions appearing before higher numbered ones.';


--
-- Name: COLUMN report_dashboard.collection_id; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.report_dashboard.collection_id IS 'Optional ID of Collection this Dashboard belongs to.';


--
-- Name: COLUMN report_dashboard.collection_position; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.report_dashboard.collection_position IS 'Optional pinned position for this item in its Collection. NULL means item is not pinned.';


--
-- Name: report_dashboard_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.report_dashboard_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.report_dashboard_id_seq OWNER TO farai;

--
-- Name: report_dashboard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.report_dashboard_id_seq OWNED BY public.report_dashboard.id;


--
-- Name: report_dashboardcard; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.report_dashboardcard (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    "sizeX" integer NOT NULL,
    "sizeY" integer NOT NULL,
    "row" integer DEFAULT 0 NOT NULL,
    col integer DEFAULT 0 NOT NULL,
    card_id integer,
    dashboard_id integer NOT NULL,
    parameter_mappings text NOT NULL,
    visualization_settings text NOT NULL
);


ALTER TABLE public.report_dashboardcard OWNER TO farai;

--
-- Name: report_dashboardcard_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.report_dashboardcard_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.report_dashboardcard_id_seq OWNER TO farai;

--
-- Name: report_dashboardcard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.report_dashboardcard_id_seq OWNED BY public.report_dashboardcard.id;


--
-- Name: revision; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.revision (
    id integer NOT NULL,
    model character varying(16) NOT NULL,
    model_id integer NOT NULL,
    user_id integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    object character varying NOT NULL,
    is_reversion boolean DEFAULT false NOT NULL,
    is_creation boolean DEFAULT false NOT NULL,
    message text
);


ALTER TABLE public.revision OWNER TO farai;

--
-- Name: revision_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.revision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.revision_id_seq OWNER TO farai;

--
-- Name: revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.revision_id_seq OWNED BY public.revision.id;


--
-- Name: screens; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.screens (
    id integer NOT NULL,
    screen_id character varying(255) NOT NULL,
    data json DEFAULT '"{}"'::json,
    type character varying(255),
    "position" integer,
    script_id character varying(255),
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.screens OWNER TO farai;

--
-- Name: screens_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.screens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.screens_id_seq OWNER TO farai;

--
-- Name: screens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.screens_id_seq OWNED BY public.screens.id;


--
-- Name: scripts; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.scripts (
    id integer NOT NULL,
    script_id character varying(255) NOT NULL,
    "position" integer,
    data json DEFAULT '"{}"'::json,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.scripts OWNER TO farai;

--
-- Name: scripts_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.scripts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.scripts_id_seq OWNER TO farai;

--
-- Name: scripts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.scripts_id_seq OWNED BY public.scripts.id;


--
-- Name: segment; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.segment (
    id integer NOT NULL,
    table_id integer NOT NULL,
    creator_id integer NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    archived boolean DEFAULT false NOT NULL,
    definition text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    points_of_interest text,
    caveats text,
    show_in_getting_started boolean DEFAULT false NOT NULL
);


ALTER TABLE public.segment OWNER TO farai;

--
-- Name: segment_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.segment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.segment_id_seq OWNER TO farai;

--
-- Name: segment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.segment_id_seq OWNED BY public.segment.id;


--
-- Name: setting; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.setting (
    key character varying(254) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.setting OWNER TO farai;

--
-- Name: task_history; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.task_history (
    id integer NOT NULL,
    task character varying(254) NOT NULL,
    db_id integer,
    started_at timestamp without time zone NOT NULL,
    ended_at timestamp without time zone NOT NULL,
    duration integer NOT NULL,
    task_details text
);


ALTER TABLE public.task_history OWNER TO farai;

--
-- Name: TABLE task_history; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON TABLE public.task_history IS 'Timing and metadata info about background/quartz processes';


--
-- Name: COLUMN task_history.task; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.task_history.task IS 'Name of the task';


--
-- Name: COLUMN task_history.task_details; Type: COMMENT; Schema: public; Owner: farai
--

COMMENT ON COLUMN public.task_history.task_details IS 'JSON string with additional info on the task';


--
-- Name: task_history_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.task_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.task_history_id_seq OWNER TO farai;

--
-- Name: task_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.task_history_id_seq OWNED BY public.task_history.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.users (
    id integer NOT NULL,
    user_id character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255),
    data json DEFAULT '"{}"'::json,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    role integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.users OWNER TO farai;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO farai;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: view_log; Type: TABLE; Schema: public; Owner: farai
--

CREATE TABLE public.view_log (
    id integer NOT NULL,
    user_id integer,
    model character varying(16) NOT NULL,
    model_id integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL
);


ALTER TABLE public.view_log OWNER TO farai;

--
-- Name: view_log_id_seq; Type: SEQUENCE; Schema: public; Owner: farai
--

CREATE SEQUENCE public.view_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.view_log_id_seq OWNER TO farai;

--
-- Name: view_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: farai
--

ALTER SEQUENCE public.view_log_id_seq OWNED BY public.view_log.id;


--
-- Name: activity id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.activity ALTER COLUMN id SET DEFAULT nextval('public.activity_id_seq'::regclass);


--
-- Name: api_keys id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.api_keys ALTER COLUMN id SET DEFAULT nextval('public.api_keys_id_seq'::regclass);


--
-- Name: apps id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.apps ALTER COLUMN id SET DEFAULT nextval('public.apps_id_seq'::regclass);


--
-- Name: card_label id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.card_label ALTER COLUMN id SET DEFAULT nextval('public.card_label_id_seq'::regclass);


--
-- Name: collection id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.collection ALTER COLUMN id SET DEFAULT nextval('public.collection_id_seq'::regclass);


--
-- Name: collection_revision id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.collection_revision ALTER COLUMN id SET DEFAULT nextval('public.collection_revision_id_seq'::regclass);


--
-- Name: computation_job id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.computation_job ALTER COLUMN id SET DEFAULT nextval('public.computation_job_id_seq'::regclass);


--
-- Name: computation_job_result id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.computation_job_result ALTER COLUMN id SET DEFAULT nextval('public.computation_job_result_id_seq'::regclass);


--
-- Name: config_keys id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.config_keys ALTER COLUMN id SET DEFAULT nextval('public.config_keys_id_seq'::regclass);


--
-- Name: configurations id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.configurations ALTER COLUMN id SET DEFAULT nextval('public.configurations_id_seq'::regclass);


--
-- Name: core_user id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.core_user ALTER COLUMN id SET DEFAULT nextval('public.core_user_id_seq'::regclass);


--
-- Name: dashboard_favorite id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.dashboard_favorite ALTER COLUMN id SET DEFAULT nextval('public.dashboard_favorite_id_seq'::regclass);


--
-- Name: dashboardcard_series id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.dashboardcard_series ALTER COLUMN id SET DEFAULT nextval('public.dashboardcard_series_id_seq'::regclass);


--
-- Name: dependency id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.dependency ALTER COLUMN id SET DEFAULT nextval('public.dependency_id_seq'::regclass);


--
-- Name: devices id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.devices ALTER COLUMN id SET DEFAULT nextval('public.devices_id_seq'::regclass);


--
-- Name: diagnoses id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.diagnoses ALTER COLUMN id SET DEFAULT nextval('public.diagnoses_id_seq'::regclass);


--
-- Name: dimension id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.dimension ALTER COLUMN id SET DEFAULT nextval('public.dimension_id_seq'::regclass);


--
-- Name: hospitals id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.hospitals ALTER COLUMN id SET DEFAULT nextval('public.hospitals_id_seq'::regclass);


--
-- Name: label id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.label ALTER COLUMN id SET DEFAULT nextval('public.label_id_seq'::regclass);


--
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


--
-- Name: metabase_database id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metabase_database ALTER COLUMN id SET DEFAULT nextval('public.metabase_database_id_seq'::regclass);


--
-- Name: metabase_field id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metabase_field ALTER COLUMN id SET DEFAULT nextval('public.metabase_field_id_seq'::regclass);


--
-- Name: metabase_fieldvalues id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metabase_fieldvalues ALTER COLUMN id SET DEFAULT nextval('public.metabase_fieldvalues_id_seq'::regclass);


--
-- Name: metabase_table id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metabase_table ALTER COLUMN id SET DEFAULT nextval('public.metabase_table_id_seq'::regclass);


--
-- Name: metric id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metric ALTER COLUMN id SET DEFAULT nextval('public.metric_id_seq'::regclass);


--
-- Name: metric_important_field id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metric_important_field ALTER COLUMN id SET DEFAULT nextval('public.metric_important_field_id_seq'::regclass);


--
-- Name: nt_aliases id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_aliases ALTER COLUMN id SET DEFAULT nextval('public.nt_aliases_id_seq'::regclass);


--
-- Name: nt_api_keys id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_api_keys ALTER COLUMN id SET DEFAULT nextval('public.nt_api_keys_id_seq'::regclass);


--
-- Name: nt_auth_clients id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_auth_clients ALTER COLUMN id SET DEFAULT nextval('public.nt_auth_clients_id_seq'::regclass);


--
-- Name: nt_change_logs id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_change_logs ALTER COLUMN id SET DEFAULT nextval('public.nt_change_logs_id_seq'::regclass);


--
-- Name: nt_config_keys id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_config_keys ALTER COLUMN id SET DEFAULT nextval('public.nt_config_keys_id_seq'::regclass);


--
-- Name: nt_config_keys_drafts id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_config_keys_drafts ALTER COLUMN id SET DEFAULT nextval('public.nt_config_keys_drafts_id_seq'::regclass);


--
-- Name: nt_config_keys_history id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_config_keys_history ALTER COLUMN id SET DEFAULT nextval('public.nt_config_keys_history_id_seq'::regclass);


--
-- Name: nt_data_keys id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_data_keys ALTER COLUMN id SET DEFAULT nextval('public.nt_data_keys_id_seq'::regclass);


--
-- Name: nt_data_keys_drafts id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_data_keys_drafts ALTER COLUMN id SET DEFAULT nextval('public.nt_data_keys_drafts_id_seq'::regclass);


--
-- Name: nt_data_keys_history id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_data_keys_history ALTER COLUMN id SET DEFAULT nextval('public.nt_data_keys_history_id_seq'::regclass);


--
-- Name: nt_devices id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_devices ALTER COLUMN id SET DEFAULT nextval('public.nt_devices_id_seq'::regclass);


--
-- Name: nt_diagnoses id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_diagnoses ALTER COLUMN id SET DEFAULT nextval('public.nt_diagnoses_id_seq'::regclass);


--
-- Name: nt_diagnoses_drafts id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_diagnoses_drafts ALTER COLUMN id SET DEFAULT nextval('public.nt_diagnoses_drafts_id_seq'::regclass);


--
-- Name: nt_diagnoses_history id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_diagnoses_history ALTER COLUMN id SET DEFAULT nextval('public.nt_diagnoses_history_id_seq'::regclass);


--
-- Name: nt_drugs_library id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_drugs_library ALTER COLUMN id SET DEFAULT nextval('public.nt_drugs_library_id_seq'::regclass);


--
-- Name: nt_drugs_library_drafts id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_drugs_library_drafts ALTER COLUMN id SET DEFAULT nextval('public.nt_drugs_library_drafts_id_seq'::regclass);


--
-- Name: nt_drugs_library_history id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_drugs_library_history ALTER COLUMN id SET DEFAULT nextval('public.nt_drugs_library_history_id_seq'::regclass);


--
-- Name: nt_editor_info id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_editor_info ALTER COLUMN id SET DEFAULT nextval('public.nt_editor_info_id_seq'::regclass);


--
-- Name: nt_email_templates id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_email_templates ALTER COLUMN id SET DEFAULT nextval('public.nt_email_templates_id_seq'::regclass);


--
-- Name: nt_files id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_files ALTER COLUMN id SET DEFAULT nextval('public.nt_files_id_seq'::regclass);


--
-- Name: nt_files_chunks id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_files_chunks ALTER COLUMN id SET DEFAULT nextval('public.nt_files_chunks_id_seq'::regclass);


--
-- Name: nt_hospitals id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_hospitals ALTER COLUMN id SET DEFAULT nextval('public.nt_hospitals_id_seq'::regclass);


--
-- Name: nt_hospitals_drafts id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_hospitals_drafts ALTER COLUMN id SET DEFAULT nextval('public.nt_hospitals_drafts_id_seq'::regclass);


--
-- Name: nt_hospitals_history id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_hospitals_history ALTER COLUMN id SET DEFAULT nextval('public.nt_hospitals_history_id_seq'::regclass);


--
-- Name: nt_languages id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_languages ALTER COLUMN id SET DEFAULT nextval('public.nt_languages_id_seq'::regclass);


--
-- Name: nt_mailer_settings id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_mailer_settings ALTER COLUMN id SET DEFAULT nextval('public.nt_mailer_settings_id_seq'::regclass);


--
-- Name: nt_pending_deletion id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_pending_deletion ALTER COLUMN id SET DEFAULT nextval('public.nt_pending_deletion_id_seq'::regclass);


--
-- Name: nt_screens id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_screens ALTER COLUMN id SET DEFAULT nextval('public.nt_screens_id_seq'::regclass);


--
-- Name: nt_screens_drafts id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_screens_drafts ALTER COLUMN id SET DEFAULT nextval('public.nt_screens_drafts_id_seq'::regclass);


--
-- Name: nt_screens_history id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_screens_history ALTER COLUMN id SET DEFAULT nextval('public.nt_screens_history_id_seq'::regclass);


--
-- Name: nt_scripts id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_scripts ALTER COLUMN id SET DEFAULT nextval('public.nt_scripts_id_seq'::regclass);


--
-- Name: nt_scripts_drafts id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_scripts_drafts ALTER COLUMN id SET DEFAULT nextval('public.nt_scripts_drafts_id_seq'::regclass);


--
-- Name: nt_scripts_history id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_scripts_history ALTER COLUMN id SET DEFAULT nextval('public.nt_scripts_history_id_seq'::regclass);


--
-- Name: nt_sites id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_sites ALTER COLUMN id SET DEFAULT nextval('public.nt_sites_id_seq'::regclass);


--
-- Name: nt_sys _id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_sys ALTER COLUMN _id SET DEFAULT nextval('public.nt_sys__id_seq'::regclass);


--
-- Name: nt_tokens id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_tokens ALTER COLUMN id SET DEFAULT nextval('public.nt_tokens_id_seq'::regclass);


--
-- Name: nt_user_roles id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_user_roles ALTER COLUMN id SET DEFAULT nextval('public.nt_user_roles_id_seq'::regclass);


--
-- Name: nt_users id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_users ALTER COLUMN id SET DEFAULT nextval('public.nt_users_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: permissions_group id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.permissions_group ALTER COLUMN id SET DEFAULT nextval('public.permissions_group_id_seq'::regclass);


--
-- Name: permissions_group_membership id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.permissions_group_membership ALTER COLUMN id SET DEFAULT nextval('public.permissions_group_membership_id_seq'::regclass);


--
-- Name: permissions_revision id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.permissions_revision ALTER COLUMN id SET DEFAULT nextval('public.permissions_revision_id_seq'::regclass);


--
-- Name: pulse id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.pulse ALTER COLUMN id SET DEFAULT nextval('public.pulse_id_seq'::regclass);


--
-- Name: pulse_card id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.pulse_card ALTER COLUMN id SET DEFAULT nextval('public.pulse_card_id_seq'::regclass);


--
-- Name: pulse_channel id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.pulse_channel ALTER COLUMN id SET DEFAULT nextval('public.pulse_channel_id_seq'::regclass);


--
-- Name: pulse_channel_recipient id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.pulse_channel_recipient ALTER COLUMN id SET DEFAULT nextval('public.pulse_channel_recipient_id_seq'::regclass);


--
-- Name: query_execution id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.query_execution ALTER COLUMN id SET DEFAULT nextval('public.query_execution_id_seq'::regclass);


--
-- Name: report_card id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_card ALTER COLUMN id SET DEFAULT nextval('public.report_card_id_seq'::regclass);


--
-- Name: report_cardfavorite id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_cardfavorite ALTER COLUMN id SET DEFAULT nextval('public.report_cardfavorite_id_seq'::regclass);


--
-- Name: report_dashboard id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_dashboard ALTER COLUMN id SET DEFAULT nextval('public.report_dashboard_id_seq'::regclass);


--
-- Name: report_dashboardcard id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_dashboardcard ALTER COLUMN id SET DEFAULT nextval('public.report_dashboardcard_id_seq'::regclass);


--
-- Name: revision id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.revision ALTER COLUMN id SET DEFAULT nextval('public.revision_id_seq'::regclass);


--
-- Name: screens id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.screens ALTER COLUMN id SET DEFAULT nextval('public.screens_id_seq'::regclass);


--
-- Name: scripts id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.scripts ALTER COLUMN id SET DEFAULT nextval('public.scripts_id_seq'::regclass);


--
-- Name: segment id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.segment ALTER COLUMN id SET DEFAULT nextval('public.segment_id_seq'::regclass);


--
-- Name: task_history id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.task_history ALTER COLUMN id SET DEFAULT nextval('public.task_history_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: view_log id; Type: DEFAULT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.view_log ALTER COLUMN id SET DEFAULT nextval('public.view_log_id_seq'::regclass);


--
-- Name: Session Session_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public."Session"
    ADD CONSTRAINT "Session_pkey" PRIMARY KEY (sid);


--
-- Name: Sessions Sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public."Sessions"
    ADD CONSTRAINT "Sessions_pkey" PRIMARY KEY (sid);


--
-- Name: activity activity_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.activity
    ADD CONSTRAINT activity_pkey PRIMARY KEY (id);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: apps apps_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.apps
    ADD CONSTRAINT apps_pkey PRIMARY KEY (id);


--
-- Name: card_label card_label_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.card_label
    ADD CONSTRAINT card_label_pkey PRIMARY KEY (id);


--
-- Name: collection collection_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_pkey PRIMARY KEY (id);


--
-- Name: collection_revision collection_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.collection_revision
    ADD CONSTRAINT collection_revision_pkey PRIMARY KEY (id);


--
-- Name: computation_job computation_job_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.computation_job
    ADD CONSTRAINT computation_job_pkey PRIMARY KEY (id);


--
-- Name: computation_job_result computation_job_result_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.computation_job_result
    ADD CONSTRAINT computation_job_result_pkey PRIMARY KEY (id);


--
-- Name: config_keys config_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.config_keys
    ADD CONSTRAINT config_keys_pkey PRIMARY KEY (id);


--
-- Name: configurations configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.configurations
    ADD CONSTRAINT configurations_pkey PRIMARY KEY (id);


--
-- Name: core_session core_session_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.core_session
    ADD CONSTRAINT core_session_pkey PRIMARY KEY (id);


--
-- Name: core_user core_user_email_key; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.core_user
    ADD CONSTRAINT core_user_email_key UNIQUE (email);


--
-- Name: core_user core_user_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.core_user
    ADD CONSTRAINT core_user_pkey PRIMARY KEY (id);


--
-- Name: dashboard_favorite dashboard_favorite_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.dashboard_favorite
    ADD CONSTRAINT dashboard_favorite_pkey PRIMARY KEY (id);


--
-- Name: dashboardcard_series dashboardcard_series_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.dashboardcard_series
    ADD CONSTRAINT dashboardcard_series_pkey PRIMARY KEY (id);


--
-- Name: data_migrations data_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.data_migrations
    ADD CONSTRAINT data_migrations_pkey PRIMARY KEY (id);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: dependency dependency_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.dependency
    ADD CONSTRAINT dependency_pkey PRIMARY KEY (id);


--
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: diagnoses diagnoses_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.diagnoses
    ADD CONSTRAINT diagnoses_pkey PRIMARY KEY (id);


--
-- Name: dimension dimension_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.dimension
    ADD CONSTRAINT dimension_pkey PRIMARY KEY (id);


--
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: hospitals hospitals_hospital_id_key; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.hospitals
    ADD CONSTRAINT hospitals_hospital_id_key UNIQUE (hospital_id);


--
-- Name: hospitals hospitals_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.hospitals
    ADD CONSTRAINT hospitals_pkey PRIMARY KEY (id);


--
-- Name: databasechangelog idx_databasechangelog_id_author_filename; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.databasechangelog
    ADD CONSTRAINT idx_databasechangelog_id_author_filename UNIQUE (id, author, filename);


--
-- Name: metabase_field idx_uniq_field_table_id_parent_id_name; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metabase_field
    ADD CONSTRAINT idx_uniq_field_table_id_parent_id_name UNIQUE (table_id, parent_id, name);


--
-- Name: metabase_table idx_uniq_table_db_id_schema_name; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metabase_table
    ADD CONSTRAINT idx_uniq_table_db_id_schema_name UNIQUE (db_id, schema, name);


--
-- Name: report_cardfavorite idx_unique_cardfavorite_card_id_owner_id; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_cardfavorite
    ADD CONSTRAINT idx_unique_cardfavorite_card_id_owner_id UNIQUE (card_id, owner_id);


--
-- Name: label label_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.label
    ADD CONSTRAINT label_pkey PRIMARY KEY (id);


--
-- Name: label label_slug_key; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.label
    ADD CONSTRAINT label_slug_key UNIQUE (slug);


--
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: metabase_database metabase_database_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metabase_database
    ADD CONSTRAINT metabase_database_pkey PRIMARY KEY (id);


--
-- Name: metabase_field metabase_field_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metabase_field
    ADD CONSTRAINT metabase_field_pkey PRIMARY KEY (id);


--
-- Name: metabase_fieldvalues metabase_fieldvalues_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metabase_fieldvalues
    ADD CONSTRAINT metabase_fieldvalues_pkey PRIMARY KEY (id);


--
-- Name: metabase_table metabase_table_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metabase_table
    ADD CONSTRAINT metabase_table_pkey PRIMARY KEY (id);


--
-- Name: metric_important_field metric_important_field_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metric_important_field
    ADD CONSTRAINT metric_important_field_pkey PRIMARY KEY (id);


--
-- Name: metric metric_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metric
    ADD CONSTRAINT metric_pkey PRIMARY KEY (id);


--
-- Name: nt_aliases nt_aliases_name_script_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_aliases
    ADD CONSTRAINT nt_aliases_name_script_unique UNIQUE (name, script);


--
-- Name: nt_aliases nt_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_aliases
    ADD CONSTRAINT nt_aliases_pkey PRIMARY KEY (id);


--
-- Name: nt_aliases nt_aliases_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_aliases
    ADD CONSTRAINT nt_aliases_uuid_unique UNIQUE (uuid);


--
-- Name: nt_api_keys nt_api_keys_api_key_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_api_keys
    ADD CONSTRAINT nt_api_keys_api_key_id_unique UNIQUE (api_key_id);


--
-- Name: nt_api_keys nt_api_keys_api_key_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_api_keys
    ADD CONSTRAINT nt_api_keys_api_key_unique UNIQUE (api_key);


--
-- Name: nt_api_keys nt_api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_api_keys
    ADD CONSTRAINT nt_api_keys_pkey PRIMARY KEY (id);


--
-- Name: nt_auth_clients nt_auth_clients_client_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_auth_clients
    ADD CONSTRAINT nt_auth_clients_client_id_unique UNIQUE (client_id);


--
-- Name: nt_auth_clients nt_auth_clients_client_token_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_auth_clients
    ADD CONSTRAINT nt_auth_clients_client_token_unique UNIQUE (client_token);


--
-- Name: nt_auth_clients nt_auth_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_auth_clients
    ADD CONSTRAINT nt_auth_clients_pkey PRIMARY KEY (id);


--
-- Name: nt_change_logs nt_change_logs_change_log_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_change_log_id_unique UNIQUE (change_log_id);


--
-- Name: nt_change_logs nt_change_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_pkey PRIMARY KEY (id);


--
-- Name: nt_config_keys nt_config_keys_config_key_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_config_keys
    ADD CONSTRAINT nt_config_keys_config_key_id_unique UNIQUE (config_key_id);


--
-- Name: nt_config_keys_drafts nt_config_keys_drafts_config_key_draft_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_config_keys_drafts
    ADD CONSTRAINT nt_config_keys_drafts_config_key_draft_id_unique UNIQUE (config_key_draft_id);


--
-- Name: nt_config_keys_drafts nt_config_keys_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_config_keys_drafts
    ADD CONSTRAINT nt_config_keys_drafts_pkey PRIMARY KEY (id);


--
-- Name: nt_config_keys_history nt_config_keys_history_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_config_keys_history
    ADD CONSTRAINT nt_config_keys_history_pkey PRIMARY KEY (id);


--
-- Name: nt_config_keys nt_config_keys_key_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_config_keys
    ADD CONSTRAINT nt_config_keys_key_unique UNIQUE (key);


--
-- Name: nt_config_keys nt_config_keys_label_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_config_keys
    ADD CONSTRAINT nt_config_keys_label_unique UNIQUE (label);


--
-- Name: nt_config_keys nt_config_keys_old_config_key_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_config_keys
    ADD CONSTRAINT nt_config_keys_old_config_key_id_unique UNIQUE (old_config_key_id);


--
-- Name: nt_config_keys nt_config_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_config_keys
    ADD CONSTRAINT nt_config_keys_pkey PRIMARY KEY (id);


--
-- Name: nt_data_keys_drafts nt_data_keys_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_data_keys_drafts
    ADD CONSTRAINT nt_data_keys_drafts_pkey PRIMARY KEY (id);


--
-- Name: nt_data_keys_drafts nt_data_keys_drafts_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_data_keys_drafts
    ADD CONSTRAINT nt_data_keys_drafts_uuid_unique UNIQUE (uuid);


--
-- Name: nt_data_keys_history nt_data_keys_history_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_data_keys_history
    ADD CONSTRAINT nt_data_keys_history_pkey PRIMARY KEY (id);


--
-- Name: nt_data_keys nt_data_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_data_keys
    ADD CONSTRAINT nt_data_keys_pkey PRIMARY KEY (id);


--
-- Name: nt_data_keys nt_data_keys_unique_key_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_data_keys
    ADD CONSTRAINT nt_data_keys_unique_key_unique UNIQUE (unique_key);


--
-- Name: nt_data_keys nt_data_keys_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_data_keys
    ADD CONSTRAINT nt_data_keys_uuid_unique UNIQUE (uuid);


--
-- Name: nt_devices nt_devices_device_hash_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_devices
    ADD CONSTRAINT nt_devices_device_hash_unique UNIQUE (device_hash);


--
-- Name: nt_devices nt_devices_device_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_devices
    ADD CONSTRAINT nt_devices_device_id_unique UNIQUE (device_id);


--
-- Name: nt_devices nt_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_devices
    ADD CONSTRAINT nt_devices_pkey PRIMARY KEY (id);


--
-- Name: nt_diagnoses nt_diagnoses_diagnosis_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_diagnoses
    ADD CONSTRAINT nt_diagnoses_diagnosis_id_unique UNIQUE (diagnosis_id);


--
-- Name: nt_diagnoses_drafts nt_diagnoses_drafts_diagnosis_draft_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_diagnoses_drafts
    ADD CONSTRAINT nt_diagnoses_drafts_diagnosis_draft_id_unique UNIQUE (diagnosis_draft_id);


--
-- Name: nt_diagnoses_drafts nt_diagnoses_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_diagnoses_drafts
    ADD CONSTRAINT nt_diagnoses_drafts_pkey PRIMARY KEY (id);


--
-- Name: nt_diagnoses_history nt_diagnoses_history_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_diagnoses_history
    ADD CONSTRAINT nt_diagnoses_history_pkey PRIMARY KEY (id);


--
-- Name: nt_diagnoses nt_diagnoses_old_diagnosis_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_diagnoses
    ADD CONSTRAINT nt_diagnoses_old_diagnosis_id_unique UNIQUE (old_diagnosis_id);


--
-- Name: nt_diagnoses nt_diagnoses_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_diagnoses
    ADD CONSTRAINT nt_diagnoses_pkey PRIMARY KEY (id);


--
-- Name: nt_drugs_library_drafts nt_drugs_library_drafts_item_draft_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_drugs_library_drafts
    ADD CONSTRAINT nt_drugs_library_drafts_item_draft_id_unique UNIQUE (item_draft_id);


--
-- Name: nt_drugs_library_drafts nt_drugs_library_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_drugs_library_drafts
    ADD CONSTRAINT nt_drugs_library_drafts_pkey PRIMARY KEY (id);


--
-- Name: nt_drugs_library_history nt_drugs_library_history_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_drugs_library_history
    ADD CONSTRAINT nt_drugs_library_history_pkey PRIMARY KEY (id);


--
-- Name: nt_drugs_library nt_drugs_library_item_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_drugs_library
    ADD CONSTRAINT nt_drugs_library_item_id_unique UNIQUE (item_id);


--
-- Name: nt_drugs_library nt_drugs_library_key_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_drugs_library
    ADD CONSTRAINT nt_drugs_library_key_unique UNIQUE (key);


--
-- Name: nt_drugs_library nt_drugs_library_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_drugs_library
    ADD CONSTRAINT nt_drugs_library_pkey PRIMARY KEY (id);


--
-- Name: nt_editor_info nt_editor_info_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_editor_info
    ADD CONSTRAINT nt_editor_info_pkey PRIMARY KEY (id);


--
-- Name: nt_email_templates nt_email_templates_name_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_email_templates
    ADD CONSTRAINT nt_email_templates_name_unique UNIQUE (name);


--
-- Name: nt_email_templates nt_email_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_email_templates
    ADD CONSTRAINT nt_email_templates_pkey PRIMARY KEY (id);


--
-- Name: nt_email_templates nt_email_templates_template_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_email_templates
    ADD CONSTRAINT nt_email_templates_template_id_unique UNIQUE (template_id);


--
-- Name: nt_files_chunks nt_files_chunks_chunk_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_files_chunks
    ADD CONSTRAINT nt_files_chunks_chunk_id_unique UNIQUE (chunk_id);


--
-- Name: nt_files_chunks nt_files_chunks_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_files_chunks
    ADD CONSTRAINT nt_files_chunks_pkey PRIMARY KEY (id);


--
-- Name: nt_files nt_files_file_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_files
    ADD CONSTRAINT nt_files_file_id_unique UNIQUE (file_id);


--
-- Name: nt_files nt_files_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_files
    ADD CONSTRAINT nt_files_pkey PRIMARY KEY (id);


--
-- Name: nt_hospitals_drafts nt_hospitals_drafts_hospital_draft_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_hospitals_drafts
    ADD CONSTRAINT nt_hospitals_drafts_hospital_draft_id_unique UNIQUE (hospital_draft_id);


--
-- Name: nt_hospitals_drafts nt_hospitals_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_hospitals_drafts
    ADD CONSTRAINT nt_hospitals_drafts_pkey PRIMARY KEY (id);


--
-- Name: nt_hospitals_history nt_hospitals_history_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_hospitals_history
    ADD CONSTRAINT nt_hospitals_history_pkey PRIMARY KEY (id);


--
-- Name: nt_hospitals nt_hospitals_hospital_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_hospitals
    ADD CONSTRAINT nt_hospitals_hospital_id_unique UNIQUE (hospital_id);


--
-- Name: nt_hospitals nt_hospitals_name_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_hospitals
    ADD CONSTRAINT nt_hospitals_name_unique UNIQUE (name);


--
-- Name: nt_hospitals nt_hospitals_old_hospital_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_hospitals
    ADD CONSTRAINT nt_hospitals_old_hospital_id_unique UNIQUE (old_hospital_id);


--
-- Name: nt_hospitals nt_hospitals_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_hospitals
    ADD CONSTRAINT nt_hospitals_pkey PRIMARY KEY (id);


--
-- Name: nt_languages nt_languages_iso_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_languages
    ADD CONSTRAINT nt_languages_iso_unique UNIQUE (iso);


--
-- Name: nt_languages nt_languages_name_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_languages
    ADD CONSTRAINT nt_languages_name_unique UNIQUE (name);


--
-- Name: nt_languages nt_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_languages
    ADD CONSTRAINT nt_languages_pkey PRIMARY KEY (id);


--
-- Name: nt_lock nt_lock_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_lock
    ADD CONSTRAINT nt_lock_pkey PRIMARY KEY (lock_id);


--
-- Name: nt_mailer_settings nt_mailer_settings_name_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_mailer_settings
    ADD CONSTRAINT nt_mailer_settings_name_unique UNIQUE (name);


--
-- Name: nt_mailer_settings nt_mailer_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_mailer_settings
    ADD CONSTRAINT nt_mailer_settings_pkey PRIMARY KEY (id);


--
-- Name: nt_mailer_settings nt_mailer_settings_setting_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_mailer_settings
    ADD CONSTRAINT nt_mailer_settings_setting_id_unique UNIQUE (setting_id);


--
-- Name: nt_pending_deletion nt_pending_deletion_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_pkey PRIMARY KEY (id);


--
-- Name: nt_screens_drafts nt_screens_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_screens_drafts
    ADD CONSTRAINT nt_screens_drafts_pkey PRIMARY KEY (id);


--
-- Name: nt_screens_drafts nt_screens_drafts_screen_draft_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_screens_drafts
    ADD CONSTRAINT nt_screens_drafts_screen_draft_id_unique UNIQUE (screen_draft_id);


--
-- Name: nt_screens_history nt_screens_history_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_screens_history
    ADD CONSTRAINT nt_screens_history_pkey PRIMARY KEY (id);


--
-- Name: nt_screens nt_screens_old_screen_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_screens
    ADD CONSTRAINT nt_screens_old_screen_id_unique UNIQUE (old_screen_id);


--
-- Name: nt_screens nt_screens_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_screens
    ADD CONSTRAINT nt_screens_pkey PRIMARY KEY (id);


--
-- Name: nt_screens nt_screens_screen_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_screens
    ADD CONSTRAINT nt_screens_screen_id_unique UNIQUE (screen_id);


--
-- Name: nt_scripts_drafts nt_scripts_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_scripts_drafts
    ADD CONSTRAINT nt_scripts_drafts_pkey PRIMARY KEY (id);


--
-- Name: nt_scripts_drafts nt_scripts_drafts_script_draft_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_scripts_drafts
    ADD CONSTRAINT nt_scripts_drafts_script_draft_id_unique UNIQUE (script_draft_id);


--
-- Name: nt_scripts_history nt_scripts_history_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_scripts_history
    ADD CONSTRAINT nt_scripts_history_pkey PRIMARY KEY (id);


--
-- Name: nt_scripts nt_scripts_old_script_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_scripts
    ADD CONSTRAINT nt_scripts_old_script_id_unique UNIQUE (old_script_id);


--
-- Name: nt_scripts nt_scripts_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_scripts
    ADD CONSTRAINT nt_scripts_pkey PRIMARY KEY (id);


--
-- Name: nt_scripts nt_scripts_script_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_scripts
    ADD CONSTRAINT nt_scripts_script_id_unique UNIQUE (script_id);


--
-- Name: nt_sites nt_sites_display_name_key; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_sites
    ADD CONSTRAINT nt_sites_display_name_key UNIQUE (display_name);


--
-- Name: nt_sites nt_sites_link_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_sites
    ADD CONSTRAINT nt_sites_link_unique UNIQUE (link);


--
-- Name: nt_sites nt_sites_name_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_sites
    ADD CONSTRAINT nt_sites_name_unique UNIQUE (name);


--
-- Name: nt_sites nt_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_sites
    ADD CONSTRAINT nt_sites_pkey PRIMARY KEY (id);


--
-- Name: nt_sites nt_sites_site_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_sites
    ADD CONSTRAINT nt_sites_site_id_unique UNIQUE (site_id);


--
-- Name: nt_sys nt_sys_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_sys
    ADD CONSTRAINT nt_sys_id_unique UNIQUE (id);


--
-- Name: nt_sys nt_sys_key_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_sys
    ADD CONSTRAINT nt_sys_key_unique UNIQUE (key);


--
-- Name: nt_sys nt_sys_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_sys
    ADD CONSTRAINT nt_sys_pkey PRIMARY KEY (_id);


--
-- Name: nt_user_roles nt_user_roles_name_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_user_roles
    ADD CONSTRAINT nt_user_roles_name_unique UNIQUE (name);


--
-- Name: nt_user_roles nt_user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_user_roles
    ADD CONSTRAINT nt_user_roles_pkey PRIMARY KEY (id);


--
-- Name: nt_users nt_users_email_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_users
    ADD CONSTRAINT nt_users_email_unique UNIQUE (email);


--
-- Name: nt_users nt_users_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_users
    ADD CONSTRAINT nt_users_pkey PRIMARY KEY (id);


--
-- Name: nt_users nt_users_user_id_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_users
    ADD CONSTRAINT nt_users_user_id_unique UNIQUE (user_id);


--
-- Name: permissions permissions_group_id_object_key; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_group_id_object_key UNIQUE (group_id, object);


--
-- Name: permissions_group_membership permissions_group_membership_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.permissions_group_membership
    ADD CONSTRAINT permissions_group_membership_pkey PRIMARY KEY (id);


--
-- Name: permissions_group permissions_group_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.permissions_group
    ADD CONSTRAINT permissions_group_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: permissions_revision permissions_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.permissions_revision
    ADD CONSTRAINT permissions_revision_pkey PRIMARY KEY (id);


--
-- Name: qrtz_blob_triggers pk_qrtz_blob_triggers; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.qrtz_blob_triggers
    ADD CONSTRAINT pk_qrtz_blob_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_calendars pk_qrtz_calendars; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.qrtz_calendars
    ADD CONSTRAINT pk_qrtz_calendars PRIMARY KEY (sched_name, calendar_name);


--
-- Name: qrtz_cron_triggers pk_qrtz_cron_triggers; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.qrtz_cron_triggers
    ADD CONSTRAINT pk_qrtz_cron_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_fired_triggers pk_qrtz_fired_triggers; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.qrtz_fired_triggers
    ADD CONSTRAINT pk_qrtz_fired_triggers PRIMARY KEY (sched_name, entry_id);


--
-- Name: qrtz_job_details pk_qrtz_job_details; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.qrtz_job_details
    ADD CONSTRAINT pk_qrtz_job_details PRIMARY KEY (sched_name, job_name, job_group);


--
-- Name: qrtz_locks pk_qrtz_locks; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.qrtz_locks
    ADD CONSTRAINT pk_qrtz_locks PRIMARY KEY (sched_name, lock_name);


--
-- Name: qrtz_scheduler_state pk_qrtz_scheduler_state; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.qrtz_scheduler_state
    ADD CONSTRAINT pk_qrtz_scheduler_state PRIMARY KEY (sched_name, instance_name);


--
-- Name: qrtz_simple_triggers pk_qrtz_simple_triggers; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.qrtz_simple_triggers
    ADD CONSTRAINT pk_qrtz_simple_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_simprop_triggers pk_qrtz_simprop_triggers; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.qrtz_simprop_triggers
    ADD CONSTRAINT pk_qrtz_simprop_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_triggers pk_qrtz_triggers; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.qrtz_triggers
    ADD CONSTRAINT pk_qrtz_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_paused_trigger_grps pk_sched_name; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.qrtz_paused_trigger_grps
    ADD CONSTRAINT pk_sched_name PRIMARY KEY (sched_name, trigger_group);


--
-- Name: pulse_card pulse_card_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.pulse_card
    ADD CONSTRAINT pulse_card_pkey PRIMARY KEY (id);


--
-- Name: pulse_channel pulse_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.pulse_channel
    ADD CONSTRAINT pulse_channel_pkey PRIMARY KEY (id);


--
-- Name: pulse_channel_recipient pulse_channel_recipient_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.pulse_channel_recipient
    ADD CONSTRAINT pulse_channel_recipient_pkey PRIMARY KEY (id);


--
-- Name: pulse pulse_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.pulse
    ADD CONSTRAINT pulse_pkey PRIMARY KEY (id);


--
-- Name: query_cache query_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.query_cache
    ADD CONSTRAINT query_cache_pkey PRIMARY KEY (query_hash);


--
-- Name: query_execution query_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.query_execution
    ADD CONSTRAINT query_execution_pkey PRIMARY KEY (id);


--
-- Name: query query_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.query
    ADD CONSTRAINT query_pkey PRIMARY KEY (query_hash);


--
-- Name: report_card report_card_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT report_card_pkey PRIMARY KEY (id);


--
-- Name: report_card report_card_public_uuid_key; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT report_card_public_uuid_key UNIQUE (public_uuid);


--
-- Name: report_cardfavorite report_cardfavorite_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_cardfavorite
    ADD CONSTRAINT report_cardfavorite_pkey PRIMARY KEY (id);


--
-- Name: report_dashboard report_dashboard_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT report_dashboard_pkey PRIMARY KEY (id);


--
-- Name: report_dashboard report_dashboard_public_uuid_key; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT report_dashboard_public_uuid_key UNIQUE (public_uuid);


--
-- Name: report_dashboardcard report_dashboardcard_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_dashboardcard
    ADD CONSTRAINT report_dashboardcard_pkey PRIMARY KEY (id);


--
-- Name: revision revision_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.revision
    ADD CONSTRAINT revision_pkey PRIMARY KEY (id);


--
-- Name: screens screens_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.screens
    ADD CONSTRAINT screens_pkey PRIMARY KEY (id);


--
-- Name: scripts scripts_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.scripts
    ADD CONSTRAINT scripts_pkey PRIMARY KEY (id);


--
-- Name: segment segment_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.segment
    ADD CONSTRAINT segment_pkey PRIMARY KEY (id);


--
-- Name: setting setting_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.setting
    ADD CONSTRAINT setting_pkey PRIMARY KEY (key);


--
-- Name: task_history task_history_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.task_history
    ADD CONSTRAINT task_history_pkey PRIMARY KEY (id);


--
-- Name: nt_tokens tokens_code_unique; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_tokens
    ADD CONSTRAINT tokens_code_unique UNIQUE (code);


--
-- Name: nt_tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);


--
-- Name: card_label unique_card_label_card_id_label_id; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.card_label
    ADD CONSTRAINT unique_card_label_card_id_label_id UNIQUE (card_id, label_id);


--
-- Name: collection unique_collection_personal_owner_id; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT unique_collection_personal_owner_id UNIQUE (personal_owner_id);


--
-- Name: dashboard_favorite unique_dashboard_favorite_user_id_dashboard_id; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.dashboard_favorite
    ADD CONSTRAINT unique_dashboard_favorite_user_id_dashboard_id UNIQUE (user_id, dashboard_id);


--
-- Name: dimension unique_dimension_field_id_name; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.dimension
    ADD CONSTRAINT unique_dimension_field_id_name UNIQUE (field_id, name);


--
-- Name: metric_important_field unique_metric_important_field_metric_id_field_id; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metric_important_field
    ADD CONSTRAINT unique_metric_important_field_metric_id_field_id UNIQUE (metric_id, field_id);


--
-- Name: permissions_group_membership unique_permissions_group_membership_user_id_group_id; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.permissions_group_membership
    ADD CONSTRAINT unique_permissions_group_membership_user_id_group_id UNIQUE (user_id, group_id);


--
-- Name: permissions_group unique_permissions_group_name; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.permissions_group
    ADD CONSTRAINT unique_permissions_group_name UNIQUE (name);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: view_log view_log_pkey; Type: CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.view_log
    ADD CONSTRAINT view_log_pkey PRIMARY KEY (id);


--
-- Name: active_version_index; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX active_version_index ON public.nt_change_logs USING btree (entity_id, is_active);


--
-- Name: change_logs_data_version_index; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX change_logs_data_version_index ON public.nt_change_logs USING btree (data_version);


--
-- Name: change_logs_date_index; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX change_logs_date_index ON public.nt_change_logs USING btree (date_of_change);


--
-- Name: change_logs_entity_index; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX change_logs_entity_index ON public.nt_change_logs USING btree (entity_type, entity_id);


--
-- Name: change_logs_user_index; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX change_logs_user_index ON public.nt_change_logs USING btree (user_id);


--
-- Name: config_keys_search_index; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX config_keys_search_index ON public.nt_config_keys USING gin ((((to_tsvector('english'::regconfig, key) || to_tsvector('english'::regconfig, label)) || to_tsvector('english'::regconfig, summary))));


--
-- Name: diagnoses_search_index; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX diagnoses_search_index ON public.nt_diagnoses USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: hospitals_search_index; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX hospitals_search_index ON public.nt_hospitals USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: idx_activity_custom_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_activity_custom_id ON public.activity USING btree (custom_id);


--
-- Name: idx_activity_timestamp; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_activity_timestamp ON public.activity USING btree ("timestamp");


--
-- Name: idx_activity_user_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_activity_user_id ON public.activity USING btree (user_id);


--
-- Name: idx_card_collection_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_card_collection_id ON public.report_card USING btree (collection_id);


--
-- Name: idx_card_creator_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_card_creator_id ON public.report_card USING btree (creator_id);


--
-- Name: idx_card_label_card_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_card_label_card_id ON public.card_label USING btree (card_id);


--
-- Name: idx_card_label_label_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_card_label_label_id ON public.card_label USING btree (label_id);


--
-- Name: idx_card_public_uuid; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_card_public_uuid ON public.report_card USING btree (public_uuid);


--
-- Name: idx_cardfavorite_card_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_cardfavorite_card_id ON public.report_cardfavorite USING btree (card_id);


--
-- Name: idx_cardfavorite_owner_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_cardfavorite_owner_id ON public.report_cardfavorite USING btree (owner_id);


--
-- Name: idx_collection_location; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_collection_location ON public.collection USING btree (location);


--
-- Name: idx_collection_personal_owner_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_collection_personal_owner_id ON public.collection USING btree (personal_owner_id);


--
-- Name: idx_dashboard_collection_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_dashboard_collection_id ON public.report_dashboard USING btree (collection_id);


--
-- Name: idx_dashboard_creator_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_dashboard_creator_id ON public.report_dashboard USING btree (creator_id);


--
-- Name: idx_dashboard_favorite_dashboard_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_dashboard_favorite_dashboard_id ON public.dashboard_favorite USING btree (dashboard_id);


--
-- Name: idx_dashboard_favorite_user_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_dashboard_favorite_user_id ON public.dashboard_favorite USING btree (user_id);


--
-- Name: idx_dashboard_public_uuid; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_dashboard_public_uuid ON public.report_dashboard USING btree (public_uuid);


--
-- Name: idx_dashboardcard_card_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_dashboardcard_card_id ON public.report_dashboardcard USING btree (card_id);


--
-- Name: idx_dashboardcard_dashboard_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_dashboardcard_dashboard_id ON public.report_dashboardcard USING btree (dashboard_id);


--
-- Name: idx_dashboardcard_series_card_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_dashboardcard_series_card_id ON public.dashboardcard_series USING btree (card_id);


--
-- Name: idx_dashboardcard_series_dashboardcard_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_dashboardcard_series_dashboardcard_id ON public.dashboardcard_series USING btree (dashboardcard_id);


--
-- Name: idx_data_migrations_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_data_migrations_id ON public.data_migrations USING btree (id);


--
-- Name: idx_dependency_dependent_on_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_dependency_dependent_on_id ON public.dependency USING btree (dependent_on_id);


--
-- Name: idx_dependency_dependent_on_model; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_dependency_dependent_on_model ON public.dependency USING btree (dependent_on_model);


--
-- Name: idx_dependency_model; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_dependency_model ON public.dependency USING btree (model);


--
-- Name: idx_dependency_model_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_dependency_model_id ON public.dependency USING btree (model_id);


--
-- Name: idx_dimension_field_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_dimension_field_id ON public.dimension USING btree (field_id);


--
-- Name: idx_field_parent_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_field_parent_id ON public.metabase_field USING btree (parent_id);


--
-- Name: idx_field_table_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_field_table_id ON public.metabase_field USING btree (table_id);


--
-- Name: idx_fieldvalues_field_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_fieldvalues_field_id ON public.metabase_fieldvalues USING btree (field_id);


--
-- Name: idx_label_slug; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_label_slug ON public.label USING btree (slug);


--
-- Name: idx_metabase_table_db_id_schema; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_metabase_table_db_id_schema ON public.metabase_table USING btree (db_id, schema);


--
-- Name: idx_metabase_table_show_in_getting_started; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_metabase_table_show_in_getting_started ON public.metabase_table USING btree (show_in_getting_started);


--
-- Name: idx_metric_creator_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_metric_creator_id ON public.metric USING btree (creator_id);


--
-- Name: idx_metric_important_field_field_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_metric_important_field_field_id ON public.metric_important_field USING btree (field_id);


--
-- Name: idx_metric_important_field_metric_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_metric_important_field_metric_id ON public.metric_important_field USING btree (metric_id);


--
-- Name: idx_metric_show_in_getting_started; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_metric_show_in_getting_started ON public.metric USING btree (show_in_getting_started);


--
-- Name: idx_metric_table_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_metric_table_id ON public.metric USING btree (table_id);


--
-- Name: idx_permissions_group_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_permissions_group_id ON public.permissions USING btree (group_id);


--
-- Name: idx_permissions_group_id_object; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_permissions_group_id_object ON public.permissions USING btree (group_id, object);


--
-- Name: idx_permissions_group_membership_group_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_permissions_group_membership_group_id ON public.permissions_group_membership USING btree (group_id);


--
-- Name: idx_permissions_group_membership_group_id_user_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_permissions_group_membership_group_id_user_id ON public.permissions_group_membership USING btree (group_id, user_id);


--
-- Name: idx_permissions_group_membership_user_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_permissions_group_membership_user_id ON public.permissions_group_membership USING btree (user_id);


--
-- Name: idx_permissions_group_name; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_permissions_group_name ON public.permissions_group USING btree (name);


--
-- Name: idx_permissions_object; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_permissions_object ON public.permissions USING btree (object);


--
-- Name: idx_pulse_card_card_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_pulse_card_card_id ON public.pulse_card USING btree (card_id);


--
-- Name: idx_pulse_card_pulse_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_pulse_card_pulse_id ON public.pulse_card USING btree (pulse_id);


--
-- Name: idx_pulse_channel_pulse_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_pulse_channel_pulse_id ON public.pulse_channel USING btree (pulse_id);


--
-- Name: idx_pulse_channel_schedule_type; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_pulse_channel_schedule_type ON public.pulse_channel USING btree (schedule_type);


--
-- Name: idx_pulse_collection_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_pulse_collection_id ON public.pulse USING btree (collection_id);


--
-- Name: idx_pulse_creator_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_pulse_creator_id ON public.pulse USING btree (creator_id);


--
-- Name: idx_qrtz_ft_inst_job_req_rcvry; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_ft_inst_job_req_rcvry ON public.qrtz_fired_triggers USING btree (sched_name, instance_name, requests_recovery);


--
-- Name: idx_qrtz_ft_j_g; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_ft_j_g ON public.qrtz_fired_triggers USING btree (sched_name, job_name, job_group);


--
-- Name: idx_qrtz_ft_jg; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_ft_jg ON public.qrtz_fired_triggers USING btree (sched_name, job_group);


--
-- Name: idx_qrtz_ft_t_g; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_ft_t_g ON public.qrtz_fired_triggers USING btree (sched_name, trigger_name, trigger_group);


--
-- Name: idx_qrtz_ft_tg; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_ft_tg ON public.qrtz_fired_triggers USING btree (sched_name, trigger_group);


--
-- Name: idx_qrtz_ft_trig_inst_name; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_ft_trig_inst_name ON public.qrtz_fired_triggers USING btree (sched_name, instance_name);


--
-- Name: idx_qrtz_j_grp; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_j_grp ON public.qrtz_job_details USING btree (sched_name, job_group);


--
-- Name: idx_qrtz_j_req_recovery; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_j_req_recovery ON public.qrtz_job_details USING btree (sched_name, requests_recovery);


--
-- Name: idx_qrtz_t_c; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_t_c ON public.qrtz_triggers USING btree (sched_name, calendar_name);


--
-- Name: idx_qrtz_t_g; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_t_g ON public.qrtz_triggers USING btree (sched_name, trigger_group);


--
-- Name: idx_qrtz_t_j; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_t_j ON public.qrtz_triggers USING btree (sched_name, job_name, job_group);


--
-- Name: idx_qrtz_t_jg; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_t_jg ON public.qrtz_triggers USING btree (sched_name, job_group);


--
-- Name: idx_qrtz_t_n_g_state; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_t_n_g_state ON public.qrtz_triggers USING btree (sched_name, trigger_group, trigger_state);


--
-- Name: idx_qrtz_t_n_state; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_t_n_state ON public.qrtz_triggers USING btree (sched_name, trigger_name, trigger_group, trigger_state);


--
-- Name: idx_qrtz_t_next_fire_time; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_t_next_fire_time ON public.qrtz_triggers USING btree (sched_name, next_fire_time);


--
-- Name: idx_qrtz_t_nft_misfire; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_t_nft_misfire ON public.qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time);


--
-- Name: idx_qrtz_t_nft_st; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_t_nft_st ON public.qrtz_triggers USING btree (sched_name, trigger_state, next_fire_time);


--
-- Name: idx_qrtz_t_nft_st_misfire; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_t_nft_st_misfire ON public.qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time, trigger_state);


--
-- Name: idx_qrtz_t_nft_st_misfire_grp; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_t_nft_st_misfire_grp ON public.qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time, trigger_group, trigger_state);


--
-- Name: idx_qrtz_t_state; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_qrtz_t_state ON public.qrtz_triggers USING btree (sched_name, trigger_state);


--
-- Name: idx_query_cache_updated_at; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_query_cache_updated_at ON public.query_cache USING btree (updated_at);


--
-- Name: idx_query_execution_query_hash_started_at; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_query_execution_query_hash_started_at ON public.query_execution USING btree (hash, started_at);


--
-- Name: idx_query_execution_started_at; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_query_execution_started_at ON public.query_execution USING btree (started_at);


--
-- Name: idx_report_dashboard_show_in_getting_started; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_report_dashboard_show_in_getting_started ON public.report_dashboard USING btree (show_in_getting_started);


--
-- Name: idx_revision_model_model_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_revision_model_model_id ON public.revision USING btree (model, model_id);


--
-- Name: idx_segment_creator_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_segment_creator_id ON public.segment USING btree (creator_id);


--
-- Name: idx_segment_show_in_getting_started; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_segment_show_in_getting_started ON public.segment USING btree (show_in_getting_started);


--
-- Name: idx_segment_table_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_segment_table_id ON public.segment USING btree (table_id);


--
-- Name: idx_table_db_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_table_db_id ON public.metabase_table USING btree (db_id);


--
-- Name: idx_task_history_db_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_task_history_db_id ON public.task_history USING btree (db_id);


--
-- Name: idx_task_history_end_time; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_task_history_end_time ON public.task_history USING btree (ended_at);


--
-- Name: idx_uniq_field_table_id_parent_id_name_2col; Type: INDEX; Schema: public; Owner: farai
--

CREATE UNIQUE INDEX idx_uniq_field_table_id_parent_id_name_2col ON public.metabase_field USING btree (table_id, name) WHERE (parent_id IS NULL);


--
-- Name: idx_uniq_table_db_id_schema_name_2col; Type: INDEX; Schema: public; Owner: farai
--

CREATE UNIQUE INDEX idx_uniq_table_db_id_schema_name_2col ON public.metabase_table USING btree (db_id, name) WHERE (schema IS NULL);


--
-- Name: idx_view_log_timestamp; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_view_log_timestamp ON public.view_log USING btree (model_id);


--
-- Name: idx_view_log_user_id; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX idx_view_log_user_id ON public.view_log USING btree (user_id);


--
-- Name: screens_search_index; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX screens_search_index ON public.nt_screens USING gin (to_tsvector('english'::regconfig, title));


--
-- Name: scripts_search_index; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX scripts_search_index ON public.nt_scripts USING gin (((to_tsvector('english'::regconfig, title) || to_tsvector('english'::regconfig, description))));


--
-- Name: unique_version_per_entity; Type: INDEX; Schema: public; Owner: farai
--

CREATE UNIQUE INDEX unique_version_per_entity ON public.nt_change_logs USING btree (entity_type, entity_id, version);


--
-- Name: users_search_index; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX users_search_index ON public.nt_users USING gin (((((to_tsvector('english'::regconfig, email) || to_tsvector('english'::regconfig, display_name)) || to_tsvector('english'::regconfig, first_name)) || to_tsvector('english'::regconfig, last_name))));


--
-- Name: version_chain_index; Type: INDEX; Schema: public; Owner: farai
--

CREATE INDEX version_chain_index ON public.nt_change_logs USING btree (entity_id, parent_version);


--
-- Name: activity fk_activity_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.activity
    ADD CONSTRAINT fk_activity_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id);


--
-- Name: report_card fk_card_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_card_collection_id FOREIGN KEY (collection_id) REFERENCES public.collection(id);


--
-- Name: card_label fk_card_label_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.card_label
    ADD CONSTRAINT fk_card_label_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id);


--
-- Name: card_label fk_card_label_ref_label_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.card_label
    ADD CONSTRAINT fk_card_label_ref_label_id FOREIGN KEY (label_id) REFERENCES public.label(id);


--
-- Name: report_card fk_card_made_public_by_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_card_made_public_by_id FOREIGN KEY (made_public_by_id) REFERENCES public.core_user(id);


--
-- Name: report_card fk_card_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_card_ref_user_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id);


--
-- Name: report_cardfavorite fk_cardfavorite_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_cardfavorite
    ADD CONSTRAINT fk_cardfavorite_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id);


--
-- Name: report_cardfavorite fk_cardfavorite_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_cardfavorite
    ADD CONSTRAINT fk_cardfavorite_ref_user_id FOREIGN KEY (owner_id) REFERENCES public.core_user(id);


--
-- Name: collection fk_collection_personal_owner_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT fk_collection_personal_owner_id FOREIGN KEY (personal_owner_id) REFERENCES public.core_user(id);


--
-- Name: collection_revision fk_collection_revision_user_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.collection_revision
    ADD CONSTRAINT fk_collection_revision_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id);


--
-- Name: computation_job fk_computation_job_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.computation_job
    ADD CONSTRAINT fk_computation_job_ref_user_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id);


--
-- Name: computation_job_result fk_computation_result_ref_job_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.computation_job_result
    ADD CONSTRAINT fk_computation_result_ref_job_id FOREIGN KEY (job_id) REFERENCES public.computation_job(id);


--
-- Name: report_dashboard fk_dashboard_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT fk_dashboard_collection_id FOREIGN KEY (collection_id) REFERENCES public.collection(id);


--
-- Name: dashboard_favorite fk_dashboard_favorite_dashboard_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.dashboard_favorite
    ADD CONSTRAINT fk_dashboard_favorite_dashboard_id FOREIGN KEY (dashboard_id) REFERENCES public.report_dashboard(id) ON DELETE CASCADE;


--
-- Name: dashboard_favorite fk_dashboard_favorite_user_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.dashboard_favorite
    ADD CONSTRAINT fk_dashboard_favorite_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: report_dashboard fk_dashboard_made_public_by_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT fk_dashboard_made_public_by_id FOREIGN KEY (made_public_by_id) REFERENCES public.core_user(id);


--
-- Name: report_dashboard fk_dashboard_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT fk_dashboard_ref_user_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id);


--
-- Name: report_dashboardcard fk_dashboardcard_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_dashboardcard
    ADD CONSTRAINT fk_dashboardcard_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id);


--
-- Name: report_dashboardcard fk_dashboardcard_ref_dashboard_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_dashboardcard
    ADD CONSTRAINT fk_dashboardcard_ref_dashboard_id FOREIGN KEY (dashboard_id) REFERENCES public.report_dashboard(id);


--
-- Name: dashboardcard_series fk_dashboardcard_series_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.dashboardcard_series
    ADD CONSTRAINT fk_dashboardcard_series_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id);


--
-- Name: dashboardcard_series fk_dashboardcard_series_ref_dashboardcard_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.dashboardcard_series
    ADD CONSTRAINT fk_dashboardcard_series_ref_dashboardcard_id FOREIGN KEY (dashboardcard_id) REFERENCES public.report_dashboardcard(id);


--
-- Name: dimension fk_dimension_displayfk_ref_field_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.dimension
    ADD CONSTRAINT fk_dimension_displayfk_ref_field_id FOREIGN KEY (human_readable_field_id) REFERENCES public.metabase_field(id) ON DELETE CASCADE;


--
-- Name: dimension fk_dimension_ref_field_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.dimension
    ADD CONSTRAINT fk_dimension_ref_field_id FOREIGN KEY (field_id) REFERENCES public.metabase_field(id) ON DELETE CASCADE;


--
-- Name: metabase_field fk_field_parent_ref_field_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metabase_field
    ADD CONSTRAINT fk_field_parent_ref_field_id FOREIGN KEY (parent_id) REFERENCES public.metabase_field(id);


--
-- Name: metabase_field fk_field_ref_table_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metabase_field
    ADD CONSTRAINT fk_field_ref_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id);


--
-- Name: metabase_fieldvalues fk_fieldvalues_ref_field_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metabase_fieldvalues
    ADD CONSTRAINT fk_fieldvalues_ref_field_id FOREIGN KEY (field_id) REFERENCES public.metabase_field(id);


--
-- Name: metric_important_field fk_metric_important_field_metabase_field_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metric_important_field
    ADD CONSTRAINT fk_metric_important_field_metabase_field_id FOREIGN KEY (field_id) REFERENCES public.metabase_field(id);


--
-- Name: metric_important_field fk_metric_important_field_metric_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metric_important_field
    ADD CONSTRAINT fk_metric_important_field_metric_id FOREIGN KEY (metric_id) REFERENCES public.metric(id);


--
-- Name: metric fk_metric_ref_creator_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metric
    ADD CONSTRAINT fk_metric_ref_creator_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id);


--
-- Name: metric fk_metric_ref_table_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metric
    ADD CONSTRAINT fk_metric_ref_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id);


--
-- Name: nt_lock fk_new_script_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_lock
    ADD CONSTRAINT fk_new_script_id FOREIGN KEY (new_script_id) REFERENCES public.nt_scripts_drafts(script_draft_id) ON DELETE CASCADE;


--
-- Name: permissions_group_membership fk_permissions_group_group_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.permissions_group_membership
    ADD CONSTRAINT fk_permissions_group_group_id FOREIGN KEY (group_id) REFERENCES public.permissions_group(id);


--
-- Name: permissions fk_permissions_group_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT fk_permissions_group_id FOREIGN KEY (group_id) REFERENCES public.permissions_group(id);


--
-- Name: permissions_group_membership fk_permissions_group_membership_user_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.permissions_group_membership
    ADD CONSTRAINT fk_permissions_group_membership_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id);


--
-- Name: permissions_revision fk_permissions_revision_user_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.permissions_revision
    ADD CONSTRAINT fk_permissions_revision_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id);


--
-- Name: pulse_card fk_pulse_card_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.pulse_card
    ADD CONSTRAINT fk_pulse_card_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id);


--
-- Name: pulse_card fk_pulse_card_ref_pulse_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.pulse_card
    ADD CONSTRAINT fk_pulse_card_ref_pulse_id FOREIGN KEY (pulse_id) REFERENCES public.pulse(id);


--
-- Name: pulse_channel_recipient fk_pulse_channel_recipient_ref_pulse_channel_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.pulse_channel_recipient
    ADD CONSTRAINT fk_pulse_channel_recipient_ref_pulse_channel_id FOREIGN KEY (pulse_channel_id) REFERENCES public.pulse_channel(id);


--
-- Name: pulse_channel_recipient fk_pulse_channel_recipient_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.pulse_channel_recipient
    ADD CONSTRAINT fk_pulse_channel_recipient_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id);


--
-- Name: pulse_channel fk_pulse_channel_ref_pulse_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.pulse_channel
    ADD CONSTRAINT fk_pulse_channel_ref_pulse_id FOREIGN KEY (pulse_id) REFERENCES public.pulse(id);


--
-- Name: pulse fk_pulse_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.pulse
    ADD CONSTRAINT fk_pulse_collection_id FOREIGN KEY (collection_id) REFERENCES public.collection(id);


--
-- Name: pulse fk_pulse_ref_creator_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.pulse
    ADD CONSTRAINT fk_pulse_ref_creator_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id);


--
-- Name: qrtz_blob_triggers fk_qrtz_blob_triggers_triggers; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.qrtz_blob_triggers
    ADD CONSTRAINT fk_qrtz_blob_triggers_triggers FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES public.qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_cron_triggers fk_qrtz_cron_triggers_triggers; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.qrtz_cron_triggers
    ADD CONSTRAINT fk_qrtz_cron_triggers_triggers FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES public.qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_simple_triggers fk_qrtz_simple_triggers_triggers; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.qrtz_simple_triggers
    ADD CONSTRAINT fk_qrtz_simple_triggers_triggers FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES public.qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_simprop_triggers fk_qrtz_simprop_triggers_triggers; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.qrtz_simprop_triggers
    ADD CONSTRAINT fk_qrtz_simprop_triggers_triggers FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES public.qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_triggers fk_qrtz_triggers_job_details; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.qrtz_triggers
    ADD CONSTRAINT fk_qrtz_triggers_job_details FOREIGN KEY (sched_name, job_name, job_group) REFERENCES public.qrtz_job_details(sched_name, job_name, job_group);


--
-- Name: report_card fk_report_card_ref_database_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_report_card_ref_database_id FOREIGN KEY (database_id) REFERENCES public.metabase_database(id);


--
-- Name: report_card fk_report_card_ref_table_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_report_card_ref_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id);


--
-- Name: revision fk_revision_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.revision
    ADD CONSTRAINT fk_revision_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id);


--
-- Name: nt_lock fk_script_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_lock
    ADD CONSTRAINT fk_script_id FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: segment fk_segment_ref_creator_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.segment
    ADD CONSTRAINT fk_segment_ref_creator_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id);


--
-- Name: segment fk_segment_ref_table_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.segment
    ADD CONSTRAINT fk_segment_ref_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id);


--
-- Name: core_session fk_session_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.core_session
    ADD CONSTRAINT fk_session_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id);


--
-- Name: metabase_table fk_table_ref_database_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.metabase_table
    ADD CONSTRAINT fk_table_ref_database_id FOREIGN KEY (db_id) REFERENCES public.metabase_database(id);


--
-- Name: nt_lock fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_lock
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.nt_users(user_id) ON DELETE CASCADE;


--
-- Name: view_log fk_view_log_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.view_log
    ADD CONSTRAINT fk_view_log_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id);


--
-- Name: nt_auth_clients nt_auth_clients_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_auth_clients
    ADD CONSTRAINT nt_auth_clients_user_id_nt_users_user_id_fk FOREIGN KEY (user_id) REFERENCES public.nt_users(user_id) ON DELETE CASCADE;


--
-- Name: nt_change_logs nt_change_logs_alias_id_nt_aliases_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_alias_id_nt_aliases_uuid_fk FOREIGN KEY (alias_id) REFERENCES public.nt_aliases(uuid) ON DELETE SET NULL;


--
-- Name: nt_change_logs nt_change_logs_config_key_id_nt_config_keys_config_key_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_config_key_id_nt_config_keys_config_key_id_fk FOREIGN KEY (config_key_id) REFERENCES public.nt_config_keys(config_key_id) ON DELETE SET NULL;


--
-- Name: nt_change_logs nt_change_logs_data_key_id_nt_data_keys_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_data_key_id_nt_data_keys_uuid_fk FOREIGN KEY (data_key_id) REFERENCES public.nt_data_keys(uuid) ON DELETE SET NULL;


--
-- Name: nt_change_logs nt_change_logs_diagnosis_id_nt_diagnoses_diagnosis_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_diagnosis_id_nt_diagnoses_diagnosis_id_fk FOREIGN KEY (diagnosis_id) REFERENCES public.nt_diagnoses(diagnosis_id) ON DELETE SET NULL;


--
-- Name: nt_change_logs nt_change_logs_drugs_library_item_id_nt_drugs_library_item_id_f; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_drugs_library_item_id_nt_drugs_library_item_id_f FOREIGN KEY (drugs_library_item_id) REFERENCES public.nt_drugs_library(item_id) ON DELETE SET NULL;


--
-- Name: nt_change_logs nt_change_logs_hospital_id_nt_hospitals_hospital_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_hospital_id_nt_hospitals_hospital_id_fk FOREIGN KEY (hospital_id) REFERENCES public.nt_hospitals(hospital_id) ON DELETE SET NULL;


--
-- Name: nt_change_logs nt_change_logs_screen_id_nt_screens_screen_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_screen_id_nt_screens_screen_id_fk FOREIGN KEY (screen_id) REFERENCES public.nt_screens(screen_id) ON DELETE SET NULL;


--
-- Name: nt_change_logs nt_change_logs_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE SET NULL;


--
-- Name: nt_change_logs nt_change_logs_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_user_id_nt_users_user_id_fk FOREIGN KEY (user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_config_keys_drafts nt_config_keys_drafts_config_key_id_nt_config_keys_config_key_i; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_config_keys_drafts
    ADD CONSTRAINT nt_config_keys_drafts_config_key_id_nt_config_keys_config_key_i FOREIGN KEY (config_key_id) REFERENCES public.nt_config_keys(config_key_id) ON DELETE CASCADE;


--
-- Name: nt_config_keys_drafts nt_config_keys_drafts_created_by_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_config_keys_drafts
    ADD CONSTRAINT nt_config_keys_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_config_keys_history nt_config_keys_history_config_key_id_nt_config_keys_config_key_; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_config_keys_history
    ADD CONSTRAINT nt_config_keys_history_config_key_id_nt_config_keys_config_key_ FOREIGN KEY (config_key_id) REFERENCES public.nt_config_keys(config_key_id) ON DELETE CASCADE;


--
-- Name: nt_data_keys_drafts nt_data_keys_drafts_created_by_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_data_keys_drafts
    ADD CONSTRAINT nt_data_keys_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_data_keys_drafts nt_data_keys_drafts_data_key_id_nt_data_keys_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_data_keys_drafts
    ADD CONSTRAINT nt_data_keys_drafts_data_key_id_nt_data_keys_uuid_fk FOREIGN KEY (data_key_id) REFERENCES public.nt_data_keys(uuid) ON DELETE CASCADE;


--
-- Name: nt_data_keys_history nt_data_keys_history_data_key_id_nt_data_keys_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_data_keys_history
    ADD CONSTRAINT nt_data_keys_history_data_key_id_nt_data_keys_uuid_fk FOREIGN KEY (data_key_id) REFERENCES public.nt_data_keys(uuid) ON DELETE CASCADE;


--
-- Name: nt_diagnoses_drafts nt_diagnoses_drafts_created_by_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_diagnoses_drafts
    ADD CONSTRAINT nt_diagnoses_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_diagnoses_drafts nt_diagnoses_drafts_diagnosis_id_nt_diagnoses_diagnosis_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_diagnoses_drafts
    ADD CONSTRAINT nt_diagnoses_drafts_diagnosis_id_nt_diagnoses_diagnosis_id_fk FOREIGN KEY (diagnosis_id) REFERENCES public.nt_diagnoses(diagnosis_id) ON DELETE CASCADE;


--
-- Name: nt_diagnoses_drafts nt_diagnoses_drafts_script_draft_id_nt_scripts_drafts_script_dr; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_diagnoses_drafts
    ADD CONSTRAINT nt_diagnoses_drafts_script_draft_id_nt_scripts_drafts_script_dr FOREIGN KEY (script_draft_id) REFERENCES public.nt_scripts_drafts(script_draft_id) ON DELETE CASCADE;


--
-- Name: nt_diagnoses_drafts nt_diagnoses_drafts_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_diagnoses_drafts
    ADD CONSTRAINT nt_diagnoses_drafts_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_diagnoses_history nt_diagnoses_history_diagnosis_id_nt_diagnoses_diagnosis_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_diagnoses_history
    ADD CONSTRAINT nt_diagnoses_history_diagnosis_id_nt_diagnoses_diagnosis_id_fk FOREIGN KEY (diagnosis_id) REFERENCES public.nt_diagnoses(diagnosis_id) ON DELETE CASCADE;


--
-- Name: nt_diagnoses_history nt_diagnoses_history_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_diagnoses_history
    ADD CONSTRAINT nt_diagnoses_history_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_diagnoses nt_diagnoses_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_diagnoses
    ADD CONSTRAINT nt_diagnoses_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_drugs_library_drafts nt_drugs_library_drafts_created_by_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_drugs_library_drafts
    ADD CONSTRAINT nt_drugs_library_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_drugs_library_drafts nt_drugs_library_drafts_item_id_nt_drugs_library_item_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_drugs_library_drafts
    ADD CONSTRAINT nt_drugs_library_drafts_item_id_nt_drugs_library_item_id_fk FOREIGN KEY (item_id) REFERENCES public.nt_drugs_library(item_id) ON DELETE CASCADE;


--
-- Name: nt_drugs_library_history nt_drugs_library_history_item_id_nt_drugs_library_item_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_drugs_library_history
    ADD CONSTRAINT nt_drugs_library_history_item_id_nt_drugs_library_item_id_fk FOREIGN KEY (item_id) REFERENCES public.nt_drugs_library(item_id) ON DELETE CASCADE;


--
-- Name: nt_files_chunks nt_files_chunks_file_id_nt_files_file_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_files_chunks
    ADD CONSTRAINT nt_files_chunks_file_id_nt_files_file_id_fk FOREIGN KEY (file_id) REFERENCES public.nt_files(file_id) ON DELETE CASCADE;


--
-- Name: nt_files nt_files_owner_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_files
    ADD CONSTRAINT nt_files_owner_id_nt_users_user_id_fk FOREIGN KEY (owner_id) REFERENCES public.nt_users(user_id) ON DELETE CASCADE;


--
-- Name: nt_hospitals_drafts nt_hospitals_drafts_created_by_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_hospitals_drafts
    ADD CONSTRAINT nt_hospitals_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_hospitals_drafts nt_hospitals_drafts_hospital_id_nt_hospitals_hospital_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_hospitals_drafts
    ADD CONSTRAINT nt_hospitals_drafts_hospital_id_nt_hospitals_hospital_id_fk FOREIGN KEY (hospital_id) REFERENCES public.nt_hospitals(hospital_id) ON DELETE CASCADE;


--
-- Name: nt_hospitals_history nt_hospitals_history_hospital_id_nt_hospitals_hospital_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_hospitals_history
    ADD CONSTRAINT nt_hospitals_history_hospital_id_nt_hospitals_hospital_id_fk FOREIGN KEY (hospital_id) REFERENCES public.nt_hospitals(hospital_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_config_key_draft_id_nt_config_keys_drafts_c; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_config_key_draft_id_nt_config_keys_drafts_c FOREIGN KEY (config_key_draft_id) REFERENCES public.nt_config_keys_drafts(config_key_draft_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_config_key_id_nt_config_keys_config_key_id_; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_config_key_id_nt_config_keys_config_key_id_ FOREIGN KEY (config_key_id) REFERENCES public.nt_config_keys(config_key_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_created_by_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_pending_deletion nt_pending_deletion_diagnosis_draft_id_nt_diagnoses_drafts_diag; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_diagnosis_draft_id_nt_diagnoses_drafts_diag FOREIGN KEY (diagnosis_draft_id) REFERENCES public.nt_diagnoses_drafts(diagnosis_draft_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_diagnosis_id_nt_diagnoses_diagnosis_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_diagnosis_id_nt_diagnoses_diagnosis_id_fk FOREIGN KEY (diagnosis_id) REFERENCES public.nt_diagnoses(diagnosis_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_diagnosis_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_diagnosis_script_id_nt_scripts_script_id_fk FOREIGN KEY (diagnosis_script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_drugs_library_item_draft_id_nt_drugs_librar; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_drugs_library_item_draft_id_nt_drugs_librar FOREIGN KEY (drugs_library_item_draft_id) REFERENCES public.nt_drugs_library_drafts(item_draft_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_drugs_library_item_id_nt_drugs_library_item; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_drugs_library_item_id_nt_drugs_library_item FOREIGN KEY (drugs_library_item_id) REFERENCES public.nt_drugs_library(item_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_hospital_draft_id_nt_hospitals_drafts_hospi; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_hospital_draft_id_nt_hospitals_drafts_hospi FOREIGN KEY (hospital_draft_id) REFERENCES public.nt_hospitals_drafts(hospital_draft_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_hospital_id_nt_hospitals_hospital_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_hospital_id_nt_hospitals_hospital_id_fk FOREIGN KEY (hospital_id) REFERENCES public.nt_hospitals(hospital_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_screen_draft_id_nt_screens_drafts_screen_dr; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_screen_draft_id_nt_screens_drafts_screen_dr FOREIGN KEY (screen_draft_id) REFERENCES public.nt_screens_drafts(screen_draft_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_screen_id_nt_screens_screen_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_screen_id_nt_screens_screen_id_fk FOREIGN KEY (screen_id) REFERENCES public.nt_screens(screen_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_screen_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_screen_script_id_nt_scripts_script_id_fk FOREIGN KEY (screen_script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_script_draft_id_nt_scripts_drafts_script_dr; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_script_draft_id_nt_scripts_drafts_script_dr FOREIGN KEY (script_draft_id) REFERENCES public.nt_scripts_drafts(script_draft_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_screens_drafts nt_screens_drafts_created_by_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_screens_drafts
    ADD CONSTRAINT nt_screens_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_screens_drafts nt_screens_drafts_screen_id_nt_screens_screen_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_screens_drafts
    ADD CONSTRAINT nt_screens_drafts_screen_id_nt_screens_screen_id_fk FOREIGN KEY (screen_id) REFERENCES public.nt_screens(screen_id) ON DELETE CASCADE;


--
-- Name: nt_screens_drafts nt_screens_drafts_script_draft_id_nt_scripts_drafts_script_draf; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_screens_drafts
    ADD CONSTRAINT nt_screens_drafts_script_draft_id_nt_scripts_drafts_script_draf FOREIGN KEY (script_draft_id) REFERENCES public.nt_scripts_drafts(script_draft_id) ON DELETE CASCADE;


--
-- Name: nt_screens_drafts nt_screens_drafts_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_screens_drafts
    ADD CONSTRAINT nt_screens_drafts_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_screens_history nt_screens_history_screen_id_nt_screens_screen_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_screens_history
    ADD CONSTRAINT nt_screens_history_screen_id_nt_screens_screen_id_fk FOREIGN KEY (screen_id) REFERENCES public.nt_screens(screen_id) ON DELETE CASCADE;


--
-- Name: nt_screens_history nt_screens_history_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_screens_history
    ADD CONSTRAINT nt_screens_history_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_screens nt_screens_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_screens
    ADD CONSTRAINT nt_screens_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_scripts_drafts nt_scripts_drafts_created_by_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_scripts_drafts
    ADD CONSTRAINT nt_scripts_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_scripts_drafts nt_scripts_drafts_hospital_id_nt_hospitals_hospital_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_scripts_drafts
    ADD CONSTRAINT nt_scripts_drafts_hospital_id_nt_hospitals_hospital_id_fk FOREIGN KEY (hospital_id) REFERENCES public.nt_hospitals(hospital_id) ON DELETE SET NULL;


--
-- Name: nt_scripts_drafts nt_scripts_drafts_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_scripts_drafts
    ADD CONSTRAINT nt_scripts_drafts_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_scripts_history nt_scripts_history_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_scripts_history
    ADD CONSTRAINT nt_scripts_history_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_scripts nt_scripts_hospital_id_nt_hospitals_hospital_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_scripts
    ADD CONSTRAINT nt_scripts_hospital_id_nt_hospitals_hospital_id_fk FOREIGN KEY (hospital_id) REFERENCES public.nt_hospitals(hospital_id) ON DELETE SET NULL;


--
-- Name: nt_users nt_users_role_nt_user_roles_name_fk; Type: FK CONSTRAINT; Schema: public; Owner: farai
--

ALTER TABLE ONLY public.nt_users
    ADD CONSTRAINT nt_users_role_nt_user_roles_name_fk FOREIGN KEY (role) REFERENCES public.nt_user_roles(name) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict SRzOzfI5tmAQdI70A048c66glbQQMeXqCL4DiVbX7rIQrGUY1hGA7lDTCJK8D6s

