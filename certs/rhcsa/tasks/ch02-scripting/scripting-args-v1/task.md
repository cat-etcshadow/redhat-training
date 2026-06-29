## Write a script that validates positional arguments ($1, $2, $#)

Create an executable script at **{{SCRIPT_PATH}}** that backs up a file.

Requirements:

1. Accepts exactly **two arguments**: `<source-file>` and `<destination-directory>`.
   If the wrong number of arguments is given, print usage to stderr and exit **1**:
   ```
   Usage: backup_file.sh <source-file> <destination-dir>
   ```

2. If `<source-file>` does not exist or is not a regular file, print an error to
   stderr and exit **2**.

3. If `<destination-directory>` does not exist, **create it**.

4. Copy `<source-file>` to `<destination-directory>/` with a timestamp suffix:
   ```
   <original-name>.<YYYYMMDD-HHMMSS>
   ```
   Use `$(date +%Y%m%d-%H%M%S)` for the timestamp.

5. Print: `Backed up <source> to <destination-path>`

6. Exit **0** on success.

Key variables: `$1` (first arg), `$2` (second arg), `$#` (argument count),
`$0` (script name), `$(basename "$1")` (filename without path).
