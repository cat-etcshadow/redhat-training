## Repair a broken /etc/fstab entry to restore boot

A bad `/etc/fstab` entry was added that references a non-existent device.
On the next reboot this would drop the system into emergency mode.

Your task:

1. Identify the broken `/etc/fstab` entry (device or UUID does not exist
   on the system).
2. Remove or correct it so that `mount -a` completes without errors.

Do not disable `systemd-fstab-generator` or comment out all of `/etc/fstab`.
Fix only the broken entry.
