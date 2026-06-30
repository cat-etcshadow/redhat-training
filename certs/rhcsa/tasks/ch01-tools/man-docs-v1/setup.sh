#!/usr/bin/env bash
rm -f "$DEST_FILE" "$OUTPUT_FILE"
# Create a large file in /var/log to guarantee find returns output
dd if=/dev/urandom bs=1M count=3 of=/var/log/rhtr-test.log 2>/dev/null || true
