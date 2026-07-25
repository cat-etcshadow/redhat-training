#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

rpm -q "$PKG" &>/dev/null || fail "$PKG is not installed"
[[ -x "$BIN_PATH" ]] || fail "$BIN_PATH is not present or not executable"

[[ $errors -eq 0 ]] && exit 0 || exit 1
