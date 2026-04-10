set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"

APP_ROOT="${APP_ROOT:-$HOME/neotree}"
NODE_ENV_FILE="${NODE_ENV_FILE:-$APP_ROOT/node-api/.env}"
MB_PORT="${MB_PORT:-6000}"
MB_MEMORY="${MB_MEMORY:-1G}"
MB_VERSION="${MB_VERSION:-1.57.0}"
SERVICE_NAME="${SERVICE_NAME:-metabase}"
INSTALL_DIR="${INSTALL_DIR:-/opt/metabase}"

if [ ! -f "$NODE_ENV_FILE" ]; then
  log_error "node-api env file not found at $NODE_ENV_FILE. Deploy node-api first."
  exit 1
fi

dotenv_get "$NODE_ENV_FILE" PGHOST || PGHOST=""
dotenv_get "$NODE_ENV_FILE" PGPORT || PGPORT=""
dotenv_get "$NODE_ENV_FILE" PGDATABASE || PGDATABASE=""
dotenv_get "$NODE_ENV_FILE" PGUSER || PGUSER=""
dotenv_get "$NODE_ENV_FILE" PGPASSWORD || PGPASSWORD=""

if [ -z "$PGHOST" ] || [ -z "$PGPORT" ] || [ -z "$PGDATABASE" ] || [ -z "$PGUSER" ] || [ -z "$PGPASSWORD" ]; then
  log_error "Missing PG* vars in $NODE_ENV_FILE; node-api must be configured first."
  exit 1
fi

log_info "Using node-api database as Metabase source: host=$PGHOST port=$PGPORT db=$PGDATABASE user=$PGUSER"

log_info "Ensuring system user $SERVICE_NAME"
sudo useradd -r -m -U -d "$INSTALL_DIR" -s /bin/false "$SERVICE_NAME" 2>/dev/null || true

log_info "Creating install dir $INSTALL_DIR"
sudo mkdir -p "$INSTALL_DIR"

JAR_URL="https://downloads.metabase.com/v${MB_VERSION}/metabase.jar"
log_info "Downloading Metabase ${MB_VERSION} from $JAR_URL"
sudo curl -L -o "$INSTALL_DIR/metabase.jar" "$JAR_URL"
sudo chown -R "$SERVICE_NAME:$SERVICE_NAME" "$INSTALL_DIR"
