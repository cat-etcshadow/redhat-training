#!/usr/bin/env bash
DIRS=(teamdocs reports shared-notes)
GROUPS=(editors reviewers writers)
i=$(( RANDOM % ${#DIRS[@]} ))

echo "TARGET_DIR=/srv/${DIRS[$i]}"
echo "TARGET_GROUP=${GROUPS[$i]}"
