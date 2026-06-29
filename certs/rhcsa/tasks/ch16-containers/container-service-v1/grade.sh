#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f /etc/systemd/system/container-myapp.service ]] \
  || fail "/etc/systemd/system/container-myapp.service does not exist"

systemctl is-enabled container-myapp.service &>/dev/null \
  || fail "container-myapp.service is not enabled"
systemctl is-active container-myapp.service &>/dev/null \
  || fail "container-myapp.service is not active"

[[ $errors -eq 0 ]] && exit 0 || exit 1
