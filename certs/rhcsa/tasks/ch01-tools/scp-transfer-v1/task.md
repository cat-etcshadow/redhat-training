## Securely transfer files between systems

SSH key-based authentication to `localhost` is already configured for root. Use **scp** to copy **{{SRC_FILE}}** to **{{SCP_DEST}}/payload.tar.gz** on `localhost`, and use **rsync** to synchronize the entire **{{SRC_DIR}}** directory to **{{RSYNC_DEST}}**.
