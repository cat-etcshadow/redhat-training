## Extend a logical volume to use all remaining free space

A logical volume **{{LV_NAME}}** in volume group **{{VG_NAME}}** is provisioned and mounted at **{{MOUNT_POINT}}** with an **XFS** filesystem, but most of the volume group's space was left unallocated. Extend **{{LV_NAME}}** to use all remaining free space in **{{VG_NAME}}**, and grow the XFS filesystem on **{{MOUNT_POINT}}** to use the new space online.
