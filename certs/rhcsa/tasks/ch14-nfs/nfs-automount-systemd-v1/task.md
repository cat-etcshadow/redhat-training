## Configure an NFS share to mount on demand with systemd automount

Your task:

Add a persistent entry in `/etc/fstab` for
**{{NFS_SERVER}}:{{EXPORT_PATH}}** at **{{MOUNT_POINT}}**, configured so
that it is **not** mounted at boot but instead mounts automatically **on
first access**, using systemd automount mount options.
