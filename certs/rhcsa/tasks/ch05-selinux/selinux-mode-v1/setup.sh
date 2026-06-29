#!/usr/bin/env bash
rm -f "$OUTPUT_FILE"
# leave SELinux as enforcing so candidate must exercise both transitions
setenforce 1 2>/dev/null || true
