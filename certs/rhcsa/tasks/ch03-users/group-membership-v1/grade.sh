#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

id "$TARGET_USER" &>/dev/null || fail "User $TARGET_USER does not exist"

primary=$(id -gn "$TARGET_USER" 2>/dev/null)
[[ "$primary" == "$NEW_PRIMARY" ]] \
  || fail "Primary group of $TARGET_USER is '$primary', expected '$NEW_PRIMARY'"

id "$TARGET_USER" | grep -qw "$SUPP_GROUP1" \
  || fail "$TARGET_USER is not a member of supplementary group $SUPP_GROUP1"

id "$TARGET_USER" | grep -qw "$SUPP_GROUP2" \
  || fail "$TARGET_USER is not a member of supplementary group $SUPP_GROUP2"

[[ $errors -eq 0 ]] && exit 0 || exit 1
