#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

firewall-cmd --permanent --zone=public --list-forward-ports 2>/dev/null \
  | grep -q "port=${FROM_PORT}:proto=tcp:toport=${TO_PORT}" \
  || fail "No permanent forward port rule ${FROM_PORT}->${TO_PORT}/tcp in public zone"

firewall-cmd --zone=public --list-forward-ports 2>/dev/null \
  | grep -q "port=${FROM_PORT}:proto=tcp:toport=${TO_PORT}" \
  || fail "Forward port rule is not active — was 'firewall-cmd --reload' run?"

[[ $errors -eq 0 ]] && exit 0 || exit 1
