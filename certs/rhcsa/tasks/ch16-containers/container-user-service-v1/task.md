## Run a rootless container as a user systemd service

The user **{{CTR_USER}}** already exists on the system.

Your task:

1. Enable linger for **{{CTR_USER}}** so their systemd user instance starts at boot.

2. As **{{CTR_USER}}**, generate a rootless systemd user service unit named
   **{{CTR_NAME}}** for a container running `sleep infinity`.

3. Enable and start the user service for **{{CTR_NAME}}**.

After completion, the user service must be active and **{{CTR_NAME}}** must
be running under **{{CTR_USER}}**.
