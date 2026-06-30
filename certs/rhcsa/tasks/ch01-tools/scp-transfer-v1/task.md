## Securely transfer files between systems

SSH key-based authentication to `localhost` is already configured for root.

Your task:

1. Use **scp** to copy **{{SRC_FILE}}** to **{{SCP_DEST}}/payload.tar.gz** on `localhost`.

2. Use **rsync** to synchronize the entire **{{SRC_DIR}}** directory to **{{RSYNC_DEST}}**.

3. Verify:
   - `{{SCP_DEST}}/payload.tar.gz` exists and matches the source
   - `{{RSYNC_DEST}}/` contains the same files as `{{SRC_DIR}}/`
