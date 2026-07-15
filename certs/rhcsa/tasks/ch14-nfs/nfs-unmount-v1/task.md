## Unmount and remove a decommissioned NFS share

The NFS server **{{NFS_SERVER}}** has been decommissioned, but its share is still configured in `/etc/fstab`, mounted at **{{MOUNT_POINT}}**. Unmount **{{MOUNT_POINT}}**, remove its entry from `/etc/fstab` entirely, and remove the now-unused **{{MOUNT_POINT}}** directory.
