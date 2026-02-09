source "$(dirname "$0")/../lib/log.sh"
log_info "Running preflight checks"
uname -m | grep -q x86_64 || { log_error "Unsupported architecture"; exit 1; }
df -h / | awk 'NR==2 {print $4}' | sed 's/G//' | awk '{if ($1 < 10) exit 1}' || {
  log_error "Insufficient disk space"
  exit 1
}
