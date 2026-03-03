#!/usr/bin/env bash
set -euo pipefail

NEOTREE_BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$NEOTREE_BASE_DIR/lib/log.sh"
source "$NEOTREE_BASE_DIR/lib/checks.sh"

NEOTREE_LOG_DIR="$NEOTREE_BASE_DIR/logs"
mkdir -p "$NEOTREE_LOG_DIR"
NEOTREE_RUN_LOG="$NEOTREE_LOG_DIR/deploy_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$NEOTREE_RUN_LOG") 2>&1
trap 'log_error "Deployment failed at line $LINENO. See $NEOTREE_RUN_LOG"; exit 1' ERR

log_info "Starting Neotree Story 6 deployment"
log_info "Deploy log: $NEOTREE_RUN_LOG"

bash "$NEOTREE_BASE_DIR/node-api/deploy.sh"
bash "$NEOTREE_BASE_DIR/webeditor/deploy.sh"

log_success "Neotree deployment completed successfully"
