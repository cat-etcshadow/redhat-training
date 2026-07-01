## Configure a direct autofs map

Unlike an indirect map, a **direct** autofs map mounts at an absolute path
that is used directly as the map key — not under a common parent directory.

Your task:

1. Configure a direct map in **/etc/auto.master.d/direct.autofs**,
   referencing **/etc/auto.direct**.

2. In **/etc/auto.direct**, configure **{{MOUNT_PATH}}** to automatically
   mount **{{NFS_SERVER}}:{{EXPORT_PATH}}** on access.

3. Enable and start the `autofs` service.
