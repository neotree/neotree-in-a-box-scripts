reset_email_values() {
  MAIL_MAILER=""
  MAIL_HOST=""
  MAIL_PORT=""
  MAIL_USERNAME=""
  MAIL_PASSWORD=""
  MAIL_ENCRYPTION=""
  MAIL_FROM_ADDRESS=""
  MAIL_FROM_NAME=""
  MAIL_RECEIVERS=""
}

prompt_mail_values() {
  if confirm_with_back "Configure email server variables now? Press b to skip for now."; then
    WRITE_ENV=1

    MAIL_MAILER="$(prompt_required "MAIL_MAILER (e.g. smtp)" "${MAIL_MAILER:-}")"
    MAIL_HOST="$(prompt_required "MAIL_HOST" "${MAIL_HOST:-}")"
    MAIL_PORT="$(prompt_required "MAIL_PORT" "${MAIL_PORT:-587}")"
    MAIL_USERNAME="$(prompt_required "MAIL_USERNAME" "${MAIL_USERNAME:-}")"
    if [ -n "${MAIL_PASSWORD:-}" ]; then
      local old_mail_pw new_mail_pw
      old_mail_pw="$MAIL_PASSWORD"
      new_mail_pw="$(prompt_secret "MAIL_PASSWORD (press enter to keep existing)")"
      MAIL_PASSWORD="${new_mail_pw:-$old_mail_pw}"
    else
      MAIL_PASSWORD="$(prompt_secret "MAIL_PASSWORD")"
      if [ -z "$MAIL_PASSWORD" ]; then
        log_error "MAIL_PASSWORD is required."
        exit 1
      fi
    fi
    MAIL_ENCRYPTION="$(prompt_required "MAIL_ENCRYPTION (e.g. tls)" "${MAIL_ENCRYPTION:-}")"
    MAIL_FROM_ADDRESS="$(prompt_required "MAIL_FROM_ADDRESS" "${MAIL_FROM_ADDRESS:-}")"
    MAIL_FROM_NAME="$(prompt_required "MAIL_FROM_NAME" "${MAIL_FROM_NAME:-}")"
    MAIL_RECEIVERS="$(prompt_required "MAIL_RECEIVERS (comma-separated)" "${MAIL_RECEIVERS:-}")"
    return 0
  else
    case $? in
      2) return 2 ;;
      *)
        WRITE_ENV=1
        log_warn "Skipping email configuration"
        return 1
        ;;
    esac
  fi
}

write_mail_env_file() {
  local file="$1"
  {
    dotenv_write_var MAIL_MAILER "${MAIL_MAILER:-}"
    dotenv_write_var MAIL_HOST "${MAIL_HOST:-}"
    dotenv_write_var MAIL_PORT "${MAIL_PORT:-}"
    dotenv_write_var MAIL_USERNAME "${MAIL_USERNAME:-}"
    dotenv_write_var MAIL_PASSWORD "${MAIL_PASSWORD:-}"
    dotenv_write_var MAIL_ENCRYPTION "${MAIL_ENCRYPTION:-}"
    dotenv_write_var MAIL_FROM_ADDRESS "${MAIL_FROM_ADDRESS:-}"
    dotenv_write_var MAIL_FROM_NAME "${MAIL_FROM_NAME:-}"
    dotenv_write_var MAIL_RECEIVERS "${MAIL_RECEIVERS:-}"
  } >"$file"
}
