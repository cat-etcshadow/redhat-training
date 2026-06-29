## Set ACL entries on a directory

The directory **/var/data/reports** already exists on the system.

Configure Access Control Lists (ACLs) on **/var/data/reports** so that:

1. The user **auditor** (already exists) has **read and execute** permission
   on the directory, but **cannot write** to it.

2. The group **contractors** (already exists) has **no access** to the directory.

3. Any new files or subdirectories created inside **/var/data/reports**
   automatically inherit rule 1 and rule 2 (use **default ACLs**).

Do not change the standard Unix permissions on the directory.
