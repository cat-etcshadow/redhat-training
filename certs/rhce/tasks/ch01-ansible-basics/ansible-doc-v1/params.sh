#!/usr/bin/env bash
NAMES=(blockinfile.yml motd-block.yml insert-block.yml banner.yml)
FILES=(/etc/motd /etc/issue /etc/profile.d/info.sh)
MARKERS=("ANSIBLE MANAGED" "MANAGED BY ANSIBLE" "CONFIG BLOCK")
BLOCKS=("Welcome to managed host" "System administered by Ansible" "Do not edit manually")
idx=$(( RANDOM % ${#NAMES[@]} ))
fidx=$(( RANDOM % ${#FILES[@]} ))
midx=$(( RANDOM % ${#MARKERS[@]} ))
bidx=$(( RANDOM % ${#BLOCKS[@]} ))
echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${NAMES[$idx]}"
echo "TARGET_FILE=${FILES[$fidx]}"
echo "BLOCK_CONTENT=${BLOCKS[$bidx]}"
echo "MARKER=${MARKERS[$midx]}"
