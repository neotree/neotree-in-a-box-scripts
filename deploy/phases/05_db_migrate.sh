source "$(dirname "$0")/../lib/log.sh"

APP_DIR="$HOME/neotree-node-api"
ENV_FILE="$APP_DIR/.env"
DB_DIR="$(dirname "$0")/../database"
LOG_DIR="$(dirname "$0")/../logs"

if [ "${SKIP_DB_MIGRATIONS:-0}" = "1" ]; then
  log_warn "Skipping database migrations (SKIP_DB_MIGRATIONS=1)"
  exit 0
fi

if [ ! -f "$ENV_FILE" ]; then
  log_error ".env not found at $ENV_FILE"
  exit 1
fi

if [ ! -d "$DB_DIR" ]; then
  log_error "Database scripts directory not found: $DB_DIR"
  exit 1
fi

mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/db_migrate_$(date +%Y%m%d_%H%M%S).log"

set -a
. "$ENV_FILE"
set +a

if [ -z "${PGDATABASE:-}" ] || [ -z "${PGUSER:-}" ] || [ -z "${PGHOST:-}" ] || [ -z "${PGPORT:-}" ]; then
  log_error "Missing required PG* variables for migration"
  exit 1
fi

log_info "Running database scripts from $DB_DIR"
log_info "Migration log: $LOG_FILE"

for file in "$DB_DIR"/*.sql; do
  if [ ! -f "$file" ]; then
    continue
  fi
  log_info "Applying $(basename "$file")"
  PGPASSWORD="${PGPASSWORD:-}" psql -v ON_ERROR_STOP=1 \
    "host=$PGHOST port=$PGPORT dbname=$PGDATABASE user=$PGUSER sslmode=prefer" \
    -f "$file" 2>&1 | tee -a "$LOG_FILE"
  if [ "${PIPESTATUS[0]}" -ne 0 ]; then
    log_error "Failed on $(basename "$file"). See $LOG_FILE"
    exit 1
  fi
done

log_success "Database scripts completed successfully"
