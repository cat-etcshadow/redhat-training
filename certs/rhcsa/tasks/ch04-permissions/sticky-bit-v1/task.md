## Create a shared directory with sticky bit and SGID

Create group **{{SHARED_GROUP}}** if it does not already exist, and create directory **{{SHARED_DIR}}** (including parent directories as needed) with group owner **{{SHARED_GROUP}}**, the SGID bit set so new files inside inherit the group, the sticky bit set so only the file owner (or root) can delete files inside, and permissions granting the owning group read/write/execute with no access for others — mode `3770`.
