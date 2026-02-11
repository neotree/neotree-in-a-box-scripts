ALTER TABLE public.impilo_sessions 
    ALTER COLUMN id SET DEFAULT nextval('public.impilo_sessions_id_seq');

ALTER TABLE public.sessions 
    ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq');