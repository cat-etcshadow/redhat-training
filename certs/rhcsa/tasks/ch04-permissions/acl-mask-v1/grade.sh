#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -d "$TARGET_DIR" ]] || fail "$TARGET_DIR does not exist"

acl=$(getfacl -c "$TARGET_DIR" 2>/dev/null)

echo "$acl" | grep -qE "^group:${TARGET_GROUP}:rwx" \
  || fail "group:$TARGET_GROUP ACL entry is not rwx"

echo "$acl" | grep -qE "^mask::rwx" \
  || fail "ACL mask is not rwx — group entry stays restricted regardless of the named entry"

echo "$acl" | grep "^group:${TARGET_GROUP}:" | grep -q '#effective' \
  && fail "group:$TARGET_GROUP is still restricted by the mask (effective rights differ from rwx)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
