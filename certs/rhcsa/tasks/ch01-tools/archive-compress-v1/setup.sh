#!/usr/bin/env bash
rm -rf "$SRC_DIR" "$ARCHIVE_DIR" "$EXTRACT_DIR"
mkdir -p "$SRC_DIR/subdir"
echo "config line 1" > "$SRC_DIR/config.conf"
echo "config line 2" >> "$SRC_DIR/config.conf"
echo "readme content" > "$SRC_DIR/README.txt"
echo "nested file"   > "$SRC_DIR/subdir/data.dat"
echo "another file"  > "$SRC_DIR/subdir/notes.txt"
