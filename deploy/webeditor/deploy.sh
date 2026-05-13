#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$BASE_DIR/../lib/log.sh"
source "$BASE_DIR/../lib/checks.sh"
source "$BASE_DIR/../lib/progress.sh"
source "$BASE_DIR/../lib/prompt.sh"

LOG_DIR="$BASE_DIR/logs"
mkdir -p "$LOG_DIR"
RUN_LOG="$LOG_DIR/deploy_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$RUN_LOG") 2>&1
trap 'log_error "Deployment failed at line $LINENO. See $RUN_LOG"; exit 1' ERR

log_info "Starting Neotree Webeditor deployment"
log_info "Deploy log: $RUN_LOG"

COMPONENT_NAME="webeditor"
APP_ROOT="${APP_ROOT:-$HOME/neotree}"
APP_DIR="${APP_DIR:-$APP_ROOT/neotree-editor}"

if [ ! -d "$APP_DIR" ] && progress_has_component_state "$COMPONENT_NAME"; then
  log_warn "Saved progress found for $COMPONENT_NAME, but app directory is missing at $APP_DIR; clearing saved progress"
  progress_clear_component "$COMPONENT_NAME"
fi

progress_prepare_component_run "$COMPONENT_NAME"

if progress_is_component_complete "$COMPONENT_NAME"; then
  log_info "Skipping $COMPONENT_NAME deployment; already completed in a previous run"
  exit 0
fi

run_tracked_phase "$COMPONENT_NAME" "01_preflight" "$BASE_DIR/phases/01_preflight.sh" "Preflight checks"
run_tracked_phase "$COMPONENT_NAME" "02_clone_repo" "$BASE_DIR/phases/02_clone_repo.sh" "Clone or update repo"
run_tracked_phase "$COMPONENT_NAME" "03_env_setup" "$BASE_DIR/phases/03_env_setup.sh" "Environment setup"
run_tracked_phase "$COMPONENT_NAME" "04_db_migrate" "$BASE_DIR/phases/04_db_migrate.sh" "Database migration"
run_tracked_phase "$COMPONENT_NAME" "05_node_build" "$BASE_DIR/phases/05_node_build.sh" "Install node dependencies"
run_tracked_phase "$COMPONENT_NAME" "06_pm2_start" "$BASE_DIR/phases/06_pm2_start.sh" "Start PM2 process"
run_tracked_phase "$COMPONENT_NAME" "07_post_install" "$BASE_DIR/phases/07_post_install.sh" "Post-install checks"
if confirm_advanced_setup "Webeditor" "email server variables, nginx reverse proxy, domain or public IP setup, and optional TLS certificate configuration"; then
  run_tracked_phase "$COMPONENT_NAME" "09_advanced_setup" "$BASE_DIR/phases/09_advanced_setup.sh" "Advanced setup"
else
  log_info "Skipping advanced setup"
fi
progress_mark_component_complete "$COMPONENT_NAME"

log_success "Neotree editor deployment completed successfully"
