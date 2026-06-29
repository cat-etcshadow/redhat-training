## Create a volume group and logical volume with XFS filesystem

An additional block device is attached to the system.

Your task:

1. Create a physical volume (PV) on the extra disk.
2. Create a volume group named **{{VG_NAME}}** using that PV.
3. Create a logical volume named **{{LV_NAME}}** of size **{{LV_SIZE}}**
   within **{{VG_NAME}}**.
4. Format **{{LV_NAME}}** with XFS.
5. Mount it persistently at **{{MOUNT_POINT}}** using its UUID in `/etc/fstab`.
