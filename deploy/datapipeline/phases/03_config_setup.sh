set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"
source "$(dirname "$0")/../../lib/prompt.sh"
source "$(dirname "$0")/../../lib/checks.sh"
source "$(dirname "$0")/../../lib/global_env.sh"

APP_ROOT="${APP_ROOT:-$HOME/neotree}"
APP_DIR="${APP_DIR:-$APP_ROOT/datapipeline}"
CONF_DIR="$APP_DIR/conf/local"
DB_FILE="$CONF_DIR/database.ini"
HOSP_FILE="$CONF_DIR/hospitals.ini"
NODE_ENV_FILE="${NODE_ENV_FILE:-$APP_ROOT/node-api/.env}"
WEBEDITOR_ENV_FILE="${WEBEDITOR_ENV_FILE:-$APP_ROOT/neotree-editor/.env}"

if [ ! -d "$APP_DIR" ]; then
  log_error "Datapipeline directory not found: $APP_DIR. Run clone phase first."
  exit 1
fi

mkdir -p "$CONF_DIR"

prompt() {
  local label="$1" default_value="${2:-}" input
  if [ -t 0 ]; then
    if [ -n "$default_value" ]; then
      read -p "$label [$default_value]: " input || true
      echo "${input:-$default_value}"
    else
      read -p "$label: " input || true
      echo "$input"
    fi
  else
    echo "$default_value"
  fi
}

lowercase() { echo "$1" | tr 'A-Z' 'a-z'; }

backup_if_exists() {
  local file="$1"
  if [ -f "$file" ]; then
    local backup="${file}.bak_$(date +%Y%m%d_%H%M%S)"
    cp "$file" "$backup"
    log_warn "Existing $(basename "$file") backed up to $backup"
  fi
}

ini_get() {
  local file="$1" key="$2"
  [ -f "$file" ] || return 1
  awk -F '=' -v k="$key" '
    $1 ~ "^[[:space:]]*" k "[[:space:]]*$" {
      value=$2
      sub(/^[[:space:]]*/, "", value)
      sub(/[[:space:]]*$/, "", value)
      print value
    }
  ' "$file" | tail -n 1
}

default_host="localhost"
default_db="${NODE_API_DB_NAME:-node_api}"
default_user="neotree_app"
default_password=""
default_country="${DATAPIPELINE_COUNTRY:-malawi}"
default_cron_dir="$APP_DIR/"
default_webeditor="http://localhost:3001"
default_webeditor_key=""
default_hospital_code="${DATAPIPELINE_HOSPITAL_CODE:-TH}"
default_hospital_name="${DATAPIPELINE_HOSPITAL_NAME:-Test Hospital}"
default_admission_script_id="${DATAPIPELINE_ADMISSION_SCRIPT_ID:-e0f80463-276f-4b3d-b58b-6561eac49d66}"
default_discharge_script_id="${DATAPIPELINE_DISCHARGE_SCRIPT_ID:-1fca161e-825b-41ac-bada-4b6209ebb8fe}"

generate_secret() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 24
  else
    od -An -N24 -tx1 /dev/urandom | tr -d ' \n'
  fi
}

ensure_datapipeline_database() {
  local esc_user esc_db esc_pw db_exists
  esc_user="$DB_USER"
  esc_db="$DB_NAME"
  esc_pw="${DB_PASSWORD//\'/\'\'}"

  if ! echo "$esc_user" | grep -Eq '^[A-Za-z0-9_]+$' || ! echo "$esc_db" | grep -Eq '^[A-Za-z0-9_]+$'; then
    log_error "Database user and name must use only letters, numbers, or underscores."
    return 1
  fi

  if ! id -u postgres >/dev/null 2>&1; then
    log_warn "System user 'postgres' not found; skipping datapipeline database creation"
    return 0
  fi

  if ! sudo -u postgres psql -v ON_ERROR_STOP=1 <<SQL
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$esc_user') THEN
    CREATE ROLE "$esc_user" LOGIN PASSWORD '$esc_pw' NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOINHERIT;
  END IF;
END
\$\$;

ALTER ROLE "$esc_user" WITH LOGIN PASSWORD '$esc_pw' NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOINHERIT;
SQL
  then
    log_warn "Could not ensure shared PostgreSQL user '$esc_user'; continuing with config file generation"
    return 0
  fi

  if ! db_exists="$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='${esc_db}'")"; then
    log_warn "Could not check datapipeline database '$esc_db'; continuing with config file generation"
    return 0
  fi

  if ! echo "$db_exists" | grep -q 1; then
    sudo -u postgres createdb -O "$esc_user" "$esc_db" || {
      log_warn "Could not create datapipeline database '$esc_db'; continuing with config file generation"
      return 0
    }
  fi

  sudo -u postgres psql -v ON_ERROR_STOP=1 <<SQL
