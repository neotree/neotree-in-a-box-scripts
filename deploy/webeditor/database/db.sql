--
-- PostgreSQL database dump
--

\restrict ElIF706539kg8ikAQPYB70DHYYRhfRZuXe9VkN9RGcQGl7pEHJ9QhfHMzqhTfpr

-- Dumped from database version 10.23 (Ubuntu 10.23-0ubuntu0.18.04.2)
-- Dumped by pg_dump version 16.14 (Ubuntu 16.14-0ubuntu0.24.04.1)

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

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
-- Name: change_log_action; Type: TYPE; Schema: public; Owner: neotree_webeditor_dev
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


ALTER TYPE public.change_log_action OWNER TO neotree_webeditor_dev;

--
-- Name: change_log_entity; Type: TYPE; Schema: public; Owner: neotree_webeditor_dev
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
    'release',
    'problem'
);


ALTER TYPE public.change_log_entity OWNER TO neotree_webeditor_dev;

--
-- Name: dff_item_validation_type; Type: TYPE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TYPE public.dff_item_validation_type AS ENUM (
    'default',
    'condition'
);


ALTER TYPE public.dff_item_validation_type OWNER TO neotree_webeditor_dev;

--
-- Name: draft_origin; Type: TYPE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TYPE public.draft_origin AS ENUM (
    'data_key_sync',
    'editor',
    'import',
    'other'
);


ALTER TYPE public.draft_origin OWNER TO neotree_webeditor_dev;

--
-- Name: drug_type; Type: TYPE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TYPE public.drug_type AS ENUM (
    'drug',
    'fluid',
    'feed'
);


ALTER TYPE public.drug_type OWNER TO neotree_webeditor_dev;

--
-- Name: integrity_import_snapshot_status; Type: TYPE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TYPE public.integrity_import_snapshot_status AS ENUM (
    'pending_review',
    'accepted',
    'rejected'
);


ALTER TYPE public.integrity_import_snapshot_status OWNER TO neotree_webeditor_dev;

--
-- Name: list_style; Type: TYPE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TYPE public.list_style AS ENUM (
    'none',
    'number',
    'bullet'
);


ALTER TYPE public.list_style OWNER TO neotree_webeditor_dev;

--
-- Name: mailer_service; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.mailer_service AS ENUM (
    'gmail',
    'smtp'
);


ALTER TYPE public.mailer_service OWNER TO postgres;

--
-- Name: role_name; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.role_name AS ENUM (
    'user',
    'admin',
    'super_user'
);


ALTER TYPE public.role_name OWNER TO postgres;

--
-- Name: screen_type; Type: TYPE; Schema: public; Owner: postgres
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


ALTER TYPE public.screen_type OWNER TO postgres;

--
-- Name: script_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.script_type AS ENUM (
    'admission',
    'discharge',
    'neolab',
    'drecord',
    'dff_calculator'
);


ALTER TYPE public.script_type OWNER TO postgres;

--
-- Name: site_env; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.site_env AS ENUM (
    'production',
    'stage',
    'development',
    'demo'
);


ALTER TYPE public.site_env OWNER TO postgres;

--
-- Name: site_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.site_type AS ENUM (
    'nodeapi',
    'webeditor'
);


