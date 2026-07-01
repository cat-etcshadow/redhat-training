#!/usr/bin/env bash
if [[ "$ACTION" == "disable" ]]; then
  timedatectl set-ntp false
else
  timedatectl set-ntp true
fi
