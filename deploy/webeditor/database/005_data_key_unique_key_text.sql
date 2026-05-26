-- WebEditor data keys can use composite unique_key values such as
-- "<field uuid>_<item uuid>", so these columns must be text rather than uuid.

ALTER TABLE public.nt_data_keys
  ALTER COLUMN unique_key TYPE text USING unique_key::text,
  ALTER COLUMN unique_key SET DEFAULT (md5(random()::text || clock_timestamp()::text)::uuid)::text;

ALTER TABLE public.nt_data_keys_drafts
  ALTER COLUMN unique_key TYPE text USING unique_key::text;
