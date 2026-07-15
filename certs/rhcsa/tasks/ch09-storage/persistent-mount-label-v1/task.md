## Create XFS partition with label and mount by LABEL

An extra **{{DISK_SIZE}}** disk is available. Add a **{{PART_SIZE}}** partition on it, format it as **XFS** with the label **{{FS_LABEL}}**, and mount it persistently at **{{MOUNT_POINT}}** using an `/etc/fstab` entry that references the **LABEL** (not UUID or device path), without requiring a reboot.
