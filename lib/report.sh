#!/usr/bin/env bash
# report.sh — grading loop, scoring, result display

# ── grade all tasks in the active session ─────────────────────────────────────
grade_all_tasks() {
  rhtr_require_state

  local cert duration pass_threshold mode
  source "$STATE_DIR/exam.conf"

  [[ -f "$STATE_DIR/active-tasks.txt" ]] \
    || die "No task list found. Re-run: rhtr $cert new"

  # Determine timing state
  local now; now=$(date +%s)
  local time_note=""
  if [[ -n "${DEADLINE_EPOCH:-}" ]]; then
    if [[ $now -gt $DEADLINE_EPOCH ]]; then
      time_note="${C_RED}OVERTIME${C_RESET}"
    else
      local remaining=$(( DEADLINE_EPOCH - now ))
      time_note="$(seconds_to_hms $remaining) remaining"
    fi
  fi

  echo ""
  echo -e "${C_BOLD}Grading session${C_RESET} — $NAME${time_note:+ ($time_note)}"
  echo ""

  # Clear previous grades
  : > "$STATE_DIR/grades.txt"

  local total_pts=0 earned_pts=0 task_num=0

  # Read into array so vm_exec calls inside the loop cannot consume the fd
  local task_dirs=()
  mapfile -t task_dirs < "$STATE_DIR/active-tasks.txt"

  local task_dir
  for task_dir in "${task_dirs[@]}"; do
    (( task_num++ )) || true

    local POINTS=0 TITLE="" DIFFICULTY="" RHEL_VERSIONS=""
    source "$task_dir/meta.sh"

    local grade_script="$task_dir/grade.sh"
    local result="FAIL" exit_code=1

    if [[ ! -f "$grade_script" ]]; then
      warn "No grade.sh in $(task_short_name "$task_dir") — skipping"
    else
      # Run grade script inside the primary VM; capture output for diagnostics
      local output
      output=$(_run_task_script "${VM_NAMES[0]}" "$grade_script" "$task_dir" 2>&1) && exit_code=0 || exit_code=$?
    fi

    [[ $exit_code -eq 0 ]] && result="PASS"

    local pts_earned=0
    [[ $result == "PASS" ]] && pts_earned=$POINTS

    # Persist result
    echo "$task_dir|$result|$pts_earned|$POINTS" >> "$STATE_DIR/grades.txt"

    _print_task_row "$task_num" "$result" "$(task_short_name "$task_dir")" "$POINTS" "$pts_earned"

    # Show diagnostics and solution on failure in train mode
    if [[ $result == "FAIL" && "${MODE:-exam}" == "train" ]]; then
      [[ -n "${output:-}" ]] && echo -e "   ${C_DIM}$output${C_RESET}"
      _show_solution "$task_dir"
    fi

    (( total_pts  += POINTS ))     || true
    (( earned_pts += pts_earned )) || true
  done

  print_score "$earned_pts" "$total_pts" "${PASS_THRESHOLD:-70}"
}

# ── display helpers ───────────────────────────────────────────────────────────
_print_task_row() {
  local num="$1" result="$2" name="$3" max_pts="$4" earned_pts="$5"

  local colour
  [[ $result == "PASS" ]] && colour="$C_GREEN" || colour="$C_RED"

  printf "  ${colour}[%-4s]${C_RESET} %2d. %-45s %3d pts\n" \
    "$result" "$num" "$name" "$max_pts"
}

# Print a failed task's solution.sh, if one exists (train mode only — called
# from grade_all_tasks after diagnostics, never in exam mode).
_show_solution() {
  local task_dir="$1"
  local solution="$task_dir/solution.sh"
  [[ -f "$solution" ]] || return 0

  echo -e "   ${C_YELLOW}Solution — $(task_short_name "$task_dir")${C_RESET}"
  local line
  while IFS= read -r line; do
    echo -e "   ${C_DIM}$line${C_RESET}"
  done < "$solution"
  echo ""
}

print_score() {
  local earned="$1" total="$2" threshold="${3:-70}"
  local pct=0
  [[ $total -gt 0 ]] && pct=$(( earned * 100 / total ))

  local verdict_colour verdict
  if [[ $pct -ge $threshold ]]; then
    verdict_colour="$C_GREEN"; verdict="PASS"
  else
    verdict_colour="$C_RED"; verdict="FAIL"
  fi

  echo ""
  printf '  %s\n' "$(printf '─%.0s' {1..55})"
  printf "  Score:  %d / %d  (%d%%)\n" "$earned" "$total" "$pct"
  printf "  Result: ${verdict_colour}%s${C_RESET}  (threshold: %d%%)\n" "$verdict" "$threshold"
  printf '  %s\n' "$(printf '─%.0s' {1..55})"
  echo ""
}

# Re-display last grading results from grades.txt without re-running graders
print_cached_report() {
  rhtr_require_state
  [[ -f "$STATE_DIR/grades.txt" ]] || die "No grades yet. Run: rhtr <cert> grade"

  local cert; source "$STATE_DIR/exam.conf"
  local total_pts=0 earned_pts=0 task_num=0

  echo ""
  echo -e "${C_BOLD}Last grading result${C_RESET} — $NAME"
  echo ""

  while IFS='|' read -r task_dir result pts_earned pts_total; do
    (( task_num++ ))       || true
    _print_task_row "$task_num" "$result" "$(task_short_name "$task_dir")" \
      "$pts_total" "$pts_earned"
    (( total_pts  += pts_total ))  || true
    (( earned_pts += pts_earned )) || true
  done < "$STATE_DIR/grades.txt"

  print_score "$earned_pts" "$total_pts" "${PASS_THRESHOLD:-70}"
}
