#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

found=0
if [[ -f /etc/cron.d/rhtr-backup ]] && grep -Eq '^[0-9*/,-]+[[:space:]]+[0-9*/,-]+[[:space:]]+[0-9*/,-]+[[:space:]]+[0-9*/,-]+[[:space:]]+[0-9*/,-]+[[:space:]]+backupsvc[[:space:]]+.*rhtr-backup\.sh' /etc/cron.d/rhtr-backup; then
  found=1
fi
if crontab -u backupsvc -l 2>/dev/null | grep -Eq '^[0-9*/,-]+[[:space:]]+[0-9*/,-]+[[:space:]]+[0-9*/,-]+[[:space:]]+[0-9*/,-]+[[:space:]]+[0-9*/,-]+[[:space:]]+.*rhtr-backup\.sh'; then
  found=1
fi

(( found == 1 )) || fail "no active cron entry runs rhtr-backup.sh as backupsvc"

systemctl is-active crond &>/dev/null || fail "crond is not running"

[[ $errors -eq 0 ]] && exit 0 || exit 1
