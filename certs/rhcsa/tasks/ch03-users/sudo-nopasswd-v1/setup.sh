#!/usr/bin/env bash
# Ensure operator exists, remove any previous sudoers config
id "$SUDO_USER" &>/dev/null || useradd -m "$SUDO_USER"
rm -f "/etc/sudoers.d/$SUDO_USER"
