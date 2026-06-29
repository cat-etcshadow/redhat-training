#!/usr/bin/env bash
useradd -m "$CTR_USER" 2>/dev/null || true
# disable linger (candidate must enable it)
loginctl disable-linger "$CTR_USER" 2>/dev/null || true
# stop and clean any existing container for this user
su - "$CTR_USER" -c "systemctl --user stop container-${CTR_NAME}.service 2>/dev/null; \
  systemctl --user disable container-${CTR_NAME}.service 2>/dev/null; \
  podman stop $CTR_NAME 2>/dev/null; \
  podman rm $CTR_NAME 2>/dev/null; \
  rm -f ~/.config/systemd/user/container-${CTR_NAME}.service" 2>/dev/null || true
# pre-pull image so the task focuses on service setup
su - "$CTR_USER" -c "podman pull registry.access.redhat.com/ubi9/ubi &>/dev/null" 2>/dev/null || true
