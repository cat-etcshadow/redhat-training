## Configure an NFS server export

Your task:

1. Create the export directory **{{EXPORT_DIR}}** (including parent directories).
2. Export **{{EXPORT_DIR}}** to **{{NFS_CLIENT}}** with read-write, synchronous,
   and no root squash options via `/etc/exports`.
3. The `nfs-server` service must be running and enabled at boot.
4. **{{EXPORT_DIR}}** must be exported to **{{NFS_CLIENT}}**.
