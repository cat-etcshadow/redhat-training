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

_select_weighted() {
  for entry in "${TOPICS[@]}"; do
    local chapter="${entry%%:*}"
    local count="${entry##*:}"
    [[ $count -eq 0 ]] && continue
    _select_random_from_chapter "$chapter" "$count"
  done
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

  # shuf from the compatible list, take up to $count
  printf '%s\n' "${available[@]}" | shuf | head -n "$count"
}

# ── fixed list ────────────────────────────────────────────────────────────────

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
