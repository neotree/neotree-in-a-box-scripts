set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"

APP_ROOT="${APP_ROOT:-$HOME/neotree}"
APP_DIR="${APP_DIR:-$APP_ROOT/node-api}"
REPO_URL="${NODE_API_REPO:-https://github.com/neotree/node-api.git}"
REPO_BRANCH="${NODE_API_BRANCH:-auto-deploy}"

mkdir -p "$APP_ROOT"

if [ -d "$APP_DIR/.git" ]; then
  log_warn "Repo already exists at $APP_DIR"
  if [ "${UPDATE_REPO:-0}" = "1" ]; then
    log_info "Updating repo branch $REPO_BRANCH (UPDATE_REPO=1)"
    git -C "$APP_DIR" fetch --all
    git -C "$APP_DIR" checkout "$REPO_BRANCH"
    git -C "$APP_DIR" pull --ff-only origin "$REPO_BRANCH"
  fi
else
  log_info "Cloning $REPO_URL branch $REPO_BRANCH into $APP_DIR"
  git clone --branch "$REPO_BRANCH" "$REPO_URL" "$APP_DIR"
fi
