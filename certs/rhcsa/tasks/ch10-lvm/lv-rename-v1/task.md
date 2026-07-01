## Rename a logical volume and fix its fstab reference

The logical volume **{{OLD_LV_NAME}}** (in volume group **{{VG_NAME}}**) is
mounted at **{{MOUNT_POINT}}**, and `/etc/fstab` currently references it by
its **device path**.

Your task:

1. Rename **{{OLD_LV_NAME}}** to **{{NEW_LV_NAME}}**, without losing any
   data on it.

2. Update any references so that **{{MOUNT_POINT}}** still mounts correctly
   using the new name.
