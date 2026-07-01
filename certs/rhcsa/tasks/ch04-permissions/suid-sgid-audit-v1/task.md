## Audit and remove unauthorized SUID bits

The directory **{{APP_DIR}}** contains several application files. Some have
the **SUID** bit set.

Your task:

1. Find every file under **{{APP_DIR}}** that has the SUID bit set, and save
   their full paths (one per line) to **{{REPORT_FILE}}**.

2. **{{BAD_BINARY}}** is an unauthorized legacy tool — remove its SUID bit.

3. **{{GOOD_BINARY}}** is an approved tool — its SUID bit must remain
   unchanged.
