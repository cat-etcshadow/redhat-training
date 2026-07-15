## Grow a partition and its XFS filesystem online

An additional block device is attached to the system. It has a single **1 GiB** XFS partition mounted persistently at **{{MOUNT_POINT}}**, but the disk itself is larger (**{{DISK_SIZE}}** total) — there is unallocated space after the partition. Grow the partition to use all remaining free space on the disk and grow the XFS filesystem to match the new partition size, doing this online — without unmounting **{{MOUNT_POINT}}** and without any data loss.
