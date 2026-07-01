#!/usr/bin/env bash
dnf install -y at &>/dev/null
systemctl enable --now atd &>/dev/null

for job in $(atq 2>/dev/null | awk '{print $1}'); do atrm "$job" 2>/dev/null || true; done

echo "echo keep1 > ${KEEP_FILE1}"   | at now + 1 day &>/dev/null
echo "echo keep2 > ${KEEP_FILE2}"   | at now + 1 day &>/dev/null
echo "echo remove > ${REMOVE_FILE}" | at now + 1 day &>/dev/null
