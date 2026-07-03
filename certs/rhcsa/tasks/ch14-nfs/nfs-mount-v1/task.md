## Mount an NFS share persistently

An NFS server is exporting **/exports/shared** from host **nfsserver.example.com**.

Your task:

1. Create the local mount point **/mnt/nfsshare**.
2. Mount the NFS share **nfsserver.example.com:/exports/shared** at
   **/mnt/nfsshare** persistently in `/etc/fstab` with options
   `nfsvers=4,soft,timeo=30`.
3. The share must be mounted and active without requiring a reboot.
