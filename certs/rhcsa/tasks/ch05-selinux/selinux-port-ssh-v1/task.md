## Label a non-standard SSH port for SELinux

**sshd** must be configured to also listen on the non-standard port **{{SSH_PORT}}**, in addition to its default port 22, with SELinux remaining in **Enforcing** mode. Add SELinux port labeling so that **{{SSH_PORT}}/tcp** is associated with the `ssh_port_t` type, configure `/etc/ssh/sshd_config` so sshd listens on **{{SSH_PORT}}** while keeping port 22 as well, and restart sshd so it is listening on **{{SSH_PORT}}**.
