#!/usr/bin/env bash
sed -i "s/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=${TIMEOUT_VAL}/" /etc/default/grub

if [[ -f /boot/efi/EFI/rocky/grub.cfg ]]; then
  grub2-mkconfig -o /boot/efi/EFI/rocky/grub.cfg
else
  grub2-mkconfig -o /boot/grub2/grub.cfg
fi
