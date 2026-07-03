## Remove a decommissioned logical volume

The volume group **{{VG_NAME}}** contains two logical volumes:

- **{{LV_KEEP}}**, mounted at **{{MOUNT_KEEP}}**, which is still in use.
- **{{LV_REMOVE}}**, mounted at **{{MOUNT_REMOVE}}**, which has been
  decommissioned and must be removed.

Your task:

1. Unmount **{{MOUNT_REMOVE}}** and remove its entry from `/etc/fstab`.
2. Remove the logical volume **{{LV_REMOVE}}** from **{{VG_NAME}}**.
3. **{{LV_KEEP}}** must remain untouched — still mounted at
   **{{MOUNT_KEEP}}**, with its data intact.
