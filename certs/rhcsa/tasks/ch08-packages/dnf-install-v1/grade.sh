#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }
rpm -q tmux     &>/dev/null || fail "tmux is not installed"
rpm -q man-pages &>/dev/null || fail "man-pages is not installed"
[[ $errors -eq 0 ]] && exit 0 || exit 1
