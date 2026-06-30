#!/usr/bin/env bash
NAMES=(issue.yml set-issue.yml configure-issue.yml motd-issue.yml)
idx=$(( RANDOM % ${#NAMES[@]} ))
echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${NAMES[$idx]}"
echo "DEV_MSG=Development"
echo "TEST_MSG=Test"
echo "PROD_MSG=Production"
