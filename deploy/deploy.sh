#!/usr/bin/env bash
set -euo pipefail

NEOTREE_BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$NEOTREE_BASE_DIR/lib/log.sh"
source "$NEOTREE_BASE_DIR/lib/checks.sh"
source "$NEOTREE_BASE_DIR/lib/progress.sh"

NEOTREE_LOG_DIR="$NEOTREE_BASE_DIR/logs"
mkdir -p "$NEOTREE_LOG_DIR"
NEOTREE_RUN_LOG="$NEOTREE_LOG_DIR/deploy_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$NEOTREE_RUN_LOG") 2>&1
trap 'log_error "Deployment failed at line $LINENO. See $NEOTREE_RUN_LOG"; exit 1' ERR

log_info "Deploy log: $NEOTREE_RUN_LOG"

select_install_mode() {
  local mode="${INSTALL_MODE:-}"
  local answer

  if [ "${EXPRESS_INSTALL:-0}" = "1" ] || [ "${AUTOMATIC_INSTALL:-0}" = "1" ]; then
    mode="express"
  fi

  case "$mode" in
    express|automatic|auto)
      export AUTO_YES=1
      export SKIP_ADVANCED_SETUP=1
      export SETUP_PUBLIC_IP_ACCESS="${SETUP_PUBLIC_IP_ACCESS:-1}"
      log_component "Using express installation: defaults enabled, optional advanced setup skipped"
      return 0
      ;;
    custom|manual|interactive)
      log_component "Using custom installation: prompts enabled"
      return 0
      ;;
    "")
      ;;
    *)
      log_error "Unknown INSTALL_MODE '$mode'. Use express or custom."
      exit 1
      ;;
  esac

  if [ ! -t 0 ]; then
    log_warn "Non-interactive shell detected; using express installation"
    export AUTO_YES=1
    export SKIP_ADVANCED_SETUP=1
    export SETUP_PUBLIC_IP_ACCESS="${SETUP_PUBLIC_IP_ACCESS:-1}"
    log_component "Using express installation: defaults enabled, optional advanced setup skipped"
    return 0
  fi

  read -r -p "Use express installation with recommended defaults? [y/n]: " answer
  case "$answer" in
    [Nn]*)
      log_component "Using custom installation: prompts enabled"
      ;;
    *)
      export AUTO_YES=1
      export SKIP_ADVANCED_SETUP=1
      export SETUP_PUBLIC_IP_ACCESS="${SETUP_PUBLIC_IP_ACCESS:-1}"
      log_component "Using express installation: defaults enabled, optional advanced setup skipped"
      ;;
  esac
}

run_component() {
  local component="$1"
  local script_path="$2"

  log_component "Starting component: $component"
  bash "$script_path"
  log_success "Component succeeded: $component"
}

detect_public_ip() {
  local ip
  ip="$(curl -4 -fsS ifconfig.me 2>/dev/null || true)"
  if [ -z "$ip" ]; then
    ip="$(hostname -I 2>/dev/null | awk '{print $1}')"
  fi
  printf '%s\n' "${ip:-127.0.0.1}"
}

print_public_access_summary() {
  local webeditor_url="$1" metabase_url="$2" green reset
  green="\033[1;32m"
  reset="\033[0m"

  printf '\n%b' "$green"
  printf 'Public access URLs\n'
  printf 'Metabase via: %s\n' "$metabase_url"
  printf 'WebEditor via: %s\n' "$webeditor_url"
  printf 'If Metabase does not open externally, confirm port 8080 is allowed in the server firewall/security group.\n'
  printf '%b\n' "$reset"
}

setup_public_ip_access() {
  local public_ip

  public_ip="${PUBLIC_SERVER_IP:-$(detect_public_ip)}"
  PUBLIC_WEBEDITOR_URL="http://${public_ip}"
  PUBLIC_METABASE_URL="http://${public_ip}:8080"

  log_component "Configuring express public IP access for WebEditor and Metabase"

  PUBLIC_IP_NGINX_SETUP=1 \
    NGINX_SERVER_NAME="$public_ip" \
    NGINX_LISTEN_PORT=80 \
    bash "$NEOTREE_BASE_DIR/webeditor/phases/08_nginx_setup.sh"

  PUBLIC_IP_NGINX_SETUP=1 \
    NGINX_SERVER_NAME="$public_ip" \
    NGINX_LISTEN_PORT=8080 \
    bash "$NEOTREE_BASE_DIR/metabase/phases/04_nginx_setup.sh"
}

select_install_mode

run_component "node-api" "$NEOTREE_BASE_DIR/node-api/deploy.sh"
run_component "webeditor" "$NEOTREE_BASE_DIR/webeditor/deploy.sh"
run_component "datapipeline" "$NEOTREE_BASE_DIR/datapipeline/deploy.sh"
run_component "metabase" "$NEOTREE_BASE_DIR/metabase/deploy.sh"

if [ "${SETUP_PUBLIC_IP_ACCESS:-0}" = "1" ]; then
  setup_public_ip_access
fi

log_success "Neotree deployment completed successfully"

if [ -n "${PUBLIC_WEBEDITOR_URL:-}" ] && [ -n "${PUBLIC_METABASE_URL:-}" ]; then
  print_public_access_summary "$PUBLIC_WEBEDITOR_URL" "$PUBLIC_METABASE_URL"
fi
