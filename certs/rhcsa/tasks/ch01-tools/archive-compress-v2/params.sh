#!/usr/bin/env bash
FORMATS=(bzip2 xz)
EXTS=(tar.bz2 tar.xz)
SRCDIRS=(dbdump etcbackup vardata homedir)
fidx=$(( RANDOM % ${#FORMATS[@]} ))
sidx=$(( RANDOM % ${#SRCDIRS[@]} ))

echo "SRC_DIR=/opt/rhtr_src2_${SRCDIRS[$sidx]}"
echo "ARCHIVE_FORMAT=${FORMATS[$fidx]}"
echo "ARCHIVE_EXT=${EXTS[$fidx]}"
echo "ARCHIVE_DIR=/opt/rhtr_archives2"
echo "EXTRACT_DIR=/opt/rhtr_extracted2"
