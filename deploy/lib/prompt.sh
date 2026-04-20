prompt_secret() {
  local label="$1"
  local default_value="${2:-}"
  local input=""
  local char prompt_suffix
  local old_stty

  if [ ! -t 0 ]; then
    log_error "Non-interactive shell cannot prompt for secrets."
    return 1
  fi

  if [ -n "$default_value" ]; then
    prompt_suffix=" (press enter to keep default)"
  else
    prompt_suffix=""
  fi

  printf '%s%s: ' "$label" "$prompt_suffix" >&2

  old_stty="$(stty -g)" || return 1
  trap 'stty "$old_stty" >/dev/null 2>&1' EXIT HUP INT TERM
  stty -echo -icanon min 1 time 0

  while IFS= read -r -n 1 char; do
    case "$char" in
      '')
        break
        ;;
      $'\n'|$'\r')
        break
        ;;
      $'\177'|$'\010')
        if [ -n "$input" ]; then
          input="${input%?}"
          printf '\b \b' >&2
        fi
        ;;
      *)
        input+="$char"
        printf '*' >&2
        ;;
    esac
  done

  stty "$old_stty" >/dev/null 2>&1
  trap - EXIT HUP INT TERM

  printf '\n' >&2

  if [ -n "$default_value" ] && [ -z "$input" ]; then
    input="$default_value"
  fi

  dotenv_sanitize_value "$input"
}
