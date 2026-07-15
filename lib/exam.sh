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
# EXIT-trap cleanup for _start_session: if setup was interrupted after the
# topology came up, destroy the VMs before wiping state so nothing is orphaned.
_start_session_cleanup() {
  if [[ "${_SESSION_TOPOLOGY_UP:-0}" == "1" ]]; then
    warn "Session setup interrupted — tearing down VMs..."
    topology_destroy || warn "Topology teardown failed; check 'incus list' for leftover VMs"
  fi
  rm -rf "$STATE_DIR"
  die 'Session setup failed — state cleaned up'
}

_start_session() {
  local mode="$1"; shift
  local selected_tasks=("$@")

  # Verify image exists before doing anything
  vm_require_image "rocky${RHEL_VERSION}"

  # Persist state; trap ensures cleanup if anything below fails. Once
  # topology_create starts, cleanup must also tear down any VMs it created —
  # otherwise an interrupt orphans them while wiping the state that tracks them.
  mkdir -p "$STATE_DIR"
  _SESSION_TOPOLOGY_UP=0
  trap '_start_session_cleanup' EXIT
  echo "$CERT" > "$STATE_DIR/cert"
  printf '%s\n' "${selected_tasks[@]}" > "$STATE_DIR/active-tasks.txt"

  _assign_task_disks
  _assign_task_requirements

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
  _SESSION_TOPOLOGY_UP=1
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
      _run_task_script "${VM_NAMES[0]}" "$setup" "$task_dir" \
        || die "Setup failed for $(task_short_name "$task_dir") — environment not ready for this task"
    fi
    (( i++ ))
  done
  _apply_post_setups "${selected_tasks[@]}"

  trap - EXIT
  _display_tasks "${selected_tasks[@]}"
}

