## Unmount and remove a decommissioned NFS share

The NFS server **{{NFS_SERVER}}** has been decommissioned, but its share
is still configured in `/etc/fstab`, mounted at **{{MOUNT_POINT}}**.

Your task:

1. Unmount **{{MOUNT_POINT}}**, if mounted.
2. Remove its entry from `/etc/fstab` entirely.
3. Remove the now-unused **{{MOUNT_POINT}}** directory.
