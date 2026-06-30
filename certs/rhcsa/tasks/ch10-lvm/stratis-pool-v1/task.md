## Create a Stratis storage pool and filesystem

**Stratis** is a local storage management solution that provides thin provisioning,
snapshots, and tiering on top of XFS. It is the modern replacement for VDO on RHEL 9+.

Your task:

1. Install the Stratis packages and enable the daemon.

2. Identify the extra block device (the second disk, e.g. `/dev/vdb`).

3. Create a Stratis **pool** named **{{POOL_NAME}}** using the extra disk.

4. Create a Stratis **filesystem** named **{{FS_NAME}}** inside the pool.

5. Create mount point **{{MOUNT_POINT}}** and mount the filesystem **persistently**
   via `/etc/fstab` using the filesystem's UUID.

6. Run `mount -a` and verify with `stratis filesystem list`.
