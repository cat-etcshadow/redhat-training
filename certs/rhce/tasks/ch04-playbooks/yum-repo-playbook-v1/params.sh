#!/usr/bin/env bash
NAMES=(yum-repo.yml configure-repos.yml repos.yml setup-repos.yml)
idx=$(( RANDOM % ${#NAMES[@]} ))
echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${NAMES[$idx]}"
