## Manually Switch the Running Target

Switch the currently running system into `rescue.target`, confirm the switch took effect, and then switch back to `multi-user.target` with `sshd` active — all without rebooting the system and without changing the persistent default target, which (as reported by `systemctl get-default`) must be exactly what it was before you started.
