#!/usr/bin/env bash
# lint.sh — static, no-VM authoring checks for tasks/profiles/fixed lists
#
# Catches the authoring-mistake classes already documented elsewhere in this
# codebase (missing NEEDS_DISK/NEEDS_CONTAINERS flags, broken {{KEY}}
# placeholders, bad meta.sh fields, dangling profile/fixed-list references)
# without booting a VM. Runs entirely inside this shell — no incus calls.

# ── findings collection ───────────────────────────────────────────────────────
# Reset before each unit (task/profile/fixed-list); entries are "LEVEL|msg".
_LINT_FINDINGS=()

_lint_add() {
  local level="$1"; shift
  _LINT_FINDINGS+=("$level|$*")
}

# Print "[STATUS] label" then each finding indented underneath; accumulate
# totals into $_LINT_ERR_TOTAL / $_LINT_WARN_TOTAL.
_lint_emit_result() {
  local label="$1"
  local errs=0 warns=0 f level msg

  for f in "${_LINT_FINDINGS[@]}"; do
    level="${f%%|*}"
    [[ "$level" == "ERROR" ]] && (( errs++ )) || true
    [[ "$level" == "WARN"  ]] && (( warns++ )) || true
  done
  (( _LINT_ERR_TOTAL  += errs  )) || true
  (( _LINT_WARN_TOTAL += warns )) || true

  local status colour
  if   [[ $errs  -gt 0 ]]; then status="FAIL"; colour="$C_RED"
  elif [[ $warns -gt 0 ]]; then status="WARN"; colour="$C_YELLOW"
  else                          status="PASS"; colour="$C_GREEN"
  fi
  printf "  ${colour}[%-4s]${C_RESET} %s\n" "$status" "$label"

  for f in "${_LINT_FINDINGS[@]}"; do
    level="${f%%|*}"; msg="${f#*|}"
    if [[ "$level" == "ERROR" ]]; then
      echo -e "         ${C_RED}error:${C_RESET} $msg"
    else
      echo -e "         ${C_YELLOW}warn:${C_RESET}  $msg"
    fi
  done
}

# ── per-task checks ───────────────────────────────────────────────────────────

