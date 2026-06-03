set -euo pipefail
source "$(dirname "$0")/../../lib/log.sh"
source "$(dirname "$0")/../../lib/dotenv.sh"
source "$(dirname "$0")/../../lib/global_env.sh"

APP_ROOT="${APP_ROOT:-$HOME/neotree}"
NODE_ENV_FILE="${NODE_ENV_FILE:-$APP_ROOT/node-api/.env}"
MB_PORT="${MB_PORT:-6000}"
MB_MEMORY="${MB_MEMORY:-1G}"
MB_VERSION="${MB_VERSION:-1.57.0}"
SERVICE_NAME="${SERVICE_NAME:-metabase}"
INSTALL_DIR="${INSTALL_DIR:-/opt/metabase}"
MB_DATABASE="${MB_DATABASE:-metabase}"

if ! load_shared_pg_env; then
  PGHOST="$(dotenv_get "$NODE_ENV_FILE" PGHOST || true)"
  PGPORT="$(dotenv_get "$NODE_ENV_FILE" PGPORT || true)"
  PGUSER="$(dotenv_get "$NODE_ENV_FILE" PGUSER || true)"
  PGPASSWORD="$(dotenv_get "$NODE_ENV_FILE" PGPASSWORD || true)"
fi

if [ -z "$PGHOST" ] || [ -z "$PGPORT" ] || [ -z "$PGUSER" ] || [ -z "$PGPASSWORD" ]; then
  log_error "Missing shared PG user vars in $NODE_ENV_FILE; node-api must be configured first."
  exit 1
fi

UNIT_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

log_info "Writing systemd unit to $UNIT_FILE"
sudo tee "$UNIT_FILE" >/dev/null <<EOF
[Unit]
Description=Metabase
After=network.target postgresql.service

[Service]
User=${SERVICE_NAME}
Group=${SERVICE_NAME}
WorkingDirectory=${INSTALL_DIR}
Environment=MB_JETTY_PORT=${MB_PORT}
Environment=MB_DB_TYPE=postgres
Environment=MB_DB_DBNAME=${MB_DATABASE}
Environment=MB_DB_PORT=${PGPORT}
Environment=MB_DB_USER=${PGUSER}
Environment=MB_DB_PASS=${PGPASSWORD}
Environment=MB_DB_HOST=${PGHOST}
ExecStart=/usr/bin/java --add-opens java.base/java.nio=ALL-UNNAMED -Xmx${MB_MEMORY} -jar ${INSTALL_DIR}/metabase.jar
Restart=always
RestartSec=5
SuccessExitStatus=143
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

log_info "Reloading systemd and starting Metabase"
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl restart "$SERVICE_NAME"

metabase_available() {
  curl -fsS --max-time 2 "http://localhost:${MB_PORT}/api/health" >/dev/null 2>&1
}

log_info "Waiting for Metabase health check on port $MB_PORT"
for i in $(seq 1 20); do
  if metabase_available; then
    log_success "Metabase is up at http://$(hostname -I | awk '{print $1}'):${MB_PORT}"
    exit 0
  fi
  sleep 3
done

log_error "Metabase did not become healthy. Check logs with: sudo journalctl -u ${SERVICE_NAME} -f"
exit 1
