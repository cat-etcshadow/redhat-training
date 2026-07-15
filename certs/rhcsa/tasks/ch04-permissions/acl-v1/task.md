## Set ACL entries on a directory

The directory **/var/data/reports** already exists on the system. Configure ACLs so that the user **auditor** has read and execute permission on the directory but cannot write to it, the group **contractors** has no access to the directory, and default ACLs are set so that any new files or subdirectories created inside **/var/data/reports** automatically inherit both rules. The standard Unix permissions on the directory must remain unchanged.
