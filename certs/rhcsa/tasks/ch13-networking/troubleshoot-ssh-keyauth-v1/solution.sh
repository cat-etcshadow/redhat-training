#!/usr/bin/env bash
# investigate:
# ssh -v sshadmin@localhost
# journalctl -u sshd --since -10min
chmod 700 /home/sshadmin/.ssh
chmod 600 /home/sshadmin/.ssh/authorized_keys
