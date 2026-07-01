## Mount an NFS share persistently with tuned options

Your task:

Add a persistent mount in `/etc/fstab` for
**{{NFS_SERVER}}:{{EXPORT_PATH}}** at **{{MOUNT_POINT}}**, with these
options:

- Read-only (`ro`)
- `noatime`
- `rsize={{RSIZE}}`
- `wsize={{WSIZE}}`
