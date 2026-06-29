## Hint

- `chgrp -R <group> <dir>` — recursively change group ownership
- `find <dir> -type d -exec chmod 2775 {} +` — set SGID+rwxrwsr-x on all dirs
- `find <dir> -type f -exec chmod 0664 {} +` — set rw-rw-r-- on all files
- Mode `2775` = SGID bit (2) + owner rwx (7) + group rwx (7) + others r-x (5)
- SGID on a directory means new files/dirs inherit the directory's group
- `ls -ld /dir` shows permissions; `s` in group execute position = SGID set
- `stat -c '%a %G' file` shows numeric mode and group name
