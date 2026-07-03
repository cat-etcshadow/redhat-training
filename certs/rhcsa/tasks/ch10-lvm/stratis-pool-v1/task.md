## Create a Stratis storage pool and filesystem

An extra **{{DISK_SIZE}}** block device is attached to the system.

Your task:

1. Identify the extra block device.

2. Create a Stratis **pool** named **{{POOL_NAME}}** using the extra disk.

3. Create a Stratis **filesystem** named **{{FS_NAME}}** inside the pool.

4. Create mount point **{{MOUNT_POINT}}** and mount the filesystem **persistently**
   via `/etc/fstab` using the filesystem's UUID.

5. The filesystem must be mounted at **{{MOUNT_POINT}}** without requiring a reboot.
