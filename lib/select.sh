#!/usr/bin/env bash
# select.sh — task selection: random weighted, fixed list, topic-all
#
# All functions emit absolute task-dir paths to stdout, one per line.
# Callers collect with: mapfile -t tasks < <(select_tasks ...)

# ── main dispatcher ───────────────────────────────────────────────────────────

# Called after exam.conf variables are set by the profile/flag parsing in exam.sh.
# Reads:  CERT  RHEL_VERSION  (and either TOPICS[] or FIXED_TASKS[] from the profile)
# Emits:  absolute task dir paths
select_tasks() {
  if [[ -n "${FIXED_TASKS[*]:-}" ]]; then
    _select_fixed
  elif [[ -n "${TOPIC_OVERRIDE:-}" ]]; then
    _select_topic_all "$TOPIC_OVERRIDE"
  else
    _select_weighted
  fi
}

# ── weighted random draw ──────────────────────────────────────────────────────

# Accumulates picks across ALL chapters (not just the current one) before
# emitting, so a task's CONFLICTS (declared in meta.sh) can be honoured even
# when the conflicting task lives in a different chapter/topic — e.g. two
# tasks that both claim group_vars/all but in ch03 and ch09 respectively.
# A chapter processed earlier in TOPICS[] wins any conflict; see README.
_select_weighted() {
  local _weighted_selected=()
  for entry in "${TOPICS[@]}"; do
    local chapter="${entry%%:*}"
    local count="${entry##*:}"
    [[ "$count" =~ ^[0-9]+$ ]] || die "Invalid task count '$count' in profile entry '$entry'"
    [[ $count -eq 0 ]] && continue
    local picked=()
    mapfile -t picked < <(_select_random_from_chapter "$chapter" "$count" _weighted_selected)
    _weighted_selected+=("${picked[@]}")
  done
  printf '%s\n' "${_weighted_selected[@]}"
}

