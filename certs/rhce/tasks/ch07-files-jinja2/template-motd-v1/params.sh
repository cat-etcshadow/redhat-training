#!/usr/bin/env bash
NAMES=(motd.yml deploy-motd.yml configure-motd.yml)
idx=$(( RANDOM % ${#NAMES[@]} ))
echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${NAMES[$idx]}"
echo "TEMPLATE_FILE=/home/student/ansible/motd.j2"