ALTER TYPE public.site_type OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: Session; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public."Session" (
    sid character varying(36) NOT NULL,
    expires timestamp with time zone,
    data text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Session" OWNER TO neotree_webeditor_dev;

--
-- Name: Sessions; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public."Sessions" (
    sid character varying(36) NOT NULL,
    expires timestamp with time zone,
    data text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Sessions" OWNER TO neotree_webeditor_dev;

--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.api_keys (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public.api_keys OWNER TO neotree_webeditor_dev;

--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.api_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.api_keys_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.api_keys_id_seq OWNED BY public.api_keys.id;


--
-- Name: apps; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.apps (
    id integer NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    last_backup_date timestamp with time zone,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    should_track_usage boolean DEFAULT false
);


ALTER TABLE public.apps OWNER TO neotree_webeditor_dev;

--
-- Name: apps_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.apps_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.apps_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: apps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.apps_id_seq OWNED BY public.apps.id;


--
-- Name: config_keys; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.config_keys (
    id integer NOT NULL,
    config_key_id character varying(255) NOT NULL,
    "position" integer,
    data json DEFAULT '"{}"'::json,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public.config_keys OWNER TO neotree_webeditor_dev;

--
-- Name: config_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.config_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.config_keys_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: config_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.config_keys_id_seq OWNED BY public.config_keys.id;


--
-- Name: configurations; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.configurations (
    id integer NOT NULL,
    unique_key character varying(255) NOT NULL,
    data json DEFAULT '"{}"'::json,
    "deletedAt" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.configurations OWNER TO neotree_webeditor_dev;

--
-- Name: configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.configurations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.configurations_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.configurations_id_seq OWNED BY public.configurations.id;


--
-- Name: devices; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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


ALTER TABLE public.devices OWNER TO neotree_webeditor_dev;

--
-- Name: devices_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.devices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.devices_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.devices_id_seq OWNED BY public.devices.id;


--
-- Name: diagnoses; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.diagnoses (
    id integer NOT NULL,
    diagnosis_id character varying(255) NOT NULL,
    data json DEFAULT '"{}"'::json,
    "position" integer,
    script_id character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public.diagnoses OWNER TO neotree_webeditor_dev;

--
-- Name: diagnoses_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.diagnoses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.diagnoses_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: diagnoses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.diagnoses_id_seq OWNED BY public.diagnoses.id;


--
-- Name: files; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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


ALTER TABLE public.files OWNER TO neotree_webeditor_dev;

--
-- Name: hospitals; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.hospitals (
    id integer NOT NULL,
    hospital_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    country character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public.hospitals OWNER TO neotree_webeditor_dev;

--
-- Name: hospitals_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.hospitals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hospitals_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: hospitals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.hospitals_id_seq OWNED BY public.hospitals.id;


--
-- Name: logs; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.logs (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    data json DEFAULT '"{}"'::json,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public.logs OWNER TO neotree_webeditor_dev;

--
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logs_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.logs_id_seq OWNED BY public.logs.id;


--
-- Name: nt_admin_audit_logs; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_admin_audit_logs (
    id integer NOT NULL,
    audit_log_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    area text NOT NULL,
    action text NOT NULL,
    actor_user_id uuid,
    before_state jsonb DEFAULT '{}'::jsonb NOT NULL,
    after_state jsonb DEFAULT '{}'::jsonb NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_admin_audit_logs OWNER TO neotree_webeditor_dev;

--
-- Name: nt_admin_audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_admin_audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_admin_audit_logs_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_admin_audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_admin_audit_logs_id_seq OWNED BY public.nt_admin_audit_logs.id;


--
-- Name: nt_aliases; Type: TABLE; Schema: public; Owner: morris
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


ALTER TABLE public.nt_aliases OWNER TO morris;

--
-- Name: nt_aliases_id_seq; Type: SEQUENCE; Schema: public; Owner: morris
--

CREATE SEQUENCE public.nt_aliases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_aliases_id_seq OWNER TO morris;

--
-- Name: nt_aliases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: morris
--

ALTER SEQUENCE public.nt_aliases_id_seq OWNED BY public.nt_aliases.id;


--
-- Name: nt_api_keys; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_api_keys (
    id integer NOT NULL,
    api_key_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    api_key text NOT NULL,
    valid_until timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_api_keys OWNER TO neotree_webeditor_dev;

--
-- Name: nt_api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_api_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_api_keys_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_api_keys_id_seq OWNED BY public.nt_api_keys.id;


--
-- Name: nt_auth_clients; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_auth_clients (
    id integer NOT NULL,
    client_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    client_token text NOT NULL,
    user_id uuid,
    valid_until timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_auth_clients OWNER TO neotree_webeditor_dev;

--
-- Name: nt_auth_clients_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_auth_clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_auth_clients_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_auth_clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_auth_clients_id_seq OWNED BY public.nt_auth_clients.id;


--
-- Name: nt_change_logs; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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
    previous_snapshot jsonb DEFAULT '{}'::jsonb NOT NULL,
    problem_id uuid
);


ALTER TABLE public.nt_change_logs OWNER TO neotree_webeditor_dev;

--
-- Name: nt_change_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_change_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_change_logs_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_change_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_change_logs_id_seq OWNED BY public.nt_change_logs.id;


--
-- Name: nt_config_keys; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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


ALTER TABLE public.nt_config_keys OWNER TO neotree_webeditor_dev;

--
-- Name: nt_config_keys_drafts; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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


ALTER TABLE public.nt_config_keys_drafts OWNER TO neotree_webeditor_dev;

--
-- Name: nt_config_keys_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_config_keys_drafts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_config_keys_drafts_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_config_keys_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_config_keys_drafts_id_seq OWNED BY public.nt_config_keys_drafts.id;


--
-- Name: nt_config_keys_history; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_config_keys_history (
    id integer NOT NULL,
    version integer NOT NULL,
    config_key_id uuid NOT NULL,
    restore_key uuid,
    data jsonb DEFAULT '[]'::jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_config_keys_history OWNER TO neotree_webeditor_dev;

--
-- Name: nt_config_keys_history_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_config_keys_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_config_keys_history_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_config_keys_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_config_keys_history_id_seq OWNED BY public.nt_config_keys_history.id;


--
-- Name: nt_config_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_config_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_config_keys_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_config_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_config_keys_id_seq OWNED BY public.nt_config_keys.id;


--
-- Name: nt_data_keys; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_data_keys (
    id integer NOT NULL,
    uuid uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    unique_key text DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
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
    deleted_at timestamp without time zone,
    confidential boolean DEFAULT true NOT NULL
);


ALTER TABLE public.nt_data_keys OWNER TO neotree_webeditor_dev;

--
-- Name: nt_data_keys_drafts; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_data_keys_drafts (
    id integer NOT NULL,
    uuid uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    name text NOT NULL,
    unique_key text NOT NULL,
    data_key_id uuid,
    data jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by_user_id uuid,
    draft_origin text DEFAULT 'editor'::text NOT NULL
);


ALTER TABLE public.nt_data_keys_drafts OWNER TO neotree_webeditor_dev;

--
-- Name: nt_data_keys_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_data_keys_drafts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_data_keys_drafts_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_data_keys_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_data_keys_drafts_id_seq OWNED BY public.nt_data_keys_drafts.id;


--
-- Name: nt_data_keys_history; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_data_keys_history (
    id integer NOT NULL,
    version integer NOT NULL,
    data_key_id uuid NOT NULL,
    restore_key uuid,
    data jsonb DEFAULT '[]'::jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_data_keys_history OWNER TO neotree_webeditor_dev;

--
-- Name: nt_data_keys_history_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_data_keys_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_data_keys_history_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_data_keys_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_data_keys_history_id_seq OWNED BY public.nt_data_keys_history.id;


--
-- Name: nt_data_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_data_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_data_keys_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_data_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_data_keys_id_seq OWNED BY public.nt_data_keys.id;


--
-- Name: nt_devices; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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


ALTER TABLE public.nt_devices OWNER TO neotree_webeditor_dev;

--
-- Name: nt_devices_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_devices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_devices_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_devices_id_seq OWNED BY public.nt_devices.id;


--
-- Name: nt_diagnoses; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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


ALTER TABLE public.nt_diagnoses OWNER TO neotree_webeditor_dev;

--
-- Name: nt_diagnoses_drafts; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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
    created_by_user_id uuid,
    draft_origin public.draft_origin DEFAULT 'editor'::public.draft_origin NOT NULL
);


ALTER TABLE public.nt_diagnoses_drafts OWNER TO neotree_webeditor_dev;

--
-- Name: nt_diagnoses_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_diagnoses_drafts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_diagnoses_drafts_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_diagnoses_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_diagnoses_drafts_id_seq OWNED BY public.nt_diagnoses_drafts.id;


--
-- Name: nt_diagnoses_history; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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


ALTER TABLE public.nt_diagnoses_history OWNER TO neotree_webeditor_dev;

--
-- Name: nt_diagnoses_history_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_diagnoses_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_diagnoses_history_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_diagnoses_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_diagnoses_history_id_seq OWNED BY public.nt_diagnoses_history.id;


--
-- Name: nt_diagnoses_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_diagnoses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_diagnoses_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_diagnoses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_diagnoses_id_seq OWNED BY public.nt_diagnoses.id;


--
-- Name: nt_drugs_library; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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


ALTER TABLE public.nt_drugs_library OWNER TO neotree_webeditor_dev;

--
-- Name: nt_drugs_library_drafts; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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


ALTER TABLE public.nt_drugs_library_drafts OWNER TO neotree_webeditor_dev;

--
-- Name: nt_drugs_library_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_drugs_library_drafts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_drugs_library_drafts_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_drugs_library_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_drugs_library_drafts_id_seq OWNED BY public.nt_drugs_library_drafts.id;


--
-- Name: nt_drugs_library_history; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_drugs_library_history (
    id integer NOT NULL,
    version integer NOT NULL,
    item_id uuid NOT NULL,
    restore_key uuid,
    data jsonb DEFAULT '[]'::jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_drugs_library_history OWNER TO neotree_webeditor_dev;

--
-- Name: nt_drugs_library_history_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_drugs_library_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_drugs_library_history_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_drugs_library_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_drugs_library_history_id_seq OWNED BY public.nt_drugs_library_history.id;


--
-- Name: nt_drugs_library_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_drugs_library_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_drugs_library_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_drugs_library_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_drugs_library_id_seq OWNED BY public.nt_drugs_library.id;


--
-- Name: nt_editor_info; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_editor_info (
    id integer NOT NULL,
    data_version integer DEFAULT 1 NOT NULL,
    last_publish_date timestamp without time zone,
    last_data_keys_sync_date timestamp without time zone,
    integrity_policy jsonb DEFAULT '{"scanScope": "affected_scripts_only", "useBaseline": true, "triggerSources": {"imports": false, "deletions": false, "scriptEdits": false, "dataKeyLibraryEdits": false}, "enforcementMode": "off"}'::jsonb NOT NULL,
    integrity_baseline jsonb DEFAULT '{"capturedAt": null, "fingerprints": [], "totalScripts": 0, "ruleSetVersion": "2026-04-26", "capturedByUserId": null, "fingerprintVersion": 2, "totalBlockingIssues": 0, "acceptedImportFingerprints": [], "acceptedImportFingerprintRefs": {}}'::jsonb NOT NULL
);


ALTER TABLE public.nt_editor_info OWNER TO neotree_webeditor_dev;

--
-- Name: nt_editor_info_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_editor_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_editor_info_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_editor_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_editor_info_id_seq OWNED BY public.nt_editor_info.id;


--
-- Name: nt_email_templates; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_email_templates (
    id integer NOT NULL,
    template_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    name text NOT NULL,
    data jsonb NOT NULL
);


ALTER TABLE public.nt_email_templates OWNER TO neotree_webeditor_dev;

--
-- Name: nt_email_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_email_templates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_email_templates_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_email_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_email_templates_id_seq OWNED BY public.nt_email_templates.id;


--
-- Name: nt_files; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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


ALTER TABLE public.nt_files OWNER TO neotree_webeditor_dev;

--
-- Name: nt_files_aliases; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_files_aliases (
    id integer NOT NULL,
    file_id uuid,
    alias text NOT NULL
);


ALTER TABLE public.nt_files_aliases OWNER TO neotree_webeditor_dev;

--
-- Name: nt_files_aliases_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_files_aliases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_files_aliases_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_files_aliases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_files_aliases_id_seq OWNED BY public.nt_files_aliases.id;


--
-- Name: nt_files_chunks; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_files_chunks (
    id integer NOT NULL,
    chunk_id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    file_id uuid NOT NULL,
    data bytea NOT NULL
);


ALTER TABLE public.nt_files_chunks OWNER TO neotree_webeditor_dev;

--
-- Name: nt_files_chunks_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_files_chunks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_files_chunks_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_files_chunks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_files_chunks_id_seq OWNED BY public.nt_files_chunks.id;


--
-- Name: nt_files_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_files_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_files_id_seq OWNED BY public.nt_files.id;


--
-- Name: nt_hospitals; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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


ALTER TABLE public.nt_hospitals OWNER TO neotree_webeditor_dev;

--
-- Name: nt_hospitals_drafts; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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


ALTER TABLE public.nt_hospitals_drafts OWNER TO neotree_webeditor_dev;

--
-- Name: nt_hospitals_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_hospitals_drafts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_hospitals_drafts_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_hospitals_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_hospitals_drafts_id_seq OWNED BY public.nt_hospitals_drafts.id;


--
-- Name: nt_hospitals_history; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_hospitals_history (
    id integer NOT NULL,
    version integer NOT NULL,
    hospital_id uuid NOT NULL,
    restore_key uuid,
    data jsonb DEFAULT '[]'::jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_hospitals_history OWNER TO neotree_webeditor_dev;

--
-- Name: nt_hospitals_history_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_hospitals_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_hospitals_history_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_hospitals_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_hospitals_history_id_seq OWNED BY public.nt_hospitals_history.id;


--
-- Name: nt_hospitals_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_hospitals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_hospitals_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_hospitals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_hospitals_id_seq OWNED BY public.nt_hospitals.id;


--
-- Name: nt_integrity_import_snapshots; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_integrity_import_snapshots (
    id integer NOT NULL,
    snapshot_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    status public.integrity_import_snapshot_status DEFAULT 'pending_review'::public.integrity_import_snapshot_status NOT NULL,
    source_type text NOT NULL,
    source_label text,
    imported_script_ids jsonb DEFAULT '[]'::jsonb NOT NULL,
    imported_data_key_ids jsonb DEFAULT '[]'::jsonb NOT NULL,
    fingerprint_version integer NOT NULL,
    rule_set_version text NOT NULL,
    total_blocking_issues integer DEFAULT 0 NOT NULL,
    total_scripts integer DEFAULT 0 NOT NULL,
    fingerprints jsonb DEFAULT '[]'::jsonb NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_by_user_id uuid,
    accepted_by_user_id uuid,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    accepted_at timestamp without time zone
);


ALTER TABLE public.nt_integrity_import_snapshots OWNER TO neotree_webeditor_dev;

--
-- Name: nt_integrity_import_snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_integrity_import_snapshots_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_integrity_import_snapshots_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_integrity_import_snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_integrity_import_snapshots_id_seq OWNED BY public.nt_integrity_import_snapshots.id;


--
-- Name: nt_languages; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_languages (
    id integer NOT NULL,
    name text NOT NULL,
    iso text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.nt_languages OWNER TO neotree_webeditor_dev;

--
-- Name: nt_languages_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_languages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_languages_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_languages_id_seq OWNED BY public.nt_languages.id;


--
-- Name: nt_lock; Type: TABLE; Schema: public; Owner: morris
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


ALTER TABLE public.nt_lock OWNER TO morris;

--
-- Name: nt_mailer_settings; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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


ALTER TABLE public.nt_mailer_settings OWNER TO neotree_webeditor_dev;

--
-- Name: nt_mailer_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_mailer_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_mailer_settings_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_mailer_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_mailer_settings_id_seq OWNED BY public.nt_mailer_settings.id;


--
-- Name: nt_pending_deletion; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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
    hospital_draft_id uuid,
    problem_id uuid,
    problem_script_id uuid,
    problem_draft_id uuid,
    draft_origin public.draft_origin DEFAULT 'editor'::public.draft_origin NOT NULL
);


ALTER TABLE public.nt_pending_deletion OWNER TO neotree_webeditor_dev;

--
-- Name: nt_pending_deletion_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_pending_deletion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_pending_deletion_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_pending_deletion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_pending_deletion_id_seq OWNED BY public.nt_pending_deletion.id;


--
-- Name: nt_problems; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_problems (
    id integer NOT NULL,
    problem_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    old_script_id text,
    version integer NOT NULL,
    script_id uuid NOT NULL,
    "position" integer NOT NULL,
    source text DEFAULT 'editor'::text,
    expression text NOT NULL,
    name text DEFAULT ''::text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    key text DEFAULT ''::text,
    key_id text DEFAULT ''::text NOT NULL,
    severity_order integer,
    expression_meaning text DEFAULT ''::text NOT NULL,
    text1 text DEFAULT ''::text NOT NULL,
    text2 text DEFAULT ''::text NOT NULL,
    text3 text DEFAULT ''::text NOT NULL,
    image1 jsonb,
    image2 jsonb,
    image3 jsonb,
    preferences jsonb DEFAULT '{"fontSize": {}, "fontStyle": {}, "highlight": {}, "textColor": {}, "fontWeight": {}, "backgroundColor": {}}'::jsonb NOT NULL,
    publish_date timestamp without time zone DEFAULT now() NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    symptoms jsonb DEFAULT '[]'::jsonb NOT NULL
);


ALTER TABLE public.nt_problems OWNER TO neotree_webeditor_dev;

--
-- Name: nt_problems_drafts; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_problems_drafts (
    id integer NOT NULL,
    problem_draft_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    problem_id uuid,
    script_id uuid,
    script_draft_id uuid,
    "position" integer NOT NULL,
    data jsonb NOT NULL,
    created_by_user_id uuid,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    draft_origin public.draft_origin DEFAULT 'editor'::public.draft_origin NOT NULL
);


ALTER TABLE public.nt_problems_drafts OWNER TO neotree_webeditor_dev;

--
-- Name: nt_problems_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_problems_drafts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_problems_drafts_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_problems_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_problems_drafts_id_seq OWNED BY public.nt_problems_drafts.id;


--
-- Name: nt_problems_history; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_problems_history (
    id integer NOT NULL,
    version integer NOT NULL,
    problem_id uuid NOT NULL,
    script_id uuid NOT NULL,
    restore_key text,
    data jsonb DEFAULT '[]'::jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_problems_history OWNER TO neotree_webeditor_dev;

--
-- Name: nt_problems_history_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_problems_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_problems_history_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_problems_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_problems_history_id_seq OWNED BY public.nt_problems_history.id;


--
-- Name: nt_problems_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_problems_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_problems_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_problems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_problems_id_seq OWNED BY public.nt_problems.id;


--
-- Name: nt_screens; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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
    collection_name text DEFAULT ''::text NOT NULL,
    collection_label text DEFAULT ''::text NOT NULL,
    content_text_image jsonb,
    list_style public.list_style DEFAULT 'none'::public.list_style NOT NULL,
    key_id text DEFAULT ''::text NOT NULL,
    ref_id_data_key text DEFAULT ''::text NOT NULL,
    ref_key_data_key text DEFAULT ''::text NOT NULL,
    print_display_columns integer DEFAULT 2 NOT NULL,
    rank_items boolean DEFAULT false NOT NULL,
    hcw_problems_instructions text DEFAULT ''::text NOT NULL,
    suggested_problems_instructions text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.nt_screens OWNER TO neotree_webeditor_dev;

--
-- Name: nt_screens_drafts; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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
    created_by_user_id uuid,
    draft_origin public.draft_origin DEFAULT 'editor'::public.draft_origin NOT NULL
);


ALTER TABLE public.nt_screens_drafts OWNER TO neotree_webeditor_dev;

--
-- Name: nt_screens_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_screens_drafts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_screens_drafts_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_screens_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_screens_drafts_id_seq OWNED BY public.nt_screens_drafts.id;


--
-- Name: nt_screens_history; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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


ALTER TABLE public.nt_screens_history OWNER TO neotree_webeditor_dev;

--
-- Name: nt_screens_history_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_screens_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_screens_history_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_screens_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_screens_history_id_seq OWNED BY public.nt_screens_history.id;


--
-- Name: nt_screens_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_screens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_screens_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_screens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_screens_id_seq OWNED BY public.nt_screens.id;


--
-- Name: nt_scripts; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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
    reviewable boolean,
    review_configurations jsonb DEFAULT '[]'::jsonb NOT NULL,
    print_config jsonb DEFAULT '{"sections": [], "footerFields": [], "headerFields": []}'::jsonb NOT NULL,
    eligibility_criteria jsonb
);


ALTER TABLE public.nt_scripts OWNER TO neotree_webeditor_dev;

--
-- Name: nt_scripts_drafts; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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
    created_by_user_id uuid,
    draft_origin public.draft_origin DEFAULT 'editor'::public.draft_origin NOT NULL
);


ALTER TABLE public.nt_scripts_drafts OWNER TO neotree_webeditor_dev;

--
-- Name: nt_scripts_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_scripts_drafts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_scripts_drafts_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_scripts_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_scripts_drafts_id_seq OWNED BY public.nt_scripts_drafts.id;


--
-- Name: nt_scripts_history; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_scripts_history (
    id integer NOT NULL,
    version integer NOT NULL,
    script_id uuid NOT NULL,
    restore_key uuid,
    data jsonb DEFAULT '[]'::jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.nt_scripts_history OWNER TO neotree_webeditor_dev;

--
-- Name: nt_scripts_history_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_scripts_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_scripts_history_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_scripts_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_scripts_history_id_seq OWNED BY public.nt_scripts_history.id;


--
-- Name: nt_scripts_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_scripts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_scripts_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_scripts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_scripts_id_seq OWNED BY public.nt_scripts.id;


--
-- Name: nt_sites; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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


ALTER TABLE public.nt_sites OWNER TO neotree_webeditor_dev;

--
-- Name: nt_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_sites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_sites_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_sites_id_seq OWNED BY public.nt_sites.id;


--
-- Name: nt_sys; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_sys (
    _id integer NOT NULL,
    id uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL,
    key text NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.nt_sys OWNER TO neotree_webeditor_dev;

--
-- Name: nt_sys__id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_sys__id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_sys__id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_sys__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_sys__id_seq OWNED BY public.nt_sys._id;


--
-- Name: nt_tokens; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_tokens (
    id integer NOT NULL,
    code integer NOT NULL,
    secret text NOT NULL,
    valid_until timestamp without time zone NOT NULL
);


ALTER TABLE public.nt_tokens OWNER TO neotree_webeditor_dev;

--
-- Name: nt_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_tokens_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_tokens_id_seq OWNED BY public.nt_tokens.id;


--
-- Name: nt_user_roles; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.nt_user_roles (
    id integer NOT NULL,
    name public.role_name NOT NULL,
    description text
);


ALTER TABLE public.nt_user_roles OWNER TO neotree_webeditor_dev;

--
-- Name: nt_user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_user_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_user_roles_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_user_roles_id_seq OWNED BY public.nt_user_roles.id;


--
-- Name: nt_users; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
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


ALTER TABLE public.nt_users OWNER TO neotree_webeditor_dev;

--
-- Name: nt_users_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.nt_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nt_users_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: nt_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.nt_users_id_seq OWNED BY public.nt_users.id;


--
-- Name: screens; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.screens (
    id integer NOT NULL,
    screen_id character varying(255) NOT NULL,
    data json DEFAULT '"{}"'::json,
    type character varying(255),
    "position" integer,
    script_id character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public.screens OWNER TO neotree_webeditor_dev;

--
-- Name: screens_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.screens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.screens_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: screens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.screens_id_seq OWNED BY public.screens.id;


--
-- Name: scripts; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.scripts (
    id integer NOT NULL,
    script_id character varying(255) NOT NULL,
    "position" integer,
    data json DEFAULT '"{}"'::json,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public.scripts OWNER TO neotree_webeditor_dev;

--
-- Name: scripts_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.scripts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.scripts_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: scripts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.scripts_id_seq OWNED BY public.scripts.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE TABLE public.users (
    id integer NOT NULL,
    user_id character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255),
    data json DEFAULT '"{}"'::json,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    role integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.users OWNER TO neotree_webeditor_dev;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: neotree_webeditor_dev
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO neotree_webeditor_dev;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neotree_webeditor_dev
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: api_keys id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.api_keys ALTER COLUMN id SET DEFAULT nextval('public.api_keys_id_seq'::regclass);


--
-- Name: apps id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.apps ALTER COLUMN id SET DEFAULT nextval('public.apps_id_seq'::regclass);


--
-- Name: config_keys id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.config_keys ALTER COLUMN id SET DEFAULT nextval('public.config_keys_id_seq'::regclass);


--
-- Name: configurations id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.configurations ALTER COLUMN id SET DEFAULT nextval('public.configurations_id_seq'::regclass);


--
-- Name: devices id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.devices ALTER COLUMN id SET DEFAULT nextval('public.devices_id_seq'::regclass);


--
-- Name: diagnoses id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.diagnoses ALTER COLUMN id SET DEFAULT nextval('public.diagnoses_id_seq'::regclass);


--
-- Name: hospitals id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.hospitals ALTER COLUMN id SET DEFAULT nextval('public.hospitals_id_seq'::regclass);


--
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


--
-- Name: nt_admin_audit_logs id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_admin_audit_logs ALTER COLUMN id SET DEFAULT nextval('public.nt_admin_audit_logs_id_seq'::regclass);


--
-- Name: nt_aliases id; Type: DEFAULT; Schema: public; Owner: morris
--

ALTER TABLE ONLY public.nt_aliases ALTER COLUMN id SET DEFAULT nextval('public.nt_aliases_id_seq'::regclass);


--
-- Name: nt_api_keys id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_api_keys ALTER COLUMN id SET DEFAULT nextval('public.nt_api_keys_id_seq'::regclass);


--
-- Name: nt_auth_clients id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_auth_clients ALTER COLUMN id SET DEFAULT nextval('public.nt_auth_clients_id_seq'::regclass);


--
-- Name: nt_change_logs id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_change_logs ALTER COLUMN id SET DEFAULT nextval('public.nt_change_logs_id_seq'::regclass);


--
-- Name: nt_config_keys id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_config_keys ALTER COLUMN id SET DEFAULT nextval('public.nt_config_keys_id_seq'::regclass);


--
-- Name: nt_config_keys_drafts id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_config_keys_drafts ALTER COLUMN id SET DEFAULT nextval('public.nt_config_keys_drafts_id_seq'::regclass);


--
-- Name: nt_config_keys_history id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_config_keys_history ALTER COLUMN id SET DEFAULT nextval('public.nt_config_keys_history_id_seq'::regclass);


--
-- Name: nt_data_keys id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_data_keys ALTER COLUMN id SET DEFAULT nextval('public.nt_data_keys_id_seq'::regclass);


--
-- Name: nt_data_keys_drafts id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_data_keys_drafts ALTER COLUMN id SET DEFAULT nextval('public.nt_data_keys_drafts_id_seq'::regclass);


--
-- Name: nt_data_keys_history id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_data_keys_history ALTER COLUMN id SET DEFAULT nextval('public.nt_data_keys_history_id_seq'::regclass);


--
-- Name: nt_devices id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_devices ALTER COLUMN id SET DEFAULT nextval('public.nt_devices_id_seq'::regclass);


--
-- Name: nt_diagnoses id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_diagnoses ALTER COLUMN id SET DEFAULT nextval('public.nt_diagnoses_id_seq'::regclass);


--
-- Name: nt_diagnoses_drafts id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_diagnoses_drafts ALTER COLUMN id SET DEFAULT nextval('public.nt_diagnoses_drafts_id_seq'::regclass);


--
-- Name: nt_diagnoses_history id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_diagnoses_history ALTER COLUMN id SET DEFAULT nextval('public.nt_diagnoses_history_id_seq'::regclass);


--
-- Name: nt_drugs_library id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_drugs_library ALTER COLUMN id SET DEFAULT nextval('public.nt_drugs_library_id_seq'::regclass);


--
-- Name: nt_drugs_library_drafts id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_drugs_library_drafts ALTER COLUMN id SET DEFAULT nextval('public.nt_drugs_library_drafts_id_seq'::regclass);


--
-- Name: nt_drugs_library_history id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_drugs_library_history ALTER COLUMN id SET DEFAULT nextval('public.nt_drugs_library_history_id_seq'::regclass);


--
-- Name: nt_editor_info id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_editor_info ALTER COLUMN id SET DEFAULT nextval('public.nt_editor_info_id_seq'::regclass);


--
-- Name: nt_email_templates id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_email_templates ALTER COLUMN id SET DEFAULT nextval('public.nt_email_templates_id_seq'::regclass);


--
-- Name: nt_files id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_files ALTER COLUMN id SET DEFAULT nextval('public.nt_files_id_seq'::regclass);


--
-- Name: nt_files_aliases id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_files_aliases ALTER COLUMN id SET DEFAULT nextval('public.nt_files_aliases_id_seq'::regclass);


--
-- Name: nt_files_chunks id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_files_chunks ALTER COLUMN id SET DEFAULT nextval('public.nt_files_chunks_id_seq'::regclass);


--
-- Name: nt_hospitals id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_hospitals ALTER COLUMN id SET DEFAULT nextval('public.nt_hospitals_id_seq'::regclass);


--
-- Name: nt_hospitals_drafts id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_hospitals_drafts ALTER COLUMN id SET DEFAULT nextval('public.nt_hospitals_drafts_id_seq'::regclass);


--
-- Name: nt_hospitals_history id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_hospitals_history ALTER COLUMN id SET DEFAULT nextval('public.nt_hospitals_history_id_seq'::regclass);


--
-- Name: nt_integrity_import_snapshots id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_integrity_import_snapshots ALTER COLUMN id SET DEFAULT nextval('public.nt_integrity_import_snapshots_id_seq'::regclass);


--
-- Name: nt_languages id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_languages ALTER COLUMN id SET DEFAULT nextval('public.nt_languages_id_seq'::regclass);


--
-- Name: nt_mailer_settings id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_mailer_settings ALTER COLUMN id SET DEFAULT nextval('public.nt_mailer_settings_id_seq'::regclass);


--
-- Name: nt_pending_deletion id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion ALTER COLUMN id SET DEFAULT nextval('public.nt_pending_deletion_id_seq'::regclass);


--
-- Name: nt_problems id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_problems ALTER COLUMN id SET DEFAULT nextval('public.nt_problems_id_seq'::regclass);


--
-- Name: nt_problems_drafts id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_problems_drafts ALTER COLUMN id SET DEFAULT nextval('public.nt_problems_drafts_id_seq'::regclass);


--
-- Name: nt_problems_history id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_problems_history ALTER COLUMN id SET DEFAULT nextval('public.nt_problems_history_id_seq'::regclass);


--
-- Name: nt_screens id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_screens ALTER COLUMN id SET DEFAULT nextval('public.nt_screens_id_seq'::regclass);


--
-- Name: nt_screens_drafts id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_screens_drafts ALTER COLUMN id SET DEFAULT nextval('public.nt_screens_drafts_id_seq'::regclass);


--
-- Name: nt_screens_history id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_screens_history ALTER COLUMN id SET DEFAULT nextval('public.nt_screens_history_id_seq'::regclass);


--
-- Name: nt_scripts id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_scripts ALTER COLUMN id SET DEFAULT nextval('public.nt_scripts_id_seq'::regclass);


--
-- Name: nt_scripts_drafts id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_scripts_drafts ALTER COLUMN id SET DEFAULT nextval('public.nt_scripts_drafts_id_seq'::regclass);


--
-- Name: nt_scripts_history id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_scripts_history ALTER COLUMN id SET DEFAULT nextval('public.nt_scripts_history_id_seq'::regclass);


--
-- Name: nt_sites id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_sites ALTER COLUMN id SET DEFAULT nextval('public.nt_sites_id_seq'::regclass);


--
-- Name: nt_sys _id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_sys ALTER COLUMN _id SET DEFAULT nextval('public.nt_sys__id_seq'::regclass);


--
-- Name: nt_tokens id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_tokens ALTER COLUMN id SET DEFAULT nextval('public.nt_tokens_id_seq'::regclass);


--
-- Name: nt_user_roles id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_user_roles ALTER COLUMN id SET DEFAULT nextval('public.nt_user_roles_id_seq'::regclass);


--
-- Name: nt_users id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_users ALTER COLUMN id SET DEFAULT nextval('public.nt_users_id_seq'::regclass);


--
-- Name: screens id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.screens ALTER COLUMN id SET DEFAULT nextval('public.screens_id_seq'::regclass);


--
-- Name: scripts id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.scripts ALTER COLUMN id SET DEFAULT nextval('public.scripts_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: Session Session_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public."Session"
    ADD CONSTRAINT "Session_pkey" PRIMARY KEY (sid);


--
-- Name: Sessions Sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public."Sessions"
    ADD CONSTRAINT "Sessions_pkey" PRIMARY KEY (sid);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: apps apps_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.apps
    ADD CONSTRAINT apps_pkey PRIMARY KEY (id);


--
-- Name: config_keys config_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.config_keys
    ADD CONSTRAINT config_keys_pkey PRIMARY KEY (id);


--
-- Name: configurations configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.configurations
    ADD CONSTRAINT configurations_pkey PRIMARY KEY (id);


--
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: diagnoses diagnoses_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.diagnoses
    ADD CONSTRAINT diagnoses_pkey PRIMARY KEY (id);


--
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: hospitals hospitals_hospital_id_key; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.hospitals
    ADD CONSTRAINT hospitals_hospital_id_key UNIQUE (hospital_id);


--
-- Name: hospitals hospitals_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.hospitals
    ADD CONSTRAINT hospitals_pkey PRIMARY KEY (id);


--
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: nt_admin_audit_logs nt_admin_audit_logs_audit_log_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_admin_audit_logs
    ADD CONSTRAINT nt_admin_audit_logs_audit_log_id_unique UNIQUE (audit_log_id);


--
-- Name: nt_admin_audit_logs nt_admin_audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_admin_audit_logs
    ADD CONSTRAINT nt_admin_audit_logs_pkey PRIMARY KEY (id);


--
-- Name: nt_aliases nt_aliases_name_script_unique; Type: CONSTRAINT; Schema: public; Owner: morris
--

ALTER TABLE ONLY public.nt_aliases
    ADD CONSTRAINT nt_aliases_name_script_unique UNIQUE (name, script);


--
-- Name: nt_aliases nt_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: morris
--

ALTER TABLE ONLY public.nt_aliases
    ADD CONSTRAINT nt_aliases_pkey PRIMARY KEY (id);


--
-- Name: nt_aliases nt_aliases_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: morris
--

ALTER TABLE ONLY public.nt_aliases
    ADD CONSTRAINT nt_aliases_uuid_unique UNIQUE (uuid);


--
-- Name: nt_api_keys nt_api_keys_api_key_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_api_keys
    ADD CONSTRAINT nt_api_keys_api_key_id_unique UNIQUE (api_key_id);


--
-- Name: nt_api_keys nt_api_keys_api_key_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_api_keys
    ADD CONSTRAINT nt_api_keys_api_key_unique UNIQUE (api_key);


--
-- Name: nt_api_keys nt_api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_api_keys
    ADD CONSTRAINT nt_api_keys_pkey PRIMARY KEY (id);


--
-- Name: nt_auth_clients nt_auth_clients_client_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_auth_clients
    ADD CONSTRAINT nt_auth_clients_client_id_unique UNIQUE (client_id);


--
-- Name: nt_auth_clients nt_auth_clients_client_token_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_auth_clients
    ADD CONSTRAINT nt_auth_clients_client_token_unique UNIQUE (client_token);


--
-- Name: nt_auth_clients nt_auth_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_auth_clients
    ADD CONSTRAINT nt_auth_clients_pkey PRIMARY KEY (id);


--
-- Name: nt_change_logs nt_change_logs_change_log_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_change_log_id_unique UNIQUE (change_log_id);


--
-- Name: nt_change_logs nt_change_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_pkey PRIMARY KEY (id);


--
-- Name: nt_config_keys nt_config_keys_config_key_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_config_keys
    ADD CONSTRAINT nt_config_keys_config_key_id_unique UNIQUE (config_key_id);


--
-- Name: nt_config_keys_drafts nt_config_keys_drafts_config_key_draft_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_config_keys_drafts
    ADD CONSTRAINT nt_config_keys_drafts_config_key_draft_id_unique UNIQUE (config_key_draft_id);


--
-- Name: nt_config_keys_drafts nt_config_keys_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_config_keys_drafts
    ADD CONSTRAINT nt_config_keys_drafts_pkey PRIMARY KEY (id);


--
-- Name: nt_config_keys_history nt_config_keys_history_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_config_keys_history
    ADD CONSTRAINT nt_config_keys_history_pkey PRIMARY KEY (id);


--
-- Name: nt_config_keys nt_config_keys_key_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_config_keys
    ADD CONSTRAINT nt_config_keys_key_unique UNIQUE (key);


--
-- Name: nt_config_keys nt_config_keys_label_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_config_keys
    ADD CONSTRAINT nt_config_keys_label_unique UNIQUE (label);


--
-- Name: nt_config_keys nt_config_keys_old_config_key_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_config_keys
    ADD CONSTRAINT nt_config_keys_old_config_key_id_unique UNIQUE (old_config_key_id);


--
-- Name: nt_config_keys nt_config_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_config_keys
    ADD CONSTRAINT nt_config_keys_pkey PRIMARY KEY (id);


--
-- Name: nt_data_keys_drafts nt_data_keys_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_data_keys_drafts
    ADD CONSTRAINT nt_data_keys_drafts_pkey PRIMARY KEY (id);


--
-- Name: nt_data_keys_drafts nt_data_keys_drafts_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_data_keys_drafts
    ADD CONSTRAINT nt_data_keys_drafts_uuid_unique UNIQUE (uuid);


--
-- Name: nt_data_keys_history nt_data_keys_history_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_data_keys_history
    ADD CONSTRAINT nt_data_keys_history_pkey PRIMARY KEY (id);


--
-- Name: nt_data_keys nt_data_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_data_keys
    ADD CONSTRAINT nt_data_keys_pkey PRIMARY KEY (id);


--
-- Name: nt_data_keys nt_data_keys_unique_key_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_data_keys
    ADD CONSTRAINT nt_data_keys_unique_key_unique UNIQUE (unique_key);


--
-- Name: nt_data_keys nt_data_keys_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_data_keys
    ADD CONSTRAINT nt_data_keys_uuid_unique UNIQUE (uuid);


--
-- Name: nt_devices nt_devices_device_hash_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_devices
    ADD CONSTRAINT nt_devices_device_hash_unique UNIQUE (device_hash);


--
-- Name: nt_devices nt_devices_device_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_devices
    ADD CONSTRAINT nt_devices_device_id_unique UNIQUE (device_id);


--
-- Name: nt_devices nt_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_devices
    ADD CONSTRAINT nt_devices_pkey PRIMARY KEY (id);


--
-- Name: nt_diagnoses nt_diagnoses_diagnosis_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_diagnoses
    ADD CONSTRAINT nt_diagnoses_diagnosis_id_unique UNIQUE (diagnosis_id);


--
-- Name: nt_diagnoses_drafts nt_diagnoses_drafts_diagnosis_draft_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_diagnoses_drafts
    ADD CONSTRAINT nt_diagnoses_drafts_diagnosis_draft_id_unique UNIQUE (diagnosis_draft_id);


--
-- Name: nt_diagnoses_drafts nt_diagnoses_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_diagnoses_drafts
    ADD CONSTRAINT nt_diagnoses_drafts_pkey PRIMARY KEY (id);


--
-- Name: nt_diagnoses_history nt_diagnoses_history_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_diagnoses_history
    ADD CONSTRAINT nt_diagnoses_history_pkey PRIMARY KEY (id);


--
-- Name: nt_diagnoses nt_diagnoses_old_diagnosis_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_diagnoses
    ADD CONSTRAINT nt_diagnoses_old_diagnosis_id_unique UNIQUE (old_diagnosis_id);


--
-- Name: nt_diagnoses nt_diagnoses_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_diagnoses
    ADD CONSTRAINT nt_diagnoses_pkey PRIMARY KEY (id);


--
-- Name: nt_drugs_library_drafts nt_drugs_library_drafts_item_draft_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_drugs_library_drafts
    ADD CONSTRAINT nt_drugs_library_drafts_item_draft_id_unique UNIQUE (item_draft_id);


--
-- Name: nt_drugs_library_drafts nt_drugs_library_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_drugs_library_drafts
    ADD CONSTRAINT nt_drugs_library_drafts_pkey PRIMARY KEY (id);


--
-- Name: nt_drugs_library_history nt_drugs_library_history_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_drugs_library_history
    ADD CONSTRAINT nt_drugs_library_history_pkey PRIMARY KEY (id);


--
-- Name: nt_drugs_library nt_drugs_library_item_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_drugs_library
    ADD CONSTRAINT nt_drugs_library_item_id_unique UNIQUE (item_id);


--
-- Name: nt_drugs_library nt_drugs_library_key_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_drugs_library
    ADD CONSTRAINT nt_drugs_library_key_unique UNIQUE (key);


--
-- Name: nt_drugs_library nt_drugs_library_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_drugs_library
    ADD CONSTRAINT nt_drugs_library_pkey PRIMARY KEY (id);


--
-- Name: nt_editor_info nt_editor_info_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_editor_info
    ADD CONSTRAINT nt_editor_info_pkey PRIMARY KEY (id);


--
-- Name: nt_email_templates nt_email_templates_name_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_email_templates
    ADD CONSTRAINT nt_email_templates_name_unique UNIQUE (name);


--
-- Name: nt_email_templates nt_email_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_email_templates
    ADD CONSTRAINT nt_email_templates_pkey PRIMARY KEY (id);


--
-- Name: nt_email_templates nt_email_templates_template_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_email_templates
    ADD CONSTRAINT nt_email_templates_template_id_unique UNIQUE (template_id);


--
-- Name: nt_files_aliases nt_files_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_files_aliases
    ADD CONSTRAINT nt_files_aliases_pkey PRIMARY KEY (id);


--
-- Name: nt_files_chunks nt_files_chunks_chunk_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_files_chunks
    ADD CONSTRAINT nt_files_chunks_chunk_id_unique UNIQUE (chunk_id);


--
-- Name: nt_files_chunks nt_files_chunks_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_files_chunks
    ADD CONSTRAINT nt_files_chunks_pkey PRIMARY KEY (id);


--
-- Name: nt_files nt_files_file_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_files
    ADD CONSTRAINT nt_files_file_id_unique UNIQUE (file_id);


--
-- Name: nt_files nt_files_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_files
    ADD CONSTRAINT nt_files_pkey PRIMARY KEY (id);


--
-- Name: nt_hospitals_drafts nt_hospitals_drafts_hospital_draft_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_hospitals_drafts
    ADD CONSTRAINT nt_hospitals_drafts_hospital_draft_id_unique UNIQUE (hospital_draft_id);


--
-- Name: nt_hospitals_drafts nt_hospitals_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_hospitals_drafts
    ADD CONSTRAINT nt_hospitals_drafts_pkey PRIMARY KEY (id);


--
-- Name: nt_hospitals_history nt_hospitals_history_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_hospitals_history
    ADD CONSTRAINT nt_hospitals_history_pkey PRIMARY KEY (id);


--
-- Name: nt_hospitals nt_hospitals_hospital_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_hospitals
    ADD CONSTRAINT nt_hospitals_hospital_id_unique UNIQUE (hospital_id);


--
-- Name: nt_hospitals nt_hospitals_name_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_hospitals
    ADD CONSTRAINT nt_hospitals_name_unique UNIQUE (name);


--
-- Name: nt_hospitals nt_hospitals_old_hospital_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_hospitals
    ADD CONSTRAINT nt_hospitals_old_hospital_id_unique UNIQUE (old_hospital_id);


--
-- Name: nt_hospitals nt_hospitals_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_hospitals
    ADD CONSTRAINT nt_hospitals_pkey PRIMARY KEY (id);


--
-- Name: nt_integrity_import_snapshots nt_integrity_import_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_integrity_import_snapshots
    ADD CONSTRAINT nt_integrity_import_snapshots_pkey PRIMARY KEY (id);


--
-- Name: nt_integrity_import_snapshots nt_integrity_import_snapshots_snapshot_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_integrity_import_snapshots
    ADD CONSTRAINT nt_integrity_import_snapshots_snapshot_id_unique UNIQUE (snapshot_id);


--
-- Name: nt_languages nt_languages_iso_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_languages
    ADD CONSTRAINT nt_languages_iso_unique UNIQUE (iso);


--
-- Name: nt_languages nt_languages_name_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_languages
    ADD CONSTRAINT nt_languages_name_unique UNIQUE (name);


--
-- Name: nt_languages nt_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_languages
    ADD CONSTRAINT nt_languages_pkey PRIMARY KEY (id);


--
-- Name: nt_lock nt_lock_pkey; Type: CONSTRAINT; Schema: public; Owner: morris
--

ALTER TABLE ONLY public.nt_lock
    ADD CONSTRAINT nt_lock_pkey PRIMARY KEY (lock_id);


--
-- Name: nt_mailer_settings nt_mailer_settings_name_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_mailer_settings
    ADD CONSTRAINT nt_mailer_settings_name_unique UNIQUE (name);


--
-- Name: nt_mailer_settings nt_mailer_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_mailer_settings
    ADD CONSTRAINT nt_mailer_settings_pkey PRIMARY KEY (id);


--
-- Name: nt_mailer_settings nt_mailer_settings_setting_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_mailer_settings
    ADD CONSTRAINT nt_mailer_settings_setting_id_unique UNIQUE (setting_id);


--
-- Name: nt_pending_deletion nt_pending_deletion_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_pkey PRIMARY KEY (id);


--
-- Name: nt_problems_drafts nt_problems_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_problems_drafts
    ADD CONSTRAINT nt_problems_drafts_pkey PRIMARY KEY (id);


--
-- Name: nt_problems_drafts nt_problems_drafts_problem_draft_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_problems_drafts
    ADD CONSTRAINT nt_problems_drafts_problem_draft_id_unique UNIQUE (problem_draft_id);


--
-- Name: nt_problems_history nt_problems_history_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_problems_history
    ADD CONSTRAINT nt_problems_history_pkey PRIMARY KEY (id);


--
-- Name: nt_problems nt_problems_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_problems
    ADD CONSTRAINT nt_problems_pkey PRIMARY KEY (id);


--
-- Name: nt_problems nt_problems_problem_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_problems
    ADD CONSTRAINT nt_problems_problem_id_unique UNIQUE (problem_id);


--
-- Name: nt_screens_drafts nt_screens_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_screens_drafts
    ADD CONSTRAINT nt_screens_drafts_pkey PRIMARY KEY (id);


--
-- Name: nt_screens_drafts nt_screens_drafts_screen_draft_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_screens_drafts
    ADD CONSTRAINT nt_screens_drafts_screen_draft_id_unique UNIQUE (screen_draft_id);


--
-- Name: nt_screens_history nt_screens_history_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_screens_history
    ADD CONSTRAINT nt_screens_history_pkey PRIMARY KEY (id);


--
-- Name: nt_screens nt_screens_old_screen_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_screens
    ADD CONSTRAINT nt_screens_old_screen_id_unique UNIQUE (old_screen_id);


--
-- Name: nt_screens nt_screens_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_screens
    ADD CONSTRAINT nt_screens_pkey PRIMARY KEY (id);


--
-- Name: nt_screens nt_screens_screen_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_screens
    ADD CONSTRAINT nt_screens_screen_id_unique UNIQUE (screen_id);


--
-- Name: nt_scripts_drafts nt_scripts_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_scripts_drafts
    ADD CONSTRAINT nt_scripts_drafts_pkey PRIMARY KEY (id);


--
-- Name: nt_scripts_drafts nt_scripts_drafts_script_draft_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_scripts_drafts
    ADD CONSTRAINT nt_scripts_drafts_script_draft_id_unique UNIQUE (script_draft_id);


--
-- Name: nt_scripts_history nt_scripts_history_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_scripts_history
    ADD CONSTRAINT nt_scripts_history_pkey PRIMARY KEY (id);


--
-- Name: nt_scripts nt_scripts_old_script_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_scripts
    ADD CONSTRAINT nt_scripts_old_script_id_unique UNIQUE (old_script_id);


--
-- Name: nt_scripts nt_scripts_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_scripts
    ADD CONSTRAINT nt_scripts_pkey PRIMARY KEY (id);


--
-- Name: nt_scripts nt_scripts_script_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_scripts
    ADD CONSTRAINT nt_scripts_script_id_unique UNIQUE (script_id);


--
-- Name: nt_sites nt_sites_display_name_key; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_sites
    ADD CONSTRAINT nt_sites_display_name_key UNIQUE (display_name);


--
-- Name: nt_sites nt_sites_link_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_sites
    ADD CONSTRAINT nt_sites_link_unique UNIQUE (link);


--
-- Name: nt_sites nt_sites_name_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_sites
    ADD CONSTRAINT nt_sites_name_unique UNIQUE (name);


--
-- Name: nt_sites nt_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_sites
    ADD CONSTRAINT nt_sites_pkey PRIMARY KEY (id);


--
-- Name: nt_sites nt_sites_site_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_sites
    ADD CONSTRAINT nt_sites_site_id_unique UNIQUE (site_id);


--
-- Name: nt_sys nt_sys_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_sys
    ADD CONSTRAINT nt_sys_id_unique UNIQUE (id);


--
-- Name: nt_sys nt_sys_key_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_sys
    ADD CONSTRAINT nt_sys_key_unique UNIQUE (key);


--
-- Name: nt_sys nt_sys_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_sys
    ADD CONSTRAINT nt_sys_pkey PRIMARY KEY (_id);


--
-- Name: nt_user_roles nt_user_roles_name_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_user_roles
    ADD CONSTRAINT nt_user_roles_name_unique UNIQUE (name);


--
-- Name: nt_user_roles nt_user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_user_roles
    ADD CONSTRAINT nt_user_roles_pkey PRIMARY KEY (id);


--
-- Name: nt_users nt_users_email_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_users
    ADD CONSTRAINT nt_users_email_unique UNIQUE (email);


--
-- Name: nt_users nt_users_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_users
    ADD CONSTRAINT nt_users_pkey PRIMARY KEY (id);


--
-- Name: nt_users nt_users_user_id_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_users
    ADD CONSTRAINT nt_users_user_id_unique UNIQUE (user_id);


--
-- Name: screens screens_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.screens
    ADD CONSTRAINT screens_pkey PRIMARY KEY (id);


--
-- Name: scripts scripts_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.scripts
    ADD CONSTRAINT scripts_pkey PRIMARY KEY (id);


--
-- Name: nt_tokens tokens_code_unique; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_tokens
    ADD CONSTRAINT tokens_code_unique UNIQUE (code);


--
-- Name: nt_tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: active_version_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX active_version_index ON public.nt_change_logs USING btree (entity_type, entity_id, is_active);


--
-- Name: admin_audit_logs_action_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX admin_audit_logs_action_index ON public.nt_admin_audit_logs USING btree (action);


--
-- Name: admin_audit_logs_actor_user_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX admin_audit_logs_actor_user_index ON public.nt_admin_audit_logs USING btree (actor_user_id);


--
-- Name: admin_audit_logs_area_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX admin_audit_logs_area_index ON public.nt_admin_audit_logs USING btree (area);


--
-- Name: admin_audit_logs_created_at_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX admin_audit_logs_created_at_index ON public.nt_admin_audit_logs USING btree (created_at);


--
-- Name: change_logs_data_version_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX change_logs_data_version_index ON public.nt_change_logs USING btree (data_version);


--
-- Name: change_logs_date_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX change_logs_date_index ON public.nt_change_logs USING btree (date_of_change);


--
-- Name: change_logs_entity_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX change_logs_entity_index ON public.nt_change_logs USING btree (entity_type, entity_id);


--
-- Name: change_logs_single_active_version_idx; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE UNIQUE INDEX change_logs_single_active_version_idx ON public.nt_change_logs USING btree (entity_type, entity_id) WHERE (is_active = true);


--
-- Name: change_logs_user_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX change_logs_user_index ON public.nt_change_logs USING btree (user_id);


--
-- Name: config_keys_search_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX config_keys_search_index ON public.nt_config_keys USING gin ((((to_tsvector('english'::regconfig, key) || to_tsvector('english'::regconfig, label)) || to_tsvector('english'::regconfig, summary))));


--
-- Name: diagnoses_search_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX diagnoses_search_index ON public.nt_diagnoses USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: hospitals_search_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX hospitals_search_index ON public.nt_hospitals USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: integrity_import_snapshots_accepted_by_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX integrity_import_snapshots_accepted_by_index ON public.nt_integrity_import_snapshots USING btree (accepted_by_user_id);


--
-- Name: integrity_import_snapshots_created_at_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX integrity_import_snapshots_created_at_index ON public.nt_integrity_import_snapshots USING btree (created_at);


--
-- Name: integrity_import_snapshots_created_by_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX integrity_import_snapshots_created_by_index ON public.nt_integrity_import_snapshots USING btree (created_by_user_id);


--
-- Name: integrity_import_snapshots_source_type_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX integrity_import_snapshots_source_type_index ON public.nt_integrity_import_snapshots USING btree (source_type);


--
-- Name: integrity_import_snapshots_status_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX integrity_import_snapshots_status_index ON public.nt_integrity_import_snapshots USING btree (status);


--
-- Name: nt_data_keys_data_type_idx; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX nt_data_keys_data_type_idx ON public.nt_data_keys USING btree (data_type);


--
-- Name: nt_data_keys_deleted_at_idx; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX nt_data_keys_deleted_at_idx ON public.nt_data_keys USING btree (deleted_at);


--
-- Name: nt_data_keys_drafts_data_key_id_idx; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX nt_data_keys_drafts_data_key_id_idx ON public.nt_data_keys_drafts USING btree (data_key_id);


--
-- Name: nt_data_keys_drafts_name_idx; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX nt_data_keys_drafts_name_idx ON public.nt_data_keys_drafts USING btree (name);


--
-- Name: nt_data_keys_drafts_unique_key_idx; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX nt_data_keys_drafts_unique_key_idx ON public.nt_data_keys_drafts USING btree (unique_key);


--
-- Name: nt_data_keys_name_idx; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX nt_data_keys_name_idx ON public.nt_data_keys USING btree (name);


--
-- Name: nt_data_keys_name_lower_idx; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX nt_data_keys_name_lower_idx ON public.nt_data_keys USING btree (lower(name));


--
-- Name: problems_search_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX problems_search_index ON public.nt_problems USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: screens_search_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX screens_search_index ON public.nt_screens USING gin (to_tsvector('english'::regconfig, title));


--
-- Name: scripts_search_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX scripts_search_index ON public.nt_scripts USING gin (((to_tsvector('english'::regconfig, title) || to_tsvector('english'::regconfig, description))));


--
-- Name: unique_version_per_entity; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE UNIQUE INDEX unique_version_per_entity ON public.nt_change_logs USING btree (entity_type, entity_id, version);


--
-- Name: users_search_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX users_search_index ON public.nt_users USING gin (((((to_tsvector('english'::regconfig, email) || to_tsvector('english'::regconfig, display_name)) || to_tsvector('english'::regconfig, first_name)) || to_tsvector('english'::regconfig, last_name))));


--
-- Name: version_chain_index; Type: INDEX; Schema: public; Owner: neotree_webeditor_dev
--

CREATE INDEX version_chain_index ON public.nt_change_logs USING btree (entity_id, parent_version);


--
-- Name: nt_lock fk_new_script_id; Type: FK CONSTRAINT; Schema: public; Owner: morris
--

ALTER TABLE ONLY public.nt_lock
    ADD CONSTRAINT fk_new_script_id FOREIGN KEY (new_script_id) REFERENCES public.nt_scripts_drafts(script_draft_id) ON DELETE CASCADE;


--
-- Name: nt_lock fk_script_id; Type: FK CONSTRAINT; Schema: public; Owner: morris
--

ALTER TABLE ONLY public.nt_lock
    ADD CONSTRAINT fk_script_id FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_lock fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: morris
--

ALTER TABLE ONLY public.nt_lock
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.nt_users(user_id) ON DELETE CASCADE;


--
-- Name: nt_admin_audit_logs nt_admin_audit_logs_actor_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_admin_audit_logs
    ADD CONSTRAINT nt_admin_audit_logs_actor_user_id_nt_users_user_id_fk FOREIGN KEY (actor_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_auth_clients nt_auth_clients_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_auth_clients
    ADD CONSTRAINT nt_auth_clients_user_id_nt_users_user_id_fk FOREIGN KEY (user_id) REFERENCES public.nt_users(user_id) ON DELETE CASCADE;


--
-- Name: nt_change_logs nt_change_logs_alias_id_nt_aliases_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_alias_id_nt_aliases_uuid_fk FOREIGN KEY (alias_id) REFERENCES public.nt_aliases(uuid) ON DELETE SET NULL;


--
-- Name: nt_change_logs nt_change_logs_config_key_id_nt_config_keys_config_key_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_config_key_id_nt_config_keys_config_key_id_fk FOREIGN KEY (config_key_id) REFERENCES public.nt_config_keys(config_key_id) ON DELETE SET NULL;


--
-- Name: nt_change_logs nt_change_logs_data_key_id_nt_data_keys_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_data_key_id_nt_data_keys_uuid_fk FOREIGN KEY (data_key_id) REFERENCES public.nt_data_keys(uuid) ON DELETE SET NULL;


--
-- Name: nt_change_logs nt_change_logs_diagnosis_id_nt_diagnoses_diagnosis_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_diagnosis_id_nt_diagnoses_diagnosis_id_fk FOREIGN KEY (diagnosis_id) REFERENCES public.nt_diagnoses(diagnosis_id) ON DELETE SET NULL;


--
-- Name: nt_change_logs nt_change_logs_drugs_library_item_id_nt_drugs_library_item_id_f; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_drugs_library_item_id_nt_drugs_library_item_id_f FOREIGN KEY (drugs_library_item_id) REFERENCES public.nt_drugs_library(item_id) ON DELETE SET NULL;


--
-- Name: nt_change_logs nt_change_logs_problem_id_nt_problems_problem_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_problem_id_nt_problems_problem_id_fk FOREIGN KEY (problem_id) REFERENCES public.nt_problems(problem_id) ON DELETE SET NULL;


--
-- Name: nt_change_logs nt_change_logs_screen_id_nt_screens_screen_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_screen_id_nt_screens_screen_id_fk FOREIGN KEY (screen_id) REFERENCES public.nt_screens(screen_id) ON DELETE SET NULL;


--
-- Name: nt_change_logs nt_change_logs_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE SET NULL;


--
-- Name: nt_change_logs nt_change_logs_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_change_logs
    ADD CONSTRAINT nt_change_logs_user_id_nt_users_user_id_fk FOREIGN KEY (user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_config_keys_drafts nt_config_keys_drafts_config_key_id_nt_config_keys_config_key_i; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_config_keys_drafts
    ADD CONSTRAINT nt_config_keys_drafts_config_key_id_nt_config_keys_config_key_i FOREIGN KEY (config_key_id) REFERENCES public.nt_config_keys(config_key_id) ON DELETE CASCADE;


--
-- Name: nt_config_keys_drafts nt_config_keys_drafts_created_by_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_config_keys_drafts
    ADD CONSTRAINT nt_config_keys_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_config_keys_history nt_config_keys_history_config_key_id_nt_config_keys_config_key_; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_config_keys_history
    ADD CONSTRAINT nt_config_keys_history_config_key_id_nt_config_keys_config_key_ FOREIGN KEY (config_key_id) REFERENCES public.nt_config_keys(config_key_id) ON DELETE CASCADE;


--
-- Name: nt_data_keys_drafts nt_data_keys_drafts_created_by_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_data_keys_drafts
    ADD CONSTRAINT nt_data_keys_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_data_keys_drafts nt_data_keys_drafts_data_key_id_nt_data_keys_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_data_keys_drafts
    ADD CONSTRAINT nt_data_keys_drafts_data_key_id_nt_data_keys_uuid_fk FOREIGN KEY (data_key_id) REFERENCES public.nt_data_keys(uuid) ON DELETE CASCADE;


--
-- Name: nt_data_keys_history nt_data_keys_history_data_key_id_nt_data_keys_uuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_data_keys_history
    ADD CONSTRAINT nt_data_keys_history_data_key_id_nt_data_keys_uuid_fk FOREIGN KEY (data_key_id) REFERENCES public.nt_data_keys(uuid) ON DELETE CASCADE;


--
-- Name: nt_diagnoses_drafts nt_diagnoses_drafts_created_by_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_diagnoses_drafts
    ADD CONSTRAINT nt_diagnoses_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_diagnoses_drafts nt_diagnoses_drafts_diagnosis_id_nt_diagnoses_diagnosis_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_diagnoses_drafts
    ADD CONSTRAINT nt_diagnoses_drafts_diagnosis_id_nt_diagnoses_diagnosis_id_fk FOREIGN KEY (diagnosis_id) REFERENCES public.nt_diagnoses(diagnosis_id) ON DELETE CASCADE;


--
-- Name: nt_diagnoses_drafts nt_diagnoses_drafts_script_draft_id_nt_scripts_drafts_script_dr; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_diagnoses_drafts
    ADD CONSTRAINT nt_diagnoses_drafts_script_draft_id_nt_scripts_drafts_script_dr FOREIGN KEY (script_draft_id) REFERENCES public.nt_scripts_drafts(script_draft_id) ON DELETE CASCADE;


--
-- Name: nt_diagnoses_drafts nt_diagnoses_drafts_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_diagnoses_drafts
    ADD CONSTRAINT nt_diagnoses_drafts_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_diagnoses_history nt_diagnoses_history_diagnosis_id_nt_diagnoses_diagnosis_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_diagnoses_history
    ADD CONSTRAINT nt_diagnoses_history_diagnosis_id_nt_diagnoses_diagnosis_id_fk FOREIGN KEY (diagnosis_id) REFERENCES public.nt_diagnoses(diagnosis_id) ON DELETE CASCADE;


--
-- Name: nt_diagnoses_history nt_diagnoses_history_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_diagnoses_history
    ADD CONSTRAINT nt_diagnoses_history_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_diagnoses nt_diagnoses_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_diagnoses
    ADD CONSTRAINT nt_diagnoses_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_drugs_library_drafts nt_drugs_library_drafts_created_by_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_drugs_library_drafts
    ADD CONSTRAINT nt_drugs_library_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_drugs_library_drafts nt_drugs_library_drafts_item_id_nt_drugs_library_item_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_drugs_library_drafts
    ADD CONSTRAINT nt_drugs_library_drafts_item_id_nt_drugs_library_item_id_fk FOREIGN KEY (item_id) REFERENCES public.nt_drugs_library(item_id) ON DELETE CASCADE;


--
-- Name: nt_drugs_library_history nt_drugs_library_history_item_id_nt_drugs_library_item_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_drugs_library_history
    ADD CONSTRAINT nt_drugs_library_history_item_id_nt_drugs_library_item_id_fk FOREIGN KEY (item_id) REFERENCES public.nt_drugs_library(item_id) ON DELETE CASCADE;


--
-- Name: nt_files_aliases nt_files_aliases_file_id_nt_files_file_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_files_aliases
    ADD CONSTRAINT nt_files_aliases_file_id_nt_files_file_id_fk FOREIGN KEY (file_id) REFERENCES public.nt_files(file_id) ON DELETE CASCADE;


--
-- Name: nt_files_chunks nt_files_chunks_file_id_nt_files_file_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_files_chunks
    ADD CONSTRAINT nt_files_chunks_file_id_nt_files_file_id_fk FOREIGN KEY (file_id) REFERENCES public.nt_files(file_id) ON DELETE CASCADE;


--
-- Name: nt_files nt_files_owner_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_files
    ADD CONSTRAINT nt_files_owner_id_nt_users_user_id_fk FOREIGN KEY (owner_id) REFERENCES public.nt_users(user_id) ON DELETE CASCADE;


--
-- Name: nt_hospitals_drafts nt_hospitals_drafts_created_by_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_hospitals_drafts
    ADD CONSTRAINT nt_hospitals_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_hospitals_drafts nt_hospitals_drafts_hospital_id_nt_hospitals_hospital_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_hospitals_drafts
    ADD CONSTRAINT nt_hospitals_drafts_hospital_id_nt_hospitals_hospital_id_fk FOREIGN KEY (hospital_id) REFERENCES public.nt_hospitals(hospital_id) ON DELETE CASCADE;


--
-- Name: nt_hospitals_history nt_hospitals_history_hospital_id_nt_hospitals_hospital_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_hospitals_history
    ADD CONSTRAINT nt_hospitals_history_hospital_id_nt_hospitals_hospital_id_fk FOREIGN KEY (hospital_id) REFERENCES public.nt_hospitals(hospital_id) ON DELETE CASCADE;


--
-- Name: nt_integrity_import_snapshots nt_integrity_import_snapshots_accepted_by_user_id_nt_users_user; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_integrity_import_snapshots
    ADD CONSTRAINT nt_integrity_import_snapshots_accepted_by_user_id_nt_users_user FOREIGN KEY (accepted_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_integrity_import_snapshots nt_integrity_import_snapshots_created_by_user_id_nt_users_user_; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_integrity_import_snapshots
    ADD CONSTRAINT nt_integrity_import_snapshots_created_by_user_id_nt_users_user_ FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_pending_deletion nt_pending_deletion_config_key_draft_id_nt_config_keys_drafts_c; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_config_key_draft_id_nt_config_keys_drafts_c FOREIGN KEY (config_key_draft_id) REFERENCES public.nt_config_keys_drafts(config_key_draft_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_config_key_id_nt_config_keys_config_key_id_; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_config_key_id_nt_config_keys_config_key_id_ FOREIGN KEY (config_key_id) REFERENCES public.nt_config_keys(config_key_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_created_by_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_pending_deletion nt_pending_deletion_diagnosis_draft_id_nt_diagnoses_drafts_diag; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_diagnosis_draft_id_nt_diagnoses_drafts_diag FOREIGN KEY (diagnosis_draft_id) REFERENCES public.nt_diagnoses_drafts(diagnosis_draft_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_diagnosis_id_nt_diagnoses_diagnosis_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_diagnosis_id_nt_diagnoses_diagnosis_id_fk FOREIGN KEY (diagnosis_id) REFERENCES public.nt_diagnoses(diagnosis_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_diagnosis_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_diagnosis_script_id_nt_scripts_script_id_fk FOREIGN KEY (diagnosis_script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_drugs_library_item_draft_id_nt_drugs_librar; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_drugs_library_item_draft_id_nt_drugs_librar FOREIGN KEY (drugs_library_item_draft_id) REFERENCES public.nt_drugs_library_drafts(item_draft_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_drugs_library_item_id_nt_drugs_library_item; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_drugs_library_item_id_nt_drugs_library_item FOREIGN KEY (drugs_library_item_id) REFERENCES public.nt_drugs_library(item_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_problem_draft_id_nt_problems_drafts_problem; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_problem_draft_id_nt_problems_drafts_problem FOREIGN KEY (problem_draft_id) REFERENCES public.nt_problems_drafts(problem_draft_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_problem_id_nt_problems_problem_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_problem_id_nt_problems_problem_id_fk FOREIGN KEY (problem_id) REFERENCES public.nt_problems(problem_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_problem_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_problem_script_id_nt_scripts_script_id_fk FOREIGN KEY (problem_script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_screen_draft_id_nt_screens_drafts_screen_dr; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_screen_draft_id_nt_screens_drafts_screen_dr FOREIGN KEY (screen_draft_id) REFERENCES public.nt_screens_drafts(screen_draft_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_screen_id_nt_screens_screen_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_screen_id_nt_screens_screen_id_fk FOREIGN KEY (screen_id) REFERENCES public.nt_screens(screen_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_screen_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_screen_script_id_nt_scripts_script_id_fk FOREIGN KEY (screen_script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_script_draft_id_nt_scripts_drafts_script_dr; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_script_draft_id_nt_scripts_drafts_script_dr FOREIGN KEY (script_draft_id) REFERENCES public.nt_scripts_drafts(script_draft_id) ON DELETE CASCADE;


--
-- Name: nt_pending_deletion nt_pending_deletion_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_pending_deletion
    ADD CONSTRAINT nt_pending_deletion_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_problems_drafts nt_problems_drafts_created_by_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_problems_drafts
    ADD CONSTRAINT nt_problems_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_problems_drafts nt_problems_drafts_problem_id_nt_problems_problem_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_problems_drafts
    ADD CONSTRAINT nt_problems_drafts_problem_id_nt_problems_problem_id_fk FOREIGN KEY (problem_id) REFERENCES public.nt_problems(problem_id) ON DELETE CASCADE;


--
-- Name: nt_problems_drafts nt_problems_drafts_script_draft_id_nt_scripts_drafts_script_dra; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_problems_drafts
    ADD CONSTRAINT nt_problems_drafts_script_draft_id_nt_scripts_drafts_script_dra FOREIGN KEY (script_draft_id) REFERENCES public.nt_scripts_drafts(script_draft_id) ON DELETE CASCADE;


--
-- Name: nt_problems_drafts nt_problems_drafts_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_problems_drafts
    ADD CONSTRAINT nt_problems_drafts_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_problems_history nt_problems_history_problem_id_nt_problems_problem_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_problems_history
    ADD CONSTRAINT nt_problems_history_problem_id_nt_problems_problem_id_fk FOREIGN KEY (problem_id) REFERENCES public.nt_problems(problem_id) ON DELETE CASCADE;


--
-- Name: nt_problems_history nt_problems_history_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_problems_history
    ADD CONSTRAINT nt_problems_history_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_problems nt_problems_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_problems
    ADD CONSTRAINT nt_problems_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_screens_drafts nt_screens_drafts_created_by_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_screens_drafts
    ADD CONSTRAINT nt_screens_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_screens_drafts nt_screens_drafts_screen_id_nt_screens_screen_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_screens_drafts
    ADD CONSTRAINT nt_screens_drafts_screen_id_nt_screens_screen_id_fk FOREIGN KEY (screen_id) REFERENCES public.nt_screens(screen_id) ON DELETE CASCADE;


--
-- Name: nt_screens_drafts nt_screens_drafts_script_draft_id_nt_scripts_drafts_script_draf; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_screens_drafts
    ADD CONSTRAINT nt_screens_drafts_script_draft_id_nt_scripts_drafts_script_draf FOREIGN KEY (script_draft_id) REFERENCES public.nt_scripts_drafts(script_draft_id) ON DELETE CASCADE;


--
-- Name: nt_screens_drafts nt_screens_drafts_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_screens_drafts
    ADD CONSTRAINT nt_screens_drafts_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_screens_history nt_screens_history_screen_id_nt_screens_screen_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_screens_history
    ADD CONSTRAINT nt_screens_history_screen_id_nt_screens_screen_id_fk FOREIGN KEY (screen_id) REFERENCES public.nt_screens(screen_id) ON DELETE CASCADE;


--
-- Name: nt_screens_history nt_screens_history_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_screens_history
    ADD CONSTRAINT nt_screens_history_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_screens nt_screens_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_screens
    ADD CONSTRAINT nt_screens_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_scripts_drafts nt_scripts_drafts_created_by_user_id_nt_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_scripts_drafts
    ADD CONSTRAINT nt_scripts_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL;


--
-- Name: nt_scripts_drafts nt_scripts_drafts_hospital_id_nt_hospitals_hospital_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_scripts_drafts
    ADD CONSTRAINT nt_scripts_drafts_hospital_id_nt_hospitals_hospital_id_fk FOREIGN KEY (hospital_id) REFERENCES public.nt_hospitals(hospital_id) ON DELETE SET NULL;


--
-- Name: nt_scripts_drafts nt_scripts_drafts_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_scripts_drafts
    ADD CONSTRAINT nt_scripts_drafts_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_scripts_history nt_scripts_history_script_id_nt_scripts_script_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_scripts_history
    ADD CONSTRAINT nt_scripts_history_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE;


--
-- Name: nt_scripts nt_scripts_hospital_id_nt_hospitals_hospital_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_scripts
    ADD CONSTRAINT nt_scripts_hospital_id_nt_hospitals_hospital_id_fk FOREIGN KEY (hospital_id) REFERENCES public.nt_hospitals(hospital_id) ON DELETE SET NULL;


--
-- Name: nt_users nt_users_role_nt_user_roles_name_fk; Type: FK CONSTRAINT; Schema: public; Owner: neotree_webeditor_dev
--

ALTER TABLE ONLY public.nt_users
    ADD CONSTRAINT nt_users_role_nt_user_roles_name_fk FOREIGN KEY (role) REFERENCES public.nt_user_roles(name) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict ElIF706539kg8ikAQPYB70DHYYRhfRZuXe9VkN9RGcQGl7pEHJ9QhfHMzqhTfpr

