global_env_file() {
  printf '%s\n' "${GLOBAL_ENV_FILE:-$APP_ROOT/.env}"
}

generate_secret() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 24
  else
    od -An -N24 -tx1 /dev/urandom | tr -d ' \n'
  fi
}

load_shared_pg_env() {
  local file
  file="$(global_env_file)"

  if [ -f "$file" ]; then
    dotenv_read_var "$file" PGHOST ""
    dotenv_read_var "$file" PGPORT ""
    dotenv_read_var "$file" PGUSER ""
    dotenv_read_var "$file" PGPASSWORD ""
    return 0
  fi

  return 1
}

write_shared_pg_env() {
  local file
  file="$(global_env_file)"
  mkdir -p "$(dirname "$file")"
  {
    dotenv_write_var PGHOST "${PGHOST:-localhost}"
    dotenv_write_var PGPORT "${PGPORT:-5432}"
    dotenv_write_var PGUSER "${PGUSER:-neotree_app}"
    dotenv_write_var PGPASSWORD "${PGPASSWORD:-}"
  } >"$file"
  chmod 600 "$file"
}

ensure_shared_pg_env() {
  load_shared_pg_env || true

  PGHOST="${PGHOST:-localhost}"
  PGPORT="${PGPORT:-5432}"
  PGUSER="${PGUSER:-neotree_app}"
  PGPASSWORD="${PGPASSWORD:-$(generate_secret)}"

  write_shared_pg_env
}
