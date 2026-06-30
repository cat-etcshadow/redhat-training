#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

tz=$(timedatectl show -p Timezone --value 2>/dev/null)
[[ "$tz" == "$TIMEZONE" ]] \
  || fail "Timezone is '$tz', expected '$TIMEZONE' — run: timedatectl set-timezone $TIMEZONE"

systemctl is-active chronyd &>/dev/null \
  || fail "chronyd is not running — run: systemctl enable --now chronyd"

systemctl is-enabled chronyd &>/dev/null \
  || fail "chronyd is not enabled at boot — run: systemctl enable chronyd"

[[ $errors -eq 0 ]] && exit 0 || exit 1
