APT_UPDATED=0

confirm() {
  if [ "${AUTO_YES:-0}" = "1" ]; then
    log_info "$1 [y/n]: y (AUTO_YES=1)"
    return 0
  fi
  if [ ! -t 0 ]; then
    log_error "Non-interactive shell. Set AUTO_YES=1 to proceed."
    return 1
  fi
  read -p "$1 [y/n]: " yn
  case $yn in
    [Yy]*) return 0 ;;
    *) return 1 ;;
  esac
}

confirm_with_back() {
  if [ "${AUTO_YES:-0}" = "1" ]; then
    log_info "$1 [y/n/b]: y (AUTO_YES=1)"
    return 0
  fi
  if [ ! -t 0 ]; then
    log_error "Non-interactive shell. Set AUTO_YES=1 to proceed."
    return 1
  fi
  read -p "$1 [y/n/b]: " yn
  case $yn in
    [Yy]*) return 0 ;;
    [Bb]*) return 2 ;;
    *) return 1 ;;
  esac
}

confirm_or_exit() {
  if ! confirm "$1"; then
    log_error "User declined. Exiting."
    exit 1
  fi
}

confirm_advanced_setup() {
  local component="$1"
  local includes="$2"

  if [ "${SKIP_ADVANCED_SETUP:-0}" = "1" ]; then
    log_info "Skipping $component advanced setup (SKIP_ADVANCED_SETUP=1)"
    return 1
  fi

  log_info "$component advanced setup is OPTIONAL."
  log_info "Advanced setup includes: $includes"
  confirm "Do you want to proceed with advanced setup? Choose no to skip this optional process."
}

apt_update_once() {
  if [ "$APT_UPDATED" -eq 0 ]; then
    sudo apt update
    APT_UPDATED=1
  fi
}

ensure_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log_warn "$1 not found"
    confirm_or_exit "Install $2?"
    apt_update_once
    sudo apt install -y "$2"
  else
    log_info "$1 is installed"
  fi
}

node_major_version() {
  local version
  version="$(node --version 2>/dev/null || true)"
  version="${version#v}"
  printf '%s\n' "${version%%.*}"
}

install_nodesource_node() {
  local major="$1"
  local setup_script="/tmp/nodesource_setup_${major}.x"

  ensure_cmd curl curl
  log_info "Installing Node.js ${major}.x from NodeSource"
  curl -fsSL "https://deb.nodesource.com/setup_${major}.x" -o "$setup_script"
  sudo bash "$setup_script"
  sudo apt install -y nodejs
  rm -f "$setup_script"
  hash -r 2>/dev/null || true
  install_pm2_global
}

ensure_node_major() {
  local required_major="${1:-20}"
  local current_major

  if ! command -v node >/dev/null 2>&1; then
    log_warn "node not found"
    confirm_or_exit "Install Node.js ${required_major}.x?"
    install_nodesource_node "$required_major"
  fi

  current_major="$(node_major_version)"
  if [ -z "$current_major" ] || [ "$current_major" -lt "$required_major" ]; then
    log_warn "Node.js ${required_major}.x or newer is required; current version is $(node --version 2>/dev/null || echo unknown)"
    confirm_or_exit "Upgrade Node.js to ${required_major}.x?"
    install_nodesource_node "$required_major"
    current_major="$(node_major_version)"
  fi

  if [ -z "$current_major" ] || [ "$current_major" -lt "$required_major" ]; then
    log_error "Node.js ${required_major}.x or newer is required. Current version is $(node --version 2>/dev/null || echo unknown)."
    exit 1
  fi

  if ! command -v npm >/dev/null 2>&1; then
    log_error "npm was not found after installing Node.js. Check the Node.js installation."
    exit 1
  fi

  log_info "Node.js $(node --version) and npm $(npm --version) are ready"
}

install_pm2_global() {
  local npm_bin

  npm_bin="$(command -v npm || true)"
  if [ -z "$npm_bin" ]; then
    log_error "npm not found; cannot install pm2"
    exit 1
  fi

  log_info "Installing pm2 globally"
  if echo "$npm_bin" | grep -q "$HOME"; then
    "$npm_bin" install -g pm2
  else
    sudo "$npm_bin" install -g pm2
  fi
  hash -r 2>/dev/null || true
}

ensure_pm2() {
  hash -r 2>/dev/null || true
  if command -v pm2 >/dev/null 2>&1; then
    log_info "pm2 is installed at $(command -v pm2)"
    return 0
  fi

  log_warn "pm2 not found"
  confirm_or_exit "Install pm2 globally?"
  install_pm2_global
}

python_header_available() {
  local python_bin="${1:-python3.8}"
  "$python_bin" - <<'PY' >/dev/null 2>&1
import sysconfig
from pathlib import Path
include_dir = sysconfig.get_paths().get("include", "")
raise SystemExit(0 if include_dir and (Path(include_dir) / "Python.h").exists() else 1)
PY
}

