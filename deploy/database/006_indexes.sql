CREATE UNIQUE INDEX IF NOT EXISTS idx_impilo_uid_scriptid_date 
ON public.impilo_sessions (uid, scriptid, date("time"));