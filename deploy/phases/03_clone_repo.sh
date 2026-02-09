source "$(dirname "$0")/../lib/log.sh"
APP_DIR="$HOME/neotree-node-api"

if [ -d "$APP_DIR" ]; then
  log_warn "Repo already exists, skipping clone"
else
  git clone https://github.com/neotree/node-api.git "$APP_DIR"
fi
