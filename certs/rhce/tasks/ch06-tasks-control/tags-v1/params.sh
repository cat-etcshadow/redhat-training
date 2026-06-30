#!/usr/bin/env bash
PLAYBOOKS=(tagged-tasks.yml selective-run.yml task-tags.yml)
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
