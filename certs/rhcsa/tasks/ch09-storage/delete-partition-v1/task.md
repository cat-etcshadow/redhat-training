## Delete an unused partition

An extra **{{DISK_SIZE}}** disk is attached to the system. It currently
has two partitions:

- The **first** partition (200 MiB) was created by mistake and is not
  used by anything.
- The **second** partition is formatted **ext4** and mounted persistently
  at **{{MOUNT_POINT}}**.

Your task:

1. Delete the first, unused partition from the disk.
2. The second partition must remain untouched — still mounted at
   **{{MOUNT_POINT}}**, with its data intact.
