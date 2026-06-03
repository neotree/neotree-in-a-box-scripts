set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/checks.sh"
APP_DIR="${APP_DIR:-$HOME/neotree/neotree-editor}"
cd "$APP_DIR"

if [ ! -f .env ]; then
  cp .env-example .env
  log_warn ".env created from example. Please configure and re-run deploy."
  exit 1
fi

NPM_INSTALL_FLAGS="${NPM_INSTALL_FLAGS:---legacy-peer-deps}"

ensure_node_major 20

if [ -n "$NPM_INSTALL_FLAGS" ]; then
  log_info "Installing node dependencies with npm flags: $NPM_INSTALL_FLAGS"
else
  log_info "Installing node dependencies"
fi

if [ -f package-lock.json ]; then
  npm ci $NPM_INSTALL_FLAGS
else
  npm install $NPM_INSTALL_FLAGS
fi
if npm run | grep -qE " build($|:)"; then
  npm run build
else
  log_warn "No build script found in package.json, skipping build"
fi
