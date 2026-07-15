## Configure a user-mountable filesystem with noauto

An additional **{{DISK_SIZE}}** block device is attached to the system with a single **ext4** partition already formatted on it. The user **{{TEST_USER}}** already exists. Configure **{{MOUNT_POINT}}** in `/etc/fstab` so that the filesystem does not mount automatically at boot, and so that the regular user **{{TEST_USER}}** can mount and unmount it manually — using plain `mount {{MOUNT_POINT}}` / `umount {{MOUNT_POINT}}` — without `sudo` or root privileges.
