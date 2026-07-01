## Grow a partition and its XFS filesystem online

An additional block device is attached to the system. It has a single
**1 GiB** XFS partition mounted persistently at **{{MOUNT_POINT}}**, but the
disk itself is larger — there is unallocated space after the partition.

Your task:

1. Grow the partition to use **all remaining free space** on the disk.
2. Grow the **XFS** filesystem to match the new partition size.
3. Do this **online** — without unmounting **{{MOUNT_POINT}}** and without
   any data loss.
