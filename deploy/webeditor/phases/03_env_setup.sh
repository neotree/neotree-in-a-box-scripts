set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"
source "$(dirname "$0")/../../lib/prompt.sh"
source "$(dirname "$0")/../../lib/global_env.sh"

APP_ROOT="${APP_ROOT:-$HOME/neotree}"
APP_DIR="${APP_DIR:-$APP_ROOT/neotree-editor}"
ENV_FILE="${ENV_FILE:-$APP_DIR/.env}"
EXAMPLE_FILE="${EXAMPLE_FILE:-$APP_DIR/.env-example}"
NODE_ENV_FILE="${NODE_ENV_FILE:-$APP_ROOT/node-api/.env}"
GLOBAL_ENV_FILE="${GLOBAL_ENV_FILE:-$APP_ROOT/.env}"
DEFAULT_PGDATABASE="${WEBEDITOR_DB_NAME:-webeditor}"
DEFAULT_PORT="${WEBEDITOR_PORT:-3001}"
DEFAULT_APP_URL="${WEBEDITOR_APP_URL:-http://localhost:${DEFAULT_PORT}}"

if [ ! -d "$APP_DIR" ]; then
  log_error "App directory not found: $APP_DIR"
  exit 1
fi

prompt() {
  local label="$1"
  local default="${2:-}"
  local value
  if [ -n "$default" ]; then
    read -p "$label [$default]: " value
    echo "${value:-$default}"
  else
    read -p "$label: " value
    echo "$value"
  fi
}

prompt_required() {
  local label="$1"
  local default="${2:-}"
  local value
  while true; do
    value="$(prompt "$label" "$default")"
    if [ -n "$value" ]; then
      echo "$value"
      return 0
    fi
    log_error "This value is required."
  done
}

confirm() {
  if [ "${AUTO_YES:-0}" = "1" ]; then
    log_info "$1 [y/n]: y (AUTO_YES=1)"
    return 0
  fi
  if [ ! -t 0 ]; then
    log_error "Non-interactive shell. Set AUTO_YES=1 to proceed."
    return 1
  fi
  read -p "$1 [y/n]: " yn
  case $yn in
    [Yy]*) return 0 ;;
    *) return 1 ;;
  esac
}

confirm_with_back() {
  if [ "${AUTO_YES:-0}" = "1" ]; then
    log_info "$1 [y/n/b]: y (AUTO_YES=1)"
    return 0
  fi
  if [ ! -t 0 ]; then
    log_error "Non-interactive shell. Set AUTO_YES=1 to proceed."
    return 1
  fi
  read -p "$1 [y/n/b]: " yn
  case $yn in
    [Yy]*) return 0 ;;
    [Bb]*) return 2 ;;
    *) return 1 ;;
  esac
}

require_simple_ident() {
  local label="$1"
  local value="$2"
  if ! echo "$value" | grep -Eq '^[A-Za-z0-9_]+$'; then
    log_error "$label must use only letters, numbers, or underscores."
    exit 1
  fi
}

