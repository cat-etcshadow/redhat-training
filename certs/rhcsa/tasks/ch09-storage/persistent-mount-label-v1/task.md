## Create XFS partition with label and mount by LABEL

Your task:

1. Identify the extra disk (the second disk in `lsblk`).
2. Add a **{{PART_SIZE}} partition** on it (create a GPT partition table first if the disk is blank).
3. Format it as **XFS** with the label **{{FS_LABEL}}**.
4. Create mount point **{{MOUNT_POINT}}**.
5. Add a persistent entry to `/etc/fstab` using the **LABEL** (not UUID or device path).
6. Mount all entries with `mount -a` and verify the filesystem is mounted at **{{MOUNT_POINT}}**.

> **Lab note:** In a full exam the extra disk is shared across storage and LVM
> tasks. If another partition already exists, add this partition in the remaining
> free space — do not wipe the existing partition table.
