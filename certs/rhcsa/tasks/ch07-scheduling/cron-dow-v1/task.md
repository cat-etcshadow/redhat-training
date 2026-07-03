## Create a cron job restricted to specific days of the week

The user **{{CRON_USER}}** (already exists) needs a recurring job that
only runs on certain days.

Your task:

1. Create a cron job for user **{{CRON_USER}}** that runs
   `{{CRON_SCRIPT}}` at **{{CRON_HOUR}}:{{CRON_MIN}}**, but only on
   **{{DOW_LABEL}}**.
2. The day-of-week field of the cron entry must be exactly
   **{{DOW_PATTERN}}**.
3. The cron job must run as user **{{CRON_USER}}**, not as root.
4. The script `{{CRON_SCRIPT}}` already exists and is executable.
