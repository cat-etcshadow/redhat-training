#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

grep -qE "^GRUB_TIMEOUT=${TIMEOUT_VAL}\$" /etc/default/grub \
  || fail "/etc/default/grub does not set GRUB_TIMEOUT=${TIMEOUT_VAL}"

grep -qE "set timeout=${TIMEOUT_VAL}\$" /boot/grub2/grub.cfg \
  || fail "/boot/grub2/grub.cfg was not regenerated with timeout=${TIMEOUT_VAL}"

[[ $errors -eq 0 ]] && exit 0 || exit 1
