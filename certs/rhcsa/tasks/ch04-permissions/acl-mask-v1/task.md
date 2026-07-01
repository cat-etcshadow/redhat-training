## Fix an ACL mask restricting effective permissions

The directory **{{TARGET_DIR}}** exists. The group **{{TARGET_GROUP}}**
already has a named ACL entry granting **rwx** on it, but members of the
group are reporting they cannot actually write to the directory.

Your task:

1. Inspect the ACLs on **{{TARGET_DIR}}** with `getfacl` and determine why
   the group's granted permissions are not taking effect.

2. Fix it so that **{{TARGET_GROUP}}** has full, **effective** read, write,
   and execute access to **{{TARGET_DIR}}** — without removing or changing
   the named group ACL entry itself.
