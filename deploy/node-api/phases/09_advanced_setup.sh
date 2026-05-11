set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"
source "$(dirname "$0")/../../lib/prompt.sh"
source "$(dirname "$0")/../../lib/mail_env.sh"

APP_ROOT="${APP_ROOT:-$HOME/neotree}"
APP_DIR="${APP_DIR:-$APP_ROOT/node-api}"
ENV_FILE="${ENV_FILE:-$APP_DIR/.env}"
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if [ ! -d "$APP_DIR" ]; then
  log_error "App directory not found: $APP_DIR"
  exit 1
fi

if [ ! -f "$ENV_FILE" ]; then
  log_error ".env not found at $ENV_FILE. Run the core setup first."
  exit 1
fi

prompt() {
  local label="$1"
  local default="${2:-}"
  local value
  if [ -n "$default" ]; then
    read -p "$label [$default]: " value
    echo "${value:-$default}"
  else
    read -p "$label: " value
    echo "$value"
  fi
}

prompt_required() {
  local label="$1"
  local default="${2:-}"
  local value
  while true; do
    value="$(prompt "$label" "$default")"
    if [ -n "$value" ]; then
      echo "$value"
      return 0
    fi
    log_error "This value is required."
  done
}

write_env_file() {
  local file="$1"
  {
    dotenv_write_var SERVER_PORT "${SERVER_PORT:-}"
    dotenv_write_var PGDATABASE "${PGDATABASE:-}"
    dotenv_write_var PGUSER "${PGUSER:-}"
    dotenv_write_var PGPASSWORD "${PGPASSWORD:-}"
    dotenv_write_var PGPORT "${PGPORT:-}"
    dotenv_write_var PGHOST "${PGHOST:-}"
    dotenv_write_var MAIL_MAILER "${MAIL_MAILER:-}"
    dotenv_write_var MAIL_HOST "${MAIL_HOST:-}"
    dotenv_write_var MAIL_PORT "${MAIL_PORT:-}"
    dotenv_write_var MAIL_USERNAME "${MAIL_USERNAME:-}"
    dotenv_write_var MAIL_PASSWORD "${MAIL_PASSWORD:-}"
    dotenv_write_var MAIL_ENCRYPTION "${MAIL_ENCRYPTION:-}"
    dotenv_write_var MAIL_FROM_ADDRESS "${MAIL_FROM_ADDRESS:-}"
    dotenv_write_var MAIL_FROM_NAME "${MAIL_FROM_NAME:-}"
    dotenv_write_var MAIL_RECEIVERS "${MAIL_RECEIVERS:-}"
  } >"$file"
}

load_env_from_file() {
  dotenv_read_var "$ENV_FILE" SERVER_PORT ""
  dotenv_read_var "$ENV_FILE" PGDATABASE ""
  dotenv_read_var "$ENV_FILE" PGUSER ""
  dotenv_read_var "$ENV_FILE" PGPASSWORD ""
  dotenv_read_var "$ENV_FILE" PGPORT ""
  dotenv_read_var "$ENV_FILE" PGHOST ""
  dotenv_read_var "$ENV_FILE" MAIL_MAILER ""
  dotenv_read_var "$ENV_FILE" MAIL_HOST ""
  dotenv_read_var "$ENV_FILE" MAIL_PORT ""
  dotenv_read_var "$ENV_FILE" MAIL_USERNAME ""
  dotenv_read_var "$ENV_FILE" MAIL_PASSWORD ""
  dotenv_read_var "$ENV_FILE" MAIL_ENCRYPTION ""
  dotenv_read_var "$ENV_FILE" MAIL_FROM_ADDRESS ""
  dotenv_read_var "$ENV_FILE" MAIL_FROM_NAME ""
  dotenv_read_var "$ENV_FILE" MAIL_RECEIVERS ""
}

reset_email_values
load_env_from_file

WRITE_ENV=1
prompt_mail_values || true

write_env_file "$ENV_FILE"
chmod 600 "$ENV_FILE"
log_success ".env updated at $ENV_FILE"

if confirm "Continue to nginx setup now?"; then
  bash "$BASE_DIR/phases/08_nginx_setup.sh"
else
  log_info "Skipping nginx setup"
fi
