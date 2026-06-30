#!/usr/bin/env bash
PASSWORDS=(rh294lab ansiblepass vaultpass exampass)
idx=$(( RANDOM % ${#PASSWORDS[@]} ))
echo "ANSIBLE_DIR=/home/student/ansible"
echo "VAULT_FILE=/home/student/ansible/vault.yml"
echo "VAULT_PASSWORD_FILE=/home/student/ansible/password.txt"
echo "VAULT_PASS=${PASSWORDS[$idx]}"
echo "DEV_PASS_VAR=dev_pass"
echo "MGR_PASS_VAR=mgr_pass"
