set -euo pipefail
source "$(dirname "$0")/../lib/log.sh"
APP_DIR="${APP_DIR:-$HOME/neotree-node-api}"

if [ -d "$APP_DIR" ]; then
  log_warn "Repo already exists, skipping clone"
  if [ "${UPDATE_REPO:-0}" = "1" ]; then
    log_info "Updating repo (UPDATE_REPO=1)"
    git -C "$APP_DIR" fetch --all
    git -C "$APP_DIR" pull --ff-only
  fi
else
  git clone https://github.com/neotree/node-api.git "$APP_DIR"
fi
