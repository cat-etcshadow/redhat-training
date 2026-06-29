#!/usr/bin/env bash
OUTFILES=(/tmp/at-result.txt /tmp/at-output.txt /tmp/at-done.txt /tmp/at-job.txt)
MESSAGES=("at job executed" "scheduled task ran" "one-time job complete" "at test ok")
DELAYS=(1 2 3)

io=$(( RANDOM % ${#OUTFILES[@]} ))
im=$(( RANDOM % ${#MESSAGES[@]} ))
id=$(( RANDOM % ${#DELAYS[@]} ))

echo "AT_OUTFILE=${OUTFILES[$io]}"
echo "AT_MESSAGE=\"${MESSAGES[$im]}\""
echo "AT_DELAY=${DELAYS[$id]}"
