#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

[[ -d "$TARGET_DIR" ]] || fail "$TARGET_DIR does not exist"

getfacl -p "$TARGET_DIR" 2>/dev/null | grep -q "^user:${TARGET_USER}:" \
  && fail "ACL entry for $TARGET_USER is still present on $TARGET_DIR"

getfacl -p "$TARGET_DIR" 2>/dev/null | grep -q "^group:${TARGET_GROUP}:rwx" \
  || fail "ACL entry for group $TARGET_GROUP was changed or removed, it must remain rwx"

[[ $errors -eq 0 ]] && exit 0 || exit 1
