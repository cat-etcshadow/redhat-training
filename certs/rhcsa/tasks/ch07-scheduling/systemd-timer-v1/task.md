## Create a systemd timer for a recurring task

The script `/usr/local/bin/cleanup.sh` already exists. Create a systemd service unit named **cleanup** that runs it as root, and a systemd timer unit named **cleanup** that activates the service every **15 minutes**, starting automatically at boot. Enable and start the timer.
