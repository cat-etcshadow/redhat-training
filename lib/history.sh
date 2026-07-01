#!/usr/bin/env bash
# history.sh — per-exam score snapshots in ~/.local/share/redhat-training/history/
#
# Distinct from progress.sh (per-task attempt/pass counters): this tracks
# whole-exam grading runs, broken down per topic, so past exams can be
# compared over time to see which topics are weakest.

HISTORY_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/redhat-training/history"

# ── save the last graded exam's per-topic scores ──────────────────────────────
cmd_save() {
  rhtr_require_state
  local label="${1:-}"

  [[ -s "$STATE_DIR/grades.txt" ]] \
    || die "No grades yet. Run: rhtr $CERT grade   (then save)"

  local NAME MODE RHEL_VERSION
  source "$STATE_DIR/exam.conf"

  mkdir -p "$HISTORY_HOME"
  local hist_file="$HISTORY_HOME/$CERT.jsonl"

  local total_pts=0 earned_pts=0
  declare -A topic_earned topic_total
  while IFS='|' read -r task_dir result pts_earned pts_total; do
    local short topic
    short=$(task_short_name "$task_dir")
    topic="${short%%/*}"
    topic_earned[$topic]=$(( ${topic_earned[$topic]:-0} + pts_earned ))
    topic_total[$topic]=$(( ${topic_total[$topic]:-0} + pts_total ))
    (( total_pts  += pts_total ))  || true
    (( earned_pts += pts_earned )) || true
  done < "$STATE_DIR/grades.txt"

  local topics_json="{" first=1 t
  for t in "${!topic_total[@]}"; do
    [[ $first -eq 1 ]] && first=0 || topics_json+=","
    topics_json+="\"$t\":{\"earned\":${topic_earned[$t]},\"total\":${topic_total[$t]}}"
  done
  topics_json+="}"

  local pct=0
  [[ $total_pts -gt 0 ]] && pct=$(( earned_pts * 100 / total_pts ))

  python3 - "$hist_file" "$NAME" "$MODE" "$RHEL_VERSION" "$label" \
    "$earned_pts" "$total_pts" "$pct" "$topics_json" <<'PY'
import json, sys
from datetime import datetime

path, name, mode, rhel, label, earned, total, pct, topics_json = sys.argv[1:10]

entry = {
    "date": datetime.now().isoformat(timespec="seconds"),
    "label": label or None,
    "name": name,
    "mode": mode,
    "rhel": rhel,
    "earned": int(earned),
    "total": int(total),
    "pct": int(pct),
    "topics": json.loads(topics_json),
}
with open(path, "a") as f:
    f.write(json.dumps(entry) + "\n")
PY

  ok "Saved exam result ($earned_pts/$total_pts, ${pct}%)${label:+ — \"$label\"} to history."
}

# ── show best/last score per topic across all saved exams ────────────────────
cmd_overview() {
  local hist_file="$HISTORY_HOME/$CERT.jsonl"

  echo ""
  echo -e "${C_BOLD}Exam history overview — $CERT${C_RESET}"
  echo ""

  if [[ ! -s "$hist_file" ]]; then
    echo "  (no saved exam results yet — run: rhtr $CERT save   after grading)"
    echo ""
    return 0
  fi

  local exam_count; exam_count=$(wc -l < "$hist_file")
  local best_overall
  best_overall=$(python3 -c "
import json
print(max((json.loads(l)['pct'] for l in open('$hist_file')), default=0))
")
  echo "  Exams saved: $exam_count   Best overall score: ${best_overall}%"
  echo ""
  printf "  %-28s %8s %8s %9s  %s\n" "Topic" "Best" "Last" "Attempts" "Last date"
  printf '  %s\n' "$(printf '─%.0s' {1..76})"

  local agg
  agg=$(python3 - "$hist_file" <<'PY'
import json, sys

entries = [json.loads(l) for l in open(sys.argv[1])]
topics = {}
for e in entries:
    for t, v in e.get("topics", {}).items():
        total = v.get("total", 0)
        if total <= 0:
            continue
        pct = v["earned"] * 100 // total
        rec = topics.setdefault(t, {"best": pct, "last": pct, "date": e["date"], "n": 0})
        rec["n"] += 1
        if e["date"] >= rec["date"]:
            rec["last"] = pct
            rec["date"] = e["date"]
        rec["best"] = max(rec["best"], pct)

for t, r in topics.items():
    print(f"{t}|{r['best']}|{r['last']}|{r['n']}|{r['date'][:10]}")
PY
)

  declare -A best_map last_map n_map date_map
  if [[ -n "$agg" ]]; then
    while IFS='|' read -r topic best last n date; do
      [[ -z "$topic" ]] && continue
      best_map[$topic]=$best
      last_map[$topic]=$last
      n_map[$topic]=$n
      date_map[$topic]=$date
    done <<< "$agg"
  fi

  local tasks_dir="$RHTR_DIR/certs/$CERT/tasks"
  local topics=()
  while IFS= read -r chapter_dir; do
    topics+=("$(basename "$chapter_dir")")
  done < <(find "$tasks_dir" -mindepth 1 -maxdepth 1 -type d | sort)

  # weakest / never-tested topics first, so you know what to train for
  local sorted
  sorted=$(for topic in "${topics[@]}"; do
    printf "%s\t%s\n" "${best_map[$topic]:--1}" "$topic"
  done | sort -n | cut -f2)

  while IFS= read -r topic; do
    if [[ -n "${best_map[$topic]:-}" ]]; then
      local best=${best_map[$topic]} last=${last_map[$topic]} n=${n_map[$topic]} date=${date_map[$topic]}
      local colour
      [[ $best -ge 70 ]] && colour="$C_GREEN" || colour="$C_RED"
      printf "  %-28s ${colour}%7s%%${C_RESET} %7s%% %9s  %s\n" "$topic" "$best" "$last" "$n" "$date"
    else
      printf "  ${C_DIM}%-28s %8s %8s %9s  %s${C_RESET}\n" "$topic" "-" "-" "0" "never"
    fi
  done <<< "$sorted"

  echo ""
}
