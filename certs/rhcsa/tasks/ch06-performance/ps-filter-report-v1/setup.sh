#!/usr/bin/env bash
cat > /usr/local/bin/rhtr-worker-a << 'SCRIPT'
#!/bin/bash
while true; do sleep 1; done
SCRIPT
cat > /usr/local/bin/rhtr-worker-b << 'SCRIPT'
#!/bin/bash
while true; do sleep 1; done
SCRIPT
cat > /usr/local/bin/rhtr-other-proc << 'SCRIPT'
#!/bin/bash
while true; do sleep 1; done
SCRIPT
chmod +x /usr/local/bin/rhtr-worker-a /usr/local/bin/rhtr-worker-b /usr/local/bin/rhtr-other-proc

pkill -f rhtr-worker-a    2>/dev/null || true
pkill -f rhtr-worker-b    2>/dev/null || true
pkill -f rhtr-other-proc  2>/dev/null || true
sleep 0.2
rm -f "$REPORT_FILE"

/usr/local/bin/rhtr-worker-a &
/usr/local/bin/rhtr-worker-b &
/usr/local/bin/rhtr-other-proc &
sleep 1
