## Create a vfat (FAT32) partition and mount it persistently

An extra disk is available. Create a vfat partition for compatibility with
Windows systems and USB media.

Your task:

1. Identify the extra disk with `lsblk`.

2. Create a partition using `fdisk` (MBR) or `parted`.

3. Format the partition as **vfat (FAT32)**.

4. Create mount point **{{MOUNT_POINT}}** and add a **persistent** entry in
   `/etc/fstab` using the partition's UUID.

5. Run `mount -a` and verify with `df -h {{MOUNT_POINT}}`.
