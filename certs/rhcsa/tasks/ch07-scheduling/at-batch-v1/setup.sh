#!/usr/bin/env bash
dnf install -y at &>/dev/null
systemctl enable --now atd
rm -f "$BATCH_OUTFILE"
for job in $(atq 2>/dev/null | awk '{print $1}'); do atrm "$job" 2>/dev/null; done
