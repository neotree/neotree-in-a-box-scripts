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
    user_ref record;
BEGIN
    target_email := current_setting('webeditor.admin_email');

    SELECT user_id
    INTO target_user_id
    FROM public.nt_users
    WHERE email = target_email;

    IF target_user_id IS NULL THEN
        RAISE EXCEPTION 'Cannot replace user references: no nt_users row found for %', target_email;
    END IF;

    FOR user_ref IN
        SELECT
            ns.nspname AS table_schema,
            c.relname AS table_name,
            a.attname AS column_name,
            a.attnotnull AS not_null
        FROM pg_constraint con
        JOIN pg_class c ON c.oid = con.conrelid
        JOIN pg_namespace ns ON ns.oid = c.relnamespace
        JOIN pg_attribute a ON a.attrelid = con.conrelid AND a.attnum = con.conkey[1]
        WHERE con.contype = 'f'
          AND con.confrelid = 'public.nt_users'::regclass
          AND con.confkey = ARRAY[
              (
                  SELECT attnum
                  FROM pg_attribute
                  WHERE attrelid = 'public.nt_users'::regclass
                    AND attname = 'user_id'
                    AND NOT attisdropped
              )
          ]
          AND array_length(con.conkey, 1) = 1
    LOOP
        IF user_ref.not_null THEN
            EXECUTE format(
                'UPDATE %I.%I SET %I = $1 WHERE %I IS DISTINCT FROM $1',
                user_ref.table_schema,
                user_ref.table_name,
                user_ref.column_name,
                user_ref.column_name
            )
            USING target_user_id;
        ELSE
            EXECUTE format(
                'UPDATE %I.%I SET %I = $1 WHERE %I IS NOT NULL AND %I IS DISTINCT FROM $1',
                user_ref.table_schema,
                user_ref.table_name,
                user_ref.column_name,
                user_ref.column_name,
                user_ref.column_name
            )
            USING target_user_id;
        END IF;
    END LOOP;

END $$;
