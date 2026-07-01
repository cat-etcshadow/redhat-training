#!/usr/bin/env bash
id "$CRON_USER" &>/dev/null || useradd -M "$CRON_USER"

script_name=$(basename "$SCRIPT_PATH")
printf '#!/usr/bin/env bash\necho "%s ran at $(date)" >> /tmp/rhtr-syscron.log\n' \
  "$script_name" > "$SCRIPT_PATH"
chmod 755 "$SCRIPT_PATH"

rm -f "$CRON_FILE"
