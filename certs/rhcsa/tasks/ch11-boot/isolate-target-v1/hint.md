## Hint

- `systemctl isolate rescue.target` switches the running system to rescue
  mode immediately, without a reboot
- `systemctl isolate multi-user.target` switches back
- `systemctl isolate` never touches the persistent default — that's what
  `systemctl set-default` is for
- Verify with `systemctl list-units --type=target` in each state
- `sshd` should be reachable again once you're back in `multi-user.target`
