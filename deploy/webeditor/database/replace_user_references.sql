-- Repoint all user foreign-key references to the retained WebEditor admin user.
--
-- Run after demo data is loaded. This is safe for sanitized demo data where
-- user-linked rows are absent or nullable, and it also repairs any remaining
-- non-null user references to the install-time admin user.
--
-- Required psql variable:
--   webeditor_admin_email

SELECT set_config('webeditor.admin_email', :'webeditor_admin_email', false);

DO $$
DECLARE
    target_user_id uuid;
    target_email text;
BEGIN
    target_email := current_setting('webeditor.admin_email');

    SELECT user_id
    INTO target_user_id
    FROM public.nt_users
    WHERE email = target_email;

    IF target_user_id IS NULL THEN
        RAISE EXCEPTION 'Cannot replace user references: no nt_users row found for %', target_email;
    END IF;

    UPDATE public.nt_auth_clients
    SET user_id = target_user_id
    WHERE user_id IS NOT NULL
      AND user_id IS DISTINCT FROM target_user_id;

    UPDATE public.nt_change_logs
    SET user_id = target_user_id
    WHERE user_id IS DISTINCT FROM target_user_id;

    UPDATE public.nt_config_keys_drafts
    SET created_by_user_id = target_user_id
    WHERE created_by_user_id IS NOT NULL
      AND created_by_user_id IS DISTINCT FROM target_user_id;

    UPDATE public.nt_data_keys_drafts
    SET created_by_user_id = target_user_id
    WHERE created_by_user_id IS NOT NULL
      AND created_by_user_id IS DISTINCT FROM target_user_id;

    UPDATE public.nt_diagnoses_drafts
    SET created_by_user_id = target_user_id
    WHERE created_by_user_id IS NOT NULL
      AND created_by_user_id IS DISTINCT FROM target_user_id;

    UPDATE public.nt_drugs_library_drafts
    SET created_by_user_id = target_user_id
    WHERE created_by_user_id IS NOT NULL
      AND created_by_user_id IS DISTINCT FROM target_user_id;

    UPDATE public.nt_files
    SET owner_id = target_user_id
    WHERE owner_id IS NOT NULL
      AND owner_id IS DISTINCT FROM target_user_id;

    UPDATE public.nt_hospitals_drafts
    SET created_by_user_id = target_user_id
    WHERE created_by_user_id IS NOT NULL
      AND created_by_user_id IS DISTINCT FROM target_user_id;

    UPDATE public.nt_pending_deletion
    SET created_by_user_id = target_user_id
    WHERE created_by_user_id IS NOT NULL
      AND created_by_user_id IS DISTINCT FROM target_user_id;

    UPDATE public.nt_problems_drafts
    SET created_by_user_id = target_user_id
    WHERE created_by_user_id IS NOT NULL
      AND created_by_user_id IS DISTINCT FROM target_user_id;

    UPDATE public.nt_screens_drafts
    SET created_by_user_id = target_user_id
    WHERE created_by_user_id IS NOT NULL
      AND created_by_user_id IS DISTINCT FROM target_user_id;

    UPDATE public.nt_scripts_drafts
    SET created_by_user_id = target_user_id
    WHERE created_by_user_id IS NOT NULL
      AND created_by_user_id IS DISTINCT FROM target_user_id;

    -- Present in the current Drizzle model, but absent from demo_data.sql.
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = 'nt_tokens'
          AND column_name = 'user_id'
    ) THEN
        EXECUTE
            'UPDATE public.nt_tokens
             SET user_id = $1
             WHERE user_id IS NOT NULL
               AND user_id IS DISTINCT FROM $1'
        USING target_user_id;
    END IF;
END $$;
