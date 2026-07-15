## Create a swap partition and activate persistently

An unpartitioned **{{DISK_SIZE}}** disk is available. Create a **512 MiB** partition and set its type to **Linux swap**, format it as swap, and activate it immediately. Make it persistent across reboots by adding it to `/etc/fstab` using the partition's UUID.
