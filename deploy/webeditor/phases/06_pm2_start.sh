set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"
APP_DIR="${APP_DIR:-$HOME/neotree/neotree-editor}"
ENV_FILE="${ENV_FILE:-$APP_DIR/.env}"
cd "$APP_DIR"

PM2_APP_NAME="${PM2_APP_NAME:-neotree-webeditor}"
DEPLOY_ENV="${DEPLOY_ENV:-production}"
SERVER_PORT="3001"

if [ -f "$ENV_FILE" ]; then
  dotenv_read_var "$ENV_FILE" PORT "3001"
  dotenv_read_var "$ENV_FILE" SERVER_PORT "${PORT:-3001}"
  PORT="${PORT:-${SERVER_PORT:-3001}}"
  SERVER_PORT="${SERVER_PORT:-$PORT}"
  export PORT SERVER_PORT
fi

case "$DEPLOY_ENV" in
  production|prod) START_SCRIPT="start:prod-server" ;;
  staging|stage) START_SCRIPT="start:stage-server" ;;
  development|dev) START_SCRIPT="start:dev-server" ;;
  *) log_error "Unknown DEPLOY_ENV '$DEPLOY_ENV'"; exit 1 ;;
esac

if pm2 describe "$PM2_APP_NAME" >/dev/null 2>&1; then
  log_warn "Removing existing PM2 app: $PM2_APP_NAME"
  pm2 delete "$PM2_APP_NAME"
fi

pm2 start npm --name "$PM2_APP_NAME" -- run "$START_SCRIPT"
pm2 describe "$PM2_APP_NAME" >/dev/null
pm2 save
