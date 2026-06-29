#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH does not exist"
[[ -x "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH is not executable"

# test: existing user root (UID 0)
out=$("$SCRIPT_PATH" root 2>/dev/null) && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "exit code for existing user 'root' is $rc, expected 0"
echo "$out" | grep -q 'root'         || fail "output for 'root' missing username: $out"
echo "$out" | grep -qE '(UID|uid) ?:? ?0' || fail "output for 'root' missing UID 0: $out"

# test: existing non-root user
out=$("$SCRIPT_PATH" rhtr_testuser 2>/dev/null) && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "exit code for 'rhtr_testuser' is $rc, expected 0"
echo "$out" | grep -q 'rhtr_testuser' || fail "output missing 'rhtr_testuser': $out"

# test: non-existent user must exit 2
"$SCRIPT_PATH" no_such_user_xyz &>/dev/null && rc=0 || rc=$?
[[ $rc -eq 2 ]] || fail "exit code for missing user is $rc, expected 2"
out=$("$SCRIPT_PATH" no_such_user_xyz 2>/dev/null || true)
echo "$out" | grep -qiE 'does not exist|not found|no such' \
  || fail "output for missing user should indicate absence: $out"

# test: no argument must exit 1
"$SCRIPT_PATH" &>/dev/null && rc=0 || rc=$?
[[ $rc -eq 1 ]] || fail "exit code with no args is $rc, expected 1"

[[ $errors -eq 0 ]] && exit 0 || exit 1
