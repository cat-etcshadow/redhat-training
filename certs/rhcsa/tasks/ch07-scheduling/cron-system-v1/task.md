## Create a system-wide cron job in /etc/cron.d

The user **{{CRON_USER}}** (already exists) needs a recurring job that is
**not** tied to any individual user's personal crontab.

Your task:

1. Create the file **{{CRON_FILE}}** using the system crontab format
   (which includes a user field).

2. Configure it to run **{{SCRIPT_PATH}}** every **{{INTERVAL_MIN}} minutes**,
   as the user **{{CRON_USER}}**.
