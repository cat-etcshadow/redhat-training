#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

ss -tln | grep -q ':8080 ' || fail "nothing is listening on port 8080"

firewall-cmd --permanent --zone=public --query-port=8080/tcp &>/dev/null \
  || fail "port 8080/tcp is not permanently open in the public zone"
firewall-cmd --zone=public --query-port=8080/tcp &>/dev/null \
  || fail "port 8080/tcp is not open in the current runtime configuration"

[[ $errors -eq 0 ]] && exit 0 || exit 1
