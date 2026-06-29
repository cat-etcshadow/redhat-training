## Hint

```bash
# Identify extra disk
lsblk
# Create PV
pvcreate /dev/sdb
# Create VG
vgcreate vg_data /dev/sdb
# Create LV
lvcreate -L 500M -n lv_storage vg_data
# Format
mkfs.xfs /dev/vg_data/lv_storage
# Mount + fstab
mkdir -p /mnt/storage
blkid /dev/vg_data/lv_storage   # get UUID
echo "UUID=...  /mnt/storage  xfs  defaults  0 0" >> /etc/fstab
mount -a
```
