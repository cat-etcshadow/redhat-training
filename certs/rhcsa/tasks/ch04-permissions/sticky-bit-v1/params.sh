#!/usr/bin/env bash
DIRS=(/collab/team /opt/shared /srv/workdir /data/common /var/shared)
GROUPS=(collab teamwork engineers operations)

id=$(( RANDOM % ${#DIRS[@]} ))
ig=$(( RANDOM % ${#GROUPS[@]} ))

echo "SHARED_DIR=${DIRS[$id]}"
echo "SHARED_GROUP=${GROUPS[$ig]}"
