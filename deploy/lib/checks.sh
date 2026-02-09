confirm() {
  read -p "$1 [y/n]: " yn
  case $yn in
    [Yy]*) return 0 ;;
    *) log_error "User declined. Exiting."; exit 1 ;;
  esac
}

ensure_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log_warn "$1 not found"
    confirm "Install $2?"
    sudo apt update && sudo apt install -y "$2"
  else
    log_info "$1 is installed"
  fi
}
