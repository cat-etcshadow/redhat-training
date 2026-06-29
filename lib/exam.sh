#!/usr/bin/env bash
# exam.sh — session orchestration: new, train, shell, grade, reset, destroy, status, hint

# ── new (exam mode) ───────────────────────────────────────────────────────────
cmd_new() {
  rhtr_require_no_state

  local profile_name="full"
  local fixed_name=""
  local topic_override=""
  RHEL_VERSION="${DEFAULT_RHEL_VERSION:-9}"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --profile) profile_name="$2"; shift 2 ;;
      --fixed)   fixed_name="$2";   shift 2 ;;
      --topic)   topic_override="$2"; shift 2 ;;
      --rhel)    RHEL_VERSION="$2";  shift 2 ;;
      *) die "Unknown flag: $1" ;;
    esac
  done

  _load_selection_source "$profile_name" "$fixed_name" "$topic_override"

  info "Selecting tasks..."
  local selected_tasks=()
  TOPIC_OVERRIDE="$topic_override"
  mapfile -t selected_tasks < <(select_tasks)

  [[ ${#selected_tasks[@]} -gt 0 ]] \
    || die "No compatible tasks found for RHEL $RHEL_VERSION. Try adding tasks or changing --rhel."

  _start_session "exam" "${selected_tasks[@]}"
}

# ── train ─────────────────────────────────────────────────────────────────────
cmd_train() {
  rhtr_require_no_state

  local topic_override=""
  local filter_diff=""
  RHEL_VERSION="${DEFAULT_RHEL_VERSION:-9}"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --topic)      topic_override="$2"; shift 2 ;;
      --difficulty) filter_diff="$2";    shift 2 ;;
      --rhel)       RHEL_VERSION="$2";   shift 2 ;;
      *) die "Unknown flag: $1" ;;
    esac
  done

  # Train mode: always uses topic-all or full catalog; no profiles/fixed
  TOPIC_OVERRIDE="${topic_override:-}"
  TOPICS=()  # not used in train
  FIXED_TASKS=()

  if [[ -n "$topic_override" ]]; then
    NAME="Train: $topic_override"
  else
    NAME="Train: $CERT (all topics)"
  fi
  DURATION=0   # no timer in train mode
  PASS_THRESHOLD="${PASS_THRESHOLD:-70}"

  local selected_tasks=()
  mapfile -t selected_tasks < <(
    if [[ -n "$topic_override" ]]; then
      _select_topic_all "$topic_override"
    else
      # All tasks across all chapters, filtered by RHEL version
      while IFS= read -r d; do
        _task_compatible "$d" && echo "$d"
      done < <(find "$RHTR_DIR/certs/$CERT/tasks" -mindepth 2 -maxdepth 2 -type d | sort)
    fi
  )

  # Apply difficulty filter if given
  if [[ -n "$filter_diff" ]]; then
    local filtered=()
    for task_dir in "${selected_tasks[@]}"; do
      local DIFFICULTY=""
      source "$task_dir/meta.sh"
      [[ "$DIFFICULTY" == "$filter_diff" ]] && filtered+=("$task_dir")
    done
    selected_tasks=("${filtered[@]}")
  fi

  [[ ${#selected_tasks[@]} -gt 0 ]] || die "No tasks match the given filters."

  _start_session "train" "${selected_tasks[@]}"
}

# ── shared session start ──────────────────────────────────────────────────────
_start_session() {
  local mode="$1"; shift
  local selected_tasks=("$@")

  # Verify image exists before doing anything
  vm_require_image "rocky${RHEL_VERSION}"

  # Persist state; trap ensures cleanup if anything below fails
  mkdir -p "$STATE_DIR"
  trap "rm -rf '$STATE_DIR'; die 'Session setup failed — state cleaned up'" EXIT
  echo "$CERT" > "$STATE_DIR/cert"
  printf '%s\n' "${selected_tasks[@]}" > "$STATE_DIR/active-tasks.txt"

  DEADLINE_EPOCH=0
  if [[ $DURATION -gt 0 ]]; then
    DEADLINE_EPOCH=$(( $(date +%s) + DURATION * 60 ))
  fi

  cat > "$STATE_DIR/exam.conf" <<EOF
CERT="$CERT"
NAME="$NAME"
MODE="$mode"
RHEL_VERSION="$RHEL_VERSION"
DURATION=$DURATION
PASS_THRESHOLD=${PASS_THRESHOLD:-70}
DEADLINE_EPOCH=$DEADLINE_EPOCH
EOF

  # Persist task list outside STATE_DIR so it survives state cleanup on failure
  mkdir -p "$RHTR_DIR/.last-session"
  printf '%s\n' "${selected_tasks[@]}" > "$RHTR_DIR/.last-session/tasks.txt"
  printf 'CERT="%s"\nNAME="%s"\nRHEL_VERSION="%s"\nDURATION=%s\nPASS_THRESHOLD=%s\n' \
    "$CERT" "$NAME" "$RHEL_VERSION" "$DURATION" "${PASS_THRESHOLD:-70}" \
    > "$RHTR_DIR/.last-session/meta.conf"

  # Build VM environment via topology
  info "Building VM environment (RHEL $RHEL_VERSION)..."
  topology_create

  info "Creating pre-exam snapshot..."
  for vm in "${VM_NAMES[@]}"; do
    vm_snapshot_create "$vm"
  done

  # Generate per-task random parameters (once per session — stable across resets)
  _generate_task_params

  # Apply setup scripts
  info "Applying task setups..."
  local i=1
  for task_dir in "${selected_tasks[@]}"; do
    local setup="$task_dir/setup.sh"
    if [[ -f "$setup" ]]; then
      printf "  [%d/%d] %s\n" "$i" "${#selected_tasks[@]}" "$(task_short_name "$task_dir")"
      _run_task_script "${VM_NAMES[0]}" "$setup" "$task_dir"
    fi
    (( i++ ))
  done

  trap - EXIT
  _display_tasks "${selected_tasks[@]}"
}

# ── show tasks from active session or last-session backup ────────────────────
cmd_tasks() {
  local tasks=()

  if [[ -f "$STATE_DIR/active-tasks.txt" ]]; then
    source "$STATE_DIR/exam.conf"
    mapfile -t tasks < "$STATE_DIR/active-tasks.txt"
  elif [[ -f "$RHTR_DIR/.last-session/tasks.txt" ]]; then
    warn "No active session — showing last session tasks"
    source "$RHTR_DIR/.last-session/meta.conf"
    mapfile -t tasks < "$RHTR_DIR/.last-session/tasks.txt"
    DEADLINE_EPOCH=0
  else
    die "No tasks to show. No active session and no previous session found."
  fi

  [[ ${#tasks[@]} -gt 0 ]] || die "Task list is empty."
  _display_tasks "${tasks[@]}"
}

# ── display task list to candidate ───────────────────────────────────────────
_display_tasks() {
  local tasks=("$@")
  clear

  source "$RHTR_DIR/certs/$CERT/cert.conf"
  local total_pts=0

  echo ""
  echo -e "${C_BOLD}$NAME${C_RESET}"
  echo -e "${C_DIM}$CERT_FULL_NAME · RHEL $RHEL_VERSION${C_RESET}"
  if [[ $DURATION -gt 0 ]]; then
    echo -e "${C_DIM}Duration: ${DURATION} min · Ends: $(epoch_to_hhmm "$DEADLINE_EPOCH")${C_RESET}"
  else
    echo -e "${C_DIM}Training mode — no time limit${C_RESET}"
  fi
  echo ""

  local i=1
  for task_dir in "${tasks[@]}"; do
    local POINTS=0 TITLE=""
    source "$task_dir/meta.sh"
    (( total_pts += POINTS ))

    echo -e "${C_CYAN}── Task $i  (${POINTS} pts) ──────────────────────────────────${C_RESET}"
    echo ""
    _render_task_md "$task_dir"
    echo ""
    (( i++ ))
  done

  echo -e "${C_BOLD}── Summary ────────────────────────────────────────────────${C_RESET}"
  echo "  Tasks:   ${#tasks[@]}"
  echo "  Total:   $total_pts pts"
  echo "  Pass:    ≥${PASS_THRESHOLD:-70}%  of total"
  echo ""
  echo "  Access:  rhtr $CERT shell"
  echo "  Grade:   rhtr $CERT grade"
  [[ ${#VM_NAMES[@]} -gt 1 ]] && echo "  Nodes:   ${VM_NAMES[*]}"
  echo ""
}

# ── session commands ──────────────────────────────────────────────────────────
cmd_shell() {
  rhtr_require_state
  source "$STATE_DIR/exam.conf"
  source "$RHTR_DIR/certs/$CERT/topology.sh"
  topology_names

  local node=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --node) node="$2"; shift 2 ;;
      *) die "Unknown flag: $1" ;;
    esac
  done

  if [[ -n "$node" ]]; then
    local found=0
    for vm in "${VM_NAMES[@]}"; do
      if [[ "$vm" == *"$node"* ]]; then
        vm_shell "$vm"; found=1; break
      fi
    done
    if [[ $found -eq 0 ]]; then
      die "Node '$node' not found. Available: ${VM_NAMES[*]}"
    fi
  else
    vm_shell "${VM_NAMES[0]}"
  fi
}

cmd_grade() {
  rhtr_require_state
  source "$STATE_DIR/exam.conf"
  source "$RHTR_DIR/certs/$CERT/topology.sh"
  topology_names
  grade_all_tasks

  # Record results in progress (train mode only, or always — your call)
  local mode; mode=$(grep '^MODE=' "$STATE_DIR/exam.conf" | cut -d'"' -f2)
  if [[ "$mode" == "train" ]] && [[ -f "$STATE_DIR/grades.txt" ]]; then
    while IFS='|' read -r task_dir result _pts_earned _pts_total; do
      progress_record "$CERT" "$task_dir" "$result"
    done < "$STATE_DIR/grades.txt"
  fi
}

cmd_reset() {
  rhtr_require_state
  source "$STATE_DIR/exam.conf"
  source "$RHTR_DIR/certs/$CERT/topology.sh"
  topology_names

  info "Restoring pre-exam snapshot..."
  for vm in "${VM_NAMES[@]}"; do
    vm_snapshot_restore "$vm"
  done

  info "Re-applying task setups..."
  local _reset_tasks=()
  mapfile -t _reset_tasks < "$STATE_DIR/active-tasks.txt"
  local _rt
  for _rt in "${_reset_tasks[@]}"; do
    local setup="$_rt/setup.sh"
    [[ -f "$setup" ]] && _run_task_script "${VM_NAMES[0]}" "$setup" "$_rt"
  done

  # Clear previous grades so the candidate starts fresh
  : > "$STATE_DIR/grades.txt"
  ok "Reset complete."
}

cmd_destroy() {
  if [[ ! -f "$STATE_DIR/exam.conf" ]]; then
    ok "No active session."
    return 0
  fi

  source "$STATE_DIR/exam.conf"
  source "$RHTR_DIR/certs/$CERT/topology.sh"

  info "Destroying VMs..."
  topology_destroy || warn "VM teardown had errors — cleaning up state anyway"

  rm -rf "$STATE_DIR"
  ok "Session destroyed."
}

cmd_status() {
  rhtr_require_state
  source "$STATE_DIR/exam.conf"

  echo ""
  echo -e "${C_BOLD}$NAME${C_RESET}"
  echo "  Cert:  $CERT · RHEL $RHEL_VERSION"
  echo "  Mode:  $MODE"

  if [[ $DURATION -gt 0 && -n "$DEADLINE_EPOCH" ]]; then
    local now; now=$(date +%s)
    if [[ $now -gt $DEADLINE_EPOCH ]]; then
      echo -e "  Time:  ${C_RED}OVERTIME${C_RESET}"
    else
      local rem=$(( DEADLINE_EPOCH - now ))
      echo "  Time:  $(seconds_to_hms $rem) remaining"
    fi
  else
    echo "  Time:  (no limit — train mode)"
  fi

  local task_count; task_count=$(wc -l < "$STATE_DIR/active-tasks.txt")
  echo "  Tasks: $task_count"

  if [[ -s "$STATE_DIR/grades.txt" ]]; then
    echo ""
    echo "  Last grade:"
    print_cached_report
  fi
  echo ""
}

cmd_hint() {
  rhtr_require_state
  source "$STATE_DIR/exam.conf"

  [[ "$MODE" == "train" ]] || die "'hint' is only available in train mode."

  # Show hint for the first ungraded task (or let user specify a number)
  local task_num="${1:-1}"
  local task_dir
  task_dir=$(sed -n "${task_num}p" "$STATE_DIR/active-tasks.txt")
  [[ -n "$task_dir" ]] || die "Task $task_num not found."

  local hint="$task_dir/hint.md"
  if [[ -f "$hint" ]]; then
    echo ""
    echo -e "${C_YELLOW}Hint — Task $task_num: $(task_short_name "$task_dir")${C_RESET}"
    echo ""
    cat "$hint"
    echo ""
  else
    warn "No hint available for task $task_num: $(task_short_name "$task_dir")"
  fi
}

# ── parameterized task helpers ────────────────────────────────────────────────

# Run a task script (setup or grade) inside the VM with its random params
# prepended as shell variable assignments.  If no params.sh exists for the
# task the script is run as-is (backwards-compatible with unparam tasks).
_run_task_script() {
  local vm="$1" script="$2" task_dir="$3"
  [[ -f "$script" ]] || die "Script not found: $script"

  local slug; slug=$(task_slug "$task_dir")
  local params_file="$STATE_DIR/task-params/${slug}.env"

  if [[ ! -f "$params_file" ]]; then
    vm_exec_script "$vm" "$script"
    return
  fi

  local tmp rc=0
  tmp=$(mktemp --suffix=.sh)
  {
    printf '#!/usr/bin/env bash\n'
    cat "$params_file"
    printf '\n'
    tail -n +2 "$script"   # skip the original shebang
  } > "$tmp"
  chmod 0700 "$tmp"
  vm_exec_script "$vm" "$tmp" || rc=$?
  rm -f "$tmp"
  return $rc
}

# Run each selected task's params.sh (if present) and persist the output to
# .state/task-params/<slug>.env.  Called once at session start; not called
# again on reset so the same random values survive through the whole session.
_generate_task_params() {
  mkdir -p "$STATE_DIR/task-params"
  local _param_tasks=()
  mapfile -t _param_tasks < "$STATE_DIR/active-tasks.txt"
  local _pt
  for _pt in "${_param_tasks[@]}"; do
    local params_sh="$_pt/params.sh"
    [[ -f "$params_sh" ]] || continue
    local slug; slug=$(task_slug "$_pt")
    bash "$params_sh" > "$STATE_DIR/task-params/${slug}.env"
  done
}

# Render task.md by substituting {{KEY}} placeholders with values from the
# task's params file.  Falls back to the raw template when no params exist
# (e.g. last-session display or tasks without params.sh).
_render_task_md() {
  local task_dir="$1"
  local slug; slug=$(task_slug "$task_dir")
  local params_file="$STATE_DIR/task-params/${slug}.env"
  local content; content=$(cat "$task_dir/task.md")

  if [[ -f "$params_file" ]]; then
    while IFS='=' read -r key val; do
      [[ -z "$key" || "$key" == \#* ]] && continue
      val="${val%\"}" ; val="${val#\"}"
      val="${val%\'}" ; val="${val#\'}"
      content="${content//\{\{${key}\}\}/${val}}"
    done < "$params_file"
  fi
  printf '%s\n' "$content"
}

# ── internal: load profile/fixed source into shell vars ──────────────────────
_load_selection_source() {
  local profile_name="$1"
  local fixed_name="$2"
  local topic_override="$3"

  TOPICS=()
  FIXED_TASKS=()
  TOPIC_OVERRIDE=""

  if [[ -n "$topic_override" ]]; then
    NAME="Exam: $topic_override"
    DURATION="${DEFAULT_DURATION:-60}"
    PASS_THRESHOLD="${PASS_THRESHOLD:-70}"
    TOPIC_OVERRIDE="$topic_override"

  elif [[ -n "$fixed_name" ]]; then
    local fixed_file="$RHTR_DIR/certs/$CERT/exams/fixed/$fixed_name.conf"
    [[ -f "$fixed_file" ]] || die "Fixed exam not found: $fixed_name"
    source "$fixed_file"
    NAME="${NAME:-$CERT_FULL_NAME — $fixed_name}"
    DURATION="${DURATION:-${DEFAULT_DURATION:-150}}"
    PASS_THRESHOLD="${PASS_THRESHOLD:-70}"

  else
    local profile_file="$RHTR_DIR/certs/$CERT/exams/profiles/$profile_name.conf"
    [[ -f "$profile_file" ]] || die "Profile not found: $profile_name"
    source "$profile_file"
    NAME="${NAME:-$CERT_FULL_NAME — $profile_name}"
    DURATION="${DURATION:-${DEFAULT_DURATION:-150}}"
    PASS_THRESHOLD="${PASS_THRESHOLD:-70}"
  fi
}
