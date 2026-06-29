#!/usr/bin/env bash
# nodejs streams vary by RHEL version; 18 and 20 are common stable choices
STREAMS=(18 20)
is=$(( RANDOM % ${#STREAMS[@]} ))
echo "NODE_STREAM=${STREAMS[$is]}"
