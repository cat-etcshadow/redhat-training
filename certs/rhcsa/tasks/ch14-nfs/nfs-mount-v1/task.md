## Mount an NFS share persistently

An NFS server is exporting **/exports/shared** from host **nfsserver.example.com**.

Your task:

1. Install the **nfs-utils** package if not already present.
2. Create the local mount point **/mnt/nfsshare**.
3. Mount the NFS share **nfsserver.example.com:/exports/shared** at
   **/mnt/nfsshare** persistently in `/etc/fstab` with options
   `nfsvers=4,soft,timeo=30`.
4. Run `mount -a` to apply the fstab entry.

**Note**: In the exam environment the NFS server may not actually be
reachable — the grader checks the `/etc/fstab` configuration only.
