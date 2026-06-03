set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"
log_info "Running post-install checks"
APP_DIR="${APP_DIR:-$HOME/neotree/neotree-editor}"
ENV_FILE="${ENV_FILE:-$APP_DIR/.env}"
PM2_APP_NAME="${PM2_APP_NAME:-neotree-webeditor}"
SERVER_PORT="3001"

if [ -f "$ENV_FILE" ]; then
  dotenv_read_var "$ENV_FILE" SERVER_PORT "3001"
  SERVER_PORT="${SERVER_PORT:-3001}"
fi

pm2 status "$PM2_APP_NAME" >/dev/null || { log_error "PM2 app not running"; exit 1; }

if ! curl -fsS --max-time 5 "http://127.0.0.1:${SERVER_PORT}" >/dev/null 2>&1; then
  log_error "WebEditor is not responding locally on port $SERVER_PORT. Check logs with: pm2 logs $PM2_APP_NAME"
  exit 1
fi

log_success "WebEditor is running locally on port $SERVER_PORT"
