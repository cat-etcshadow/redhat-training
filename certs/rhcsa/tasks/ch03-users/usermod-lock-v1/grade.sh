#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

id "$LOCK_USER"   &>/dev/null || fail "$LOCK_USER does not exist"
id "$UNLOCK_USER" &>/dev/null || fail "$UNLOCK_USER does not exist"

lock_field=$(getent shadow "$LOCK_USER" | cut -d: -f2)
[[ "$lock_field" == \!* ]] \
  || fail "$LOCK_USER's password field is not locked (expected to start with '!'): $lock_field"

unlock_field=$(getent shadow "$UNLOCK_USER" | cut -d: -f2)
[[ "$unlock_field" != \!* ]] \
  || fail "$UNLOCK_USER's password field is still locked: $unlock_field"
[[ "$unlock_field" =~ ^\$ ]] \
  || fail "$UNLOCK_USER's password hash was removed instead of unlocked: $unlock_field"

[[ $errors -eq 0 ]] && exit 0 || exit 1
