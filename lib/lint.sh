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
  local task_dir="$1" format="${2:-training}" meta="$task_dir/meta.sh"
  [[ -f "$meta" ]] || { _lint_add ERROR "meta.sh missing"; return; }

  local synerr
  if ! synerr=$(bash -n "$meta" 2>&1); then
    _lint_add ERROR "meta.sh: syntax error — $synerr"
    return
  fi

  local POINTS="" TOPIC="" TOPICS=() CHAPTER="" TITLE="" DIFFICULTY="" RHEL_VERSIONS="" \
        NEEDS_DISK="" NEEDS_CONTAINERS="" NEEDS_NODES=() CONFLICTS=()
  source "$meta" 2>/dev/null || { _lint_add ERROR "meta.sh failed to source"; return; }

  [[ "$POINTS" =~ ^[0-9]+$ && "$POINTS" -gt 0 ]] \
    || _lint_add ERROR "POINTS must be a positive integer (got '${POINTS:-}')"

  [[ -n "$TITLE" ]] || _lint_add ERROR "TITLE is empty"

  case "$DIFFICULTY" in
    easy|medium|hard) ;;
    *) _lint_add ERROR "DIFFICULTY must be easy|medium|hard (got '${DIFFICULTY:-}')" ;;
  esac

  if [[ "$format" == "exam" ]]; then
    # Flat pool: no chNN-topic nesting to cross-check CHAPTER/TOPIC against —
    # TOPICS is a plural array of every chapter/topic the scenario spans.
    [[ ${#TOPICS[@]} -gt 0 ]] \
      || _lint_add ERROR "TOPICS is empty (exam-format meta.sh needs an array of every chapter/topic this scenario touches)"
  else
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

  if [[ ${#NEEDS_NODES[@]} -gt 0 ]]; then
    if [[ -z "${_LINT_CERT_MANAGED_NODES:-}" ]]; then
      _lint_add ERROR "NEEDS_NODES set but this cert has no MANAGED_NODES declared in cert.conf"
    else
      local n
      for n in "${NEEDS_NODES[@]}"; do
        [[ " $_LINT_CERT_MANAGED_NODES " == *" $n "* ]] \
          || _lint_add ERROR "NEEDS_NODES contains '$n', not one of this cert's managed nodes ($_LINT_CERT_MANAGED_NODES)"
      done
    fi
  fi

  local this_name; this_name=$(task_short_name "$task_dir")
  local rel abs pool; pool=$(pool_dir "$CERT" "$format")
  for rel in "${CONFLICTS[@]:-}"; do
    [[ -z "$rel" ]] && continue
    if [[ "$rel" == "$this_name" ]]; then
      _lint_add ERROR "CONFLICTS lists itself ('$rel')"
      continue
    fi
    abs="$pool/$rel"
    [[ -d "$abs" ]] || _lint_add ERROR "CONFLICTS references unknown task: $rel"
  done

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

  local NEEDS_DISK="" NEEDS_NODES=() NEEDS_DISK_SIZE_MIB=""
  source "$task_dir/meta.sh" 2>/dev/null || true
  if [[ "${NEEDS_DISK:-}" == "1" ]]; then
    provided+=(DISK_SIZE)
    if [[ -n "$NEEDS_DISK_SIZE_MIB" ]]; then
      provided+=(TASK_DISK_SIZE_MIB)
    else
      provided+=(TASK_DISK_SIZE_GB)
    fi
    # A per-node disk (NEEDS_NODES set) gets its real device name discovered
    # and injected as DISK by _generate_task_params — see lib/exam.sh.
    [[ ${#NEEDS_NODES[@]} -gt 0 ]] && provided+=(DISK)
  fi

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
#
# Gated on _LINT_CERT_USES_DISK/_LINT_CERT_USES_CONTAINERS (whether this
# cert's topology.sh actually reads EXTRA_DISK_SIZES_GIB/SESSION_NEEDS_CONTAINERS)
# — RHCE's topology installs podman unconditionally and never attaches a
# dynamic extra disk, so NEEDS_DISK/NEEDS_CONTAINERS are inert there and
# flagging their absence would be a systematic false positive.
_lint_check_requirements() {
  local task_dir="$1"
  local NEEDS_DISK="" NEEDS_CONTAINERS=""
  source "$task_dir/meta.sh" 2>/dev/null || true

  local blob="" f
  for f in setup.sh nodesetup.sh grade.sh params.sh; do
    [[ -f "$task_dir/$f" ]] && blob+=$(cat "$task_dir/$f")$'\n'
  done

  if [[ "${_LINT_CERT_USES_DISK:-0}" == "1" ]] \
     && grep -qE '\$\{?(TASK_DISK_SIZE_GB|TASK_DISK_SIZE_MIB|DISK_SIZE)\b' <<<"$blob" \
     && [[ "${NEEDS_DISK:-0}" != "1" ]]; then
    _lint_add ERROR "references \$TASK_DISK_SIZE_GB/\$TASK_DISK_SIZE_MIB/\$DISK_SIZE but meta.sh doesn't set NEEDS_DISK=1"
  fi

  if [[ "${_LINT_CERT_USES_CONTAINERS:-0}" == "1" ]] \
     && grep -qE '\b(podman|skopeo|buildah)\b' <<<"$blob" \
     && [[ "${NEEDS_CONTAINERS:-0}" != "1" ]]; then
    _lint_add ERROR "references podman/skopeo/buildah but meta.sh doesn't set NEEDS_CONTAINERS=1"
  fi

  return 0
}

# tasks-exam/ gives no hints (the real exam doesn't either) — net-new rule,
# hint.md was never checked/required/forbidden anywhere before this.
_lint_check_no_hint() {
  local task_dir="$1"
  [[ -f "$task_dir/hint.md" ]] \
    && _lint_add ERROR "hint.md present — the exam-format pool gives no hints"
  return 0
}

# Enforce "outcome/state only, never names a module/collection/construct"
# for the exam-format pool (TODO.md Phase 12a). FQCN matches are near-zero
# false-positive (a collection.module string can't appear in ordinary prose
# by accident) so they're a hard ERROR; bare module-ish words are looser and
# only WARN, since legitimate outcome-only prose can still contain them (e.g.
# "the service should be running").
_lint_check_no_module_naming() {
  local task_dir="$1" task_md="$task_dir/task.md"
  [[ -f "$task_md" ]] || return 0

  local fqcn
  fqcn=$(grep -oE '\b(community\.general|ansible\.posix|ansible\.builtin)\.[A-Za-z_]+' \
    "$task_md" 2>/dev/null | sort -u || true)
  if [[ -n "$fqcn" ]]; then
    local m
    while IFS= read -r m; do
      _lint_add ERROR "task.md names a fully-qualified module/collection: $m (exam-format tasks must state outcome only)"
    done <<< "$fqcn"
  fi

  local bare
  bare=$(grep -iohE '\b(firewalld|seboolean|sefcontext|nmcli|lineinfile|template|handlers?|tags?|registered?|loop|block|rescue|lvol|parted|authorized_key|cron module|copy module|command module)\b' \
    "$task_md" 2>/dev/null | tr 'A-Z' 'a-z' | sort -u | tr '\n' ' ' || true)
  [[ -n "$bare" ]] \
    && _lint_add WARN "task.md mentions module-ish word(s) — double-check this states an outcome, not a mechanism: $bare"

  return 0
}

_lint_one_task() {
  local task_dir="$1" format="${2:-training}"
  _LINT_FINDINGS=()

  _lint_check_meta "$task_dir" "$format"
  _lint_check_syntax "$task_dir"
  _lint_check_shellcheck "$task_dir"
  _lint_check_placeholders "$task_dir"
  _lint_check_requirements "$task_dir"

  if [[ "$format" == "exam" ]]; then
    _lint_check_no_hint "$task_dir"
    _lint_check_no_module_naming "$task_dir"
  fi

  (( _LINT_TASKS_CHECKED++ )) || true
  _lint_emit_result "$(task_short_name "$task_dir")"
}

# ── same-chapter conflict checks ──────────────────────────────────────────────
# A CONFLICTS pair inside the same chapter can never be avoided at runtime —
# `train --topic` always draws every task in a chapter together
# (_select_topic_all in lib/select.sh doesn't consult CONFLICTS on purpose,
# see the comment there) — so this is promoted to a hard error instead of the
# WARN a cross-chapter pair gets in _lint_one_profile below.
_lint_chapter_conflicts() {
  local base; base=$(pool_dir "$CERT" training)
  [[ -d "$base" ]] || return 0
  echo ""
  echo -e "${C_BOLD}Same-chapter conflicts${C_RESET}"

  local chapter_dir
  for chapter_dir in "$base"/*/; do
    [[ -d "$chapter_dir" ]] || continue
    local chapter_name; chapter_name=$(basename "$chapter_dir")
    _LINT_FINDINGS=()

    local tasks=()
    mapfile -t tasks < <(find "$chapter_dir" -mindepth 1 -maxdepth 1 -type d | sort)

    if [[ ${#tasks[@]} -ge 2 ]]; then
      local i j
      for (( i=0; i<${#tasks[@]}; i++ )); do
        for (( j=i+1; j<${#tasks[@]}; j++ )); do
          _task_conflicts_pair "${tasks[$i]}" "${tasks[$j]}" \
            && _lint_add ERROR "$(task_short_name "${tasks[$i]}") conflicts with $(task_short_name "${tasks[$j]}") — 'train --topic' always draws them together"
        done
      done
    fi

    _lint_emit_result "chapter/$chapter_name"
  done
}

# All-pairs CONFLICTS check across the flat exam-format pool — there's no
# chapter grouping to scope it by the way _lint_chapter_conflicts does above,
# but the pool is small (~15-20 curated scenarios) so an all-pairs check is
# cheap.
_lint_scenario_conflicts() {
  local base; base=$(pool_dir "$CERT" exam)
  [[ -d "$base" ]] || return 0
  echo ""
  echo -e "${C_BOLD}Scenario conflicts (exam-format pool)${C_RESET}"
  _LINT_FINDINGS=()

  local tasks=()
  mapfile -t tasks < <(find "$base" -mindepth 1 -maxdepth 1 -type d | sort)

  if [[ ${#tasks[@]} -ge 2 ]]; then
    local i j
    for (( i=0; i<${#tasks[@]}; i++ )); do
      for (( j=i+1; j<${#tasks[@]}; j++ )); do
        _task_conflicts_pair "${tasks[$i]}" "${tasks[$j]}" \
          && _lint_add ERROR "$(task_short_name "${tasks[$i]}") conflicts with $(task_short_name "${tasks[$j]}") — both may be drawn together from the flat pool"
      done
    done
  fi

  _lint_emit_result "tasks-exam pool"
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
  local resolved_dirs=() resolved_names=()
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
    [[ "$count" -gt 0 ]] && { resolved_dirs+=("$chapter_dir"); resolved_names+=("$chapter"); }

    # named _rv, not v — _task_compatible's own internal `for v in
    # $RHEL_VERSIONS` loop (lib/select.sh) doesn't declare v local, so it
    # clobbers any enclosing `local v` via bash's dynamic scoping once it's
    # called from inside this loop
    local _rv
    for _rv in $_LINT_CERT_RHEL_VERSIONS; do
      local RHEL_VERSION="$_rv"
      local avail=0 d
      while IFS= read -r d; do
        _task_compatible "$d" && (( avail++ )) || true
      done < <(find "$chapter_dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort)
      (( avail < count )) \
        && _lint_add WARN "'$entry' wants $count from $chapter but only $avail compatible task(s) exist for RHEL $_rv"
    done
  done

  # Cross-chapter CONFLICTS pairs: merely possible, not guaranteed (the
  # per-chapter counts are usually less than the full chapter), so this stays
  # a WARN — _select_random_from_chapter (lib/select.sh) already avoids
  # drawing both members of a pair together at runtime. Flagged here purely
  # so the profile author knows the pair exists and why an exam might come up
  # short of the requested count for one of these chapters.
  local ci cj
  for (( ci=0; ci<${#resolved_dirs[@]}; ci++ )); do
    for (( cj=ci+1; cj<${#resolved_dirs[@]}; cj++ )); do
      local ta tb
      while IFS= read -r ta; do
        while IFS= read -r tb; do
          _task_conflicts_pair "$ta" "$tb" \
            && _lint_add WARN "$(task_short_name "$ta") conflicts with $(task_short_name "$tb") — both may be drawn by this profile (${resolved_names[$ci]}+${resolved_names[$cj]}); the selector avoids pairing them, so the exam may come up short on one topic"
        done < <(find "${resolved_dirs[$cj]}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort)
      done < <(find "${resolved_dirs[$ci]}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort)
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
    abs="$(pool_dir "$CERT" training)/$rel"
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

  # A fixed list is hand-curated and always runs every listed task together —
  # unlike a profile, there's no "merely possible" case here, so a conflicting
  # pair is a hard error, same as the same-chapter check above.
  local abs_tasks=()
  for rel in "${FIXED_TASKS[@]}"; do
    abs="$(pool_dir "$CERT" training)/$rel"
    [[ -d "$abs" ]] && abs_tasks+=("$abs")
  done
  local i j
  for (( i=0; i<${#abs_tasks[@]}; i++ )); do
    for (( j=i+1; j<${#abs_tasks[@]}; j++ )); do
      _task_conflicts_pair "${abs_tasks[$i]}" "${abs_tasks[$j]}" \
        && _lint_add ERROR "$(task_short_name "${abs_tasks[$i]}") conflicts with $(task_short_name "${abs_tasks[$j]}") — both are listed in this fixed exam"
    done
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

# ── exam-format profile / fixed-list checks ───────────────────────────────────
# Parallel to _lint_one_profile/_lint_one_fixed above, but the schema differs
# (SCENARIO_COUNT "pick N of the flat pool" instead of TOPICS "chapter:count",
# SCENARIOS instead of FIXED_TASKS) and resolves against tasks-exam/ instead
# of tasks/.

_lint_one_profile_exam() {
  local f="$1" name; name=$(basename "$f" .conf)
  _LINT_FINDINGS=()

  local synerr
  if ! synerr=$(bash -n "$f" 2>&1); then
    _lint_add ERROR "syntax error — $synerr"
    _lint_emit_result "profile-exam/$name"
    return
  fi

  local NAME="" DURATION="" PASS_THRESHOLD="" SCENARIO_COUNT=""
  source "$f" 2>/dev/null || { _lint_add ERROR "failed to source"; _lint_emit_result "profile-exam/$name"; return; }

  [[ -n "$NAME" ]] || _lint_add WARN "NAME is empty"
  [[ "$DURATION" =~ ^[0-9]+$ ]] || _lint_add ERROR "DURATION missing or not numeric"
  [[ -z "$PASS_THRESHOLD" || "$PASS_THRESHOLD" =~ ^[0-9]+$ ]] \
    || _lint_add WARN "PASS_THRESHOLD is not numeric"
  [[ "$SCENARIO_COUNT" =~ ^[0-9]+$ && "$SCENARIO_COUNT" -gt 0 ]] \
    || _lint_add ERROR "SCENARIO_COUNT must be a positive integer (got '${SCENARIO_COUNT:-}')"

  local pool; pool=$(pool_dir "$CERT" exam)
  local _rv
  for _rv in $_LINT_CERT_RHEL_VERSIONS; do
    local RHEL_VERSION="$_rv" d avail=0
    while IFS= read -r d; do
      _task_compatible "$d" && (( avail++ )) || true
    done < <(find "$pool" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort)
    [[ "$SCENARIO_COUNT" =~ ^[0-9]+$ ]] && (( avail < SCENARIO_COUNT )) \
      && _lint_add WARN "SCENARIO_COUNT=$SCENARIO_COUNT but only $avail compatible scenario(s) exist for RHEL $_rv"
  done

  _lint_emit_result "profile-exam/$name"
}

_lint_profiles_exam() {
  local dir="$RHTR_DIR/certs/$CERT/exams/profiles-exam"
  [[ -d "$dir" ]] || return 0
  echo ""
  echo -e "${C_BOLD}Profiles (exam-format)${C_RESET}"
  local f
  for f in "$dir"/*.conf; do
    [[ -f "$f" ]] || continue
    _lint_one_profile_exam "$f"
  done
}

_lint_one_fixed_exam() {
  local f="$1" name; name=$(basename "$f" .conf)
  _LINT_FINDINGS=()

  local synerr
  if ! synerr=$(bash -n "$f" 2>&1); then
    _lint_add ERROR "syntax error — $synerr"
    _lint_emit_result "fixed-exam/$name"
    return
  fi

  local NAME="" SCENARIOS=()
  source "$f" 2>/dev/null || { _lint_add ERROR "failed to source"; _lint_emit_result "fixed-exam/$name"; return; }

  [[ -n "$NAME" ]] || _lint_add WARN "NAME is empty"
  [[ ${#SCENARIOS[@]} -gt 0 ]] || _lint_add ERROR "SCENARIOS is empty"

  local pool; pool=$(pool_dir "$CERT" exam)
  local rel abs seen=() s dup
  for rel in "${SCENARIOS[@]}"; do
    abs="$pool/$rel"
    if [[ ! -d "$abs" ]]; then
      _lint_add ERROR "scenario not found: $rel"
    elif [[ ! -f "$abs/meta.sh" ]]; then
      _lint_add ERROR "$rel: meta.sh missing"
    fi
    dup=0
    for s in "${seen[@]}"; do [[ "$s" == "$rel" ]] && dup=1; done
    [[ $dup -eq 1 ]] && _lint_add WARN "$rel listed more than once"
    seen+=("$rel")
  done

  local abs_tasks=()
  for rel in "${SCENARIOS[@]}"; do
    abs="$pool/$rel"
    [[ -d "$abs" ]] && abs_tasks+=("$abs")
  done
  local i j
  for (( i=0; i<${#abs_tasks[@]}; i++ )); do
    for (( j=i+1; j<${#abs_tasks[@]}; j++ )); do
      _task_conflicts_pair "${abs_tasks[$i]}" "${abs_tasks[$j]}" \
        && _lint_add ERROR "$(task_short_name "${abs_tasks[$i]}") conflicts with $(task_short_name "${abs_tasks[$j]}") — both are listed in this fixed exam"
    done
  done

  _lint_emit_result "fixed-exam/$name"
}

_lint_fixed_lists_exam() {
  local dir="$RHTR_DIR/certs/$CERT/exams/fixed-exam"
  [[ -d "$dir" ]] || return 0
  echo ""
  echo -e "${C_BOLD}Fixed exams (exam-format)${C_RESET}"
  local f
  for f in "$dir"/*.conf; do
    [[ -f "$f" ]] || continue
    _lint_one_fixed_exam "$f"
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
  local target="" filter_topic="" format="training"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --topic)  filter_topic="$2"; shift 2 ;;
      --format) format="$2";       shift 2 ;;
      -*)       die "Unknown flag: $1" ;;
      *)        target="$1"; shift ;;
    esac
  done

  [[ "$format" == "training" || "$format" == "exam" ]] \
    || die "Unknown --format '$format' (must be training or exam)"
  [[ -n "$target" && -n "$filter_topic" ]] && die "Specify either a task or --topic, not both"
  [[ "$format" == "exam" && -n "$filter_topic" ]] \
    && die "--topic isn't supported with --format exam (the exam-format pool is flat, not chapter-nested)"

  _LINT_CERT_RHEL_VERSIONS="$RHEL_VERSIONS"
  _LINT_ERR_TOTAL=0
  _LINT_WARN_TOTAL=0
  _LINT_TASKS_CHECKED=0

  _LINT_CERT_USES_DISK=0
  _LINT_CERT_USES_CONTAINERS=0
  _LINT_CERT_MANAGED_NODES="${MANAGED_NODES:-}"
  local topology_file="$RHTR_DIR/certs/$CERT/topology.sh"
  if [[ -f "$topology_file" ]]; then
    grep -qE 'EXTRA_DISK_SIZES_GIB|task-disks\.txt' "$topology_file" && _LINT_CERT_USES_DISK=1
    grep -q 'SESSION_NEEDS_CONTAINERS' "$topology_file" && _LINT_CERT_USES_CONTAINERS=1
  fi

  echo ""
  echo -e "${C_BOLD}Lint — $CERT [$format]${C_RESET}"
  echo ""

  if [[ -n "$target" ]]; then
    local task_dir; task_dir=$(task_abs_path "$CERT" "$target" "$format")
    [[ -d "$task_dir" ]] || die "Task not found: $target"
    _lint_one_task "$task_dir" "$format"
  elif [[ "$format" == "exam" ]]; then
    local pool; pool=$(pool_dir "$CERT" exam)
    if [[ -d "$pool" ]]; then
      local task_dir
      while IFS= read -r task_dir; do
        _lint_one_task "$task_dir" exam
      done < <(find "$pool" -mindepth 1 -maxdepth 1 -type d | sort)
    fi
    _lint_scenario_conflicts
    _lint_profiles_exam
    _lint_fixed_lists_exam
  else
    local args=()
    [[ -n "$filter_topic" ]] && args+=(--topic "$filter_topic")

    local task_dir
    while IFS= read -r task_dir; do
      _lint_one_task "$task_dir" training
    done < <(select_list_tasks "$CERT" "${args[@]}")

    if [[ -z "$filter_topic" ]]; then
      _lint_chapter_conflicts
      _lint_profiles
      _lint_fixed_lists
    fi
  fi

  _lint_summary
}
