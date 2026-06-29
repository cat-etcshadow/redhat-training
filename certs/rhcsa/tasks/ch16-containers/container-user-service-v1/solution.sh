#!/usr/bin/env bash
loginctl enable-linger "$CTR_USER"
su - "$CTR_USER" -c "
  mkdir -p ~/.config/systemd/user
  podman run -d --name ${CTR_NAME} registry.access.redhat.com/ubi9/ubi sleep infinity
  podman generate systemd --name ${CTR_NAME} --files --new --restart-policy=always \
    -o ~/.config/systemd/user/
  podman stop ${CTR_NAME}
  podman rm ${CTR_NAME}
  systemctl --user daemon-reload
  systemctl --user enable --now container-${CTR_NAME}.service
"
