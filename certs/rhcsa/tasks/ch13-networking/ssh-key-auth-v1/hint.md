## Hint

- `ssh-keygen -t rsa -b 4096 -N '' -f ~/.ssh/id_rsa` — generate RSA keys, no passphrase
- `ssh-copy-id -i ~/.ssh/id_rsa.pub user@host` — automatically appends to authorized_keys
- Manually: `cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys`
- Permissions are critical: `chmod 700 ~/.ssh` and `chmod 600 ~/.ssh/authorized_keys`
- `chown -R user:user ~/.ssh` — correct ownership
- Test with `ssh -o BatchMode=yes user@localhost` — fails immediately if no key auth
- `systemctl reload sshd` applies sshd_config changes without dropping connections
