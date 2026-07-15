## Run a rootless container as a user systemd service

The user **{{CTR_USER}}** already exists on the system. Enable linger for **{{CTR_USER}}** so their systemd user instance starts at boot, and as **{{CTR_USER}}**, generate a rootless systemd user service unit named **{{CTR_NAME}}** for a container running `sleep infinity`, enabled and started so that after completion the user service is active and **{{CTR_NAME}}** is running under **{{CTR_USER}}**.
