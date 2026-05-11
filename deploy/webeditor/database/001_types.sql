DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'change_log_action') THEN
    CREATE TYPE public.change_log_action AS ENUM (
      'create',
      'update',
      'delete',
      'publish',
      'restore',
      'rollback',
      'merge'
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'change_log_entity') THEN
    CREATE TYPE public.change_log_entity AS ENUM (
      'script',
      'screen',
      'diagnosis',
      'config_key',
      'drugs_library',
      'data_key',
      'alias',
      'hospital',
      'release'
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'dff_item_validation_type') THEN
    CREATE TYPE public.dff_item_validation_type AS ENUM (
      'default',
      'condition'
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'drug_type') THEN
    CREATE TYPE public.drug_type AS ENUM (
      'drug',
      'fluid',
      'feed'
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'list_style') THEN
    CREATE TYPE public.list_style AS ENUM (
      'none',
      'number',
      'bullet'
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'mailer_service') THEN
    CREATE TYPE public.mailer_service AS ENUM (
      'gmail',
      'smtp'
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'role_name') THEN
    CREATE TYPE public.role_name AS ENUM (
      'user',
      'admin',
      'super_user'
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'screen_type') THEN
    CREATE TYPE public.screen_type AS ENUM (
      'diagnosis',
      'checklist',
      'form',
      'management',
      'multi_select',
      'single_select',
      'progress',
      'timer',
      'yesno',
      'drugs',
      'zw_edliz_summary_table',
      'mwi_edliz_summary_table',
      'fluids',
      'feeds',
      'problems'
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'script_type') THEN
    CREATE TYPE public.script_type AS ENUM (
      'admission',
      'discharge',
      'neolab',
      'drecord',
      'dff_calculator'
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'site_env') THEN
    CREATE TYPE public.site_env AS ENUM (
      'production',
      'stage',
      'development',
      'demo'
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'site_type') THEN
    CREATE TYPE public.site_type AS ENUM (
      'nodeapi',
      'webeditor'
    );
  END IF;
END
$$;
