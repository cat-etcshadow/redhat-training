#!/usr/bin/env bash
mkdir -p "$ARCHIVE_DIR" "$EXTRACT_DIR"
tar -czf "${ARCHIVE_DIR}/${ARCHIVE_NAME}" -C "$(dirname "$SRC_DIR")" "$(basename "$SRC_DIR")"
tar -xzf "${ARCHIVE_DIR}/${ARCHIVE_NAME}" -C "$EXTRACT_DIR"
