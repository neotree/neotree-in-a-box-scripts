CREATE TABLE IF NOT EXISTS public.sessions (
    id integer PRIMARY KEY,
    uid text,
    ingested_at timestamp without time zone,
    scriptid text,
    synced_to_ehr boolean DEFAULT false,
    data jsonb,
    unique_key character varying
);
