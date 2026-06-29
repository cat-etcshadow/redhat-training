## Configure SSH key-based authentication

The user **{{SSH_USER}}** exists on the system.

Your task:

1. Generate an **RSA key pair** (no passphrase) for **{{SSH_USER}}**:
   ```
   ssh-keygen -t rsa -b 4096 -N '' -f /home/{{SSH_USER}}/.ssh/id_rsa
   ```

2. Add the public key to **{{SSH_USER}}'s** `authorized_keys` so the user can
   SSH to localhost without a password:
   ```
   cat /home/{{SSH_USER}}/.ssh/id_rsa.pub >> /home/{{SSH_USER}}/.ssh/authorized_keys
   ```

3. Set correct permissions:
   ```
   chmod 700 /home/{{SSH_USER}}/.ssh
   chmod 600 /home/{{SSH_USER}}/.ssh/authorized_keys
   chown -R {{SSH_USER}}:{{SSH_USER}} /home/{{SSH_USER}}/.ssh
   ```

4. Configure `/etc/ssh/sshd_config` to ensure:
   - `PubkeyAuthentication yes`
   - `AuthorizedKeysFile .ssh/authorized_keys`
   Reload sshd: `systemctl reload sshd`

5. Verify: the following must succeed **without a password prompt**:
   ```
   su - {{SSH_USER}} -c "ssh -o StrictHostKeyChecking=no -i /home/{{SSH_USER}}/.ssh/id_rsa {{SSH_USER}}@localhost whoami"
   ```
