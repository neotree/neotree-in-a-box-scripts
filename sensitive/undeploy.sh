#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$BASE_DIR/.." && pwd)"

LOG_DIR="$BASE_DIR/logs"
mkdir -p "$LOG_DIR"

source "$REPO_ROOT/deploy/lib/log.sh"
source "$REPO_ROOT/deploy/lib/checks.sh"

RUN_LOG="$LOG_DIR/undeploy_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$RUN_LOG") 2>&1
trap 'log_error "Undeploy failed at line $LINENO. See $RUN_LOG"; exit 1' ERR

APP_ROOT="${APP_ROOT:-$HOME/neotree}"
METABASE_INSTALL_DIR="${METABASE_INSTALL_DIR:-/opt/metabase}"
METABASE_SERVICE_NAME="${METABASE_SERVICE_NAME:-metabase}"
SSL_DIR="${SSL_DIR:-/etc/ssl/neotree}"
NODE_API_SITE_NAME="${NODE_API_SITE_NAME:-neotree-node-api}"
WEBEDITOR_SITE_NAME="${WEBEDITOR_SITE_NAME:-neotree-webeditor}"
METABASE_SITE_NAME="${METABASE_SITE_NAME:-metabase}"
DEPLOY_STATE_DIR="${DEPLOY_STATE_DIR:-$REPO_ROOT/deploy/state}"

log_info "Undeploy log: $RUN_LOG"
log_warn "This script removes Neotree apps, services, configs, and packages from this machine."
log_warn "Targets include PM2, PostgreSQL, Node.js/npm, nginx, Metabase Java runtime, Python 3.8 packages, and $APP_ROOT."

confirm_or_exit "Proceed with full undeploy?"

if [ "${AUTO_YES:-0}" != "1" ]; then
  confirm_or_exit "Final confirmation: remove Neotree and related packages from this server?"
fi

systemctl_has_unit() {
  local unit="$1"
  command -v systemctl >/dev/null 2>&1 && systemctl list-unit-files --full --all 2>/dev/null | awk '{print $1}' | grep -Fxq "$unit"
}

stop_and_disable_unit() {
  local unit="$1"
  if systemctl_has_unit "$unit"; then
    log_info "Stopping and disabling $unit"
    sudo systemctl stop "$unit" >/dev/null 2>&1 || true
    sudo systemctl disable "$unit" >/dev/null 2>&1 || true
  fi
}

remove_file_if_present() {
  local path="$1"
  if [ -e "$path" ] || [ -L "$path" ]; then
    log_info "Removing $path"
    sudo rm -rf "$path"
  fi
}

remove_dir_if_present() {
  local path="$1"
  if [ -d "$path" ]; then
    log_info "Removing $path"
    sudo rm -rf "$path"
  fi
}

remove_home_dir_if_present() {
  local path="$1"
  if [ -d "$path" ]; then
    log_info "Removing $path"
    rm -rf "$path"
  fi
}

purge_package_if_installed() {
  local package="$1"
  if dpkg -s "$package" >/dev/null 2>&1; then
    log_info "Purging package $package"
    sudo apt purge -y "$package"
  else
    log_info "Package $package not installed; skipping"
  fi
}

remove_deadsnakes_ppa() {
  if command -v add-apt-repository >/dev/null 2>&1; then
    if find /etc/apt/sources.list.d -maxdepth 1 -type f -name '*deadsnakes*' 2>/dev/null | grep -q .; then
      log_info "Removing deadsnakes PPA"
      sudo add-apt-repository -y --remove ppa:deadsnakes/ppa || true
    fi
  fi
}

cleanup_pm2() {
  if command -v pm2 >/dev/null 2>&1; then
    log_info "Stopping PM2 processes"
    pm2 delete all >/dev/null 2>&1 || true
    pm2 kill >/dev/null 2>&1 || true
  fi

  remove_home_dir_if_present "$HOME/.pm2"

  if command -v npm >/dev/null 2>&1; then
    log_info "Uninstalling global pm2 package"
    npm uninstall -g pm2 >/dev/null 2>&1 || true
    sudo npm uninstall -g pm2 >/dev/null 2>&1 || true
  fi
}

cleanup_metabase() {
  stop_and_disable_unit "${METABASE_SERVICE_NAME}.service"
  remove_file_if_present "/etc/systemd/system/${METABASE_SERVICE_NAME}.service"

  if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl daemon-reload >/dev/null 2>&1 || true
  fi

  remove_dir_if_present "$METABASE_INSTALL_DIR"

  if id -u "$METABASE_SERVICE_NAME" >/dev/null 2>&1; then
    log_info "Removing system user $METABASE_SERVICE_NAME"
    sudo userdel -r "$METABASE_SERVICE_NAME" >/dev/null 2>&1 || sudo userdel "$METABASE_SERVICE_NAME" >/dev/null 2>&1 || true
  fi
}

cleanup_nginx() {
  remove_file_if_present "/etc/nginx/sites-enabled/${NODE_API_SITE_NAME}.conf"
  remove_file_if_present "/etc/nginx/sites-enabled/${WEBEDITOR_SITE_NAME}.conf"
  remove_file_if_present "/etc/nginx/sites-enabled/${METABASE_SITE_NAME}.conf"
  remove_file_if_present "/etc/nginx/sites-available/${NODE_API_SITE_NAME}.conf"
  remove_file_if_present "/etc/nginx/sites-available/${WEBEDITOR_SITE_NAME}.conf"
  remove_file_if_present "/etc/nginx/sites-available/${METABASE_SITE_NAME}.conf"
  remove_dir_if_present "$SSL_DIR"
}

cleanup_postgresql_state() {
  stop_and_disable_unit "postgresql.service"
  remove_dir_if_present "/var/lib/postgresql"
  remove_dir_if_present "/etc/postgresql"
  remove_dir_if_present "/etc/postgresql-common"
  remove_dir_if_present "/var/log/postgresql"
}

cleanup_app_files() {
  remove_home_dir_if_present "$APP_ROOT"
  remove_home_dir_if_present "$DEPLOY_STATE_DIR"
}

remove_packages() {
  apt_update_once

  purge_package_if_installed "nginx"
  purge_package_if_installed "openjdk-17-jre-headless"
  purge_package_if_installed "postgresql"
  purge_package_if_installed "postgresql-client"
  purge_package_if_installed "postgresql-common"
  purge_package_if_installed "postgresql-client-common"
  purge_package_if_installed "nodejs"
  purge_package_if_installed "npm"
  purge_package_if_installed "python3-pip"
  purge_package_if_installed "python3.8"
  purge_package_if_installed "python3.8-minimal"
  purge_package_if_installed "python3.8-venv"
  purge_package_if_installed "python3.8-distutils"
  purge_package_if_installed "libpython3.8-stdlib"
  purge_package_if_installed "libpython3.8-minimal"
  purge_package_if_installed "software-properties-common"
  purge_package_if_installed "curl"

  log_info "Running apt autoremove"
  sudo apt autoremove -y --purge
}

cleanup_pm2
cleanup_metabase
cleanup_nginx
cleanup_postgresql_state
cleanup_app_files
remove_deadsnakes_ppa
remove_packages

log_success "Neotree undeploy completed. The server has been cleaned for a fresh deploy."
