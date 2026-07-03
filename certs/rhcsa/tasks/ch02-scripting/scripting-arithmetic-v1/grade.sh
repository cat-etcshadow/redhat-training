#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH does not exist"
[[ -x "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH is not executable"

# wrong arg count -> exit 3
"$SCRIPT_PATH" &>/dev/null && fail "no-arg invocation should be non-zero" || rc=$?
[[ $rc -eq 3 ]] || fail "no-arg exit code is $rc, expected 3"

"$SCRIPT_PATH" 50 &>/dev/null && fail "one-arg invocation should be non-zero" || rc=$?
[[ $rc -eq 3 ]] || fail "one-arg exit code is $rc, expected 3"

# non-numeric -> exit 3
"$SCRIPT_PATH" abc 100 &>/dev/null && fail "non-numeric invocation should be non-zero" || rc=$?
[[ $rc -eq 3 ]] || fail "non-numeric exit code is $rc, expected 3"

# 50/100 -> OK, exit 0
out=$("$SCRIPT_PATH" 50 100) && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "50/100 exited $rc, expected 0"
echo "$out" | grep -q "Usage: 50%" || fail "50/100: missing 'Usage: 50%' in output: $out"
echo "$out" | grep -q "OK"         || fail "50/100: missing OK in output: $out"

# 80/100 -> WARNING, exit 1
out=$("$SCRIPT_PATH" 80 100) && rc=0 || rc=$?
[[ $rc -eq 1 ]] || fail "80/100 exited $rc, expected 1"
echo "$out" | grep -q "WARNING"    || fail "80/100: missing WARNING in output: $out"

# 95/100 -> CRITICAL, exit 2
out=$("$SCRIPT_PATH" 95 100) && rc=0 || rc=$?
[[ $rc -eq 2 ]] || fail "95/100 exited $rc, expected 2"
echo "$out" | grep -q "CRITICAL"   || fail "95/100: missing CRITICAL in output: $out"

# boundary: 90/100 -> CRITICAL
out=$("$SCRIPT_PATH" 90 100) && rc=0 || rc=$?
[[ $rc -eq 2 ]] || fail "90/100 (boundary) exited $rc, expected 2 (CRITICAL)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
