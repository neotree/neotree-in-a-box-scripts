#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$BASE_DIR/../lib/log.sh"
source "$BASE_DIR/../lib/checks.sh"

LOG_DIR="$BASE_DIR/logs"
mkdir -p "$LOG_DIR"
RUN_LOG="$LOG_DIR/deploy_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$RUN_LOG") 2>&1
trap 'log_error "Deployment failed at line $LINENO. See $RUN_LOG"; exit 1' ERR

log_info "Starting Neotree Node API deployment"
log_info "Deploy log: $RUN_LOG"

bash "$BASE_DIR/phases/01_preflight.sh"
bash "$BASE_DIR/phases/02_clone_repo.sh"
bash "$BASE_DIR/phases/03_env_setup.sh"
bash "$BASE_DIR/phases/04_db_migrate.sh"
bash "$BASE_DIR/phases/05_node_build.sh"
bash "$BASE_DIR/phases/06_pm2_start.sh"
bash "$BASE_DIR/phases/07_post_install.sh"
bash "$BASE_DIR/phases/08_nginx_setup.sh"

log_success "Neotree nodeapi deployment completed successfully"
