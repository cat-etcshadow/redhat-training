## Run a rootless container as a user systemd service

On RHEL 9, the recommended way to run containers as services is as a **rootless
user** with `loginctl enable-linger` so the user's systemd instance starts at boot
without requiring a login session.

The user **{{CTR_USER}}** already exists on the system.

Your task:

1. **Enable linger** for **{{CTR_USER}}** so their systemd user instance starts at boot.

2. As **{{CTR_USER}}**, create the user systemd directory, run the container temporarily,
   generate a systemd service unit from it, and reload the user daemon.

3. Stop and remove the running container (the service will manage it going forward).

4. Enable and start the user service for **{{CTR_NAME}}**.

5. Verify:
   - `loginctl show-user {{CTR_USER}} | grep Linger` → `Linger=yes`
   - `su - {{CTR_USER}} -c "systemctl --user is-active container-{{CTR_NAME}}.service"` → `active`
   - `su - {{CTR_USER}} -c "podman ps"` shows **{{CTR_NAME}}** running
