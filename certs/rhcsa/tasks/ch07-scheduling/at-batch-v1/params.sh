#!/usr/bin/env bash
OUTFILES=(/tmp/batch-result.txt /tmp/batch-output.txt /tmp/batch-done.txt)
MESSAGES=("batch job executed" "load-permitting task ran" "batch test ok")

io=$(( RANDOM % ${#OUTFILES[@]} ))
im=$(( RANDOM % ${#MESSAGES[@]} ))

echo "BATCH_OUTFILE=${OUTFILES[$io]}"
echo "BATCH_MESSAGE=\"${MESSAGES[$im]}\""
