## Audit and remove unauthorized SUID bits

The directory **{{APP_DIR}}** contains several application files, some with the SUID bit set. Find every file under **{{APP_DIR}}** with the SUID bit set and save their full paths, one per line, to **{{REPORT_FILE}}**. Remove the SUID bit from **{{BAD_BINARY}}**, an unauthorized legacy tool, while leaving the SUID bit on **{{GOOD_BINARY}}**, an approved tool, unchanged.
