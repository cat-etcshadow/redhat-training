## Hint

- `lsblk` shows attached disks; the extra disk is not `sda`
- `fdisk /dev/sdb` → `n` (new) → `p` (primary) → accept defaults for 1 GiB → `w`
- `mkfs.xfs /dev/sdb1` formats the partition
- `blkid /dev/sdb1` shows the UUID
- In `/etc/fstab`: `UUID=<uuid>  /mnt/data  xfs  defaults  0 0`
- `mount -a` mounts all fstab entries; `df -h /mnt/data` confirms
