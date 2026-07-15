#!/usr/bin/env bash
# investigate:
# cat /etc/cron.d/rhtr-backup
sed -i 's/^# *\(.*backupsvc.*rhtr-backup\.sh\)/\1/' /etc/cron.d/rhtr-backup
systemctl restart crond
