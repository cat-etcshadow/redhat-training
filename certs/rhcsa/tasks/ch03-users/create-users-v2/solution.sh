#!/usr/bin/env bash
groupadd -g "$GID" "$GROUP"
useradd -u "$UID1" -G "$GROUP" "$USER1"
echo "$PASSWORD" | passwd --stdin "$USER1"
chage -M "$MAX_AGE" -W "$WARN_DAYS" -I "$INACTIVE" "$USER1"
useradd -u "$UID2" -G "$GROUP" -s /bin/sh "$USER2"
echo "$PASSWORD" | passwd --stdin "$USER2"
passwd -l "$USER2"
