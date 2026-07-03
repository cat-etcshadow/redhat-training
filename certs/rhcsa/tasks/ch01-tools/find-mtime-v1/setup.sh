#!/usr/bin/env bash
rm -rf "$SEARCH_DIR" "$ARCHIVE_DIR"
mkdir -p "$SEARCH_DIR"
for f in old1.log old2.log old3.log; do
  touch -d "400 days ago" "$SEARCH_DIR/$f"
done
for f in new1.log new2.log; do
  touch "$SEARCH_DIR/$f"
done
