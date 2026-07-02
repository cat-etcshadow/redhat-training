#!/usr/bin/env bash
DIRS=(/collab/team /opt/shared /srv/workdir /data/common /var/shared)
GROUP_NAMES=(collab teamwork engineers operations)

id=$(( RANDOM % ${#DIRS[@]} ))
ig=$(( RANDOM % ${#GROUP_NAMES[@]} ))

echo "SHARED_DIR=${DIRS[$id]}"
echo "SHARED_GROUP=${GROUP_NAMES[$ig]}"
