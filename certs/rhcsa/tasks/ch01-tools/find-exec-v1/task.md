## Fix insecure file permissions with find and -exec

The directory **{{TARGET_DIR}}** contains files and subdirectories that were
accidentally made world-writable (mode `{{WORLD_WRITABLE_MODE}}`). This is a
security risk and must be corrected.

Your task:

1. Use `find` with `-exec` (or `-execdir`) to set all **regular files** in
   **{{TARGET_DIR}}** (recursively) to mode **{{CORRECT_FILE_MODE}}**.
2. Use `find` with `-exec` to set all **directories** in **{{TARGET_DIR}}**
   (recursively, including **{{TARGET_DIR}}** itself) to mode **{{CORRECT_DIR_MODE}}**.
3. Verify with `find {{TARGET_DIR}} -perm /o+w` — output should be **empty**.
