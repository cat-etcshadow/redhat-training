#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

default=$(systemctl get-default)
[[ "$default" == "multi-user.target" ]] \
  || fail "default boot target is '$default', expected multi-user.target"

[[ $errors -eq 0 ]] && exit 0 || exit 1
