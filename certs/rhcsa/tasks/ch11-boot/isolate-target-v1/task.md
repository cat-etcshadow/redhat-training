## Manually Switch the Running Target

Switch the currently running system into `rescue.target`, confirm the switch took effect, and then switch back to `multi-user.target` with `sshd` active — all without rebooting the system and without leaving the persistent default target set to `rescue.target`. Perform this using `rhtr rhcsa console` — `rhtr rhcsa shell` depends on a service that `rescue.target` stops.
