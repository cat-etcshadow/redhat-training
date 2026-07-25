#!/usr/bin/env bash
# core.sh — shared helpers: output, guards, path resolution

# ── colours ──────────────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  C_RED='\033[0;31m'
  C_GREEN='\033[0;32m'
  C_YELLOW='\033[0;33m'
  C_CYAN='\033[0;36m'
  C_DIM='\033[2m'
  C_BOLD='\033[1m'
  C_RESET='\033[0m'
else
  C_RED='' C_GREEN='' C_YELLOW='' C_CYAN='' C_DIM='' C_BOLD='' C_RESET=''
fi

# ── output ────────────────────────────────────────────────────────────────────
die()  { echo -e "${C_RED}error:${C_RESET} $*" >&2; exit 1; }
warn() { echo -e "${C_YELLOW}warn:${C_RESET}  $*" >&2; }
info() { echo -e "${C_CYAN}::${C_RESET} $*"; }
ok()   { echo -e "${C_GREEN}ok:${C_RESET}   $*"; }

# ── state guards ──────────────────────────────────────────────────────────────

# Abort if no active session exists
rhtr_require_state() {
  [[ -f "$STATE_DIR/exam.conf" ]] \
    || die "No active session. Run: rhtr <cert> new"
}

# Abort if a session is already active
rhtr_require_no_state() {
  if [[ -f "$STATE_DIR/exam.conf" ]]; then
    local active_cert
    active_cert=$(cat "$STATE_DIR/cert" 2>/dev/null || echo "unknown")
    die "A session is already active (cert: $active_cert). Run: rhtr $active_cert destroy"
  fi
}

# ── path helpers ──────────────────────────────────────────────────────────────

# Root dir of a cert's task pool. format: "training" (default, chNN-nested
# certs/$cert/tasks/) | "exam" (flat certs/$cert/tasks-exam/). Cert-agnostic —
# a cert opts into exam-format just by having a tasks-exam/ dir, no lib
# changes needed.
pool_dir() {
  local cert="$1" format="${2:-training}"
  case "$format" in
    training) echo "$RHTR_DIR/certs/$cert/tasks" ;;
    exam)     echo "$RHTR_DIR/certs/$cert/tasks-exam" ;;
    *) die "Unknown --format '$format' (must be training or exam)" ;;
  esac
}

pool_dir_exists() {
  [[ -d "$(pool_dir "$1" "$2")" ]]
}

# Absolute path to a task dir, given a cert-relative path like "ch05-selinux/fix-v1"
# (or a flat "webserver-stack-v1" slug when format=exam)
task_abs_path() {
  local cert="$1"
  local rel="$2"
  local format="${3:-training}"
  echo "$(pool_dir "$cert" "$format")/$rel"
}

# Short display name for a task dir path — strips whichever pool-dir segment
# (tasks/ or tasks-exam/) the path actually has.
task_short_name() {
  local task_dir="$1"
  local cert_tasks_prefix="$RHTR_DIR/certs"
  local short="${task_dir#$cert_tasks_prefix/*/tasks/}"
  short="${short#$cert_tasks_prefix/*/tasks-exam/}"
  echo "$short"
}

# Filesystem-safe slug for a task dir: ch05-selinux__fix-file-context-v1
task_slug() {
  local task_dir="$1"
  printf '%s__%s' "$(basename "$(dirname "$task_dir")")" "$(basename "$task_dir")"
}

# ── misc ──────────────────────────────────────────────────────────────────────
epoch_to_hhmm() { date -d "@$1" '+%H:%M'; }

seconds_to_hms() {
  local s=$1
  printf '%02d:%02d:%02d' $((s/3600)) $(( (s%3600)/60 )) $((s%60))
}
