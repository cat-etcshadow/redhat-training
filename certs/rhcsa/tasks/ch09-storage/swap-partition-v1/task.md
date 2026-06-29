## Create a swap partition and activate persistently

Your task:

1. Identify the unpartitioned extra disk on the system.
2. Create a **512 MiB** partition and set its type to **Linux swap**.
3. Format the partition as swap with `mkswap`.
4. Activate the swap partition immediately with `swapon`.
5. Make the swap persistent across reboots by adding it to `/etc/fstab`
   using the partition **UUID**.
