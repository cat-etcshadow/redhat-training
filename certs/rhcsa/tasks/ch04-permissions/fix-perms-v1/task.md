## Diagnose and correct broken file permissions

A junior admin has misconfigured the web document root at **{{WEB_ROOT}}**.
The web server cannot serve files and users in group **{{WEB_GROUP}}** cannot
manage content. Fix the permissions.

**Required final state:**

| Object | Owner | Group | Mode |
|--------|-------|-------|------|
| **{{WEB_ROOT}}** (dir) | root | {{WEB_GROUP}} | `2775` (SGID + rwxrwsr-x) |
| All **files** inside | root | {{WEB_GROUP}} | `0664` |
| All **subdirs** inside | root | {{WEB_GROUP}} | `2775` |

Steps:

1. Set the **group owner** of **{{WEB_ROOT}}** and all contents to **{{WEB_GROUP}}**:
   ```
   chgrp -R {{WEB_GROUP}} {{WEB_ROOT}}
   ```

2. Set **directory** mode to `2775` (SGID so new files inherit group):
   ```
   find {{WEB_ROOT}} -type d -exec chmod 2775 {} +
   ```

3. Set **file** mode to `0664`:
   ```
   find {{WEB_ROOT}} -type f -exec chmod 0664 {} +
   ```

4. Verify: users in **{{WEB_GROUP}}** can read and write files; `ls -ld {{WEB_ROOT}}`
   shows `drwxrwsr-x` and group **{{WEB_GROUP}}**.