# Run each selected task's postsetup.sh (if present) after every task's own
# setup.sh has finished. Some tasks (e.g. hostname-dns-v1) mutate shared
# system state (/etc/hosts) from their own setup.sh, which can run after an
# earlier task's setup.sh already snapshotted that same file — see git
# history for lib/exam.sh and ch01-tools/man-docs-v1 for the incident this
# fixed. A task that needs a baseline of shared state as the candidate will
# actually first see it belongs in postsetup.sh, not setup.sh.
_apply_post_setups() {
  local selected_tasks=("$@")
  local task_dir postsetup
  for task_dir in "${selected_tasks[@]}"; do
    postsetup="$task_dir/postsetup.sh"
    if [[ -f "$postsetup" ]]; then
      _run_task_script "${VM_NAMES[0]}" "$postsetup" "$task_dir" \
        || die "Post-setup failed for $(task_short_name "$task_dir") — environment not ready for this task"
    fi
  done
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
# Starts any stopped VMs in the current session (e.g. after a host reboot)
# instead of letting callers hit a raw Incus error mid-command.
_ensure_vms_running() {
  local vm stopped=()
  for vm in "${VM_NAMES[@]}"; do
    vm_running "$vm" || stopped+=("$vm")
  done
  [[ ${#stopped[@]} -eq 0 ]] && return 0
  info "Starting stopped VM(s): ${stopped[*]}"
  for vm in "${stopped[@]}"; do
    vm_start "$vm" || die "Failed to start VM '$vm'"
  done
}

cmd_shell() {
  rhtr_require_state
  source "$STATE_DIR/exam.conf"
  source "$RHTR_DIR/certs/$CERT/topology.sh"
  topology_names
  _ensure_vms_running

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
  _ensure_vms_running
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
  _ensure_vms_running

  info "Restoring pre-exam snapshot..."
  for vm in "${VM_NAMES[@]}"; do
    vm_snapshot_restore "$vm"
  done

  info "Re-applying task setups..."
  local _reset_tasks=()
  mapfile -t _reset_tasks < "$STATE_DIR/active-tasks.txt"
  local _rt _reset_failed=()
  for _rt in "${_reset_tasks[@]}"; do
    local setup="$_rt/setup.sh"
    if [[ -f "$setup" ]]; then
      _run_task_script "${VM_NAMES[0]}" "$setup" "$_rt" \
        || _reset_failed+=("$(task_short_name "$_rt")")
    fi
  done
  _apply_post_setups "${_reset_tasks[@]}"

  # Clear previous grades so the candidate starts fresh
  : > "$STATE_DIR/grades.txt"

  if [[ ${#_reset_failed[@]} -gt 0 ]]; then
    warn "Setup re-apply failed for: ${_reset_failed[*]} — these tasks' environments may be broken"
  fi
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

  # Keep task-params around after state cleanup so `rhtr <cert> tasks` can
  # still render {{KEY}} placeholders for the last-session fallback view.
  mkdir -p "$RHTR_DIR/.last-session"
  rm -rf "$RHTR_DIR/.last-session/task-params"
  [[ -d "$STATE_DIR/task-params" ]] \
    && cp -r "$STATE_DIR/task-params" "$RHTR_DIR/.last-session/task-params"

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
  # strip the original shebang only if line 1 actually is one — otherwise a
  # script that opens with a comment or code would silently lose its first line
  local body_from=1
  IFS= read -r _firstline < "$script"
  [[ "$_firstline" == '#!'* ]] && body_from=2
  {
    printf '#!/usr/bin/env bash\n'
    cat "$params_file"
    printf '\n'
    tail -n +$body_from "$script"
  } > "$tmp"
  chmod 0700 "$tmp"
  vm_exec_script "$vm" "$tmp" || rc=$?
  rm -f "$tmp"
  return $rc
}

# Assign each NEEDS_DISK=1 task in the session its own dedicated extra disk.
# Multiple ch09-storage/ch10-lvm tasks used to all fight over the single
# "second disk" topology_create attached, silently clobbering each other's
# setup — see git history for lib/exam.sh and certs/rhcsa/topology.sh.
# Sizes are distinct GiB values (skipping 10, the root disk's size) so a
# candidate can always tell disks for different tasks apart via `lsblk`, and
# so setup/grade scripts can find "their" disk by size instead of by
# position. Called once at session start, before topology_create — the
# ordered EXTRA_DISK_SIZES_GIB global tells topology how many disks to
# attach and how big each one should be.
_assign_task_disks() {
  EXTRA_DISK_SIZES_GIB=()
  : > "$STATE_DIR/task-disks.txt"

  local _dt size=2
  while IFS= read -r _dt; do
    [[ -z "$_dt" ]] && continue
    local NEEDS_DISK=""
    # shellcheck source=/dev/null
    source "$_dt/meta.sh"
    [[ "$NEEDS_DISK" == "1" ]] || continue

    size=$(( size + 1 ))
    [[ $size -eq 10 ]] && size=$(( size + 1 ))   # never collide with the 10 GiB root disk

    EXTRA_DISK_SIZES_GIB+=("$size")
    printf '%s|%s\n' "$(task_slug "$_dt")" "$size" >> "$STATE_DIR/task-disks.txt"
  done < "$STATE_DIR/active-tasks.txt"
}

# Scan the selected tasks for NEEDS_CONTAINERS=1 (set by ch16-containers'
# meta.sh files). topology_create reads the resulting SESSION_NEEDS_CONTAINERS
# global to decide whether to install podman and stand up the offline
# registry mirror — most profiles (networking, storage, lvm, ...) never touch
# containers and shouldn't pay for that setup. Called once at session start,
# before topology_create, same as _assign_task_disks.
#
# Named distinctly from the per-task NEEDS_CONTAINERS field itself (rather
# than reusing that name for the aggregate) so sourcing each task's meta.sh
# can't clobber the running result — same reason _assign_task_disks keeps
# EXTRA_DISK_SIZES_GIB separate from the per-task NEEDS_DISK it reads.
_assign_task_requirements() {
  SESSION_NEEDS_CONTAINERS=0

  local _rt
  while IFS= read -r _rt; do
    [[ -z "$_rt" ]] && continue
    local NEEDS_CONTAINERS=""
    # shellcheck source=/dev/null
    source "$_rt/meta.sh"
    [[ "$NEEDS_CONTAINERS" == "1" ]] && SESSION_NEEDS_CONTAINERS=1
  done < "$STATE_DIR/active-tasks.txt"
  return 0
}

# Look up the disk size (GiB) _assign_task_disks gave a task, if any.
_task_disk_size_gib() {
  local task_dir="$1"
  [[ -f "$STATE_DIR/task-disks.txt" ]] || return 0
  awk -F'|' -v s="$(task_slug "$task_dir")" '$1==s{print $2}' "$STATE_DIR/task-disks.txt"
}

# Run each selected task's params.sh (if present) and persist the output to
# .state/task-params/<slug>.env, plus TASK_DISK_SIZE_GB/DISK_SIZE for tasks
# _assign_task_disks gave a disk to.  Called once at session start; not
# called again on reset so the same values survive through the whole session.
_generate_task_params() {
  mkdir -p "$STATE_DIR/task-params"
  local _param_tasks=()
  mapfile -t _param_tasks < "$STATE_DIR/active-tasks.txt"
  local _pt
  for _pt in "${_param_tasks[@]}"; do
    local params_sh="$_pt/params.sh"
    local slug; slug=$(task_slug "$_pt")
    local disk_size; disk_size=$(_task_disk_size_gib "$_pt")

    [[ -f "$params_sh" || -n "$disk_size" ]] || continue

    : > "$STATE_DIR/task-params/${slug}.env"

    if [[ -f "$params_sh" ]]; then
      # params.sh echoes raw KEY=VALUE pairs, unquoted. Values with spaces
      # (e.g. "Running OK") would otherwise break when this file is spliced
      # into a setup/grade script as literal shell assignments — quote each
      # value here so it round-trips safely either way.
      local key val
      while IFS='=' read -r key val; do
        [[ -z "$key" ]] && continue
        printf '%s="%s"\n' "$key" "${val//\"/\\\"}" >> "$STATE_DIR/task-params/${slug}.env"
      done < <(bash "$params_sh")
    fi

    if [[ -n "$disk_size" ]]; then
      printf 'TASK_DISK_SIZE_GB="%s"\n' "$disk_size" >> "$STATE_DIR/task-params/${slug}.env"
      printf 'DISK_SIZE="%sGiB"\n' "$disk_size" >> "$STATE_DIR/task-params/${slug}.env"
    fi
  done
}

# Render task.md by substituting {{KEY}} placeholders with values from the
# task's params file.  Falls back to the last-session copy (see cmd_destroy)
# when there's no active session, and to the raw template when neither
# exists (e.g. tasks without params.sh).
_render_task_md() {
  local task_dir="$1"
  local slug; slug=$(task_slug "$task_dir")
  local params_file="$STATE_DIR/task-params/${slug}.env"
  [[ -f "$params_file" ]] || params_file="$RHTR_DIR/.last-session/task-params/${slug}.env"
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
