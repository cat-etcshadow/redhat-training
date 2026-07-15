## Rename a logical volume and fix its fstab reference

The logical volume **{{OLD_LV_NAME}}** (in volume group **{{VG_NAME}}**) is mounted at **{{MOUNT_POINT}}**, and `/etc/fstab` currently references it by its device path. Rename **{{OLD_LV_NAME}}** to **{{NEW_LV_NAME}}** without losing any data on it, and update `/etc/fstab` so **{{MOUNT_POINT}}** still mounts correctly under the new name.
