## Write a script that parses flags with getopts

Create an executable script at **{{SCRIPT_PATH}}** that backs up a file,
parsing its options with **getopts**.

Requirements:

1. Accepts the flags:
   - `-s <source-file>` (required)
   - `-d <dest-dir>` (required)

2. If `-s` or `-d` is missing, print a usage message to stderr and exit **1**.

3. If `<source-file>` does not exist, print an error to stderr and exit **2**.

4. Create `<dest-dir>` if it does not exist, then copy `<source-file>` into it.

5. On success, print `Backup complete` and exit **0**.

The script must be executable.
