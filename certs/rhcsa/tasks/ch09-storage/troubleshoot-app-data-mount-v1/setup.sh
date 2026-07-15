#!/usr/bin/env bash
udevadm settle
DISK=$(lsblk -dpbno NAME,TYPE,SIZE | awk -v want="$TASK_DISK_SIZE_GB" '$2=="disk"{gib=int(($3+536870912)/1073741824); if (gib==want) print $1}')
[[ -n "$DISK" ]] || { echo "ERROR: no extra disk found"; exit 1; }
for _p in "${DISK}"?*; do umount -f "$_p" 2>/dev/null || true; swapoff "$_p" 2>/dev/null || true; done
pvs --noheadings -o vg_name "$DISK" 2>/dev/null | awk '{print $1}' | while read -r _vg; do
  [[ -n "$_vg" ]] && { for _lv in /dev/"$_vg"/*; do umount -f "$_lv" 2>/dev/null || true; done; vgremove -y "$_vg" 2>/dev/null || true; }
done
for _mp in /mnt/fixme /mnt/backup /mnt/data /mnt/app /mnt/storage /mnt/appdata; do
  umount -f "$_mp" 2>/dev/null || true
  sed -i "\\|${_mp}|d" /etc/fstab 2>/dev/null || true
done
sed -i "\\|${DISK}|d" /etc/fstab
pvremove -ff -y "$DISK" 2>/dev/null || true
wipefs -af "$DISK" 2>/dev/null || true
dd if=/dev/zero of="$DISK" bs=1M count=10 2>/dev/null || true
udevadm settle

PART="${DISK}1"
echo -e "n\np\n1\n\n+1G\nw" | fdisk "$DISK" &>/dev/null
partprobe "$DISK"
mkfs.xfs -f "$PART" &>/dev/null
mkdir -p /mnt/appdata

# fstab entry deliberately declares the wrong filesystem type, with nofail so boot still succeeds
echo "$PART  /mnt/appdata  ext4  defaults,nofail  0 0" >> /etc/fstab
systemctl daemon-reload
