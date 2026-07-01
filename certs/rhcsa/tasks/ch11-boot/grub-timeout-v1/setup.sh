#!/usr/bin/env bash
if grep -q '^GRUB_TIMEOUT=' /etc/default/grub; then
  sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=5/' /etc/default/grub
else
  echo 'GRUB_TIMEOUT=5' >> /etc/default/grub
fi

if [[ -f /boot/efi/EFI/rocky/grub.cfg ]]; then
  grub2-mkconfig -o /boot/efi/EFI/rocky/grub.cfg &>/dev/null
else
  grub2-mkconfig -o /boot/grub2/grub.cfg &>/dev/null
fi
