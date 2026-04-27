set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"
source "$(dirname "$0")/../../lib/prompt.sh"

APP_ROOT="${APP_ROOT:-$HOME/neotree}"
APP_DIR="${APP_DIR:-$APP_ROOT/node-api}"
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
    dotenv_write_var SERVER_PORT "${SERVER_PORT:-}"
    dotenv_write_var PGDATABASE "${PGDATABASE:-}"
    dotenv_write_var PGUSER "${PGUSER:-}"
    dotenv_write_var PGPASSWORD "${PGPASSWORD:-}"
    dotenv_write_var PGPORT "${PGPORT:-}"
    dotenv_write_var PGHOST "${PGHOST:-}"
    dotenv_write_var MAIL_MAILER "${MAIL_MAILER:-}"
    dotenv_write_var MAIL_HOST "${MAIL_HOST:-}"
    dotenv_write_var MAIL_PORT "${MAIL_PORT:-}"
    dotenv_write_var MAIL_USERNAME "${MAIL_USERNAME:-}"
    dotenv_write_var MAIL_PASSWORD "${MAIL_PASSWORD:-}"
    dotenv_write_var MAIL_ENCRYPTION "${MAIL_ENCRYPTION:-}"
    dotenv_write_var MAIL_FROM_ADDRESS "${MAIL_FROM_ADDRESS:-}"
    dotenv_write_var MAIL_FROM_NAME "${MAIL_FROM_NAME:-}"
    dotenv_write_var MAIL_RECEIVERS "${MAIL_RECEIVERS:-}"
  } >"$file"
}

load_env_from_file() {
  dotenv_read_var "$ENV_FILE" SERVER_PORT ""
  dotenv_read_var "$ENV_FILE" PGDATABASE ""
  dotenv_read_var "$ENV_FILE" PGUSER ""
  dotenv_read_var "$ENV_FILE" PGPASSWORD ""
  dotenv_read_var "$ENV_FILE" PGPORT ""
  dotenv_read_var "$ENV_FILE" PGHOST ""
  dotenv_read_var "$ENV_FILE" MAIL_MAILER ""
  dotenv_read_var "$ENV_FILE" MAIL_HOST ""
  dotenv_read_var "$ENV_FILE" MAIL_PORT ""
  dotenv_read_var "$ENV_FILE" MAIL_USERNAME ""
  dotenv_read_var "$ENV_FILE" MAIL_PASSWORD ""
  dotenv_read_var "$ENV_FILE" MAIL_ENCRYPTION ""
  dotenv_read_var "$ENV_FILE" MAIL_FROM_ADDRESS ""
  dotenv_read_var "$ENV_FILE" MAIL_FROM_NAME ""
  dotenv_read_var "$ENV_FILE" MAIL_RECEIVERS ""
}

required_db_vars_present() {
  [ -n "${SERVER_PORT:-}" ] &&
    [ -n "${PGDATABASE:-}" ] &&
    [ -n "${PGUSER:-}" ] &&
    [ -n "${PGPASSWORD:-}" ] &&
    [ -n "${PGPORT:-}" ] &&
    [ -n "${PGHOST:-}" ]
}

prompt_db_values() {
  SERVER_PORT="$(prompt_required "SERVER_PORT" "${SERVER_PORT:-3000}")"
  PGDATABASE="$(prompt_required "PGDATABASE" "${PGDATABASE:-}")"
  PGUSER="$(prompt_required "PGUSER" "${PGUSER:-}")"

  if [ -n "${PGPASSWORD:-}" ]; then
    local old_pw new_pw
    old_pw="$PGPASSWORD"
    new_pw="$(prompt_secret "PGPASSWORD (press enter to keep existing)")"
    PGPASSWORD="${new_pw:-$old_pw}"
  else
    PGPASSWORD="$(prompt_secret "PGPASSWORD")"
    if [ -z "$PGPASSWORD" ]; then
      log_error "PGPASSWORD is required."
      exit 1
    fi
  fi

  PGPORT="$(prompt_required "PGPORT" "${PGPORT:-5432}")"
  PGHOST="$(prompt_required "PGHOST" "${PGHOST:-localhost}")"

  require_simple_ident "PGDATABASE" "$PGDATABASE"
  require_simple_ident "PGUSER" "$PGUSER"
}

prompt_email_values() {
  if confirm_with_back "Configure email server variables now? Press b to go back to the previous step."; then
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
    return 0
  else
    case $? in
      2) return 2 ;;
      *) log_warn "Skipping email configuration"; return 1 ;;
    esac
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

run_interactive_setup() {
  local stage="${1:-db}"
  local rc retry_rc

  while true; do
    case "$stage" in
      db)
        prompt_db_values
        stage="email"
        ;;
      email)
        prompt_email_values
        rc=$?
        case "$rc" in
          0|1) stage="provision" ;;
          2) log_info "Returning to database values"; stage="db" ;;
        esac
        ;;
      provision)
        if confirm_with_back "Create PostgreSQL user and database now? (requires sudo postgres access). Press b to go back to the previous step."; then
          if create_db_and_user; then
            log_success "PostgreSQL user/database ensured"
            stage="validate"
          else
            log_error "PostgreSQL provisioning failed"
            exit 1
          fi
        else
          case $? in
            2)
              log_info "Returning to email configuration"
              stage="email"
              ;;
            *)
              log_warn "Skipping PostgreSQL provisioning"
              stage="validate"
              ;;
          esac
        fi
        ;;
      validate)
        if confirm_with_back "Validate database credentials now? Press b to go back to the previous step."; then
          if validate_db_creds; then
            log_success "Database credentials are valid"
            break
          fi
          log_error "Database credential validation failed"
          if confirm_with_back "Attempt to create/update PostgreSQL user/database with provided creds? Press b to go back to the previous step."; then
            if create_db_and_user; then
              log_success "PostgreSQL user/database ensured"
              if validate_db_creds; then
                log_success "Database credentials are valid"
                break
              fi
              log_error "Database credential validation failed after provisioning"
              exit 1
            else
              log_error "PostgreSQL provisioning failed"
              exit 1
            fi
          else
            case $? in
              2)
                log_info "Returning to PostgreSQL provisioning"
                stage="provision"
                ;;
              *)
                exit 1
                ;;
            esac
          fi
        else
          case $? in
            2)
              log_info "Returning to PostgreSQL provisioning"
              stage="provision"
              ;;
            *)
              log_warn "Skipping database credential validation"
              break
              ;;
          esac
        fi
        ;;
    esac
  done
}

WRITE_ENV=0
START_STAGE="provision"

if [ -f "$ENV_FILE" ]; then
  log_info ".env found at $ENV_FILE"
  load_env_from_file
  if required_db_vars_present; then
    log_success "Existing .env already has required DB settings."
    if confirm "Edit existing .env values?"; then
      WRITE_ENV=1
      START_STAGE="db"
    else
      log_info "Keeping existing .env values"
      START_STAGE="provision"
    fi
  else
    log_warn ".env is missing required DB settings."
    if confirm "Edit .env and complete required values now?"; then
      WRITE_ENV=1
      START_STAGE="db"
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
