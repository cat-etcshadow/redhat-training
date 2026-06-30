#!/usr/bin/env bash
DEVICES=(/dev/sdb /dev/sdc)
SIZES=(1200m 800m)
PLAYBOOKS=(lvm-block.yml storage-setup.yml lvm-handler.yml)

didx=$(( RANDOM % ${#DEVICES[@]} ))
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
echo "DISK_DEVICE=${DEVICES[$didx]}"
echo "LV_SIZE=${SIZES[0]}"
echo "FALLBACK_SIZE=${SIZES[1]}"
