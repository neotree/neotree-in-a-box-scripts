set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"
source "$(dirname "$0")/../../lib/checks.sh"
APP_DIR="${APP_DIR:-$HOME/neotree/neotree-editor}"
ENV_FILE="${ENV_FILE:-$APP_DIR/.env}"
cd "$APP_DIR"

PM2_APP_NAME="${PM2_APP_NAME:-neotree-webeditor}"
DEPLOY_ENV="${DEPLOY_ENV:-production}"
SERVER_PORT="3001"

ensure_pm2
PM2_BIN="$(command -v pm2)"

if [ -f "$ENV_FILE" ]; then
  dotenv_read_var "$ENV_FILE" PORT "3001"
  dotenv_read_var "$ENV_FILE" SERVER_PORT "${PORT:-3001}"
  PORT="${PORT:-${SERVER_PORT:-3001}}"
  SERVER_PORT="${SERVER_PORT:-$PORT}"
  export PORT SERVER_PORT
fi

case "$DEPLOY_ENV" in
  production|prod) preferred_start_script="start:prod-server"; fallback_start_script="start" ;;
  staging|stage) preferred_start_script="start:stage-server"; fallback_start_script="start" ;;
  development|dev) preferred_start_script="start:dev-server"; fallback_start_script="dev" ;;
  *) log_error "Unknown DEPLOY_ENV '$DEPLOY_ENV'"; exit 1 ;;
esac

has_npm_script() {
  local script_name="$1"
  node -e "const pkg=require('./package.json'); process.exit(pkg.scripts && pkg.scripts[process.argv[1]] ? 0 : 1)" "$script_name"
}

if has_npm_script "$preferred_start_script"; then
  START_SCRIPT="$preferred_start_script"
elif has_npm_script "$fallback_start_script"; then
  START_SCRIPT="$fallback_start_script"
elif has_npm_script "start"; then
  START_SCRIPT="start"
else
  log_error "No usable WebEditor npm start script found in package.json"
  exit 1
fi

if "$PM2_BIN" describe "$PM2_APP_NAME" >/dev/null 2>&1; then
  log_warn "Removing existing PM2 app: $PM2_APP_NAME"
  "$PM2_BIN" delete "$PM2_APP_NAME"
fi

log_info "Starting WebEditor with npm script '$START_SCRIPT' on port $PORT"
"$PM2_BIN" start npm --name "$PM2_APP_NAME" --update-env -- run "$START_SCRIPT"
"$PM2_BIN" describe "$PM2_APP_NAME" >/dev/null
"$PM2_BIN" save
