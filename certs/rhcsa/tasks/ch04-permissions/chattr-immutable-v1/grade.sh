#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$PROTECTED_FILE" ]] || fail "$PROTECTED_FILE does not exist"

lsattr "$PROTECTED_FILE" 2>/dev/null | awk '{print $1}' | grep -q 'i' \
  || fail "$PROTECTED_FILE does not have the immutable attribute set"

[[ $errors -eq 0 ]] && exit 0 || exit 1
