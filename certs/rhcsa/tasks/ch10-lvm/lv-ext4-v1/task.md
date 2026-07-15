## Create an LVM logical volume with ext4

An extra **{{DISK_SIZE}}** disk is available. Create a partition for LVM use, a physical volume on it, and volume group **{{VG_NAME}}** using that physical volume. Create logical volume **{{LV_NAME}}** of size **{{LV_SIZE}}** within **{{VG_NAME}}**, format it as **ext4**, and mount it persistently at **{{MOUNT_POINT}}** using an `/etc/fstab` entry with the partition's UUID.
