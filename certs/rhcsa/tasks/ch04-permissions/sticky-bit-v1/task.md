## Create a shared directory with sticky bit and SGID

Your task:

1. Create group **{{SHARED_GROUP}}** if it does not already exist.
2. Create directory **{{SHARED_DIR}}** (including parent directories).
3. Set the group owner of **{{SHARED_DIR}}** to **{{SHARED_GROUP}}**.
4. Apply **SGID** so that new files created inside inherit the group **{{SHARED_GROUP}}**.
5. Apply the **sticky bit** so that only the file owner (or root) can delete files inside.
6. Set permissions so the owning group has read/write/execute access,
   and others have no access (mode `3770`).
7. Verify: `ls -ld {{SHARED_DIR}}` should show `drwxrws--T` (or `drwxrws--T`) with group `{{SHARED_GROUP}}`.
