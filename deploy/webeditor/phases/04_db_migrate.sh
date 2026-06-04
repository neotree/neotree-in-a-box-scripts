set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"
source "$(dirname "$0")/../../lib/prompt.sh"

APP_DIR="${APP_DIR:-$HOME/neotree/neotree-editor}"
ENV_FILE="${ENV_FILE:-$APP_DIR/.env}"
DB_DIR="$(dirname "$0")/../database"
LOG_DIR="$(dirname "$0")/../logs"

if [ "${SKIP_DB_MIGRATIONS:-0}" = "1" ]; then
  log_warn "Skipping database migrations (SKIP_DB_MIGRATIONS=1)"
  exit 0
fi

if [ ! -f "$ENV_FILE" ]; then
  log_error ".env not found at $ENV_FILE"
  exit 1
fi

if [ ! -d "$DB_DIR" ]; then
  log_error "Database scripts directory not found: $DB_DIR"
  exit 1
fi

mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/db_migrate_$(date +%Y%m%d_%H%M%S).log"
LOCK_FILE="$LOG_DIR/db_migrate.lock"

exec 9>"$LOCK_FILE"
if ! flock -n 9; then
  log_error "Another migration appears to be running (lock: $LOCK_FILE)"
  exit 1
fi

dotenv_read_var "$ENV_FILE" PGDATABASE ""
dotenv_read_var "$ENV_FILE" PGUSER ""
dotenv_read_var "$ENV_FILE" PGHOST ""
dotenv_read_var "$ENV_FILE" PGPORT ""
dotenv_read_var "$ENV_FILE" PGPASSWORD ""
dotenv_read_var "$ENV_FILE" PGSSLMODE "prefer"
dotenv_read_var "$ENV_FILE" API_KEY ""

if [ -z "${PGDATABASE:-}" ] || [ -z "${PGUSER:-}" ] || [ -z "${PGHOST:-}" ] || [ -z "${PGPORT:-}" ] || [ -z "${PGPASSWORD:-}" ]; then
  log_error "Missing required PG* variables for migration"
  exit 1
fi

if [ -z "${API_KEY:-}" ]; then
  log_error "Missing API_KEY in $ENV_FILE. Run WebEditor env setup before migrations."
  exit 1
fi

log_info "Running database scripts from $DB_DIR"
log_info "Migration log: $LOG_FILE"

if [ "${DRY_RUN:-0}" = "1" ]; then
  log_warn "DRY_RUN=1 set. Listing SQL files only."
fi

PG_CONN="host=$PGHOST port=$PGPORT dbname=$PGDATABASE user=$PGUSER sslmode=$PGSSLMODE"

PGPASSWORD="${PGPASSWORD:-}" psql -v ON_ERROR_STOP=1 \
  "$PG_CONN" \
  -c "SELECT 1;" >/dev/null 2>&1 || {
    log_error "Cannot connect to database with provided credentials"
    exit 1
  }

PGPASSWORD="${PGPASSWORD:-}" psql -v ON_ERROR_STOP=1 \
  "$PG_CONN" \
  -c "CREATE TABLE IF NOT EXISTS schema_migrations (filename TEXT PRIMARY KEY, applied_at TIMESTAMPTZ DEFAULT now());" \
  2>&1 | tee -a "$LOG_FILE"

migration_applied() {
  local fname="$1"
  local fname_escaped="${fname//\'/\'\'}"

  PGPASSWORD="${PGPASSWORD:-}" psql -tAc \
    "SELECT 1 FROM schema_migrations WHERE filename='$fname_escaped' LIMIT 1;" \
    "$PG_CONN"
}

mark_migration_applied() {
  local fname="$1"
  local fname_escaped="${fname//\'/\'\'}"

  PGPASSWORD="${PGPASSWORD:-}" psql -v ON_ERROR_STOP=1 \
    "$PG_CONN" \
    -c "INSERT INTO schema_migrations(filename) VALUES ('$fname_escaped') ON CONFLICT (filename) DO NOTHING;" \
    2>&1 | tee -a "$LOG_FILE"
}

apply_sql_file() {
  local file="$1"
  local fname
  local status
  fname="$(migration_name_for_file "$file")"

  if [ "$(migration_applied "$fname")" = "1" ]; then
    log_info "Skipping $fname (already applied)"
    return 0
  fi

  if [ "$fname" = "demo_data.sql" ]; then
    case "$(demo_data_state)" in
      loaded)
        log_info "Skipping $fname (demo data already present)"
        mark_migration_applied "$fname"
        return 0
        ;;
      partial)
        log_error "Some demo data is already present, but the seed appears incomplete. Refusing to re-apply $fname because it would duplicate rows."
        log_error "Restore from backup or clean the WebEditor database before retrying."
        exit 1
        ;;
    esac
  fi

  if [ "${DRY_RUN:-0}" = "1" ]; then
    log_info "Would apply $fname"
    return 0
  fi

  log_info "Applying $fname"
  if [[ "$file" == *.gz ]]; then
    gzip -dc "$file" | PGPASSWORD="${PGPASSWORD:-}" psql -v ON_ERROR_STOP=1 --single-transaction "$PG_CONN" 2>&1 | tee -a "$LOG_FILE"
    status=("${PIPESTATUS[@]}")
  else
    PGPASSWORD="${PGPASSWORD:-}" psql -v ON_ERROR_STOP=1 \
      --single-transaction \
      "$PG_CONN" \
      -f "$file" 2>&1 | tee -a "$LOG_FILE"
    status=("${PIPESTATUS[@]}")
  fi
  if [ "${status[0]}" -ne 0 ] || { [ "${#status[@]}" -gt 1 ] && [ "${status[1]}" -ne 0 ]; }; then
    log_error "Failed on $fname. See $LOG_FILE"
    exit 1
  fi

  mark_migration_applied "$fname"
}

