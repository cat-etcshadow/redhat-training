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

Verify: users in **{{WEB_GROUP}}** can read and write files; `ls -ld {{WEB_ROOT}}` shows `drwxrwsr-x` and group **{{WEB_GROUP}}**.
