set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"
source "$(dirname "$0")/../../lib/global_env.sh"

APP_ROOT="${APP_ROOT:-$HOME/neotree}"
NODE_ENV_FILE="${NODE_ENV_FILE:-$APP_ROOT/node-api/.env}"
MB_PORT="${MB_PORT:-6000}"
MB_MEMORY="${MB_MEMORY:-1G}"
MB_VERSION="${MB_VERSION:-latest}"
MB_DOWNLOAD_URL="${MB_DOWNLOAD_URL:-}"
SERVICE_NAME="${SERVICE_NAME:-metabase}"
INSTALL_DIR="${INSTALL_DIR:-/opt/metabase}"
MB_DATABASE="${MB_DATABASE:-metabase}"

if ! load_shared_pg_env; then
  if [ ! -f "$NODE_ENV_FILE" ]; then
    log_error "Global .env and node-api env file not found. Deploy node-api first."
    exit 1
  fi

  PGHOST="$(dotenv_get "$NODE_ENV_FILE" PGHOST || true)"
  PGPORT="$(dotenv_get "$NODE_ENV_FILE" PGPORT || true)"
  PGUSER="$(dotenv_get "$NODE_ENV_FILE" PGUSER || true)"
  PGPASSWORD="$(dotenv_get "$NODE_ENV_FILE" PGPASSWORD || true)"
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

metabase_download_url() {
  if [ -n "$MB_DOWNLOAD_URL" ]; then
    printf '%s\n' "$MB_DOWNLOAD_URL"
  elif [ "$MB_VERSION" = "latest" ]; then
    printf '%s\n' "https://downloads.metabase.com/latest/metabase.jar"
  else
    printf '%s\n' "https://downloads.metabase.com/v${MB_VERSION}/metabase.jar"
  fi
}

validate_metabase_jar() {
  local jar="$1" size magic
  [ -f "$jar" ] || return 1
  size="$(stat -c '%s' "$jar" 2>/dev/null || echo 0)"
  if [ "$size" -le 50000000 ]; then
    log_error "Downloaded Metabase jar is too small (${size} bytes). This usually means the URL returned an error page."
    return 1
  fi

  magic="$(dd if="$jar" bs=4 count=1 2>/dev/null | od -An -tx1 | tr -d ' \n')"
  if [ "$magic" != "504b0304" ]; then
    log_error "Downloaded Metabase jar is not a valid jar/zip file. First bytes: $magic"
    return 1
  fi
}

JAR_URL="$(metabase_download_url)"
tmp_jar="$(mktemp /tmp/metabase.jar.XXXXXX)"
cleanup() {
  rm -f "$tmp_jar"
}
trap cleanup EXIT

log_info "Downloading Metabase ${MB_VERSION} from $JAR_URL"
curl -fL --retry 3 --retry-delay 2 --connect-timeout 20 -o "$tmp_jar" "$JAR_URL"
validate_metabase_jar "$tmp_jar"
sudo install -m 0644 -o "$SERVICE_NAME" -g "$SERVICE_NAME" "$tmp_jar" "$INSTALL_DIR/metabase.jar"
sudo chown -R "$SERVICE_NAME:$SERVICE_NAME" "$INSTALL_DIR"
