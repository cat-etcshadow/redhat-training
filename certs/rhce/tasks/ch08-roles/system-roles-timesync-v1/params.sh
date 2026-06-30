#!/usr/bin/env bash
SERVERS=(172.25.254.250 192.168.1.1 10.0.0.1 pool.ntp.org)
NAMES=(timesync.yml configure-timesync.yml ntp.yml chrony.yml)
idx=$(( RANDOM % ${#SERVERS[@]} ))
idxn=$(( RANDOM % ${#NAMES[@]} ))
echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${NAMES[$idxn]}"
echo "NTP_SERVER=${SERVERS[$idx]}"
