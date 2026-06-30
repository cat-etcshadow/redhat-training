## Write a script that loops over files (command substitution)

Create an executable script at **{{SCRIPT_PATH}}** that:

1. Accepts two arguments: `<log-directory>` and `<archive-directory>`.
   Exit **1** with usage message if not exactly 2 arguments.

2. Creates the archive directory if it does not exist.

3. Loops over every **`.log` file** in the log directory (non-recursive) using
   **command substitution** and compresses each one with `gzip`, saving the
   compressed file in the archive directory.

4. If no `.log` files are found, print `No log files found in <dir>` and exit **0**.

5. Exit **0** on success.

Example:
```
$ archive_logs.sh /opt/rhtr_scriptlogs /opt/rhtr_scriptarchive
Archived: app.log
Archived: access.log
Archived: error.log
```
