#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -d "$SHARED_DIR" ]] || fail "$SHARED_DIR does not exist"

gname=$(stat -c '%G' "$SHARED_DIR")
[[ "$gname" == "$SHARED_GROUP" ]] \
  || fail "Group owner of $SHARED_DIR is '$gname', expected '$SHARED_GROUP'"

perms=$(stat -c '%a' "$SHARED_DIR")
[[ "$perms" == "3770" ]] \
  || fail "Permissions on $SHARED_DIR are '$perms', expected '3770'"

[[ $errors -eq 0 ]] && exit 0 || exit 1
