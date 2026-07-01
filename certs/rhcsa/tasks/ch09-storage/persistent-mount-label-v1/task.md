## Create XFS partition with label and mount by LABEL

Your task:

1. Identify the extra disk.
2. Add a **{{PART_SIZE}} partition** on it.
3. Format it as **XFS** with the label **{{FS_LABEL}}**.
4. Create mount point **{{MOUNT_POINT}}**.
5. Add a persistent entry to `/etc/fstab` using the **LABEL** (not UUID or device path).
6. Mount all entries with `mount -a` and verify the filesystem is mounted at **{{MOUNT_POINT}}**.
