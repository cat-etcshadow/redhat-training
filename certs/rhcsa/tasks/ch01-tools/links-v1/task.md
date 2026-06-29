## Create hard links and symbolic links

The file **{{TARGET_FILE}}** exists on the system.

Your task:

1. Create a **hard link** at **{{HARD_LINK}}** pointing to **{{TARGET_FILE}}**.
2. Create a **symbolic (soft) link** at **{{SOFT_LINK}}** pointing to **{{SOFT_TARGET}}**.
3. Verify:
   - `ls -li {{TARGET_FILE}} {{HARD_LINK}}` — both must show **the same inode number**
   - `ls -la {{SOFT_LINK}}` — must show it is a symlink (`l` in permissions) pointing to **{{SOFT_TARGET}}**
   - Writing to **{{HARD_LINK}}** must also be visible in **{{TARGET_FILE}}** (they share data)

Key difference:
- Hard link: same inode, survives deletion of the original name
- Symbolic link: a pointer to a path, breaks if the target is removed
