#!/usr/bin/env bash
# grub-serial-console.sh — make the GRUB menu reachable over `incus console`
#
# Runs inside the RHCSA VM (via vm_exec_script) during topology_create, once
# per VM, before any task setups run. Idempotent.
#
# The Rocky cloud image ships /etc/default/grub with GRUB_TERMINAL_OUTPUT
# set to "gfxterm" only and GRUB_TERMINAL_INPUT set to "console" only —
# no serial terminal at all. `incus console` (the default, client-free
# console type) attaches to the VM's serial device, so ch11-boot tasks that
# require interrupting GRUB, editing a boot entry, or reaching an emergency/
# rescue shell (reset-root-password-v1, repair-fstab-v1, grub-param-v1, ...)
# would show a blank screen through the whole menu and initramfs prompt —
# the console only comes alive once the kernel itself takes over ttyS0.
#
# Fix: add "serial" alongside the existing terminal values (keeps gfxterm/
# console working too, in case anyone views the VM over `incus console
# --type=vga` instead) and point GRUB_SERIAL_COMMAND at the same UART the
# kernel already uses (GRUB_CMDLINE_LINUX_DEFAULT has console=ttyS0,115200n8
# baked in by the image), then regenerate /boot/grub2/grub.cfg — the file
# grub-timeout-v1's grader already treats as canonical (EFI's grub.cfg is
# just a two-line chainload into this one).
set -uo pipefail

conf=/etc/default/grub
changed=0

if ! grep -q '^GRUB_TERMINAL_INPUT=.*serial' "$conf"; then
  sed -i 's/^GRUB_TERMINAL_INPUT="\(.*\)"/GRUB_TERMINAL_INPUT="\1 serial"/' "$conf"
  changed=1
fi

if ! grep -q '^GRUB_TERMINAL_OUTPUT=.*serial' "$conf"; then
  sed -i 's/^GRUB_TERMINAL_OUTPUT="\(.*\)"/GRUB_TERMINAL_OUTPUT="\1 serial"/' "$conf"
  changed=1
fi

if ! grep -q '^GRUB_SERIAL_COMMAND=' "$conf"; then
  echo 'GRUB_SERIAL_COMMAND="serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1"' >> "$conf"
  changed=1
fi

if [[ $changed -eq 1 ]]; then
  grub2-mkconfig -o /boot/grub2/grub.cfg &>/dev/null
  echo "grub-serial-console: serial terminal added, grub.cfg regenerated"
else
  echo "grub-serial-console: already configured"
fi
