#!/usr/bin/env bash
usermod -L "$DEL_USER"
userdel -r "$DEL_USER"
groupdel "$DEL_GROUP" 2>/dev/null || true
rm -f "/etc/sudoers.d/${DEL_USER}"
