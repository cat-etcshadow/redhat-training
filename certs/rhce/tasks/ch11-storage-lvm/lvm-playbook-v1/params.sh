#!/usr/bin/env bash
PLAYBOOKS=(lvm-setup.yml storage-lvm.yml create-lv.yml)

pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
echo "VG_NAME=research"
echo "LV_NAME=data"
echo "LV_SIZE=1200m"
echo "FALLBACK_SIZE=800m"
echo "FS_TYPE=ext4"
