#!/usr/bin/env bash
ARCHIVES=(backup.tar.gz config-archive.tar.gz ssh-backup.tar.gz)
PLAYBOOKS=(archive-fetch.yml backup-configs.yml fetch-archive.yml)

aidx=$(( RANDOM % ${#ARCHIVES[@]} ))
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
echo "ARCHIVE_NAME=${ARCHIVES[$aidx]}"
echo "FETCH_DEST=/home/student/fetched"
