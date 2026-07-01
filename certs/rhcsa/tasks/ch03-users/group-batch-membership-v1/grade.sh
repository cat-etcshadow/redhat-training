#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

getent group "$TARGET_GROUP" &>/dev/null || fail "group $TARGET_GROUP does not exist"

members=$(getent group "$TARGET_GROUP" | cut -d: -f4)

for u in "$NEW_MEMBER1" "$NEW_MEMBER2" "$NEW_MEMBER3"; do
  echo ",$members," | grep -q ",$u," \
    || fail "$u is not a member of $TARGET_GROUP (members: $members)"
done

echo ",$members," | grep -q ",$OLD_MEMBER," \
  && fail "$OLD_MEMBER is still a member of $TARGET_GROUP — should have been replaced"

[[ $errors -eq 0 ]] && exit 0 || exit 1
