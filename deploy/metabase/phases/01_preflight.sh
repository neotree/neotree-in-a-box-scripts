set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/checks.sh"
source "$(dirname "$0")/../../lib/global_env.sh"

APP_ROOT="${APP_ROOT:-$HOME/neotree}"
NODE_ENV_FILE="${NODE_ENV_FILE:-$APP_ROOT/node-api/.env}"
JAVA_PACKAGE="${JAVA_PACKAGE:-openjdk-17-jre-headless}"

log_info "Running Metabase preflight checks"

ensure_cmd curl curl
ensure_cmd java "$JAVA_PACKAGE"
ensure_cmd nginx nginx

if [ -f "$(global_env_file)" ]; then
  log_info "Found shared env file at $(global_env_file)"
elif [ -f "$NODE_ENV_FILE" ]; then
  log_info "Found node-api env file at $NODE_ENV_FILE"
else
  log_error "Shared env file and node-api env file were not found. Deploy node-api first."
  exit 1
fi

# ensure systemd present
if ! command -v systemctl >/dev/null 2>&1; then
  log_error "systemd not available; cannot manage Metabase service"
  exit 1
fi
