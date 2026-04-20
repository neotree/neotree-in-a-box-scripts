ALTER TABLE public.sessions 
    ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq');
