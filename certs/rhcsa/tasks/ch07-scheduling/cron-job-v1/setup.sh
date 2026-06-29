#!/usr/bin/env bash
id "$CRON_USER" &>/dev/null || useradd -M "$CRON_USER"
script_name=$(basename "$CRON_SCRIPT")
printf '#!/usr/bin/env bash\necho "%s ran at $(date)" >> /tmp/rhtr-cron.log\n' \
  "$script_name" > "$CRON_SCRIPT"
chmod 755 "$CRON_SCRIPT"
crontab -r -u "$CRON_USER" 2>/dev/null || true
