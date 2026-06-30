## Configure SSH key-based authentication

The user **{{SSH_USER}}** exists on the system.

Your task:

1. Generate an **RSA key pair** (no passphrase) for **{{SSH_USER}}**.

2. Add the public key to **{{SSH_USER}}'s** `authorized_keys` so the user can
   SSH to localhost without a password.

3. Set correct permissions on `~/.ssh` and `authorized_keys`.

4. Configure `/etc/ssh/sshd_config` to ensure:
   - `PubkeyAuthentication yes`
   - `AuthorizedKeysFile .ssh/authorized_keys`
   Reload sshd after making changes.

5. Verify: the following must succeed **without a password prompt**:
   ```
   su - {{SSH_USER}} -c "ssh -o StrictHostKeyChecking=no -i /home/{{SSH_USER}}/.ssh/id_rsa {{SSH_USER}}@localhost whoami"
   ```
