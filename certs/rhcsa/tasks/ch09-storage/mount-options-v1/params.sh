#!/usr/bin/env bash
MOUNTS=(/mnt/secure-data /mnt/restricted /mnt/hardened /mnt/protected)
OPT_SETS=("nosuid,nodev" "nosuid,noexec" "nodev,noexec" "nosuid,nodev,noexec")

im=$(( RANDOM % ${#MOUNTS[@]} ))
io=$(( RANDOM % ${#OPT_SETS[@]} ))

echo "MOUNT_POINT=${MOUNTS[$im]}"
echo "REQUIRED_OPTS=${OPT_SETS[$io]}"
