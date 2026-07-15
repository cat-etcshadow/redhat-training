#!/usr/bin/env bash
id sshadmin &>/dev/null || useradd -m sshadmin
mkdir -p /home/sshadmin/.ssh
if [[ ! -f /home/sshadmin/.ssh/id_rsa ]]; then
  su - sshadmin -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa" &>/dev/null
fi
su - sshadmin -c "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys"
chown -R sshadmin:sshadmin /home/sshadmin/.ssh

# deliberately incorrect permissions that make sshd refuse key auth (StrictModes)
chmod 777 /home/sshadmin/.ssh
chmod 666 /home/sshadmin/.ssh/authorized_keys
