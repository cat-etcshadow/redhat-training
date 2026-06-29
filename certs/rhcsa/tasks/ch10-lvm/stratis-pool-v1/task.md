## Create a Stratis storage pool and filesystem

**Stratis** is a local storage management solution that provides thin provisioning,
snapshots, and tiering on top of XFS. It is the modern replacement for VDO on RHEL 9+.

Your task:

1. Install the Stratis packages and enable the daemon:
   ```
   dnf install -y stratisd stratis-cli
   systemctl enable --now stratisd
   ```

2. Identify the extra block device (the second disk, e.g. `/dev/vdb`).

3. Create a Stratis **pool** named **{{POOL_NAME}}** using the extra disk:
   ```
   stratis pool create {{POOL_NAME}} /dev/sdX
   ```

4. Create a Stratis **filesystem** named **{{FS_NAME}}** inside the pool:
   ```
   stratis filesystem create {{POOL_NAME}} {{FS_NAME}}
   ```

5. Create mount point **{{MOUNT_POINT}}** and mount the filesystem **persistently**
   via `/etc/fstab`:
   ```
   UUID=<stratis-fs-uuid>  {{MOUNT_POINT}}  xfs  defaults,x-systemd.requires=stratisd.service  0  0
   ```
   The `x-systemd.requires=stratisd.service` option ensures stratisd starts before
   the filesystem is mounted.

6. Run `mount -a` and verify with `stratis filesystem list`.

> Stratis filesystems appear as XFS but require stratisd to be running.
> Get the UUID with: `lsblk -o NAME,UUID /dev/stratis/<pool>/<fs>`
