LOG_DIR="${LOG_DIR:-$PWD/logs}"
mkdir -p "$LOG_DIR"

_log_ts() { date +"%Y-%m-%d %H:%M:%S"; }
_log_use_color() { [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; }
_log_color() {
  if _log_use_color; then
    printf "%b" "$1"
  else
    printf ""
  fi
}

_log_emit() {
  local level="$1"
  local color="$2"
  local logfile="$3"
  local message="$4"
  local ts reset line

  ts="$(_log_ts)"
  reset="$(_log_color "\033[0m")"
  line="$ts ${color}${level}${reset} $message"
  echo -e "$line"
  printf '%s %s %s\n' "$ts" "$level" "$message" >> "$LOG_DIR/$logfile"
}

log_info() {
  _log_emit "[INFO]" "$(_log_color "\033[1;34m")" "info.log" "$1"
}
log_warn() {
  _log_emit "[WARN]" "$(_log_color "\033[1;33m")" "warn.log" "$1"
}
log_error() {
  _log_emit "[ERROR]" "$(_log_color "\033[1;31m")" "error.log" "$1"
}
log_success() {
  _log_emit "[SUCCESS]" "$(_log_color "\033[1;32m")" "success.log" "$1"
}
log_component() {
  _log_emit "[COMPONENT]" "$(_log_color "\033[1;35m")" "info.log" "$1"
}
