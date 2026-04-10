set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"

APP_ROOT="${APP_ROOT:-$HOME/neotree}"
APP_DIR="${APP_DIR:-$APP_ROOT/datapipeline}"
REPO_URL="${DATAPIPELINE_REPO:-https://github.com/neotree/neotree-data-pipeline-kedro.git}"
REPO_BRANCH="${DATAPIPELINE_BRANCH:-main}"

log_info "Cloning datapipeline repository"
mkdir -p "$APP_ROOT"

if [ -d "$APP_DIR/.git" ]; then
  log_warn "Repo already exists at $APP_DIR"
  if [ "${UPDATE_REPO:-0}" = "1" ]; then
    log_info "Updating repo (UPDATE_REPO=1)"
    git -C "$APP_DIR" fetch --all
    git -C "$APP_DIR" checkout "$REPO_BRANCH" 2>/dev/null || true
    git -C "$APP_DIR" pull --ff-only
  fi
else
  log_info "Cloning from $REPO_URL into $APP_DIR"
  git clone "$REPO_URL" "$APP_DIR"
  if [ -n "$REPO_BRANCH" ] && [ "$REPO_BRANCH" != "main" ]; then
    git -C "$APP_DIR" checkout "$REPO_BRANCH" || log_warn "Branch $REPO_BRANCH not found; staying on default"
  fi
fi
