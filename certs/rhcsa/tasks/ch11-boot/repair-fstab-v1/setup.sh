#!/usr/bin/env bash
# Add a broken entry that points to a non-existent UUID
echo "UUID=dead-beef-0000-0000-bad-fstab  /mnt/broken  xfs  defaults  0 0" >> /etc/fstab
mkdir -p /mnt/broken
