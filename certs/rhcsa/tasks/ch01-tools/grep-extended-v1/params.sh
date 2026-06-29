#!/usr/bin/env bash
SHELLS=(bash zsh sh ksh)
idx=$(( RANDOM % ${#SHELLS[@]} ))
echo "INPUT_FILE=/opt/rhtr_passwd_sample"
echo "TARGET_SHELL=${SHELLS[$idx]}"
echo "OUTPUT_USERS=/opt/rhtr_shell_users.txt"
echo "OUTPUT_NAMES=/opt/rhtr_user_names.txt"
