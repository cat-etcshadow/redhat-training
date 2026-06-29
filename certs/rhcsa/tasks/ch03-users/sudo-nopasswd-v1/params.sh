#!/usr/bin/env bash
USERS=(operator technician sysadmin deployer auditor)
CMD_PAIRS=(
  "/usr/bin/systemctl:/usr/sbin/useradd"
  "/usr/bin/journalctl:/usr/bin/systemctl"
  "/usr/sbin/fdisk:/usr/sbin/parted"
  "/usr/bin/dnf:/usr/bin/rpm"
  "/usr/sbin/ip:/usr/sbin/nmcli"
)

iu=$(( RANDOM % ${#USERS[@]} ))
ic=$(( RANDOM % ${#CMD_PAIRS[@]} ))

IFS=':' read -r CMD1 CMD2 <<< "${CMD_PAIRS[$ic]}"
echo "SUDO_USER=${USERS[$iu]}"
echo "CMD1=$CMD1"
echo "CMD2=$CMD2"
