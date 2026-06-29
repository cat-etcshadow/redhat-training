#!/usr/bin/env bash
# ensure sshd is running and root key auth works to localhost
systemctl enable --now sshd &>/dev/null || true
mkdir -p /root/.ssh
chmod 700 /root/.ssh
if [[ ! -f /root/.ssh/id_rsa ]]; then
  ssh-keygen -t rsa -b 2048 -N '' -f /root/.ssh/id_rsa &>/dev/null
fi
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
# disable strict host checking for localhost
grep -qF 'StrictHostKeyChecking no' /root/.ssh/config 2>/dev/null \
  || printf 'Host localhost\n    StrictHostKeyChecking no\n    UserKnownHostsFile /dev/null\n' \
     >> /root/.ssh/config
chmod 600 /root/.ssh/config

# create source material
rm -rf "$SRC_DIR" "$SCP_DEST" "$RSYNC_DEST"
mkdir -p "$SRC_DIR/data"
dd if=/dev/urandom bs=1K count=8 2>/dev/null | base64 > "$SRC_DIR/data/content.txt"
echo "metadata" > "$SRC_DIR/meta.conf"
tar -czf "$SRC_FILE" -C "$SRC_DIR" data meta.conf
mkdir -p "$SCP_DEST" "$RSYNC_DEST"
