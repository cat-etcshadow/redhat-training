#!/usr/bin/env bash
swapoff "$SWAP_FILE" 2>/dev/null || true
rm -f "$SWAP_FILE"
sed -i "\\|${SWAP_FILE}|d" /etc/fstab
