#!/usr/bin/env bash
udevadm settle
DISK=$(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1}' | sed -n '2p')
[[ -n "$DISK" ]] || { echo "ERROR: no extra disk found"; exit 1; }

# remove any existing stratis pool using this disk
stratis pool list 2>/dev/null | awk 'NR>1{print $1}' | while read -r p; do
  stratis pool destroy "$p" 2>/dev/null || true
done

for _mp in /mnt/stratis_data /mnt/stratis_apps /mnt/stratis_media /mnt/stratis_logs "${MOUNT_POINT:-}"; do
  [[ -z "$_mp" ]] && continue
  umount -f "$_mp" 2>/dev/null || true
  sed -i "\\|${_mp}|d" /etc/fstab 2>/dev/null || true
done

# clean the disk
wipefs -af "$DISK" 2>/dev/null || true
dd if=/dev/zero of="$DISK" bs=1M count=10 2>/dev/null || true

mkdir -p "$MOUNT_POINT"
