source "$(dirname "$0")/../lib/log.sh"

APP_DIR="$HOME/neotree-node-api"
ENV_FILE="$APP_DIR/.env"
EXAMPLE_FILE="$APP_DIR/.env-example"

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
  read -p "$1 [y/n]: " yn
  case $yn in
    [Yy]*) return 0 ;;
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
  cat >"$file" <<EOF
SERVER_PORT=$SERVER_PORT
PGDATABASE=$PGDATABASE
PGUSER=$PGUSER
PGPASSWORD=$PGPASSWORD
PGPORT=$PGPORT
PGHOST=$PGHOST
MAIL_MAILER=$MAIL_MAILER
MAIL_HOST=$MAIL_HOST
MAIL_PORT=$MAIL_PORT
MAIL_USERNAME=$MAIL_USERNAME
MAIL_PASSWORD=$MAIL_PASSWORD
MAIL_ENCRYPTION=$MAIL_ENCRYPTION
MAIL_FROM_ADDRESS=$MAIL_FROM_ADDRESS
MAIL_FROM_NAME=$MAIL_FROM_NAME
MAIL_RECEIVERS=$MAIL_RECEIVERS
EOF
}

validate_db_creds() {
  log_info "Validating database credentials"
  PGPASSWORD="$PGPASSWORD" psql -v ON_ERROR_STOP=1 \
    "host=$PGHOST port=$PGPORT dbname=$PGDATABASE user=$PGUSER sslmode=prefer" \
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
    CREATE USER "$esc_user" WITH PASSWORD '$esc_pw';
  END IF;
END
\$\$;

DO \$\$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_database WHERE datname = '$esc_db') THEN
    CREATE DATABASE "$esc_db" OWNER "$esc_user";
  END IF;
END
\$\$;

GRANT ALL PRIVILEGES ON DATABASE "$esc_db" TO "$esc_user";
SQL
}

log_info "Configuring environment variables"

OVERWRITE_ENV=1
WRITE_ENV=0

if [ -f "$ENV_FILE" ]; then
  log_warn ".env already exists at $ENV_FILE"
  if ! confirm "Overwrite existing .env?"; then
    log_info "Keeping existing .env"
    OVERWRITE_ENV=0
  fi
fi

if [ "$OVERWRITE_ENV" -eq 0 ]; then
  set -a
  . "$ENV_FILE"
  set +a
else
  if [ ! -f "$EXAMPLE_FILE" ]; then
    log_warn ".env-example not found. Proceeding with interactive setup."
  fi

  SERVER_PORT="$(prompt_required "SERVER_PORT" "3000")"
  PGDATABASE="$(prompt_required "PGDATABASE")"
  PGUSER="$(prompt_required "PGUSER")"
  PGPASSWORD="$(prompt_required "PGPASSWORD")"
  PGPORT="$(prompt_required "PGPORT" "5432")"
  PGHOST="$(prompt_required "PGHOST" "localhost")"

  require_simple_ident "PGDATABASE" "$PGDATABASE"
  require_simple_ident "PGUSER" "$PGUSER"

  MAIL_MAILER=""
  MAIL_HOST=""
  MAIL_PORT=""
  MAIL_USERNAME=""
  MAIL_PASSWORD=""
  MAIL_ENCRYPTION=""
  MAIL_FROM_ADDRESS=""
  MAIL_FROM_NAME=""
  MAIL_RECEIVERS=""

  if confirm "Configure email server variables now?"; then
    MAIL_MAILER="$(prompt_required "MAIL_MAILER (e.g. smtp)")"
    MAIL_HOST="$(prompt_required "MAIL_HOST")"
    MAIL_PORT="$(prompt_required "MAIL_PORT" "587")"
    MAIL_USERNAME="$(prompt_required "MAIL_USERNAME")"
    MAIL_PASSWORD="$(prompt_required "MAIL_PASSWORD")"
    MAIL_ENCRYPTION="$(prompt_required "MAIL_ENCRYPTION (e.g. tls)")"
    MAIL_FROM_ADDRESS="$(prompt_required "MAIL_FROM_ADDRESS")"
    MAIL_FROM_NAME="$(prompt_required "MAIL_FROM_NAME")"
    MAIL_RECEIVERS="$(prompt_required "MAIL_RECEIVERS (comma-separated)")"
  else
    log_warn "Skipping email configuration"
  fi

  WRITE_ENV=1
fi

if [ -z "${SERVER_PORT:-}" ] || [ -z "${PGDATABASE:-}" ] || [ -z "${PGUSER:-}" ] || [ -z "${PGPASSWORD:-}" ] || [ -z "${PGPORT:-}" ] || [ -z "${PGHOST:-}" ]; then
  log_warn "Required database variables are missing in .env"
  if confirm "Update .env with required database values now?"; then
    SERVER_PORT="$(prompt_required "SERVER_PORT" "${SERVER_PORT:-3000}")"
    PGDATABASE="$(prompt_required "PGDATABASE" "${PGDATABASE:-}")"
    PGUSER="$(prompt_required "PGUSER" "${PGUSER:-}")"
    PGPASSWORD="$(prompt_required "PGPASSWORD" "${PGPASSWORD:-}")"
    PGPORT="$(prompt_required "PGPORT" "${PGPORT:-5432}")"
    PGHOST="$(prompt_required "PGHOST" "${PGHOST:-localhost}")"

    require_simple_ident "PGDATABASE" "$PGDATABASE"
    require_simple_ident "PGUSER" "$PGUSER"
    WRITE_ENV=1
  else
    log_error "Cannot proceed without required database variables"
    exit 1
  fi
fi

if [ "$WRITE_ENV" -eq 1 ]; then
  write_env_file "$ENV_FILE"
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
    exit 1
  fi
else
  log_warn "Skipping database credential validation"
fi
