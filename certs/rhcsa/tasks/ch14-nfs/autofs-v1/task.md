## Configure autofs to automount an NFS share

Configure autofs to automatically mount an NFS home directory when a
user accesses it.

Your task:

1. Configure autofs to auto-mount **nfsserver.example.com:/exports/homes/&**
   under **/home/remotes/** using a wildcard map.
2. Create the master map entry in `/etc/auto.master.d/homes.autofs`.
3. Create the indirect map at `/etc/auto.homes` with read-write NFSv4 options.
4. The **autofs** service must be running and enabled at boot.
