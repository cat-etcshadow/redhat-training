## Extend a logical volume and resize the filesystem

A logical volume **{{LV_NAME}}** in volume group **{{VG_NAME}}** is already
provisioned and mounted at **{{MOUNT_POINT}}** with an XFS filesystem.
The application needs more space.

Your task:

1. Extend **{{LV_NAME}}** by **{{EXTEND_BY}}**.
2. Grow the XFS filesystem on **{{MOUNT_POINT}}** to use the new space online
   (no unmount required for XFS).
3. Verify the new size with `df -h {{MOUNT_POINT}}`.
