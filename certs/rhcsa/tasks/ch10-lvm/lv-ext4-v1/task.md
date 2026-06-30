## Create an LVM logical volume with ext4

Your task:

1. Identify the extra disk (the second disk in `lsblk`).
2. Create a partition for LVM use (add a new partition if the disk already has
   other partitions; use the whole disk only if it is blank).
3. Run `pvcreate` on the partition (or disk) to create a Physical Volume.
4. Create Volume Group **{{VG_NAME}}** using that Physical Volume.
5. Create Logical Volume **{{LV_NAME}}** of size **{{LV_SIZE}}** within **{{VG_NAME}}**.
6. Format it as **ext4**.
7. Create mount point **{{MOUNT_POINT}}** and add a persistent `/etc/fstab` entry using UUID.
8. Mount with `mount -a` and verify with `df -h {{MOUNT_POINT}}`.

> **Lab note:** In a full exam the extra disk is shared with other storage tasks.
> Add a new partition in the remaining free space for the PV rather than using
> the whole disk, which would destroy existing partition data.
