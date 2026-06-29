## Create an LVM logical volume with ext4

Your task:

1. Identify the extra disk (the second disk in `lsblk`).
2. Create a Physical Volume on it.
3. Create Volume Group **{{VG_NAME}}** using that Physical Volume.
4. Create Logical Volume **{{LV_NAME}}** of size **{{LV_SIZE}}** within **{{VG_NAME}}**.
5. Format it as **ext4**.
6. Create mount point **{{MOUNT_POINT}}** and add a persistent `/etc/fstab` entry using UUID.
7. Mount with `mount -a` and verify with `df -h {{MOUNT_POINT}}`.
