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
PM2_BIN="$(command -v pm2)"

if [ -f "$ENV_FILE" ]; then
  dotenv_read_var "$ENV_FILE" PORT "3001"
  dotenv_read_var "$ENV_FILE" SERVER_PORT "3001"
  SERVER_PORT="${SERVER_PORT:-${PORT:-3001}}"
fi

"$PM2_BIN" status "$PM2_APP_NAME" >/dev/null || { log_error "PM2 app not running"; exit 1; }

webeditor_candidate_ports() {
  printf '%s\n' "$SERVER_PORT"
  [ -n "${PORT:-}" ] && printf '%s\n' "$PORT"
  printf '%s\n' 3001
  printf '%s\n' 3000
}

webeditor_http_status() {
  local port="$1"
  curl -sS --max-time 5 -o /dev/null -w '%{http_code}' "http://127.0.0.1:${port}" 2>/dev/null || true
}

for i in $(seq 1 "$WEBEDITOR_STARTUP_ATTEMPTS"); do
  while read -r candidate_port; do
    [ -n "$candidate_port" ] || continue
    status_code="$(webeditor_http_status "$candidate_port")"
    case "$status_code" in
      2*|3*|4*)
        log_success "WebEditor is responding locally on port $candidate_port with HTTP $status_code"
        if [ "$candidate_port" != "$SERVER_PORT" ]; then
          log_warn "WebEditor responded on port $candidate_port, but .env SERVER_PORT is $SERVER_PORT"
        fi
        exit 0
        ;;
    esac
  done <<EOF
$(webeditor_candidate_ports | awk '!seen[$0]++')
EOF

  if ! "$PM2_BIN" describe "$PM2_APP_NAME" >/dev/null 2>&1; then
    log_error "PM2 app '$PM2_APP_NAME' is not available. Check logs with: $PM2_BIN logs $PM2_APP_NAME"
    exit 1
  fi

  log_info "WebEditor is still starting; checked ports $(webeditor_candidate_ports | awk '!seen[$0]++' | paste -sd, -) ($i/$WEBEDITOR_STARTUP_ATTEMPTS)"
  sleep "$WEBEDITOR_STARTUP_SLEEP_SECONDS"
done

log_error "WebEditor is not responding locally after $((WEBEDITOR_STARTUP_ATTEMPTS * WEBEDITOR_STARTUP_SLEEP_SECONDS)) seconds. Check logs with: $PM2_BIN logs $PM2_APP_NAME"
"$PM2_BIN" status "$PM2_APP_NAME" || true
exit 1
