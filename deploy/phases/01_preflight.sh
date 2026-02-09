source "$(dirname "$0")/../lib/log.sh"
log_info "Running preflight checks"
uname -m | grep -q x86_64 || { log_error "Unsupported architecture"; exit 1; }
df -h / | awk 'NR==2 {print $4}' | sed 's/G//' | awk '{if ($1 < 10) exit 1}' || {
  log_error "Insufficient disk space"
  exit 1
}

if ! id -u postgres >/dev/null 2>&1; then
  log_warn "PostgreSQL server user 'postgres' not found. DB/user provisioning will fail."
  log_warn "Install server with: sudo apt install -y postgresql"
fi
