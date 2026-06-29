## Create and extract a {{ARCHIVE_FORMAT}}-compressed tar archive

Your task:

1. Create the directory **{{ARCHIVE_DIR}}** if it does not exist.
2. Create a **{{ARCHIVE_FORMAT}}-compressed** tar archive of **{{SRC_DIR}}** and
   save it as **{{ARCHIVE_DIR}}/backup.{{ARCHIVE_EXT}}**.
3. Create **{{EXTRACT_DIR}}** if it does not exist.
4. Extract the archive into **{{EXTRACT_DIR}}**, preserving the directory structure.
5. Verify the extracted files match the originals.

Reference:

| Compression | Create flag | Extract flag | Extension |
|---|---|---|---|
| gzip   | `-z` | `-z` | `.tar.gz`  |
| bzip2  | `-j` | `-j` | `.tar.bz2` |
| xz     | `-J` | `-J` | `.tar.xz`  |

You can also use `tar --auto-compress` and let tar infer the format from the extension.
