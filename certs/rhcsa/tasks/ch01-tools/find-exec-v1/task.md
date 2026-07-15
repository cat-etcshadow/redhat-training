## Fix insecure file permissions with find and -exec

The directory **{{TARGET_DIR}}** contains files and subdirectories that were accidentally made world-writable (mode `{{WORLD_WRITABLE_MODE}}`). Recursively set all regular files under **{{TARGET_DIR}}** to mode **{{CORRECT_FILE_MODE}}** and all directories, including **{{TARGET_DIR}}** itself, to mode **{{CORRECT_DIR_MODE}}**, so that nothing under **{{TARGET_DIR}}** remains world-writable.