write_env_file() {
  local file="$1"
  {
    dotenv_write_var NEOTREE_SERVER_TYPE "${NEOTREE_SERVER_TYPE:-}"
    dotenv_write_var NODE_ENV "${NODE_ENV:-}"
    dotenv_write_var NEOTREE_ENV "${NEOTREE_ENV:-}"
    dotenv_write_var HOSTNAME "${HOSTNAME:-}"
    dotenv_write_var PORT "${PORT:-}"
    dotenv_write_var SERVER_PORT "${SERVER_PORT:-${PORT:-}}"
    dotenv_write_var API_KEY "${API_KEY:-}"
    dotenv_write_var DEBUG "${DEBUG:-}"
    dotenv_write_var DB_LOGGING "${DB_LOGGING:-}"
    dotenv_write_var PGDATABASE "${PGDATABASE:-}"
    dotenv_write_var PGUSER "${PGUSER:-}"
    dotenv_write_var PGPASSWORD "${PGPASSWORD:-}"
    dotenv_write_var PGPORT "${PGPORT:-}"
    dotenv_write_var PGHOST "${PGHOST:-}"
    dotenv_write_var POSTGRES_DB_URL "${POSTGRES_DB_URL:-}"
    dotenv_write_var SESSIONS_DB_URL "${SESSIONS_DB_URL:-}"
    dotenv_write_var NEXT_PUBLIC_APP_NAME "${NEXT_PUBLIC_APP_NAME:-}"
    dotenv_write_var NEXT_PUBLIC_APP_URL "${NEXT_PUBLIC_APP_URL:-}"
    dotenv_write_var NEXTAUTH_URL "${NEXTAUTH_URL:-}"
    dotenv_write_var NEXTAUTH_SECRET "${NEXTAUTH_SECRET:-}"
    dotenv_write_var JWT_SECRET "${JWT_SECRET:-}"
    dotenv_write_var MAIL_MAILER "${MAIL_MAILER:-}"
    dotenv_write_var MAIL_HOST "${MAIL_HOST:-}"
    dotenv_write_var MAIL_PORT "${MAIL_PORT:-}"
    dotenv_write_var MAIL_USERNAME "${MAIL_USERNAME:-}"
    dotenv_write_var MAIL_PASSWORD "${MAIL_PASSWORD:-}"
    dotenv_write_var MAIL_ENCRYPTION "${MAIL_ENCRYPTION:-}"
    dotenv_write_var MAIL_FROM_ADDRESS "${MAIL_FROM_ADDRESS:-}"
    dotenv_write_var MAIL_FROM_NAME "${MAIL_FROM_NAME:-}"
  } >"$file"
}

load_env_from_file() {
  dotenv_read_var "$ENV_FILE" NEOTREE_SERVER_TYPE ""
  dotenv_read_var "$ENV_FILE" NODE_ENV ""
  dotenv_read_var "$ENV_FILE" NEOTREE_ENV ""
  dotenv_read_var "$ENV_FILE" HOSTNAME ""
  dotenv_read_var "$ENV_FILE" PORT ""
  dotenv_read_var "$ENV_FILE" SERVER_PORT ""
  dotenv_read_var "$ENV_FILE" API_KEY ""
  dotenv_read_var "$ENV_FILE" DEBUG ""
  dotenv_read_var "$ENV_FILE" DB_LOGGING ""
  dotenv_read_var "$ENV_FILE" PGDATABASE ""
  dotenv_read_var "$ENV_FILE" PGUSER ""
  dotenv_read_var "$ENV_FILE" PGPASSWORD ""
  dotenv_read_var "$ENV_FILE" PGPORT ""
  dotenv_read_var "$ENV_FILE" PGHOST ""
  dotenv_read_var "$ENV_FILE" POSTGRES_DB_URL ""
  dotenv_read_var "$ENV_FILE" SESSIONS_DB_URL ""
  dotenv_read_var "$ENV_FILE" NEXT_PUBLIC_APP_NAME ""
  dotenv_read_var "$ENV_FILE" NEXT_PUBLIC_APP_URL ""
  dotenv_read_var "$ENV_FILE" NEXTAUTH_URL ""
  dotenv_read_var "$ENV_FILE" NEXTAUTH_SECRET ""
  dotenv_read_var "$ENV_FILE" JWT_SECRET ""
  dotenv_read_var "$ENV_FILE" MAIL_MAILER ""
  dotenv_read_var "$ENV_FILE" MAIL_HOST ""
  dotenv_read_var "$ENV_FILE" MAIL_PORT ""
  dotenv_read_var "$ENV_FILE" MAIL_USERNAME ""
  dotenv_read_var "$ENV_FILE" MAIL_PASSWORD ""
  dotenv_read_var "$ENV_FILE" MAIL_ENCRYPTION ""
  dotenv_read_var "$ENV_FILE" MAIL_FROM_ADDRESS ""
  dotenv_read_var "$ENV_FILE" MAIL_FROM_NAME ""
}

