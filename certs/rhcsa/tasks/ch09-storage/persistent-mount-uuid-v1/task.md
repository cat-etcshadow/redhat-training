## Fix fstab to use UUID instead of device path

The system has an entry in `/etc/fstab` that mounts a partition using its device path (e.g. `/dev/sdX1`) instead of its UUID. Update the `/etc/fstab` entry to use the partition's UUID instead, and the entry must still mount successfully.
