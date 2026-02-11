DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'impilo_sessions_impilo_uid_key'
    ) THEN
        ALTER TABLE public.impilo_sessions
            ADD CONSTRAINT impilo_sessions_impilo_uid_key UNIQUE (impilo_uid);
    END IF;
END $$;