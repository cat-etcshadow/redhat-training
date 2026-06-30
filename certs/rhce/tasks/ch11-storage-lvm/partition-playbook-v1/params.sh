#!/usr/bin/env bash
PART_SIZES=(1200MiB 800MiB)
FS_TYPES=(xfs ext4)
MOUNT_POINTS=(/mnt/part1 /mnt/storage /srv/partition)
PLAYBOOKS=(partition-setup.yml disk-partition.yml create-partition.yml)

fsidx=$(( RANDOM % ${#FS_TYPES[@]} ))
midx=$(( RANDOM % ${#MOUNT_POINTS[@]} ))
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
echo "DISK=sdb"
echo "PART_SIZE=${PART_SIZES[0]}"
echo "FALLBACK_SIZE=${PART_SIZES[1]}"
echo "FS_TYPE=${FS_TYPES[$fsidx]}"
echo "MOUNT_POINT=${MOUNT_POINTS[$midx]}"
