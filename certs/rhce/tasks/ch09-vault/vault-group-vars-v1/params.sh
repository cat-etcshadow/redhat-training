#!/usr/bin/env bash
PASSWORDS=(groupvaultpass secretpassword vaultkey2024 ansible123)
idx=$(( RANDOM % ${#PASSWORDS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "VAULT_PASS=${PASSWORDS[$idx]}"
echo "VAULT_PASS_FILE=/home/student/ansible/.vault_pass"
echo "PLAYBOOK_FILE=/home/student/ansible/show-vars.yml"
