## Run a rootless container as a user systemd service

On RHEL 9, the recommended way to run containers as services is as a **rootless
user** with `loginctl enable-linger` so the user's systemd instance starts at boot
without requiring a login session.

The user **{{CTR_USER}}** already exists on the system.

Your task:

1. **Enable linger** for **{{CTR_USER}}** so their systemd user instance starts at boot:
   ```
   loginctl enable-linger {{CTR_USER}}
   ```

2. As **{{CTR_USER}}**, create the user systemd directory and generate a service unit:
   ```
   su - {{CTR_USER}} -c "mkdir -p ~/.config/systemd/user"
   su - {{CTR_USER}} -c "podman run -d --name {{CTR_NAME}} \
       registry.access.redhat.com/ubi9/ubi sleep infinity"
   su - {{CTR_USER}} -c "podman generate systemd --name {{CTR_NAME}} \
       --files --new --restart-policy=always \
       -o ~/.config/systemd/user/"
   su - {{CTR_USER}} -c "systemctl --user daemon-reload"
   ```

3. Stop and remove the running container (the service will manage it):
   ```
   su - {{CTR_USER}} -c "podman stop {{CTR_NAME}} && podman rm {{CTR_NAME}}"
   ```

4. Enable and start the user service:
   ```
   su - {{CTR_USER}} -c "systemctl --user enable --now container-{{CTR_NAME}}.service"
   ```

5. Verify:
   - `loginctl show-user {{CTR_USER}} | grep Linger` → `Linger=yes`
   - `su - {{CTR_USER}} -c "systemctl --user is-active container-{{CTR_NAME}}.service"` → `active`
   - `su - {{CTR_USER}} -c "podman ps"` shows **{{CTR_NAME}}** running
