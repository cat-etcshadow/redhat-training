## Create ext4 partition and mount persistently

An extra **{{DISK_SIZE}}** block device is attached to the system. Create a single **{{PART_SIZE}}** partition on it, format it as **ext4**, and mount it persistently at **{{MOUNT_POINT}}** using the partition's UUID in `/etc/fstab`, with mount options that include **noatime**.
