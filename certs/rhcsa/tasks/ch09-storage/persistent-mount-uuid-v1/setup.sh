#!/usr/bin/env bash
udevadm settle
DISK=$(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1}' | sed -n '2p')
[[ -n "$DISK" ]] || { echo "ERROR: no extra disk found"; exit 1; }
for _p in "${DISK}"?*; do umount -f "$_p" 2>/dev/null || true; swapoff "$_p" 2>/dev/null || true; done
pvs --noheadings -o vg_name "$DISK" 2>/dev/null | awk '{print $1}' | while read -r _vg; do
  [[ -n "$_vg" ]] && { for _lv in /dev/"$_vg"/*; do umount -f "$_lv" 2>/dev/null || true; done; vgremove -y "$_vg" 2>/dev/null || true; }
done
for _mp in /mnt/fixme /mnt/backup /mnt/data /mnt/app /mnt/storage; do sed -i "\\|${_mp}|d" /etc/fstab; done
sed -i "\\|${DISK}|d" /etc/fstab
pvremove -ff -y "$DISK" 2>/dev/null || true
wipefs -af "$DISK" 2>/dev/null || true
dd if=/dev/zero of="$DISK" bs=1M count=10 2>/dev/null || true
PART="${DISK}1"
echo -e "n\np\n1\n\n+500M\nw" | fdisk "$DISK" &>/dev/null
partprobe "$DISK"
mkfs.xfs -f "$PART" &>/dev/null
mkdir -p /mnt/fixme
# Add entry using device path (the bad way)
sed -i '/\/mnt\/fixme/d' /etc/fstab
echo "$PART  /mnt/fixme  xfs  defaults  0 0" >> /etc/fstab
mount -a
