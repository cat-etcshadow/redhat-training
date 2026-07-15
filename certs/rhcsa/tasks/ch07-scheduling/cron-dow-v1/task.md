## Create a cron job restricted to specific days of the week

The user **{{CRON_USER}}** (already exists) needs a recurring job that only runs on certain days. The script `{{CRON_SCRIPT}}` already exists and is executable. Create a cron job that runs as user **{{CRON_USER}}**, not as root, running `{{CRON_SCRIPT}}` at **{{CRON_HOUR}}:{{CRON_MIN}}** only on **{{DOW_LABEL}}**, with the day-of-week field of the cron entry set to exactly **{{DOW_PATTERN}}**.
