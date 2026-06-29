#!/usr/bin/env bash
dnf install -y at &>/dev/null
systemctl enable --now atd
rm -f "$AT_OUTFILE"
# Remove any queued at jobs for root (best-effort)
for job in $(atq 2>/dev/null | awk '{print $1}'); do atrm "$job" 2>/dev/null; done
