#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

grep -qE "^GRUB_TIMEOUT=${TIMEOUT_VAL}\$" /etc/default/grub \
  || fail "/etc/default/grub does not set GRUB_TIMEOUT=${TIMEOUT_VAL}"

if [[ -f /boot/efi/EFI/rocky/grub.cfg ]]; then
  grub_cfg=/boot/efi/EFI/rocky/grub.cfg
else
  grub_cfg=/boot/grub2/grub.cfg
fi

grep -qE "set timeout=${TIMEOUT_VAL}\$" "$grub_cfg" \
  || fail "$grub_cfg was not regenerated with timeout=${TIMEOUT_VAL}"

[[ $errors -eq 0 ]] && exit 0 || exit 1
