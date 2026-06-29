## Create ext4 partition and mount persistently

An extra block device is attached to the system.

Your task:

1. Create a single **{{PART_SIZE}}** partition on the extra disk.
2. Format it as **ext4**.
3. Mount it persistently at **{{MOUNT_POINT}}** using the partition UUID in `/etc/fstab`.
4. The mount options must include **noatime** (to reduce write overhead).
