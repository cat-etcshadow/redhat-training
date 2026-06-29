## Hint

- bzip2: `tar -cjf backup.tar.bz2 /source` and `tar -xjf backup.tar.bz2 -C /dest`
- xz:    `tar -cJf backup.tar.xz  /source` and `tar -xJf backup.tar.xz  -C /dest`
- `tar --auto-compress -cf backup.tar.bz2 /source` also works — tar infers the format
- `file backup.tar.bz2` confirms the compression type
