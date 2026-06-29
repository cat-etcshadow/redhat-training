## Hint

- `lsblk` identifies available disks; the second disk is not the OS disk
- `parted /dev/sdX print` shows current partition table type
- `parted /dev/sdX mklabel gpt` creates a GPT partition table
- `parted /dev/sdX mkpart primary xfs 1MiB 100%` creates one partition using all space
- `gdisk /dev/sdX` is an interactive GPT-specific tool (n=new, w=write)
- After partitioning: `partprobe /dev/sdX` or `udevadm settle` to update kernel
- `mkfs.xfs /dev/sdX1` formats with XFS
- `blkid /dev/sdX1` shows the UUID; use it in `/etc/fstab`
