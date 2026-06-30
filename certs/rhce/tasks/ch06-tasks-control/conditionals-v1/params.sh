#!/usr/bin/env bash
NAMES=(conditional.yml when-tasks.yml os-config.yml conditions.yml)
PACKAGES=(httpd vsftpd chrony bind-utils)
THRESHOLDS=(512 1024 256 2048)
FILES=(/tmp/rhel_configured.txt /tmp/os_check.txt /tmp/redhat_flag.txt /tmp/platform.txt)
idx=$(( RANDOM % ${#NAMES[@]} ))
pidx=$(( RANDOM % ${#PACKAGES[@]} ))
tidx=$(( RANDOM % ${#THRESHOLDS[@]} ))
fidx=$(( RANDOM % ${#FILES[@]} ))
echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${NAMES[$idx]}"
echo "PACKAGE=${PACKAGES[$pidx]}"
echo "MIN_MEMORY=${THRESHOLDS[$tidx]}"
echo "STATUS_FILE=${FILES[$fidx]}"
