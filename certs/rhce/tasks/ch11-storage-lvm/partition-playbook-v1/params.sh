#!/usr/bin/env bash
FS_TYPES=(xfs ext4)
PLAYBOOKS=(partition-setup.yml disk-partition.yml create-partition.yml)

fsidx=$(( RANDOM % ${#FS_TYPES[@]} ))
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
echo "PART_SIZE=1200MiB"
echo "FALLBACK_SIZE=800MiB"
echo "FS_TYPE=${FS_TYPES[$fsidx]}"
