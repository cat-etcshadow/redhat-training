## Repair a broken /etc/fstab entry to restore boot

A bad `/etc/fstab` entry was added that references a non-existent device (the device or UUID does not exist on the system). On the next reboot this would drop the system into emergency mode. Remove or correct the broken entry so that `mount -a` completes without errors.
