## Fix fstab to use UUID instead of device path

The system has an entry in `/etc/fstab` that mounts a partition using
its device path (`/dev/sdb1`) instead of its UUID. This is fragile —
the device name can change between reboots.

Your task:

1. Locate the `/etc/fstab` entry that uses `/dev/sdb1`.
2. Find the UUID of that partition using `blkid`.
3. Update the `/etc/fstab` entry to use `UUID=<uuid>` instead of `/dev/sdb1`.
4. Verify the mount still works with `mount -a`.
