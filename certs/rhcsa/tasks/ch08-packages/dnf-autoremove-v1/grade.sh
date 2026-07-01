#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

rpm -q "$PKG" &>/dev/null \
  && fail "$PKG is still installed — it should have been cleaned up as an orphaned dependency"

[[ $errors -eq 0 ]] && exit 0 || exit 1
