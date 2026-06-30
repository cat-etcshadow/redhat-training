#!/usr/bin/env bash
PLAYBOOKS=(sysctl-config.yml kernel-params.yml tune-kernel.yml)
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "COLLECTIONS_DIR=/home/student/ansible/collections"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
