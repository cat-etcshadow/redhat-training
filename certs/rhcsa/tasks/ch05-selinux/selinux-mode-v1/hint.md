## Hint

- `getenforce` — show current mode (Enforcing / Permissive / Disabled)
- `sestatus` — detailed status including policy version and file contexts
- `setenforce 0` — switch to permissive (no reboot, reverts on reboot)
- `setenforce 1` — switch to enforcing (no reboot, reverts on reboot)
- `/etc/selinux/config` — persistent setting; set `SELINUX=enforcing`
- `ls -Z /path` — show SELinux context of a file (user:role:type:level)
- `ps -Z` — show SELinux context of running processes
- Never set `SELINUX=disabled` unless you fully intend to disable SELinux permanently
