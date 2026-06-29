## Write a script that handles exit codes and errors

Create an executable script at **{{SCRIPT_PATH}}** that safely copies files with
proper error handling.

Requirements:

1. Accepts two arguments: `<source>` and `<destination>`.
   - Wrong count → stderr usage message, exit **1**

2. Check source exists and is readable:
   - Does not exist → stderr error, exit **2**
   - Exists but not readable → stderr error, exit **3**

3. If destination is a directory, copy the file into it.
   If destination is a path ending in a filename, copy to that exact path
   (creating parent directories with `mkdir -p`).

4. After the `cp` command, check `$?` (the exit code of the last command):
   - If `cp` failed, print error to stderr and exit **4**
   - If `cp` succeeded, print: `Copied <source> → <destination>`

5. Use `set -e` is **not** required — you must explicitly check `$?` after `cp`.

Key concepts:
- `$?` — exit code of the last executed command
- `[[ -r "$file" ]]` — test if file is readable
- `[[ -d "$dest" ]]` — test if destination is a directory
- Stderr: `echo "error" >&2`
