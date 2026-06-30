## Hint

- `ansible.builtin.dnf`: use `state: present` to install, `state: latest` to update
- `ansible.builtin.service`: `enabled: true` survives reboots; `state: started` starts now
- `ansible.posix.firewalld`: requires `ansible.posix` collection (installed by default on RHEL)
  - `permanent: true` persists across reboots
  - `immediate: true` applies the rule immediately without reloading firewalld
- The `service:` parameter in firewalld uses the service name (ftp, smtp, etc.), not the port
- Firewalld must be running for `immediate: true` to work
