#!/usr/bin/env bash
PACKAGES=(httpd vsftpd postfix nginx)
PACKAGES2=(mariadb postgresql redis sqlite)
idx=$(( RANDOM % ${#PACKAGES[@]} ))
idx2=$(( RANDOM % ${#PACKAGES2[@]} ))
echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/facts.yml"
echo "FACT_PKG=${PACKAGES[$idx]}"
echo "FACT_SVC=${PACKAGES2[$idx2]}"
