## Create a vfat (FAT32) partition and mount it persistently

An extra disk is available. Create a vfat partition for compatibility with
Windows systems and USB media.

Your task:

1. Identify the extra disk with `lsblk`.

2. Create a partition using `fdisk` (MBR) or `parted`:
   ```
   fdisk /dev/sdX
   # press: n (new), p (primary), 1 (number), Enter (default start), +500M (size), t (type), b (FAT32), w (write)
   ```

3. Format the partition as **vfat (FAT32)**:
   ```
   mkfs.vfat -F 32 /dev/sdX1
   ```

4. Create mount point **{{MOUNT_POINT}}** and add a **persistent** entry in
   `/etc/fstab` using the partition's UUID:
   ```
   UUID=<uuid>  {{MOUNT_POINT}}  vfat  defaults  0  0
   ```
   Note: vfat does not support fsck natively, so the last two fields are `0 0`.

5. Run `mount -a` and verify with `df -h {{MOUNT_POINT}}`.

> vfat (FAT32) is cross-platform: readable and writable by Linux, Windows, and macOS.
> It does not support Unix permissions, symlinks, or files > 4 GiB.
