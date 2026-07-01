#!/usr/bin/env bash
showmount -e localhost > "$REPORT_FILE"
mount -t nfs "localhost:${EXPORT_DIR}" "$MOUNT_POINT"
