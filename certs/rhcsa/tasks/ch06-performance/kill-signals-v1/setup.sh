#!/usr/bin/env bash
cat > /usr/local/bin/rhtr_alpha << 'SCRIPT'
#!/bin/bash
while true; do sleep 1; done
SCRIPT
cat > /usr/local/bin/rhtr_beta << 'SCRIPT'
#!/bin/bash
while true; do sleep 1; done
SCRIPT
chmod +x /usr/local/bin/rhtr_alpha /usr/local/bin/rhtr_beta

pkill -f rhtr_alpha 2>/dev/null || true
pkill -f rhtr_beta  2>/dev/null || true
kill "$(cat /tmp/rhtr_kill_pid 2>/dev/null)" 2>/dev/null || true

/usr/local/bin/rhtr_alpha &
/usr/local/bin/rhtr_beta &
sleep 86400 &
echo $! > /tmp/rhtr_kill_pid
sleep 1
