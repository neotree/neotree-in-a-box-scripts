set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"

APP_ROOT="${APP_ROOT:-$HOME/neotree}"
APP_DIR="${APP_DIR:-$APP_ROOT/neotree-editor}"
ENV_FILE="${ENV_FILE:-$APP_DIR/.env}"
EXAMPLE_FILE="${EXAMPLE_FILE:-$APP_DIR/.env-example}"

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

prompt_secret() {
  local label="$1"
  local value
  if [ ! -t 0 ]; then
    log_error "Non-interactive shell cannot prompt for secrets."
    return 1
  fi
  read -s -p "$label: " value
  printf '\n' >&2
  dotenv_sanitize_value "$value"
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
    dotenv_write_var API_KEY "${API_KEY:-}"
    dotenv_write_var DEBUG "${DEBUG:-}"
    dotenv_write_var DB_LOGGING "${DB_LOGGING:-}"
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
  dotenv_read_var "$ENV_FILE" API_KEY ""
  dotenv_read_var "$ENV_FILE" DEBUG ""
  dotenv_read_var "$ENV_FILE" DB_LOGGING ""
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
    [ -n "${API_KEY:-}" ] &&
    [ -n "${POSTGRES_DB_URL:-}" ]
    [ -n "${NEXT_PUBLIC_APP_NAME:-}" ] &&
    [ -n "${NEXT_PUBLIC_APP_URL:-}" ]
    [ -n "${NEXTAUTH_URL:-}" ] &&
    [ -n "${NEXTAUTH_SECRET:-}" ]
    [ -n "${JWT_SECRET:-}" ]
}

