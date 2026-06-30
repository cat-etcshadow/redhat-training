#!/usr/bin/env bash
NAMES=(packages.yml install-pkg.yml deploy-software.yml setup-packages.yml)
idx=$(( RANDOM % ${#NAMES[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${NAMES[$idx]}"
echo "PLAYBOOK_NAME=${NAMES[$idx]}"
