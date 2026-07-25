#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

[[ -f "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH does not exist"
[[ -x "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH is not executable"

# script must define functions — check source for function keyword or ()
grep -qE '(^|\s)(print_header|check_mountpoint)\s*\(\)' "$SCRIPT_PATH" \
  || grep -qE 'function\s+(print_header|check_mountpoint)' "$SCRIPT_PATH" \
  || fail "$SCRIPT_PATH does not appear to define the required functions"

out=$("$SCRIPT_PATH" 2>/dev/null) && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "script exited $rc"

echo "$out" | grep -qi 'Disk Usage Report' \
  || fail "output missing 'Disk Usage Report' header"

echo "$out" | grep -qE '[0-9]{4}-[0-9]{2}-[0-9]{2}' \
  || fail "output missing a date in YYYY-MM-DD format"

echo "$out" | grep -q '/' \
  || fail "output missing root filesystem check"

echo "$out" | grep -qiE 'OK|WARN' \
  || fail "output missing OK or WARN status indicators"

[[ $errors -eq 0 ]] && exit 0 || exit 1
