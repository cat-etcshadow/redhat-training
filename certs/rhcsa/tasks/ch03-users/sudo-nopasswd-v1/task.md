## Grant a user sudo access for specific commands

The user **{{SUDO_USER}}** already exists on the system.

Configure **{{SUDO_USER}}** so that:

1. They can run `{{CMD1}}` as root **without a password**.
2. They can run `{{CMD2}}` as root **without a password**.
3. No other sudo privileges should be granted.

The configuration must be placed in a drop-in file under `/etc/sudoers.d/`
and must survive a reboot. Do not modify `/etc/sudoers` directly.
