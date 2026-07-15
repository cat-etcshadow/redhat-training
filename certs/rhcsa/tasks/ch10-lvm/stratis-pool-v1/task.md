## Create a Stratis storage pool and filesystem

An extra **{{DISK_SIZE}}** block device is attached to the system. Create a Stratis pool named **{{POOL_NAME}}** using the disk, and a Stratis filesystem named **{{FS_NAME}}** inside the pool. Mount the filesystem persistently at **{{MOUNT_POINT}}** via `/etc/fstab` using its UUID, without requiring a reboot.
