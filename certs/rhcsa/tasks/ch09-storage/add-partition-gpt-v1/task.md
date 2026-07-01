## Create a GPT partition and mount it persistently

An extra disk is available. It must be partitioned using a **GPT** partition table.

Your task:

1. Identify the extra disk.

2. Create a **GPT partition table** on the disk (if none exists), then add a
   **{{PART_SIZE}} partition**.

3. Format the partition with **XFS**.

4. Mount the partition persistently at **{{MOUNT_POINT}}** by adding an entry
   to `/etc/fstab` using the partition's **UUID**.

5. Mount all filesystems from fstab.
