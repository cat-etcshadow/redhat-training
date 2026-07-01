#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$REPORT_FILE" ]] || fail "$REPORT_FILE does not exist"

expected=$(pgrep -f 'rhtr-worker' | sort -n)
actual=$(grep -oE '[0-9]+' "$REPORT_FILE" | sort -n)

[[ "$actual" == "$expected" ]] \
  || fail "PIDs in $REPORT_FILE ($actual) don't match running rhtr-worker processes ($expected)"

other_pid=$(pgrep -f rhtr-other-proc | head -1)
grep -qw "$other_pid" "$REPORT_FILE" \
  && fail "$REPORT_FILE includes the decoy process rhtr-other-proc (PID $other_pid)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
