set -euo pipefail
source "$(dirname "$0")/../lib/log.sh"
APP_DIR="${APP_DIR:-$HOME/neotree/node-api}"
cd "$APP_DIR"

if [ ! -f .env ]; then
  cp .env-example .env
  log_warn ".env created from example. Please configure and re-run deploy."
  exit 1
fi

if [ -f package-lock.json ]; then
  npm ci
else
  npm install
fi
if npm run | grep -qE " build($|:)"; then
  npm run build
else
  log_warn "No build script found in package.json, skipping build"
fi
