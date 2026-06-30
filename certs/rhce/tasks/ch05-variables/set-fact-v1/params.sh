#!/usr/bin/env bash
PLAYBOOKS=(set-fact.yml classify-hosts.yml host-roles.yml)
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
