#!/usr/bin/env bash
semanage port -a -t ssh_port_t -p tcp "$SSH_PORT" \
  || semanage port -m -t ssh_port_t -p tcp "$SSH_PORT"

sed -i "s/^#*Port .*/Port ${SSH_PORT}/" /etc/ssh/sshd_config
echo "Port 22" >> /etc/ssh/sshd_config

systemctl restart sshd