libpq_header_available() {
  local include_dir=""

  if command -v pg_config >/dev/null 2>&1; then
    include_dir="$(pg_config --includedir 2>/dev/null || true)"
    if [ -n "$include_dir" ] && [ -f "$include_dir/libpq-fe.h" ]; then
      return 0
    fi
  fi

  [ -f /usr/include/postgresql/libpq-fe.h ]
}

ensure_datapipeline_build_prereqs() {
  local python_bin="${1:-python3.8}"
  local missing_build_packages=()

  if ! python_header_available "$python_bin"; then
    missing_build_packages+=(python3.8-dev)
  fi
  if ! command -v gcc >/dev/null 2>&1; then
    missing_build_packages+=(build-essential)
  fi
  if ! libpq_header_available; then
    missing_build_packages+=(libpq-dev)
  fi

  if [ "${#missing_build_packages[@]}" -eq 0 ]; then
    log_info "Python/PostgreSQL build prerequisites are available"
    return 0
  fi

  log_warn "Missing Python/PostgreSQL build prerequisites: ${missing_build_packages[*]}"
  confirm_or_exit "Install datapipeline build prerequisites?"
  apt_update_once
  sudo apt install -y "${missing_build_packages[@]}"
}

postgresql_service_available() {
  command -v systemctl >/dev/null 2>&1 ||
    command -v service >/dev/null 2>&1 ||
    command -v pg_ctlcluster >/dev/null 2>&1
}

postgresql_cluster_exists() {
  command -v pg_lsclusters >/dev/null 2>&1 || return 1
  pg_lsclusters -h 2>/dev/null | awk 'NF >= 2 { found=1 } END { exit(found ? 0 : 1) }'
}

postgresql_server_installed() {
  compgen -G "/usr/lib/postgresql/*/bin/postgres" >/dev/null || postgresql_cluster_exists
}

create_postgresql_cluster_if_missing() {
  local version

  if postgresql_cluster_exists; then
    return 0
  fi

  if ! command -v pg_createcluster >/dev/null 2>&1; then
    log_error "PostgreSQL is installed without a cluster, and pg_createcluster is not available."
    return 1
  fi

  version="$(find /usr/lib/postgresql -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort -V | tail -n 1)"
  if [ -z "$version" ]; then
    log_error "PostgreSQL server binaries were not found under /usr/lib/postgresql."
    return 1
  fi

  log_info "Creating PostgreSQL cluster ${version}/main"
  sudo pg_createcluster "$version" main --start
}

postgresql_service_running() {
  if command -v systemctl >/dev/null 2>&1; then
    if systemctl is-active postgresql >/dev/null 2>&1; then
      return 0
    fi
  fi

  if command -v service >/dev/null 2>&1; then
    if service postgresql status >/dev/null 2>&1; then
      return 0
    fi
  fi

  if command -v pg_lsclusters >/dev/null 2>&1; then
    if pg_lsclusters -h 2>/dev/null | awk '$4 == "online" { found=1 } END { exit(found ? 0 : 1) }'; then
      return 0
    fi
  fi

  return 1
}

start_postgresql_service() {
  local started=1

  create_postgresql_cluster_if_missing || return 1

  if command -v systemctl >/dev/null 2>&1; then
    if sudo systemctl enable --now postgresql >/dev/null 2>&1; then
      started=0
    elif sudo systemctl start postgresql >/dev/null 2>&1; then
      started=0
    fi
  fi

  if [ "$started" -ne 0 ] && command -v service >/dev/null 2>&1; then
    if sudo service postgresql start >/dev/null 2>&1; then
      started=0
    fi
  fi

  if [ "$started" -ne 0 ] && command -v pg_lsclusters >/dev/null 2>&1 && command -v pg_ctlcluster >/dev/null 2>&1; then
    local version cluster port status owner data_dir log_file
    while read -r version cluster port status owner data_dir log_file; do
      [ -n "$version" ] || continue
      if sudo pg_ctlcluster "$version" "$cluster" start >/dev/null 2>&1; then
        started=0
      fi
    done <<EOF
$(pg_lsclusters -h 2>/dev/null || true)
EOF
  fi

  if [ "$started" -eq 0 ]; then
    return 0
  fi

  log_error "Could not start PostgreSQL using systemctl, service, or pg_ctlcluster."
  return 1
}

ensure_postgresql_contrib() {
  if ! command -v dpkg-query >/dev/null 2>&1; then
    log_warn "Cannot verify postgresql-contrib because dpkg-query is not available"
    return 0
  fi

  if dpkg-query -W -f='${Status}' postgresql-contrib 2>/dev/null | grep -q "install ok installed"; then
    log_info "postgresql-contrib is installed"
    return 0
  fi

  log_warn "postgresql-contrib is not installed; it provides PostgreSQL extension files such as uuid-ossp"
  confirm_or_exit "Install postgresql-contrib?"
  apt_update_once
  sudo apt install -y postgresql-contrib
}
