set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/checks.sh"

log_info "Running preflight checks"

uname -m | grep -q x86_64 || { log_error "Unsupported architecture"; exit 1; }
df -h / | awk 'NR==2 {print $4}' | sed 's/G//' | awk '{if ($1 < 10) exit 1}' || {
  log_error "Insufficient disk space (need at least 10G free)"
  exit 1
}

ensure_cmd git git
ensure_cmd node nodejs
ensure_cmd npm npm

preflight_step=1
while [ "$preflight_step" -le 4 ]; do
  case "$preflight_step" in
    1)
      if ! command -v psql >/dev/null 2>&1; then
        log_warn "psql not found"
        if confirm_with_back "Install postgresql-client? Press b to go back to the previous step."; then
          apt_update_once
          sudo apt install -y postgresql-client
        else
          case $? in
            2)
              log_warn "Already at the first preflight step"
              continue
              ;;
            *)
              log_error "User declined. Exiting."
              exit 1
              ;;
          esac
        fi
      else
        log_info "psql is installed"
      fi
      ;;
    2)
      if ! id -u postgres >/dev/null 2>&1; then
        log_warn "PostgreSQL server is not installed"
        if confirm_with_back "Install PostgreSQL server now? Press b to go back to the previous step."; then
          apt_update_once
          sudo apt install -y postgresql
        else
          case $? in
            2)
              preflight_step=1
              continue
              ;;
            *)
              log_error "User declined. Exiting."
              exit 1
              ;;
          esac
        fi
      fi
      ;;
    3)
      if command -v systemctl >/dev/null 2>&1 && systemctl list-unit-files | grep -q '^postgresql\.service'; then
        if ! systemctl is-active postgresql >/dev/null 2>&1; then
          log_warn "PostgreSQL service is not running"
          if confirm_with_back "Start PostgreSQL service now? Press b to go back to the previous step."; then
            sudo systemctl enable --now postgresql
          else
            case $? in
              2)
                preflight_step=2
                continue
                ;;
              *)
                log_error "User declined. Exiting."
                exit 1
                ;;
            esac
          fi
        else
          log_info "PostgreSQL service is running"
        fi
      fi

      if command -v pg_isready >/dev/null 2>&1 && ! pg_isready -q; then
        log_warn "PostgreSQL is not accepting connections yet"
      fi
      ;;
    4)
      if ! command -v pm2 >/dev/null 2>&1; then
        log_warn "pm2 not found"
        if confirm_with_back "Install pm2 globally? Press b to go back to the previous step."; then
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
          case $? in
            2)
              preflight_step=3
              continue
              ;;
            *)
              log_error "User declined. Exiting."
              exit 1
              ;;
          esac
        fi
      else
        log_info "pm2 is installed"
      fi
      ;;
  esac
  preflight_step=$((preflight_step + 1))
done
