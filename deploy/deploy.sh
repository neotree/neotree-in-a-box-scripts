#!/usr/bin/env bash
set -euo pipefail

NEOTREE_BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$NEOTREE_BASE_DIR/lib/log.sh"
source "$NEOTREE_BASE_DIR/lib/checks.sh"
source "$NEOTREE_BASE_DIR/lib/progress.sh"

NEOTREE_LOG_DIR="$NEOTREE_BASE_DIR/logs"
mkdir -p "$NEOTREE_LOG_DIR"
NEOTREE_RUN_LOG="$NEOTREE_LOG_DIR/deploy_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$NEOTREE_RUN_LOG") 2>&1
trap 'log_error "Deployment failed at line $LINENO. See $NEOTREE_RUN_LOG"; exit 1' ERR

log_info "Deploy log: $NEOTREE_RUN_LOG"

run_component() {
  local component="$1"
  local script_path="$2"

  log_component "Starting component: $component"
  bash "$script_path"
  log_success "Component succeeded: $component"
}

run_component "node-api" "$NEOTREE_BASE_DIR/node-api/deploy.sh"
run_component "webeditor" "$NEOTREE_BASE_DIR/webeditor/deploy.sh"
run_component "datapipeline" "$NEOTREE_BASE_DIR/datapipeline/deploy.sh"
run_component "metabase" "$NEOTREE_BASE_DIR/metabase/deploy.sh"

log_success "Neotree deployment completed successfully"
