#!/usr/bin/env bash
dnf install -y chrony &>/dev/null
if [[ "$ACTION" == "disable" ]]; then
  timedatectl set-ntp true
else
  timedatectl set-ntp false
fi
