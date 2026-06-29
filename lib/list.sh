#!/usr/bin/env bash
# list.sh — discovery commands (no VM required)

cmd_list_certs() {
  echo ""
  echo -e "${C_BOLD}Supported certifications${C_RESET}"
  echo ""
  printf "  %-8s %-12s %-40s %s\n" "Cert" "Exam code" "Name" "RHEL versions"
  printf '  %s\n' "$(printf '─%.0s' {1..72})"

  for cert_dir in "$RHTR_DIR"/certs/*/; do
    local cert; cert=$(basename "$cert_dir")
    local conf="$cert_dir/cert.conf"
    [[ -f "$conf" ]] || continue

    local CERT_FULL_NAME="" EXAM_CODE="" RHEL_VERSIONS="" DEFAULT_RHEL_VERSION=""
    source "$conf"

    printf "  %-8s %-12s %-40s %s\n" \
      "$cert" "${EXAM_CODE:--}" "${CERT_FULL_NAME:--}" \
      "${RHEL_VERSIONS:-?}  (default: ${DEFAULT_RHEL_VERSION:-?})"
  done
  echo ""
}

cmd_list_topics() {
  echo ""
  echo -e "${C_BOLD}Topics — $CERT${C_RESET}"
  echo ""

  local tasks_dir="$RHTR_DIR/certs/$CERT/tasks"
  [[ -d "$tasks_dir" ]] || die "No tasks directory for cert: $CERT"

  while IFS= read -r chapter_dir; do
    local chapter; chapter=$(basename "$chapter_dir")
    local count; count=$(find "$chapter_dir" -mindepth 1 -maxdepth 1 -type d | wc -l)
    printf "  %-28s  %d task variant(s)\n" "$chapter" "$count"
  done < <(find "$tasks_dir" -mindepth 1 -maxdepth 1 -type d | sort)

  echo ""
}

cmd_list_tasks() {
  # Parse optional filters from remaining args (already shifted past "list-tasks")
  local filter_topic="" filter_diff="" filter_rhel=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --topic)      filter_topic="$2";  shift 2 ;;
      --difficulty) filter_diff="$2";   shift 2 ;;
      --rhel)       filter_rhel="$2";   shift 2 ;;
      *) die "Unknown flag: $1" ;;
    esac
  done

  echo ""
  local header="Tasks — $CERT"
  [[ -n "$filter_topic" ]] && header+=" / $filter_topic"
  [[ -n "$filter_rhel"  ]] && header+=" (RHEL $filter_rhel)"
  echo -e "${C_BOLD}$header${C_RESET}"
  echo ""
  printf "  %-52s %5s  %-8s  %s\n" "Task" "Pts" "Diff" "RHEL"
  printf '  %s\n' "$(printf '─%.0s' {1..80})"

  local args=()
  [[ -n "$filter_topic" ]] && args+=(--topic "$filter_topic")
  [[ -n "$filter_diff"  ]] && args+=(--difficulty "$filter_diff")
  [[ -n "$filter_rhel"  ]] && args+=(--rhel "$filter_rhel")

  local found=0
  while IFS= read -r task_dir; do
    local POINTS=0 DIFFICULTY="" RHEL_VERSIONS="" TITLE=""
    source "$task_dir/meta.sh"

    local short; short=$(task_short_name "$task_dir")
    printf "  %-52s %5d  %-8s  %s\n" \
      "$short" "$POINTS" "${DIFFICULTY:--}" "${RHEL_VERSIONS:-all}"
    (( found++ )) || true
  done < <(select_list_tasks "$CERT" "${args[@]}")

  [[ $found -eq 0 ]] && echo "  (no tasks match the given filters)"
  echo ""
}

cmd_list_profiles() {
  local profiles_dir="$RHTR_DIR/certs/$CERT/exams/profiles"
  echo ""
  echo -e "${C_BOLD}Profiles — $CERT${C_RESET}"
  echo ""
  printf "  %-24s  %-35s  %s\n" "Name" "Description" "Duration"
  printf '  %s\n' "$(printf '─%.0s' {1..70})"

  if [[ -d "$profiles_dir" ]]; then
    while IFS= read -r f; do
      local NAME="" DURATION="" PASS_THRESHOLD="" TOPICS=() FIXED_TASKS=()
      source "$f"
      printf "  %-24s  %-35s  %s\n" \
        "$(basename "$f" .conf)" "${NAME:--}" "${DURATION:+${DURATION} min}"
    done < <(find "$profiles_dir" -name "*.conf" | sort)
  else
    echo "  (none yet)"
  fi
  echo ""
}

cmd_list_fixed() {
  local fixed_dir="$RHTR_DIR/certs/$CERT/exams/fixed"
  echo ""
  echo -e "${C_BOLD}Fixed exams — $CERT${C_RESET}"
  echo ""
  printf "  %-24s  %-35s  %s\n" "Name" "Description" "Tasks"
  printf '  %s\n' "$(printf '─%.0s' {1..70})"

  if [[ -d "$fixed_dir" ]]; then
    while IFS= read -r f; do
      local NAME="" FIXED_TASKS=()
      source "$f"
      printf "  %-24s  %-35s  %d\n" \
        "$(basename "$f" .conf)" "${NAME:--}" "${#FIXED_TASKS[@]}"
    done < <(find "$fixed_dir" -name "*.conf" | sort)
  else
    echo "  (none yet)"
  fi
  echo ""
}

cmd_show_task() {
  local rel="$1"
  [[ -n "$rel" ]] || die "Usage: rhtr <cert> show <chapter/task-variant>"

  local task_dir="$RHTR_DIR/certs/$CERT/tasks/$rel"
  [[ -d "$task_dir" ]] || die "Task not found: $rel"

  local meta="$task_dir/meta.sh"
  local task_md="$task_dir/task.md"

  [[ -f "$meta" ]] && source "$meta"

  echo ""
  echo -e "${C_BOLD}$rel${C_RESET}  (${POINTS:-?} pts · ${DIFFICULTY:--} · RHEL ${RHEL_VERSIONS:-all})"
  echo ""

  if [[ -f "$task_md" ]]; then
    cat "$task_md"
  else
    echo "(no task.md)"
  fi
  echo ""

  if [[ -f "$task_dir/hint.md" ]]; then
    echo -e "${C_DIM}Hint file: hint.md available${C_RESET}"
  fi
  if [[ -f "$task_dir/solution.sh" ]]; then
    echo -e "${C_DIM}Solution file: solution.sh available${C_RESET}"
  fi
  echo ""
}
