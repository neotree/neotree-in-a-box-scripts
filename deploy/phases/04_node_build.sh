source "$(dirname "$0")/../lib/log.sh"
APP_DIR="$HOME/neotree-node-api"
cd "$APP_DIR"

if [ ! -f .env ]; then
  cp .env-example .env
  log_warn ".env created from example. Please configure and re-run deploy."
  exit 1
fi

npm install
npm run build
