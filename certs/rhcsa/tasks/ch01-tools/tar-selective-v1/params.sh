#!/usr/bin/env bash
FILENAMES=(release-notes.txt config.yaml manifest.json changelog.md)
SUBDIRS=(docs config meta release)

i=$(( RANDOM % ${#FILENAMES[@]} ))

echo "TARGET_FILE=${SUBDIRS[$i]}/${FILENAMES[$i]}"
echo "ARCHIVE=/root/rhtr-bundle.tar.gz"
echo "EXTRACT_DIR=/root/extracted"
