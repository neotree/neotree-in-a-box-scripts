-- Create or update the WebEditor admin user.
--
-- Required psql variables:
--   webeditor_admin_email
--   webeditor_admin_password
--   webeditor_admin_first_name
--   webeditor_admin_last_name

INSERT INTO public.nt_user_roles (id, name, description) VALUES
    (1, 'user', 'Default user'),
    (2, 'admin', 'Admin user'),
    (3, 'super_user', 'Super user')
ON CONFLICT (name) DO UPDATE
SET description = EXCLUDED.description;

SELECT pg_catalog.setval(
    'public.nt_user_roles_id_seq',
    GREATEST((SELECT COALESCE(max(id), 1) FROM public.nt_user_roles), 1),
    true
);

WITH user_input AS (
    SELECT
        :'webeditor_admin_email'::text AS email,
        :'webeditor_admin_password'::text AS plain_password,
        (:'webeditor_admin_first_name'::text || ' ' || :'webeditor_admin_last_name'::text) AS display_name,
        :'webeditor_admin_first_name'::text AS first_name,
        :'webeditor_admin_last_name'::text AS last_name,
        'super_user'::public.role_name AS role
)
INSERT INTO public.nt_users (
    user_id,
    role,
    email,
    password,
    display_name,
    first_name,
    last_name,
    activation_date,
    created_at,
    updated_at
)
SELECT
    gen_random_uuid(),
    role,
    email,
    crypt(plain_password, gen_salt('bf', 10)),
    display_name,
    first_name,
    last_name,
    now(),
    now(),
    now()
FROM user_input
ON CONFLICT (email) DO UPDATE
SET
    role = EXCLUDED.role,
    password = EXCLUDED.password,
    display_name = EXCLUDED.display_name,
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    activation_date = COALESCE(public.nt_users.activation_date, now()),
    updated_at = now();
