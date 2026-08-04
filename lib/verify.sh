#!/usr/bin/env bash
# verify.sh — grader-contract harness
#
# Proves, on real VMs, that every task's setup/grade/solution chain holds:
#
#   C1  grade after setup.sh    must FAIL   (a grader that passes here is vacuous)
#   C2  grade after solution.sh must PASS   (grader or solution is broken)
#   C3  grade again, unchanged  must PASS   (grader must be idempotent)
#   C4  re-run setup.sh, grade  must FAIL   (setup must be re-runnable for `reset`)
#
# Tasks are swept in batches that mirror a real exam, so cross-task interference
# shows up too; anything that violates the contract is then re-run alone to tell
# "this grader is broken" apart from "a neighbour's setup broke it".

VERIFY_ROOT=""
VERIFY_TSV=""
VERIFY_SUFFIX=""

# ── result recording ──────────────────────────────────────────────────────────

# tsv columns: task  c1  c2  c3  c4  tier  seconds  note
_verify_record() {
  local task="$1" c1="$2" c2="$3" c3="$4" c4="$5" tier="$6" secs="$7" note="$8"
  # incus draws transfer progress with bare \r; left in, it splits this row in
  # any reader that treats \r as a line break (python's universal newlines does)
  note="${note//$'\t'/ }"; note="${note//$'\n'/ ; }"; note="${note//$'\r'/ }"
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$task" "$c1" "$c2" "$c3" "$c4" "$tier" "$secs" "${note:0:400}" >> "$VERIFY_TSV"
}

# a task is clean only when every check that ran met its expectation
_verify_task_ok() {
  local c1="$1" c2="$2" c3="$3" c4="$4"
  [[ "$c1" == "ok" && "$c2" == "ok" && "$c3" == "ok" ]] || return 1
  [[ "$c4" == "ok" || "$c4" == "skip" ]] || return 1
  return 0
}

_verify_already_done() {
  [[ -f "$VERIFY_TSV" ]] || return 1
  cut -f1 "$VERIFY_TSV" | grep -qxF "$1"
}

# ── batch composition ─────────────────────────────────────────────────────────

