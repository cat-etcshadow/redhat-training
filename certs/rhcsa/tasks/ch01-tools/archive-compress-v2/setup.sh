#!/usr/bin/env bash
rm -rf "$SRC_DIR" "$ARCHIVE_DIR" "$EXTRACT_DIR"
mkdir -p "$SRC_DIR/conf" "$SRC_DIR/data"
echo "host=db01"     > "$SRC_DIR/conf/db.conf"
echo "port=5432"    >> "$SRC_DIR/conf/db.conf"
dd if=/dev/urandom bs=1K count=4 2>/dev/null | base64 > "$SRC_DIR/data/payload.bin"
echo "manifest v1"   > "$SRC_DIR/MANIFEST"