required_db_vars_present() {
  [ -n "${NEOTREE_SERVER_TYPE:-}" ] &&
    [ -n "${NODE_ENV:-}" ] &&
    [ -n "${NEOTREE_ENV:-}" ] &&
    [ -n "${HOSTNAME:-}" ] &&
    [ -n "${PORT:-}" ] &&
    [ -n "${PGDATABASE:-}" ] &&
    [ -n "${PGUSER:-}" ] &&
    [ -n "${PGPASSWORD:-}" ] &&
    [ -n "${PGPORT:-}" ] &&
    [ -n "${PGHOST:-}" ] &&
    [ -n "${POSTGRES_DB_URL:-}" ] &&
    [ -n "${NEXT_PUBLIC_APP_NAME:-}" ] &&
    [ -n "${NEXT_PUBLIC_APP_URL:-}" ] &&
    [ -n "${NEXTAUTH_URL:-}" ] &&
    [ -n "${NEXTAUTH_SECRET:-}" ] &&
    [ -n "${JWT_SECRET:-}" ]
}

auto_config_db_values() {
  WRITE_ENV=1
  local node_pg_user node_pg_pass node_pg_host node_pg_port

  if ! load_shared_pg_env && [ -f "$NODE_ENV_FILE" ]; then
    node_pg_user="$(dotenv_get "$NODE_ENV_FILE" PGUSER || true)"
    node_pg_pass="$(dotenv_get "$NODE_ENV_FILE" PGPASSWORD || true)"
    node_pg_host="$(dotenv_get "$NODE_ENV_FILE" PGHOST || true)"
    node_pg_port="$(dotenv_get "$NODE_ENV_FILE" PGPORT || true)"
    PGUSER="${node_pg_user:-}"
    PGPASSWORD="${node_pg_pass:-}"
    PGHOST="${node_pg_host:-}"
    PGPORT="${node_pg_port:-}"
  else
    node_pg_user="${PGUSER:-}"
    node_pg_pass="${PGPASSWORD:-}"
    node_pg_host="${PGHOST:-}"
    node_pg_port="${PGPORT:-}"
  fi

  NEOTREE_SERVER_TYPE="${NEOTREE_SERVER_TYPE:-production}"
  NODE_ENV="${NODE_ENV:-production}"
  NEOTREE_ENV="${NEOTREE_ENV:-production}"
  HOSTNAME="${HOSTNAME:-production}"
  PORT="${PORT:-$DEFAULT_PORT}"
  SERVER_PORT="$PORT"
  API_KEY="${API_KEY:-}"
  DEBUG="${DEBUG:-false}"
  DB_LOGGING="${DB_LOGGING:-false}"
  PGDATABASE="$DEFAULT_PGDATABASE"
  PGUSER="${node_pg_user:-${PGUSER:-neotree_app}}"
  PGPASSWORD="${node_pg_pass:-${PGPASSWORD:-$(generate_secret)}}"
  PGPORT="${node_pg_port:-${PGPORT:-5432}}"
  PGHOST="${node_pg_host:-${PGHOST:-localhost}}"
  POSTGRES_DB_URL="postgres://${PGUSER}:${PGPASSWORD}@${PGHOST}:${PGPORT}/${PGDATABASE}"
  SESSIONS_DB_URL="$POSTGRES_DB_URL"
  NEXT_PUBLIC_APP_NAME="${NEXT_PUBLIC_APP_NAME:-default}"
  NEXT_PUBLIC_APP_URL="${NEXT_PUBLIC_APP_URL:-$DEFAULT_APP_URL}"
  NEXTAUTH_URL="${NEXTAUTH_URL:-$NEXT_PUBLIC_APP_URL}"
  NEXTAUTH_SECRET="${NEXTAUTH_SECRET:-$(generate_secret)}"
  JWT_SECRET="${JWT_SECRET:-$(generate_secret)}"

  require_simple_ident "PGDATABASE" "$PGDATABASE"
  require_simple_ident "PGUSER" "$PGUSER"

  write_shared_pg_env

  log_info "Auto-configured webeditor database '$PGDATABASE' with shared PostgreSQL user '$PGUSER'"
}

