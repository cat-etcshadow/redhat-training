#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH does not exist"
[[ -x "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH is not executable"

# no-arg → exit 1
"$SCRIPT_PATH" &>/dev/null && fail "no-arg should be non-zero" || rc=$?
[[ $rc -eq 1 ]] || fail "no-arg exit code is $rc, expected 1"

# unknown action → exit 3
"$SCRIPT_PATH" frobnicate sshd &>/dev/null && fail "unknown action should be non-zero" || rc=$?
[[ $rc -eq 3 ]] || fail "unknown action exit code is $rc, expected 3"
err=$("$SCRIPT_PATH" frobnicate sshd 2>&1 || true)
echo "$err" | grep -qi 'unknown' || fail "unknown action output doesn't say 'Unknown': $err"

# status action — sshd should be running
out=$("$SCRIPT_PATH" status sshd 2>/dev/null) && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "'status sshd' exited $rc (is sshd running?)"

# start/stop with crond (always available)
"$SCRIPT_PATH" start crond &>/dev/null && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "'start crond' failed with exit $rc"

out=$("$SCRIPT_PATH" stop crond 2>/dev/null) && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "'stop crond' failed with exit $rc"
echo "$out" | grep -qi 'stop' || fail "'stop crond' output missing 'stop': $out"

# restart
"$SCRIPT_PATH" restart sshd &>/dev/null && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "'restart sshd' failed with exit $rc"

# restore crond
systemctl start crond &>/dev/null || true

[[ $errors -eq 0 ]] && exit 0 || exit 1
