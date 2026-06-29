#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

# sha256_worker must be running with nice 15
worker_pid=$(pgrep -f sha256_worker | head -1)
[[ -n "$worker_pid" ]] || fail "sha256_worker process is not running"

worker_nice=$(ps -o nice= -p "$worker_pid" 2>/dev/null | tr -d ' ')
[[ "$worker_nice" == "15" ]] \
  || fail "sha256_worker nice value is $worker_nice, expected 15"

# dd process must be running with nice -5
dd_pid=$(pgrep -f "dd if=/dev/zero" | head -1)
[[ -n "$dd_pid" ]] || fail "dd if=/dev/zero process is not running"

dd_nice=$(ps -o nice= -p "$dd_pid" 2>/dev/null | tr -d ' ')
[[ "$dd_nice" == "-5" ]] \
  || fail "dd process nice value is $dd_nice, expected -5"

[[ $errors -eq 0 ]] && exit 0 || exit 1
