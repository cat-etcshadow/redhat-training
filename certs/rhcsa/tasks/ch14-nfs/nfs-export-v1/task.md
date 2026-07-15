## Configure an NFS server export

Create the export directory **{{EXPORT_DIR}}** (including parent directories) and export it to **{{NFS_CLIENT}}** with read-write, synchronous, and no root squash options via `/etc/exports`, with the `nfs-server` service running and enabled at boot.
