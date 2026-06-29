#!/usr/bin/env bash
groupadd "$DEL_GROUP" 2>/dev/null || true
useradd -m -G "$DEL_GROUP" "$DEL_USER" 2>/dev/null || true
echo "${DEL_USER}:TempPass1!" | chpasswd
mkdir -p "/home/${DEL_USER}/docs"
echo "some file" > "/home/${DEL_USER}/docs/report.txt"
echo "${DEL_USER} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${DEL_USER}"
chmod 0440 "/etc/sudoers.d/${DEL_USER}"
