#!/usr/bin/env bash
OLD_PASSES=(rh294lab exampass vaultpass)
NEW_PASSES=(ansible newpass changed rekey123)
idxo=$(( RANDOM % ${#OLD_PASSES[@]} ))
idxn=$(( RANDOM % ${#NEW_PASSES[@]} ))
echo "ANSIBLE_DIR=/home/student/ansible"
echo "VAULT_FILE=/home/student/ansible/vault.yml"
echo "OLD_VAULT_PASS=${OLD_PASSES[$idxo]}"
echo "NEW_VAULT_PASS=${NEW_PASSES[$idxn]}"
