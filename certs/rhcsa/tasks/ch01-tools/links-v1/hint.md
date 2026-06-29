## Hint

- `ln /path/to/source /path/to/hardlink` — create a hard link (no `-s` flag)
- `ln -s /path/to/target /path/to/symlink` — create a symbolic link
- `ls -li` shows inodes: a hard link and its source share the same number
- `readlink /path/to/symlink` shows where a symlink points
- Hard links cannot span filesystems or point to directories (usually)
