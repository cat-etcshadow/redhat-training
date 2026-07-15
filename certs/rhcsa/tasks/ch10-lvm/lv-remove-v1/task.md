## Remove a decommissioned logical volume

The volume group **{{VG_NAME}}** contains two logical volumes: **{{LV_KEEP}}**, mounted at **{{MOUNT_KEEP}}**, which is still in use, and **{{LV_REMOVE}}**, mounted at **{{MOUNT_REMOVE}}**, which has been decommissioned. Unmount **{{MOUNT_REMOVE}}**, remove its entry from `/etc/fstab`, and remove the logical volume **{{LV_REMOVE}}** from **{{VG_NAME}}**, while leaving **{{LV_KEEP}}** untouched — still mounted at **{{MOUNT_KEEP}}**, with its data intact.
