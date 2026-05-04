STATE_DIR="${NEOTREE_STATE_DIR:-${BASE_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/state}"
mkdir -p "$STATE_DIR"

_progress_component_dir() {
  local component="$1"
  printf '%s/%s\n' "$STATE_DIR" "$component"
}

_progress_component_done_file() {
  local component="$1"
  printf '%s/component.done\n' "$(_progress_component_dir "$component")"
}

_progress_phase_done_file() {
  local component="$1"
  local phase="$2"
  printf '%s/phases/%s.done\n' "$(_progress_component_dir "$component")" "$phase"
}

progress_prepare_component_run() {
  local component="$1"

  if [ "${FORCE_DEPLOY:-0}" = "1" ]; then
    progress_clear_component "$component"
    log_warn "FORCE_DEPLOY=1 set; cleared saved progress for $component"
  fi

  mkdir -p "$(_progress_component_dir "$component")/phases"
}

progress_has_component_state() {
  local component="$1"
  [ -d "$(_progress_component_dir "$component")" ]
}

progress_clear_component() {
  local component="$1"
  rm -rf "$(_progress_component_dir "$component")"
}

progress_is_component_complete() {
  local component="$1"
  [ -f "$(_progress_component_done_file "$component")" ]
}

progress_mark_component_complete() {
  local component="$1"
  mkdir -p "$(_progress_component_dir "$component")"
  printf 'completed_at=%s\n' "$(date -Iseconds)" > "$(_progress_component_done_file "$component")"
}

progress_mark_phase_complete() {
  local component="$1"
  local phase="$2"
  mkdir -p "$(_progress_component_dir "$component")/phases"
  printf 'completed_at=%s\n' "$(date -Iseconds)" > "$(_progress_phase_done_file "$component" "$phase")"
}

progress_is_phase_complete() {
  local component="$1"
  local phase="$2"
  [ -f "$(_progress_phase_done_file "$component" "$phase")" ]
}

run_tracked_phase() {
  local component="$1"
  local phase="$2"
  local script_path="$3"
  local description="${4:-$phase}"

  if progress_is_phase_complete "$component" "$phase"; then
    log_info "Skipping $component phase $phase ($description); already completed"
    return 0
  fi

  log_info "Running $component phase $phase ($description)"
  bash "$script_path"
  progress_mark_phase_complete "$component" "$phase"
  log_success "Completed $component phase $phase ($description)"
}
