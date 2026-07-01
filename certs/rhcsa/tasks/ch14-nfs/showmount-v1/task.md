## Discover and mount an NFS export with showmount

An NFS server is running on this system (**localhost**), exporting a share,
but its exact export path is not documented.

Your task:

1. Use `showmount -e localhost` to list the available exports, and save
   the output to **{{REPORT_FILE}}**.

2. Mount the discovered export at **{{MOUNT_POINT}}** (a one-time mount —
   it does not need to be persistent).
