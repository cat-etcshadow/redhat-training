#!/usr/bin/env bash
mkdir -p "$ARCHIVE_DIR"
find "$SEARCH_DIR" -maxdepth 1 -type f -mtime +365 -exec mv {} "$ARCHIVE_DIR"/ \;
