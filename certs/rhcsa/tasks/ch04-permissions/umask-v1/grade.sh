#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

id "$UMASK_USER" &>/dev/null || fail "User $UMASK_USER does not exist"

actual=$(su - "$UMASK_USER" -c 'umask' 2>/dev/null | tr -d ' ')
[[ "$actual" == "$UMASK_VAL" ]] \
  || fail "umask for $UMASK_USER is '$actual', expected '$UMASK_VAL'"

grep -q "umask $UMASK_VAL" /etc/profile.d/custom-umask.sh 2>/dev/null \
  || fail "/etc/profile.d/custom-umask.sh does not set umask $UMASK_VAL"

[[ $errors -eq 0 ]] && exit 0 || exit 1