_resolve_chapter_dir() {
  local cert="$1" topic="$2"
  local base="$RHTR_DIR/certs/$cert/tasks"
  # Exact match first (also accepts full ch03-users style in profiles)
  [[ -d "$base/$topic" ]] && { echo "$base/$topic"; return 0; }
  # Short name: collect glob matches into an array without process substitution
  local matches=() g
  for g in "$base"/*-"$topic"; do
    [[ -d "$g" ]] && matches+=("$g")
  done
  if [[ ${#matches[@]} -eq 1 ]]; then
    echo "${matches[0]}"; return 0
  elif [[ ${#matches[@]} -gt 1 ]]; then
    warn "Ambiguous topic '$topic' matched multiple dirs — skipping"; return 1
  fi
  return 1
}

_select_random_from_chapter() {
  local chapter="$1"
  local count="$2"
  local -n _already_selected="$3"   # abs paths picked so far this session (other chapters + this one)
  local chapter_dir
  chapter_dir=$(_resolve_chapter_dir "$CERT" "$chapter") \
    || { warn "Chapter dir not found for topic '$chapter' (skipping)"; return; }

  local available=()
  while IFS= read -r d; do
    _task_compatible "$d" && available+=("$d")
  done < <(find "$chapter_dir" -mindepth 1 -maxdepth 1 -type d | sort)

  if [[ ${#available[@]} -eq 0 ]]; then
    warn "No compatible tasks in $chapter for RHEL $RHEL_VERSION"
    return
  fi

  local shuffled=()
  mapfile -t shuffled < <(printf '%s\n' "${available[@]}" | shuf)

  # Draw one at a time instead of a blind `head -n count`, skipping any
  # candidate whose CONFLICTS (meta.sh) intersects what's already selected —
  # a plain shuf|head has no way to avoid two tasks that can't both be
  # satisfied in the same session (see README: "CONFLICTS").
  local picked=() combined=("${_already_selected[@]}") skipped=() d
  for d in "${shuffled[@]}"; do
    [[ ${#picked[@]} -ge $count ]] && break
    if _task_conflicts_with_selected "$d" combined; then
      skipped+=("$(task_short_name "$d")")
      continue
    fi
    picked+=("$d")
    combined+=("$d")
  done

  if [[ ${#picked[@]} -lt $count ]]; then
    warn "Only ${#picked[@]}/$count non-conflicting task(s) available in $chapter"
    [[ ${#skipped[@]} -gt 0 ]] && warn "  skipped (CONFLICTS with an already-selected task): ${skipped[*]}"
  fi

  printf '%s\n' "${picked[@]}"
}

# ── conflict checking (CONFLICTS field in meta.sh) ────────────────────────────

# Emits a task's declared CONFLICTS entries (relative "chXX-topic/task" paths,
# same format as FIXED_TASKS), one per line. Empty if the field is unset.
_task_conflicts_list() {
  local task_dir="$1"
  local CONFLICTS=()
  # shellcheck source=/dev/null
  source "$task_dir/meta.sh"
  [[ ${#CONFLICTS[@]} -eq 0 ]] && return 0
  printf '%s\n' "${CONFLICTS[@]}"
}

# Returns 0 if $1 (an absolute task dir) conflicts with any task dir in the
# array named by $2. CONFLICTS only needs to be declared on one side of a
# pair — checked in both directions so authors don't have to duplicate it.
_task_conflicts_with_selected() {
  local task_dir="$1"
  local -n _sel_ref="$2"
  local task_name; task_name=$(task_short_name "$task_dir")

  local my_conflicts=()
  mapfile -t my_conflicts < <(_task_conflicts_list "$task_dir")

  local other other_name other_conflicts c
  for other in "${_sel_ref[@]}"; do
    other_name=$(task_short_name "$other")
    for c in "${my_conflicts[@]}"; do
      [[ -n "$c" && "$c" == "$other_name" ]] && return 0
    done
    other_conflicts=()
    mapfile -t other_conflicts < <(_task_conflicts_list "$other")
    for c in "${other_conflicts[@]}"; do
      [[ -n "$c" && "$c" == "$task_name" ]] && return 0
    done
  done
  return 1
}

# Returns 0 if two specific task dirs conflict with each other (either
# direction). Used by lint.sh for static pairwise checks — the selector
# itself uses _task_conflicts_with_selected against a whole accumulated list.
_task_conflicts_pair() {
  local a="$1" b="$2"
  local a_name; a_name=$(task_short_name "$a")
  local b_name; b_name=$(task_short_name "$b")

  local a_conflicts=() b_conflicts=() c
  mapfile -t a_conflicts < <(_task_conflicts_list "$a")
  mapfile -t b_conflicts < <(_task_conflicts_list "$b")

  for c in "${a_conflicts[@]}"; do [[ -n "$c" && "$c" == "$b_name" ]] && return 0; done
  for c in "${b_conflicts[@]}"; do [[ -n "$c" && "$c" == "$a_name" ]] && return 0; done
  return 1
}

# ── fixed list ────────────────────────────────────────────────────────────────

# Deliberately does NOT drop conflicting tasks the way _select_random_from_chapter
# does — a fixed list is hand-curated, so silently dropping one member of a
# CONFLICTS pair would change its point total without the author noticing.
# `rhtr <cert> lint` catches conflicting pairs in fixed lists as a hard error
# instead; the fix belongs in the .conf file, not at runtime.
_select_fixed() {
  for rel in "${FIXED_TASKS[@]}"; do
    local abs="$RHTR_DIR/certs/$CERT/tasks/$rel"
    [[ -d "$abs" ]] || die "Fixed task not found: $abs"
    _task_compatible "$abs" \
      || warn "Fixed task $rel is not compatible with RHEL $RHEL_VERSION — including anyway"
    echo "$abs"
  done
}

# ── topic-all (train / topic profile) ────────────────────────────────────────

# Deliberately does NOT skip conflicting tasks — topic-all means "every task
# in this chapter", and a same-chapter CONFLICTS pair can never be avoided by
# dropping one side without silently shrinking what `train --topic` covers.
# `rhtr <cert> lint` treats a same-chapter conflict as a hard error, forcing
# the underlying task content to be fixed rather than the pair suppressed.
_select_topic_all() {
  local chapter="$1"
  local chapter_dir
  chapter_dir=$(_resolve_chapter_dir "$CERT" "$chapter") || die "Unknown topic: $chapter"

  while IFS= read -r d; do
    _task_compatible "$d" && echo "$d"
  done < <(find "$chapter_dir" -mindepth 1 -maxdepth 1 -type d | sort)
}

# ── version compatibility ─────────────────────────────────────────────────────

# Returns 0 if the task's RHEL_VERSIONS includes $RHEL_VERSION (or is unset/empty)
_task_compatible() {
  local task_dir="$1"
  local meta="$task_dir/meta.sh"
  [[ -f "$meta" ]] || return 1

  local RHEL_VERSIONS=""
  # shellcheck source=/dev/null
  source "$meta"

  # If the task doesn't declare RHEL_VERSIONS, assume compatible with everything
  [[ -z "$RHEL_VERSIONS" ]] && return 0

  for v in $RHEL_VERSIONS; do
    [[ "$v" == "$RHEL_VERSION" ]] && return 0
  done
  return 1
}

# ── filtering helpers (used by list.sh) ──────────────────────────────────────

# Emit all task dirs for a cert, optionally filtered
# Args: cert [--topic ch] [--difficulty easy|medium|hard] [--rhel version]
select_list_tasks() {
  local cert="$1"; shift
  local filter_topic="" filter_diff="" filter_rhel=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --topic)      filter_topic="$2";  shift 2 ;;
      --difficulty) filter_diff="$2";   shift 2 ;;
      --rhel)       filter_rhel="$2";   shift 2 ;;
      *) die "select_list_tasks: unknown flag $1" ;;
    esac
  done

  local search_root="$RHTR_DIR/certs/$cert/tasks"
  if [[ -n "$filter_topic" ]]; then
    local resolved
    resolved=$(_resolve_chapter_dir "$cert" "$filter_topic") \
      || die "Unknown topic: $filter_topic"
    search_root="$resolved"
  fi
  [[ -d "$search_root" ]] || die "No tasks found at: $search_root"

  while IFS= read -r task_dir; do
    local meta="$task_dir/meta.sh"
    [[ -f "$meta" ]] || continue

    local DIFFICULTY="" RHEL_VERSIONS=""
    # shellcheck source=/dev/null
    source "$meta"

    [[ -n "$filter_diff"  && "$DIFFICULTY"    != "$filter_diff"  ]] && continue
    if [[ -n "$filter_rhel" && -n "$RHEL_VERSIONS" ]]; then
      local match=0
      for v in $RHEL_VERSIONS; do [[ "$v" == "$filter_rhel" ]] && match=1; done
      [[ $match -eq 0 ]] && continue
    fi

    echo "$task_dir"
  done < <(find "$search_root" -mindepth $([[ -n "$filter_topic" ]] && echo 1 || echo 2) \
                               -maxdepth $([[ -n "$filter_topic" ]] && echo 1 || echo 2) \
                               -type d | sort)
}
