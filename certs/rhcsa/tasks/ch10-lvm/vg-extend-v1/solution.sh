#!/usr/bin/env bash
DISK=$(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1}' | grep -v sda | head -1)
pvcreate "$DISK"
vgextend "$VG_NAME" "$DISK"
