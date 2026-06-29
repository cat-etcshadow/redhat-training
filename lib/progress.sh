#!/usr/bin/env bash
# progress.sh — per-task training history in ~/.redhat-training/progress/

PROGRESS_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/redhat-training/progress"

# ── record a task result ──────────────────────────────────────────────────────
progress_record() {
  local cert="$1"       # e.g. rhcsa
  local task_dir="$2"   # absolute path
  local result="$3"     # PASS | FAIL

  local key; key=$(_progress_key "$cert" "$task_dir")
  local file="$PROGRESS_HOME/$cert/$key.json"
  mkdir -p "$(dirname "$file")"

  local attempts=0 passes=0
  if [[ -f "$file" ]]; then
    attempts=$(python3 -c "import json,sys; d=json.load(open('$file')); print(d.get('attempts',0))")
    passes=$(python3   -c "import json,sys; d=json.load(open('$file')); print(d.get('passes',0))")
  fi

  (( attempts++ )) || true
  if [[ $result == "PASS" ]]; then (( passes++ )) || true; fi

  python3 - "$file" "$attempts" "$passes" <<'PY'
import json, sys
path, attempts, passes = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
from datetime import date
data = {"attempts": attempts, "passes": passes, "last_attempted": str(date.today())}
json.dump(data, open(path, "w"), indent=2)
PY
}

# ── read one task's record ────────────────────────────────────────────────────
progress_read() {
  local cert="$1"
  local task_dir="$2"
  local key; key=$(_progress_key "$cert" "$task_dir")
  local file="$PROGRESS_HOME/$cert/$key.json"

  if [[ -f "$file" ]]; then
    cat "$file"
  else
    echo '{"attempts":0,"passes":0,"last_attempted":null}'
  fi
}

# ── display progress table ────────────────────────────────────────────────────
cmd_progress() {
  local cert="$CERT"
  local filter_topic=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --topic) filter_topic="$2"; shift 2 ;;
      *) die "Unknown flag: $1" ;;
    esac
  done

  local search_root="$RHTR_DIR/certs/$cert/tasks"
  if [[ -n "$filter_topic" ]]; then
    local resolved
    resolved=$(_resolve_chapter_dir "$cert" "$filter_topic") \
      || die "Unknown topic: $filter_topic"
    search_root="$resolved"
  fi
  [[ -d "$search_root" ]] || die "No tasks directory for cert: $cert"

  local depth_min=2 depth_max=2
  [[ -n "$filter_topic" ]] && depth_min=1 && depth_max=1

  echo ""
  echo -e "${C_BOLD}Training progress — $cert${filter_topic:+ / $filter_topic}${C_RESET}"
  echo ""
  printf "  %-48s %7s %7s %6s  %s\n" "Task" "Attempts" "Passes" "Rate" "Last"
  printf '  %s\n' "$(printf '─%.0s' {1..80})"

  while IFS= read -r task_dir; do
    local meta="$task_dir/meta.sh"
    [[ -f "$meta" ]] || continue

    local TITLE="" DIFFICULTY=""
    source "$meta"

    local short; short=$(task_short_name "$task_dir")
    local json; json=$(progress_read "$cert" "$task_dir")

    local attempts passes last rate_str
    attempts=$(echo "$json" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['attempts'])")
    passes=$(echo   "$json" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['passes'])")
    last=$(echo     "$json" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['last_attempted'] or '-')")

    if [[ $attempts -gt 0 ]]; then
      local rate=$(( passes * 100 / attempts ))
      rate_str="${rate}%"
      local colour
      [[ $rate -ge 70 ]] && colour="$C_GREEN" || colour="$C_RED"
      printf "  %-48s %7d %7d ${colour}%6s${C_RESET}  %s\n" \
        "$short" "$attempts" "$passes" "$rate_str" "$last"
    else
      printf "  ${C_DIM}%-48s %7s %7s %6s  %s${C_RESET}\n" \
        "$short" "-" "-" "-" "never"
    fi
  done < <(find "$search_root" -mindepth "$depth_min" -maxdepth "$depth_max" -type d | sort)

  echo ""
}

# ── internal ──────────────────────────────────────────────────────────────────
_progress_key() {
  local cert="$1"
  local task_dir="$2"
  local short; short=$(task_short_name "$task_dir")
  # ch05-selinux/fix-file-context-v1 → ch05-selinux__fix-file-context-v1
  echo "${short//\//__}"
}
