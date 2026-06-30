## Create a GPT partition and mount it persistently

An extra disk is available (find it with `lsblk`). It must be partitioned using
a **GPT** partition table (not MBR/DOS).

Your task:

1. Identify the extra disk (it will be the second disk, not the OS disk).

2. Create a **GPT partition table** on the disk (if none exists), then add a
   **{{PART_SIZE}} partition** using `parted` or `gdisk`.

3. Format the partition with **XFS**.

4. Mount the partition persistently at **{{MOUNT_POINT}}** by adding an entry
   to `/etc/fstab` using the partition's **UUID**.

5. Mount all filesystems from fstab and verify with `df -h {{MOUNT_POINT}}`.

> **Lab note:** In a full exam the extra disk is shared across storage and LVM
> tasks. If the disk already has a partition table, add a new partition in the
> free space rather than recreating the table.