validate_db_creds() {
  log_info "Validating database credentials using password auth (host/port)"
  if command -v pg_isready >/dev/null 2>&1; then
    if ! pg_isready -q -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE"; then
      log_warn "pg_isready check failed (server not ready or auth required)"
    fi
  fi
  PGPASSWORD="$PGPASSWORD" psql -v ON_ERROR_STOP=1 \
    "host=$PGHOST port=$PGPORT dbname=$PGDATABASE user=$PGUSER sslmode=${PGSSLMODE:-prefer}" \
    -c "SELECT 1;" >/dev/null
}

postgresql_cluster_exists() {
  command -v pg_lsclusters >/dev/null 2>&1 || return 1
  pg_lsclusters -h 2>/dev/null | awk 'NF >= 2 { found=1 } END { exit(found ? 0 : 1) }'
}

create_postgresql_cluster_if_missing() {
  local version

  if postgresql_cluster_exists; then
    return 0
  fi

  if ! command -v pg_createcluster >/dev/null 2>&1; then
    log_error "PostgreSQL is installed without a cluster, and pg_createcluster is not available."
    return 1
  fi

  version="$(find /usr/lib/postgresql -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort -V | tail -n 1)"
  if [ -z "$version" ]; then
    log_error "PostgreSQL server binaries were not found under /usr/lib/postgresql."
    return 1
  fi

  log_info "Creating PostgreSQL cluster ${version}/main"
  sudo pg_createcluster "$version" main --start
}

start_postgresql_service() {
  local started=1

  create_postgresql_cluster_if_missing || return 1

  if command -v systemctl >/dev/null 2>&1; then
    if sudo systemctl enable --now postgresql >/dev/null 2>&1; then
      started=0
    elif sudo systemctl start postgresql >/dev/null 2>&1; then
      started=0
    fi
  fi

  if [ "$started" -ne 0 ] && command -v service >/dev/null 2>&1; then
    if sudo service postgresql start >/dev/null 2>&1; then
      started=0
    fi
  fi

  if [ "$started" -ne 0 ] && command -v pg_lsclusters >/dev/null 2>&1 && command -v pg_ctlcluster >/dev/null 2>&1; then
    local version cluster port status owner data_dir log_file
    while read -r version cluster port status owner data_dir log_file; do
      [ -n "$version" ] || continue
      if sudo pg_ctlcluster "$version" "$cluster" start >/dev/null 2>&1; then
        started=0
      fi
    done <<EOF
$(pg_lsclusters -h 2>/dev/null || true)
EOF
  fi

  if [ "$started" -eq 0 ]; then
    return 0
  fi

  log_error "Could not start PostgreSQL using systemctl, service, or pg_ctlcluster."
  return 1
}

ensure_postgres_local_ready() {
  if sudo -u postgres psql -v ON_ERROR_STOP=1 -d postgres -c "SELECT 1;" >/dev/null 2>&1; then
    return 0
  fi

  log_warn "PostgreSQL server is not running or is not accepting local connections."

  if command -v systemctl >/dev/null 2>&1 || command -v service >/dev/null 2>&1 || command -v pg_ctlcluster >/dev/null 2>&1; then
    if confirm_with_back "Start PostgreSQL service now? Press b to go back to the previous step."; then
      if ! start_postgresql_service; then
        log_error "Failed to start PostgreSQL service."
        return 1
      fi

      if sudo -u postgres psql -v ON_ERROR_STOP=1 -d postgres -c "SELECT 1;" >/dev/null 2>&1; then
        log_success "PostgreSQL service is running"
        return 0
      fi

      log_error "PostgreSQL still is not accepting local connections after starting the service."
      return 1
    else
      case $? in
        2) return 2 ;;
        *)
          log_info "Start PostgreSQL, then retry this step. On systemd hosts: sudo systemctl enable --now postgresql"
          return 1
          ;;
      esac
    fi
  fi

  log_info "Start PostgreSQL, then retry this step. On systemd hosts: sudo systemctl enable --now postgresql"
  return 1
}

