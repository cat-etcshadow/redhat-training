#!/usr/bin/env bash
cat > /usr/local/bin/rhtr_cpu_hog << 'SCRIPT'
#!/bin/bash
while :; do :; done
SCRIPT
chmod +x /usr/local/bin/rhtr_cpu_hog

pkill -f rhtr_cpu_hog 2>/dev/null || true
sleep 0.2
nohup /usr/local/bin/rhtr_cpu_hog &>/dev/null &
disown
rm -f "$OUTPUT_FILE"
