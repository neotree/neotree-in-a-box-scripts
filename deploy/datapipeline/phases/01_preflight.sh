set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/checks.sh"

log_info "Running datapipeline preflight checks"

ensure_cmd git git

PYTHON_BIN="${PYTHON_BIN:-python3.8}"

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  log_warn "$PYTHON_BIN not found (Ubuntu 24.04 does not ship it by default)"
  confirm_or_exit "Install python3.8 from deadsnakes PPA now?"
  apt_update_once
  sudo apt install -y software-properties-common
  sudo add-apt-repository -y ppa:deadsnakes/ppa
  apt_update_once
  sudo apt install -y python3.8 python3.8-venv python3.8-distutils
else
  log_info "$PYTHON_BIN is available"
fi

if ! "$PYTHON_BIN" -m venv --help >/dev/null 2>&1; then
  log_warn "python3.8 venv module not available"
  confirm_or_exit "Install python3.8-venv now?"
  apt_update_once
  sudo apt install -y python3.8-venv
else
  log_info "python3.8-venv is available"
fi

if ! "$PYTHON_BIN" -m pip --version >/dev/null 2>&1; then
  log_warn "pip for $PYTHON_BIN not found; bootstrapping with ensurepip"
  "$PYTHON_BIN" -m ensurepip --upgrade || {
    log_warn "ensurepip failed; installing python3-pip for fallback"
    apt_update_once
    sudo apt install -y python3-pip
  }
fi


if ! command -v psql >/dev/null 2>&1; then
  log_warn "psql not found (needed to verify database connectivity)"
  confirm_or_exit "Install postgresql-client now?"
  apt_update_once
  sudo apt install -y postgresql-client
else
  log_info "psql is installed"
fi
