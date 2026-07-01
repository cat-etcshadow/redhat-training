## Create a Stratis storage pool and filesystem

Your task:

1. Install the Stratis packages and enable the daemon.

2. Identify the extra block device.

3. Create a Stratis **pool** named **{{POOL_NAME}}** using the extra disk.

4. Create a Stratis **filesystem** named **{{FS_NAME}}** inside the pool.

5. Create mount point **{{MOUNT_POINT}}** and mount the filesystem **persistently**
   via `/etc/fstab` using the filesystem's UUID.

6. Mount all entries in `/etc/fstab`.
