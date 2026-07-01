#!/usr/bin/env bash
id "$TARGET_USER" &>/dev/null || useradd -M "$TARGET_USER"

cat > /usr/local/bin/rhtr-user-job << 'SCRIPT'
#!/bin/bash
while true; do sleep 1; done
SCRIPT
chmod +x /usr/local/bin/rhtr-user-job

pkill -u "$TARGET_USER" -f rhtr-user-job 2>/dev/null || true
sleep 0.2

runuser -u "$TARGET_USER" -- /usr/local/bin/rhtr-user-job &
runuser -u "$TARGET_USER" -- /usr/local/bin/rhtr-user-job &
sleep 1