apply_manual_sql_file() {
  local file="$1"
  local fname
  fname="manual_migrations/$(basename "$file")"

  if [ "$(migration_applied "$fname")" = "1" ]; then
    log_info "Skipping $fname (already applied)"
    return 0
  fi

  if [ "${DRY_RUN:-0}" = "1" ]; then
    log_info "Would apply $fname"
    return 0
  fi

  log_info "Applying $fname"
  PGPASSWORD="${PGPASSWORD:-}" psql -v ON_ERROR_STOP=1 \
    --single-transaction \
    "$PG_CONN" \
    -f "$file" 2>&1 | tee -a "$LOG_FILE"
  if [ "${PIPESTATUS[0]}" -ne 0 ]; then
    log_error "Failed on $fname. See $LOG_FILE"
    exit 1
  fi

  mark_migration_applied "$fname"
}

apply_manual_migrations() {
  local manual_dir="$APP_DIR/manual_migrations"
  local manual_files

  if [ ! -d "$manual_dir" ]; then
    log_info "No WebEditor manual migrations directory found at $manual_dir"
    return 0
  fi

  mapfile -t manual_files < <(find "$manual_dir" -maxdepth 1 -type f -name "*.sql" | sort)
  if [ "${#manual_files[@]}" -eq 0 ]; then
    log_info "No WebEditor manual migration SQL files found in $manual_dir"
    return 0
  fi

  log_info "Running WebEditor manual migrations from $manual_dir"
  for file in "${manual_files[@]}"; do
    apply_manual_sql_file "$file"
  done
}

demo_data_state() {
  PGPASSWORD="${PGPASSWORD:-}" psql -tAc "
    WITH seed_tables AS (
      SELECT 'nt_hospitals'::text AS table_name, to_regclass('public.nt_hospitals') AS rel
      UNION ALL SELECT 'nt_scripts', to_regclass('public.nt_scripts')
      UNION ALL SELECT 'nt_data_keys', to_regclass('public.nt_data_keys')
      UNION ALL SELECT 'nt_screens', to_regclass('public.nt_screens')
    ),
    counts AS (
      SELECT table_name,
             CASE
               WHEN rel IS NULL THEN 0
               ELSE (xpath('/row/count/text()', query_to_xml(format('SELECT count(*) FROM public.%I', table_name), false, true, '')))[1]::text::int
             END AS row_count
      FROM seed_tables
    )
    SELECT CASE
      WHEN bool_and(row_count > 0) THEN 'loaded'
      WHEN bool_or(row_count > 0) THEN 'partial'
      ELSE 'empty'
    END
    FROM counts;" "$PG_CONN"
}

migration_name_for_file() {
  local fname
  fname="$(basename "$1")"
  printf '%s\n' "${fname%.gz}"
}

first_existing_file() {
  local file
  for file in "$@"; do
    if [ -f "$file" ]; then
      printf '%s\n' "$file"
      return 0
    fi
  done
  return 1
}

prompt_required() {
  local var_name="$1"
  local label="$2"
  local value="${!var_name:-}"

  if [ -n "$value" ]; then
    return 0
  fi

  if [ ! -t 0 ]; then
    log_error "Missing $var_name. Set it in the environment for non-interactive deployment."
    exit 1
  fi

  while [ -z "$value" ]; do
    read -r -p "$label: " value
    if [ -z "$value" ]; then
      log_error "$label is required."
    fi
  done

  printf -v "$var_name" '%s' "$value"
}

prompt_password() {
  if [ -n "${WEBEDITOR_ADMIN_PASSWORD:-}" ]; then
    return 0
  fi

  if [ ! -t 0 ]; then
    log_error "Missing WEBEDITOR_ADMIN_PASSWORD. Set it in the environment for non-interactive deployment."
    exit 1
  fi

  local password_one=""
  local password_two=""
  while true; do
    password_one="$(prompt_secret "WebEditor admin password")"
    password_two="$(prompt_secret "Confirm WebEditor admin password")"

    if [ -z "$password_one" ]; then
      log_error "WebEditor admin password is required."
    elif [ "$password_one" != "$password_two" ]; then
      log_error "WebEditor admin passwords do not match."
    else
      WEBEDITOR_ADMIN_PASSWORD="$password_one"
      return 0
    fi
  done
}

