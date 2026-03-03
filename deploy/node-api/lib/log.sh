_log_ts() { date +"%Y-%m-%d %H:%M:%S"; }
_log_use_color() { [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; }
_log_color() {
  if _log_use_color; then
    printf "%b" "$1"
  else
    printf ""
  fi
}

log_info() {
  local c_reset c_info
  c_info="$(_log_color "\033[1;34m")"
  c_reset="$(_log_color "\033[0m")"
  echo -e "$(_log_ts) ${c_info}[INFO]${c_reset} $1"
}
log_warn() {
  local c_reset c_warn
  c_warn="$(_log_color "\033[1;33m")"
  c_reset="$(_log_color "\033[0m")"
  echo -e "$(_log_ts) ${c_warn}[WARN]${c_reset} $1"
}
log_error() {
  local c_reset c_err
  c_err="$(_log_color "\033[1;31m")"
  c_reset="$(_log_color "\033[0m")"
  echo -e "$(_log_ts) ${c_err}[ERROR]${c_reset} $1"
}
log_success() {
  local c_reset c_ok
  c_ok="$(_log_color "\033[1;32m")"
  c_reset="$(_log_color "\033[0m")"
  echo -e "$(_log_ts) ${c_ok}[SUCCESS]${c_reset} $1"
}
