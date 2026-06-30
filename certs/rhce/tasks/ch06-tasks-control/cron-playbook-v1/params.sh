#!/usr/bin/env bash
NAMES=(cron.yml configure-cron.yml scheduled-tasks.yml)
USERS=(natasha john lisa)
MINUTES=(2 5 10 15)
idx=$(( RANDOM % ${#NAMES[@]} ))
idxu=$(( RANDOM % ${#USERS[@]} ))
idxm=$(( RANDOM % ${#MINUTES[@]} ))
echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${NAMES[$idx]}"
echo "CRON_USER=${USERS[$idxu]}"
echo "CRON_MINUTE=${MINUTES[$idxm]}"
