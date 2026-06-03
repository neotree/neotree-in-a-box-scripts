set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/checks.sh"
log_info "Running post-install checks"
PM2_APP_NAME="${PM2_APP_NAME:-neotree-api}"
ensure_pm2
pm2 status "$PM2_APP_NAME" >/dev/null || { log_error "PM2 app not running"; exit 1; }
