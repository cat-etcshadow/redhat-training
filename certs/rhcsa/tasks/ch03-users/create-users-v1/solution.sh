#!/usr/bin/env bash
groupadd -g "$GID" "$GROUP"
useradd -u "$UID1" -G "$GROUP" "$USER1"
useradd -u "$UID2" -G "$GROUP" "$USER2"
echo "$PASSWORD" | passwd --stdin "$USER1"
echo "$PASSWORD" | passwd --stdin "$USER2"
echo "$USER1 ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/$USER1"
chmod 0440 "/etc/sudoers.d/$USER1"
