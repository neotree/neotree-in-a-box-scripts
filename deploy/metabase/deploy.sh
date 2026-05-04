#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$BASE_DIR/../lib/log.sh"
source "$BASE_DIR/../lib/checks.sh"
source "$BASE_DIR/../lib/progress.sh"

LOG_DIR="$BASE_DIR/logs"
mkdir -p "$LOG_DIR"
RUN_LOG="$LOG_DIR/deploy_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$RUN_LOG") 2>&1
trap 'log_error "Metabase deploy failed at line $LINENO. See $RUN_LOG"; exit 1' ERR

log_info "Starting Metabase deployment"
log_info "Deploy log: $RUN_LOG"

# Shared defaults (can be overridden via env)
export MB_PORT="${MB_PORT:-6000}"
export MB_MEMORY="${MB_MEMORY:-1G}"
export MB_VERSION="${MB_VERSION:-1.57.0}"
export SERVICE_NAME="${MB_SERVICE_NAME:-metabase}"
export INSTALL_DIR="${MB_INSTALL_DIR:-/opt/metabase}"
export JAVA_PACKAGE="${MB_JAVA_PACKAGE:-openjdk-17-jre-headless}"
export APP_ROOT="${APP_ROOT:-$HOME/neotree}"
export NODE_ENV_FILE="${NODE_ENV_FILE:-$APP_ROOT/node-api/.env}"

COMPONENT_NAME="metabase"

if [ ! -f "$INSTALL_DIR/metabase.jar" ] && progress_has_component_state "$COMPONENT_NAME"; then
  log_warn "Saved progress found for $COMPONENT_NAME, but Metabase is missing at $INSTALL_DIR; clearing saved progress"
  progress_clear_component "$COMPONENT_NAME"
fi

progress_prepare_component_run "$COMPONENT_NAME"

if progress_is_component_complete "$COMPONENT_NAME"; then
  log_info "Skipping $COMPONENT_NAME deployment; already completed in a previous run"
  exit 0
fi

run_tracked_phase "$COMPONENT_NAME" "01_preflight" "$BASE_DIR/phases/01_preflight.sh" "Preflight checks"
run_tracked_phase "$COMPONENT_NAME" "02_prepare_app" "$BASE_DIR/phases/02_prepare_app.sh" "Prepare application"
run_tracked_phase "$COMPONENT_NAME" "03_systemd" "$BASE_DIR/phases/03_systemd.sh" "Systemd setup"
run_tracked_phase "$COMPONENT_NAME" "04_nginx_setup" "$BASE_DIR/phases/04_nginx_setup.sh" "Nginx setup"
progress_mark_component_complete "$COMPONENT_NAME"

log_success "Metabase deployment completed successfully"
