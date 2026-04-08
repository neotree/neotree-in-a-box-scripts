set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/checks.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"

APP_DIR="${APP_DIR:-$HOME/neotree/node-api}"
ENV_FILE="${ENV_FILE:-$APP_DIR/.env}"
NGINX_SITE_NAME="${NGINX_SITE_NAME:-neotree-node-api}"
NGINX_SERVER_NAME="${NGINX_SERVER_NAME:-_}"

if [ "${SKIP_NGINX_SETUP:-0}" = "1" ]; then
  log_warn "Skipping nginx setup (SKIP_NGINX_SETUP=1)"
  exit 0
fi

if ! confirm "Configure nginx reverse proxy for Node API now?"; then
  log_info "Skipping nginx setup"
  exit 0
fi

if ! command -v nginx >/dev/null 2>&1; then
  log_warn "nginx not found"
  confirm_or_exit "Install nginx now?"
  apt_update_once
  sudo apt install -y nginx
fi

SERVER_PORT="3000"
if [ -f "$ENV_FILE" ]; then
  dotenv_read_var "$ENV_FILE" SERVER_PORT "3000"
  SERVER_PORT="${SERVER_PORT:-3000}"
fi

SITE_FILE="/etc/nginx/sites-available/${NGINX_SITE_NAME}.conf"
ENABLED_FILE="/etc/nginx/sites-enabled/${NGINX_SITE_NAME}.conf"

sudo tee "$SITE_FILE" >/dev/null <<EOF
server {
    listen 80;
    server_name ${NGINX_SERVER_NAME};

    location / {
        proxy_pass http://127.0.0.1:${SERVER_PORT};
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

if [ ! -L "$ENABLED_FILE" ]; then
  sudo ln -s "$SITE_FILE" "$ENABLED_FILE"
fi

if [ -L "/etc/nginx/sites-enabled/default" ]; then
  sudo rm -f /etc/nginx/sites-enabled/default
fi

sudo nginx -t
sudo systemctl restart nginx

log_success "nginx configured for ${NGINX_SERVER_NAME} -> 127.0.0.1:${SERVER_PORT}"
