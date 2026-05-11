set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"
source "$(dirname "$0")/../../lib/prompt.sh"
source "$(dirname "$0")/../../lib/mail_env.sh"

APP_ROOT="${APP_ROOT:-$HOME/neotree}"
APP_DIR="${APP_DIR:-$APP_ROOT/neotree-editor}"
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
    dotenv_write_var NEOTREE_SERVER_TYPE "${NEOTREE_SERVER_TYPE:-}"
    dotenv_write_var NODE_ENV "${NODE_ENV:-}"
    dotenv_write_var NEOTREE_ENV "${NEOTREE_ENV:-}"
    dotenv_write_var HOSTNAME "${HOSTNAME:-}"
    dotenv_write_var PORT "${PORT:-}"
    dotenv_write_var SERVER_PORT "${SERVER_PORT:-${PORT:-}}"
    dotenv_write_var API_KEY "${API_KEY:-}"
    dotenv_write_var DEBUG "${DEBUG:-}"
    dotenv_write_var DB_LOGGING "${DB_LOGGING:-}"
    dotenv_write_var PGDATABASE "${PGDATABASE:-}"
    dotenv_write_var PGUSER "${PGUSER:-}"
    dotenv_write_var PGPASSWORD "${PGPASSWORD:-}"
    dotenv_write_var PGPORT "${PGPORT:-}"
    dotenv_write_var PGHOST "${PGHOST:-}"
    dotenv_write_var POSTGRES_DB_URL "${POSTGRES_DB_URL:-}"
    dotenv_write_var SESSIONS_DB_URL "${SESSIONS_DB_URL:-}"
    dotenv_write_var NEXT_PUBLIC_APP_NAME "${NEXT_PUBLIC_APP_NAME:-}"
    dotenv_write_var NEXT_PUBLIC_APP_URL "${NEXT_PUBLIC_APP_URL:-}"
    dotenv_write_var NEXTAUTH_URL "${NEXTAUTH_URL:-}"
    dotenv_write_var NEXTAUTH_SECRET "${NEXTAUTH_SECRET:-}"
    dotenv_write_var JWT_SECRET "${JWT_SECRET:-}"
    dotenv_write_var MAIL_MAILER "${MAIL_MAILER:-}"
    dotenv_write_var MAIL_HOST "${MAIL_HOST:-}"
    dotenv_write_var MAIL_PORT "${MAIL_PORT:-}"
    dotenv_write_var MAIL_USERNAME "${MAIL_USERNAME:-}"
    dotenv_write_var MAIL_PASSWORD "${MAIL_PASSWORD:-}"
    dotenv_write_var MAIL_ENCRYPTION "${MAIL_ENCRYPTION:-}"
    dotenv_write_var MAIL_FROM_ADDRESS "${MAIL_FROM_ADDRESS:-}"
    dotenv_write_var MAIL_FROM_NAME "${MAIL_FROM_NAME:-}"
  } >"$file"
}

load_env_from_file() {
  dotenv_read_var "$ENV_FILE" NEOTREE_SERVER_TYPE ""
  dotenv_read_var "$ENV_FILE" NODE_ENV ""
  dotenv_read_var "$ENV_FILE" NEOTREE_ENV ""
  dotenv_read_var "$ENV_FILE" HOSTNAME ""
  dotenv_read_var "$ENV_FILE" PORT ""
  dotenv_read_var "$ENV_FILE" SERVER_PORT ""
  dotenv_read_var "$ENV_FILE" API_KEY ""
  dotenv_read_var "$ENV_FILE" DEBUG ""
  dotenv_read_var "$ENV_FILE" DB_LOGGING ""
  dotenv_read_var "$ENV_FILE" PGDATABASE ""
  dotenv_read_var "$ENV_FILE" PGUSER ""
  dotenv_read_var "$ENV_FILE" PGPASSWORD ""
  dotenv_read_var "$ENV_FILE" PGPORT ""
  dotenv_read_var "$ENV_FILE" PGHOST ""
  dotenv_read_var "$ENV_FILE" POSTGRES_DB_URL ""
  dotenv_read_var "$ENV_FILE" SESSIONS_DB_URL ""
  dotenv_read_var "$ENV_FILE" NEXT_PUBLIC_APP_NAME ""
  dotenv_read_var "$ENV_FILE" NEXT_PUBLIC_APP_URL ""
  dotenv_read_var "$ENV_FILE" NEXTAUTH_URL ""
  dotenv_read_var "$ENV_FILE" NEXTAUTH_SECRET ""
  dotenv_read_var "$ENV_FILE" JWT_SECRET ""
  dotenv_read_var "$ENV_FILE" MAIL_MAILER ""
  dotenv_read_var "$ENV_FILE" MAIL_HOST ""
  dotenv_read_var "$ENV_FILE" MAIL_PORT ""
  dotenv_read_var "$ENV_FILE" MAIL_USERNAME ""
  dotenv_read_var "$ENV_FILE" MAIL_PASSWORD ""
  dotenv_read_var "$ENV_FILE" MAIL_ENCRYPTION ""
  dotenv_read_var "$ENV_FILE" MAIL_FROM_ADDRESS ""
  dotenv_read_var "$ENV_FILE" MAIL_FROM_NAME ""
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
