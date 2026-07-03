#!/usr/bin/env bash
id "$TARGET_USER" &>/dev/null || useradd -m "$TARGET_USER"
rm -f "/home/$TARGET_USER/confirmed.txt"
