#!/usr/bin/env bash
scp "$SRC_FILE" "root@localhost:${SCP_DEST}/payload.tar.gz"
rsync -av "${SRC_DIR}/" "${RSYNC_DEST}/"
