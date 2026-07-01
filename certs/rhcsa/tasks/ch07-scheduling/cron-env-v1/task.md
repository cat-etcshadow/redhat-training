## Set PATH in a crontab so a cron job can find a dependency

The user **{{CRON_USER}}** (already exists) needs a recurring job, but cron
runs jobs with a minimal environment and a restricted default `PATH`.

The script **{{SCRIPT_PATH}}** calls another executable, `custom-helper`,
by name (not by full path). `custom-helper` lives in **{{TOOL_DIR}}**, a
directory that is **not** part of cron's default `PATH`.

Your task:

1. Add a crontab entry for **{{CRON_USER}}** that runs **{{SCRIPT_PATH}}**
   every **5 minutes**.

2. Add a `PATH` definition to **{{CRON_USER}}'s** crontab that includes
   **{{TOOL_DIR}}**, so that when cron runs the script, `custom-helper` can
   still be found.
