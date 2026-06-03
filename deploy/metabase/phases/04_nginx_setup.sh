set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/checks.sh"

MB_PORT="${MB_PORT:-6000}"
SERVICE_NAME="${SERVICE_NAME:-metabase}"
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

if [ "${PUBLIC_IP_NGINX_SETUP:-0}" = "1" ]; then
  server_name="${NGINX_SERVER_NAME:-$(detect_public_ip)}"
  log_info "Using public IP as Metabase server_name: $server_name"
else
  server_name="$(prompt "Metabase domain (leave blank to use server public IP)" "$NGINX_SERVER_NAME")"
  if [ -z "$server_name" ]; then
    server_name="$(detect_public_ip)"
    log_info "Using detected IP as server_name: $server_name"
  fi
fi

setup_step="tls"
USE_TLS=0
CERT_PATH=""
KEY_PATH=""
SSL_DIR="/etc/ssl/neotree"

if [ "${PUBLIC_IP_NGINX_SETUP:-0}" = "1" ]; then
  setup_step="write"
fi

while true; do
  case "$setup_step" in
    tls)
      if confirm_with_back "Configure TLS with existing certificate files now? Press b to go back to the previous step."; then
        USE_TLS=1
        while true; do
          CERT_PATH="$(prompt "Path to fullchain certificate file" "$SSL_DIR/${SERVICE_NAME}.crt")"
          KEY_PATH="$(prompt "Path to private key file" "$SSL_DIR/${SERVICE_NAME}.key")"
          if [ -f "$CERT_PATH" ] && [ -f "$KEY_PATH" ]; then
            break
          fi
          log_warn "Files not found. Please provide valid paths."
        done

        log_info "Staging certificates under $SSL_DIR"
        sudo mkdir -p "$SSL_DIR"
        sudo cp "$CERT_PATH" "$SSL_DIR/${SERVICE_NAME}.crt"
        sudo cp "$KEY_PATH" "$SSL_DIR/${SERVICE_NAME}.key"
        sudo chown root:root "$SSL_DIR/${SERVICE_NAME}.crt" "$SSL_DIR/${SERVICE_NAME}.key"
        sudo chmod 600 "$SSL_DIR/${SERVICE_NAME}.key"
      else
        case $? in
          2)
            log_info "Returning to server name selection"
            server_name="$(prompt "Metabase domain (leave blank to use server public IP)" "$server_name")"
            if [ -z "$server_name" ]; then
              server_name="$(detect_public_ip)"
              log_info "Using detected IP as server_name: $server_name"
            fi
            continue
            ;;
        esac
      fi
      setup_step="write"
      ;;
    write)
      ensure_cmd nginx nginx
      SITE_FILE="/etc/nginx/sites-available/${SERVICE_NAME}.conf"

      log_info "Writing nginx config to $SITE_FILE"
      if [ "$USE_TLS" -eq 1 ]; then
  sudo tee "$SITE_FILE" >/dev/null <<EOF
upstream metabase_local {
  server 127.0.0.1:${MB_PORT};
}

server {
  listen ${NGINX_LISTEN_PORT};
  server_name ${server_name};
  return 301 https://\$host\$request_uri;
}

server {
  listen 443 ssl;
  server_name ${server_name};

  ssl_certificate ${SSL_DIR}/${SERVICE_NAME}.crt;
  ssl_certificate_key ${SSL_DIR}/${SERVICE_NAME}.key;

  location / {
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_pass http://metabase_local;
  }
}
EOF
      else
  sudo tee "$SITE_FILE" >/dev/null <<EOF
upstream metabase_local {
  server 127.0.0.1:${MB_PORT};
}

server {
  listen ${NGINX_LISTEN_PORT};
  server_name ${server_name};

  location / {
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_pass http://metabase_local;
  }
}
EOF
      fi

      sudo ln -sf "$SITE_FILE" "/etc/nginx/sites-enabled/${SERVICE_NAME}.conf"

      log_info "Testing nginx configuration"
      sudo nginx -t

      log_info "Reloading nginx"
      sudo systemctl reload nginx

      if ! curl -fsS --max-time 5 "http://127.0.0.1:${NGINX_LISTEN_PORT}/api/health" >/dev/null 2>&1; then
        log_error "nginx is not proxying Metabase on local port ${NGINX_LISTEN_PORT}. Check Metabase with: curl -I http://127.0.0.1:${MB_PORT}/api/health"
        exit 1
      fi

      log_success "Nginx configured for Metabase at http://${server_name}:${NGINX_LISTEN_PORT}"
      if [ "$USE_TLS" -eq 1 ]; then
        log_success "TLS enabled; certificate staged under $SSL_DIR"
      fi
      break
      ;;
  esac
done
