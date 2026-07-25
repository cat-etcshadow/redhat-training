#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

[[ -f /etc/systemd/system/container-rhtr-webapp.service ]] \
  || fail "/etc/systemd/system/container-rhtr-webapp.service does not exist"

systemctl is-enabled container-rhtr-webapp.service &>/dev/null \
  || fail "container-rhtr-webapp.service is not enabled"
systemctl is-active container-rhtr-webapp.service &>/dev/null \
  || fail "container-rhtr-webapp.service is not active"

[[ $errors -eq 0 ]] && exit 0 || exit 1
