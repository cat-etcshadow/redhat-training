#!/usr/bin/env bash
GOOD=(approved-tool trusted-helper vetted-util)
BAD=(legacy-patch old-debug-tool unaudited-script)
ig=$(( RANDOM % ${#GOOD[@]} ))
ib=$(( RANDOM % ${#BAD[@]} ))

echo "APP_DIR=/opt/rhtr-apps"
echo "GOOD_BINARY=${GOOD[$ig]}"
echo "BAD_BINARY=${BAD[$ib]}"
echo "REPORT_FILE=/root/suid-report.txt"
