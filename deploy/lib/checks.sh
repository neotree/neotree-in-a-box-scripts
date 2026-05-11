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
  local started=1

  if command -v systemctl >/dev/null 2>&1; then
    if sudo systemctl enable --now postgresql; then
      started=0
    elif sudo systemctl start postgresql; then
      started=0
    fi
  fi

  if [ "$started" -ne 0 ] && command -v service >/dev/null 2>&1; then
    if sudo service postgresql start; then
      started=0
    fi
  fi

  if [ "$started" -ne 0 ] && command -v pg_lsclusters >/dev/null 2>&1 && command -v pg_ctlcluster >/dev/null 2>&1; then
    local version cluster port status owner data_dir log_file
    while read -r version cluster port status owner data_dir log_file; do
      [ -n "$version" ] || continue
      if sudo pg_ctlcluster "$version" "$cluster" start; then
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
