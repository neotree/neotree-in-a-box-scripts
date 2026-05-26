set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/checks.sh"

PHASE_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_ROOT="${APP_ROOT:-$HOME/neotree}"
APP_DIR="${APP_DIR:-$APP_ROOT/datapipeline}"
PYTHON_BIN="${PYTHON_BIN:-python3.8}"
VENV_DIR="${VENV_DIR:-$APP_DIR/env}"
REQUIREMENTS_FILE="${REQUIREMENTS_FILE:-$APP_DIR/src/requirements.txt}"
PIP_INSTALL_FLAGS="${PIP_INSTALL_FLAGS:---use-deprecated=legacy-resolver --no-cache-dir}"
PIP_CONSTRAINT_FILE="${PIP_CONSTRAINT_FILE:-$PHASE_DIR/../constraints/python38.txt}"
PIP_CONSTRAINT_FLAGS=""

if [ ! -d "$APP_DIR" ]; then
  log_error "Datapipeline directory not found: $APP_DIR. Run clone phase first."
  exit 1
fi

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  log_error "$PYTHON_BIN is required but not found. Re-run preflight."
  exit 1
fi

ensure_datapipeline_build_prereqs "$PYTHON_BIN"

if [ ! -d "$VENV_DIR" ]; then
  log_info "Creating virtual environment at $VENV_DIR using $PYTHON_BIN"
  "$PYTHON_BIN" -m venv "$VENV_DIR"
else
  log_info "Virtual environment already exists at $VENV_DIR"
fi

if [ -n "$PIP_INSTALL_FLAGS" ]; then
  log_info "Installing Python dependencies with pip flags: $PIP_INSTALL_FLAGS"
fi

if [ -f "$PIP_CONSTRAINT_FILE" ]; then
  PIP_CONSTRAINT_FLAGS="-c $PIP_CONSTRAINT_FILE"
  log_info "Installing Python dependencies with pip constraints: $PIP_CONSTRAINT_FILE"
else
  log_warn "Pip constraints file not found at $PIP_CONSTRAINT_FILE; continuing without constraints"
fi

log_info "Upgrading pip, setuptools, and wheel"
"$VENV_DIR/bin/pip" install --upgrade pip setuptools wheel --no-cache-dir

log_info "Installing Kedro 0.17.0"
"$VENV_DIR/bin/pip" install kedro==0.17.0 $PIP_INSTALL_FLAGS $PIP_CONSTRAINT_FLAGS

if [ -f "$REQUIREMENTS_FILE" ]; then
  log_info "Installing datapipeline requirements from $REQUIREMENTS_FILE"
  "$VENV_DIR/bin/pip" install -r "$REQUIREMENTS_FILE" $PIP_INSTALL_FLAGS $PIP_CONSTRAINT_FLAGS
else
  log_warn "Requirements file not found at $REQUIREMENTS_FILE; skipping extra dependencies"
fi

log_success "Datapipeline Python environment is ready"