prompt_webeditor_admin() {
  prompt_webeditor_admin_email
  prompt_password
  prompt_required WEBEDITOR_ADMIN_FIRST_NAME "WebEditor admin first name"
  prompt_required WEBEDITOR_ADMIN_LAST_NAME "WebEditor admin last name"
}

prompt_webeditor_admin_email() {
  prompt_required WEBEDITOR_ADMIN_EMAIL "WebEditor admin email"
  while ! printf '%s' "$WEBEDITOR_ADMIN_EMAIL" | grep -Eq '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'; do
    log_error "WebEditor admin username must be a valid email address."
    WEBEDITOR_ADMIN_EMAIL=""
    prompt_required WEBEDITOR_ADMIN_EMAIL "WebEditor admin email"
  done
}

apply_sql_file_with_admin_vars() {
  local file="$1"
  local fname
  fname="$(basename "$file")"

  if [ "$(migration_applied "$fname")" = "1" ]; then
    log_info "Skipping $fname (already applied)"
    return 0
  fi

  if [ "${DRY_RUN:-0}" = "1" ]; then
    log_info "Would apply $fname"
    return 0
  fi

  log_info "Applying $fname"
  PGPASSWORD="${PGPASSWORD:-}" psql -v ON_ERROR_STOP=1 \
    -v webeditor_admin_email="${WEBEDITOR_ADMIN_EMAIL:-}" \
    -v webeditor_admin_password="${WEBEDITOR_ADMIN_PASSWORD:-}" \
    -v webeditor_admin_first_name="${WEBEDITOR_ADMIN_FIRST_NAME:-}" \
    -v webeditor_admin_last_name="${WEBEDITOR_ADMIN_LAST_NAME:-}" \
    "$PG_CONN" \
    -f "$file" 2>&1 | tee -a "$LOG_FILE"
  if [ "${PIPESTATUS[0]}" -ne 0 ]; then
    log_error "Failed on $fname. See $LOG_FILE"
    exit 1
  fi

  mark_migration_applied "$fname"
}

ensure_webeditor_api_key() {
  if [ "${DRY_RUN:-0}" = "1" ]; then
    log_info "Would seed WebEditor API key"
    return 0
  fi

  log_info "Ensuring WebEditor API key is seeded"
  PGPASSWORD="${PGPASSWORD:-}" psql -v ON_ERROR_STOP=1 \
    -v webeditor_api_key="${API_KEY:-}" \
    "$PG_CONN" 2>&1 <<'SQL' | tee -a "$LOG_FILE"
INSERT INTO public.nt_api_keys (api_key)
SELECT :'webeditor_api_key'
WHERE NOT EXISTS (
  SELECT 1 FROM public.nt_api_keys WHERE api_key = :'webeditor_api_key'
);
SQL
  if [ "${PIPESTATUS[0]}" -ne 0 ]; then
    log_error "Failed to seed WebEditor API key. See $LOG_FILE"
    exit 1
  fi
}

mapfile -t files < <(find "$DB_DIR" -maxdepth 1 -type f -name "[0-9][0-9][0-9]_*.sql" | sort)
if [ "${#files[@]}" -eq 0 ]; then
  log_warn "No numbered SQL migration files found in $DB_DIR"
else
  for file in "${files[@]}"; do
    apply_sql_file "$file"
  done
fi

ensure_webeditor_api_key

special_files=(
  "$DB_DIR/create_user.sql"
)
if demo_data_file="$(first_existing_file "$DB_DIR/demo_data.sql.gz" "$DB_DIR/demo_data.sql")"; then
  special_files+=("$demo_data_file")
else
  special_files+=("$DB_DIR/demo_data.sql.gz")
fi
special_files+=(
  "$DB_DIR/replace_user_references.sql"
)

should_prompt_admin=0
should_prompt_admin_email=0
for file in "${special_files[@]}"; do
  if [ -f "$file" ] && [ "$(migration_applied "$(migration_name_for_file "$file")")" != "1" ]; then
    case "$(migration_name_for_file "$file")" in
      create_user.sql)
        should_prompt_admin=1
        ;;
      replace_user_references.sql)
        should_prompt_admin_email=1
        ;;
    esac
  fi
done

if [ "$should_prompt_admin" = "1" ]; then
  if [ "${DRY_RUN:-0}" = "1" ]; then
    log_info "Would prompt for WebEditor admin user details"
  else
    prompt_webeditor_admin
  fi
elif [ "$should_prompt_admin_email" = "1" ]; then
  if [ "${DRY_RUN:-0}" = "1" ]; then
    log_info "Would prompt for WebEditor admin email"
  else
    prompt_webeditor_admin_email
  fi
fi

for file in "${special_files[@]}"; do
  if [ ! -f "$file" ]; then
    log_warn "Optional SQL file not found: $file"
    continue
  fi

  case "$(migration_name_for_file "$file")" in
    create_user.sql|replace_user_references.sql)
      apply_sql_file_with_admin_vars "$file"
      ;;
    *)
      apply_sql_file "$file"
      ;;
  esac
done

apply_manual_migrations

log_success "Database scripts completed successfully"
