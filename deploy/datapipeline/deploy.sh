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
trap 'log_error "Datapipeline deploy failed at line $LINENO. See $RUN_LOG"; exit 1' ERR

log_info "Starting Neotree datapipeline deployment"
log_info "Deploy log: $RUN_LOG"

COMPONENT_NAME="datapipeline"
progress_prepare_component_run "$COMPONENT_NAME"

if progress_is_component_complete "$COMPONENT_NAME"; then
  log_info "Skipping $COMPONENT_NAME deployment; already completed in a previous run"
  exit 0
fi

run_tracked_phase "$COMPONENT_NAME" "01_preflight" "$BASE_DIR/phases/01_preflight.sh" "Preflight checks"
run_tracked_phase "$COMPONENT_NAME" "02_clone_repo" "$BASE_DIR/phases/02_clone_repo.sh" "Clone or update repo"
run_tracked_phase "$COMPONENT_NAME" "03_config_setup" "$BASE_DIR/phases/03_config_setup.sh" "Configuration setup"
run_tracked_phase "$COMPONENT_NAME" "04_python_setup" "$BASE_DIR/phases/04_python_setup.sh" "Python environment setup"
progress_mark_component_complete "$COMPONENT_NAME"

log_success "Neotree datapipeline deployment completed successfully"
