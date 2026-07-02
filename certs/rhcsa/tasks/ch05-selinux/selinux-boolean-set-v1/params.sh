#!/usr/bin/env bash
BOOLEANS=(ftpd_full_access samba_enable_home_dirs mysql_connect_any)
DESCRIPTIONS=("FTP full filesystem access" "Samba access to user home directories" "MySQL/MariaDB arbitrary port connections")

i=$(( RANDOM % ${#BOOLEANS[@]} ))

echo "BOOL_NAME=${BOOLEANS[$i]}"
echo "BOOL_DESC=${DESCRIPTIONS[$i]}"
