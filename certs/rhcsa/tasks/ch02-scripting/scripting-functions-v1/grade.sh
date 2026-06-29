#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH does not exist"
[[ -x "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH is not executable"

# script must define functions — check source for function keyword or ()
grep -qE '(^|\s)(print_header|check_mountpoint|main)\s*\(\)' "$SCRIPT_PATH" \
  || grep -qE 'function\s+(print_header|check_mountpoint|main)' "$SCRIPT_PATH" \
  || fail "$SCRIPT_PATH does not appear to define the required functions"

# run to stdout
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

# run with --output flag
"$SCRIPT_PATH" --output "$REPORT_FILE" &>/dev/null && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "--output flag caused non-zero exit $rc"
[[ -f "$REPORT_FILE" ]] || fail "--output $REPORT_FILE was not created"
[[ -s "$REPORT_FILE" ]] || fail "--output file $REPORT_FILE is empty"

grep -qi 'Disk Usage Report' "$REPORT_FILE" \
  || fail "$REPORT_FILE missing header (--output did not redirect properly)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
