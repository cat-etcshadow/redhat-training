#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

pgrep -f rhtr-worker.sh &>/dev/null || fail "rhtr-worker.sh is not running"
[[ -f "$LOG_FILE" ]] || fail "$LOG_FILE does not exist"

size1=$(stat -c%s "$LOG_FILE" 2>/dev/null || echo 0)
sleep 2
size2=$(stat -c%s "$LOG_FILE" 2>/dev/null || echo 0)
(( size2 > size1 )) \
  || fail "$LOG_FILE is not growing — output was not redirected from a live process"

[[ $errors -eq 0 ]] && exit 0 || exit 1
