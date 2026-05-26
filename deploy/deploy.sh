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

select_install_mode() {
  local mode="${INSTALL_MODE:-}"
  local answer

  if [ "${EXPRESS_INSTALL:-0}" = "1" ] || [ "${AUTOMATIC_INSTALL:-0}" = "1" ]; then
    mode="express"
  fi

  case "$mode" in
    express|automatic|auto)
      export AUTO_YES=1
      export SKIP_ADVANCED_SETUP=1
      log_component "Using express installation: defaults enabled, optional advanced setup skipped"
      return 0
      ;;
    custom|manual|interactive)
      log_component "Using custom installation: prompts enabled"
      return 0
      ;;
    "")
      ;;
    *)
      log_error "Unknown INSTALL_MODE '$mode'. Use express or custom."
      exit 1
      ;;
  esac

  if [ ! -t 0 ]; then
    log_warn "Non-interactive shell detected; using express installation"
    export AUTO_YES=1
    export SKIP_ADVANCED_SETUP=1
    log_component "Using express installation: defaults enabled, optional advanced setup skipped"
    return 0
  fi

  read -r -p "Use express installation with recommended defaults? [Y/n]: " answer
  case "$answer" in
    [Nn]*)
      log_component "Using custom installation: prompts enabled"
      ;;
    *)
      export AUTO_YES=1
      export SKIP_ADVANCED_SETUP=1
      log_component "Using express installation: defaults enabled, optional advanced setup skipped"
      ;;
  esac
}

run_component() {
  local component="$1"
  local script_path="$2"

  log_component "Starting component: $component"
  bash "$script_path"
  log_success "Component succeeded: $component"
}

select_install_mode

run_component "node-api" "$NEOTREE_BASE_DIR/node-api/deploy.sh"
run_component "webeditor" "$NEOTREE_BASE_DIR/webeditor/deploy.sh"
run_component "datapipeline" "$NEOTREE_BASE_DIR/datapipeline/deploy.sh"
run_component "metabase" "$NEOTREE_BASE_DIR/metabase/deploy.sh"

log_success "Neotree deployment completed successfully"
