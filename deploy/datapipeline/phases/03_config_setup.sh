set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"
source "$(dirname "$0")/../../lib/prompt.sh"
source "$(dirname "$0")/../../lib/checks.sh"

APP_ROOT="${APP_ROOT:-$HOME/neotree}"
APP_DIR="${APP_DIR:-$APP_ROOT/datapipeline}"
CONF_DIR="$APP_DIR/conf/local"
DB_FILE="$CONF_DIR/database.ini"
HOSP_FILE="$CONF_DIR/hospitals.ini"
NODE_ENV_FILE="${NODE_ENV_FILE:-$APP_ROOT/node-api/.env}"

if [ ! -d "$APP_DIR" ]; then
  log_error "Datapipeline directory not found: $APP_DIR. Run clone phase first."
  exit 1
fi

mkdir -p "$CONF_DIR"

prompt() {
  local label="$1" default_value="${2:-}" input
  if [ -t 0 ]; then
    if [ -n "$default_value" ]; then
      read -p "$label [$default_value]: " input || true
      echo "${input:-$default_value}"
    else
      read -p "$label: " input || true
      echo "$input"
    fi
  else
    echo "$default_value"
  fi
}

lowercase() { echo "$1" | tr 'A-Z' 'a-z'; }

backup_if_exists() {
  local file="$1"
  if [ -f "$file" ]; then
    local backup="${file}.bak_$(date +%Y%m%d_%H%M%S)"
    cp "$file" "$backup"
    log_warn "Existing $(basename "$file") backed up to $backup"
  fi
}

default_host="localhost"
default_db="node-api"
default_user="node-api"
default_password=""
default_country="zimbabwe"
default_webeditor=""
default_webeditor_key=""

if [ -f "$NODE_ENV_FILE" ]; then
  log_info "Loading defaults from $NODE_ENV_FILE"
  node_pg_host="$(dotenv_get "$NODE_ENV_FILE" PGHOST || true)"
  node_pg_user="$(dotenv_get "$NODE_ENV_FILE" PGUSER || true)"
  node_pg_pass="$(dotenv_get "$NODE_ENV_FILE" PGPASSWORD || true)"

  [ -n "$node_pg_host" ] && default_host="$node_pg_host"
  [ -n "$node_pg_user" ] && default_user="$node_pg_user"
  [ -n "$node_pg_pass" ] && default_password="$node_pg_pass"
else
  log_warn "Node API .env not found at $NODE_ENV_FILE; using fallback defaults"
fi

if [ -f "$DB_FILE" ]; then
  if confirm "database.ini already exists. Recreate it now?"; then
    backup_if_exists "$DB_FILE"
  else
    log_info "Keeping existing database.ini"
    if [ ! -f "$HOSP_FILE" ]; then
      log_info "Creating hospitals.ini placeholder"
      echo "# Add hospital configuration here" > "$HOSP_FILE"
    fi
    exit 0
  fi
fi

DB_HOST="$(prompt "Database host" "$default_host")"
DB_NAME="$(prompt "Database name" "$default_db")"
DB_USER="$(prompt "Database user" "$default_user")"
DB_PASSWORD="$(prompt_secret "Database password" "$default_password")"

country_input="$(prompt "Country (zimbabwe/malawi)" "$default_country")"
country_input="$(lowercase "$country_input")"
case "$country_input" in
  zimbabwe|malawi)
    DB_COUNTRY="$country_input"
    ;;
  *)
    log_warn "Unknown country '$country_input', defaulting to zimbabwe"
    DB_COUNTRY="zimbabwe"
    ;;
esac

DATA_FIX="$(prompt "Enable data_fix (True/False)" "True")"

CONNECT_WEBEDITOR=0
if confirm "Configure webeditor connection now?"; then
  CONNECT_WEBEDITOR=1
  WEBEDITOR_URL="$(prompt "Webeditor URL" "$default_webeditor")"
  WEBEDITOR_API_KEY="$(prompt_secret "Webeditor API key" "$default_webeditor_key")"
fi

backup_if_exists "$DB_FILE"
cat > "$DB_FILE" <<EOF
[postgresql_dev]
host = $DB_HOST
database = $DB_NAME
user = $DB_USER
password = $DB_PASSWORD
country = $DB_COUNTRY
data_fix = $DATA_FIX
EOF

if [ "$CONNECT_WEBEDITOR" -eq 1 ]; then
cat >> "$DB_FILE" <<EOF

[webeditor]
webeditor = $WEBEDITOR_URL
webeditor_api_key = $WEBEDITOR_API_KEY
EOF
fi

if [ ! -f "$HOSP_FILE" ]; then
  log_info "Creating hospitals.ini placeholder"
  cat > "$HOSP_FILE" <<EOF
# hospitals.ini
# Add hospital-level overrides in ini format, e.g.
# [default]
# code = HOSP001
EOF
fi

log_success "database.ini and hospitals.ini ready under $CONF_DIR"
