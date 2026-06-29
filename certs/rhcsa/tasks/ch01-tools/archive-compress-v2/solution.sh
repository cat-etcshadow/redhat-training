#!/usr/bin/env bash
mkdir -p "$ARCHIVE_DIR" "$EXTRACT_DIR"
case "$ARCHIVE_FORMAT" in
  bzip2) tar -cjf "${ARCHIVE_DIR}/backup.${ARCHIVE_EXT}" -C "$(dirname "$SRC_DIR")" "$(basename "$SRC_DIR")"
         tar -xjf "${ARCHIVE_DIR}/backup.${ARCHIVE_EXT}" -C "$EXTRACT_DIR" ;;
  xz)    tar -cJf "${ARCHIVE_DIR}/backup.${ARCHIVE_EXT}" -C "$(dirname "$SRC_DIR")" "$(basename "$SRC_DIR")"
         tar -xJf "${ARCHIVE_DIR}/backup.${ARCHIVE_EXT}" -C "$EXTRACT_DIR" ;;
esac
