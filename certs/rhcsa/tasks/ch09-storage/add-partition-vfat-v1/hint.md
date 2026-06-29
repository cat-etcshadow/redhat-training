## Hint

- `mkfs.vfat -F 32 /dev/sdX1` — format as FAT32 (requires `dosfstools` package)
- `fdisk /dev/sdX` then `t` → `b` sets partition type to FAT32 (type 0x0b)
- `parted /dev/sdX mkpart primary fat32 1MiB 100%` also works
- `/etc/fstab` entry: `UUID=<uuid>  /mnt/point  vfat  defaults  0  0`
- vfat does not support fsck pass numbering — use `0 0` for the last two fields
- `blkid /dev/sdX1` shows UUID and type confirmation
