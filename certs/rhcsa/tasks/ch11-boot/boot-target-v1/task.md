## Change the default systemd boot target

The system is currently set to boot into graphical mode. You need to
change the default boot target to **multi-user** (console-only) mode
to reduce resource usage.

Your task:

1. Set the default boot target to **multi-user.target** persistently.
2. The change must survive a reboot (do not just use `systemctl isolate`).
3. Verify with `systemctl get-default`.
