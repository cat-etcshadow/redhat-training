#!/usr/bin/env bash
sed -i -E 's/^#+[[:space:]]*%wheel[[:space:]]+ALL=\(ALL\)[[:space:]]+ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
visudo -c
usermod -aG wheel "$WHEEL_USER"