ALTER DATABASE "$esc_db" OWNER TO "$esc_user";
REVOKE ALL ON DATABASE "$esc_db" FROM PUBLIC;
GRANT CONNECT, TEMP ON DATABASE "$esc_db" TO "$esc_user";
SQL
}

query_webeditor_script_id() {
  local script_type="$1"
  local pgdatabase pguser pghost pgport pgpassword pgsslmode order_sql

  [ -f "$WEBEDITOR_ENV_FILE" ] || return 1
  command -v psql >/dev/null 2>&1 || return 1

  pgdatabase="$(dotenv_get "$WEBEDITOR_ENV_FILE" PGDATABASE || true)"
  pguser="$(dotenv_get "$WEBEDITOR_ENV_FILE" PGUSER || true)"
  pghost="$(dotenv_get "$WEBEDITOR_ENV_FILE" PGHOST || true)"
  pgport="$(dotenv_get "$WEBEDITOR_ENV_FILE" PGPORT || true)"
  pgpassword="$(dotenv_get "$WEBEDITOR_ENV_FILE" PGPASSWORD || true)"
  pgsslmode="$(dotenv_get "$WEBEDITOR_ENV_FILE" PGSSLMODE || true)"

  [ -n "$pgdatabase" ] && [ -n "$pguser" ] && [ -n "$pghost" ] && [ -n "$pgport" ] && [ -n "$pgpassword" ] || return 1

  case "$script_type" in
    admission)
      order_sql="CASE
        WHEN old_script_id = '-KO1TK4zMvLhxTw6eKia' THEN 0
        WHEN title = 'Neotree Admission' THEN 1
        WHEN title ILIKE '%malawi%' THEN 2
        ELSE 9
      END"
      ;;
    discharge)
      order_sql="CASE
        WHEN old_script_id = '-KYDiO2BTM4kSGZDVXAO' THEN 0
        WHEN title = 'NeoDischarge' THEN 1
        WHEN title ILIKE '%malawi%' THEN 2
        ELSE 9
      END"
      ;;
    *)
      return 1
      ;;
  esac

  PGPASSWORD="$pgpassword" psql -tAc "
    SELECT script_id::text
    FROM public.nt_scripts
    WHERE type = '$script_type'::public.script_type
      AND deleted_at IS NULL
    ORDER BY $order_sql, id
    LIMIT 1;" \
    "host=$pghost port=$pgport dbname=$pgdatabase user=$pguser sslmode=${pgsslmode:-prefer}" 2>/dev/null | tr -d '[:space:]'
}

write_hospitals_ini() {
  local admission_script_id discharge_script_id

  admission_script_id="${DATAPIPELINE_ADMISSION_SCRIPT_ID:-}"
  discharge_script_id="${DATAPIPELINE_DISCHARGE_SCRIPT_ID:-}"

  if [ -z "$admission_script_id" ]; then
    admission_script_id="$(query_webeditor_script_id admission || true)"
  fi
  if [ -z "$discharge_script_id" ]; then
    discharge_script_id="$(query_webeditor_script_id discharge || true)"
  fi

  admission_script_id="${admission_script_id:-$default_admission_script_id}"
  discharge_script_id="${discharge_script_id:-$default_discharge_script_id}"

  cat > "$HOSP_FILE" <<EOF
[$default_hospital_code]
name= $default_hospital_name
country= $DB_COUNTRY
admissions = $admission_script_id
discharges = $discharge_script_id
EOF
}

if [ -f "$NODE_ENV_FILE" ]; then
  node_pg_db="$(dotenv_get "$NODE_ENV_FILE" PGDATABASE || true)"
  [ -n "$node_pg_db" ] && default_db="$node_pg_db"
