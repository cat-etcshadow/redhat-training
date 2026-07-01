## Fix fstab to use UUID instead of device path

The system has an entry in `/etc/fstab` that mounts a partition using
its device path (`/dev/sdb1`) instead of its UUID.

Your task:

1. Locate the `/etc/fstab` entry that uses `/dev/sdb1`.
2. Find the UUID of that partition.
3. Update the `/etc/fstab` entry to use `UUID=<uuid>` instead of `/dev/sdb1`.
4. The entry must still mount successfully.
