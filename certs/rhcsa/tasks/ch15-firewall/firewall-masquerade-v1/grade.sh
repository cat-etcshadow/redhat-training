#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

firewall-cmd --permanent --zone="$ZONE" --query-masquerade &>/dev/null \
  || fail "masquerade is not permanently enabled on zone $ZONE"

firewall-cmd --zone="$ZONE" --query-masquerade &>/dev/null \
  || fail "masquerade is not active on zone $ZONE — was 'firewall-cmd --reload' run?"

[[ $errors -eq 0 ]] && exit 0 || exit 1
