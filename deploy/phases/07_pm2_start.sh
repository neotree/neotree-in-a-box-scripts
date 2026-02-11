source "$(dirname "$0")/../lib/log.sh"
APP_DIR="$HOME/neotree-node-api"
cd "$APP_DIR"

pm2 start npm --name neotree-api -- run start:prod-server
pm2 save
