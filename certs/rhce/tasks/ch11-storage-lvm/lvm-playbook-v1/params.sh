#!/usr/bin/env bash
MOUNT_POINTS=(/mnt/data /data /srv/data)
PLAYBOOKS=(lvm-setup.yml storage-lvm.yml create-lv.yml)

midx=$(( RANDOM % ${#MOUNT_POINTS[@]} ))
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
echo "VG_NAME=research"
echo "LV_NAME=data"
echo "LV_SIZE=1200m"
echo "FALLBACK_SIZE=800m"
echo "MOUNT_POINT=${MOUNT_POINTS[$midx]}"
echo "FS_TYPE=ext4"
