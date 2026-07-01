#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

rpm -q "$PKG_A" &>/dev/null \
  && fail "$PKG_A is still installed — the transaction was not undone"
rpm -q "$PKG_B" &>/dev/null \
  && fail "$PKG_B is still installed — the transaction was not undone"

[[ $errors -eq 0 ]] && exit 0 || exit 1
