## Configure a user-mountable filesystem with noauto

An additional block device is attached to the system with a single **ext4**
partition already formatted on it. The user **{{TEST_USER}}** already
exists.

Your task:

Configure **{{MOUNT_POINT}}** in `/etc/fstab` so that:

1. The filesystem does **not** mount automatically at boot.
2. The regular user **{{TEST_USER}}** can mount and unmount it manually,
   using plain `mount {{MOUNT_POINT}}` / `umount {{MOUNT_POINT}}`, **without**
   `sudo` or root privileges.
