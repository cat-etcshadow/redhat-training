## Label a non-standard SSH port for SELinux

**sshd** must be configured to also listen on the non-standard port
**{{SSH_PORT}}**, in addition to its default port 22.

Your task:

1. Add SELinux port labeling so that **{{SSH_PORT}}/tcp** is associated with
   the `ssh_port_t` type.

2. Configure `/etc/ssh/sshd_config` so sshd listens on **{{SSH_PORT}}**
   (keep port 22 as well).

3. Restart sshd and confirm it is listening on **{{SSH_PORT}}**.

Do **not** set SELinux to permissive mode.
