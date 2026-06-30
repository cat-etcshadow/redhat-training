#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

pgrep -f /usr/local/bin/rhtr_alpha &>/dev/null \
  && fail "rhtr_alpha is still running — use: pkill rhtr_alpha"

pgrep -f /usr/local/bin/rhtr_beta &>/dev/null \
  && fail "rhtr_beta is still running — use: killall rhtr_beta"

pid=$(cat /tmp/rhtr_kill_pid 2>/dev/null || echo 0)
if [[ "$pid" -gt 0 ]]; then
  kill -0 "$pid" 2>/dev/null \
    && fail "process $pid (from /tmp/rhtr_kill_pid) is still running — use: kill $pid"
fi

[[ $errors -eq 0 ]] && exit 0 || exit 1
