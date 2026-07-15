## Manage SELinux operating mode

Write the output of `sestatus` to **{{OUTPUT_FILE}}**, then temporarily switch SELinux to permissive mode before returning it to enforcing. Make **enforcing** the persistent default (survives reboots) by setting `SELINUX=enforcing` in `/etc/selinux/config`. Finally, append the SELinux context of `/etc/passwd` and `/usr/sbin/sshd` to **{{OUTPUT_FILE}}**.
