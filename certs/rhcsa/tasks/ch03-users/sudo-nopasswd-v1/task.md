## Grant a user sudo access for specific commands

The user **{{SUDO_USER}}** already exists on the system. Configure **{{SUDO_USER}}** so they can run `{{CMD1}}` and `{{CMD2}}` as root without a password, with no other sudo privileges granted. The configuration must be placed in a drop-in file under `/etc/sudoers.d/`, must survive a reboot, and `/etc/sudoers` itself must not be modified.
