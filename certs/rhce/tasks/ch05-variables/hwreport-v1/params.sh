#!/usr/bin/env bash
NAMES=(hwreport.yml hardware-report.yml sysinfo.yml host-report.yml)
idx=$(( RANDOM % ${#NAMES[@]} ))
echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${NAMES[$idx]}"
echo "REPORT_PATH=/root/hwreport.txt"
