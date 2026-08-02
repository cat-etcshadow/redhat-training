#!/usr/bin/env bash
SIZES=(1200m 800m)
PLAYBOOKS=(lvm-block.yml storage-setup.yml lvm-handler.yml)

pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
echo "LV_SIZE=${SIZES[0]}"
echo "FALLBACK_SIZE=${SIZES[1]}"
