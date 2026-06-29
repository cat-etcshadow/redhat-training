## Securely transfer files between systems

SSH key-based authentication to `localhost` is already configured for root.

Your task:

1. Use **scp** to copy **{{SRC_FILE}}** to **{{SCP_DEST}}/payload.tar.gz** on `localhost`:
   ```
   scp {{SRC_FILE}} root@localhost:{{SCP_DEST}}/payload.tar.gz
   ```

2. Use **rsync** to synchronize the entire **{{SRC_DIR}}** directory to **{{RSYNC_DEST}}**:
   ```
   rsync -av {{SRC_DIR}}/ {{RSYNC_DEST}}/
   ```
   The trailing slash on the source means "contents of" — without it rsync copies
   the directory itself, creating an extra nesting level.

3. Verify:
   - `{{SCP_DEST}}/payload.tar.gz` exists and matches the source
   - `{{RSYNC_DEST}}/` contains the same files as `{{SRC_DIR}}/`

Common `rsync` flags: `-a` (archive: preserves permissions, timestamps, symlinks),
`-v` (verbose), `-z` (compress in transit), `--delete` (remove files on dest no
longer in source), `--dry-run` (preview without executing).
