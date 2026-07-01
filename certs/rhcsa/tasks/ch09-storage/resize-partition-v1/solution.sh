#!/usr/bin/env bash
DISK=$(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1}' | grep -v sda | head -1)
growpart "$DISK" 1
xfs_growfs "$MOUNT_POINT"
