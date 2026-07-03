#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f /etc/systemd/system/rhtr-brokensvc.service ]] \
  || fail "/etc/systemd/system/rhtr-brokensvc.service does not exist"

systemctl is-enabled rhtr-brokensvc.service &>/dev/null \
  || fail "rhtr-brokensvc.service is not enabled"

systemctl is-active rhtr-brokensvc.service &>/dev/null \
  || fail "rhtr-brokensvc.service is not active"

grep -q "rhtr-brokensvc ran" /var/log/rhtr-brokensvc.log 2>/dev/null \
  || fail "/var/log/rhtr-brokensvc.log shows no evidence the service actually ran successfully"

[[ $errors -eq 0 ]] && exit 0 || exit 1
