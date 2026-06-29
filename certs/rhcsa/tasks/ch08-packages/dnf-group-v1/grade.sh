#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }
rpm -q gcc &>/dev/null || fail "gcc is not installed (Development Tools group not installed?)"
dnf group list installed 2>/dev/null | grep -qi 'Development Tools' \
  || fail "Development Tools group is not marked as installed"
[[ $errors -eq 0 ]] && exit 0 || exit 1
