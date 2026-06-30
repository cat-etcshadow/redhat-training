#!/usr/bin/env bash
NAMES=(managed-nodes.yml setup-nodes.yml configure-access.yml node-prep.yml)
USERS=(ansible automation sysops devops)
KEYS=(
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCtest+key1 control@ansible"
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCtest+key2 control@rhce"
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCtest+key3 ansible@control"
)
idx=$(( RANDOM % ${#NAMES[@]} ))
uidx=$(( RANDOM % ${#USERS[@]} ))
kidx=$(( RANDOM % ${#KEYS[@]} ))
echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${NAMES[$idx]}"
echo "ANSIBLE_USER=${USERS[$uidx]}"
echo "SSH_KEY=${KEYS[$kidx]}"
