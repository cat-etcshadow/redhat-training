## Allow access to NFS-mounted home directories via SELinux

Users on this system have their home directories mounted over NFS. They are able to log in but cannot access their home directories because SELinux is blocking access. Enable the SELinux boolean that permits users to access NFS-mounted home directories, persistently, while SELinux remains in **Enforcing** mode.
