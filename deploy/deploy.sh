#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$BASE_DIR/lib/log.sh"
source "$BASE_DIR/lib/checks.sh"

log_info "Starting Neotree Story 6 deployment"

bash "$BASE_DIR/phases/01_preflight.sh"
bash "$BASE_DIR/phases/02_dependencies.sh"
bash "$BASE_DIR/phases/03_clone_repo.sh"
bash "$BASE_DIR/phases/04_env_setup.sh"
bash "$BASE_DIR/phases/05_db_migrate.sh"
bash "$BASE_DIR/phases/06_node_build.sh"
bash "$BASE_DIR/phases/07_pm2_start.sh"
bash "$BASE_DIR/phases/08_post_install.sh"

log_success "Neotree deployment completed successfully"
