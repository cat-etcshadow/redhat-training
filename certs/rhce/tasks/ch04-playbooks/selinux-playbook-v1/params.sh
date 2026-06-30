#!/usr/bin/env bash
NAMES=(selinux.yml se-config.yml selinux-policy.yml)
DIRS=(/srv/web /opt/app /data/web /var/appdata)
CONTEXTS=(httpd_sys_content_t httpd_sys_rw_content_t public_content_t)
BOOLEANS=(httpd_can_network_connect httpd_enable_homedirs httpd_can_sendmail)
idx=$(( RANDOM % ${#NAMES[@]} ))
didx=$(( RANDOM % ${#DIRS[@]} ))
cidx=$(( RANDOM % ${#CONTEXTS[@]} ))
bidx=$(( RANDOM % ${#BOOLEANS[@]} ))
echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${NAMES[$idx]}"
echo "CUSTOM_DIR=${DIRS[$didx]}"
echo "SELINUX_TYPE=${CONTEXTS[$cidx]}"
echo "SELINUX_BOOLEAN=${BOOLEANS[$bidx]}"
