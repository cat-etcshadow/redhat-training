## Mount a filesystem persistently with hardened mount options

An additional **{{DISK_SIZE}}** block device is attached to the system with a single **ext4** partition already created and formatted on it. Mount the partition persistently at **{{MOUNT_POINT}}** in `/etc/fstab`, with the mount options **{{REQUIRED_OPTS}}** in addition to `defaults`.
