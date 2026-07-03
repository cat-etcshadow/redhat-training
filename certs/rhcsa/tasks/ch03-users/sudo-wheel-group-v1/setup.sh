#!/usr/bin/env bash
userdel -r "$WHEEL_USER" 2>/dev/null || true
useradd "$WHEEL_USER"
echo 'RedHat9!' | passwd --stdin "$WHEEL_USER" &>/dev/null
# disable the wheel-group sudo rule to simulate a hardened/broken system
sed -i -E 's/^%wheel[[:space:]]+ALL=\(ALL\)[[:space:]]+ALL/# %wheel ALL=(ALL) ALL/' /etc/sudoers
