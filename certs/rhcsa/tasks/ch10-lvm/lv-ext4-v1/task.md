## Create an LVM logical volume with ext4

Your task:

1. Identify the extra disk.
2. Create a partition for LVM use.
3. Create a Physical Volume on the partition.
4. Create Volume Group **{{VG_NAME}}** using that Physical Volume.
5. Create Logical Volume **{{LV_NAME}}** of size **{{LV_SIZE}}** within **{{VG_NAME}}**.
6. Format it as **ext4**.
7. Create mount point **{{MOUNT_POINT}}** and add a persistent `/etc/fstab` entry using UUID.
8. Mount all entries in `/etc/fstab`.
