## Allow access to NFS-mounted home directories via SELinux

Users on this system have their home directories mounted over NFS.
They are able to log in but cannot access their home directories —
SELinux is blocking access.

Your task:

1. Identify and enable the SELinux boolean that permits users to access
   NFS-mounted home directories — persistently.
2. SELinux must remain in **Enforcing** mode.
