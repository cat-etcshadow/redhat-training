#!/usr/bin/env bash
EXTS=(log conf txt sh py)
idx=$(( RANDOM % ${#EXTS[@]} ))
echo "SEARCH_DIR=/opt/rhtr_find"
echo "PATTERN=*.${EXTS[$idx]}"
echo "OUTPUT_FILE=/opt/rhtr_find_results.txt"
echo "FILE_EXT=${EXTS[$idx]}"
