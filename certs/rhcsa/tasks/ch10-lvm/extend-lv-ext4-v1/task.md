## Extend a logical volume and resize the ext4 filesystem

A logical volume **{{LV_NAME}}** in volume group **{{VG_NAME}}** is already
provisioned and mounted at **{{MOUNT_POINT}}** with an **ext4** filesystem.

Your task:

1. Extend **{{LV_NAME}}** by **{{EXTEND_BY}}**.
2. Grow the ext4 filesystem to fill the new space using `resize2fs`.
3. Verify the new size with `df -h {{MOUNT_POINT}}`.
