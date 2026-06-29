## Create a GPT partition and mount it persistently

An extra disk is available (find it with `lsblk`). It must be partitioned using
a **GPT** partition table (not MBR/DOS).

Your task:

1. Identify the extra disk (it will be the second disk, not the OS disk).

2. Create a **GPT partition table** and a single partition of **{{PART_SIZE}}**
   using `parted` (or `gdisk`):
   ```
   parted /dev/sdX --script mklabel gpt
   parted /dev/sdX --script mkpart primary xfs 1MiB {{PART_SIZE}}
   ```
   Or with `gdisk` interactively.

3. Format the partition with **XFS**:
   ```
   mkfs.xfs /dev/sdX1
   ```

4. Mount the partition persistently at **{{MOUNT_POINT}}** by adding an entry
   to `/etc/fstab` using the partition's **UUID**:
   ```
   UUID=<uuid>  {{MOUNT_POINT}}  xfs  defaults  0  2
   ```

5. Mount all filesystems from fstab and verify:
   ```
   mount -a
   df -h {{MOUNT_POINT}}
   ```

> Key difference from MBR: GPT supports disks > 2 TiB and up to 128 partitions.
> Use `parted` or `gdisk` (from `gdisk` package) instead of `fdisk` for GPT.
