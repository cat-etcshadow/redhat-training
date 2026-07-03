#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

podman ps --format '{{.Names}}' 2>/dev/null | grep -qx rhtr-lifecycle-a \
  && fail "rhtr-lifecycle-a should be stopped, but is still running"

podman ps -a --format '{{.Names}}' 2>/dev/null | grep -qx rhtr-lifecycle-a \
  || fail "rhtr-lifecycle-a should still exist in stopped state, but is missing entirely"

podman ps -a --format '{{.Names}}' 2>/dev/null | grep -qx rhtr-lifecycle-b \
  && fail "rhtr-lifecycle-b should have been removed entirely, but still exists"

[[ $errors -eq 0 ]] && exit 0 || exit 1
