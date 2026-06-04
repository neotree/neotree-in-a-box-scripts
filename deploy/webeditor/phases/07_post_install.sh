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
}

webeditor_test_response() {
  local port="$1"
  curl -fsS --max-time 5 "http://127.0.0.1:${port}/api/test" 2>/dev/null || true
}

for i in $(seq 1 "$WEBEDITOR_STARTUP_ATTEMPTS"); do
  while read -r candidate_port; do
    [ -n "$candidate_port" ] || continue
    response_body="$(webeditor_test_response "$candidate_port")"
    if printf '%s' "$response_body" | grep -Eq '"status"[[:space:]]*:[[:space:]]*"ok"'; then
      log_success "WebEditor readiness endpoint is responding on port $candidate_port (/api/test)"
      if [ "$candidate_port" != "$SERVER_PORT" ]; then
        log_warn "WebEditor responded on port $candidate_port, but .env SERVER_PORT is $SERVER_PORT"
      fi
      exit 0
    fi
  done <<EOF
$(webeditor_candidate_ports | awk '!seen[$0]++')
EOF

  if ! "$PM2_BIN" describe "$PM2_APP_NAME" >/dev/null 2>&1; then
    log_error "PM2 app '$PM2_APP_NAME' is not available. Check logs with: $PM2_BIN logs $PM2_APP_NAME"
    exit 1
  fi

  log_info "WebEditor is still starting; checked /api/test on ports $(webeditor_candidate_ports | awk '!seen[$0]++' | paste -sd, -) ($i/$WEBEDITOR_STARTUP_ATTEMPTS)"
  sleep "$WEBEDITOR_STARTUP_SLEEP_SECONDS"
done

log_error "WebEditor /api/test is not responding with status ok after $((WEBEDITOR_STARTUP_ATTEMPTS * WEBEDITOR_STARTUP_SLEEP_SECONDS)) seconds. Check logs with: $PM2_BIN logs $PM2_APP_NAME"
"$PM2_BIN" status "$PM2_APP_NAME" || true
exit 1
