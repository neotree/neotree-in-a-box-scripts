set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"
source "$(dirname "$0")/../../lib/global_env.sh"

APP_ROOT="${APP_ROOT:-$HOME/neotree}"
NODE_ENV_FILE="${NODE_ENV_FILE:-$APP_ROOT/node-api/.env}"
MB_PORT="${MB_PORT:-6000}"
MB_MEMORY="${MB_MEMORY:-1G}"
MB_VERSION="${MB_VERSION:-1.57.0}"
SERVICE_NAME="${SERVICE_NAME:-metabase}"
INSTALL_DIR="${INSTALL_DIR:-/opt/metabase}"
MB_DATABASE="${MB_DATABASE:-metabase}"

if ! load_shared_pg_env; then
  if [ ! -f "$NODE_ENV_FILE" ]; then
    log_error "Global .env and node-api env file not found. Deploy node-api first."
    exit 1
  fi

  dotenv_get "$NODE_ENV_FILE" PGHOST || PGHOST=""
  dotenv_get "$NODE_ENV_FILE" PGPORT || PGPORT=""
  dotenv_get "$NODE_ENV_FILE" PGUSER || PGUSER=""
  dotenv_get "$NODE_ENV_FILE" PGPASSWORD || PGPASSWORD=""
fi

if [ -z "$PGHOST" ] || [ -z "$PGPORT" ] || [ -z "$PGUSER" ] || [ -z "$PGPASSWORD" ]; then
  log_error "Missing shared PG user vars in $NODE_ENV_FILE; node-api must be configured first."
  exit 1
fi

if ! echo "$MB_DATABASE" | grep -Eq '^[A-Za-z0-9_]+$' || ! echo "$PGUSER" | grep -Eq '^[A-Za-z0-9_]+$'; then
  log_error "Metabase database and PostgreSQL user must use only letters, numbers, or underscores."
  exit 1
fi

log_info "Ensuring Metabase application database: host=$PGHOST port=$PGPORT db=$MB_DATABASE user=$PGUSER"

if id -u postgres >/dev/null 2>&1; then
  db_exists="$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='${MB_DATABASE}'")"
  if ! echo "$db_exists" | grep -q 1; then
    sudo -u postgres createdb -O "$PGUSER" "$MB_DATABASE"
  fi
  sudo -u postgres psql -v ON_ERROR_STOP=1 <<SQL
ALTER DATABASE "$MB_DATABASE" OWNER TO "$PGUSER";
REVOKE ALL ON DATABASE "$MB_DATABASE" FROM PUBLIC;
GRANT CONNECT, TEMP ON DATABASE "$MB_DATABASE" TO "$PGUSER";
SQL
else
  log_warn "System user 'postgres' not found; skipping Metabase database creation"
fi

log_info "Ensuring system user $SERVICE_NAME"
sudo useradd -r -m -U -d "$INSTALL_DIR" -s /bin/false "$SERVICE_NAME" 2>/dev/null || true

log_info "Creating install dir $INSTALL_DIR"
sudo mkdir -p "$INSTALL_DIR"

JAR_URL="https://downloads.metabase.com/v${MB_VERSION}/metabase.jar"
log_info "Downloading Metabase ${MB_VERSION} from $JAR_URL"
sudo curl -L -o "$INSTALL_DIR/metabase.jar" "$JAR_URL"
sudo chown -R "$SERVICE_NAME:$SERVICE_NAME" "$INSTALL_DIR"
