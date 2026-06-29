## Manage SELinux operating mode

Your task:

1. Check the current SELinux mode with `getenforce` and `sestatus`. Write the
   output of `sestatus` to **{{OUTPUT_FILE}}**.

2. Temporarily set SELinux to **permissive** mode (no reboot needed):
   ```
   setenforce 0
   ```
   Verify: `getenforce` should output `Permissive`.

3. Return SELinux to **enforcing** mode:
   ```
   setenforce 1
   ```
   Verify: `getenforce` should output `Enforcing`.

4. Make **enforcing** the **persistent default** (survives reboots) by editing
   `/etc/selinux/config`:
   - Set `SELINUX=enforcing`

5. List the SELinux context of `/etc/passwd` and `/usr/sbin/sshd`:
   ```
   ls -Z /etc/passwd
   ls -Z /usr/sbin/sshd
   ```
   Append this output to **{{OUTPUT_FILE}}**.

The grader checks that SELinux is currently **Enforcing**, the config file is
set to `enforcing`, and **{{OUTPUT_FILE}}** contains sestatus output and file contexts.
