## Archive old files based on modification time

The directory **{{SEARCH_DIR}}** contains a mix of old and recently modified log files. Move every regular file directly inside **{{SEARCH_DIR}}** (not in subdirectories) that was last modified more than **365 days** ago into **{{ARCHIVE_DIR}}**, creating **{{ARCHIVE_DIR}}** if it does not already exist, while leaving files modified within the last 365 days in place in **{{SEARCH_DIR}}**.
