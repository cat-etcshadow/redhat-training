#!/usr/bin/env bash
# exam.sh — session orchestration: new, train, shell, grade, reset, destroy, status, hint

# ── new (exam mode) ───────────────────────────────────────────────────────────
cmd_new() {
  rhtr_require_no_state

  local profile_name="full"
  local fixed_name=""
  local topic_override=""
  RHEL_VERSION="${DEFAULT_RHEL_VERSION:-9}"
  FORMAT="training"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --profile) profile_name="$2"; shift 2 ;;
      --fixed)   fixed_name="$2";   shift 2 ;;
      --topic)   topic_override="$2"; shift 2 ;;
      --rhel)    RHEL_VERSION="$2";  shift 2 ;;
      --format)  FORMAT="$2";       shift 2 ;;
      *) die "Unknown flag: $1" ;;
    esac
  done

  [[ "$FORMAT" == "training" || "$FORMAT" == "exam" ]] \
    || die "Unknown --format '$FORMAT' (must be training or exam)"
  pool_dir_exists "$CERT" "$FORMAT" \
    || die "Cert '$CERT' has no '$FORMAT' pool ($(pool_dir "$CERT" "$FORMAT") not found) — --format $FORMAT isn't available for $CERT yet."

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
  FORMAT="training"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --topic)      topic_override="$2"; shift 2 ;;
      --difficulty) filter_diff="$2";    shift 2 ;;
      --rhel)       RHEL_VERSION="$2";   shift 2 ;;
      --format)     FORMAT="$2";        shift 2 ;;
      *) die "Unknown flag: $1" ;;
    esac
  done

  [[ "$FORMAT" == "training" || "$FORMAT" == "exam" ]] \
    || die "Unknown --format '$FORMAT' (must be training or exam)"
  pool_dir_exists "$CERT" "$FORMAT" \
    || die "Cert '$CERT' has no '$FORMAT' pool ($(pool_dir "$CERT" "$FORMAT") not found) — --format $FORMAT isn't available for $CERT yet."
  [[ "$FORMAT" == "exam" && -n "$topic_override" ]] \
    && die "--topic isn't supported with --format exam (the exam-format pool is flat, not chapter-nested)"

  # Train mode: always uses topic-all or full catalog; no profiles/fixed
  TOPIC_OVERRIDE="${topic_override:-}"
  TOPICS=()  # not used in train
  FIXED_TASKS=()

  if [[ -n "$topic_override" ]]; then
    NAME="Train: $topic_override"
  else
    NAME="Train: $CERT (all topics)${FORMAT:+ [$FORMAT]}"
  fi
  DURATION=0   # no timer in train mode
  PASS_THRESHOLD="${PASS_THRESHOLD:-70}"

  local selected_tasks=()
  mapfile -t selected_tasks < <(
    if [[ -n "$topic_override" ]]; then
      _select_topic_all "$topic_override"
    else
      # All tasks across the pool, filtered by RHEL version. Training pools
      # are chapter-nested (depth 2); the flat exam-format pool is depth 1.
      local pool; pool=$(pool_dir "$CERT" "$FORMAT")
      local depth=2
      [[ "$FORMAT" == "exam" ]] && depth=1
      while IFS= read -r d; do
        _task_compatible "$d" && echo "$d"
      done < <(find "$pool" -mindepth "$depth" -maxdepth "$depth" -type d | sort)
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
  _assign_task_nodes

  DEADLINE_EPOCH=0
  if [[ $DURATION -gt 0 ]]; then
    DEADLINE_EPOCH=$(( $(date +%s) + DURATION * 60 ))
  fi

  cat > "$STATE_DIR/exam.conf" <<EOF
CERT="$CERT"
NAME="$NAME"
MODE="$mode"
FORMAT="${FORMAT:-training}"
RHEL_VERSION="$RHEL_VERSION"
SESSION_NODES="$SESSION_NODES"
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
  _apply_node_setups "${selected_tasks[@]}"

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

# Run each selected task's nodesetup.sh (if present) once per managed node it
# targets — unlike setup.sh/postsetup.sh, which only ever run on VM_NAMES[0]
# (the RHCE control node), some tasks need to prepare state (e.g. a pre-sized
# LVM volume group, a raw disk) ON a specific managed node itself. Target
# nodes come from the task's own NEEDS_NODES (same field _assign_task_nodes
# reads); a task with no NEEDS_NODES has no per-node disk and is skipped.
# Short node names (node1..node5) are mapped to actual VM names positionally
# via $SESSION_NODES/$NODE_NAMES, which topology_names() populates from the
# same space-split list in the same order.
_apply_node_setups() {
  local selected_tasks=("$@")
  local -a session_node_list=($SESSION_NODES)
  local task_dir nodesetup
  for task_dir in "${selected_tasks[@]}"; do
    nodesetup="$task_dir/nodesetup.sh"
    [[ -f "$nodesetup" ]] || continue

    local NEEDS_NODES=()
    # shellcheck source=/dev/null
    source "$task_dir/meta.sh"
    [[ ${#NEEDS_NODES[@]} -gt 0 ]] || continue

    local n idx vm
    for n in "${NEEDS_NODES[@]}"; do
      vm=""
      for idx in "${!session_node_list[@]}"; do
        [[ "${session_node_list[$idx]}" == "$n" ]] || continue
        vm="${NODE_NAMES[$idx]}"
        break
      done
      [[ -n "$vm" ]] || die "Node setup for $(task_short_name "$task_dir") wants '$n', which is not in this session's node set ($SESSION_NODES)"
      _run_task_script "$vm" "$nodesetup" "$task_dir" \
        || die "Node setup failed for $(task_short_name "$task_dir") on $vm — environment not ready for this task"
    done
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

cmd_console() {
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
        vm_console "$vm"; found=1; break
      fi
    done
    if [[ $found -eq 0 ]]; then
      die "Node '$node' not found. Available: ${VM_NAMES[*]}"
    fi
  else
    vm_console "${VM_NAMES[0]}"
  fi
}

cmd_grade() {
  rhtr_require_state
  source "$STATE_DIR/exam.conf"
  source "$RHTR_DIR/certs/$CERT/topology.sh"
  topology_names
  _ensure_vms_running

  local task_num=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --task) task_num="$2"; shift 2 ;;
      *) die "Unknown flag: $1" ;;
    esac
  done

  local mode; mode=$(grep '^MODE=' "$STATE_DIR/exam.conf" | cut -d'"' -f2)

  if [[ -n "$task_num" ]]; then
    grade_one_task "$task_num"
    [[ "$mode" == "train" ]] && progress_record "$CERT" "$GRADE_ONE_TASK_DIR" "$GRADE_ONE_TASK_RESULT"
    return
  fi

  grade_all_tasks

  # Record results in progress (train mode only, or always — your call)
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
  _apply_node_setups "${_reset_tasks[@]}"

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
    # collections a task's playbook needs (community.general, ansible.posix, …)
    # must resolve regardless of what any OTHER task's ansible.cfg sets for
    # collections_paths — that setting fully replaces ansible's default search
    # list, so a student completing the ansible.cfg task would otherwise hide
    # system collections from every later task's --syntax-check.
    printf 'export ANSIBLE_COLLECTIONS_PATH=/usr/share/ansible/collections\n'
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
#
# RHCE extension: unlike RHCSA's single VM, a disk-needing RHCE task must say
# WHICH managed node(s) get the disk — read the same NEEDS_NODES field
# _assign_task_nodes reads. Unlike _assign_task_nodes (which defaults an
# unset NEEDS_NODES to all 5 for topology *sizing*), this deliberately does
# NOT default: an unset NEEDS_NODES here means "no per-node disk targeting",
# leaving the nodes column empty and this task on the plain
# EXTRA_DISK_SIZES_GIB/RHCSA-style path. Defaulting here would wrongly turn
# every existing RHCSA NEEDS_DISK=1 task into a "per-node" one the moment its
# meta.sh is sourced (RHCSA never sets NEEDS_NODES), so any RHCE task
# spanning all 5 nodes must spell out
# NEEDS_NODES=(node1 node2 node3 node4 node5) explicitly.
# Recorded as a 3rd column in task-disks.txt; empty for RHCSA tasks (which
# never set NEEDS_NODES), so certs/rhcsa/topology.sh's existing
# EXTRA_DISK_SIZES_GIB-only path is completely unaffected.
#
# A task can also set NEEDS_DISK_SIZE_MIB to opt out of the shared whole-GiB
# counter and get an exact small MiB-sized disk instead (e.g. a raw
# partitioning task that needs the disk itself to be tightly sized rather
# than relying on a filler LV to eat up unwanted free space). Recorded as a
# 4th column; when set, this task does NOT consume a slot in the shared GiB
# counter sequence.
_assign_task_disks() {
  EXTRA_DISK_SIZES_GIB=()
  : > "$STATE_DIR/task-disks.txt"

  local _dt size=2
  while IFS= read -r _dt; do
    [[ -z "$_dt" ]] && continue
    local NEEDS_DISK="" NEEDS_NODES=() NEEDS_DISK_SIZE_MIB=""
    # shellcheck source=/dev/null
    source "$_dt/meta.sh"
    [[ "$NEEDS_DISK" == "1" ]] || continue

    local nodes=""
    if [[ ${#NEEDS_NODES[@]} -gt 0 ]]; then
      nodes="${NEEDS_NODES[*]}"
    fi

    local this_size=""
    if [[ -n "$NEEDS_DISK_SIZE_MIB" ]]; then
      # MiB-override tasks don't touch the shared GiB counter at all.
      printf '%s|%s|%s|%s\n' "$(task_slug "$_dt")" "" "$nodes" "$NEEDS_DISK_SIZE_MIB" \
        >> "$STATE_DIR/task-disks.txt"
      continue
    fi

    size=$(( size + 1 ))
    [[ $size -eq 10 ]] && size=$(( size + 1 ))   # never collide with the 10 GiB root disk

    EXTRA_DISK_SIZES_GIB+=("$size")
    printf '%s|%s|%s|%s\n' "$(task_slug "$_dt")" "$size" "$nodes" "" >> "$STATE_DIR/task-disks.txt"
  done < "$STATE_DIR/active-tasks.txt"
}

# Scan the selected tasks for a declared NEEDS_NODES=(node3 node4) — mirrors
# _assign_task_disks exactly, but for RHCE's managed-node topology instead of
# RHCSA's extra disks. A task that doesn't declare NEEDS_NODES gets the full
# 5-node set (safe default, same soft-default convention as NEEDS_DISK/
# NEEDS_CONTAINERS being unset = off) so existing tasks that assume all 5
# nodes exist keep working unchanged. The unioned result is persisted into
# exam.conf as SESSION_NODES so certs/rhce/topology.sh's topology_names() can
# read it back on every later command (shell/grade/reset/destroy), not just
# at session start — see topology_names() for why that matters.
_assign_task_nodes() {
  local -A _node_set=()
  local _nt
  while IFS= read -r _nt; do
    [[ -z "$_nt" ]] && continue
    local NEEDS_NODES=()
    # shellcheck source=/dev/null
    source "$_nt/meta.sh"
    if [[ ${#NEEDS_NODES[@]} -eq 0 ]]; then
      NEEDS_NODES=(node1 node2 node3 node4 node5)
    fi
    local n
    for n in "${NEEDS_NODES[@]}"; do _node_set["$n"]=1; done
  done < "$STATE_DIR/active-tasks.txt"

  SESSION_NODES=""
  local i
  for (( i=1; i<=5; i++ )); do
    [[ -n "${_node_set[node$i]:-}" ]] && SESSION_NODES+="node$i "
  done
  SESSION_NODES="${SESSION_NODES% }"
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

# Look up the space-separated target node list (e.g. "node3 node4")
# _assign_task_disks recorded for a task, if any — empty for RHCSA-style
# single-VM certs and for RHCE tasks with no NEEDS_DISK.
_task_disk_nodes() {
  local task_dir="$1"
  [[ -f "$STATE_DIR/task-disks.txt" ]] || return 0
  awk -F'|' -v s="$(task_slug "$task_dir")" '$1==s{print $3}' "$STATE_DIR/task-disks.txt"
}

# Look up the MiB-override size _assign_task_disks gave a task via
# NEEDS_DISK_SIZE_MIB, if any — empty for tasks using the shared GiB counter.
_task_disk_size_mib() {
  local task_dir="$1"
  [[ -f "$STATE_DIR/task-disks.txt" ]] || return 0
  awk -F'|' -v s="$(task_slug "$task_dir")" '$1==s{print $4}' "$STATE_DIR/task-disks.txt"
}

# Given a task's target node list (short names, e.g. "node3 node4"), return
# the actual VM name of the first one — used to discover a per-node disk's
# real device name. Maps short names to VM names positionally via
# $SESSION_NODES / $NODE_NAMES, which topology_names() (certs/rhce/topology.sh)
# builds from the same space-split list in the same order.
_first_target_vm() {
  local nodes="$1"
  local first_node="${nodes%% *}"
  [[ -n "$first_node" ]] || return 1
  local -a session_node_list=($SESSION_NODES)
  local i
  for i in "${!session_node_list[@]}"; do
    if [[ "${session_node_list[$i]}" == "$first_node" ]]; then
      echo "${NODE_NAMES[$i]}"
      return 0
    fi
  done
  return 1
}

# Discover the real kernel device name (e.g. "vdb", no /dev/ prefix) of a
# per-node task disk already attached by topology_create, by matching size
# via lsblk on the VM — same size-match technique RHCSA's setup.sh scripts
# already use to find "their" disk, just run remotely against the target
# node instead of locally inside a setup.sh. want_gib/want_mib: pass whichever
# one is non-empty for this task; the other should be "".
_discover_task_disk_name() {
  local vm="$1" want_gib="$2" want_mib="$3"
  local lsblk_out; lsblk_out=$(vm_exec "$vm" lsblk -dpbno NAME,TYPE,SIZE 2>/dev/null) || return 1
  if [[ -n "$want_mib" ]]; then
    awk -v want="$want_mib" '$2=="disk"{mib=int(($3+524288)/1048576); if (mib==want) {print $1; exit}}' <<<"$lsblk_out"
  else
    awk -v want="$want_gib" '$2=="disk"{gib=int(($3+536870912)/1073741824); if (gib==want) {print $1; exit}}' <<<"$lsblk_out"
  fi
}

# Run each selected task's params.sh (if present) and persist the output to
# .state/task-params/<slug>.env, plus TASK_DISK_SIZE_GB/DISK_SIZE (or the MiB
# equivalent) for tasks _assign_task_disks gave a disk to, plus a discovered
# real DISK device name for tasks with a per-node target list. Called once
# at session start; not called again on reset so the same values survive
# through the whole session.
_generate_task_params() {
  mkdir -p "$STATE_DIR/task-params"
  local _param_tasks=()
  mapfile -t _param_tasks < "$STATE_DIR/active-tasks.txt"
  local _pt
  for _pt in "${_param_tasks[@]}"; do
    local params_sh="$_pt/params.sh"
    local slug; slug=$(task_slug "$_pt")
    local disk_size; disk_size=$(_task_disk_size_gib "$_pt")
    local disk_size_mib; disk_size_mib=$(_task_disk_size_mib "$_pt")
    local disk_nodes; disk_nodes=$(_task_disk_nodes "$_pt")

    [[ -f "$params_sh" || -n "$disk_size" || -n "$disk_size_mib" ]] || continue

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
    elif [[ -n "$disk_size_mib" ]]; then
      printf 'TASK_DISK_SIZE_MIB="%s"\n' "$disk_size_mib" >> "$STATE_DIR/task-params/${slug}.env"
      printf 'DISK_SIZE="%sMiB"\n' "$disk_size_mib" >> "$STATE_DIR/task-params/${slug}.env"
    fi

    if [[ -n "$disk_nodes" ]]; then
      local target_vm; target_vm=$(_first_target_vm "$disk_nodes")
      if [[ -n "$target_vm" ]]; then
        local disk_name
        disk_name=$(_discover_task_disk_name "$target_vm" "$disk_size" "$disk_size_mib")
        if [[ -n "$disk_name" ]]; then
          printf 'DISK="%s"\n' "${disk_name#/dev/}" >> "$STATE_DIR/task-params/${slug}.env"
        else
          warn "Could not discover task disk device name for $(task_short_name "$_pt") on $target_vm"
        fi
      else
        warn "Could not resolve a target VM for $(task_short_name "$_pt")'s node list ($disk_nodes)"
      fi
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
    local fixed_subdir="fixed"; [[ "${FORMAT:-training}" == "exam" ]] && fixed_subdir="fixed-exam"
    local fixed_file="$RHTR_DIR/certs/$CERT/exams/$fixed_subdir/$fixed_name.conf"
    [[ -f "$fixed_file" ]] || die "Fixed exam not found: $fixed_name (looked in exams/$fixed_subdir/)"
    source "$fixed_file"
    NAME="${NAME:-$CERT_FULL_NAME — $fixed_name}"
    DURATION="${DURATION:-${DEFAULT_DURATION:-150}}"
    PASS_THRESHOLD="${PASS_THRESHOLD:-70}"

  else
    local profiles_subdir="profiles"; [[ "${FORMAT:-training}" == "exam" ]] && profiles_subdir="profiles-exam"
    local profile_file="$RHTR_DIR/certs/$CERT/exams/$profiles_subdir/$profile_name.conf"
    [[ -f "$profile_file" ]] || die "Profile not found: $profile_name (looked in exams/$profiles_subdir/)"
    source "$profile_file"
    NAME="${NAME:-$CERT_FULL_NAME — $profile_name}"
    DURATION="${DURATION:-${DEFAULT_DURATION:-150}}"
    PASS_THRESHOLD="${PASS_THRESHOLD:-70}"
  fi
}
