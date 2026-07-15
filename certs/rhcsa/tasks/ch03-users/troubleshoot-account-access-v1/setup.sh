#!/usr/bin/env bash
useradd -m devuser 2>/dev/null || true
echo "devuser:Str0ngP@ss!" | chpasswd
# account expiration date set in the past
chage -E "$(date -d '2 days ago' +%Y-%m-%d)" devuser
