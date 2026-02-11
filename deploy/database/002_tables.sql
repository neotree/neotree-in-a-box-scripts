CREATE TABLE IF NOT EXISTS public.impilo_sessions (
    id integer PRIMARY KEY,
    ingested_at timestamp without time zone DEFAULT now(),
    "time" timestamp without time zone,
    scriptid text,
    uid text,
    unique_key text,
    impilo_id text,
    impilo_uid uuid NOT NULL,
    synced boolean DEFAULT false,
    data text
);

CREATE TABLE IF NOT EXISTS public.sessions (
    id integer PRIMARY KEY,
    uid text,
    ingested_at timestamp without time zone,
    scriptid text,
    synced_to_ehr boolean DEFAULT false,
    data jsonb,
    unique_key character varying
);