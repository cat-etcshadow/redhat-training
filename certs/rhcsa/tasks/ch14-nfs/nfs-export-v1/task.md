## Configure an NFS server export

Your task:

1. Install `nfs-utils` if not already present.
2. Create the export directory **{{EXPORT_DIR}}** (including parent directories).
3. Export **{{EXPORT_DIR}}** to **{{NFS_CLIENT}}** with read-write, synchronous,
   and no root squash options via `/etc/exports`.
4. Start and enable the `nfs-server` service.
5. Apply the export configuration.
6. Verify **{{EXPORT_DIR}}** is exported to **{{NFS_CLIENT}}**.
