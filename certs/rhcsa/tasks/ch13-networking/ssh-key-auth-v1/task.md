## Configure SSH key-based authentication

The user **{{SSH_USER}}** exists on the system. Set up SSH key-based authentication for **{{SSH_USER}}** using an RSA key pair with no passphrase, with correct ownership and permissions on `~/.ssh` and `authorized_keys`, with `sshd` public key authentication enabled and applied to the running service, such that **{{SSH_USER}}** can SSH to localhost without a password prompt.
