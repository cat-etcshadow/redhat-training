## Manage SELinux operating mode

Your task:

1. Check the current SELinux mode with `getenforce` and `sestatus`. Write the
   output of `sestatus` to **{{OUTPUT_FILE}}**.

2. Temporarily set SELinux to **permissive** mode.

3. Return SELinux to **enforcing** mode.

4. Make **enforcing** the **persistent default** (survives reboots) by editing
   `/etc/selinux/config`:
   - Set `SELINUX=enforcing`

5. List the SELinux context of `/etc/passwd` and `/usr/sbin/sshd` and append
   this output to **{{OUTPUT_FILE}}**.
