#!/usr/bin/env bash
semanage port -d -t ssh_port_t -p tcp "$SSH_PORT" 2>/dev/null || true
sed -i "s/^#*Port .*/Port 22/" /etc/ssh/sshd_config
systemctl restart sshd
