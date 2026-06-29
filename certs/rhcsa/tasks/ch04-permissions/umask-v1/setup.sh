#!/usr/bin/env bash
userdel -r "$UMASK_USER" 2>/dev/null || true
useradd -m "$UMASK_USER"
sed -i '/umask/d' "/home/$UMASK_USER/.bashrc"    2>/dev/null || true
sed -i '/umask/d' "/home/$UMASK_USER/.bash_profile" 2>/dev/null || true
rm -f /etc/profile.d/custom-umask.sh
