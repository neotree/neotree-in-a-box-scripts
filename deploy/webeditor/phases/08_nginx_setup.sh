set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/checks.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"

APP_DIR="${APP_DIR:-$HOME/neotree/neotree-editor}"
ENV_FILE="${ENV_FILE:-$APP_DIR/.env}"
NGINX_SITE_NAME="${NGINX_SITE_NAME:-neotree-webeditor}"
NGINX_SERVER_NAME="${NGINX_SERVER_NAME:-}"
NGINX_LISTEN_PORT="${NGINX_LISTEN_PORT:-80}"

prompt() {
  local label="$1" default_value="${2:-}" input
  if [ -t 0 ]; then
    if [ -n "$default_value" ]; then
      read -p "$label [$default_value]: " input || true
      echo "${input:-$default_value}"
    else
      read -p "$label: " input || true
      echo "$input"
    fi
  else
    echo "$default_value"
  fi
}

detect_public_ip() {
  local ip
  ip="$(curl -4 -fsS ifconfig.me 2>/dev/null || true)"
  if [ -z "$ip" ]; then
    ip="$(hostname -I 2>/dev/null | awk '{print $1}')"
  fi
  echo "${ip:-127.0.0.1}"
}

if [ "${SKIP_NGINX_SETUP:-0}" = "1" ]; then
  log_warn "Skipping nginx setup (SKIP_NGINX_SETUP=1)"
  exit 0
fi

setup_step="confirm"
USE_TLS=0
CERT_PATH=""
KEY_PATH=""
SSL_DIR="/etc/ssl/neotree"
CRT_NAME="${NGINX_SITE_NAME}.crt"
KEY_NAME="${NGINX_SITE_NAME}.key"
SERVER_PORT="3000"

if [ "${PUBLIC_IP_NGINX_SETUP:-0}" = "1" ]; then
  setup_step="server_name"
fi

while true; do
  case "$setup_step" in
    confirm)
      if confirm_with_back "Configure nginx reverse proxy for Webeditor now? Press b to stay on this step."; then
        setup_step="server_name"
      else
        case $? in
          2)
            log_warn "Already at the first nginx setup step"
            continue
            ;;
          *)
            log_info "Skipping nginx setup"
            exit 0
            ;;
        esac
      fi
      ;;
    server_name)
      ensure_cmd nginx nginx

      SERVER_PORT="3000"
      if [ -f "$ENV_FILE" ]; then
        dotenv_read_var "$ENV_FILE" SERVER_PORT "3000"
        SERVER_PORT="${SERVER_PORT:-3000}"
      fi

      if [ "${PUBLIC_IP_NGINX_SETUP:-0}" = "1" ]; then
        NGINX_SERVER_NAME="${NGINX_SERVER_NAME:-$(detect_public_ip)}"
        log_info "Using public IP as WebEditor server_name: $NGINX_SERVER_NAME"
        setup_step="write"
      else
        server_name_input="$(prompt "Webeditor domain (leave blank to use server public IP)" "$NGINX_SERVER_NAME")"
        if [ -z "$server_name_input" ]; then
          NGINX_SERVER_NAME="$(detect_public_ip)"
          log_info "Using detected IP as server_name: $NGINX_SERVER_NAME"
        else
          NGINX_SERVER_NAME="$server_name_input"
        fi
        setup_step="tls"
      fi
      ;;
    tls)
      if confirm_with_back "Configure TLS with existing certificate files now? Press b to go back to the previous step."; then
        USE_TLS=1
        while true; do
          CERT_PATH="$(prompt "Path to fullchain certificate file" "$SSL_DIR/$CRT_NAME")"
          KEY_PATH="$(prompt "Path to private key file" "$SSL_DIR/$KEY_NAME")"
          if [ -f "$CERT_PATH" ] && [ -f "$KEY_PATH" ]; then
            break
          fi
          log_warn "Files not found. Please provide valid paths."
        done

        log_info "Staging certificates under $SSL_DIR"
        sudo mkdir -p "$SSL_DIR"
        sudo cp "$CERT_PATH" "$SSL_DIR/$CRT_NAME"
        sudo cp "$KEY_PATH" "$SSL_DIR/$KEY_NAME"
        sudo chown root:root "$SSL_DIR/$CRT_NAME" "$SSL_DIR/$KEY_NAME"
        sudo chmod 600 "$SSL_DIR/$KEY_NAME"
      else
        case $? in
          2)
            log_info "Returning to server name selection"
            setup_step="server_name"
            continue
            ;;
        esac
      fi
      setup_step="write"
      ;;
    write)
      SITE_FILE="/etc/nginx/sites-available/${NGINX_SITE_NAME}.conf"
      ENABLED_FILE="/etc/nginx/sites-enabled/${NGINX_SITE_NAME}.conf"

      log_info "Writing nginx config to $SITE_FILE"
      if [ "$USE_TLS" -eq 1 ]; then
sudo tee "$SITE_FILE" >/dev/null <<EOF
upstream webeditor_local {
  server 127.0.0.1:${SERVER_PORT};
}

server {
  listen ${NGINX_LISTEN_PORT};
  server_name ${NGINX_SERVER_NAME};
  return 301 https://\$host\$request_uri;
}

server {
  listen 443 ssl;
  server_name ${NGINX_SERVER_NAME};

  ssl_certificate ${SSL_DIR}/${CRT_NAME};
  ssl_certificate_key ${SSL_DIR}/${KEY_NAME};

  location / {
    proxy_pass http://webeditor_local;
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
      else
sudo tee "$SITE_FILE" >/dev/null <<EOF
upstream webeditor_local {
  server 127.0.0.1:${SERVER_PORT};
}

server {
  listen ${NGINX_LISTEN_PORT};
  server_name ${NGINX_SERVER_NAME};

  location / {
    proxy_pass http://webeditor_local;
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
      fi

      if [ ! -L "$ENABLED_FILE" ]; then
        sudo ln -s "$SITE_FILE" "$ENABLED_FILE"
      fi

      if [ -L "/etc/nginx/sites-enabled/default" ]; then
        sudo rm -f /etc/nginx/sites-enabled/default
      fi

      sudo nginx -t
      sudo systemctl reload nginx

      log_success "nginx configured for ${NGINX_SERVER_NAME}:${NGINX_LISTEN_PORT} -> 127.0.0.1:${SERVER_PORT}"
      if [ "$USE_TLS" -eq 1 ]; then
        log_success "TLS enabled; certs staged under $SSL_DIR"
      fi
      break
      ;;
  esac
done
