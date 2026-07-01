#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH does not exist"
[[ -x "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH is not executable"

grep -qE '\buntil\b' "$SCRIPT_PATH" \
  || fail "script does not appear to use an until loop"

rm -f /tmp/rhtr-marker-a /tmp/rhtr-marker-b

# no args → non-zero exit
"$SCRIPT_PATH" &>/dev/null && fail "no-arg invocation should be non-zero" || rc=$?
[[ $rc -ne 0 ]] || fail "no-arg exit code is 0, expected non-zero"

# file already exists → immediate success
touch /tmp/rhtr-marker-a
out=$("$SCRIPT_PATH" /tmp/rhtr-marker-a) && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "existing-file case exited $rc, expected 0"
echo "$out" | grep -qi "found" || fail "existing-file case output missing 'found': $out"

# file never appears → must poll, then time out non-zero
out=$("$SCRIPT_PATH" /tmp/rhtr-marker-b 2>&1) && fail "missing-file case should exit non-zero" || rc=$?
[[ $rc -ne 0 ]] || fail "missing-file exit code is 0, expected non-zero"
echo "$out" | grep -qi "wait"    || fail "missing-file case doesn't show polling/waiting output"
echo "$out" | grep -qi "timeout" || fail "missing-file case doesn't report a timeout"

[[ $errors -eq 0 ]] && exit 0 || exit 1
