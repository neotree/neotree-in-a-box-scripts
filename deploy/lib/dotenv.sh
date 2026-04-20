dotenv__trim() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

dotenv__decode() {
  local v
  v="$(dotenv__trim "$1")"

  if [[ "$v" == \"*\" ]] && [[ "$v" == *\" ]]; then
    v="${v:1:${#v}-2}"
    v="${v//\\\"/\"}"
    v="${v//\\\\/\\}"
    printf '%s' "$v"
    return 0
  fi

  if [[ "$v" == \'*\' ]] && [[ "$v" == *\' ]]; then
    v="${v:1:${#v}-2}"
    # Accept both dotenv-style and shell-style escaped single quotes.
    v="${v//\\\'/\'}"
    v="${v//"'\\''"/\'}"
    printf '%s' "$v"
    return 0
  fi

  printf '%s' "$v"
}

dotenv_get() {
  local file="$1"
  local key="$2"
  local raw

  [ -f "$file" ] || return 1

  raw="$(
    awk -v k="$key" '
      $0 ~ "^[[:space:]]*" k "[[:space:]]*=" {
        line=$0
        sub(/^[[:space:]]*[^=]+[[:space:]]*=[[:space:]]*/, "", line)
        print line
      }
    ' "$file" | tail -n 1
  )"

  [ -n "$raw" ] || return 1
  dotenv__decode "$raw"
}

dotenv_read_var() {
  local file="$1"
  local key="$2"
  local default="${3:-}"
  local value

  if value="$(dotenv_get "$file" "$key" 2>/dev/null)"; then
    printf -v "$key" '%s' "$value"
  else
    printf -v "$key" '%s' "$default"
  fi
}

dotenv_quote() {
  local value="$1"
  # Store values as double-quoted dotenv strings.
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  printf '"%s"' "$value"
}

dotenv_sanitize_value() {
  local value="$1"
  value="${value//$'\r'/}"
  value="${value//$'\n'/}"
  printf '%s' "$value"
}

dotenv_write_var() {
  local key="$1"
  local value="$2"
  printf '%s=%s\n' "$key" "$(dotenv_sanitize_value "$value")"
}
