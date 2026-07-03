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
grep -qF 'StrictHostKeyChecking no' /root/.ssh/config 2>/dev/null \
  || printf 'Host localhost\n    StrictHostKeyChecking no\n    UserKnownHostsFile /dev/null\n' \
     >> /root/.ssh/config
chmod 600 /root/.ssh/config

cat > "$REMOTE_SCRIPT" <<'SCRIPT'
#!/bin/bash
echo REMOTE-OK
SCRIPT
chmod +x "$REMOTE_SCRIPT"
rm -f "$OUT_FILE"
