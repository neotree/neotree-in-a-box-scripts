source "$(dirname "$0")/../lib/log.sh"
log_info "Running post-install checks"
pm2 status neotree-api >/dev/null || { log_error "PM2 app not running"; exit 1; }
