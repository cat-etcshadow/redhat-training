## Archive old files based on modification time

The directory **{{SEARCH_DIR}}** contains a mix of old and recently
modified log files.

Your task:

1. Create the directory **{{ARCHIVE_DIR}}** if it does not already exist.
2. Using `find`, locate every regular file directly inside **{{SEARCH_DIR}}**
   (do not recurse into subdirectories) that was last modified more than
   **365 days** ago.
3. Move each matching file into **{{ARCHIVE_DIR}}**.
4. Files modified within the last 365 days must remain in **{{SEARCH_DIR}}**,
   untouched.
