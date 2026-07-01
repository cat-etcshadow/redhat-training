## Create XFS partition and mount persistently

An additional block device is attached to the system.

Your task:

1. Identify the unpartitioned disk.
2. Create a single **{{PART_SIZE}}** primary partition on it.
3. Format the partition with the **XFS** filesystem.
4. Create the directory **{{MOUNT_POINT}}** if it does not already exist.
5. Mount the partition persistently at **{{MOUNT_POINT}}** using its **UUID**
   in `/etc/fstab`.
6. Mount all entries in `/etc/fstab` and verify the partition is mounted.
