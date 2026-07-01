## Mount a filesystem persistently with hardened mount options

An additional block device is attached to the system with a single
**ext4** partition already created and formatted on it.

Your task:

1. Create the directory **{{MOUNT_POINT}}** if it does not already exist.
2. Mount the partition persistently at **{{MOUNT_POINT}}** in `/etc/fstab`,
   with the mount options: **{{REQUIRED_OPTS}}** (in addition to `defaults`).
3. Mount all entries in `/etc/fstab` and verify the options took effect.