# Greedily fill batches of at most $2 tasks, never putting two conflicting tasks
# together — the same CONFLICTS rule a real session obeys, so a batch is always
# a session that could legitimately have been drawn.
_verify_make_batches() {
  local -n _all="$1"
  local size="$2"
  local -a remaining=("${_all[@]}")

  while [[ ${#remaining[@]} -gt 0 ]]; do
    local -a batch=() leftover=()
    local t
    for t in "${remaining[@]}"; do
      if [[ ${#batch[@]} -lt $size ]] && ! _task_conflicts_with_selected "$t" batch; then
        batch+=("$t")
      else
        leftover+=("$t")
      fi
    done
    # a task that conflicts with everything already placed would loop forever
    [[ ${#batch[@]} -eq 0 ]] && { batch=("${remaining[0]}"); leftover=("${remaining[@]:1}"); }
    printf '%s\n' "${batch[*]}"
    remaining=("${leftover[@]}")
  done
}

# ── one batch ─────────────────────────────────────────────────────────────────

_verify_needs_disk() {
  local t
  for t in "$@"; do
    local NEEDS_DISK=""
    # shellcheck source=/dev/null
    source "$t/meta.sh"
    [[ "$NEEDS_DISK" == "1" ]] && return 0
  done
  return 1
}

# Stand up the batch's environment using the real session helpers, so verify
# exercises the same code path a candidate hits. Unlike _start_session this
# records a setup failure instead of dying — one broken task must not abort a
# whole sweep.
_verify_setup_batch() {
  local -n _tasks="$1"

  mkdir -p "$STATE_DIR"
  echo "$CERT" > "$STATE_DIR/cert"
  printf '%s\n' "${_tasks[@]}" > "$STATE_DIR/active-tasks.txt"

  _assign_task_disks
  _assign_task_requirements
  _assign_task_nodes

  cat > "$STATE_DIR/exam.conf" <<EOF
CERT="$CERT"
NAME="verify"
MODE="exam"
FORMAT="${FORMAT:-training}"
RHEL_VERSION="$RHEL_VERSION"
SESSION_NODES="$SESSION_NODES"
DURATION=0
PASS_THRESHOLD=70
DEADLINE_EPOCH=0
EOF

  topology_create
  local vm
  for vm in "${VM_NAMES[@]}"; do vm_snapshot_create "$vm"; done
  _generate_task_params
}

# Run every task's setup.sh, then the post/node setup passes a session does.
# Returns the names of tasks whose setup failed, one per line, on fd 3.
_verify_run_setups() {
  local -n _stasks="$1"
  local t rc
  for t in "${_stasks[@]}"; do
    [[ -f "$t/setup.sh" ]] || continue
    rc=0
    _run_task_script "${VM_NAMES[0]}" "$t/setup.sh" "$t" &>/dev/null || rc=$?
    [[ $rc -ne 0 ]] && echo "$(task_short_name "$t")" >&3
  done
  ( _apply_post_setups "${_stasks[@]}" ) &>/dev/null || echo "__postsetup__" >&3
  ( _apply_node_setups "${_stasks[@]}" ) &>/dev/null || echo "__nodesetup__" >&3
  return 0
}

# exit 0 = grader passed
_verify_grade() {
  local task="$1"
  _run_task_script "${VM_NAMES[0]}" "$task/grade.sh" "$task" &>/dev/null
}

# Writes the grader's (de-noised) output to $VERIFY_GRADE_OUT and returns the
# grader's own exit status. Piping straight to grep here would replace that
# status with grep's and silently turn every FAIL into a pass.
VERIFY_GRADE_OUT=""
_verify_grade_out() {
  local task="$1" rc=0 raw
  raw=$(mktemp)
  _run_task_script "${VM_NAMES[0]}" "$task/grade.sh" "$task" &>"$raw" || rc=$?
  # progress lines are \r-separated, so break on \r before filtering them out
  VERIFY_GRADE_OUT=$(tr '\r' '\n' < "$raw" \
    | grep -vE '^(Pushing|Retrieving) |^warn:  (SFTP|Setup script)|^ *$' || true)
  rm -f "$raw"
  return $rc
}

# Sweep one batch through the full contract. tier is "batch" or "isolated".
_verify_batch() {
  local tier="$1"; shift
  local -a tasks=("$@")
  local start_all; start_all=$(date +%s)

  info "Batch (${#tasks[@]} task(s), tier=$tier): $(for t in "${tasks[@]}"; do task_short_name "$t"; done | tr '\n' ' ')"

  local -a failed_setup=()
  _verify_setup_batch tasks
  mapfile -t failed_setup < <(_verify_run_setups tasks 3>&1 1>/dev/null)

  local -A C1=() C2=() C3=() C4=() NOTE=()
  local t name rc

  # C1 — nothing solved yet, every grader must say FAIL
  for t in "${tasks[@]}"; do
    name=$(task_short_name "$t")
    if [[ " ${failed_setup[*]} " == *" $name "* ]]; then
      C1["$name"]="setup-failed"; NOTE["$name"]="setup.sh returned non-zero"
      continue
    fi
    if _verify_grade "$t"; then
      C1["$name"]="VACUOUS"
      NOTE["$name"]="grader passed before any work was done; "
    else
      C1["$name"]="ok"
    fi
  done

  # C2/C3 — solve, then the grader must pass, twice
  for t in "${tasks[@]}"; do
    name=$(task_short_name "$t")
    [[ "${C1[$name]}" == "setup-failed" ]] && { C2["$name"]="skip"; C3["$name"]="skip"; continue; }

    if [[ ! -f "$t/solution.sh" ]]; then
      C2["$name"]="no-solution"; C3["$name"]="skip"; continue
    fi

    rc=0
    _run_task_script "${VM_NAMES[0]}" "$t/solution.sh" "$t" &>/dev/null || rc=$?
    [[ $rc -ne 0 ]] && NOTE["$name"]="${NOTE[$name]:-}solution.sh rc=$rc; "

    if _verify_grade_out "$t"; then C2["$name"]="ok"; else C2["$name"]="FAIL"; fi
    if [[ "${C2[$name]}" == "FAIL" ]]; then
      NOTE["$name"]="${NOTE[$name]:-}${VERIFY_GRADE_OUT}"
    fi

    if [[ "${C2[$name]}" == "ok" ]]; then
      _verify_grade "$t" && C3["$name"]="ok" || {
        C3["$name"]="NOT-IDEMPOTENT"
        NOTE["$name"]="${NOTE[$name]:-}second grade run failed after a passing one"
      }
    else
      C3["$name"]="skip"
    fi
  done

  # C4 — re-running setup must put the task back into its unsolved state
  local -a resetup_failed=()
  mapfile -t resetup_failed < <(_verify_run_setups tasks 3>&1 1>/dev/null)
  for t in "${tasks[@]}"; do
    name=$(task_short_name "$t")
    if [[ "${C1[$name]}" == "setup-failed" || "${C2[$name]}" == "no-solution" ]]; then
      C4["$name"]="skip"
    elif [[ " ${resetup_failed[*]} " == *" $name "* ]]; then
      C4["$name"]="SETUP-NOT-RERUNNABLE"
      NOTE["$name"]="${NOTE[$name]:-}setup.sh failed on second run; "
    elif _verify_grade "$t"; then
      C4["$name"]="STALE-STATE"
      NOTE["$name"]="${NOTE[$name]:-}grader still passes after setup.sh re-ran — reset would leave the task solved; "
    else
      C4["$name"]="ok"
    fi
  done

  local now; now=$(date +%s)
  for t in "${tasks[@]}"; do
    name=$(task_short_name "$t")
    _verify_record "$name" "${C1[$name]}" "${C2[$name]}" "${C3[$name]}" "${C4[$name]}" \
      "$tier" "$(( now - start_all ))" "${NOTE[$name]:-}"
    if _verify_task_ok "${C1[$name]}" "${C2[$name]}" "${C3[$name]}" "${C4[$name]}"; then
      echo -e "  ${C_GREEN}ok${C_RESET}    $name"
    else
      echo -e "  ${C_RED}BAD${C_RESET}   $name  C1=${C1[$name]} C2=${C2[$name]} C3=${C3[$name]} C4=${C4[$name]}"
      # plain `[[ ]] && arr+=()` would return 1 on the isolated tier and, under
      # set -e, abort the whole sweep after the first re-run
      if [[ "$tier" == "batch" ]]; then VERIFY_RETRY+=("$t"); fi
    fi
  done
  return 0
}

# ── teardown between batches ──────────────────────────────────────────────────
#
# Snapshot restore reverts the root disk but NOT attached block volumes, and
# _assign_task_disks sizes those per session — so a batch holding a NEEDS_DISK
# task has to go all the way down and back up.
_verify_teardown() {
  local -a tasks=("$@")
  if _verify_needs_disk "${tasks[@]}"; then
    topology_destroy &>/dev/null || true
  else
    local vm
    for vm in "${VM_NAMES[@]}"; do vm_snapshot_restore "$vm" &>/dev/null || true; done
  fi
  rm -rf "$STATE_DIR"
}

# ── static gameability ranking ────────────────────────────────────────────────
#
# Scores each grade.sh by how much of its verdict rests on artefacts the
# candidate fully controls. A grader that only greps a file the candidate wrote
# can be satisfied without doing the task — the rigor check TODO 13c says lint
# is missing.
_verify_rank() {
  local -a tasks=("$@")
  local t g score live exec_art text syntax_only name

  printf '%s\t%s\t%s\n' "score" "task" "signals"
  for t in "${tasks[@]}"; do
    g="$t/grade.sh"
    [[ -f "$g" ]] || continue
    name=$(task_short_name "$t")

    # commands that read real system state rather than a file the candidate
    # wrote — deliberately broad, one genuine probe clears a grader
    live=$(grep -cE '\b(systemctl|findmnt|mountpoint|mount|umount|lsblk|blkid|swapon|df|du|getfacl|getenforce|sestatus|semanage|getsebool|restorecon|matchpathcon|firewall-cmd|nft|iptables|getent|passwd -S|chage|lsattr|lvs|vgs|pvs|lvdisplay|vgdisplay|pvdisplay|podman|curl|wget|nmcli|hostnamectl|timedatectl|chronyc|journalctl|grubby|rpm|crontab|atq|pgrep|pidof|sysctl|tuned-adm|showmount|exportfs|runuser|stat|ausearch|loginctl|udevadm|systemd-analyze)\b|ls -[a-zA-Z]*Z|\bip (a|r|-)|\bss -|\bid \b|\bsu -|\bps ' "$g" || true)

    # running the candidate's own artefact (a script, a playbook) is a
    # behavioural check, not a text check — ch02-scripting grades this way
    exec_art=$(grep -cE '"\$(SCRIPT_PATH|SCRIPT|PLAYBOOK)"|\bbash "\$|ansible-navigator run|ansible(-playbook)? .*-m ' "$g" || true)

    # --syntax-check parses YAML on the control node and never touches a
    # managed node, so on its own it proves nothing about live state
    syntax_only=0
    if grep -q 'syntax-check' "$g" \
       && ! grep -qE 'ansible-navigator run|ansible(-playbook)? [^-].*-m |\bssh \b' "$g"; then
      syntax_only=1
    fi

    text=$(grep -cE '\bgrep\b|\btest -f\b|\[\[ -f|\[ -f ' "$g" || true)

    score=0
    [[ $live -eq 0 && $exec_art -eq 0 ]] && score=$(( score + 3 ))
    [[ $text -gt 0 && $live -eq 0 && $exec_art -eq 0 ]] && score=$(( score + 2 ))
    [[ $syntax_only -eq 1 ]] && score=$(( score + 3 ))
    [[ $live -eq 1 && $exec_art -eq 0 ]] && score=$(( score + 1 ))
    printf '%s\t%s\tlive=%s exec=%s text=%s syntax_only=%s\n' \
      "$score" "$name" "$live" "$exec_art" "$text" "$syntax_only"
  done | sort -rn
}

# ── entry point ───────────────────────────────────────────────────────────────

cmd_verify() {
  local topic="" single="" fixed="" batch_size=12 isolate=0 resume=0 rank=0 shard=""
  FORMAT="training"
  RHEL_VERSION="${DEFAULT_RHEL_VERSION:-9}"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --topic)      topic="$2"; shift 2 ;;
      --task)       single="$2"; shift 2 ;;
      --fixed)      fixed="$2"; shift 2 ;;
      --format)     FORMAT="$2"; shift 2 ;;
      --rhel)       RHEL_VERSION="$2"; shift 2 ;;
      --batch)      batch_size="$2"; shift 2 ;;
      --shard)      shard="$2"; shift 2 ;;
      --isolate)    isolate=1; shift ;;
      --resume)     resume=1; shift ;;
      --rank)       rank=1; shift ;;
      *) die "verify: unknown option '$1'" ;;
    esac
  done

  local pool; pool=$(pool_dir "$CERT" "$FORMAT")
  [[ -d "$pool" ]] || die "No '$FORMAT' task pool for $CERT"

  # resolve the task set
  local -a tasks=()
  if [[ -n "$single" ]]; then
    tasks=("$pool/$single")
    [[ -d "${tasks[0]}" ]] || die "No such task: $single"
  elif [[ -n "$fixed" ]]; then
    local subdir="fixed"; [[ "$FORMAT" == "exam" ]] && subdir="fixed-exam"
    local FIXED_TASKS=()
    # shellcheck source=/dev/null
    source "$RHTR_DIR/certs/$CERT/exams/$subdir/$fixed.conf"
    local rel; for rel in "${FIXED_TASKS[@]}"; do tasks+=("$pool/$rel"); done
  elif [[ -n "$topic" ]]; then
    mapfile -t tasks < <(find "$pool/$topic" -mindepth 1 -maxdepth 1 -type d | sort)
  else
    if [[ "$FORMAT" == "exam" ]]; then
      mapfile -t tasks < <(find "$pool" -mindepth 1 -maxdepth 1 -type d | sort)
    else
      mapfile -t tasks < <(find "$pool" -mindepth 2 -maxdepth 2 -type d | sort)
    fi
  fi
  [[ ${#tasks[@]} -gt 0 ]] || die "No tasks matched"

  # filter to tasks that actually support this RHEL version
  local -a compatible=()
  local t
  for t in "${tasks[@]}"; do
    local RHEL_VERSIONS=""
    # shellcheck source=/dev/null
    source "$t/meta.sh"
    if [[ -z "$RHEL_VERSIONS" || " $RHEL_VERSIONS " == *" $RHEL_VERSION "* ]]; then
      compatible+=("$t")
    else
      info "skip $(task_short_name "$t") — not marked for RHEL $RHEL_VERSION"
    fi
  done
  tasks=("${compatible[@]}")

  if [[ $rank -eq 1 ]]; then
    _verify_rank "${tasks[@]}"
    return 0
  fi

  # isolated state + VM names so a sweep never touches a live session
  VERIFY_SUFFIX="-vfy${shard:+$shard}"
  export RHTR_VM_SUFFIX="$VERIFY_SUFFIX"   # read by certs/*/topology.sh
  VERIFY_ROOT="$RHTR_DIR/.verify"
  STATE_DIR="$VERIFY_ROOT/state${shard:+-$shard}"
  VERIFY_TSV="$VERIFY_ROOT/${CERT}-${FORMAT}-rhel${RHEL_VERSION}${shard:+-$shard}.tsv"
  mkdir -p "$VERIFY_ROOT"
  rm -rf "$STATE_DIR"

  if [[ $resume -eq 1 ]]; then
    local -a todo=()
    for t in "${tasks[@]}"; do
      _verify_already_done "$(task_short_name "$t")" || todo+=("$t")
    done
    info "Resume: ${#todo[@]}/${#tasks[@]} task(s) left"
    tasks=("${todo[@]}")
    [[ ${#tasks[@]} -gt 0 ]] || { ok "Nothing left to verify"; return 0; }
  fi

  [[ $isolate -eq 1 ]] && batch_size=1

  local -a batches=()
  mapfile -t batches < <(_verify_make_batches tasks "$batch_size")

  info "Verifying ${#tasks[@]} $CERT task(s) on RHEL $RHEL_VERSION in ${#batches[@]} batch(es)"
  echo ""

  VERIFY_RETRY=()
  local b
  for b in "${batches[@]}"; do
    # shellcheck disable=SC2206
    local -a bt=($b)
    _verify_batch "batch" "${bt[@]}"
    _verify_teardown "${bt[@]}"
    echo ""
  done

  # tier 2 — anything that misbehaved gets a clean VM to itself, which
  # separates a broken grader from a neighbour that trampled it
  if [[ ${#VERIFY_RETRY[@]} -gt 0 && $isolate -eq 0 ]]; then
    info "Re-running ${#VERIFY_RETRY[@]} failing task(s) in isolation"
    echo ""
    local rt
    for rt in "${VERIFY_RETRY[@]}"; do
      _verify_batch "isolated" "$rt"
      _verify_teardown "$rt"
    done
  fi

  topology_destroy &>/dev/null || true
  rm -rf "$STATE_DIR"

  _verify_summary
}

_verify_summary() {
  echo ""
  echo -e "  ${C_BOLD}Verify summary${C_RESET} — $VERIFY_TSV"
  echo "  ───────────────────────────────────────────────────────"
  python3 - "$VERIFY_TSV" <<'PY'
import sys, collections
rows = [l.rstrip("\n").split("\t") for l in open(sys.argv[1], newline="\n") if l.strip()]
rows = [r for r in rows if len(r) >= 8]
# a task re-run in isolation supersedes its batch result
best = {}
for r in rows:
    if r[0] not in best or r[5] == "isolated":
        best[r[0]] = r
ok = [r for r in best.values() if r[1]=="ok" and r[2]=="ok" and r[3]=="ok" and r[4] in ("ok","skip")]
bad = [r for r in best.values() if r not in ok]
print(f"  tasks checked : {len(best)}")
print(f"  clean         : {len(ok)}")
print(f"  violations    : {len(bad)}")
if bad:
    kinds = collections.Counter()
    for r in bad:
        for col,label in zip(r[1:5], ("C1","C2","C3","C4")):
            if col not in ("ok","skip"):
                kinds[f"{label}:{col}"] += 1
    print("")
    for k,v in kinds.most_common():
        print(f"    {v:3d}  {k}")
    print("")
    for r in sorted(bad, key=lambda x: x[0]):
        print(f"    {r[0]}")
        print(f"        C1={r[1]} C2={r[2]} C3={r[3]} C4={r[4]}  [{r[5]}]")
        if r[7].strip():
            print(f"        {r[7][:200]}")
PY
  echo "  ───────────────────────────────────────────────────────"
}
