## Configure a direct autofs map

Configure a direct map in **/etc/auto.master.d/direct.autofs**, referencing **/etc/auto.direct**, so that **{{MOUNT_PATH}}** automatically mounts **{{NFS_SERVER}}:{{EXPORT_PATH}}** on access, with the `autofs` service enabled and started.