create_db_and_user() {
  local esc_user esc_db esc_pw
  esc_user="$PGUSER"
  esc_db="$PGDATABASE"
  esc_pw="${PGPASSWORD//\'/\'\'}"

  log_info "Creating PostgreSQL user and database (if needed)"
  if ! id -u postgres >/dev/null 2>&1; then
    log_error "System user 'postgres' not found. Install PostgreSQL server or create the user."
    return 1
  fi

  ensure_postgres_local_ready || return $?

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
    log_error "Failed to create or update PostgreSQL role '$esc_user'"
    return 1
  fi

  local db_exists
  if ! db_exists="$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='${esc_db}'")"; then
    log_error "Failed to check whether PostgreSQL database '$esc_db' exists"
    return 1
  fi

  if ! echo "$db_exists" | grep -q 1; then
    if ! sudo -u postgres createdb -O "$esc_user" "$esc_db"; then
      log_error "Failed to create PostgreSQL database '$esc_db'"
      return 1
    fi
  fi

  if ! sudo -u postgres psql -v ON_ERROR_STOP=1 <<SQL
ALTER DATABASE "$esc_db" OWNER TO "$esc_user";
REVOKE ALL ON DATABASE "$esc_db" FROM PUBLIC;
GRANT CONNECT, TEMP ON DATABASE "$esc_db" TO "$esc_user";
SQL
  then
    log_error "Failed to apply permissions for PostgreSQL database '$esc_db'"
    return 1
  fi

  validate_db_creds
}

run_interactive_setup() {
  local stage="${1:-db}"
  local rc

  while true; do
    case "$stage" in
      db)
        auto_config_db_values
        stage="provision"
        ;;
      provision)
        rc=0
        create_db_and_user || rc=$?
        if [ "$rc" -eq 0 ]; then
          log_success "PostgreSQL shared user/database ensured"
          stage="validate"
        elif [ "$rc" -eq 2 ]; then
          log_info "Returning to database values"
          stage="db"
        else
          log_error "PostgreSQL provisioning failed"
          exit 1
        fi
        ;;
      validate)
        if validate_db_creds; then
          log_success "Database credentials are valid"
          break
        fi
        log_error "Database credential validation failed"
        exit 1
        ;;
    esac
  done
}

WRITE_ENV=0
START_STAGE="provision"

if [ -f "$ENV_FILE" ]; then
  log_info ".env found at $ENV_FILE"
  load_env_from_file
  WRITE_ENV=1
  START_STAGE="db"
else
  SERVER_PORT=""
  NEOTREE_SERVER_TYPE=""
  NODE_ENV=""
  NEOTREE_ENV=""
  HOSTNAME=""
  PORT=""
  SERVER_PORT=""
  API_KEY=""
  DEBUG=""
  DB_LOGGING=""
  PGDATABASE=""
  PGUSER=""
  PGPASSWORD=""
  PGPORT=""
  PGHOST=""
  POSTGRES_DB_URL=""
  SESSIONS_DB_URL=""
  NEXT_PUBLIC_APP_NAME=""
  NEXT_PUBLIC_APP_URL=""
  NEXTAUTH_URL=""
  NEXTAUTH_SECRET=""
  JWT_SECRET=""
  MAIL_MAILER=""
  MAIL_HOST=""
  MAIL_PORT=""
  MAIL_USERNAME=""
  MAIL_PASSWORD=""
  MAIL_ENCRYPTION=""
  MAIL_FROM_ADDRESS=""
  MAIL_FROM_NAME=""
  MAIL_RECEIVERS=""

  if [ ! -f "$EXAMPLE_FILE" ]; then
    log_warn ".env-example not found. Proceeding with interactive setup."
  fi
  WRITE_ENV=1
  START_STAGE="db"
fi

log_info "Configuring environment variables"
run_interactive_setup "$START_STAGE"

if ! required_db_vars_present; then
  log_error "Required database variables are missing."
  exit 1
fi

if [ "$WRITE_ENV" -eq 1 ]; then
  write_env_file "$ENV_FILE"
  chmod 600 "$ENV_FILE"
  log_success ".env updated at $ENV_FILE"
fi
