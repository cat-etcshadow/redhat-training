#!/usr/bin/env bash
DEST_FILES=(/tmp/rhtr-hosts-copy /tmp/rhtr-hosts-bak /tmp/rhtr-etc-hosts /tmp/rhtr-hostcopy)
OUTPUT_FILES=(/tmp/rhtr-find-large.txt /tmp/rhtr-bigfiles.txt /tmp/rhtr-large-logs.txt /tmp/rhtr-logsize.txt)

id=$(( RANDOM % ${#DEST_FILES[@]} ))
io=$(( RANDOM % ${#OUTPUT_FILES[@]} ))

echo "DEST_FILE=${DEST_FILES[$id]}"
echo "OUTPUT_FILE=${OUTPUT_FILES[$io]}"
