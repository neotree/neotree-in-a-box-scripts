set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"

APP_ROOT="${APP_ROOT:-$HOME/neotree}"
APP_DIR="${APP_DIR:-$APP_ROOT/neotree-editor}"

mkdir -p "$APP_ROOT"

if [ -d "$APP_DIR/.git" ]; then
  log_warn "Repo already exists at $APP_DIR"
  if [ "${UPDATE_REPO:-0}" = "1" ]; then
    log_info "Updating repo (UPDATE_REPO=1)"
    git -C "$APP_DIR" fetch --all
    git -C "$APP_DIR" pull --ff-only
  fi
else
  git clone https://github.com/neotree/neotree-editor.git "$APP_DIR"
fi