prompt_db_values() {
  NEOTREE_SERVER_TYPE="$(prompt_required "NEOTREE_SERVER_TYPE (production | stage | development)" "${PNEOTREE_SERVER_TYPET:production}")"
  NODE_ENV="$(prompt_required "NODE_ENV" "${NODE_ENV:production}")"
  NEOTREE_ENV="$(prompt_required "NEOTREE_ENV" "${NEOTREE_ENV:-}")"
  HOSTNAME="$(prompt_required "HOSTNAME (development | stage | demo | production)" "${HOSTNAME:production}")"
  PORT="$(prompt_required "PORT" "${PORT:3000}")"
  API_KEY="$(prompt_required "API_KEY" "${API_KEY:-}")"
  POSTGRES_DB_URL="$(prompt_required "POSTGRES_DB_URL (postgres://<dbuser>:<dbpass>@localhost:5432/<dbname>)" "${POSTGRES_DB_URL:-}")"
  NEXT_PUBLIC_APP_NAME="$(prompt_required "NEXT_PUBLIC_APP_NAME" "${NEXT_PUBLIC_APP_NAME:-}")"
  NEXT_PUBLIC_APP_URL="$(prompt_required "NEXT_PUBLIC_APP_URL" "${NEXT_PUBLIC_APP_URL:Neotree}")"
  NEXTAUTH_URL="$(prompt_required "NEXTAUTH_URL" "${NEXTAUTH_URL:http://localhost:3000}")"
  NEXTAUTH_SECRET="$(prompt_required "NEXTAUTH_SECRET" "${NEXTAUTH_SECRET:-}")"
  JWT_SECRET="$(prompt_required "JWT_SECRET" "${JWT_SECRET:-}")"
}

prompt_email_values() {
  if confirm "Configure email server variables now?"; then
    MAIL_MAILER="$(prompt_required "MAIL_MAILER (e.g. smtp)" "${MAIL_MAILER:-}")"
    MAIL_HOST="$(prompt_required "MAIL_HOST" "${MAIL_HOST:-}")"
    MAIL_PORT="$(prompt_required "MAIL_PORT" "${MAIL_PORT:-587}")"
    MAIL_USERNAME="$(prompt_required "MAIL_USERNAME" "${MAIL_USERNAME:-}")"
    if [ -n "${MAIL_PASSWORD:-}" ]; then
      local old_mail_pw new_mail_pw
      old_mail_pw="$MAIL_PASSWORD"
      new_mail_pw="$(prompt_secret "MAIL_PASSWORD (press enter to keep existing)")"
      MAIL_PASSWORD="${new_mail_pw:-$old_mail_pw}"
    else
      MAIL_PASSWORD="$(prompt_secret "MAIL_PASSWORD")"
      if [ -z "$MAIL_PASSWORD" ]; then
        log_error "MAIL_PASSWORD is required."
        exit 1
      fi
    fi
    MAIL_ENCRYPTION="$(prompt_required "MAIL_ENCRYPTION (e.g. tls)" "${MAIL_ENCRYPTION:-}")"
    MAIL_FROM_ADDRESS="$(prompt_required "MAIL_FROM_ADDRESS" "${MAIL_FROM_ADDRESS:-}")"
    MAIL_FROM_NAME="$(prompt_required "MAIL_FROM_NAME" "${MAIL_FROM_NAME:-}")"
    MAIL_RECEIVERS="$(prompt_required "MAIL_RECEIVERS (comma-separated)" "${MAIL_RECEIVERS:-}")"
  else
    log_warn "Skipping email configuration"
  fi
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

  sudo -u postgres psql -v ON_ERROR_STOP=1 <<SQL
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$esc_user') THEN
    CREATE ROLE "$esc_user" LOGIN PASSWORD '$esc_pw' NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOINHERIT;
  END IF;
END
\$\$;

ALTER ROLE "$esc_user" WITH LOGIN PASSWORD '$esc_pw' NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOINHERIT;
SQL

  if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='${esc_db}'" | grep -q 1; then
    sudo -u postgres createdb -O "$esc_user" "$esc_db"
  fi

  sudo -u postgres psql -v ON_ERROR_STOP=1 <<SQL
ALTER DATABASE "$esc_db" OWNER TO "$esc_user";
REVOKE ALL ON DATABASE "$esc_db" FROM PUBLIC;
GRANT CONNECT, TEMP ON DATABASE "$esc_db" TO "$esc_user";
SQL

  validate_db_creds
}

log_info "Configuring environment variables"

WRITE_ENV=0

if [ -f "$ENV_FILE" ]; then
  log_info ".env found at $ENV_FILE"
  load_env_from_file
  if required_db_vars_present; then
    log_success "Existing .env already has required DB settings."
    if confirm "Edit existing .env values?"; then
      prompt_db_values
      prompt_email_values
      WRITE_ENV=1
    else
      log_info "Keeping existing .env values"
    fi
  else
    log_warn ".env is missing required DB settings."
    if confirm "Edit .env and complete required values now?"; then
      prompt_db_values
      prompt_email_values
      WRITE_ENV=1
    else
      log_error "Cannot proceed without required database variables"
      exit 1
    fi
  fi
else
  SERVER_PORT=""
  PGDATABASE=""
  PGUSER=""
  PGPASSWORD=""
  PGPORT=""
  PGHOST=""
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

  prompt_db_values
  prompt_email_values
  WRITE_ENV=1
fi

if ! required_db_vars_present; then
  log_error "Required database variables are missing."
  exit 1
fi

if [ "$WRITE_ENV" -eq 1 ]; then
  write_env_file "$ENV_FILE"
  chmod 600 "$ENV_FILE"
  log_success ".env updated at $ENV_FILE"
fi

if confirm "Create PostgreSQL user and database now? (requires sudo postgres access)"; then
  if create_db_and_user; then
    log_success "PostgreSQL user/database ensured"
  else
    log_error "PostgreSQL provisioning failed"
    exit 1
  fi
else
  log_warn "Skipping PostgreSQL provisioning"
fi

if confirm "Validate database credentials now?"; then
  if validate_db_creds; then
    log_success "Database credentials are valid"
  else
    log_error "Database credential validation failed"
    if confirm "Attempt to create/update PostgreSQL user/database with provided creds?"; then
      if create_db_and_user; then
        log_success "PostgreSQL user/database ensured"
        if validate_db_creds; then
          log_success "Database credentials are valid"
        else
          log_error "Database credential validation failed after provisioning"
          exit 1
        fi
      else
        log_error "PostgreSQL provisioning failed"
        exit 1
      fi
    else
      exit 1
    fi
  fi
else
  log_warn "Skipping database credential validation"
fi
