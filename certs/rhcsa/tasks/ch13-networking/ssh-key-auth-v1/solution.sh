#!/usr/bin/env bash
SSH_DIR="/home/${SSH_USER}/.ssh"
mkdir -p "$SSH_DIR"
ssh-keygen -t rsa -b 4096 -N '' -f "${SSH_DIR}/id_rsa"
cat "${SSH_DIR}/id_rsa.pub" >> "${SSH_DIR}/authorized_keys"
chmod 700 "$SSH_DIR"
chmod 600 "${SSH_DIR}/authorized_keys"
chown -R "${SSH_USER}:${SSH_USER}" "$SSH_DIR"

grep -qiE '^\s*PubkeyAuthentication' /etc/ssh/sshd_config \
  && sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
  || echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config

systemctl reload sshd
