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

postgresql_service_available() {
  command -v systemctl >/dev/null 2>&1 || command -v service >/dev/null 2>&1
}

postgresql_service_running() {
  if command -v systemctl >/dev/null 2>&1; then
    systemctl is-active postgresql >/dev/null 2>&1
    return $?
  fi

  if command -v service >/dev/null 2>&1; then
    service postgresql status >/dev/null 2>&1
    return $?
  fi

  return 1
}

start_postgresql_service() {
  if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl enable --now postgresql
    return $?
  fi

  if command -v service >/dev/null 2>&1; then
    sudo service postgresql start
    return $?
  fi

  log_error "No supported service manager found to start PostgreSQL."
  return 1
}
