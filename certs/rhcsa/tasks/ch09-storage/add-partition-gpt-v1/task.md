## Create a GPT partition and mount it persistently

An extra **{{DISK_SIZE}}** disk is available and must be partitioned using a **GPT** partition table. Create a **{{PART_SIZE}}** partition on it, format it with **XFS**, and mount it persistently at **{{MOUNT_POINT}}** using the partition's UUID in `/etc/fstab`.
