## Configure autofs to automount an NFS share

Configure autofs to automatically mount an NFS home directory when a user accesses it: auto-mount **nfsserver.example.com:/exports/homes/&** under **/home/remotes/** using a wildcard map, with the master map entry in `/etc/auto.master.d/homes.autofs` and the indirect map at `/etc/auto.homes` using read-write NFSv4 options, with the `autofs` service running and enabled at boot.
