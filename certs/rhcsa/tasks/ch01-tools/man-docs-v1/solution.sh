#!/usr/bin/env bash
cp -a /etc/hosts "$DEST_FILE"
find /var/log -size +1M > "$OUTPUT_FILE"
