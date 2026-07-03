## Remove a named ACL entry from a directory

The directory **{{TARGET_DIR}}** currently has ACL entries granting **rwx**
access to both the user **{{TARGET_USER}}** and the group
**{{TARGET_GROUP}}**.

Your task:

1. Remove the ACL entry for user **{{TARGET_USER}}** from
   **{{TARGET_DIR}}** entirely, so they no longer appear in its ACL.
2. The ACL entry for group **{{TARGET_GROUP}}** must remain unchanged
   (**rwx**).
