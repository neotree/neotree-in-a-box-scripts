set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"

APP_DIR="${APP_DIR:-$HOME/neotree/neotree-editor}"
ENV_FILE="${ENV_FILE:-$APP_DIR/.env}"
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
LOCK_FILE="$LOG_DIR/db_migrate.lock"

exec 9>"$LOCK_FILE"
if ! flock -n 9; then
  log_error "Another migration appears to be running (lock: $LOCK_FILE)"
  exit 1
fi

dotenv_read_var "$ENV_FILE" PGDATABASE ""
dotenv_read_var "$ENV_FILE" PGUSER ""
dotenv_read_var "$ENV_FILE" PGHOST ""
dotenv_read_var "$ENV_FILE" PGPORT ""
dotenv_read_var "$ENV_FILE" PGPASSWORD ""
dotenv_read_var "$ENV_FILE" PGSSLMODE "prefer"

if [ -z "${PGDATABASE:-}" ] || [ -z "${PGUSER:-}" ] || [ -z "${PGHOST:-}" ] || [ -z "${PGPORT:-}" ] || [ -z "${PGPASSWORD:-}" ]; then
  log_error "Missing required PG* variables for migration"
  exit 1
fi

log_info "Running database scripts from $DB_DIR"
log_info "Migration log: $LOG_FILE"

if [ "${DRY_RUN:-0}" = "1" ]; then
  log_warn "DRY_RUN=1 set. Listing SQL files only."
fi

PGPASSWORD="${PGPASSWORD:-}" psql -v ON_ERROR_STOP=1 \
  "host=$PGHOST port=$PGPORT dbname=$PGDATABASE user=$PGUSER sslmode=$PGSSLMODE" \
  -c "SELECT 1;" >/dev/null 2>&1 || {
    log_error "Cannot connect to database with provided credentials"
    exit 1
  }

PGPASSWORD="${PGPASSWORD:-}" psql -v ON_ERROR_STOP=1 \
  "host=$PGHOST port=$PGPORT dbname=$PGDATABASE user=$PGUSER sslmode=$PGSSLMODE" \
  -c "CREATE TABLE IF NOT EXISTS schema_migrations (filename TEXT PRIMARY KEY, applied_at TIMESTAMPTZ DEFAULT now());" \
  2>&1 | tee -a "$LOG_FILE"

mapfile -t files < <(find "$DB_DIR" -maxdepth 1 -type f -name "*.sql" | sort)
if [ "${#files[@]}" -eq 0 ]; then
  log_warn "No SQL files found in $DB_DIR"
  exit 0
fi

for file in "${files[@]}"; do
  fname="$(basename "$file")"
  fname_escaped="${fname//\'/\'\'}"

  applied="$(PGPASSWORD="${PGPASSWORD:-}" psql -tAc \
    "SELECT 1 FROM schema_migrations WHERE filename='$fname_escaped' LIMIT 1;" \
    "host=$PGHOST port=$PGPORT dbname=$PGDATABASE user=$PGUSER sslmode=$PGSSLMODE")"

  if [ "$applied" = "1" ]; then
    log_info "Skipping $fname (already applied)"
    continue
  fi

  if [ "${DRY_RUN:-0}" = "1" ]; then
    log_info "Would apply $fname"
    continue
  fi

  log_info "Applying $fname"
  PGPASSWORD="${PGPASSWORD:-}" psql -v ON_ERROR_STOP=1 \
    "host=$PGHOST port=$PGPORT dbname=$PGDATABASE user=$PGUSER sslmode=$PGSSLMODE" \
    -f "$file" 2>&1 | tee -a "$LOG_FILE"
  if [ "${PIPESTATUS[0]}" -ne 0 ]; then
    log_error "Failed on $fname. See $LOG_FILE"
    exit 1
  fi

  PGPASSWORD="${PGPASSWORD:-}" psql -v ON_ERROR_STOP=1 \
    "host=$PGHOST port=$PGPORT dbname=$PGDATABASE user=$PGUSER sslmode=$PGSSLMODE" \
    -c "INSERT INTO schema_migrations(filename) VALUES ('$fname_escaped');" \
    2>&1 | tee -a "$LOG_FILE"
done

log_success "Database scripts completed successfully"
