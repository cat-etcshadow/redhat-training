#!/usr/bin/env bash
DIRS=(rhtr_mtime1 rhtr_mtime2 rhtr_mtime3 rhtr_mtime4)
ARCHIVES=(rhtr_mtime_archive1 rhtr_mtime_archive2 rhtr_mtime_archive3 rhtr_mtime_archive4)
i=$(( RANDOM % ${#DIRS[@]} ))
echo "SEARCH_DIR=/opt/${DIRS[$i]}"
echo "ARCHIVE_DIR=/opt/${ARCHIVES[$i]}"
