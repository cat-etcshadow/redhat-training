#!/usr/bin/env bash
DIRS=(teamdocs reports shared-notes)
GROUP_NAMES=(editors reviewers writers)
i=$(( RANDOM % ${#DIRS[@]} ))

echo "TARGET_DIR=/srv/${DIRS[$i]}"
echo "TARGET_GROUP=${GROUP_NAMES[$i]}"
