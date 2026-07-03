## Manually Switch the Running Target

Without editing any configuration file, without running `systemctl
set-default`, and without rebooting the system:

1. Switch the currently **running** system into
   `rescue.target`.
2. Confirm you are now running in rescue mode.
3. Switch the running system back to
   `multi-user.target`.

When you finish:
- The system must be back in `multi-user.target`, with `sshd` active.
- The **persistent default target** (`systemctl get-default`) must be
  exactly what it was before you started — changing the running target
  must not change the boot default.