_lint_check_meta() {
  local task_dir="$1" meta="$task_dir/meta.sh"
  [[ -f "$meta" ]] || { _lint_add ERROR "meta.sh missing"; return; }

  local synerr
  if ! synerr=$(bash -n "$meta" 2>&1); then
    _lint_add ERROR "meta.sh: syntax error — $synerr"
    return
  fi

  local POINTS="" TOPIC="" CHAPTER="" TITLE="" DIFFICULTY="" RHEL_VERSIONS="" \
        NEEDS_DISK="" NEEDS_CONTAINERS=""
  source "$meta" 2>/dev/null || { _lint_add ERROR "meta.sh failed to source"; return; }

  [[ "$POINTS" =~ ^[0-9]+$ && "$POINTS" -gt 0 ]] \
    || _lint_add ERROR "POINTS must be a positive integer (got '${POINTS:-}')"

  [[ -n "$TITLE" ]] || _lint_add ERROR "TITLE is empty"

  case "$DIFFICULTY" in
    easy|medium|hard) ;;
    *) _lint_add ERROR "DIFFICULTY must be easy|medium|hard (got '${DIFFICULTY:-}')" ;;
  esac

  [[ -n "$TOPIC" ]] || _lint_add WARN "TOPIC is empty"

  local chapter_dir_name; chapter_dir_name=$(basename "$(dirname "$task_dir")")
  local dir_chapter_num="${chapter_dir_name#ch}"; dir_chapter_num="${dir_chapter_num%%-*}"
  local dir_topic="${chapter_dir_name#ch*-}"

  if [[ "$dir_chapter_num" =~ ^[0-9]+$ ]]; then
    local dir_chapter_num_norm=$((10#$dir_chapter_num))
    if [[ -n "$CHAPTER" && "$CHAPTER" != "$dir_chapter_num_norm" ]]; then
      _lint_add ERROR "CHAPTER=$CHAPTER does not match directory $chapter_dir_name (expected $dir_chapter_num_norm)"
    fi
  fi

  if [[ -n "$TOPIC" && -n "$dir_topic" && "$TOPIC" != "$dir_topic" ]]; then
    _lint_add WARN "TOPIC='$TOPIC' does not match directory topic '$dir_topic' (profiles resolve chapters by directory name, not TOPIC)"
  fi

  if [[ -n "$RHEL_VERSIONS" ]]; then
    local v
    for v in $RHEL_VERSIONS; do
      [[ " $_LINT_CERT_RHEL_VERSIONS " == *" $v "* ]] \
        || _lint_add ERROR "RHEL_VERSIONS contains '$v', not supported by this cert ($_LINT_CERT_RHEL_VERSIONS)"
    done
  fi

  [[ -z "${NEEDS_DISK:-}" || "$NEEDS_DISK" == "0" || "$NEEDS_DISK" == "1" ]] \
    || _lint_add ERROR "NEEDS_DISK must be 0 or 1 (got '$NEEDS_DISK')"
  [[ -z "${NEEDS_CONTAINERS:-}" || "$NEEDS_CONTAINERS" == "0" || "$NEEDS_CONTAINERS" == "1" ]] \
    || _lint_add ERROR "NEEDS_CONTAINERS must be 0 or 1 (got '$NEEDS_CONTAINERS')"

  return 0
}

_lint_check_syntax() {
  local task_dir="$1" f

  for f in setup.sh grade.sh task.md; do
    [[ -f "$task_dir/$f" ]] || _lint_add ERROR "$f is required but missing"
  done

  for f in setup.sh grade.sh params.sh postsetup.sh solution.sh; do
    local path="$task_dir/$f"
    [[ -f "$path" ]] || continue
    local out
    if ! out=$(bash -n "$path" 2>&1); then
      _lint_add ERROR "$f: syntax error — $out"
    fi
  done

  return 0
}

_lint_check_shellcheck() {
  command -v shellcheck >/dev/null 2>&1 || return 0
  local task_dir="$1" f

  for f in setup.sh grade.sh postsetup.sh params.sh solution.sh; do
    local path="$task_dir/$f"
    [[ -f "$path" ]] || continue
    local line
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      line="${line/#$path:/$f:}"
      _lint_add WARN "$line"
    done < <(shellcheck -S warning -e SC2154 -f gcc "$path" 2>/dev/null || true)
  done

  return 0
}

# Cross-check {{KEY}} placeholders in task.md against what params.sh emits
# (and TASK_DISK_SIZE_GB/DISK_SIZE when NEEDS_DISK=1). params.sh is never
# sourced here — only grepped for its expected `echo "KEY=..."` shape — since
# executing an unreviewed task's script at lint time would defeat the point
# of a static check.
_lint_check_placeholders() {
  local task_dir="$1" task_md="$task_dir/task.md"
  [[ -f "$task_md" ]] || return 0

  local placeholders=()
  mapfile -t placeholders < <(
    grep -oE '\{\{[A-Za-z_][A-Za-z0-9_]*\}\}' "$task_md" 2>/dev/null \
      | sed -E 's/\{\{|\}\}//g' | sort -u
  )
  [[ ${#placeholders[@]} -eq 0 ]] && return 0

  local provided=()
  if [[ -f "$task_dir/params.sh" ]]; then
    mapfile -t provided < <(
      grep -oE 'echo[[:space:]]+"?[A-Za-z_][A-Za-z0-9_]*=' "$task_dir/params.sh" 2>/dev/null \
        | grep -oE '[A-Za-z_][A-Za-z0-9_]*=$' | sed 's/=$//' | sort -u
    )
  fi

  local NEEDS_DISK=""
  source "$task_dir/meta.sh" 2>/dev/null || true
  [[ "${NEEDS_DISK:-}" == "1" ]] && provided+=(TASK_DISK_SIZE_GB DISK_SIZE)

  local key p found
  for key in "${placeholders[@]}"; do
    found=0
    for p in "${provided[@]}"; do [[ "$p" == "$key" ]] && found=1; done
    [[ $found -eq 0 ]] \
      && _lint_add ERROR "task.md uses {{$key}} but no params.sh/NEEDS_DISK source provides it"
  done

  return 0
}

# Flag scripts that use disk/container machinery without declaring the
# matching meta.sh flag — the exact bug _assign_task_disks and
# _assign_task_requirements in lib/exam.sh guard against at session-build
# time; catching it here means it never gets that far.
_lint_check_requirements() {
  local task_dir="$1"
  local NEEDS_DISK="" NEEDS_CONTAINERS=""
  source "$task_dir/meta.sh" 2>/dev/null || true

  local blob="" f
  for f in setup.sh grade.sh params.sh; do
    [[ -f "$task_dir/$f" ]] && blob+=$(cat "$task_dir/$f")$'\n'
  done

  if grep -qE '\$\{?(TASK_DISK_SIZE_GB|DISK_SIZE)\b' <<<"$blob" && [[ "${NEEDS_DISK:-0}" != "1" ]]; then
    _lint_add ERROR "references \$TASK_DISK_SIZE_GB/\$DISK_SIZE but meta.sh doesn't set NEEDS_DISK=1"
  fi

  if grep -qE '\b(podman|skopeo|buildah)\b' <<<"$blob" && [[ "${NEEDS_CONTAINERS:-0}" != "1" ]]; then
    _lint_add ERROR "references podman/skopeo/buildah but meta.sh doesn't set NEEDS_CONTAINERS=1"
  fi

  return 0
}

_lint_one_task() {
  local task_dir="$1"
  _LINT_FINDINGS=()

  _lint_check_meta "$task_dir"
  _lint_check_syntax "$task_dir"
  _lint_check_shellcheck "$task_dir"
  _lint_check_placeholders "$task_dir"
  _lint_check_requirements "$task_dir"

  (( _LINT_TASKS_CHECKED++ )) || true
  _lint_emit_result "$(task_short_name "$task_dir")"
}

# ── profile checks ────────────────────────────────────────────────────────────

_lint_one_profile() {
  local f="$1" name; name=$(basename "$f" .conf)
  _LINT_FINDINGS=()

  local synerr
  if ! synerr=$(bash -n "$f" 2>&1); then
    _lint_add ERROR "syntax error — $synerr"
    _lint_emit_result "profile/$name"
    return
  fi

  local NAME="" DURATION="" PASS_THRESHOLD="" TOPICS=()
  source "$f" 2>/dev/null || { _lint_add ERROR "failed to source"; _lint_emit_result "profile/$name"; return; }

  [[ -n "$NAME" ]] || _lint_add WARN "NAME is empty"
  [[ "$DURATION" =~ ^[0-9]+$ ]] || _lint_add ERROR "DURATION missing or not numeric"
  [[ -z "$PASS_THRESHOLD" || "$PASS_THRESHOLD" =~ ^[0-9]+$ ]] \
    || _lint_add WARN "PASS_THRESHOLD is not numeric"
  [[ ${#TOPICS[@]} -gt 0 ]] || _lint_add ERROR "TOPICS is empty"

  local entry chapter count
  for entry in "${TOPICS[@]}"; do
    chapter="${entry%%:*}"; count="${entry##*:}"
    if [[ ! "$count" =~ ^[0-9]+$ ]]; then
      _lint_add ERROR "bad entry '$entry' — count is not numeric"
      continue
    fi

    local chapter_dir
    if ! chapter_dir=$(_resolve_chapter_dir "$CERT" "$chapter"); then
      _lint_add ERROR "topic '$chapter' in entry '$entry' does not resolve to any chapter dir"
      continue
    fi

    local v
    for v in $_LINT_CERT_RHEL_VERSIONS; do
      local RHEL_VERSION="$v"
      local avail=0 d
      while IFS= read -r d; do
        _task_compatible "$d" && (( avail++ )) || true
      done < <(find "$chapter_dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort)
      (( avail < count )) \
        && _lint_add WARN "'$entry' wants $count from $chapter but only $avail compatible task(s) exist for RHEL $v"
    done
  done

  _lint_emit_result "profile/$name"
}

_lint_profiles() {
  local dir="$RHTR_DIR/certs/$CERT/exams/profiles"
  [[ -d "$dir" ]] || return 0
  echo ""
  echo -e "${C_BOLD}Profiles${C_RESET}"
  local f
  for f in "$dir"/*.conf; do
    [[ -f "$f" ]] || continue
    _lint_one_profile "$f"
  done
}

# ── fixed-list checks ─────────────────────────────────────────────────────────

_lint_one_fixed() {
  local f="$1" name; name=$(basename "$f" .conf)
  _LINT_FINDINGS=()

  local synerr
  if ! synerr=$(bash -n "$f" 2>&1); then
    _lint_add ERROR "syntax error — $synerr"
    _lint_emit_result "fixed/$name"
    return
  fi

  local NAME="" FIXED_TASKS=()
  source "$f" 2>/dev/null || { _lint_add ERROR "failed to source"; _lint_emit_result "fixed/$name"; return; }

  [[ -n "$NAME" ]] || _lint_add WARN "NAME is empty"
  [[ ${#FIXED_TASKS[@]} -gt 0 ]] || _lint_add ERROR "FIXED_TASKS is empty"

  local rel abs seen=() s dup
  for rel in "${FIXED_TASKS[@]}"; do
    abs="$RHTR_DIR/certs/$CERT/tasks/$rel"
    if [[ ! -d "$abs" ]]; then
      _lint_add ERROR "task not found: $rel"
    elif [[ ! -f "$abs/meta.sh" ]]; then
      _lint_add ERROR "$rel: meta.sh missing"
    fi

    dup=0
    for s in "${seen[@]}"; do [[ "$s" == "$rel" ]] && dup=1; done
    [[ $dup -eq 1 ]] && _lint_add WARN "$rel listed more than once"
    seen+=("$rel")
  done

  _lint_emit_result "fixed/$name"
}

_lint_fixed_lists() {
  local dir="$RHTR_DIR/certs/$CERT/exams/fixed"
  [[ -d "$dir" ]] || return 0
  echo ""
  echo -e "${C_BOLD}Fixed exams${C_RESET}"
  local f
  for f in "$dir"/*.conf; do
    [[ -f "$f" ]] || continue
    _lint_one_fixed "$f"
  done
}

# ── summary ───────────────────────────────────────────────────────────────────

_lint_summary() {
  echo ""
  printf '  %s\n' "$(printf '─%.0s' {1..55})"
  echo "  Checked:  $_LINT_TASKS_CHECKED task(s)"
  echo "  Errors:   $_LINT_ERR_TOTAL"
  echo "  Warnings: $_LINT_WARN_TOTAL"
  printf '  %s\n' "$(printf '─%.0s' {1..55})"
  echo ""

  [[ $_LINT_ERR_TOTAL -eq 0 ]]
}

# ── entry point ────────────────────────────────────────────────────────────────

cmd_lint() {
  local target="" filter_topic=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --topic) filter_topic="$2"; shift 2 ;;
      -*)      die "Unknown flag: $1" ;;
      *)       target="$1"; shift ;;
    esac
  done

  [[ -n "$target" && -n "$filter_topic" ]] && die "Specify either a task or --topic, not both"

  _LINT_CERT_RHEL_VERSIONS="$RHEL_VERSIONS"
  _LINT_ERR_TOTAL=0
  _LINT_WARN_TOTAL=0
  _LINT_TASKS_CHECKED=0

  echo ""
  echo -e "${C_BOLD}Lint — $CERT${C_RESET}"
  echo ""

  if [[ -n "$target" ]]; then
    local task_dir; task_dir=$(task_abs_path "$CERT" "$target")
    [[ -d "$task_dir" ]] || die "Task not found: $target"
    _lint_one_task "$task_dir"
  else
    local args=()
    [[ -n "$filter_topic" ]] && args+=(--topic "$filter_topic")

    local task_dir
    while IFS= read -r task_dir; do
      _lint_one_task "$task_dir"
    done < <(select_list_tasks "$CERT" "${args[@]}")

    if [[ -z "$filter_topic" ]]; then
      _lint_profiles
      _lint_fixed_lists
    fi
  fi

  _lint_summary
}
