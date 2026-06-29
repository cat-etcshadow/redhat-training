#!/usr/bin/env bash
SRCDIRS=(webfiles configs logs reports appdata backups)
ARCHIVES=(site-backup config-snapshot log-archive report-bundle app-backup data-dump)
idx=$(( RANDOM % ${#SRCDIRS[@]} ))

echo "SRC_DIR=/opt/rhtr_src_${SRCDIRS[$idx]}"
echo "ARCHIVE_NAME=${ARCHIVES[$idx]}.tar.gz"
echo "ARCHIVE_DIR=/opt/rhtr_archives"
echo "EXTRACT_DIR=/opt/rhtr_extracted"
