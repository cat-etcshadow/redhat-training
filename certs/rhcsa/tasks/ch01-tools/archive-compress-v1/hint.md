## Hint

- `tar -czf archive.tar.gz /path/to/source` — create gzip-compressed archive
- `tar -xzf archive.tar.gz -C /destination` — extract into a directory
- `tar -tzf archive.tar.gz` — list archive contents without extracting
- The `-C` flag changes directory before extracting; use it to control where files land
- `file archive.tar.gz` confirms the format
