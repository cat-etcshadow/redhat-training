## Mount an NFS share persistently with tuned options

Add a persistent mount in `/etc/fstab` for **{{NFS_SERVER}}:{{EXPORT_PATH}}** at **{{MOUNT_POINT}}**, with options `ro`, `noatime`, `rsize={{RSIZE}}`, and `wsize={{WSIZE}}`.