fi

if ! load_shared_pg_env; then
  if [ -f "$NODE_ENV_FILE" ]; then
    log_info "Loading defaults from $NODE_ENV_FILE"
    node_pg_host="$(dotenv_get "$NODE_ENV_FILE" PGHOST || true)"
    node_pg_user="$(dotenv_get "$NODE_ENV_FILE" PGUSER || true)"
    node_pg_pass="$(dotenv_get "$NODE_ENV_FILE" PGPASSWORD || true)"

    [ -n "$node_pg_host" ] && default_host="$node_pg_host"
    [ -n "$node_pg_user" ] && default_user="$node_pg_user"
    [ -n "$node_pg_pass" ] && default_password="$node_pg_pass"
  else
    log_warn "Global .env and node-api .env not found; using fallback defaults"
  fi
else
  [ -n "$PGHOST" ] && default_host="$PGHOST"
  [ -n "$PGUSER" ] && default_user="$PGUSER"
  [ -n "$PGPASSWORD" ] && default_password="$PGPASSWORD"
fi

if [ -f "$WEBEDITOR_ENV_FILE" ]; then
  log_info "Loading WebEditor defaults from $WEBEDITOR_ENV_FILE"
  webeditor_port="$(dotenv_get "$WEBEDITOR_ENV_FILE" PORT || true)"
  webeditor_server_port="$(dotenv_get "$WEBEDITOR_ENV_FILE" SERVER_PORT || true)"
  webeditor_api_key="$(dotenv_get "$WEBEDITOR_ENV_FILE" API_KEY || true)"

  default_webeditor="http://localhost:${webeditor_port:-${webeditor_server_port:-3001}}"
  [ -n "$webeditor_api_key" ] && default_webeditor_key="$webeditor_api_key"
fi

if [ -f "$DB_FILE" ]; then
  if confirm "database.ini already exists. Recreate it now?"; then
    backup_if_exists "$DB_FILE"
  else
    log_info "Keeping existing database.ini"
    if [ ! -f "$HOSP_FILE" ]; then
      DB_COUNTRY="$(ini_get "$DB_FILE" country || true)"
      DB_COUNTRY="${DB_COUNTRY:-$default_country}"
      log_info "Creating hospitals.ini"
      write_hospitals_ini
    fi
    exit 0
  fi
fi

while true; do
  DB_HOST="$default_host"
  DB_NAME="$default_db"
  DB_USER="$default_user"
  DB_PASSWORD="${default_password:-$(generate_secret)}"
  log_info "Auto-configured datapipeline database '$DB_NAME' with shared PostgreSQL user '$DB_USER'"

  country_input="$(prompt "Country (zimbabwe/malawi)" "$default_country")"
  country_input="$(lowercase "$country_input")"
  case "$country_input" in
    zimbabwe|malawi)
      DB_COUNTRY="$country_input"
      ;;
    *)
      log_warn "Unknown country '$country_input', defaulting to zimbabwe"
      DB_COUNTRY="zimbabwe"
      ;;
  esac

  DATA_FIX="$(prompt "Enable data_fix (true/false)" "false")"
  CRON_DIR="${DATAPIPELINE_CRON_DIR:-$default_cron_dir}"
  WEBEDITOR_URL="${WEBEDITOR_URL:-$default_webeditor}"
  WEBEDITOR_API_KEY="${WEBEDITOR_API_KEY:-$default_webeditor_key}"
  break
done

ensure_datapipeline_database || true

backup_if_exists "$DB_FILE"
cat > "$DB_FILE" <<EOF
[postgresql_dev]
host = $DB_HOST
database= $DB_NAME
user= $DB_USER
password= $DB_PASSWORD
country = $DB_COUNTRY
cron_dir = $CRON_DIR
data_fix = $DATA_FIX
webeditor = $WEBEDITOR_URL
webeditor_api_key = $WEBEDITOR_API_KEY
EOF

if [ ! -f "$HOSP_FILE" ]; then
  log_info "Creating hospitals.ini"
  write_hospitals_ini
fi

log_success "database.ini and hospitals.ini ready under $CONF_DIR"
