#!/usr/bin/env bash
CONFIG_LINES=("MaxAuthTries 3" "ClientAliveInterval 300" "PermitRootLogin no")
PLAYBOOKS=(harden-ssh.yml ssh-config.yml configure-sshd.yml)

cidx=$(( RANDOM % ${#CONFIG_LINES[@]} ))
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
echo "CONFIG_LINE=${CONFIG_LINES[$cidx]}"
echo "CONFIG_FILE=/etc/ssh/sshd_config"
