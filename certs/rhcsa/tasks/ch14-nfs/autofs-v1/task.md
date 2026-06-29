## Configure autofs to automount an NFS share

Configure autofs to automatically mount an NFS home directory when a
user accesses it.

Your task:

1. Install **autofs** if not present.
2. Configure autofs to auto-mount **nfsserver.example.com:/exports/homes/&**
   under **/home/remotes/** using a wildcard map.
3. Create the master map entry in `/etc/auto.master.d/homes.autofs`.
4. Create the indirect map at `/etc/auto.homes` with read-write NFSv4 options.
5. Enable and start the **autofs** service.
