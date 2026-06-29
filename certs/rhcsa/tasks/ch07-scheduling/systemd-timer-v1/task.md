## Create a systemd timer for a recurring task

Your task:

1. Create a systemd service unit named **cleanup** that runs
   `/usr/local/bin/cleanup.sh` as root.
2. Create a systemd timer unit named **cleanup** that activates
   the cleanup service every **15 minutes**, starting automatically at boot.
3. Enable and start the timer.

The script `/usr/local/bin/cleanup.sh` already exists.
