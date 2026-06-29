## Hint

- `groupadd -g <GID> <groupname>` creates a group with a specific GID
- `useradd -u <UID> -G <group> <username>` creates a user with UID and supplementary group
- `passwd <username>` sets a password interactively
- For passwordless sudo, create `/etc/sudoers.d/<username>` containing:
  `alice ALL=(ALL) NOPASSWD: ALL`
- Always use `visudo -c -f /etc/sudoers.d/alice` to validate the file syntax before saving
