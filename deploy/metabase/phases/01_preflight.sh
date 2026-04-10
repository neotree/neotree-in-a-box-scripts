set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/checks.sh"

APP_ROOT="${APP_ROOT:-$HOME/neotree}"
NODE_ENV_FILE="${NODE_ENV_FILE:-$APP_ROOT/node-api/.env}"
JAVA_PACKAGE="${JAVA_PACKAGE:-openjdk-17-jre-headless}"

log_info "Running Metabase preflight checks"

ensure_cmd curl curl
ensure_cmd java "$JAVA_PACKAGE"
ensure_cmd nginx nginx

if [ ! -f "$NODE_ENV_FILE" ]; then
  log_error "node-api env file not found at $NODE_ENV_FILE. Deploy node-api first."
  exit 1
else
  log_info "Found node-api env file at $NODE_ENV_FILE"
fi

# ensure systemd present
if ! command -v systemctl >/dev/null 2>&1; then
  log_error "systemd not available; cannot manage Metabase service"
  exit 1
fi
