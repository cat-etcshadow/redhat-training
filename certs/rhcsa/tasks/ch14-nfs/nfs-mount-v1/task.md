## Mount an NFS share persistently

An NFS server is exporting **/exports/shared** from host **nfsserver.example.com**. Create the local mount point **/mnt/nfsshare** and mount **nfsserver.example.com:/exports/shared** there persistently in `/etc/fstab` with options `nfsvers=4,soft,timeo=30`, active without requiring a reboot.
