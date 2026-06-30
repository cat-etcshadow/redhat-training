#!/usr/bin/env bash
FORKS_VALS=(10 15 20)
fidx=$(( RANDOM % ${#FORKS_VALS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "CFG_FILE=/home/student/ansible/ansible.cfg"
echo "FORKS=${FORKS_VALS[$fidx]}"
echo "LOG_PATH=/home/student/ansible/ansible.log"
echo "ROLES_DIR=/home/student/ansible/roles"
echo "COLLECTIONS_DIR=/home/student/ansible/collections"
