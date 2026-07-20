#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

id "$UMASK_USER" &>/dev/null || fail "User $UMASK_USER does not exist"

actual_user=$(su - "$UMASK_USER" -c 'umask' 2>/dev/null | tr -d ' ')
actual_user=${actual_user#0}
[[ "$actual_user" == "$UMASK_VAL" ]] \
  || fail "umask for $UMASK_USER is '$actual_user', expected '$UMASK_VAL'"

tmp_user="umaskgrade$$"
trap 'userdel -r "$tmp_user" 2>/dev/null || true' EXIT
useradd -m "$tmp_user" 2>/dev/null
actual_sys=$(su - "$tmp_user" -c 'umask' 2>/dev/null | tr -d ' ')
actual_sys=${actual_sys#0}
[[ "$actual_sys" == "$UMASK_VAL" ]] \
  || fail "system-wide umask is '$actual_sys' (tested via fresh user), expected '$UMASK_VAL'"

[[ $errors -eq 0 ]] && exit 0 || exit 1
