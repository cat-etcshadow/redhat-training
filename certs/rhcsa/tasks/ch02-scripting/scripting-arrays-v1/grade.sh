#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH does not exist"
[[ -x "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH is not executable"

# no-arg → exit non-zero
"$SCRIPT_PATH" &>/dev/null && fail "no-arg invocation should be non-zero" || rc=$?
[[ $rc -ne 0 ]] || fail "no-arg exit code is 0, expected non-zero"

# threshold=10 → gadget(8) and gear(3) are low, total 2
out=$("$SCRIPT_PATH" 10) && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "threshold 10 invocation exited $rc"
echo "$out" | grep -q "gadget"                          || fail "threshold 10: missing gadget in output"
echo "$out" | grep -q "gear"                             || fail "threshold 10: missing gear in output"
echo "$out" | grep -qi "Total low-stock items: 2"        || fail "threshold 10: expected total of 2, got: $out"

# threshold=50 → widget(45), gadget(8), gear(3) are low, total 3
out=$("$SCRIPT_PATH" 50) && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "threshold 50 invocation exited $rc"
echo "$out" | grep -qi "Total low-stock items: 3"        || fail "threshold 50: expected total of 3, got: $out"

[[ $errors -eq 0 ]] && exit 0 || exit 1
