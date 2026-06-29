#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

rpm -q autofs &>/dev/null || fail "autofs is not installed"

[[ -f /etc/auto.master.d/homes.autofs ]] \
  || fail "/etc/auto.master.d/homes.autofs does not exist"
grep -q '/home/remotes' /etc/auto.master.d/homes.autofs \
  || fail "master map does not reference /home/remotes"
grep -q '/etc/auto.homes' /etc/auto.master.d/homes.autofs \
  || fail "master map does not reference /etc/auto.homes"

[[ -f /etc/auto.homes ]] || fail "/etc/auto.homes does not exist"
grep -q 'nfsserver.example.com:/exports/homes' /etc/auto.homes \
  || fail "/etc/auto.homes does not reference nfsserver.example.com:/exports/homes"
grep -q '\*' /etc/auto.homes || fail "/etc/auto.homes does not use a wildcard (*) entry"

systemctl is-enabled autofs &>/dev/null || fail "autofs service is not enabled"
systemctl is-active  autofs &>/dev/null || fail "autofs service is not running"

[[ $errors -eq 0 ]] && exit 0 || exit 1
