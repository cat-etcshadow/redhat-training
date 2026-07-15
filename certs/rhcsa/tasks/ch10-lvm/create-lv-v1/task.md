## Create a volume group and logical volume with XFS filesystem

An additional **{{DISK_SIZE}}** block device is attached to the system. Create a physical volume on the disk, a volume group named **{{VG_NAME}}** using that physical volume, and a logical volume named **{{LV_NAME}}** of size **{{LV_SIZE}}** within **{{VG_NAME}}**. Format **{{LV_NAME}}** with XFS and mount it persistently at **{{MOUNT_POINT}}** using its UUID in `/etc/fstab`.
