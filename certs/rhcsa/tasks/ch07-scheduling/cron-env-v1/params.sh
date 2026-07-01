#!/usr/bin/env bash
USERS=(scheduler taskrunner cronsvc automator)
i=$(( RANDOM % ${#USERS[@]} ))

echo "CRON_USER=${USERS[$i]}"
echo "TOOL_DIR=/opt/rhtr-tools/bin"
echo "SCRIPT_PATH=/opt/rhtr-tools/custom-tool.sh"
