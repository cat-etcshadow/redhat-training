#!/usr/bin/env bash
id "$USER1" &>/dev/null || useradd -m "$USER1"
id "$USER2" &>/dev/null || useradd -m "$USER2"
echo 'RedHat9!' | passwd --stdin "$USER1"
echo 'RedHat9!' | passwd --stdin "$USER2"
chage -m 0 -M 99999 -W 7 -I -1 -E -1 "$USER1"
chage -m 0 -M 99999 -W 7 -I -1 -E -1 "$USER2"
