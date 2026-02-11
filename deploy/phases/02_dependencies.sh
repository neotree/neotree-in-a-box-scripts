source "$(dirname "$0")/../lib/log.sh"
source "$(dirname "$0")/../lib/checks.sh"

ensure_cmd git git
ensure_cmd psql postgresql-client
ensure_cmd node nodejs
ensure_cmd npm npm

if ! id -u postgres >/dev/null 2>&1; then
  log_warn "PostgreSQL server user 'postgres' not found"
  confirm "Install postgresql server?"
  sudo apt update && sudo apt install -y postgresql
fi

if ! command -v pm2 >/dev/null 2>&1; then
  log_warn "pm2 not found"
  confirm "Install pm2 globally?"
  NPM_BIN="$(command -v npm || true)"
  if [ -z "$NPM_BIN" ]; then
    log_error "npm not found after install"
    exit 1
  fi
  if echo "$NPM_BIN" | grep -q "$HOME"; then
    "$NPM_BIN" install -g pm2
  else
    sudo "$NPM_BIN" install -g pm2
  fi
else
  log_info "pm2 is installed"
fi
