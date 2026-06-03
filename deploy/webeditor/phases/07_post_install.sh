set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"
source "$(dirname "$0")/../../lib/checks.sh"
log_info "Running post-install checks"
APP_DIR="${APP_DIR:-$HOME/neotree/neotree-editor}"
ENV_FILE="${ENV_FILE:-$APP_DIR/.env}"
PM2_APP_NAME="${PM2_APP_NAME:-neotree-webeditor}"
SERVER_PORT="3001"
WEBEDITOR_STARTUP_ATTEMPTS="${WEBEDITOR_STARTUP_ATTEMPTS:-30}"
WEBEDITOR_STARTUP_SLEEP_SECONDS="${WEBEDITOR_STARTUP_SLEEP_SECONDS:-2}"

ensure_pm2

if [ -f "$ENV_FILE" ]; then
  dotenv_read_var "$ENV_FILE" PORT "3001"
  dotenv_read_var "$ENV_FILE" SERVER_PORT "3001"
  SERVER_PORT="${SERVER_PORT:-${PORT:-3001}}"
fi

pm2 status "$PM2_APP_NAME" >/dev/null || { log_error "PM2 app not running"; exit 1; }

webeditor_http_status() {
  curl -sS --max-time 5 -o /dev/null -w '%{http_code}' "http://127.0.0.1:${SERVER_PORT}" 2>/dev/null || true
}

for i in $(seq 1 "$WEBEDITOR_STARTUP_ATTEMPTS"); do
  status_code="$(webeditor_http_status)"
  case "$status_code" in
    2*|3*|4*)
      log_success "WebEditor is responding locally on port $SERVER_PORT with HTTP $status_code"
      exit 0
      ;;
  esac

  if ! pm2 describe "$PM2_APP_NAME" >/dev/null 2>&1; then
    log_error "PM2 app '$PM2_APP_NAME' is not available. Check logs with: pm2 logs $PM2_APP_NAME"
    exit 1
  fi

  log_info "WebEditor is still starting on port $SERVER_PORT ($i/$WEBEDITOR_STARTUP_ATTEMPTS)"
  sleep "$WEBEDITOR_STARTUP_SLEEP_SECONDS"
done

log_error "WebEditor is not responding locally on port $SERVER_PORT after $((WEBEDITOR_STARTUP_ATTEMPTS * WEBEDITOR_STARTUP_SLEEP_SECONDS)) seconds. Check logs with: pm2 logs $PM2_APP_NAME"
exit 1
