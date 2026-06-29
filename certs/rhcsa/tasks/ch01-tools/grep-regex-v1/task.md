## Search files with grep and regular expressions

The directory **{{LOG_DIR}}** contains several log files.

Your task:

1. Search **all files** in **{{LOG_DIR}}** recursively for lines containing `ERROR`
   or `error` (case-insensitive). Write matching lines to **{{ERROR_OUTPUT}}**.
   ```
   grep -ri 'error' {{LOG_DIR}} > {{ERROR_OUTPUT}}
   ```

2. Search **all files** in **{{LOG_DIR}}** for lines that contain an **IPv4 address**
   (a pattern like `192.168.1.10` — four groups of 1-3 digits separated by dots).
   Write matching lines to **{{IP_OUTPUT}}**.
   ```
   grep -rE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' {{LOG_DIR}} > {{IP_OUTPUT}}
   ```

3. Verify:
   - `{{ERROR_OUTPUT}}` is non-empty
   - `{{IP_OUTPUT}}` is non-empty
   - Both files exist

Key grep flags:
- `-r` recursive, `-i` case-insensitive, `-E` extended regex, `-n` show line numbers,
  `-l` list filenames only, `-c` count matches per file
