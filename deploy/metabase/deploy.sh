#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$BASE_DIR/../lib/log.sh"
source "$BASE_DIR/../lib/checks.sh"

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

bash "$BASE_DIR/phases/01_preflight.sh"
bash "$BASE_DIR/phases/02_prepare_app.sh"
bash "$BASE_DIR/phases/03_systemd.sh"
bash "$BASE_DIR/phases/04_nginx_setup.sh"

log_success "Metabase deployment completed successfully"
