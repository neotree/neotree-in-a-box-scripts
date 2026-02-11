set -euo pipefail
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

if command -v systemctl >/dev/null 2>&1; then
  if systemctl is-enabled postgresql >/dev/null 2>&1; then
    if ! systemctl is-active postgresql >/dev/null 2>&1; then
      log_warn "PostgreSQL service is installed but not running"
      log_warn "Start it with: sudo systemctl start postgresql"
    fi
  fi
fi

if command -v pg_isready >/dev/null 2>&1; then
  if ! pg_isready -q; then
    log_warn "PostgreSQL is not accepting connections on default socket/port"
  fi
fi
