#!/usr/bin/env bash
useradd -m "$SSH_USER" 2>/dev/null || true
# remove any pre-existing keys so candidate must generate them
rm -rf "/home/${SSH_USER}/.ssh"
# ensure sshd is running
systemctl enable --now sshd &>/dev/null
# reset sshd_config to defaults for PubkeyAuth (in case it was disabled)
sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd
